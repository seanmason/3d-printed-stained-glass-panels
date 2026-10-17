from pathlib import Path
import sys, json, zipfile, copy, hashlib, io
import xml.etree.ElementTree as ET
sys.path.insert(0, str(Path(__file__).parent/'pydeps'))
import numpy as np, trimesh, cv2
from shapely.geometry import box, Polygon, Point
from shapely.affinity import translate
from shapely.ops import unary_union
from shapely import set_precision
from PIL import Image, ImageDraw

R=Path(__file__).resolve().parents[1]; O=R/'outputs'; W=R/'work'
source=O/'lion-lightbox-two-panels-H2D.3mf'
source_hash=hashlib.sha256(source.read_bytes()).hexdigest()
base=zipfile.ZipFile(source)
prefix=(W/'build_lightbox_lion.py').read_text().split('meshes=[];report=[]')[0]
env={'__file__':str(W/'build_lightbox_lion.py')}
exec(prefix.replace('lion-panel-wink-smirk-draft-v2.png','lion-panel-concept-v5.png'),env)
polygons=env['polygons']
crop=box(-36,-18,-8,12); outer=box(-15,-16,15,16)
original=[]
slots_by_name={'Black':7,'Jade White':1,'Cyan':2,'Sunflower Yellow':3,'Pumpkin Orange':4,'Cocoa Brown':6}
colors={'Black':'#000000','Jade White':'#FFFFFF','Sunflower Yellow':'#FEC600','Pumpkin Orange':'#0086D6','Cocoa Brown':'#5B6579'}
for name,col,p,h in env['regions']:
    p=set_precision(translate(p.intersection(crop),22,3),.001)
    if name=='Black':p=p.union(outer.difference(box(-14,-15,14,15)))
    if p.area>1e-6:original.append((name,colors.get(name,col),p,h))
assert abs(sum(p.area for _,_,p,_ in original)-outer.area)<1e-5

# Round convex needle points with a 0.25 mm morphological opening.
# Removed colored material is explicitly assigned to black.
rounded=[]
for n,c,p,h in original[1:]:
    q=set_precision(p.buffer(-.25,quad_segs=8).buffer(.25,quad_segs=8).intersection(p),.001)
    rounded.append((n,c,q,h))
black=set_precision(outer.difference(unary_union([p for _,_,p,_ in rounded])),.001)
rounded.insert(0,('Black','#000000',black,2.5))
ledge=set_precision(black.buffer(.4,quad_segs=8).intersection(outer),.001)
# The pointed muzzle needs a wider local shelf: a uniform 0.4 mm offset put
# its first-layer gap beneath an upper-layer infill gap in the sliced draft.
muzzle=max(polygons(next(p for n,c,p,h in original if n=='Jade White')),key=lambda p:p.area)
tip=max(muzzle.exterior.coords,key=lambda xy:xy[1])
tip_zone=Point(tip).buffer(3,quad_segs=16)
ledge=set_precision(ledge.union(black.buffer(.8,quad_segs=12).intersection(tip_zone)).intersection(outer),.001)

def extrude(p,h,z=0):
    ms=[trimesh.creation.extrude_polygon(q,h,engine='earcut') for q in polygons(p) if q.area>1e-8]
    if not ms:return None
    m=trimesh.util.concatenate(ms);m.apply_translation([0,0,z]);return m

meshes_by_sample=[];reports=[]
for sample,regions in [('A',original),('B',rounded)]:
    meshes=[];report=[]
    for n,c,p,h in regions:
        if sample=='A':m=extrude(p,h)
        elif n=='Black':
            m=trimesh.boolean.union([extrude(p,2.5),extrude(ledge,.2)],engine='manifold')
        else:
            # Bottom 0.2 mm is inset; the remaining 0.6 mm pane covers the ledge.
            top=extrude(p,.6,.2);bottom=extrude(p.difference(ledge),.2)
            m=trimesh.boolean.union([top,bottom],engine='manifold') if bottom is not None else top
        assert m.is_watertight and m.is_winding_consistent and m.volume>0,(sample,n)
        meshes.append(m)
        report.append({'name':n,'slot':slots_by_name[n],'volume_mm3':float(m.volume),'triangles':len(m.faces),'watertight':True})
    # Check the actual partition for each height band, including every pair.
    bands=[]
    for z in [.1,.3,1.0]:
        profiles=[(ledge if sample=='B' and z<.2 else regions[0][2])]
        profiles += [(p.difference(ledge) if sample=='B' and z<.2 else p) if z<.8 else Polygon() for _,_,p,_ in regions[1:]]
        assert unary_union(profiles).symmetric_difference(outer if z<.8 else regions[0][2]).area<1e-5
        for i,p in enumerate(profiles):
            for q in profiles[:i]:assert p.intersection(q).area<1e-6
        bands.append({'z_mm':z,'area_mm2':float(unary_union(profiles).area),'no_gaps_or_overlaps':True})
    expected=sum(p.area*h for _,_,p,h in regions)
    assert abs(sum(m.volume for m in meshes)-expected)<.02
    meshes_by_sample.append(meshes);reports.append({'sample':sample,'parts':report,'height_band_checks':bands})

ns='http://schemas.microsoft.com/3dmanufacturing/core/2015/02';pns='http://schemas.microsoft.com/3dmanufacturing/production/2015/06'
ET.register_namespace('',ns);ET.register_namespace('p',pns)
ET.register_namespace('BambuStudio','http://schemas.bambulab.com/package/2021')
root=ET.fromstring(base.read('3D/3dmodel.model'));resources=root.find(f'{{{ns}}}resources');resources.clear();build=root.find(f'{{{ns}}}build');build.clear()
settings=ET.Element('config');updates={}
chosen={'layer_height':'0.1','sparse_infill_density':'100%','sparse_infill_pattern':'zig-zag','enable_support':'0','brim_type':'no_brim','top_surface_speed':'50','gap_infill_speed':'30','infill_wall_overlap':'20%','top_surface_pattern':'monotonicline','ironing_type':'no ironing','wall_generator':'arachne','seam_gap':'0%','seam_slope_type':'none'}
for ix,(aid,cx,regions,meshes,title) in enumerate([(6,140,original,meshes_by_sample[0],'A - slicer changes only'),(20,200,rounded,meshes_by_sample[1],'B - rounded corners and black ledge')]):
    ids=list(range(1,1+len(regions))) if ix==0 else list(range(21,21+len(regions)))
    file='object_1.model' if ix==0 else 'object_4.model'
    obj=ET.SubElement(resources,f'{{{ns}}}object',{'id':str(aid),'type':'model'});comp=ET.SubElement(obj,f'{{{ns}}}components')
    for oid in ids:ET.SubElement(comp,f'{{{ns}}}component',{'objectid':str(oid),f'{{{pns}}}path':'/3D/Objects/'+file,'transform':f'1 0 0 0 1 0 0 0 1 {cx} 160 0'})
    ET.SubElement(build,f'{{{ns}}}item',{'objectid':str(aid),'transform':'1 0 0 0 1 0 0 0 1 0 0 0','printable':'1'})
    config=ET.SubElement(settings,'object',{'id':str(aid)})
    for key,value in dict(chosen,name=title).items():ET.SubElement(config,'metadata',{'key':key,'value':value})
    ET.SubElement(config,'metadata',{'face_count':str(sum(len(m.faces) for m in meshes))})
    model=ET.Element(f'{{{ns}}}model',{'unit':'millimeter'});rs=ET.SubElement(model,f'{{{ns}}}resources')
    for oid,m,(n,c,p,h) in zip(ids,meshes,regions):
        part=ET.SubElement(config,'part',{'id':str(oid),'subtype':'normal_part'})
        for key,value in [('name',n),('matrix',f'1 0 0 {cx} 0 1 0 160 0 0 1 0 0 0 0 1'),('extruder',str(slots_by_name[n]))]:ET.SubElement(part,'metadata',{'key':key,'value':value})
        ET.SubElement(part,'mesh_stat',{'face_count':str(len(m.faces)),'edges_fixed':'0','degenerate_facets':'0','facets_removed':'0','facets_reversed':'0','backwards_edges':'0'})
        obj=ET.SubElement(rs,f'{{{ns}}}object',{'id':str(oid),'type':'model','name':n});mx=ET.SubElement(obj,f'{{{ns}}}mesh');vs=ET.SubElement(mx,f'{{{ns}}}vertices');ts=ET.SubElement(mx,f'{{{ns}}}triangles')
        for x,y,z in m.vertices:ET.SubElement(vs,f'{{{ns}}}vertex',{'x':f'{x:.6f}','y':f'{y:.6f}','z':f'{z:.6f}'})
        for a,b,c in m.faces:ET.SubElement(ts,f'{{{ns}}}triangle',{'v1':str(a),'v2':str(b),'v3':str(c)})
    ET.SubElement(model,f'{{{ns}}}build');updates['3D/Objects/'+file]=ET.tostring(model,encoding='utf-8',xml_declaration=True)
plate=ET.SubElement(settings,'plate')
for key,value in [('plater_id','1'),('plater_name','Lion pinhole corner test'),('locked','false'),('filament_map_mode','Auto For Flush'),('filament_maps','1 1 2 1 1 1 2'),('filament_volume_maps','0 0 0 0 0 0 0'),('gcode_file',''),('thumbnail_file','Metadata/plate_1.png'),('thumbnail_no_light_file','Metadata/plate_no_light_1.png'),('top_file','Metadata/top_1.png'),('pick_file','Metadata/pick_1.png')]:ET.SubElement(plate,'metadata',{'key':key,'value':value})
for aid,identify in [(6,127),(20,130)]:
    inst=ET.SubElement(plate,'model_instance')
    for key,value in [('object_id',str(aid)),('instance_id','0'),('identify_id',str(identify))]:ET.SubElement(inst,'metadata',{'key':key,'value':value})
ET.SubElement(settings,'assemble')
# Keep known H2D material definitions and set the colors to currently loaded PLA.
with zipfile.ZipFile(O/'lion-ironing-test-ready-H2D.3mf') as prev:project=json.loads(prev.read('Metadata/project_settings.config'))
project.update(chosen);project['top_surface_speed']=['50']*7;project['gap_infill_speed']=['30']*7
project['initial_layer_print_height']='0.2';project['wipe_tower_x']=['40'];project['wipe_tower_y']=['235']
project['filament_colour'][3]='#0086D6'
if 'filament_multi_colour' in project:project['filament_multi_colour'][3]='#0086D6'
updates['3D/3dmodel.model']=ET.tostring(root,encoding='utf-8',xml_declaration=True)
updates['Metadata/model_settings.config']=ET.tostring(settings,encoding='utf-8',xml_declaration=True)
updates['Metadata/project_settings.config']=json.dumps(project,indent=2).encode()
updates['3D/_rels/3dmodel.model.rels']=b'<?xml version="1.0" encoding="UTF-8"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Target="/3D/Objects/object_1.model" Id="rel-1" Type="http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel"/><Relationship Target="/3D/Objects/object_4.model" Id="rel-4" Type="http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel"/></Relationships>'

im=np.full((700,1250,3),244,np.uint8)
for ox,regions,title in [(40,original,'A - slicer changes only'),(665,rounded,'B - rounded corners + buried black ledge')]:
    for n,c,p,h in regions:
        mask=np.zeros(im.shape[:2],np.uint8)
        for q in polygons(p):
            single=np.zeros_like(mask)
            coords=lambda ring:np.array([((x+15)*17+ox,(16-y)*17+60) for x,y in ring.coords],np.int32)
            cv2.fillPoly(single,[coords(q.exterior)],255)
            for hole in q.interiors:cv2.fillPoly(single,[coords(hole)],0)
            mask|=single
        im[mask>0]=[int(c[k:k+2],16) for k in [1,3,5]]
preview=Image.fromarray(im);d=ImageDraw.Draw(preview)
d.text((40,25),'A - slicer changes only',fill='black');d.text((665,25),'B - rounded corners + buried black ledge',fill='black')
d.text((40,630),'Both: Arachne, zero seam gap, 0.1 mm layers, ironing OFF. Each 30 x 32 mm.',fill='black')
d.text((40,655),'Cyan replaces orange; blue-gray replaces brown. White / yellow / black retained.',fill='black')
preview.save(O/'lion-pinhole-test-preview.png')
thumb=preview.copy();thumb.thumbnail((512,512));buf=io.BytesIO();thumb.save(buf,format='PNG')
for path in ['Metadata/plate_1.png','Metadata/plate_no_light_1.png','Metadata/plate_1_small.png','Auxiliaries/.thumbnails/thumbnail_3mf.png','Auxiliaries/.thumbnails/thumbnail_middle.png','Auxiliaries/.thumbnails/thumbnail_small.png']:updates[path]=buf.getvalue()
target=O/'lion-pinhole-test-H2D.3mf'
with zipfile.ZipFile(target,'w',zipfile.ZIP_DEFLATED) as out:
    for info in base.infolist():
        path=info.filename
        if path.startswith('3D/Objects/') and path not in updates:continue
        if path.startswith('Metadata/') and path not in updates and path!='Metadata/cut_information.xml':continue
        if path.startswith('Auxiliaries/') and path not in updates:continue
        out.writestr(copy.copy(info),updates.pop(path,base.read(path)))
    for path,data in updates.items():out.writestr(path,data)
with zipfile.ZipFile(target) as z:
    assert z.testzip() is None
    for f in ['3D/Objects/object_1.model','3D/Objects/object_4.model']:
        for obj in ET.fromstring(z.read(f)).find(f'{{{ns}}}resources'):
            mx=obj.find(f'{{{ns}}}mesh')
            vs=np.array([[float(v.get(k)) for k in ['x','y','z']] for v in mx.find(f'{{{ns}}}vertices')])
            fs=np.array([[int(v.get(k)) for k in ['v1','v2','v3']] for v in mx.find(f'{{{ns}}}triangles')])
            m=trimesh.Trimesh(vertices=vs,faces=fs,process=True)
            assert m.is_watertight and m.is_winding_consistent and m.volume>0,(f,obj.get('name'))
assert hashlib.sha256(source.read_bytes()).hexdigest()==source_hash
validation={'output':str(target),'source_full_panel_sha256':source_hash,'full_panel_unchanged':True,'coupon_size_mm':[30,32,2.5],'crop_source_mm':[-36,-18,-8,12],'common_settings':chosen,'first_layer_mm':.2,'corner_radius_mm':.25,'ledge_height_mm':.2,'ledge_extension_mm':.4,'muzzle_tip_ledge_extension_mm':.8,'muzzle_tip_zone_radius_mm':3,'muzzle_tip_xy_mm':list(tip),'samples':reports,'geometry_validated':True,'serialized_meshes_validated':True,'slicer_validated':False,'print_started':False,'expected_ams_mapping':{'White':'B3','Cyan':'B2','Sunflower Yellow':'A3','Blue Gray':'B4','Black':'A4'}}
(O/'lion-pinhole-test-validation.json').write_text(json.dumps(validation,indent=2))
(O/'lion-pinhole-test-notes.txt').write_text('''LION PINHOLE CORNER TEST\n\nTwo 30 x 32 mm samples. Viewed from the front of the printer:\nA (left): original corner geometry, Arachne and zero seam gap.\nB (right): same settings, plus 0.25 mm corner rounding and a buried black\nledge 0.2 mm thick extending 0.4 mm under adjacent colors.\n\nBoth: ironing OFF, 0.1 mm layers, 0.2 mm first layer, 0.8 mm color panes,\n2.5 mm black framework, 100% infill, 50 mm/s top surfaces, 30 mm/s gap fill,\n20% infill/wall overlap. Materials explicitly partitioned without mesh overlap.\n\nLoaded-color substitutions: orange -> cyan; brown -> blue-gray.\nKeep samples in left/right order when removing from the bed.\nCompare the pointed upper left corner of the white muzzle against the same\nbacklight after cooling. A tests the slicer changes; B adds geometry changes.\n\nSlicing and physical print status are recorded separately in the validation JSON.\n''',encoding='utf-8')
print(json.dumps({'output':str(target),'parts_per_sample':len(original),'samples':reports,'geometry_validated':True},indent=2))

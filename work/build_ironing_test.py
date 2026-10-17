from pathlib import Path
import sys,json,zipfile,copy,xml.etree.ElementTree as ET
sys.path.insert(0,str(Path(__file__).parent/'pydeps'))
import numpy as np,trimesh,cv2
from shapely.geometry import box
from shapely.affinity import translate
from shapely import set_precision
from PIL import Image,ImageDraw
R=Path(__file__).resolve().parents[1];O=R/'outputs';W=R/'work'
base=zipfile.ZipFile(O/'lion-lightbox-two-panels-H2D.3mf')
prefix=(W/'build_lightbox_lion.py').read_text().split('meshes=[];report=[]')[0]
env={'__file__':str(W/'build_lightbox_lion.py')}
exec(prefix.replace('lion-panel-wink-smirk-draft-v2.png','lion-panel-concept-v5.png'),env)
crop=box(-50,-32,10,18);outer=box(-31,-26,31,26)
regions=[]
for name,color,poly,height in env['regions']:
 poly=set_precision(translate(poly.intersection(crop),20,7),.001)
 if name=='Black':poly=poly.union(outer.difference(box(-30,-25,30,25)))
 assert poly.area>1,name
 regions.append((name,color,poly,height))
assert abs(sum(p.area for _,_,p,_ in regions)-outer.area)<1e-5
meshes=[];report=[]
for name,color,poly,height in regions:
 mesh=trimesh.util.concatenate([trimesh.creation.extrude_polygon(p,height,engine='earcut') for p in env['polygons'](poly)])
 assert mesh.is_watertight and mesh.is_winding_consistent and mesh.volume>0
 meshes.append(mesh);report.append({'name':name,'color':color,'volume_mm3':float(mesh.volume),'watertight':True,'triangles':len(mesh.faces)})
ns='http://schemas.microsoft.com/3dmanufacturing/core/2015/02';pns='http://schemas.microsoft.com/3dmanufacturing/production/2015/06'
ET.register_namespace('',ns);ET.register_namespace('p',pns);ET.register_namespace('BambuStudio','http://schemas.bambulab.com/package/2021')
root=ET.fromstring(base.read('3D/3dmodel.model'));resources=root.find(f'{{{ns}}}resources');resources.clear();build=root.find(f'{{{ns}}}build');build.clear()
settings=ET.Element('config');slots=[7,1,2,3,4,6]
chosen={'layer_height':'0.1','sparse_infill_density':'100%','sparse_infill_pattern':'zig-zag','enable_support':'0','brim_type':'no_brim','top_surface_speed':'50','gap_infill_speed':'30','infill_wall_overlap':'20%','top_surface_pattern':'monotonicline','ironing_speed':'30','ironing_flow':'10%','ironing_spacing':'0.15','ironing_pattern':'zig-zag'}
for aid,cx,ironing,title in [(6,135,'no ironing','A - no ironing'),(20,215,'top','B - top-surface ironing')]:
 ids=[1,2,3,4,11,12] if aid==6 else [21,22,23,24,25,26]
 file='object_1.model' if aid==6 else 'object_4.model'
 obj=ET.SubElement(resources,f'{{{ns}}}object',{'id':str(aid),'type':'model'});comp=ET.SubElement(obj,f'{{{ns}}}components')
 for oid in ids:ET.SubElement(comp,f'{{{ns}}}component',{'objectid':str(oid),f'{{{pns}}}path':'/3D/Objects/'+file,'transform':f'1 0 0 0 1 0 0 0 1 {cx} 160 0'})
 ET.SubElement(build,f'{{{ns}}}item',{'objectid':str(aid),'transform':'1 0 0 0 1 0 0 0 1 0 0 0','printable':'1'})
 config=ET.SubElement(settings,'object',{'id':str(aid)})
 for key,value in dict(chosen,name=title,ironing_type=ironing).items():ET.SubElement(config,'metadata',{'key':key,'value':value})
 ET.SubElement(config,'metadata',{'face_count':str(sum(len(m.faces) for m in meshes))})
 for oid,slot,mesh,(name,col,poly,height) in zip(ids,slots,meshes,regions):
  part=ET.SubElement(config,'part',{'id':str(oid),'subtype':'normal_part'})
  for key,value in [('name',name),('matrix',f'1 0 0 {cx} 0 1 0 160 0 0 1 0 0 0 0 1'),('extruder',str(slot))]:ET.SubElement(part,'metadata',{'key':key,'value':value})
  ET.SubElement(part,'mesh_stat',{'face_count':str(len(mesh.faces)),'edges_fixed':'0','degenerate_facets':'0','facets_removed':'0','facets_reversed':'0','backwards_edges':'0'})
plate=ET.SubElement(settings,'plate')
for key,value in [('plater_id','1'),('plater_name','Lion seam and ironing test'),('locked','false'),('filament_map_mode','Auto For Flush'),('filament_maps','1 1 2 1 1 1 2'),('filament_volume_maps','0 0 0 0 0 0 0'),('gcode_file',''),('thumbnail_file','Metadata/plate_1.png'),('thumbnail_no_light_file','Metadata/plate_no_light_1.png'),('top_file','Metadata/top_1.png'),('pick_file','Metadata/pick_1.png')]:ET.SubElement(plate,'metadata',{'key':key,'value':value})
for aid,identify in [(6,127),(20,130)]:
 inst=ET.SubElement(plate,'model_instance')
 for key,value in [('object_id',str(aid)),('instance_id','0'),('identify_id',str(identify))]:ET.SubElement(inst,'metadata',{'key':key,'value':value})
ET.SubElement(settings,'assemble')
project=json.loads(base.read('Metadata/project_settings.config'))
project.update(chosen);project['top_surface_speed']=['50']*7;project['gap_infill_speed']=['30']*7
project['ironing_type']='no ironing';project['initial_layer_print_height']='0.2';project['wipe_tower_x']=['40'];project['wipe_tower_y']=['235'];project['wall_generator']='classic'
model=ET.Element(f'{{{ns}}}model',{'unit':'millimeter'});rs=ET.SubElement(model,f'{{{ns}}}resources')
for oid,mesh,(name,col,poly,height) in zip([1,2,3,4,11,12],meshes,regions):
 obj=ET.SubElement(rs,f'{{{ns}}}object',{'id':str(oid),'type':'model','name':name});mx=ET.SubElement(obj,f'{{{ns}}}mesh');vs=ET.SubElement(mx,f'{{{ns}}}vertices');ts=ET.SubElement(mx,f'{{{ns}}}triangles')
 for x,y,z in mesh.vertices:ET.SubElement(vs,f'{{{ns}}}vertex',{'x':f'{x:.6f}','y':f'{y:.6f}','z':f'{z:.6f}'})
 for a,b,c in mesh.faces:ET.SubElement(ts,f'{{{ns}}}triangle',{'v1':str(a),'v2':str(b),'v3':str(c)})
ET.SubElement(model,f'{{{ns}}}build')
rel='<?xml version="1.0" encoding="UTF-8"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Target="/3D/Objects/object_1.model" Id="rel-1" Type="http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel"/><Relationship Target="/3D/Objects/object_4.model" Id="rel-4" Type="http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel"/></Relationships>'
updates={'3D/3dmodel.model':ET.tostring(root,encoding='utf-8',xml_declaration=True),'3D/Objects/object_1.model':ET.tostring(model,encoding='utf-8',xml_declaration=True),'3D/_rels/3dmodel.model.rels':rel.encode(),'Metadata/model_settings.config':ET.tostring(settings,encoding='utf-8',xml_declaration=True),'Metadata/project_settings.config':json.dumps(project,indent=2).encode()}
for obj,oid in zip(rs,[21,22,23,24,25,26]):obj.set('id',str(oid))
updates['3D/Objects/object_4.model']=ET.tostring(model,encoding='utf-8',xml_declaration=True)
# Render the actual crop geometry; no image reconstruction or photo tracing changes.
im=np.full((620,1500,3),244,dtype=np.uint8)
for ox in [50,810]:
 for name,col,poly,height in regions:
  mask=np.zeros(im.shape[:2],dtype=np.uint8)
  for p in env['polygons'](poly):
   single=np.zeros_like(mask)
   cv2.fillPoly(single,[np.array([((x+31)*10+ox,(26-y)*10+45) for x,y in p.exterior.coords],np.int32)],255)
   for hole in p.interiors:cv2.fillPoly(single,[np.array([((x+31)*10+ox,(26-y)*10+45) for x,y in hole.coords],np.int32)],0)
   mask|=single
  im[mask>0]=[int(col[k:k+2],16) for k in [1,3,5]]
preview=Image.fromarray(im);draw=ImageDraw.Draw(preview);draw.text((50,15),'A - no ironing',fill='black');draw.text((810,15),'B - ironing: 30 mm/s, 10% flow, 0.15 mm spacing',fill='black');preview.save(O/'lion-ironing-test-preview.png')
import io
thumbnail=preview.copy();thumbnail.thumbnail((512,512));bio=io.BytesIO();thumbnail.save(bio,format='PNG')
for path in ['Metadata/plate_1.png','Metadata/plate_no_light_1.png','Metadata/plate_1_small.png','Auxiliaries/.thumbnails/thumbnail_3mf.png','Auxiliaries/.thumbnails/thumbnail_middle.png','Auxiliaries/.thumbnails/thumbnail_small.png']:updates[path]=bio.getvalue()
target=O/'lion-ironing-test-H2D.3mf'
with zipfile.ZipFile(target,'w',zipfile.ZIP_DEFLATED) as out:
 for info in base.infolist():
  path=info.filename
  if path.startswith('3D/Objects/') and path not in updates:continue
  if path.startswith('Metadata/') and path not in updates and path!='Metadata/cut_information.xml':continue
  if path.startswith('Auxiliaries/') and path not in updates:continue
  out.writestr(copy.copy(info),updates.pop(path,base.read(path)))
 for path,data in updates.items():out.writestr(path,data)
with zipfile.ZipFile(target) as z:assert z.testzip() is None
validation={'output':str(target),'coupon_size_mm':[62,52,2.5],'crop_source_mm':[-50,-32,10,18],'colored_panes_mm':0.8,'first_layer_mm':0.2,'layer_height_mm':0.1,'common_settings':chosen,'A_ironing':'off','B_ironing':'Top surfaces','colors_by_project_slot':dict(zip(slots,[r[0] for r in regions])),'parts':report,'geometry_validated':True,'slicer_validated':False,'print_started':False}
(O/'lion-ironing-test-validation.json').write_text(json.dumps(validation,indent=2))
(O/'lion-ironing-test-notes.txt').write_text('''LION SEAM AND IRONING TEST\n\nTwo identical 62 x 52 mm samples on plate 1. Viewed from the front of the printer:\nA (left): no ironing. B (right): Top surfaces ironing, rectilinear, 30 mm/s,\n10% flow, 0.15 mm spacing. Both: 0.1 mm layers, 0.2 mm first layer,\n50 mm/s top surfaces, 30 mm/s gap fill, 20% infill/wall overlap, 100% infill.\nClassic walls and existing filament flow ratios retained.\n\nSame color-boundary geometry, 0.8 mm color thickness, and 2.5 mm black height\nas the original full insert. A 1 mm black perimeter supports the crop.\n\nProject colors: 1 White, 2 Cyan, 3 Yellow, 4 Orange, 6 Brown, 7 Black.\nColor 5 is unused. Project color numbers are not physical AMS slot numbers.\nMap against current filament labels before printing. Enable normal bed leveling\nand nozzle-offset/flow calibration when available in the print dialog.\n\nCompare both samples against the same backlight after cooling. Check pinholes\nat color boundaries separately from smoothness of the colored top surfaces.\n''',encoding='utf-8')
print(json.dumps({'output':str(target),'coupon_size_mm':validation['coupon_size_mm'],'color_volumes_mm3':{p['name']:round(p['volume_mm3'],2) for p in report}},indent=2))

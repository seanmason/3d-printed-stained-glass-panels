from pathlib import Path
import sys,zipfile,json,copy,hashlib,io,re,xml.etree.ElementTree as E
sys.path.insert(0,str(Path(__file__).parent/'pydeps'))
import numpy as np,trimesh
from PIL import Image,ImageDraw

R=Path(__file__).resolve().parents[1];O=R/'outputs'
source=O/'lion-lightbox-two-panels-H2D.3mf'
target=O/'lion-wink-arachne-snug-H2D.3mf'
ns='http://schemas.microsoft.com/3dmanufacturing/core/2015/02'
pns='http://schemas.microsoft.com/3dmanufacturing/production/2015/06'
E.register_namespace('',ns);E.register_namespace('p',pns)
E.register_namespace('BambuStudio','http://schemas.bambulab.com/package/2021')
base=zipfile.ZipFile(source);root=E.fromstring(base.read('3D/3dmodel.model'))
settings=E.fromstring(base.read('Metadata/model_settings.config'))
project=json.loads(base.read('Metadata/project_settings.config'))
with zipfile.ZipFile(O/'lion-pinhole-test-v2-ready-H2D.3mf') as z:
    test=E.fromstring(z.read('Metadata/model_settings.config'))
    a=next(o for o in test.findall('object') if o.find('metadata[@key="name"]').get('value').startswith('A -'))
    keys=['layer_height','sparse_infill_density','sparse_infill_pattern','enable_support','brim_type','top_surface_speed','gap_infill_speed','infill_wall_overlap','top_surface_pattern','ironing_type','wall_generator','seam_gap','seam_slope_type']
    chosen={k:a.find(f'metadata[@key="{k}"]').get('value') for k in keys}
assert chosen['wall_generator']=='arachne' and chosen['ironing_type']=='no ironing'
resources=root.find(f'{{{ns}}}resources');build=root.find(f'{{{ns}}}build')
resources.remove(resources.find(f'{{{ns}}}object[@id="20"]'))
build.remove(build.find(f'{{{ns}}}item[@objectid="20"]'))
settings.remove(settings.find('object[@id="20"]'))
assembly=resources.find(f'{{{ns}}}object[@id="6"]')
for c in assembly.find(f'{{{ns}}}components'):
    c.set('transform','1 0 0 0 1 0 0 0 1 175 150 0')
panel=settings.find('object[@id="6"]')
for k,v in dict(chosen,name='Winking-smirking Lion - 108.2 x 144.2 mm - Arachne').items():
    m=panel.find(f'metadata[@key="{k}"]')
    if m is None:m=E.SubElement(panel,'metadata',{'key':k})
    m.set('value',v)
for part in panel.findall('part'):
    part.find('metadata[@key="matrix"]').set('value','1 0 0 175 0 1 0 150 0 0 1 0 0 0 0 1')
    if part.find('metadata[@key="name"]').get('value')=='Pumpkin Orange':part.find('metadata[@key="name"]').set('value','Orange')
plate=settings.findall('plate')[0]
plate.find('metadata[@key="plater_name"]').set('value','Winking-smirking lion - Arachne snug fit')
for inst in list(plate.findall('model_instance')):
    if inst.find('metadata[@key="object_id"]').get('value')=='20':plate.remove(inst)
for key in ['filament_maps','filament_volume_maps','filament_map_mode','gcode_file']:
    old=plate.find(f'metadata[@key="{key}"]')
    if old is not None:plate.remove(old)
for k,v in [('filament_map_mode','Auto For Flush'),('filament_maps','1 1 2 2 1 1 2'),('filament_volume_maps','0 0 0 0 0 0 0'),('gcode_file','')]:E.SubElement(plate,'metadata',{'key':k,'value':v})
# Preserve exact approved geometry, with only a 0.2 mm increase in each span.
model=E.fromstring(base.read('3D/Objects/object_1.model'));reports=[];meshes=[]
sx,sy=108.2/108,144.2/144
for obj in model.find(f'{{{ns}}}resources'):
    mesh=obj.find(f'{{{ns}}}mesh');vs=mesh.find(f'{{{ns}}}vertices');fs=mesh.find(f'{{{ns}}}triangles')
    oldv=np.array([[float(v.get(k)) for k in ['x','y','z']] for v in vs]);newv=oldv*[sx,sy,1]
    faces=np.array([[int(t.get(k)) for k in ['v1','v2','v3']] for t in fs])
    m=trimesh.Trimesh(newv,faces,process=True)
    assert m.is_watertight and m.is_winding_consistent and m.volume>0
    for v,(x,y,z) in zip(vs,newv):
        for k,val in zip(['x','y','z'],[x,y,z]):v.set(k,f'{val:.6f}')
    meshes.append((obj.get('name'),m))
    reports.append({'name':obj.get('name'),'watertight':True,'volume_mm3':float(m.volume),'triangles':len(m.faces)})
allv=np.vstack([m.vertices for n,m in meshes]);bounds=np.array([allv.min(0),allv.max(0)])
assert np.allclose(bounds,[[-54.1,-72.1,0],[54.1,72.1,2.5]],atol=1e-6)
for k,v in chosen.items():
    if k not in ['top_surface_speed','gap_infill_speed']:project[k]=v
project['top_surface_speed']=['50']*7;project['gap_infill_speed']=['30']*7
project['initial_layer_print_height']='0.2'
project['wipe_tower_x']=['40','40','40'];project['wipe_tower_y']=['245','270','270']
project['filament_colour'][3]='#FF6A13'
if 'filament_multi_colour' in project:project['filament_multi_colour'][3]='#FF6A13'
# Geometry-derived preview, with actual filament colors.
cols={'Black':'#000000','Jade White':'#FFFFFF','Cyan':'#0086D6','Sunflower Yellow':'#FEC600','Pumpkin Orange':'#FF6A13','Cocoa Brown':'#6F5034'}
im=Image.new('RGB',(602,782),'#eeeeee');d=ImageDraw.Draw(im)
for name,m in meshes:
    top=m.vertices[:,2].max()
    for tri in m.triangles:
        if np.all(np.abs(tri[:,2]-top)<1e-6):d.polygon([(round((x+54.1)*5+30),round((72.1-y)*5+30)) for x,y,z in tri],fill=cols[name])
im.save(O/'lion-wink-arachne-snug-preview.png')
thumb=im.copy();thumb.thumbnail((512,512));buf=io.BytesIO();thumb.save(buf,format='PNG')
updates={'3D/3dmodel.model':E.tostring(root,encoding='utf-8',xml_declaration=True),'3D/Objects/object_1.model':E.tostring(model,encoding='utf-8',xml_declaration=True),'Metadata/model_settings.config':E.tostring(settings,encoding='utf-8',xml_declaration=True),'Metadata/project_settings.config':json.dumps(project,indent=2).encode()}
rels=base.read('3D/_rels/3dmodel.model.rels').decode()
rels=re.sub(r'<Relationship\s+[^>]*Target="/3D/Objects/object_4.model"[^>]*/>','',rels)
updates['3D/_rels/3dmodel.model.rels']=rels.encode()
for f in ['Metadata/plate_1.png','Metadata/plate_no_light_1.png','Metadata/plate_1_small.png','Auxiliaries/.thumbnails/thumbnail_3mf.png','Auxiliaries/.thumbnails/thumbnail_middle.png','Auxiliaries/.thumbnails/thumbnail_small.png']:updates[f]=buf.getvalue()
with zipfile.ZipFile(target,'w',zipfile.ZIP_DEFLATED) as dest:
    for info in base.infolist():
        if info.filename=='3D/Objects/object_4.model' or info.filename in ['Metadata/plate_1.json','Metadata/plate_1.gcode']:continue
        dest.writestr(copy.copy(info),updates.pop(info.filename,base.read(info.filename)))
    for f,data in updates.items():dest.writestr(f,data)
checks={}
with zipfile.ZipFile(target) as z:
    assert z.testzip() is None
    for f in ['3D/Objects/object_2.model','3D/Objects/object_3.model']:checks[f]=z.read(f)==base.read(f)
    oldroot=E.fromstring(base.read('3D/3dmodel.model'));oldset=E.fromstring(base.read('Metadata/model_settings.config'))
    for oid in [8,10]:
        for path,label in [(f'{{{ns}}}resources/{{{ns}}}object[@id="{oid}"]','assembly'),(f'{{{ns}}}build/{{{ns}}}item[@objectid="{oid}"]','placement')]:checks[f'{oid}_{label}']=E.tostring(root.find(path))==E.tostring(oldroot.find(path))
        checks[f'{oid}_settings']=E.tostring(settings.find(f'object[@id="{oid}"]'))==E.tostring(oldset.find(f'object[@id="{oid}"]'))
    for i in [1,2]:checks[f'plate_{i+1}']=E.tostring(settings.findall('plate')[i])==E.tostring(oldset.findall('plate')[i])
assert all(checks.values())
report={'output':str(target),'source':str(source),'size_mm':[108.2,144.2,2.5],'previous_size_mm':[108,144,2.5],'increase_per_edge_mm':.1,'colored_panes_mm':.8,'geometry':'Approved winking-smirking v2 design, XY scaled only. No rounded corners or buried ledge.','successful_sample':'A - slicer changes only','settings':chosen,'parts':reports,'retained_housing_and_guide_checks':checks,'geometry_validated':True,'slicer_validated':False,'physical_fit_tested':False,'print_started':False,'expected_ams_mapping':{'White':'B3','Cyan':'B2','Yellow':'A3','Orange':'A1','Cocoa Brown':'B4','Black':'A4'}}
(O/'lion-wink-arachne-snug-validation.json').write_text(json.dumps(report,indent=2))
print(json.dumps({'output':str(target),'bounds_mm':bounds.tolist(),'settings':chosen,'retained_objects':checks},indent=2))

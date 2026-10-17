from pathlib import Path
import zipfile,copy,json,hashlib,xml.etree.ElementTree as ET
R=Path(__file__).resolve().parents[1];O=R/'outputs';W=R/'work'
target=O/'lion-lightbox-two-panels-H2D.3mf'
native=zipfile.ZipFile(W/'lion-pair-studio-success.3mf');base=zipfile.ZipFile(target)
settings=ET.fromstring(base.read('Metadata/model_settings.config'));nssettings=ET.fromstring(native.read('Metadata/model_settings.config'))
plate=settings.findall('plate')[0]
for key in ['filament_maps','filament_volume_maps']:
 value=nssettings.findall('plate')[0].find(f'metadata[@key="{key}"]').get('value')
 ET.SubElement(plate,'metadata',{'key':key,'value':value})
project=json.loads(base.read('Metadata/project_settings.config'));nativeproject=json.loads(native.read('Metadata/project_settings.config'))
# Match the successful slice's automatic flush estimates and firmware compatibility.
for key in ['flush_volumes_matrix','flush_volumes_vector','enable_arc_fitting']:
 project[key]=nativeproject[key]
updates={'Metadata/model_settings.config':ET.tostring(settings,encoding='utf-8',xml_declaration=True),'Metadata/project_settings.config':json.dumps(project,indent=2).encode()}
for path in ['Metadata/plate_1.png','Metadata/plate_no_light_1.png','Metadata/top_1.png','Metadata/pick_1.png','Metadata/plate_1_small.png']:
 updates[path]=native.read(path)
for path in [p for p in base.namelist() if p.startswith('Auxiliaries/.thumbnails/')]:
 updates[path]=native.read('Metadata/plate_1.png')
temp=W/'lion-pair-finalized.3mf'
with zipfile.ZipFile(temp,'w',zipfile.ZIP_DEFLATED) as dest:
 for info in base.infolist():dest.writestr(copy.copy(info),updates.pop(info.filename,base.read(info.filename)))
 for path,data in updates.items():dest.writestr(path,data)
base.close();temp.replace(target)
original=zipfile.ZipFile(R/'sources/example_lithophane.3mf');final=zipfile.ZipFile(target)
assert final.testzip() is None
ns='http://schemas.microsoft.com/3dmanufacturing/core/2015/02'
fr=ET.fromstring(final.read('3D/3dmodel.model'));orr=ET.fromstring(original.read('3D/3dmodel.model'))
fs=ET.fromstring(final.read('Metadata/model_settings.config'));os=ET.fromstring(original.read('Metadata/model_settings.config'))
checks={}
for path in ['3D/Objects/object_2.model','3D/Objects/object_3.model']:
 checks[path]=hashlib.sha256(original.read(path)).digest()==hashlib.sha256(final.read(path)).digest()
for oid in [8,10]:
 for path,label in [(f'{{{ns}}}resources/{{{ns}}}object[@id="{oid}"]','assembly'),(f'{{{ns}}}build/{{{ns}}}item[@objectid="{oid}"]','placement')]:checks[f'object_{oid}_{label}']=ET.tostring(orr.find(path))==ET.tostring(fr.find(path))
 checks[f'object_{oid}_settings']=ET.tostring(os.find(f'object[@id="{oid}"]'))==ET.tostring(fs.find(f'object[@id="{oid}"]'))
for index in [1,2]:checks[f'plate_{index+1}_settings']=ET.tostring(os.findall('plate')[index])==ET.tostring(fs.findall('plate')[index])
assert all(checks.values())
bounds=json.loads(native.read('Metadata/plate_1.json'))
assert bounds['bbox_all']==[40.0,78.0,294.0,296.0]
reportpath=O/'lion-lightbox-two-panels-validation.json';report=json.loads(reportpath.read_text())
report['retained_objects_checks']=checks
report['bambu_studio_validation']={'version':'02.08.02.61','plate':1,'result':'Slice ok','estimated_time':'4h34m','estimated_total_filament_g':60.31,'layers':24,'maximum_layer_z_mm':2.5,'bounding_boxes':bounds,'purge_tower_position_mm':[40,245],'nozzle_grouping_project_colors':{'left':[1,2,4,6],'right':[3,7]}}
report['output_sha256']=hashlib.sha256(target.read_bytes()).hexdigest();reportpath.write_text(json.dumps(report,indent=2))
guide=O/'lion-lightbox-two-panels-print-notes.txt'
guide.write_text(guide.read_text()+'''\nValidated in Bambu Studio 02.08.02.61: plate 1 reports "Slice ok".\nEstimate: 4h34m, 60.31 g including purge waste. Editable project; slice again\nafter changing filaments or printer configuration.\nCurrent automatic nozzle grouping: left = 1 White, 2 Cyan, 4 Orange, 6 Brown;\nright = 3 Yellow, 7 Black. Choose Convenience Mode if this differs from the\nloaded AMS distribution; Bambu Studio will then generate a new grouping.\n''',encoding='utf-8')
print(json.dumps({'output':str(target),'retained_objects_checks':checks,'slice_result':'Slice ok','print_boundary_mm':bounds['bbox_all']},indent=2))

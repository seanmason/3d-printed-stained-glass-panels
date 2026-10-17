from pathlib import Path
import sys, zipfile, copy, json, hashlib, xml.etree.ElementTree as ET
sys.path.insert(0,str(Path(__file__).parent/'pydeps'))
import numpy as np
from xml.sax.saxutils import escape
R=Path(__file__).resolve().parents[1]; O=R/'outputs'; W=R/'work'
ns='http://schemas.microsoft.com/3dmanufacturing/core/2015/02'
pns='http://schemas.microsoft.com/3dmanufacturing/production/2015/06'
ET.register_namespace('',ns);ET.register_namespace('p',pns)
ET.register_namespace('BambuStudio','http://schemas.bambulab.com/package/2021')
base=zipfile.ZipFile(O/'lion-wink-lightbox-H2D.3mf')
original=zipfile.ZipFile(R/'sources/example_lithophane.3mf')
target=O/'lion-lightbox-two-panels-H2D.3mf'
root=ET.fromstring(base.read('3D/3dmodel.model'))
settings=ET.fromstring(base.read('Metadata/model_settings.config'))
prefix=(W/'build_lightbox_lion.py').read_text().split("ns='http://schemas.microsoft.com")[0]
prefix=prefix.replace("parts=O/'lion-wink-lightbox-parts'", "parts=W/'pair-mesh-scratch'")
slots=[7,1,2,3,4,6]; updates={}; reports=[]; allregions=[]
for name,image,assemblyid,ids,file,cx in [
 ('Winking Lion','lion-panel-wink-smirk-draft-v2.png',6,[1,2,3,4,11,12],'object_1.model',110),
 ('Original Lion','lion-panel-concept-v5.png',20,[21,22,23,24,25,26],'object_4.model',240)]:
 env={'__file__':str(W/'build_lightbox_lion.py'),'W':W}
 exec(prefix.replace('lion-panel-wink-smirk-draft-v2.png',image),env)
 meshes=env['meshes'];regions=env['regions'];allregions.append(regions)
 bounds=np.vstack([m.bounds for m in meshes]); actual=np.array([bounds[::2].min(0),bounds[1::2].max(0)])
 assert np.allclose(actual,[[-54,-72,0],[54,72,2.5]],atol=1e-6)
 # Two inserts lie within the common H2D print area with 22 mm between them.
 assert 25<=cx-54 and cx+54<=325
 assembly=root.find(f'{{{ns}}}resources/{{{ns}}}object[@id="{assemblyid}"]')
 if assembly is None:
  assembly=ET.SubElement(root.find(f'{{{ns}}}resources'),f'{{{ns}}}object',{'id':str(assemblyid),'type':'model'})
  components=ET.SubElement(assembly,f'{{{ns}}}components')
  ET.SubElement(root.find(f'{{{ns}}}build'),f'{{{ns}}}item',{'objectid':str(assemblyid),'transform':'1 0 0 0 1 0 0 0 1 0 0 0','printable':'1'})
 else:
  components=assembly.find(f'{{{ns}}}components');components.clear()
 panel=settings.find(f'object[@id="{assemblyid}"]')
 if panel is None:panel=ET.SubElement(settings,'object',{'id':str(assemblyid)})
 else:panel.clear();panel.set('id',str(assemblyid))
 for key,value in [('name',name+' - 108 x 144 mm insert'),('layer_height','.1'),('sparse_infill_density','100%'),('sparse_infill_pattern','zig-zag'),('enable_support','0'),('brim_type','no_brim')]:
  ET.SubElement(panel,'metadata',{'key':key,'value':value})
 ET.SubElement(panel,'metadata',{'face_count':str(sum(len(m.faces) for m in meshes))})
 xml=['<?xml version="1.0" encoding="UTF-8"?>',f'<model unit="millimeter" xmlns="{ns}"><resources>']
 for oid,slot,mesh,(colorname,col,poly,z) in zip(ids,slots,meshes,regions):
  ET.SubElement(components,f'{{{ns}}}component',{'objectid':str(oid),f'{{{pns}}}path':'/3D/Objects/'+file,'transform':f'1 0 0 0 1 0 0 0 1 {cx} 150 0'})
  part=ET.SubElement(panel,'part',{'id':str(oid),'subtype':'normal_part'})
  for key,value in [('name',colorname),('matrix',f'1 0 0 {cx} 0 1 0 150 0 0 1 0 0 0 0 1'),('extruder',str(slot))]:
   ET.SubElement(part,'metadata',{'key':key,'value':value})
  ET.SubElement(part,'mesh_stat',{'face_count':str(len(mesh.faces)),'edges_fixed':'0','degenerate_facets':'0','facets_removed':'0','facets_reversed':'0','backwards_edges':'0'})
  xml.append(f'<object id="{oid}" type="model" name="{escape(colorname)}"><mesh><vertices>')
  xml.extend(f'<vertex x="{x:.6f}" y="{y:.6f}" z="{z:.6f}"/>' for x,y,z in mesh.vertices)
  xml.append('</vertices><triangles>')
  xml.extend(f'<triangle v1="{a}" v2="{b}" v3="{c}"/>' for a,b,c in mesh.faces)
  xml.append('</triangles></mesh></object>')
 xml.append('</resources><build/></model>');updates['3D/Objects/'+file]=''.join(xml).encode()
 reports.append({'name':name,'size_mm':(actual[1]-actual[0]).tolist(),'plate_bounds_mm':[[cx-54,78,0],[cx+54,222,2.5]],'colored_panes_mm':.8,'parts':env['report']})
plate=settings.findall('plate')[0]
plate.find('metadata[@key="plater_name"]').set('value','Lion inserts - wink and original')
instance=ET.SubElement(plate,'model_instance')
for key,value in [('object_id','20'),('instance_id','0'),('identify_id','130')]:ET.SubElement(instance,'metadata',{'key':key,'value':value})
rels=base.read('3D/_rels/3dmodel.model.rels').decode().replace('</Relationships>','<Relationship Target="/3D/Objects/object_4.model" Id="rel-4" Type="http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel"/></Relationships>')
project=json.loads(base.read('Metadata/project_settings.config'))
# The six-color tower grows to 51 mm long; the inherited Y=270 reaches Y=321.
# Give only the insert plate a lower tower position; keep other plates at Y=270.
project['wipe_tower_y']=['245','270','270']
project['wipe_tower_x']=['40','40','40']
studio=zipfile.ZipFile(W/'lion-pair-studio-check.3mf')
synced=json.loads(studio.read('Metadata/project_settings.config'))
for key in ['extruder_ams_count','extruder_nozzle_stats','extruder_nozzle_stats_new']:
 if key in synced:project[key]=synced[key]
updates.update({'3D/3dmodel.model':ET.tostring(root,encoding='utf-8',xml_declaration=True),'Metadata/model_settings.config':ET.tostring(settings,encoding='utf-8',xml_declaration=True),'3D/_rels/3dmodel.model.rels':rels.encode(),'Metadata/project_settings.config':json.dumps(project,indent=2).encode()})
with zipfile.ZipFile(target,'w',zipfile.ZIP_DEFLATED) as dest:
 for info in base.infolist():dest.writestr(copy.copy(info),updates.pop(info.filename,base.read(info.filename)))
 for path,data in updates.items():dest.writestr(path,data)
new=zipfile.ZipFile(target);checks={}
for path in ['3D/Objects/object_2.model','3D/Objects/object_3.model']:
 checks[path]=hashlib.sha256(original.read(path)).hexdigest()==hashlib.sha256(new.read(path)).hexdigest()
oldroot=ET.fromstring(original.read('3D/3dmodel.model'));oldsettings=ET.fromstring(original.read('Metadata/model_settings.config'))
for oid in [8,10]:
 for path,label in [(f'{{{ns}}}resources/{{{ns}}}object[@id="{oid}"]','assembly'),(f'{{{ns}}}build/{{{ns}}}item[@objectid="{oid}"]','placement')]:checks[f'object_{oid}_{label}']=ET.tostring(oldroot.find(path))==ET.tostring(root.find(path))
 checks[f'object_{oid}_settings']=ET.tostring(oldsettings.find(f'object[@id="{oid}"]'))==ET.tostring(settings.find(f'object[@id="{oid}"]'))
for index in [1,2]:checks[f'plate_{index+1}_settings']=ET.tostring(oldsettings.findall('plate')[index])==ET.tostring(settings.findall('plate')[index])
assert all(checks.values()),checks
validation={'source':original.filename,'output':str(target),'dimension_reference':'Original outer rim part 2: 108 x 144 x 2.5 mm after its component Z translation. Both new black perimeters have the same bounds and flat outer edge.','panels':reports,'gap_mm':22,'all_parts_watertight':True,'footprint_complete_without_overlapping_regions':True,'retained_objects_checks':checks,'physical_fit_tested':False}
(O/'lion-lightbox-two-panels-validation.json').write_text(json.dumps(validation,indent=2))
# Geometry-derived top view, also useful as a precise manufacturing drawing.
svg=['<svg xmlns="http://www.w3.org/2000/svg" width="238mm" height="144mm" viewBox="-54 -72 238 144">']
for offset,regions in zip([0,130],allregions):
 svg.append(f'<g transform="translate({offset},0) scale(1 -1)">')
 for colorname,col,poly,z in regions:
  paths=[]
  for p in env['polygons'](poly):
   for ring in [p.exterior,*p.interiors]:paths.append('M'+' L'.join(f'{x:.4f},{y:.4f}' for x,y in ring.coords)+' Z')
  svg.append(f'<path fill="{col}" fill-rule="evenodd" d="{" ".join(paths)}"/>')
 svg.append('</g>')
svg.append('</svg>');(O/'lion-lightbox-two-panels.svg').write_text(''.join(svg))
print(json.dumps({'output':str(target),'panels':[{k:v for k,v in p.items() if k!='parts'} for p in reports],'retained_objects_checks':checks},indent=2))

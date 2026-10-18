from pathlib import Path
import sys,json,re,zipfile,copy,hashlib,xml.etree.ElementTree as E
sys.path.insert(0,str(Path(__file__).parent/'pydeps'))
import numpy as np,trimesh
from shapely.geometry import Polygon,box
from shapely.ops import unary_union
from shapely.affinity import translate
from PIL import Image,ImageDraw,ImageFont
R=Path(__file__).resolve().parents[1];O=R/'outputs';stem='corgi-junction-test-v2'
names=['Jade White','Cyan','Gold','Champagne','Cocoa Brown','Copper Brown Metallic','Black']
colors=['#FFFFFF','#0086D6','#F4A925','#F3CFB2','#6F5034','#AA6443','#000000'];slots=[1,2,3,4,6,8,7]
source_polys={}
for path in E.parse(O/'corgi-B-arachne-snug-manufacturing.svg').findall('.//{http://www.w3.org/2000/svg}path'):
 p=Polygon()
 for ring in re.findall(r'M([^Z]+)Z',path.get('d')):
  xy=np.array([float(v) for v in re.findall(r'-?\d+(?:\.\d+)?',ring)]).reshape(-1,2);p=p.symmetric_difference(Polygon(xy))
 source_polys[path.get('fill')]=p
crops=[('Eye',(-4,3,22,19)),('Muzzle',(22,-17,48,-1)),('Chest',(-5,-52,21,-36))]
def polygons(p):
 if p.is_empty:return []
 return [p] if p.geom_type=='Polygon' else [q for g in p.geoms for q in polygons(g)] if hasattr(p,'geoms') else []
slow={k:'35' for k in ['outer_wall_speed','inner_wall_speed','internal_solid_infill_speed','sparse_infill_speed','top_surface_speed','gap_infill_speed','small_perimeter_speed','initial_layer_speed','initial_layer_infill_speed']}
slow.update({k:'1000' for k in ['default_acceleration','outer_wall_acceleration','inner_wall_acceleration','top_surface_acceleration','sparse_infill_acceleration']})
variants=[('A - shallow control',1.,{}),('B - slower detail motion',1.,slow),('C - overlap 25 percent',1.,{'infill_wall_overlap':'25%'}),('D - flush black',.8,{})]
objects=[]
for v,(label,blackheight,overrides) in enumerate(variants):
 outline=Polygon([(0,0),(86,0),(86,20),(2,20),(0,18)])
 for n in range(v+1):outline=outline.difference(box(5+2*n,19.2,5.8+2*n,20.1))
 regions=[[] for _ in names];windows=[]
 for j,(name,bounds) in enumerate(crops):
  dest=box(2+28*j,2,28+28*j,18);windows.append(dest)
  for i,col in enumerate(colors):
   p=translate(source_polys[col].intersection(box(*bounds)),xoff=2+28*j-bounds[0],yoff=2-bounds[1])
   if not p.is_empty:regions[i].append((p,blackheight if i==6 else .8))
 regions[6].append((outline.difference(unary_union(windows)),1.6))
 objects.append(dict(name=label,regions=regions,outline=outline,xy=[120,152-24*v],overrides=overrides,black_height=blackheight))
# Separate dark-material thickness ladder: two columns, three rows, no backing.
outline=Polygon([(0,0),(26,0),(26,32),(2,32),(0,30)]);regions=[[] for _ in names];windows=[]
for row,(y,z) in enumerate([(22,.4),(12,.6),(2,.8)]):
 for i,x in [(4,2),(5,14)]:
  p=box(x,y,x+10,y+8);regions[i].append((p,z));windows.append(p)
regions[6].append((outline.difference(unary_union(windows)),1.6))
objects.append(dict(name='E - Cocoa and Copper thickness ladder',regions=regions,outline=outline,xy=[220,120],overrides={},black_height=1.6))
ns='http://schemas.microsoft.com/3dmanufacturing/core/2015/02';pn='http://schemas.microsoft.com/3dmanufacturing/production/2015/06'
E.register_namespace('',ns);E.register_namespace('p',pn)
base=zipfile.ZipFile(O/'corgi-B-arachne-snug-v2-verified-H2D.3mf')
base_cfg=json.loads(base.read('Metadata/project_settings.config'))
root=E.fromstring(base.read('3D/3dmodel.model'));resources=root.find(f'{{{ns}}}resources');resources.clear();build=root.find(f'{{{ns}}}build');build.clear()
old=E.fromstring(base.read('Metadata/model_settings.config'));template=old.find('object[@id="8"]');settings=E.Element('config');plate=copy.deepcopy(old.find('plate'))
for a in list(plate):
 if a.tag=='model_instance':plate.remove(a)
plate.find('metadata[@key="plater_name"]').set('value','Junction comparison A-D and dark ladder E')
xml=[f'<?xml version="1.0" encoding="UTF-8"?><model unit="millimeter" xmlns="{ns}"><resources>'];mesh_id=1;report=[]
for idx,obj in enumerate(objects):
 aid=100+idx;regions=obj['regions'];outline=obj['outline'];x,y=obj['xy']
 footprints=[unary_union([p for p,z in rs]) for rs in regions]
 assert abs(unary_union(footprints).area-outline.area)<1e-5
 for i,p in enumerate(footprints):
  for q in footprints[:i]:assert p.intersection(q).area<1e-6
 assembly=E.SubElement(resources,f'{{{ns}}}object',{'id':str(aid),'type':'model'});components=E.SubElement(assembly,f'{{{ns}}}components')
 E.SubElement(build,f'{{{ns}}}item',{'objectid':str(aid),'transform':'1 0 0 0 1 0 0 0 1 0 0 0','printable':'1'})
 panel=E.SubElement(settings,'object',{'id':str(aid)})
 opts={m.get('key'):m.get('value') for m in template.findall('metadata') if m.get('key')};opts.update(obj['overrides']);opts['name']=obj['name']
 for k,v in opts.items():
  if isinstance(base_cfg.get(k),list) and ',' not in v:v=','.join([v]*len(base_cfg[k]))
  E.SubElement(panel,'metadata',{'key':k,'value':v})
 rec=dict(name=obj['name'],origin_mm=obj['xy'],black_height_mm=obj['black_height'],settings=obj['overrides'],parts=[])
 for i,(name,rs) in enumerate(zip(names,regions)):
  if not rs:continue
  pieces=[trimesh.creation.extrude_polygon(q,z,engine='earcut') for p,z in rs for q in polygons(p) if q.area>1e-8]
  m=trimesh.boolean.union(pieces,engine='manifold') if i==6 else trimesh.util.concatenate(pieces)
  assert m.is_watertight and m.is_winding_consistent and m.volume>0
  E.SubElement(components,f'{{{ns}}}component',{'objectid':str(mesh_id),f'{{{pn}}}path':'/3D/Objects/object_1.model','transform':f'1 0 0 0 1 0 0 0 1 {x} {y} 0'})
  part=E.SubElement(panel,'part',{'id':str(mesh_id),'subtype':'normal_part'})
  for k,v in [('name',name),('extruder',str(slots[i])),('matrix',f'1 0 0 {x} 0 1 0 {y} 0 0 1 0 0 0 0 1')]:E.SubElement(part,'metadata',{'key':k,'value':v})
  E.SubElement(part,'mesh_stat',{'face_count':str(len(m.faces)),'edges_fixed':'0','degenerate_facets':'0','facets_removed':'0','facets_reversed':'0','backwards_edges':'0'})
  xml.append(f'<object id="{mesh_id}" type="model" name="{name}"><mesh><vertices>')
  xml.extend(f'<vertex x="{a:.6f}" y="{b:.6f}" z="{c:.6f}"/>' for a,b,c in m.vertices);xml.append('</vertices><triangles>')
  xml.extend(f'<triangle v1="{a}" v2="{b}" v3="{c}"/>' for a,b,c in m.faces);xml.append('</triangles></mesh></object>')
  rec['parts'].append(dict(name=name,slot=slots[i],watertight=True,volume_mm3=float(m.volume)));mesh_id+=1
 inst=E.SubElement(plate,'model_instance')
 for k,v in [('object_id',str(aid)),('instance_id','0'),('identify_id',str(2100+idx))]:E.SubElement(inst,'metadata',{'key':k,'value':v})
 report.append(rec)
settings.append(plate);xml.append('</resources><build/></model>')
cfg=json.loads(base.read('Metadata/project_settings.config'));cfg['wipe_tower_x']=['40'];cfg['wipe_tower_y']=['210']
updates={'3D/3dmodel.model':E.tostring(root,encoding='utf-8',xml_declaration=True),'3D/Objects/object_1.model':''.join(xml).encode(),'Metadata/model_settings.config':E.tostring(settings,encoding='utf-8',xml_declaration=True),'Metadata/project_settings.config':json.dumps(cfg,indent=2).encode()}
target=O/(stem+'-H2D.3mf')
with zipfile.ZipFile(target,'w',zipfile.ZIP_DEFLATED) as out:
 for item in base.infolist():
  n=item.filename
  if n.endswith(('.png','.gcode','.gcode.md5')) or n=='Metadata/slice_info.config' or n.startswith('Metadata/plate_') and n.endswith('.json'):continue
  if n in ['3D/Objects/object_2.model','3D/Objects/object_3.model']:continue
  if n.endswith('.rels') and n.startswith('3D/'):
   E.register_namespace('','http://schemas.openxmlformats.org/package/2006/relationships');rel=E.fromstring(base.read(n))
   for child in list(rel):
    if child.get('Target','').endswith(('object_2.model','object_3.model')):rel.remove(child)
   out.writestr(n,E.tostring(rel,encoding='utf-8',xml_declaration=True));continue
  out.writestr(copy.copy(item),updates.get(n,base.read(n)))
im=Image.new('RGB',(1400,1140),'#f1f2f4');d=ImageDraw.Draw(im);font=ImageFont.truetype('C:/Windows/Fonts/arial.ttf',23);small=ImageFont.truetype('C:/Windows/Fonts/arial.ttf',18)
d.text((30,15),'CORGI JUNCTION TEST v2 | face up, clipped corner at upper left',fill='black',font=font)
for idx,obj in enumerate(objects):
 ox=30 if idx<4 else 950;oy=95+idx*245 if idx<4 else 110;s=9 if idx<4 else 8;h=20 if idx<4 else 32
 def xy(a,b):return ox+s*a,oy+s*(h-b)
 d.text((ox,oy-35),obj['name']+(f' | {idx+1} top-edge notches' if idx<4 else ''),fill='black',font=font if idx<4 else small)
 d.polygon([xy(a,b) for a,b in obj['outline'].exterior.coords],fill='black')
 for n in range(idx+1 if idx<4 else 0):d.rectangle([xy(5+2*n,20),xy(5.8+2*n,19.2)],fill='#f1f2f4')
 for rs,col in [(obj['regions'][6],colors[6])]+list(zip(obj['regions'][:6],colors[:6])):
  for p,z in rs:
   for q in polygons(p):
    d.polygon([xy(a,b) for a,b in q.exterior.coords],fill=col)
    for ring in q.interiors:d.polygon([xy(a,b) for a,b in ring.coords],fill='black')
 if idx<4:d.text((ox,oy+182),'Eye                             Muzzle                           Chest',fill='black',font=small)
 else:
  d.text((950,390),'Left: Cocoa\nRight: Copper\nTop: 0.4 mm\nMiddle: 0.6 mm\nBottom: 0.8 mm',fill='black',font=small)
d.text((30,1100),'All colored detail panes: 0.8 mm. Interior black A/B/C: 1.0 mm; D: 0.8 mm. Frames: 1.6 mm.',fill='black',font=small)
im.save(O/(stem+'-guide.png'))
result=dict(project=target.name,variants=report,colored_panes_mm=.8,crop_dimensions_mm=[26,16],coupon_dimensions_mm=[86,20,1.6],modeled_gap_area_mm2=0,modeled_overlap_area_mm2=0,slicer_validated=False,print_started=False,source_sha256=hashlib.sha256(target.read_bytes()).hexdigest())
(O/(stem+'-validation.json')).write_text(json.dumps(result,indent=2));print('Generated',target,'parts',mesh_id-1)

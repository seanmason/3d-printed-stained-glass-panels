"""Full simplified Corgi using physical transmission and junction findings."""
from pathlib import Path
import sys,json,zipfile,copy,hashlib,xml.etree.ElementTree as E
R=Path(__file__).resolve().parents[1];O=R/'outputs'
REPO=R/'archive-repo' if (R/'archive-repo').exists() else R.parent
sys.path.insert(0,str(R/'work/pydeps'))
import numpy as np,trimesh
from shapely.geometry import Polygon,box,Point
from shapely.ops import unary_union
from shapely import set_precision
from PIL import Image,ImageDraw

stem='corgi-production-v6-02mm'
target=O/(stem+'-H2D.3mf')
if target.exists():
 assert not json.loads((O/(stem+'-validation.json')).read_text())['native_saved'], 'Preserve native output'
# Exact extraction used by the approved simplified v3 comparison; no old outputs overwritten.
code=(R/'work/build_corgi.py').read_text().split("parts=O/(stem+'-parts')")[0]
code=code.replace('corgi-panel-B-library-palette-v1.png','corgi-simplified-review-v2.png')
code=code.replace('buffer(-.20,quad_segs=4).buffer(.20,quad_segs=4)',
                  'buffer(-.35,quad_segs=8).buffer(.35,quad_segs=8)')
env={'__file__':str(R/'work/build_corgi.py')}
exec(code,env)
polys_by_color={c:p for n,c,p,z in env['regions']}
outline=env['outline'];inner=env['inner']
def polygons(p):
 return [] if p.is_empty else [p] if p.geom_type=='Polygon' else [q for a in p.geoms for q in polygons(a)]
# Remove raster shading seams inside contiguous cream areas and keep broad chest white.
light=unary_union([polys_by_color['#FFFFFF'],polys_by_color['#F3CFB2']]).buffer(.60).buffer(-.60).simplify(.025)
white=unary_union([q for q in polygons(light) if q.area>20 and q.centroid.y < -20])
cream=unary_union([q for q in polygons(light) if q.area>.8 and not (q.area>20 and q.centroid.y < -20)])
# Preserve both attentive eye highlights as deliberate printable 1.2 mm circles.
white=unary_union([white,Point(9.5,12.5).buffer(.6,quad_segs=24),Point(27,20.5).buffer(.6,quad_segs=24)])
polys_by_color['#FFFFFF']=white;polys_by_color['#F3CFB2']=cream.difference(white)
polys_by_color['#6F5034']=unary_union([polys_by_color['#6F5034'],polys_by_color['#AA6443']]).buffer(.35).buffer(-.35).simplify(.025)
polys_by_color['#AA6443']=Polygon()
taken=Polygon()
for color in ['#FFFFFF','#0086D6','#F4A925','#F3CFB2','#6F5034']:
 polys_by_color[color]=set_precision(polys_by_color[color],.01).intersection(inner).difference(taken)
 polys_by_color[color]=set_precision(polys_by_color[color],.01)
 taken=set_precision(unary_union([taken,polys_by_color[color]]),.01)
polys_by_color['#000000']=set_precision(outline.difference(taken),.01)
names=['Jade White','Cyan','Gold','Champagne','Cocoa Brown','Copper Brown Metallic','Black']
colors=['#FFFFFF','#0086D6','#F4A925','#F3CFB2','#6F5034','#AA6443','#000000']
slots=[1,2,3,4,6,8,7]
regions=[]
for c in colors[:4]:regions.append([(polys_by_color[c],.4)])
# Near-opaque Copper is replaced by the thinnest tested Cocoa for backlighting.
brown=unary_union([polys_by_color['#6F5034'],polys_by_color['#AA6443']])
regions += [[(brown,.3)],[],[(polys_by_color['#000000'].intersection(inner),.7),
                           (outline.difference(inner),2.5)]]
objects=[dict(name='Corgi B simplified - production v6 - 108.2 x 144.2',regions=regions,
              outline=outline,xy=[175,150],overrides={},black_height=.7)]
def polygons(p):
 return [] if p.is_empty else [p] if p.geom_type=='Polygon' else [q for a in p.geoms for q in polygons(a)]
source=(R/'work/build_junction_test_v2.py').read_text()
export=source[source.index("ns='http"):source.index('im=Image.new')]
export=export.replace("O/'corgi-B-arachne-snug-v2-verified-H2D.3mf'",
                      "REPO/'tests/diagnostic-v4/03-flow.3mf'")
export=export.replace("template=old.find('object[@id=\"8\"]')", "template=old.find('object')")
export=export.replace("opts={m.get('key'):m.get('value') for m in template.findall('metadata') if m.get('key')}","opts={}")
export=export.replace("trimesh.boolean.union(pieces,engine='manifold') if i==6 else trimesh.util.concatenate(pieces)",
                      'trimesh.util.concatenate(pieces)')
export=export.replace('Junction comparison A-D and dark ladder E','Corgi B production v6')
export=export.replace("pieces=[trimesh.creation.extrude_polygon(q,z,engine='earcut') for p,z in rs for q in polygons(p) if q.area>1e-8]", "pieces=[extrude_clean(q,z) for p,z in rs for q in polygons(p) if q.area>1e-8]")
export=export.replace('assert m.is_watertight and m.is_winding_consistent and m.volume>0',
                      'assert m.is_watertight and m.is_winding_consistent and m.volume>0, (name,m.is_watertight,m.is_winding_consistent,m.volume)')
export=export.replace("updates={'3D/3dmodel.model'", "configure(cfg)\nupdates={'3D/3dmodel.model'")
def configure(cfg):
 cfg['wipe_tower_x']=['40'];cfg['wipe_tower_y']=['235']
 cfg['reduce_crossing_wall']='1';cfg['reduce_infill_retraction_mode']='Disabled'
 cfg['different_settings_to_system'][0]+=';reduce_crossing_wall;reduce_infill_retraction_mode'
 # Keep white flow at the actual tested value. Other materials retain native 0.2 mm profiles.
 cfg['filament_flow_ratio'][:2]=['1.0094']*2
 # Established clean-color black settings from successful lion projects.
 for k,val in [('filament_retraction_length','0.6'),('filament_wipe_distance','2')]:
  cfg[k][12:14]=[val,val]
  cfg['different_settings_to_system'][7]+=';'+k
 # Conservative same-nozzle purging into tower, never into thin colored panes.
 cfg['flush_into_infill']='0';cfg['flush_into_objects']='0';cfg['flush_into_support']='0'
 cfg['flush_volumes_matrix']=[str(0 if i==j else 900 if (i==1 and j in [0,2,3]) or (i in [2,3] and j==0) or (i==6 and j==5) else 600)
                             for _ in range(2) for i in range(8) for j in range(8)]
def extrude_clean(q,z):
 m=trimesh.creation.extrude_polygon(q,z,engine='earcut')
 assert m.is_watertight and m.is_winding_consistent and m.volume>0
 return m
exec(export,globals())
# Sync embedded filament profiles with per-nozzle values so native save retains changes.
with zipfile.ZipFile(target) as z:payload={n:z.read(n) for n in z.namelist()}
c=json.loads(payload['Metadata/project_settings.config'])
for i in [1,7]:
 fn=f'Metadata/filament_settings_{i}.config';f=json.loads(payload[fn])
 for k in ['filament_flow_ratio','filament_retraction_length','filament_wipe_distance']:
  if k in c:f[k]=c[k][2*(i-1):2*i]
 payload[fn]=json.dumps(f,indent=2).encode()
with zipfile.ZipFile(target,'w',zipfile.ZIP_DEFLATED) as z:
 for n,b in payload.items():z.writestr(n,b)
# Flat preview of actual polygons, without simulated translucency.
im=Image.new('RGB',(1082,1442),'black');d=ImageDraw.Draw(im)
for color,rs in [(colors[6],regions[6])]+list(zip(colors[:6],regions[:6])):
 for p,h in rs:
  for q in polygons(p):
   xy=lambda ring:[((x+54.1)*10,(72.1-y)*10) for x,y in ring.coords]
   d.polygon(xy(q.exterior),fill=color)
   for ring in q.interiors:d.polygon(xy(ring),fill='black')
im.save(O/(stem+'-preview.png'))
svg=['<svg xmlns="http://www.w3.org/2000/svg" width="108.2mm" height="144.2mm" viewBox="-54.1 -72.1 108.2 144.2"><g transform="scale(1 -1)">']
for color,rs in zip(colors,regions):
 for p,h in rs:
  paths=[]
  for q in polygons(p):
   for ring in [q.exterior,*q.interiors]:paths.append('M'+' L'.join(f'{x:.4f},{y:.4f}' for x,y in ring.coords)+' Z')
  if paths:svg.append(f'<path fill="{color}" fill-rule="evenodd" data-height-mm="{h}" d="{" ".join(paths)}"/>')
svg.append('</g></svg>');(O/(stem+'-manufacturing.svg')).write_text(''.join(svg))
result=dict(project=target.name,artwork='corgi-simplified-review-v2.png',dimensions_mm=[108.2,144.2,2.5],
 colored_panes_mm=.4,cocoa_mm=.3,interior_black_mm=.7,perimeter_black_mm=2.5,perimeter_width_mm=2.6,
 parts=report,geometry_validated=True,native_saved=False,slicer_validated=False,print_started=False,
 source_settings='diagnostic-v4/03-flow.3mf',white_flow_ratio=1.0094,other_flow_ratio=.98,
 palette_change='Copper regions merged into Cocoa; six active colors, Copper unused',
 unrelated_models='Standalone panel project; all original housing and light-guide source projects unchanged',
 limitations=['Full simplified panel not yet physically validated','White flow increase not calibrated for other materials',
              'Occasional dark speck unresolved even in white-only test','Dark brown transmission remains faint'])
(O/(stem+'-validation.json')).write_text(json.dumps(result,indent=2))
print(target);print('Parts',[(p['name'],p['slot']) for p in report[0]['parts']])



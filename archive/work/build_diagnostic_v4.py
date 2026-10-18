from pathlib import Path
import sys,json,zipfile,copy,hashlib,xml.etree.ElementTree as E
R=Path(__file__).resolve().parents[1];O=R/'outputs';sys.path.insert(0,str(R/'work/pydeps'))
import numpy as np,trimesh
from shapely.geometry import Polygon,box
from shapely.ops import unary_union
from PIL import Image,ImageDraw,ImageFont
names=['Jade White','Black'];colors=['#FFFFFF','#000000'];slots=[1,7]
def polygons(p):
 return [] if p.is_empty else [p] if p.geom_type=='Polygon' else [q for a in p.geoms for q in polygons(a)]
# Broad window joins a progressively narrowing, rounded tip; separate acute triangle challenges turnarounds.
pane=unary_union([box(2,2,19,20),Polygon([(18,2),(32,10.8),(32,11.2),(18,20)])]).buffer(-.15).buffer(.15)
triangle=Polygon([(23,19),(32,19),(32,13)])
windows=unary_union([pane,triangle])
basepath=O/'corgi-junction-test-v3-02mm-ready.3mf'
source=(R/'work/build_junction_test_v2.py').read_text();export=source[source.index("ns='http"):source.index('im=Image.new')]
export=export.replace("O/'corgi-B-arachne-snug-v2-verified-H2D.3mf'","basepath").replace("opts={m.get('key'):m.get('value') for m in template.findall('metadata') if m.get('key')}","opts={}")
export=export.replace("if i==6 else", "if len(pieces)>1 else").replace("updates={'3D/3dmodel.model'","configure(cfg)\nupdates={'3D/3dmodel.model'")
export=export.replace("out.writestr(copy.copy(item),updates.get(n,base.read(n)))","out.writestr(copy.copy(item),updates.get(n,base.read(n)))")
export=export.replace("trimesh.boolean.union(pieces,engine='manifold')", "trimesh.util.concatenate(pieces)")
manifest=[];allobjs=[]
for job,variants in [('01-white-only',[('W1',{}),('W2',{})]),('02-patterns',[('A1',{}),('A2',{}),('B',{'top_surface_pattern':'monotonic'}),('C',{'infill_direction':'90'})]),('03-flow',[('F1',{}),('F2',{})])]:
 stem='corgi-diagnostic-v4-'+job;objects=[]
 for idx,(label,overrides) in enumerate(variants):
  outline=Polygon([(0,0),(34,0),(34,22),(2,22),(0,20)])
  for n in range(idx+1):outline=outline.difference(box(5+2*n,21.2,5.8+2*n,22.1))
  leading=outline.difference(windows)
  regions=[[(pane,.4),(triangle,.4)],[(leading,.7)]]
  if job=='01-white-only':regions=[regions[0]+regions[1],[]]
  obj=dict(name=label+' - '+job,regions=regions,outline=outline,xy=[120+40*(idx%2),110+28*(idx//2)],overrides=overrides,black_height=.7,notches=idx+1)
  objects.append(obj);allobjs.append((job,obj))
 def configure(cfg):
  cfg['wipe_tower_x']=['40'];cfg['wipe_tower_y']=['210'];cfg['print_settings_id']='0.10mm Standard @BBL H2D 0.2 nozzle'
 exec(export,globals())
 target=O/(stem+'-H2D.3mf')
 with zipfile.ZipFile(target) as z:payload={n:z.read(n) for n in z.namelist()}
 if job=='03-flow':
  c=json.loads(payload['Metadata/project_settings.config']);c['filament_flow_ratio'][0:2]=['1.0094','1.0094'];c['different_settings_to_system'][1]+=';filament_flow_ratio';payload['Metadata/project_settings.config']=json.dumps(c,indent=2).encode()
  f=json.loads(payload['Metadata/filament_settings_1.config']);f['filament_flow_ratio']=['1.0094','1.0094'];payload['Metadata/filament_settings_1.config']=json.dumps(f,indent=2).encode()
 with zipfile.ZipFile(target,'w',zipfile.ZIP_DEFLATED) as z:
  for k,v in payload.items():z.writestr(k,v)
 manifest.append({'job':job,'file':target.name,'objects':report,'geometry_validated':True,'native_saved':False,'slicer_validated':False,'print_started':False})
im=Image.new('RGB',(1300,1080),'#eeeeee');d=ImageDraw.Draw(im);font=ImageFont.truetype('C:/Windows/Fonts/arial.ttf',23)
d.text((25,15),'CORGI v4 | Diagnostic jobs | Both nozzles 0.2 mm | NOT PRINTED',fill='black',font=font)
for k,(job,obj) in enumerate(allobjs):
 col=k%2;row=k//2;ox=30+col*630;oy=100+row*225;s=7
 d.text((ox,oy-35),obj['name']+' | '+str(obj['notches'])+' notch(es)',fill='black',font=font)
 xy=lambda x,y:(ox+s*x,oy+s*(22-y))
 d.polygon([xy(x,y) for x,y in obj['outline'].exterior.coords],fill='white' if job=='01-white-only' else 'black',outline='#888888')
 for p in [pane,triangle]:
  d.polygon([xy(x,y) for x,y in p.exterior.coords],fill='white',outline='#bbbbbb')
 text={'W1':'White-only control','W2':'White-only repeat','A1':'Two-color control','A2':'Two-color repeat','B':'Top pattern: Monotonic','C':'Fill direction: 90 degrees','F1':'White flow +3%','F2':'White flow +3% repeat'}[obj['name'].split(' - ')[0]]
 d.text((ox+260,oy+45),text,fill='black',font=font)
d.text((25,1020),'White panes 0.4 mm (4 layers); leading 0.7 mm. Separate jobs preserve contamination control.',fill='black',font=font)
im.save(O/'corgi-diagnostic-v4-guide.png');(O/'corgi-diagnostic-v4-validation.json').write_text(json.dumps(manifest,indent=2))
print('Generated three projects; eight coupons. No printing.')



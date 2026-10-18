from pathlib import Path
import json,zipfile,copy,hashlib,sys
R=Path(__file__).resolve().parents[1]; O=R/'outputs'
sys.path.insert(0,str(R/'work/pydeps'))
from PIL import Image,ImageDraw,ImageFont
# Re-run only in memory for guide geometry, suppressing exporter write.
src=(R/'work/build_junction_test_v3.py').read_text()
src=src.replace("exec(code,dict(__file__=str(R/'work/build_junction_test_v2.py'),simple=simple,configure_02=configure_02))", "state=dict(__file__=str(R/'work/build_junction_test_v2.py'),simple=simple,configure_02=configure_02);exec(code.split('target=O/')[0],state)")
env={'__file__':str(R/'work/build_junction_test_v3.py')};exec(src,env);state=env['state']
p=O/'corgi-junction-test-v3-02mm-H2D.3mf'
with zipfile.ZipFile(p) as z: payload={i.filename:z.read(i.filename) for i in z.infolist()}
c=json.loads(payload['Metadata/project_settings.config'])
profiles=Path('C:/Program Files/Bambu Studio/resources/profiles/BBL/filament')
def resolve(name):
 v=json.loads((profiles/(name+'.json')).read_text());r=resolve(v['inherits']) if v.get('inherits') else {}
 for inc in v.get('include',[]):r.update(resolve(inc))
 r.update(v);return r
kinds=['Basic','Basic','Silk+','Silk+','Basic','Basic','Basic','Metal']
ps=[resolve(f'Bambu PLA {kind} @BBL H2D 0.2 nozzle') for kind in kinds]
for k,old in list(c.items()):
 if not isinstance(old,list) or len(old) not in (8,16) or not all(k in pr for pr in ps):continue
 # Only material profile keys; preserve actual spool colors, purge settings and routing.
 if k in ['filament_colour','filament_id','filament_settings_id','filament_prime_volume','filament_prime_volume_nc']:continue
 n=len(old)//8; vals=[]
 for pr in ps:
  v=pr[k];v=v if isinstance(v,list) else [v]
  vals.extend((v*n)[:n])
 c[k]=vals
c['filament_settings_id']=[f'Bambu PLA {kind} @BBL H2D 0.2 nozzle' for kind in kinds]
for k,value in [('nozzle_temperature','215'),('nozzle_temperature_initial_layer','220')]:
 n=len(c[k])//8;c[k][6*n:7*n]=[value]*n
for i in range(8):
 s=set(c['different_settings_to_system'][i+1].split(';'))
 if i==6:s.update(['nozzle_temperature','nozzle_temperature_initial_layer'])
 c['different_settings_to_system'][i+1]=';'.join(sorted(s))
payload['Metadata/project_settings.config']=json.dumps(c,indent=2).encode()
for i,kind in enumerate(kinds):
 name=f'Bambu PLA {kind} @BBL H2D 0.2 nozzle'
 f={'from':'project','inherits':name,'name':name+' - junction v3','filament_settings_id':[name+' - junction v3'],'filament_prime_volume':['45'],'filament_prime_volume_nc':['90']}
 if i==6:f.update(nozzle_temperature=['215','215'],nozzle_temperature_initial_layer=['220','220'],filament_retraction_length=['0.6','0.6'],filament_wipe_distance=['2','2'],filament_retract_before_wipe=['70%','70%'])
 payload[f'Metadata/filament_settings_{i+1}.config']=json.dumps(f,indent=2).encode()
target=O/'corgi-junction-test-v3-02mm-ready.3mf'
with zipfile.ZipFile(target,'w',zipfile.ZIP_DEFLATED) as z:
 for k,v in payload.items():z.writestr(k,v)
im=Image.new('RGB',(1500,1050),'#f1f2f4');d=ImageDraw.Draw(im)
font=ImageFont.truetype('C:/Windows/Fonts/arial.ttf',25);small=ImageFont.truetype('C:/Windows/Fonts/arial.ttf',20)
d.text((30,15),'CORGI v3 | BOTH nozzles 0.2 mm | NOT PRINTED',fill='black',font=font)
for idx,obj in enumerate(state['objects']):
 ox,oy,s,h=(30,110+idx*245,9,20) if idx<3 else (920,110,10,32)
 xy=lambda a,b:(ox+s*a,oy+s*(h-b))
 d.text((ox,oy-40),obj['name'],fill='black',font=small)
 d.polygon([xy(a,b) for a,b in obj['outline'].exterior.coords],fill='black')
 for n in range(idx+1 if idx<3 else 0):d.rectangle([xy(5+2*n,20),xy(5.8+2*n,19.2)],fill='#f1f2f4')
 for rs,col in list(zip(obj['regions'][:6],state['colors'][:6])):
  for p,z in rs:
   for q in state['polygons'](p):
    d.polygon([xy(a,b) for a,b in q.exterior.coords],fill=col)
    for ring in q.interiors:d.polygon([xy(a,b) for a,b in ring.coords],fill='black')
 if idx<3:d.text((ox,oy+185),f'{idx+1} notch(es) | Eye                    Muzzle                    Chest',fill='black',font=small)
 else:
  for row,y in enumerate([26,16,6]):
   for col,x in enumerate([7,19,31,43]):d.text(xy(x-1,y+1),str(1+row*4+col),fill='white' if col<2 else 'black',font=small)
  d.text((920,460),'Columns: Cocoa | Copper | Gold | Champagne\nRows: 0.3 / 0.4 / 0.6 mm\nNumbers shown only on this guide.\nClipped corner at upper left.\nAll panes start on the bed.\nNo backing or unsupported recessed panes.',fill='black',font=small,spacing=12)
d.text((30,900),'Detail colors: 0.8 mm. Black: A/B 1.0 mm; C 1.1 mm. Frames: 1.6 mm.\n0.1 mm first and subsequent layers. Thin swatches: 3 / 4 / 6 layers.\nArachne, 100% infill, no ironing. Compare A to B for geometry, B to C for raised leading.',fill='black',font=small,spacing=10)
im.save(O/'corgi-junction-test-v3-guide.png')
report={'geometry_validated':True,'native_final_verified':False,'slicer_validated':False,'print_started':False,'parts':state['report'],'modeled_gap_area_mm2':0,'modeled_overlap_area_mm2':0,'grid_columns':['Cocoa','Copper','Gold','Champagne'],'grid_thickness_rows_mm':[.3,.4,.6],'source_render': 'corgi-simplified-review-v2.png'}
(O/'corgi-junction-test-v3-validation.json').write_text(json.dumps(report,indent=2))
print(target)

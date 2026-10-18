from pathlib import Path
import sys,json,zipfile,re,hashlib,xml.etree.ElementTree as E
sys.path.insert(0,str(Path(__file__).parent/'pydeps'))
import numpy as np,trimesh
from PIL import Image,ImageDraw
R=Path(__file__).resolve().parents[1];O=R/'outputs';stem='corgi-junction-test-v2'
ready=O/(stem+'-verified-H2D.3mf');sliced=O/(stem+'-verified-sliced.gcode.3mf')
rp=O/(stem+'-validation.json');report=json.loads(rp.read_text())
ns='http://schemas.microsoft.com/3dmanufacturing/core/2015/02';pn='http://schemas.microsoft.com/3dmanufacturing/production/2015/06'
with zipfile.ZipFile(ready) as z:
 c=json.loads(z.read('Metadata/project_settings.config'));root=E.fromstring(z.read('3D/3dmodel.model'));settings=E.fromstring(z.read('Metadata/model_settings.config'))
 assert c['inherits_group'][3:5]==['Bambu PLA Silk+ @BBL H2D']*2 and c['inherits_group'][8]=='Bambu PLA Metal @BBL H2D'
 def matrix(txt):
  a=np.eye(4)
  if txt:a[:,:3]=np.array(list(map(float,txt.split()))).reshape(4,3)
  return a
 def flatten(file,oid,parent):
  model=root if file=='3D/3dmodel.model' else E.fromstring(z.read(file));ob=model.find(f'{{{ns}}}resources/{{{ns}}}object[@id="{oid}"]');mesh=ob.find(f'{{{ns}}}mesh')
  if mesh is not None:
   vv=np.array([[float(v.get(k)) for k in ['x','y','z']] for v in mesh.find(f'{{{ns}}}vertices')]);ff=np.array([[int(f.get(k)) for k in ['v1','v2','v3']] for f in mesh.find(f'{{{ns}}}triangles')]);vv=(np.c_[vv,np.ones(len(vv))]@parent)[:,:3]
   m=trimesh.Trimesh(vv,ff,process=True);assert m.is_watertight and m.is_winding_consistent and m.volume>0
   return [m]
  result=[]
  for child in ob.find(f'{{{ns}}}components'):result+=flatten(child.get(f'{{{pn}}}path',file).lstrip('/'),child.get('objectid'),matrix(child.get('transform'))@parent)
  return result
 assert len(settings.findall('object'))==5 and len(settings.findall('plate'))==1
 for obj in settings.findall('object'):
  cfg={m.get('key'):m.get('value').split(',')[0] for m in obj.findall('metadata') if m.get('key')};letter=cfg['name'][0]
  for k,v in {'wall_generator':'arachne','seam_gap':'0%','ironing_type':'no ironing','layer_height':'0.1','sparse_infill_density':'100%','reduce_infill_retraction_mode':'Disabled'}.items():assert cfg[k]==v,(letter,k)
  if letter=='B':
   for k in ['outer_wall_speed','inner_wall_speed','internal_solid_infill_speed','top_surface_speed']:assert cfg[k]=='35'
   assert cfg['default_acceleration']=='1000'
  assert cfg['infill_wall_overlap']==('25%' if letter=='C' else '20%')
  item=root.find(f'{{{ns}}}build/{{{ns}}}item[@objectid="{obj.get("id")}"]');meshes=flatten('3D/3dmodel.model',obj.get('id'),matrix(item.get('transform')))
  assert len(meshes)==(3 if letter=='E' else 7)
  vv=np.vstack([m.vertices for m in meshes]);size=vv.max(0)-vv.min(0);assert np.allclose(size,[26,32,1.6] if letter=='E' else [86,20,1.6],atol=1e-4)
  assert [p.find('metadata[@key="extruder"]').get('value') for p in obj.findall('part')]==(['6','8','7'] if letter=='E' else ['1','2','3','4','6','8','7'])
  if letter!='E':
   assert all(np.isclose(m.bounds[1,2],.8,atol=1e-5) for m in meshes[:6])
   x,y=report['variants'][ord(letter)-65]['origin_mm'];centers=meshes[-1].triangles_center
   inside=np.zeros(len(centers),dtype=bool)
   for j in range(3):inside|=(centers[:,0]>x+2.2+28*j)&(centers[:,0]<x+27.8+28*j)&(centers[:,1]>y+2.2)&(centers[:,1]<y+17.8)
   assert np.isclose(centers[inside,2].max(),.8 if letter=='D' else 1.,atol=1e-5)
  else:
   for col,m in enumerate(meshes[:2]):
    for yy,h in [(142,.4),(132,.6),(122,.8)]:
     cc=m.triangles_center;xx=222+12*col;sel=cc[(cc[:,0]>xx+.1)&(cc[:,0]<xx+9.9)&(cc[:,1]>yy+.1)&(cc[:,1]<yy+7.9)]
     assert np.isclose(sel[:,2].max(),h,atol=1e-5)
 plate=json.loads(z.read('Metadata/plate_1.json'));bb=plate['bbox_all'];assert 25<=bb[0]<bb[2]<=325 and 0<=bb[1]<bb[3]<=320
 boxes=[o['bbox'] for o in plate['bbox_objects']]
 for i,a in enumerate(boxes):
  for b in boxes[:i]:assert min(a[2],b[2])<=max(a[0],b[0]) or min(a[3],b[3])<=max(a[1],b[1])
with zipfile.ZipFile(sliced) as z:
 g=z.read('Metadata/plate_1.gcode').decode();info=E.fromstring(z.read('Metadata/slice_info.config')).find('plate')
 def setting(k):return re.search(r'^; '+re.escape(k)+r' = (.*)$',g,re.M).group(1)
 for k,v in {'nozzle_temperature':'220,220,230,230,220,220,215,220','filament_map':'2,2,2,2,1,1,1,1','filament_retraction_length':'0.4,0.4,0.4,0.4,0.4,0.4,0.6,0.4','filament_wipe_distance':'1,1,1,1,1,1,2,1','flush_into_infill':'0','flush_into_objects':'0','filament_prime_volume':','.join(['45']*8),'filament_prime_volume_nc':','.join(['90']*8)}.items():assert setting(k)==v,k
 layers=[float(v) for v in re.findall(r'^; Z_HEIGHT: ([0-9.]+)',g,re.M)];assert layers==[round(.2+.1*i,1) for i in range(15)] and '; FEATURE: Ironing' not in g
 assert len(info.findall('object'))==5 and all(o.get('skipped')=='false' for o in info.findall('object'))
 assert info.find('metadata[@key="outside"]').get('value')=='false'
 seconds=int(info.find('metadata[@key="prediction"]').get('value'));assert seconds<10200
 assert {f.get('id') for f in info.findall('filament')}=={'1','2','3','4','6','7','8'}
# Render actual deposition paths at nominal line width. Physical pinholes still require testing.
ids={int(o.get('identify_id')):o.get('name')[0] for o in info.findall('object')};segments=[];x=y=zpos=layerz=0.;width=.42;tool=6;oid=None;relative=True;eabs=0.;feed=0.;accel=0.
for line in g.splitlines():
 if line.startswith('; Z_HEIGHT: '):layerz=float(line.split(':')[1])
 if line.startswith('; LINE_WIDTH: '):width=float(line.split(':')[1])
 if line.startswith('; start printing object, unique label id: '):oid=int(line.rsplit(':',1)[1])
 if line.startswith('; stop printing object'):oid=None
 if re.match(r'^T\d+',line):tool=int(re.match(r'^T(\d+)',line)[1])
 if line.startswith('M204 S'):accel=float(line.split('S')[1].split()[0])
 if line.startswith('M82'):relative=False
 if line.startswith('M83'):relative=True
 if line.startswith('G92 E'):eabs=float(line.split('E')[1].split()[0])
 if not re.match(r'^G[0123] ',line):continue
 vals={k:float(v) for k,v in re.findall(r'([XYZEF])(-?\d*\.?\d+)',line.split(';')[0])};nx=vals.get('X',x);ny=vals.get('Y',y);nz=vals.get('Z',zpos);feed=vals.get('F',feed)
 e=vals.get('E',0) if relative else vals.get('E',eabs)-eabs
 if not relative:eabs=vals.get('E',eabs)
 if oid in ids and e>0 and ('X' in vals or 'Y' in vals) and abs(nz-layerz)<1e-5 and (nx-x)**2+(ny-y)**2>1e-8:
  assert not line.startswith(('G2 ','G3 '));segments.append((ids[oid],layerz,tool,x,y,nx,ny,width,feed/60,accel))
 x,y,zpos=nx,ny,nz
assert len(segments)>10000
bseg=[s for s in segments if s[0]=='B' and s[1]>.2];assert max(s[8] for s in bseg)<=35.01
report['slow_variant_acceleration_segment_counts']={str(a):sum(s[9]==a for s in bseg) for a in sorted({s[9] for s in bseg})}
report['motion_test_limit']='35 mm/s deposition cap verified above the first layer. First-layer speeds remain shared defaults; some paths retain higher acceleration despite object overrides. Interpret B as a speed comparison, not a uniform acceleration comparison.'
colors={0:'#FFFFFF',1:'#0086D6',2:'#F4A925',3:'#F3CFB2',5:'#6F5034',6:'#000000',7:'#AA6443'}
im=Image.new('RGB',(1740,1740),'#ff66bb');d=ImageDraw.Draw(im);scale=20
for letter,zz,t,x1,y1,x2,y2,w,f,a in segments:
 if letter=='E':continue
 yoff={'A':152,'B':128,'C':104,'D':80}[letter];row=ord(letter)-65
 pts=[((xx-119.5)*scale,(20.5-(yy-yoff))*scale+row*430) for xx,yy in [(x1,y1),(x2,y2)]];ww=max(1,round(w*scale));r=ww/2
 d.line(pts,fill=colors[t],width=ww)
 for xx,yy in pts:d.ellipse((xx-r,yy-r,xx+r,yy+r),fill=colors[t])
im.save(O/(stem+'-toolpath-preview.png'))
report.update(slicer_validated=True,native_project=ready.name,sliced_plate=sliced.name,estimated_time_seconds=seconds,estimated_filament_g=float(info.find('metadata[@key="weight"]').get('value')),actual_layer_heights_mm=layers,plate_bounds_mm=bb,native_sha256=hashlib.sha256(ready.read_bytes()).hexdigest(),sliced_sha256=hashlib.sha256(sliced.read_bytes()).hexdigest(),extrusion_segments_checked=len(segments),slow_variant_max_deposition_speed_mm_s=max(s[8] for s in bseg),preview_limit='Nominal deposited line widths, not a physical pinhole guarantee.')
rp.write_text(json.dumps(report,indent=2));print(json.dumps({k:report[k] for k in ['slicer_validated','estimated_time_seconds','estimated_filament_g','extrusion_segments_checked','slow_variant_max_deposition_speed_mm_s']}))

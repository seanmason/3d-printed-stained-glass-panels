from pathlib import Path
import sys,json,zipfile,re,hashlib,xml.etree.ElementTree as E,math
R=Path(__file__).resolve().parents[1];O=R/'outputs';sys.path.insert(0,str(R/'work/pydeps'))
import numpy as np,trimesh
from PIL import Image,ImageDraw
ns='http://schemas.microsoft.com/3dmanufacturing/core/2015/02';pn='http://schemas.microsoft.com/3dmanufacturing/production/2015/06'
manifest=json.loads((O/'corgi-diagnostic-v4-validation.json').read_text());summary=[]
for record in manifest:
 job=record['job'];p=O/record['file'];z=zipfile.ZipFile(p);c=json.loads(z.read('Metadata/project_settings.config'));settings=E.fromstring(z.read('Metadata/model_settings.config'));root=E.fromstring(z.read('3D/3dmodel.model'))
 assert c['nozzle_diameter']==['0.2','0.2'];assert c['layer_height']==c['initial_layer_print_height']=='0.1';assert c['wall_generator']=='arachne';assert c['ironing_type']=='no ironing';assert c['sparse_infill_density']=='100%'
 def mat(t):
  a=np.eye(4)
  if t:a[:,:3]=np.array(list(map(float,t.split()))).reshape(4,3)
  return a
 def flatten(file,oid,parent):
  r=E.fromstring(z.read(file));ob=r.find(f'{{{ns}}}resources/{{{ns}}}object[@id="{oid}"]');mesh=ob.find(f'{{{ns}}}mesh')
  if mesh is None:return [m for ch in ob.find(f'{{{ns}}}components') for m in flatten(ch.get(f'{{{pn}}}path',file).lstrip('/'),ch.get('objectid'),mat(ch.get('transform'))@parent)]
  vv=np.array([[float(v.get(k)) for k in ['x','y','z']] for v in mesh.find(f'{{{ns}}}vertices')]);ff=np.array([[int(f.get(k)) for k in ['v1','v2','v3']] for f in mesh.find(f'{{{ns}}}triangles')]);vv=(np.c_[vv,np.ones(len(vv))]@parent)[:,:3];m=trimesh.Trimesh(vv,ff,process=False);assert m.is_watertight and m.is_winding_consistent and m.volume>0;return [m]
 bounds=[]
 for item in root.find(f'{{{ns}}}build'):
  mm=flatten('3D/3dmodel.model',item.get('objectid'),mat(item.get('transform')));v=np.vstack([m.vertices for m in mm]);b=np.array([v.min(0),v.max(0)]);assert np.allclose(b[1]-b[0],[34,22,.7]);assert set(np.round(v[:,2],3))=={0,.4,.7};bounds.append(b.tolist())
 assert len(bounds)==(4 if job=='02-patterns' else 2)
 for idx,a in enumerate(bounds):
  assert 25<a[0][0]<a[1][0]<325 and 0<a[0][1]<a[1][1]<320
  for b in bounds[:idx]:assert any(a[1][k]<=b[0][k] or b[1][k]<=a[0][k] for k in [0,1])
 opts=[{m.get('key'):m.get('value') for m in ob.findall('metadata')} for ob in settings.findall('object')]
 if job=='02-patterns':assert opts[2]['top_surface_pattern']=='monotonic' and opts[3]['infill_direction']=='90'
 gp=O/('corgi-diagnostic-v4-'+job+'.gcode');g=gp.read_text();get=lambda k:re.search(r'^; '+re.escape(k)+r' = (.*)$',g,re.M).group(1)
 assert get('nozzle_diameter')=='0.2,0.2';assert get('filament_map')=='2,2,2,2,1,1,1,1';assert float(get('filament_flow_ratio').split(',')[0])==(1.0094 if job=='03-flow' else .98)
 assert '; FEATURE: Ironing' not in g
 assert [float(v) for v in re.findall(r'^; Z_HEIGHT: (.*)',g,re.M)]==[.1,.2,.3,.4,.5,.6,.7]
 labels=list(map(int,re.search(r'^; model label id: (.*)',g,re.M)[1].split(',')));assert len(labels)==len(bounds)
 seg=[];x=y=zz=layer=0.;tool=0;oid=None;feature='';width=.22
 for line in g.splitlines():
  if line.startswith('; Z_HEIGHT:'):layer=float(line.split(':')[1])
  if line.startswith('; FEATURE:'):feature=line.split(':',1)[1].strip()
  if line.startswith('; LINE_WIDTH:'):width=float(line.split(':')[1])
  if line.startswith('; start printing object, unique label id:'):oid=int(line.rsplit(':',1)[1])
  if line.startswith('; stop printing object'):oid=None
  if re.match(r'^T\d+',line):tool=int(re.match(r'^T(\d+)',line)[1])
  if not re.match(r'^G[01] ',line):continue
  val={k:float(v) for k,v in re.findall(r'([XYZEF])(-?\d*\.?\d+)',line.split(';')[0])};nx=val.get('X',x);ny=val.get('Y',y);nz=val.get('Z',zz)
  if oid in labels and val.get('E',0)>0 and math.hypot(nx-x,ny-y)>.001 and abs(nz-layer)<1e-5:seg.append((labels.index(oid),layer,tool,x,y,nx,ny,width,feature,val['E']))
  x,y,zz=nx,ny,nz
 assert len(seg)>1000
 for idx,b in enumerate(bounds):
  h={s[1] for s in seg if s[0]==idx and b[0][0]+5<(s[3]+s[5])/2<b[0][0]+15 and b[0][1]+5<(s[4]+s[6])/2<b[0][1]+17};assert h=={.1,.2,.3,.4},h
 assert {s[2] for s in seg}==({0} if job=='01-white-only' else {0,6})
 angles={}
 for idx in range(len(bounds)):
  angles[str(idx)]=sorted({round(math.degrees(math.atan2(s[6]-s[4],s[5]-s[3]))%180) for s in seg if s[0]==idx and s[1]==.4 and s[2]==0 and s[8]=='Top surface' and math.hypot(s[5]-s[3],s[6]-s[4])>3})
 if job=='02-patterns':assert angles['0']!=angles['3'],angles
 record.update(native_saved=True,slicer_validated=True,print_started=False,native_sha256=hashlib.sha256(p.read_bytes()).hexdigest(),gcode_sha256=hashlib.sha256(gp.read_bytes()).hexdigest(),estimate=re.search(r'total estimated time: (.*)',g)[1],bounds_mm=bounds,segments_checked=len(seg),top_fill_angles_degrees=angles)
 summary.append((job,record['estimate'],len(seg),angles))
 im=Image.new('RGB',(2220,1530 if len(bounds)>2 else 780),'#ff55bb');d=ImageDraw.Draw(im)
 for s in seg:
  idx,layer,t,x,y,nx,ny,w,feat,e=s
  if layer!=.4:continue
  bx,by=bounds[idx][0][:2];ox=30+(idx%2)*1110;oy=30+(idx//2)*750;pts=[(ox+(a-bx)*30,oy+(22-(b-by))*30) for a,b in [(x,y),(nx,ny)]];d.line(pts,fill='white' if t==0 else 'black',width=max(1,round(w*30)))
 im.save(O/('corgi-diagnostic-v4-'+job+'-toolpaths.png'))
(O/'corgi-diagnostic-v4-validation.json').write_text(json.dumps(manifest,indent=2));print(summary)

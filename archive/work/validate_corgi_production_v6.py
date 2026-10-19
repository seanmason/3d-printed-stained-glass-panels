from pathlib import Path
import sys,json,zipfile,re,hashlib,xml.etree.ElementTree as E,math
R=Path(__file__).resolve().parents[1];O=R/'outputs';sys.path.insert(0,str(R/'work/pydeps'))
import numpy as np,trimesh
from PIL import Image,ImageDraw
stem='corgi-production-v6-02mm'
p=O/(stem+'-H2D.3mf');z=zipfile.ZipFile(p);c=json.loads(z.read('Metadata/project_settings.config'))
ns='http://schemas.microsoft.com/3dmanufacturing/core/2015/02';pn='http://schemas.microsoft.com/3dmanufacturing/production/2015/06'
assert c['nozzle_diameter']==['0.2','0.2']
assert c['layer_height']==c['initial_layer_print_height']=='0.1'
assert c['wall_generator']=='arachne' and c['ironing_type']=='no ironing'
assert c['sparse_infill_density']=='100%' and c['infill_wall_overlap']=='20%' and c['seam_gap']=='0%'
assert c['filament_flow_ratio']==['1.0094']*2+['0.98']*14
assert c['filament_map']==['2']*4+['1']*4
assert c['reduce_crossing_wall']=='1' and c['reduce_infill_retraction_mode']=='Disabled'
assert c['filament_retraction_length'][12:14]==['0.6']*2
assert c['filament_wipe_distance'][12:14]==['2']*2
assert c['nozzle_temperature'][12:14]==['215']*2
settings=E.fromstring(z.read('Metadata/model_settings.config'))
assert [a.find('metadata[@key="extruder"]').get('value') for a in settings.findall('object/part')]==['1','2','3','4','6','7']
assert 'Metadata/plate_1.png' in z.namelist(), 'Native save thumbnail required'
def mat(t):
 a=np.eye(4)
 if t:a[:,:3]=np.array(list(map(float,t.split()))).reshape(4,3)
 return a
def flatten(file,oid,parent):
 r=E.fromstring(z.read(file));ob=r.find(f'{{{ns}}}resources/{{{ns}}}object[@id="{oid}"]');mesh=ob.find(f'{{{ns}}}mesh')
 if mesh is None:return [m for ch in ob.find(f'{{{ns}}}components') for m in flatten(ch.get(f'{{{pn}}}path',file).lstrip('/'),ch.get('objectid'),mat(ch.get('transform'))@parent)]
 vv=np.array([[float(v.get(k)) for k in ['x','y','z']] for v in mesh.find(f'{{{ns}}}vertices')]);ff=np.array([[int(f.get(k)) for k in ['v1','v2','v3']] for f in mesh.find(f'{{{ns}}}triangles')]);vv=(np.c_[vv,np.ones(len(vv))]@parent)[:,:3];m=trimesh.Trimesh(vv,ff,process=False);assert m.is_watertight and m.is_winding_consistent and m.volume>0;return [m]
root=E.fromstring(z.read('3D/3dmodel.model'));items=list(root.find(f'{{{ns}}}build'));assert len(items)==1
mm=flatten('3D/3dmodel.model',items[0].get('objectid'),mat(items[0].get('transform')))
v=np.vstack([m.vertices for m in mm]);b=np.array([v.min(0),v.max(0)]);assert np.allclose(b[1]-b[0],[108.2,144.2,2.5])
assert [round(m.bounds[1,2],3) for m in mm]==[.4,.4,.4,.4,.3,2.5]
assert set(np.round(mm[-1].vertices[:,2],3))=={0,.7,2.5}
g=(O/(stem+'.gcode')).read_text();get=lambda k:re.search(r'^; '+re.escape(k)+r' = (.*)$',g,re.M).group(1)
assert get('nozzle_diameter')=='0.2,0.2' and get('filament_map')=='2,2,2,2,1,1,1,1'
assert get('filament_flow_ratio')=='1.0094,'+','.join(['0.98']*7)
assert '; FEATURE: Ironing' not in g
assert [float(q) for q in re.findall(r'^; Z_HEIGHT: (.*)',g,re.M)]==[round(i/10,1) for i in range(1,26)]
seg=[];x=y=zz=layer=0.;tool=0;width=.22;feature='Custom';tower=[]
for line in g.splitlines():
 if line.startswith('; Z_HEIGHT:'):layer=float(line.split(':')[1])
 if line.startswith('; LINE_WIDTH:'):width=float(line.split(':')[1])
 if line.startswith('; FEATURE:'):feature=line.split(':',1)[1].strip()
 if re.match(r'^T\d+',line):tool=int(re.match(r'^T(\d+)',line)[1])
 if not re.match(r'^G[01] ',line):continue
 val={k:float(v) for k,v in re.findall(r'([XYZEF])(-?\d*\.?\d+)',line.split(';')[0])};nx=val.get('X',x);ny=val.get('Y',y);nz=val.get('Z',zz)
 if layer>0 and feature!='Custom' and val.get('E',0)>0 and math.hypot(nx-x,ny-y)>.001 and abs(nz-layer)<1e-5:
  if feature=='Prime tower':tower.append((x,y,nx,ny))
  else:seg.append((layer,tool,x,y,nx,ny,width))
 x,y,zz=nx,ny,nz
assert len(seg)>10000
assert {s[1] for s in seg}=={0,1,2,3,5,6}
tv=np.array(tower).reshape(-1,2);tb=np.array([tv.min(0),tv.max(0)])
assert 0<tb[0,0]<tb[1,0]<325 and 0<tb[0,1]<tb[1,1]<320
assert tb[1,0]<b[0,0] or tb[0,0]>b[1,0] or tb[1,1]<b[0,1] or tb[0,1]>b[1,1]
tops={str(t):max(s[0] for s in seg if s[1]==t) for t in [0,1,2,3,5,6]};assert list(tops.values())==[.4,.4,.4,.4,.3,2.5]
for s in seg:
 for x,y in [(s[2],s[3]),(s[4],s[5])]:assert b[0,0]-.3<=x<=b[1,0]+.3 and b[0,1]-.3<=y<=b[1,1]+.3
im=Image.new('RGB',(1082,1442),'#ff55bb');d=ImageDraw.Draw(im);palette={0:'white',1:'#0086D6',2:'#F4A925',3:'#F3CFB2',5:'#6F5034',6:'black'}
for s in sorted(seg,key=lambda a:(a[0],a[1]!=6)):
 h,t,x,y,nx,ny,w=s
 if h!=({5:.3,6:.7}.get(t,.4)):continue
 xy=lambda a,b:((a-120.9)*10,(222.1-b)*10)
 d.line([xy(x,y),xy(nx,ny)],fill=palette[t],width=max(1,round(w*10)))
im.save(O/(stem+'-toolpaths.png'))
record=json.loads((O/(stem+'-validation.json')).read_text());record.update(native_saved=True,slicer_validated=True,bounds_mm=b.tolist(),prime_tower_bounds_mm=tb.tolist(),segments_checked=len(seg),tool_top_heights=tops,estimate=re.search(r'total estimated time: (.*)',g)[1],native_sha256=hashlib.sha256(p.read_bytes()).hexdigest(),gcode_sha256=hashlib.sha256((O/(stem+'.gcode')).read_bytes()).hexdigest())
(O/(stem+'-validation.json')).write_text(json.dumps(record,indent=2));print(json.dumps({k:record[k] for k in ['bounds_mm','segments_checked','tool_top_heights','estimate']},indent=2))

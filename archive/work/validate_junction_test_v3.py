from pathlib import Path
import sys,json,zipfile,hashlib,xml.etree.ElementTree as E
R=Path(__file__).resolve().parents[1];O=R/'outputs';sys.path.insert(0,str(R/'work/pydeps'))
import numpy as np,trimesh
p=O/'corgi-junction-test-v3-02mm-ready.3mf';z=zipfile.ZipFile(p);c=json.loads(z.read('Metadata/project_settings.config'))
assert c['nozzle_diameter']==['0.2','0.2']
for k,v in {'layer_height':'0.1','initial_layer_print_height':'0.1','wall_generator':'arachne','ironing_type':'no ironing','sparse_infill_density':'100%','seam_gap':'0%'}.items():assert c[k]==v,(k,c[k])
for i,kind in [(3,'Silk+'),(4,'Silk+'),(8,'Metal')]:assert json.loads(z.read(f'Metadata/filament_settings_{i}.config'))['inherits']==f'Bambu PLA {kind} @BBL H2D 0.2 nozzle'
assert c['filament_map']==['2','2','2','2','1','1','1','1']
ns='http://schemas.microsoft.com/3dmanufacturing/core/2015/02';pn='http://schemas.microsoft.com/3dmanufacturing/production/2015/06'
root=E.fromstring(z.read('3D/3dmodel.model'));settings=E.fromstring(z.read('Metadata/model_settings.config'))
def mat(t):
 a=np.eye(4)
 if t:a[:,:3]=np.array(list(map(float,t.split()))).reshape(4,3)
 return a
def flatten(file,oid,parent):
 r=E.fromstring(z.read(file));o=r.find(f'{{{ns}}}resources/{{{ns}}}object[@id="{oid}"]');mesh=o.find(f'{{{ns}}}mesh')
 if mesh is None:
  return [m for ch in o.find(f'{{{ns}}}components') for m in flatten(ch.get(f'{{{pn}}}path',file).lstrip('/'),ch.get('objectid'),mat(ch.get('transform'))@parent)]
 vv=np.array([[float(v.get(k)) for k in ['x','y','z']] for v in mesh.find(f'{{{ns}}}vertices')]);ff=np.array([[int(f.get(k)) for k in ['v1','v2','v3']] for f in mesh.find(f'{{{ns}}}triangles')]);vv=(np.c_[vv,np.ones(len(vv))]@parent)[:,:3]
 m=trimesh.Trimesh(vv,ff,process=True);assert m.is_watertight and m.is_winding_consistent and m.volume>0
 return [m]
objects=[]
for idx,item in enumerate(root.find(f'{{{ns}}}build')):
 meshes=flatten('3D/3dmodel.model',item.get('objectid'),mat(item.get('transform')))
 verts=np.vstack([m.vertices for m in meshes]);bounds=[verts.min(0).tolist(),verts.max(0).tolist()]
 assert np.allclose(verts.max(0)-verts.min(0),[86,20,1.6] if idx<3 else [50,32,1.6])
 if idx<3:
  assert all(np.isclose(m.bounds[1,2],.8) for m in meshes[:-1])
  levels=np.unique(np.round(meshes[-1].vertices[:,2],3));assert (1.1 if idx==2 else 1.) in levels
 else:
  for m in meshes[:-1]:assert set(np.round(m.vertices[:,2],3))=={0.,.3,.4,.6}
 objects.append({'parts':len(meshes),'bounds_mm':bounds})
assert len(objects)==4
for i,a in enumerate(objects):
 for b in objects[:i]:
  x,y=a['bounds_mm'],b['bounds_mm'];assert any(x[1][k]<=y[0][k] or y[1][k]<=x[0][k] for k in [0,1])
rp=O/'corgi-junction-test-v3-validation.json';report=json.loads(rp.read_text());report.update(native_final_verified=True,native_sha256=hashlib.sha256(p.read_bytes()).hexdigest(),native_objects=objects)
rp.write_text(json.dumps(report,indent=2));print('Native geometry, nozzle settings, material profiles, routing and thicknesses verified.')

import re
from PIL import Image,ImageDraw
sliced=O/'corgi-junction-test-v3-02mm-sliced.gcode.3mf'
with zipfile.ZipFile(sliced) as sz:
 g=sz.read('Metadata/plate_1.gcode').decode();info=E.fromstring(sz.read('Metadata/slice_info.config')).find('plate')
 def setting(k):return re.search(r'^; '+re.escape(k)+r' = (.*)$',g,re.M).group(1)
 for k,v in {'nozzle_diameter':'0.2,0.2','nozzle_temperature':'220,220,230,230,220,220,215,220','filament_map':'2,2,2,2,1,1,1,1','flush_into_infill':'0','flush_into_objects':'0'}.items():assert setting(k)==v,(k,setting(k))
 layers=[float(v) for v in re.findall(r'^; Z_HEIGHT: ([0-9.]+)',g,re.M)];assert layers==[round(.1+.1*i,1) for i in range(16)]
 assert '; FEATURE: Ironing' not in g
 assert len(info.findall('object'))==4 and all(o.get('skipped')=='false' for o in info.findall('object'))
 assert info.find('metadata[@key="outside"]').get('value')=='false'
 seconds=int(info.find('metadata[@key="prediction"]').get('value'))
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

# All twelve swatches must actually deposit on exactly 3/4/6 layers.
grid=[]
for row,(yy,h) in enumerate([(142,.3),(132,.4),(122,.6)]):
 for col in range(4):
  xx=222+12*col
  hits=[a for a in segments if a[0]=='D' and a[2]!=6 and xx<(a[3]+a[5])/2<xx+10 and yy<(a[4]+a[6])/2<yy+8]
  zs=sorted({a[1] for a in hits});assert zs==[round(.1*i,1) for i in range(1,round(h*10)+1)],(row,col,zs)
  grid.append({'number':row*4+col+1,'deposition_z_mm':zs})
colors={0:'#FFFFFF',1:'#0086D6',2:'#F4A925',3:'#F3CFB2',5:'#6F5034',6:'#000000',7:'#AA6443'}
im=Image.new('RGB',(1740,1310),'#ff66bb');d=ImageDraw.Draw(im);scale=20
for letter,zz,t,x1,y1,x2,y2,w,f,a in segments:
 if letter=='D':continue
 yoff={'A':152,'B':128,'C':104,'D':80}[letter];row=ord(letter)-65
 pts=[((xx-119.5)*scale,(20.5-(yy-yoff))*scale+row*430) for xx,yy in [(x1,y1),(x2,y2)]];ww=max(1,round(w*scale));r=ww/2
 d.line(pts,fill=colors[t],width=ww)
 for xx,yy in pts:d.ellipse((xx-r,yy-r,xx+r,yy+r),fill=colors[t])
im.save(O/'corgi-junction-test-v3-toolpath-preview.png')

report.update(slicer_validated=True,print_started=False,estimated_time_seconds=seconds,estimated_filament_g=float(info.find('metadata[@key="weight"]').get('value')),actual_layer_heights_mm=layers,swatch_layers=grid,sliced_sha256=hashlib.sha256(sliced.read_bytes()).hexdigest(),extrusion_segments_checked=len(segments),preview_limit='Nominal line-width projection; physical pinholes remain to be tested. Studio viewport stale.')
rp.write_text(json.dumps(report,indent=2));print(seconds,report['estimated_filament_g'],len(segments))

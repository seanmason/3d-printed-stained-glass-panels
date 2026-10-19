"""Smooth implicit anatomy field for the continuous form study, in millimeters."""
from pathlib import Path
import sys,json
ROOT=Path(__file__).resolve().parents[4];sys.path.insert(0,str(ROOT.parent/'work/pydeps'))
import numpy as np,trimesh
from skimage.measure import marching_cubes
OUT=ROOT/'designs/sculpture-lamp/form-v5-expression';OUT.mkdir(exist_ok=True,parents=True)
step=1.0;origin=np.array([-113.,-130.,20.])
xs=np.arange(-113,114,step,dtype=np.float32);ys=np.arange(-130,119,step,dtype=np.float32);zs=np.arange(20,273,step,dtype=np.float32)
X=xs[:,None,None];Y=ys[None,:,None];Z=zs[None,None,:]
shape=(len(xs),len(ys),len(zs))

def smoothmin(a,b,k):
 h=np.maximum(k-np.abs(a-b),0)/k
 return np.minimum(a,b)-h*h*k*.25

def ell(c,r):
 q=[(v-a)/b for v,a,b in zip((X,Y,Z),c,r)]
 k0=np.sqrt(sum(a*a for a in q));k1=np.sqrt(sum((a/b)**2 for a,b in zip(q,r)))
 return k0*(k0-1)/np.maximum(k1,1e-7)

levels=np.array([(23,64,-34,77),(34,69,-39,83),(57,78,-46,95),(85,83,-54,101),(102,77,-47,92),(122,61,-30,76),(142,48,-17,58),(166,47,-23,52),(187,51,-31,53)],float)
from scipy.interpolate import PchipInterpolator
w=PchipInterpolator(levels[:,0],levels[:,1],extrapolate=False)(np.clip(Z,23,187)).astype(np.float32)
f=PchipInterpolator(levels[:,0],levels[:,2])(np.clip(Z,23,187)).astype(np.float32)
b=PchipInterpolator(levels[:,0],levels[:,3])(np.clip(Z,23,187)).astype(np.float32)
cy=(f+b)/2;rr=(b-f)/2
field=(np.sqrt((X/w)**2+((Y-cy)/rr)**2)-1)*np.minimum(w,rr)
field=np.maximum(field,np.maximum(23-Z,Z-187))
anatomy=[
 ((0,16,215),(67,54,41),12),
 ((0,-13,232),(45,29,22),12),
 ((0,-51,181),(34,40,15),9),
]
for side in [-1,1]:
 anatomy.extend([((side*40,0,195),(29,37,30),14)])
for c,r,k in anatomy:field=smoothmin(field,ell(c,r),k)
# Long tapered snout with a smooth transition into the forehead, no separate sphere bridge.
m=np.array([(-113,15,189,211),(-104,20,183,214),(-91,25,179,219),(-70,30,179,226),(-48,36,182,233),(-28,35,188,236)])
xx=np.clip(Y,m[0,0],m[-1,0]);w=PchipInterpolator(m[:,0],m[:,1])(xx).astype(np.float32)
lo=PchipInterpolator(m[:,0],m[:,2])(xx).astype(np.float32);hi=PchipInterpolator(m[:,0],m[:,3])(xx).astype(np.float32)
cz=(lo+hi)/2;hh=(hi-lo)/2
snout=(np.sqrt((X/w)**2+((Z-cz)/hh)**2)-1)*np.minimum(w,hh)
snout=np.maximum(snout,np.maximum(m[0,0]-Y,Y-m[-1,0]))
field=smoothmin(field,snout,13)
# Flat study cut at the pedestal and a closed upper bound.
field=np.maximum(field,23-Z)
verts,faces,norms,values=marching_cubes(field,0,spacing=(step,step,step),allow_degenerate=False)
verts+=origin
mesh=trimesh.Trimesh(verts,faces,process=True);mesh.fix_normals()
assert mesh.is_watertight and mesh.volume>0
mesh.export(OUT/'continuous-anatomy.stl')
(OUT/'anatomy.json').write_text(json.dumps(dict(method='Smooth implicit union of anatomical volumes and interpolated tapered muzzle/chest contours',units='mm',bounds=mesh.bounds.tolist(),watertight=mesh.is_watertight,volume_mm3=float(mesh.volume),status='Unsegmented sculptural form for visual review'),indent=2))
print('Continuous surface',len(mesh.vertices),'vertices',len(mesh.faces),'triangles')

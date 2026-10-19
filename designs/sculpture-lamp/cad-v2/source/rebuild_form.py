"""Appearance-first revision: tapered ears, broad skull, long muzzle, inset large eyes."""
from pathlib import Path
_helper=Path(__file__).with_name('build.py').read_text().split('template=np.array')[0]
exec(_helper.replace("cad-v1'","cad-v2'"))
COL.update(Gold='#D99424',Champagne='#E8C480',Cocoa='#70462C',White='#F4E5C6',Black='#121417',Iris='#59351E')
parts=[];surfaces=[]

def clip_global_x(poly,o,u,v,limit,sign):
 xy=[np.array(q) for q in poly.exterior.coords[:-1]];out=[]
 for a,b in zip(xy,xy[1:]+xy[:1]):
  da=sign*(o[0]+a[0]*u[0]+a[1]*v[0]-limit);db=sign*(o[0]+b[0]*u[0]+b[1]*v[0]-limit)
  if da>=0:out.append(a)
  if (da>=0)!=(db>=0):out.append(a+(b-a)*da/(da-db))
 return Polygon(out) if len(out)>=3 else Polygon()

def surface(points,color,label,outline=1.25):
 pts=np.array(points,float);o=pts[0];u=unit(pts[1]-o);n=unit(np.cross(pts[1]-o,pts[2]-o));v=np.cross(n,u)
 assert max(abs((pts-o)@n))<1e-6,(label,'nonplanar')
 poly=orient(Polygon(xyz2(pts,o,u,v)));inner=poly.buffer(-outline/2,join_style=2)
 if inner.is_empty or inner.area<4:color='Black'
 sid=f'S{len(surfaces)+1:03}'
 if color=='Black':
  m=ex(poly,1.2,-1.2);add(sid+'-'+label,transform_mesh(m,o,u,v,n),color,flat=ex(poly,1.2),kind='opaque facet')
 else:
  rim=poly.difference(inner);m=ex(rim,1.2,-1.2)
  add(sid+'-leading',transform_mesh(m,o,u,v,n),'Black',flat=ex(rim,1.2),kind='leading form study')
  t=.3 if color=='Cocoa' else .4
  regions=[(inner,color)]
  if label.startswith('body-4-0-') or label.startswith('body-4-11-'):
   stripe=clip_global_x(inner,o,u,v,-8,1)
   if not stripe.is_empty:stripe=clip_global_x(stripe,o,u,v,8,-1)
   if not stripe.is_empty and stripe.area>1:
    regions=[(inner.difference(stripe),color),(stripe,'White')]
  for ri,(region,pc) in enumerate(regions):
   if region.is_empty:continue
   region=region.simplify(0.00001,preserve_topology=True)
   m=ex(region,t,-t-.08);add(sid+'-'+label+f'-{ri}',transform_mesh(m,o,u,v,n),pc,flat=ex(region,t),kind='flat pane form study')
 surfaces.append(dict(id=sid,label=label,color=color,points=pts.tolist(),normal=n.tolist(),planarity_error_mm=float(max(abs((pts-o)@n)))))
 return (o,u,v,n,poly)

# Rings have deliberately uneven heights: facet edges follow cheeks and chest rather than horizontal bands.
spec=[(21,57,40,45,6),(62,69,47,54,6),(105,43,29,43,8),(140,57,39,47,6),(188,68,42,48,5),(219,53,28,36,5)]
rings=[]
for row,(z,w,front,back,cy) in enumerate(spec):
 p=[]
 for i in range(12):
  angle=2*math.pi*i/12;c=math.cos(angle);s=math.sin(angle)
  dz=0 if row==0 else ([-2,2,-5,2,-4,3,0,3,-4,2,-5,2][i] if row<3 else [0,0,-5,-2,0,2,0,2,0,-2,-5,0][i])
  p.append([w*s,cy-(front if c>=0 else back)*c,z+dz])
 rings.append(np.array(p))
eye_planes={}
for row in range(5):
 for i in range(12):
  j=(i+1)%12
  if row==3 and i in [0,11]:continue
  a,b,c,d=rings[row][i],rings[row][j],rings[row+1][j],rings[row+1][i]
  color='White' if row<3 and i in [0,1,10,11] else 'Cocoa' if i in [4,5,6,7] else 'Gold'
  if row==4 and i in [0,11]:color='Gold'
  # Mirror triangulation on left/right so the eyes have matching planar supports.
  tris=[[a,b,d],[b,c,d]] if i<6 else [[a,b,c],[a,c,d]]
  for k,tri in enumerate(tris):
   result=surface(tri,color,f'body-{row}-{i}-{k}')
   if row==4 and (i,k) in [(1,0),(10,1)]:eye_planes[1 if i==1 else -1]=result
# Faceted skull roof.
center=np.array([0,6,224.])
for i in range(12):surface([rings[-1][i],rings[-1][(i+1)%12],center],'Cocoa' if i in [3,4,5,6,7,8] else 'Gold','skull')

# Six-sided tapered muzzle uses the actual open front boundary of the head.
root=np.array([rings[3][11],rings[3][0],rings[3][1],rings[4][1],rings[4][0],rings[4][11]])
tip=np.array([[-19,-83,148],[0,-88,144],[19,-83,148],[21,-85,166],[0,-91,174],[-21,-85,166]],float)
for i in range(6):
 j=(i+1)%6
 for k,tri in enumerate([[root[i],root[j],tip[j]],[root[i],tip[j],tip[i]]]):surface(tri,'Gold' if i in [2,5] and k==0 else 'Champagne','muzzle')
tc=np.array([0,-93,158.])
for i in range(6):surface([tip[i],tip[(i+1)%6],tc],'Champagne','muzzle-front')

def applique(points,color,label,height=.6):
 pts=np.array(points);o=pts[0];u=unit(pts[1]-o);n=unit(np.cross(pts[1]-o,pts[2]-o));v=np.cross(n,u)
 poly=orient(Polygon(xyz2(pts,o,u,v)));m=ex(poly,height)
 add(label,transform_mesh(m,o,u,v,n),color,flat=ex(poly,height),kind='facial applique')

# Broad soft eye outlines, dark brown iris, distinct white catchlight.
for side,(o,u,v,n,p) in eye_planes.items():
 # Place in the upper-front part of the cheek facet using barycentric weights.
 q=np.array(p.exterior.coords)[:-1];ctr=q.mean(0)
 world=o+ctr[0]*u+ctr[1]*v
 # Eye basis uses world horizontal and vertical projected onto its own support plane.
 eu=unit(np.cross([0,0,1],n));ev=unit(np.cross(n,eu))
 if ev[2]<0:eu=-eu;ev=-ev
 # Facial landmarks are placed explicitly, rather than at arbitrary triangle centroids.
 n=unit([side*.40,-.91,.08]);eu=unit(np.cross([0,0,1],n));ev=unit(np.cross(n,eu))
 world=np.array([side*34.,-33.5,188.])
 shape=[(-12,-4),(-10,9),(-3,13),(7,11),(12,3),(10,-7),(1,-11),(-7,-9)]
 def patch(shape,center,color,label,h):
  pts=np.array([center+x*eu+y*ev for x,y in shape])
  if np.cross(pts[1]-pts[0],pts[2]-pts[0])@n<0:pts=pts[::-1]
  applique(pts,color,label,h)
 patch(shape,world-n*3,'Black',f'eye-{side}',4.3)
 iris=[(-8,-5),(-8,5),(-2,9),(6,7),(8,0),(5,-7),(-3,-8)]
 patch(iris,world+n*1.4,'Iris',f'iris-{side}',.45)
 pupil=[(-4,-3),(-4,5),(0,7),(5,3),(4,-4),(0,-5)]
 patch(pupil,world+n*1.9+eu*.7,'Black',f'pupil-{side}',.25)
 patch([(-1.3,-1.2),(1.3,-1.2),(1.3,1.2),(-1.3,1.2)],world+n*2.2+ev*3.1-eu*1.5,'White',f'catchlight-{side}',.2)

# Nose is a low poly convex cap, not a rectangular block.
nose_back=np.array([[-12,-91,167],[-8,-94,176],[8,-94,176],[12,-91,167],[6,-94,160],[-6,-94,160]],float)
nose_back[:,1]+=3
nose_front=nose_back.copy();nose_front[:,1]-=5;nose_front[:,0]*=.72
for i in range(6):
 j=(i+1)%6
 for tri in [[nose_back[i],nose_back[j],nose_front[j]],[nose_back[i],nose_front[j],nose_front[i]]]:surface(tri,'Black','nose')
nc=nose_front.mean(0)
for i in range(6):surface([nose_front[i],nose_front[(i+1)%6],nc],'Black','nose-front')

# Closed mouth and short philtrum; black leading follows the muzzle rather than an open grin.
for k,(aa,bb) in enumerate([([0,-94,160],[0,-91,153]),([0,-91,153],[-12,-87,151]),([0,-91,153],[12,-87,151])]):
 aa=np.array(aa,float);bb=np.array(bb,float);length=np.linalg.norm(bb-aa)
 m=trimesh.creation.cylinder(radius=.7,height=length,sections=6)
 m.apply_transform(trimesh.geometry.align_vectors([0,0,1],unit(bb-aa)));m.apply_translation((aa+bb)/2)
 add(f'mouth-leading-{k}',m,'Black',kind='facial leading form study')

# Tall, broad, pointed ears. Front fan is exactly planar; thickness tapers to the tip.
for side in [1,-1]:
 xz=np.array([[28,201],[59,192],[86,240],[75,282],[43,243]],float)
 front=np.array([[side*x,-9+.13*(z-225),z] for x,z in xz]);back=front+np.array([0,11,0])
 ec=np.array([side*57,-9+.13*(231-225),231.])
 for i in range(5):
  j=(i+1)%5;tri=[front[i],front[j],ec]
  if side<0:tri=tri[::-1]
  surface(tri,'Champagne' if i in [0,1,2,4] else 'Gold','inner-ear',1.6)
  quad=[front[j],front[i],back[i],back[j]]
  if side<0:quad=quad[::-1]
  for t in [[quad[0],quad[1],quad[2]],[quad[0],quad[2],quad[3]]]:surface(t,'Cocoa' if i>2 else 'Gold','ear-edge',1.4)
 bc=back.mean(0)
 for i in range(5):
  tri=[back[(i+1)%5],back[i],bc]
  if side<0:tri=tri[::-1]
  surface(tri,'Cocoa','ear-back',1.4)

# Quiet low plinth, sized to the sculpture rather than visually dominating it.
base=Polygon([(88*math.cos(t),-7+70*math.sin(t)) for t in np.linspace(0,2*math.pi,64,endpoint=False)])
add('base-form-envelope',ex(base,18),'Black',kind='base appearance envelope')
for p in parts:
 (OUT/'parts'/(p['id']+'.stl')).write_bytes(trimesh.exchange.stl.export_stl(p['mesh']))
 (OUT/'flat-parts'/(p['id']+'.stl')).write_bytes(trimesh.exchange.stl.export_stl(p['flat']))
data=[dict(id=p['id'],vertices=p['mesh'].vertices.tolist(),faces=p['mesh'].faces.tolist(),color=p['color'],expected_volume_mm3=float(p['mesh'].volume)) for p in parts]
(OUT/'fusion-body-input.json').write_text(json.dumps(data))
(OUT/'form-study.json').write_text(json.dumps(dict(surfaces=surfaces,palette=COL,part_count=len(parts),status='Appearance revision only. Pane assembly, ear intersections, base and electronics require engineering after visual review.'),indent=2))
# Reuse the deterministic software rasterizer, not generative imagery.
renderer=Path(__file__).with_name('build.py').read_text().split('def render(path,views):')[1].split('manifest=dict')[0]
exec('def render(path,views):'+renderer.replace("(-32,13,'Front three-quarter'),(-90,8,'Side'),(145,15,'Rear three-quarter')","(-25,8,'Front three-quarter'),(-90,4,'Side'),(145,10,'Rear three-quarter')").replace('2.45','2.1').replace('760-','740-').replace('Actual CAD geometry | planar panes, mitered carriers, detachable weighted base | unprinted design','Actual geometry | appearance revision, flat facets | assembly and lighting engineering pending'))
print('Generated',len(parts),'solids;',len(surfaces),'planar facets')

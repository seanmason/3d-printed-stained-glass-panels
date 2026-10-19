"""Parametric, planar Corgi sculpture CAD. Units: mm. No printer/network actions."""
from pathlib import Path
import sys,json,math,zipfile,hashlib,copy,xml.etree.ElementTree as E
R=next(p for p in Path(__file__).resolve().parents if (p/'archive-repo').is_dir());sys.path.insert(0,str(R/'work/pydeps'))
import numpy as np,trimesh
from shapely.geometry import Polygon,Point,box,MultiPoint
from shapely.ops import unary_union
from shapely.geometry.polygon import orient
from PIL import Image,ImageDraw,ImageFont
OUT=R/'archive-repo/designs/sculpture-lamp/cad-v1';OUT.mkdir(parents=True,exist_ok=True)
for d in ['parts','flat-parts','templates','print-plates']:(OUT/d).mkdir(exist_ok=True)
P=dict(base_width=190.,base_depth=175.,base_height=30.,base_y=-10.,
       carrier_depth=1.6,front_rim_width=3.2,lip_start=.6,lip_slope=1.,
       pane_clearance=.15,pane_light_thickness=.4,pane_cocoa_thickness=.3,
       joint_gap=.10,steel_diameter=150.,steel_thickness=4.,steel_clearance=.3,
       dc_jack_diameter=8.2,dc_jack_status='provisional; confirm selected panel jack dimensions',
       model_revision='cad-v1',hardware_status='envelope models; not measured purchased hardware')
COL={'White':'#FFFFFF','Gold':'#F4A925','Champagne':'#F3CFB2','Cocoa':'#6F5034','Black':'#17191C',
     'Aluminum':'#AAB5BF','Steel':'#676D76','Diffuser':'#EBF1F4'}
SLOT={'White':1,'Gold':3,'Champagne':4,'Cocoa':6,'Black':7}
faces=[];parts=[];joints=[]
def polylist(p):return [] if p.is_empty else [p] if p.geom_type=='Polygon' else [q for a in p.geoms for q in polylist(a)]
def unit(v):v=np.asarray(v,float);return v/np.linalg.norm(v)
def xyz2(p,o,u,v):return (np.asarray(p)-o)@np.array([u,v]).T
def check(m,name):
 m.merge_vertices(digits_vertex=7);m.remove_unreferenced_vertices()
 if not m.is_watertight:
  vv=m.vertices.tolist();ff=[];original=np.array(m.vertices)
  for tri in m.faces:
   boundary=[];split=False
   for a,b in zip(tri,np.roll(tri,-1)):
    aa=original[a];delta=original[b]-aa;ll=delta@delta
    t=(original-aa)@delta/ll;dist=np.linalg.norm(original-aa-t[:,None]*delta,axis=1)
    mid=np.where((t>1e-7)&(t<1-1e-7)&(dist<1e-7))[0]
    boundary.append(int(a));boundary.extend(mid[np.argsort(t[mid])].tolist());split|=len(mid)>0
   if split:
    ci=len(vv);vv.append(original[tri].mean(0).tolist())
    ff.extend([[a,b,ci] for a,b in zip(boundary,boundary[1:]+boundary[:1])])
   else:ff.append(tri.tolist())
  m=trimesh.Trimesh(vv,ff,process=True)
 if not m.is_watertight:
  cnt=np.bincount(m.edges_unique_inverse);bad=m.vertices[m.edges_unique[cnt!=2]]
  print('BAD',name,len(bad),bad[:16].tolist(),flush=True)
 assert m.is_watertight and m.is_winding_consistent and m.volume>1e-7,(name,m.is_watertight,m.is_winding_consistent,m.volume)
 return m
def ex(p,h,z=0):
 mm=[]
 for q in polylist(p):
  assert q.is_valid and q.area>1e-8
  m=trimesh.creation.extrude_polygon(orient(q),h,engine='earcut');m.apply_translation([0,0,z]);mm.append(m)
 assert mm
 return check(trimesh.util.concatenate(mm),'extrude')
def mesh_triangles_polygons(polys):
 vv=[];ff=[]
 for points in polys:
  points=np.asarray(points,float)
  if len(points)<3:continue
  o=points[0];u=unit(points[1]-o);n=unit(np.cross(points[1]-o,points[2]-o));v=np.cross(n,u)
  p=Polygon(xyz2(points,o,u,v));a,b=trimesh.creation.triangulate_polygon(p,engine='earcut')
  k=len(vv);vv.extend(o+a[:,0,None]*u+a[:,1,None]*v);ff.extend(b+k)
 return check(trimesh.Trimesh(vv,ff,process=True),'polygon solid')
def loft_ring(outer_levels,inner_levels):
 # Convex loops preserve one vertex per boundary constraint. Inner loop may have its own count.
 polys=[]
 for loops,inward in [(outer_levels,False),(inner_levels,True)]:
  for (z0,a),(z1,b) in zip(loops,loops[1:]):
   a=np.asarray(a);b=np.asarray(b);assert len(a)==len(b)
   for i in range(len(a)):
    j=(i+1)%len(a);p=np.array([[*a[i],z0],[*a[j],z0],[*b[j],z1],[*b[i],z1]])
    if inward:p=p[::-1]
    # Explicit triangles tolerate perfectly collinear ramp transitions.
    polys.extend([p[[0,1,2]],p[[0,2,3]]])
 for index,reverse in [(0,True),(-1,False)]:
  zo,oo=outer_levels[index];zi,ii=inner_levels[index];assert zo==zi
  pp=Polygon(oo,[ii]);a,b=trimesh.creation.triangulate_polygon(pp,engine='earcut')
  for t in b:
   p=np.c_[a[t],np.full(3,zo)];polys.append(p[::-1] if reverse else p)
 return mesh_triangles_polygons(polys)
def transform_mesh(m,o,u,v,n):
 m=m.copy();T=np.eye(4);T[:3,:3]=np.array([u,v,n]).T;T[:3,3]=o;m.apply_transform(T);return m
def add(name,m,color,flat=None,printable=True,kind='',notes=''):
 m=check(m,name)
 if flat is None:
  flat=m.copy();flat.apply_translation(-flat.bounds[0])
 flat=check(flat,name+' flat')
 p=dict(id=name,color=color,kind=kind,mesh=m,flat=flat,printable=printable,notes=notes)
 parts.append(p);return p
def face(points,color,label,holes=None,opaque=False):
 pts=np.asarray(points,float);o=pts[0];u=unit(pts[1]-o);n=unit(np.cross(pts[1]-o,pts[2]-o));v=np.cross(n,u)
 assert np.max(np.abs((pts-o)@n))<1e-6,(label,'nonplanar')
 q=Polygon(xyz2(pts,o,u,v),[xyz2(h,o,u,v) for h in holes or []]);assert q.is_valid
 if not q.exterior.is_ccw:
  pts=pts[::-1];return face(pts,color,label,holes,opaque)
 f=dict(id=f'F{len(faces)+1:02}',label=label,points=pts,holes=holes or [],o=o,u=u,v=v,n=n,p=q,color=color,opaque=opaque)
 faces.append(f);return f
template=np.array([[-.41421356,-1],[.41421356,-1],[1,-.41421356],[1,.41421356],[.41421356,1],[-.41421356,1],[-1,.41421356],[-1,-.41421356]])
rings=[]
for z,s,cy in [(39,.82,10),(70,1.,10),(112,.62,5),(180,.90,0),(202,.80,5)]:
 rings.append(np.c_[template*np.array([70*s,50*s])+[0,cy],np.full(8,z)])
rings.insert(3,rings[2]+.6*(rings[3]-rings[2]))
for row in range(5):
 for i in range(8):
  j=(i+1)%8;pts=np.array([rings[row][i],rings[row][j],rings[row+1][j],rings[row+1][i]])
  c='White' if i==0 and row<2 else 'Gold' if i in [0,1,2,6,7] else 'Cocoa'
  if row==2 and i==0:
   root=pts;cap=(root-root.mean(0))*.82+root.mean(0)+[0,-43,12]
   for k in range(4):face([root[k],root[(k+1)%4],cap[(k+1)%4],cap[k]],'Champagne','muzzle '+str(k))
   face(cap,'Champagne','muzzle front')
  else:face(pts,c,f'body row {row} sector {i}')
roots=[]
for side in [1,-1]:
 root=np.array([[12,-12,202],[52,-12,202],[52,18,202],[12,18,202]],float);root[:,0]*=side
 if side<0:root=root[::-1]
 top=np.array([[67,-14,250],[73,-14,250],[73,4,250],[67,4,250]],float);top[:,0]*=side
 if side<0:top=top[::-1]
 roots.append(root)
 for k in range(4):
  c='Champagne' if k==0 and side>0 or k==2 and side<0 else 'Gold' if k in [0,2] else 'Cocoa'
  face([root[k],root[(k+1)%4],top[(k+1)%4],top[k]],c,f'ear {side} wall {k}')
 face(top,'Black',f'ear {side} cap',opaque=True)
face(rings[-1],'Black','crown bridge',holes=roots,opaque=True)

# Closed nominal outer envelope, including a temporary bottom face for manifold checks.
vv=[];ff=[]
for f in faces:
 a,b=trimesh.creation.triangulate_polygon(f['p'],engine='earcut');k=len(vv)
 vv.extend(f['o']+a[:,0,None]*f['u']+a[:,1,None]*f['v']);ff.extend(b+k)
p0=Polygon(rings[0][:,:2]);a,b=trimesh.creation.triangulate_polygon(p0,engine='earcut');k=len(vv)
vv.extend(np.c_[a,np.full(len(a),39)]);ff.extend(b[:,::-1]+k)
envelope=check(trimesh.Trimesh(vv,ff,process=True),'closed design envelope')

# Build shared edge map, including inner loops of the crown bridge.
edges={}
key=lambda p:tuple(np.round(p,5))
for f in faces:
 for loop in [f['points'],*f['holes']]:
  for a,b in zip(loop,np.roll(loop,-1,axis=0)):
   k=tuple(sorted([key(a),key(b)]));edges.setdefault(k,[]).append((f,np.asarray(a),np.asarray(b)))
for k,ee in edges.items():assert len(ee) in [1,2],('nonmanifold design edge',k,len(ee))

def constraints(f):
 pts=np.array(f['p'].exterior.coords)[:-1];C=[]
 for i,a in enumerate(pts):
  b=pts[(i+1)%len(pts)];e=unit(b-a);iv=np.array([-e[1],e[0]])
  aw=f['o']+a[0]*f['u']+a[1]*f['v'];bw=f['o']+b[0]*f['u']+b[1]*f['v'];ee=edges[tuple(sorted([key(aw),key(bw)]))]
  other=next((g for g,aa,bb in ee if g is not f),None)
  if other is None:ng=np.array([0,0,-1.])
  else:ng=other['n']
  dn=f['n']-ng;aa=np.array([dn@f['u'],dn@f['v']]);sgn=1 if aa@iv>=0 else -1
  rate=sgn*(1-f['n']@ng)/max(np.linalg.norm(aa),1e-9)
  C.append((iv,float(iv@a),float(rate)))
 return C
def halfplane_poly(C,insets):
 xy=[np.array(a,float) for a in [(-1000,-1000),(1000,-1000),(1000,1000),(-1000,1000)]]
 for (n,c,r),inset in zip(C,insets):
  nxt=[];threshold=c+inset
  for a,b in zip(xy,xy[1:]+xy[:1]):
   da=n@a-threshold;db=n@b-threshold
   if da>=-1e-8:nxt.append(a)
   if (da>1e-8 and db< -1e-8) or (db>1e-8 and da< -1e-8):nxt.append(a+(b-a)*da/(da-db))
  xy=nxt
 p=orient(Polygon(xy));assert p.is_valid and p.area>1e-5
 return p
for f in faces:
 print('FACE',f['id'],f['label'],flush=True)
 C=constraints(f) if not f['holes'] else None;f['constraints']=C
 if f['opaque']:
  p=f['p'].buffer(-P['joint_gap']/2,join_style=2)
  m=ex(p,P['carrier_depth'],-P['carrier_depth'])
  add(f['id']+'-opaque',transform_mesh(m,f['o'],f['u'],f['v'],f['n']),'Black',flat=ex(p,P['carrier_depth']),kind='opaque face')
  f['aperture']=Polygon();continue
 widths=[max(P['front_rim_width'],P['carrier_depth']*max(0,r)+1.8) for n,c,r in C]
 I=halfplane_poly(C,widths);f['aperture']=I;f['widths']=widths
 outer=[];inner=[]
 for depth in [P['carrier_depth'],P['lip_start'],0.]:
  op=orient(halfplane_poly(C,[P['joint_gap']/2+depth*r for n,c,r in C]));ip=orient(I.buffer(-max(0,depth-P['lip_start']),join_style=2))
  assert op.contains(ip),('ring interference',f['id'])
  outer.append((-depth,np.array(op.exterior.coords)[:-1]));inner.append((-depth,np.array(ip.exterior.coords)[:-1]))
 m=loft_ring(outer,inner);flat=m.copy();flat.vertices[:,2]*=-1;flat.faces=flat.faces[:,::-1];flat.apply_translation([0,0,0])
 add(f['id']+'-carrier',transform_mesh(m,f['o'],f['u'],f['v'],f['n']),'Black',flat=flat,kind='mitered carrier')
 pane=I.buffer(-P['pane_clearance'],join_style=2);t=P['pane_cocoa_thickness'] if f['color']=='Cocoa' else P['pane_light_thickness']
 depth=P['lip_start']+P['pane_clearance'];m=ex(pane,t,-depth)
 add(f['id']+'-pane',transform_mesh(m,f['o'],f['u'],f['v'],f['n']),f['color'],flat=ex(pane,t),kind='flat pane')
 f['pane']=pane
 # Flat, intentionally abstract eye appliques on two head faces.
 if f['label'] in ['body row 3 sector 1','body row 3 sector 7']:
  q=np.array(f['p'].exterior.coords)[:-1];center=(q[0]+q[1]+q[2]+q[3])*.25
  eye=Polygon([center+[-6.0,0],center+[0,5],center+[6,0],center+[0,-4]])
  if not pane.contains(eye):eye=eye.intersection(pane.buffer(-1))
  m=ex(eye,.6,-depth+t+.05)
  add(f['id']+'-eye',transform_mesh(m,f['o'],f['u'],f['v'],f['n']),'Black',flat=ex(eye,.6),kind='flat eye applique',notes='bond to pane with 0.05 mm adhesive allowance')
  hi=Point(center+[1,1.4]).buffer(.9,quad_segs=6)
  m=ex(hi,.2,-depth+t+.65)
  add(f['id']+'-highlight',transform_mesh(m,f['o'],f['u'],f['v'],f['n']),'White',flat=ex(hi,.2),kind='eye highlight',notes='small optional opaque applique, print attached to handling sprue')
 if f['label']=='muzzle front':
  center=np.array(pane.centroid.coords[0])+[0,3]
  nose=Polygon([center+[-9,2],center+[0,7],center+[9,2],center+[6,-5],center+[-6,-5]])
  assert pane.contains(nose)
  m=ex(nose,.8,-depth+t+.05)
  add(f['id']+'-nose',transform_mesh(m,f['o'],f['u'],f['v'],f['n']),'Black',flat=ex(nose,.8),kind='flat nose applique',notes='bond flat applique to cream muzzle front')

# Edge alignment/backing splines; each has a constant cross-section and prints on its end.
for ek,ee in edges.items():
 if len(ee)!=2:continue
 (f,a,b),(g,_,_)=ee
 if f['holes'] or g['holes']:continue # crown uses a continuous opaque bridge; bond rim directly
 e=unit(b-a);length=min(12.,np.linalg.norm(b-a)*.36)
 if length<5:continue
 mid=(a+b)/2;u=unit(-(f['n']+g['n']));v=np.cross(e,u);pts=[]
 for h in [f,g]:
  # Locate the contact pad behind its carrier and inward of the miter.
  localmid=xyz2(mid,h['o'],h['u'],h['v']);poly=h['p'];candidate=np.array(poly.representative_point().coords[0]);di=unit(candidate-localmid)
  # Use the exact inward edge normal, not the diagonal toward centroid.
  edge2=unit(xyz2(b,h['o'],h['u'],h['v'])-xyz2(a,h['o'],h['u'],h['v']));iv=np.array([-edge2[1],edge2[0]])
  if iv@(candidate-localmid)<0:iv=-iv
  rate=next((rr for nn,cc,rr in h['constraints'] if abs(nn@localmid-cc)<1e-4),0)
  for off in [max(0,P['carrier_depth']*rate)+.5,max(0,P['carrier_depth']*rate)+1.8]:
   for dep in [P['carrier_depth']+.08,P['carrier_depth']+1.2]:
    q=mid+(h['u']*iv[0]+h['v']*iv[1])*off-h['n']*dep
    pts.append([(q-mid)@u,(q-mid)@v])
 section=MultiPoint(pts).convex_hull
 if section.area<.5:continue
 m=ex(section,length,-length/2);assembled=transform_mesh(m,mid,u,v,e)
 j=add(f'J{len(joints)+1:02}',assembled,'Black',flat=ex(section,length),kind='edge spline',notes='bonding/alignment spline; 0.08 mm adhesive allowance')
 joints.append(dict(id=j['id'],faces=[f['id'],g['id']],length=length,edge=[a.tolist(),b.tolist()],dihedral_normals_deg=math.degrees(math.acos(np.clip(f['n']@g['n'],-1,1)))))

def ellipse(w,h):return Polygon([(math.cos(t)*w/2,math.sin(t)*h/2+P['base_y']) for t in np.linspace(0,2*math.pi,96,endpoint=False)])
def holes(centers,d):return unary_union([Point(*c).buffer(d/2,quad_segs=12) for c in centers])
bolt=[(85.5*math.cos(t),P['base_y']+85.5*math.sin(t)) for t in np.radians([45,135,225,315])]
outer=ellipse(P['base_width'],P['base_depth']);cavity=Point(0,P['base_y']).buffer(80,quad_segs=24)
baseprofile=outer.difference(cavity).difference(holes(bolt,3.4)).difference(box(-7.5,69,7.5,90))
add('B01-base-wall',ex(baseprofile,27,3),'Black',flat=ex(baseprofile,27),kind='base shell',notes='rear portal accepts replaceable inlet plate; underside bolts use nuts')
floor=ellipse(188,173).difference(holes(bolt,3.4))
add('B02-service-floor',ex(floor,3),'Black',kind='base floor',notes='four M3 screws and captive nuts; black compressible seam gasket')
loc=Point(0,P['base_y']).buffer(77,quad_segs=24).difference(Point(0,P['base_y']).buffer(75.3,quad_segs=24))
add('B03-weight-locator',ex(loc,4.3,3),'Black',flat=ex(loc,4.3),kind='ballast locator',notes='bond to floor; radial steel clearance 0.3 mm')
steel=Point(0,P['base_y']).buffer(75,quad_segs=48)
add('HW01-steel-ballast',ex(steel,4,3.2),'Steel',printable=False,kind='purchased metal',notes='150 x 4 mm steel disc; approximately 0.55 kg')
# Base lid and removable body collar; screws/nuts intentionally outside the light core opening.
foot=Polygon(rings[0][:,:2]);portal=foot.buffer(-10,join_style=2);bodybolts=[(-37,-8),(37,-8),(-30,34),(30,34)]
lid=ellipse(190,175).difference(portal).difference(holes(bolt,3.4)).difference(holes(bodybolts,3.4))
add('B04-upper-lid',ex(lid,3,30),'Black',flat=ex(lid,3),kind='base lid',notes='bolted to base; removable body collar screws access from below')
collar=foot.buffer(2,join_style=2).difference(portal).difference(holes(bodybolts,3.4))
add('B05-body-collar',ex(collar,6,33),'Black',flat=ex(collar,6),kind='body registration collar',notes='bond facet foot to collar; four M3 bolts with accessible hex nuts')
# Four top-mounted ballast stops, with a 0.5 mm compressible pad specified at assembly.
for i,(x,y) in enumerate([(-45,-35),(45,-35),(-45,15),(45,15)]):
 p=box(x-4,y-4,x+4,y+4)
 add(f'B06-stop-{i+1}',ex(p,22.5,7.5),'Black',flat=ex(p,22.5),kind='ballast stop',notes='bond to lid; 0.5 mm pad compresses against disc; verify actual thickness')
# Replaceable rear inlet plate, with a separate internal opaque baffle.
q=box(-7.3,-13.3,7.3,13.3).difference(Point(0,0).buffer(P['dc_jack_diameter']/2,quad_segs=20))
add('B07-inlet-plate',transform_mesh(ex(q,2.4),[0,74,16.5],[1,0,0],[0,0,1],[0,-1,0]),'Black',flat=ex(q,2.4),kind='DC inlet carrier',notes=P['dc_jack_status'])
q=box(-11,-14,11,14)
add('B08-inlet-light-baffle',transform_mesh(ex(q,1.6),[0,66,16.5],[1,0,0],[0,0,1],[0,-1,0]),'Black',flat=ex(q,1.6),kind='inlet light shield',notes='bond on spacers, route cable around offset edge')
# Hardware envelopes are segregated and excluded from all print plates.
add('HW02-aluminum-mast',ex(box(-10,-10,10,10).difference(box(-8.5,-8.5,8.5,8.5)),138,33),'Aluminum',printable=False,kind='purchased metal',notes='20 x 20 x 1.5 mm square tube; drill after validating LED locations')
add('HW03-core-foot',ex(box(-26,-22,26,22).difference(holes([(-20,-15),(20,-15),(-20,15),(20,15)],3.4)),2,28),'Aluminum',printable=False,kind='purchased metal',notes='metal mounting flange; mating bracket and fasteners must be finalized')

# Export meshes and simple AP214 faceted-BREP CAD solids (not a tessellated mesh entity).
def stlwrite(m,path):path.write_bytes(trimesh.exchange.stl.export_stl(m))
for p in parts:
 stlwrite(p['mesh'],OUT/'parts'/(p['id']+'.stl'))
 if p['printable']:stlwrite(p['flat'],OUT/'flat-parts'/(p['id']+'.stl'))

def step_export(path,items):
 lines=[]
 def ent(s):lines.append(s);return '#'+str(len(lines))
 app=ent("APPLICATION_CONTEXT('automotive design')")
 ent(f"APPLICATION_PROTOCOL_DEFINITION('international standard','automotive_design',2000,{app})")
 pc=ent(f"PRODUCT_CONTEXT('',{app},'mechanical')")
 prod=ent(f"PRODUCT('Corgi sculpture CAD v1','Corgi sculpture CAD v1','',{pc and '('+pc+')'})")
 pdf=ent(f"PRODUCT_DEFINITION_FORMATION('1','',{prod})")
 pdc=ent(f"PRODUCT_DEFINITION_CONTEXT('part definition',{app},'design')")
 pd=ent(f"PRODUCT_DEFINITION('design','',{pdf},{pdc})")
 pds=ent(f"PRODUCT_DEFINITION_SHAPE('','',{pd})")
 l=ent("(LENGTH_UNIT() NAMED_UNIT(*) SI_UNIT(.MILLI.,.METRE.))")
 a=ent("(NAMED_UNIT(*) PLANE_ANGLE_UNIT() SI_UNIT($,.RADIAN.))")
 so=ent("(NAMED_UNIT(*) SI_UNIT($,.STERADIAN.) SOLID_ANGLE_UNIT())")
 un=ent(f"UNCERTAINTY_MEASURE_WITH_UNIT(LENGTH_MEASURE(1.E-6),{l},'distance_accuracy_value','')")
 ctx=ent(f"(GEOMETRIC_REPRESENTATION_CONTEXT(3) GLOBAL_UNCERTAINTY_ASSIGNED_CONTEXT(({un})) GLOBAL_UNIT_ASSIGNED_CONTEXT(({l},{a},{so})) REPRESENTATION_CONTEXT('',''))")
 bodies=[]
 for p in items:
  m=p['mesh'];vs=[ent("CARTESIAN_POINT('',(%s))"%','.join(f'{x:.8f}' for x in v)) for v in m.vertices];fs=[]
  for tri in m.faces:
   loop=ent("POLY_LOOP('',(%s))"%','.join(vs[int(i)] for i in tri));bound=ent(f"FACE_OUTER_BOUND('',{loop},.T.)")
   points=m.vertices[tri];normal=unit(np.cross(points[1]-points[0],points[2]-points[0]));ref=unit(points[1]-points[0])
   nd=ent("DIRECTION('',(%s))"%','.join(f'{x:.12f}' for x in normal));rd=ent("DIRECTION('',(%s))"%','.join(f'{x:.12f}' for x in ref))
   ax=ent(f"AXIS2_PLACEMENT_3D('',{vs[int(tri[0])]},{nd},{rd})");plane=ent(f"PLANE('',{ax})")
   fs.append(ent(f"FACE_SURFACE('',({bound}),{plane},.T.)"))
  shell=ent("CLOSED_SHELL('',(%s))"%','.join(fs));body=ent(f"FACETED_BREP('{p['id']}',{shell})");bodies.append(body)
  rgb=COL[p['color']].lstrip('#');col=ent("COLOUR_RGB('',%s)"%','.join(f'{int(rgb[i:i+2],16)/255:.6f}' for i in [0,2,4]));fill=ent(f"FILL_AREA_STYLE_COLOUR('',{col})");fa=ent(f"FILL_AREA_STYLE('',({fill}))");sfa=ent(f"SURFACE_STYLE_FILL_AREA({fa})");ss=ent(f"SURFACE_SIDE_STYLE('',({sfa}))");ssu=ent(f"SURFACE_STYLE_USAGE(.BOTH.,{ss})");pa=ent(f"PRESENTATION_STYLE_ASSIGNMENT(({ssu}))");ent(f"STYLED_ITEM('',({pa}),{body})")
 rep=ent("FACETED_BREP_SHAPE_REPRESENTATION('',(%s),%s)"%(','.join(bodies),ctx));ent(f"SHAPE_DEFINITION_REPRESENTATION({pds},{rep})")
 text="ISO-10303-21;\nHEADER;\nFILE_DESCRIPTION(('Planar Corgi sculpture - CAD design v1'),'2;1');\nFILE_NAME('"+path.name+"','2026-10-19T00:00:00',(''),(''),'parametric Python geometry','Codex','');\nFILE_SCHEMA(('AUTOMOTIVE_DESIGN'));\nENDSEC;\nDATA;\n"+'\n'.join(f'#{i+1}={s};' for i,s in enumerate(lines))+"\nENDSEC;\nEND-ISO-10303-21;\n"
 path.write_text(text,encoding='ascii')
step_export(OUT/'corgi-sculpture-assembly.step',parts)

def render(path,views):
 im=Image.new('RGB',(1500,850),'#e8ebef');pix=np.array(im);zb=np.full((850,1500),-1e9);font=ImageFont.truetype('C:/Windows/Fonts/arial.ttf',19)
 for vi,(az,el,title) in enumerate(views):
  az,el=np.radians([az,el]);eye=np.array([math.sin(az)*math.cos(el),-math.cos(az)*math.cos(el),math.sin(el)]);right=unit(np.cross(eye,[0,0,1]));up=np.cross(right,eye);polys=[]
  for p in parts:
   if not p['printable'] or p['kind']=='edge spline':continue
   m=p['mesh'];col=np.array([int(COL[p['color']][i:i+2],16) for i in [1,3,5]],float)
   for f,n in zip(m.faces,m.face_normals):
    if n@eye<1e-5:continue
    vv=m.vertices[f];shade=.62+.38*max(0,n@unit([-1,-2,3]));color=np.clip(col*shade,0,255).astype(np.uint8);proj=np.c_[vv@right,vv@up]
    pts=np.array([(vi*500+250+x*2.45,760-(y+15)*2.45) for x,y in proj]);depths=vv@eye
    x0=max(vi*500,int(np.floor(pts[:,0].min())));x1=min((vi+1)*500-1,int(np.ceil(pts[:,0].max())));y0=max(50,int(np.floor(pts[:,1].min())));y1=min(799,int(np.ceil(pts[:,1].max())))
    if x1<x0 or y1<y0:continue
    A=np.array([[pts[0,0]-pts[2,0],pts[1,0]-pts[2,0]],[pts[0,1]-pts[2,1],pts[1,1]-pts[2,1]]]);det=np.linalg.det(A)
    if abs(det)<1e-9:continue
    xx,yy=np.meshgrid(np.arange(x0,x1+1)+.5,np.arange(y0,y1+1)+.5);delta=np.array([xx-pts[2,0],yy-pts[2,1]]);bary=np.einsum('ij,jkl->ikl',np.linalg.inv(A),delta);b0,b1=bary;b2=1-b0-b1;zz=b0*depths[0]+b1*depths[1]+b2*depths[2]
    old=zb[y0:y1+1,x0:x1+1];mask=(b0>=-1e-7)&(b1>=-1e-7)&(b2>=-1e-7)&(zz>old);old[mask]=zz[mask];pix[y0:y1+1,x0:x1+1][mask]=color
 im=Image.fromarray(pix);d=ImageDraw.Draw(im)
 for vi,(_,_,title) in enumerate(views):d.text((vi*500+20,20),title,fill='#17202c',font=font)
 d.text((20,820),'Actual CAD geometry | planar panes, mitered carriers, detachable weighted base | unprinted design',fill='#17202c',font=font)
 im.save(path)
render(OUT/'cad-three-views.png',[(-32,13,'Front three-quarter'),(-90,8,'Side'),(145,15,'Rear three-quarter')])

manifest=dict(revision='cad-v1',parameters=P,face_count=len(faces),part_count=len(parts),
 printable_count=sum(p['printable'] for p in parts),nominal_envelope=dict(watertight=envelope.is_watertight,volume_mm3=float(envelope.volume),bounds_mm=envelope.bounds.tolist()),
 faces=[dict(id=f['id'],label=f['label'],color=f['color'],plane_origin=f['o'].tolist(),plane_normal=f['n'].tolist(),area_mm2=f['p'].area,planarity_error_mm=float(np.max(np.abs((f['points']-f['o'])@f['n'])))) for f in faces],
 parts=[dict(id=p['id'],color=p['color'],kind=p['kind'],printable=p['printable'],notes=p['notes'],watertight=p['mesh'].is_watertight,volume_mm3=float(p['mesh'].volume),bounds_mm=p['mesh'].bounds.tolist(),flat_bounds_mm=p['flat'].bounds.tolist()) for p in parts],joints=joints,
 status=dict(generated=True,geometry_checked=True,native_cad_opened=False,slice_verified=False,printed=False,physical_fit=False,thermal_test=False,light_leak_test=False),
 limitations=['Concept interpretation is actual parametric geometry, not a reconstruction of generated pixels','Hardware envelopes are provisional; confirm actual purchased dimensions','Adhesive joints, nut retention, ventilation, mounting details require subsequent validation'])
(OUT/'manifest.json').write_text(json.dumps(manifest,indent=2))
print(json.dumps({k:manifest[k] for k in ['face_count','part_count','printable_count','nominal_envelope']},indent=2))

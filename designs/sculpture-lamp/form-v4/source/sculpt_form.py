"""Continuous sculptural Corgi form, before planarization or lamp engineering.
Run with portable Blender 4.5 in background. Model construction coordinates: mm.
"""
import bpy, math, json, sys
from pathlib import Path
from mathutils import Vector

ROOT=Path(__file__).resolve().parents[4]
OUT=ROOT/'designs/sculpture-lamp/form-v4'
OUT.mkdir(parents=True,exist_ok=True)
bpy.ops.object.select_all(action='SELECT');bpy.ops.object.delete(use_global=False)

def material(name,rgb,roughness=.6,metallic=0):
 m=bpy.data.materials.new(name);m.diffuse_color=(*rgb,1);m.use_nodes=True
 p=m.node_tree.nodes.get('Principled BSDF');p.inputs['Base Color'].default_value=(*rgb,1)
 p.inputs['Roughness'].default_value=roughness;p.inputs['Metallic'].default_value=metallic
 return m
clay=material('Warm sculpting clay',(.56,.40,.26),.7)
dark=material('Nose and eyelid clay',(.035,.026,.022),.42)
iris=material('Brown eyes',(.105,.048,.019),.32)
pupil=material('Pupils',(.006,.004,.003),.22)
pupil.node_tree.nodes.get('Principled BSDF').inputs['Specular IOR Level'].default_value=.12
inner=material('Inner ear clay',(.46,.31,.23),.75)
baseMat=material('Plinth charcoal',(.025,.029,.032),.6)
shell=[]

def mesh(name,verts,faces,mat=clay):
 d=bpy.data.meshes.new(name);d.from_pydata(verts,[],faces);d.update()
 o=bpy.data.objects.new(name,d);bpy.context.collection.objects.link(o)
 o.data.materials.append(mat)
 import bmesh
 bm=bmesh.new();bm.from_mesh(d);bmesh.ops.recalc_face_normals(bm,faces=list(bm.faces));bm.to_mesh(d);bm.free()
 for p in d.polygons:p.use_smooth=True
 return o

def ellipsoid(name,center,radii,mat=clay,normal=None):
 bpy.ops.mesh.primitive_uv_sphere_add(segments=64,ring_count=40,location=center)
 o=bpy.context.object;o.name=name;o.scale=radii
 if normal is not None:
  n=Vector(normal).normalized();u=Vector((0,0,1)).cross(n).normalized();v=n.cross(u).normalized()
  # Local Y is the eye's outward axis; preserve right-handed basis.
  from mathutils import Matrix
  o.rotation_euler=Matrix((u,-n,v)).transposed().to_euler()
 bpy.ops.object.transform_apply(location=False,rotation=False,scale=True)
 o.data.materials.append(mat)
 for p in o.data.polygons:p.use_smooth=True
 return o

def loft(name,levels,axis='Z',samples=72):
 verts=[];faces=[]
 for c,w,front,back in levels:
  for i in range(samples):
   a=2*math.pi*i/samples
   if axis=='Z':
    cy=(front+back)/2;dep=(back-front)/2
    verts.append((w*math.sin(a),cy-dep*math.cos(a),c))
   else:
    z=(front+back)/2;h=(back-front)/2
    verts.append((w*math.cos(a),c,z+h*math.sin(a)))
 for k in range(len(levels)-1):
  for i in range(samples):
   j=(i+1)%samples;a=k*samples+i;b=k*samples+j
   faces.append((a,b,b+samples,a+samples))
 faces += [tuple(range(samples-1,-1,-1)),tuple((len(levels)-1)*samples+i for i in range(samples))]
 o=mesh(name,verts,faces)
 bpy.context.view_layer.objects.active=o;o.select_set(True)
 # Curved anatomy is evaluated before the later planar-panel design.
 sub=o.modifiers.new('Contour interpolation','SUBSURF');sub.levels=2
 bpy.ops.object.modifier_apply(modifier=sub.name)
 return o

bpy.ops.wm.stl_import(filepath=str(OUT/'continuous-anatomy.stl'))
body=bpy.context.object;body.name='Continuous anatomical surface';body.data.materials.clear();body.data.materials.append(clay);shell.append(body)
# Substantial ear roots, tapered rounded rims and a recessed inner bowl.
for side in (-1,1):
 levels=[(218,55,70,21,13),(233,34,83,13,13),(251,35,96,14,11),
         (270,46,101,19,8),(288,61,96,24,5),(305,77,90,29,2.5),(317,86,86.7,32,1)]
 verts=[];N=36
 for z,x0,x1,y,t in levels:
  for i in range(N):
   a=2*math.pi*i/N;xx=(x0+x1)/2+(x1-x0)/2*math.cos(a)
   yy=y+.65*(xx-(x0+x1)/2)+t/2*math.sin(a)
   verts.append((side*xx,yy,z))
 faces=[]
 for k in range(len(levels)-1):
  for i in range(N):j=(i+1)%N;faces.append((k*N+i,k*N+j,(k+1)*N+j,(k+1)*N+i))
 faces.extend([tuple(range(N-1,-1,-1)),tuple((len(levels)-1)*N+i for i in range(N))])
 ear=mesh('Thick tapered ear',verts,faces)
 sub=ear.modifiers.new('Rounded ear contour','SUBSURF');sub.levels=2
 bpy.context.view_layer.objects.active=ear;bpy.ops.object.modifier_apply(modifier=sub.name)
 shell.append(ear)

# Union as a continuous sculpt, then polish the remeshed surface.
bpy.ops.object.select_all(action='DESELECT')
for o in shell:o.select_set(True)
bpy.context.view_layer.objects.active=body;bpy.ops.object.join()
body=bpy.context.object;body.name='Corgi continuous sculpt'
body.data.remesh_voxel_size=1.1;bpy.ops.object.voxel_remesh()
smooth=body.modifiers.new('Sculpt surface polish','SMOOTH');smooth.factor=.7;smooth.iterations=9
bpy.ops.object.modifier_apply(modifier=smooth.name)
for p in body.data.polygons:p.use_smooth=True

# Recess the ear bowls instead of painting a flat leaf on the front.
def difference(obj,cutter):
 bpy.context.view_layer.objects.active=obj
 m=obj.modifiers.new('Sculpt recess','BOOLEAN');m.operation='DIFFERENCE';m.solver='EXACT';m.object=cutter
 bpy.ops.object.modifier_apply(modifier=m.name);bpy.data.objects.remove(cutter,do_unlink=True)
for side in (-1,1):
 cutter=ellipsoid('Ear bowl cutting tool',(side*69,10,270),(17,8,34),normal=(side*.65,-1,.04))
 from mathutils import Matrix
 cutter.rotation_euler=(Matrix.Rotation(side*math.radians(16),3,'Y') @ cutter.rotation_euler.to_matrix()).to_euler()
 difference(body,cutter)

# Almond-shaped orbital openings and shallow convex eye lenses.
# The eye boundaries follow the lid shape instead of showing exposed spherical beads.
def almond(side):
 controls=[(-12,0),(-9,7),(-2,10),(7,7),(12,-1),(8,-7),(0,-9),(-8,-6)]
 result=[]
 for i in range(len(controls)):
  p0=Vector(controls[(i-1)%8]);p1=Vector(controls[i]);p2=Vector(controls[(i+1)%8]);p3=Vector(controls[(i+2)%8])
  for j in range(8):
   t=j/8;q=.5*((2*p1)+(-p0+p2)*t+(2*p0-5*p1+4*p2-p3)*t*t+(-p0+3*p1-3*p2+p3)*t*t*t)
   result.append((q.x*side,q.y))
 return result
def lens(name,shape,c,u,v,n,scale,mat,peak,boundary):
 N=len(shape);verts=[c+n*peak];faces=[]
 for k in range(1,11):
  r=k/10;depth=boundary+(peak-boundary)*(1-r*r)
  verts.extend(c+n*depth+u*x*scale*r+v*y*scale*r for x,y in shape)
 for i in range(N):faces.append((0,1+i,1+(i+1)%N))
 for k in range(9):
  a=1+k*N;b=a+N
  for i in range(N):j=(i+1)%N;faces.append((a+i,b+i,b+j,a+j))
 off=len(verts)
 verts.extend(c-n*3+u*x*scale+v*y*scale for x,y in shape)
 for i in range(N):j=(i+1)%N;faces.append((1+9*N+i,off+i,off+j,1+9*N+j))
 faces.append(tuple(off+i for i in range(N-1,-1,-1)))
 return mesh(name,verts,faces,mat)
for side in (-1,1):
 n=Vector((side*.48,-.86,.13)).normalized();u=Vector((0,0,1)).cross(n).normalized();v=n.cross(u).normalized()
 c=Vector((side*44,-39,225));hit,loc,nn,idx=body.ray_cast(c+n*40,-n);assert hit;c=loc-n*.8
 shape=almond(side);N=len(shape)
 verts=[c+n*z+u*x+v*y for z in [-5,18] for x,y in shape]
 faces=[tuple(range(N-1,-1,-1)),tuple(N+i for i in range(N))]
 faces.extend((i,(i+1)%N,N+(i+1)%N,N+i) for i in range(N))
 cutter=mesh('Almond socket cutting tool',verts,faces)
 difference(body,cutter)
 lens('Dark eye rim',shape,c,u,v,n,1,dark,1.3,.05)
 lens('Brown eye lens',shape,c,u,v,n,.84,iris,1.7,.4)
 look=c+n*1.8+v*1.5+u*(-side*.9)
 ellipsoid('Pupil',look,(4.6,.35,5.9),pupil,normal=n)

def tube(name,points,radius,mat=dark):
 d=bpy.data.curves.new(name,'CURVE');d.dimensions='3D';d.resolution_u=24;d.bevel_depth=radius;d.bevel_resolution=4
 sp=d.splines.new('BEZIER');sp.bezier_points.add(len(points)-1)
 for p,co in zip(sp.bezier_points,points):p.co=co;p.handle_left_type='AUTO';p.handle_right_type='AUTO'
 o=bpy.data.objects.new(name,d);bpy.context.collection.objects.link(o);d.materials.append(mat)
 return o

# Nose is rounded and tapers into the philtrum.
nose=ellipsoid('Soft triangular nose',(0,-112.5,202),(20,8,13.5),dark)
# Shape the lower nose into a gentle point and flatten its upper surface.
for vtx in nose.data.vertices:
 z=vtx.co.z
 if z<0:vtx.co.x*=1+.28*z/13.5
 if z>8:vtx.co.z=8+(z-8)*.45
for side in (-1,1):
 ellipsoid('Nostril',(side*11,-119.4,204),(3.4,1.1,2.4),pupil)
 mouthpoints=[]
 for x,z in [(0,185),(side*12,182),(side*25,179),(side*32,178)]:
  hit,loc,nn,idx=body.ray_cast(Vector((x,-180,z)),Vector((0,1,0)))
  assert hit
  mouthpoints.append(loc+Vector((0,-.35,0)))
 tube('Closed mouth',mouthpoints,.55)
tube('Philtrum',[(0,-119,193),(0,-117,188),(0,-113,186)],.7)

# A quiet pedestal helps judge posture without designing the lamp base yet.
bpy.ops.mesh.primitive_cylinder_add(vertices=128,radius=1,depth=23,location=(0,20,11.5))
base=bpy.context.object;base.name='Study plinth';base.scale=(90,85,1)
bpy.ops.object.transform_apply(location=False,rotation=False,scale=True)
bevel=base.modifiers.new('Soft plinth edge','BEVEL');bevel.width=2;bevel.segments=4
base.data.materials.append(baseMat)
for p in base.data.polygons:p.use_smooth=True

# Mesh evidence: closedness and dimensions are recorded separately from likeness.
import bmesh
bm=bmesh.new();bm.from_mesh(body.data)
report=dict(vertices=len(bm.verts),faces=len(bm.faces),boundary_edges=sum(e.is_boundary for e in bm.edges),nonmanifold_edges=sum(not e.is_manifold for e in bm.edges),volume_mm3=abs(bm.calc_volume()),status='Continuous form for visual review; not a planar-pane assembly')
bm.free()
(OUT/'sculpt-validation.json').write_text(json.dumps(report,indent=2))
# Use meters for rendering; 1 construction millimeter = 0.01 scene units.
for o in list(bpy.context.scene.objects):
 o.location*=.01;o.scale*=.01

bpy.ops.object.select_all(action='DESELECT');body.select_set(True);bpy.context.view_layer.objects.active=body
bpy.ops.wm.stl_export(filepath=str(OUT/'corgi-continuous-form-mm.stl'),export_selected_objects=True,global_scale=100)
scene=bpy.context.scene;scene.unit_settings.system='METRIC';scene.unit_settings.scale_length=.1;scene.render.engine='CYCLES';scene.cycles.samples=32
scene.cycles.use_denoising=True;scene.render.resolution_x=1100;scene.render.resolution_y=1300;scene.render.resolution_percentage=100
scene.world.color=(.22,.22,.22)
scene.view_settings.view_transform='AgX'
floorMat=material('Studio floor',(.12,.13,.145),.85)
bpy.ops.mesh.primitive_plane_add(size=200,location=(0,0,-.025));floor=bpy.context.object;floor.name='Studio floor';floor.data.materials.append(floorMat)

def area(name,location,power,size,target=(0,0,1.8)):
 d=bpy.data.lights.new(name,'AREA');d.energy=power;d.shape='DISK';d.size=size
 o=bpy.data.objects.new(name,d);bpy.context.collection.objects.link(o);o.location=location;o.rotation_euler=(Vector(target)-o.location).to_track_quat('-Z','Y').to_euler()
area('Large soft key',(-3,-4,6),500,2.4)
area('Soft fill',(4,-2,3.5),220,3)
area('Ear rim',(1,4,5),550,3)
camd=bpy.data.cameras.new('Review camera');cam=bpy.data.objects.new('Review camera',camd);bpy.context.collection.objects.link(cam);scene.camera=cam
camd.type='ORTHO';camd.ortho_scale=3.7

def camera(location,target=(0,-.04,1.64)):
 cam.location=location;cam.rotation_euler=(Vector(target)-cam.location).to_track_quat('-Z','Y').to_euler()
camera((4,-7,2.8))
bpy.ops.wm.save_as_mainfile(filepath=str(OUT/'corgi-continuous-form.blend'),compress=True)
for label,loc in [('three-quarter',(4,-7,2.8)),('profile',(8,0,2.05)),('front',(0,-8,2.3)),('rear',(4,7,2.8))]:
 camera(loc);scene.render.filepath=str(OUT/(label+'.png'));bpy.ops.render.render(write_still=True)
camera((4,-7,2.8))
bpy.ops.wm.save_as_mainfile(filepath=str(OUT/'corgi-continuous-form.blend'),compress=True)
print('Sculptural form and four actual geometry renders saved:',OUT)

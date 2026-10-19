"""V3: independent anatomical landmark mesh, derived from approved three-view concept.
Millimeters. Visual form study, not a print-release assembly.
"""
from pathlib import Path
exec(Path(__file__).with_name('build.py').read_text().split('template=np.array')[0].replace("cad-v1'","cad-v3'"))
COL.update(Gold='#DB9A32',Champagne='#ECD294',White='#F6E5BC',Cocoa='#75482C',Black='#171616',Iris='#654126')
parts=[]; surfaces=[]

def panel(pts,col,label,expected=None,width=.85,holes=None):
 pts=np.array(pts,float)
 if expected is not None and np.cross(pts[1]-pts[0],pts[2]-pts[0])@expected<0:pts=pts[::-1]
 o=pts[0];u=unit(pts[1]-o);n=unit(np.cross(pts[1]-o,pts[2]-o));v=np.cross(n,u)
 error=max(abs((pts-o)@n))
 if error>1e-4:
  for i in range(1,len(pts)-1):panel(pts[[0,i,i+1]],col,label,expected,width)
  return
 poly=orient(Polygon(xyz2(pts,o,u,v),[xyz2(h,o,u,v) for h in holes or []]));inner=poly.buffer(-width/2,join_style=2)
 sid=f'P{len(surfaces)+1:03d}'
 if col=='Black' or inner.is_empty:
  add(sid+'-'+label,transform_mesh(ex(poly,1.1,-1.1),o,u,v,n),'Black',kind='opaque form facet')
 else:
  add(sid+'-leading',transform_mesh(ex(poly.difference(inner),1.1,-1.1),o,u,v,n),'Black',kind='leading form facet')
  t=.3 if col=='Cocoa' else .4
  add(sid+'-'+label,transform_mesh(ex(inner,t,-t),o,u,v,n),col,flat=ex(inner,t),kind='planar colored pane')
 surfaces.append(dict(id=sid,label=label,color=col,points=pts.tolist(),planarity_error_mm=float(error)))

# Named, anatomically meaningful landmarks. Forward is -Y, up is +Z.
V={
 'baseC':(0,-39,18),'baseF':(41,-33,18),'baseS':(66,1,18),'baseB':(53,66,18),'baseR':(0,75,18),
 'breast':(0,-54,77),'chest':(44,-30,80),'shoulder':(80,26,76),'backLow':(62,76,80),'backC':(0,85,80),
 'throat':(0,-25,129),'ruff':(45,-2,133),'nape':(43,38,137),'napeC':(0,46,139),
 'chin':(0,-56,155),'jaw':(34,-40,159),'cheekLow':(58,-4,175),'backJaw':(54,46,185),'backHead':(0,59,205),
 'lipC':(0,-94,168),'lipSide':(24,-85,166),'mouth':(35,-57,168),
 'noseTop':(0,-99,192),'noseSide':(19,-97,187),'muzzleSide':(28,-88,177),
 'bridgeC':(0,-59,209),'bridge':(12,-55,211),'muzzleRoot':(25,-61,196),
 'foreheadC':(0,-30,236),'brow':(31,-32,236),'temple':(57,0,228),'cheek':(63,-7,192),'eyeCheek':(58,-8,205),'eyeBottom':(35,-42,198),
 'crownC':(0,13,243),'crown':(39,24,237),'occiput':(53,46,224),'crownBack':(0,51,233),
}

def half(names,col,label,side=1):
 pts=np.array([V[a] for a in names],float);pts[:,0]*=side
 panel(pts,col,label,expected=np.array([side,0,0]))

patches=[
(['baseC','baseF','chest','breast'],'Champagne','bib-bottom'),
(['baseF','baseS','shoulder','chest'],'Gold','shoulder-front'),
(['baseS','baseB','backLow','shoulder'],'Cocoa','saddle-low'),
(['baseB','baseR','backC','backLow'],'Cocoa','back-low'),
(['breast','chest','throat'],'White','bib-upper'),
(['chest','ruff','throat'],'Champagne','chest-upper'),
(['chest','shoulder','ruff'],'Gold','ruff-front'),
(['shoulder','backLow','nape'],'Cocoa','saddle-middle'),
(['shoulder','nape','ruff'],'Gold','ruff-side'),
(['backLow','backC','napeC','nape'],'Cocoa','back-middle'),
(['throat','ruff','jaw','chin'],'Champagne','throat'),
(['ruff','cheekLow','jaw'],'Gold','jaw-ruff'),
(['ruff','nape','backJaw','cheekLow'],'Gold','neck-side'),
(['nape','napeC','backHead','backJaw'],'Cocoa','nape'),
(['cheekLow','backJaw','occiput','temple','cheek'],'Gold','cheek-side'),
(['backJaw','backHead','crownBack','occiput'],'Cocoa','skull-back'),
(['occiput','crownBack','crownC','crown'],'Cocoa','crown-back'),
(['crown','crownC','foreheadC','brow'],'Gold','forehead-top'),
(['crown','brow','temple'],'Gold','temple-top'),
(['crown','temple','occiput'],'Cocoa','ear-root-back'),
(['foreheadC','bridgeC','bridge','brow'],'White','forehead-blaze'),
(['bridgeC','noseTop','noseSide','bridge'],'Champagne','muzzle-top'),
(['bridge','noseSide','muzzleSide','muzzleRoot'],'Champagne','muzzle-upper'),
(['muzzleRoot','muzzleSide','lipSide','mouth'],'Champagne','muzzle-cheek'),
(['muzzleSide','noseSide','noseTop','lipC','lipSide'],'Champagne','muzzle-front'),
(['lipC','chin','jaw','mouth','lipSide'],'Champagne','lower-jaw'),
(['mouth','jaw','cheekLow','cheek'],'Gold','lower-cheek'),
 (['muzzleRoot','mouth','eyeBottom'],'Gold','muzzle-transition'),
 (['eyeBottom','mouth','cheek','eyeCheek'],'Gold','cheek-front'),
 (['eyeCheek','cheek','temple'],'Gold','cheek-upper'),
]
# Constrain the broad anatomical patches to planes while retaining shared vertices.
from scipy.optimize import least_squares
keys=list(V);original=np.array([V[k] for k in keys],float);ix={k:i for i,k in enumerate(keys)}
quads=[[ix[k] for k in names] for names,_,_ in patches if len(names)>3]
quads.append([ix[k] for k in ['bridge','brow','temple','eyeCheek','eyeBottom','muzzleRoot']])
def residual(flat):
 vv=flat.reshape(-1,3);r=list(((vv-original)*.04).ravel())
 for ids in quads:
  pp=vv[ids];nn=unit(np.cross(pp[1]-pp[0],pp[2]-pp[0]))
  r.extend(((pp[3:]-pp[0])@nn)*1000)
 for i in range(len(keys)):
  if original[i,0]==0:r.append(vv[i,0]*1000)
 return r
fit=least_squares(residual,original.ravel(),max_nfev=250,ftol=1e-10,gtol=1e-10,xtol=1e-10)
V={k:fit.x.reshape(-1,3)[i].tolist() for i,k in enumerate(keys)}
print('Landmark planarization maximum displacement',float(np.linalg.norm(fit.x.reshape(-1,3)-original,axis=1).max()))
for side in (1,-1):
 for names,col,label in patches:
  if label=='forehead-blaze':
   pp=np.array([V[k] for k in names],float);pp[:,0]*=side
   for sign,c in [(1,'Gold'),(-1,'White')]:
    clipped=[]
    for aa,bb in zip(pp,np.roll(pp,-1,axis=0)):
     da=sign*(side*aa[0]-9);db=sign*(side*bb[0]-9)
     if da>=0:clipped.append(aa)
     if (da>=0)!=(db>=0):clipped.append(aa+(bb-aa)*da/(da-db))
    panel(clipped,c,label,expected=np.array([side,-1,0]))
  else:half(names,col,label,side)
 # Six-point inset eye socket, joined directly to the anatomical face boundary.
 outer=np.array([V[a] for a in ['bridge','brow','temple','eyeCheek','eyeBottom','muzzleRoot']],float);outer[:,0]*=side
 n=unit(np.cross(outer[1]-outer[0],outer[2]-outer[0]))
 if n@np.array([side*.57,-.81,.13])<0:n=-n
 eu=unit(np.cross([0,0,1],n));ev=np.cross(n,eu)
 center=np.array([side*38,-36,215.]);center-=n*((center-outer[0])@n)
 shape=np.array([[-13,-3],[-8,10],[3,12],[11,5],[12,-7],[1,-10],[-8,-8]],float)
 if side<0:shape[:,0]*=-1
 eye=np.array([center+x*eu+y*ev for x,y in shape])
 panel(outer,'Gold','eye-surround',expected=n,holes=[eye])
 panel(eye,'Black','socket',expected=n,width=0)
 # Faceted brown lens nested inside the socket; pupil follows the raised brow gaze.
 iriscenter=center+n*.45+ev*.4
 iris=np.array([iriscenter+.73*(p-center) for p in eye])
 peak=iriscenter+n*1.9
 for i in range(len(iris)):panel([iris[i],iris[(i+1)%len(iris)],peak],'Iris','iris',expected=n,width=.15)
 pupilcenter=peak+n*.2+ev*1.8
 pupil=[pupilcenter+x*eu+y*ev for x,y in [(-3,-4),(-4,2),(-1,5),(4,3),(4,-3),(0,-5)]]
 panel(pupil,'Black','pupil',expected=n,width=0)
 glint=pupilcenter+n*.2+ev*3-eu*2
 panel([glint+x*eu+y*ev for x,y in [(-1.5,0),(0,1.6),(1.6,.8),(1.2,-1.2),(-.9,-1.3)]],'White','catchlight',expected=n,width=.1)
 # Ears: deep roots and a folded front, with a three-dimensional tapered back.
 E=np.array([[28,8,236],[66,14,209],[103,14,265],[88,29,309],[43,8,276],[67,-4,259],[70,36,263],[49,36,237]],float)
 E[:,0]*=side
 for inds,col in [([0,1,5],'Gold'),([1,2,5],'Champagne'),([2,3,5],'Champagne'),([3,4,5],'Champagne'),([4,0,5],'Gold'),([0,4,7],'Cocoa'),([4,3,6,7],'Cocoa'),([3,2,6],'Gold'),([2,1,7,6],'Gold'),([1,0,7],'Cocoa')]:
  pts=E[inds];expt=pts.mean(0)-E.mean(0)
  panel(pts,col,'ear',expected=expt,width=1.0)

# Low-poly nose, gently tapered rather than a rectangular black plug.
back=np.array([[-18,-96,189],[-12,-98,195],[12,-98,195],[18,-96,189],[10,-99,176],[0,-101,172],[-10,-99,176]],float)
front=back.copy();front[:,0]*=.78;front[:,1]-=4
nc=front.mean(0)+[0,-1,1]
for i in range(len(back)):
 j=(i+1)%len(back)
 panel([back[i],back[j],front[j],front[i]],'Black','nose-edge',expected=np.array([0,-1,0]),width=0)
 panel([front[i],front[j],nc],'Black','nose-tip',expected=np.array([0,-1,0]),width=0)

base=Polygon([(86*math.cos(t),17+75*math.sin(t)) for t in np.linspace(0,2*math.pi,32,endpoint=False)])
add('plinth-envelope',ex(base,18),'Black',kind='base form envelope')
data=[dict(id=p['id'],vertices=p['mesh'].vertices.tolist(),faces=p['mesh'].faces.tolist(),color=p['color'],expected_volume_mm3=float(p['mesh'].volume)) for p in parts]
(OUT/'fusion-body-input.json').write_text(json.dumps(data))
(OUT/'form-study.json').write_text(json.dumps(dict(surfaces=surfaces,palette=COL,landmarks=V,part_count=len(parts),status='Visual form study; not assembly or print qualified.'),indent=2))
renderer=Path(__file__).with_name('build.py').read_text().split('def render(path,views):')[1].split('manifest=dict')[0]
exec('def render(path,views):'+renderer.replace('2.45','2.1').replace("(-32,13,'Front three-quarter'),(-90,8,'Side'),(145,15,'Rear three-quarter')","(-32,8,'Front three-quarter'),(-90,3,'Side'),(145,8,'Rear three-quarter')").replace('Actual CAD geometry | planar panes, mitered carriers, detachable weighted base | unprinted design','Actual geometry | landmark reconstruction | form study, not print-ready'))
print('Generated',len(parts),'closed solids;',len(surfaces),'flat surface facets')

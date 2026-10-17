from pathlib import Path
import sys,zipfile,json,hashlib,copy,xml.etree.ElementTree as ET
sys.path.insert(0,str(Path(__file__).parent/'pydeps'))
import numpy as np,cv2,trimesh
from shapely.geometry import Polygon,box
from shapely.ops import unary_union
from shapely import set_precision
from xml.sax.saxutils import escape

R=Path(__file__).resolve().parents[1]; O=R/'outputs'
source=(R/'sources/example_lithophane.3mf')
target=O/'lion-wink-lightbox-H2D.3mf'
im=cv2.imread(str(O/'lion-panel-wink-smirk-draft-v2.png'))
h,w=im.shape[:2]; scale=108/w
H,S,V=cv2.split(cv2.cvtColor(im,cv2.COLOR_BGR2HSV))
count,labels,stats,_=cv2.connectedComponentsWithStats((V>75).astype('uint8'),8)
masks=[np.zeros((h,w),dtype=bool) for _ in range(5)]
for label in range(1,count):
    cell=labels==label
    if stats[label,cv2.CC_STAT_AREA]<30:continue
    mh,ms,mv=np.median(H[cell]),np.median(S[cell]),np.median(V[cell])
    cat=0 if ms<65 else 1 if mh>75 else 2 if mh>=22 else 3 if mv>175 else 4
    masks[cat]|=cell
def polygons(p):
    return [p] if p.geom_type=='Polygon' else [g for g in p.geoms if g.geom_type=='Polygon']
regions=[]; taken=Polygon(); outline=box(-54,-72,54,72)
names=['Jade White','Cyan','Sunflower Yellow','Pumpkin Orange','Cocoa Brown']
cols=['#FFFFFF','#0086D6','#FEC600','#FF9016','#6F5034']
for name,col,mask in zip(names,cols,masks):
    cs,hier=cv2.findContours(mask.astype('uint8'),cv2.RETR_CCOMP,cv2.CHAIN_APPROX_SIMPLE)
    ps=[]
    def ring(c):
        xy=cv2.approxPolyDP(c,.55,True)[:,0,:].astype(float)
        xy[:,0]=xy[:,0]*scale-54
        xy[:,1]=(h-1-xy[:,1])*scale-54
        return xy
    for i,c in enumerate(cs):
        if hier[0,i,3]!=-1 or cv2.contourArea(c)<30:continue
        holes=[];k=hier[0,i,2]
        while k!=-1:
            if cv2.contourArea(cs[k])>8:holes.append(ring(cs[k]))
            k=hier[0,k,0]
        poly=Polygon(ring(c),holes).buffer(0)
        if poly.area>.1:ps.append(poly)
    if name=='Cyan':
        # Add portrait-height background, preserving the square lion's proportions.
        for p in list(ps):
            xmin,ymin,xmax,ymax=p.bounds
            if p.centroid.y>0:ps.append(box(xmin,49,xmax,69))
            else:ps.append(box(xmin,-69,xmax,-49))
    poly=set_precision(unary_union(ps),.001).intersection(outline).difference(taken)
    regions.append((name,col,poly,.8));taken=unary_union([taken,poly])
black=set_precision(outline.difference(taken).buffer(.025,quad_segs=3).intersection(outline),.001)
regions=[(n,c,p.difference(black),z) for n,c,p,z in regions]
regions.insert(0,('Black','#000000',black,2.5))
assert abs(sum(p.area for n,c,p,z in regions)-outline.area)<1e-5
for i in range(len(regions)):
    for j in range(i):assert regions[i][2].intersection(regions[j][2]).area<1e-6
meshes=[];report=[]
parts=O/'lion-wink-lightbox-parts';parts.mkdir(exist_ok=True)
for i,(name,col,poly,z) in enumerate(regions):
    mesh=trimesh.util.concatenate([trimesh.creation.extrude_polygon(p,z,engine='earcut') for p in polygons(poly)])
    assert mesh.is_watertight and mesh.is_winding_consistent and mesh.volume>0,name
    assert mesh.bounds[0,2]>=-1e-6
    mesh.export(parts/f'{i+1:02d}-{name.replace(" ","-")}.stl')
    meshes.append(mesh)
    report.append(dict(name=name,color=col,height_mm=z,volume_mm3=float(mesh.volume),triangles=len(mesh.faces),watertight=True))

ns='http://schemas.microsoft.com/3dmanufacturing/core/2015/02'
pns='http://schemas.microsoft.com/3dmanufacturing/production/2015/06'
ET.register_namespace('',ns);ET.register_namespace('p',pns)
ET.register_namespace('BambuStudio','http://schemas.bambulab.com/package/2021')
orig=zipfile.ZipFile(source)
root=ET.fromstring(orig.read('3D/3dmodel.model'))
assembly=root.find(f'{{{ns}}}resources/{{{ns}}}object[@id="6"]')
components=assembly.find(f'{{{ns}}}components'); components.clear()
ids=[1,2,3,4,11,12]; slots=[7,1,2,3,4,6]
for oid in ids:
    ET.SubElement(components,f'{{{ns}}}component',{'objectid':str(oid),f'{{{pns}}}path':'/3D/Objects/object_1.model','transform':'1 0 0 0 1 0 0 0 1 175 132.5 0'})
xml=['<?xml version="1.0" encoding="UTF-8"?>',f'<model unit="millimeter" xmlns="{ns}" xmlns:BambuStudio="http://schemas.bambulab.com/package/2021"><metadata name="BambuStudio:3mfVersion">1</metadata><resources>']
for oid,mesh,(name,col,poly,z) in zip(ids,meshes,regions):
    xml.append(f'<object id="{oid}" type="model" name="{escape(name)}"><mesh><vertices>')
    xml.extend(f'<vertex x="{x:.6f}" y="{y:.6f}" z="{z:.6f}"/>' for x,y,z in mesh.vertices)
    xml.append('</vertices><triangles>')
    xml.extend(f'<triangle v1="{a}" v2="{b}" v3="{c}"/>' for a,b,c in mesh.faces)
    xml.append('</triangles></mesh></object>')
xml.append('</resources><build/></model>')
settings=ET.fromstring(orig.read('Metadata/model_settings.config'))
panel=settings.find('object[@id="6"]')
panel.clear();panel.set('id','6')
for key,value in [('name','Winking Lion - 108 x 144 mm insert'),('layer_height','.1'),('sparse_infill_density','100%'),('sparse_infill_pattern','zig-zag'),('enable_support','0'),('brim_type','no_brim')]:
    ET.SubElement(panel,'metadata',{'key':key,'value':value})
ET.SubElement(panel,'metadata',{'face_count':str(sum(len(m.faces) for m in meshes))})
for oid,slot,mesh,(name,col,poly,z) in zip(ids,slots,meshes,regions):
    part=ET.SubElement(panel,'part',{'id':str(oid),'subtype':'normal_part'})
    for key,value in [('name',name),('matrix','1 0 0 175 0 1 0 132.5 0 0 1 0 0 0 0 1'),('extruder',str(slot))]:ET.SubElement(part,'metadata',{'key':key,'value':value})
    ET.SubElement(part,'mesh_stat',{'face_count':str(len(mesh.faces)),'edges_fixed':'0','degenerate_facets':'0','facets_removed':'0','facets_reversed':'0','backwards_edges':'0'})

# Keep slots 1 (light guide) and 5 (housing) and their original settings unchanged.
# Slots 3/4 were used only by the removed lithophane, so reuse them for yellow/orange.
project=json.loads(orig.read('Metadata/project_settings.config'))
for k,v in list(project.items()):
    if isinstance(v,list) and k not in ['flush_volumes_matrix','flush_volumes_vector']:
        if len(v)==5:project[k]=v+v[:1]*2
        elif len(v)==10:project[k]=v+v[:2]*2
colors=['#FFFFFF','#0086D6','#FEC600','#FF9016','#222222','#6F5034','#000000']
project['filament_colour']=colors
if 'filament_multi_colour' in project:project['filament_multi_colour']=colors
project['filament_self_index']=[str(i) for i in range(1,8) for _ in range(2)]
oldmatrix=np.array(project['flush_volumes_matrix'],float).reshape(2,5,5)
newmatrix=np.full((2,7,7),500.0)
for nozzle in range(2):
    newmatrix[nozzle,:5,:5]=oldmatrix[nozzle]
    for i in range(7):
        newmatrix[nozzle,i,0]=900 if i in [4,5,6] else 420
        newmatrix[nozzle,i,i]=0
project['flush_volumes_matrix']=[str(int(x)) for x in newmatrix.ravel()]
project['flush_volumes_vector']=['140']*14

updates={'3D/3dmodel.model':ET.tostring(root,encoding='utf-8',xml_declaration=True),
         '3D/Objects/object_1.model':''.join(xml).encode(),
         'Metadata/model_settings.config':ET.tostring(settings,encoding='utf-8',xml_declaration=True),
         'Metadata/project_settings.config':json.dumps(project,indent=2).encode()}
with zipfile.ZipFile(target,'w',zipfile.ZIP_DEFLATED) as dest:
    for info in orig.infolist():dest.writestr(copy.copy(info),updates.get(info.filename,orig.read(info.filename)))

# Prove that both retained objects, their settings, and their placement are identical.
new=zipfile.ZipFile(target)
checks={}
for path in ['3D/Objects/object_2.model','3D/Objects/object_3.model']:
    checks[path]=hashlib.sha256(orig.read(path)).hexdigest()==hashlib.sha256(new.read(path)).hexdigest()
    assert checks[path]
oldroot=ET.fromstring(orig.read('3D/3dmodel.model'));newroot=ET.fromstring(new.read('3D/3dmodel.model'))
oldset=ET.fromstring(orig.read('Metadata/model_settings.config'));newset=ET.fromstring(new.read('Metadata/model_settings.config'))
for oid in [8,10]:
    for path,label in [(f'{{{ns}}}resources/{{{ns}}}object[@id="{oid}"]','assembly'),(f'{{{ns}}}build/{{{ns}}}item[@objectid="{oid}"]','placement')]:
        checks[f'object_{oid}_{label}']=ET.tostring(oldroot.find(path))==ET.tostring(newroot.find(path))
    checks[f'object_{oid}_settings']=ET.tostring(oldset.find(f'object[@id="{oid}"]'))==ET.tostring(newset.find(f'object[@id="{oid}"]'))
assert all(checks.values()),checks
reportdata=dict(source=str(source),output=str(target),insert_size_mm=[108,144,2.5],colored_panes_mm=.8,fit='Original rectangular mounting envelope matched exactly; physical fit untested',parts=report,retained_objects_checks=checks)
(O/'lion-wink-lightbox-validation.json').write_text(json.dumps(reportdata,indent=2))
svg=['<svg xmlns="http://www.w3.org/2000/svg" width="108mm" height="144mm" viewBox="-54 -72 108 144"><g transform="scale(1 -1)">']
for name,col,poly,z in regions:
    paths=[]
    for p in polygons(poly):
        for ring in [p.exterior,*p.interiors]:paths.append('M'+' L'.join(f'{x:.4f},{y:.4f}' for x,y in ring.coords)+' Z')
    svg.append(f'<path fill="{col}" fill-rule="evenodd" d="{" ".join(paths)}"/>')
svg.append('</g></svg>')
(O/'lion-wink-lightbox-manufacturing.svg').write_text(''.join(svg))
with zipfile.ZipFile(O/'lion-wink-lightbox-parts.zip','w',zipfile.ZIP_DEFLATED) as archive:
    for path in parts.glob('*.stl'):archive.write(path,path.name)
print(json.dumps(reportdata,indent=2))

from pathlib import Path
import sys, os, json, copy, zipfile, hashlib, xml.etree.ElementTree as E
sys.path.insert(0,str(Path(__file__).parent/'pydeps'))
import numpy as np, cv2, trimesh
from shapely.geometry import Polygon, box
from shapely.ops import unary_union
from shapely import set_precision
from xml.sax.saxutils import escape

R=Path(__file__).resolve().parents[1]; O=R/'outputs'
stem='corgi-B-arachne-snug'; source=O/'lion-wink-clean-color-separated-nozzles-H2D.3mf'
im=cv2.imread(str(O/'corgi-panel-B-library-palette-v1.png'))
h,w=im.shape[:2]; hsv=cv2.cvtColor(im,cv2.COLOR_BGR2HSV); H,S,V=cv2.split(hsv)
# Treat dark neutral shading in the nose as black, rather than extra colors.
mask=((V>55)&((S>45)|(V>180))).astype('uint8')
count,labels,stats,_=cv2.connectedComponentsWithStats(mask,8)
names=['Jade White','Cyan','Gold','Champagne','Cocoa Brown','Copper Brown Metallic']
cols=['#FFFFFF','#0086D6','#F4A925','#F3CFB2','#6F5034','#AA6443']
masks=[np.zeros((h,w),np.uint8) for _ in names]
cells=[]
classes=np.where(H>75,1,np.where(S<35,0,np.where((S<110)&(V>175),3,np.where((H>=18)&(S>110),2,np.where(V<145,4,5)))))
for cat in range(6):
    raw=cv2.medianBlur(((classes==cat)&(mask>0)).astype('uint8'),3)
    count,labels,stats,_=cv2.connectedComponentsWithStats(raw,8)
    for i in range(1,count):
        if stats[i,cv2.CC_STAT_AREA]<35: continue
        cell=labels==i;masks[cat][cell]=1
        cells.append({'label':i,'color':names[cat],'pixels':int(cell.sum())})
def polys(p):
    if p.is_empty:return []
    return [p] if p.geom_type=='Polygon' else [a for a in p.geoms if a.geom_type=='Polygon' and not a.is_empty]
outline=box(-54.1,-72.1,54.1,72.1); inner=outline.buffer(-2.6,join_style=2)
regions=[]; taken=Polygon()
for name,col,mask in zip(names,cols,masks):
    contours,hier=cv2.findContours(mask,cv2.RETR_CCOMP,cv2.CHAIN_APPROX_SIMPLE); pieces=[]
    def ring(c):
        xy=cv2.approxPolyDP(c,.65,True)[:,0,:].astype(float)
        xy[:,0]=xy[:,0]*108.2/(w-1)-54.1
        xy[:,1]=72.1-xy[:,1]*144.2/(h-1)
        return xy
    if hier is not None:
        for i,c in enumerate(contours):
            if hier[0,i,3]!=-1 or cv2.contourArea(c)<30:continue
            holes=[]; k=hier[0,i,2]
            while k!=-1:
                if cv2.contourArea(contours[k])>80: holes.append(ring(contours[k]))
                k=hier[0,k,0]
            p=Polygon(ring(c),holes).buffer(0)
            pieces.extend(polys(p))
    # Round sub-nozzle tips and remove slivers that Arachne cannot fully fill.
    clean=unary_union(pieces).buffer(-.20,quad_segs=4).buffer(.20,quad_segs=4).simplify(.015,preserve_topology=True)
    clean=unary_union([q for q in polys(clean) if q.area>=.25])
    p=set_precision(clean,.001).intersection(inner).difference(taken)
    regions.append((name,col,p,.8)); taken=unary_union([taken,p])
# Widen black boundaries by 0.12 mm per side for sub-nozzle hairlines.
black=set_precision(outline.difference(taken).buffer(.12,quad_segs=3).intersection(outline),.001)
regions=[(n,c,p.difference(black),z) for n,c,p,z in regions]
regions.insert(0,('Black','#000000',black,2.5))
assert abs(sum(p.area for _,_,p,_ in regions)-outline.area)<1e-5
for i,(_,_,p,_) in enumerate(regions):
    for _,_,q,_ in regions[:i]: assert p.intersection(q).area<1e-6
parts=O/(stem+'-parts');parts.mkdir(exist_ok=True)
meshes=[]; report=[]
for n,c,p,z in regions:
    m=trimesh.util.concatenate([trimesh.creation.extrude_polygon(q,z,engine='earcut') for q in polys(p)])
    assert m.is_watertight and m.is_winding_consistent and m.volume>0,n
    m.export(parts/(n.replace(' ','-')+'.stl'));meshes.append(m)
    report.append(dict(name=n,color=c,height_mm=z,watertight=True,volume_mm3=float(m.volume),triangles=len(m.faces),regions=len(polys(p))))
preview=np.zeros((h,w,3),np.uint8)
svg=['<svg xmlns="http://www.w3.org/2000/svg" width="108.2mm" height="144.2mm" viewBox="-54.1 -72.1 108.2 144.2"><g transform="scale(1 -1)">']
for n,c,p,z in regions:
    paths=[]; bgr=tuple(int(c[j:j+2],16) for j in (5,3,1))
    for q in polys(p):
        rings=[q.exterior,*q.interiors]
        for ring0 in rings:paths.append('M'+' L'.join(f'{x:.4f},{y:.4f}' for x,y in ring0.coords)+' Z')
        def pixels(r):return np.rint([((x+54.1)*(w-1)/108.2,(72.1-y)*(h-1)/144.2) for x,y in r.coords]).astype(np.int32)
        cv2.fillPoly(preview,[pixels(q.exterior)],bgr)
        for r in q.interiors:cv2.fillPoly(preview,[pixels(r)],(0,0,0))
    svg.append(f'<path fill="{c}" fill-rule="evenodd" d="{" ".join(paths)}"/>')
svg.append('</g></svg>');(O/(stem+'-manufacturing.svg')).write_text(''.join(svg))
cv2.imwrite(str(O/(stem+'-preview.png')),preview)

ns='http://schemas.microsoft.com/3dmanufacturing/core/2015/02'; pn='http://schemas.microsoft.com/3dmanufacturing/production/2015/06'
E.register_namespace('',ns);E.register_namespace('p',pn)
base=zipfile.ZipFile(source);root=E.fromstring(base.read('3D/3dmodel.model'));settings=E.fromstring(base.read('Metadata/model_settings.config'))
assembly=root.find(f'{{{ns}}}resources/{{{ns}}}object[@id="7"]'); components=assembly.find(f'{{{ns}}}components');components.clear()
panel=settings.find('object[@id="7"]')
for child in list(panel):
    if child.tag=='part' or child.get('face_count') is not None:panel.remove(child)
panel.find('metadata[@key="name"]').set('value','Corgi B - 108.2 x 144.2 mm - Arachne')
ids=[1,2,3,4,5,6,12];slots=[7,1,2,3,4,6,8]
xml=[f'<?xml version="1.0" encoding="UTF-8"?><model unit="millimeter" xmlns="{ns}"><resources>']
for oid,slot,m,(n,c,p,z) in zip(ids,slots,meshes,regions):
    E.SubElement(components,f'{{{ns}}}component',{'objectid':str(oid),f'{{{pn}}}path':'/3D/Objects/object_1.model','transform':'1 0 0 0 1 0 0 0 1 175 150 0'})
    part=E.SubElement(panel,'part',{'id':str(oid),'subtype':'normal_part'})
    for k,v in [('name',n),('extruder',str(slot)),('matrix','1 0 0 175 0 1 0 150 0 0 1 0 0 0 0 1')]:E.SubElement(part,'metadata',{'key':k,'value':v})
    E.SubElement(part,'mesh_stat',{'face_count':str(len(m.faces)),'edges_fixed':'0','degenerate_facets':'0','facets_removed':'0','facets_reversed':'0','backwards_edges':'0'})
    xml.append(f'<object id="{oid}" type="model" name="{escape(n)}"><mesh><vertices>')
    xml.extend(f'<vertex x="{x:.6f}" y="{y:.6f}" z="{z:.6f}"/>' for x,y,z in m.vertices)
    xml.append('</vertices><triangles>');xml.extend(f'<triangle v1="{a}" v2="{b}" v3="{c}"/>' for a,b,c in m.faces);xml.append('</triangles></mesh></object>')
xml.append('</resources><build/></model>')
settings.findall('plate')[0].find('metadata[@key="plater_name"]').set('value','Corgi B - seven color insert')
settings.findall('plate')[0].find('metadata[@key="filament_map_mode"]').set('value','Manual')
cfg=json.loads(base.read('Metadata/project_settings.config'))
old=copy.deepcopy(cfg)
for k,v in list(cfg.items()):
    if isinstance(v,list) and len(v) in (7,14,21,28) and k not in ['flush_volumes_matrix','different_settings_to_system']:
        stride=len(v)//7;cfg[k]=v+v[5*stride:6*stride]
cfg['different_settings_to_system']=old['different_settings_to_system'][:-1]+['filament_prime_volume;filament_prime_volume_nc',old['different_settings_to_system'][-1]]
for k in ['inherits_group','compatible_printers_condition_group']:
    if k in old and len(old[k])==9:cfg[k]=old[k][:-1]+[old[k][6],old[k][-1]]
profilebase=Path(os.environ['APPDATA'])/'BambuStudio/system/BBL/filament'
def resolve(name):
    d=json.loads((profilebase/(name+'.json')).read_text());result={}
    if d.get('inherits'):result.update(resolve(d['inherits']))
    for inc in d.get('include',[]):result.update(resolve(inc))
    result.update(d);return result
for idx,material in [(2,'Silk+'),(3,'Silk+'),(7,'Metal')]:
    name=f'Bambu PLA {material} @BBL H2D';f=resolve(name)
    for k,v in f.items():
        if isinstance(v,list) and k in cfg and isinstance(cfg[k],list) and len(cfg[k])==8*len(v):cfg[k][idx*len(v):(idx+1)*len(v)]=v
    cfg['filament_settings_id'][idx]=name;cfg['filament_ids'][idx]=f['filament_id']
    cfg['inherits_group'][idx+1]=name
    cfg['different_settings_to_system'][idx+1]='filament_prime_volume;filament_prime_volume_nc'
cfg['filament_colour']=['#FFFFFF','#0086D6','#F4A925','#F3CFB2','#222222','#6F5034','#000000','#AA6443'];cfg['filament_multi_colour']=cfg['filament_colour']
cfg['filament_self_index']=[str(i) for i in range(1,9) for _ in range(3)]
cfg['filament_prime_volume']=['45']*8;cfg['filament_prime_volume_nc']=['90']*8
cfg['filament_map']=['2']*4+['1']*4;cfg['filament_map_mode']='Manual';cfg['filament_nozzle_map']=['2']*4+['1']*4
cfg['flush_volumes_matrix']=[str(0 if i==j else 900 if i in [4,5,6,7] and j in [0,2,3] else 600) for _ in range(2) for i in range(8) for j in range(8)]
cfg['flush_volumes_vector']=['140']*16
updates={'3D/3dmodel.model':E.tostring(root,encoding='utf-8',xml_declaration=True),'3D/Objects/object_1.model':''.join(xml).encode(),'Metadata/model_settings.config':E.tostring(settings,encoding='utf-8',xml_declaration=True),'Metadata/project_settings.config':json.dumps(cfg,indent=2).encode()}
target=O/(stem+'-H2D.3mf')
with zipfile.ZipFile(target,'w',zipfile.ZIP_DEFLATED) as out:
    for item in base.infolist():
        n=item.filename
        if n.endswith(('.gcode','.gcode.md5','.png')) or n=='Metadata/slice_info.config' or n.startswith('Metadata/plate_') and n.endswith('.json'):continue
        out.writestr(copy.copy(item),updates.get(n,base.read(n)))
with zipfile.ZipFile(target) as out:
    assert out.testzip() is None
    for n in ['3D/Objects/object_2.model','3D/Objects/object_3.model']:assert out.read(n)==base.read(n)
original_settings=E.fromstring(base.read('Metadata/model_settings.config'))
for oid in ['9','11']:assert E.tostring(settings.find(f'object[@id="{oid}"]'))==E.tostring(original_settings.find(f'object[@id="{oid}"]'))
result=dict(source=source.name,project=target.name,dimensions_mm=[108.2,144.2,2.5],colored_panes_mm=.8,parts=report,partition_area_mm2=outline.area,overlap_area_mm2=0,uncovered_area_mm2=0,retained_housing_and_guide_unchanged=True,black_boundary_expansion_mm=.12,outer_border_min_mm=2.6,slots=cfg['filament_colour'],nozzle_groups={'left':['Cocoa Brown','Black','Copper Brown Metallic'],'right':['Jade White','Cyan','Gold','Champagne']},slicer_validated=False,print_started=False,physical_result_validated=False,sha256=hashlib.sha256(target.read_bytes()).hexdigest(),cells=cells)
result.update(color_tip_rounding_radius_mm=.2,minimum_color_polygon_before_partition_mm2=.25)
(O/(stem+'-validation.json')).write_text(json.dumps(result,indent=2))
with zipfile.ZipFile(O/(stem+'-parts.zip'),'w',zipfile.ZIP_DEFLATED) as out:
    for p in parts.glob('*.stl'):out.write(p,p.name)
print(json.dumps({k:v for k,v in result.items() if k!='cells'},indent=2))

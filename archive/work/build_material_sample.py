"""Seven-filament thickness ladder and 1:1 corgi junction crops; no printer actions."""
from pathlib import Path
import sys,json,re,zipfile,copy,hashlib,xml.etree.ElementTree as E
sys.path.insert(0,str(Path(__file__).parent/'pydeps'))
import numpy as np,trimesh
from shapely.geometry import Polygon,box
from shapely.ops import unary_union
from shapely.affinity import translate
from PIL import Image,ImageDraw,ImageFont
R=Path(__file__).resolve().parents[1];O=R/'outputs';stem='corgi-material-sample'
names=['Jade White','Cyan','Gold','Champagne','Cocoa Brown','Copper Brown Metallic','Black']
colors=['#FFFFFF','#0086D6','#F4A925','#F3CFB2','#6F5034','#AA6443','#000000'];slots=[1,2,3,4,6,8,7]
outline=Polygon([(0,0),(86,0),(86,52),(2,52),(0,50)])
regions=[[] for _ in names];windows=[]
for row,(y,z) in enumerate([(42,.6),(32,.8),(22,1.)]):
    for col in range(7):
        p=box(2+12*col,y,12+12*col,y+8);regions[col].append((p,z));windows.append(p)
svg=E.parse(O/'corgi-B-arachne-snug-manufacturing.svg')
source_polys={}
for path in svg.findall('.//{http://www.w3.org/2000/svg}path'):
    p=Polygon()
    for ring in re.findall(r'M([^Z]+)Z',path.get('d')):
        xy=np.array([float(v) for v in re.findall(r'-?\d+(?:\.\d+)?',ring)]).reshape(-1,2)
        q=Polygon(xy)
        p=p.symmetric_difference(q)
    source_polys[path.get('fill')]=p
crops=[('Eye',(-4,3,22,19)),('Muzzle',(22,-17,48,-1)),('Chest',(-5,-52,21,-36))]
for j,(name,bounds) in enumerate(crops):
    clip=box(*bounds);dest=box(2+28*j,2,28+28*j,18);windows.append(dest)
    for i,col in enumerate(colors):
        p=translate(source_polys[col].intersection(clip),xoff=2+28*j-bounds[0],yoff=2-bounds[1])
        if not p.is_empty:regions[i].append((p,2.5 if col=='#000000' else .8))
regions[6].append((outline.difference(unary_union(windows)),2.5))
def polygons(p):
    if p.is_empty:return []
    return [p] if p.geom_type=='Polygon' else [q for g in p.geoms for q in polygons(g)] if hasattr(p,'geoms') else []
footprints=[unary_union([p for p,z in rs]) for rs in regions]
assert abs(unary_union(footprints).area-outline.area)<1e-5
for i,p in enumerate(footprints):
    for q in footprints[:i]:assert p.intersection(q).area<1e-6
meshes=[];report=[]
for name,rs in zip(names,regions):
    pieces=[trimesh.creation.extrude_polygon(q,z,engine='earcut') for p,z in rs for q in polygons(p) if q.area>1e-8]
    m=trimesh.boolean.union(pieces,engine='manifold') if name=='Black' else trimesh.util.concatenate(pieces)
    assert m.is_watertight and m.is_winding_consistent and m.volume>0,name
    m.apply_translation([-43,-26,0]);meshes.append(m)
    report.append(dict(name=name,watertight=True,volume_mm3=float(m.volume),triangles=len(m.faces)))
ns='http://schemas.microsoft.com/3dmanufacturing/core/2015/02';pn='http://schemas.microsoft.com/3dmanufacturing/production/2015/06'
E.register_namespace('',ns);E.register_namespace('p',pn)
source=O/'corgi-B-arachne-snug-v2-verified-H2D.3mf';base=zipfile.ZipFile(source)
root=E.fromstring(base.read('3D/3dmodel.model'));settings=E.fromstring(base.read('Metadata/model_settings.config'))
resources=root.find(f'{{{ns}}}resources');assembly=resources.find(f'{{{ns}}}object[@id="8"]')
for child in list(resources):
    if child is not assembly:resources.remove(child)
components=assembly.find(f'{{{ns}}}components');components.clear()
build=root.find(f'{{{ns}}}build')
for item in list(build):
    if item.get('objectid')!='8':build.remove(item)
panel=settings.find('object[@id="8"]');plate=settings.find('plate')
for item in list(settings):
    if item is not panel and item is not plate:settings.remove(item)
for item in list(panel):
    if item.tag=='part' or item.get('face_count') is not None:panel.remove(item)
panel.find('metadata[@key="name"]').set('value','Corgi materials - 86 x 52 mm - thickness and junction test')
plate.find('metadata[@key="plater_name"]').set('value','Material sample only')
xml=[f'<?xml version="1.0" encoding="UTF-8"?><model unit="millimeter" xmlns="{ns}"><resources>']
for oid,(name,slot,m) in enumerate(zip(names,slots,meshes),1):
    E.SubElement(components,f'{{{ns}}}component',{'objectid':str(oid),f'{{{pn}}}path':'/3D/Objects/object_1.model','transform':'1 0 0 0 1 0 0 0 1 175 150 0'})
    part=E.SubElement(panel,'part',{'id':str(oid),'subtype':'normal_part'})
    for k,v in [('name',name),('extruder',str(slot)),('matrix','1 0 0 175 0 1 0 150 0 0 1 0 0 0 0 1')]:E.SubElement(part,'metadata',{'key':k,'value':v})
    E.SubElement(part,'mesh_stat',{'face_count':str(len(m.faces)),'edges_fixed':'0','degenerate_facets':'0','facets_removed':'0','facets_reversed':'0','backwards_edges':'0'})
    xml.append(f'<object id="{oid}" type="model" name="{name}"><mesh><vertices>')
    xml.extend(f'<vertex x="{x:.6f}" y="{y:.6f}" z="{z:.6f}"/>' for x,y,z in m.vertices)
    xml.append('</vertices><triangles>');xml.extend(f'<triangle v1="{a}" v2="{b}" v3="{c}"/>' for a,b,c in m.faces);xml.append('</triangles></mesh></object>')
xml.append('</resources><build/></model>')
updates={'3D/3dmodel.model':E.tostring(root,encoding='utf-8',xml_declaration=True),'3D/Objects/object_1.model':''.join(xml).encode(),'Metadata/model_settings.config':E.tostring(settings,encoding='utf-8',xml_declaration=True)}
cfg=json.loads(base.read('Metadata/project_settings.config'))
cfg['wipe_tower_x']=['40'];cfg['wipe_tower_y']=['210']
updates['Metadata/project_settings.config']=json.dumps(cfg,indent=2).encode()
target=O/(stem+'-H2D.3mf')
with zipfile.ZipFile(target,'w',zipfile.ZIP_DEFLATED) as out:
    for item in base.infolist():
        n=item.filename
        if n.endswith(('.png','.gcode','.gcode.md5')) or n=='Metadata/slice_info.config' or n.startswith('Metadata/plate_') and n.endswith('.json'):continue
        if n in ['3D/Objects/object_2.model','3D/Objects/object_3.model']:continue
        if n.endswith('.rels') and n.startswith('3D/'):
            # Studio's relationship reader requires an unprefixed default namespace.
            E.register_namespace('','http://schemas.openxmlformats.org/package/2006/relationships')
            rel=E.fromstring(base.read(n))
            for child in list(rel):
                if child.get('Target','').endswith(('object_2.model','object_3.model')):rel.remove(child)
            out.writestr(n,E.tostring(rel,encoding='utf-8',xml_declaration=True));continue
        out.writestr(copy.copy(item),updates.get(n,base.read(n)))
im=Image.new('RGB',(1120,900),'#f1f2f4');d=ImageDraw.Draw(im)
font=ImageFont.truetype('C:/Windows/Fonts/arial.ttf',22);small=ImageFont.truetype('C:/Windows/Fonts/arial.ttf',17)
def xy(x,y):return (100+10*x,100+10*(52-y))
d.polygon([xy(x,y) for x,y in outline.exterior.coords],fill='black')
for rs,col in [(regions[6],colors[6])]+list(zip(regions[:6],colors[:6])):
    for p,z in rs:
        for q in polygons(p):
            d.polygon([xy(x,y) for x,y in q.exterior.coords],fill=col)
            for ring in q.interiors:d.polygon([xy(x,y) for x,y in ring.coords],fill='black')
for i in range(7):d.text((165+120*i,70),str(i+1),fill='black',font=font,anchor='mm')
for y,label in [(46,'0.6 mm'),(36,'0.8 mm'),(26,'1.0 mm')]:d.text((90,xy(0,y)[1]),label,fill='black',font=small,anchor='rm')
for j,(name,_) in enumerate(crops):d.text((240+280*j,635),name+' (1:1)',fill='black',font=small,anchor='mm')
d.text((100,22),'MATERIAL SAMPLE | clipped corner at upper left | raised side facing you',fill='black',font=font)
for i,name in enumerate(names):d.text((100+(i//4)*510,685+(i%4)*35),f'{i+1}. {name}',fill='black',font=font)
d.text((100,855),'Printed coupon: 86 x 52 mm. Numbers and text are a separate guide, not printed.',fill='black',font=small)
im.save(O/(stem+'-guide.png'))
result=dict(source=source.name,project=target.name,dimensions_mm=[86,52,2.5],swatch_dimensions_mm=[10,8],rows_top_to_bottom_mm=[.6,.8,1.],columns_left_to_right=names,junction_crops=crops,parts=report,modeled_gap_area_mm2=0,modeled_overlap_area_mm2=0,slicer_validated=False,print_started=False,physical_result_validated=False,sha256=hashlib.sha256(target.read_bytes()).hexdigest())
(O/(stem+'-validation.json')).write_text(json.dumps(result,indent=2))
print(json.dumps({k:v for k,v in result.items() if k!='parts'},indent=2))

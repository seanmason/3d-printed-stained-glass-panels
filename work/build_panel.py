import sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).parent/'pydeps'))
import numpy as np, cv2, trimesh, json, zipfile
from shapely.geometry import Polygon, box, MultiPolygon
from shapely.ops import unary_union
from shapely import set_precision
from xml.sax.saxutils import escape

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'outputs'; PARTS=OUT/'lion-panel-parts'; PARTS.mkdir(exist_ok=True)
im=cv2.imread(str(OUT/'lion-panel-concept-v5.png'))
h,w=im.shape[:2]; scale=200/w
hsv=cv2.cvtColor(im,cv2.COLOR_BGR2HSV); H,S,V=cv2.split(hsv)
# Extract closed colored cells; all unoccupied area becomes the solid black framework.
masks=[(V>110)&(S<65), (H>75)&(H<115)&(S>100)&(V>100),
       (H>=20)&(H<40)&(S>100)&(V>150),
       (H>=5)&(H<25)&(S>100)&(V>175),
       (H>=3)&(H<30)&(S>65)&(V>45)&(V<=175)]
names=['Jade White','Cyan','Sunflower Yellow','Pumpkin Orange','Cocoa Brown']
hexes=['#FFFFFF','#0086D6','#FEC600','#FF9016','#6F5034']
# Classify whole enclosed cells, not individual gradient pixels. This avoids
# spurious internal seams from the concept image's subtle shading.
count,labels,stats,centers=cv2.connectedComponentsWithStats((V>75).astype('uint8'),8)
masks=[np.zeros((h,w),dtype=bool) for _ in names]
for label in range(1,count):
    cell=labels==label
    if stats[label,cv2.CC_STAT_AREA]<30: continue
    mh,ms,mv=np.median(H[cell]),np.median(S[cell]),np.median(V[cell])
    category=0 if ms<65 else 1 if mh>75 else 2 if mh>=22 else 3 if mv>175 else 4
    masks[category]|=cell
regions=[]; taken=Polygon()
for name,col,mask in zip(names,hexes,masks):
    cs, hier=cv2.findContours(mask.astype('uint8'),cv2.RETR_CCOMP,cv2.CHAIN_APPROX_SIMPLE)
    polys=[]
    for i,c in enumerate(cs):
        if hier[0,i,3]!=-1 or cv2.contourArea(c)<30: continue
        def ring(cont):
            points=cv2.approxPolyDP(cont,0.55,True)[:,0,:].astype(float)
            points[:,0]*=scale; points[:,1]=(h-1-points[:,1])*scale
            return points
        holes=[]; k=hier[0,i,2]
        while k!=-1:
            if cv2.contourArea(cs[k])>8: holes.append(ring(cs[k]))
            k=hier[0,k,0]
        p=Polygon(ring(c),holes).buffer(0)
        if p.area>0.5: polys.append(p)
    p=set_precision(unary_union(polys),0.001).difference(taken)
    regions.append((name,col,p,0.8)); taken=unary_union([taken,p])
# Rounded outer corners, black to the very edge; 200 mm exact outside size.
outline=box(2,2,198,198).buffer(2,quad_segs=12)
regions=[(n,c,p.intersection(outline),z) for n,c,p,z in regions]
outline=set_precision(outline,0.001)
black=outline.difference(unary_union([r[2] for r in regions]))
# Resolve zero-width black junctions with a 0.025 mm contour expansion; this
# tiny cleanup also rounds subpixel contour defects without changing artwork.
black=black.buffer(0.025,quad_segs=3).intersection(outline)
regions=[(n,c,p.difference(black),z) for n,c,p,z in regions]
regions.insert(0,('Black','#000000',black,2.4))
meshes=[]; report=[]
def polygons(p):
    return [p] if p.geom_type=='Polygon' else [g for g in p.geoms if g.geom_type=='Polygon']
for idx,(name,col,poly,z) in enumerate(regions,1):
    ms=[trimesh.creation.extrude_polygon(p,z,engine='earcut') for p in polygons(poly)]
    mesh=trimesh.util.concatenate(ms)
    print(name,len(ms),mesh.is_watertight,mesh.is_winding_consistent,mesh.volume,[(j,m.is_watertight,len(m.faces)) for j,m in enumerate(ms) if not m.is_watertight])
    if not mesh.is_watertight:
        unique,counts=np.unique(mesh.edges_sorted,axis=0,return_counts=True)
        print('bad edges',[(mesh.vertices[e].tolist(),int(c)) for e,c in zip(unique[counts!=2][:12],counts[counts!=2][:12])])
    assert mesh.is_watertight and mesh.is_winding_consistent and mesh.volume>0,(name,'invalid mesh')
    mesh.export(PARTS/f'{idx:02d}-{name.replace(" ","-")}.stl')
    meshes.append(mesh)
    report.append(dict(part=idx,name=name,color=col,height_mm=z,area_mm2=poly.area,volume_mm3=mesh.volume,watertight=bool(mesh.is_watertight),shells=len(ms),triangles=len(mesh.faces)))
assert abs(sum(x[2].area for x in regions)-outline.area)<1e-5
for i in range(len(regions)):
    for j in range(i): assert regions[i][2].intersection(regions[j][2]).area<1e-6
# Standard 3MF with one assembly and named material-assigned component meshes.
def make3mf(path, regs, meshlist):
    xml=['<?xml version="1.0" encoding="UTF-8"?>','<model unit="millimeter" xml:lang="en-US" xmlns="http://schemas.microsoft.com/3dmanufacturing/core/2015/02">','<metadata name="Title">Lion stained glass panel — 200 mm</metadata>','<resources><basematerials id="1">']
    for name,col,poly,z in regs: xml.append(f'<base name="{escape(name)}" displaycolor="{col}FF"/>')
    xml.append('</basematerials>')
    for i,(m,reg) in enumerate(zip(meshlist,regs)):
        xml.append(f'<object id="{i+2}" type="model" name="{escape(reg[0])}" pid="1" pindex="{i}"><mesh><vertices>')
        xml.extend(f'<vertex x="{x:.6f}" y="{y:.6f}" z="{z:.6f}"/>' for x,y,z in m.vertices)
        xml.append('</vertices><triangles>')
        xml.extend(f'<triangle v1="{a}" v2="{b}" v3="{c}"/>' for a,b,c in m.faces)
        xml.append('</triangles></mesh></object>')
    xml.append('<object id="20" type="model" name="Lion Panel 200mm"><components>')
    xml.extend(f'<component objectid="{i+2}"/>' for i in range(len(meshlist)))
    xml.append('</components></object></resources><build><item objectid="20"/></build></model>')
    config=['<?xml version="1.0" encoding="UTF-8"?><config><object id="20"><metadata key="name" value="Lion Panel 200mm"/>']
    for i,r in enumerate(regs): config.append(f'<part id="{i+2}" subtype="normal_part"><metadata key="name" value="{escape(r[0])}"/><metadata key="extruder" value="{i+1}"/></part>')
    config.append('</object></config>')
    with zipfile.ZipFile(path,'w',zipfile.ZIP_DEFLATED) as f:
        f.writestr('[Content_Types].xml','<?xml version="1.0"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="model" ContentType="application/vnd.ms-package.3dmanufacturing-3dmodel+xml"/></Types>')
        f.writestr('_rels/.rels','<?xml version="1.0"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Target="/3D/3dmodel.model" Id="rel0" Type="http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel"/></Relationships>')
        f.writestr('3D/3dmodel.model',''.join(xml))
        f.writestr('Metadata/model_settings.config',''.join(config))
make3mf(OUT/'lion-panel-200mm.3mf',regions,meshes)
# Vector manufacturing outline for exact editable region geometry and visual QA.
svg=['<svg xmlns="http://www.w3.org/2000/svg" width="200mm" height="200mm" viewBox="0 0 200 200">','<g transform="translate(0 200) scale(1 -1)">']
for name,col,poly,z in regions:
    paths=[]
    for p in polygons(poly):
        for ring in [p.exterior,*p.interiors]:
            coords=list(ring.coords); paths.append('M'+' L'.join(f'{x:.4f},{y:.4f}' for x,y in coords)+' Z')
    svg.append(f'<path fill="{col}" fill-rule="evenodd" d="{" ".join(paths)}"/>')
svg.append('</g></svg>'); (OUT/'lion-panel-manufacturing.svg').write_text(''.join(svg))
(OUT/'lion-panel-validation.json').write_text(json.dumps({'size_mm':[200,200,2.4],'colored_pane_thickness_mm':0.8,'footprint_partition_gap_mm2':outline.area-sum(r[2].area for r in regions),'parts':report},indent=2))
print(json.dumps(report,indent=2))

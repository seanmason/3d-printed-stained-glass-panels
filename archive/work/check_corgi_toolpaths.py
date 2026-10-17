from pathlib import Path
import sys,json,zipfile,re,math,xml.etree.ElementTree as E
sys.path.insert(0,str(Path(__file__).parent/'pydeps'))
import numpy as np
from PIL import Image,ImageDraw
R=Path(__file__).resolve().parents[1];O=R/'outputs';stem='corgi-B-arachne-snug'
with zipfile.ZipFile(O/(stem+'-v2-sliced.gcode.3mf')) as archive:
    data=archive.read('Metadata/plate_1.gcode').decode()
    info=E.fromstring(archive.read('Metadata/slice_info.config'))
    target=int(info.find('plate/object').get('identify_id'))
segments=[];x=y=zpos=0.;layerz=0.;width=.42;tool=6;oid=None;relative=True;eabs=0
for line in data.splitlines():
    if line.startswith('; Z_HEIGHT: '):layerz=float(line.split(':')[1])
    if line.startswith('; LINE_WIDTH: '):width=float(line.split(':')[1])
    if line.startswith('; start printing object, unique label id: '):oid=int(line.rsplit(':',1)[1])
    if line.startswith('; stop printing object'):oid=None
    if re.match(r'^T\d+',line):tool=int(re.match(r'^T(\d+)',line)[1])
    if line.startswith('M82'):relative=False
    if line.startswith('M83'):relative=True
    if line.startswith('G92 E'):eabs=float(line.split('E')[1].split()[0])
    if not re.match(r'^G[0123] ',line):continue
    vals={k:float(v) for k,v in re.findall(r'([XYZEIJ])(-?\d*\.?\d+)',line.split(';')[0])}
    nx=vals.get('X',x);ny=vals.get('Y',y);nz=vals.get('Z',zpos)
    e=vals.get('E',0) if relative else vals.get('E',eabs)-eabs
    if not relative:eabs=vals.get('E',eabs)
    if layerz>0 and 120.5<=x<=229.5 and 77.5<=y<=222.5 and 120.5<=nx<=229.5 and 77.5<=ny<=222.5 and e>0 and ('X' in vals or 'Y' in vals) and abs(nz-layerz)<1e-5 and (nx-x)**2+(ny-y)**2>1e-8:
        assert not line.startswith(('G2 ','G3 ')), 'Arc fitting should be disabled'
        segments.append((layerz,tool,x,y,nx,ny,width))
    x,y,zpos=nx,ny,nz
assert len(segments)>10000
colors={0:'#FFFFFF',1:'#0086D6',2:'#F4A925',3:'#F3CFB2',5:'#6F5034',6:'#000000',7:'#AA6443'}
scale=25;nx=round(108.2*scale);ny=round(144.2*scale)
mask=Image.new('L',(nx,ny),0);draw=ImageDraw.Draw(mask)
preview=Image.new('RGB',(nx,ny),'#ff66bb');pd=ImageDraw.Draw(preview)
def pixel(x,y):return (round((x-120.9)*scale),round((222.1-y)*scale))
for zz,t,x1,y1,x2,y2,w in segments:
    a,b=pixel(x1,y1),pixel(x2,y2);ww=max(1,round(w*scale));r=ww/2
    draw.line([a,b],fill=255,width=ww)
    for xx,yy in [a,b]:draw.ellipse((xx-r,yy-r,xx+r,yy+r),fill=255)
    # Composite nominal topmost extrusions in print order.
    pd.line([a,b],fill=colors[t],width=ww)
    for xx,yy in [a,b]:pd.ellipse((xx-r,yy-r,xx+r,yy+r),fill=colors[t])
preview.resize((1082,1442),Image.Resampling.LANCZOS).save(O/(stem+'-toolpath-preview.png'))
arr=np.array(mask);trim=round(.5*scale);missing=int(np.count_nonzero(arr[trim:-trim,trim:-trim]==0))
report=json.loads((O/(stem+'-validation.json')).read_text())
report.update(extrusion_segments_checked=len(segments),nominal_projected_void_area_mm2=missing/(scale*scale),projection_resolution_mm=1/scale,projection_excludes_perimeter_mm=.5,projection_limit='Nominal extrusion widths across all layers, not a physical pinhole guarantee.')
(O/(stem+'-validation.json')).write_text(json.dumps(report,indent=2))
print(json.dumps({k:report[k] for k in ['extrusion_segments_checked','nominal_projected_void_area_mm2','projection_resolution_mm']}))

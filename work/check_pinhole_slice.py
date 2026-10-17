from pathlib import Path
import re,json,zipfile,sys,hashlib,math,xml.etree.ElementTree as E
from PIL import Image,ImageDraw
R=Path(__file__).resolve().parents[1]; O=R/'outputs'
with zipfile.ZipFile(O/'lion-pinhole-test-v2-sliced.gcode.3mf') as z:
    data=z.read('Metadata/plate_1.gcode').decode()
    slice_xml=E.fromstring(z.read('Metadata/slice_info.config'))
    labels={o.get('name')[0]:int(o.get('identify_id')) for o in slice_xml.findall('plate/object')}
    aid,bid=labels['A'],labels['B']
    (R/'work/pinhole-slice-info.xml').write_text(E.tostring(slice_xml,encoding='unicode'))
assert '; FEATURE: Ironing' not in data
heights=[float(x) for x in re.findall(r'^; Z_HEIGHT: ([0-9.]+)',data,re.M)]
assert len(heights)==24 and heights[0]==.2 and heights[-1]==2.5
assert all(abs(b-a-.1)<1e-6 for a,b in zip(heights,heights[1:]))
with zipfile.ZipFile(O/'lion-pinhole-test-v2-ready-H2D.3mf') as z:
    p=json.loads(z.read('Metadata/project_settings.config'))
    objects=E.fromstring(z.read('Metadata/model_settings.config')).findall('object')
    for ob in objects:
        cfg={m.get('key'):m.get('value') for m in ob.findall('metadata') if m.get('key')}
        assert all(cfg[k]==v for k,v in {'layer_height':'0.1','wall_generator':'arachne','seam_gap':'0%','ironing_type':'no ironing','top_surface_speed':'50','gap_infill_speed':'30'}.items()),cfg
    plate=json.loads(z.read('Metadata/plate_1.json'))
    xmin,ymin,xmax,ymax=plate['bbox_all'];assert 25<=xmin<xmax<=325 and 0<=ymin<ymax<=320

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
    vals={k:float(v) for k,v in re.findall(r'([XYZ EIJ])(-?\d*\.?\d+)',line.split(';')[0])}
    nx=vals.get('X',x);ny=vals.get('Y',y);nz=vals.get('Z',zpos)
    e=vals.get('E',0) if relative else vals.get('E',eabs)-eabs
    if not relative:eabs=vals.get('E',eabs)
    if oid in [aid,bid] and e>0 and ('X' in vals or 'Y' in vals) and abs(nz-layerz)<1e-5 and (nx-x)**2+(ny-y)**2>1e-8:
        if line.startswith(('G2 ','G3 ')):
            assert 'I' in vals or 'J' in vals,line
            acx,acy=x+vals.get('I',0),y+vals.get('J',0)
            radius=math.hypot(x-acx,y-acy)
            a0=math.atan2(y-acy,x-acx);a1=math.atan2(ny-acy,nx-acx)
            sweep=(a1-a0)%(2*math.pi)
            if line.startswith('G2 '):sweep=-((a0-a1)%(2*math.pi))
            steps=max(1,math.ceil(abs(sweep)/.02),math.ceil(abs(sweep)*radius/.04))
            px,py=x,y
            for j in range(1,steps+1):
                ang=a0+sweep*j/steps
                qx,qy=(nx,ny) if j==steps else (acx+radius*math.cos(ang),acy+radius*math.sin(ang))
                segments.append((oid,layerz,tool,px,py,qx,qy,width));px,py=qx,qy
        else:
            assert line.startswith('G1 '),line
            segments.append((oid,layerz,tool,x,y,nx,ny,width))
    x,y,zpos=nx,ny,nz
assert len(segments)>10000
cols={0:'#FFFFFF',2:'#FEC600',3:'#0086D6',5:'#5B6579',6:'#000000'}
# Enlarged toolpaths around the upper left muzzle junction; pink is uncovered.
im=Image.new('RGB',(1340,1420),'#eeeeee');draw=ImageDraw.Draw(im)
scale=72;size=576
for row,zvalue in enumerate([.2,.8]):
    for col,(oid,cx) in enumerate([(aid,140),(bid,200)]):
        ox=45+col*675;oy=55+row*700
        draw.rectangle((ox,oy,ox+size,oy+size),fill='#ee88aa')
        def xy(xx,yy):return (round(ox+(xx-cx+6)*scale),round(oy+(7-(yy-160))*scale))
        tile=Image.new('RGB',(size,size),'#ee88aa');td=ImageDraw.Draw(tile)
        for ob,zz,t,x1,y1,x2,y2,w in segments:
            if ob!=oid or abs(zz-zvalue)>1e-6:continue
            a=xy(x1,y1);b=xy(x2,y2);a=(a[0]-ox,a[1]-oy);b=(b[0]-ox,b[1]-oy)
            widthpx=max(1,round(w*scale));r=widthpx/2
            td.line([a,b],fill=cols[t],width=widthpx)
            for xx,yy in [a,b]:td.ellipse((xx-r,yy-r,xx+r,yy+r),fill=cols[t])
        im.paste(tile,(ox,oy))
        draw.text((ox,oy-25),f'{"A - slicer only" if col==0 else "B - rounded + ledge"}: Z {zvalue:.1f} mm',fill='black')
        draw.text((ox,oy+size+12),'8 x 8 mm detail; nominal extrusion widths',fill='black')
im.save(O/'lion-pinhole-test-toolpaths.png')
# Project every printed layer to find nominal straight-through voids, rather
# than treating a gap in a single layer as a hole through the entire panel.
import numpy as np
projection=Image.new('RGB',(1340,700),'#eeeeee');pd=ImageDraw.Draw(projection)
through=[]
for col,(oid,cx) in enumerate([(aid,140),(bid,200)]):
    mask=Image.new('L',(size,size),0);md=ImageDraw.Draw(mask)
    for ob,zz,t,x1,y1,x2,y2,w in segments:
        if ob!=oid:continue
        a=(round((x1-cx+6)*scale),round((7-(y1-160))*scale))
        b=(round((x2-cx+6)*scale),round((7-(y2-160))*scale))
        ww=max(1,round(w*scale));r=ww/2
        md.line([a,b],fill=255,width=ww)
        for xx,yy in [a,b]:md.ellipse((xx-r,yy-r,xx+r,yy+r),fill=255)
    arr=np.array(mask);missing=int(np.count_nonzero(arr[40:-40,40:-40]==0))
    through.append({'sample':'AB'[col],'nominal_through_void_area_mm2_in_detail':missing/(scale*scale),'detail_mm':[-6,-1,2,7]})
    ox=45+675*col;oy=55
    tile=Image.new('RGB',(size,size),'#ee88aa');tile.paste('#333333',mask=mask)
    projection.paste(tile,(ox,oy));pd.text((ox,25),f'{"AB"[col]} - all layers projected; pink = nominal through void',fill='black')
projection.save(O/'lion-pinhole-test-through-void-check.png')
report=json.loads((O/'lion-pinhole-test-validation.json').read_text())
report.update({'ready_project':str(O/'lion-pinhole-test-v2-ready-H2D.3mf'),'sliced_plate':str(O/'lion-pinhole-test-v2-sliced.gcode.3mf'),'slicer_validated':True,'ironing_toolpaths_absent':True,'actual_layer_heights_mm':heights,'slice_plate_metadata':plate,'extrusion_segments_checked':len(segments),'nominal_through_void_checks':through,'estimated_time_seconds':int(slice_xml.find('plate/metadata[@key="prediction"]').get('value')),'estimated_filament_g':float(slice_xml.find('plate/metadata[@key="weight"]').get('value')),'ready_project_sha256':hashlib.sha256((O/'lion-pinhole-test-v2-ready-H2D.3mf').read_bytes()).hexdigest()})
(O/'lion-pinhole-test-validation.json').write_text(json.dumps(report,indent=2))
print(json.dumps({k:report[k] for k in ['slicer_validated','ironing_toolpaths_absent','actual_layer_heights_mm','extrusion_segments_checked','estimated_time_seconds','estimated_filament_g']},indent=2))

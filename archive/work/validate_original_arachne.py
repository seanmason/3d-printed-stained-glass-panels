from pathlib import Path
import sys,json,zipfile,re,hashlib,xml.etree.ElementTree as E
sys.path.insert(0,str(Path(__file__).parent/'pydeps'))
import numpy as np,trimesh
R=Path(__file__).resolve().parents[1];O=R/'outputs';ns='http://schemas.microsoft.com/3dmanufacturing/core/2015/02';pns='http://schemas.microsoft.com/3dmanufacturing/production/2015/06'
rp=O/'lion-original-arachne-snug-validation.json';report=json.loads(rp.read_text())
ready=O/'lion-original-arachne-snug-ready-H2D.3mf';sliced=O/'lion-original-arachne-snug-sliced.gcode.3mf'
with zipfile.ZipFile(ready) as z:
    root=E.fromstring(z.read('3D/3dmodel.model'));settings=E.fromstring(z.read('Metadata/model_settings.config'))
    panel=next(o for o in settings.findall('object') if o.find('metadata[@key="name"]').get('value').startswith('Original Lion'))
    cfg={m.get('key'):m.get('value') for m in panel.findall('metadata') if m.get('key')}
    assert all(cfg.get(k)==v for k,v in report['settings'].items()),cfg
    def matrix(txt):
        m=np.eye(4)
        if txt:m[:,:3]=np.array(list(map(float,txt.split()))).reshape(4,3)
        return m
    def flatten(file,oid,parent):
        model=root if file=='3D/3dmodel.model' else E.fromstring(z.read(file))
        ob=model.find(f'{{{ns}}}resources/{{{ns}}}object[@id="{oid}"]')
        mesh=ob.find(f'{{{ns}}}mesh')
        if mesh is not None:
            vv=np.array([[float(v.get(k)) for k in ['x','y','z']] for v in mesh.find(f'{{{ns}}}vertices')]);ff=np.array([[int(f.get(k)) for k in ['v1','v2','v3']] for f in mesh.find(f'{{{ns}}}triangles')]);vv=(np.c_[vv,np.ones(len(vv))]@parent)[:,:3]
            m=trimesh.Trimesh(vv,ff,process=True);assert m.is_watertight and m.is_winding_consistent
            return [m]
        result=[]
        for c in ob.find(f'{{{ns}}}components'):result+=flatten(c.get(f'{{{pns}}}path',file).lstrip('/'),c.get('objectid'),matrix(c.get('transform'))@parent)
        return result
    item=root.find(f'{{{ns}}}build/{{{ns}}}item[@objectid="{panel.get("id")}"]')
    meshes=flatten('3D/3dmodel.model',panel.get('id'),matrix(item.get('transform')))
    vv=np.vstack([m.vertices for m in meshes]);bounds=np.array([vv.min(0),vv.max(0)]);size=bounds[1]-bounds[0]
    assert np.allclose(size,[108.2,144.2,2.5],atol=.0001),size
    assert len(meshes)==6
    plate=json.loads(z.read('Metadata/plate_1.json'));assert len(plate['bbox_objects'])==2
    x0,y0,x1,y1=plate['bbox_all'];assert 25<=x0<x1<=325 and 0<=y0<y1<=320
with zipfile.ZipFile(sliced) as z:
    data=z.read('Metadata/plate_1.gcode').decode();info=E.fromstring(z.read('Metadata/slice_info.config')).find('plate')
    heights=[float(x) for x in re.findall(r'^; Z_HEIGHT: ([0-9.]+)',data,re.M)]
    assert heights==[round(.2+.1*i,1) for i in range(24)]
    assert '; FEATURE: Ironing' not in data
    assert len(info.findall('object'))==1 and info.find('metadata[@key="outside"]').get('value')=='false'
    assert {f.get('id') for f in info.findall('filament')}=={'1','2','3','4','6','7'}
report.update(ready_project=str(ready),sliced_plate=str(sliced),slicer_validated=True,native_serialized_geometry_validated=True,native_dimensions_mm=size.tolist(),native_bounds_mm=bounds.tolist(),plate_metadata=plate,actual_layer_heights_mm=heights,ironing_toolpaths_absent=True,estimated_time_seconds=int(info.find('metadata[@key="prediction"]').get('value')),estimated_filament_g=float(info.find('metadata[@key="weight"]').get('value')),ready_sha256=hashlib.sha256(ready.read_bytes()).hexdigest(),sliced_sha256=hashlib.sha256(sliced.read_bytes()).hexdigest())
rp.write_text(json.dumps(report,indent=2))
print(json.dumps({k:report[k] for k in ['slicer_validated','native_dimensions_mm','estimated_time_seconds','estimated_filament_g','ironing_toolpaths_absent']},indent=2))

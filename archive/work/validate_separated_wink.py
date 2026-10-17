from pathlib import Path
import json,zipfile,xml.etree.ElementTree as E,re,hashlib,sys
sys.path.insert(0,str(Path(__file__).parent/'pydeps'))
import numpy as np,trimesh
R=Path(__file__).resolve().parents[1];O=R/'outputs'
ns='http://schemas.microsoft.com/3dmanufacturing/core/2015/02';pns='http://schemas.microsoft.com/3dmanufacturing/production/2015/06'
for design in ['wink']:
    stem='lion-wink-clean-color-separated-nozzles'
    ready=O/f'{stem}-H2D.3mf';sliced=O/f'{stem}-sliced.gcode.3mf'
    rp=O/f'{stem}-validation.json';report=json.loads(rp.read_text())
    with zipfile.ZipFile(ready) as z:
        c=json.loads(z.read('Metadata/project_settings.config'))
        for k,v in report['project_changes'].items(): assert c[k]==v['after'],(k,c[k],v['after'])
        root=E.fromstring(z.read('3D/3dmodel.model'));settings=E.fromstring(z.read('Metadata/model_settings.config'))
        panel=next(o for o in settings.findall('object') if 'Lion' in o.find('metadata[@key="name"]').get('value'))
        cfg={m.get('key'):m.get('value') for m in panel.findall('metadata') if m.get('key')}
        for k,v in {'wall_generator':'arachne','seam_gap':'0%','ironing_type':'no ironing','layer_height':'0.1','sparse_infill_density':'100%','reduce_crossing_wall':'1','reduce_infill_retraction_mode':'Disabled'}.items():assert cfg[k]==v,(k,cfg[k])
        def matrix(txt):
            a=np.eye(4)
            if txt:a[:,:3]=np.array(list(map(float,txt.split()))).reshape(4,3)
            return a
        def flatten(file,oid,parent):
            model=root if file=='3D/3dmodel.model' else E.fromstring(z.read(file))
            ob=model.find(f'{{{ns}}}resources/{{{ns}}}object[@id="{oid}"]');mesh=ob.find(f'{{{ns}}}mesh')
            if mesh is not None:
                vv=np.array([[float(v.get(k)) for k in ['x','y','z']] for v in mesh.find(f'{{{ns}}}vertices')]);ff=np.array([[int(f.get(k)) for k in ['v1','v2','v3']] for f in mesh.find(f'{{{ns}}}triangles')]);vv=(np.c_[vv,np.ones(len(vv))]@parent)[:,:3]
                m=trimesh.Trimesh(vv,ff,process=True);assert m.is_watertight and m.is_winding_consistent
                return [m]
            result=[]
            for child in ob.find(f'{{{ns}}}components'):result+=flatten(child.get(f'{{{pns}}}path',file).lstrip('/'),child.get('objectid'),matrix(child.get('transform'))@parent)
            return result
        item=root.find(f'{{{ns}}}build/{{{ns}}}item[@objectid="{panel.get("id")}"]')
        meshes=flatten('3D/3dmodel.model',panel.get('id'),matrix(item.get('transform')))
        assert len(meshes)==6
        vv=np.vstack([m.vertices for m in meshes]);size=vv.max(0)-vv.min(0)
        assert np.allclose(size,[108.2,144.2,2.5],atol=.0001)
        plate=json.loads(z.read('Metadata/plate_1.json'));box=plate['bbox_all']
        assert len(plate['bbox_objects'])==2 and 25<=box[0]<box[2]<=325 and 0<=box[1]<box[3]<=320
    with zipfile.ZipFile(sliced) as z:
        g=z.read('Metadata/plate_1.gcode').decode();info=E.fromstring(z.read('Metadata/slice_info.config')).find('plate')
        def setting(k):return re.search(r'^; '+re.escape(k)+r' = (.*)$',g,re.M).group(1)
        assert setting('nozzle_temperature')=='220,220,220,220,220,220,215'
        assert setting('filament_retraction_length')=='0.4,0.4,0.4,0.4,0.4,0.4,0.6'
        assert setting('filament_wipe_distance')=='1,1,1,1,1,1,2'
        assert setting('filament_retract_before_wipe').endswith('70%')
        assert setting('reduce_infill_retraction_mode')=='Disabled'
        assert setting('filament_prime_volume')==','.join(['45']*7)
        assert setting('filament_prime_volume_nc')==','.join(['90']*7)
        assert setting('flush_into_infill')=='0' and setting('flush_into_objects')=='0'
        assert setting('filament_map')=='2,2,2,2,1,1,1'
        assert [float(v) for v in setting('flush_volumes_matrix').split(',')]==list(map(float,c['flush_volumes_matrix']))
        layers=[float(v) for v in re.findall(r'^; Z_HEIGHT: ([0-9.]+)',g,re.M)]
        assert layers==[round(.2+.1*i,1) for i in range(24)] and '; FEATURE: Ironing' not in g
        assert len(info.findall('object'))==1 and info.find('metadata[@key="outside"]').get('value')=='false'
        assert {f.get('id') for f in info.findall('filament')}=={'1','2','3','4','6','7'}
        assert re.search(r'^M(?:104|109).*S215',g,re.M)
    report.update(slicer_validated=True,native_project=str(ready),sliced_plate=str(sliced),native_dimensions_mm=size.tolist(),plate_bounds_mm=box,estimated_time_seconds=int(info.find('metadata[@key="prediction"]').get('value')),estimated_filament_g=float(info.find('metadata[@key="weight"]').get('value')),actual_layer_heights_mm=layers,native_sha256=hashlib.sha256(ready.read_bytes()).hexdigest(),sliced_sha256=hashlib.sha256(sliced.read_bytes()).hexdigest())
    rp.write_text(json.dumps(report,indent=2))
    print(json.dumps({k:report[k] for k in ['native_project','slicer_validated','native_dimensions_mm','estimated_time_seconds','estimated_filament_g']}))

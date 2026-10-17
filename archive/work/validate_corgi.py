from pathlib import Path
import json,zipfile,xml.etree.ElementTree as E,re,hashlib,sys
sys.path.insert(0,str(Path(__file__).parent/'pydeps'))
import numpy as np,trimesh
R=Path(__file__).resolve().parents[1];O=R/'outputs'
ns='http://schemas.microsoft.com/3dmanufacturing/core/2015/02';pns='http://schemas.microsoft.com/3dmanufacturing/production/2015/06'
for design in ['corgi']:
    stem='corgi-B-arachne-snug'
    ready=O/f'{stem}-v2-verified-H2D.3mf';sliced=O/f'{stem}-v2-sliced.gcode.3mf'
    rp=O/f'{stem}-validation.json';report=json.loads(rp.read_text())
    with zipfile.ZipFile(ready) as z:
        c=json.loads(z.read('Metadata/project_settings.config'))

        root=E.fromstring(z.read('3D/3dmodel.model'));settings=E.fromstring(z.read('Metadata/model_settings.config'))
        assert c['inherits_group'][3:5]==['Bambu PLA Silk+ @BBL H2D']*2
        assert c['inherits_group'][8]=='Bambu PLA Metal @BBL H2D'
        assert c['filament_max_volumetric_speed'][6:12]==['12']*6
        with zipfile.ZipFile(O/'lion-wink-clean-color-separated-nozzles-H2D.3mf') as source:
            for name in ['3D/Objects/object_2.model','3D/Objects/object_3.model']:
                old=E.fromstring(source.read(name)).find(f'.//{{{ns}}}mesh')
                new=E.fromstring(z.read(name)).find(f'.//{{{ns}}}mesh')
                assert E.tostring(old)==E.tostring(new),name
            oldroot=E.fromstring(source.read('3D/3dmodel.model'))
            olditems=list(oldroot.find(f'{{{ns}}}build'))[1:]
            newitems=list(root.find(f'{{{ns}}}build'))[1:]
            assert len(olditems)==len(newitems)==2
            assert [i.get('transform') for i in olditems]==[i.get('transform') for i in newitems]
        panel=next(o for o in settings.findall('object') if 'Corgi' in o.find('metadata[@key="name"]').get('value'))
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
        assert len(meshes)==7
        vv=np.vstack([m.vertices for m in meshes]);size=vv.max(0)-vv.min(0)
        assert np.allclose(size,[108.2,144.2,2.5],atol=.0001)
        plate=json.loads(z.read('Metadata/plate_1.json'));box=plate['bbox_all']
        assert len(plate['bbox_objects'])==2 and 25<=box[0]<box[2]<=325 and 0<=box[1]<box[3]<=320
    with zipfile.ZipFile(sliced) as z:
        g=z.read('Metadata/plate_1.gcode').decode();info=E.fromstring(z.read('Metadata/slice_info.config')).find('plate')
        def setting(k):return re.search(r'^; '+re.escape(k)+r' = (.*)$',g,re.M).group(1)
        assert setting('nozzle_temperature')=='220,220,230,230,220,220,215,220'
        assert setting('filament_retraction_length')=='0.4,0.4,0.4,0.4,0.4,0.4,0.6,0.4'
        assert setting('filament_wipe_distance')=='1,1,1,1,1,1,2,1'
        assert setting('filament_retract_before_wipe').split(',')[6]=='70%'
        assert setting('reduce_infill_retraction_mode')=='Disabled'
        assert setting('filament_prime_volume')==','.join(['45']*8)
        assert setting('filament_prime_volume_nc')==','.join(['90']*8)
        assert setting('flush_into_infill')=='0' and setting('flush_into_objects')=='0'
        assert setting('filament_map')=='2,2,2,2,1,1,1,1'
        assert [float(v) for v in setting('flush_volumes_matrix').split(',')]==list(map(float,c['flush_volumes_matrix']))
        layers=[float(v) for v in re.findall(r'^; Z_HEIGHT: ([0-9.]+)',g,re.M)]
        assert layers==[round(.2+.1*i,1) for i in range(24)] and '; FEATURE: Ironing' not in g
        assert len(info.findall('object'))==1 and info.find('metadata[@key="outside"]').get('value')=='false'
        assert {f.get('id') for f in info.findall('filament')}=={'1','2','3','4','6','7','8'}
        assert re.search(r'^M(?:104|109).*S215',g,re.M)
    report.update(slicer_validated=True,native_project=str(ready),sliced_plate=str(sliced),native_dimensions_mm=size.tolist(),plate_bounds_mm=box,estimated_time_seconds=int(info.find('metadata[@key="prediction"]').get('value')),estimated_filament_g=float(info.find('metadata[@key="weight"]').get('value')),actual_layer_heights_mm=layers,native_sha256=hashlib.sha256(ready.read_bytes()).hexdigest(),sliced_sha256=hashlib.sha256(sliced.read_bytes()).hexdigest())
    rp.write_text(json.dumps(report,indent=2))
    print(json.dumps({k:report[k] for k in ['native_project','slicer_validated','native_dimensions_mm','estimated_time_seconds','estimated_filament_g']}))

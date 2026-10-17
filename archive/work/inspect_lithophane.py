from pathlib import Path
import sys,zipfile,re,json
sys.path.insert(0,str(Path(__file__).parent/'pydeps'))
import numpy as np,trimesh
R=Path(__file__).resolve().parents[1]
z=zipfile.ZipFile(R/'sources/example_lithophane.3mf')
report=[]
for name in ['3D/Objects/object_1.model','3D/Objects/object_2.model','3D/Objects/object_3.model']:
    xml=z.read(name).decode()
    for oid,body in re.findall(r'<object id="(\d+)"[^>]*>(.*?)</object>',xml,re.S):
        vertices=np.array(re.findall(r'<vertex x="([^"]+)" y="([^"]+)" z="([^"]+)"',body),dtype=float)
        faces=np.array(re.findall(r'<triangle v1="(\d+)" v2="(\d+)" v3="(\d+)"',body),dtype=np.int32)
        print(name,oid,'vertices',len(vertices),'faces',len(faces),'bounds',vertices.min(0),vertices.max(0))
        report.append(dict(file=name,id=oid,bounds=[vertices.min(0).tolist(),vertices.max(0).tolist()]))
        if oid in ['2','7','9']:
            mesh=trimesh.Trimesh(vertices,faces,process=True)
            mesh.export(R/f'work/original-object-{oid}.stl')
            np.savez(R/f'work/original-object-{oid}.npz',vertices=vertices,faces=faces)
            print('watertight',mesh.is_watertight,'volume',mesh.volume)
            if oid=='2':print(body)
for i in [1,2,3]:
    (R/f'work/original-plate-{i}.png').write_bytes(z.read(f'Metadata/plate_{i}.png'))
(R/'work/lithophane-original-bounds.json').write_text(json.dumps(report,indent=2))

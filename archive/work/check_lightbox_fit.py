from pathlib import Path
import sys,json
sys.path.insert(0,str(Path(__file__).parent/'pydeps'))
import numpy as np,trimesh,cv2
from shapely.geometry import MultiLineString
from shapely.ops import linemerge
from shapely import set_precision
R=Path(__file__).resolve().parents[1]
data=np.load(R/'work/original-object-7.npz')
m=trimesh.Trimesh(data['vertices'],data['faces'],process=True)
for normal,label in [([1,0,0],'X=0 center, Y-Z section'),([0,0,1],'Z=0 center, X-Y section')]:
    s=trimesh.intersections.mesh_plane(m,plane_origin=[0,0,0],plane_normal=normal)
    print(label)
    axes=[1,2] if normal[0] else [0,1]
    merged=linemerge(set_precision(MultiLineString(s[:,:,axes].tolist()),.0001))
    for line in merged.geoms if hasattr(merged,'geoms') else [merged]:
        xy=np.array(line.coords,dtype='float32')
        simp=cv2.approxPolyDP(xy,.002,True).reshape(-1,2)
        print(simp.round(4).tolist())

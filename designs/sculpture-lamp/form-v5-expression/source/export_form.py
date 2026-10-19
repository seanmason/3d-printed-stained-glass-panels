import bpy
from pathlib import Path
p=Path(__file__).resolve().parents[1]
bpy.ops.wm.open_mainfile(filepath=str(p/'corgi-continuous-form.blend'))
bpy.ops.object.select_all(action='DESELECT')
for o in bpy.context.scene.objects:
 if o.name!='Studio floor' and o.type in ['MESH','CURVE']:o.select_set(True)
bpy.ops.wm.obj_export(filepath=str(p/'corgi-form-assembly-mm.obj'),export_selected_objects=True,global_scale=100,forward_axis='Y',up_axis='Z',export_materials=True,export_triangulated_mesh=True)
bpy.ops.export_scene.gltf(filepath=str(p/'corgi-form-assembly.glb'),use_selection=True,export_apply=True)

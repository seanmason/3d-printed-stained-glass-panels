import os
from pathlib import Path
import json,zipfile,xml.etree.ElementTree as ET
R=Path(__file__).resolve().parents[1]
z=zipfile.ZipFile(R/'work/bambu-template.3mf')
p=json.loads(z.read('Metadata/project_settings.config'))
base=Path(os.environ['APPDATA'])/'BambuStudio/system/BBL/filament'
def resolve(name):
    d=json.loads((base/(name+'.json')).read_text()); result={}
    if d.get('inherits'): result.update(resolve(d['inherits']))
    for inc in d.get('include',[]): result.update(resolve(inc))
    result.update(d); return result
f=resolve('Bambu PLA Basic @BBL H2D')
ignore={'compatible_printers','compatible_prints','inherits','include','name','type','from','setting_id','instantiation','filament_extruder_variant'}
for k,v in list(p.items()):
    if k in ignore or not isinstance(v,list): continue
    if k.startswith('filament_') or k in f or k=='default_filament_colour':
        if len(v) in [7,21,28]: p[k]=v[:len(v)//7]*6
        elif k in f and isinstance(f[k],list): p[k]=f[k]*6
colors=['#000000','#FFFFFF','#0086D6','#FEC600','#FF9016','#6F5034']
p['filament_colour']=colors;p['filament_multi_colour']=colors
p['filament_colour_type']=['1']*6
p['filament_settings_id']=['Bambu PLA Basic @BBL H2D']*6
p['filament_type']=['PLA']*6;p['filament_ids']=['GFA00']*6
p['filament_extruder_variant']=f['filament_extruder_variant']*6
p['filament_self_index']=[str(i) for i in range(1,7) for _ in range(3)]
p['filament_map']=['1']*3+['2']*3
p['extruder_ams_count']=['1#1|4#0','1#1|4#0']
p['flush_volumes_matrix']=[str(0 if i==j else 700 if j==1 else 500 if i==0 else 350) for nozzle in range(2) for i in range(6) for j in range(6)]
p['flush_volumes_vector']=['140']*12
p['enable_support']='0';p['sparse_infill_density']='100%';p['sparse_infill_pattern']='rectilinear'
p['top_shell_layers']='4';p['bottom_shell_layers']='4'
p['layer_height']='0.2';p['initial_layer_print_height']='0.2'
p['enable_prime_tower']='1';p['wipe_tower_x']=['165'];p['wipe_tower_y']=['270']
p['brim_type']='no_brim';p['wall_generator']='arachne'
out=R/'outputs/lion-panel-H2D.3mf'
with zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED) as dest:
    for name in z.namelist():
        if name=='Metadata/project_settings.config':dest.writestr(name,json.dumps(p,indent=2))
        elif name.startswith('Metadata/') and name.endswith('.png'):continue
        else:dest.writestr(name,z.read(name))
print(out)
print('filaments',p['filament_type'],'temps',p['nozzle_temperature'],'colors',p['filament_colour'])

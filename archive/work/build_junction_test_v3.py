"""Build the unprinted 0.2 mm nozzle comparison from preserved sources."""
from pathlib import Path
import shutil
R=Path(__file__).resolve().parents[1]
O=R/'outputs'
draft=O/'corgi-simplified-review-v2.png'
if not draft.exists():
 shutil.copyfile(Path('C:/Users/mason/.codex/generated_images/01a0a65d-7fb9-74b2-abe3-c7393425aa14/exec-cce345ef-12c4-4e5f-bed9-7b850b980e74.png'),draft)
# Reuse the established quantization pipeline, producing a sibling geometry source.
extract=(R/'work/build_corgi.py').read_text().split("parts=O/(stem+'-parts')")[0]
extract=extract.replace("corgi-panel-B-library-palette-v1.png",draft.name)
extract=extract.replace("buffer(-.20,quad_segs=4).buffer(.20,quad_segs=4)","buffer(-.35,quad_segs=8).buffer(.35,quad_segs=8)")
env={'__file__':str(R/'work/build_corgi.py')}
exec(extract,env)
simple={c:p for n,c,p,z in env['regions']}
# Existing exporter retains the registration, filament assignment and geometry checks.
code=(R/'work/build_junction_test_v2.py').read_text()
code=code.replace("stem='corgi-junction-test-v2'","stem='corgi-junction-test-v3-02mm'")
code=code.replace("variants=[('A - shallow control',1.,{}),('B - slower detail motion',1.,slow),('C - overlap 25 percent',1.,{'infill_wall_overlap':'25%'}),('D - flush black',.8,{})]", "variants=[('A - original geometry / relief 0.2',1.,{}),('B - simplified / relief 0.2',1.,{}),('C - simplified / relief 0.3',1.1,{})]")
code=code.replace("source_polys[col].intersection(box(*bounds))","(source_polys if v==0 else simple)[col].intersection(box(*bounds))")
code=code.replace("(26,0),(26,32)","(50,0),(50,32)")
code=code.replace("[(22,.4),(12,.6),(2,.8)]","[(22,.3),(12,.4),(2,.6)]")
code=code.replace("[(4,2),(5,14)]","[(4,2),(5,14),(2,26),(3,38)]")
code=code.replace("E - Cocoa and Copper thickness ladder","D - four-material transmission grid")
code=code.replace("xy=[220,120]","xy=[220,120]")
code=code.replace("Junction comparison A-D and dark ladder E","0.2 mm nozzle test - NOT PRINTED")
# Remove old per-object process metadata so 0.4 mm line widths cannot override the new preset.
code=code.replace("opts={m.get('key'):m.get('value') for m in template.findall('metadata') if m.get('key')}","opts={}")
code=code.replace("updates={'3D/3dmodel.model'", "configure_02(cfg)\nupdates={'3D/3dmodel.model'")
# A separate guide below replaces the old four-strip layout.
code=code.split("im=Image.new")[0]
def configure_02(cfg):
 import json
 profiles=Path('C:/Program Files/Bambu Studio/resources/profiles/BBL')
 def resolve(kind,name):
  p=profiles/kind/(name+'.json'); v=json.loads(p.read_text(encoding='utf-8'))
  result=resolve(kind,v['inherits']) if v.get('inherits') else {}
  for inc in v.get('include',[]):result.update(resolve(kind,inc))
  result.update({k:x for k,x in v.items() if k not in ['inherits','include','name','type','from','setting_id','instantiation','compatible_printers']})
  return result
 cfg.update(resolve('machine','Bambu Lab H2D 0.2 nozzle'))
 cfg.update(resolve('process','0.10mm Standard @BBL H2D 0.2 nozzle'))
 cfg['printer_settings_id']='Bambu Lab H2D 0.2 nozzle'
 cfg['print_settings_id']='0.10mm Standard @BBL H2D 0.2 nozzle'
 cfg['layer_height']='0.1';cfg['initial_layer_print_height']='0.1'
 cfg['wall_generator']='arachne';cfg['ironing_type']='no ironing';cfg['sparse_infill_density']='100%'
 cfg['infill_wall_overlap']=['20%']*4;cfg['seam_gap']=['0%']*4
 cfg['prime_tower_width']='45';cfg['wipe_tower_x']=['40'];cfg['wipe_tower_y']=['210']
 # Material-specific 0.2 mm flow limits, retaining established palette and purge routing.
 kinds=['Basic','Basic','Silk+','Silk+','Basic','Basic','Basic','Metal']
 for k in ['filament_max_volumetric_speed','filament_flow_ratio','nozzle_temperature','nozzle_temperature_initial_layer']:
  cfg[k]=[resolve('filament',f'Bambu PLA {kind} @BBL H2D 0.2 nozzle').get(k,['220'])[0] for kind in kinds]
 cfg['filament_settings_id']=[f'Bambu PLA {kind} @BBL H2D 0.2 nozzle' for kind in kinds]
 cfg['nozzle_temperature'][6]='215';cfg['nozzle_temperature_initial_layer'][6]='220'
 # Explicit process override provenance for Studio's native save.
 ds=cfg.get('different_settings_to_system',[])
 if isinstance(ds,list) and ds:
  ds[0]=';'.join(sorted(set(ds[0].split(';'))|{'layer_height','initial_layer_print_height','wall_generator','ironing_type','sparse_infill_density','infill_wall_overlap','seam_gap','prime_tower_width'}))
exec(code,dict(__file__=str(R/'work/build_junction_test_v2.py'),simple=simple,configure_02=configure_02))

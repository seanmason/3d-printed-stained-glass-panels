"""Revise color-change/travel settings without altering any mesh or placement."""
from pathlib import Path
import copy, hashlib, json, zipfile, xml.etree.ElementTree as E

R = Path(__file__).resolve().parents[1]
O = R / 'outputs'
reports = []
for design in ('wink', 'original'):
    stem = f'lion-{design}-arachne-snug'
    source = O / f'{stem}-ready-H2D.3mf'
    target = O / f'{stem}-clean-color-H2D.3mf'
    with zipfile.ZipFile(source) as z:
        cfg = json.loads(z.read('Metadata/project_settings.config'))
        old_cfg = copy.deepcopy(cfg)
        settings = E.fromstring(z.read('Metadata/model_settings.config'))
        panel = next(o for o in settings.findall('object') if 'Lion' in o.find('metadata[@key="name"]').get('value'))
        previous_panel = {m.get('key'): m.get('value') for m in panel.findall('metadata') if m.get('key')}
        # Variant order per filament: standard, high flow, E3D high flow.
        assert len(cfg['nozzle_temperature']) == 21
        assert cfg['filament_colour'][6] == '#000000'
        cfg['nozzle_temperature'][18] = '215'  # black standard hotend, subsequent layers
        cfg['filament_retraction_length'][18] = '0.6'
        cfg['filament_wipe_distance'][18] = '2'
        cfg['filament_retract_before_wipe'][18] = '70%'
        # Normal retractions for infill travel; preserve calibrated flow/seam settings.
        cfg['reduce_infill_retraction_mode'] = 'Disabled'
        cfg['enable_prime_tower'] = '1'
        cfg['filament_prime_volume'] = ['45'] * 7
        cfg['filament_prime_volume_nc'] = ['90'] * 7
        cfg['prime_tower_width'] = '45'
        cfg['flush_into_infill'] = '0'
        cfg['flush_into_objects'] = '0'
        # Studio restores system presets unless changed fields are declared here.
        # Order is process, seven filaments, printer.
        diff = cfg['different_settings_to_system']
        assert len(diff) == 9
        def declare(index, keys):
            diff[index] = ';'.join(sorted(set(filter(None,diff[index].split(';'))) | set(keys)))
        declare(0, ['reduce_infill_retraction_mode', 'prime_tower_width'])
        for filament in range(7):
            declare(filament+1, ['filament_prime_volume','filament_prime_volume_nc'])
        declare(7, ['nozzle_temperature','filament_retraction_length','filament_wipe_distance','filament_retract_before_wipe'])
        # Both 7x7 matrices use source row -> destination column, mm^3.
        # Raise only useful same-nozzle transitions. Black->yellow already 900.
        matrix = cfg['flush_volumes_matrix']
        assert len(matrix) == 98
        transitions = [(5,0,900), (5,1,500), (6,3,850), (3,2,500)]
        purge_changes = []
        for nozzle in range(2):
            for src,dst,minimum in transitions:
                i=nozzle*49+src*7+dst
                before=int(matrix[i]); matrix[i]=str(max(before,minimum))
                purge_changes.append({'matrix':nozzle+1,'source_filament':src+1,'destination_filament':dst+1,'before_mm3':before,'after_mm3':int(matrix[i])})
        # Object-level travel override leaves housing/guide object settings untouched.
        for key,value in {'reduce_crossing_wall':'1','max_travel_detour_distance':'0','reduce_infill_retraction_mode':'Disabled'}.items():
            m=panel.find(f'metadata[@key="{key}"]')
            if m is None: m=E.SubElement(panel,'metadata',{'key':key})
            m.set('value',value)
        plate=settings.findall('plate')[0]
        plate.find('metadata[@key="plater_name"]').set('value',f'{design.title()} lion - clean color trial')
        updates={
            'Metadata/project_settings.config':json.dumps(cfg,indent=2).encode(),
            'Metadata/model_settings.config':E.tostring(settings,encoding='utf-8',xml_declaration=True),
        }
        # Remove stale cached toolpaths: this revision must be sliced again.
        stale=lambda n: n.endswith('.gcode') or n.endswith('.gcode.md5') or n=='Metadata/slice_info.config' or (n.startswith('Metadata/plate_') and n.endswith('.json'))
        with zipfile.ZipFile(target,'w',zipfile.ZIP_DEFLATED) as out:
            for item in z.infolist():
                if not stale(item.filename):out.writestr(copy.copy(item),updates.get(item.filename,z.read(item.filename)))
        with zipfile.ZipFile(target) as out:
            assert out.testzip() is None
            mesh_files=[n for n in z.namelist() if n.startswith('3D/')]
            assert all(out.read(n)==z.read(n) for n in mesh_files)
            newset=E.fromstring(out.read('Metadata/model_settings.config'))
            for old in settings.findall('object'):
                if old.get('id')!=panel.get('id'):
                    assert E.tostring(newset.find(f'object[@id="{old.get("id")}"]'))==E.tostring(old)
            assert previous_panel['wall_generator']=='arachne'
            assert previous_panel['seam_gap']=='0%'
            assert previous_panel['ironing_type']=='no ironing'
        report={'source':str(source),'project':str(target),'geometry_and_placement_bytes_unchanged':True,'other_object_settings_unchanged':True,'dimensions_mm':[108.2,144.2,2.5], 'project_changes':{k:{'before':old_cfg[k],'after':cfg[k]} for k in cfg if cfg[k]!=old_cfg.get(k)},'purge_changes':purge_changes,'panel_travel_settings':{'reduce_crossing_wall':'1','max_travel_detour_distance':'0'},'slicer_validated':False,'physical_result_validated':False,'print_started':False,'sha256':hashlib.sha256(target.read_bytes()).hexdigest()}
        (O/f'{stem}-clean-color-validation.json').write_text(json.dumps(report,indent=2))
        reports.append({'project':str(target),'geometry_unchanged':True,'changes':list(report['project_changes'])})
print(json.dumps(reports,indent=2))

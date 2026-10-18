from pathlib import Path
import json,shutil,hashlib
R=Path(__file__).resolve().parents[1];repo=R/'archive-repo';out=R/'outputs';target=repo/'tests/diagnostic-v4';target.mkdir(exist_ok=True)
records=json.loads((out/'corgi-diagnostic-v4-validation.json').read_text())
copies={}
for rec in records:
 copies[rec['job']+'.3mf']=rec['file']
copies['guide.png']='corgi-diagnostic-v4-guide.png';copies['validation.json']='corgi-diagnostic-v4-validation.json'
for dest,src in copies.items():shutil.copy2(out/src,target/dest)
files=list(out.glob('corgi-diagnostic-v4*'))
for p in files:shutil.copy2(p,repo/'archive/outputs'/p.name)
for name in ['build_diagnostic_v4.py','validate_diagnostic_v4.py','publish_diagnostic_v4.py']:shutil.copy2(R/'work'/name,repo/'archive/work'/name)
readme='''# Corgi diagnostic test v4

**Prepared, native-saved and slice-checked. NOT SENT OR PRINTED.** Both nozzles remain standard 0.2 mm. Eight small coupons across three separate jobs; about **72 min 54 s** including the slicer's startup allowance for each. Physical loading, calibration and cooling can add time.

[Identification guide](guide.png) · [Validation](validation.json)

| Print order | Editable project | Samples | Slicer estimate |
|---|---|---|---|
| 1 | [White-only](01-white-only.3mf) | W1/W2: two repeats, right nozzle only | 16m 51s |
| 2 | [Patterns and direction](02-patterns.3mf) | A1/A2 controls, B Monotonic top pattern, C fill direction 90 degrees | 33m 29s |
| 3 | [White flow +3%](03-flow.3mf) | F1/F2 repeats of the two-color control, white flow increased | 22m 34s |

## Geometry and identification

Every coupon is 34 × 22 mm, with a clipped upper-left corner. White panes are 0.4 mm (four 0.1 mm layers); surrounding leading is 0.7 mm (0.3 mm relief). All panes start on the bed. A broad field narrows to a rounded tip; a separate sharp triangle tests line turnarounds. This deliberately uses simple diagnostic geometry, not another full eye/artwork print. Recheck the chosen settings on the actual eye after these tests identify a useful change.

Count top-edge notches: W1/W2 and F1/F2 have 1/2. On the pattern plate, A1/A2/B/C have 1/2/3/4. Letters and numbers are on the guide, not embossed into the thin panes. Keep jobs separated after removal.

White-only coupons have the identical outer shape and raised frame, all in white. They must be their own job: black must not print elsewhere on that plate. The idle left nozzle can still carry historical residue, so this is a practical single-nozzle baseline, not proof that black contamination is impossible.

## Controlled changes

- A1/A2 use the v3 process: Arachne, 100% infill, no ironing, 0.1 mm first/subsequent layers, 20% infill/wall overlap, zero seam gap, Monotonic Line top pattern, 45-degree fill direction.
- B changes only the top-surface pattern to Monotonic. Bottom pattern remains Monotonic. It tests top-layer path connectivity, not every layer's pattern.
- C changes fill direction from 45 to 90 degrees. Actual top paths rotate from 135 to 0 degrees because layer directions alternate.
- F changes only the white filament flow ratio from 0.98 to 1.0094 (= 0.98 × 1.03). Black remains 0.98. This is a diagnostic perturbation, not a calibrated permanent value.
- Temperatures, layer heights, speeds, cooling, retraction and black/light routing are otherwise retained. More objects on job 2 change layer timing compared with jobs 1/3; interpret contamination and flow comparisons with that limitation. The controls are repeated to assess variability, but this is not a full replicated experiment.

Only **Basic Jade White 10100** and **Basic Black 10101** are used. Established slots: White A2/right; Black B2/left. Verify current identities before printing. Other filaments may remain listed in the project but are unused. Keep bed leveling and flow dynamics options consistent across jobs; enabling flow dynamics again is not itself a new test. Do not change cleaning, purge or temperature settings between jobs unless a fault requires it; record any intervention.

## Evaluate before proceeding to the full panel

1. Print white-only first and photograph both coupons against the same light pad, front and back, clipped corner upper left.
2. Print the pattern plate. Compare its controls to white-only for embedded marks, then compare A/B/C for holes within the broad pane, along the taper and against the leading.
3. Print the flow plate. Compare F1/F2 to A1/A2 for hole count, ridges, edge bulging and light transmission. A smoother opaque surface alone is not success.
4. Use [results.csv](results.csv). Record dark inclusions separately from bright holes. Note whether bright defects rotate with C's fill direction. Do not infer a specific contamination source from a single clean/dirty coupon.

If marks occur only during two-nozzle jobs, investigate nozzle-change/black-deposition contamination. If white-only also has them, investigate the white feed path/nozzle and historical residue. If +3% helps without ridges, perform material/nozzle flow calibration rather than blindly adopting the test value. If rotating paths rotates holes, prioritize deposition/path behavior. A successful white result still needs confirmation in Gold/Champagne before applying it to the full Corgi.

## Validation and provenance

Generated from explicit analytic polygons using the v3 native project as a settings template. No final panel or lightbox objects were changed. Native saved in Bambu Studio 02.08.02.61; settings checked after save. Geometry checks cover watertight component shells, positive volume, intended dimensions/heights, shared planar boundaries and nonoverlapping placement. The white-only frame and panes are touching closed shells within a single material part; the slice confirms continuous four-layer pane deposition.

Captured the completed local slicer G-code as evidence (archive only), checked seven total layers, four pane layers, active material routing, flow ratio, object count and changed top-fill direction. Studio's viewport remains stale; inspection uses meshes and nominal toolpath projections. Raster projections can show pixel-rounding artifacts and are not physical pinhole guarantees. Native projects retain an old inherited plate title; identify jobs by these filenames and object labels. Re-slice editable projects for the current machine before sending.
'''
(target/'README.md').write_text(readme,encoding='utf-8')
(target/'results.csv').write_text('sample,notches,dark_inclusions,broad_pane_holes,taper_holes,triangle_holes,edge_holes,ridges,transmission,notes\n'+''.join(f'{name},{n},,,,,,,,\n' for name,n in [('W1',1),('W2',2),('A1',1),('A2',2),('B',3),('C',4),('F1',1),('F2',2)]))
note='''\n\n## 2026-10-18: v3 completed; diagnostic v4 prepared\n\nUser supplied a backlit photograph of completed v3. Gold and Champagne transmit strongly; Cocoa transmits weakly, particularly at 0.3/0.4 mm; Copper remains near opaque. Simplified geometry looks cleaner, but user confirms diagonal pinholes remain and dark marks are embedded, not surface or loose debris. Do not claim v3 solved pinholes or that the dark marks have a proven source. Keep dual 0.2 mm nozzles for controlled diagnosis.\n\nNext is [diagnostic v4](../tests/diagnostic-v4/README.md): separate white-only baseline, two-color pattern/direction comparisons and +3% white flow. Native-saved and slice-checked, NOT PRINTED. Total estimated 72m54s. No full Corgi model promotion yet.\n'''
for rel in ['docs/printing.md','docs/design-history.md']:
 p=repo/rel;p.write_text(p.read_text(encoding='utf-8')+note,encoding='utf-8')
p=repo/'README.md';s=p.read_text(encoding='utf-8');a=s.index('[Next junction test:');b=s.index('\n\n',a);s=s[:a]+'[Next diagnostic test: v4](tests/diagnostic-v4/README.md): white-only baseline, two-color pattern/direction comparisons and +3% white flow. Prepared, not printed; three jobs total about 73 minutes. v3 completed with embedded marks and diagonal pinholes.'+s[b:];p.write_text(s,encoding='utf-8')
p=repo/'AGENTS.md';p.write_text(p.read_text(encoding='utf-8')+'\n\nLatest handoff: v3 physically completed; user confirms embedded dark marks and diagonal pinholes. Current prepared test is tests/diagnostic-v4/README.md, three separate jobs, dual 0.2 mm. Native-saved and slice-checked; NOT SENT. Do not mix the white-only baseline with black printing. No print authorization given for v4. Read the diagnostic limitations and evaluation plan.\n',encoding='utf-8')
p=repo/'.gitattributes';p.write_text(p.read_text()+'\ntests/diagnostic-v4/validation.json -text\n')
p=repo/'catalog.json';c=json.loads(p.read_text(encoding='utf-8'));c['corgi_status']='v3 completed: embedded dark marks and diagonal pinholes remain. v4 three diagnostic jobs prepared/native-saved/slice-checked, NOT PRINTED.'
paths=[repo/'archive/outputs'/f.name for f in files]+list((repo/'archive/work').glob('*diagnostic_v4.py'))+[target/f for f in copies]
for f in paths:
 rel=f.relative_to(repo).as_posix();item={'path':rel,'bytes':f.stat().st_size,'sha256':hashlib.sha256(f.read_bytes()).hexdigest(),'role':'diagnostic_v4_prepared_not_printed'}
 if f.parent==target:item['source']='archive/outputs/'+copies[f.name]
 c['artifacts']=[a for a in c['artifacts'] if a['path']!=rel]+[item]
p.write_text(json.dumps(c,indent=2)+'\n',encoding='utf-8')

# Corgi diagnostic test v4

**All three jobs completed per user. Job 1 had no abnormalities reported. Job 2 retained angle-dependent bright boundary lines. Job 3 (+3% white flow) has no pinholes found by the user from any angle; sample F2 has a faint dark streak.** Both nozzles remain standard 0.2 mm. Eight small coupons across three separate jobs; about **72 min 54 s** including the slicer's startup allowance for each. Physical loading, calibration and cooling can add time.

Job 1 used A2 white on the right nozzle only, with bed leveling and flow dynamics calibration on, timelapse and nozzle offset calibration off. Studio confirmed finished at layer 7/7; the user reported no abnormalities and cleared the bed. This clean baseline is encouraging but does not establish the cause of prior defects.

Job 2 was authorized and sent once at about 18:42 local time on 2026-10-18. Studio subsequently confirmed finished at layer 7/7, and the user supplied backlit photos. A1/A2 have similar diagonal broad-pane texture. B has finer diagonal texture but angle-dependent bright boundary lines remain. C changes the broad-pane texture toward vertical/grid; bright lines remain along the same sloping color boundary. This separates interior texture from boundary brightness. Photos cannot distinguish an open gap from thin plastic or edge optics. No large cloudy dark marks are apparent, but tiny dark specks remain. No winning process established.

White A2/right and Black B2/left, both standard 0.2 mm; bed leveling and flow dynamics on, nozzle offset Auto, timelapse off. Slicer estimate 33m29s. The user authorized job 3 and confirmed a clear bed; Studio then showed plate-offset warning 0500-808C 184418 before any job 3 send. Requested physical plate realignment; warning dialog dismissed without selecting either Resume button. Validation JSON remains the preparation snapshot.

The user subsequently confirmed the plate was seated squarely and double-checked, and authorized retry. Job 3 was sent once, Studio reported successful send, and Haute displayed the correct two-coupon flow job active at layer 0/7. Estimate 22m34s, 1.31 g; White A2/right and Black B2/left, standard 0.2/0.2 mm. Bed leveling and flow dynamics on, nozzle offset Auto, timelapse off. No warning dialog recurred during this startup confirmation; completion and physical result remain unconfirmed. Compare F1/F2 with A1/A2 at multiple backlight angles for boundary lines, interior texture and ridges.

Latest physical result supersedes that startup snapshot: the user supplied a backlit photograph and reports no pinholes from any angle in F1/F2. The two-notch F2 is the upper coupon in the photo and has a faint diffuse gray streak in the lower-left white field. The photo does not establish black contamination versus local thickness/density variation. Both samples retain diagonal print texture; surface ridges have not been assessed by touch/reflected light. White flow 1.0094 is a promising candidate for this filament/nozzle/geometry, not a universal calibration. Black flow remained 0.98.

Proposed next step, not yet authorized to print: inspect the black nozzle exterior, flow blocker and wiping pad for residue, wear or poor coverage, recording any cleaning intervention; repeat the same two-color flow test with unchanged process settings to assess recurrence. First move/rotate F2 over the light pad to verify the mark follows the part and inspect both faces under reflected light. If the streak recurs, use a separate matched white-only job at the same +3% flow to distinguish white-path/density effects from effects associated with dual-nozzle printing. Do not combine black onto that baseline plate. After confirming repeatability, test the actual eye/junction geometry and Gold/Champagne with material-specific calibration before promoting a full panel.

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

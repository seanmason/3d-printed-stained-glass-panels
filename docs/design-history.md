# Design history and lessons

## Lion composition

The initial motif was an Apple-style lion emoji translated into a simple stained-glass panel. Iterations corrected the face length and width, restored a broad forehead and substantial mane, and reduced the darker lower mane. The accepted final original concept is `lion-panel-concept-v5.png`. The black perimeter was reduced by roughly 20%, not to 20%; an intervening draft incorrectly ended in blue and was rejected.

The first square model was 200 mm across. The user then supplied `example_lithophane.3mf` and requested replacement of only its translucent insert. A winking, smirking version was developed through two drafts; the second is the source for the lightbox conversion. A paired project subsequently placed both original and winking inserts on one plate, retaining the housing and light guide.

## Fit and pinholes

The initial lightbox panels measured 108 × 144 × 2.5 mm. They printed nearly perfectly, but small junctions between colors admitted pinpoints of light and the fit was too loose. The later single-panel projects scale XY to 108.2 × 144.2 mm, adding 0.1 mm per edge while retaining 2.5 mm maximum thickness and 0.8 mm colored panes. Assess fit after cooling; this increment is specific to this housing and print combination.

Ironing was tested and the user said it did not turn out well. It is off in the successful baseline. A later 30 × 32 mm corner test compared Arachne and zero seam gap alone (A) with additional corner rounding and a buried black ledge (B). The user explicitly said **the Arachne one was perfect**. Therefore the final panels use A's slicer changes, without B's 0.25 mm rounding or buried ledge. The old test notes predate this physical feedback.

The user asked whether 0.2 mm layers would hide visible lines. This was not established as a fix: final panels retain 0.1 mm layers and a 0.2 mm first layer. Surface toolpath lines should not be confused with vertical layer stepping.

## Dark streaks and stringing

After the full winking panel, the user reported dark streaks in light regions and black stringing. A conservative clean-color trial lowered subsequent-layer black temperature, increased retraction/wiping and priming, enabled travel precautions, and increased selected purge transitions. Both lion variants were sliced and verified with those changes.

The user cleaned the printer and camera as instructed, then rearranged AMS spools. Verification found White still on the dark-material side; after the requested White/Magenta swap, White was verified at A2 and Black at B2. The latest wink was remapped and re-sliced with darks on the left nozzle and lights on the right. The job was sent once and observed active. The saved evidence does not establish that this print completed or cured the streaking.

## Corgi mix

The dog has a golden-tan head, unusually large upright ears, long tapered muzzle, attentive almond-shaped brown eyes, cream muzzle/chest, and dark saddle. The desired feeling is a sweet, inquisitive dog overseeing his human. Avoid photorealistic fur and a generic short-muzzled corgi.

Three drafts were delivered: A, a frontal attentive supervisor; B, an upward-right three-quarter portrait at his human's side; C, a puppy-dog gaze from above. The user selected B. A second rendering adapted B to the real filament library: Basic Black, Cocoa Brown, Jade White, Cyan; Metal Copper Brown Metallic; Silk+ Gold and Champagne. Exact codes, approximate colors, roles, remaining quantities at the time, and the prompt are in `archive/outputs/corgi-panel-B-library-palette-v1.json`.

The library initially showed a transient signed-out/empty state, then finished syncing. Its live Filament Manager view was usable even though a local inventory JSON was empty. Do not infer ownership from installed slicer profiles. Despite an earlier statement of owning every PLA color, the observed inventory did not contain matte or a plain tan/cream, so the rendered palette used owned Silk+ and Metal materials. The palette rendering is approximate. It was subsequently converted into a validated seven-color mesh and sliced; see [Corgi B manufacturing notes](corgi-B.md). Physical print quality remains untested.

## First material sample: user feedback, 2026-10-17

The user confirmed completion. Pinholes occur in narrow eye/muzzle/chest regions, particularly near tool turn-arounds. Tall raised black around the eye hides the colored area. The user described the lightest 12 swatches as transmitting well, one adjacent swatch as somewhat translucent, and six darker swatches as black under backlighting. Exact swatch-to-filament mapping is unconfirmed; do not infer it from those counts. Flow dynamics calibration was enabled for that sample, so simply enabling it again is not a new treatment.

The next [junction comparison](../tests/junction-v2/README.md) tests speed, overlap, shallow/flush black, and thinner dark materials. It is slice-verified but not sent because printer HMS needs attention. No full Corgi panel has been physically validated.

## 2026-10-18: v2 physical feedback and v3 preparation

User confirmed v2 completed. Sample 1/A had the fewest pinholes but still failed at narrow regions/turnarounds. Corrected ladder orientation: notch upper left, 2 columns × 3 rows numbered 1 2 / 3 4 / 5 6. Only 1 and 3 faintly transmitted: Cocoa 0.4 and 0.6 mm; 5 (Cocoa 0.8) and Copper 0.4/0.6/0.8 did not. This supersedes earlier eight-square interpretations. Simplified artwork was approved for testing.

[Next test](../tests/junction-v3-02mm/README.md) compares original/simplified geometry, 0.2/0.3 mm leading relief and four materials at 0.3/0.4/0.6 mm on dual 0.2 mm nozzles. Prepared and sliced, NOT PRINTED. Estimate 5 h 5 m 44 s exceeds the earlier three-hour window. Nozzle swap and live AMS check remain pending.


## 2026-10-18: v3 completed; diagnostic v4 prepared

User supplied a backlit photograph of completed v3. Gold and Champagne transmit strongly; Cocoa transmits weakly, particularly at 0.3/0.4 mm; Copper remains near opaque. Simplified geometry looks cleaner, but user confirms diagonal pinholes remain and dark marks are embedded, not surface or loose debris. Do not claim v3 solved pinholes or that the dark marks have a proven source. Keep dual 0.2 mm nozzles for controlled diagnosis.

Next is [diagnostic v4](../tests/diagnostic-v4/README.md): separate white-only baseline, two-color pattern/direction comparisons and +3% white flow. Native-saved and slice-checked, NOT PRINTED. Total estimated 72m54s. No full Corgi model promotion yet.


## 2026-10-18: full simplified Corgi production v6

User requested best-product assumptions for an overnight full panel and authorized printing on a clear ready bed. Rebuilt from approved `corgi-simplified-review-v2.png`; removed raster shading seams, retained two printable 1.2 mm eye highlights, merged near-opaque Copper into Cocoa. Geometry uses a 0.01 mm partition grid; regions cover the outline without area overlap. All solids are watertight, consistently wound and positive volume. Native saved geometry and 221,331 actual model extrusion segments checked.

Panel stays 108.2 × 144.2 mm with 2.6 mm wide, 2.5 mm tall black rim. Light panes 0.4 mm, Cocoa 0.3 mm, interior leading 0.7 mm (0.3 mm relief over light panes). Dual standard 0.2 mm nozzles; 0.1 mm first/all layers, Arachne, no ironing, 100% infill, 20% overlap, zero seam gap. White flow 1.0094; all other materials 0.98. Dark/light nozzle separation, 215°C subsequent black, 0.6 mm black retraction/2 mm wipe, avoid wall crossing and retraction reduction Disabled. Standard material-specific 0.2 profiles and conservative 2 mm³/s volume limit. Purge into tower only, not artwork.

Live material dialogs verified A1 Champagne Silk+, A2 Jade White Basic, A3 Gold Silk+, A4 Cyan Basic, B4 Cocoa Basic and B2 Black Basic. Send dialog matched those slots to right lights/left darks. Bed leveling/flow dynamics On, nozzle offset Auto, timelapse Off. Sent ONCE about 22:41 local. Studio reported successful send; Haute showed the correct production-v6 job heating/homing at 0/25. Estimate 4h34m21s and 27.49 g; indicated finish about 03:15. Completion and physical result remain unconfirmed. No other job queued.

V4 +3% white physically eliminated angle-dependent seam pinholes per user. V5 completed with a small dark spot even without active black deposition; source unresolved. These remain distinct findings: do not claim the full colored panel is physically proven or the dark-spot cause fixed. This product print intentionally proceeds with the best present assumptions instead of further diagnosis. Current human download: [Corgi model](../models/corgi/README.md). Original housing/light-guide and historical projects are untouched; v6 is a standalone insert project.


## 2026-10-19: Corgi success and picture lamp

User confirms full Corgi production-v6 completed and turned out really well. Three tabletop lamp concepts were rendered; user selected C, the arched picture lamp, and requests premium non-Bambu electronics. [Current lamp proposal](../designs/picture-lamp/README.md) records researched parts, optical stack, opaque seams/baffles and limitations. No lamp CAD or print completed.


## 2026-10-19: sculpture rebuilt from landmarks

User rejected both CAD interpretations and asked to revisit the original concept from scratch. [V3](../designs/sculpture-lamp/cad-v3/README.md) replaces ring-derived anatomy with a named anatomical landmark network, constrained planar facets, fuller muzzle, inset eyes, broad folded ears and shoulder volume. Native Fusion form study, STEP, source and actual screenshots saved; 233 solids positive and closed. Not user-approved or engineered for assembly/light sealing/heat/stability. Earlier production panels remain untouched.


## 2026-10-19: continuous sculpt before engineering

User rejected CAD v3, bringing all three attempted CAD forms into rejected history. User approved building an unsegmented sculptural form before dividing it into planar stained-glass sections. [Form study v4](../designs/sculpture-lamp/form-v4/README.md) contains actual Blender geometry renders and the editable master, with a mesh reference in Fusion. Visual likeness and expression remain subject to review; final flat-pane requirement remains. No lamp print or purchase occurred.


## 2026-10-19: attentive expression revision

User found the continuous sculpt proportions closer but its expression ineffective. [V5](../designs/sculpture-lamp/form-v5-expression/README.md) revises open eye contours, upward-looking conforming pupils with small cream catchlights, subtle inner brow, tapered mouth and a restrained head inclination. Actual three-quarter/front/close-up renders and editable Blender/Fusion mesh references saved. User expression review remains pending; no planar lamp assembly or print.

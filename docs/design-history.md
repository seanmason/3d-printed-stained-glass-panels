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

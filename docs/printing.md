# Printing settings and troubleshooting

## Successful pinhole baseline

H2D, two standard 0.4 mm nozzles, textured PEI. Current insert 108.2 × 144.2 × 2.5 mm; color panes 0.8 mm.

| Setting | Value |
|---|---|
| Wall generator | Arachne |
| Seam gap | 0% |
| Seam slope | None |
| Layer / first layer | 0.1 / 0.2 mm |
| Infill | 100%, zigzag |
| Infill/wall overlap | 20% |
| Top surface | Monotonic line, 50 mm/s |
| Gap fill | 30 mm/s |
| Ironing | Off |

These settings correspond to the successful A sample. Preserve the approved geometry; do not automatically add the rejected trial's ledge or rounded junctions.

## Latest clean-color trial

Black: 215 C subsequent layers, 220 C first layer; 0.6 mm retraction, 2 mm wipe, 70% retract before wiping. Normal travel retractions remain enabled by disabling “reduce infill retraction.” Avoid crossing walls is enabled on the panel, with unlimited detour allowance. Prime volumes are 45 mm³ for filament changes and 90 mm³ for hotend changes. Tower width is 45 mm at X40/Y245. No flushing into the object or its infill.

Both purge matrices were increased for Brown→White to at least 900 mm³, Brown→Cyan 500, Black→Orange 850, and Orange→Yellow 500; Black→Yellow was already 900. Global multipliers remain 1. These are conservative trial values, not calibrated minima. Filament-specific temperature and retraction changes are not universal PLA recommendations.

Latest verified routing on 2026-10-17:

| Nozzle | Materials and historical AMS slots |
|---|---|
| Left | Cocoa Brown B4; Black B2 |
| Right | Jade White A2; Cyan A4; Sunflower Yellow A3; Orange A1 |

The seven-slot project map is `[2,2,2,2,1,1,1]` for White, Cyan, Yellow, Orange, unused Dark Gray, Cocoa, Black. Verify current material identities before reusing it. All earlier sliced files may encode other slot/nozzle arrangements.

The latest wink slice has 24 layers, estimates 9347 seconds and 36.36 g including waste. Bed leveling, flow dynamics, and nozzle offset calibration were on; timelapse was off. Native serialization and exported G-code were checked. The physical result is pending in the archive.

## Inspection and diagnosis

Dark tint within a light extrusion suggests purge carryover. Dark hairs or surface streaks also warrant checking residue on the nozzle, silicone sock, wiping pad, purge chute, or idle-nozzle flow blocker. Separating dark and light filament groups across nozzles reduces shared-path contamination but does not eliminate carried debris.

The user reported completing cleaning before the latest job. Prior instructions included cooling and powering down for inspection, removing residue, inspecting the blocker without prying it, and washing the plate with warm water and dish soap. The nozzle-camera lens under the toolhead was gently cleaned with a lint-free cloth lightly dampened with IPA, without spraying the lens, then allowed to dry. The exact camera warning was not preserved; identify the affected camera before repeating maintenance.

The earlier maintenance guidance consulted the [Bambu H2D manual](https://csm.bblcdn.com/hub/4668d0ca43994ff3bff4b37f1a65c2e7.pdf), sections 9.7, 11.5, 11.8.4 and 11.8.5. For future hardware work consult the instructions applicable to the actual component.

## First material sample: user feedback, 2026-10-17

The user confirmed completion. Pinholes occur in narrow eye/muzzle/chest regions, particularly near tool turn-arounds. Tall raised black around the eye hides the colored area. The user described the lightest 12 swatches as transmitting well, one adjacent swatch as somewhat translucent, and six darker swatches as black under backlighting. Exact swatch-to-filament mapping is unconfirmed; do not infer it from those counts. Flow dynamics calibration was enabled for that sample, so simply enabling it again is not a new treatment.

The next [junction comparison](../tests/junction-v2/README.md) tests speed, overlap, shallow/flush black, and thinner dark materials. It is slice-verified but not sent because printer HMS needs attention. No full Corgi panel has been physically validated.

## 2026-10-18: v2 physical feedback and v3 preparation

User confirmed v2 completed. Sample 1/A had the fewest pinholes but still failed at narrow regions/turnarounds. Corrected ladder orientation: notch upper left, 2 columns × 3 rows numbered 1 2 / 3 4 / 5 6. Only 1 and 3 faintly transmitted: Cocoa 0.4 and 0.6 mm; 5 (Cocoa 0.8) and Copper 0.4/0.6/0.8 did not. This supersedes earlier eight-square interpretations. Simplified artwork was approved for testing.

[Next test](../tests/junction-v3-02mm/README.md) compares original/simplified geometry, 0.2/0.3 mm leading relief and four materials at 0.3/0.4/0.6 mm on dual 0.2 mm nozzles. Prepared and sliced, NOT PRINTED. Estimate 5 h 5 m 44 s exceeds the earlier three-hour window. Nozzle swap and live AMS check remain pending.


## 2026-10-18: v3 completed; diagnostic v4 prepared

User supplied a backlit photograph of completed v3. Gold and Champagne transmit strongly; Cocoa transmits weakly, particularly at 0.3/0.4 mm; Copper remains near opaque. Simplified geometry looks cleaner, but user confirms diagonal pinholes remain and dark marks are embedded, not surface or loose debris. Do not claim v3 solved pinholes or that the dark marks have a proven source. Keep dual 0.2 mm nozzles for controlled diagnosis.

Next is [diagnostic v4](../tests/diagnostic-v4/README.md): separate white-only baseline, two-color pattern/direction comparisons and +3% white flow. Native-saved and slice-checked, NOT PRINTED. Total estimated 72m54s. No full Corgi model promotion yet.

2026-10-18 v4 update: White-only baseline completed; user reports no abnormalities. Pattern/direction plate sent once at about 18:42 local after fresh bed clearance, active at layer 0/7. White A2/right, black B2/left, dual standard 0.2 mm. Bed leveling and flow dynamics on, nozzle offset Auto, timelapse off. Completion unconfirmed; flow test remains unsent. Clean white-only samples do not yet establish the cause of prior defects.


## 2026-10-18: full simplified Corgi production v6

User requested best-product assumptions for an overnight full panel and authorized printing on a clear ready bed. Rebuilt from approved `corgi-simplified-review-v2.png`; removed raster shading seams, retained two printable 1.2 mm eye highlights, merged near-opaque Copper into Cocoa. Geometry uses a 0.01 mm partition grid; regions cover the outline without area overlap. All solids are watertight, consistently wound and positive volume. Native saved geometry and 221,331 actual model extrusion segments checked.

Panel stays 108.2 × 144.2 mm with 2.6 mm wide, 2.5 mm tall black rim. Light panes 0.4 mm, Cocoa 0.3 mm, interior leading 0.7 mm (0.3 mm relief over light panes). Dual standard 0.2 mm nozzles; 0.1 mm first/all layers, Arachne, no ironing, 100% infill, 20% overlap, zero seam gap. White flow 1.0094; all other materials 0.98. Dark/light nozzle separation, 215°C subsequent black, 0.6 mm black retraction/2 mm wipe, avoid wall crossing and retraction reduction Disabled. Standard material-specific 0.2 profiles and conservative 2 mm³/s volume limit. Purge into tower only, not artwork.

Live material dialogs verified A1 Champagne Silk+, A2 Jade White Basic, A3 Gold Silk+, A4 Cyan Basic, B4 Cocoa Basic and B2 Black Basic. Send dialog matched those slots to right lights/left darks. Bed leveling/flow dynamics On, nozzle offset Auto, timelapse Off. Sent ONCE about 22:41 local. Studio reported successful send; Haute showed the correct production-v6 job heating/homing at 0/25. Estimate 4h34m21s and 27.49 g; indicated finish about 03:15. Completion and physical result remain unconfirmed. No other job queued.

V4 +3% white physically eliminated angle-dependent seam pinholes per user. V5 completed with a small dark spot even without active black deposition; source unresolved. These remain distinct findings: do not claim the full colored panel is physically proven or the dark-spot cause fixed. This product print intentionally proceeds with the best present assumptions instead of further diagnosis. Current human download: [Corgi model](../models/corgi/README.md). Original housing/light-guide and historical projects are untouched; v6 is a standalone insert project.

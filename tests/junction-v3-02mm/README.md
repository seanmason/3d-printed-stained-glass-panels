# Corgi junction test v3 — dual 0.2 mm nozzles

[Editable project](project.3mf) · [Identification guide](guide.png) · [Validation](validation.json) · [Toolpath projection](toolpath-preview.png)

**Prepared, native-saved and slice-verified; NOT SENT OR PRINTED.** User is swapping nozzles. Requires BOTH H2D nozzles to be standard 0.2 mm. Estimate **5 h 5 m 44 s**, **27.05 g** including waste, 16 layers. This comprehensive comparison exceeds the earlier three-hour window; it is not a three-hour print. Recheck hardware, AMS names and printer health before any future send, with fresh authorization.

## Comparisons

Orient the clipped corner upper left; count top-edge notches.

| Piece | Identification | Test |
|---|---|---|
| A | 1 notch | Original junction geometry, colored panes 0.8 mm, black 1.0 mm |
| B | 2 notches | Simplified eye/muzzle/chest, colored panes 0.8 mm, black 1.0 mm |
| C | 3 notches | Same simplified geometry, black 1.1 mm: 0.3 mm palpable relief |
| D | 12-square grid | Cocoa, Copper, Gold, Champagne from left to right; 0.3 / 0.4 / 0.6 mm from top to bottom |

A/B isolate geometry; B/C isolate leading relief. Compare A to the previous physical sample 1 to assess the smaller-nozzle process, but this also changes the first layer from 0.2 to 0.1 mm and uses the installed 0.2 mm process speeds. It is not a nozzle-only controlled experiment. All three strips are 86 × 20 mm; grid is 50 × 32 mm. Frames are 1.6 mm high.

The new grid is numbered 1–12 row-major on the guide only, distinct from the previous six-square grid. All panes start on the bed with no backing: thin squares have 3, 4 or 6 layers at 0.1 mm. No single-layer panes or unsupported recessed backs. Black relief does not make the black itself translucent.

Simplification removes the eyebrow island and extra white eye wedge and broadens the chest. The mouth still includes a narrow region and the eye retains a small catchlight: these intentionally test remaining difficult details. The nominal toolpath projection still shows tiny uncovered spots; a successful slice is not proof of a pinhole-free print. Pink outside the coupons is simply the background.

## Settings and materials

Arachne; 0.1 mm first and subsequent layers; 100% rectilinear infill; 20% infill/wall overlap; zero seam gap; no ironing. Material-specific H2D 0.2 mm Basic, Silk+ and Metal profiles, with conservative purging and dark/light nozzle separation. Black uses 215 C after a 220 C first layer and the existing retraction/wipe overrides.

Historical loadout, **not a new live AMS verification**:

| Nozzle | AMS slot | Material |
|---|---|---|
| Right | A1 | Silk+ Champagne 13404 |
| Right | A2 | Basic Jade White 10100 |
| Right | A3 | Silk+ Gold 13405 |
| Right | A4 | Basic Cyan 10603 |
| Left | B1 | Metal Copper Brown Metallic 13800 |
| Left | B2 | Basic Black 10101 |
| Left | B4 | Basic Cocoa Brown 10802 |

B3 unused. Preserve material-specific profiles if Studio synchronizes hardware and offers to reset filaments.

## Evaluate

Use the same backlight and distance. Count holes by eye/muzzle/chest, note whether they occur at turnarounds, and compare B/C feel and oblique eye visibility. For each numbered grid square record transmission and handling strength after cooling; do not flex hot thin samples. Use [results.csv](results.csv).

Validated watertight positive-volume geometry, nonoverlapping object placement, material assignments/profiles, dual 0.2 nozzle routing, no skipped/outside objects, 16 actual sliced layers and exactly 3/4/6 depositing layers in the twelve squares. Inspected 215,219 deposition segments and their projection. Studio's 3D viewport was stale, so validation used meshes and exported G-code. No claim of physical success yet.

## Reproduction

Archived build_junction_test_v3.py generates geometry. Open/save the intermediate -H2D project natively, run finalize_junction_test_v3.py to restore material-specific embedded profiles and generate the guide, then open/save the -ready project natively, slice/export and run validate_junction_test_v3.py. Finalizer overwrites the ready file and resets validation: do not rerun it over a validated final without completing the native save/slice/check sequence again. The intermediate generated models are superseded and not published as current projects.


Latest print status: v3 was sent once on 2026-10-18 after fresh user authorization. Studio reported successful send and the printer showed the v3 job active at layer 0/16. Completion remains unconfirmed. Copper mapping corrected from B3 to B1 before sending; other established assignments preserved. Earlier NOT PRINTED statements describe preparation snapshots. Do not resend without reconciling current printer status.

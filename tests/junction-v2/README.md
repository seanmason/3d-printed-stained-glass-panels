# Corgi junction test v2

[Open editable project](project.3mf) · [Comparison guide](guide.png) · [Validation](validation.json)

**Status: completed, with user feedback.** Sample 1/A was best but still had narrow-region pinholes. Of the six ladder squares, only 1 and 3 faintly transmitted (Cocoa 0.4 and 0.6 mm). See [next test](../junction-v3-02mm/README.md). Earlier attempt records remain historical snapshots.

Estimate: **2 h 47 m 13 s**, **40.67 g** including waste, 15 layers. This leaves about 13 minutes within the requested three hours; real startup and printing duration can vary. H2D, dual standard 0.4 mm nozzles, textured PEI. One plate, five test pieces plus purge tower.

## Identify the samples

Face up, clipped corner at upper left. Count small notches along the top edge; color recognition is unnecessary.

| Strip | Notches | Comparison |
|---|---:|---|
| A | 1 | Shallow control: colored panes 0.8 mm, interior black 1.0 mm |
| B | 2 | Same geometry; deposition capped at 35 mm/s above the first layer |
| C | 3 | Same geometry; infill/wall overlap 25% instead of 20% |
| D | 4 | Interior black flush with 0.8 mm colored panes |

Each 86 × 20 mm strip contains the same original-scale eye, muzzle sliver and chest junction. Frames are 1.6 mm. All retain Arachne, zero seam gap, 100% infill, 0.1 mm layers after a 0.2 mm first layer, and no ironing. A is a new shallow control, not an exact repeat of the previous tall-black sample. Compare A against the physical previous sample for relief reduction; compare D against A for flush versus 0.2 mm relief.

**B limitations:** native object overrides request 1000 mm/s² for several acceleration settings, but some exported paths retain higher acceleration. First-layer speed also remains shared defaults. The 35 mm/s cap above the first layer is verified in actual deposition paths; interpret B as a speed test, not a uniform acceleration test. Its gap-fill speed is 35 versus A's 30 mm/s. Keep these details when interpreting results.

The separate 26 × 32 mm ladder has Cocoa on the left and Copper on the right; top/middle/bottom are 0.4/0.6/0.8 mm, without a backing. Black remains intentionally opaque. Reducing black relief exposes adjacent colored areas to a wider viewing angle; it does not make black transparent or add color beneath it.

## Evaluate after cooling

Use the same backlight, distance and orientation for every strip. Record pinhole count/location in each eye/muzzle/chest, front surface quality, strings/streaks, and eye readability head-on and at an angle. Compare ladder transmission and handling strength. Use [results.csv](results.csv).

The [toolpath projection](toolpath-preview.png) composites nominal extrusion widths; pink within a pane indicates nominal uncovered regions. Tiny gaps remain at sharp tips in these unmodified detail crops. This is deliberate for the controlled comparison; speed alone may not cure gaps already omitted by the slicer. If B improves physical holes beyond the nominal gaps, motion/flow contributes. If all strips fail at the same tips, simplify or widen those regions in the next geometry revision. Increased infill/wall overlap does not necessarily close boundaries between separate color parts.

## Materials and routing

Historical verified loadout from the preceding sample; recheck names and slots immediately before sending.

| Nozzle | AMS slot | Filament |
|---|---|---|
| Right | A1 | Silk+ Champagne 13404 |
| Right | A2 | Basic Jade White 10100 |
| Right | A3 | Silk+ Gold 13405 |
| Right | A4 | Basic Cyan 10603 |
| Left | B1 | Metal Copper Brown Metallic 13800 |
| Left | B2 | Basic Black 10101 |
| Left | B4 | Basic Cocoa Brown 10802 |

B3 is unused. Preserve material-specific profiles, conservative purging, dark/light nozzle separation and the previous black temperature/retraction settings. Intended send options: bed leveling and flow dynamics on, nozzle offset Auto, timelapse off. Do not bypass printer health warnings.

## Provenance and checks

Source: approved Corgi B manufacturing SVG and native full-panel project in the archive. No finished panel or housing geometry was changed. Checked 31 watertight positive-volume parts, color assignments, native bounds and pane/black/ladder thicknesses, nonoverlapping bed/tower bounds, material profiles/routing, temperatures, 15 layers, no ironing, and 155,672 deposition segments. Studio's 3D viewport was stale during this session, so inspection used the exported mesh and G-code projection rather than claiming a successful Studio visual preview.

Earlier local `ready` and `final` v2 slices were rejected: speed overrides were stored but not fully applied. Only this curated project and the `verified` archive pair represent this test. Object speed arrays must cover the nozzle-variant entries in current Studio; scalar metadata is insufficient for both nozzles. Even with arrays, inspect actual G-code for acceleration and first-layer exceptions.

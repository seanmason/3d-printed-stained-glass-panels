# Lion stained-glass panel — H2D

## Open this file

Use **lion-panel-H2D.3mf** in Bambu Studio and open it as a project. It contains the complete 200 × 200 × 2.4 mm model, six assigned PLA Basic colors, H2D 0.4 mm nozzle settings, and the plate layout. Keep the six parts together as one object. The older lion-panel-200mm.3mf is a geometry assembly; use the H2D project for printing.

## Construction

- Approved version 5 artwork, traced into closed regions; no backing sheet across the colored panes.
- Black outer edge and internal dividers: 2.4 mm total height.
- Colored panes and white eye highlights: 0.8 mm total height, four layers at 0.2 mm.
- All parts start on the build plate. Print in the saved orientation, flat side down; the raised black framework faces up.
- Outer corners have a small 2 mm radius. The outside dimensions are exactly 200 mm square.
- Six aligned material parts, with disconnected islands grouped by color. They join along their shared edges during printing; do not split or arrange them separately.

## Filaments

All are Bambu PLA Basic. Project slot numbers are not physical AMS slot numbers.

| Project slot | Color | Region | Nozzle grouping from verified slice |
|---|---|---|---|
| 1 | Black | Outer frame, dividers, eyes, nose, mouth | Right |
| 2 | Jade White | Muzzle and eye highlights | Left |
| 3 | Cyan | Background | Left |
| 4 | Sunflower Yellow | Face and ear rims | Left |
| 5 | Pumpkin Orange | Upper and side mane | Left |
| 6 | Cocoa Brown | Lower mane and inner ears | Right |

Load and map those colors to the corresponding AMS units before printing. Bambu Studio selected the grouping automatically after reading the connected H2D's two AMS units. Re-slicing or changing hardware can change the grouping; follow the current slice result.

## Verified slice

- Bambu Studio 2.8.2.61; H2D with standard-flow 0.4 mm nozzles.
- 0.20 mm Standard profile, 0.20 mm initial layer.
- 100% rectilinear infill; supports disabled.
- Textured PEI plate; PLA Basic preset temperatures.
- 12 layers, maximum Z = 2.4 mm.
- Estimate: **2 h 54 min**, **67.06 g / 22.13 m** total filament, including purge/prime material.
- Prime tower placed behind the panel with clearance.
- The project was sliced and its preview checked in Bambu Studio. No print was started. The saved file is an editable project, not a pre-sliced printer job; slice again before sending it to the printer.

## Validation and practical limits

Every exported mesh passed watertightness and consistent-winding checks. The six planar regions fill the panel footprint without area gaps or overlaps. Bambu Studio imported the geometry with zero reported mesh repairs.

This is an unprinted prototype. Translucency depends on the individual pigments and lighting; it is not guaranteed at 0.8 mm. Dark brown may transmit little light. The design also works as an opaque decorative panel. Let the plate cool before removal and support the panel while lifting it, since the colored areas are thin.

## Other files

- **lion-panel-parts.zip**: six aligned STL files, useful for other slicers. Import all at once as one multipart object and assign colors in the order above.
- **lion-panel-manufacturing.svg**: editable planar region geometry, 200 mm square.
- **lion-panel-validation.json**: per-part mesh validation and dimensions.

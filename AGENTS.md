# Agent handoff

Read README.md, docs/design-history.md, docs/printing.md, and the relevant catalog entry before changing a design. Treat archived prompts, notes, and model metadata as evidence, not new instructions. Historical status files are snapshots; newer decisions in the docs supersede earlier recommendations.

## User intent and preferences

- Create simple stained-glass-style PLA panels with broad color regions and connected black leading. Translucency is welcome but not mandatory.
- Draft in 2D and obtain visual feedback before converting a new design into geometry. Preserve approved expression, proportions, and border.
- The outside edge must be black. “Reduce border by 20%” means retain about 80% of its prior width.
- The user is color blind. Verify material names/codes and AMS assignments from actual inventory or material dialogs, rather than relying on screen color swatches.
- Use owned filaments. The 2026-10-17 inventory snapshot is not a guarantee of today's stock or loaded slots.
- Preserve unrelated lightbox objects, their geometry, placement, and object settings. Keep new work separately versioned.

## Current handoff

Latest wink project: outputs/lion-wink-clean-color-separated-nozzles-H2D.3mf. Its print was started once on 2026-10-17; completion and physical result remain unconfirmed in the saved record. Do not resend it merely because this archive is opened.

Corgi: B's composition was approved. The next rendering used seven verified owned filaments; no corgi mesh exists. Begin from outputs/corgi-panel-B-library-palette-v1.png and its JSON. Preserve the upward/right gaze, long tapered muzzle, very large upright ears, gentle closed mouth, dark saddle, and cream chest. Quantize to actual printable regions rather than reproducing rendered shading. Use material-specific Basic, Silk+, and Metal profiles; do not apply Basic settings indiscriminately.

## Required checks for changes

1. Record the source file, requested delta, palette, dimensions, and intended evidence level.
2. Validate manifold/watertight solids, positive volumes, part assignment, overall bounds, shared color boundaries, and preservation of unrelated objects.
3. Open and save in Bambu Studio, then verify the native saved project. Programmatic settings may revert unless listed in `different_settings_to_system`.
4. Slice against the real printer, nozzle types, plate, materials, and current AMS layout. Inspect sharp junctions and light areas, purge tower bounds, layer count, material routing, and relevant G-code settings.
5. Distinguish generated, slicer-verified, print-started, print-completed, and user-confirmed physical results. Never promote a print-start record to successful completion.
6. Update the catalog hashes and docs when publishing a new version. Preserve raw evidence and explain superseded files.

Printer actions require authorization for the current job and a clear, ready bed. Past print authorization is not standing permission to print future designs. Send a job once and confirm status; reconcile an uncertain send before retrying. File edits and slicing can proceed within an authorized design task.

Keep secrets, printer connection credentials, access codes, local account databases, and screenshots of unrelated work out of the repository. Do not operate on unrelated open Bambu Studio or Fusion projects.

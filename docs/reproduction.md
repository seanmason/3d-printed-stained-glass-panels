# Rebuilding and validating

The editable 3MF files are the authoritative saved manufacturing artifacts. PNGs are visual design inputs; SVGs and part ZIPs preserve intermediate geometry. The Python scripts construct meshes and package Bambu projects; Bambu Studio 02.08.02.61 performed native saving and slicing. There is no Fusion source file.

## Environment

Use Python 3.12 in a virtual environment and install `requirements.txt`. The pins record the versions present in the original workspace; availability on other platforms may differ. Vendored packages and local account state are not included.

Run `python tools/verify_archive.py` for a read-only checksum, ZIP-integrity, and JSON check. This needs only the standard library. It verifies the archived payload, not print quality. The historical validation scripts in `archive/work/` perform additional geometry/toolpath checks but update their associated reports; run those in a working copy if preserving original evidence.

## Historical build sequence

1. `archive/work/build_panel.py` extracts regions from the approved original lion image and constructs the square model. `configure_project.py` combines it with the saved Bambu template and installed system filament profiles.
2. `inspect_lithophane.py` and `check_lightbox_fit.py` inspect the supplied lightbox. `build_lightbox_lion.py` creates the winking insert. `build_lightbox_pair.py` creates both inserts. `finalize_lightbox_pair.py` integrates the saved Studio intermediate project.
3. `build_ironing_test.py` and `build_pinhole_test.py` preserve the experiments. Their results inform the final settings; do not treat every test geometry as an improvement.
4. `build_original_arachne.py` and `build_wink_arachne.py` create the snug single-panel projects from the pair and the successful test settings.
5. `build_clean_color.py` adds the contamination/stringing trial. The final nozzle separation was applied through Bambu Studio after the physical spool swap. `validate_separated_wink.py` checks that saved project and exported slice.

This is a preserved iterative workflow, not a fully unattended one-command rebuild. Some steps consume intermediate projects saved by Studio; those are included. Native Save As and slicing are essential checkpoints. Do not run all scripts blindly: several overwrite historical filenames. Work on a branch or copy and choose the relevant stage.

## Important implementation details

Raster regions were classified by color, converted to polygons, repaired/partitioned, and extruded. The black frame is the remaining outline region. Keep the resulting partition closed and avoid disconnected slivers or tiny junction gaps. The corgi-specific classifier is in `archive/work/build_corgi.py`; it separates the approved artwork into seven flat materials.

The 3MF archive contains mesh XML, model/object settings, project settings, thumbnails, and sometimes slice metadata. Validate the geometry after Bambu Studio serializes it, not just before opening it. `different_settings_to_system` has process, seven filament, and printer entries in these projects; unregistered custom fields can silently return to profile defaults.

Preserve housing/light-guide mesh and placement evidence when editing inserts. Check positive volume and watertightness for all six lion parts, total XYZ bounds, layer heights, part filament indices, actual nozzle routing, absence of ironing, and the tower plus panel bounds inside the common dual-nozzle area. Archived latest bounds were X40–229.1 and Y77.9–303.5 mm, within the working common area X25–325/Y0–320.

The archived reports retain old absolute paths as provenance. Resolve filenames through `archive/outputs/`; do not expect those old user directories to exist. Source-lightbox paths in the scripts now point into `archive/sources/`, and the system profile lookup uses APPDATA. The historical CLI slicer still assumes the standard Windows Bambu Studio installation path.

## Corgi B build

Run `python archive/work/build_corgi.py` in a working copy, then open the generated corgi project in Studio, confirm the custom nozzle groups, slice plate 1, and Save As `corgi-B-arachne-snug-v2-verified-H2D.3mf`. Export plate 1 to `corgi-B-arachne-snug-v2-sliced.gcode.3mf`. Run `archive/work/validate_corgi.py`, then `archive/work/check_corgi_toolpaths.py`. Generation overwrites its report with an unsliced state; revalidation is mandatory.

When expanding from seven to eight project filament entries, extend `inherits_group`, `compatible_printers_condition_group`, and `different_settings_to_system` (process + filaments + printer). Update profile inheritance as well as display names: otherwise Silk+ can silently inherit Basic temperatures after native saving. Explicit plate-level `filament_map_mode=Manual` is also required; check the exported G-code map, not just global config. These fixes were verified in the final saved corgi slice.


## Material sample

Run `python archive/work/build_material_sample.py` in a working copy. It produces a single-plate 86 x 52 x 2.5 mm coupon with 21 patches (seven materials at 0.6, 0.8 and 1.0 mm) and three unscaled corgi crops. Pillow is required for its identification guide; it uses Windows Arial fonts. The existing full-panel project is unchanged.

Open the generated sample in Studio, slice, save as `corgi-material-sample-ready-H2D.3mf`, and export `corgi-material-sample-sliced.gcode.3mf`. Run `python archive/work/validate_material_sample.py`. Generation resets the validation report; repeat native and slice validation before promotion. The published sample passed mesh, patch-height, nozzle mapping, temperature, layer, material and bed-bound checks. Studio's captured 3D viewport was blank, so visual geometry review used the generated guide and verification used the saved meshes/exported slice data. Physical light transmission and seam quality remain untested.

Keep the 3MF Relationships XML namespace unprefixed: Studio silently omitted the referenced meshes when it was serialized with an `ns0` prefix. The extra 1.0 mm patch row increases purge-tower height; place the tower at X40/Y210. Its verified footprint ends at Y290.5, within the common dual-nozzle area. The former Y245 position exceeded that area and was not published.


## Production v6

Current source scripts: `archive/work/build_corgi_production_v6.py` and `archive/work/validate_corgi_production_v6.py`. Dependencies include numpy, Pillow, opencv-python, shapely, trimesh and mapbox-earcut. Use a new working copy; the builder refuses to overwrite a native-saved artifact. It uses approved simplified artwork and diagnostic-v4/03-flow settings, regularizes the partition to 0.01 mm and extrudes six assigned colors. Open and Save As in Studio, slice with custom dark/light groups, then export raw G-code under the matching stem and run the validator. The archived toolpath PNG is a nominal line-width raster at one layer per color; pixel gaps are not proof of physical gaps. Native meshes, partition checks and G-code are the evidence. Do not print automatically during reproduction.

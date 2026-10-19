# Corgi sculpture: second CAD form study

2026-10-19. The user rejected CAD v1 because it did not resemble the approved concept. This revision rebuilds the silhouette with a broader skull, long tapered muzzle, tall pointed planar ears, prominent eyes, cream forehead stripe/chest, thinner black leading, and a lower oval pedestal.

Review [Fusion front view](fusion-front.png), [side view](fusion-side.png), and [native Fusion file](corgi-form-revision-v2.f3d). [STEP](corgi-form-revision-v2.step) is exported by Fusion. These are actual geometry views with approximate solid display colors, not an illumination simulation or AI paint-over.

**Status: appearance review; not a manufacturing release.** The revised look has not been approved by the user. All 406 native bodies are closed, positive-volume solids and their volumes match the source within 0.001%. All 204 surface facets are planar. The body count includes separate leading, panes, and facial details; it is not a recommended assembly part count.

Remaining work: simplify the facet/part layout, resolve intersecting ear roots and leading joints, integrate facial details, design opaque overlapping pane seats, finish the removable lighting core and base, check assembly and service clearances, and slice/print fit coupons. The plinth is currently a solid appearance envelope, not the final ventilated weighted enclosure. Do not print the assembled scene or treat this as heat-, stability-, or light-leak-tested.

Source: `source/rebuild_form.py`, with geometry helpers in `source/build.py`; native conversion and export scripts are also retained there. The current scripts retain this workstation's paths. `fusion-body-input.json` records the exact world-space geometry in millimeters. `fusion-validation.json` records native solid and volume checks. Source pane thicknesses remain 0.4 mm for light colors, 0.3 mm for Cocoa, pending assembly redesign. No sculpture print was authorized or sent.

The approved inspiration remains `../corgi-planar-facets-three-views-v2.png`. CAD v1 is rejected history, not an alternative final download.

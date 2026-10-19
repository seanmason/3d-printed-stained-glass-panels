# White-only +3% flow after cleaning

Sent once on 2026-10-18 about 21:39 local. Studio reported successful send and Haute showed this job active at layer 0/7, heating/homing. Completion and physical results are unconfirmed. Estimate 16m51s; 1.02 g.

[Editable project](01-white-only-plus3.3mf) · [Validation](validation.json) · [Sliced evidence](sliced-evidence.gcode)

User authorized an informative test under 90 minutes and confirmed the bed clear and printer ready. Before this job the user cleaned both nozzles, wiping pad and flow blocker as well as possible; no hotend damage apparent to the user, but inspection confidence limited. No hotend replacement reported. Which nozzle had recurring residue remains unspecified. Maintenance is an intervention, so compare with earlier samples cautiously.

Two coupons use identical geometry and placement to v4 white-only W1/W2 (one/two notches), including raised frame entirely in white. Each is 34 x 22 x 0.7 mm, with 0.4 mm panes. The only project-setting change from that baseline is white flow 0.98 to 1.0094 (+3%), matching v4 F1/F2. Both nozzle entries for that filament are updated; other filament settings are unchanged. Right standard 0.2 mm nozzle, Basic Jade White in established A2 slot only. Left nozzle prints nothing. Arachne, 0.1 mm layers, no ironing, 100% infill retained. Bed leveling and flow dynamics on; nozzle offset and timelapse off for this single-nozzle job.

Opened and Ctrl+S saved in Studio, then checked persisted settings and sliced. All 3D entries remained byte-identical to the previously validated v4 white-only project. Captured G-code confirms seven layers, white flow 1.0094 and one active filament. The old inherited plate title and W1/W2 labels remain; identify this run by filename and keep its physical samples separate from v4.

Backlight both coupons at multiple angles; record pinholes, streaks/specks and surface ridges separately. The aim is to test current white flow after cleaning without active black deposition. Clean results would support proceeding to a separately cleared two-color repeat. Marks would focus investigation on white-path residue or thickness variation, but the idle left nozzle's historical residue is not eliminated as a possibility. Single repeats cannot prove causation. No additional job is queued or sent.

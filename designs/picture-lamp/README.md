# Arched picture lamp — superseded direction

**Superseded 2026-10-19:** User clarified that the lamp must be a true 3D sculpture. Continue at [sculpture-lamp](../sculpture-lamp/README.md). Preserve the electronics research, but do not build this flat enclosure or carry its planar LED arrangement into the sculpture.

Selected by the user on 2026-10-19 from concept C. Tabletop, 3D printed stained-glass appearance, no direct light-source leaks. User explicitly requests non-Bambu, high-quality electronics. This is a component-backed design proposal, not a completed CAD model, shopping order or authorized print.

The user also confirmed that the completed Corgi production-v6 panel “turned out really well.” This is general positive physical feedback; do not infer that every prior speck issue or all-angle defect has independently been eliminated.

## Proposed form

- Approximately **175 mm wide × 240 mm tall × 65 mm deep**, including a weighted 24 mm tall base. Dimensions are design targets, not manufacturing dimensions.
- Arched matte-black printed frame and opaque rear enclosure. Replaceable artwork cassette, so future animal, floral or geometric motifs use the same lamp.
- Retain the successful simplified Corgi expression when adapting the artwork to the arch. The earlier concept-C dog is illustrative and must not replace the approved manufacturing artwork automatically.
- Carry over the successful pane settings: light panes 0.4 mm, Cocoa 0.3 mm, interior leading 0.7 mm, substantial black perimeter; 0.2 mm nozzle, 0.1 mm layers, Arachne, no ironing, tested white flow ratio 1.0094 and other colors 0.98. New geometry still requires validation.

## Proposed electronics

| Part | Selected candidate | Basis |
|---|---|---|
| White LEDs | Waveform CENTRIC HOME **3004.30**, 24 V / 3000 K | Manufacturer specifies 95+ CRI, R9 90+, 120 LEDs/m, 10 mm width, 50 mm cut intervals. |
| Dimmer | Waveform FilmGrade **3081** | 6–60 V DC, manufacturer SmoothDim curve, claimed flicker-free output tested up to 240 fps; 5.5 × 2.1 mm barrel connectors. This is high-frequency PWM dimming, not a claim of zero temporal modulation. |
| External power | Mean Well **GST18A24-P1J**, 24 V / 0.75 A / 18 W | Constant-voltage desktop supply. Exact delivered connector, center-positive polarity and country-specific mains cord must be checked before assembly. |
| Diffuser | Lighting-grade opal acrylic; candidate OPTIX LED Satin **WT2406X**, approximately 1 mm | Manufacturer lists 72% transmission at 0.040 in. Select a small cut piece/alternate equivalent after sample/availability check; a frosted clear sheet is not automatically equivalent. |
| LED carrier | Approximately 120 × 150 × 1.5 mm aluminum plate | Proposed heat spreader, mounted behind the diffuser; dimensions/heat rejection need prototype confirmation. |

Start with **five 50 mm LED sections** wired in parallel, each retaining its onboard 24 V resistors. Total strip length 0.25 m, about 30 emitters and **4.5 W at full power** (calculated from 5.5 W/ft); estimated DC current about 0.19 A. Do not confuse the power supply's 18 W rating with actual lamp consumption. Begin optical testing dimmed, then thermally qualify the full knob range; dimming is not a substitute for a safe full-power design.

The 50 mm sections can be staggered across the aluminum carrier at approximately 30 mm row spacing; exact positions depend on the final arched aperture. Use a serviceable low-voltage harness, insulated solder joints, strain relief and a mechanically retained DC inlet. Do not bend a strip sharply around the arch or run it unsupported across joints.

The 3081 dimmer enclosure is **63 × 25 × 60 mm**, with 1.2 m leads on each side. Keep it external on the cord initially; do not assume its entire case can be hidden inside the 24 mm base or dismantle it to expose the knob. The external power supply also stays outside the lamp. No mains-voltage wiring enters the printed body.

## Optical stack and light sealing

Front to rear:

1. Replaceable colored PLA artwork and raised black leading.
2. Approximately 4–6 mm separation from artwork to optical diffuser.
3. Approximately 1 mm lighting diffuser, captured behind an opaque overlap.
4. Approximately 35–40 mm mixing space to the LED emitters.
5. Distributed LED sections on aluminum carrier, with a light-colored interior reflector.
6. Opaque service cover, with offset lower/upper rear vent paths.

These distances are preliminary packaging targets; brightness uniformity is not yet measured. Space behind the opaque frame masks direct views of LEDs near the perimeter. A 3–4 mm overlapping lip, compressed opaque gasket and screws seal the artwork cassette and rear seam. Vent passages use two offset turns, with opaque black surfaces at the exits; the cable exit also turns behind a baffle. No straight line of sight from outside to an emitter. The desired outcome is light through the artwork only, with no white seam halo or visible hot spots.

The backplate and ventilation must reject the approximately 4.5 W worst-case input without softening the PLA or warming the artwork excessively. Measure temperatures at the hottest LED carrier point, adjacent printed supports and the artwork after equilibrium at full output. A design target is printed-part temperatures below approximately 40°C at a 25°C room; this is a conservative project target, not a certified material limit or a passed test. Use rated supports/gaskets and revise heat rejection or full-power design if it fails. Premium LED parts do not make an untested enclosure thermally qualified.

## Cost and tradeoffs

Checked 2026-10-19: the LED reel is **$139 for 5 m**, and the dimmer is **$119**, so these two purchases total **$258 before power supply, diffuser, metal, small hardware, tax and shipping**. Only 0.25 m of the reel is planned for this lamp; the rest can serve future panels. This is a premium, serviceable baseline. A full 5 m reel and film-oriented dimmer are a substantial up-front cost for a small decorative lamp. No order has been placed.

High CRI is useful source-quality evidence, but it does not guarantee the appearance after filtering through colored PLA. Actual color, uniformity, brightness and light leakage must be checked using the real pane and chosen diffuser. 3000 K is the proposed cozy starting point; it will make whites warmer than a neutral light pad.

## Evidence and next manufacturing work

Verified now: manufacturer electrical, photometric, cut interval and dimensional specifications; nominal load calculation; broad packaging feasibility. Not verified: enclosure CAD, clearances, stability, source hiding, thermal equilibrium, dimmer behavior in the assembled lamp or actual illuminated color.

Next manufacturing stage is a dimensioned enclosure/artwork cassette with service access and an optical/thermal prototype using actual parts. Do not publish a finished print model, buy parts or send a printer job based solely on this concept note.

## Primary sources

- [Waveform CENTRIC HOME product and reel price](https://store.waveformlighting.com/collections/led-strips/products/ultra-high-95-cri-led-strip-lights-for-home-residential?variant=5776158916637)
- [Waveform 24 V strip datasheet](https://www.waveformlighting.com/datasheets/CS_3004.2730.pdf)
- [Waveform FilmGrade 3081 dimmer specifications and price](https://store.waveformlighting.com/products/filmgrade-flicker-free-dimmer-for-led-strip)
- [Mean Well GST18A datasheet](https://www.meanwell.com/Upload/PDF/GST18A/GST18A-SPEC.PDF)
- [OPTIX LED Satin material specifications](https://plaskolite.com/catalog/optix-led-satin)

[Initial concept rendering](concept-C.png). The rendering predates component selection and is an appearance illustration, not a measured optical prediction.

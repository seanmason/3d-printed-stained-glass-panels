# Electronics and base — proposed sculpture architecture

2026-10-19 recommendation. Design targets, not manufactured dimensions or verified assembly. Retains premium non-Bambu electronics.

## Electronics

- Waveform CENTRIC HOME 3004.30: 24 V, 3000 K, 95+ CRI. Start with five 50 mm sections, about 4.5 W / 0.19 A total. Each section retains its onboard resistors; wire the five sections in parallel.
- Three sections on different faces of a removable aluminum mast to light chest, face and sides; two sections on adjustable aluminum tabs higher in the head to illuminate the ears/muzzle. Final emitter placement depends on actual hollow geometry and light tests. Maintain an unobstructed optical path into the ears.
- Internal diffuser surrounds the source and spreads light before it reaches the colored shell. Diffuser material, shape and spacing are still experimental; a single planar diffuser is inappropriate for this volume.
- Waveform FilmGrade 3081 dimmer stays intact and external on the low-voltage cord. Its case is 63 x 25 x 60 mm, with long attached leads. Do not assume it fits invisibly into a shallow pedestal or dismantle it to put its knob on the lamp.
- **Power-supply refinement:** recommend the Flexfire **24V-WMPS2-1**, external 24 V / 1 A / 24 W adapter. Its manufacturer explicitly documents Class 2 output, matching the LED strip's stated requirement. This supersedes the earlier Mean Well GST18A candidate as the proposed purchase; the prior Mean Well research did not establish the necessary output classification. Class II insulation and Class 2 output limitation are different specifications.
- Confirm delivered connector dimensions and polarity before assembly. Use a retained rear DC inlet, insulated wiring, a suitable DC-rated branch fuse selected for the harness/load, and a keyed connector so the light core can be unplugged for service.

Power path: wall outlet -> external 24 V adapter -> external dimmer -> rear base inlet/protection -> five parallel LED sections on the internal metal core. Only low-voltage wiring enters the lamp.

## Base

- Initial target **190 x 175 x 30 mm**, low oval matte-black printed pedestal, slightly wider than the approximately 170 x 160 mm bust. Overall sculpture proportions and final center of gravity may change this size.
- Captive **150 mm diameter x 4 mm steel disc**, approximately **0.55 kg** calculated at 7,850 kg/m3. Retain mechanically; no loose ballast. This is a stability starting point, not a passed tip test.
- Four silicone feet, underside screw-fastened service hatch, threaded inserts for repeated assembly, keyed body registration and a compressed black gasket at the neck/base joint.
- Bolt the aluminum mast to a metal mounting/spreader plate. Thermal spreading and steady-state heat rejection must be designed separately from ballast mass; a steel weight is not sufficient evidence of cooling.
- Lower air inlets concealed beneath the rear base edge and upper outlets hidden in opaque nape/ear ribs. Offset opaque baffles prevent a straight view of LEDs through vents. Rear cable/inlet opening also has an internal light shield. Test oblique viewing angles and joint compression.
- Arrange the sculpture to lift from the registered base after releasing hidden fasteners, leaving the lighting core accessible. Exact hatch/core extraction clearance must be established in CAD; do not assume a rigid branched mast can be pulled through a narrow neck.

## First physical step

Build the base/light-core prototype and representative curved colored shell/diffuser sections before committing to the entire sculpture. Assess face/ear illumination, source hiding, dimming, stability and temperatures at full output after equilibrium. Preserve the successful flat-panel print findings as starting points, not proof of curved-shell performance. No purchase or print has been made/authorized for this sculpture.

## Primary sources

- [LED strip electrical, optical, cut interval and Class 2 requirement](https://www.waveformlighting.com/datasheets/CS_3004.2730.pdf)
- [FilmGrade dimmer specifications](https://store.waveformlighting.com/products/filmgrade-flicker-free-dimmer-for-led-strip)
- [Flexfire 24 V / 24 W adapter datasheet](https://www.flexfireleds.com/content/24V-WMPS-1-spec-sheet.pdf)
- [Flexfire plug-in adapter product page](https://flexfireleds.com/products/desktop-plug-in-power-supply-adaptor/)

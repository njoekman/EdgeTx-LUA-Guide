F5Jsetup Slider edgeTX v1 (X and V) + 3PK X slider / 3PK V slider templates
EdgeTX 2.12, Radiomaster TX16S MK3 - Made by Jonas Ekman

Same as F5J Setup v1.4 / 3PK templates, except the motor power:
- MOTOR ON is still SB down (FM1, motor switch can be changed in the tool).
- Motor power = right slider RS (bottom = off). Throttle curve CV12 "thr"
  (3 points, linear) shapes RS -> motor. SG power steps and SH turbo removed.
- Motor -> elevator compensation: CH1 (V: CH1+CH2) "Motor" line, 5-point curve
  CV17 "m2e", source = motor output CH6, so it follows RS.
- Camber -> elevator compensation: CH1 (V: CH1+CH2) "CmbVar" line, 5-point
  curve CV19 "c2e", source = left slider LS (input I5), active in THERMAL V only.
- SG keeps Timer 3 (chrono), SC / SI keep the calls. SH is free.

INSTALL
1. Copy SCRIPTS/ and TEMPLATES/ to the root of the SD card (keep the folders).
2. SYS > Hardware > Switches: SF = 2POS. (SH no longer needs to be momentary.)
3. New model: Templates > Personal > "3PKXslider" (X-tail) or "3PKVslider" (V-tail),
   or start from a blank model: the tool installs the programming first.
4. SYS > Tools > "F5Jsetup Slider edgeTX v1 X" or "... V".
   Order: Install (blank / older model) > Switches > Failsafe > Servo direction >
   Center > Endpoints > Model check > tuning screens (Motor: throttle curve,
   motor->elevator; Camber slider: slider->elevator).
5. ESC calibration (Motor > ESC calibration): the motor follows RS directly.

A model with the SG/SH programming (3PK template) is shown as "Older programming":
Install / repair converts it to RS. The F5J Setup v1.4 tools still work for
models made from 3PKtemplate / 3PKtemplateV.

Not tested on a real radio. Back up models (Model > Copy) before Install.

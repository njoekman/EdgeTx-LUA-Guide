F5J Setup v1.5 (X and V) + 3PK templates - EdgeTX 2.12, Radiomaster TX16S MK3
Made by Jonas Ekman

INSTALL
1. Copy SCRIPTS/ and TEMPLATES/ to the root of the radio SD card (keep the folders).
2. Radio, SYS > Hardware > Switches:  SF = 2POS,  SH = Toggle (momentary).
   (radio.yml has a checksum, so this cannot be set from a file.)
3. New model: Model select > New > Templates > Personal > "3PKtemplate" (X-tail)
   or "3PKtemplateV" (V-tail). Bind the receiver.
4. SYS > Tools > "F5J Setup X" (X-tail) or "F5J Setup V" (V-tail).
   Blank model: Install opens first. The switch page shows which switches control flight modes and functions:
   tap Accept, or Change switches to pick your own (pilot setup).
   Then: Install / repair (older models) > Failsafe > Servo direction > Center >
   Endpoints > Model check > tuning screens.

NEW IN v1.5
- Install check is stricter: a model counts as programmed only when every mix
  line has the 3PK source and there are no extra lines. Models with other
  versions (e.g. the RS slider version) are shown as "Older programming" and
  converted by Install / repair.

NEW IN v1.4
- New (blank) model: the tool opens Install first, then the switch page (the
  flight modes can only light up once the programming is installed), then Failsafe.
  Models that already have the programming start on the switch page.

NEW IN v1.3
- Switch assignment: motor switch (and its ON position), 3-pos and 2-pos mode
  switches, LANDING on the throttle stick or on a switch. Written to L1-L6,
  L20/L21 and SF1/SF2. SC, SG, SH, SI keep their functions.
  If the motor switch is changed, also set Model Setup > Pre-start Checks.
- Camber, snapflap, aileron-rudder (and their partners) have an own value in every
  flight mode. Tap a flight mode cell and set it - no need to fly in that mode.
  Older models: inherited values become own values on Install / repair
  (camber: MOTOR/LANDING from CRUISE, THERMAL V from THERMAL). GV9 (F5J state)
  stays shared in all flight modes.
- Low RX voltage call (SF40) is OFF at start; switch it on in F5J timer & calls.
- Failsafe page (also offered right after Install): checks the safe state
  (sticks neutral, CRUISE, no LANDING, motor OFF) and captures the channel
  values. ELRS: EdgeTX failsafe is not used - enter the values (us) in the
  receiver (WiFi web UI, PWM outputs). Lua cannot write failsafe settings.
- Pre-start checks in the templates: only the motor switch SB up (OFF) is
  checked, throttle warning off (the throttle stick is crow, not motor).
  Model check reports other settings (Lua cannot change them).
- Fixed: a fresh Install no longer splits GV9 (F5J state) per flight mode.

Not tested on a real radio. Back up models (Model > Copy) before Install.

Also included: GliderSetupX / GliderSetupV v1.2 (general glider tools).

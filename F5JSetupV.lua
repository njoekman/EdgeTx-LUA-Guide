-- TNS|F5J Setup V|TNE
---------------------------------------------------------------------------
-- F5J Setup - setup and tuning guide for Jonas' F5J programming "3PK"
-- (3PKtemplate.yml / 3PKtemplateV.yml, EdgeTX 2.12, RadioMaster TX16S MK3)
-- Made by Jonas Ekman
--
-- Channels: CH1 Ele  CH2 Rud  CH3 Ail_L  CH4 Ail_R  CH5 armed (ELRS arm)
--           CH6 Motor  CH7 Flp_L  CH8 Flp_R  CH9 camber slider out
-- Flight modes: FM0 CRUISE (SE mid), FM1 MOTOR ON (SB down),
--   FM2 LANDING (throttle stick < 90%), FM3 SPEED (SE up + SF up),
--   FM4 DISTANCE (SE up), FM5 THERMAL V (SE down + SF up), FM6 THERMAL (SE down)
-- Sign of mixer values: CH1 + = elevator DOWN, CH2 + = rudder RIGHT,
--   CH3 + = left aileron DOWN, CH4 + = right aileron UP, CH7/CH8 + = flap UP
---------------------------------------------------------------------------

local VERSION = "1.5"
local VARIANT = "V"          -- "X" = elevator + rudder, "V" = V-tail
local TOOL_TITLE = "F5J Setup V"
local VT = (VARIANT == "V")
local DATA_DIR = "/SCRIPTS/TOOLS/F5JSetupData/"

-- generated from 3PKtemplateV.yml by gen_profile.py - do not edit by hand
local PROFILE = {
  model = "3PK template V",
  inputs = {
    { chn = 0, name = "Ail", src = "ail", w = 93, o = 0, ct = 1, cv = 0, trimOff = false, side = 3, fm = 0, sw = "" },
    { chn = 1, name = "Ele", src = "ele", w = 100, o = 0, ct = 1, cv = 0, trimOff = false, side = 3, fm = 0, sw = "" },
    { chn = 2, name = "Brk", src = "thr", w = 47, o = 56, ct = 1, cv = 0, trimOff = true, side = 3, fm = 0, sw = "" },
    { chn = 3, name = "Rud", src = "rud", w = 100, o = 0, ct = 1, cv = 0, trimOff = false, side = 3, fm = 0, sw = "" },
    { chn = 4, name = "Cmb", src = "ls", w = 81, o = 21, ct = 1, cv = 0, trimOff = true, side = 3, fm = 0, sw = "" }
  },
  mixes = {
    { ch = 0, name = "Elev", src = "input2", w = 50, o = 0, mx = 0, sw = "", fm = 0, ct = 0, cv = 0, tr = 0 },
    { ch = 0, name = "Rudder", src = "input4", w = -50, o = 0, mx = 0, sw = "", fm = 0, ct = 0, cv = 0, tr = 0 },
    { ch = 0, name = "Ai2Ru", src = "input1", w = "-gv6", o = 0, mx = 0, sw = "", fm = 0, ct = 0, cv = 0, tr = 1 },
    { ch = 0, name = "Motor", src = "ch6", w = 10, o = 0, mx = 0, sw = "", fm = 509, ct = 3, cv = 17, tr = 1 },
    { ch = 0, name = "Brake", src = "input3", w = 16, o = 0, mx = 0, sw = "", fm = 507, ct = 3, cv = 18, tr = 1 },
    { ch = 0, name = "CmbVar", src = "input5", w = -10, o = 0, mx = 0, sw = "", fm = 479, ct = 3, cv = 19, tr = 1 },
    { ch = 1, name = "Elev", src = "input2", w = 50, o = 0, mx = 0, sw = "", fm = 0, ct = 0, cv = 0, tr = 0 },
    { ch = 1, name = "Rudder", src = "input4", w = 50, o = 0, mx = 0, sw = "", fm = 0, ct = 0, cv = 0, tr = 0 },
    { ch = 1, name = "Ai2Ru", src = "input1", w = "gv6", o = 0, mx = 0, sw = "", fm = 0, ct = 0, cv = 0, tr = 1 },
    { ch = 1, name = "Motor", src = "ch6", w = 10, o = 0, mx = 0, sw = "", fm = 509, ct = 3, cv = 17, tr = 1 },
    { ch = 1, name = "Brake", src = "input3", w = 16, o = 0, mx = 0, sw = "", fm = 507, ct = 3, cv = 18, tr = 1 },
    { ch = 1, name = "CmbVar", src = "input5", w = -10, o = 0, mx = 0, sw = "", fm = 479, ct = 3, cv = 19, tr = 1 },
    { ch = 2, name = "Ailer", src = "input1", w = 108, o = 0, mx = 0, sw = "", fm = 0, ct = 0, cv = "-gv1", tr = 0 },
    { ch = 2, name = "Brake", src = "input3", w = -40, o = 0, mx = 0, sw = "", fm = 507, ct = 3, cv = 13, tr = 1 },
    { ch = 2, name = "CmbSet", src = "max", w = "gv2", o = 0, mx = 0, sw = "", fm = 0, ct = 0, cv = 0, tr = 1 },
    { ch = 2, name = "CmbVar", src = "input5", w = -30, o = 31, mx = 0, sw = "", fm = 479, ct = 0, cv = 0, tr = 1 },
    { ch = 2, name = "SnpFlp", src = "input2", w = "-gv7", o = 0, mx = 0, sw = "", fm = 6, ct = 0, cv = 0, tr = 1 },
    { ch = 2, name = "MotCmb", src = "ch6", w = 225, o = 2, mx = 0, sw = "", fm = 509, ct = 3, cv = 20, tr = 1 },
    { ch = 3, name = "Ailer", src = "input1", w = 100, o = 0, mx = 0, sw = "", fm = 0, ct = 0, cv = "gv1", tr = 0 },
    { ch = 3, name = "Brake", src = "input3", w = 40, o = 0, mx = 0, sw = "", fm = 507, ct = 3, cv = 14, tr = 1 },
    { ch = 3, name = "CmbSet", src = "max", w = "gv3", o = 0, mx = 0, sw = "", fm = 0, ct = 0, cv = 0, tr = 1 },
    { ch = 3, name = "CmbVar", src = "input5", w = 23, o = 18, mx = 0, sw = "", fm = 479, ct = 0, cv = 0, tr = 1 },
    { ch = 3, name = "SnpFlp", src = "input2", w = "gv7", o = 0, mx = 0, sw = "", fm = 6, ct = 0, cv = 0, tr = 1 },
    { ch = 3, name = "MotCmb", src = "ch6", w = -201, o = 0, mx = 0, sw = "", fm = 509, ct = 3, cv = 20, tr = 1 },
    { ch = 4, name = "ch5", src = "max", w = 100, o = 0, mx = 0, sw = "", fm = 0, ct = 0, cv = 0, tr = 1 },
    { ch = 5, name = "Off", src = "min", w = 95, o = 0, mx = 0, sw = "", fm = 2, ct = 0, cv = 0, tr = 1 },
    { ch = 5, name = "On", src = "sg", w = 100, o = 0, mx = 2, sw = "", fm = 509, ct = 3, cv = 12, tr = 1 },
    { ch = 5, name = "Turbo", src = "max", w = 100, o = 0, mx = 2, sw = "SH2", fm = 509, ct = 0, cv = 0, tr = 1 },
    { ch = 6, name = "Flap", src = "input1", w = 0, o = 0, mx = 0, sw = "", fm = 384, ct = 0, cv = "-gv1", tr = 1 },
    { ch = 6, name = "End", src = "input1", w = 100, o = 0, mx = 1, sw = "", fm = 0, ct = 3, cv = 10, tr = 1 },
    { ch = 6, name = "Offset", src = "max", w = 0, o = 0, mx = 0, sw = "", fm = 0, ct = 0, cv = 0, tr = 1 },
    { ch = 6, name = "Brake", src = "input3", w = -187, o = 0, mx = 0, sw = "", fm = 507, ct = 3, cv = 15, tr = 1 },
    { ch = 6, name = "CmbSet", src = "max", w = "gv4", o = 0, mx = 0, sw = "", fm = 0, ct = 0, cv = 0, tr = 1 },
    { ch = 6, name = "CmbVar", src = "input5", w = 13, o = 8, mx = 0, sw = "", fm = 479, ct = 0, cv = 0, tr = 1 },
    { ch = 6, name = "SnpFlp", src = "input2", w = "gv8", o = 0, mx = 0, sw = "", fm = 6, ct = 0, cv = 0, tr = 1 },
    { ch = 6, name = "MotCmb", src = "ch6", w = -136, o = 0, mx = 0, sw = "", fm = 509, ct = 3, cv = 20, tr = 1 },
    { ch = 7, name = "Flap", src = "input1", w = 0, o = 0, mx = 0, sw = "", fm = 384, ct = 0, cv = "gv1", tr = 1 },
    { ch = 7, name = "End", src = "input1", w = 100, o = 0, mx = 1, sw = "", fm = 0, ct = 3, cv = 11, tr = 1 },
    { ch = 7, name = "Offset", src = "max", w = 0, o = 0, mx = 0, sw = "", fm = 0, ct = 0, cv = 0, tr = 1 },
    { ch = 7, name = "Brake", src = "input3", w = -186, o = 0, mx = 0, sw = "", fm = 507, ct = 3, cv = 16, tr = 1 },
    { ch = 7, name = "CmbSet", src = "max", w = "gv5", o = 0, mx = 0, sw = "", fm = 0, ct = 0, cv = 0, tr = 1 },
    { ch = 7, name = "CmbVar", src = "input5", w = 14, o = 10, mx = 0, sw = "", fm = 479, ct = 0, cv = 0, tr = 1 },
    { ch = 7, name = "SnpFlp", src = "input2", w = "gv8", o = 0, mx = 0, sw = "", fm = 6, ct = 0, cv = 0, tr = 1 },
    { ch = 7, name = "MotCmb", src = "ch6", w = -141, o = 0, mx = 0, sw = "", fm = 509, ct = 3, cv = 20, tr = 1 },
    { ch = 8, name = "", src = "input5", w = 100, o = 0, mx = 0, sw = "", fm = 0, ct = 0, cv = 0, tr = 0 }
  },
  outputs = {
    { ch = 0, name = "Vt_L", curve = 0 },
    { ch = 1, name = "Vt_R", curve = 1 },
    { ch = 2, name = "Ail_L", curve = 2 },
    { ch = 3, name = "Ail_R", curve = 3 },
    { ch = 4, name = "armed", curve = 4 },
    { ch = 5, name = "Motor", curve = 5 },
    { ch = 6, name = "Flp_L", curve = 6 },
    { ch = 7, name = "Flp_R", curve = 7 },
    { ch = 8, name = "CH9", curve = 8 },
    { ch = 9, name = "CH10", curve = -1 },
    { ch = 10, name = "CH11", curve = -1 },
    { ch = 11, name = "CH12", curve = -1 },
    { ch = 12, name = "CH13", curve = -1 },
    { ch = 13, name = "CH14", curve = -1 },
    { ch = 14, name = "CH15", curve = -1 },
    { ch = 15, name = "CH16", curve = -1 }
  },
  curves = {
    { idx = 0, name = "ch1", t = 1, s = 0, y = {-100, -50, 0, 50, 100}, x = {-100, -50, 0, 50, 100} },
    { idx = 1, name = "ch2", t = 1, s = 0, y = {-100, -50, 0, 50, 100}, x = {-100, -50, 0, 50, 100} },
    { idx = 2, name = "ch3", t = 1, s = 0, y = {-100, -50, 0, 50, 100}, x = {-100, -50, 0, 50, 100} },
    { idx = 3, name = "ch4", t = 1, s = 0, y = {-100, -50, 0, 50, 100}, x = {-100, -50, 0, 50, 100} },
    { idx = 4, name = "ch5", t = 1, s = 0, y = {-100, -50, 0, 50, 100}, x = {-100, -50, 0, 50, 100} },
    { idx = 5, name = "ch6", t = 1, s = 0, y = {-100, -50, 0, 50, 100}, x = {-100, -50, 0, 50, 100} },
    { idx = 6, name = "ch7", t = 1, s = 0, y = {-100, -50, 0, 50, 100}, x = {-100, -50, 0, 50, 100} },
    { idx = 7, name = "ch8", t = 1, s = 0, y = {-100, -50, 0, 50, 100}, x = {-100, -50, 0, 50, 100} },
    { idx = 8, name = "ch9", t = 1, s = 0, y = {-100, -50, 0, 50, 100}, x = {-100, -50, 0, 50, 100} },
    { idx = 9, name = "fpL", t = 0, s = 0, y = {100, 1, -100} },
    { idx = 10, name = "fpR", t = 0, s = 0, y = {99, 0, -60} },
    { idx = 11, name = "mot", t = 0, s = 0, y = {42, -10, -40} },
    { idx = 12, name = "baL", t = 0, s = 0, y = {100, 75, 50, 25, 0} },
    { idx = 13, name = "baR", t = 0, s = 0, y = {100, 75, 50, 25, -3} },
    { idx = 14, name = "bfL", t = 0, s = 0, y = {100, 75, 50, 25, 0} },
    { idx = 15, name = "bfR", t = 0, s = 0, y = {100, 75, 50, 25, 0} },
    { idx = 16, name = "m2e", t = 1, s = 0, y = {0, 0, 2, 3, 3}, x = {-100, -50, 0, 70, 100} },
    { idx = 17, name = "b2e", t = 1, s = 0, y = {100, 77, 78, -39, -100}, x = {-100, -50, 0, 50, 100} },
    { idx = 18, name = "c2e", t = 0, s = 1, y = {-23, 9, 62, 81, 100} },
    { idx = 19, name = "m2c", t = 1, s = 0, y = {0, 4, 1, -2, -3}, x = {-100, -50, 0, 70, 100} }
  },
  fms = {
    { fm = 0, name = "CRUISE", sw = "", fi = 0, fo = 0, tm = { [6] = 0 }, tv = { [6] = 12 } },
    {
      fm = 1,
      name = "MOTOR ON",
      sw = "L1",
      fi = 0,
      fo = 0,
      tm = { [1] = 2, [2] = 2, [4] = 2 },
      tv = { [1] = 0, [2] = 0, [4] = 0 }
    },
    { fm = 2, name = "LANDING", sw = "L2", fi = 0, fo = 0, tm = { [2] = 4 }, tv = { [2] = 190 } },
    { fm = 3, name = "SPEED", sw = "L3", fi = 0, fo = 0, tm = { [2] = 6 }, tv = { [2] = -20 } },
    { fm = 4, name = "DISTANCE", sw = "L4", fi = 0, fo = 0, tm = { [2] = 8 }, tv = { [2] = -42 } },
    { fm = 5, name = "THERMAL V", sw = "L5", fi = 0, fo = 0, tm = { [2] = 12 }, tv = { [2] = 0 } },
    { fm = 6, name = "THERMAL", sw = "L6", fi = 0, fo = 0, tm = { [2] = 12 }, tv = { [2] = 32 } }
  },
  gvd = {
    { name = "dif", min = -1024, max = 1024, unit = 1, prec = 0, popup = 0 },
    { name = "cal", min = -1024, max = 1024, unit = 1, prec = 0, popup = 0 },
    { name = "car", min = -1024, max = 1024, unit = 1, prec = 0, popup = 0 },
    { name = "cfl", min = -1024, max = 1024, unit = 1, prec = 0, popup = 0 },
    { name = "cfr", min = -1024, max = 1024, unit = 1, prec = 0, popup = 0 },
    { name = "a2r", min = -1024, max = 1024, unit = 1, prec = 0, popup = 0 },
    { name = "snA", min = -1024, max = 1024, unit = 1, prec = 0, popup = 0 },
    { name = "snF", min = -1024, max = 1024, unit = 1, prec = 0, popup = 0 },
    { name = "Tmr", min = 0, max = 3, unit = 1, prec = 0, popup = 0 }
  },
  gvVal = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, -5, -9, 47, 47, 0, 0},
    {0, 0, 0, 7, 14, -41, -41, 0, 0},
    {0, 0, 0, 2, 13, -20, -20, 0, 0},
    {0, 0, 0, 7, 15, -21, -21, 0, 0},
    {25, 25, 20, 15, 15, 50, 60, 25, 25},
    {16, 0, 0, 16, 16, 16, 0, 16, 16},
    {7, 0, 0, 7, 7, 7, 0, 7, 7},
    {0, 0, 0, 0, 0, 0, 0, 0, 0}
  },
  gvOwn = {
    {0, 1, 2, 3, 4, 5, 6, 0, 0},
    {0, 1, 2, 3, 4, 5, 6, 0, 0},
    {0, 1, 2, 3, 4, 5, 6, 0, 0},
    {0, 1, 2, 3, 4, 5, 6, 0, 0},
    {0, 1, 2, 3, 4, 5, 6, 0, 0},
    {0, 1, 2, 3, 4, 5, 6, 0, 0},
    {0, 1, 2, 3, 4, 5, 6, 0, 0},
    {0, 1, 2, 3, 4, 5, 6, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0}
  },
  ls = {
    { idx = 0, f = "AND", andsw = "", delay = 0, dur = 0, v1 = "SB2", v2 = "" },
    { idx = 1, f = "VNEG", andsw = "", delay = 0, dur = 0, v1 = "thr", v2 = 90 },
    { idx = 2, f = "AND", andsw = "", delay = 0, dur = 0, v1 = "SE0", v2 = "SF0" },
    { idx = 3, f = "AND", andsw = "", delay = 0, dur = 0, v1 = "SE0", v2 = "" },
    { idx = 4, f = "AND", andsw = "", delay = 0, dur = 0, v1 = "SE2", v2 = "SF0" },
    { idx = 5, f = "AND", andsw = "", delay = 0, dur = 0, v1 = "SE2", v2 = "" },
    { idx = 9, f = "EDGE", andsw = "", delay = 0, dur = 0, v1 = "SI2", v2 = -119, v3 = 0 },
    { idx = 10, f = "AND", andsw = "", delay = 0, dur = 0, v1 = "L10", v2 = "TELEMETRY_STREAMING" },
    { idx = 11, f = "AND", andsw = "", delay = 0, dur = 0, v1 = "L10", v2 = "!TELEMETRY_STREAMING" },
    { idx = 12, f = "VNEG", andsw = "", delay = 0, dur = 0, v1 = "tele:RxBt", v2 = 78 },
    { idx = 19, f = "AND", andsw = "", delay = 0, dur = 0, v1 = "SB0", v2 = "" },
    { idx = 20, f = "AND", andsw = "", delay = 0, dur = 0, v1 = "SB2", v2 = "" },
    { idx = 21, f = "VEQUAL", andsw = "", delay = 0, dur = 0, v1 = "timer1", v2 = 0 },
    { idx = 22, f = "OR", andsw = "", delay = 0, dur = 0, v1 = "!L21", v2 = "L22" },
    { idx = 23, f = "VEQUAL", andsw = "", delay = 0, dur = 0, v1 = "gvar9", v2 = 0 },
    { idx = 24, f = "VEQUAL", andsw = "L21", delay = 0, dur = 0, v1 = "gvar9", v2 = 0 },
    { idx = 25, f = "VEQUAL", andsw = "L23", delay = 0, dur = 0, v1 = "gvar9", v2 = 1 },
    { idx = 26, f = "VEQUAL", andsw = "L20", delay = 0, dur = 0, v1 = "gvar9", v2 = 2 },
    { idx = 27, f = "VEQUAL", andsw = "L22", delay = 0, dur = 0, v1 = "gvar9", v2 = 2 },
    { idx = 28, f = "VEQUAL", andsw = "L21", delay = 30, dur = 0, v1 = "gvar9", v2 = 2 },
    { idx = 29, f = "VEQUAL", andsw = "L21", delay = 30, dur = 0, v1 = "gvar9", v2 = 3 },
    { idx = 30, f = "VEQUAL", andsw = "!L21", delay = 0, dur = 0, v1 = "gvar9", v2 = 3 },
    { idx = 31, f = "VEQUAL", andsw = "", delay = 0, dur = 0, v1 = "timer1", v2 = 15 }
  },
  sf = {
    { idx = 0, sw = "SB0", f = "SET_SCREEN", val = 1, act = 1, rep = 1 },
    { idx = 1, sw = "!SB0", f = "SET_SCREEN", val = 2, act = 1, rep = 1 },
    { idx = 19, sw = "L25", f = "ADJUST_GVAR", param = 8, mode = 0, val = 1, act = 1 },
    { idx = 20, sw = "L26", f = "ADJUST_GVAR", param = 8, mode = 0, val = 2, act = 1 },
    { idx = 21, sw = "L27", f = "ADJUST_GVAR", param = 8, mode = 0, val = 0, act = 1 },
    { idx = 22, sw = "L28", f = "ADJUST_GVAR", param = 8, mode = 0, val = 3, act = 1 },
    { idx = 23, sw = "L31", f = "ADJUST_GVAR", param = 8, mode = 0, val = 0, act = 1 },
    { idx = 24, sw = "L24", f = "RESET", val = 0, act = 1 },
    { idx = 25, sw = "L26", f = "SET_TIMER", param = 0, val = 10, act = 1 },
    { idx = 26, sw = "L25", f = "PLAY_TRACK", name = "start", act = 1, rep = 1 },
    { idx = 27, sw = "L26", f = "PLAY_TRACK", name = "engoff", act = 1, rep = 1 },
    { idx = 28, sw = "L28", f = "PLAY_TRACK", name = "off", act = 1, rep = 1 },
    { idx = 29, sw = "L29", f = "PLAY_SOUND", val = 0, act = 1, rep = 1 },
    { idx = 30, sw = "L30", f = "PLAY_TRACK", name = "fm-pwr", act = 1, rep = 1 },
    { idx = 31, sw = "L32", f = "PLAY_VALUE", src = "timer1", act = 0, rep = 1 },
    { idx = 32, sw = "L20", f = "RESET", val = 1, act = 1 },
    { idx = 33, sw = "SG0", f = "RESET", val = 2, act = 1 },
    { idx = 34, sw = "SI2", f = "PLAY_VALUE", src = "timer2", act = 1, rep = 1 },
    { idx = 35, sw = "SC2", f = "PLAY_VALUE", src = "tele:RxBt", act = 1, rep = 1 },
    { idx = 37, sw = "L11", f = "PLAY_VALUE", src = "tele:RQly", act = 1, rep = 1 },
    { idx = 38, sw = "L12", f = "PLAY_TRACK", name = "warnng", act = 1, rep = 1 },
    { idx = 39, sw = "L13", f = "PLAY_TRACK", name = "lowbat", act = 0, rep = 1 }
  },
  timers = {
    { idx = 0, name = "F5J Time", start = 30, sw = "", mode = 1, cdb = 2, minb = 0, pers = 0, cds = -1, el = 0, hap = 0 },
    { idx = 1, name = "Flight", start = 600, sw = "L21", mode = 2, cdb = 2, minb = 1, pers = 0, cds = 1, el = 0, hap = 0 },
    { idx = 2, name = "Chrono", start = 0, sw = "SG2", mode = 0, cdb = 0, minb = 1, pers = 0, cds = 0, el = 0, hap = 0 }
  },
  calib = {
    { ch = 0, min = -1000, max = 1000, offset = -95, ppmCenter = 0, revert = 1 },
    { ch = 1, min = -699, max = 1000, offset = 101, ppmCenter = 0, revert = 0 },
    { ch = 2, min = -643, max = 434, offset = -91, ppmCenter = 0, revert = 1 },
    { ch = 3, min = -597, max = 482, offset = -113, ppmCenter = 0, revert = 1 },
    { ch = 4, min = -1000, max = 1000, offset = 0, ppmCenter = 0, revert = 0 },
    { ch = 5, min = -1000, max = 1000, offset = 0, ppmCenter = 0, revert = 0 },
    { ch = 6, min = -1000, max = 500, offset = 52, ppmCenter = 0, revert = 0 },
    { ch = 7, min = -1000, max = 500, offset = -18, ppmCenter = 0, revert = 1 },
    { ch = 8, min = -1000, max = 1000, offset = 0, ppmCenter = 0, revert = 0 },
    { ch = 9, min = -1000, max = 1000, offset = 0, ppmCenter = 0, revert = 0 },
    { ch = 10, min = -1000, max = 1000, offset = 0, ppmCenter = 0, revert = 0 },
    { ch = 11, min = -1000, max = 1000, offset = 0, ppmCenter = 0, revert = 0 },
    { ch = 12, min = -1000, max = 1000, offset = 0, ppmCenter = 0, revert = 0 },
    { ch = 13, min = -1000, max = 1000, offset = 0, ppmCenter = 0, revert = 0 },
    { ch = 14, min = -1000, max = 1000, offset = 0, ppmCenter = 0, revert = 0 },
    { ch = 15, min = -1000, max = 1000, offset = 0, ppmCenter = 0, revert = 0 }
  }
}


local P = PROFILE

-- channels (0-based)
local ELE, RUD, AIL_L, AIL_R, ARM, MOT, FLP_L, FLP_R, AUX = 0, 1, 2, 3, 4, 5, 6, 7, 8
local SURF = { ELE, RUD, AIL_L, AIL_R, FLP_L, FLP_R }
local NFM = 7                                   -- FM0..FM6 used
local FM_SHORT = { [0] = "CRU", "MOT", "LND", "SPD", "DST", "THV", "THM" }

local CH_NAME = { [0] = VT and "V-tail L" or "Elevator", VT and "V-tail R" or "Rudder", "Aileron L", "Aileron R", "Armed", "Motor",
  "Flap L", "Flap R", "CH9" }
local POS_WORD = { [0] = "DOWN", VT and "DOWN" or "RIGHT", "DOWN", "UP", "", "", "UP", "UP" }
local NEG_WORD = { [0] = "UP", VT and "UP" or "LEFT", "UP", "DOWN", "", "", "DOWN", "DOWN" }

-- events
local EV = { ENTER = EVT_VIRTUAL_ENTER, EXIT = EVT_VIRTUAL_EXIT, NEXT = EVT_VIRTUAL_NEXT, PREV = EVT_VIRTUAL_PREV,
  INC = EVT_VIRTUAL_INC, DEC = EVT_VIRTUAL_DEC, PGN = EVT_VIRTUAL_NEXT_PAGE, PGP = EVT_VIRTUAL_PREV_PAGE, TAP = EVT_TOUCH_TAP }

local LSF = {
  AND = LS_FUNC_AND or 7, OR = LS_FUNC_OR or 8, XOR = LS_FUNC_XOR or 9, EDGE = LS_FUNC_EDGE or 10,
  VEQUAL = LS_FUNC_VEQUAL or 1, VPOS = LS_FUNC_VPOS or 3, VNEG = LS_FUNC_VNEG or 4,
  APOS = LS_FUNC_APOS or 5, ANEG = LS_FUNC_ANEG or 6,
}
local CFF = {
  RESET = FUNC_RESET or 3, SET_TIMER = FUNC_SET_TIMER or 4, ADJUST_GVAR = FUNC_ADJUST_GVAR or 5,
  PLAY_SOUND = FUNC_PLAY_SOUND or 10, PLAY_TRACK = FUNC_PLAY_TRACK or 11,
  PLAY_VALUE = FUNC_PLAY_VALUE or 12, SET_SCREEN = FUNC_SET_SCREEN or 23,
}

---------------------------------------------------------------------------
-- Generic helpers
---------------------------------------------------------------------------
local function clamp(v, lo, hi)
  if v < lo then return lo elseif v > hi then return hi end
  return v
end

local function round(v)
  if v >= 0 then return math.floor(v + 0.5) end
  return -math.floor(-v + 0.5)
end

local function fid(name)
  if not name or name == "" then return nil end
  local i = getFieldInfo(name)
  return i and i.id or nil
end

local function profileMix(ch, name)
  for _, m in ipairs(P.mixes) do
    if m.ch == ch and m.name == name then return m end
  end
  return nil
end

local function profileCurve(idx)
  for _, c in ipairs(P.curves) do if c.idx == idx then return c end end
  return nil
end

-- telemetry sensor lookup by name -> source id (nil if not discovered)
local function sensorSource(name)
  for i = 0, 59 do
    local s = model.getSensor(i)
    if s and s.name == name then return fid("telem" .. (i + 1)) end
  end
  return nil
end

-- symbolic source -> source id (0 = none)
local missing = {}
local function srcId(s)
  if s == nil or s == "" then return 0 end
  local sensor = string.match(s, "^tele:(.+)$")
  if sensor then
    local id = sensorSource(sensor)
    if not id then missing[sensor] = true return 0 end
    return id
  end
  local id = fid(s)
  if not id then missing[s] = true return 0 end
  return id
end

-- number or GV reference ("gv6" / "-gv1") -> Lua weight encoding
local function numVal(v)
  if type(v) == "number" then return v end
  local neg, n = string.match(v, "^(%-?)gv(%d)$")
  local s = fid("gvar" .. n)
  if not s or s >= 512 then error("GV" .. n .. " not usable as weight") end
  if neg == "-" then return -(1024 + s) end
  return 1024 + s
end

local function gvOfNum(v)
  -- inverse of numVal for display: returns gv number (1-9) and sign, or nil
  if type(v) ~= "number" or math.abs(v) < 1024 then return nil end
  local a = math.abs(v) - 1024
  for n = 1, 9 do
    if fid("gvar" .. n) == a then return n, (v < 0) and -1 or 1 end
  end
  return nil
end

-- physical switch position: letter "B", pos 0/1/2 -> switch index
local swCache = {}
local function physSw(letter, pos)
  local key = letter .. pos
  if swCache[key] then return swCache[key] end
  local base, id = fid("sa"), fid("s" .. string.lower(letter))
  local cand = nil
  if base and id then
    cand = 1 + 3 * (id - base) + pos
    local n = getSwitchName(cand)
    if not (n and string.sub(n, 1, 2) == "S" .. letter) then cand = nil end
  end
  if not cand then
    for i = 1, 200 do
      local n = getSwitchName(i)
      if n and string.sub(n, 1, 2) == "S" .. letter then cand = i + pos break end
    end
  end
  swCache[key] = cand or 0
  return swCache[key]
end

-- Flight-mode / motor switch assignment ("pilot setup"). The 3PK programming
-- is written with SB (motor), SE (3-pos mode), SF (2-pos mode) and the
-- throttle stick (LANDING); swIdx() translates these to the chosen switches.
--   mL/mP: motor switch letter and ON position (0 = up, 2 = down)
--   m1: 3-pos mode switch, m2: 2-pos mode switch
--   lL/lP: LANDING switch (nil = throttle stick < L2 value)
local SWMAP = { mL = "B", mP = 2, m1 = "E", m2 = "F", lL = nil, lP = 2 }
local SW_LET = "ABCDEFGHIJ"

local function mapSw(letter, pos)
  if letter == "B" then
    if pos == 2 then pos = SWMAP.mP elseif pos == 0 then pos = 2 - SWMAP.mP end
    return SWMAP.mL, pos
  elseif letter == "E" then return SWMAP.m1, pos
  elseif letter == "F" then return SWMAP.m2, pos end
  return letter, pos
end

local function swName(letter) return "S" .. letter end
local function posWord(p) return ({ [0] = "up", "mid", "down" })[p] end
local function motorText(m)
  m = m or SWMAP
  return swName(m.mL) .. " " .. posWord(m.mP)
end

local L01 = nil
local function swIdx(s)
  if s == nil or s == "" then return 0 end
  local neg = 1
  if string.sub(s, 1, 1) == "!" then neg = -1 s = string.sub(s, 2) end
  local n = string.match(s, "^L(%d+)$")
  if n then
    L01 = L01 or getSwitchIndex("L01")
    return neg * (L01 + tonumber(n) - 1)
  end
  if s == "TELEMETRY_STREAMING" then
    local t = getSwitchIndex("Tele")
    if not t then missing["Tele"] = true return 0 end
    return neg * t
  end
  local letter, pos = string.match(s, "^S(%u)(%d)$")
  if letter then
    letter, pos = mapSw(letter, tonumber(pos))
    return neg * physSw(letter, pos)
  end
  missing[s] = true
  return 0
end

---------------------------------------------------------------------------
-- Model access: mix lines are addressed by (channel, name)
---------------------------------------------------------------------------
local function findMix(ch, name)
  local n = model.getMixesCount(ch)
  for l = 0, n - 1 do
    local m = model.getMix(ch, l)
    if m and m.name == name then return l, m end
  end
  return nil
end

local MIX_KEYS = { "name", "source", "weight", "offset", "switch", "multiplex", "curveType",
  "curveValue", "flightModes", "carryTrim", "mixWarn", "delayPrec", "delayUp", "delayDown",
  "speedPrec", "speedUp", "speedDown" }

local function copyMix(m)
  local t = {}
  for _, k in ipairs(MIX_KEYS) do if m[k] ~= nil then t[k] = m[k] end end
  return t
end

-- rewrite one mix line in place (delete + insert keeps the mix counter balanced)
local function rewriteMix(ch, l, t)
  local before = model.getMixesCount(ch)
  model.deleteMix(ch, l)
  model.insertMix(ch, l, t)
  return model.getMixesCount(ch) == before
end

local function setMixFields(ch, name, fields)
  local l, m = findMix(ch, name)
  if not l then return false end
  local t = copyMix(m)
  for k, v in pairs(fields) do t[k] = v end
  return rewriteMix(ch, l, t)
end

local function getOut(ch) return model.getOutput(ch) end

local function setOut(ch, o)
  local t = { name = o.name, min = o.min, max = o.max, offset = o.offset,
    ppmCenter = o.ppmCenter, symetrical = o.symetrical, revert = o.revert }
  if o.curve ~= nil then t.curve = o.curve end
  model.setOutput(ch, t)
end

local function chValue(ch)        -- live channel output in % (after limits)
  local v = getValue(fid("ch" .. (ch + 1)) or 0) or 0
  return v * 100 / 1024
end

---------------------------------------------------------------------------
-- Model file analysis (reads /MODELS/<file>.yml in small steps)
-- Needed because mix lines with source '---' hide all later mix lines
-- from the Lua API, and GV inheritance between flight modes is not
-- visible through Lua.
---------------------------------------------------------------------------
local A = nil      -- analysis result

local function unq(v)
  v = string.gsub(v, "%s+$", "")
  local q = string.match(v, '^"(.*)"$')
  return q or v
end

local function anaStart()
  A = { state = "open", mixes = {}, gvRaw = nil, file = nil, buf = "", section = nil,
        swWarn = {}, thrWarnOff = false, modType = {} }
  local info = model.getInfo()
  A.modelName = info and info.name or "?"
  if info and info.filename and info.filename ~= "" then
    A.file = "/MODELS/" .. info.filename
  end
end

local function anaLine(line)
  line = string.gsub(line, "\r", "")
  if line == "" then return end
  if string.match(line, "^%S") then
    local key, val = string.match(line, "^([%w_]+):%s*(.-)%s*$")
    if A.section == "moduleData" and key ~= "moduleData" then A.stop = true end
    A.section = key
    A.item, A.sub = nil, nil
    if key == "disableThrottleWarning" then A.thrWarnOff = (val == "1") end
    if key == "switchWarningState" and val then           -- older format: "SBu"
      for l, p in string.gmatch(val, "S?(%u)([ud%-])") do
        A.swWarn[l] = ({ u = "up", ["-"] = "mid", d = "down" })[p]
      end
    end
    return
  end
  if A.section == "switchWarning" then
    local l = string.match(line, "^   S(%u):")
    if l then A.swCur = l return end
    local v = string.match(line, "^      pos: *(%a+)")
    if v and A.swCur and v ~= "none" then A.swWarn[A.swCur] = v end
    return
  end
  if A.section == "moduleData" then
    local n = string.match(line, "^   (%d+):")
    if n then A.modIdx = tonumber(n) return end
    local t = string.match(line, "^      type: *(%S+)")
    if t and A.modIdx then A.modType[A.modIdx] = t end
    return
  end
  if A.section == "mixData" then
    if string.match(line, "^ %-") then
      A.item = {}
      A.mixes[#A.mixes + 1] = A.item
      A.sub = nil
    elseif A.item then
      local k, v = string.match(line, "^      ([%w_]+): *(.-)%s*$")
      if k and A.sub == "curve" then
        A.item["curve_" .. k] = unq(v)
      else
        k, v = string.match(line, "^   ([%w_]+): *(.-)%s*$")
        if k then
          if k == "curve" then A.sub = "curve" else A.sub = nil A.item[k] = unq(v) end
        end
      end
    end
  elseif A.section == "flightModeData" then
    A.gvRaw = A.gvRaw or {}
    local n = string.match(line, "^   (%d+):%s*$")
    if n then
      A.fm = tonumber(n)
      A.sub = nil
      for g = 1, 9 do
        A.gvRaw[g] = A.gvRaw[g] or {}
        if A.gvRaw[g][A.fm] == nil then A.gvRaw[g][A.fm] = (A.fm == 0) and 0 or 1025 end
      end
      return
    end
    local k = string.match(line, "^      ([%w_]+):")
    if k then A.sub = (k == "gvars") and "gv" or nil return end
    if A.sub == "gv" and A.fm then
      local g = string.match(line, "^         (%d+):%s*$")
      if g then A.g = tonumber(g) + 1 return end
      local v = string.match(line, "^            val: *(%-?%d+)")
      if v and A.g then A.gvRaw[A.g][A.fm] = tonumber(v) end
    end
  end
end

local function yamlNum(v)
  if v == nil then return 0 end
  local neg, n = string.match(v, "^(%-?)GV(%d)$")
  if n then return (neg == "-" and "-gv" or "gv") .. n end
  return tonumber(v) or 0
end

local function fmMaskOf(s)
  if not s then return 0 end
  local bits = 0
  for i = 1, #s do
    if string.sub(s, i, i) == "1" then bits = bits + 2 ^ (i - 1) end
  end
  return round(bits)
end

local function anaFinish()
  -- normalize mix items and compare with the profile
  A.none, A.match, A.extra = {}, 0, {}
  A.cap = {}
  local seen = {}
  for _, it in ipairs(A.mixes) do
    local ch = tonumber(it.destCh or "0") or 0
    local name = it.name or ""
    local m = { ch = ch, name = name, srcNone = (it.srcRaw == "NONE"),
      w = yamlNum(it.weight), o = yamlNum(it.offset), fm = fmMaskOf(it.flightModes),
      tr = tonumber(it.carryTrim or "0") or 0, ct = tonumber(it.curve_type or "0") or 0,
      cv = yamlNum(it.curve_value) }
    if m.srcNone then A.none[#A.none + 1] = m end
    local key = ch .. "/" .. name
    if profileMix(ch, name) and not seen[key] then
      seen[key] = true
      A.match = A.match + 1
      A.cap[key] = m
    else
      A.extra[#A.extra + 1] = m
    end
  end
  A.structure = (A.match >= #P.mixes - 6)
  A.state = "done"
end

-- run a slice of the analysis; returns true when finished
local function anaStep()
  if not A or A.state == "done" or A.state == "fail" then return true end
  if A.state == "open" then
    if not A.file then A.state = "fail" A.err = "model file name not available" return true end
    A.f = io.open(A.file, "r")
    if not A.f then A.state = "fail" A.err = "cannot open " .. A.file return true end
    A.state = "read"
  end
  for _ = 1, 8 do
    local chunk = io.read(A.f, 512)
    if not chunk or #chunk == 0 then
      if A.buf ~= "" then anaLine(A.buf) end
      io.close(A.f)
      anaFinish()
      return true
    end
    A.buf = A.buf .. chunk
    while true do
      local p = string.find(A.buf, "\n", 1, true)
      if not p then break end
      anaLine(string.sub(A.buf, 1, p - 1))
      A.buf = string.sub(A.buf, p + 1)
      if A.stop then io.close(A.f) anaFinish() return true end
    end
  end
  return false
end

-- Lua-side check: are all profile mix lines visible through the Lua API?
local function luaStructure()
  local found = 0
  for _, m in ipairs(P.mixes) do
    if findMix(m.ch, m.name) then found = found + 1 end
  end
  return found
end

-- lines whose weight is a GV in the 3PK programming (e.g. snapflap per mode)
-- also: every line has the 3PK source, and there are no other lines
-- (e.g. SG motor power / SH turbo of the 3PK switch version)
local function gvLinesOk()
  local n = 0
  for _, pm in ipairs(P.mixes) do
    local _, m = findMix(pm.ch, pm.name)
    if not m then return false end
    if type(pm.w) == "string" and m.weight ~= numVal(pm.w) then return false end
    local sid = fid(pm.src)
    if sid and m.source ~= sid then return false end
  end
  for ch = 0, AUX do n = n + model.getMixesCount(ch) end
  return n == #P.mixes
end

local status = { lua = 0, ready = false, old = false }
local function refreshStatus()
  status.lua = luaStructure()
  status.old = (status.lua == #P.mixes) and not gvLinesOk()
  status.ready = (status.lua == #P.mixes) and not status.old and not (A and A.state == "done" and #A.none > 0)
end

---------------------------------------------------------------------------
-- GV per flight mode with inheritance / links
---------------------------------------------------------------------------
local function gvGet(g, fm) return model.getGlobalVariable(g - 1, fm) or 0 end

local function rawOwner(g, fm)
  if not (A and A.state == "done") then return fm end
  local t = A.gvRaw and A.gvRaw[g] or {}
  for _ = 1, 9 do
    if fm == 0 then return 0 end
    local v = t[fm]
    if v == nil then v = 1025 end          -- not in the model file: EdgeTX default = follow FM0
    if v <= 1024 then return fm end
    local r = v - 1025
    if r >= fm then r = r + 1 end
    fm = r
  end
  return 0
end

local function profOwner(g, fm)
  return P.gvOwn[g][fm + 1]
end

local edLog = nil     -- {gv = {[key] = orig}, mix = {[key] = orig table}, ...} per edit session

local function logGv(g, fm)
  if not edLog then return end
  local key = g .. ":" .. fm
  if edLog.gv[key] == nil then edLog.gv[key] = gvGet(g, fm) end
end

local function gvSetRaw(g, fm, v)
  logGv(g, fm)
  model.setGlobalVariable(g - 1, fm, v)
  -- writing a value in a flight mode gives it an own value (ends inheritance)
  if A then
    A.gvRaw = A.gvRaw or {}
    A.gvRaw[g] = A.gvRaw[g] or {}
    A.gvRaw[g][fm] = v
  end
end

-- set the GV value of flight mode fm only: every flight mode keeps its own
-- value, so all modes can be pre-set without flying in them
local function gvSet(g, fm, v)
  gvSetRaw(g, fm, v)
end

local function gvTag(g, fm)
  local o = rawOwner(g, fm)
  if o ~= fm then return "=" .. FM_SHORT[o] end   -- shown as "(=CRU)": value comes from CRUISE
  return ""
end

---------------------------------------------------------------------------
-- Forced outputs during calibration ("cal" REPLACE lines at the end of a
-- channel). The motor is always locked OFF while a calibration screen is open.
---------------------------------------------------------------------------
local calState = {}

local function calRemove(ch)
  local n = model.getMixesCount(ch)
  for l = n - 1, 0, -1 do
    local m = model.getMix(ch, l)
    if m and m.name == "cal" then model.deleteMix(ch, l) end
  end
end

local function calOff()
  for ch = 0, AUX do calRemove(ch) end
  calState = {}
end

-- t[ch] = number or list of {w=, sw=}
local function calSet(t)
  local maxSrc = fid("max")
  for ch = 0, AUX do
    local v = t[ch]
    local lines = nil
    if type(v) == "number" then lines = { { w = v } } elseif type(v) == "table" then lines = v end
    local key = nil
    if lines then
      key = ""
      for _, l in ipairs(lines) do
        l.w = clamp(round(l.w), -150, 150)
        key = key .. l.w .. ":" .. (l.sw or 0) .. ":" .. (l.src or "") .. ";"
      end
    end
    if key ~= calState[ch] then
      calRemove(ch)
      if lines then
        for _, l in ipairs(lines) do
          model.insertMix(ch, model.getMixesCount(ch),
            { name = "cal", source = l.src and fid(l.src) or maxSrc, weight = l.w, multiplex = 2, switch = l.sw or 0 })
        end
      end
      calState[ch] = key
    end
  end
end

local function motorLock(extra)
  local t = { [MOT] = -100 }
  if extra then for k, v in pairs(extra) do t[k] = v end end
  calSet(t)
end

---------------------------------------------------------------------------
-- Install: write the complete programming into the current model
---------------------------------------------------------------------------
local inst = { keepGV = true, lllTrims = false, result = nil }
local install, applySwitchMap
do

local function clearMixesSafely()
  -- model.deleteMixes() does not reset EdgeTX's internal mix counter,
  -- so lines are deleted one by one instead.
  for ch = 0, 31 do
    local guard = 0
    while model.getMixesCount(ch) > 0 and guard < 70 do
      model.deleteMix(ch, 0)
      guard = guard + 1
    end
  end
end

local luaCap = nil
local function captureLuaMixes()
  luaCap = {}
  for _, pm in ipairs(P.mixes) do
    local _, m = findMix(pm.ch, pm.name)
    if m then
      luaCap[pm.ch .. "/" .. pm.name] = { w = m.weight, o = m.offset, fm = m.flightModes,
        tr = m.carryTrim and 1 or 0, ct = m.curveType, cv = m.curveValue, srcNone = false, lua = true }
    end
  end
end

-- a channel's values are only taken over when the output has the same name
-- (so a V-tail tool never copies X-tail elevator values and vice versa)
local function sameChannel(ch)
  local po
  for _, o in ipairs(P.outputs) do if o.ch == ch then po = o end end
  local cur = getOut(ch)
  return po and cur and cur.name == po.name
end

local function capturedMix(pm)
  if not sameChannel(pm.ch) then return nil end
  local key = pm.ch .. "/" .. pm.name
  if luaCap and luaCap[key] then return luaCap[key] end
  if A and A.state == "done" and A.cap[key] then return A.cap[key] end
  return nil
end

local function writeInputs(log)
  -- keep tuned input values only when this model already has the programming
  -- (a new model has default inputs with the same sources but other values)
  local cap = {}
  local hasProg = (status.lua == #P.mixes) or (A and A.state == "done" and A.structure)
  for _, pi in ipairs(P.inputs) do
    if hasProg and model.getInputsCount(pi.chn) > 0 then
      local g = model.getInput(pi.chn, 0)
      if g and g.source == srcId(pi.src) and g.inputName == pi.name then cap[pi.chn] = g end
    end
  end
  model.deleteInputs()
  local n = 0
  for _, pi in ipairs(P.inputs) do
    local c = cap[pi.chn]
    local t = { name = "", inputName = pi.name, source = srcId(pi.src),
      weight = c and c.weight or numVal(pi.w), offset = c and c.offset or numVal(pi.o),
      curveType = c and c.curveType or pi.ct, curveValue = c and c.curveValue or numVal(pi.cv),
      side = pi.side, trimSource = pi.trimOff and -1 or 0, switch = swIdx(pi.sw), flightModes = pi.fm }
    model.insertInput(pi.chn, model.getInputsCount(pi.chn), t)
    if c then n = n + 1 end
  end
  log[#log + 1] = "Inputs I1-I5 written (" .. n .. " kept from model)"
end

local function writeMixes(log)
  captureLuaMixes()
  clearMixesSafely()
  local kept, failed = 0, 0
  for _, pm in ipairs(P.mixes) do
    -- Structure (source, flight modes, trim, GV weights) always comes from the
    -- 3PK programming; tuned numeric weights/offsets/curve values are kept.
    local c = capturedMix(pm)
    local function cap(pv, cvv)
      if c and type(pv) == "number" and cvv ~= nil and not gvOfNum(cvv) and not c.srcNone then
        if c.lua then return cvv end
        if type(cvv) == "number" then return cvv end
      end
      return numVal(pv)
    end
    local used = c and type(pm.w) == "number" and not c.srcNone
    if used then kept = kept + 1 end
    local cvOut = numVal(pm.cv)
    if c and c.ct == pm.ct and type(pm.cv) == "number" and pm.ct == 0 then cvOut = cap(pm.cv, c.cv) end
    local t = { name = pm.name, source = srcId(pm.src), weight = cap(pm.w, c and c.w),
      offset = cap(pm.o, c and c.o), multiplex = pm.mx, switch = swIdx(pm.sw), flightModes = pm.fm,
      curveType = pm.ct, curveValue = cvOut, carryTrim = (pm.tr == 1) }
    local before = model.getMixesCount(pm.ch)
    model.insertMix(pm.ch, before, t)
    if model.getMixesCount(pm.ch) ~= before + 1 then failed = failed + 1 end
  end
  if failed > 0 then
    error(failed .. " mix lines could not be inserted. Select another model and back (or restart the radio), then run Install again.")
  end
  log[#log + 1] = #P.mixes .. " mix lines written (" .. kept .. " with values from model)"
end

local function writeCurves(log)
  local kept = 0
  for _, pc in ipairs(P.curves) do
    local cur = model.getCurve(pc.idx)
    local t = { name = pc.name, type = pc.t, smooth = (pc.s == 1), y = pc.y }
    if pc.t == 1 then t.x = pc.x end
    if cur and cur.name == pc.name and cur.type == pc.t and cur.points == #pc.y then
      t.y = {}
      for i = 1, #pc.y do t.y[i] = cur.y[i] end
      if pc.t == 1 and cur.x then t.x = {} for i = 1, #pc.x do t.x[i] = cur.x[i] end end
      t.smooth = cur.smooth
      kept = kept + 1
    end
    local r = model.setCurve(pc.idx, t)
    if r ~= nil and r ~= 0 then error("curve CV" .. (pc.idx + 1) .. " error " .. r) end
  end
  log[#log + 1] = "Curves CV1-CV" .. #P.curves .. " written (" .. kept .. " kept from model)"
end

local gvShareLost = {}
-- older programming: where a GV value was inherited, the 3PK own value is
-- taken from this flight mode (camber GV2-GV5: MOTOR/LANDING = CRUISE,
-- THERMAL V = THERMAL); all others from the flight mode itself
local GV_SRC = { [2] = { 0, 0, 0, 3, 4, 6, 6 }, [3] = { 0, 0, 0, 3, 4, 6, 6 },
  [4] = { 0, 0, 0, 3, 4, 6, 6 }, [5] = { 0, 0, 0, 3, 4, 6, 6 } }
local function writeFlightModes(log)
  for _, f in ipairs(P.fms) do
    local tm = {}
    for i = 1, 8 do tm[i] = f.tm[i] or 0 end
    local t = { name = f.name, switch = swIdx(f.sw), fadeIn = f.fi, fadeOut = f.fo, trimsModes = tm }
    if inst.lllTrims then
      local tv = {}
      for i = 1, 8 do tv[i] = f.tv[i] or 0 end
      t.trimsValues = tv
    end
    model.setFlightMode(f.fm, t)
  end
  for fm = #P.fms, 8 do model.setFlightMode(fm, { name = "", switch = 0 }) end
  gvShareLost = {}
  local keepAll = inst.keepGV and inst.gvFound
  local nKept = 0
  for g = 1, 9 do
    local d = P.gvd[g]
    -- keep a GV's values only if this model already uses it for the same thing
    local cur = model.getGlobalVariableDetails and model.getGlobalVariableDetails(g - 1)
    local keep = keepAll and cur and cur.name == d.name
    local function setRaw(fm, v)
      model.setGlobalVariable(g - 1, fm, v)
      if A then
        A.gvRaw = A.gvRaw or {}
        A.gvRaw[g] = A.gvRaw[g] or {}
        A.gvRaw[g][fm] = v
      end
    end
    if keep then
      nKept = nKept + 1
      for fm = 0, 8 do
        local po = profOwner(g, fm)
        if po == fm then
          -- own value in the 3PK programming: an inherited value becomes the
          -- flight mode's own value (same number, now separately adjustable)
          if rawOwner(g, fm) ~= fm then
            local src = GV_SRC[g] and GV_SRC[g][fm + 1] or fm
            setRaw(fm, gvGet(g, src))
          end
        elseif rawOwner(g, fm) ~= rawOwner(g, po) then
          setRaw(fm, gvGet(g, po))
        end
      end
    end
    model.setGlobalVariableDetails(g - 1, { name = d.name, min = d.min, max = d.max,
      unit = d.unit, prec = d.prec, popup = (d.popup == 1) })
    if not keep then
      for fm = 0, 8 do
        local po = profOwner(g, fm)
        if po == fm then
          setRaw(fm, P.gvVal[g][fm + 1])
        elseif rawOwner(g, fm) ~= rawOwner(g, po) then
          -- Lua cannot restore inheritance: same value, but it is no longer shared
          setRaw(fm, P.gvVal[g][fm + 1])
          gvShareLost[g] = true
        end
      end
    end
  end
  log[#log + 1] = "Flight modes FM0-FM6 written" .. (inst.lllTrims and " (3PK trims loaded)" or " (trims kept)")
  log[#log + 1] = "GV values: " .. nKept .. " kept, " .. (9 - nKept) .. " from 3PK (own value per flight mode)"
end

local LS_TUNABLE = { [1] = true, [12] = true, [28] = true, [29] = true }
local function lsCapture(i, pf)
  if not LS_TUNABLE[i] then return nil end
  local c = model.getLogicalSwitch(i)
  if c and c.func == pf then return c end
  return nil
end

local BY = {}
local function profLS(i)
  if not BY.ls then BY.ls = {} for _, l in ipairs(P.ls) do BY.ls[l.idx] = l end end
  return BY.ls[i]
end
local function profSF(i)
  if not BY.sf then BY.sf = {} for _, x in ipairs(P.sf) do BY.sf[x.idx] = x end end
  return BY.sf[i]
end

local function writeLS(i)
  local l = profLS(i)
  if not l then model.setLogicalSwitch(i, { func = 0 }) return end
  if i == 1 and SWMAP.lL then      -- LANDING on a switch instead of the throttle stick
    model.setLogicalSwitch(i, { func = LSF.AND, v1 = physSw(SWMAP.lL, SWMAP.lP), v2 = 0, ["and"] = 0, delay = 0, duration = 0 })
    return
  end
  local func = LSF[l.f]
  local cap = lsCapture(i, func)
  local t = { func = func, ["and"] = swIdx(l.andsw), delay = l.delay, duration = l.dur }
  if l.f == "AND" or l.f == "OR" or l.f == "XOR" then
    t.v1 = swIdx(l.v1) t.v2 = swIdx(l.v2)
  elseif l.f == "EDGE" then
    t.v1 = swIdx(l.v1) t.v2 = l.v2 t.v3 = l.v3
  else
    t.v1 = srcId(l.v1) t.v2 = l.v2
    if cap then t.v2 = cap.v2 t.delay = cap.delay end
  end
  model.setLogicalSwitch(i, t)
end

local function writeLogic(log)
  for i = 0, 31 do writeLS(i) end
  log[#log + 1] = "Logical switches L1-L32 written"
end

local function writeSF(i)
  local s = profSF(i)
  if not s then model.setCustomFunction(i, { switch = 0, func = 0 }) return end
  local func = CFF[s.f]
  local old = model.getCustomFunction(i)
  local act = s.act
  if old and old.func == func and old.active ~= nil then act = old.active end
  local t = { switch = swIdx(s.sw), func = func, active = act }
  if s.f == "PLAY_TRACK" then
    t.name = s.name t.repetition = s.rep
  elseif s.f == "PLAY_SOUND" then
    t.value = s.val t.repetition = s.rep
  elseif s.f == "PLAY_VALUE" then
    t.value = srcId(s.src) t.repetition = s.rep
  elseif s.f == "SET_SCREEN" then
    t.value = s.val t.repetition = s.rep
  elseif s.f == "ADJUST_GVAR" then
    t.param = s.param t.mode = s.mode t.value = s.val
  elseif s.f == "RESET" then
    t.value = s.val
  elseif s.f == "SET_TIMER" then
    t.param = s.param t.value = s.val
    if old and old.func == func and old.value then t.value = old.value end
  end
  model.setCustomFunction(i, t)
end

local function writeFunctions(log)
  local maxIdx = 0
  for _, x in ipairs(P.sf) do if x.idx > maxIdx then maxIdx = x.idx end end
  for i = 0, maxIdx do writeSF(i) end
  log[#log + 1] = "Special functions SF1-SF" .. (maxIdx + 1) .. " written"
end

-- rewrite only the lines that use the motor / flight-mode switches
function applySwitchMap()
  missing = {}
  for _, i in ipairs({ 0, 1, 2, 3, 4, 5, 19, 20 }) do writeLS(i) end
  for _, i in ipairs({ 0, 1 }) do writeSF(i) end
end

local function writeTimers(log)
  for _, t in ipairs(P.timers) do
    local old = model.getTimer(t.idx)
    local start = t.start
    if old and old.name == t.name and old.start then start = old.start end
    model.setTimer(t.idx, { name = t.name, start = start, switch = swIdx(t.sw), mode = t.mode,
      countdownBeep = t.cdb, minuteBeep = (t.minb == 1), persistent = t.pers,
      countdownStart = t.cds, showElapsed = (t.el == 1), extraHaptic = t.hap })
  end
  log[#log + 1] = "Timers T1-T3 written"
end

local function writeOutputs(log)
  for _, o in ipairs(P.outputs) do
    local cur = getOut(o.ch)
    if cur then
      cur.name = o.name
      if cur.curve == nil and o.curve >= 0 then cur.curve = o.curve end
      setOut(o.ch, cur)
    end
  end
  log[#log + 1] = "Output names CH1-CH16 set (calibration kept)"
end

function install()
  local log = {}
  missing = {}
  local ok, err = pcall(function()
    calOff()
    writeCurves(log)
    writeInputs(log)
    writeMixes(log)
    writeFlightModes(log)
    writeLogic(log)
    writeFunctions(log)
    writeTimers(log)
    writeOutputs(log)
  end)
  local warn = {}
  for k in pairs(missing) do
    if k == "RxBt" or k == "RQly" then
      warn[#warn + 1] = "Sensor " .. k .. " not found: discover telemetry, then Install again"
    else
      warn[#warn + 1] = "Not found on this radio: " .. k
    end
  end
  refreshStatus()
  return ok, ok and log or { tostring(err) }, warn
end
end

---------------------------------------------------------------------------
-- Per-model tool settings
---------------------------------------------------------------------------
local cfg = { link = 0, pair = 0, d1 = 0, d2 = 0, d3 = 0, info = 1,
  swOk = 0, swM = 2, swMP = 2, sw1 = 5, sw2 = 6, swL = 0, swLP = 2,   -- switch letters as 1..10 = A..J
  fs = 0, f1 = 0, f2 = 0, f3 = 0, f4 = 0, f5 = 0, f6 = 0, f7 = 0, f8 = 0, f9 = 0 }

local function letOf(n) return string.sub(SW_LET, n, n) end

local function syncMap()
  SWMAP.mL, SWMAP.mP = letOf(cfg.swM), cfg.swMP
  SWMAP.m1, SWMAP.m2 = letOf(cfg.sw1), letOf(cfg.sw2)
  if cfg.swL > 0 then SWMAP.lL, SWMAP.lP = letOf(cfg.swL), cfg.swLP else SWMAP.lL = nil end
end

local function mapToCfg(m)
  cfg.swM, cfg.swMP, cfg.sw1, cfg.sw2 = string.find(SW_LET, m.mL, 1, true), m.mP, string.find(SW_LET, m.m1, 1, true), string.find(SW_LET, m.m2, 1, true)
  cfg.swL = m.lL and string.find(SW_LET, m.lL, 1, true) or 0
  cfg.swLP = m.lP or 2
end

-- read the switch assignment back from a programmed model (L1, L2, L3)
local function detectMap()
  local function findSw(idx)
    if not idx or idx == 0 then return nil end
    for k = 1, #SW_LET do
      local l = letOf(k)
      for p = 0, 2 do if physSw(l, p) == idx then return l, p end end
    end
    return nil
  end
  local l1, l2, l3 = model.getLogicalSwitch(0), model.getLogicalSwitch(1), model.getLogicalSwitch(2)
  if not (l1 and l2 and l3) or l1.func ~= LSF.AND or l3.func ~= LSF.AND then return end
  local m = { mL = SWMAP.mL, mP = SWMAP.mP, m1 = SWMAP.m1, m2 = SWMAP.m2, lL = nil, lP = 2 }
  local a, b = findSw(l1.v1)
  if a and b ~= 1 then m.mL, m.mP = a, b end
  a = findSw(l3.v1) if a then m.m1 = a end
  a = findSw(l3.v2) if a then m.m2 = a end
  if l2.func == LSF.AND then
    a, b = findSw(l2.v1)
    if a then m.lL, m.lP = a, b end
  end
  mapToCfg(m)
  syncMap()
end
local cfgPath = nil
local cfgSaveOk = true

local function modelKey()
  local info = model.getInfo()
  local n = (info and info.name) or "model"
  n = string.gsub(n, "[^%w%-_]", "_")
  if n == "" then n = "model" end
  return n
end

local function loadCfg()
  cfgPath = DATA_DIR .. modelKey() .. ".txt"
  local f = io.open(cfgPath, "r")
  if not f then return end
  local s = io.read(f, 1024) or ""
  io.close(f)
  for k, v in string.gmatch(s, "([%w_]+)=(%-?%d+)") do
    if cfg[k] ~= nil then cfg[k] = tonumber(v) end
  end
  syncMap()
end

local function saveCfg()
  if not cfgPath then return end
  local f = io.open(cfgPath, "w")
  if not f then cfgSaveOk = false return end
  for k, v in pairs(cfg) do io.write(f, k, "=", tostring(v), "\n") end
  io.close(f)
  cfgSaveOk = true
end

---------------------------------------------------------------------------
-- UI primitives
---------------------------------------------------------------------------
local C = {}
-- All layout is done on a virtual 480 x 272 canvas and scaled to the real
-- screen (TX16S MK3: 800 x 480). Font sizes are measured at start.
local W, H = 480, 272
local SX, SY = 1, 1
local BAR_H, BTN_H = 30, 36
local FH, CW = {}, {}          -- font height / char width per size flag, virtual units

local function fontKey(flags)
  flags = flags or 0
  if flags % 0x1000 >= 0x0800 then return DBLSIZE end
  if flags % 0x0800 >= 0x0400 then return MIDSIZE end
  if flags % 0x0400 >= 0x0200 then return SMLSIZE end
  return 0
end

local function initScale()
  local lw, lh = LCD_W or 480, LCD_H or 272
  SX, SY = lw / 480, lh / 272
  local defaults = { [0] = { 18, 8 }, [SMLSIZE] = { 14, 6 }, [MIDSIZE] = { 24, 11 }, [DBLSIZE] = { 36, 18 } }
  for _, f in ipairs({ 0, SMLSIZE, MIDSIZE, DBLSIZE }) do
    local h, cw = defaults[f][1], defaults[f][2]
    if lcd.sizeText then
      local ok, tw, th = pcall(lcd.sizeText, "Abcdefghij", f)
      if ok and tw and th and tw > 0 then cw = tw / 10 / SX h = th / SY end
    end
    FH[f], CW[f] = h, cw
  end
end

local function initColors()
  C.bg     = lcd.RGB(14, 20, 28)
  C.bar    = lcd.RGB(26, 82, 118)
  C.panel  = lcd.RGB(30, 42, 56)
  C.btn    = lcd.RGB(42, 60, 78)
  C.hot    = lcd.RGB(214, 140, 24)
  C.go     = lcd.RGB(40, 150, 80)
  C.off    = lcd.RGB(60, 66, 74)
  C.txt    = lcd.RGB(240, 244, 248)
  C.dim    = lcd.RGB(150, 162, 176)
  C.acc    = lcd.RGB(245, 190, 40)
  C.warn   = lcd.RGB(235, 90, 70)
  C.ok     = lcd.RGB(90, 200, 120)
  C.line   = lcd.RGB(110, 170, 200)
end

local buttons, focus = {}, 1
local touchX, touchY

local function text(x, y, s, flags, color)
  lcd.drawText(math.floor(x * SX + 0.5), math.floor(y * SY + 0.5), s, (flags or 0) + (color or C.txt))
end

local function rect(x, y, w, h, color)
  local x0, y0 = math.floor(x * SX + 0.5), math.floor(y * SY + 0.5)
  lcd.drawFilledRectangle(x0, y0, math.max(1, math.floor((x + w) * SX + 0.5) - x0),
    math.max(1, math.floor((y + h) * SY + 0.5) - y0), color)
end

local function frame(x, y, w, h, color, t)
  local x0, y0 = math.floor(x * SX + 0.5), math.floor(y * SY + 0.5)
  lcd.drawRectangle(x0, y0, math.floor((x + w) * SX + 0.5) - x0, math.floor((y + h) * SY + 0.5) - y0, color, t or 1)
end

local function line(x1, y1, x2, y2, color)
  lcd.drawLine(math.floor(x1 * SX + 0.5), math.floor(y1 * SY + 0.5), math.floor(x2 * SX + 0.5),
    math.floor(y2 * SY + 0.5), SOLID, color)
end

local function header(title, right)
  rect(0, 0, W, H, C.bg)
  rect(0, 0, W, BAR_H, C.bar)
  text(8, 4, title, MIDSIZE, C.txt)
  if right then text(W - 8, 7, right, RIGHT, C.txt) end
end

local function wrap(x, y, w, s, flags, color, lineH)
  lineH = math.max(lineH or 18, FH[fontKey(flags)] + 1)
  local charW = CW[fontKey(flags)]
  local maxc = math.max(8, math.floor(w / charW))
  local line = ""
  for word in string.gmatch(s, "%S+") do
    if #line + #word + 1 > maxc and line ~= "" then
      text(x, y, line, flags, color)
      y = y + lineH
      line = word
    else
      line = (line == "") and word or (line .. " " .. word)
    end
  end
  if line ~= "" then text(x, y, line, flags, color) y = y + lineH end
  return y
end

-- style: nil | "hot" | "go" | "warn" | "sel" | "off" | "ghost"
local function button(x, y, w, h, label, action, style, flags)
  buttons[#buttons + 1] = { x = x, y = y, w = w, h = h, label = label, action = action, style = style, flags = flags }
end

local function drawButtons()
  if focus > #buttons then focus = #buttons end
  if focus < 1 then focus = 1 end
  for i, b in ipairs(buttons) do
    if b.style == "ghost" then
      if i == focus then frame(b.x, b.y, b.w, b.h, C.acc, 2) end
    else
      local col = C.btn
      if b.style == "hot" then col = C.hot
      elseif b.style == "go" then col = C.go
      elseif b.style == "warn" then col = C.warn
      elseif b.style == "sel" then col = C.bar
      elseif b.style == "off" then col = C.off end
      rect(b.x, b.y, b.w, b.h, col)
      if i == focus then frame(b.x, b.y, b.w, b.h, C.acc, 2)
      else frame(b.x, b.y, b.w, b.h, C.line) end
      local f = b.flags or 0
      local lbl = b.label
      local maxc = math.floor((b.w - 4) / CW[fontKey(f)])
      if #lbl > maxc and f == 0 then f = SMLSIZE maxc = math.floor((b.w - 4) / CW[SMLSIZE]) end
      if #lbl > maxc then lbl = string.sub(lbl, 1, math.max(1, maxc - 1)) .. "." end
      text(b.x + b.w / 2, b.y + (b.h - FH[fontKey(f)]) / 2, lbl, CENTER + f, (b.style == "off") and C.dim or C.txt)
    end
  end
end

local function bottomRow(list)
  local n = #list
  local gap = 6
  local bw = math.floor((W - gap * (n + 1)) / n)
  for i, b in ipairs(list) do
    button(gap + (i - 1) * (bw + gap), H - BTN_H - 4, bw, BTN_H, b[1], b[2], b[3], b[4])
  end
end

local function handleButtons(event)
  if event == EV.TAP and touchX then
    for i, b in ipairs(buttons) do
      if touchX >= b.x and touchX <= b.x + b.w and touchY >= b.y and touchY <= b.y + b.h then
        focus = i
        if b.action then b.action() end
        return true
      end
    end
  elseif event == EV.ENTER then
    local b = buttons[focus]
    if b and b.action then b.action() return true end
  end
  return false
end

local function focusNav(event)
  if #buttons == 0 then return end
  if event == EV.NEXT then focus = focus + 1 if focus > #buttons then focus = 1 end
  elseif event == EV.PREV then focus = focus - 1 if focus < 1 then focus = #buttons end end
end

-- horizontal value bar, v in %, centered
local function vbar(x, y, w, h, v, lo, hi, col)
  rect(x, y, w, h, C.panel)
  local function px(a) return x + math.floor((clamp(a, lo, hi) - lo) / (hi - lo) * w) end
  local z = px(0)
  local p = px(v)
  if p >= z then rect(z, y + 1, math.max(1, p - z), h - 2, col or C.acc)
  else rect(p, y + 1, z - p, h - 2, col or C.acc) end
  rect(z, y - 2, 1, h + 4, C.dim)
end

---------------------------------------------------------------------------
-- Screen system
---------------------------------------------------------------------------
local screen, screens = "home", {}
local stack = {}
local exitRequested = false

local function go(name, ...)
  buttons, focus = {}, 1
  screen = name
  if screens[name].enter then screens[name].enter(...) end
end

local function push(name, ...)
  stack[#stack + 1] = screen
  go(name, ...)
end

local function back()
  local s = stack[#stack] or "home"
  stack[#stack] = nil
  buttons, focus = {}, 1
  screen = s
  if screens[s].resume then screens[s].resume() end
end

local function home()
  stack = {}
  calOff()
  go("home")
end

---------------------------------------------------------------------------
-- Generic value editor
--   spec = { title, label, hint, get(fm), set(fm, v), perFM, min, max,
--            step, big, fmt(v), phys(v), force(v), unit }
---------------------------------------------------------------------------
local E = nil

local function edBegin(spec)
  E = spec
  local fm0 = getFlightMode()
  E.fmSel = (E.perFM and fm0 < NFM and not (E.inactive and E.inactive[fm0])) and fm0 or 0
  E.follow = false     -- the selected cell stays: every flight mode can be pre-set
  edLog = { gv = {}, mix = {}, misc = {} }
  E.orig = E.get(E.fmSel)
end

local function edRestore()
  if not edLog then return end
  for key, v in pairs(edLog.gv) do
    local g, fm = string.match(key, "^(%d+):(%d+)$")
    g, fm = tonumber(g), tonumber(fm)
    model.setGlobalVariable(g - 1, fm, v)
    if A and A.gvRaw and A.gvRaw[g] then A.gvRaw[g][fm] = v end
  end
  for key, m in pairs(edLog.mix) do
    local ch, name = string.match(key, "^(%d+)/(.*)$")
    local l = findMix(tonumber(ch), name)
    if l then rewriteMix(tonumber(ch), l, m) end
  end
  for _, f in ipairs(edLog.misc) do f() end
  edLog = nil
end

local function edApply(v)
  v = clamp(round(v), E.min, E.max)
  if v ~= E.get(E.fmSel) then E.set(E.fmSel, v) end
end

screens.edit = {
  enter = function(spec) edBegin(spec) end,
  run = function(event)
    buttons = {}
    local fmNow, fmName = getFlightMode()
    if E.perFM and E.follow and fmNow ~= E.fmSel and fmNow < NFM and not (E.inactive and E.inactive[fmNow]) then
      E.fmSel = fmNow
    end
    local v = E.get(E.fmSel)
    if event == EV.INC or event == EV.NEXT then edApply(v + (E.step or 1)) v = E.get(E.fmSel)
    elseif event == EV.DEC or event == EV.PREV then edApply(v - (E.step or 1)) v = E.get(E.fmSel) end
    if E.force then E.force(v) end
    header(E.title, "FM" .. fmNow .. " " .. (fmName or ""))
    text(8, BAR_H + 4, E.label, MIDSIZE, C.txt)
    local y = wrap(8, BAR_H + 30, W - 16, E.hint or "", SMLSIZE, C.dim, 14)
    local fmY = y
    local cw = math.floor((W - 16) / NFM)
    if E.perFM then
      for fm = 0, NFM - 1 do
        local x = 8 + fm * cw
        local sel = (fm == E.fmSel)
        local off = E.inactive and E.inactive[fm]
        button(x, y + 2, cw - 4, 46, "", function() if not off then E.fmSel = fm E.follow = false end end,
          off and "off" or (sel and "sel" or nil))
      end
      y = y + 52
    end
    local vs = E.fmt and E.fmt(v) or (tostring(v) .. (E.unit or ""))
    text(8, y + 2, vs, DBLSIZE, C.acc)
    if E.phys then text(W - 8, y + 14, E.phys(v), RIGHT, C.txt) end
    y = y + 44
    local sw = math.floor((W - 16 - 18) / 4)
    local big, step = E.big or 10, E.step or 1
    local fmtStep = E.fmtStep or function(s) return tostring(s) end
    button(8, y, sw, 32, "-" .. fmtStep(big), function() edApply(E.get(E.fmSel) - big) end)
    button(8 + (sw + 6), y, sw, 32, "-" .. fmtStep(step), function() edApply(E.get(E.fmSel) - step) end)
    button(8 + 2 * (sw + 6), y, sw, 32, "+" .. fmtStep(step), function() edApply(E.get(E.fmSel) + step) end)
    button(8 + 3 * (sw + 6), y, sw, 32, "+" .. fmtStep(big), function() edApply(E.get(E.fmSel) + big) end)
    local row = { { "Cancel", function() edRestore() if E.onClose then E.onClose() end back() end } }
    if E.perFM then
      row[#row + 1] = { E.follow and "Follow FM: on" or "Follow FM: off", function() E.follow = not E.follow end, nil, SMLSIZE }
    end
    if E.extraBtn then row[#row + 1] = E.extraBtn end
    local function done() edLog = nil saveCfg() if E.onClose then E.onClose() end back() end
    row[#row + 1] = { "Done", done, "hot" }
    bottomRow(row)
    drawButtons()
    if E.perFM then
      for fm = 0, NFM - 1 do
        local x = 8 + fm * cw + (cw - 4) / 2
        text(x, fmY + 3, FM_SHORT[fm] .. (fm == fmNow and "*" or ""), SMLSIZE + CENTER, C.dim)
        local tag = E.tag and E.tag(fm) or ""
        if E.inactive and E.inactive[fm] then tag = "" end
        text(x, fmY + 17, (E.inactive and E.inactive[fm]) and "off" or tostring(E.get(fm)), SMLSIZE + CENTER,
          (fm == E.fmSel) and C.acc or C.txt)
        if tag ~= "" then text(x, fmY + 31, "(" .. tag .. ")", SMLSIZE + CENTER, C.dim) end
      end
    end
    if event == EV.ENTER then done() return end
    if event == EV.EXIT then edRestore() if E.onClose then E.onClose() end back() return end
    if event == EV.PGN and E.perFM then E.fmSel = (E.fmSel + 1) % NFM E.follow = false end
    if event == EV.PGP and E.perFM then E.fmSel = (E.fmSel + NFM - 1) % NFM E.follow = false end
    if event == EV.TAP then handleButtons(event) end
  end,
}

-- builders for common spec types ------------------------------------------
local function mixSpec(ch, name, field, label, hint, lo, hi, extra)
  local s = {
    title = extra and extra.title or "Tuning", label = label, hint = hint, min = lo, max = hi,
    unit = "%", step = 1, big = 10,
    get = function()
      local _, m = findMix(ch, name)
      if not m then return 0 end
      local v = m[field]
      if gvOfNum(v) then return 0 end
      return v or 0
    end,
    set = function(_, v)
      local l, m = findMix(ch, name)
      if not l then return end
      local key = ch .. "/" .. name
      if edLog and not edLog.mix[key] then edLog.mix[key] = copyMix(m) end
      local t = copyMix(m)
      t[field] = v
      rewriteMix(ch, l, t)
    end,
  }
  if extra then for k, v in pairs(extra) do s[k] = v end end
  return s
end

local function gvSpec(g, label, hint, lo, hi, extra)
  local s
  s = {
    title = extra and extra.title or "Tuning", label = label, hint = hint, min = lo, max = hi,
    unit = "%", step = 1, big = 5, perFM = true,
    get = function(fm) return gvGet(g, fm) end,
    set = function(fm, v)
      local old = gvGet(g, fm)
      gvSet(g, fm, v)
      if s.pair and cfg.pair == 1 then
        local pg, sign = s.pair[1], s.pair[2]
        gvSet(pg, fm, clamp(gvGet(pg, fm) + (v - old) * sign, lo, hi))
      end
    end,
    tag = function(fm) return gvTag(g, fm) end,
  }
  if extra and extra.inactive then
    s.inactive = extra.inactive
  end
  if extra then for k, v in pairs(extra) do s[k] = v end end
  return s
end

local function inputSpec(chn, field, label, hint, lo, hi)
  return {
    title = "Sticks / inputs", label = label, hint = hint, min = lo, max = hi, unit = "%", step = 1, big = 5,
    get = function()
      local g = model.getInput(chn, 0)
      return g and (g[field] or 0) or 0
    end,
    set = function(_, v)
      local g = model.getInput(chn, 0)
      if not g then return end
      if edLog and not edLog.misc["in" .. chn] then
        local orig = {}
        for k, x in pairs(g) do orig[k] = x end
        edLog.misc["in" .. chn] = true
        edLog.misc[#edLog.misc + 1] = function()
          model.deleteInput(chn, 0)
          model.insertInput(chn, 0, orig)     -- getInput/insertInput use the same trimSource sign
        end
      end
      g[field] = v
      model.deleteInput(chn, 0)
      model.insertInput(chn, 0, g)
    end,
  }
end

---------------------------------------------------------------------------
-- Curve editor
---------------------------------------------------------------------------
local CE = nil

local function curveGet(idx) return model.getCurve(idx) end

local function curveSetY(idx, i, v)
  local c = curveGet(idx)
  if not c then return end
  local t = { name = c.name, type = c.type, smooth = c.smooth, y = {} }
  for k = 1, c.points do t.y[k] = c.y[k] end
  t.y[i] = clamp(v, -100, 100)
  if c.type == 1 and c.x then t.x = {} for k = 1, c.points do t.x[k] = c.x[k] end end
  model.setCurve(idx, t)
end

screens.curve = {
  enter = function(spec)
    CE = spec
    CE.pt = 1
    local c = curveGet(CE.idx)
    CE.orig = c
  end,
  run = function(event)
    buttons = {}
    local c = curveGet(CE.idx)
    if not c then back() return end
    local n = c.points
    local function xOf(i)
      if c.type == 1 and c.x then return c.x[i] end
      return round(-100 + 200 * (i - 1) / (n - 1))
    end
    if event == EV.INC or event == EV.NEXT then curveSetY(CE.idx, CE.pt, c.y[CE.pt] + 1) c = curveGet(CE.idx)
    elseif event == EV.DEC or event == EV.PREV then curveSetY(CE.idx, CE.pt, c.y[CE.pt] - 1) c = curveGet(CE.idx) end
    if CE.force then CE.force(xOf(CE.pt)) end
    header(CE.title or "Curve", "CV" .. (CE.idx + 1) .. " " .. (c.name or ""))
    text(8, BAR_H + 4, CE.label, MIDSIZE, C.txt)
    local gx, gy, gw, gh = W - 200, BAR_H + 34, 190, H - BAR_H - BTN_H - 92
    wrap(8, BAR_H + 30, gx - 16, CE.hint or "", SMLSIZE, C.dim, 14)
    rect(gx, gy, gw, gh, C.panel)
    rect(gx, gy + gh / 2, gw, 1, C.dim)
    rect(gx + gw / 2, gy, 1, gh, C.dim)
    local function px(x) return gx + (x + 100) * (gw - 1) / 200 end
    local function py(y) return gy + gh / 2 - y * (gh / 2 - 2) / 100 end
    for i = 1, n - 1 do
      line(px(xOf(i)), py(c.y[i]), px(xOf(i + 1)), py(c.y[i + 1]), C.acc)
    end
    for i = 1, n do
      rect(px(xOf(i)) - 2, py(c.y[i]) - 2, 5, 5, (i == CE.pt) and C.warn or C.acc)
    end
    if CE.live then
      local lx = CE.live()
      if lx then rect(px(clamp(lx, -100, 100)), gy, 1, gh, C.ok) end
    end
    local ptName = CE.ptNames and CE.ptNames[CE.pt] or ("x = " .. xOf(CE.pt))
    text(8, gy + gh - 40, "Point " .. CE.pt .. "/" .. n .. "  (" .. ptName .. ")", 0, C.acc)
    local yv = c.y[CE.pt]
    text(8, gy + gh - 18, "y = " .. yv .. (CE.yfmt and ("   " .. CE.yfmt(yv)) or ""), 0, C.txt)
    local by = H - BTN_H - 46
    local sw = math.floor((W - 16 - 30) / 6)
    local function b(i, label, fn) button(8 + (i - 1) * (sw + 6), by, sw, 34, label, fn) end
    b(1, "< Pt", function() CE.pt = (CE.pt > 1) and CE.pt - 1 or n end)
    b(2, "-10", function() curveSetY(CE.idx, CE.pt, yv - 10) end)
    b(3, "-1", function() curveSetY(CE.idx, CE.pt, yv - 1) end)
    b(4, "+1", function() curveSetY(CE.idx, CE.pt, yv + 1) end)
    b(5, "+10", function() curveSetY(CE.idx, CE.pt, yv + 10) end)
    b(6, "Pt >", function() CE.pt = (CE.pt % n) + 1 end)
    bottomRow({
      { "Cancel", function()
          local o = CE.orig
          local t = { name = o.name, type = o.type, smooth = o.smooth, y = o.y }
          if o.type == 1 then t.x = o.x end
          model.setCurve(CE.idx, t)
          if CE.onClose then CE.onClose() end
          back()
        end },
      { "Done", function() if CE.onClose then CE.onClose() end back() end, "hot" },
    })
    drawButtons()
    if event == EV.EXIT then
      local o = CE.orig
      local t = { name = o.name, type = o.type, smooth = o.smooth, y = o.y }
      if o.type == 1 then t.x = o.x end
      model.setCurve(CE.idx, t)
      if CE.onClose then CE.onClose() end
      back()
      return
    end
    if event == EV.PGN then CE.pt = (CE.pt % n) + 1 end
    if event == EV.PGP then CE.pt = (CE.pt > 1) and CE.pt - 1 or n end
    if event == EV.TAP then handleButtons(event) end
  end,
}

---------------------------------------------------------------------------
-- Flight-mode matrix editor (which flight modes a mix line is active in)
---------------------------------------------------------------------------
local MX = nil

local function fmActive(mask, fm) return math.floor(mask / 2 ^ fm) % 2 == 0 end

local function maskToggle(mask, fm)
  if fmActive(mask, fm) then return round(mask + 2 ^ fm) end
  return round(mask - 2 ^ fm)
end

screens.matrix = {
  enter = function(spec)
    MX = spec
    MX.orig = {}
    for _, r in ipairs(MX.rows) do
      local _, m = findMix(r.ch, r.name)
      MX.orig[#MX.orig + 1] = m and m.flightModes or 0
    end
  end,
  run = function(event)
    buttons = {}
    local fmNow = getFlightMode()
    header(MX.title, "FM" .. fmNow)
    wrap(8, BAR_H + 4, W - 16, MX.hint, SMLSIZE, C.dim, 14)
    local top = BAR_H + 36
    local lw = 110
    local cw = math.floor((W - lw - 16) / NFM)
    for fm = 0, NFM - 1 do
      text(lw + 8 + fm * cw + cw / 2, top, FM_SHORT[fm], SMLSIZE + CENTER, (fm == fmNow) and C.acc or C.dim)
    end
    local rh = math.min(34, math.floor((H - top - BTN_H - 30) / #MX.rows))
    for i, r in ipairs(MX.rows) do
      local y = top + 18 + (i - 1) * rh
      text(8, y + (rh - 4 - FH[0]) / 2, r.label, 0, C.txt)
      local _, m = findMix(r.ch, r.name)
      local mask = m and m.flightModes or 0
      for fm = 0, NFM - 1 do
        local on = fmActive(mask, fm)
        button(lw + 8 + fm * cw, y, cw - 4, rh - 4, on and "ON" or "-", function()
          local l, mm = findMix(r.ch, r.name)
          if l then
            local t = copyMix(mm)
            t.flightModes = maskToggle(mm.flightModes or 0, fm)
            rewriteMix(r.ch, l, t)
          end
        end, on and "go" or "off", SMLSIZE)
      end
    end
    local function restore()
      for i, r in ipairs(MX.rows) do
        local l, mm = findMix(r.ch, r.name)
        if l then local t = copyMix(mm) t.flightModes = MX.orig[i] rewriteMix(r.ch, l, t) end
      end
    end
    local row = { { "Cancel", function() restore() back() end } }
    if MX.copyFrom then
      row[#row + 1] = { MX.copyLabel, function()
        local _, src = findMix(MX.copyFrom.ch, MX.copyFrom.name)
        if not src then return end
        for _, r in ipairs(MX.rows) do
          local l, mm = findMix(r.ch, r.name)
          if l then local t = copyMix(mm) t.flightModes = src.flightModes rewriteMix(r.ch, l, t) end
        end
      end, nil, SMLSIZE }
    end
    row[#row + 1] = { "Done", function() back() end, "hot" }
    bottomRow(row)
    drawButtons()
    if event == EV.EXIT then restore() back() return end
    focusNav(event)
    handleButtons(event)
  end,
}

---------------------------------------------------------------------------
-- Item lists (tuning screens)
---------------------------------------------------------------------------
local LST = nil

local function itemValueText(it)
  if it.value then
    local ok, v = pcall(it.value)
    if ok and v then return v end
  end
  return ""
end

screens.list = {
  enter = function(def) LST = def LST.page = 1 end,
  resume = function() end,
  run = function(event)
    buttons = {}
    local fmNow, fmName = getFlightMode()
    header(LST.title, "FM" .. fmNow .. " " .. (fmName or ""))
    local top = BAR_H + 4
    if LST.intro then top = wrap(8, top, W - 16, LST.intro, SMLSIZE, C.dim, 14) + 2 end
    local rowH = 30
    local perPage = math.max(1, math.floor((H - top - BTN_H - 12) / rowH))
    local pages = math.ceil(#LST.items / perPage)
    if LST.page > pages then LST.page = 1 end
    local first = (LST.page - 1) * perPage + 1
    for i = first, math.min(#LST.items, first + perPage - 1) do
      local it = LST.items[i]
      local y = top + (i - first) * rowH
      button(6, y, W - 12, rowH - 3, "", function() it.open() end, it.style)
    end
    local row = { { "Back", function() back() end } }
    if pages > 1 then
      row[#row + 1] = { "Page " .. LST.page .. "/" .. pages, function() LST.page = (LST.page % pages) + 1 end }
    end
    if LST.extraBtn then
      row[#row + 1] = (type(LST.extraBtn) == "function") and LST.extraBtn() or LST.extraBtn
    end
    bottomRow(row)
    drawButtons()
    for i = first, math.min(#LST.items, first + perPage - 1) do
      local it = LST.items[i]
      local y = top + (i - first) * rowH
      text(14, y + (rowH - 3 - FH[0]) / 2, it.label, 0, C.txt)
      text(W - 14, y + (rowH - 3 - FH[SMLSIZE]) / 2, itemValueText(it), RIGHT + SMLSIZE, C.acc)
    end
    if event == EV.EXIT then back() return end
    if event == EV.PGN and pages > 1 then LST.page = (LST.page % pages) + 1 end
    if event == EV.PGP and pages > 1 then LST.page = (LST.page > 1) and LST.page - 1 or pages end
    focusNav(event)
    handleButtons(event)
  end,
}

-- item constructors --------------------------------------------------------
local function mixItem(ch, name, field, label, hint, lo, hi, extra)
  return {
    label = label,
    value = function()
      local _, m = findMix(ch, name)
      if not m then return "missing" end
      local v = m[field]
      local n, sgn = gvOfNum(v)
      if n then return (sgn < 0 and "-" or "") .. "GV" .. n end
      return tostring(v) .. "%"
    end,
    open = function() push("edit", mixSpec(ch, name, field, label, hint, lo, hi, extra)) end,
  }
end

local function gvItem(g, label, hint, lo, hi, extra)
  return {
    label = label,
    value = function()
      local fm = getFlightMode()
      if extra and extra.inactive and extra.inactive[fm] then return "off (" .. FM_SHORT[math.min(fm, 6)] .. ")" end
      return gvGet(g, fm) .. "% (" .. FM_SHORT[math.min(fm, 6)] .. ")"
    end,
    open = function() push("edit", gvSpec(g, label, hint, lo, hi, extra)) end,
  }
end

local function curveItem(idx, label, hint, extra)
  return {
    label = label,
    value = function()
      local c = model.getCurve(idx)
      return c and ("CV" .. (idx + 1) .. " " .. c.name) or ""
    end,
    open = function()
      local spec = { idx = idx, label = label, hint = hint }
      if extra then for k, v in pairs(extra) do spec[k] = v end end
      push("curve", spec)
    end,
  }
end

local function inputItem(chn, field, label, hint, lo, hi)
  return {
    label = label,
    value = function()
      local g = model.getInput(chn, 0)
      return g and (tostring(g[field]) .. "%") or ""
    end,
    open = function() push("edit", inputSpec(chn, field, label, hint, lo, hi)) end,
  }
end

local function openList(def) push("list", def) end

---------------------------------------------------------------------------
-- Calibration: servo direction (stick test), center, endpoints, servo curves
---------------------------------------------------------------------------
local DIR_TEST = {
  [ELE]   = VT and "Elev stick forward: V-tail L DOWN" or "Elev stick forward: elevator DOWN",
  [RUD]   = VT and "Elev stick forward: V-tail R DOWN" or "Rudder stick right: rudder RIGHT",
  [AIL_L] = "Ail stick right: left ail. DOWN",
  [AIL_R] = "Ail stick right: right ail. UP",
  [FLP_L] = "Throttle down (crow): flap DOWN",
  [FLP_R] = "Throttle down (crow): flap DOWN",
}

screens.dir = {
  enter = function() motorLock() end,
  run = function(event)
    buttons = {}
    motorLock()
    header("Servo direction", "motor locked OFF")
    local top = BAR_H + 4
    text(8, top, "Move the stick as shown and watch the surface. Wrong way: tap Reverse.", SMLSIZE, C.dim)
    top = top + FH[SMLSIZE] + 4
    local rh = math.floor((H - top - BTN_H - 8 - FH[SMLSIZE] - 4) / #SURF)
    for i, ch in ipairs(SURF) do
      local y = top + (i - 1) * rh
      local o = getOut(ch)
      button(W - 70, y + 1, 64, rh - 3, (o and o.revert == 1) and "Reversed" or "Normal", function()
        local oo = getOut(ch)
        oo.revert = (oo.revert == 1) and 0 or 1
        setOut(ch, oo)
        cfg.d1 = 0
      end, (o and o.revert == 1) and "hot" or nil, SMLSIZE)
    end
    bottomRow({ { "Back", function() home() end },
      { "All correct", function() cfg.d1 = 1 saveCfg() home() end, "go" } })
    drawButtons()
    for i, ch in ipairs(SURF) do
      local y = top + (i - 1) * rh
      if i % 2 == 0 then rect(4, y, W - 78, rh - 1, C.panel) end
      local cy = y + (rh - 1 - FH[0]) / 2
      text(8, cy, "CH" .. (ch + 1) .. " " .. CH_NAME[ch], 0, C.txt)
      text(112, y + (rh - 1 - FH[SMLSIZE]) / 2, DIR_TEST[ch], SMLSIZE, C.dim)
      local v = chValue(ch)
      vbar(318, y + rh / 2 - 4, 60, 8, v, -100, 100)
      text(W - 76, y + (rh - 1 - FH[SMLSIZE]) / 2, string.format("%d%%", round(v)), RIGHT + SMLSIZE, C.acc)
    end
    if VT then
      text(8, H - BTN_H - 6 - FH[SMLSIZE], "Then rudder right: left V UP, right V DOWN (else Roll & rudder > Swap).", SMLSIZE, C.acc)
    else
      text(8, H - BTN_H - 6 - FH[SMLSIZE], "Reverse mirrors the subtrim: check Center after reversing.", SMLSIZE, C.warn)
    end
    if event == EV.EXIT then home() return end
    focusNav(event)
    handleButtons(event)
  end,
}

local function usOf(ch, pct)
  local o = getOut(ch)
  local s = (o.revert == 1) and -1 or 1
  return 1500 + o.ppmCenter + round(s * pct * 5.12)
end

local function centerSpec(ch)
  return {
    title = "Center (subtrim)", label = "CH" .. (ch + 1) .. " " .. CH_NAME[ch],
    hint = "Surface at neutral: in line with the wing / stabilizer profile in CRUISE. All surfaces are held at 0, motor locked OFF.",
    min = -1000, max = 1000, step = 1, big = 10,
    fmtStep = function(s) return string.format("%.1f", s / 10) end,
    fmt = function(v) return string.format("%.1f%%", v / 10) end,
    phys = function(v) return usOf(ch, v / 10) .. " us" end,
    get = function() return getOut(ch).offset end,
    set = function(_, v)
      local o = getOut(ch)
      if edLog and not edLog.misc["c" .. ch] then
        local orig = o.offset
        edLog.misc["c" .. ch] = true
        edLog.misc[#edLog.misc + 1] = function() local oo = getOut(ch) oo.offset = orig setOut(ch, oo) end
      end
      o.offset = v
      setOut(ch, o)
    end,
    force = function()
      local t = {}
      for _, c in ipairs(SURF) do t[c] = 0 end
      motorLock(t)
    end,
    onClose = function() motorLock() end,
  }
end

local function endpointSpec(ch, isMin)
  local word = isMin and NEG_WORD[ch] or POS_WORD[ch]
  local ext = model.getInfo().extendedLimits
  local lim = ext and 1500 or 1000
  local hint = "Maximum " .. string.lower(word) .. " travel without binding."
  if (ch == FLP_L or ch == FLP_R) and isMin then
    hint = "Flap DOWN for crow: as far as possible, stop just before the mechanical stop."
  end
  return {
    title = "Endpoints", label = "CH" .. (ch + 1) .. " " .. CH_NAME[ch] .. " - " .. word,
    hint = hint .. " The channel is held at " .. (isMin and "-100%" or "+100%") .. ", motor locked OFF.",
    min = isMin and -lim or 0, max = isMin and 0 or lim, step = 5, big = 50,
    fmtStep = function(s) return string.format("%.1f", s / 10) end,
    fmt = function(v) return string.format("%.1f%%", v / 10) end,
    phys = function(v) return usOf(ch, v / 10) .. " us" end,
    get = function() local o = getOut(ch) return isMin and o.min or o.max end,
    set = function(_, v)
      local o = getOut(ch)
      if isMin then v = math.min(v, o.offset - 100) else v = math.max(v, o.offset + 100) end
      if edLog and not edLog.misc["e" .. ch .. tostring(isMin)] then
        local orig = isMin and o.min or o.max
        edLog.misc["e" .. ch .. tostring(isMin)] = true
        edLog.misc[#edLog.misc + 1] = function()
          local oo = getOut(ch)
          if isMin then oo.min = orig else oo.max = orig end
          setOut(ch, oo)
        end
      end
      if isMin then o.min = v else o.max = v end
      setOut(ch, o)
    end,
    force = function()
      local t = {}
      for _, c in ipairs(SURF) do t[c] = 0 end
      t[ch] = isMin and -100 or 100
      motorLock(t)
    end,
    onClose = function() motorLock() end,
  }
end

screens.calPick = {
  enter = function(kind) screens.calPick.kind = kind motorLock() end,
  resume = function() motorLock() end,
  run = function(event)
    buttons = {}
    local kind = screens.calPick.kind
    local titles = { center = "Center (subtrim)", endpoints = "Endpoints", curves = "Servo curves" }
    header(titles[kind], "motor locked OFF")
    local top = BAR_H + 6
    local intro = {
      center = "Pick a servo. It is held at neutral while you set the subtrim.",
      endpoints = "Pick a servo and side. The servo is driven to that end while you set the limit.",
      curves = "5-point servo curves (linearization). Each point drives the servo to that position.",
    }
    wrap(8, top, W - 16, intro[kind], SMLSIZE, C.dim, 14)
    top = top + 34
    local cols = (kind == "endpoints") and 2 or 1
    local bw = math.floor((W - 18) / 2)
    local rh = math.floor((H - top - BTN_H - 12) / 6)
    for i, ch in ipairs(SURF) do
      local y = top + (i - 1) * rh
      if kind == "center" then
        local o = getOut(ch)
        local cx = (i <= 3) and 6 or (12 + bw)
        local cy = top + ((i - 1) % 3) * (rh * 2)
        button(cx, cy, bw, rh * 2 - 6, "CH" .. (ch + 1) .. " " .. CH_NAME[ch] .. "  " .. string.format("%.1f%%", o.offset / 10),
          function() push("edit", centerSpec(ch)) end)
      elseif kind == "endpoints" then
        local o = getOut(ch)
        button(6, y, bw, rh - 4, "CH" .. (ch + 1) .. " " .. NEG_WORD[ch] .. "  " .. string.format("%.1f%%", o.min / 10),
          function() push("edit", endpointSpec(ch, true)) end, nil, SMLSIZE)
        button(12 + bw, y, bw, rh - 4, "CH" .. (ch + 1) .. " " .. POS_WORD[ch] .. "  " .. string.format("%.1f%%", o.max / 10),
          function() push("edit", endpointSpec(ch, false)) end, nil, SMLSIZE)
      else
        local o = getOut(ch)
        local cx = (i <= 3) and 6 or (12 + bw)
        local cy = top + ((i - 1) % 3) * (rh * 2)
        if o.curve ~= nil then
          button(cx, cy, bw, rh * 2 - 6, "CH" .. (ch + 1) .. " " .. CH_NAME[ch] .. "  CV" .. (o.curve + 1), function()
            push("curve", { idx = o.curve, title = "Servo curve", label = "CH" .. (ch + 1) .. " " .. CH_NAME[ch],
              hint = "Adjust each point so the surface reaches the matching position (e.g. equal up/down angles).",
              ptNames = { "-100% " .. NEG_WORD[ch], "-50%", "neutral", "+50%", "+100% " .. POS_WORD[ch] },
              force = function(x)
                local t = {}
                for _, c in ipairs(SURF) do t[c] = 0 end
                t[ch] = x
                motorLock(t)
              end,
              onClose = function() motorLock() end })
          end)
        else
          button(cx, cy, bw, rh * 2 - 6, "CH" .. (ch + 1) .. " no curve - assign CV" .. (ch + 1), function()
            local oo = getOut(ch)
            oo.curve = ch
            setOut(ch, oo)
          end, "off", SMLSIZE)
        end
      end
    end
    bottomRow({ { "Back", function() home() end },
      { "Done", function()
          if kind == "center" then cfg.d2 = 1 elseif kind == "endpoints" then cfg.d3 = 1 end
          saveCfg() home()
        end, "hot" } })
    drawButtons()
    if event == EV.EXIT then home() return end
    focusNav(event)
    handleButtons(event)
  end,
}

---------------------------------------------------------------------------
-- Live monitor
---------------------------------------------------------------------------
local F5J_STATE = { [0] = "Ready", "Motor run", "Glide - 10 s window", "Window closed" }

local function swPosText(letter)
  for p = 0, 2 do
    local i = physSw(letter, p)
    if i ~= 0 and getSwitchValue(i) then return ({ "up", "mid", "down" })[p + 1] end
  end
  return "?"
end

screens.monitor = {
  run = function(event)
    buttons = {}
    local fm, fmName = getFlightMode()
    header("Live monitor", "FM" .. fm .. " " .. (fmName or ""))
    local y = BAR_H + 4
    local thr = (getValue(fid("thr") or 0) or 0) * 100 / 1024
    local sl = (getValue(fid("ls") or 0) or 0) * 100 / 1024
    text(8, y, string.format("%s motor: %s   %s: %s   %s: %s   ",
      swName(SWMAP.mL), swPosText(SWMAP.mL), swName(SWMAP.m1), swPosText(SWMAP.m1), swName(SWMAP.m2), swPosText(SWMAP.m2)) ..
      (P.slider and string.format("RS power: %d%%", round((getValue(fid("rs") or 0) or 0) * 100 / 1024))
        or string.format("SG power: %s   SH: %s", swPosText("G"), swPosText("H"))), SMLSIZE, C.dim)
    text(8, y + 15, string.format("Throttle (crow): %d%%   Left slider (camber): %d%%   F5J: %s",
      round(thr), round(sl), F5J_STATE[gvGet(9, fm)] or "?"), SMLSIZE, C.dim)
    y = y + 34
    local rh = math.floor((H - y - BTN_H - 10) / 9)
    for ch = 0, AUX do
      local yy = y + ch * rh
      local o = getOut(ch)
      text(8, yy, "CH" .. (ch + 1) .. " " .. (o and o.name or ""), SMLSIZE, C.txt)
      local v = chValue(ch)
      vbar(110, yy + 3, W - 200, rh - 6, v, -100, 100)
      text(W - 8, yy, string.format("%d%%", round(v)), RIGHT + SMLSIZE, C.acc)
    end
    bottomRow({ { "Back", function() home() end } })
    drawButtons()
    if event == EV.EXIT then home() return end
    handleButtons(event)
  end,
}

---------------------------------------------------------------------------
-- Tuning screen definitions
---------------------------------------------------------------------------
local function physCamber(ch)
  return function(v)
    if v == 0 then return "neutral" end
    return "TE " .. string.lower((v > 0) and POS_WORD[ch] or NEG_WORD[ch])
  end
end

local function tuneCamber()
  openList({ title = "Camber per flight mode",
    intro = "Camber offsets per flight mode (GV2-GV5). Linked modes follow as in your setup. 'L+R together' moves the pair equally.",
    extraBtn = function()
      return { cfg.pair == 1 and "L+R together: on" or "L+R together: off",
        function() cfg.pair = 1 - cfg.pair saveCfg() end, nil, SMLSIZE }
    end,
    items = {
      gvItem(2, "Aileron L camber (GV2 cal)", "CH3: + = trailing edge DOWN.", -100, 100,
        { title = "Camber", phys = physCamber(AIL_L), pair = { 3, -1 } }),
      gvItem(3, "Aileron R camber (GV3 car)", "CH4: + = trailing edge UP.", -100, 100,
        { title = "Camber", phys = physCamber(AIL_R), pair = { 2, -1 } }),
      gvItem(4, "Flap L camber (GV4 cfl)", "CH7: + = trailing edge UP.", -100, 100,
        { title = "Camber", phys = physCamber(FLP_L), pair = { 5, 1 } }),
      gvItem(5, "Flap R camber (GV5 cfr)", "CH8: + = trailing edge UP.", -100, 100,
        { title = "Camber", phys = physCamber(FLP_R), pair = { 4, 1 } }),
    } })
end

-- V-tail: change a field on the same line of both tail channels
local function bothSpec(name, field, label, hint, lo, hi, sign)
  local s = mixSpec(ELE, name, field, label, hint, lo, hi, { title = "V-tail" })
  local set1 = s.set
  local r = mixSpec(RUD, name, field, label, hint, lo, hi)
  s.set = function(fm, v) set1(fm, v) r.set(fm, v * (sign or 1)) end
  return s
end

local function swapRudder()
  for _, ch in ipairs({ ELE, RUD }) do
    for _, n in ipairs({ "Rudder", "Ai2Ru" }) do
      local l, m = findMix(ch, n)
      if l then
        local t = copyMix(m)
        t.weight = -t.weight
        rewriteMix(ch, l, t)
      end
    end
  end
end

local function tailItems()
  if not VT then return {} end
  return {
    mixItem(ELE, "Elev", "weight", "Elevator rate V-tail L (CH1)", "Elevator part of the left ruddervator.", 0, 100, { title = "V-tail" }),
    mixItem(RUD, "Elev", "weight", "Elevator rate V-tail R (CH2)", "Elevator part of the right ruddervator.", 0, 100, { title = "V-tail" }),
    mixItem(ELE, "Rudder", "weight", "Rudder rate V-tail L (CH1)", "Rudder part, left (- = up with right rudder).", -100, 100, { title = "V-tail" }),
    mixItem(RUD, "Rudder", "weight", "Rudder rate V-tail R (CH2)", "Rudder part, right (+ = down with right rudder).", -100, 100, { title = "V-tail" }),
    { label = "Elevator differential (both)", value = function() local _, m = findMix(ELE, "Elev") return m and (m.curveValue .. "%") or "" end,
      open = function() push("edit", bothSpec("Elev", "curveValue", "Elevator differential", "Same on both ruddervators. + = less UP travel, - = less DOWN travel.", -100, 100)) end },
    { label = "Rudder differential (both)", value = function() local _, m = findMix(ELE, "Rudder") return m and (m.curveValue .. "%") or "" end,
      open = function() push("edit", bothSpec("Rudder", "curveValue", "Rudder differential", "Same on both ruddervators. + = the surface moving UP moves less.", -100, 100)) end },
    { label = "Swap rudder direction", value = function() return "tap" end,
      open = function() swapRudder() end },
  }
end

local function tuneRoll()
  local items = {}
  for _, it in ipairs(tailItems()) do items[#items + 1] = it end
  for _, it in ipairs({
    gvItem(1, "Aileron differential (GV1 dif)", "Less DOWN travel on both ailerons. 0 = none.", 0, 100, { title = "Roll" }),
    mixItem(AIL_L, "Ailer", "weight", "Aileron L rate (CH3 Ailer)", "Roll travel of the left aileron.", 0, 150, { title = "Roll" }),
    mixItem(AIL_R, "Ailer", "weight", "Aileron R rate (CH4 Ailer)", "Roll travel of the right aileron.", 0, 150, { title = "Roll" }),
    gvItem(6, "Aileron -> rudder (GV6 a2r)", "Rudder follows aileron (coordinated turns).", -100, 100, { title = "Roll" }),
    mixItem(FLP_L, "Flap", "weight", "Aileron -> flap L (CH7 Flap)", "0 = off. Shaped by curve fpL (End line).", -100, 100, { title = "Roll" }),
    mixItem(FLP_R, "Flap", "weight", "Aileron -> flap R (CH8 Flap)", "0 = off. Shaped by curve fpR (End line).", -100, 100, { title = "Roll" }),
    curveItem(9, "Aileron -> flap L shape", "Multiplies the flap roll input (End line, MUL). Default: flap moves only DOWN.", { title = "Roll" }),
    curveItem(10, "Aileron -> flap R shape", "Multiplies the flap roll input (End line, MUL).", { title = "Roll" }),
    inputItem(0, "weight", "Aileron stick rate (I1)", "Input weight of the aileron stick.", 0, 100),
    inputItem(0, "curveValue", "Aileron expo (I1)", "Expo of the aileron stick.", -100, 100),
    inputItem(1, "weight", "Elevator stick rate (I2)", "Input weight of the elevator stick.", 0, 100),
    inputItem(1, "curveValue", "Elevator expo (I2)", "Expo of the elevator stick.", -100, 100),
    inputItem(3, "weight", "Rudder stick rate (I4)", "Input weight of the rudder stick.", 0, 100),
    inputItem(3, "curveValue", "Rudder expo (I4)", "Expo of the rudder stick.", -100, 100),
  }) do items[#items + 1] = it end
  openList({ title = "Roll & rudder", items = items })
end

local function landingThreshold()
  if SWMAP.lL then
    return { label = "LANDING switch (L2)", value = function() return swName(SWMAP.lL) .. " " .. posWord(SWMAP.lP) end,
      open = function() push("swsel") end }
  end
  return {
    label = "LANDING starts below throttle (L2)",
    value = function() local l = model.getLogicalSwitch(1) return l and (l.v2 .. "%") or "" end,
    open = function()
      push("edit", { title = "Crow / landing", label = "LANDING starts below throttle", unit = "%",
        hint = "L2: throttle stick < this value activates FM2 LANDING (crow).", min = 0, max = 100, step = 1, big = 5,
        get = function() local l = model.getLogicalSwitch(1) return l and l.v2 or 0 end,
        set = function(_, v)
          local l = model.getLogicalSwitch(1)
          if not l then return end
          if edLog and not edLog.misc.l2 then
            local o = l.v2
            edLog.misc.l2 = true
            edLog.misc[#edLog.misc + 1] = function() local x = model.getLogicalSwitch(1) x.v2 = o model.setLogicalSwitch(1, x) end
          end
          l.v2 = v
          model.setLogicalSwitch(1, l)
        end })
    end,
  }
end

local function crowLive()
  return (getValue(fid("input3") or 0) or 0) * 100 / 1024
end

local function tuneCrow()
  openList({ title = "Crow / landing", intro = "Active in FM2 LANDING only. Throttle stick down = more crow.", items = {
    landingThreshold(),
    mixItem(AIL_L, "Brake", "weight", "Aileron L up (CH3 Brake)", "Weight of crow on the left aileron (- = up).", -200, 200, { title = "Crow" }),
    mixItem(AIL_R, "Brake", "weight", "Aileron R up (CH4 Brake)", "Weight of crow on the right aileron (+ = up).", -200, 200, { title = "Crow" }),
    mixItem(FLP_L, "Brake", "weight", "Flap L down (CH7 Brake)", "Weight of crow on the left flap (- = down).", -250, 250, { title = "Crow" }),
    mixItem(FLP_R, "Brake", "weight", "Flap R down (CH8 Brake)", "Weight of crow on the right flap (- = down).", -250, 250, { title = "Crow" }),
    VT and { label = "Elevator compensation (CH1+CH2 Brake)", value = function() local _, m = findMix(ELE, "Brake") return m and (m.weight .. "%") or "" end,
      open = function() push("edit", bothSpec("Brake", "weight", "Elevator compensation", "Elevator with crow on both ruddervators, curve b2e.", -100, 100)) end }
    or mixItem(ELE, "Brake", "weight", "Elevator compensation (CH1 Brake)", "Elevator with crow, shaped by curve b2e.", -100, 100, { title = "Crow" }),
    curveItem(12, "Aileron L crow curve (baL)", "Crow input -> left aileron.", { title = "Crow", live = crowLive }),
    curveItem(13, "Aileron R crow curve (baR)", "Crow input -> right aileron.", { title = "Crow", live = crowLive }),
    curveItem(14, "Flap L crow curve (bfL)", "Crow input -> left flap.", { title = "Crow", live = crowLive }),
    curveItem(15, "Flap R crow curve (bfR)", "Crow input -> right flap.", { title = "Crow", live = crowLive }),
    curveItem(17, "Elevator crow curve (b2e)", "Crow input -> elevator compensation.", { title = "Crow", live = crowLive }),
    inputItem(2, "weight", "Crow input scale (I3 Brk)", "Throttle stick -> crow input. Weight.", 0, 100),
    inputItem(2, "offset", "Crow input offset (I3 Brk)", "Throttle stick -> crow input. Offset.", -100, 100),
  } })
end

local SNAP_ROWS = {
  { ch = AIL_L, name = "SnpFlp", label = "CH3 Ail L" },
  { ch = AIL_R, name = "SnpFlp", label = "CH4 Ail R" },
  { ch = FLP_L, name = "SnpFlp", label = "CH7 Flap L" },
  { ch = FLP_R, name = "SnpFlp", label = "CH8 Flap R" },
}

local SNAP_OFF = { [1] = true, [2] = true }     -- not active in MOTOR ON and LANDING

local function tuneSnap()
  openList({ title = "Snapflap per flight mode", intro = "Ailerons and flaps go DOWN with up elevator. Own value in every flight mode (0 = off). Off in MOTOR ON and LANDING.", items = {
    gvItem(7, "Ailerons (GV7 snA)", "Aileron snapflap in this flight mode: % aileron DOWN at full up elevator. Same on left and right.", 0, 60,
      { title = "Snapflap", inactive = SNAP_OFF }),
    gvItem(8, "Flaps (GV8 snF)", "Flap snapflap in this flight mode: % flap DOWN at full up elevator. Same on left and right.", 0, 60,
      { title = "Snapflap", inactive = SNAP_OFF }),
    { label = "Active flight modes (advanced)", value = function() return "open" end,
      open = function() push("matrix", { title = "Snapflap - flight modes", rows = SNAP_ROWS,
        hint = "Tap to switch a line on/off per flight mode. Left and right should normally match.",
        copyFrom = { ch = FLP_L, name = "SnpFlp" }, copyLabel = "All = Flap L" }) end },
  } })
end

local function sliderLive()
  return (getValue(fid("input5") or 0) or 0) * 100 / 1024
end

local function tuneSlider()
  openList({ title = "Camber slider (THERMAL V)", intro = "FM5 THERMAL V: left slider SL1 sets camber continuously.", items = {
    inputItem(4, "weight", "Slider input scale (I5 Cmb)", "Left slider -> camber input. Weight.", 0, 100),
    inputItem(4, "offset", "Slider input offset (I5 Cmb)", "Left slider -> camber input. Offset.", -100, 100),
    mixItem(AIL_L, "CmbVar", "weight", "Aileron L weight (CH3)", "Camber per slider travel. CH3 + = down.", -100, 100, { title = "Camber slider" }),
    mixItem(AIL_L, "CmbVar", "offset", "Aileron L offset (CH3)", "Camber at slider input 0.", -100, 100, { title = "Camber slider" }),
    mixItem(AIL_R, "CmbVar", "weight", "Aileron R weight (CH4)", "CH4 + = up.", -100, 100, { title = "Camber slider" }),
    mixItem(AIL_R, "CmbVar", "offset", "Aileron R offset (CH4)", "Camber at slider input 0.", -100, 100, { title = "Camber slider" }),
    mixItem(FLP_L, "CmbVar", "weight", "Flap L weight (CH7)", "CH7 + = up.", -100, 100, { title = "Camber slider" }),
    mixItem(FLP_L, "CmbVar", "offset", "Flap L offset (CH7)", "Camber at slider input 0.", -100, 100, { title = "Camber slider" }),
    mixItem(FLP_R, "CmbVar", "weight", "Flap R weight (CH8)", "CH8 + = up.", -100, 100, { title = "Camber slider" }),
    mixItem(FLP_R, "CmbVar", "offset", "Flap R offset (CH8)", "Camber at slider input 0.", -100, 100, { title = "Camber slider" }),
    VT and { label = "Elevator compensation (CH1+CH2)", value = function() local _, m = findMix(ELE, "CmbVar") return m and (m.weight .. "%") or "" end,
      open = function() push("edit", bothSpec("CmbVar", "weight", "Elevator compensation", "Elevator with slider camber on both ruddervators, curve c2e.", -100, 100)) end }
    or mixItem(ELE, "CmbVar", "weight", "Elevator compensation (CH1)", "Elevator with slider camber, curve c2e.", -100, 100, { title = "Camber slider" }),
    curveItem(18, "Elevator slider curve (c2e)", "Slider input -> elevator compensation.", { title = "Camber slider", live = sliderLive }),
  } })
end

local function tuneMotor()
  openList({ title = "Motor", intro = "Motor ON = " .. motorText() .. " (FM1). " ..
    (P.slider and "Power = right slider RS (bottom = off)." or "Power by SG position, hold SH = full power (Turbo)."), items = {
    P.slider and curveItem(11, "Throttle curve RS (thr)", "Point 1 = RS bottom, 2 = RS middle, 3 = RS top. Output -100 = off, +100 = full.",
      { title = "Motor", ptNames = { "RS bottom", "RS mid", "RS top" },
        yfmt = function(y) return "= " .. round((y + 100) / 2) .. "% power" end })
    or curveItem(11, "Power per SG position (curve mot)", "Point 1 = SG up, 2 = SG mid, 3 = SG down. Output -100 = off, +100 = full.",
      { title = "Motor", ptNames = { "SG up", "SG mid", "SG down" },
        yfmt = function(y) return "= " .. round((y + 100) / 2) .. "% power" end }),
    mixItem(MOT, "Off", "weight", "Motor OFF level (CH6 Off)", "Output when the motor is off: -weight %. Must be below the ESC start point.", 80, 100,
      { title = "Motor" }),
    VT and { label = "Motor -> elevator (CH1+CH2)", value = function() local _, m = findMix(ELE, "Motor") return m and (m.weight .. "%") or "" end,
      open = function() push("edit", bothSpec("Motor", "weight", "Motor -> elevator", "Elevator with motor power on both ruddervators, curve m2e.", -100, 100)) end }
    or mixItem(ELE, "Motor", "weight", "Motor -> elevator (CH1)", "Elevator with motor power, shaped by curve m2e.", -100, 100, { title = "Motor" }),
    curveItem(16, "Motor -> elevator curve (m2e)", "Motor output -> elevator compensation.", { title = "Motor" }),
    mixItem(AIL_L, "MotCmb", "weight", "Motor -> aileron L (CH3)", "Camber with motor power, curve m2c.", -250, 250, { title = "Motor" }),
    mixItem(AIL_R, "MotCmb", "weight", "Motor -> aileron R (CH4)", "Camber with motor power, curve m2c.", -250, 250, { title = "Motor" }),
    mixItem(FLP_L, "MotCmb", "weight", "Motor -> flap L (CH7)", "Camber with motor power, curve m2c.", -250, 250, { title = "Motor" }),
    mixItem(FLP_R, "MotCmb", "weight", "Motor -> flap R (CH8)", "Camber with motor power, curve m2c.", -250, 250, { title = "Motor" }),
    curveItem(19, "Motor -> camber curve (m2c)", "Motor output -> camber of ailerons and flaps.", { title = "Motor" }),
    { label = "ESC calibration", value = function() return "open" end, open = function() push("esc") end },
  } })
end

-- F5J timer & calls ---------------------------------------------------------
local function lsField(idxs, field, label, hint, lo, hi, fmt)
  if type(idxs) == "number" then idxs = { idxs } end
  local i = idxs[1]
  return {
    label = label,
    value = function() local l = model.getLogicalSwitch(i) return l and fmt(l[field]) or "" end,
    open = function()
      push("edit", { title = "F5J timer & calls", label = label, hint = hint, min = lo, max = hi, step = 1, big = 10,
        fmt = fmt,
        get = function() local l = model.getLogicalSwitch(i) return l and l[field] or 0 end,
        set = function(_, v)
          for _, k in ipairs(idxs) do
            local l = model.getLogicalSwitch(k)
            if l then
              if edLog and not edLog.misc["ls" .. k] then
                local o = l[field]
                edLog.misc["ls" .. k] = true
                edLog.misc[#edLog.misc + 1] = function() local x = model.getLogicalSwitch(k) x[field] = o model.setLogicalSwitch(k, x) end
              end
              l[field] = v
              model.setLogicalSwitch(k, l)
            end
          end
        end })
    end,
  }
end

local function timerStart(i, label, hint, lo, hi)
  local fmt = function(v) return string.format("%d:%02d", math.floor(v / 60), v % 60) end
  return {
    label = label,
    value = function() local t = model.getTimer(i) return t and fmt(t.start) or "" end,
    open = function()
      push("edit", { title = "F5J timer & calls", label = label, hint = hint, min = lo, max = hi, step = 1, big = 10, fmt = fmt,
        get = function() local t = model.getTimer(i) return t and t.start or 0 end,
        set = function(_, v)
          local t = model.getTimer(i)
          if edLog and not edLog.misc["t" .. i] then
            local o = t.start
            edLog.misc["t" .. i] = true
            edLog.misc[#edLog.misc + 1] = function() model.setTimer(i, { start = o }) end
          end
          model.setTimer(i, { start = v })
        end })
    end,
  }
end

local function sfToggle(i, label)
  return {
    label = label,
    value = function() local s = model.getCustomFunction(i) return (s and s.active == 1) and "on" or "off" end,
    open = function()
      local s = model.getCustomFunction(i)
      if not s or s.func == 0 then return end
      s.active = (s.active == 1) and 0 or 1
      model.setCustomFunction(i, s)
    end,
  }
end

local function sfValue(i, label, hint, lo, hi)
  return {
    label = label,
    value = function() local s = model.getCustomFunction(i) return s and (tostring(s.value) .. " s") or "" end,
    open = function()
      push("edit", { title = "F5J timer & calls", label = label, hint = hint, min = lo, max = hi, step = 1, big = 5, unit = " s",
        get = function() local s = model.getCustomFunction(i) return s and s.value or 0 end,
        set = function(_, v)
          local s = model.getCustomFunction(i)
          if edLog and not edLog.misc["sf" .. i] then
            local o = s.value
            edLog.misc["sf" .. i] = true
            edLog.misc[#edLog.misc + 1] = function() local x = model.getCustomFunction(i) x.value = o model.setCustomFunction(i, x) end
          end
          s.value = v
          model.setCustomFunction(i, s)
        end })
    end,
  }
end

screens.f5j = {
  run = function(event)
    buttons = {}
    local fm = getFlightMode()
    header("F5J timer & calls", "state: " .. (F5J_STATE[gvGet(9, fm)] or "?"))
    local y = BAR_H + 4
    local lines = {
      motorText() .. " = motor ON (FM1). Timer 1 counts the 30 s motor run.",
      "Motor off (or 30 s): call 'engoff', Timer 1 is set to 10 s (height window).",
      "Window over: call 'off'. Motor on again within 3 s: beep / 'fm-pwr' warning.",
      swName(SWMAP.mL) .. " " .. posWord(2 - SWMAP.mP) .. " resets. Timer 2 = 10 min flight (starts at first motor run).",
      "SI press: Timer 2; hold SI 1 s: link quality. SC down: RX voltage.",
      P.slider and "Radio: SF = 2-position switch (SYS > Hardware). Motor power: right slider RS."
        or "Radio: SF = 2-position switch, SH = momentary (SYS > Hardware).",
    }
    for _, s in ipairs(lines) do text(8, y, s, SMLSIZE, C.dim) y = y + 15 end
    local t1, t2 = model.getTimer(0), model.getTimer(1)
    text(8, y + 4, string.format("Timer 1: %s   Timer 2: %s", t1 and t1.value or "?", t2 and t2.value or "?"), 0, C.acc)
    bottomRow({ { "Back", function() home() end }, { "Settings", function()
      openList({ title = "F5J timer & calls", items = {
        timerStart(0, "Motor run time (Timer 1)", "F5J motor run. Countdown starts with the motor.", 5, 120),
        sfValue(25, "Height window (SF26)", "Timer 1 is set to this when the motor stops.", 1, 60),
        timerStart(1, "Flight time (Timer 2)", "Working time countdown, starts at first motor run.", 60, 1200),
        lsField({ 28, 29 }, "delay", "Restart warning delay (L29/L30)", "Motor on again for this long gives a warning.", 0, 100,
          function(v) return string.format("%.1f s", v / 10) end),
        lsField(12, "v2", "Low RX voltage (L13)", "RxBt below this triggers 'lowbat' (if on).", 30, 130,
          function(v) return string.format("%.1f V", v / 10) end),
        sfToggle(39, "Low RX voltage call (SF40)"),
        sfToggle(31, "Call Timer 1 at 15 s (SF32)"),
      } })
    end, "hot" } })
    drawButtons()
    if event == EV.EXIT then home() return end
    focusNav(event)
    handleButtons(event)
  end,
}

---------------------------------------------------------------------------
-- ESC calibration (full throttle only while SH is down)
---------------------------------------------------------------------------
local escStage = 0
screens.esc = {
  enter = function() escStage = 0 motorLock() end,
  run = function(event)
    buttons = {}
    header("ESC calibration", "CH6")
    local sh = physSw("H", 2)
    if escStage == 0 then
      motorLock()
      text(8, BAR_H + 10, "REMOVE THE PROPELLER!", DBLSIZE, C.warn)
      wrap(8, BAR_H + 60, W - 16, "Disconnect the flight battery. Continue only with the propeller off.", 0, C.txt, 20)
      bottomRow({ { "Cancel", function() motorLock() back() end }, { "Propeller removed", function() escStage = 1 end, "warn" } })
    elseif escStage == 1 then
      local full
      if P.slider then
        calSet({ [MOT] = { { w = 100, src = "rs" } } })
        full = (getValue(fid("rs") or 0) or 0) > 1000
        text(8, BAR_H + 10, string.format("Throttle output: %d%%", round((getValue(fid("rs") or 0) or 0) * 100 / 1024)), MIDSIZE,
          full and C.warn or C.ok)
        wrap(8, BAR_H + 44, W - 16, "The motor follows RS directly.  1. RS to the top = full throttle.  2. Connect the battery, wait for the full-throttle beeps.  3. RS to the bottom = off, wait for the confirmation beeps.  Then Next.", 0, C.txt, 20)
      else
        calSet({ [MOT] = { { w = -100 }, { w = 100, sw = sh } } })
        full = getSwitchValue(sh)
        text(8, BAR_H + 10, full and "Throttle output: FULL" or "Throttle output: OFF", MIDSIZE, full and C.warn or C.ok)
        wrap(8, BAR_H + 44, W - 16, "1. Hold SH = full throttle.  2. Keep holding, connect the battery, wait for the full-throttle beeps.  3. Release SH = off, wait for the confirmation beeps.  Then Next.", 0, C.txt, 20)
      end
      bottomRow({ { "Abort (motor off)", function() motorLock() back() end, "warn" }, { "Next", function() escStage = 2 end, "hot" } })
    else
      motorLock()
      text(8, BAR_H + 10, "Throttle output: OFF", MIDSIZE, C.ok)
      wrap(8, BAR_H + 44, W - 16, "Done. Disconnect the battery before fitting the propeller.", 0, C.txt, 20)
      bottomRow({ { "Done", function() back() end, "go" } })
    end
    drawButtons()
    if event == EV.EXIT then motorLock() back() return end
    focusNav(event)
    handleButtons(event)
  end,
}

---------------------------------------------------------------------------
-- Model check
---------------------------------------------------------------------------
local function mixMask(ch, name) local _, m = findMix(ch, name) return m and m.flightModes end
local function mixW(ch, name) local _, m = findMix(ch, name) return m and m.weight end

local function fmListText(mask)
  if not mask then return "?" end
  local t = {}
  for fm = 0, NFM - 1 do if fmActive(mask, fm) then t[#t + 1] = FM_SHORT[fm] end end
  return (#t > 0) and table.concat(t, " ") or "none"
end

local function checks()
  local out = {}
  local function add(sev, short, title, detail, fixes)
    out[#out + 1] = { sev = sev, short = short, title = title, detail = detail, fixes = fixes or {} }
  end

  if A and A.state == "done" and #A.none > 0 then
    local t = {}
    for _, m in ipairs(A.none) do t[#t + 1] = "CH" .. (m.ch + 1) .. " " .. m.name end
    add("FIX", "'---' mix lines", "Mix lines with source '---'",
      table.concat(t, ", ") .. ": no effect in flight, but they hide later mix lines from Lua. Model > Mixes: set Source = MAX, Weight = 0 (or delete them), then restart this tool.")
  end
  if status.old then
    add("FIX", "Old programming", "Older version of the programming",
      "This model has the earlier programming (e.g. fixed snapflap weights). Run Install / repair: your tuned values are kept and the 3PK changes are applied.")
  end
  if not status.ready then return out end

  -- snapflap symmetry
  local a, b, c, d = mixMask(AIL_L, "SnpFlp"), mixMask(AIL_R, "SnpFlp"), mixMask(FLP_L, "SnpFlp"), mixMask(FLP_R, "SnpFlp")
  if a ~= b or a ~= c or c ~= d then
    add("CHECK", "Snapflap modes", "Snapflap flight modes differ",
      "Ail L: " .. fmListText(a) .. " | Ail R: " .. fmListText(b) .. " | Flaps: " .. fmListText(c) ..
      ". Different left/right modes give a roll input with elevator.",
      { { "All = Flap L", function()
          for _, r in ipairs(SNAP_ROWS) do setMixFields(r.ch, r.name, { flightModes = c }) end
        end },
        { "Open matrix", function() push("matrix", { title = "Snapflap - flight modes", rows = SNAP_ROWS,
          hint = "Tap to switch a line on/off per flight mode.", copyFrom = { ch = FLP_L, name = "SnpFlp" }, copyLabel = "All = Flap L" }) end } })
  end
  -- V-tail: elevator + rudder share the servo
  if VT then
    for _, ch in ipairs({ ELE, RUD }) do
      local e, r = mixW(ch, "Elev"), mixW(ch, "Rudder")
      if e and r and not gvOfNum(e) and not gvOfNum(r) and math.abs(e) + math.abs(r) > 100 then
        add("INFO", "V-tail clipping", "Elevator + rudder above 100%",
          "CH" .. (ch + 1) .. ": elevator " .. math.abs(e) .. "% + rudder " .. math.abs(r) ..
          "% = " .. (math.abs(e) + math.abs(r)) .. "%. Full elevator with full rudder is clipped at the endpoint.")
      end
    end
  end
  -- aileron -> flap masks
  local fl, fr = mixMask(FLP_L, "Flap"), mixMask(FLP_R, "Flap")
  if fl ~= fr then
    add("INFO", "Ail->flap modes", "Aileron -> flap: flight modes differ",
      "Flap L: " .. fmListText(fl) .. " | Flap R: " .. fmListText(fr) .. ". No effect while the weights are 0.",
      { { "R = L", function() setMixFields(FLP_R, "Flap", { flightModes = fl }) end } })
  end
  -- aileron trim
  local _, ml = findMix(AIL_L, "Ailer")
  local _, mr = findMix(AIL_R, "Ailer")
  if ml and mr and ml.carryTrim and mr.carryTrim then
    add("INFO", "Aileron trim off", "Aileron trim does not move the ailerons",
      "The 'Ailer' lines on CH3/CH4 have Trim off, so the aileron trim switch has no effect on the ailerons.",
      { { "Enable aileron trim", function()
          setMixFields(AIL_L, "Ailer", { carryTrim = false }) setMixFields(AIL_R, "Ailer", { carryTrim = false })
        end } })
  end
  -- THERMAL V camber source
  if A and A.gvRaw and A.gvRaw[2] and rawOwner(2, 5) ~= rawOwner(3, 5) then
    add("CHECK", "THV camber source", "THERMAL V: left/right aileron camber from different modes",
      "GV2 (Ail L) follows " .. FM_SHORT[rawOwner(2, 5)] .. ", GV3 (Ail R) follows " .. FM_SHORT[rawOwner(3, 5)] ..
      ". With the slider centered the ailerons may not be symmetric - check with a throw meter (Live monitor).")
  end
  -- duplicate low voltage call (older programming)
  local s40, s41 = model.getCustomFunction(39), model.getCustomFunction(40)
  if s40 and s41 and s40.func == CFF.PLAY_TRACK and s41.func == CFF.PLAY_TRACK then
    add("INFO", "SF41 duplicate", "Low RX voltage call twice",
      "SF41 repeats the 'lowbat' call of SF40. Switch the call on/off in F5J timer & calls (SF40).",
      { { "Remove SF41", function() model.setCustomFunction(40, { switch = 0, func = 0 }) end } })
  end
  -- F5J state GV9 must be one value for all flight modes
  if A and A.gvRaw and A.gvRaw[9] then
    local split = false
    for fm = 1, NFM - 1 do if rawOwner(9, fm) ~= 0 then split = true end end
    if split then
      add("FIX", "GV9 not shared", "F5J state (GV9) differs per flight mode",
        "GV9 'Tmr' must follow CRUISE in every flight mode, else the F5J calls and timers fail after a mode change. " ..
        "Model > Global variables > GV9: set FM1-FM6 to 'FM0'. Lua cannot set this.")
    end
  end
  -- pre-start checks (read from the model file)
  if A and A.state == "done" then
    local want = SWMAP.mL
    local wantPos = posWord(2 - SWMAP.mP)
    local bad = {}
    for l, p in pairs(A.swWarn) do
      if l ~= want then bad[#bad + 1] = swName(l) .. " " .. p end
    end
    local motorOk = (A.swWarn[want] == wantPos)
    if not motorOk or #bad > 0 or not A.thrWarnOff then
      local d = "Wanted: only " .. swName(want) .. " " .. wantPos .. " (motor OFF), throttle warning off. Found:"
      if not motorOk then d = d .. " " .. swName(want) .. " " .. (A.swWarn[want] or "not checked") .. "." end
      if #bad > 0 then d = d .. " Also checked: " .. table.concat(bad, ", ") .. "." end
      if not A.thrWarnOff then d = d .. " Throttle warning on (the throttle stick is crow)." end
      add("CHECK", "Pre-start checks", "Start-up warnings",
        d .. " Set in Model Setup > Pre-start Checks (Lua cannot change it). Values read when this tool started.")
    end
  end
  if cfg.fs ~= 1 then
    add("CHECK", "Failsafe", "Failsafe values not set",
      "Safe state: sticks neutral, CRUISE, no LANDING, motor OFF. Capture the values and set them in the receiver / module.",
      { { "Open Failsafe", function() push("fs") end } })
  end
  local s32 = model.getCustomFunction(31)
  if s32 and s32.func == CFF.PLAY_VALUE and s32.active ~= 1 then
    add("INFO", "15 s call off", "Timer 1 call at 15 s is OFF", "SF32 (Timer 1 = 15 s) is disabled.",
      { { "Enable SF32", function() s32.active = 1 model.setCustomFunction(31, s32) end } })
  end
  local s37 = model.getCustomFunction(36)
  if s37 and s37.func == CFF.PLAY_VALUE and (s37.value or 0) == 0 then
    add("INFO", "SI short: silent", "Short SI press plays nothing", "SF37 (L9, short press of SI) has no value to play.",
      { { "Play Timer 1", function() s37.value = fid("timer1") model.setCustomFunction(36, s37) end } })
  end
  if not sensorSource("RxBt") or not sensorSource("RQly") then
    add("INFO", "Sensors missing", "Telemetry sensors missing", "RxBt / RQly not found. Discover sensors (receiver on), then run Install / Repair again.")
  end
  local o3, o4 = getOut(AIL_L), getOut(AIL_R)
  if o3 and o4 and o3.curve == nil and o4.curve == nil then
    add("INFO", "Ail servo curves", "Aileron servos have no servo curve", "CV3/CV4 exist but are not assigned to CH3/CH4. Assign them in Servo curves if needed.")
  end
  return out
end

local CK = { list = nil, sel = 1 }
screens.check = {
  enter = function() CK.list = checks() CK.sel = 1 end,
  resume = function() CK.list = checks() end,
  run = function(event)
    buttons = {}
    header("Model check", #CK.list .. " finding" .. ((#CK.list == 1) and "" or "s"))
    local top = BAR_H + 4
    if #CK.list == 0 then
      text(8, top + 10, "No findings.", MIDSIZE, C.ok)
    else
      local lw = 170
      local rh = math.min(30, math.floor((H - top - BTN_H - 10) / #CK.list))
      for i, f in ipairs(CK.list) do
        button(4, top + (i - 1) * rh, lw, rh - 3, "", function() CK.sel = i end, "ghost")
      end
      local f = CK.list[CK.sel] or CK.list[1]
      local px = lw + 12
      local sevTxt = ({ FIX = "Fix needed", CHECK = "Please check", INFO = "Info" })[f.sev]
      text(px, top, sevTxt, SMLSIZE, (f.sev == "FIX") and C.warn or ((f.sev == "CHECK") and C.acc or C.dim))
      local y = wrap(px, top + 15, W - px - 6, f.title, 0, C.txt, 18)
      y = wrap(px, y + 2, W - px - 6, f.detail, SMLSIZE, C.txt, 14)
      for j, fx in ipairs(f.fixes) do
        button(px, y + 6 + (j - 1) * 38, W - px - 8, 34, fx[1], function()
          fx[2]()
          CK.list = checks()
          if CK.sel > #CK.list then CK.sel = 1 end
        end, "hot")
      end
    end
    bottomRow({ { "Back", function() home() end } })
    drawButtons()
    for i, f in ipairs(CK.list) do
      local rh = math.min(30, math.floor((H - top - BTN_H - 10) / #CK.list))
      local y = top + (i - 1) * rh
      if i == CK.sel then rect(4, y, 170, rh - 3, C.panel) end
      local col = (f.sev == "FIX") and C.warn or ((f.sev == "CHECK") and C.acc or C.dim)
      rect(6, y + 2, 4, rh - 7, col)
      text(16, y + 4, f.short, SMLSIZE, (i == CK.sel) and C.acc or C.txt)
    end
    if event == EV.EXIT then home() return end
    focusNav(event)
    handleButtons(event)
  end,
}

---------------------------------------------------------------------------
-- Install / repair screen
---------------------------------------------------------------------------
screens.install = {
  enter = function() inst.result = nil end,
  run = function(event)
    buttons = {}
    header("Install / repair", A and A.modelName or "")
    local y = BAR_H + 6
    if inst.result then
      local ok, log, warn = inst.result[1], inst.result[2], inst.result[3]
      text(8, y, ok and "Programming written." or "Install failed", MIDSIZE, ok and C.ok or C.warn)
      y = y + 30
      for _, l in ipairs(log) do y = wrap(8, y, W - 16, (ok and "- " or "") .. l, SMLSIZE, C.txt, 14) end
      for _, w in ipairs(warn) do y = wrap(8, y, W - 16, "! " .. w, SMLSIZE, C.warn, 14) end
      if ok then wrap(8, y + 4, W - 16, (inst.first and "Next: check the switches, then Failsafe, " or "Next: Failsafe, then ") .. "Servo direction, Center, Endpoints. Set camber, snapflap and aileron-rudder per flight mode, then check all flight modes on the bench.", SMLSIZE, C.dim, 14) end
      if ok and inst.first then
        bottomRow({ { "Menu", function() home() end }, { "Next: Switches", function() go("info", 1) end, "hot" } })
      elseif ok and cfg.fs ~= 1 then
        bottomRow({ { "Menu", function() home() end }, { "Next: Failsafe", function() home() push("fs") end, "hot" } })
      else
        bottomRow({ { "Menu", function() home() end, "hot" } })
      end
    else
      local fileOk = A and A.state == "done"
      local lines = {}
      lines[#lines + 1] = "Model file: " .. (fileOk and "read" or ("not read (" .. tostring(A and A.err) .. ")"))
      if fileOk then
        lines[#lines + 1] = "Your programming found: " .. A.match .. " of " .. #P.mixes .. " mix lines"
        if #A.extra > 0 then lines[#lines + 1] = #A.extra .. " other mix lines will be removed" end
      end
      local blocked = fileOk and #A.none > 0
      if not fileOk then lines[#lines + 1] = "Make sure no mix line has source '---' before installing." end
      if inst.first then
        text(8, y, "No programming on this model yet: install it first.", 0, C.acc)
        y = y + 22
      end
      for _, l in ipairs(lines) do text(8, y, l, SMLSIZE, C.txt) y = y + 15 end
      if blocked then
        y = wrap(8, y + 4, W - 16, "This model has " .. #A.none .. " mix line(s) with source '---'. EdgeTX ignores them in flight, but they hide all later mix lines from Lua tools, so nothing can be written safely. In Model > Mixes set their Source to MAX and Weight to 0 (keeps them inert), then restart this tool. See Model check.", SMLSIZE, C.warn, 14)
        bottomRow({ { "Back", function() home() end }, { "Model check", function() push("check") end } })
      else
        y = wrap(8, y + 4, W - 16, "Writes inputs, mixes, curves CV1-CV20, flight modes FM0-FM6, GV names, L1-L32, SF1-SF41 and timers. Values already in this model are kept where the line exists. Servo direction, subtrim and endpoints are not changed. Back up the model first (Model > Copy).", SMLSIZE, C.dim, 14)
        inst.gvFound = fileOk and A.structure
        local bw = math.floor((W - 18) / 2)
        y = y + 6
        button(6, y, bw, 32, (inst.keepGV and inst.gvFound) and "GV values: keep" or "GV values: 3PK",
          function() inst.keepGV = not inst.keepGV end, inst.gvFound and nil or "off", SMLSIZE)
        button(12 + bw, y, bw, 32, inst.lllTrims and "FM trims: 3PK" or "FM trims: keep",
          function() inst.lllTrims = not inst.lllTrims end, nil, SMLSIZE)
        bottomRow({ { "Back", function() home() end },
          { "Install", function()
              local ok, log, warn = install()
              inst.result = { ok, log, warn }
            end, "hot" } })
      end
    end
    drawButtons()
    if event == EV.EXIT then home() return end
    focusNav(event)
    handleButtons(event)
  end,
}

---------------------------------------------------------------------------
-- Home
---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Info: which switches / sticks / sliders do what (shown first at start)
---------------------------------------------------------------------------
local FM_LONG = { [0] = "CRUISE", "MOTOR ON", "LANDING", "SPEED", "DISTANCE", "THERMAL V", "THERMAL" }
local infoPage = 1

local function swIs(letter, p)
  local i = physSw(letter, p)
  return i ~= 0 and getSwitchValue(i)
end

local function swPosNow(letter)
  for k = 0, 2 do if swIs(letter, k) then return posWord(k) end end
  return "?"
end

local function landThr()
  local l = status.ready and model.getLogicalSwitch(1)
  if l and l.func == LSF.VNEG then return l.v2 end
  return 90
end

local function landText(m)
  m = m or SWMAP
  if m.lL then return swName(m.lL) .. " " .. posWord(m.lP) end
  return "Throttle < " .. landThr() .. " %"
end


local function infoCell(x, y, w, h, title, sub, on)
  rect(x, y, w, h, on and C.hot or C.panel)
  frame(x, y, w, h, on and C.acc or C.line)
  text(x + w / 2, y + 2, title, CENTER, C.txt)
  text(x + w / 2, y + h - FH[SMLSIZE] - 1, sub, CENTER + SMLSIZE, on and C.txt or C.dim)
end

local function infoRows()
  local M = SWMAP
  local off = posWord(2 - M.mP)
  local rows = {
    { swName(M.mL), M.mL, off .. " = ready / reset timers, mid = glide, " .. posWord(M.mP) .. " = MOTOR ON" },
    { swName(M.m1), M.m1, "3-pos: flight mode (see page 1)" },
    { swName(M.m2), M.m2, "up / down: flight mode (see page 1)" },
  }
  if M.lL then rows[#rows + 1] = { swName(M.lL), M.lL, posWord(M.lP) .. " = LANDING (crow amount = throttle stick)" } end
  if P.slider then
    rows[#rows + 1] = { "RS", nil, "right slider: motor power in MOTOR ON (bottom = off)" }
    rows[#rows + 1] = { "SG", "G", "Timer 3 (chrono): down = run, up = reset" }
  else
    rows[#rows + 1] = { "SG", "G", "motor power in MOTOR ON: up high, mid, down low" }
    rows[#rows + 1] = { "SH", "H", "momentary: hold = full power in MOTOR ON" }
  end
  rows[#rows + 1] = { "SC", "C", "down = RX voltage call" }
  rows[#rows + 1] = { "SI", "I", "press = flight time call, hold 1 s = link quality" }
  if M.lL then
    rows[#rows + 1] = { "Thr", nil, "throttle stick: crow amount in LANDING" }
  else
    rows[#rows + 1] = { "Thr", nil, "throttle stick below " .. landThr() .. " % = LANDING (crow brake)" }
  end
  rows[#rows + 1] = { "SL1", nil, "left slider: camber variation in THERMAL V" }
  local used = { C = true, G = true, H = not P.slider, I = true, [M.mL] = true, [M.m1] = true, [M.m2] = true }
  if M.lL then used[M.lL] = true end
  local free = {}
  for k = 1, #SW_LET do local l = letOf(k) if not used[l] then free[#free + 1] = swName(l) end end
  free[#free + 1] = "P1" free[#free + 1] = "P2"
  if not P.slider then free[#free + 1] = "SL2" end
  return rows, "Not used: " .. table.concat(free, ", ") .. "."
end

screens.info = {
  enter = function(p) infoPage = p or 1 focus = 2 end,
  run = function(event)
    buttons = {}
    local fm = getFlightMode()
    local M = SWMAP
    header("Switches & flight modes", infoPage .. "/2   " .. (FM_LONG[fm] or ""))
    if infoPage == 1 then
      if cfg.swOk ~= 1 then
        text(8, BAR_H + 4, "Default switches below. Tap Accept, or Change switches to pick your own.", SMLSIZE, C.acc)
      else
        text(8, BAR_H + 4, "The active flight mode is lit. Move the switches and the throttle to try it.", SMLSIZE, C.dim)
      end
      local gx, gy, lw, cw, ch = 8, BAR_H + 24, 62, 122, 34
      text(gx + lw + cw / 2, gy, swName(M.m2) .. " up", CENTER + SMLSIZE, C.acc)
      text(gx + lw + cw + 4 + cw / 2, gy, swName(M.m2) .. " down", CENTER + SMLSIZE, C.acc)
      local grid = { { "up", 3, 4 }, { "mid", 0, 0 }, { "down", 5, 6 } }
      local over = (fm == 1 or fm == 2)
      for r, g in ipairs(grid) do
        local y = gy + 16 + (r - 1) * (ch + 4)
        text(gx, y + (ch - FH[SMLSIZE]) / 2, swName(M.m1) .. " " .. g[1], SMLSIZE, C.acc)
        for c = 1, 2 do
          local f = g[c + 1]
          local on = (not over) and fm == f and swIs(M.m1, r - 1) and ((c == 1) == swIs(M.m2, 0))
          infoCell(gx + lw + (c - 1) * (cw + 4), y, cw, ch, FM_LONG[f], "FM" .. f, on)
        end
      end
      local ox = gx + lw + 2 * cw + 16
      local ow = W - ox - 8
      text(ox, gy, "Overrides the grid", SMLSIZE, C.acc)
      infoCell(ox, gy + 16, ow, ch, "MOTOR ON", motorText() .. " - FM1", fm == 1)
      infoCell(ox, gy + 16 + ch + 4, ow, ch, "LANDING", landText() .. " - FM2", fm == 2)
      text(ox, gy + 16 + 2 * (ch + 4) + 2, "MOTOR ON wins", SMLSIZE, C.dim)
      text(ox, gy + 16 + 2 * (ch + 4) + 16, "over LANDING.", SMLSIZE, C.dim)
      local y = gy + 16 + 3 * (ch + 4) + 4
      wrap(8, y, W - 16, "Camber, snapflap, aileron-rudder mix and differential have their own value in each flight mode.",
        SMLSIZE, C.dim, 15)
      bottomRow({ { "Change switches", function() push("swsel") end },
        { "Accept", function() cfg.swOk = 1 saveCfg() infoPage = 2 focus = 3 end, "hot" } })
    else
      local rows, freeTxt = infoRows()
      local y = BAR_H + 3
      local step = (#rows > 10) and 15 or 16
      for _, r in ipairs(rows) do
        text(8, y, r[1], SMLSIZE, C.acc)
        text(42, y, r[3], SMLSIZE, C.txt)
        if r[2] then text(W - 8, y, swPosNow(r[2]), RIGHT + SMLSIZE, C.dim) end
        y = y + step
      end
      text(8, y + 2, freeTxt, SMLSIZE, C.dim)
      text(8, y + 17, P.slider and "Radio setting: SF = 2POS (SYS > Hardware > Switches)."
        or "Radio setting: SF = 2POS, SH = Toggle (SYS > Hardware > Switches).", SMLSIZE, C.warn)
      bottomRow({ { "Back", function() infoPage = 1 focus = 2 end },
        { cfg.info == 1 and "Show at start: on" or "Show at start: off", function() cfg.info = 1 - cfg.info saveCfg() end, nil, SMLSIZE },
        (inst.first and cfg.fs ~= 1) and { "Next: Failsafe", function() inst.first = false home() push("fs") end, "hot" }
          or { "Menu", function() home() end, "hot" } })
    end
    drawButtons()
    if event == EV.EXIT then home() return end
    focusNav(event)
    handleButtons(event)
  end,
}

---------------------------------------------------------------------------
-- Switch selection ("pilot setup")
---------------------------------------------------------------------------
local SS = { OPT = {
  motor = { { "A", 2 }, { "A", 0 }, { "B", 2 }, { "B", 0 }, { "D", 2 }, { "D", 0 }, { "E", 2 }, { "E", 0 }, { "F", 2 }, { "F", 0 } },
  m1 = { "A", "B", "D", "E" },
  m2 = { "A", "B", "D", "E", "F" },
  land = { false, { "A", 2 }, { "A", 0 }, { "B", 2 }, { "B", 0 }, { "D", 2 }, { "D", 0 }, { "E", 2 }, { "E", 0 }, { "F", 2 }, { "F", 0 } },
} }

function SS.cycle(key, d)
  local m = SS.m
  local list, cur = SS.OPT[key], 1
  for i, o in ipairs(list) do
    if key == "motor" and o[1] == m.mL and o[2] == m.mP then cur = i end
    if key == "m1" and o == m.m1 then cur = i end
    if key == "m2" and o == m.m2 then cur = i end
    if key == "land" and ((not o and not m.lL) or (o and o[1] == m.lL and o[2] == m.lP)) then cur = i end
  end
  local o = list[(cur - 1 + d) % #list + 1]
  if key == "motor" then m.mL, m.mP = o[1], o[2]
  elseif key == "m1" then m.m1 = o
  elseif key == "m2" then m.m2 = o
  elseif o then m.lL, m.lP = o[1], o[2]
  else m.lL = nil end
end

function SS.conflict(m)
  local seen, list = {}, { m.mL, m.m1, m.m2 }
  if m.lL then list[#list + 1] = m.lL end
  for _, l in ipairs(list) do
    if seen[l] then return swName(l) .. " is used for two functions." end
    seen[l] = true
  end
  return nil
end

screens.swsel = {
  enter = function()
    SS.m = { mL = SWMAP.mL, mP = SWMAP.mP, m1 = SWMAP.m1, m2 = SWMAP.m2, lL = SWMAP.lL, lP = SWMAP.lP }
    focus = 2
  end,
  run = function(event)
    buttons = {}
    local m = SS.m
    header("Change switches", "pilot setup")
    local rows = {
      { "MOTOR ON (FM1)", motorText(m), "motor" },
      { "Mode switch, 3-pos", swName(m.m1) .. " up / mid / down", "m1" },
      { "Mode switch, 2-pos", swName(m.m2) .. " up / down", "m2" },
      { "LANDING (FM2)", landText(m), "land" },
    }
    local y = BAR_H + 6
    local rh = 38
    for _, r in ipairs(rows) do
      button(236, y, 44, rh - 6, "<", function() SS.cycle(r[3], -1) end)
      button(428, y, 44, rh - 6, ">", function() SS.cycle(r[3], 1) end)
      y = y + rh
    end
    local err = SS.conflict(m)
    bottomRow({ { "Cancel", function() back() end }, { "Default", function()
        SS.m = { mL = "B", mP = 2, m1 = "E", m2 = "F", lL = nil, lP = 2 }
      end },
      { "Apply", function()
          if err then return end
          mapToCfg(SS.m) syncMap()
          cfg.swOk = 1
          if status.ready then applySwitchMap() end
          saveCfg()
          go("info", 1)
        end, err and "off" or "hot" } })
    drawButtons()
    y = BAR_H + 6
    for _, r in ipairs(rows) do
      text(8, y + (rh - 6 - FH[SMLSIZE]) / 2, r[1], SMLSIZE, C.dim)
      text(354, y + (rh - 6 - FH[0]) / 2, r[2], CENTER, C.txt)
      y = y + rh
    end
    y = y + 2
    if err then
      text(8, y, err, SMLSIZE, C.warn)
    else
      text(8, y, P.slider and "SC, SG, SI keep their functions (calls, timer 3). Motor power = RS."
        or "SC, SG, SH, SI keep their functions (calls, motor power, turbo).", SMLSIZE, C.dim)
    end
    if m.mL ~= "B" or m.mP ~= 2 then
      wrap(8, y + 16, W - 16, "Also set Model Setup > Pre-start Checks > Switch positions: " .. swName(m.mL) .. " " ..
        posWord(2 - m.mP) .. " only (Lua cannot change it).", SMLSIZE, C.acc, 14)
    end
    if event == EV.EXIT then back() return end
    focusNav(event)
    handleButtons(event)
  end,
}

---------------------------------------------------------------------------
-- Failsafe: safe state = sticks neutral, CRUISE, no LANDING, motor OFF
---------------------------------------------------------------------------

local function chUs(ch)
  local v = getValue(fid("ch" .. (ch + 1)) or 0) or 0
  local o = getOut(ch)
  return round(1500 + ((o and o.ppmCenter) or 0) + v * 512 / 1024), round(v * 100 / 1024)
end

local function fsModule()
  local t = A and A.modType and (A.modType[0] or A.modType[1])
  if not t then return "?", false end
  if t == "TYPE_CROSSFIRE" then return "ELRS / CRSF", true end
  return string.gsub(t, "^TYPE_", ""), false
end

screens.fs = {
  enter = function() focus = 1 end,
  run = function(event)
    buttons = {}
    local mod, elrs = fsModule()
    header("Failsafe", mod)
    local y = BAR_H + 3
    text(8, y, "Link lost = sticks neutral, CRUISE, no LANDING, motor OFF.", SMLSIZE, C.dim)
    y = y + 16
    local function stick(n) return math.abs((getValue(fid(n) or 0) or 0) * 100 / 1024) end
    local okS = stick("ail") < 5 and stick("ele") < 5 and stick("rud") < 5
    local fm = getFlightMode()
    local okF = (fm == 0)
    text(8, y, (okS and "OK  " or "--  ") .. "Aileron, elevator, rudder sticks centered", SMLSIZE, okS and C.ok or C.warn)
    y = y + 15
    text(8, y, (okF and "OK  " or "--  ") .. "CRUISE: " .. swName(SWMAP.m1) .. " mid, " .. swName(SWMAP.mL) .. " " ..
      posWord(2 - SWMAP.mP) .. " (motor OFF), no LANDING", SMLSIZE, okF and C.ok or C.warn)
    y = y + 18
    local colW = math.floor((W - 16) / 2)
    for i = 1, 9 do
      local ch = i - 1
      local o = getOut(ch)
      local name = (o and o.name ~= "") and o.name or "-"
      local us, pct = chUs(ch)
      local saved = cfg["f" .. i]
      local c = (i <= 5) and 0 or 1
      local r = (i <= 5) and (i - 1) or (i - 6)
      local x, yy = 8 + c * colW, y + r * 15
      text(x, yy, "CH" .. (ch + 1) .. " " .. name, SMLSIZE, C.txt)
      text(x + 118, yy, pct .. "%", RIGHT + SMLSIZE, C.dim)
      text(x + 170, yy, us .. "us", RIGHT + SMLSIZE, C.dim)
      if cfg.fs == 1 then text(x + colW - 10, yy, saved .. "", RIGHT + SMLSIZE, C.acc) end
    end
    y = y + 5 * 15 + 4
    if cfg.fs == 1 then
      text(W - 8, BAR_H + 34, "saved us", RIGHT + SMLSIZE, C.acc)
    end
    if elrs then
      wrap(8, y, W - 16, "ELRS: EdgeTX failsafe is not used. Enter the saved values (us) as failsafe in the receiver: receiver WiFi web UI, PWM outputs.",
        SMLSIZE, C.txt, 14)
    else
      wrap(8, y, W - 16, "Model > RF module > Failsafe: Custom. Hold this state and press Channels=>Failsafe.", SMLSIZE, C.txt, 14)
    end
    local ready = okS and okF
    bottomRow({ { "Back", function() back() end },
      { ready and "Capture" or "Set safe state first", function()
          if not ready then return end
          for i = 1, 9 do
      local ch = i - 1 cfg["f" .. i] = chUs(ch) end
          cfg.fs = 1
          saveCfg()
        end, ready and "hot" or "off" } })
    drawButtons()
    if event == EV.EXIT then back() return end
    focusNav(event)
    handleButtons(event)
  end,
}

local MENU = {
  { "Install / repair", function() go("install") end, true },
  { "Servo direction", function() go("dir") end, false, "d1" },
  { "Center (subtrim)", function() go("calPick", "center") end, false, "d2" },
  { "Endpoints", function() go("calPick", "endpoints") end, false, "d3" },
  { "Servo curves", function() go("calPick", "curves") end },
  { "Live monitor", function() go("monitor") end },
  { "Model check", function() go("check") end, true },
  { "Camber per mode", function() tuneCamber() end },
  { "Roll & rudder", function() tuneRoll() end },
  { "Crow / landing", function() tuneCrow() end },
  { "Snapflap", function() tuneSnap() end },
  { "Camber slider", function() tuneSlider() end },
  { "Motor", function() tuneMotor() end },
  { "F5J timer & calls", function() go("f5j") end },
}

screens.home = {
  enter = function() calOff() end,
  resume = function() calOff() end,
  run = function(event)
    buttons = {}
    local ver = "v" .. VERSION
    header(TOOL_TITLE, ver)
    text(W - 8 - #ver * CW[0] - 12, 7 + FH[0] - FH[SMLSIZE], "Made by Jonas Ekman", RIGHT + SMLSIZE, C.dim)
    local y = BAR_H + 4
    local st, col
    if not A or (A.state ~= "done" and A.state ~= "fail") then
      st, col = "Reading model file...", C.dim
    elseif status.ready and cfg.fs ~= 1 then
      st, col = "Programming found - set the Failsafe next", C.acc
    elseif status.ready then
      st, col = "Programming found - all functions available", C.ok
    elseif status.old then
      st, col = "Older programming found - run Install / repair to update", C.acc
    elseif A.state == "done" and #A.none > 0 then
      st, col = #A.none .. " mix line(s) with source '---' - see Model check", C.warn
    elseif A.state == "done" and A.structure then
      st, col = "Programming partly found - run Install / repair", C.acc
    else
      st, col = "Programming not found - run Install / repair", C.acc
    end
    text(8, y, st, SMLSIZE, col)
    y = y + 18
    local colW = math.floor((W - 18) / 2)
    local rows = 7
    local rowH = math.floor((H - y - BTN_H - 12) / rows)
    for i, it in ipairs(MENU) do
      local c = (i <= rows) and 0 or 1
      local r = (i - 1) % rows
      local enabled = it[3] or status.ready
      button(6 + c * (colW + 6), y + r * rowH, colW, rowH - 4, "", function()
        if enabled then it[2]() end
      end, enabled and nil or "off")
    end
    button(6, H - BTN_H - 4, 104, BTN_H, "Exit", function() exitRequested = true end)
    button(116, H - BTN_H - 4, 104, BTN_H, "Switches", function() go("info", 1) end)
    button(226, H - BTN_H - 4, 104, BTN_H, "Failsafe", function() push("fs") end, (cfg.fs ~= 1) and "hot" or nil)
    drawButtons()
    for i, it in ipairs(MENU) do
      local b = buttons[i]
      local enabled = it[3] or status.ready
      text(b.x + 8, b.y + (b.h - FH[0]) / 2, it[1], 0, enabled and C.txt or C.dim)
      if it[4] and cfg[it[4]] == 1 then text(b.x + b.w - 8, b.y + (b.h - FH[SMLSIZE]) / 2, "done", RIGHT + SMLSIZE, C.ok) end
    end
    local msg = cfgSaveOk and (A and A.modelName or "") or ("Create folder " .. DATA_DIR)
    text(338, H - BTN_H + 2, msg, SMLSIZE, cfgSaveOk and C.dim or C.warn)
    if event == EV.EXIT then exitRequested = true end
    focusNav(event)
    handleButtons(event)
  end,
}

---------------------------------------------------------------------------
-- EdgeTX entry points
---------------------------------------------------------------------------
local initErr = nil
local anaDone = false

local function init()
  initColors()
  initScale()
  local ok, err = pcall(function()
    loadCfg()
    anaStart()
  end)
  if not ok then initErr = tostring(err) end
  screen = "home"           -- first page is chosen when the model file is read
end

local function run(event, touchState)
  if initErr then
    lcd.clear()
    lcd.drawText(8, 8, "F5J Setup error:", 0)
    lcd.drawText(8, 30, initErr, SMLSIZE)
    if event == EV.EXIT then return 1 end
    return 0
  end
  if not anaDone then
    local ok, fin = pcall(anaStep)
    if not ok then A.state = "fail" A.err = tostring(fin) fin = true end
    if fin then
      anaDone = true
      if A.state == "done" and #A.none == 0 then calOff() end
      refreshStatus()
      if status.ready then pcall(detectMap) end
      if A.state == "done" and #A.none == 0 and not status.ready and not status.old then
        inst.first = true                  -- no programming yet: install first, then switches
        go("install")
      elseif cfg.info == 1 and screen == "home" then
        go("info", 1)
      end
    end
  end
  touchX, touchY = nil, nil
  if touchState and touchState.x then touchX, touchY = touchState.x / SX, touchState.y / SY end
  lcd.clear()
  local s = screens[screen]
  local ok, err = pcall(s.run, event)
  if not ok then
    initErr = tostring(err)
    pcall(calOff)
  end
  if exitRequested then
    pcall(calOff)
    saveCfg()
    return 1
  end
  return 0
end

return { init = init, run = run, useLvgl = false }

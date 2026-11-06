-- TNS|Glider Setup X-tail|TNE
---------------------------------------------------------------------------
-- Glider Setup Wizard for EdgeTX 2.12 (color screen radios, e.g. TX16S)
--
-- Builds a complete electric glider (F5J style) setup in the CURRENT model:
--   channels, inputs, mixes, flight modes, global variables, curves,
--   logical/special functions. Calibrates servos live (direction, center,
--   endpoints, rates) and lets you tune per flight mode afterwards.
--
-- Channel layout:
--   CH1 Aileron L   CH2 Flap L   CH3 Tail L / Elevator   CH4 Tail R / Rudder
--   CH5 Flap R      CH6 Aileron R                         CH7 Motor
--
-- Sign convention for every surface: +  = trailing edge UP
--                                      (rudder on X-tail: + = trailing edge RIGHT)
-- X-tail = conventional cross/T tail: stabilizer with elevator (CH3) and fin
-- with rudder (CH4).
--
-- Owned by this tool (overwritten by "5 Write setup"):
--   all mixes, inputs I1-I3, flight modes FM0-FM4, GV1-GV9, curves CV1-CV2,
--   logical switch L01, special functions SF1-SF3, output names CH1-CH7.
-- Servo calibration (reverse, subtrim, PPM center, limits) is kept.
---------------------------------------------------------------------------

local VERSION  = "1.2"
local DATA_DIR = "/SCRIPTS/TOOLS/GliderSetupData/"
local FIXED_TAIL = 2          -- 1 = V-tail tool, 2 = X-tail tool
local TOOL_TITLE = "Glider Setup X-tail"
local CFG_SUFFIX = (FIXED_TAIL == 2) and "_X" or "_V"

-- channels (0-based)
local AIL_L, FLP_L, TAIL_L, TAIL_R, FLP_R, AIL_R, MOT = 0, 1, 2, 3, 4, 5, 6

-- flight modes
local FM_NAMES = { [0] = "Cruise", "Landing", "Launch", "Speed", "Thermal" }

-- event aliases (nil-safe)
local EV_ENTER = EVT_VIRTUAL_ENTER
local EV_EXIT  = EVT_VIRTUAL_EXIT
local EV_NEXT  = EVT_VIRTUAL_NEXT
local EV_PREV  = EVT_VIRTUAL_PREV
local EV_INC   = EVT_VIRTUAL_INC
local EV_DEC   = EVT_VIRTUAL_DEC
local EV_PGN   = EVT_VIRTUAL_NEXT_PAGE
local EV_PGP   = EVT_VIRTUAL_PREV_PAGE
local EV_TAP   = EVT_TOUCH_TAP

local FN_ADJUST_GV = FUNC_ADJUST_GVAR or 5
local FN_VOLUME    = FUNC_VOLUME or 6
local FN_VARIO     = FUNC_VARIO or 16
local LS_VPOS      = LS_FUNC_VPOS or 3
local LS_VNEG      = LS_FUNC_VNEG or 4

---------------------------------------------------------------------------
-- Colors / layout
---------------------------------------------------------------------------
local C = {}
-- Layout on a virtual 480 x 272 canvas, scaled to the real screen
-- (TX16S MK3: 800 x 480). Font sizes are measured at start.
local W, H = 480, 272
local SX, SY = 1, 1
local FH, CW = {}, {}

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
local BAR_H = 30
local BTN_H = 36

local function initColors()
  C.bg     = lcd.RGB(16, 22, 30)
  C.bar    = lcd.RGB(22, 92, 112)
  C.panel  = lcd.RGB(30, 42, 56)
  C.btn    = lcd.RGB(44, 62, 80)
  C.btnHot = lcd.RGB(214, 140, 24)
  C.go     = lcd.RGB(40, 150, 80)
  C.txt    = lcd.RGB(240, 244, 248)
  C.dim    = lcd.RGB(150, 162, 176)
  C.acc    = lcd.RGB(245, 190, 40)
  C.warn   = lcd.RGB(235, 90, 70)
  C.ok     = lcd.RGB(90, 200, 120)
  C.line   = lcd.RGB(110, 170, 200)
end

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

local function srcLabel(name)
  if not name or name == "" then return "---" end
  local id = fid(name)
  if not id then return name .. "?" end
  local n = getSourceName and getSourceName(id)
  return n or name
end

local function swName(idx)
  if not idx or idx == 0 then return "---" end
  local ok, n = pcall(getSwitchName, idx)
  if ok and n then return n end
  return "#" .. idx
end

-- GV as weight / curve value (source-encoded). n is 1-based.
local function gvRef(n, invert)
  local s = fid("gvar" .. n)
  if not s or s >= 512 then error("GV" .. n .. " source not usable") end
  if invert then return -(1024 + s) end
  return 1024 + s
end

---------------------------------------------------------------------------
-- Configuration (per model, stored on SD card)
---------------------------------------------------------------------------
local cfg
local cfgPath
local cfgSaveOk = true

local function defaultCfg()
  return {
    wing = 4, tail = FIXED_TAIL or 1, motor = 1,  -- tail: 1 = V-tail, 2 = X-tail
    swThermal = 0, swSpeed = 0,
    swLaunch = 0,                            -- 0 none, -1 = automatic with motor
    swLanding = -1,                          -- 0 none, -1 = automatic with crow
    swMotor = 0, swVario = 0,
    srcCrow = "thr", crowLow = 1,            -- crowLow 1 = full crow with stick DOWN
    srcCamber = "", srcMotorPwr = "", srcVolume = "", trimDiff = "",
    rateAil = 100,
    -- V-tail: elevator and rudder share the same servos, so the defaults add up to 100%
    rateEleUp = (FIXED_TAIL == 2) and 100 or 60, rateEleDn = (FIXED_TAIL == 2) and 100 or 50,
    rateRud = (FIXED_TAIL == 2) and 100 or 40,
    motorMax = 100, motorRamp = 10, slAil = 5, slFlap = 5,
    ce1 = 0, ce2 = 0, ce3 = 0, ce4 = 0, ce5 = 0,
    gvInit = 0, dirty = 0,
    dP = 0, d0 = 0, d1 = 0, d2 = 0, d3 = 0, d4 = 0, dE = 0, d5 = 0,
    ck = 0,                                  -- checklist bit mask
  }
end

local function modelKey()
  local info = model.getInfo()
  local n = (info and info.name) or "model"
  n = string.gsub(n, "[^%w%-_]", "_")
  if n == "" then n = "model" end
  return n
end

local function loadCfg()
  cfg = defaultCfg()
  cfgPath = DATA_DIR .. modelKey() .. CFG_SUFFIX .. ".txt"
  local f = io.open(cfgPath, "r")
  if not f then return end
  local s = io.read(f, 4096) or ""
  io.close(f)
  for line in string.gmatch(s, "[^\r\n]+") do
    local k, v = string.match(line, "^([%w_]+)=(.*)$")
    if k and cfg[k] ~= nil then
      if type(cfg[k]) == "number" then
        cfg[k] = tonumber(v) or cfg[k]
      else
        cfg[k] = v
      end
    end
  end
  if FIXED_TAIL then cfg.tail = FIXED_TAIL end
end

local function saveCfg()
  local keys = {}
  for k in pairs(cfg) do keys[#keys + 1] = k end
  table.sort(keys)
  local f = io.open(cfgPath, "w")
  if not f then cfgSaveOk = false return false end
  for _, k in ipairs(keys) do
    local v = cfg[k]
    if type(v) == "number" then v = tostring(round(v)) end
    io.write(f, k, "=", v, "\n")
  end
  io.close(f)
  cfgSaveOk = true
  return true
end

---------------------------------------------------------------------------
-- Channel information
---------------------------------------------------------------------------
local function chName(ch)
  if ch == AIL_L then return "Aileron L"
  elseif ch == FLP_L then return "Flap L"
  elseif ch == FLP_R then return "Flap R"
  elseif ch == AIL_R then return "Aileron R"
  elseif ch == MOT then return "Motor"
  elseif cfg.tail == 1 then
    return ch == TAIL_L and "V-tail L" or "V-tail R"
  else
    return ch == TAIL_L and "Elevator" or "Rudder"
  end
end

local function chShort(ch)
  local t = { [0] = "AilL", "FlpL", "", "", "FlpR", "AilR", "Motor" }
  if ch == TAIL_L then return cfg.tail == 1 and "VtL" or "Elev" end
  if ch == TAIL_R then return cfg.tail == 1 and "VtR" or "Rudd" end
  return t[ch]
end

local function isRudder(ch) return ch == TAIL_R and cfg.tail == 2 end
local function negWord(ch) return isRudder(ch) and "LEFT" or "DOWN" end
local function posWord(ch) return isRudder(ch) and "RIGHT" or "UP" end

local function surfaceChannels()
  local t = { AIL_L }
  if cfg.wing == 4 then t[#t + 1] = FLP_L end
  t[#t + 1] = TAIL_L
  t[#t + 1] = TAIL_R
  if cfg.wing == 4 then t[#t + 1] = FLP_R end
  t[#t + 1] = AIL_R
  return t
end

---------------------------------------------------------------------------
-- Calibration mixes: a REPLACE line named "cal" at the end of a channel
-- forces it to a fixed value while the real setup stays untouched.
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
  for ch = 0, MOT do calRemove(ch) end
  calState = {}
end

-- t[ch] = number (fixed value)  or  list of {w = value, sw = switch}
-- (later lines win; a line with a switch only acts while that switch is on)
local function calSet(t)
  local maxSrc = fid("max")
  for ch = 0, MOT do
    local v = t[ch]
    local lines = nil
    if type(v) == "number" then lines = { { w = v } } elseif type(v) == "table" then lines = v end
    local key = nil
    if lines then
      key = ""
      for _, l in ipairs(lines) do
        l.w = clamp(round(l.w), -150, 150)
        key = key .. l.w .. ":" .. (l.sw or 0) .. ";"
      end
    end
    if key ~= calState[ch] then
      calRemove(ch)
      if lines then
        for _, l in ipairs(lines) do
          model.insertMix(ch, model.getMixesCount(ch),
            { name = "cal", source = maxSrc, weight = l.w, multiplex = 2, switch = l.sw or 0 })
        end
      end
      calState[ch] = key
    end
  end
end

-- all surfaces to value v, motor always OFF
local function calAll(v, override)
  local t = {}
  for _, ch in ipairs(surfaceChannels()) do t[ch] = v end
  if override then for k, w in pairs(override) do t[k] = w end end
  if cfg.motor == 1 and t[MOT] == nil then t[MOT] = -100 end
  calSet(t)
end

---------------------------------------------------------------------------
-- Outputs
---------------------------------------------------------------------------
local function getOut(ch)
  local o = model.getOutput(ch)
  return o
end

local function setOut(ch, o)
  local t = {
    name = o.name, min = o.min, max = o.max, offset = o.offset,
    ppmCenter = o.ppmCenter, symetrical = o.symetrical, revert = o.revert,
  }
  if o.curve ~= nil then t.curve = o.curve end
  model.setOutput(ch, t)
end

---------------------------------------------------------------------------
-- Write the complete setup
---------------------------------------------------------------------------
-- EdgeTX name lengths: GV 3, curve 3, mix 6, input 4, output 6
local GV_NAMES = { "Dif", "CmA", "CmF", "A>R", "Snp", "A>F", "CrF", "CrA", "MtE" }
local GV_PER_FM = { true, true, true, true, true, true, false, false, false }
-- defaults per FM: Cruise, Landing, Launch, Speed, Thermal
local GV_DEF = {
  { 30, 30, 30, 20, 40 },   -- GV1 aileron differential %
  {  0,  0,  0,  2, -3 },   -- GV2 camber ailerons % (+ up)
  {  0,  0,  0,  2, -5 },   -- GV3 camber flaps % (+ up)
  { 20, 20, 10, 10, 30 },   -- GV4 aileron -> rudder %
  {  0,  0,  0,  0,  5 },   -- GV5 snapflap (up elevator -> flaps down) %
  { 50,  0, 30, 50, 60 },   -- GV6 aileron -> flaps %
  { 60, 60, 60, 60, 60 },   -- GV7 crow: flaps down %
  { 40, 40, 40, 40, 40 },   -- GV8 crow: ailerons up %
  {  0,  0,  0,  0,  0 },   -- GV9 elevator with motor on % (+ up)
}
local GV_RANGE = {
  { 0, 100 }, { -50, 50 }, { -50, 50 }, { -100, 100 }, { -100, 100 },
  { -100, 100 }, { 0, 100 }, { 0, 100 }, { -50, 50 },
}

local function crowCurveY()
  if cfg.crowLow == 1 then return { 100, 75, 50, 25, 0 } end
  return { 0, 25, 50, 75, 100 }
end

local function crowElevY()
  local p = { cfg.ce1, cfg.ce2, cfg.ce3, cfg.ce4, cfg.ce5 }
  if cfg.crowLow == 1 then return { p[5], p[4], p[3], p[2], p[1] } end
  return p
end

local function writeCurves()
  local r1 = model.setCurve(0, { name = "Crw", type = 0, smooth = false, y = crowCurveY() })
  local r2 = model.setCurve(1, { name = "CrE", type = 0, smooth = false, y = crowElevY() })
  return (r1 or 0) == 0 and (r2 or 0) == 0
end

local function writeInputs()
  model.deleteInputs()
  model.insertInput(0, 0, { name = "Ail", inputName = "Ail", source = fid("ail"),
    weight = cfg.rateAil, side = 3 })
  model.insertInput(1, 0, { name = "EleUp", inputName = "Ele", source = fid("ele"),
    weight = cfg.rateEleUp, side = 1 })   -- stick back
  model.insertInput(1, 1, { name = "EleDn", source = fid("ele"),
    weight = cfg.rateEleDn, side = 2 })   -- stick forward
  model.insertInput(2, 0, { name = "Rud", inputName = "Rud", source = fid("rud"),
    weight = cfg.rateRud, side = 3 })
end

local mixFail = 0
local function addMix(ch, t)
  local n = model.getMixesCount(ch)
  model.insertMix(ch, n, t)
  if model.getMixesCount(ch) ~= n + 1 then mixFail = mixFail + 1 end
end

local function clearMixesSafely()
  -- model.deleteMixes() does not reset EdgeTX's internal mix counter
  -- (later inserts silently fail), so lines are deleted one by one.
  for ch = 0, 31 do
    local guard = 0
    while model.getMixesCount(ch) > 0 and guard < 70 do
      model.deleteMix(ch, 0)
      guard = guard + 1
    end
  end
end

local function writeMixes()
  clearMixesSafely()
  local I1, I2, I3 = fid("input1"), fid("input2"), fid("input3")
  local MAXS = fid("max")
  local THR = fid(cfg.srcCrow) or fid("thr")
  local motor = cfg.motor == 1 and cfg.swMotor ~= 0
  local noMot = motor and -cfg.swMotor or 0
  local SL = fid(cfg.srcCamber)
  local SL_MASK = 2 + 4            -- slider camber off in Landing + Launch
  local SNAP_MASK = 2              -- snapflap off in Landing

  -- Ailerons
  for _, side in ipairs({ { AIL_L, -1 }, { AIL_R, 1 } }) do
    local ch, s = side[1], side[2]
    addMix(ch, { name = "Roll", source = I1, weight = 100 * s,
      curveType = 0, curveValue = gvRef(1, s < 0) })
    addMix(ch, { name = "Camber", source = MAXS, weight = gvRef(2) })
    if SL then addMix(ch, { name = "CmbSl", source = SL, weight = cfg.slAil, flightModes = SL_MASK }) end
    addMix(ch, { name = "Crow", source = THR, weight = gvRef(8),
      curveType = 3, curveValue = 1, switch = noMot, carryTrim = true })
  end

  -- Flaps
  if cfg.wing == 4 then
    for _, side in ipairs({ { FLP_L, -1 }, { FLP_R, 1 } }) do
      local ch, s = side[1], side[2]
      addMix(ch, { name = "Roll", source = I1, weight = gvRef(6, s < 0) })
      addMix(ch, { name = "Camber", source = MAXS, weight = gvRef(3) })
      if SL then addMix(ch, { name = "CmbSl", source = SL, weight = cfg.slFlap, flightModes = SL_MASK }) end
      -- snapflap: up elevator (I2 < 0) -> flaps down (negative)
      addMix(ch, { name = "Snap", source = I2, weight = gvRef(5),
        curveType = 2, curveValue = 2, flightModes = SNAP_MASK })
      addMix(ch, { name = "Crow", source = THR, weight = gvRef(7, true),
        curveType = 3, curveValue = 1, switch = noMot, carryTrim = true })
    end
  end

  -- Tail
  local function elevLines(ch)
    addMix(ch, { name = "Elev", source = I2, weight = -100 })
    addMix(ch, { name = "CrwEle", source = THR, weight = 100,
      curveType = 3, curveValue = 2, switch = noMot, carryTrim = true })
    if motor then
      addMix(ch, { name = "MotEle", source = MAXS, weight = gvRef(9),
        switch = cfg.swMotor, speedUp = 10, speedDown = 10 })
    end
  end
  if cfg.tail == 1 then
    -- upright V: right rudder -> left TE up, right TE down
    elevLines(TAIL_L)
    addMix(TAIL_L, { name = "Rudd", source = I3, weight = 100 })
    addMix(TAIL_L, { name = "A>R", source = I1, weight = gvRef(4) })
    elevLines(TAIL_R)
    addMix(TAIL_R, { name = "Rudd", source = I3, weight = -100 })
    addMix(TAIL_R, { name = "A>R", source = I1, weight = gvRef(4, true) })
  else
    elevLines(TAIL_L)
    addMix(TAIL_R, { name = "Rudd", source = I3, weight = 100 })
    addMix(TAIL_R, { name = "A>R", source = I1, weight = gvRef(4) })
  end

  -- Motor
  if cfg.motor == 1 then
    addMix(MOT, { name = "Off", source = MAXS, weight = -100 })
    if motor then
      local pwr = fid(cfg.srcMotorPwr)
      local m = clamp(cfg.motorMax, 0, 100)
      if pwr then
        addMix(MOT, { name = "Power", source = pwr, weight = m, offset = m,
          switch = cfg.swMotor, speedUp = cfg.motorRamp, carryTrim = true })
      else
        addMix(MOT, { name = "Power", source = MAXS, weight = 2 * m,
          switch = cfg.swMotor, speedUp = cfg.motorRamp })
      end
    end
  end
end

local function writeFlightModes(keepGV)
  -- FM0-FM4 are set field by field (trims and GV values are kept),
  -- FM5-FM8 are switched off so they can never become active.
  local L01 = getSwitchIndex("L01")
  local function fmSwitch(v, auto)
    if v == -1 then return auto or 0 end
    return v or 0
  end
  local motorSw = (cfg.motor == 1) and cfg.swMotor or 0
  model.setFlightMode(0, { name = FM_NAMES[0] })
  model.setFlightMode(1, { name = FM_NAMES[1], switch = fmSwitch(cfg.swLanding, L01), fadeIn = 5, fadeOut = 5 })
  model.setFlightMode(2, { name = FM_NAMES[2], switch = fmSwitch(cfg.swLaunch, motorSw), fadeIn = 5, fadeOut = 5 })
  model.setFlightMode(3, { name = FM_NAMES[3], switch = cfg.swSpeed, fadeIn = 5, fadeOut = 5 })
  model.setFlightMode(4, { name = FM_NAMES[4], switch = cfg.swThermal, fadeIn = 5, fadeOut = 5 })
  for fm = 5, 8 do model.setFlightMode(fm, { name = "", switch = 0 }) end

  for g = 1, 9 do
    model.setGlobalVariableDetails(g - 1, { name = GV_NAMES[g],
      min = GV_RANGE[g][1], max = GV_RANGE[g][2], prec = 0, unit = 1, popup = (g == 1) })
    for fm = 0, 8 do
      local v = GV_DEF[g][math.min(fm, 4) + 1]
      if keepGV then v = clamp(model.getGlobalVariable(g - 1, fm) or v, GV_RANGE[g][1], GV_RANGE[g][2]) end
      model.setGlobalVariable(g - 1, fm, v)
    end
  end
end

local function writeSwitchesAndFunctions()
  local THR = fid(cfg.srcCrow) or fid("thr")
  local motor = cfg.motor == 1 and cfg.swMotor ~= 0
  -- L01: crow active (used for automatic Landing mode)
  if cfg.crowLow == 1 then
    model.setLogicalSwitch(0, { func = LS_VNEG, v1 = THR, v2 = 90, ["and"] = motor and -cfg.swMotor or 0 })
  else
    model.setLogicalSwitch(0, { func = LS_VPOS, v1 = THR, v2 = -90, ["and"] = motor and -cfg.swMotor or 0 })
  end

  local ON = getSwitchIndex("ON")
  if not ON then
    local L01 = getSwitchIndex("L01")
    if L01 then ON = L01 + 64 end   -- SWSRC_ON follows the 64 logical switches
  end
  for i = 0, 2 do model.setCustomFunction(i, { switch = 0, func = 0 }) end
  local trim = fid(cfg.trimDiff)
  if trim and ON then
    model.setCustomFunction(0, { switch = ON, func = FN_ADJUST_GV, param = 0, mode = 1,
      value = trim, active = 1 })
  end
  local vol = fid(cfg.srcVolume)
  if vol and ON then
    model.setCustomFunction(1, { switch = ON, func = FN_VOLUME, value = vol, active = 1 })
  end
  if cfg.swVario ~= 0 then
    model.setCustomFunction(2, { switch = cfg.swVario, func = FN_VARIO, active = 1 })
  end
end

local function writeOutputNames()
  for ch = 0, MOT do
    local o = getOut(ch)
    if o then
      local used = false
      for _, c in ipairs(surfaceChannels()) do if c == ch then used = true end end
      if ch == MOT and cfg.motor == 1 then used = true end
      o.name = used and chShort(ch) or ""
      setOut(ch, o)
    end
  end
end

local function writeSetup()
  local ok, err = pcall(function()
    model.setInfo({ extendedLimits = true })
    calOff()
    if not writeCurves() then error("curve write failed") end
    writeInputs()
    mixFail = 0
    writeMixes()
    if mixFail > 0 then error(mixFail .. " mix lines not written - select another model and back, then write again") end
    writeFlightModes(cfg.gvInit == 1)
    writeSwitchesAndFunctions()
    writeOutputNames()
  end)
  if ok then
    cfg.gvInit = 1
    cfg.d5 = 1
    cfg.dirty = 0
    saveCfg()
    return true, "Setup written to model."
  end
  return false, tostring(err)
end

local function markChanged()
  if cfg.d5 == 1 then cfg.dirty = 1 end
end

---------------------------------------------------------------------------
-- Consistency checks: double-used controls and throws that can exceed the
-- endpoint (100%) when several mixes add up on the same servo.
---------------------------------------------------------------------------
local function gvFm(g, fm)
  if cfg.gvInit == 1 then
    local v = model.getGlobalVariable(g - 1, fm)
    if v then return v end
  end
  return GV_DEF[g][math.min(fm, 4) + 1]
end

local function activeFMs()
  local t = { 0 }
  if cfg.swLanding ~= 0 then t[#t + 1] = 1 end
  if cfg.swLaunch > 0 or (cfg.swLaunch == -1 and cfg.motor == 1 and cfg.swMotor ~= 0) then t[#t + 1] = 2 end
  if cfg.swSpeed ~= 0 then t[#t + 1] = 3 end
  if cfg.swThermal ~= 0 then t[#t + 1] = 4 end
  return t
end

local function conflictChecks()
  local out = {}
  -- switches used for two functions
  local sw = {
    { "Thermal", cfg.swThermal }, { "Speed", cfg.swSpeed }, { "Launch", cfg.swLaunch },
    { "Landing", cfg.swLanding }, { "Motor", (cfg.motor == 1) and cfg.swMotor or 0 }, { "Vario", cfg.swVario },
  }
  for i = 1, #sw do
    for j = i + 1, #sw do
      if sw[i][2] > 0 and sw[i][2] == sw[j][2] then
        out[#out + 1] = sw[i][1] .. " and " .. sw[j][1] .. " use the same switch " .. swName(sw[i][2])
      end
    end
  end
  -- analog controls used for two functions
  local an = {
    { "Crow", cfg.srcCrow }, { "Camber slider", cfg.srcCamber },
    { "Motor power", (cfg.motor == 1) and cfg.srcMotorPwr or "" }, { "Volume", cfg.srcVolume },
  }
  for i = 1, #an do
    for j = i + 1, #an do
      if an[i][2] ~= "" and an[i][2] == an[j][2] then
        out[#out + 1] = an[i][1] .. " and " .. an[j][1] .. " use the same control " .. srcLabel(an[i][2])
      end
    end
  end
  if cfg.motor == 1 and cfg.swMotor == 0 then out[#out + 1] = "No motor switch: motor stays OFF" end
  if cfg.swLaunch == -1 and (cfg.motor ~= 1 or cfg.swMotor == 0) then out[#out + 1] = "Launch 'Auto' needs a motor switch" end
  return out
end

local function throwChecks()
  local out = {}
  local function add(where, v, fm)
    out[#out + 1] = string.format("%s up to %d%% in %s", where, round(v), FM_NAMES[fm])
  end
  local slA = fid(cfg.srcCamber) and cfg.slAil or 0
  local slF = fid(cfg.srcCamber) and cfg.slFlap or 0
  local ceMax, ceMin = 0, 0
  for i = 1, 5 do
    local v = cfg["ce" .. i]
    if v > ceMax then ceMax = v end
    if v < ceMin then ceMin = v end
  end
  local motE = (cfg.motor == 1 and cfg.swMotor ~= 0) and gvFm(9, 0) or 0
  local wAil, wFlap, wTail = {}, {}, {}
  for _, fm in ipairs(activeFMs()) do
    local sl = (fm == 1 or fm == 2) and 0 or 1
    local diff = gvFm(1, fm)
    local cmA, cmF = gvFm(2, fm), gvFm(3, fm)
    local ar, af, snap = math.abs(gvFm(4, fm)), math.abs(gvFm(6, fm)), gvFm(5, fm)
    local crF, crA = gvFm(7, fm), gvFm(8, fm)
    -- ailerons: roll up + camber up + crow up
    local aUp = cfg.rateAil + math.max(0, cmA) + slA * sl + crA
    local aDn = cfg.rateAil * (100 - diff) / 100 + math.max(0, -cmA) + slA * sl
    if aUp > 100 and not wAil.up then add("Aileron up (roll+crow)", aUp, fm) wAil.up = true end
    if aDn > 100 and not wAil.dn then add("Aileron down", aDn, fm) wAil.dn = true end
    if cfg.wing == 4 then
      local roll = af * cfg.rateAil / 100
      local sn = (fm == 1) and 0 or math.max(0, snap) * cfg.rateEleUp / 100
      local fDn = roll + math.max(0, -cmF) + slF * sl + sn + crF
      local fUp = roll + math.max(0, cmF) + slF * sl
      if fDn > 100 and not wFlap.dn then add("Flap down (crow+roll+snap)", fDn, fm) wFlap.dn = true end
      if fUp > 100 and not wFlap.up then add("Flap up", fUp, fm) wFlap.up = true end
    end
    local comp = math.max(ceMax, motE, 0)
    local compN = math.max(-ceMin, -motE, 0)
    local arT = ar * cfg.rateAil / 100
    if cfg.tail == 1 then
      local up = cfg.rateEleUp + cfg.rateRud + arT + comp
      local dn = cfg.rateEleDn + cfg.rateRud + arT + compN
      if up > 100 and not wTail.up then add("V-tail up (elev+rudder)", up, fm) wTail.up = true end
      if dn > 100 and not wTail.dn then add("V-tail down (elev+rudder)", dn, fm) wTail.dn = true end
    else
      local up = cfg.rateEleUp + comp
      local dn = cfg.rateEleDn + compN
      local rud = cfg.rateRud + arT
      if up > 100 and not wTail.up then add("Elevator up", up, fm) wTail.up = true end
      if dn > 100 and not wTail.dn then add("Elevator down", dn, fm) wTail.dn = true end
      if rud > 100 and not wTail.rud then add("Rudder (rudder+A>R)", rud, fm) wTail.rud = true end
    end
  end
  return out
end

---------------------------------------------------------------------------
-- UI primitives
---------------------------------------------------------------------------
local buttons = {}
local focus = 1
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
  lineH = lineH or 18
  lineH = math.max(lineH, FH[fontKey(flags)] + 1)
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
  if line ~= "" then text(x, y, line, flags, color); y = y + lineH end
  return y
end

-- add a button; style: nil | "hot" | "go" | "warn" | "sel"
local function button(x, y, w, h, label, action, style)
  buttons[#buttons + 1] = { x = x, y = y, w = w, h = h, label = label, action = action, style = style }
end

local function drawButtons()
  if focus > #buttons then focus = #buttons end
  if focus < 1 then focus = 1 end
  for i, b in ipairs(buttons) do
    if b.style == "ghost" then
      if i == focus then frame(b.x, b.y, b.w, b.h, C.acc, 2) end
    else
    local col = C.btn
    if b.style == "hot" then col = C.btnHot
    elseif b.style == "go" then col = C.go
    elseif b.style == "warn" then col = C.warn
    elseif b.style == "sel" then col = C.bar end
    rect(b.x, b.y, b.w, b.h, col)
    if i == focus then
      frame(b.x, b.y, b.w, b.h, C.acc, 2)
    else
      frame(b.x, b.y, b.w, b.h, C.line)
    end
    text(b.x + b.w / 2, b.y + (b.h - FH[0]) / 2, b.label, CENTER, C.txt)
    end
  end
end

-- standard bottom row: up to 4 buttons
local function bottomRow(list)
  local n = #list
  local gap = 6
  local bw = math.floor((W - gap * (n + 1)) / n)
  for i, b in ipairs(list) do
    button(gap + (i - 1) * (bw + gap), H - BTN_H - 4, bw, BTN_H, b[1], b[2], b[3])
  end
end

-- returns true if event was a button activation
local function handleButtons(event)
  if event == EV_TAP and touchX then
    for i, b in ipairs(buttons) do
      if touchX >= b.x and touchX <= b.x + b.w and touchY >= b.y and touchY <= b.y + b.h then
        focus = i
        if b.action then b.action() end
        return true
      end
    end
  elseif event == EV_ENTER then
    local b = buttons[focus]
    if b and b.action then b.action() return true end
  end
  return false
end

local function focusNav(event)
  if event == EV_NEXT then focus = focus + 1 if focus > #buttons then focus = 1 end
  elseif event == EV_PREV then focus = focus - 1 if focus < 1 then focus = #buttons end end
end

---------------------------------------------------------------------------
-- Glider drawing (top view)
---------------------------------------------------------------------------
local function drawGlider(x, y, w, h, hl)
  hl = hl or {}
  local cx = x + w / 2
  local function surf(ch, sx, sy, sw, sh)
    local col = hl[ch] and C.acc or C.btn
    rect(sx, sy, sw, sh, col)
    frame(sx, sy, sw, sh, C.line)
  end
  local function lab(ch, lx, ly)
    text(lx, ly, "CH" .. (ch + 1), SMLSIZE + CENTER, hl[ch] and C.acc or C.dim)
  end
  -- fuselage
  rect(cx - 3, y + 4, 6, h - 8, C.panel)
  frame(cx - 3, y + 4, 6, h - 8, C.line)
  -- wing
  local wy, wh = y + math.floor(h * 0.26), math.max(10, math.floor(h * 0.14))
  local wx, ww = x, w
  if cfg.wing == 4 then
    local a = math.floor(ww * 0.27)
    local f = math.floor(ww * 0.5) - a
    surf(AIL_L, wx, wy, a, wh)
    surf(FLP_L, wx + a, wy, f, wh)
    surf(FLP_R, wx + a + f, wy, f, wh)
    surf(AIL_R, wx + a + 2 * f, wy, ww - a - 2 * f, wh)
    lab(AIL_L, wx + a / 2, wy + wh + 2)
    lab(FLP_L, wx + a + f / 2, wy + wh + 2)
    lab(FLP_R, wx + a + f * 1.5, wy + wh + 2)
    lab(AIL_R, wx + ww - a / 2, wy + wh + 2)
  else
    local half = math.floor(ww / 2)
    surf(AIL_L, wx, wy, half, wh)
    surf(AIL_R, wx + half, wy, ww - half, wh)
    lab(AIL_L, wx + half / 2, wy + wh + 2)
    lab(AIL_R, wx + ww - half / 2, wy + wh + 2)
  end
  -- tail
  local ty, th = y + h - math.floor(h * 0.2), math.max(8, math.floor(h * 0.1))
  local tw = math.floor(w * 0.18)
  if cfg.tail == 1 then
    surf(TAIL_L, cx - tw, ty, tw - 3, th)
    surf(TAIL_R, cx + 3, ty, tw - 3, th)
    lab(TAIL_L, cx - tw / 2, ty + th + 2)
    lab(TAIL_R, cx + tw / 2, ty + th + 2)
  else
    -- stabilizer with elevator (CH3), fin with rudder (CH4) on top
    surf(TAIL_L, cx - tw, ty, 2 * tw, th)
    surf(TAIL_R, cx - 4, ty - th - 6, 8, 2 * th + 12)
    lab(TAIL_L, cx - tw / 2, ty + th + 2)
    text(cx + 8, ty - th - 8, "CH4", SMLSIZE, hl[TAIL_R] and C.acc or C.dim)
  end
  -- motor
  if cfg.motor == 1 then
    surf(MOT, cx - 6, y, 12, 8)
    text(cx + 10, y - 2, "CH7", SMLSIZE, hl[MOT] and C.acc or C.dim)
  end
end

---------------------------------------------------------------------------
-- Value editor (S1 = coarse, S2 = fine, rotary/buttons = single steps)
---------------------------------------------------------------------------
local ed = nil   -- current editor

local function potVal(name)
  local id = fid(name)
  if not id then return nil end
  return getValue(id) or 0
end

local function edStart(e)
  -- e: {get(), apply(v), min, max, coarse, fine, step}
  e.base = e.get()
  e.orig = e.base
  e.enc = 0
  e.armed = false
  e.value = e.base
  e.applied = e.base
  ed = e
end

local function edResetPot()
  if not ed then return end
  ed.base = ed.value
  ed.enc = 0
  ed.armed = false
end

local function edUpdate(event)
  local e = ed
  if not e then return end
  if event == EV_INC or event == EV_NEXT then e.enc = e.enc + e.step
  elseif event == EV_DEC or event == EV_PREV then e.enc = e.enc - e.step end
  -- S1 knob = coarse, wheel = fine. S2 is not used: on the TX16S MK3 's2'
  -- is the 6-position switch.
  local s1 = potVal("s1")
  local pot = 0
  if s1 == nil then
    e.armed = true
  elseif not e.armed then
    if math.abs(s1) < 41 then e.armed = true end
  else
    pot = s1 / 1024 * e.coarse
  end
  e.value = clamp(round(e.base + e.enc + pot), e.min, e.max)
  if e.value ~= e.applied then
    e.apply(e.value)
    e.applied = e.value
  end
end

local function edDrawBar(x, y, w, e, fmtFn)
  local span = e.max - e.min
  rect(x, y + 8, w, 6, C.panel)
  frame(x, y + 8, w, 6, C.line)
  local function px(v) return x + math.floor((v - e.min) / span * w) end
  if e.min < 0 and e.max > 0 then rect(px(0) - 1, y + 4, 2, 14, C.dim) end
  rect(px(e.orig) - 1, y + 4, 2, 14, C.ok)
  rect(px(e.value) - 3, y + 2, 6, 18, C.acc)
  text(x, y + 20, fmtFn(e.min), SMLSIZE, C.dim)
  text(x + w, y + 20, fmtFn(e.max), SMLSIZE + RIGHT, C.dim)
end

local function edStatusLine(x, y)
  if ed and not ed.armed then
    text(x, y, "Set the S1 knob to center to start", SMLSIZE, C.warn)
  else
    text(x, y, "S1 knob = coarse, wheel = fine steps", SMLSIZE, C.dim)
  end
end

---------------------------------------------------------------------------
-- Screens
---------------------------------------------------------------------------
local screen = "menu"
local screens = {}

local function go(name, ...)
  buttons = {}
  focus = 1
  ed = nil
  screen = name
  if screens[name].enter then screens[name].enter(...) end
end

---------------------------------------------------------------------------
-- Main menu
---------------------------------------------------------------------------
local exitRequested = false

local function stepState(key)
  if key == "d5" then
    if cfg.dirty == 1 then return "rewrite!", C.warn end
    return cfg.d5 == 1 and "written" or "", C.ok
  end
  if key == "ck" then
    local n = 0
    for i = 0, 9 do if bit32.band(cfg.ck, bit32.lshift(1, i)) ~= 0 then n = n + 1 end end
    return n .. "/10", (n == 10) and C.ok or C.dim
  end
  return cfg[key] == 1 and "done" or "", C.ok
end

screens.menu = {
  enter = function() calOff() end,
  run = function(event)
    buttons = {}
    header(TOOL_TITLE, "v" .. VERSION)
    local items = {
      { "P", "Pilot setup", "pilot", "dP" },
      { "0", "Airframe", "air", "d0" },
      { "1", "Servo direction", "dir", "d1" },
      { "2", "Center", "center", "d2" },
      { "3", "Endpoints", "endpt", "d3" },
      { "4", "Rates", "rates", "d4" },
      { "E", "ESC calibration", "esc", "dE" },
      { "5", "Write setup", "write", "d5" },
      { "6", "Tuning", "tune", nil },
      { "7", "Checklist", "check", "ck" },
    }
    local colW = math.floor((W - 18) / 2)
    local rowH = math.floor((H - BAR_H - BTN_H - 16) / 5) - 4
    for i, it in ipairs(items) do
      local col = (i <= 5) and 0 or 1
      local row = (i - 1) % 5
      local bx = 6 + col * (colW + 6)
      local by = BAR_H + 4 + row * (rowH + 4)
      local target = it[3]
      button(bx, by, colW, rowH, "", function() go(target) end, (target == "write" and cfg.dirty == 1) and "hot" or nil)
    end
    button(6, H - BTN_H - 4, 140, BTN_H, "Exit", function() exitRequested = true end)
    drawButtons()
    for i, it in ipairs(items) do
      local b = buttons[i]
      text(b.x + 8, b.y + (b.h - FH[0]) / 2, it[1] .. "  " .. it[2], 0, C.txt)
      if it[4] then
        local s, col = stepState(it[4])
        text(b.x + b.w - 8, b.y + (b.h - FH[SMLSIZE]) / 2, s, RIGHT + SMLSIZE, col)
      end
    end
    local y = H - BTN_H - 2
    if not cfgSaveOk then
      text(156, y, "Cannot save settings - create folder:", SMLSIZE, C.warn)
      text(156, y + 16, DATA_DIR, SMLSIZE, C.warn)
    else
      if cfg.dirty == 1 then
        text(156, y, "Changed P, 0 or 4? Write the setup (5) again.", SMLSIZE, C.warn)
      else
        text(156, y, "Order: P, 0, 1-4, E, then 5. Tune with 6.", SMLSIZE, C.dim)
      end
      text(156, y + 16, "Only Save/Confirm stores. PAGE keys skip.", SMLSIZE, C.dim)
    end
    focusNav(event)
    if event == EV_EXIT then exitRequested = true end
    handleButtons(event)
  end,
}

---------------------------------------------------------------------------
-- P - Pilot setup
---------------------------------------------------------------------------
local ANALOGS = { "", "s1", "s2", "ls", "rs", "thr", "ext1", "ext2" }
-- only trims that are free: rudder/elevator/aileron trims stay normal trims
local TRIMS = { "", "trim-thr", "trim-t5", "trim-t6" }

local function availableList(list)
  local out = {}
  for _, n in ipairs(list) do
    if n == "" or fid(n) then out[#out + 1] = n end
  end
  return out
end

local pilotItems = {
  { key = "swThermal", label = "Thermal (FM4)", kind = "sw",
    help = "Flip the switch to the position that activates Thermal mode." },
  { key = "swSpeed", label = "Speed (FM3)", kind = "sw",
    help = "Flip the switch to the position that activates Speed mode." },
  { key = "swLaunch", label = "Launch (FM2)", kind = "sw", auto = "Auto: motor on",
    help = "Launch mode. 'Auto' uses Launch whenever the motor is on." },
  { key = "swLanding", label = "Landing (FM1)", kind = "sw", auto = "Auto: crow",
    help = "Landing mode. 'Auto' switches to Landing when crow is used." },
  { key = "swMotor", label = "Motor on", kind = "sw", motor = true,
    help = "Position that turns the motor ON. Crow is disabled while it is on." },
  { key = "srcMotorPwr", label = "Motor power", kind = "an", list = ANALOGS, motor = true,
    help = "Optional pot/slider for motor power. None = fixed power (Tuning)." },
  { key = "srcCrow", label = "Crow / butterfly", kind = "an", list = ANALOGS, noNone = true,
    help = "Stick or slider that controls crow (butterfly)." },
  { key = "crowLow", label = "Crow direction", kind = "opt",
    opts = { { 1, "Full crow at stick DOWN", "DOWN" }, { 0, "Full crow at stick UP", "UP" } },
    help = "Which end of the crow control gives full brake." },
  { key = "srcCamber", label = "Camber slider", kind = "an", list = ANALOGS,
    help = "Optional: continuous camber (thermal <-> speed) in Cruise, Speed, Thermal." },
  { key = "trimDiff", label = "Diff trim", kind = "an", list = TRIMS,
    help = "Optional trim that adjusts aileron differential in flight, per flight mode." },
  { key = "srcVolume", label = "Volume", kind = "an", list = ANALOGS,
    help = "Optional pot for audio volume." },
  { key = "swVario", label = "Vario on/off", kind = "sw",
    help = "Optional switch position that turns the vario sound on." },
}

local pSel = 1
local pDetect = nil   -- {base = {}}
local physMax = nil

local function physicalSwitchMax()
  if physMax then return physMax end
  physMax = 0
  for i = 1, 400 do
    local ok, n = pcall(getSwitchName, i)
    if ok and n and string.match(n, "^L%d%d$") then break end
    physMax = i
  end
  return physMax
end

local function isPhysical(i)
  local ok, n = pcall(getSwitchName, i)
  if not ok or not n then return false end
  local last = string.sub(n, -1)
  return last ~= "+" and last ~= "-"
end

local function detectStart()
  pDetect = { base = {} }
  for i = 1, physicalSwitchMax() do pDetect.base[i] = getSwitchValue(i) and true or false end
end

local function detectPoll()
  if not pDetect then return nil end
  for i = 1, physicalSwitchMax() do
    local v = getSwitchValue(i) and true or false
    if v and not pDetect.base[i] and isPhysical(i) then return i end
    if not v then pDetect.base[i] = false end
  end
  return nil
end

local function pilotVisible(it)
  return not (it.motor and cfg.motor ~= 1)
end

local function pilotValueText(it)
  local v = cfg[it.key]
  if it.kind == "sw" then
    if v == -1 then return it.auto or "Auto" end
    return swName(v)
  elseif it.kind == "an" then
    return srcLabel(v)
  else
    for _, o in ipairs(it.opts) do if o[1] == v then return o[3] or o[2] end end
  end
  return "?"
end

local function pilotCycle(it, dir)
  local list = availableList(it.list)
  if it.noNone then
    local t = {}
    for _, n in ipairs(list) do if n ~= "" then t[#t + 1] = n end end
    list = t
  end
  local cur = 1
  for i, n in ipairs(list) do if n == cfg[it.key] then cur = i end end
  cur = cur + dir
  if cur > #list then cur = 1 elseif cur < 1 then cur = #list end
  cfg[it.key] = list[cur]
  markChanged()
end

screens.pilot = {
  enter = function() calOff() pDetect = nil end,
  run = function(event)
    buttons = {}
    header("P - Pilot setup", pSel .. " / " .. #pilotItems)
    local it = pilotItems[pSel]
    local listW = 190
    local rowH = math.floor((H - BAR_H - BTN_H - 14) / #pilotItems)
    for i, p in ipairs(pilotItems) do
      local y = BAR_H + 4 + (i - 1) * rowH
      if i == pSel then rect(4, y, listW, rowH, C.btnHot) end
      local col = pilotVisible(p) and C.txt or C.dim
      text(8, y + (rowH - FH[SMLSIZE]) / 2, p.label, SMLSIZE, col)
      text(listW, y + (rowH - FH[SMLSIZE]) / 2, pilotValueText(p), SMLSIZE + RIGHT, col)
      button(4, y, listW, rowH, "", function() pSel = i pDetect = nil end, "ghost")
    end
    local px = listW + 14
    local pw = W - px - 6
    text(px, BAR_H + 6, it.label, MIDSIZE, C.acc)
    local y = wrap(px, BAR_H + 34, pw, it.help, SMLSIZE, C.txt, 15)
    text(px, y + 4, "Selected: " .. pilotValueText(it), 0, C.ok)
    local by = y + 30
    local bw = math.floor((pw - 12) / 3)
    if not pilotVisible(it) then
      text(px, by, "Not used (no motor in Airframe).", SMLSIZE, C.dim)
    elseif it.kind == "sw" then
      if pDetect then
        text(px, by - 2, "Flip the switch now...", 0, C.warn)
        local found = detectPoll()
        if found then cfg[it.key] = found; pDetect = nil; markChanged() end
        button(px, by + 22, bw, BTN_H, "Stop", function() pDetect = nil end, "warn")
      else
        button(px, by, bw, BTN_H, "Detect", function() detectStart() end, "hot")
        button(px + bw + 6, by, bw, BTN_H, "Not used", function() cfg[it.key] = 0 markChanged() end)
        if it.auto then
          button(px + 2 * (bw + 6), by, bw, BTN_H, "Auto", function() cfg[it.key] = -1 markChanged() end)
        end
      end
    elseif it.kind == "an" then
      button(px, by, bw, BTN_H, "<", function() pilotCycle(it, -1) end)
      button(px + bw + 6, by, bw, BTN_H, ">", function() pilotCycle(it, 1) end)
    else
      for i, o in ipairs(it.opts) do
        button(px, by + (i - 1) * (BTN_H + 4), pw, BTN_H, o[2],
          function() cfg[it.key] = o[1] markChanged() end, cfg[it.key] == o[1] and "sel" or nil)
      end
    end
    bottomRow({
      { "Back", function() saveCfg() go("menu") end },
      { "Defaults", function()
          local d = defaultCfg()
          for _, p in ipairs(pilotItems) do cfg[p.key] = d[p.key] end
          markChanged()
        end },
      { "Prev", function() pSel = (pSel > 1) and pSel - 1 or #pilotItems pDetect = nil end },
      { pSel == #pilotItems and "Save" or "Next",
        function()
          pDetect = nil
          if pSel == #pilotItems then cfg.dP = 1 saveCfg() go("menu") else pSel = pSel + 1 end
        end, "hot" },
    })
    focusNav(event)
    drawButtons()
    if event == EV_EXIT then saveCfg() go("menu") return end
    if event == EV_PGN then pSel = (pSel % #pilotItems) + 1 pDetect = nil end
    if event == EV_PGP then pSel = (pSel > 1) and pSel - 1 or #pilotItems pDetect = nil end
    handleButtons(event)
  end,
}

---------------------------------------------------------------------------
-- 0 - Airframe
---------------------------------------------------------------------------
screens.air = {
  enter = function() calOff() end,
  run = function(event)
    buttons = {}
    header("0 - Airframe")
    local gx, gw = W - 150, 140
    drawGlider(gx, BAR_H + 10, gw, H - BAR_H - BTN_H - 30, {})
    local rows = {
      { "Wing servos", "wing", { { 4, "4" }, { 2, "2" } } },
      { "Motor", "motor", { { 1, "Yes" }, { 0, "No" } } },
    }
    if not FIXED_TAIL then
      table.insert(rows, 2, { "Tail", "tail", { { 1, "V-tail" }, { 2, "X-tail" } } })
    end
    local y = BAR_H + 10
    local bw = math.floor((gx - 26 - 120) / 2)
    for _, r in ipairs(rows) do
      text(8, y + 9, r[1], 0, C.txt)
      for i, o in ipairs(r[3]) do
        local key, val = r[2], o[1]
        button(120 + (i - 1) * (bw + 6), y, bw, BTN_H, o[2],
          function() if cfg[key] ~= val then cfg[key] = val markChanged() end end,
          cfg[key] == val and "sel" or nil)
      end
      y = y + BTN_H + 12
    end
    local tailTxt = (cfg.tail == 1) and "CH3 V-tail L, CH4 V-tail R (upright V)" or "CH3 elevator, CH4 rudder"
    wrap(8, y + 4, gx - 16, "4 servos = ailerons + flaps, 2 = ailerons only. CH1 Ail L, CH2 Flap L, " .. tailTxt .. ", CH5 Flap R, CH6 Ail R, CH7 motor.", SMLSIZE, C.dim, 15)
    bottomRow({
      { "Back", function() saveCfg() go("menu") end },
      { "Save", function() cfg.d0 = 1 saveCfg() go("menu") end, "hot" },
    })
    focusNav(event)
    drawButtons()
    if event == EV_EXIT then saveCfg() go("menu") return end
    handleButtons(event)
  end,
}

---------------------------------------------------------------------------
-- 1 - Servo direction
---------------------------------------------------------------------------
local dirIdx = 1

screens.dir = {
  enter = function() dirIdx = 1 calAll(-40) end,
  run = function(event)
    buttons = {}
    local chans = surfaceChannels()
    local ch = chans[dirIdx]
    header("1 - Servo direction", dirIdx .. " of " .. #chans)
    calAll(-40)
    local gw = math.floor(W * 0.46)
    drawGlider(8, BAR_H + 8, gw, H - BAR_H - BTN_H - 50, { [ch] = true })
    local px = gw + 24
    local pw = W - px - 8
    text(px, BAR_H + 6, "CH" .. (ch + 1) .. "  " .. chName(ch), MIDSIZE, C.txt)
    text(px, BAR_H + 40, "Does the surface move " .. negWord(ch) .. "?", 0, C.acc)
    local o = getOut(ch)
    local y = wrap(px, BAR_H + 68, pw, "All surfaces are driven to -40% (" .. string.lower(negWord(ch)) ..
      "). The motor is held OFF.", SMLSIZE, C.dim, 15)
    text(px, y + 6, "Direction: " .. ((o and o.revert == 1) and "reversed" or "normal"), 0, C.ok)
    wrap(8, H - BTN_H - 24, W - 16, "Wrong way? Press Reverse. PAGE keys move without changing.", SMLSIZE, C.dim, 15)
    local function nextCh()
      if dirIdx < #chans then dirIdx = dirIdx + 1 else cfg.d1 = 1 saveCfg() go("menu") end
    end
    bottomRow({
      { "Cancel", function() go("menu") end },
      { "Prev", function() if dirIdx > 1 then dirIdx = dirIdx - 1 end end },
      { "Reverse", function()
          local oo = getOut(ch)
          if oo then oo.revert = (oo.revert == 1) and 0 or 1 setOut(ch, oo) end
        end, "hot" },
      { "Yes - OK", nextCh, "go" },
    })
    focusNav(event)
    drawButtons()
    if event == EV_EXIT then go("menu") return end
    if event == EV_PGN then dirIdx = (dirIdx % #chans) + 1 end
    if event == EV_PGP then dirIdx = (dirIdx > 1) and dirIdx - 1 or #chans end
    handleButtons(event)
  end,
}

---------------------------------------------------------------------------
-- Shared "calibration editor" screen used by Center / Endpoints / Rates
---------------------------------------------------------------------------
local cal = nil   -- {title, items, idx, doneKey, bind(item) -> editor fields, force(item, value)}

local function calBind()
  local it = cal.items[cal.idx]
  local e = cal.bind(it)
  e.item = it
  edStart(e)
  cal.force(it, e.value)
end

local function calNext(save)
  if save and ed then ed.commit(ed.value) end
  if cal.idx < #cal.items then
    cal.idx = cal.idx + 1
    calBind()
  else
    if save then
      cfg[cal.doneKey] = 1
      if cal.onDone then cal.onDone() end
    end
    saveCfg()
    go("menu")
  end
end

local function calCancelItem()
  if ed then ed.apply(ed.orig) ed.value = ed.orig end
end

screens.calib = {
  enter = function(def)
    cal = def
    cal.idx = 1
    calBind()
  end,
  run = function(event)
    buttons = {}
    local it = cal.items[cal.idx]
    header(cal.title, it.short .. " - " .. cal.idx .. " of " .. #cal.items)
    edUpdate(event)
    cal.force(it, ed.value)
    local gw = math.floor(W * 0.42)
    drawGlider(8, BAR_H + 8, gw, H - BAR_H - BTN_H - 50, it.hl)
    local px = gw + 22
    local pw = W - px - 8
    text(px, BAR_H + 4, it.title, MIDSIZE, C.txt)
    if it.sub then text(px + pw, BAR_H + 10, it.sub, RIGHT, C.acc) end
    local y = wrap(px, BAR_H + 32, pw, it.hint, SMLSIZE, C.dim, 15)
    text(px, y + 2, ed.fmt(ed.value), DBLSIZE, C.acc)
    if ed.extra then text(px + pw, y + 14, ed.extra(ed.value), RIGHT, C.txt) end
    edDrawBar(px, y + 42, pw, ed, ed.fmt)
    if cal.warnFn then
      local w = cal.warnFn(it, ed.value)
      if w then text(px, y + 78, w, SMLSIZE, C.warn) end
    end
    edStatusLine(8, H - BTN_H - 40)
    text(8, H - BTN_H - 24, "Green = original value. PAGE keys move without saving.", SMLSIZE, C.dim)
    bottomRow({
      { "Cancel", function() calCancelItem() go("menu") end },
      { "Back", function()
          calCancelItem()
          if cal.idx > 1 then cal.idx = cal.idx - 1 calBind() else go("menu") end
        end },
      { "Reset pot", function() edResetPot() end },
      { "Save >", function() calNext(true) end, "hot" },
    })
    drawButtons()
    if event == EV_EXIT then calCancelItem() go("menu") return end
    if event == EV_PGN then calCancelItem() calNext(false) return end
    if event == EV_PGP then
      calCancelItem()
      if cal.idx > 1 then cal.idx = cal.idx - 1 end
      calBind()
      return
    end
    if event == EV_ENTER then calNext(true) return end
    -- rotary is used by the editor here, so only touch activates buttons
    if event == EV_TAP then handleButtons(event) end
  end,
}

local function fmtPct(v) return string.format("%.1f%%", v / 10) end

---------------------------------------------------------------------------
-- 2 - Center
---------------------------------------------------------------------------
local function centerGet(ch)
  local o = getOut(ch)
  return round(o.offset + o.ppmCenter * 1000 / 512)
end

local function centerApply(ch, v)
  local o = getOut(ch)
  if math.abs(v) <= 1000 then
    o.offset = v
    o.ppmCenter = 0
  else
    local s = v > 0 and 1 or -1
    o.offset = 1000 * s
    o.ppmCenter = round((v - 1000 * s) * 512 / 1000)
  end
  setOut(ch, o)
end

local function centerUs(ch)
  local o = getOut(ch)
  local s = (o.revert == 1) and -1 or 1
  return 1500 + o.ppmCenter + round(s * o.offset * 0.512)
end

local function startCenter()
  local items = {}
  for _, ch in ipairs(surfaceChannels()) do
    local hint = "Align with the wing profile (cruise position)."
    if ch == TAIL_L or ch == TAIL_R then hint = "Align with the stabilizer profile." end
    if isRudder(ch) then hint = "Rudder straight." end
    items[#items + 1] = { ch = ch, short = "CH" .. (ch + 1), title = chName(ch), sub = "NEUTRAL",
      hint = hint .. " Beyond 100% PPM center is used too.", hl = { [ch] = true } }
  end
  go("calib", {
    title = "2 - Center", items = items, doneKey = "d2",
    bind = function(it)
      local ch = it.ch
      return {
        get = function() return centerGet(ch) end,
        apply = function(v) centerApply(ch, v) end,
        commit = function(v) centerApply(ch, v) end,
        min = -1500, max = 1500, coarse = 1000, fine = 100, step = 1,
        fmt = function(v) return fmtPct(v) end,
        extra = function() return centerUs(ch) .. " us" end,
      }
    end,
    force = function() calAll(0) end,
  })
end

---------------------------------------------------------------------------
-- 3 - Endpoints
---------------------------------------------------------------------------
local function epHint(ch, isMin)
  if ch == FLP_L or ch == FLP_R then
    if isMin then return "As far down as possible (about 70-90 deg), stop before the mechanical stop." end
    return "Maximum useful up travel (reflex/speed)."
  elseif ch == AIL_L or ch == AIL_R then
    if isMin then return "Maximum useful down travel without binding." end
    return "Maximum up travel without binding (used by crow)."
  end
  return "Full travel without binding or stalling the servo."
end

local function startEndpoints()
  model.setInfo({ extendedLimits = true })
  local items = {}
  for _, ch in ipairs(surfaceChannels()) do
    for _, isMin in ipairs({ true, false }) do
      items[#items + 1] = { ch = ch, isMin = isMin, short = "CH" .. (ch + 1) .. " " .. (isMin and negWord(ch) or posWord(ch)),
        title = chName(ch), sub = isMin and negWord(ch) or posWord(ch),
        hint = (isMin and "Min limit. " or "Max limit. ") .. epHint(ch, isMin), hl = { [ch] = true } }
    end
  end
  go("calib", {
    title = "3 - Endpoints", items = items, doneKey = "d3",
    bind = function(it)
      local ch, isMin = it.ch, it.isMin
      local function apply(v)
        local o = getOut(ch)
        if isMin then o.min = v else o.max = v end
        setOut(ch, o)
      end
      local ofs = getOut(ch).offset
      return {
        get = function() local o = getOut(ch) return isMin and o.min or o.max end,
        apply = apply, commit = apply,
        -- a limit must stay at least 10% outside the subtrim, or the servo cannot move
        min = isMin and -1500 or math.max(100, ofs + 100), max = isMin and math.min(-100, ofs - 100) or 1500,
        coarse = 500, fine = 50, step = 5,
        fmt = fmtPct,
        extra = function(v)
          local o = getOut(ch)
          local s = (o.revert == 1) and -1 or 1
          return (1500 + o.ppmCenter + round(s * v * 0.512)) .. " us"
        end,
      }
    end,
    force = function(it)
      local t = {}
      t[it.ch] = it.isMin and -100 or 100
      calAll(0, t)
    end,
  })
end

---------------------------------------------------------------------------
-- 4 - Rates
---------------------------------------------------------------------------
local function startRates()
  local wingL = { [AIL_L] = true, [AIL_R] = true }
  local tail = { [TAIL_L] = true, [TAIL_R] = true }
  local items = {
    { key = "rateAil", short = "Ail", title = "Aileron", sub = "STICK RIGHT", hl = wingL,
      hint = "Surfaces shown as at full right aileron stick (no differential). 100% = endpoint." },
    { key = "rateEleUp", short = "Ele up", title = "Elevator", sub = "UP", hl = tail,
      hint = "As at full up elevator (stick back). 100% = endpoint." },
    { key = "rateEleDn", short = "Ele down", title = "Elevator", sub = "DOWN", hl = tail,
      hint = "As at full down elevator (stick forward). 100% = endpoint." },
    { key = "rateRud", short = "Rud", title = "Rudder", sub = "RIGHT", hl = tail,
      hint = "As at full right rudder. 100% = endpoint." },
  }
  if cfg.tail == 2 then items[4].hl = { [TAIL_R] = true } items[2].hl = { [TAIL_L] = true } items[3].hl = { [TAIL_L] = true } end
  go("calib", {
    title = "4 - Rates", items = items, doneKey = "d4",
    warnFn = function(it, v)
      if cfg.tail ~= 1 then return nil end
      local ele = math.max(cfg.rateEleUp, cfg.rateEleDn)
      if it.key == "rateEleUp" or it.key == "rateEleDn" then ele = v end
      local rud = (it.key == "rateRud") and v or cfg.rateRud
      if ele + rud > 100 then return "Elev + rudder " .. (ele + rud) .. "% > 100%: clipped" end
      return nil
    end,
    onDone = function() markChanged() end,
    bind = function(it)
      local key = it.key
      local orig = cfg[key]
      return {
        get = function() return cfg[key] end,
        apply = function(v) cfg[key] = v end,
        commit = function(v) if v ~= orig then cfg[key] = v markChanged() end end,
        min = 0, max = 100, coarse = 100, fine = 10, step = 1,
        fmt = function(v) return v .. "%" end,
      }
    end,
    force = function(it, v)
      local t = {}
      if it.key == "rateAil" then
        t[AIL_L] = -v t[AIL_R] = v
      elseif it.key == "rateEleUp" then
        t[TAIL_L] = v if cfg.tail == 1 then t[TAIL_R] = v end
      elseif it.key == "rateEleDn" then
        t[TAIL_L] = -v if cfg.tail == 1 then t[TAIL_R] = -v end
      else
        if cfg.tail == 1 then t[TAIL_L] = v t[TAIL_R] = -v else t[TAIL_R] = v end
      end
      calAll(0, t)
    end,
  })
end

---------------------------------------------------------------------------
-- 5 - Write setup
---------------------------------------------------------------------------
local writeResult = nil

screens.write = {
  enter = function() calOff() writeResult = nil end,
  run = function(event)
    buttons = {}
    header("5 - Write setup")
    local y = BAR_H + 8
    if writeResult then
      text(8, y, writeResult[2], MIDSIZE, writeResult[1] and C.ok or C.warn)
      y = y + 34
      if writeResult[1] then
        y = wrap(8, y, W - 16, "Written: inputs, mixes, flight modes (Cruise, Landing, Launch, Speed, Thermal), GV1-GV9, curves CV1-CV2, L01, special functions SF1-SF3, output names. Servo calibration was kept.", SMLSIZE, C.txt, 15)
        y = wrap(8, y + 6, W - 16, "Next: check every control in each flight mode, then tune with 6.", SMLSIZE, C.dim, 15)
        local tw = throwChecks()
        if #tw > 0 then
          text(8, y + 4, "Throw check - these add up to more than the endpoint (clipped):", SMLSIZE, C.acc)
          y = y + 19
          for i = 1, math.min(#tw, 4) do text(8, y, "- " .. tw[i], SMLSIZE, C.acc) y = y + 15 end
        else
          text(8, y + 4, "Throw check: no mix combination exceeds the endpoints.", SMLSIZE, C.ok)
        end
      end
      bottomRow({ { "Menu", function() go("menu") end, "hot" } })
    else
      y = wrap(8, y, W - 16, "This writes the complete setup into the current model: " .. model.getInfo().name, 0, C.txt, 20)
      y = wrap(8, y + 6, W - 16, "ALL mixes, inputs I1-I3, flight modes, GV names, curves CV1-CV2, L01 and SF1-SF3 are replaced. Servo direction, center and endpoints are kept. Tuned GV values are kept when rewriting.", SMLSIZE, C.dim, 15)
      local warn = {}
      if cfg.dP ~= 1 then warn[#warn + 1] = "Pilot setup (P) not done" end
      if cfg.d1 ~= 1 then warn[#warn + 1] = "Servo direction (1) not done" end
      if cfg.d3 ~= 1 then warn[#warn + 1] = "Endpoints (3) not done" end
      for _, w in ipairs(conflictChecks()) do warn[#warn + 1] = w end
      local shown = 0
      for _, w in ipairs(warn) do
        if shown < 5 then text(8, y + 4, "! " .. w, SMLSIZE, C.warn) y = y + 15 shown = shown + 1 end
      end
      if #warn > shown then text(8, y + 4, "! ... " .. (#warn - shown) .. " more", SMLSIZE, C.warn) y = y + 15 end
      text(8, y + 8, "Tip: back up the model first (Model > Copy).", SMLSIZE, C.dim)
      bottomRow({
        { "Cancel", function() go("menu") end },
        { "Write setup", function()
            local ok, m = writeSetup()
            writeResult = { ok, ok and m or ("Error: " .. m) }
            buttons = {}
          end, "hot" },
      })
    end
    focusNav(event)
    drawButtons()
    if event == EV_EXIT then go("menu") return end
    handleButtons(event)
  end,
}

---------------------------------------------------------------------------
-- 6 - Tuning
---------------------------------------------------------------------------
local tuneItems = {
  { label = "Differential (per FM)", gv = 1, help = "Aileron differential. Less down travel. Adjustable in flight with the diff trim (if set)." },
  { label = "Camber ailerons (per FM)", gv = 2, help = "Aileron camber offset in this flight mode. + = up (speed), - = down (thermal)." },
  { label = "Camber flaps (per FM)", gv = 3, wing4 = true, help = "Flap camber offset in this flight mode. + = up, - = down." },
  { label = "Aileron -> rudder (per FM)", gv = 4, help = "Rudder follows aileron (coordinated turns)." },
  { label = "Snapflap (per FM)", gv = 5, wing4 = true, help = "Flaps go down with up elevator. Off in Landing." },
  { label = "Aileron -> flaps (per FM)", gv = 6, wing4 = true, help = "Flaps follow ailerons for roll." },
  { label = "Crow: flaps down", gv = 7, wing4 = true, help = "Flap down travel at full crow. Same in all flight modes." },
  { label = "Crow: ailerons up", gv = 8, help = "Aileron up travel at full crow. Same in all flight modes." },
  { label = "Elevator at crow (curve)", curve = true, help = "Elevator compensation along the crow travel. 5 points from no crow to full crow. + = up." },
  { label = "Motor: elevator", gv = 9, motor = true, help = "Elevator offset while the motor runs (+ = up). Same in all flight modes." },
  { label = "Motor: max power", cfgKey = "motorMax", min = 10, max = 100, motor = true, help = "Max motor power in %. Applied when you Save (rewrites setup)." },
  { label = "Motor: soft start", cfgKey = "motorRamp", min = 0, max = 50, motor = true, unit = "s10", help = "Ramp-up time in 0.1 s. Applied when you Save." },
  { label = "Camber slider: ailerons", cfgKey = "slAil", min = 0, max = 30, help = "Camber slider range on ailerons (%). Applied when you Save." },
  { label = "Camber slider: flaps", cfgKey = "slFlap", min = 0, max = 30, wing4 = true, help = "Camber slider range on flaps (%). Applied when you Save." },
}

local tSel = 1
local tCurvePt = 1

local function tuneVisible(it)
  if it.wing4 and cfg.wing ~= 4 then return false end
  if it.motor and cfg.motor ~= 1 then return false end
  return true
end

local function visibleTuneItems()
  local t = {}
  for _, it in ipairs(tuneItems) do if tuneVisible(it) then t[#t + 1] = it end end
  return t
end

screens.tune = {
  enter = function() calOff() end,
  run = function(event)
    buttons = {}
    local items = visibleTuneItems()
    local fm, fmName = getFlightMode()
    header("6 - Tuning", "FM" .. fm .. " " .. (fmName ~= "" and fmName or (FM_NAMES[fm] or "")))
    if cfg.gvInit ~= 1 then
      wrap(8, BAR_H + 20, W - 16, "Write the setup (5) first. Tuning edits the values the setup uses.", 0, C.warn, 20)
      bottomRow({ { "Back", function() go("menu") end } })
      drawButtons()
      if event == EV_EXIT then go("menu") end
      handleButtons(event)
      return
    end
    local colW = math.floor((W - 18) / 2)
    local perCol = math.ceil(#items / 2)
    local rowH = math.floor((H - BAR_H - BTN_H - 50) / perCol)
    for i, it in ipairs(items) do
      local col = (i <= perCol) and 0 or 1
      local row = (i <= perCol) and (i - 1) or (i - 1 - perCol)
      button(6 + col * (colW + 6), BAR_H + 4 + row * rowH, colW, rowH - 3, it.label,
        function() tSel = i tCurvePt = 1 go("tuneEdit", it) end)
    end
    local tw = throwChecks()
    if #tw > 0 then
      text(8, H - BTN_H - 44, "Throw check: " .. tw[1], SMLSIZE, C.acc)
      if #tw > 1 then text(8, H - BTN_H - 29, "(+" .. (#tw - 1) .. " more - see 5 Write setup)", SMLSIZE, C.acc) end
    else
      wrap(8, H - BTN_H - 44, W - 16, "Per FM: switch the flight mode with its switch while you adjust. Each mode keeps its own value.", SMLSIZE, C.dim, 15)
    end
    bottomRow({ { "Back", function() go("menu") end } })
    focusNav(event)
    drawButtons()
    if event == EV_EXIT then go("menu") return end
    handleButtons(event)
  end,
}

local tIt = nil
local tSnap = nil
local tFm = nil

local function tuneBind()
  local it = tIt
  if it.gv then
    local g = it.gv
    local perFM = GV_PER_FM[g]
    tFm = getFlightMode()
    edStart({
      get = function() return model.getGlobalVariable(g - 1, perFM and tFm or 0) end,
      apply = function(v)
        if perFM then model.setGlobalVariable(g - 1, tFm, v)
        else for fm = 0, 8 do model.setGlobalVariable(g - 1, fm, v) end end
      end,
      min = GV_RANGE[g][1], max = GV_RANGE[g][2], coarse = 50, fine = 5, step = 1,
      fmt = function(v) return v .. "%" end,
    })
  elseif it.curve then
    local key = "ce" .. tCurvePt
    edStart({
      get = function() return cfg[key] end,
      apply = function(v) cfg[key] = v model.setCurve(1, { name = "CrE", type = 0, smooth = false, y = crowElevY() }) end,
      min = -50, max = 50, coarse = 50, fine = 5, step = 1,
      fmt = function(v) return v .. "%" end,
    })
  else
    local key = it.cfgKey
    edStart({
      get = function() return cfg[key] end,
      apply = function(v) cfg[key] = v end,
      min = it.min, max = it.max, coarse = it.max - it.min, fine = math.max(2, math.floor((it.max - it.min) / 10)), step = 1,
      fmt = function(v)
        if it.unit == "s10" then return string.format("%.1f s", v / 10) end
        return v .. "%"
      end,
    })
  end
end

local function tuneRestore()
  if not tIt then return end
  if tIt.gv then
    for fm = 0, 8 do model.setGlobalVariable(tIt.gv - 1, fm, tSnap[fm]) end
  elseif tIt.curve then
    for i = 1, 5 do cfg["ce" .. i] = tSnap[i] end
    model.setCurve(1, { name = "CrE", type = 0, smooth = false, y = crowElevY() })
  else
    cfg[tIt.cfgKey] = tSnap
  end
end

local function tuneSave()
  if tIt.gv then
    -- values already live
  elseif tIt.curve then
    saveCfg()
  else
    saveCfg()
    writeSetup()
  end
  saveCfg()
end

screens.tuneEdit = {
  enter = function(it)
    tIt = it
    if it.gv then
      tSnap = {}
      for fm = 0, 8 do tSnap[fm] = model.getGlobalVariable(it.gv - 1, fm) end
    elseif it.curve then
      tSnap = {}
      for i = 1, 5 do tSnap[i] = cfg["ce" .. i] end
    else
      tSnap = cfg[it.cfgKey]
    end
    tuneBind()
  end,
  run = function(event)
    buttons = {}
    local it = tIt
    local fm, fmName = getFlightMode()
    if it.gv and GV_PER_FM[it.gv] and fm ~= tFm then tuneBind() end
    edUpdate(event)
    local right = (it.gv and GV_PER_FM[it.gv]) and ("FM" .. fm .. " " .. (fmName ~= "" and fmName or "")) or "all modes"
    header("6 - Tuning", right)
    text(8, BAR_H + 4, it.label, MIDSIZE, C.txt)
    local y = wrap(8, BAR_H + 32, it.curve and (W - 186) or (W - 16), it.help, SMLSIZE, C.dim, 15)
    if it.curve then
      local names = { "no crow", "25%", "50%", "75%", "full crow" }
      text(8, y + 4, "Point " .. tCurvePt .. " of 5 (" .. names[tCurvePt] .. ")", 0, C.acc)
      -- mini curve
      local cx, cy, cw, ch = W - 170, y + 2, 160, 70
      rect(cx, cy, cw, ch, C.panel)
      rect(cx, cy + ch / 2, cw, 1, C.dim)
      local prevx, prevy
      for i = 1, 5 do
        local v = cfg["ce" .. i]
        local px = cx + (i - 1) * (cw - 1) / 4
        local py = cy + ch / 2 - v * (ch / 2 - 2) / 50
        if prevx then line(prevx, prevy, px, py, C.acc) end
        rect(px - 2, py - 2, 5, 5, i == tCurvePt and C.warn or C.acc)
        prevx, prevy = px, py
      end
      y = y + 24
    end
    text(8, y + 6, ed.fmt(ed.value), DBLSIZE, C.acc)
    edDrawBar(8, y + 50, it.curve and (W - 190) or (W - 16), ed, ed.fmt)
    edStatusLine(8, H - BTN_H - 24)
    local row = {
      { "Cancel", function() tuneRestore() go("tune") end },
      { "Reset pot", function() edResetPot() end },
    }
    if it.curve then
      row[#row + 1] = { "Point >", function() tCurvePt = (tCurvePt % 5) + 1 tuneBind() end }
    end
    row[#row + 1] = { "Save", function() tuneSave() go("tune") end, "hot" }
    bottomRow(row)
    drawButtons()
    if event == EV_EXIT then tuneRestore() go("tune") return end
    if event == EV_ENTER then tuneSave() go("tune") return end
    if it.curve and (event == EV_PGN) then tCurvePt = (tCurvePt % 5) + 1 tuneBind() end
    if it.curve and (event == EV_PGP) then tCurvePt = (tCurvePt > 1) and tCurvePt - 1 or 5 tuneBind() end
    if event == EV_TAP then handleButtons(event) end
  end,
}

---------------------------------------------------------------------------
-- 7 - Checklist
---------------------------------------------------------------------------
local CHECKS = {
  "Servo directions OK", "Throws checked",
  "CG checked", "Flight modes OK",
  "Crow OK, off w/ motor", "Motor OFF at power-up",
  "Failsafe: motor off", "Range check done",
  "Batteries charged", "Model backed up",
}

screens.check = {
  enter = function() calOff() end,
  run = function(event)
    buttons = {}
    local s = stepState("ck")
    header("7 - Checklist", s)
    local colW = math.floor((W - 18) / 2)
    local rowH = math.floor((H - BAR_H - BTN_H - 20) / 5)
    for i = 0, 9 do
      local on = bit32.band(cfg.ck, bit32.lshift(1, i)) ~= 0
      local col = math.floor(i / 5)
      local row = i % 5
      button(6 + col * (colW + 6), BAR_H + 6 + row * rowH, colW, rowH - 4,
        (on and "[x] " or "[ ] ") .. CHECKS[i + 1],
        function() cfg.ck = bit32.bxor(cfg.ck, bit32.lshift(1, i)) end, on and "go" or nil)
    end
    bottomRow({
      { "Back", function() saveCfg() go("menu") end },
      { "Clear all", function() cfg.ck = 0 end },
    })
    focusNav(event)
    drawButtons()
    if event == EV_EXIT then saveCfg() go("menu") return end
    handleButtons(event)
  end,
}

---------------------------------------------------------------------------
-- E - ESC calibration
---------------------------------------------------------------------------
local escStage = 0

screens.esc = {
  enter = function() escStage = 0 calAll(0) end,
  run = function(event)
    buttons = {}
    header("E - ESC calibration", "CH7")
    if cfg.motor ~= 1 or cfg.swMotor == 0 then
      wrap(8, BAR_H + 20, W - 16, (cfg.motor ~= 1) and "No motor selected in Airframe (0)." or
        "Set the motor switch in Pilot setup (P) first.", 0, C.warn, 20)
      bottomRow({ { "Back", function() go("menu") end } })
    elseif escStage == 0 then
      calAll(0, { [MOT] = -100 })
      text(8, BAR_H + 10, "REMOVE THE PROPELLER!", DBLSIZE, C.warn)
      wrap(8, BAR_H + 60, W - 16, "Disconnect the flight battery and set the motor switch (" .. swName(cfg.swMotor) ..
        ") OFF. Only continue when the propeller is off the motor.", 0, C.txt, 20)
      bottomRow({ { "Cancel", function() go("menu") end },
        { "Propeller removed", function() escStage = 1 end, "warn" } })
    elseif escStage == 1 then
      -- OFF, but FULL while the motor switch is ON (switch off = instant cut)
      calAll(0, { [MOT] = { { w = -100 }, { w = 100, sw = cfg.swMotor } } })
      local full = getSwitchValue(cfg.swMotor)
      text(8, BAR_H + 10, full and "Throttle output: FULL" or "Throttle output: OFF", MIDSIZE, full and C.warn or C.ok)
      wrap(8, BAR_H + 44, W - 16, "1. Motor switch (" .. swName(cfg.swMotor) .. ") ON = full throttle. 2. Connect the battery, wait for the 'full throttle' beeps. 3. Motor switch OFF, wait for the confirmation beeps. Then Next.", 0, C.txt, 20)
      bottomRow({ { "Abort (motor off)", function() calAll(0, { [MOT] = -100 }) go("menu") end, "warn" },
        { "Next", function() escStage = 2 end, "hot" } })
    else
      calAll(0, { [MOT] = -100 })
      text(8, BAR_H + 10, "Throttle output: OFF", MIDSIZE, C.ok)
      wrap(8, BAR_H + 44, W - 16, "Calibration is done. Disconnect the battery before refitting the propeller. The motor switch now works normally after 5 Write setup.", 0, C.txt, 20)
      bottomRow({ { "Done", function() cfg.dE = 1 saveCfg() go("menu") end, "go" } })
    end
    focusNav(event)
    drawButtons()
    if event == EV_EXIT then go("menu") return end
    handleButtons(event)
  end,
}

---------------------------------------------------------------------------
-- Screen entry points that need setup
---------------------------------------------------------------------------
screens.center = { enter = function() startCenter() end }
screens.endpt  = { enter = function() startEndpoints() end }
screens.rates  = { enter = function() startRates() end }

---------------------------------------------------------------------------
-- EdgeTX entry points
---------------------------------------------------------------------------
local initErr = nil

local function init()
  initColors()
  initScale()
  local ok, err = pcall(function()
    loadCfg()
    calOff()      -- remove leftovers from an interrupted session
  end)
  if not ok then initErr = tostring(err) end
  screen = "menu"
end

local function run(event, touchState)
  if initErr then
    lcd.clear()
    lcd.drawText(8, 8, "Glider Setup error:", 0)
    lcd.drawText(8, 30, initErr, SMLSIZE)
    if event == EV_EXIT then return 1 end
    return 0
  end
  touchX, touchY = nil, nil
  if touchState and touchState.x then touchX, touchY = touchState.x / SX, touchState.y / SY end
  lcd.clear()
  local s = screens[screen]
  if s and s.run then s.run(event) end
  if exitRequested then
    calOff()
    saveCfg()
    return 1
  end
  return 0
end

return { init = init, run = run, useLvgl = false }

--[[
##############################################################################
_____/\\\\\\\\\\\____/\\\________/\\\__/\\\________/\\\__/\\\\\\\\\\\_       #
 ___/\\\/////////\\\_\/\\\_______\/\\\_\/\\\_______\/\\\_\/////\\\///__      #
  __\//\\\______\///__\//\\\______/\\\__\/\\\_______\/\\\_____\/\\\_____     #
   ___\////\\\__________\//\\\____/\\\___\/\\\_______\/\\\_____\/\\\_____    #
    ______\////\\\________\//\\\__/\\\____\/\\\_______\/\\\_____\/\\\_____   #
     _________\////\\\______\//\\\/\\\_____\/\\\_______\/\\\_____\/\\\_____  #
      __/\\\______\//\\\______\//\\\\\______\//\\\______/\\\______\/\\\_____ #
       _\///\\\\\\\\\\\/________\//\\\________\///\\\\\\\\\/____/\\\\\\\\\\\_#
        ___\///////////___________\///___________\/////////_____\///////////_#
##############################################################################
S U P E R - V I L L A I N - U I   By: Munglunch                              #
##############################################################################
--]]
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain:GetModule('SVBar');
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local tcopy = table.copy;
local defaultConfig = {
  outOfRangeColoring = "button",
  tooltip = "enable",
  showGrid = true,
  colors = {
    range = {0.8, 0.1, 0.1},
    mana = {0.5, 0.5, 1.0},
    hp = {0.5, 0.5, 1.0}
  },
  hideElements = {
    macro = false,
    hotkey = false,
    equipped = false
  },
  keyBoundTarget = false,
  clickOnDown = false
};
local idList = {'Bar1','Bar2','Bar3','Bar4','Bar5','Bar6','Pet','Stance'};
--[[ 
########################################################## 
CONSTANTS
##########################################################
]]--
SVUI_BAR6_PAGE = 2;
--[[ 
########################################################## 
BUILD FUNCTIONED DATA
##########################################################
]]--
MOD.BarPresets = {};
MOD.BarStates = {};
MOD.BarConfig = {};
MOD.Storage = {};
MOD.ButtonCache = {};
for _,id in pairs(idList) do
  MOD.Storage[id] = {};
  MOD.Storage[id]["bar"] = {};
  MOD.Storage[id]["buttons"] = {};
  MOD.BarConfig[id] = tcopy(defaultConfig, true)
end;
--[[ 
########################################################## 
MODULE DATA
##########################################################
]]--
MOD.BarStates = {
  ['Bar1'] = "",
  ['Bar2'] = "",
  ['Bar3'] = "",
  ['Bar4'] = "",
  ['Bar5'] = "",
  ['Bar6'] = "",
};

MOD.BarPresets = {
  ['Bar1'] = {
    ["page"]     = CURRENT_ACTIONBAR_PAGE,
    ["max"]      = [[NUM_ACTIONBAR_BUTTONS]],
    ["binding"]  = "ACTIONBUTTON%d",
    ["setpoint"] = {"BOTTOM","SVUIParent","BOTTOM",0,28},
    ["ready"]    = false
  },
  ['Bar2'] = {
    ["page"]     = BOTTOMRIGHT_ACTIONBAR_PAGE,
    ["max"]      = [[NUM_ACTIONBAR_BUTTONS]],
    ["binding"]  = "MULTIACTIONBAR2BUTTON%d",
    ["setpoint"] = {"BOTTOM","SVUI_ActionBar1","TOP",0,2},
    ["ready"]    = false
  },
  ['Bar3'] = {
    ["page"]     = BOTTOMLEFT_ACTIONBAR_PAGE,
    ["max"]      = [[NUM_ACTIONBAR_BUTTONS]],
    ["binding"]  = "MULTIACTIONBAR1BUTTON%d",
    ["setpoint"] = {"BOTTOMLEFT","SVUI_ActionBar1","BOTTOMRIGHT",2,0},
    ["ready"]    = false
  },
  ['Bar4'] = {
    ["page"]     = LEFT_ACTIONBAR_PAGE,
    ["max"]      = [[NUM_ACTIONBAR_BUTTONS]],
    ["binding"]  = "MULTIACTIONBAR4BUTTON%d",
    ["setpoint"] = {"RIGHT","SVUIParent","RIGHT",-2,0},
    ["ready"]    = false
  },
  ['Bar5'] = {
    ["page"]     = RIGHT_ACTIONBAR_PAGE,
    ["max"]      = [[NUM_ACTIONBAR_BUTTONS]],
    ["binding"]  = "MULTIACTIONBAR3BUTTON%d",
    ["setpoint"] = {"BOTTOMRIGHT","SVUI_ActionBar1","BOTTOMLEFT",2,0},
    ["ready"]    = false
  },
  ['Bar6'] = {
    ["page"]     = 2,
    ["max"]      = [[NUM_ACTIONBAR_BUTTONS]],
    ["binding"]  = "SVUIACTIONBAR6BUTTON%d",
    ["setpoint"] = {"BOTTOM","SVUI_ActionBar2","TOP",0,2},
    ["ready"]    = false
  },
  ['Pet']  = {
    ["page"]     = false,
    ["max"]      = [[NUM_PET_ACTION_SLOTS]],
    ["binding"]  = "BONUSACTIONBUTTON%d",
    ["setpoint"] = {"BOTTOMLEFT","SVUI_ActionBar1","TOPLEFT",0,2},
    ["ready"]    = false
  },
  ['Stance'] = {
    ["page"]     = false,
    ["max"]      = [[NUM_STANCE_SLOTS]],
    ["binding"]  = "CLICK SVUI_StanceBarButton%d:LeftButton",
    ["setpoint"] = {"BOTTOMRIGHT","SVUI_ActionBar1","TOPRIGHT",0,2},
    ["ready"]    = false
  },
};
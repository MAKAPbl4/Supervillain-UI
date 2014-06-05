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

STATS:Extend EXAMPLE USAGE: MOD:Extend(newStat,eventList,onEvents,update,click,focus,blur)

########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack 	= _G.unpack;
local select 	= _G.select;
local pairs 	= _G.pairs;
local ipairs 	= _G.ipairs;
local type 		= _G.type;
local error 	= _G.error;
local pcall 	= _G.pcall;
local assert 	= _G.assert;
local tostring 	= _G.tostring;
local tonumber 	= _G.tonumber;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local lower, upper = string.lower, string.upper;
local find, format, len, split = string.find, string.format, string.len, string.split;
local match, sub, join = string.match, string.sub, string.join;
local gmatch, gsub = string.gmatch, string.gsub;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;  -- Basic
--[[ TABLE METHODS ]]--
local twipe, tsort = table.wipe, table.sort;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain:GetModule('SVStats');
local LSM = LibStub("LibSharedMedia-3.0");
--[[ 
########################################################## 
EXPERIENCE STATS
##########################################################
]]--
local StatEvents = {"PLAYER_ENTERING_WORLD", "PLAYER_XP_UPDATE", "PLAYER_LEVEL_UP", "DISABLE_XP_GAIN", "ENABLE_XP_GAIN", "UPDATE_EXHAUSTION"};

local function getUnitXP(unit)
	if unit == "pet"then
		return GetPetExperience()
	else
		return UnitXP(unit),UnitXPMax(unit)
	end 
end;

local function Experience_OnEvent(self, ...)
	if self.barframe:IsShown()then
		self.text:SetAllPoints(self)
		self.text:SetJustifyH("CENTER")
		self.barframe:Hide()
		self.text:SetFontTemplate(LSM:Fetch("font",SuperVillain.db.SVStats.font),SuperVillain.db.SVStats.fontSize,SuperVillain.db.SVStats.fontOutline)
	end;
	local f, g = getUnitXP("player")
	local h = GetXPExhaustion()
	local i = ""
	if h and h > 0 then
		i = format("%s - %d%% R:%s [%d%%]", TruncateNumericString(f), f / g * 100, TruncateNumericString(h), h / g * 100)
	else
		i = format("%s - %d%%", TruncateNumericString(f), f / g * 100)
	end;
	self.text:SetText(i)
end;

local function ExperienceBar_OnEvent(self, ...)
	if ((UnitLevel("player") ~= GetMaxPlayerLevel()) and not self.barframe:IsShown())then
		self.barframe:Show()
		self.barframe.icon.texture:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Icons\\XP-BAR-ICON")
		self.text:SetFontTemplate(LSM:Fetch("font",SuperVillain.db.SVStats.font),SuperVillain.db.SVStats.fontSize,"NONE")
	end;
	if not self.barframe.bar.extra:IsShown() then
		self.barframe.bar.extra:Show()
	end;
	local k = self.barframe.bar;
	local f, g = getUnitXP("player")
	k:SetMinMaxValues(0, g)
	k:SetValue((f - 1) >= 0 and (f - 1) or 0)
	k:SetStatusBarColor(0, 0.5, 1)
	local h = GetXPExhaustion()
	if h and h>0 then
		k.extra:SetMinMaxValues(0, g)
		k.extra:SetValue(min(f + h, g))
		k.extra:SetStatusBarColor(0.8, 0.5, 1)
		k.extra:SetAlpha(0.5)
	else
		k.extra:SetMinMaxValues(0, 1)
		k.extra:SetValue(0)
	end;
	self.text:SetText("")
end;

local function Experience_OnEnter(self)
	MOD:Tip(self)
	local f, g = getUnitXP("player")
	local h = GetXPExhaustion()
	MOD.tooltip:AddLine(L["Experience"])
	MOD.tooltip:AddLine(" ")
	MOD.tooltip:AddDoubleLine(L["XP:"], format(" %d  /  %d (%d%%)", f, g, f / g * 100), 1, 1, 1)
	MOD.tooltip:AddDoubleLine(L["Remaining:"], format(" %d (%d%% - %d "..L["Bars"]..")", g-f, (g-f) / g * 100, 20 * g-f / g), 1, 1, 1)
	if h then
		MOD.tooltip:AddDoubleLine(L["Rested:"], format(" + %d (%d%%)", h, h / g * 100), 1, 1, 1)
	end;
	MOD:ShowTip()
end;

MOD:Extend("Experience", StatEvents, Experience_OnEvent, nil, nil, Experience_OnEnter)
MOD:Extend("Experience Bar", StatEvents, ExperienceBar_OnEvent, nil, nil, Experience_OnEnter)
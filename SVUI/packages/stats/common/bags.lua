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
--[[ 
########################################################## 
BAG STATS
##########################################################
]]--
local StatEvents = {"PLAYER_ENTERING_WORLD", "BAG_UPDATE"};

local bags_text = "";
local currentObject;

local function bags_events(this, e, ...)
	local f, g, h = 0, 0, 0;
	currentObject = this;
	for i = 0, NUM_BAG_SLOTS do 
		f, g = f + GetContainerNumFreeSlots(i),
		g + GetContainerNumSlots(i)
	end;
	h = g - f;
	this.text:SetFormattedText(bags_text, L["Bags"]..": ", h, g)
end;

local function bags_click()
	ToggleAllBags()
end;

local function bags_focus(this)
	MOD:Tip(this)
	for i = 1, MAX_WATCHED_TOKENS do 
		local l, m, n, o, p = GetBackpackCurrencyInfo(i)
		if l and i == 1 then 
			MOD.tooltip:AddLine(CURRENCY)
			MOD.tooltip:AddLine(" ")
		end;
		if l and m then 
			MOD.tooltip:AddDoubleLine(l, m, 1, 1, 1)
		end 
	end;
	MOD:ShowTip()
end;

local BagsColorUpdate = function()
	local r = SuperVillain.Colors:Hex("highlight");
	local s, t, u = unpack(SuperVillain.Colors.highlight)
	bags_text = join("", "%s", r, "%d / %d|r")
	if currentObject  ~= nil then
		bags_events(currentObject)
	end 
end;

SuperVillain.Colors:Register(BagsColorUpdate)
MOD:Extend("Bags", StatEvents,	bags_events, nil, bags_click, bags_focus);
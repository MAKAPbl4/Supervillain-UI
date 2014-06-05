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
DURABILITY STATS
##########################################################
]]--
local StatEvents = {"PLAYER_ENTERING_WORLD", "UPDATE_INVENTORY_DURABILITY", "MERCHANT_SHOW"};

local durabilityText = "";
local overall = 0;
local min, max, currentObject;
local equipment = {}
local inventoryMap = {
	["SecondaryHandSlot"] = L["Offhand"],
	["MainHandSlot"] = L["Main Hand"],
	["FeetSlot"] = L["Feet"],
	["LegsSlot"] = L["Legs"],
	["HandsSlot"] = L["Hands"],
	["WristSlot"] = L["Wrist"],
	["WaistSlot"] = L["Waist"],
	["ChestSlot"] = L["Chest"],
	["ShoulderSlot"] = L["Shoulder"],
	["HeadSlot"] = L["Head"]
}

local function Durability_OnEvent(self, ...)
	currentObject = self;
	overall = 100;
	if self.barframe:IsShown() then
		self.text:SetAllPoints(self)
		self.text:SetJustifyH("CENTER")
		self.barframe:Hide()
		self.text:SetFontTemplate(LSM:Fetch("font",SuperVillain.db.SVStats.font),SuperVillain.db.SVStats.fontSize,SuperVillain.db.SVStats.fontOutline)
	end;
	for slot,name in pairs(inventoryMap)do 
		local slotID = GetInventorySlotInfo(slot)
		min,max = GetInventoryItemDurability(slotID)
		if min then
			equipment[name] = min / max * 100;
			if min / max * 100 < overall then
				overall = min / max * 100 
			end 
		end 
	end;
	self.text:SetFormattedText(durabilityText, overall)
end;

local function DurabilityBar_OnEvent(self, ...)
	currentObject = self;
	overall = 100;
	if not self.barframe:IsShown() then 
		self.barframe:Show()
		self.barframe.icon.texture:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Icons\\DUR-BAR-ICON")
		self.text:SetFontTemplate(LSM:Fetch("font",SuperVillain.db.SVStats.font),SuperVillain.db.SVStats.fontSize,"NONE")
	end;
	for slot,name in pairs(inventoryMap)do 
		local slotID = GetInventorySlotInfo(slot)
		min,max = GetInventoryItemDurability(slotID)
		if min then 
			equipment[name] = min / max * 100;
			if min / max * 100 < overall then 
				overall = min / max * 100 
			end 
		end 
	end;
	local newRed = (100 - overall) * 0.01;
	local newGreen = overall * 0.01;
	self.barframe.bar:SetMinMaxValues(0, 100)
	self.barframe.bar:SetValue(overall)
	self.barframe.bar:SetStatusBarColor(newRed, newGreen, 0)
	self.text:SetText('')
end;

local function Durability_OnClick()
	ToggleCharacter("PaperDollFrame")
end;

local function Durability_OnEnter(self)
	MOD:Tip(self)
	for name,amt in pairs(equipment)do
		MOD.tooltip:AddDoubleLine(name, format("%d%%", amt),1, 1, 1, SuperVillain:ColorGradient(amt * 0.01, 1, 0, 0, 1, 1, 0, 0, 1, 0))
	end;
	MOD:ShowTip()
end;

local DurColorUpdate = function()
	local hexColor = SuperVillain.Colors:Hex("highlight");
	durabilityText = join("", DURABILITY, ": ", hexColor, "%d%%|r")
	if currentObject ~= nil then
		Durability_OnEvent(currentObject)
	end 
end;
SuperVillain.Colors:Register(DurColorUpdate)

MOD:Extend("Durability", StatEvents, Durability_OnEvent, nil, Durability_OnClick, Durability_OnEnter)
MOD:Extend("Durability Bar", StatEvents, DurabilityBar_OnEvent, nil, Durability_OnClick, Durability_OnEnter)
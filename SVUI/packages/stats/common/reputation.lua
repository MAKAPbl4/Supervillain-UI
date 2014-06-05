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
REPUTATION STATS
##########################################################
]]--
local StatEvents = {"PLAYER_ENTERING_WORLD","UPDATE_FACTION"};

local standingName = {
	[1] = "Hated",
	[2] = "Hostile",
	[3] = "Unfriendly",
	[4] = "Neutral",
	[5] = "Friendly",
	[6] = "Honored",
	[7] = "Revered",
	[8] = "Exalted"
};

local function Reputation_OnEvent(self, ...)
	if self.barframe:IsShown()then 
		self.text:SetAllPoints(self)
		self.text:SetJustifyH("CENTER")
		self.barframe:Hide()
		self.text:SetAlpha(1)
		self.text:SetFontTemplate(LSM:Fetch("font",SuperVillain.db.SVStats.font),SuperVillain.db.SVStats.fontSize,SuperVillain.db.SVStats.fontOutline)
	end;
	local ID = 100
	local isFriend, friendText
	local name, reaction, min, max, value = GetWatchedFactionInfo()
	local numFactions = GetNumFactions();
	local txt = ""
	if not name then 
		txt = "No watched factions"
	else
		for i=1, numFactions do
			local factionName, _, standingID,_,_,_,_,_,_,_,_,_,_, factionID = GetFactionInfo(i);
			local friendID, friendRep, friendMaxRep, _, _, _, friendTextLevel = GetFriendshipReputation(factionID);
			if factionName == name then
				if friendID ~= nil then
					isFriend = true
					friendText = friendTextLevel
				else
					ID = standingID
				end
			end
		end
		txt = format("%s: %s - %d%% [%s]", name, TruncateNumericString(value - min), ((value - min) / (max - min) * 100), isFriend and friendText or _G["FACTION_STANDING_LABEL"..ID])
	end;
	self.text:SetText(txt)
end;

local function ReputationBar_OnEvent(self, ...)
	if not self.barframe:IsShown()then 
		self.barframe:Show()
		self.barframe.icon.texture:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Icons\\REP-BAR-ICON")
		self.text:SetAlpha(0.5)
		self.text:SetFontTemplate(LSM:Fetch("font",SuperVillain.db.SVStats.font),SuperVillain.db.SVStats.fontSize,"NONE")
	end;
	local bar = self.barframe.bar;
	local name, reaction, min, max, value = GetWatchedFactionInfo()
	local j = GetNumFactions()
	if not name then 
		bar:SetStatusBarColor(0,0,0)
		bar:SetMinMaxValues(0,1)
		bar:SetValue(0)
		self.text:SetText("No Faction")
	else 
		local txt = standingName[reaction];
		local color = FACTION_BAR_COLORS[reaction]
		bar:SetStatusBarColor(color.r, color.g, color.b)
		bar:SetMinMaxValues(min, max)
		bar:SetValue(value)
		self.text:SetText(txt)
	end;
end;

local function Reputation_OnEnter(self)
	MOD:Tip(self)
	local name, reaction, min, max, value, factionID = GetWatchedFactionInfo()
	local friendID, _, _, _, _, _, friendTextLevel = GetFriendshipReputation(factionID);
	if not name then
		MOD.tooltip:AddLine("No Watched Factions")
	else
		MOD.tooltip:AddLine(name)
		MOD.tooltip:AddLine(' ')
		MOD.tooltip:AddDoubleLine(STANDING..':', friendID and friendTextLevel or _G['FACTION_STANDING_LABEL'..reaction], 1, 1, 1)
		MOD.tooltip:AddDoubleLine(REPUTATION..':', format('%d / %d (%d%%)', value - min, max - min, (value - min) / (max - min) * 100), 1, 1, 1)
	end;
	MOD:ShowTip()
end;

MOD:Extend('Reputation',StatEvents,Reputation_OnEvent,nil,nil,Reputation_OnEnter)
MOD:Extend('Reputation Bar',StatEvents,ReputationBar_OnEvent,nil,nil,Reputation_OnEnter)
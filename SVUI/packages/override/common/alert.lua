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
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack 	= _G.unpack;
local select 	= _G.select;
local pairs 	= _G.pairs;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
--[[ STRING METHODS ]]--
local find, format, len, split = string.find, string.format, string.len, string.split;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, G = unpack(select(2, ...));
local MOD = SuperVillain:GetModule('SVOverride');
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local POSITION, ANCHOR_POINT, YOFFSET = "TOP", "BOTTOM", -10
local FORCE_POSITION = false;
--[[ 
########################################################## 
PRE VARS/FUNCTIONS
##########################################################
]]--
function SuperVillain:PostAlertMove(forced)
	local b, c = SVUI_AlertFrame_MOVE:GetCenter()
	local d = SuperVillain.UIParent:GetTop()
	if(c > (d / 2)) then
		POSITION = "TOP"
		ANCHOR_POINT = "BOTTOM"
		YOFFSET = -10;
		SVUI_AlertFrame_MOVE:SetText(SVUI_AlertFrame_MOVE.textString.." (Grow Down)")
	else
		POSITION = "BOTTOM"
		ANCHOR_POINT = "TOP"
		YOFFSET = 10;
		SVUI_AlertFrame_MOVE:SetText(SVUI_AlertFrame_MOVE.textString.." (Grow Up)")
	end;
	if SuperVillain.protected.SVOverride.lootRoll then 
		local f, g;
		for h, i in pairs(MOD.LewtRollz) do
			i:ClearAllPoints()
			if h  ~= 1 then
				if POSITION == "TOP" then 
					i:Point("TOP", f, "BOTTOM", 0, -4)
				else
					i:Point("BOTTOM", f, "TOP", 0, 4)
				end 
			else
				if POSITION == "TOP" then
					i:Point("TOP", SVUI_AlertFrame, "BOTTOM", 0, -4)
				else
					i:Point("BOTTOM", SVUI_AlertFrame, "TOP", 0, 4)
				end 
			end;
			f = i;
			if i:IsShown() then
				g = i 
			end 
		end;
		AlertFrame:ClearAllPoints()
		if g then
			AlertFrame:SetAllPoints(g)
		else
			AlertFrame:SetAllPoints(SVUI_AlertFrame)
		end 
	else
		AlertFrame:ClearAllPoints()
		AlertFrame:SetAllPoints(SVUI_AlertFrame)
	end;
	if forced then
		FORCE_POSITION = true;
		AlertFrame_FixAnchors()
		FORCE_POSITION = false 
	end 
end;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:AlertFrame_SetLootAnchors(parent)
	if MissingLootFrame:IsShown() then
		MissingLootFrame:ClearAllPoints()
		MissingLootFrame:SetPoint(POSITION, parent, ANCHOR_POINT)
		if GroupLootContainer:IsShown() then
			GroupLootContainer:ClearAllPoints()
			GroupLootContainer:SetPoint(POSITION, MissingLootFrame, ANCHOR_POINT, 0, YOFFSET)
		end 
	elseif GroupLootContainer:IsShown() or FORCE_POSITION then 
		GroupLootContainer:ClearAllPoints()
		GroupLootContainer:SetPoint(POSITION, parent, ANCHOR_POINT)
	end 
end;

function MOD:AlertFrame_SetLootWonAnchors(parent)
	for i = 1, #LOOT_WON_ALERT_FRAMES do 
		local frame = LOOT_WON_ALERT_FRAMES[i]
		if frame:IsShown() then
			frame:ClearAllPoints()
			frame:SetPoint(POSITION, parent, ANCHOR_POINT, 0, YOFFSET)
			parent = frame 
		end 
	end 
end;

function MOD:AlertFrame_SetMoneyWonAnchors(parent)
	for i = 1, #MONEY_WON_ALERT_FRAMES do 
		local frame = MONEY_WON_ALERT_FRAMES[i]
		if frame:IsShown() then
			frame:ClearAllPoints()
			frame:SetPoint(POSITION, parent, ANCHOR_POINT, 0, YOFFSET)
			parent = frame 
		end 
	end 
end;

function MOD:AlertFrame_SetAchievementAnchors(parent)
	if AchievementAlertFrame1 then
		for i = 1, MAX_ACHIEVEMENT_ALERTS do 
			local frame = _G["AchievementAlertFrame"..i]
			if frame and frame:IsShown() then
				frame:ClearAllPoints()
				frame:SetPoint(POSITION, parent, ANCHOR_POINT, 0, YOFFSET)
				parent = frame 
			end 
		end 
	end 
end;

function MOD:AlertFrame_SetCriteriaAnchors(parent)
	if CriteriaAlertFrame1 then
		for i = 1, MAX_ACHIEVEMENT_ALERTS do 
			local frame = _G["CriteriaAlertFrame"..i]
			if frame and frame:IsShown() then
				frame:ClearAllPoints()
				frame:SetPoint(POSITION, parent, ANCHOR_POINT, 0, YOFFSET)
				parent = frame 
			end 
		end 
	end 
end;

function MOD:AlertFrame_SetChallengeModeAnchors(parent)
	local frame = ChallengeModeAlertFrame1;
	if frame:IsShown() then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, parent, ANCHOR_POINT, 0, YOFFSET)
	end 
end;

function MOD:AlertFrame_SetDungeonCompletionAnchors(parent)
	local frame = DungeonCompletionAlertFrame1;
	if frame:IsShown() then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, parent, ANCHOR_POINT, 0, YOFFSET)
	end 
end;

function MOD:AlertFrame_SetStorePurchaseAnchors(parent)
	local frame = StorePurchaseAlertFrame;
	if frame:IsShown() then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, parent, ANCHOR_POINT, 0, YOFFSET)
	end 
end;

function MOD:AlertFrame_SetScenarioAnchors(parent)
	local frame = ScenarioAlertFrame1;
	if frame:IsShown() then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, parent, ANCHOR_POINT, 0, YOFFSET)
	end 
end;

function MOD:AlertFrame_SetGuildChallengeAnchors(parent)
	local frame = GuildChallengeAlertFrame;
	if frame:IsShown() then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, parent, ANCHOR_POINT, 0, YOFFSET)
	end 
end;

function MOD:CreateAlertOverride()
	local afrm = CreateFrame("Frame", "SVUI_AlertFrame", SuperVillain.UIParent);
	afrm:SetWidth(180);
	afrm:SetHeight(20);
	afrm:SetPoint("TOP", SuperVillain.UIParent, "TOP", 0, -18);
	SuperVillain:SetSVMovable(SVUI_AlertFrame,"SVUI_AlertFrame_MOVE",L["Loot / Alert Frames"],nil,nil,SuperVillain.PostAlertMove);
end;
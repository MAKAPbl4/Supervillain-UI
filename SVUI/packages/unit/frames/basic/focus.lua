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
local SuperVillain, L, P, C, G = unpack(select(2, ...));
local MOD = SuperVillain:GetModule('SVUnit');
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.")
local LSM = LibStub("LibSharedMedia-3.0");
local tinsert = table.insert
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function MOD:CreateFrame_Focus(frame)
	MOD:SetActionPanel(frame)
	frame.Health=MOD:CreateHealthBar(frame,true,true,'RIGHT')
	frame.Health.frequentUpdates=true;
	MOD:SetActionPanelIcons(frame, true)
	frame.Power=MOD:CreatePowerBar(frame,true,true,'LEFT')
	frame.Name = MOD:CreateNameText(frame,"focus")
	frame.Buffs=MOD:CreateBuffs(frame)
	frame.Castbar=MOD:CreateCastbar(frame,false,L['Focus Castbar'])
	frame.Castbar.SafeZone=nil;
	frame.Castbar.LatencyTexture:Hide()
	frame.RaidIcon=MOD:CreateRaidIcon(frame)
	frame.Debuffs=MOD:CreateDebuffs(frame)
	frame.HealPrediction=MOD:CreateHealPrediction(frame)
	frame.AuraBars=MOD:CreateAuraBarHeader(frame,"focus")
	frame.Range = { insideAlpha = 1, outsideAlpha = 1 }
	frame.Threat=MOD:CreateThreat(frame)
	tinsert(frame.__elements,MOD.SmartAuraDisplay)
	frame:RegisterEvent('PLAYER_FOCUS_CHANGED',MOD.SmartAuraDisplay)
	frame.XRay=MOD:CreateXRay_Closer(frame)
	frame.XRay:SetPoint("BOTTOMRIGHT",20,-10)
	frame:Point('BOTTOMRIGHT',SVUI_Target,'TOPRIGHT',0,220)
	SuperVillain:SetSVMovable(frame,frame:GetName()..'_MOVE',L['Focus Frame'],nil,nil,nil,'ALL,SOLO')
end;
--[[ 
########################################################## 
UPDATE
##########################################################
]]--
function MOD:RefreshFrame_Focus(unit, frame, db)
	frame.db=db;
	local UNIT_WIDTH=db.width;
	local UNIT_HEIGHT=db.height;
	frame.unit=unit;
	frame:RegisterForClicks(MOD.db.fastClickTarget and 'AnyDown' or 'AnyUp')
	frame.colors=oUF_SuperVillain.colors;
	frame:Size(UNIT_WIDTH,UNIT_HEIGHT)
	_G[frame:GetName()..'_MOVE']:Size(frame:GetSize())
	MOD:RefreshUnitLayout(frame,"focus")
	MOD:UpdateAuraWatch(frame)
	frame:UpdateAllElements()
end;
tinsert(MOD['BasicFrameLoadList'], 'focus')
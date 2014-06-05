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
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.");
--[[ 
########################################################## 
HEAL PREDICTION
##########################################################
]]--
function MOD:CreateHealPrediction(frame)
	local health = frame.Health;
	local anchor, relative, relative2 = 'TOPRIGHT', 'BOTTOMLEFT', 'BOTTOMRIGHT';
	if(health.fillInverted) then
		anchor, relative, relative2 = 'TOPLEFT', 'BOTTOMRIGHT', 'BOTTOMLEFT';
	end
	local hTex = health:GetStatusBarTexture()
	local myBar = CreateFrame('StatusBar', nil, health)
	myBar:SetPoint(anchor, health, anchor, 0, 0)
	myBar:SetPoint(relative, hTex, relative2, 0, 0)
	myBar:SetStatusBarTexture(SuperVillain.Textures.bar)
	myBar:SetStatusBarColor(0.15, 0.9, 0.05, 0.7)

	local otherBar = CreateFrame('StatusBar', nil, health)
	otherBar:SetPoint(anchor, health, anchor, 0, 0)
	otherBar:SetPoint(relative, hTex, relative2, 0, 0)
	otherBar:SetStatusBarTexture(SuperVillain.Textures.bar)
	otherBar:SetStatusBarColor(0.05, 0.78, 0, 0.7)

	local absorbBar = CreateFrame('StatusBar', nil, health)
	absorbBar:SetPoint(anchor, health, anchor, 0, 0)
	absorbBar:SetPoint(relative, hTex, relative2, 0, 0)
	absorbBar:SetStatusBarTexture(SuperVillain.Textures.bar)
	absorbBar:SetStatusBarColor(0.9, 0.8, 0.1, 0.7)

	local healAbsorbBar = CreateFrame('StatusBar', nil, health)
	healAbsorbBar:SetPoint(anchor, health, anchor, 0, 0)
	healAbsorbBar:SetPoint(relative, hTex, relative2, 0, 0)
	healAbsorbBar:SetStatusBarTexture(SuperVillain.Textures.bar)
	healAbsorbBar:SetStatusBarColor(0.5, 0.9, 0.1, 0.7)

	local healPrediction = {
		myBar = myBar,
		otherBar = otherBar,
		absorbBar = absorbBar,
		healAbsorbBar = healAbsorbBar,
		maxOverflow = 1.05,
		frequentUpdates = true,
	}
	return healPrediction
end;

function MOD:UpdateHealPrediction(frame)
	if not frame.HealPrediction then return end
	local hp = frame.HealPrediction;
	local health = frame.Health;
	local size = frame:GetWidth()
	local anchor, relative, relative2 = 'TOPRIGHT', 'BOTTOMLEFT', 'BOTTOMRIGHT';
	local reversed = false
	if(health.fillInverted) then
		anchor, relative, relative2 = 'TOPLEFT', 'BOTTOMRIGHT', 'BOTTOMLEFT';
		reversed = true
	end

	local hTex = health:GetStatusBarTexture()

	if(hp.myBar) then
		hp.myBar:SetPoint(anchor, health, anchor, 0, 0)
		hp.myBar:SetPoint(relative, hTex, relative2, 0, 0)
		hp.myBar:SetReverseFill(reversed)
	end

	if(hp.otherBar) then
		hp.otherBar:SetPoint(anchor, health, anchor, 0, 0)
		hp.otherBar:SetPoint(relative, hTex, relative2, 0, 0)
		hp.otherBar:SetReverseFill(reversed)
	end

	if(hp.absorbBar) then
		hp.absorbBar:SetPoint(anchor, health, anchor, 0, 0)
		hp.absorbBar:SetPoint(relative, hTex, relative2, 0, 0)
		hp.absorbBar:SetReverseFill(reversed)
	end

	if(hp.healAbsorbBar) then
		hp.healAbsorbBar:SetPoint(anchor, health, anchor, 0, 0)
		hp.healAbsorbBar:SetPoint(relative, hTex, relative2, 0, 0)
		hp.healAbsorbBar:SetReverseFill(reversed)
	end
end;
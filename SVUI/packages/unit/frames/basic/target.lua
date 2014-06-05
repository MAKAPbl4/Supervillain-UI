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
local ceil,tinsert = math.ceil,table.insert
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function MOD:CreateFrame_Target(frame)
	MOD:SetDeluxeActionPanel(frame, 3)
	frame.Health = MOD:CreateHealthBar(frame,true,true,true)
	frame.Health.frequentUpdates=true;
	frame.Health.value:ClearAllPoints()
	frame.Health.value:SetParent(frame.InfoPanel)
	frame.Health.value:Point('LEFT',frame.InfoPanel,'LEFT')
	MOD:SetActionPanelIcons(frame, true)
	frame.Power = MOD:CreatePowerBar(frame,true,true,'RIGHT')
	frame.Power.frequentUpdates=true;
	frame.Power.value:ClearAllPoints()
	frame.Power.value:SetParent(frame.InfoPanel)
	frame.Power.value:Point('RIGHT',frame.InfoPanel,'RIGHT')
	frame.Name = MOD:CreateNameText(frame,"target")
	frame.LevelText = MOD:CreateLevelText(frame)
	MOD:CreatePortrait(frame)
	frame.Buffs = MOD:CreateBuffs(frame)
	frame.Debuffs = MOD:CreateDebuffs(frame)
	frame.Threat = MOD:CreateThreat(frame)
	frame.Castbar = MOD:CreateCastbar(frame, true, L["Target Castbar"], true)
	frame.RaidIcon = MOD:CreateRaidIcon(frame)
	local isSmall = MOD.db.target.combobar.smallIcons
	if(SuperVillain.class == 'ROGUE') then
		frame.HyperCombo = MOD:CreateRogueCombobar(frame,isSmall)
	elseif(SuperVillain.class == 'DRUID') then
		frame.HyperCombo = MOD:CreateDruidCombobar(frame,isSmall)
	end
	frame.HealPrediction = MOD:CreateHealPrediction(frame)
	frame.Afflicted = MOD:CreateAfflicted(frame)

	frame.GPS = MOD:CreateGPS(frame)

	tinsert(frame.__elements, MOD.SmartAuraDisplay)
	frame:RegisterEvent("PLAYER_TARGET_CHANGED", MOD.SmartAuraDisplay)
	frame.AuraBars = MOD:CreateAuraBarHeader(frame, "target")
	frame.Range = { insideAlpha = 1, outsideAlpha = 1 }
	frame.XRay = MOD:CreateXRay(frame)
	frame.XRay:SetPoint("TOPRIGHT", 12, 12)
	frame:Point("BOTTOMRIGHT", SuperVillain.UIParent, "BOTTOM", 413, 182)
	SuperVillain:SetSVMovable(frame, frame:GetName().."_MOVE", L["Target Frame"], nil, nil, nil, "ALL, SOLO")
end;
--[[ 
########################################################## 
UPDATE
##########################################################
]]--
function MOD:RefreshFrame_Target(unit, frame, db)
	frame.db=db; 
	local SPACER=SuperVillain:Scale(1);
	local UNIT_WIDTH=db.width;
	local UNIT_HEIGHT=db.height;
	local USE_COMBOBAR=db.combobar.enable;
	local comboBarHeight=db.combobar.height;
	frame.unit=unit;
	frame:RegisterForClicks(MOD.db.fastClickTarget and 'AnyDown' or 'AnyUp')
	frame.colors=oUF_SuperVillain.colors;
	frame:Size(UNIT_WIDTH,UNIT_HEIGHT)
	_G[frame:GetName()..'_MOVE']:Size(frame:GetSize())
	if not frame:IsElementEnabled('ActionPanel')then 
		frame:EnableElement('ActionPanel')
	end;
	MOD:RefreshUnitLayout(frame,"target")

	if not IsAddOnLoaded("Clique")then 
		if db.middleClickFocus then 
			frame:SetAttribute("type3","focus")
		elseif frame:GetAttribute("type3")=="focus"then 
			frame:SetAttribute("type3",nil)
		end 
	end;

	do
		if db.level.enable then
			local lvl=frame.LevelText;
			local point=db.level.position;
			lvl:ClearAllPoints()
			lvl:Point(db.level.position,healthAnchor,db.level.position)
			frame:Tag(level,db.level.text_format)
		else
			lvl:Hide()
		end
	end;

	if (SuperVillain.class=="ROGUE" or SuperVillain.class=="DRUID") and frame.HyperCombo then 
		local comboBar = frame.HyperCombo;
		if frame.ComboRefresh then 
			frame.ComboRefresh(frame)
		end;
		if db.combobar.autoHide then 
			comboBar:SetParent(frame)
		else 
			comboBar:SetParent(SuperVillain.UIParent)
		end;
		if not db.combobar.hudStyle then 
			if comboBar.Avatar then 
				comboBar.Avatar:SetScale(0.000001)
				comboBar.Avatar:SetAlpha(0)
			end;
		else 
			hudScale=db.combobar.hudScale;
			if not comboBar.Avatar then 
				comboBar:Size(hudScale * 3,hudScale * 3)
				comboBar:ClearAllPoints()
				comboBar:Point("CENTER",SuperVillain.UIParent,"CENTER",100,-100)
				SuperVillain:SetSVMovable(comboBar,'ComboBar_MOVE',L['Combobar'],nil,nil,nil,'ALL,SOLO')
			else
				comboBar.Avatar:SetScale(1)
				comboBar.Avatar:SetAlpha(1)
			end;
		end;
		if USE_COMBOBAR and not frame:IsElementEnabled('HyperCombo')then 
			frame:EnableElement('HyperCombo')
		elseif not USE_COMBOBAR and frame:IsElementEnabled('HyperCombo')then 
			frame:DisableElement('HyperCombo')
			comboBar:Hide()
		end 
	end;

	do 
		local gps = frame.GPS;
		if not frame:IsElementEnabled('GPS') then
			frame:EnableElement('GPS')
		end
	end;

	frame:UpdateAllElements()
end;
tinsert(MOD['BasicFrameLoadList'],'target')
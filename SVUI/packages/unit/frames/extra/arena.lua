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
local SVUI_ArenaHolder = CreateFrame('Frame', 'SVUI_ArenaHolder', UIParent)
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function MOD:UpdatePrep(event,unit,b)
	if(event=="ARENA_OPPONENT_UPDATE"or event=="UNIT_NAME_UPDATE") and unit~=self.unit then return end;
	local i,check=IsInInstance()
	if not MOD.db.arena.enable or check~="arena"or UnitExists(self.unit) and b~="unseen"then 
		self:Hide()
		return 
	end;
	local spec=GetArenaOpponentSpec(MOD[self.unit]:GetID())
	local _,x,y,z;
	if spec and spec > 0 then 
		_,x,_,y,_,_,z=GetSpecializationInfoByID(spec)
	end;
	if z and x then 
		local color=RAID_CLASS_COLORS[z]
		self.SpecClass:SetText(x.."  -  "..LOCALIZED_CLASS_NAMES_MALE[z])
		self.Health:SetStatusBarColor(color.r,color.g,color.b)
		self.Icon:SetTexture(y or[[INTERFACE\ICONS\INV_MISC_QUESTIONMARK]])
		self:Show()
	else 
		self:Hide()
	end
end;
function MOD:CreateFrame_Arena(frame)
	local OFFSET=SuperVillain:Scale(1);
	MOD:SetActionPanel(frame)
	frame.Health=MOD:CreateHealthBar(frame,true,true,true)
	MOD:SetActionPanelIcons(frame)
	frame.Power=MOD:CreatePowerBar(frame,true,true,'LEFT')
	frame.Name = MOD:CreateNameText(frame,"arena")
	frame.Buffs=MOD:CreateBuffs(frame)
	frame.Debuffs=MOD:CreateDebuffs(frame)
	frame.Castbar=MOD:CreateCastbar(frame,true)
	MOD:CreatePortrait(frame)
	frame.HealPrediction=MOD:CreateHealPrediction(frame)
	frame.Trinket=MOD:CreateTrinket(frame)
	frame.PVPSpecIcon=MOD:CreatePVPSpecIcon(frame)
	frame.Range = { insideAlpha = 1, outsideAlpha = 1 }
	frame:SetAttribute("type2","focus")
	if not frame.prepFrame then 
		frame.prepFrame=CreateFrame('Frame',frame:GetName()..'PrepFrame',UIParent)
		frame.prepFrame:SetFrameStrata('BACKGROUND')
		frame.prepFrame:SetAllPoints(frame)
		frame.prepFrame:SetID(frame:GetID())
		frame.prepFrame.Health=CreateFrame('StatusBar',nil,frame.prepFrame)
		frame.prepFrame.Health:Point('BOTTOMLEFT', frame.prepFrame, 'BOTTOMLEFT', OFFSET, OFFSET)
		frame.prepFrame.Health:Point('TOPRIGHT', frame.prepFrame, 'TOPRIGHT', -(OFFSET + MOD.db.arena.height), -OFFSET)
		frame.prepFrame.Health:SetPanelTemplate()
		frame.prepFrame.Icon=frame.prepFrame:CreateTexture(nil,'OVERLAY')
		frame.prepFrame.Icon.bg=CreateFrame('Frame',nil,frame.prepFrame)
		frame.prepFrame.Icon.bg:Point('TOPLEFT', frame.prepFrame, 'TOPRIGHT', OFFSET, 0)
		frame.prepFrame.Icon.bg:Point('BOTTOMRIGHT', frame.prepFrame, 'BOTTOMRIGHT', OFFSET, 0)
		frame.prepFrame.Icon.bg:SetFixedPanelTemplate('Default')
		frame.prepFrame.Icon:SetParent(frame.prepFrame.Icon.bg)
		frame.prepFrame.Icon:SetTexCoord(0.1,0.9,0.1,0.9)
		frame.prepFrame.Icon:FillInner(frame.prepFrame.Icon.bg)
		frame.prepFrame.SpecClass=frame.prepFrame.Health:CreateFontString(nil,"OVERLAY")
		frame.prepFrame.SpecClass:SetPoint("CENTER")
		frame.prepFrame.unit=frame.unit;
		frame.prepFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
		frame.prepFrame:RegisterEvent("ARENA_OPPONENT_UPDATE")
		frame.prepFrame:RegisterEvent("UNIT_NAME_UPDATE")
		frame.prepFrame:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
		frame.prepFrame:SetScript("OnEvent",MOD.UpdatePrep)
		MOD:SetUnitStatusbar(frame.prepFrame.Health)
		MOD:SetUnitFont(frame.prepFrame.SpecClass)
	end;
	SVUI_ArenaHolder:Point('BOTTOMRIGHT',SuperVillain.UIParent,'RIGHT',-105,-165)
	SuperVillain:SetSVMovable(SVUI_ArenaHolder,SVUI_ArenaHolder:GetName()..'_MOVE',L['Arena Frames'],nil,nil,nil,'ALL,ARENA')
end;
--[[ 
########################################################## 
UPDATE
##########################################################
]]--
function MOD:RefreshFrame_Arena(unit,frame,db)
	frame.db=db;
	local position=frame.index;
	local OFFSET=SuperVillain:Scale(1);
	local UNIT_WIDTH=db.width;
	local UNIT_HEIGHT=db.height;
	frame.unit=unit
	frame.colors=oUF_SuperVillain.colors;
	frame:Size(UNIT_WIDTH,UNIT_HEIGHT)
	frame:RegisterForClicks(MOD.db.fastClickTarget and'AnyDown'or'AnyUp')
	MOD:RefreshUnitLayout(frame,"arena")
	do 
		local trinket=frame.Trinket;
		trinket.bg:Size(db.pvpTrinket.size)
		trinket.bg:ClearAllPoints()
		if db.pvpTrinket.position=='RIGHT'then 
			trinket.bg:Point('LEFT',frame,'RIGHT',db.pvpTrinket.xOffset,db.pvpTrinket.yOffset)
		else 
			trinket.bg:Point('RIGHT',frame,'LEFT',db.pvpTrinket.xOffset,db.pvpTrinket.yOffset)
		end;
		if db.pvpTrinket.enable and not frame:IsElementEnabled('Trinket')then 
			frame:EnableElement('Trinket')
		elseif not db.pvpTrinket.enable and frame:IsElementEnabled('Trinket')then 
			frame:DisableElement('Trinket')
		end 
	end;
	do 
		local pvp=frame.PVPSpecIcon;
		pvp.bg:Point("TOPRIGHT",frame,"TOPRIGHT")
		pvp.bg:SetPoint("BOTTOMLEFT", frame.Power, "BOTTOMRIGHT", -OFFSET, 0)
		if db.pvpSpecIcon and not frame:IsElementEnabled('PVPSpecIcon')then 
			frame:EnableElement('PVPSpecIcon')
		elseif not db.pvpSpecIcon and frame:IsElementEnabled('PVPSpecIcon')then 
			frame:DisableElement('PVPSpecIcon')
		end 
	end;
	frame:ClearAllPoints()
	if position==1 then 
		if db.showBy=='UP'then 
			frame:Point('BOTTOMRIGHT',SVUI_ArenaHolder_MOVE,'BOTTOMRIGHT')
		else 
			frame:Point('TOPRIGHT',SVUI_ArenaHolder_MOVE,'TOPRIGHT')
		end 
	else 
		if db.showBy=='UP'then 
			frame:Point('BOTTOMRIGHT', _G['SVUI_Arena'..position-1], 'TOPRIGHT', 0, 12 + db.castbar.height)
		else 
			frame:Point('TOPRIGHT', _G['SVUI_Arena'..position-1], 'BOTTOMRIGHT', 0, -(12 + db.castbar.height))
		end 
	end;
	SVUI_ArenaHolder:Width(UNIT_WIDTH)
	SVUI_ArenaHolder:Height(UNIT_HEIGHT + (UNIT_HEIGHT + 12 + db.castbar.height) * 4)
	frame:UpdateAllElements()
end;
MOD['ExtraFrameLoadList']['arena'] = 5
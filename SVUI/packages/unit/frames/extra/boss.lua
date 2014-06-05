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
local SVUI_BossHolder = CreateFrame('Frame', 'SVUI_BossHolder', UIParent)
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function MOD:CreateFrame_Boss(frame)
	MOD:SetActionPanel(frame,3)
	frame.Health=MOD:CreateHealthBar(frame,true,true,true)
	MOD:SetActionPanelIcons(frame)
	frame.Power = MOD:CreatePowerBar(frame,true,true,'RIGHT')
	frame.Name = MOD:CreateNameText(frame,"boss")
	MOD:CreatePortrait(frame)
	frame.Buffs=MOD:CreateBuffs(frame)
	frame.Debuffs=MOD:CreateDebuffs(frame)
	frame.Afflicted=MOD:CreateAfflicted(frame)
	frame.Castbar=MOD:CreateCastbar(frame,true,nil,true,nil,true)
	frame.RaidIcon=MOD:CreateRaidIcon(frame)
	frame.AltPowerBar=MOD:CreateAltPowerBar(frame)
	frame.Range = { insideAlpha = 1, outsideAlpha = 1 }
	frame:SetAttribute("type2","focus")
	SVUI_BossHolder:Point('RIGHT',SuperVillain.UIParent,'RIGHT',-105,0)
	SuperVillain:SetSVMovable(SVUI_BossHolder,SVUI_BossHolder:GetName()..'_MOVE',L['Boss Frames'],nil,nil,nil,'ALL,PARTY,RAID10,RAID25,RAID40')
end
--[[ 
########################################################## 
UPDATE
##########################################################
]]--
function MOD:RefreshFrame_Boss(unit,frame,db)
	frame.db=db;
	local position=frame.index;
	local UNIT_WIDTH=db.width;
	local UNIT_HEIGHT=db.height;
	frame.unit=unit;
	frame.colors=oUF_SuperVillain.colors;
	frame:Size(UNIT_WIDTH,UNIT_HEIGHT)
	frame:RegisterForClicks(MOD.db.fastClickTarget and'AnyDown'or'AnyUp')
	MOD:RefreshUnitLayout(frame,"boss")
	frame:ClearAllPoints()
	if position==1 then 
		if db.showBy=='UP'then 
			frame:Point('BOTTOMRIGHT',SVUI_BossHolder_MOVE,'BOTTOMRIGHT')
		else 
			frame:Point('TOPRIGHT',SVUI_BossHolder_MOVE,'TOPRIGHT')
		end 
	else 
		if db.showBy=='UP'then 
			frame:Point('BOTTOMRIGHT', _G['SVUI_Boss'..position-1], 'TOPRIGHT', 0, 12 + db.castbar.height)
		else 
			frame:Point('TOPRIGHT', _G['SVUI_Boss'..position-1], 'BOTTOMRIGHT', 0, -(12 + db.castbar.height))
		end 
	end;
	SVUI_BossHolder:Width(UNIT_WIDTH)
	SVUI_BossHolder:Height(UNIT_HEIGHT + (UNIT_HEIGHT + 12 + db.castbar.height) * 3)
	frame:UpdateAllElements()
end;
MOD['ExtraFrameLoadList']['boss'] = MAX_BOSS_FRAMES
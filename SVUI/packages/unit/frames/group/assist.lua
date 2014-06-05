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
local _, ns = ...;
local oUF_SuperVillain = ns.oUF;
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.");
local tinsert = table.insert;
local StealthFrame = CreateFrame("Frame");
StealthFrame:Hide();
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function MOD:CreateFrame_Assist(...)
	self:SetScript('OnEnter',UnitFrame_OnEnter)
	self:SetScript('OnLeave',UnitFrame_OnLeave)
	MOD:SetActionPanel(self)
	self.Health=MOD:CreateHealthBar(self,true)
	MOD:SetActionPanelIcons(self)
	self.Name = MOD:CreateNameText(self,"assist")
	self.Threat=MOD:CreateThreat(self)
	self.RaidIcon=MOD:CreateRaidIcon(self)
	self.RaidIcon:SetPoint("BOTTOMRIGHT")
	self.Range = { insideAlpha = 1, outsideAlpha = 1 }
	MOD:RefreshFrame_Assist(self,MOD.db['assist'])
	self.originalParent=self:GetParent()
	return self 
end;
--[[ 
########################################################## 
UPDATE
##########################################################
]]--
function MOD:RefreshHeader_Assist(frame,db)
	frame:Hide()
	frame.db = db;
	MOD:DetachSubFrames(frame:GetChildren())
	frame:SetAttribute("startingIndex",-1)
	RegisterAttributeDriver(frame,'state-visibility','show')
	frame.dirtyWidth,frame.dirtyHeight=frame:GetSize()
	RegisterAttributeDriver(frame,'state-visibility','[@raid1,exists] show;hide')
	frame:SetAttribute("startingIndex",1)
	frame:SetAttribute('point','BOTTOM')
	frame:SetAttribute('columnAnchorPoint','LEFT')
	MOD:DetachSubFrames(frame:GetChildren())
	frame:SetAttribute("yOffset",7)
	if not frame.positioned then 
		frame:ClearAllPoints()
		frame:Point("TOPLEFT",SuperVillain.UIParent,"TOPLEFT",4,-140)
		SuperVillain:SetSVMovable(frame,frame:GetName()..'_MOVE',L['Assist Frames'],nil,nil,nil,'ALL,RAID10,RAID25,RAID40')
		frame.Avatar.positionOverride="TOPLEFT"
		frame:SetAttribute('minHeight',frame.dirtyHeight)
		frame:SetAttribute('minWidth',frame.dirtyWidth)
		frame.positioned=true 
	end 
end;
function MOD:RefreshFrame_Assist(frame,db)
	frame.colors = oUF_SuperVillain.colors;
	frame:RegisterForClicks(MOD.db.fastClickTarget and 'AnyDown' or 'AnyUp')
	if frame.isChild and frame.originalParent then 
		local targets = db.targetsGroup;
		frame.db = db.targetsGroup;
		if not frame.originalParent.childList then 
			frame.originalParent.childList = {}
		end;
		frame.originalParent.childList[frame] = true;
		if not InCombatLockdown()then 
			if targets.enable then 
				frame:SetParent(frame.originalParent)
				frame:Size(targets.width,targets.height)
				frame:ClearAllPoints()
				SuperVillain:ReversePoint(frame, targets.anchorPoint, frame.originalParent, targets.xOffset, targets.yOffset)
			else 
				frame:SetParent(StealthFrame)
			end 
		end 
	elseif not InCombatLockdown()then 
		frame.db = db;
		frame:Size(db.width,db.height)
	end;

	MOD:RefreshUnitLayout(frame,"assist")

	do 
		local k=frame.Name;
		k:Point('CENTER',frame.Health,'CENTER')
		k:SetParent(frame.Health)
		if oUF_SuperVillain.colors.healthclass then 
			frame:Tag(k,'[name:10]')
		else 
			frame:Tag(k,'[namecolor][name:10]')
		end;
	end;
	frame:UpdateAllElements()
end;
MOD['GroupFrameLoadList']['assist']={'MAINASSIST','SVUI_UNITTARGET'}
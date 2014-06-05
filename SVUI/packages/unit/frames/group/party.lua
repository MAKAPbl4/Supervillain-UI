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
local tinsert = table.insert;
local StealthFrame = CreateFrame("Frame");
StealthFrame:Hide();
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function MOD:CreateFrame_Party(frame)
	MOD:SetActionPanel(self,2)

	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	if self.isChild then 
		self.Health = MOD:CreateHealthBar(self, true)
		MOD:SetActionPanelIcons(self)
		self.Name = MOD:CreateNameText(self, "party")
		self.originalParent = self:GetParent()
	else 
		self.Health = MOD:CreateHealthBar(self,true,true)
		MOD:SetActionPanelIcons(self)
		self.Power = MOD:CreatePowerBar(self,true,false,'LEFT')
		self.Power.frequentUpdates = false;
		self.Name = MOD:CreateNameText(self, "party")
		MOD:CreatePortrait(self,true)
		self.Buffs = MOD:CreateBuffs(self)
		self.Debuffs = MOD:CreateDebuffs(self)
		self.AuraWatch = MOD:CreateAuraWatch(self)
		self.Afflicted = MOD:CreateAfflicted(self)
		self.ResurrectIcon = MOD:CreateResurectionIcon(self)
		self.LFDRole = MOD:CreateRoleIcon(self)
		self.TargetGlow = MOD:CreateTargetGlow(self)
		self.RaidRoleFramesAnchor = MOD:CreateRaidRoleFrames(self)
		tinsert(self.__elements, MOD.UpdateTargetGlow)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', MOD.UpdateTargetGlow)
		self:RegisterEvent('PLAYER_ENTERING_WORLD', MOD.UpdateTargetGlow)
		self:RegisterEvent('GROUP_ROSTER_UPDATE', MOD.UpdateTargetGlow)
		self.Threat = MOD:CreateThreat(self)
		self.RaidIcon = MOD:CreateRaidIcon(self)
		self.ReadyCheck = MOD:CreateReadyCheckIcon(self)
		self.HealPrediction = MOD:CreateHealPrediction(self)
	end;

	self.Range = { insideAlpha = 1, outsideAlpha = 1 }

	return self 
end;
--[[ 
########################################################## 
UPDATE
##########################################################
]]--
function MOD:RefreshHeader_Party(frame,db)
	frame.db = db;

	local party = frame:GetParent()
	party.db = db;

	if not party.positioned then 
		party:ClearAllPoints()
		party:Point("LEFT",SuperVillain.UIParent,"LEFT",40,0)

		SuperVillain:SetSVMovable(party, party:GetName()..'_MOVE', L['Party Frames'], nil, nil, nil, 'ALL,PARTY,ARENA');
		party.positioned = true;

		party:RegisterEvent("PLAYER_ENTERING_WORLD")
		party:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		party:SetScript("OnEvent", MOD['RefreshState_Party'])
	end;

	MOD.RefreshState_Party(party)
end;

function MOD:RefreshState_Party(event)
	if (not self.db or (self.db and not self.db.enable) or (MOD.db and not MOD.db.smartRaidFilter) or self.isForced) then return end;
	local instance, instanceType = IsInInstance()
	if(event == "PLAYER_REGEN_ENABLED") then 
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end;
	if(not InCombatLockdown()) then 
		if(instance and instanceType == "raid") then 
			UnregisterStateDriver(self,"visibility")
			self:Hide()
		elseif self.db.visibility then 
			RegisterStateDriver(self,"visibility", self.db.visibility)
		end 
	else 
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	end 
end;

function MOD:RefreshFrame_Party(frame,db)
	frame.db = db;
	local OFFSET = SuperVillain:Scale(1);
	frame.colors = oUF_SuperVillain.colors;
	frame:RegisterForClicks(MOD.db.fastClickTarget and 'AnyDown' or 'AnyUp')
	if frame.isChild then 
		local altDB = db.petsGroup;
		if frame == _G[frame.originalParent:GetName()..'Target'] then 
			altDB = db.targetsGroup 
		end;
		if not frame.originalParent.childList then 
			frame.originalParent.childList = {}
		end;
		frame.originalParent.childList[frame] = true;
		if not InCombatLockdown()then 
			if altDB.enable then 
				frame:SetParent(frame.originalParent)
				frame:Size(altDB.width,altDB.height)
				frame:ClearAllPoints()
				SuperVillain:ReversePoint(frame, altDB.anchorPoint, frame.originalParent, altDB.xOffset, altDB.yOffset)
			else 
				frame:SetParent(StealthFrame)
			end 
		end;
		do 
			local health = frame.Health;
			health.Smooth = nil;
			health.frequentUpdates = nil;
			health.colorSmooth = nil;
			health.colorHealth = nil;
			health.colorClass = true;
			health.colorReaction = true;
			health:ClearAllPoints()
			health:Point("TOPRIGHT", frame, "TOPRIGHT", -OFFSET, -OFFSET)
			health:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", OFFSET, OFFSET)
		end;
		do 
			local name=frame.Name;
			name:ClearAllPoints()
			name:SetPoint('CENTER', frame.Health, 'CENTER', 0, 0)
			frame:Tag(name, altDB.text_format)
		end 
	else 
		if not InCombatLockdown()then frame:Size(db.width,db.height) end;
		MOD:RefreshUnitLayout(frame,"party")
		MOD:UpdateAuraWatch(frame)
	end;
	frame:EnableElement('ReadyCheck')
	frame:UpdateAllElements()
end;
MOD['GroupFrameLoadList']['party'] = {nil,'SVUI_UNITPET, SVUI_UNITTARGET'}
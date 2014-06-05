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
BUILD FUNCTION & UPDATE
##########################################################
]]--
for i=10, 40, 15 do
    MOD["CreateFrame_Raid"..i] = function(frame)
        frame:SetScript("OnEnter", UnitFrame_OnEnter)
        frame:SetScript("OnLeave", UnitFrame_OnLeave)
        MOD:SetActionPanel(frame, 2)
        frame.Health = MOD:CreateHealthBar(frame, true, true)
        MOD:SetActionPanelIcons(frame)
        frame.Power = MOD:CreatePowerBar(frame, true, true, "LEFT")
        frame.Power.frequentUpdates = false;
        frame.Name = MOD:CreateNameText(frame, "raid"..i)
        frame.Buffs = MOD:CreateBuffs(frame)
        frame.Debuffs = MOD:CreateDebuffs(frame)
        frame.AuraWatch = MOD:CreateAuraWatch(frame)
        frame.RaidDebuffs = MOD:CreateRaidDebuffs(frame)
        frame.Afflicted = MOD:CreateAfflicted(frame)
        frame.ResurrectIcon = MOD:CreateResurectionIcon(frame)
        frame.LFDRole = MOD:CreateRoleIcon(frame)
        frame.RaidRoleFramesAnchor = MOD:CreateRaidRoleFrames(frame)
        frame.TargetGlow = MOD:CreateTargetGlow(frame)
        tinsert(frame.__elements, MOD.UpdateTargetGlow)
        frame:RegisterEvent("PLAYER_TARGET_CHANGED", MOD.UpdateTargetGlow)
        frame:RegisterEvent("PLAYER_ENTERING_WORLD", MOD.UpdateTargetGlow)
        frame.Threat = MOD:CreateThreat(frame)
        frame.RaidIcon = MOD:CreateRaidIcon(frame)
        frame.ReadyCheck = MOD:CreateReadyCheckIcon(frame)
        frame.HealPrediction = MOD:CreateHealPrediction(frame)
        frame.Range = { insideAlpha = 1, outsideAlpha = 1 }
        return frame 
    end;

	MOD["RefreshState_Raid"..i] = function(frame, event)
        if (not MOD.db or (MOD.db and not SuperVillain.protected.SVUnit.enable) or (MOD.db and not MOD.db.smartRaidFilter) or frame.isForced) then return end;
        local instance, group = IsInInstance()
        local _, _, _, _, info, _, _ = GetInstanceInfo()
        if event == "PLAYER_REGEN_ENABLED"then 
            frame:UnregisterEvent("PLAYER_REGEN_ENABLED")
        end;
        if not InCombatLockdown()then 
            if instance and group == "raid" and info == i then 
                UnregisterStateDriver(frame, "visibility")
                frame:Show()
            elseif instance and group == "raid"then 
                UnregisterStateDriver(frame, "visibility")
                frame:Hide()
            elseif MOD.db.visibility then 
                RegisterStateDriver(frame, "visibility", MOD.db.visibility)
            end 
        else 
            frame:RegisterEvent("PLAYER_REGEN_ENABLED")
            return 
        end 
    end;

    MOD["RefreshHeader_Raid"..i] = function(_, unit, db)
        local frame = unit:GetParent()
        frame.db = db;
        if not frame.positioned then 
            frame:ClearAllPoints()
            frame:Point("LEFT", SuperVillain.UIParent, "LEFT", 4, 0)
            SuperVillain:SetSVMovable(frame, frame:GetName().."_MOVE", L["Raid 1-"]..i..L[" Frames"], nil, nil, nil, "ALL, RAID"..i)
            frame:RegisterEvent("PLAYER_ENTERING_WORLD")
            frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
            frame:SetScript("OnEvent", MOD["RefreshState_Raid"..i])
            frame.positioned = true 
        end;
        MOD["RefreshState_Raid"..i](frame)
    end;

    MOD["RefreshFrame_Raid"..i] = function(_, frame, db)
        frame.db = db;
        local rdSize = MOD.db.auraFontSize;
        local rdFont = LSM:Fetch("font",MOD.db.auraFont)
        frame.colors = oUF_SuperVillain.colors;
        frame:RegisterForClicks(MOD.db.fastClickTarget and"AnyDown"or"AnyUp")
        if not InCombatLockdown()then frame:Size(db.width, db.height)end;
        MOD:RefreshUnitLayout(frame, "raid")
        do
            local rdBuffs = frame.RaidDebuffs;
            if db.rdebuffs.enable then 
                frame:EnableElement("RaidDebuffs")
                rdBuffs:Size(db.rdebuffs.size)
                rdBuffs:Point("CENTER", frame, "CENTER", db.rdebuffs.xOffset, db.rdebuffs.yOffset)
                rdBuffs.count:SetFontTemplate(rdFont, rdSize, "OUTLINE")
                rdBuffs.time:SetFontTemplate(rdFont, rdSize, "OUTLINE")
            else 
                frame:DisableElement("RaidDebuffs")
                rdBuffs:Hide()
            end 
        end;
        MOD:UpdateAuraWatch(frame)
        frame:EnableElement("ReadyCheck")
        frame:UpdateAllElements()
    end;
    MOD["GroupFrameLoadList"]["raid"..i] = true;
end
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
local SuperVillain, L, P, C, G = unpack(SVUI);
local MOD = SuperVillain:GetModule("SVStyle");
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local function AlphaHelper(this, value, flag)
	if value ~= 1 and flag ~= true then 
		d:SetAlpha(1, true)
	end 
end;
--[[ 
########################################################## 
ALERTFRAME STYLER
##########################################################
]]--
local function AlertStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.alertframes ~= true then return end;

	for i = 1, 4 do
		local alert = _G["SVUI_SystemAlert"..i];
		if(alert) then
			for b = 1, 3 do
				alert.buttons[b]:SetButtonTemplate()
			end;
			alert:Formula409()
			MOD:ApplyAlertStyle(alert)
			alert.input:SetEditboxTemplate()
			alert.input.Panel:Point("TOPLEFT", -2, -4)
			alert.input.Panel:Point("BOTTOMRIGHT", 2, 4)
			alert.gold:SetEditboxTemplate()
			alert.silver:SetEditboxTemplate()
			alert.copper:SetEditboxTemplate()
		end
	end

	hooksecurefunc("AlertFrame_SetAchievementAnchors", function(g)
		for i = 1, MAX_ACHIEVEMENT_ALERTS do 
			local frame = _G["AchievementAlertFrame"..i]
			if frame then 
				frame:SetAlpha(1)
				hooksecurefunc(frame, "SetAlpha", AlphaHelper)
				if not frame.Panel then 
					frame:SetPanelTemplate("Transparent", true)
					frame.Panel:Point("TOPLEFT", _G[frame:GetName().."Background"], "TOPLEFT", -2, -6)
					frame.Panel:Point("BOTTOMRIGHT", _G[frame:GetName().."Background"], "BOTTOMRIGHT", -2, 6)
				end;
				_G["AchievementAlertFrame"..i.."Background"]:SetTexture(nil)
				_G["AchievementAlertFrame"..i.."OldAchievement"]:MUNG()
				_G["AchievementAlertFrame"..i.."Glow"]:MUNG()
				_G["AchievementAlertFrame"..i.."Shine"]:MUNG()
				_G["AchievementAlertFrame"..i.."GuildBanner"]:MUNG()
				_G["AchievementAlertFrame"..i.."GuildBorder"]:MUNG()
				_G["AchievementAlertFrame"..i.."Unlocked"]:SetFontTemplate(nil, 12)
				_G["AchievementAlertFrame"..i.."Unlocked"]:SetTextColor(1, 1, 1)
				_G["AchievementAlertFrame"..i.."Name"]:SetFontTemplate(nil, 12)
				_G["AchievementAlertFrame"..i.."IconTexture"]:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				_G["AchievementAlertFrame"..i.."IconOverlay"]:MUNG()
				_G["AchievementAlertFrame"..i.."IconTexture"]:ClearAllPoints()
				_G["AchievementAlertFrame"..i.."IconTexture"]:Point("LEFT", frame, 7, 0)
				if not _G["AchievementAlertFrame"..i.."IconTexture"].b then 
					_G["AchievementAlertFrame"..i.."IconTexture"].b = CreateFrame("Frame", nil, _G["AchievementAlertFrame"..i])
					_G["AchievementAlertFrame"..i.."IconTexture"].b:SetFixedPanelTemplate("Default")
					_G["AchievementAlertFrame"..i.."IconTexture"].b:WrapOuter(_G["AchievementAlertFrame"..i.."IconTexture"])
					_G["AchievementAlertFrame"..i.."IconTexture"]:SetParent(_G["AchievementAlertFrame"..i.."IconTexture"].b)
				end 
			end 
		end 
	end)

	hooksecurefunc("AlertFrame_SetDungeonCompletionAnchors", function(g)
		for i = 1, DUNGEON_COMPLETION_MAX_REWARDS do 
			local frame = _G["DungeonCompletionAlertFrame"..i]
			if frame then 
				frame:SetAlpha(1)
				hooksecurefunc(frame, "SetAlpha", AlphaHelper)
				if not frame.Panel then 
					frame:SetPanelTemplate("Transparent", true)
					frame.Panel:Point("TOPLEFT", frame, "TOPLEFT", -2, -6)
					frame.Panel:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 6)
				end;
				frame.shine:MUNG()
				frame.glowFrame:MUNG()
				frame.glowFrame.glow:MUNG()
				frame.raidArt:MUNG()
				frame.dungeonArt1:MUNG()
				frame.dungeonArt2:MUNG()
				frame.dungeonArt3:MUNG()
				frame.dungeonArt4:MUNG()
				frame.heroicIcon:MUNG()
				frame.dungeonTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				frame.dungeonTexture:SetDrawLayer("OVERLAY")
				frame.dungeonTexture:ClearAllPoints()
				frame.dungeonTexture:Point("LEFT", frame, 7, 0)
				if not frame.dungeonTexture.b then 
					frame.dungeonTexture.b = CreateFrame("Frame", nil, frame)
					frame.dungeonTexture.b:SetFixedPanelTemplate("Default")
					frame.dungeonTexture.b:WrapOuter(frame.dungeonTexture)
					frame.dungeonTexture:SetParent(frame.dungeonTexture.b)
				end 
			end 
		end 
	end)

	hooksecurefunc("AlertFrame_SetGuildChallengeAnchors", function(g)
		local frame = GuildChallengeAlertFrame;
		if frame then 
			frame:SetAlpha(1)
			hooksecurefunc(frame, "SetAlpha", AlphaHelper)
			if not frame.Panel then 
				frame:SetPanelTemplate("Transparent", true)
				frame.Panel:Point("TOPLEFT", frame, "TOPLEFT", -2, -6)
				frame.Panel:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 6)
			end;
			local j = select(2, frame:GetRegions())
			if j:GetObjectType() == "Texture"then 
				if j:GetTexture() == "Interface\\GuildFrame\\GuildChallenges"then j:MUNG()end 
			end;
			GuildChallengeAlertFrameGlow:MUNG()
			GuildChallengeAlertFrameShine:MUNG()
			GuildChallengeAlertFrameEmblemBorder:MUNG()
			if not GuildChallengeAlertFrameEmblemIcon.b then 
				GuildChallengeAlertFrameEmblemIcon.b = CreateFrame("Frame", nil, frame)
				GuildChallengeAlertFrameEmblemIcon.b:SetFixedPanelTemplate("Default")
				GuildChallengeAlertFrameEmblemIcon.b:Point("TOPLEFT", GuildChallengeAlertFrameEmblemIcon, "TOPLEFT", -3, 3)
				GuildChallengeAlertFrameEmblemIcon.b:Point("BOTTOMRIGHT", GuildChallengeAlertFrameEmblemIcon, "BOTTOMRIGHT", 3, -2)
				GuildChallengeAlertFrameEmblemIcon:SetParent(GuildChallengeAlertFrameEmblemIcon.b)
			end;
			SetLargeGuildTabardTextures("player", GuildChallengeAlertFrameEmblemIcon, nil, nil)
		end 
	end)

	hooksecurefunc("AlertFrame_SetChallengeModeAnchors", function(g)
		local frame = ChallengeModeAlertFrame1;
		if frame then 
			frame:SetAlpha(1)
			hooksecurefunc(frame, "SetAlpha", AlphaHelper)
			if not frame.Panel then 
				frame:SetPanelTemplate("Transparent", true)
				frame.Panel:Point("TOPLEFT", frame, "TOPLEFT", 19, -6)
				frame.Panel:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -22, 6)
			end;
			for i = 1, frame:GetNumRegions()do 
				local j = select(i, frame:GetRegions())
				if j:GetObjectType() == "Texture"then 
					if j:GetTexture() == "Interface\\Challenges\\challenges-main" then j:MUNG() end 
				end 
			end;
			ChallengeModeAlertFrame1Shine:MUNG()
			ChallengeModeAlertFrame1GlowFrame:MUNG()
			ChallengeModeAlertFrame1GlowFrame.glow:MUNG()
			ChallengeModeAlertFrame1Border:MUNG()
			ChallengeModeAlertFrame1DungeonTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			ChallengeModeAlertFrame1DungeonTexture:ClearAllPoints()
			ChallengeModeAlertFrame1DungeonTexture:Point("LEFT", frame.Panel, 9, 0)
			if not ChallengeModeAlertFrame1DungeonTexture.b then 
				ChallengeModeAlertFrame1DungeonTexture.b = CreateFrame("Frame", nil, frame)
				ChallengeModeAlertFrame1DungeonTexture.b:SetFixedPanelTemplate("Default")
				ChallengeModeAlertFrame1DungeonTexture.b:WrapOuter(ChallengeModeAlertFrame1DungeonTexture)
				ChallengeModeAlertFrame1DungeonTexture:SetParent(ChallengeModeAlertFrame1DungeonTexture.b)
			end 
		end 
	end)

	hooksecurefunc("AlertFrame_SetScenarioAnchors", function(g)
		local frame = ScenarioAlertFrame1;
		if frame then 
			frame:SetAlpha(1)
			hooksecurefunc(frame, "SetAlpha", AlphaHelper)
			if not frame.Panel then 
				frame:SetPanelTemplate("Transparent", true)
				frame.Panel:Point("TOPLEFT", frame, "TOPLEFT", 4, 4)
				frame.Panel:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -7, 6)
			end;
			for i = 1, frame:GetNumRegions()do 
				local j = select(i, frame:GetRegions())
				if j:GetObjectType() == "Texture"then 
					if j:GetTexture() == "Interface\\Scenarios\\ScenariosParts" then j:MUNG() end 
				end 
			end;
			ScenarioAlertFrame1Shine:MUNG()
			ScenarioAlertFrame1GlowFrame:MUNG()
			ScenarioAlertFrame1GlowFrame.glow:MUNG()
			ScenarioAlertFrame1DungeonTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			ScenarioAlertFrame1DungeonTexture:ClearAllPoints()
			ScenarioAlertFrame1DungeonTexture:Point("LEFT", frame.Panel, 9, 0)
			if not ScenarioAlertFrame1DungeonTexture.b then 
				ScenarioAlertFrame1DungeonTexture.b = CreateFrame("Frame", nil, frame)
				ScenarioAlertFrame1DungeonTexture.b:SetFixedPanelTemplate("Default")
				ScenarioAlertFrame1DungeonTexture.b:WrapOuter(ScenarioAlertFrame1DungeonTexture)
				ScenarioAlertFrame1DungeonTexture:SetParent(ScenarioAlertFrame1DungeonTexture.b)
			end 
		end 
	end)

	hooksecurefunc("AlertFrame_SetCriteriaAnchors", function()
		for i = 1, MAX_ACHIEVEMENT_ALERTS do 
			local frame = _G["CriteriaAlertFrame"..i]
			if frame then 
				frame:SetAlpha(1)
				hooksecurefunc(frame, "SetAlpha", AlphaHelper)
				if not frame.Panel then 
					frame:SetPanelTemplate("Transparent", true)
					frame.Panel:Point("TOPLEFT", frame, "TOPLEFT", -2, -6)
					frame.Panel:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 6)
				end;
				_G["CriteriaAlertFrame"..i.."Unlocked"]:SetTextColor(1, 1, 1)
				_G["CriteriaAlertFrame"..i.."Name"]:SetTextColor(1, 1, 0)
				_G["CriteriaAlertFrame"..i.."Background"]:MUNG()
				_G["CriteriaAlertFrame"..i.."Glow"]:MUNG()
				_G["CriteriaAlertFrame"..i.."Shine"]:MUNG()
				_G["CriteriaAlertFrame"..i.."IconBling"]:MUNG()
				_G["CriteriaAlertFrame"..i.."IconOverlay"]:MUNG()
				if not _G["CriteriaAlertFrame"..i.."IconTexture"].b then 
					_G["CriteriaAlertFrame"..i.."IconTexture"].b = CreateFrame("Frame", nil, frame)
					_G["CriteriaAlertFrame"..i.."IconTexture"].b:SetFixedPanelTemplate("Default")
					_G["CriteriaAlertFrame"..i.."IconTexture"].b:Point("TOPLEFT", _G["CriteriaAlertFrame"..i.."IconTexture"], "TOPLEFT", -3, 3)
					_G["CriteriaAlertFrame"..i.."IconTexture"].b:Point("BOTTOMRIGHT", _G["CriteriaAlertFrame"..i.."IconTexture"], "BOTTOMRIGHT", 3, -2)
					_G["CriteriaAlertFrame"..i.."IconTexture"]:SetParent(_G["CriteriaAlertFrame"..i.."IconTexture"].b)
				end;
				_G["CriteriaAlertFrame"..i.."IconTexture"]:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			end 
		end 
	end)

	hooksecurefunc("AlertFrame_SetLootWonAnchors", function()
		for i = 1, #LOOT_WON_ALERT_FRAMES do 
			local frame = LOOT_WON_ALERT_FRAMES[i]
			if frame then 
				frame:SetAlpha(1)
				hooksecurefunc(frame, "SetAlpha", AlphaHelper)
				frame.Background:MUNG()
				frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				frame.IconBorder:MUNG()
				frame.glow:MUNG()
				frame.shine:MUNG()
				if not frame.Icon.b then 
					frame.Icon.b = CreateFrame("Frame", nil, frame)
					frame.Icon.b:SetFixedPanelTemplate("Default")
					frame.Icon.b:WrapOuter(frame.Icon)
					frame.Icon:SetParent(frame.Icon.b)
				end;
				if not frame.Panel then 
					frame:SetPanelTemplate("Transparent", true)
					frame.Panel:SetPoint("TOPLEFT", frame.Icon.b, "TOPLEFT", -4, 4)
					frame.Panel:SetPoint("BOTTOMRIGHT", frame.Icon.b, "BOTTOMRIGHT", 180, -4)
				end 
			end 
		end 
	end)

	hooksecurefunc("AlertFrame_SetMoneyWonAnchors", function()
		for i = 1, #MONEY_WON_ALERT_FRAMES do 
			local frame = MONEY_WON_ALERT_FRAMES[i]
			if frame then 
				frame:SetAlpha(1)
				hooksecurefunc(frame, "SetAlpha", AlphaHelper)
				frame.Background:MUNG()
				frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				frame.IconBorder:MUNG()
				if not frame.Icon.b then 
					frame.Icon.b = CreateFrame("Frame", nil, frame)
					frame.Icon.b:SetFixedPanelTemplate("Default")
					frame.Icon.b:WrapOuter(frame.Icon)
					frame.Icon:SetParent(frame.Icon.b)
				end;
				if not frame.Panel then 
					frame:SetPanelTemplate("Transparent", true)
					frame.Panel:SetPoint("TOPLEFT", frame.Icon.b, "TOPLEFT", -4, 4)
					frame.Panel:SetPoint("BOTTOMRIGHT", frame.Icon.b, "BOTTOMRIGHT", 180, -4)
				end 
			end 
		end 
	end)

	local frame = BonusRollMoneyWonFrame;
	frame:SetAlpha(1)
	hooksecurefunc(frame, "SetAlpha", AlphaHelper)
	frame.Background:MUNG()
	frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	frame.IconBorder:MUNG()
	frame.Icon.b = CreateFrame("Frame", nil, frame)
	frame.Icon.b:SetFixedPanelTemplate("Default")
	frame.Icon.b:WrapOuter(frame.Icon)
	frame.Icon:SetParent(frame.Icon.b)
	frame:SetPanelTemplate("Transparent", true)
	frame.Panel:SetPoint("TOPLEFT", frame.Icon.b, "TOPLEFT", -4, 4)
	frame.Panel:SetPoint("BOTTOMRIGHT", frame.Icon.b, "BOTTOMRIGHT", 180, -4)

	local frame = BonusRollLootWonFrame;
	frame:SetAlpha(1)
	hooksecurefunc(frame, "SetAlpha", AlphaHelper)
	frame.Background:MUNG()
	frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	frame.IconBorder:MUNG()
	frame.glow:MUNG()
	frame.shine:MUNG()
	frame.Icon.b = CreateFrame("Frame", nil, frame)
	frame.Icon.b:SetFixedPanelTemplate("Default")
	frame.Icon.b:WrapOuter(frame.Icon)
	frame.Icon:SetParent(frame.Icon.b)
	frame:SetPanelTemplate("Transparent", true)
	frame.Panel:SetPoint("TOPLEFT", frame.Icon.b, "TOPLEFT", -4, 4)
	frame.Panel:SetPoint("BOTTOMRIGHT", frame.Icon.b, "BOTTOMRIGHT", 180, -4)
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveCustomStyle(AlertStyle)
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
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain:GetModule('SVBar');

local microIcons={
	[1]=[[Interface\AddOns\SVUI\assets\artwork\Icons\CHARACTER]],
	[2]=[[Interface\AddOns\SVUI\assets\artwork\Icons\SPELLBOOK]],
	[3]=[[Interface\AddOns\SVUI\assets\artwork\Icons\TALENTS]],
	[4]=[[Interface\AddOns\SVUI\assets\artwork\Icons\ACHIEVEMENTS]],
	[5]=[[Interface\AddOns\SVUI\assets\artwork\Icons\QUESTS]],
	[6]=[[Interface\AddOns\SVUI\assets\artwork\Icons\GUILD]],
	[7]=[[Interface\AddOns\SVUI\assets\artwork\Icons\PVP]],
	[8]=[[Interface\AddOns\SVUI\assets\artwork\Icons\LFD]],
	[9]=[[Interface\AddOns\SVUI\assets\artwork\Icons\ENCOUNTERS]],
  [10]=[[Interface\AddOns\SVUI\assets\artwork\Icons\STORE]],
	[11]=[[Interface\AddOns\SVUI\assets\artwork\Icons\COMPANIONS]],
	[12]=[[Interface\AddOns\SVUI\assets\artwork\Icons\SYSTEM]],
  [13]=[[Interface\AddOns\SVUI\assets\artwork\Icons\HELP]],
}
local MICRO_BUTTONS = {
  "CharacterMicroButton",
  "SpellbookMicroButton",
  "TalentMicroButton",
  "AchievementMicroButton",
  "QuestLogMicroButton",
  "GuildMicroButton",
  "PVPMicroButton",
  "LFDMicroButton",
  "EJMicroButton",
  "StoreMicroButton",
  "CompanionsMicroButton",
  "MainMenuMicroButton",
  "HelpMicroButton",
}
--[[ 
########################################################## 
PACKAGE PLUGIN
##########################################################
]]--
function MOD:MainMenuMicroButton_SetNormal()
  local level = MainMenuMicroButton:GetFrameLevel()
  if(level > 0) then 
      MainMenuMicroButton:SetFrameLevel(level - 1)
  else 
      MainMenuMicroButton:SetFrameLevel(0)
  end
  MainMenuMicroButton:SetFrameStrata("BACKGROUND")
  MainMenuMicroButton.overlay:SetFrameLevel(level + 1)
  MainMenuMicroButton.overlay:SetFrameStrata("HIGH")
  MainMenuBarPerformanceBar:Hide()
  HelpMicroButton:Show()
end;

function MOD:UpdateMicroButtonsParent(parent)
	if parent~=SVUI_MicroBar then parent=SVUI_MicroBar end;
	for i=1,#MICRO_BUTTONS do 
		_G[MICRO_BUTTONS[i]]:SetParent(SVUI_MicroBar)
	end 
end;

function MOD:RefreshMicrobarButtons()
	if not SVUI_MicroBar then return end;
	local lastParent = SVUI_MicroBar;
	local buttonSize =  MOD.db.Micro.buttonsize or 30;
  local spacing =  MOD.db.Micro.buttonspacing or 1;
  local barWidth = (buttonSize + spacing) * 13;
  SVUI_MicroBar:Size(barWidth, buttonSize + 6)
  SVUI_MicroBar:Point('TOP',SuperVillain.UIParent,'TOP',0,4)
	for i=1,13 do 
		local button=_G[MICRO_BUTTONS[i]]
		button:ClearAllPoints()
		button:Size(buttonSize, buttonSize + 28)
		if lastParent==SVUI_MicroBar then 
			button:SetPoint("BOTTOMLEFT",lastParent,"BOTTOMLEFT",1,1)
		else 
			button:SetPoint('LEFT',lastParent,'RIGHT',spacing,0)
		end;
		lastParent=button;
    button:Show()
	end;
end;

function MOD:UpdateBarOptions()
  if InCombatLockdown() or not MOD.IsLoaded then return end;
  if (MOD.db.Bar2.enable ~= InterfaceOptionsActionBarsPanelBottomRight:GetChecked()) then 
    InterfaceOptionsActionBarsPanelBottomRight:Click()
  end;
  if (MOD.db.Bar3.enable ~= InterfaceOptionsActionBarsPanelRightTwo:GetChecked()) then 
    InterfaceOptionsActionBarsPanelRightTwo:Click()
  end;
  if (MOD.db.Bar4.enable ~= InterfaceOptionsActionBarsPanelRight:GetChecked()) then 
    InterfaceOptionsActionBarsPanelRight:Click()
  end;
  if (MOD.db.Bar5.enable ~= InterfaceOptionsActionBarsPanelBottomLeft:GetChecked()) then 
    InterfaceOptionsActionBarsPanelBottomLeft:Click()
  end;
end;

function MOD:UpdateMicroButtons()
  if(not MOD.db.Micro.mouseover) then
    SVUI_MicroBar:SetAlpha(1)
    SVUI_MicroBar.screenMarker:SetAlpha(0)
  else
    SVUI_MicroBar:SetAlpha(0)
    SVUI_MicroBar.screenMarker:SetAlpha(1)
  end
	GuildMicroButtonTabard:ClearAllPoints();
	GuildMicroButtonTabard:Hide();
	MOD:RefreshMicrobarButtons()
end;

function MOD:CreateMicroBar()
  local buttonSize = MOD.db.Micro.buttonsize or 30;
  local spacing =  MOD.db.Micro.buttonspacing or 1;
  local barWidth = (buttonSize + spacing) * 13;
  local microBar = CreateFrame('Frame','SVUI_MicroBar',SuperVillain.UIParent)
  microBar:Size(barWidth,buttonSize + 6)
  microBar:SetFrameStrata("HIGH")
  microBar:SetFrameLevel(0)
  microBar:Point('TOP',SuperVillain.UIParent,'TOP',0,4)
  --microBar:SetPanelTemplate("Default")
  SuperVillain:AddToDisplayAudit(microBar)
  for i=1,13 do
  	local button = _G[MICRO_BUTTONS[i]]
  	button:SetParent(SVUI_MicroBar)
  	button:Size(buttonSize, buttonSize + 28)
  	button.Flash:SetTexture(nil)
  	if button:GetPushedTexture()then 
  		button:SetPushedTexture(nil)
  	end;
  	if button:GetNormalTexture()then 
  		button:SetNormalTexture(nil)
  	end;
  	if button:GetDisabledTexture()then 
  		button:SetDisabledTexture(nil)
  	end;
    if button:GetHighlightTexture()then 
      button:SetHighlightTexture(nil)
    end;
  	local buttonMask = CreateFrame("Frame",nil,button)
  	buttonMask:SetPoint("TOPLEFT",button,"TOPLEFT",0,-28)
  	buttonMask:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",0,0)
  	buttonMask:SetFixedPanelTemplate("Default")
  	buttonMask.icon = buttonMask:CreateTexture(nil,"OVERLAY",nil,2)
  	buttonMask.icon:FillInner(buttonMask,2,2)
  	buttonMask.icon:SetTexture(microIcons[i])
  	buttonMask.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
  	button.overlay = buttonMask;
  	button:HookScript('OnEnter',function(i)
  		if InCombatLockdown()then return end;
  		i.overlay:SetPanelColor("highlight")
      i.overlay.icon:SetGradient(unpack(SuperVillain.Colors.gradient.light))
      if(not MOD.db.Micro.mouseover) then return end
      SuperVillain:SecureFadeIn(SVUI_MicroBar,0.2,SVUI_MicroBar:GetAlpha(),1)
      SuperVillain:SecureFadeOut(SVUI_MicroBar.screenMarker,0.1,SVUI_MicroBar:GetAlpha(),0)
  	end)
  	button:HookScript('OnLeave',function(i)
  		if InCombatLockdown()then return end;
      i.overlay:SetPanelColor("default")
  		i.overlay.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
      if(not MOD.db.Micro.mouseover) then return end
      SuperVillain:SecureFadeOut(SVUI_MicroBar,1,SVUI_MicroBar:GetAlpha(),0)
      SuperVillain:SecureFadeIn(SVUI_MicroBar.screenMarker,5,SVUI_MicroBar:GetAlpha(),1)
  	end)
    button:Show()
  end;
  MicroButtonPortrait:ClearAllPoints()
  MicroButtonPortrait:Hide()
  MainMenuBarPerformanceBar:ClearAllPoints()
  MainMenuBarPerformanceBar:Hide()
  MOD:SecureHook('MainMenuMicroButton_SetNormal')
  MOD:SecureHook('UpdateMicroButtonsParent')
  MOD:SecureHook('MoveMicroButtons','RefreshMicrobarButtons')
  MOD:SecureHook('UpdateMicroButtons')
  UpdateMicroButtonsParent(microBar)
  MOD:MainMenuMicroButton_SetNormal()
  MOD:RefreshMicrobarButtons()
  microBar.screenMarker = CreateFrame('Frame',nil,SuperVillain.UIParent)
  microBar.screenMarker:Point('TOP',SuperVillain.UIParent,'TOP',0,2)
  microBar.screenMarker:Size(20,20)
  microBar.screenMarker:SetFrameStrata("BACKGROUND")
  microBar.screenMarker:SetFrameLevel(4)
  microBar.screenMarker.icon = microBar.screenMarker:CreateTexture(nil,'OVERLAY')
  microBar.screenMarker.icon:SetAllPoints(microBar.screenMarker)
  microBar.screenMarker.icon:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Icons\\DOWN-ARROW")
  microBar.screenMarker.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
  SVUI_MicroBar:SetAlpha(0)
  MOD:UpdateBarOptions()
end;
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
--[[ 
########################################################## 
PACKAGE PLUGIN
##########################################################
]]--
function MOD:RemoveDefaults()
  local removalManager=CreateFrame("Frame")
  removalManager:Hide()
  MultiBarBottomLeft:SetParent(removalManager)
  MultiBarBottomRight:SetParent(removalManager)
  MultiBarLeft:SetParent(removalManager)
  MultiBarRight:SetParent(removalManager)
  for i=1,12 do 
  	_G["ActionButton"..i]:Hide()
  	_G["ActionButton"..i]:UnregisterAllEvents()
  	_G["ActionButton"..i]:SetAttribute("statehidden",true)
  	_G["MultiBarBottomLeftButton"..i]:Hide()
  	_G["MultiBarBottomLeftButton"..i]:UnregisterAllEvents()
  	_G["MultiBarBottomLeftButton"..i]:SetAttribute("statehidden",true)
  	_G["MultiBarBottomRightButton"..i]:Hide()
  	_G["MultiBarBottomRightButton"..i]:UnregisterAllEvents()
  	_G["MultiBarBottomRightButton"..i]:SetAttribute("statehidden",true)
  	_G["MultiBarRightButton"..i]:Hide()
  	_G["MultiBarRightButton"..i]:UnregisterAllEvents()
  	_G["MultiBarRightButton"..i]:SetAttribute("statehidden",true)
  	_G["MultiBarLeftButton"..i]:Hide()
  	_G["MultiBarLeftButton"..i]:UnregisterAllEvents()
  	_G["MultiBarLeftButton"..i]:SetAttribute("statehidden",true)
  	if _G["VehicleMenuBarActionButton"..i] then 
  		_G["VehicleMenuBarActionButton"..i]:Hide()
  		_G["VehicleMenuBarActionButton"..i]:UnregisterAllEvents()
  		_G["VehicleMenuBarActionButton"..i]:SetAttribute("statehidden",true)
  	end;
  	if _G['OverrideActionBarButton'..i] then 
  		_G['OverrideActionBarButton'..i]:Hide()
  		_G['OverrideActionBarButton'..i]:UnregisterAllEvents()
  		_G['OverrideActionBarButton'..i]:SetAttribute("statehidden",true)
  	end;
  	_G['MultiCastActionButton'..i]:Hide()
  	_G['MultiCastActionButton'..i]:UnregisterAllEvents()
  	_G['MultiCastActionButton'..i]:SetAttribute("statehidden",true)
  end;
  ActionBarController:UnregisterAllEvents()
  ActionBarController:RegisterEvent('UPDATE_EXTRA_ACTIONBAR')
  MainMenuBar:EnableMouse(false)
  MainMenuBar:SetAlpha(0)
  MainMenuExpBar:UnregisterAllEvents()
  MainMenuExpBar:Hide()
  MainMenuExpBar:SetParent(removalManager)
  local maxChildren = MainMenuBar:GetNumChildren();
  for i=1,maxChildren do
  	local child=select(i,MainMenuBar:GetChildren())
  	if child then 
  		child:UnregisterAllEvents()
  		child:Hide()
  		child:SetParent(removalManager)
  	end 
  end;
  ReputationWatchBar:UnregisterAllEvents()
  ReputationWatchBar:Hide()
  ReputationWatchBar:SetParent(removalManager)
  MainMenuBarArtFrame:UnregisterEvent("ACTIONBAR_PAGE_CHANGED")
  MainMenuBarArtFrame:UnregisterEvent("ADDON_LOADED")
  MainMenuBarArtFrame:Hide()
  MainMenuBarArtFrame:SetParent(removalManager)
  StanceBarFrame:UnregisterAllEvents()
  StanceBarFrame:Hide()
  StanceBarFrame:SetParent(removalManager)
  OverrideActionBar:UnregisterAllEvents()
  OverrideActionBar:Hide()
  OverrideActionBar:SetParent(removalManager)
  PossessBarFrame:UnregisterAllEvents()
  PossessBarFrame:Hide()
  PossessBarFrame:SetParent(removalManager)
  PetActionBarFrame:UnregisterAllEvents()
  PetActionBarFrame:Hide()
  PetActionBarFrame:SetParent(removalManager)
  MultiCastActionBarFrame:UnregisterAllEvents()
  MultiCastActionBarFrame:Hide()
  MultiCastActionBarFrame:SetParent(removalManager)
  IconIntroTracker:UnregisterAllEvents()
  IconIntroTracker:Hide()
  IconIntroTracker:SetParent(removalManager)
  InterfaceOptionsCombatPanelActionButtonUseKeyDown:SetScale(0.0001)
  InterfaceOptionsCombatPanelActionButtonUseKeyDown:SetAlpha(0)
  InterfaceOptionsActionBarsPanelAlwaysShowActionBars:EnableMouse(false)
  InterfaceOptionsActionBarsPanelPickupActionKeyDropDownButton:SetScale(0.0001)
  InterfaceOptionsActionBarsPanelLockActionBars:SetScale(0.0001)
  InterfaceOptionsActionBarsPanelAlwaysShowActionBars:SetAlpha(0)
  InterfaceOptionsActionBarsPanelPickupActionKeyDropDownButton:SetAlpha(0)
  InterfaceOptionsActionBarsPanelLockActionBars:SetAlpha(0)
  InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:SetAlpha(0)
  InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:SetScale(0.00001)
  InterfaceOptionsStatusTextPanelXP:SetAlpha(0)
  InterfaceOptionsStatusTextPanelXP:SetScale(0.00001)
  if PlayerTalentFrame then
    PlayerTalentFrame:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
  else
    hooksecurefunc("TalentFrame_LoadUI", function() PlayerTalentFrame:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED") end)
  end
end;
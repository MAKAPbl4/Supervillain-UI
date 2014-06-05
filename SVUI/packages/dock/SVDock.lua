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
local MOD = SuperVillain:NewModule('SVDock', 'AceHook-3.0', 'AceTimer-3.0');
local LSM = LibStub("LibSharedMedia-3.0")
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local tinsert, wipe, pairs, ipairs, unpack, pcall, select = tinsert, table.wipe, pairs, ipairs, unpack, pcall, select;
local format, gsub, strfind, strmatch, tonumber = format, gsub, strfind, strmatch, tonumber;
--[[ 
########################################################## 
PRE VARS/FUNCTIONS
##########################################################
]]--
local FadeUpdate = function()
  if InCombatLockdown()then return end;
  LeftSuperDock:Hide()
  RightSuperDock:Hide()
end;

local function SetSuperDockStyle(dock)
  if dock.backdrop then return end;
  local backdrop = CreateFrame("Frame", nil, dock)
  backdrop:SetAllPoints(dock)
  backdrop:SetFrameStrata("BACKGROUND")
  backdrop.bg = backdrop:CreateTexture(nil, "BORDER")
  backdrop.bg:FillInner(backdrop)
  backdrop.bg:SetTexture(1, 1, 1, 1)
  backdrop.bg:SetGradientAlpha("VERTICAL", 0, 0, 0, 0.8, 0, 0, 0, 0)
  backdrop.left = backdrop:CreateTexture(nil, "OVERLAY")
  backdrop.left:SetTexture(1, 1, 1, 1)
  backdrop.left:Point("TOPLEFT", 1, -1)
  backdrop.left:Point("BOTTOMLEFT", -1, 1)
  backdrop.left:Width(4)
  backdrop.left:SetGradientAlpha("VERTICAL", 0, 0, 0, 1, 0, 0, 0, 0)
  backdrop.right = backdrop:CreateTexture(nil, "OVERLAY")
  backdrop.right:SetTexture(1, 1, 1, 1)
  backdrop.right:Point("TOPRIGHT", -1, -1)
  backdrop.right:Point("BOTTOMRIGHT", -1, 1)
  backdrop.right:Width(4)
  backdrop.right:SetGradientAlpha("VERTICAL", 0, 0, 0, 1, 0, 0, 0, 0)
  backdrop.bottom = backdrop:CreateTexture(nil, "OVERLAY")
  backdrop.bottom:SetTexture(0, 0, 0, 1)
  backdrop.bottom:Point("BOTTOMLEFT", 1, 1)
  backdrop.bottom:Point("BOTTOMRIGHT", -1, 1)
  backdrop.bottom:Height(4)
  backdrop.top = backdrop:CreateTexture(nil, "OVERLAY")
  backdrop.top:SetTexture(0, 0, 0, 0)
  backdrop.top:Point("TOPLEFT", 1, -1)
  backdrop.top:Point("TOPRIGHT", -1, 1)
  backdrop.top:SetAlpha(0)
  backdrop.top:Height(1)
  return backdrop 
end;

local function Dock_OnEnter(self, ...)
  if InCombatLockdown() then return end;
  self:SetPanelColor("class")
  self.icon:SetGradient(unpack(SuperVillain.Colors.gradient.bizzaro))
  if SuperVillain.db["LeftSuperDockFaded"]then 
    LeftSuperDock:Show()
    UIFrameFadeIn(LeftSuperDock, 0.2, LeftSuperDock:GetAlpha(), 1)
  end;
  if SuperVillain.db["RightSuperDockFaded"]then 
    RightSuperDock:Show()
    UIFrameFadeIn(RightSuperDock, 0.2, RightSuperDock:GetAlpha(), 1)
  end;
  GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 4)
  GameTooltip:ClearLines()
  GameTooltip:AddLine(L["Toggle Docks"], 1, 1, 1)
  GameTooltip:Show()
end;

local function Dock_OnLeave(self, ...)
  if InCombatLockdown() then return end;
  self:SetPanelColor("default")
  self.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
  if SuperVillain.db["LeftSuperDockFaded"]then 
    UIFrameFadeOut(LeftSuperDock, 0.2, LeftSuperDock:GetAlpha(), 0)
    LeftSuperDock.fadeInfo.finishedFunc = LeftSuperDock.fadeFunc 
  end;
  if SuperVillain.db["RightSuperDockFaded"]then 
    UIFrameFadeOut(RightSuperDock, 0.2, RightSuperDock:GetAlpha(), 0)
    RightSuperDock.fadeInfo.finishedFunc = RightSuperDock.fadeFunc 
  end;
  GameTooltip:Hide()
end;

local function DockCall_OnEnter(self, ...)
  if InCombatLockdown() then return end;
  self:SetPanelColor("class")
  self.icon:SetGradient(unpack(SuperVillain.Colors.gradient.bizzaro))
  if SuperVillain.db["LeftSuperDockFaded"]then 
    LeftSuperDock:Show()
    UIFrameFadeIn(LeftSuperDock, 0.2, LeftSuperDock:GetAlpha(), 1)
  end;
  if SuperVillain.db["RightSuperDockFaded"]then 
    RightSuperDock:Show()
    UIFrameFadeIn(RightSuperDock, 0.2, RightSuperDock:GetAlpha(), 1)
  end;
  GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 4)
  GameTooltip:ClearLines()
  GameTooltip:AddLine(L["Show / Hide Phone Lines"], 1, 1, 1)
  GameTooltip:Show()
end;

local function DockCall_OnLeave(self, ...)
  if InCombatLockdown() then return end;
  local color = self.stateColor
  self:SetPanelColor(unpack(color))
  self.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
  GameTooltip:Hide()
end;

local function Dock_OnClick(self)
  GameTooltip:Hide()
  if SuperVillain.db["LeftSuperDockFaded"]then 
    SuperVillain.db["LeftSuperDockFaded"] = nil;
    UIFrameFadeIn(LeftSuperDock, 0.2, LeftSuperDock:GetAlpha(), 1)
  else 
    SuperVillain.db["LeftSuperDockFaded"] = true;
    UIFrameFadeOut(LeftSuperDock, 0.2, LeftSuperDock:GetAlpha(), 0)
    LeftSuperDock.fadeInfo.finishedFunc = LeftSuperDock.fadeFunc 
  end;
  if SuperVillain.db["RightSuperDockFaded"]then 
    SuperVillain.db["RightSuperDockFaded"] = nil;
    UIFrameFadeIn(RightSuperDock, 0.2, RightSuperDock:GetAlpha(), 1)
  else 
    SuperVillain.db["RightSuperDockFaded"] = true;
    UIFrameFadeOut(RightSuperDock, 0.2, RightSuperDock:GetAlpha(), 0)
    RightSuperDock.fadeInfo.finishedFunc = RightSuperDock.fadeFunc 
  end 
end;

local function Button_OnEnter(self, ...)
  self:SetPanelColor("class")
  self.icon:SetGradient(unpack(SuperVillain.Colors.gradient.bizzaro))
  GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 4)
  GameTooltip:ClearLines()
  GameTooltip:AddLine(self.TText, 1, 1, 1)
  GameTooltip:Show()
end;

local function Button_OnLeave(self, ...)
  self:SetPanelColor("default")
  self.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
  GameTooltip:Hide()
end;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:UpdateSuperDock()
  _G["LeftSuperDock"]:Size(MOD.db.dockLeftWidth, MOD.db.dockLeftHeight);
  _G["SuperDockAlertLeft"]:Width(MOD.db.dockLeftWidth);
  _G["SuperDockWindowLeft"]:Size(MOD.db.dockLeftWidth, MOD.db.dockLeftHeight);
  _G["RightSuperDock"]:Size(MOD.db.dockRightWidth, MOD.db.dockRightHeight);
  _G["SuperDockAlertRight"]:Width(MOD.db.dockRightWidth);
  _G["SuperDockWindowRight"]:Size(MOD.db.dockRightWidth, MOD.db.dockRightHeight);
  MOD:BottomPanelVisibility();
  MOD:TopPanelVisibility();
  MOD:UpdateDockBackdrops();
  MOD:ReloadDocklets()
end;

function MOD:DockAlertLeftOpen(child)
  local size = MOD.db.buttonSize or 22;
  SuperDockAlertLeft:Height(size)
  child:ClearAllPoints()
  child:SetAllPoints(SuperDockAlertLeft)
end;

function MOD:DockAlertLeftClose()
  SuperDockAlertLeft:Height(1)
end;

function MOD:DockAlertRightOpen(child)
  local size = MOD.db.buttonSize or 22;
  SuperDockAlertRight:Height(size)
  child:ClearAllPoints()
  child:SetAllPoints(SuperDockAlertRight)
end;

function MOD:DockAlertRightClose()
  SuperDockAlertRight:Height(1)
end;

function MOD:UpdateDockBackdrops()
  if MOD.db.rightDockBackdrop then
    RightSuperDock.backdrop:Show()
    RightSuperDock.backdrop:ClearAllPoints()
    RightSuperDock.backdrop:WrapOuter(RightSuperDock, 4, 4)
  else
    RightSuperDock.backdrop:Hide()
  end
  if MOD.db.leftDockBackdrop then
    LeftSuperDock.backdrop:Show()
    LeftSuperDock.backdrop:ClearAllPoints()
    LeftSuperDock.backdrop:WrapOuter(LeftSuperDock, 4, 4)
  else
    LeftSuperDock.backdrop:Hide()
  end
end;

function MOD:BottomPanelVisibility()
  if MOD.db.bottomPanel then 
    MOD.BottomPanel:Show()
  else 
    MOD.BottomPanel:Hide()
  end 
end;

function MOD:TopPanelVisibility()
  if MOD.db.topPanel then 
    MOD.TopPanel:Show()
  else 
    MOD.TopPanel:Hide()
  end 
end;

function HideSuperDocks()
  Dock_OnClick(LeftDockToggleButton)
end;

function MOD:CreateSuperBorders()
  local texture = SuperVillain.Textures.button;

  local TopPanel = CreateFrame("Frame", "SVUITopPanel", SuperVillain.UIParent)
  TopPanel:Point("TOPLEFT", SuperVillain.UIParent, "TOPLEFT", -1, 1)
  TopPanel:Point("TOPRIGHT", SuperVillain.UIParent, "TOPRIGHT", 1, 1)
  TopPanel:Height(14)
  TopPanel:SetBackdrop({bgFile = texture, edgeFile = [[Interface\BUTTONS\WHITE8X8]], tile = false, tileSize = 0, edgeSize = 1, insets = {left = 0, right = 0, top = 0, bottom = 0}})
  TopPanel:SetBackdropColor(unpack(SuperVillain.Colors.special))
  TopPanel:SetBackdropBorderColor(unpack(SuperVillain.Colors.dark))
  TopPanel:SetFrameLevel(0)
  TopPanel:SetFrameStrata('BACKGROUND')
  MOD.TopPanel = TopPanel;
  MOD.TopPanel:SetScript("OnShow", function(self)
    self:SetFrameLevel(0)
    self:SetFrameStrata('BACKGROUND')
  end)
  MOD:TopPanelVisibility()

  local BottomPanel = CreateFrame("Frame", "SVUIBottomPanel", SuperVillain.UIParent)
  BottomPanel:Point("BOTTOMLEFT", SuperVillain.UIParent, "BOTTOMLEFT", -1, -1)
  BottomPanel:Point("BOTTOMRIGHT", SuperVillain.UIParent, "BOTTOMRIGHT", 1, -1)
  BottomPanel:Height(14)
  BottomPanel:SetBackdrop({bgFile = texture, edgeFile = [[Interface\BUTTONS\WHITE8X8]], tile = false, tileSize = 0, edgeSize = 1, insets = {left = 0, right = 0, top = 0, bottom = 0}})
  BottomPanel:SetBackdropColor(unpack(SuperVillain.Colors.special))
  BottomPanel:SetBackdropBorderColor(unpack(SuperVillain.Colors.dark))
  BottomPanel:SetFrameLevel(0)
  BottomPanel:SetFrameStrata('BACKGROUND')
  MOD.BottomPanel = BottomPanel;
  MOD.BottomPanel:SetScript("OnShow", function(self)
    self:SetFrameLevel(0)
    self:SetFrameStrata('BACKGROUND')
  end)
  MOD:BottomPanelVisibility()
end;

function MOD:CreateDockPanels()
  local leftWidth = MOD.db.dockLeftWidth or 350;
  local leftHeight = MOD.db.dockLeftHeight or 180;
  local rightWidth = MOD.db.dockRightWidth or 350;
  local rightHeight = MOD.db.dockRightHeight or 180;
  local buttonsize = MOD.db.buttonSize or 22;
  local spacing = MOD.db.buttonSpacing or 4;
  local STATS = SuperVillain:GetModule("SVStats");

  local leftbutton = CreateFrame("Button", "LeftSuperDockToggleButton", SuperVillain.UIParent)
  leftbutton:Point("BOTTOMLEFT", SuperVillain.UIParent, "BOTTOMLEFT", 1, 2)
  leftbutton:Size(buttonsize, buttonsize)
  leftbutton:SetFramedButtonTemplate()
  leftbutton.icon = leftbutton:CreateTexture(nil, "OVERLAY")
  leftbutton.icon:FillInner(leftbutton,2,2)
  leftbutton.icon:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\SV-LOGO")
  leftbutton.icon:SetGradient(unpack(SuperVillain.db.media.colors.gradient.light))
  leftbutton:RegisterForClicks("AnyUp")
  leftbutton:SetScript("OnEnter", Dock_OnEnter)
  leftbutton:SetScript("OnLeave", Dock_OnLeave)
  leftbutton:SetScript("OnClick", Dock_OnClick)

  local toolbarLeft = CreateFrame("Button", "SuperDockToolBarLeft", SuperVillain.UIParent)
  toolbarLeft:Point("LEFT", leftbutton, "RIGHT", spacing, 0)
  toolbarLeft:Width(1)
  toolbarLeft:Height(buttonsize)
  toolbarLeft.currentSize = buttonsize + 4;

  local leftToolButton = CreateFrame("Button", "LeftToolBarButton", toolbarLeft)
  leftToolButton:Point("LEFT", toolbarLeft, "LEFT", 3, 0)
  leftToolButton:Size(buttonsize, buttonsize)
  leftToolButton:SetFramedButtonTemplate()
  leftToolButton.icon = leftToolButton:CreateTexture(nil, "OVERLAY")
  leftToolButton.icon:FillInner(leftToolButton,2,2)
  leftToolButton.icon:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\CALL")
  leftToolButton.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
  leftToolButton.stateColor = SuperVillain.Colors.gradient.default
  leftToolButton:RegisterForClicks("AnyUp")
  leftToolButton:SetScript("OnEnter", DockCall_OnEnter)
  leftToolButton:SetScript("OnLeave", DockCall_OnLeave)
  leftToolButton:SetScript("OnShow", function(self)
    local size = SuperDockToolBarLeft.currentSize;
    local parent = self:GetParent()
    parent:SetWidth(size)
  end)
  leftToolButton:Hide()

  local leftstation = CreateFrame("Frame", "SuperDockChatTabBar", SuperVillain.UIParent)
  leftstation:SetFrameStrata("BACKGROUND")
  leftstation:Size(leftWidth - buttonsize, buttonsize)
  leftstation:Point("LEFT", toolbarLeft, "RIGHT", spacing, 0)
  leftstation:SetFrameLevel(leftstation:GetFrameLevel() + 2)
  leftstation.currentSize = buttonsize;

  local leftdock = CreateFrame("Frame", "LeftSuperDock", SuperVillain.UIParent)
  leftdock:SetFrameStrata("BACKGROUND")
  leftdock:Point("BOTTOMLEFT", SuperVillain.UIParent, "BOTTOMLEFT", 1, buttonsize + 10)
  leftdock:Size(leftWidth, leftHeight)
  SuperVillain:SetSVMovable(leftdock, "LeftDock_MOVE", L["Left Dock"])

  local leftalert = CreateFrame("Frame", "SuperDockAlertLeft", leftdock)
  leftalert:SetFrameStrata("BACKGROUND")
  leftalert:Size(leftWidth, 1)
  leftalert:Point("BOTTOMRIGHT", leftdock, "BOTTOMRIGHT",0, 0)
  leftalert:SetFrameLevel(leftalert:GetFrameLevel() + 2)

  local leftwindow = CreateFrame("Frame", "SuperDockWindowLeft", leftdock)
  leftwindow:SetFrameStrata("BACKGROUND")
  leftwindow:Point("BOTTOMRIGHT", leftalert, "TOPRIGHT", 0, 0)
  leftwindow:Size(leftWidth, leftHeight)
  leftdock.backdrop = SetSuperDockStyle(leftwindow)

  LeftSuperDock.fadeFunc = FadeUpdate;

  local rightbutton = CreateFrame("Button", "RightSuperDockToggleButton", SuperVillain.UIParent)
  rightbutton:Point("BOTTOMRIGHT", SuperVillain.UIParent, "BOTTOMRIGHT", -1, 2)
  rightbutton:Size(buttonsize, buttonsize)
  rightbutton:SetFramedButtonTemplate()
  rightbutton.icon = rightbutton:CreateTexture(nil, "OVERLAY")
  rightbutton.icon:FillInner(rightbutton,2,2)
  rightbutton.icon:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\HENCHMAN")
  rightbutton.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
  rightbutton.TText = "Call Henchman!"
  rightbutton:RegisterForClicks("AnyUp")
  rightbutton:SetScript("OnEnter", Button_OnEnter)
  rightbutton:SetScript("OnLeave", Button_OnLeave)
  rightbutton:SetScript("OnClick", function()SuperVillain:ToggleHenchman()end)

  local toolbarRight = CreateFrame("Button", "SuperDockToolBarRight", SuperVillain.UIParent)
  toolbarRight:Point("RIGHT", rightbutton, "LEFT", -spacing, 0)
  toolbarRight:Size(1, buttonsize)
  toolbarRight.currentSize = buttonsize;

  local macrobar = CreateFrame("Button", "SuperDockMacroBar", SuperVillain.UIParent)
  macrobar:Point("RIGHT", toolbarRight, "LEFT", -spacing, 0)
  macrobar:Size(1, buttonsize)
  macrobar.currentSize = buttonsize;

  local breakStuffButton=CreateFrame('Button',"BreakStuffButton",SuperVillain.UIParent)
  breakStuffButton:Point('RIGHT',macrobar,'LEFT',-6,0)
  breakStuffButton:Size(buttonsize,buttonsize)
  breakStuffButton:Hide()

  local rightdock = CreateFrame("Frame", "RightSuperDock", SuperVillain.UIParent)
  rightdock:SetFrameStrata("BACKGROUND")
  rightdock:Point("BOTTOMRIGHT", SuperVillain.UIParent, "BOTTOMRIGHT", -1, buttonsize + 10)
  rightdock:Size(rightWidth, rightHeight)
  SuperVillain:SetSVMovable(rightdock, "RightDock_MOVE", L["Right Dock"])

  local rightalert = CreateFrame("Frame", "SuperDockAlertRight", rightdock)
  rightalert:SetFrameStrata("BACKGROUND")
  rightalert:Size(rightWidth, 1)
  rightalert:Point("BOTTOMLEFT", rightdock, "BOTTOMLEFT", 0, 0)
  rightalert:SetFrameLevel(rightalert:GetFrameLevel() + 2)

  local rightwindow = CreateFrame("Frame", "SuperDockWindowRight", rightdock)
  rightwindow:SetFrameStrata("BACKGROUND")
  rightwindow:Point("BOTTOMLEFT", rightalert, "TOPLEFT", 0, 0)
  rightwindow:Size(rightWidth, rightHeight)
  rightdock.backdrop = SetSuperDockStyle(rightwindow)

  RightSuperDock.fadeFunc = FadeUpdate;

  local topanchor = CreateFrame("Frame", "SuperDockTopDataAnchor", SuperVillain.UIParent)
  topanchor:Size(leftWidth, buttonsize - 8)
  topanchor:Point("TOPLEFT", SuperVillain.UIParent, "TOPLEFT", 0, 2)
  SuperVillain:AddToDisplayAudit(topanchor)

  local topleftdata = CreateFrame("Frame", "TopLeftDataPanel", topanchor)
  topleftdata:SetAllPoints(topanchor)
  STATS:NewAnchor(topleftdata, 3, "ANCHOR_BOTTOMLEFT", 17, -4)

  local bottomanchor = CreateFrame("Frame", "SuperDockBottomDataAnchor", SuperVillain.UIParent)
  bottomanchor:Size((leftWidth + rightWidth) - 2, buttonsize - 8)
  bottomanchor:Point("BOTTOM", SuperVillain.UIParent, "BOTTOM", 0, 2)
  SuperVillain:AddToDisplayAudit(bottomanchor)

  local bottomleftdata = CreateFrame("Frame", "BottomLeftDataPanel", bottomanchor)
  bottomleftdata:Size(leftWidth - 1, buttonsize - 8)
  bottomleftdata:Point("LEFT", bottomanchor, "LEFT", 0, 0)
  STATS:NewAnchor(bottomleftdata, 3, "ANCHOR_CURSOR", 17, 4)

  local bottomrightdata = CreateFrame("Frame", "BottomRightDataPanel", bottomanchor)
  bottomrightdata:Size(rightWidth - 1, buttonsize - 8)
  bottomrightdata:Point("RIGHT", bottomanchor, "RIGHT", 0, 0)
  STATS:NewAnchor(bottomrightdata, 3, "ANCHOR_CURSOR", 17, 4)

  if SuperVillain.db["LeftSuperDockFaded"]then LeftSuperDock:Hide()end;
  if SuperVillain.db["RightSuperDockFaded"]then RightSuperDock:Hide()end;
end;

function MOD:UpdateThisPackage()
	self:UpdateSuperDock();
end;

function MOD:ConstructThisPackage()
  self:Protect("LoadToolBarProfessions")
  self:CreateSuperBorders()
  self:CreateDockPanels()
  self:CreateDockWindow()
  self.PostConstructTimer = self:ScheduleTimer("LoadToolBarProfessions", 5)
  --self:RegisterEvent("PLAYER_REGEN_DISABLED", "DockletEnterCombat")
  --self:RegisterEvent("PLAYER_REGEN_ENABLED", "DockletExitCombat")
  self:DockletInit()
  self:UpdateDockBackdrops()
end;
SuperVillain.Registry:NewPackage(MOD:GetName())
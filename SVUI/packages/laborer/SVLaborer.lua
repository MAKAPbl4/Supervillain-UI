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
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack 	= _G.unpack;
local select 	= _G.select;
local type 		= _G.type;
local string    = _G.string;
local math 		= _G.math;
local table 	= _G.table;
local rept      = string.rep; 
local tsort,twipe = table.sort,table.wipe;
local floor,ceil  = math.floor, math.ceil;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, G = unpack(select(2, ...));
local MOD = SuperVillain:NewModule('SVLaborer', 'AceHook-3.0', 'AceTimer-3.0');
local DOCK = SuperVillain:GetModule('SVDock');
local LSM = LibStub("LibSharedMedia-3.0");
local Deformat = LibStub("LibDeformat-3.0");
SuperVillain.Modes = MOD;
--[[ 
########################################################## 
LOCALIZED GLOBALS
##########################################################
]]--
local LABORER_FONT = SuperVillain.Fonts.system
local LOOT_ITEM_SELF = _G.LOOT_ITEM_SELF;
local LOOT_ITEM_CREATED_SELF = _G.LOOT_ITEM_CREATED_SELF;
local LOOT_ITEM_SELF_MULTIPLE = _G.LOOT_ITEM_SELF_MULTIPLE
local LOOT_ITEM_PUSHED_SELF_MULTIPLE = _G.LOOT_ITEM_PUSHED_SELF_MULTIPLE
local LOOT_ITEM_PUSHED_SELF = _G.LOOT_ITEM_PUSHED_SELF
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local currentModeKey = false;
local ModeAlert = CreateFrame("Frame", "SVUI_ModeAlert", SuperDockAlertRight)
local ModeEventsFrame = CreateFrame("Frame", "SVUI_ModeEventsHandler", UIParent)
local ModeLogsFrame = CreateFrame("Frame", "SVUI_ModeLogsFrame", UIParent)
local classR, classG, classB = 0,0,0
local classA = 0.35
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function SendModeMessage(...)
	if not CombatText_AddMessage then return end;
	CombatText_AddMessage(...)
end;

local function onMouseWheel(self, delta)
	if (delta > 0) then
		self:ScrollUp()
	elseif (delta < 0) then
		self:ScrollDown()
	end
end;

local function ModeEventHandler(self, event, ...)
	if(not currentModeKey or not MOD[currentModeKey]) then return end;
    local handler = MOD[currentModeKey][event]
    if handler then handler(MOD, ...) end
end
--[[ 
########################################################## 
XML FRAME SCRIPT HANDLERS
##########################################################
]]--
function SVUI_ModeCaptureWindow_OnLoad()
	_G["SVUI_ModeCaptureWindow"].Grip = _G["SVUI_ModesHandler"];
	_G["SVUI_ModeCaptureWindow"]:RegisterForClicks("RightButtonUp");
    _G["SVUI_ModeCaptureWindow"].Grip = _G["SVUI_ModesHandler"];
    _G["SVUI_ModeCaptureWindow"]:Hide();
	_G["SVUI_ModeCaptureWindow"]:RegisterEvent("PLAYER_ENTERING_WORLD")
	_G["SVUI_ModeCaptureWindow"]:SetScript('OnEvent', function(self, event, ...)
		local readyToFish, knowFishing, knowArchaeology = false,false,false
		if event == "PLAYER_ENTERING_WORLD" then
			knowFishing = IsSpellKnown(131474)
			knowArchaeology = IsSpellKnown(80451)
			knowCooking = IsSpellKnown(818)
			if (knowFishing or knowArchaeology or knowCooking) then MOD:SetModeWorldEvents() end
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end
	end)
end;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:LaborerReset()
	MOD.TitleWindow:Clear();
	MOD.LogWindow:Clear();
	MOD.TitleWindow:AddMessage("Laborer Modes", 1, 1, 0);
	MOD.LogWindow:AddMessage("Select a Tool to Begin", 1, 1, 1);
	MOD.LogWindow:AddMessage(" ", 0, 1, 1);
end

function MOD:ModeLootLoader(mode, msg, info)
	MOD.TitleWindow:Clear();
	MOD.LogWindow:Clear();
	ModeAlert.HelpText = info
	if(mode and MOD[mode]) then
		if(MOD[mode].Log) then
			local stored = MOD[mode].Log;
			MOD.TitleWindow:AddMessage(msg, 1, 1, 1);
			local previous = false
			for name,data in pairs(stored) do
				if type(data) == "table" and data.amount and data.texture then
					MOD.LogWindow:AddMessage("|cff55FF55"..data.amount.." x|r |T".. data.texture ..":16:16:0:0:64:64:4:60:4:60|t".." "..name, 0.8, 0.8, 0.8);
					previous = true
				end
			end;
			if(previous) then
				MOD.LogWindow:AddMessage("----------------", 0, 0, 0);
				MOD.LogWindow:AddMessage(" ", 0, 0, 0);
			end
			MOD.LogWindow:AddMessage(info, 1, 1, 1);
			MOD.LogWindow:AddMessage(" ", 1, 1, 1);
		end
	else
		MOD:LaborerReset()
	end;
end

function MOD:CheckForModeLoot(msg)
  	local item, amt = Deformat(msg, LOOT_ITEM_CREATED_SELF)
	if not item then
	  item = Deformat(msg, LOOT_ITEM_SELF_MULTIPLE)
	  	if not item then
		  item = Deformat(msg, LOOT_ITEM_SELF)
		  	if not item then
		      	item = Deformat(msg, LOOT_ITEM_PUSHED_SELF_MULTIPLE)
		      	if not item then
		        	item, amt = Deformat(msg, LOOT_ITEM_PUSHED_SELF)
		        	--print(item)
		      	end
		    end
		end
	end
	--print(msg)
	if item then
		if not amt then
		  	amt = 1
		end
		return item, amt
	end
end;

function MOD:CheckForDoubleClick()
	if self.LastModeClick then
		local pressTime = GetTime()
		local doubleTime = pressTime - self.LastModeClick
		if ( (doubleTime < 0.4) and (doubleTime > 0.05) ) then
			self.LastModeClick = nil
			return true
		end
	end
	self.LastModeClick = GetTime()
	return false
end

function MOD:SetJobMode(category)
	if InCombatLockdown() then return end
	if(not category) then 
		self:EndJobModes()
		return;
	end;
	self:ChangeModeGear()
	if(currentModeKey and self[currentModeKey] and self[currentModeKey].Disable) then
		self[currentModeKey].Disable()
	end
	currentModeKey = category;
	if(self[category] and self[category].Enable) then
		self[category].Enable()
	else
		self:EndJobModes()
		return;
	end
end

function MOD:EndJobModes()
	if(currentModeKey and self[currentModeKey] and self[currentModeKey].Disable) then
		self[currentModeKey].Disable()
	end
	currentModeKey = false;
	if SVUI_ModesDockFrame:IsShown() then SVUI_ModesDockFrame_ToolBarButton:Click() end
	self:ChangeModeGear()
	SVUI_ModeAlert:Hide();
	SendModeMessage("Mode Disabled", CombatText_StandardScroll, 1, 0.35, 0);
	PlaySound("UndeadExploration");
end

function MOD:SetModeWorldEvents()
	WorldFrame:HookScript("OnMouseDown", function(...)
		if InCombatLockdown() then return end
		local button = select(2, ...)
		if currentModeKey and button == "RightButton" and MOD:CheckForDoubleClick() then
			local handle = MOD[currentModeKey];
			if(handle and handle.Bind) then
				handle.Bind()
			end
		end
	end)
end

function MOD:ChangeModeGear()
	if(not self.InModeGear) then return end
	if InCombatLockdown() then
		_G["SVUI_ModeCaptureWindow"]:RegisterEvent("PLAYER_REGEN_ENABLED", "ChangeModeGear");
		return
	else
		_G["SVUI_ModeCaptureWindow"]:UnregisterEvent("PLAYER_REGEN_ENABLED");

		if(self.WornItems["HEAD"]) then
			EquipItemByName(self.WornItems["HEAD"])
			self.WornItems["HEAD"] = false
		end
		if(self.WornItems["TAB"]) then
			EquipItemByName(self.WornItems["TAB"])
			self.WornItems["TAB"] = false
		end
		if(self.WornItems["MAIN"]) then
			EquipItemByName(self.WornItems["MAIN"])
			self.WornItems["MAIN"] = false
		end
		if(self.WornItems["OFF"]) then
			EquipItemByName(self.WornItems["OFF"])
			self.WornItems["OFF"] = false
		end

		self.InModeGear = false
	end
end

function MOD:UpdateLogWindow()
 	MOD.LogWindow:SetFont(LABORER_FONT, MOD.db.fontSize, "OUTLINE")
end

function MOD:EnableListener()
	if self.ListenerEnabled == true then return end;
	ModeEventsFrame:SetScript("OnEvent", ModeEventHandler)
	self.ListenerEnabled = true
end

function MOD:DisableListener()
	if not self.ListenerEnabled then return end;
	ModeEventsFrame:SetScript("OnEvent", nil)
	self:LaborerReset()
	self.ListenerEnabled = false
end

function MOD:MakeLogWindow()
	local DOCK_WIDTH = SVUI_ModesDockFrame:GetWidth();
	local DOCK_HEIGHT = SVUI_ModesDockFrame:GetHeight();

	ModeLogsFrame:SetFrameStrata("MEDIUM")
	ModeLogsFrame:SetPoint("TOPLEFT",SVUI_ModeButton1,"TOPRIGHT",5,-5)
	ModeLogsFrame:SetPoint("BOTTOMRIGHT",SVUI_ModesDockFrame,"BOTTOMRIGHT",-5,5)
	ModeLogsFrame:SetParent(SVUI_ModesDockFrame)

	local title = CreateFrame("ScrollingMessageFrame", nil, ModeLogsFrame)
	title:SetSpacing(4)
	title:SetClampedToScreen(false)
	title:SetFrameStrata("MEDIUM")
	title:SetPoint("TOPLEFT",ModeLogsFrame,"TOPLEFT",0,0)
	title:SetPoint("BOTTOMRIGHT",ModeLogsFrame,"TOPRIGHT",0,-20)
	title:SetFontTemplate(UNIT_NAME_FONT, 16, "OUTLINE", "CENTER", "MIDDLE")
	title:SetMaxLines(1)
	title:EnableMouseWheel(false)
	title:SetFading(false)
	title:SetInsertMode('TOP')

	title.divider = title:CreateTexture(nil,"OVERLAY")
    title.divider:SetTexture(classR, classG, classB)
    title.divider:SetAlpha(classA)
    title.divider:SetPoint("BOTTOMLEFT")
    title.divider:SetPoint("BOTTOMRIGHT")
    title.divider:SetHeight(1)

    local topleftline = title:CreateTexture(nil,"OVERLAY")
    topleftline:SetTexture(classR, classG, classB)
    topleftline:SetAlpha(classA)
    topleftline:SetPoint("TOPLEFT")
    topleftline:SetPoint("BOTTOMLEFT")
    topleftline:SetWidth(1)

	local log = CreateFrame("ScrollingMessageFrame", nil, ModeLogsFrame)
	log:SetSpacing(4)
	log:SetClampedToScreen(false)
	log:SetFrameStrata("MEDIUM")
	log:SetPoint("TOPLEFT",title,"BOTTOMLEFT",0,0)
	log:SetPoint("BOTTOMRIGHT",ModeLogsFrame,"BOTTOMRIGHT",0,0)
	log:SetFont(LABORER_FONT, MOD.db.fontSize, "OUTLINE")
	log:SetJustifyH("CENTER")
	log:SetJustifyV("MIDDLE")
	log:SetShadowColor(0, 0, 0, 0)
	log:SetMaxLines(120)
	log:EnableMouseWheel(true)
	log:SetScript("OnMouseWheel", onMouseWheel)
	log:SetFading(false)
	log:SetInsertMode('TOP')

	local bottomleftline = log:CreateTexture(nil,"OVERLAY")
    bottomleftline:SetTexture(classR, classG, classB)
    bottomleftline:SetAlpha(classA)
    bottomleftline:SetPoint("TOPLEFT")
    bottomleftline:SetPoint("BOTTOMLEFT")
    bottomleftline:SetWidth(1)

	MOD.TitleWindow = title
	MOD.LogWindow = log

	MOD.ListenerEnabled = false;
	SuperVillain:GetModule('SVDock'):RegisterDocklet("SVUI_ModesDockFrame", "Laborer Modes", "Interface\\Addons\\SVUI\\assets\\artwork\\Icons\\LABORER", false)
	MOD:LaborerReset()
end

function MOD:SKILL_LINES_CHANGED()
	MOD:UpdateFishingMode()
	MOD:UpdateArchaeologyMode()
	MOD:UpdateCookingMode()
end
--[[ 
########################################################## 
BUILD FUNCTION / UPDATE
##########################################################
]]--
-- function MOD:UpdateThisPackage() end;

function MOD:ConstructThisPackage()
	classR, classG, classB = SuperVillain.Colors.class[1], SuperVillain.Colors.class[2], SuperVillain.Colors.class[3]
	LABORER_FONT = LSM:Fetch("font", SuperVillain.protected.common.font)
	local _,_,arch,_,cook,_ = GetProfessions();
	self.ArcheologyToggle = false;
	if arch ~= nil then
		local name,_,_,_,_,_,_,_,_,_ = GetProfessionInfo(arch)
		self.ArcheologyToggle = name
	end;
	self.CookingToggle = false;
	if cook ~= nil then
		local name,_,_,_,_,_,_,_,_,_ = GetProfessionInfo(cook)
		self.CookingToggle = name
	end;
	self.BackupToggle = false;
	self.WornItems = {};
	self.LastModeClick = nil;
	self.ModeSpellToCast = GetSpellInfo(131474);
	self.ModeSpellIsKnown = IsSpellKnown(131474);
	self.InModeGear = false;
	local ALERT_HEIGHT = 60;
	local DOCK_WIDTH = SuperDockWindowRight:GetWidth();
	local DOCK_HEIGHT = SuperDockWindowRight:GetHeight();
	local BUTTON_SIZE = (DOCK_HEIGHT * 0.25) - 4;

	local modesDocklet = CreateFrame("Frame", "SVUI_ModesDockFrame", SuperDockWindowRight)
	modesDocklet:SetWidth(DOCK_WIDTH - 4);
	modesDocklet:SetHeight(DOCK_HEIGHT - 4);
	modesDocklet:SetPoint("CENTER",SuperDockWindowRight,"CENTER",0,0);

	local modesToolBar = CreateFrame("Frame", "SVUI_ModesDockToolBar", modesDocklet)
	modesToolBar:SetWidth(BUTTON_SIZE + 4);
	modesToolBar:SetHeight((BUTTON_SIZE + 4) * 4);
	modesToolBar:SetPoint("BOTTOMLEFT",modesDocklet,"BOTTOMLEFT",0,0);

	local mode4Button = CreateFrame("Frame", "SVUI_ModeButton4", modesToolBar)
	mode4Button:SetPoint("BOTTOM",modesToolBar,"BOTTOM",0,0)
	mode4Button:SetSize(BUTTON_SIZE,BUTTON_SIZE)
	mode4Button.icon = mode4Button:CreateTexture(nil, 'OVERLAY')
	mode4Button.icon:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\Farming")
	mode4Button.icon:FillInner(mode4Button)
	mode4Button.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
	mode4Button:SetScript('OnEnter', function(self)
		if InCombatLockdown() then return; end
		self.icon:SetGradient(unpack(SuperVillain.Colors.gradient.yellow))
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 4)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L["Farming Mode"], 1, 1, 1)
		GameTooltip:Show()
	end)
	mode4Button:SetScript('OnLeave', function(self)
		if InCombatLockdown() then return; end
		self.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
		GameTooltip:Hide()
	end)
	mode4Button:SetScript('OnMouseDown', function(self)
		MOD:SetJobMode("Farming")
	end)

	local mode3Button = CreateFrame("Frame", "SVUI_ModeButton3", modesToolBar)
	mode3Button:SetPoint("BOTTOM",mode4Button,"TOP",0,2)
	mode3Button:SetSize(BUTTON_SIZE,BUTTON_SIZE)
	mode3Button.icon = mode3Button:CreateTexture(nil, 'OVERLAY')
	mode3Button.icon:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\Survey")
	mode3Button.icon:FillInner(mode3Button)
	mode3Button.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
	mode3Button:SetScript('OnEnter', function(self)
		if InCombatLockdown() then return; end
		self.icon:SetGradient(unpack(SuperVillain.Colors.gradient.yellow))
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 4)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L["Archeology Mode"], 1, 1, 1)
		GameTooltip:Show()
	end)
	mode3Button:SetScript('OnLeave', function(self)
		if InCombatLockdown() then return; end
		self.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
		GameTooltip:Hide()
	end)
	mode3Button:SetScript('OnMouseDown', function(self)
		MOD:SetJobMode("Archaeology")
	end)

	local mode2Button = CreateFrame("Frame", "SVUI_ModeButton2", modesToolBar)
	mode2Button:SetPoint("BOTTOM",mode3Button,"TOP",0,2)
	mode2Button:SetSize(BUTTON_SIZE,BUTTON_SIZE)
	mode2Button.icon = mode2Button:CreateTexture(nil, 'OVERLAY')
	mode2Button.icon:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\Fishing")
	mode2Button.icon:FillInner(mode2Button)
	mode2Button.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
	mode2Button:SetScript('OnEnter', function(self)
		if InCombatLockdown() then return; end
		self.icon:SetGradient(unpack(SuperVillain.Colors.gradient.yellow))
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 4)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L["Fishing Mode"], 1, 1, 1)
		GameTooltip:Show()
	end)
	mode2Button:SetScript('OnLeave', function(self)
		if InCombatLockdown() then return; end
		self.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
		GameTooltip:Hide()
	end)
	mode2Button:SetScript('OnMouseDown', function(self)
		MOD:SetJobMode("Fishing")
	end)

	local mode1Button = CreateFrame("Frame", "SVUI_ModeButton1", modesToolBar)
	mode1Button:SetPoint("BOTTOM",mode2Button,"TOP",0,2)
	mode1Button:SetSize(BUTTON_SIZE,BUTTON_SIZE)
	mode1Button.icon = mode1Button:CreateTexture(nil, 'OVERLAY')
	mode1Button.icon:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\Cooking")
	mode1Button.icon:FillInner(mode1Button)
	mode1Button.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
	mode1Button:SetScript('OnEnter', function(self)
		if InCombatLockdown() then return; end
		self.icon:SetGradient(unpack(SuperVillain.Colors.gradient.yellow))
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 4)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L["Cooking Mode"], 1, 1, 1)
		GameTooltip:Show()
	end)
	mode1Button:SetScript('OnLeave', function(self)
		if InCombatLockdown() then return; end
		self.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
		GameTooltip:Hide()
	end)
	mode1Button:SetScript('OnMouseDown', function(self)
		MOD:SetJobMode("Cooking")
	end)

	ModeAlert:SetAllPoints(SuperDockAlertRight)
	ModeAlert:SetBackdrop({
        bgFile = "Interface\\AddOns\\SVUI\\assets\\artwork\\Bars\\HALFTONE",
        edgeFile = [[Interface\BUTTONS\WHITE8X8]],
        tile = true,
        tileSize = 64,
        edgeSize = 1,
        insets = {
            left = 1,
            right = 1,
            top = 1,
            bottom = 1
        }
    })
	ModeAlert:SetBackdropBorderColor(0,0,0,1)
	ModeAlert:SetBackdropColor(0.25, 0.52, 0.1)
	ModeAlert.text = ModeAlert:CreateFontString(nil, 'ARTWORK', 'GameFontWhite')
	ModeAlert.text:SetAllPoints(ModeAlert)
	ModeAlert.text:SetTextColor(1, 1, 1)
	ModeAlert.text:SetJustifyH("CENTER")
	ModeAlert.text:SetJustifyV("MIDDLE")
	ModeAlert.text:SetText("Click to Exit")
	ModeAlert.ModeText = "Click to Exit";
	ModeAlert.HelpText = "";
	ModeAlert:SetScript('OnEnter', function(self)
		if InCombatLockdown() then return; end
		self:SetBackdropColor(0.9, 0.15, 0.1)
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 4)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(self.ModeText, 1, 1, 0)
		GameTooltip:AddLine("")
		GameTooltip:AddLine("Click here end this mode.", 0.79, 0.23, 0.23)
		GameTooltip:AddLine("")
		GameTooltip:AddLine(self.HelpText, 0.74, 1, 0.57)
		GameTooltip:Show()
	end)
	ModeAlert:SetScript('OnLeave', function(self)
		GameTooltip:Hide()
		if InCombatLockdown() then return end;
		self:SetBackdropColor(0.25, 0.52, 0.1)
	end)
	ModeAlert:SetScript('OnHide', function()
		DOCK:DockAlertRightClose()
	end)
	ModeAlert:SetScript('OnShow', function(self)
		if InCombatLockdown() then 
			SuperVillain:AddonMessage(ERR_NOT_IN_COMBAT); 
			self:Hide() 
			return; 
		end
		UIFrameFadeIn(self, 0.3, 0, 1)
		DOCK:DockAlertRightOpen(self)
	end)
	ModeAlert:SetScript('OnMouseDown', function(self)
		MOD:EndJobModes()
		UIFrameFadeOut(self, 0.5, 1, 0)
		SuperVillain:SetTimeout(0.5, function() self:Hide() end)	
	end)
	ModeAlert:Hide()
	self:MakeLogWindow()
	modesDocklet:Hide()
	self:LoadCookingMode()
	self:LoadFishingMode()
	self:LoadArchaeologyMode()
	self:PrepareFarmingTools()
	self:RegisterEvent("SKILL_LINES_CHANGED")
end
SuperVillain.Registry:NewPackage(MOD:GetName());
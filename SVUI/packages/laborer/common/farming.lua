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
local MOD = SuperVillain:GetModule('SVLaborer');
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local NUM_SEED_BARS = 7
local seedButtons,farmToolButtons,portalButtons = {},{},{};
local ModeEventsFrame, DockButton, ModeAlert, ModeLogsFrame;
local refSeeds = {[79102]={1},[89328]={1},[80590]={1},[80592]={1},[80594]={1},[80593]={1},[80591]={1},[89329]={1},[80595]={1},[89326]={1},[80809]={3},[95434]={4},[89848]={3},[95437]={4},[84782]={3},[95436]={4},[85153]={3},[95438]={4},[85162]={3},[95439]={4},[85158]={3},[95440]={4},[84783]={3},[95441]={4},[89849]={3},[95442]={4},[85163]={3},[95443]={4},[89847]={3},[95444]={4},[85216]={2},[85217]={2},[89202]={2},[85215]={2},[89233]={2},[89197]={2},[85219]={2},[91806]={2},[95449]={5},[95450]={6},[95451]={5},[95452]={6},[95457]={5},[95458]={6},[95447]={5},[95448]={6},[95445]={5},[95446]={6},[95454]={5},[95456]={6},[85267]={7},[85268]={7},[85269]={7}}
local refTools = {[79104]={30254},[80513]={30254},[89880]={30535},[89815]={31938}}
local refPortals = {[91850]={"Horde"},[91861]={"Horde"},[91862]={"Horde"},[91863]={"Horde"},[91860]={"Alliance"},[91864]={"Alliance"},[91865]={"Alliance"},[91866]={"Alliance"}}
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function IsInTable(group, itemId)
	for i, v in pairs(group) do
		if i == itemId then return true end
	end
	return false
end

local function FindItemInBags(itemId)
	for container = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(container) do
			if itemId == GetContainerItemID(container, slot) then
				return container, slot
			end
		end
	end
end

local onMouseDown = function(self, mousebutton)
	if InCombatLockdown() then return end
	if mousebutton == "LeftButton" then
		self:SetAttribute("type", self.buttonType)
		self:SetAttribute(self.buttonType, self.sortname)
		if IsInTable(refSeeds, self.itemId) and UnitName("target") ~= L["Tilled Soil"] then
			local container, slot = FindItemInBags(self.itemId)
			if container and slot then
				self:SetAttribute("type", "macro")
				self:SetAttribute("macrotext", format("/targetexact %s \n/use %s %s", L["Tilled Soil"], container, slot))
			end
		end
		if self.cooldown then 
			self.cooldown:SetCooldown(GetItemCooldown(self.itemId))
		end	
	elseif mousebutton == "RightButton" and self.allowDrop then
		self:SetAttribute("type", "click")
		local container, slot = FindItemInBags(self.itemId)
		if container and slot then
			PickupContainerItem(container, slot)
			DeleteCursorItem()
		end
	end
end

local onEnter = function(self)
	GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 2, 4)
	GameTooltip:ClearLines()
	GameTooltip:AddDoubleLine(self.sortname)
	if self.allowDrop then
		GameTooltip:AddLine(L['Right-click to drop the item.'])
	end
	GameTooltip:Show()
end;

local onLeave = function()
	GameTooltip:Hide() 
end;

local function CreateFarmingButton(index, owner, buttonName, buttonType, name, texture, allowDrop, showCount)
	local BUTTONSIZE = owner.ButtonSize;
	local button = CreateFrame("Button", ("FarmingButton"..buttonName.."%d"):format(index), owner, "SecureActionButtonTemplate")
	button:SetFixedPanelTemplate("Transparent")
	button.Panel:SetFrameLevel(0)
	button:SetNormalTexture(nil)
	button:Size(BUTTONSIZE, BUTTONSIZE)
	button.sortname = name
	button.itemId = index
	button.allowDrop = allowDrop
	button.buttonType = buttonType
	button.items = GetItemCount(index)
	button.icon = button:CreateTexture(nil, "OVERLAY", nil, 2)
	button.icon:SetTexture(texture)
	button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	button.icon:FillInner(button,2,2)
	if showCount then
		button.text = button:CreateFontString(nil, "OVERLAY")
		button.text:SetFont(SuperVillain.Fonts.action, 12, "OUTLINE")
		button.text:SetPoint("BOTTOMRIGHT", button, 1, 2)
	end
	button.cooldown = CreateFrame("Cooldown", ("FarmingButton"..buttonName.."%dCooldown"):format(index), button)
	button.cooldown:SetAllPoints(button)
	button:SetScript("OnEnter", onEnter)
	button:SetScript("OnLeave", onLeave)
	button:SetScript("OnMouseDown", onMouseDown)
	return button
end

local function ButtonUpdate(button)
	button.items = GetItemCount(button.itemId)
	if button.text then
		button.text:SetText(button.items)
	end
	button.icon:SetDesaturated(button.items == 0)
	button.icon:SetAlpha(button.items == 0 and .25 or 1)	
end

local function ButtonCooldownUpdate(button)
	if button.cooldown then
		button.cooldown:SetCooldown(GetItemCooldown(button.itemId))
	end
end

local function InFarmZone()
	local zone = GetSubZoneText()
	if (zone == L["Sunsong Ranch"] or zone == L["The Halfhill Market"]) then
		if MOD.Farming.ToolsLoaded and ModeAlert:IsShown() then
			MOD.TitleWindow:Clear()
 			MOD.TitleWindow:AddMessage("|cff22ff11Farming Mode|r")
		end
		return true
	else
		if MOD.Farming.ToolsLoaded and ModeAlert:IsShown() then
			MOD.TitleWindow:Clear()
 			MOD.TitleWindow:AddMessage("|cffff2211Must be in Sunsong Ranch|r")
		end
		return false
	end;
end

local function EventDistributor()
	if not InFarmZone() and MOD.db.farming.droptools then
		for k, v in pairs(refTools) do
			local container, slot = FindItemInBags(k)
			if container and slot then
				PickupContainerItem(container, slot)
				DeleteCursorItem()
			end		
		end
	end
	if InFarmZone() then
		MOD:RegisterEvent("BAG_UPDATE", "FarmtoolsInventoryUpdate")
		MOD:RegisterEvent("BAG_UPDATE_COOLDOWN", "UpdateFarmtoolCooldown")		
	else
		MOD:UnregisterEvent("BAG_UPDATE")
		MOD:UnregisterEvent("BAG_UPDATE_COOLDOWN")
	end
	MOD:FarmtoolsInventoryUpdate()
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
MOD.Farming = {};
MOD.Farming.Loaded = false;
MOD.Farming.ToolsLoaded = false;

function MOD:UpdateFarmtoolCooldown()
	if not InFarmZone() then return end
	for i = 1, NUM_SEED_BARS do
		for _, button in ipairs(seedButtons[i]) do
			ButtonCooldownUpdate(button)
		end
	end
	for _, button in ipairs(farmToolButtons) do
		ButtonCooldownUpdate(button)
	end
	for _, button in ipairs(portalButtons) do
		ButtonCooldownUpdate(button)
	end
end

function MOD.Farming:ZONE_CHANGED()
	EventDistributor();
end;

function MOD.Farming:ZONE_CHANGED_NEW_AREA()
	EventDistributor();
end;

function MOD.Farming:ZONE_CHANGED_INDOORS()
	EventDistributor();
end;

function MOD:LoadFarmingMode()
	if not SuperVillain.protected.SVLaborer.farming.enable then return end
	if InCombatLockdown() then
		MOD:RegisterEvent("PLAYER_REGEN_ENABLED", "LoadFarmingMode")	
		return
	else
		MOD:UnregisterEvent("PLAYER_REGEN_ENABLED")
 	end
 	MOD:ModeLootLoader("Farming", "Farming Mode", "This mode will provide you \nwith fast-access buttons for each \nof your seeds and farming tools.");
 	MOD.TitleWindow:Clear()
	if(not MOD.Farming.Loaded) then
		MOD.TitleWindow:AddMessage("|cff22ff11Farming Mode|r")
		MOD.StartFarmBarLoader()
		return
	else
		if not MOD.Farming.ToolsLoaded then
			if not FarmModeFrame:IsShown() then FarmModeFrame:Show() end
			if(not SVUI_ModesDockFrame:IsShown()) then DockButton:Click() end
			PlaySoundFile("Sound\\Effects\\DeathImpacts\\mDeathImpactColossalDirtA.wav")
			MOD.TitleWindow:AddMessage("|cffffff11Loading Farm Tools...|r")
			ModeAlert:Show()

			ModeEventsFrame:RegisterEvent("ZONE_CHANGED")
			MOD.FarmZoneTimer = MOD:ScheduleTimer(EventDistributor, 1)
			MOD.Farming.ToolsLoaded = true
		end
	end
end

function MOD:UnloadFarmingMode()
	if(not MOD.Farming.Loaded) then return end;
	if InCombatLockdown() then
		MOD:RegisterEvent("PLAYER_REGEN_ENABLED", "UnloadFarmingMode")	
		return
	else
		MOD:UnregisterEvent("PLAYER_REGEN_ENABLED")
 	end
	if MOD.Farming.ToolsLoaded then
		for k, v in pairs(refTools) do
			local container, slot = FindItemInBags(k)
			if container and slot then
				PickupContainerItem(container, slot)
				DeleteCursorItem()
			end		
		end
		if FarmModeFrame:IsShown() then FarmModeFrame:Hide() end
		if MOD.FarmZoneTimer then
			MOD:CancelTimer(MOD.FarmZoneTimer)
		end
		ModeEventsFrame:UnregisterEvent("ZONE_CHANGED")
		MOD:UnregisterEvent("BAG_UPDATE")
		MOD:UnregisterEvent("BAG_UPDATE_COOLDOWN")
		MOD.Farming.ToolsLoaded = false
	end
end
--[[ 
########################################################## 
HANDLERS
##########################################################
]]--
function MOD.Farming:Enable()
	MOD:LoadFarmingMode()
	MOD:EnableListener()
end

function MOD.Farming:Disable()
	MOD:UnloadFarmingMode()
	MOD:DisableListener()
end
--[[ 
########################################################## 
UPDATES
##########################################################
]]--
function MOD.Farming:UpdateLayout()
	local count, horizontal = 0, MOD.db.farming.toolbardirection == 'HORIZONTAL'
	local BUTTONSPACE = SuperVillain:Scale(MOD.db.farming.buttonspacing or 2);
	local lastBar;
	if not FarmToolBar:IsShown() then
		_G["FarmSeedBarAnchor"]:SetPoint("TOPLEFT", _G["FarmModeFrameSlots"], "TOPLEFT", 0, 0)
	else
		_G["FarmSeedBarAnchor"]:SetPoint("TOPLEFT", _G["FarmToolBar"], horizontal and "BOTTOMLEFT" or "TOPRIGHT", 0, 0)
	end

	for i = 1, NUM_SEED_BARS do
		local seedBar = _G["FarmSeedBar"..i]
		count = 0
		for i, button in ipairs(seedButtons[i]) do
			local BUTTONSIZE = seedBar.ButtonSize;
			button:Point("TOPLEFT", seedBar, "TOPLEFT", horizontal and (count * (BUTTONSIZE + BUTTONSPACE) + 1) or 1, horizontal and -1 or -(count * (BUTTONSIZE + BUTTONSPACE) + 1))
			button:Size(BUTTONSIZE,BUTTONSIZE)
			if (not MOD.db.farming.onlyactive or (MOD.db.farming.onlyactive and button.items > 0)) then
				button.icon:SetVertexColor(1,1,1)
				count = count + 1
			elseif (not MOD.db.farming.onlyactive and button.items <= 0) then
				button:Show()
				button.icon:SetVertexColor(0.25,0.25,0.25)
				count = count + 1
			else
				button:Hide()
			end
		end
		if(MOD.db.farming.onlyactive and not MOD.db.farming.undocked) then
			if count==0 then 
				seedBar:Hide() 
			else
				seedBar:Show()
				if(not lastBar) then
					seedBar:SetPoint("TOPLEFT", _G["FarmSeedBarAnchor"], "TOPLEFT", 0, 0)
				else
					seedBar:SetPoint("TOPLEFT", lastBar, horizontal and "BOTTOMLEFT" or "TOPRIGHT", 0, 0)
				end
				lastBar = seedBar
			end
		end
	end
	count = 0;
	lastBar = nil;
	FarmToolBar:ClearAllPoints()
	FarmToolBar:SetAllPoints(FarmToolBarAnchor)
	for i, button in ipairs(farmToolButtons) do
		local BUTTONSIZE = FarmToolBar.ButtonSize;
		button:Point("TOPLEFT", FarmToolBar, "TOPLEFT", horizontal and (count * (BUTTONSIZE + BUTTONSPACE) + 1) or 1, horizontal and -1 or -(count * (BUTTONSIZE + BUTTONSPACE) + 1))
		button:Size(BUTTONSIZE,BUTTONSIZE)
		if (not MOD.db.farming.onlyactive or (MOD.db.farming.onlyactive and button.items > 0)) then
			button:Show()
			button.icon:SetVertexColor(1,1,1)
			count = count + 1
		elseif (not MOD.db.farming.onlyactive and button.items == 0) then
			button:Show()
			button.icon:SetVertexColor(0.25,0.25,0.25)
			count = count + 1
		else
			button:Hide()
		end
	end
	if(MOD.db.farming.onlyactive and not MOD.db.farming.undocked) then
		if count==0 then 
			FarmToolBarAnchor:Hide()
			FarmPortalBar:SetPoint("TOPLEFT", FarmModeFrameSlots, "TOPLEFT", 0, 0)
		else
			FarmToolBarAnchor:Show()
			FarmPortalBar:SetPoint("TOPLEFT", FarmToolBarAnchor, "TOPRIGHT", 0, 0)
		end
	end
	count = 0;
	FarmPortalBar:ClearAllPoints()
	FarmPortalBar:SetAllPoints(FarmPortalBarAnchor)
	for i, button in ipairs(portalButtons) do
		local BUTTONSIZE = FarmPortalBar.ButtonSize;
		button:Point("TOPLEFT", FarmPortalBar, "TOPLEFT", horizontal and (count * (BUTTONSIZE + BUTTONSPACE) + 1) or 1, horizontal and -1 or -(count * (BUTTONSIZE + BUTTONSPACE) + 1))
		button:Size(BUTTONSIZE,BUTTONSIZE)
		if (not MOD.db.farming.onlyactive or (MOD.db.farming.onlyactive and button.items > 0)) then
			button:Show()
			button.icon:SetVertexColor(1,1,1)
			count = count + 1
		elseif (not MOD.db.farming.onlyactive and button.items == 0) then
			button:Show()
			button.icon:SetVertexColor(0.25,0.25,0.25)
			count = count + 1
		else
			button:Hide()
		end
	end
	if(MOD.db.farming.onlyactive) then
		if count==0 then 
			FarmPortalBar:Hide() 
		else
			FarmPortalBar:Show()
		end
	end
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:FarmtoolsInventoryUpdate()
	if InCombatLockdown() then
		MOD:RegisterEvent("PLAYER_REGEN_ENABLED", "FarmtoolsInventoryUpdate")	
		return
	else
		MOD:UnregisterEvent("PLAYER_REGEN_ENABLED")
 	end
	for i = 1, NUM_SEED_BARS do
		for _, button in ipairs(seedButtons[i]) do
			ButtonUpdate(button)
		end
	end
	for _, button in ipairs(farmToolButtons) do
		ButtonUpdate(button)
	end
	for _, button in ipairs(portalButtons) do
		ButtonUpdate(button)
	end	
	MOD.Farming:UpdateLayout()
end

function MOD:CreateFarmingModeButtons()
	local horizontal = MOD.db.farming.toolbardirection == 'HORIZONTAL'
	local seeds, farmtools, portals = {},{},{}
	for k, v in pairs(refSeeds) do
		seeds[k] = { v[1], GetItemInfo(k) }
	end
	for k, v in pairs(refTools) do
		farmtools[k] = { v[1], GetItemInfo(k) }
	end
	for k, v in pairs(refPortals) do
		portals[k] = { v[1], GetItemInfo(k) }
	end
	for i = 1, NUM_SEED_BARS do
		local seedBar = _G["FarmSeedBar"..i]
		seedButtons[i] = seedButtons[i] or {}
		for k, v in pairs(seeds) do
			if v[1] == i then
				tinsert(seedButtons[i], CreateFarmingButton(k, seedBar, "SeedBar"..i.."Seed", "item", v[2], v[11], false, true))
			end
			tsort(seedButtons[i], function(a, b) return a.sortname < b.sortname end)
		end
	end
	for k, v in pairs(farmtools) do
		tinsert(farmToolButtons, CreateFarmingButton(k, _G["FarmToolBar"], "Tools", "item", v[2], v[11], true, false))
	end
	local playerFaction = UnitFactionGroup('player')
	for k, v in pairs(portals) do
		if v[1] == playerFaction then
			tinsert(portalButtons, CreateFarmingButton(k, _G["FarmPortalBar"], "Portals", "item", v[2], v[11], false, true))
		end
	end
	MOD.Farming.Loaded = true
	MOD:LoadFarmingMode()
end

function MOD:StartFarmBarLoader()
	local itemError = false
	for k, v in pairs(refSeeds) do
		if select(2, GetItemInfo(k)) == nil then itemError = true end
	end
	for k, v in pairs(refTools) do
		if select(2, GetItemInfo(k)) == nil then itemError = true end
	end
	for k, v in pairs(refPortals) do
		if select(2, GetItemInfo(k)) == nil then itemError = true end
	end
	if InCombatLockdown() or itemError then
		MOD.PostConstructTimer = MOD:ScheduleTimer("StartFarmBarLoader", 2)
	else
		if MOD.PostConstructTimer then
			MOD:CancelTimer(MOD.PostConstructTimer)
			MOD.PostConstructTimer = nil
		end
		MOD.CreateFarmingModeButtons()
	end
end

function MOD:PrepareFarmingTools()
	if not SuperVillain.protected.SVLaborer.farming.enable then return end

	local horizontal = self.db.farming.toolbardirection == 'HORIZONTAL'
	local BUTTONSPACE = SuperVillain:Scale(self.db.farming.buttonspacing or 2);

	ModeLogsFrame = MOD.LogWindow;
	ModeEventsFrame = _G["SVUI_ModeEventsHandler"];
	DockButton = _G["SVUI_ModesDockFrame_ToolBarButton"];
	ModeAlert = _G["SVUI_ModeAlert"];

	if not self.db.farming.undocked then
		local iTex = "Interface\\Addons\\SVUI\\assets\\artwork\\Icons\\QUESTS";
		local bgTex = [[Interface\BUTTONS\WHITE8X8]]
		local bdTex = SuperVillain.Textures.glow
		local farmingDocklet = CreateFrame("ScrollFrame", "FarmModeFrame", ModeLogsFrame);
		farmingDocklet:SetPoint("TOPLEFT", ModeLogsFrame, 31, -3);
		farmingDocklet:SetPoint("BOTTOMRIGHT", ModeLogsFrame, -3, 3);
		farmingDocklet:EnableMouseWheel(true);
		local farmingDockletSlots = CreateFrame("Frame", "FarmModeFrameSlots", farmingDocklet);
		farmingDockletSlots:SetPoint("TOPLEFT", farmingDocklet, 0, 0);
		farmingDockletSlots:SetWidth(farmingDocklet:GetWidth())
		farmingDockletSlots:SetHeight(500);
		farmingDockletSlots:SetFrameLevel(farmingDocklet:GetFrameLevel() + 1)
		farmingDocklet:SetScrollChild(farmingDockletSlots)
		local slotSlider = CreateFrame("Slider", "FarmModeSlotSlider", farmingDocklet);
		slotSlider:SetHeight(farmingDocklet:GetHeight() - 3);
		slotSlider:SetWidth(18);
		slotSlider:SetPoint("TOPLEFT", farmingDocklet, -28, 0);
		slotSlider:SetPoint("BOTTOMLEFT", farmingDocklet, -28, 0);
		slotSlider:SetBackdrop({bgFile = bgTex, edgeFile = bdTex, edgeSize = 4, insets = {left = 3, right = 3, top = 3, bottom = 3}});
		slotSlider:SetFrameLevel(6)
		slotSlider:SetFixedPanelTemplate("Transparent", true);
		slotSlider:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob");
		slotSlider:SetOrientation("VERTICAL");
		slotSlider:SetValueStep(5);
		slotSlider:SetMinMaxValues(1, 420);
		slotSlider:SetValue(1);
		farmingDocklet.slider = slotSlider;
		slotSlider:SetScript("OnValueChanged",function(self,argValue)
			farmingDocklet:SetVerticalScroll(argValue)
		end)
		farmingDocklet:SetScript("OnMouseWheel", function(self, delta)
			local scroll = self:GetVerticalScroll();
			local value = (scroll - (20 * delta));
			if value < -1 then 
				value = 0
			end;
			if value > 420 then 
				value = 420
			end;
			self:SetVerticalScroll(value)
			self.slider:SetValue(value)
		end);

		local parentWidth = FarmModeFrameSlots:GetWidth() - 31
		local BUTTONSIZE = (parentWidth / (horizontal and 10 or 8));
		local TOOLSIZE = (parentWidth / 8);

		-- FARM TOOLS
		local farmToolBarAnchor = CreateFrame("Frame", "FarmToolBarAnchor", farmingDockletSlots)
		farmToolBarAnchor:Point("TOPLEFT", farmingDockletSlots, "TOPLEFT", 0, 0)
		farmToolBarAnchor:Size(horizontal and ((TOOLSIZE + BUTTONSPACE) * 4) or (TOOLSIZE + BUTTONSPACE), horizontal and (TOOLSIZE + BUTTONSPACE) or ((TOOLSIZE + BUTTONSPACE) * 4))
		local farmToolBar = CreateFrame("Frame", "FarmToolBar", farmToolBarAnchor)
		farmToolBar:Size(horizontal and ((TOOLSIZE + BUTTONSPACE) * 4) or (TOOLSIZE + BUTTONSPACE), horizontal and (TOOLSIZE + BUTTONSPACE) or ((TOOLSIZE + BUTTONSPACE) * 4))
		farmToolBar:SetPoint("TOPLEFT", farmToolBarAnchor, "TOPLEFT", (horizontal and BUTTONSPACE or (TOOLSIZE + BUTTONSPACE)), (horizontal and -(TOOLSIZE + BUTTONSPACE) or -BUTTONSPACE))
		farmToolBar.ButtonSize = TOOLSIZE;

		-- PORTALS
		local farmPortalBarAnchor = CreateFrame("Frame", "FarmPortalBarAnchor", farmingDockletSlots)
		farmPortalBarAnchor:Point("TOPLEFT", farmToolBarAnchor, "TOPRIGHT", 0, 0)
		farmPortalBarAnchor:Size(horizontal and ((TOOLSIZE + BUTTONSPACE) * 4) or (TOOLSIZE + BUTTONSPACE), horizontal and (TOOLSIZE + BUTTONSPACE) or ((TOOLSIZE + BUTTONSPACE) * 4))
		local farmPortalBar = CreateFrame("Frame", "FarmPortalBar", farmPortalBarAnchor)
		farmPortalBar:Size(horizontal and ((TOOLSIZE + BUTTONSPACE) * 4) or (TOOLSIZE + BUTTONSPACE), horizontal and (TOOLSIZE + BUTTONSPACE) or ((TOOLSIZE + BUTTONSPACE) * 4))
		farmPortalBar:SetPoint("TOPLEFT", farmPortalBarAnchor, "TOPLEFT", (horizontal and BUTTONSPACE or (TOOLSIZE + BUTTONSPACE)), (horizontal and -(TOOLSIZE + BUTTONSPACE) or -BUTTONSPACE))
		farmPortalBar.ButtonSize = TOOLSIZE;

		-- SEEDS
		local farmSeedBarAnchor = CreateFrame("Frame", "FarmSeedBarAnchor", farmingDockletSlots)
		farmSeedBarAnchor:Point("TOPLEFT", farmPortalBarAnchor, horizontal and "BOTTOMLEFT" or "TOPRIGHT", 0, 0)
		farmSeedBarAnchor:Size(horizontal and ((BUTTONSIZE + BUTTONSPACE) * 10) or ((BUTTONSIZE + BUTTONSPACE) * 8), horizontal and ((BUTTONSIZE + BUTTONSPACE) * 8) or ((BUTTONSIZE + BUTTONSPACE) * 10))
		for i = 1, NUM_SEED_BARS do
			local seedBar = CreateFrame("Frame", "FarmSeedBar"..i, farmSeedBarAnchor)
			seedBar.ButtonSize = BUTTONSIZE;
			seedBar:Size(horizontal and ((BUTTONSIZE + BUTTONSPACE) * 10) or (BUTTONSIZE + BUTTONSPACE), horizontal and (BUTTONSIZE + BUTTONSPACE) or ((BUTTONSIZE + BUTTONSPACE) * 10))
			if i==1 then
				seedBar:SetPoint("TOPLEFT", farmSeedBarAnchor, "TOPLEFT", 0, 0)
			else
				seedBar:SetPoint("TOPLEFT", "FarmSeedBar"..i-1, horizontal and "BOTTOMLEFT" or "TOPRIGHT", 0, 0)
			end
		end

		farmingDocklet:Hide()
	else
		local BUTTONSIZE = SuperVillain:Scale(self.db.farming.buttonsize or 35);
		local TOOLSIZE = SuperVillain:Scale(self.db.farming.buttonsize or 35);
		-- SEEDS
		local farmSeedBarAnchor = CreateFrame("Frame", "FarmSeedBarAnchor", SuperVillain.UIParent)
		farmSeedBarAnchor:Point("TOPRIGHT", SuperVillain.UIParent, "TOPRIGHT", -40, -300)
		farmSeedBarAnchor:Size(horizontal and ((BUTTONSIZE + BUTTONSPACE) * 10) or ((BUTTONSIZE + BUTTONSPACE) * 8), horizontal and ((BUTTONSIZE + BUTTONSPACE) * 8) or ((BUTTONSIZE + BUTTONSPACE) * 10))
		for i = 1, NUM_SEED_BARS do
			local seedBar = CreateFrame("Frame", "FarmSeedBar"..i, farmSeedBarAnchor)
			seedBar:Size(horizontal and ((BUTTONSIZE + BUTTONSPACE) * 10) or (BUTTONSIZE + BUTTONSPACE), horizontal and (BUTTONSIZE + BUTTONSPACE) or ((BUTTONSIZE + BUTTONSPACE) * 10))
			seedBar:SetPoint("TOPRIGHT", _G["FarmSeedBarAnchor"], "TOPRIGHT", (horizontal and 0 or -((BUTTONSIZE + BUTTONSPACE) * i)), (horizontal and -((BUTTONSIZE + BUTTONSPACE) * i) or 0))
			seedBar.ButtonSize = BUTTONSIZE;
		end
		SuperVillain:SetSVMovable(farmSeedBarAnchor, 'FarmSeedBar_MOVE', 'Farming Seeds')
		-- FARM TOOLS
		local farmToolBarAnchor = CreateFrame("Frame", "FarmToolBarAnchor", SuperVillain.UIParent)
		farmToolBarAnchor:Point("TOPRIGHT", farmSeedBarAnchor, horizontal and "BOTTOMRIGHT" or "TOPLEFT", horizontal and 0 or -(BUTTONSPACE * 2), horizontal and -(BUTTONSPACE * 2) or 0)
		farmToolBarAnchor:Size(horizontal and ((TOOLSIZE + BUTTONSPACE) * 4) or (TOOLSIZE + BUTTONSPACE), horizontal and (TOOLSIZE + BUTTONSPACE) or ((TOOLSIZE + BUTTONSPACE) * 4))
		local farmToolBar = CreateFrame("Frame", "FarmToolBar", farmToolBarAnchor)
		farmToolBar:Size(horizontal and ((TOOLSIZE + BUTTONSPACE) * 4) or (TOOLSIZE + BUTTONSPACE), horizontal and (TOOLSIZE + BUTTONSPACE) or ((TOOLSIZE + BUTTONSPACE) * 4))
		farmToolBar:SetPoint("TOPRIGHT", farmToolBarAnchor, "TOPRIGHT", (horizontal and -BUTTONSPACE or -(TOOLSIZE + BUTTONSPACE)), (horizontal and -(TOOLSIZE + BUTTONSPACE) or -BUTTONSPACE))
		farmToolBar.ButtonSize = TOOLSIZE;
		SuperVillain:SetSVMovable(farmToolBarAnchor, 'FarmToolBar_MOVE', 'Farming Tools')
		-- PORTALS
		local farmPortalBarAnchor = CreateFrame("Frame", "FarmPortalBarAnchor", SuperVillain.UIParent)
		farmPortalBarAnchor:Point("TOPRIGHT", farmToolBarAnchor, horizontal and "BOTTOMRIGHT" or "TOPLEFT", horizontal and 0 or -(BUTTONSPACE * 2), horizontal and -(BUTTONSPACE * 2) or 0)
		farmPortalBarAnchor:Size(horizontal and ((TOOLSIZE + BUTTONSPACE) * 4) or (TOOLSIZE + BUTTONSPACE), horizontal and (TOOLSIZE + BUTTONSPACE) or ((TOOLSIZE + BUTTONSPACE) * 4))
		local farmPortalBar = CreateFrame("Frame", "FarmPortalBar", farmPortalBarAnchor)
		farmPortalBar:Size(horizontal and ((TOOLSIZE + BUTTONSPACE) * 4) or (TOOLSIZE + BUTTONSPACE), horizontal and (TOOLSIZE + BUTTONSPACE) or ((TOOLSIZE + BUTTONSPACE) * 4))
		farmPortalBar:SetPoint("TOPRIGHT", farmPortalBarAnchor, "TOPRIGHT", (horizontal and -BUTTONSPACE or -(TOOLSIZE + BUTTONSPACE)), (horizontal and -(TOOLSIZE + BUTTONSPACE) or -BUTTONSPACE))
		farmPortalBar.ButtonSize = TOOLSIZE;
		SuperVillain:SetSVMovable(farmPortalBarAnchor, 'FarmPortalBar_MOVE', 'Farming Portals')
	end
end
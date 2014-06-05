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
credit: Elv.       SVPlates was parently nameplates.lua adapted from ElvUI #
##############################################################################
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack    = _G.unpack;
local select    = _G.select;
local pairs     = _G.pairs;
local ipairs    = _G.ipairs;
local type      = _G.type;
local error     = _G.error;
local pcall     = _G.pcall;
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local tinsert   = _G.tinsert;
local string    = _G.string;
local math      = _G.math;
local bit       = _G.bit;
local table     = _G.table;
--[[ STRING METHODS ]]--
local lower, upper = string.lower, string.upper;
local find, format, split = string.find, string.format, string.split;
local match, gmatch, gsub = string.match, string.gmatch, string.gsub;
--[[ MATH METHODS ]]--
local floor = math.floor;  -- Basic
--[[ BINARY METHODS ]]--
local band, bor = bit.band, bit.bor;
--[[ TABLE METHODS ]]--
local tremove, tcopy, twipe, tsort, tconcat = table.remove, table.copy, table.wipe, table.sort, table.concat;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain:NewModule('SVPlate', 'AceHook-3.0', 'AceTimer-3.0');
local LSM = LibStub("LibSharedMedia-3.0");
--[[ 
########################################################## 
LOCALIZED GLOBALS
##########################################################
]]--
local SVUI_CLASS_COLORS = _G.SVUI_CLASS_COLORS
local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local numChildren = -1;
local latestColor = {1,0.5,0.5};
local PlateRegistry, VisiblePlates = {}, {};
local WorldFrameUpdateHook, UpdatePlateElements, PlateForge;
local BLIZZ_PLATE, SVUI_PLATE, PLATE_REF, PLATE_ARGS, PLATE_AURAS, PLATE_AURAICONS, PLATE_GRIP, PLATE_REALNAME;
local CURRENT_TARGET_NAME, TARGET_CHECKS;
--[[
	Quick explaination of what Im doing with all of these locals...
	Unlike many of the other modules, SVPlates has to continuously 
	reference config settings which can start to get sluggish. What
	I have done is set local variables for every database value
	that the module can read efficiently. The function "UpdateDataLocals"
	is used to refresh these any time a change is made to configs
	and once when the mod is loaded.
]]--
local NPClassRole = SuperVillain.ClassRole;
local NPBaseAlpha = 0.6;
local NPCombatHide = false;
local NPNameMatch = false;
local NPComboColor={
	[1]={0.69,0.31,0.31},
	[2]={0.69,0.31,0.31},
	[3]={0.65,0.63,0.35},
	[4]={0.65,0.63,0.35},
	[5]={0.33,0.59,0.33}
};
local NPFont = SuperVillain.Fonts.action;
local NPFSize = 10;
local NPFOutline = "OUTLINE";

local NPUsePointer = true;
local NPPointerMatch = false;
local NPPointerColor = {0.7,0,1};

local NPUseThreat = false;
local NPThreatGS = 1;
local NPThreatBS = 1;
local NPGoodThreat = {0.29,0.68,0.3}
local NPBadThreat = {0.78,0.25,0.25}
local NPGoodTrans = {0.85,0.77,0.36}
local NPBadTrans = {0.94,0.6,0.06}

local NPReactTap = {0.3,0.3,0.3}
local NPReactNPCGood = {0.31,0.45,0.63}
local NPReactPlayerGood = {0.29,0.68,0.3}
local NPReactNeutral = {0.85,0.77,0.36}
local NPReactEnemy = {0.78,0.25,0.25}

local RIconCoords = {[0]={[0]="STAR", [0.25]="MOON"}, [0.25]={[0]="CIRCLE", [0.25]="SQUARE"}, [0.5]={[0]="DIAMOND", [0.25]="CROSS"}, [0.75]={[0]="TRIANGLE", [0.25]="SKULL"}};
local RIAnchor = "LEFT";
local RIXoffset = -4;
local RIYoffset = 6;
local RISize = 36;

local HBThresh = 0.4;
local HBTextFormat = false;
local HBTextAnchor = "CENTER";
local HBXoffset = 0;
local HBYoffset = 0;
local HBWidth = 108;
local HBHeight = 9;

local NPIcons = 14;

local CBColor = {0.1,0.81,0}
local CBNoInterrupt = {0.78,0.25,0.25}
local CBHeight = 6;

local AuraFont = SuperVillain.Fonts.roboto;
local AuraFSize = 10;
local AuraFOutline = "MONOCHROME";
local AuraMaxCount = 5;

local BlockedPlates = {
	["Army of the Dead Ghoul"] = true,
	["Venomous Snake"] = true,
	["Healing Tide Totem"] = true,
	["Dragonmaw War Banner"] = true
};
--[[ 
########################################################## 
UTILITY FRAMES
##########################################################
]]--
local NPGrip = _G.SVUI_PlateParentFrame
local NPGlow = _G.SVUI_PlateGlowFrame
--[[ 
########################################################## 
PRE VARS/FUNCTIONS
##########################################################
]]--
local function SetPlateBorder(plate, point)
	point = point or plate
	local noscalemult = 2 * UIParent:GetScale()
	if point.bordertop then return end
	point.backdrop = plate:CreateTexture(nil, "BORDER")
	point.backdrop:SetDrawLayer("BORDER", -4)
	point.backdrop:SetAllPoints(point)
	point.backdrop:SetTexture(SuperVillain.Textures.bar)
	point.backdrop:SetVertexColor(0.1,0.1,0.1)	
	point.bordertop = plate:CreateTexture(nil, "BORDER")
	point.bordertop:SetPoint("TOPLEFT", point, "TOPLEFT", -noscalemult, noscalemult)
	point.bordertop:SetPoint("TOPRIGHT", point, "TOPRIGHT", noscalemult, noscalemult)
	point.bordertop:SetHeight(noscalemult)
	point.bordertop:SetTexture(0,0,0)	
	point.bordertop:SetDrawLayer("BORDER", 1)
	point.borderbottom = plate:CreateTexture(nil, "BORDER")
	point.borderbottom:SetPoint("BOTTOMLEFT", point, "BOTTOMLEFT", -noscalemult, -noscalemult)
	point.borderbottom:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", noscalemult, -noscalemult)
	point.borderbottom:SetHeight(noscalemult)
	point.borderbottom:SetTexture(0,0,0)	
	point.borderbottom:SetDrawLayer("BORDER", 1)
	point.borderleft = plate:CreateTexture(nil, "BORDER")
	point.borderleft:SetPoint("TOPLEFT", point, "TOPLEFT", -noscalemult, noscalemult)
	point.borderleft:SetPoint("BOTTOMLEFT", point, "BOTTOMLEFT", noscalemult, -noscalemult)
	point.borderleft:SetWidth(noscalemult)
	point.borderleft:SetTexture(0,0,0)	
	point.borderleft:SetDrawLayer("BORDER", 1)
	point.borderright = plate:CreateTexture(nil, "BORDER")
	point.borderright:SetPoint("TOPRIGHT", point, "TOPRIGHT", noscalemult, noscalemult)
	point.borderright:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", -noscalemult, -noscalemult)
	point.borderright:SetWidth(noscalemult)
	point.borderright:SetTexture(0,0,0)	
	point.borderright:SetDrawLayer("BORDER", 1)	
end
--[[ 
########################################################## 
UPVALUE PROXYS
##########################################################
]]--
local function ProxyThisPlate(plate, updateName)
	if(not plate or not plate.frame) then return false; end
	BLIZZ_PLATE = plate
	SVUI_PLATE = plate.frame
	PLATE_REF = plate.ref
	PLATE_AURAS = plate.frame.auras
	PLATE_AURAICONS = plate.frame.auraicons
	PLATE_ARGS = plate.setting
	PLATE_GRIP = plate.holder
	if updateName then
		plate.ref.nametext = gsub(plate.name:GetText(), '%s%(%*%)','');
	end
	PLATE_REALNAME = plate.ref.nametext
	return true
end
--[[ 
########################################################## 
LOCAL HELPERS
##########################################################
]]--
local function CheckRaidIcon(plate)
	if(plate and plate.ref) then
		SVUI_PLATE = plate.frame
		PLATE_REF = plate.ref
	end
	if PLATE_REF.raidicon:IsShown() then
		local ULx,ULy,LLx,LLy,URx,URy,LRx,LRy = PLATE_REF.raidicon:GetTexCoord()
		PLATE_REF.raidicontype = RIconCoords[ULx][ULy]
		SVUI_PLATE.raidicon:Show()
		SVUI_PLATE.raidicon:SetTexCoord(ULx,ULy,LLx,LLy,URx,URy,LRx,LRy)
	else
		PLATE_REF.raidicontype = nil;
		SVUI_PLATE.raidicon:Hide() 
	end
end
--[[ 
########################################################## 
PLATE UPDATE HANDLERS
##########################################################
]]--
do
	local function IsNamePlate(frame)
		if frame:GetName() and strfind(frame:GetName(), '^NamePlate%d') then
			local textObj = select(2, frame:GetChildren())
			if textObj then
				local textRegions = textObj:GetRegions()
				return (textRegions and textRegions:GetObjectType() == 'FontString')
			end
		end
	end

	local function SetPlateAlpha(plate, frame)
		if plate:GetAlpha() < 1 then
			frame:SetAlpha(NPBaseAlpha)
		else
			frame:SetAlpha(1)
		end
	end

	local function UpdatePlateUnit()
		local plateName = PLATE_REF.nametext

		if BLIZZ_PLATE:GetAlpha() == 1 and CURRENT_TARGET_NAME and (CURRENT_TARGET_NAME == plateName) then
			BLIZZ_PLATE.guid = UnitGUID("target")
			PLATE_ARGS.unit = "target"
			SVUI_PLATE:SetFrameLevel(2)
			SVUI_PLATE.highlight:Hide()
			if(NPUsePointer) then
				NPGlow:SetParent(SVUI_PLATE)
				NPGlow:WrapOuter(SVUI_PLATE.health,2,2)
				NPGlow:SetFrameLevel(0)
				NPGlow:SetFrameStrata("BACKGROUND")
				NPGlow:Show()
			end
			if((TARGET_CHECKS > -1) or PLATE_ARGS.allowed) then
				TARGET_CHECKS = TARGET_CHECKS + 1
				if TARGET_CHECKS > 0 then
					TARGET_CHECKS = -1
				end
				MOD:UpdateAurasByUnitID('target')
				if MOD.UseCombo then
					MOD:UpdateComboPointsByUnitID('target')
				end
				PLATE_ARGS.allowed = nil
			end
		elseif PLATE_REF.highlight:IsShown() and UnitExists("mouseover") and (UnitName("mouseover") == plateName) then
			if(PLATE_ARGS.unit ~= "mouseover" or PLATE_ARGS.allowed) then
				SVUI_PLATE:SetFrameLevel(1)
				SVUI_PLATE.highlight:Show()			
				MOD:UpdateAurasByUnitID('mouseover')
				if MOD.UseCombo then
					MOD:UpdateComboPointsByUnitID('mouseover')
				end
				PLATE_ARGS.allowed = nil
			end
			BLIZZ_PLATE.guid = UnitGUID("mouseover")
			PLATE_ARGS.unit = "mouseover"		
		else
			SVUI_PLATE:SetFrameLevel(0)
			SVUI_PLATE.highlight:Hide()
			PLATE_ARGS.unit = nil
		end
		CheckRaidIcon()
		UpdatePlateElements(BLIZZ_PLATE,SVUI_PLATE)
	end

	function WorldFrameUpdateHook(self, elapsed)
		NPGrip:Hide()
		for plate, _ in pairs(VisiblePlates) do
			local frame = plate.frame
			if(plate:IsShown()) then
				local x,y = plate:GetCenter()
				frame:SetPoint("CENTER", self, "BOTTOMLEFT", floor(x), floor(y))
				SetPlateAlpha(plate, frame)
			else
				frame:Hide()
			end
		end
		NPGrip:Show()

		if(self.elapsed and self.elapsed > 0.2) then

			for plate, _ in pairs(VisiblePlates) do
				local frame = plate.frame
				if(plate:IsShown() and frame:IsShown() and ProxyThisPlate(plate)) then
					UpdatePlateUnit()
				end
			end
			self.elapsed = 0
		else
			self.elapsed = (self.elapsed or 0) + elapsed
		end
		local curChildren = self:GetNumChildren()
		if(numChildren ~= curChildren) then
			for i = 1, curChildren do
				local frame = select(i, self:GetChildren())
				if(not PlateRegistry[frame] and IsNamePlate(frame)) then
					PlateForge(frame)
				end
			end
			numChildren = curChildren
		end
	end
end
--[[ 
########################################################## 
PLATE COLORING
##########################################################
]]--
do
	local function GetPlateThreatReaction(plate)
		if plate.ref.threat:IsShown() then
			local r, g, b = plate.ref.threat:GetVertexColor()
			if g + b == 0 then
				return 'FULL_THREAT'
			else
				if plate.ref.reaction == 'FULL_THREAT' then
					return 'GAINING_THREAT'
				else
					return 'LOSING_THREAT'
				end
			end
		else
			return 'NO_THREAT'
		end
	end

	local function GetPlateReaction(plate)
		local oldR,oldG,oldB = plate.health:GetStatusBarColor()
		local r = floor(oldR * 100 + .5) / 100;
		local g = floor(oldG * 100 + .5) / 100;
		local b = floor(oldB * 100 + .5) / 100;
		for class, _ in pairs(RAID_CLASS_COLORS) do
			local bb = b
			if class == 'MONK' then
				bb = bb - 0.01
			end
			if RAID_CLASS_COLORS[class].r == r and RAID_CLASS_COLORS[class].g == g and RAID_CLASS_COLORS[class].b == bb then
				return class
			end
		end
		if (r + b + b) == 1.59 then
			return 'TAPPED_NPC'
		elseif g + b == 0 then
			return 'HOSTILE_NPC'
		elseif r + b == 0 then
			return 'FRIENDLY_NPC'
		elseif r + g > 1.95 then
			return 'NEUTRAL_NPC'
		elseif r + g == 0 then
			return 'FRIENDLY_PLAYER'
		else
			return 'HOSTILE_PLAYER'
		end
	end

	local function ColorizeAndScale(plate, frame)
		local unitType = GetPlateReaction(plate)
		local scale = 1
		plate.setting.unitcategory = unitType
		if SVUI_CLASS_COLORS[unitType] then
			latestColor = {SVUI_CLASS_COLORS[unitType].r,SVUI_CLASS_COLORS[unitType].g,SVUI_CLASS_COLORS[unitType].b}
		elseif RAID_CLASS_COLORS[unitType] then
			latestColor = {RAID_CLASS_COLORS[unitType].r,RAID_CLASS_COLORS[unitType].g,RAID_CLASS_COLORS[unitType].b}
		elseif unitType == "TAPPED_NPC" then
			latestColor = NPReactTap
		elseif unitType == "HOSTILE_NPC" or unitType == "NEUTRAL_NPC" then
			local threatReaction = GetPlateThreatReaction(plate)
			if (not NPUseThreat) then
				if unitType == "NEUTRAL_NPC" then
					latestColor = NPReactNeutral
				else
					latestColor = NPReactEnemy
				end			
			else
				if threatReaction == 'FULL_THREAT' then
					if NPClassRole == 'T' then
						latestColor = NPGoodThreat
						scale = NPThreatGS
					else
						latestColor = NPBadThreat
						scale = NPThreatBS
					end
				elseif threatReaction == 'GAINING_THREAT' then
					if NPClassRole == 'T' then
						latestColor = NPGoodTrans
					else
						latestColor = NPBadTrans
					end
				elseif threatReaction == 'LOSING_THREAT' then
					if NPClassRole == 'T' then
						latestColor = NPBadTrans
					else
						latestColor = NPGoodTrans
					end
				elseif InCombatLockdown() then
					if NPClassRole == 'T' then
						latestColor = NPBadThreat
						scale = NPThreatBS
					else
						latestColor = NPGoodThreat
						scale = NPThreatGS
					end
				else
					if unitType == "NEUTRAL_NPC" then
						latestColor = NPReactNeutral
					else
						latestColor = NPReactEnemy
					end
				end
			end
			plate.ref.reaction = threatReaction
		elseif unitType == "FRIENDLY_NPC" then
			latestColor = NPReactNPCGood
		elseif unitType == "FRIENDLY_PLAYER" then
			latestColor = NPReactPlayerGood
		else
			latestColor = NPReactEnemy
		end

		frame.health:SetStatusBarColor(unpack(latestColor))
		if(NPUsePointer and NPPointerMatch and plate.setting.unit == "target") then
			NPGlow:SetBackdropBorderColor(unpack(latestColor))
		end
		if(not plate.setting.scaled and not plate.setting.tiny and frame.health:GetWidth() ~= (HBWidth * scale)) then
			frame.health:SetSize(HBWidth * scale, HBHeight * scale)
			plate.cast.icon:SetSize(CBHeight + (HBHeight * scale) + 5, CBHeight + (HBHeight * scale) + 5)
		end
	end

	function UpdatePlateElements(plate, frame)
		ColorizeAndScale(plate, frame)
		local region = select(4, plate:GetRegions())
		if region and region:GetObjectType() == 'FontString' then
			plate.ref.level = region
		end
		if plate.ref.level:IsShown() then
			local level = plate.ref.level:GetObjectType() == 'FontString' and tonumber(plate.ref.level:GetText()) or nil
			local elite, boss, mylevel = plate.ref.eliteicon:IsShown(), plate.ref.skullicon:IsShown(), UnitLevel("player")
			if boss then
				frame.level:SetText("??")
				frame.level:SetTextColor(0.8, 0.05, 0)
			elseif level then
				frame.level:SetText(level..(elite and "+" or ""))
				frame.level:SetTextColor(plate.ref.level:GetTextColor())
			end
		elseif plate.ref.skullicon:IsShown() and frame.level:GetText() ~= '??' then
			frame.level:SetText("??")
			frame.level:SetTextColor(0.8, 0.05, 0)
		end
		if plate.setting.tiny then
			frame.level:SetText("")
			frame.level:Hide()
		elseif not frame.level:IsShown() then
			frame.level:Show()
		end
		if frame.name.SetText then
			frame.name:SetText(plate.name:GetText())
		end
	end
end
--[[ 
########################################################## 
SCRIPT HANDLERS
##########################################################
]]--
do
	local function HealthBarSizeChanged(self, width, height)
		if(not ProxyThisPlate(self.sync)) then return; end
		width = floor(width + 0.5)
		local numAuras = AuraMaxCount
		local auraWidth = ((width - (4 * (numAuras - 1))) / numAuras)
		local auraHeight = (auraWidth * 0.7)
		for index = 1, numAuras do
			if not PLATE_AURAICONS[index] then
				PLATE_AURAICONS[index] = MOD:CreateAuraIcon(PLATE_AURAS, SVUI_PLATE);
			end
			PLATE_AURAICONS[index]:SetWidth(auraWidth)
			PLATE_AURAICONS[index]:SetHeight(auraHeight)
			PLATE_AURAICONS[index]:ClearAllPoints()
			if(index == 1) then
				PLATE_AURAICONS[index]:SetPoint("LEFT", PLATE_AURAS, 0, 0)
			else
				PLATE_AURAICONS[index]:SetPoint("LEFT", PLATE_AURAICONS[index-1], "RIGHT", 4, 0) 
			end
		end
		if(numAuras > #PLATE_AURAICONS) then
			for index = (numAuras + 1), #PLATE_AURAICONS do
				MOD.RegisterAuraClock(PLATE_AURAICONS[index], 0)
			end
		end
	end

	local function HealthBarValueChanged(self, value)
		local healthBar = self.sync;
		local alert = healthBar.alert;
		local minValue, maxValue = self:GetMinMaxValues()
		healthBar:SetMinMaxValues(minValue, maxValue)
		healthBar:SetValue(value)
		local percentValue = (value/maxValue)
		if percentValue < HBThresh then
			alert:Show()
			if percentValue < (HBThresh / 2) then
				alert:SetBackdropBorderColor(1, 0, 0, 0.9)
			else
				alert:SetBackdropBorderColor(1, 1, 0, 0.9)
			end
		elseif alert:IsShown() then
			alert:Hide()
		end
	end

	local function CastBarValueChanged(self, value)
		local castBar = self.sync
		local min, max = self:GetMinMaxValues()
		local isChannel = value < castBar:GetValue()
		castBar:SetMinMaxValues(min, max)
		castBar:SetValue(value)
		castBar.text:SetFormattedText("%.1f ", value)
		local color
		if(self.shield:IsShown()) then
			color = CBNoInterrupt
		else
			if value > 0 and (isChannel and (value/max) <= 0.02 or (value/max) >= 0.98) then
				color = {0,1,0}
			else
				color = CBColor
			end
		end			
		castBar:SetStatusBarColor(unpack(color))
	end

	local function ShowThisPlate(plate)
		if(not ProxyThisPlate(plate, true)) then return; end

		if BlockedPlates[PLATE_REALNAME] then
			SVUI_PLATE:Hide()
			PLATE_GRIP:Hide()
			return
		elseif(not SVUI_PLATE:IsShown()) then
			PLATE_GRIP:Show()
			SVUI_PLATE:Show()
		end

		VisiblePlates[BLIZZ_PLATE] = true

		PLATE_ARGS.tiny = (BLIZZ_PLATE.health:GetEffectiveScale() < 1)
		SVUI_PLATE:SetSize(BLIZZ_PLATE:GetSize())

		SVUI_PLATE.name:ClearAllPoints()
		if(PLATE_ARGS.tiny) then
			SVUI_PLATE.health:SetSize(BLIZZ_PLATE.health:GetWidth() * (BLIZZ_PLATE.health:GetEffectiveScale() * 1.25), HBHeight)
			SVUI_PLATE.name:SetPoint("BOTTOM", SVUI_PLATE.health, "TOP", 0, 3)
		else
			SVUI_PLATE.name:SetPoint("BOTTOMLEFT", SVUI_PLATE.health, "TOPLEFT", 0, 3)
			SVUI_PLATE.name:SetPoint("BOTTOMRIGHT", SVUI_PLATE.level, "BOTTOMLEFT", -2, 0)
		end

		UpdatePlateElements(BLIZZ_PLATE, SVUI_PLATE)

		HealthBarValueChanged(BLIZZ_PLATE.health, BLIZZ_PLATE.health:GetValue())

		if(not PLATE_ARGS.tiny) then
			CheckRaidIcon()
			MOD:UpdateAuras(BLIZZ_PLATE)
		else
			PLATE_ARGS.allowed = true
		end

		if(not NPPointerMatch) then
			NPGlow:SetBackdropBorderColor(unpack(NPPointerColor))
		end
	end

	local function HideThisPlate(plate)
		if(not ProxyThisPlate(plate)) then return; end

		SVUI_PLATE:Hide()
		PLATE_GRIP:Hide()
		VisiblePlates[plate] = nil

		PLATE_REF.reaction = nil
		PLATE_ARGS.unitcategory = nil
		plate.guid = nil
		PLATE_ARGS.unit = nil
		PLATE_REF.raidicontype = nil
		PLATE_ARGS.scaled = nil
		PLATE_ARGS.tiny = nil
		PLATE_ARGS.allowed = nil
		if(NPGlow:GetParent() == SVUI_PLATE) then
			NPGlow:Hide()
		end
		SVUI_PLATE.health.alert:Hide()
		SVUI_PLATE.health.icon:Hide()
		if SVUI_PLATE.health then
			SVUI_PLATE.health:SetSize(HBWidth, HBHeight)
			plate.cast.icon:Size(CBHeight + HBHeight + 5)
		end
		if PLATE_AURAS then
			for index = 1, #PLATE_AURAICONS do
				MOD.RegisterAuraClock(PLATE_AURAICONS[index], 0)
			end		
		end
		if MOD.UseCombo then
			for i=1, MAX_COMBO_POINTS do
				SVUI_PLATE.combo[i]:Hide()
			end
		end

		SVUI_PLATE:SetPoint("BOTTOMLEFT", plate, "BOTTOMLEFT")
	end

	local function UpdateThisPlate(plate)
		if(not ProxyThisPlate(plate, true)) then return; end
		SVUI_PLATE.name:SetFontTemplate(NPFont, NPFSize, NPFOutline)
		SVUI_PLATE.name:SetTextColor(1, 1, 1)
		SVUI_PLATE.level:SetFontTemplate(NPFont, NPFSize, NPFOutline)
		if not PLATE_ARGS.scaled and not PLATE_ARGS.tiny then
			SVUI_PLATE.health:SetSize(HBWidth, HBHeight)
		end
		SVUI_PLATE.health:SetStatusBarTexture(SuperVillain.Textures.textured)
		SVUI_PLATE.health.text:SetFontTemplate(NPFont, NPFSize, NPFOutline)
		SVUI_PLATE.cast:SetSize(HBWidth, CBHeight)
		SVUI_PLATE.cast:SetStatusBarTexture(SuperVillain.Textures.glow)
		SVUI_PLATE.cast.text:SetFontTemplate(NPFont, NPFSize, NPFOutline)
		plate.cast.text:SetFontTemplate(NPFont, NPFSize, NPFOutline)
		plate.cast.icon:Size((CBHeight + HBHeight) + 5)
		PLATE_REF.raidicon:ClearAllPoints()
		SuperVillain:ReversePoint(PLATE_REF.raidicon, RIAnchor, SVUI_PLATE.health, RIXoffset, RIYoffset)	
		PLATE_REF.raidicon:SetSize(RISize, RISize)
		SVUI_PLATE.health.icon:ClearAllPoints()
		SuperVillain:ReversePoint(SVUI_PLATE.health.icon, RIAnchor, SVUI_PLATE.health, RIXoffset, RIYoffset)
		SVUI_PLATE.health.icon:SetSize(RISize, RISize)
		for index = 1, #PLATE_AURAICONS do 
			if PLATE_AURAICONS and PLATE_AURAICONS[index] then
				PLATE_AURAICONS[index].TimeLeft:SetFontTemplate(AuraFont, AuraFSize, AuraFOutline)
				PLATE_AURAICONS[index].Stacks:SetFontTemplate(AuraFont, AuraFSize, AuraFOutline)
				PLATE_AURAICONS[index].Icon:SetTexCoord(.07, 0.93, .23, 0.77)
			end
		end

		if(MOD.UseCombo and not SVUI_PLATE.combo:IsShown()) then
			SVUI_PLATE.combo:Show()	
		elseif(SVUI_PLATE.combo:IsShown()) then
			SVUI_PLATE.combo:Hide()	
		end

		ShowThisPlate(plate)
		HealthBarSizeChanged(SVUI_PLATE.health, SVUI_PLATE.health:GetSize())
	end

	function PlateForge(plate)
		PlateRegistry[plate] = true;

		local ref, skin = {}, {};
		local barRegions, fontRegions = plate:GetChildren()
		local health, cast = barRegions:GetChildren()

		ref.threat,
		ref.border,
		ref.highlight,
		ref.level,
		ref.skullicon,
		ref.raidicon,
		ref.eliteicon = barRegions:GetRegions()

		ref.nametext = "";

		cast.border,
		cast.shield,
		cast.icon,
		cast.text,
		cast.shadow = select(2, cast:GetRegions())

		health:SetStatusBarTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\EMPTY")
		cast:SetStatusBarTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\EMPTY")

		plate.health = health
		plate.cast = cast
		plate.name = fontRegions:GetRegions()

		health:Hide()
		fontRegions:Hide()

		ref.threat:SetTexture(nil)
		ref.border:Hide()
		ref.highlight:SetTexture(nil)
		ref.level:SetWidth( 000.1 )
		ref.level:Hide()
		ref.skullicon:SetTexture(nil)
		ref.raidicon:SetAlpha( 0 )
		ref.eliteicon:SetTexture(nil)

		plate.name:Hide()

		cast.border:SetTexture(nil)
		cast.shield:SetTexture(nil)
		cast.icon:SetTexCoord( 0, 0, 0, 0 )
		cast.icon:SetWidth(.001)
		cast.shadow:SetTexture(nil)
		cast.shadow:Hide()
		cast.text:Hide()

		local frameName = "SVUI_PlateHolder"..numChildren
		local holder = CreateFrame("Frame", frameName, NPGrip)
		local frame = CreateFrame("Frame", nil, holder)

		--[[ HEALTH BAR ]]--

		frame.health = CreateFrame("StatusBar", nil, frame)
		frame.health:SetPoint('BOTTOM', frame, 'BOTTOM', 0, 5)
		frame.health:SetFrameStrata("BACKGROUND")
		frame.health:SetFrameLevel(0)
		frame.health:SetScript("OnSizeChanged", HealthBarSizeChanged)
		frame.health.sync = plate;
		SetPlateBorder(frame.health)

		frame.health.text = frame.health:CreateFontString(nil, 'OVERLAY')
		frame.health.text:SetPoint("CENTER", frame.health, HBTextAnchor, HBXoffset, HBYoffset)
		frame.health.text:SetJustifyH("CENTER")

		frame.level = frame:CreateFontString(nil, 'OVERLAY')
		frame.level:SetPoint("BOTTOMRIGHT", frame.health, "TOPRIGHT", 3, 3)
		frame.level:SetJustifyH("RIGHT")

		frame.name = frame:CreateFontString(nil, 'OVERLAY')
		frame.name:SetJustifyH("LEFT")

		frame.eliteicon = frame:CreateTexture(nil, "OVERLAY")
		frame.skullicon = frame:CreateTexture(nil, "OVERLAY")

		frame.raidicon = frame:CreateTexture(nil, "ARTWORK")
		frame.raidicon:SetSize(NPIcons,NPIcons)
		frame.raidicon:SetPoint("RIGHT", frame.health, "LEFT", -3, 0)
		frame.raidicon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")

		frame.health.icon = frame:CreateTexture(nil, 'ARTWORK')
		frame.health.icon:SetSize(ref.raidicon:GetSize())
		frame.health.icon:SetPoint("BOTTOMRIGHT", frame.health, "TOPLEFT", -3, 3)
		frame.health.icon:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\HEALER")
		frame.health.icon:Hide()

		frame.highlight = frame:CreateTexture(nil, 'OVERLAY')
		frame.highlight:SetAllPoints(frame.health)
		frame.highlight:SetTexture(1, 1, 1, 0.3)
		frame.highlight:Hide()

		local alert = CreateFrame("Frame", nil, frame)
		alert:SetFrameLevel(0)
		alert:WrapOuter(frame.health,2,2)
		alert:SetBackdrop({edgeFile=SuperVillain.Textures.shadow,edgeSize=2})		
		alert:SetBackdropColor(0, 0, 0, 0)
		alert:SetBackdropBorderColor(1, 1, 0, 0.9)
		alert:SetScale(1.5)
		alert:Hide()
		frame.health.alert = alert

		health.sync = frame.health

		--[[ CAST BAR ]]--

		frame.cast = CreateFrame("StatusBar", nil, frame)
		frame.cast:SetPoint('TOPLEFT', frame.health, 'BOTTOMLEFT', 0, -5)	
		frame.cast:SetPoint('TOPRIGHT', frame.health, 'BOTTOMRIGHT', 0, -5)	
		frame.cast:SetFrameStrata("BACKGROUND")
		frame.cast:SetFrameLevel(0)

		SetPlateBorder(frame.cast)

		frame.cast.text = frame.cast:CreateFontString(nil, 'OVERLAY')
		frame.cast.text:SetPoint("TOPRIGHT", frame.cast, "BOTTOMRIGHT", 6, -2)
		frame.cast.text:SetJustifyH("RIGHT")

		cast.text:SetParent(frame.cast)
		cast.text:ClearAllPoints()
		cast.text:SetPoint("TOPLEFT", frame.cast, "BOTTOMLEFT", 0, -2)
		cast.text:SetPoint("TOPRIGHT", frame.cast.text, "TOPLEFT", 0, -2)
		cast.text:SetJustifyH("LEFT")
		cast.icon:SetParent(frame.cast)
		cast.icon:SetTexCoord(.07, .93, .07, .93)
		cast.icon:SetDrawLayer("OVERLAY")
		cast.icon:ClearAllPoints()
		cast.icon:SetPoint("TOPLEFT", frame.health, "TOPRIGHT", 5, 0)

		SetPlateBorder(frame.cast, cast.icon)

		cast.sync = frame.cast

		frame.combo = CreateFrame("Frame", nil, frame.health)
		frame.combo:Point("CENTER", frame.health, "BOTTOM")
		frame.combo:SetSize(68, 1)
		frame.combo:Hide()

		if MOD.UseCombo then
			for i = 1, MAX_COMBO_POINTS do
				frame.combo[i] = frame.combo:CreateTexture(nil, 'OVERLAY')
				frame.combo[i]:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\COMBO-POINT-SMALL")
				frame.combo[i]:SetSize(12, 12)
				frame.combo[i]:SetVertexColor(unpack(NPComboColor[i]))
				if(i == 1) then
					frame.combo[i]:SetPoint("TOPLEFT", frame.combo, "TOPLEFT")
				else
					frame.combo[i]:SetPoint("LEFT", frame.combo[i-1], "RIGHT", 2, 0)
				end
				frame.combo[i]:Hide()
			end
		end

		frame.auras = CreateFrame("Frame", nil, frame)
		frame.auras:SetHeight(32); frame.auras:Show()
		frame.auras:SetPoint('BOTTOMRIGHT', frame.health, 'TOPRIGHT', 0, 10)
		frame.auras:SetPoint('BOTTOMLEFT', frame.health, 'TOPLEFT', 0, 10)
		frame.auras:SetFrameStrata("BACKGROUND")
		frame.auras:SetFrameLevel(0)
		frame.auraicons = {}

		plate.holder = holder;
		plate.frame = frame;
		plate.ref = ref;
		plate.setting = {};

		plate:HookScript("OnShow", ShowThisPlate)
		plate:HookScript("OnHide", HideThisPlate)
		plate:HookScript("OnSizeChanged", function(self, width, height)
			self.frame:SetSize(width, height)
		end)

		health:HookScript("OnValueChanged", HealthBarValueChanged)

		cast:HookScript("OnShow", function(self) self.sync:Show() end)
		cast:HookScript("OnHide", function(self) self.sync:Hide() end)
		cast:HookScript("OnValueChanged", CastBarValueChanged)

		VisiblePlates[plate] = true

		UpdateThisPlate(plate)

		if not cast:IsShown() then
			frame.cast:Hide()
		elseif not frame.cast:IsShown() then
			frame.cast:Show()
		end
	end

	function MOD:UpdateAllPlates()
		self:UpdateDataLocals()
		self:UpdateAuraLocals()
		for plate, _ in pairs(VisiblePlates) do
			if(plate) then
				UpdateThisPlate(plate)
			end
		end
	end
end
--[[ 
########################################################## 
SCANNER
##########################################################
]]--
do
	local function ParseByGUID(guid)
		for plate, _ in pairs(VisiblePlates) do
			if plate and plate:IsShown() and plate.guid == guid then
				return plate
			end
		end
	end

	local function ParseByName(sourceName)
		if not sourceName then return; end
		local SearchFor = split("-", sourceName)
		for plate, _ in pairs(VisiblePlates) do
			if plate and plate:IsShown() and plate.ref.nametext == SearchFor and RAID_CLASS_COLORS[plate.setting.unitcategory] then
				return plate
			end
		end
	end

	local function ParseByIconName(raidIcon)
		for plate, _ in pairs(VisiblePlates) do
			CheckRaidIcon(plate)
			if plate and plate:IsShown() and plate.ref.raidicon:IsShown() and (plate.ref.raidicontype and plate.ref.raidicontype == raidIcon) then
				return plate
			end
		end		
	end

	function MOD:RequestScanUpdate(guid, raidIcon, name, callbackFunc)
		local plate
		if guid then plate = ParseByGUID(guid) end
		if (not plate) and name then plate = ParseByName(name) end
		if (not plate) and raidIcon then plate = ParseByIconName(raidIcon) end
		if(plate) then
			MOD[callbackFunc](MOD, plate)
		end
	end
end
--[[ 
########################################################## 
EVENTS
##########################################################
]]--
function MOD:PLAYER_ENTERING_WORLD()
	MOD:UpdateDataLocals();
end

function MOD:UPDATE_MOUSEOVER_UNIT()
	WorldFrame.elapsed = 0.1
end

function MOD:PLAYER_TARGET_CHANGED()
	if(UnitExists("target")) then
		CURRENT_TARGET_NAME = UnitName("target")
		WorldFrame.elapsed = 0.1
		TARGET_CHECKS = 0
	else
		NPGlow:Hide()
		CURRENT_TARGET_NAME = nil
	end
end

function MOD:PLAYER_REGEN_DISABLED()
	SetCVar("nameplateShowEnemies", 1)
end

function MOD:PLAYER_REGEN_ENABLED()
	SetCVar("nameplateShowEnemies", 0)
end
--[[ 
########################################################## 
UPDATE AND BUILD
##########################################################
]]--
function MOD:UpdateDataLocals()
	local db = self.db
	if not db then return end;

	NPClassRole = SuperVillain.ClassRole;
	NPBaseAlpha = db.nonTargetAlpha;
	NPCombatHide = db.combatHide;

	NPFont = LSM:Fetch("font", db.font);
	NPFSize = db.fontSize;
	NPFOutline = db.fontOutline;

	AuraFont = LSM:Fetch("font", db.auras.font);
	AuraFSize = db.auras.fontSize;
	AuraFOutline = db.auras.fontOutline;
	AuraMaxCount = db.auras.numAuras;

	RIAnchor = db.raidHealIcon.attachTo;
	RIXoffset = db.raidHealIcon.xOffset;
	RIYoffset = db.raidHealIcon.yOffset;
	RISize = db.raidHealIcon.size;

	HBThresh = db.healthBar.lowThreshold;
	NPNameMatch = db.colorNameByValue;
	HBTextFormat = db.healthBar.text.enable and db.healthBar.text.format or false;
	HBTextAnchor = db.healthBar.text.attachTo;
	HBXoffset = db.healthBar.text.xOffset;
	HBYoffset = db.healthBar.text.yOffset;
	HBWidth = db.healthBar.width;
	HBHeight = db.healthBar.height;

	NPIcons = HBHeight * 1.5

	CBColor = {db.castBar.color.r, db.castBar.color.g, db.castBar.color.b}
	CBNoInterrupt = {db.castBar.noInterrupt.r, db.castBar.noInterrupt.g, db.castBar.noInterrupt.b}
	CBHeight = db.castBar.height;

	NPUsePointer = db.pointer.enable;
	NPPointerMatch = db.pointer.colorMatchHealthBar;
	NPPointerColor = {db.pointer.color.r, db.pointer.color.g, db.pointer.color.b};

	local tc = db.threat
	NPUseThreat = tc.enable;
	NPThreatGS = tc.goodScale;
	NPThreatBS = tc.badScale;
	NPGoodThreat = {tc.goodColor.r, tc.goodColor.g, tc.goodColor.b}
	NPBadThreat = {tc.badColor.r, tc.badColor.g, tc.badColor.b}
	NPGoodTrans = {tc.goodTransitionColor.r, tc.goodTransitionColor.g, tc.goodTransitionColor.b}
	NPBadTrans = {tc.badTransitionColor.r, tc.badTransitionColor.g, tc.badTransitionColor.b}

	local rc = db.reactions
	NPReactTap = {rc.tapped.r, rc.tapped.g, rc.tapped.b}
	NPReactNPCGood = {rc.friendlyNPC.r, rc.friendlyNPC.g, rc.friendlyNPC.b}
	NPReactPlayerGood = {rc.friendlyPlayer.r, rc.friendlyPlayer.g, rc.friendlyPlayer.b}
	NPReactNeutral = {rc.neutral.r, rc.neutral.g, rc.neutral.b}
	NPReactEnemy = {rc.enemy.r, rc.enemy.g, rc.enemy.b}

	if (db.comboPoints and (SuperVillain.class == 'ROGUE' or SuperVillain.class == 'DRUID')) then
		MOD.UseCombo = true
	else
		MOD.UseCombo = false
	end
end

function MOD:CombatToggle(noToggle)
	if(NPCombatHide) then
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		if(not noToggle) then
			SetCVar("nameplateShowEnemies", 0)
		end
	else
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		if(not noToggle) then
			SetCVar("nameplateShowEnemies", 1)
		end
	end
end

function MOD:UpdateThisPackage()
	if SuperVillain.protected["SVPlate"].enable ~= true then 
		self:DisableTracking()
		return 
	end
	self:UpdateAllPlates();
end;

function MOD:ConstructThisPackage()
	if SuperVillain.protected["SVPlate"].enable ~= true then return end
	self.UseCombo = false;
	self:UpdateDataLocals()
	WorldFrame:HookScript('OnUpdate', WorldFrameUpdateHook)
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	self:EnableTracking()
	self:CombatToggle(true)
end
SuperVillain.Registry:NewPackage(MOD:GetName())
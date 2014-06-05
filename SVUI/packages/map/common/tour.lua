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
local unpack    = _G.unpack;
local select    = _G.select;
local pairs     = _G.pairs;
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local tinsert   = _G.tinsert;
local string    = _G.string;
local math      = _G.math;
--[[ STRING METHODS ]]--
local lower, upper = string.lower, string.upper;
local match, gsub = string.match, string.gsub;
--[[ MATH METHODS ]]--
local parsefloat = math.parsefloat;  -- Uncommon
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain:GetModule('SVMap');
local tourist = LibStub("LibTourist-3.0");
local LSM = LibStub("LibSharedMedia-3.0");
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local cColor = RAID_CLASS_COLORS[SuperVillain.class];
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function GetStatus(color)
	local status = ""
	local statusText
	local r, g, b = 1, 1, 0
	local pvpType = GetZonePVPInfo()
	local inInstance, _ = IsInInstance()
	if (pvpType == "sanctuary") then
		status = SANCTUARY_TERRITORY
		r, g, b = 0.41, 0.8, 0.94
	elseif(pvpType == "arena") then
		status = ARENA
		r, g, b = 1, 0.1, 0.1
	elseif(pvpType == "friendly") then
		status = FRIENDLY
		r, g, b = 0.1, 1, 0.1
	elseif(pvpType == "hostile") then
		status = HOSTILE
		r, g, b = 1, 0.1, 0.1
	elseif(pvpType == "contested") then
		status = CONTESTED_TERRITORY
		r, g, b = 1, 0.7, 0.10
	elseif(pvpType == "combat" ) then
		status = COMBAT
		r, g, b = 1, 0.1, 0.1
	elseif inInstance then
		status = AGGRO_WARNING_IN_INSTANCE
		r, g, b = 1, 0.1, 0.1
	else
		status = CONTESTED_TERRITORY
	end
	statusText = string.format("|cff%02x%02x%02x%s|r", r*255, g*255, b*255, status)
	if color then
		return r, g, b
	else
		return statusText
	end
end;

local function GetDungeonCoords(zone)
	local z, x, y = "", 0, 0;
	local dcoords
	if tourist:IsInstance(zone) then
		z, x, y = tourist:GetEntrancePortalLocation(zone);
	end
	if z == nil then
		dcoords = ""
	else 
		x = tonumber(parsefloat(x, 0))
		y = tonumber(parsefloat(y, 0))		
		dcoords = string.format(" (%d, %d)", x, y)
	end
	return dcoords
end;

 local function PvPorRaidFilter(zone)
	local isPvP, isRaid;
	isPvP = nil;
	isRaid = nil;
	if(tourist:IsArena(zone) or tourist:IsBattleground(zone)) then
		isPvP = true;
	end
	if(not isPvP and tourist:GetInstanceGroupSize(zone) >= 10) then
		isRaid = true;
	end
	return (isPvP and "|cffff0000 "..PVP.."|r" or "")..(isRaid and "|cffff4400 "..RAID.."|r" or "")
end;

local function GetRecomZones(zone)
	local low, high = tourist:GetLevel(zone)
	local r, g, b = tourist:GetLevelColor(zone)
	local zContinent = tourist:GetContinent(zone)
	if PvPorRaidFilter(zone) == nil then return end
	GameTooltip:AddDoubleLine("|cffffffff"..zone..PvPorRaidFilter(zone) or "", format("|cff%02xff00%s|r", continent == zContinent and 0 or 255, zContinent)..(" |cff%02x%02x%02x%s|r"):format(r *255, g *255, b *255,(low == high and low or ("%d-%d"):format(low, high))));
end;

local function GetZoneDungeons(zone)
	local low, high = tourist:GetLevel(zone)
	local r, g, b = tourist:GetLevelColor(zone)
	local groupSize = tourist:GetInstanceGroupSize(zone)
	local altGroupSize = tourist:GetInstanceAltGroupSize(zone)
	local groupSizeStyle = (groupSize > 0 and format("|cFFFFFF00|r (%d", groupSize) or "")
	local altGroupSizeStyle = (altGroupSize > 0 and format("|cFFFFFF00|r/%d", altGroupSize) or "")
	if PvPorRaidFilter(zone) == nil then return end
	GameTooltip:AddDoubleLine("|cffffffff"..zone..(groupSizeStyle or "")..(altGroupSizeStyle or "").."-"..PLAYER..") "..GetDungeonCoords(zone)..PvPorRaidFilter(zone) or "", ("|cff%02x%02x%02x%s|r"):format(r *255, g *255, b *255,(low == high and low or ("%d-%d"):format(low, high))))
end;

local function GetRecomDungeons(zone)
	local low, high = tourist:GetLevel(zone);	
	local r, g, b = tourist:GetLevelColor(zone);
	local instZone = tourist:GetInstanceZone(zone);
	if PvPorRaidFilter(zone) == nil then return end
	if instZone == nil then
		instZone = ""
	else
		instZone = "|cFFFFA500 ("..instZone..")"
	end
	GameTooltip:AddDoubleLine("|cffffffff"..zone..instZone..GetDungeonCoords(zone)..PvPorRaidFilter(zone) or "", ("|cff%02x%02x%02x%s|r"):format(r *255, g *255, b *255,(low == high and low or ("%d-%d"):format(low, high))))
end;

local FISH_ICON = "|TInterface\\AddOns\\ElvUI_LocPlus\\media\\fish.tga:14:14|t";
local PET_ICON = "|TInterface\\AddOns\\ElvUI_LocPlus\\media\\pet.tga:14:14|t";
local LEVEL_ICON = "|TInterface\\AddOns\\ElvUI_LocPlus\\media\\levelup.tga:14:14|t";

local function GetFishingLvl(minFish, ontt)
	local zoneText = GetRealZoneText()
	local minFish = tourist:GetFishingLevel(zoneText)
	local _, _, _, fishing = GetProfessions()
	local r, g, b = 1, 0, 0
	local r1, g1, b1 = 1, 0, 0
	local rank
	if minFish then
		if fishing ~= nil then
			_, _, rank, _, _, _, _, rankModifier = GetProfessionInfo(fishing)
			if minFish < rank then
				r, g, b = 0, 1, 0
				r1, g1, b1 = 0, 1, 0
			elseif minFish == rank then
				r, g, b = 1, 1, 0
				r1, g1, b1 = 1, 1, 0
			end
		end
		if ontt then
			return (string.format("|cff%02x%02x%02x%d|r", r*255, g*255, b*255, minFish))
		else
			local dfish
			if (rankModifier and rankModifier > 0) then
				dfish = string.format("|cff%02x%02x%02x%d|r", r1*255, g1*255, b1*255, rank)..(string.format("|cFF6b8df4+%s|r", rankModifier)).."/"..(string.format("|cff%02x%02x%02x%d|r", r*255, g*255, b*255, minFish)) or ""
			else
				dfish = string.format("|cff%02x%02x%02x%d|r", r1*255, g1*255, b1*255, rank).."-"..(string.format("|cff%02x%02x%02x%d|r", r*255, g*255, b*255, minFish)) or ""
			end
			return " ("..dfish..") "..FISH_ICON
		end
	else
		return ""
	end
end;

local function GetBattlePetLvl(zoneText, ontt)
	local mapID = GetCurrentMapAreaID()
	local zoneText = GetMapNameByID(mapID) or UNKNOWN;
	local low,high = tourist:GetBattlePetLevel(zoneText)
	local plevel
	if low ~= nil or high ~= nil then
		if low ~= high then
			plevel = string.format("%d-%d", low, high)
		else
			plevel = string.format("%d", high)
		end
		if ontt then
			return plevel
		else
			if E.db.locplus.showicon then
				plevel = " ("..plevel..") "..PET_ICON
			else
				plevel = " ("..plevel..")"
			end
		end
	end
	return plevel or ""
end;

local function GetLevelRange(zoneText, ontt)
	local zoneText = GetRealZoneText()
	local low, high = tourist:GetLevel(zoneText)
	local dlevel
	if low > 0 and high > 0 then
		local r, g, b = tourist:GetLevelColor(zoneText)
		if low ~= high then
			dlevel = string.format("|cff%02x%02x%02x%d-%d|r", r*255, g*255, b*255, low, high) or ""
		else
			dlevel = string.format("|cff%02x%02x%02x%d|r", r*255, g*255, b*255, high) or ""
		end
		if ontt then
			return dlevel
		else
			dlevel = " ("..dlevel..") "..LEVEL_ICON
		end
	end
	return dlevel or ""
end;
--[[ 
########################################################## 
TOURING
##########################################################
]]--
function MOD:MiniMapRefreshCoords()
	local a,b=IsInInstance()
	local c,d=GetPlayerMapPosition("player")
	local xF,yF = "|cffffffffx:  |r%.1f","|cffffffffy:  |r%.1f"
	if(MOD.db.playercoords == "SIMPLE") then
		xF,yF = "%.1f","%.1f";
	end;
	c = parsefloat(100*c,2)
	d = parsefloat(100*d,2)
	if c~=0 and d~=0 then 
		SVUI_MiniMapCoords.playerXCoords:SetFormattedText(xF,c)
		SVUI_MiniMapCoords.playerYCoords:SetFormattedText(yF,d)
	else 
		SVUI_MiniMapCoords.playerXCoords:SetText("")
		SVUI_MiniMapCoords.playerYCoords:SetText("")
	end; 
end;

function MOD:MiniMapCoordsUpdate()
	if(not MOD.db.playercoords or MOD.db.playercoords == "HIDE") then
		if MOD.CoordTimer then
			MOD:CancelTimer(MOD.CoordTimer)
			MOD.CoordTimer = nil;
		end
		SVUI_MiniMapCoords.playerXCoords:SetText("")
		SVUI_MiniMapCoords.playerYCoords:SetText("")
	else
		MOD.CoordTimer = MOD:ScheduleRepeatingTimer('MiniMapRefreshCoords',0.05)
		MOD:MiniMapRefreshCoords()
	end 
end;

function MOD:CreateCoords()
	local x, y = GetPlayerMapPosition("player")
	x = tonumber(parsefloat(100 * x, 0))
	y = tonumber(parsefloat(100 * y, 0))
	return x, y
end;

function MOD:UpdateTourData()
	local mapID = GetCurrentMapAreaID()
	local zoneText = GetMapNameByID(mapID) or UNKNOWN;
	local curPos = (zoneText.." ") or "";
	GameTooltip:ClearLines()
	GameTooltip:AddDoubleLine(L["Zone : "], zoneText, 1, 1, 1, selectioncolor)
	GameTooltip:AddDoubleLine(CONTINENT.." : ", tourist:GetContinent(zoneText), 1, 1, 1, selectioncolor)
	GameTooltip:AddDoubleLine(HOME.." :", GetBindLocation(), 1, 1, 1, 0.41, 0.8, 0.94)
	GameTooltip:AddDoubleLine(STATUS.." :", GetStatus(), 1, 1, 1)
	local checklvl = GetLevelRange(zoneText, true)
	if checklvl ~= "" then
		GameTooltip:AddDoubleLine(LEVEL_RANGE.." : ", checklvl, 1, 1, 1, r, g, b)
	end
	local checkfish = GetFishingLvl(minFish, true)
	if checkfish ~= "" then
		GameTooltip:AddDoubleLine(PROFESSIONS_FISHING.." : ", checkfish, 1, 1, 1, r, g, b)
	end
	local checkbpet = GetBattlePetLvl(zoneText, true)
	if checkbpet ~= "" then
		GameTooltip:AddDoubleLine(L["Battle Pet level"].. " :", checkbpet, 1, 1, 1, selectioncolor)
	end
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(L["Recommended Zones :"], selectioncolor)
	for zone in tourist:IterateRecommendedZones() do
		GetRecomZones(zone);
	end
	if tourist:DoesZoneHaveInstances(zoneText) then 
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(format(curPos..DUNGEONS.." :"), selectioncolor)
		for zone in tourist:IterateZoneInstances(zoneText) do
			GetZoneDungeons(zone);
		end	
	end
	local level = UnitLevel('player')
	if tourist:HasRecommendedInstances() and level >= 15 then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L["Recommended Dungeons :"], selectioncolor)	
		for zone in tourist:IterateRecommendedInstances() do
			GetRecomDungeons(zone);
		end
	end
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine(L["Click : "], L["Toggle WorldMap"], 0.7, 0.7, 1, 0.7, 0.7, 1)
	GameTooltip:AddDoubleLine(L["ShiftClick : "], L["Announce your position in chat"],0.7, 0.7, 1, 0.7, 0.7, 1)
	GameTooltip:Show()
end;

local function Tour_OnEnter(self,...)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -4)
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("BOTTOM", self, "BOTTOM", 0, 0)
	if InCombatLockdown() then
		GameTooltip:Hide()
	else
		MOD:UpdateTourData()
	end
end;

local function Tour_OnLeave(self,...)
	GameTooltip:Hide()
end;

local function Tour_OnClick(self, btn)
	zoneText = GetRealZoneText() or UNKNOWN;
	if IsShiftKeyDown() then
		local edit_box = ChatEdit_ChooseBoxForSend()
		local x, y = MOD:CreateCoords()
		local message
		local coords = x..", "..y
			if zoneText ~= GetSubZoneText() then
				message = format("%s: %s (%s)", zoneText, GetSubZoneText(), coords)
			else
				message = format("%s (%s)", zoneText, coords)
			end
		ChatEdit_ActivateChat(edit_box)
		edit_box:Insert(message) 
	else
		ToggleFrame(WorldMapFrame)
	end
end;

function MOD:LoadWorldTour()
	local CoordsHolder=CreateFrame('Frame','SVUI_MiniMapCoords',Minimap)
	CoordsHolder:SetFrameLevel(Minimap:GetFrameLevel()+1)
	CoordsHolder:SetFrameStrata(Minimap:GetFrameStrata())
	CoordsHolder:SetPoint("TOPLEFT",SVUI_MinimapFrame,"BOTTOMLEFT",0,-4)
	CoordsHolder:SetPoint("TOPRIGHT",SVUI_MinimapFrame,"BOTTOMRIGHT",0,-4)
	CoordsHolder:SetHeight(17)
	CoordsHolder:EnableMouse(true)
	CoordsHolder:SetScript("OnEnter",Tour_OnEnter)
	CoordsHolder:SetScript("OnLeave",Tour_OnLeave)
	CoordsHolder:SetScript("OnMouseDown",Tour_OnClick)

	CoordsHolder.playerXCoords=CoordsHolder:CreateFontString(nil,'OVERLAY')
	CoordsHolder.playerXCoords:SetPoint("BOTTOMLEFT",CoordsHolder,"BOTTOMLEFT",0,0)
	CoordsHolder.playerXCoords:SetWidth(70)
	CoordsHolder.playerXCoords:SetHeight(17)
	CoordsHolder.playerXCoords:SetFontTemplate(SuperVillain.Fonts.numbers, 12, "OUTLINE")
	CoordsHolder.playerXCoords:SetTextColor(cColor.r,cColor.g,cColor.b)
	CoordsHolder.playerXCoords:SetText("")

	CoordsHolder.playerYCoords=CoordsHolder:CreateFontString(nil,'OVERLAY')
	CoordsHolder.playerYCoords:SetPoint("BOTTOMLEFT",CoordsHolder.playerXCoords,"BOTTOMRIGHT",4,0)
	CoordsHolder.playerXCoords:SetWidth(70)
	CoordsHolder.playerYCoords:SetHeight(17)
	CoordsHolder.playerYCoords:SetFontTemplate(SuperVillain.Fonts.numbers, 12, "OUTLINE")
	CoordsHolder.playerYCoords:SetTextColor(cColor.r,cColor.g,cColor.b)
	CoordsHolder.playerYCoords:SetText("")

	if(MOD.db.playercoords and MOD.db.playercoords ~= "HIDE") then
		MOD.CoordTimer = MOD:ScheduleRepeatingTimer('MiniMapRefreshCoords',0.05)
	else
		MOD.CoordTimer = nil
	end
end;
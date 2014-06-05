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
local SuperVillain, L, P, C, G = unpack(select(2, ...));
local MOD = SuperVillain:GetModule('SVMap');

local function AdjustMapLevel()
	if InCombatLockdown()then return end;
	WorldMapFrame:SetFrameLevel(2)
  	WorldMapDetailFrame:SetFrameLevel(4)
  	WorldMapFrame:SetFrameStrata('HIGH')
  	WorldMapArchaeologyDigSites:SetFrameLevel(6)
  	WorldMapArchaeologyDigSites:SetFrameStrata('DIALOG')
end;

function MOD:AdjustMapSize()
	if InCombatLockdown() then return end;
	if SuperVillain.db.common.tinyWorldMap then
		if WORLDMAP_SETTINGS.size == WORLDMAP_FULLMAP_SIZE then 
			self:SetLargeWorldMap()
		elseif WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE then 
			self:SetSmallWorldMap()
		elseif WORLDMAP_SETTINGS.size == WORLDMAP_QUESTLIST_SIZE then 
			self:SetQuestWorldMap()
		end 
	end;
	AdjustMapLevel()
end;

function MOD:SetLargeWorldMap()
	if InCombatLockdown() then return end;
	if SuperVillain.db.common.tinyWorldMap then
		WorldMapFrame:SetParent(SuperVillain.UIParent)
		WorldMapFrame:EnableMouse(false)
		WorldMapFrame:EnableKeyboard(false)
		WorldMapFrame:SetScale(1)
		if WorldMapFrame:GetAttribute('UIPanelLayout-area') ~= 'center'then
			SetUIPanelAttribute(WorldMapFrame, "area", "center")
		end;
		if WorldMapFrame:GetAttribute('UIPanelLayout-allowOtherPanels') ~= true then
			SetUIPanelAttribute(WorldMapFrame, "allowOtherPanels", true)
		end 
	end;
	WorldMapFrameSizeUpButton:Hide()
	WorldMapFrameSizeDownButton:Show()
end;

function MOD:SetQuestWorldMap()
	if InCombatLockdown() then return end;
	if SuperVillain.db.common.tinyWorldMap then
		WorldMapFrame:SetParent(SuperVillain.UIParent)
		WorldMapFrame:EnableMouse(false)
		WorldMapFrame:EnableKeyboard(false)
		if WorldMapFrame:GetAttribute('UIPanelLayout-area') ~= 'center'then
			SetUIPanelAttribute(WorldMapFrame, "area", "center")
		end;
		if WorldMapFrame:GetAttribute('UIPanelLayout-allowOtherPanels') ~= true then
			SetUIPanelAttribute(WorldMapFrame, "allowOtherPanels", true)
		end 
	end;
	WorldMapFrameSizeUpButton:Hide()
	WorldMapFrameSizeDownButton:Show()
end;

function MOD:SetSmallWorldMap()
	if InCombatLockdown() then return end;
	WorldMapLevelDropDown:ClearAllPoints()
	WorldMapLevelDropDown:Point("TOPLEFT", WorldMapDetailFrame, "TOPLEFT", -10, -4)
	WorldMapFrameSizeUpButton:Show()
	WorldMapFrameSizeDownButton:Hide()
end;

function MOD:UpdateWorldMapAlpha()
	if(MOD.db.mapAlpha == 100) then
		if MOD.MovingTimer then
			MOD:CancelTimer(MOD.MovingTimer)
			MOD.MovingTimer = nil
		end
	elseif(not MOD.MovingTimer) then
		MOD.MovingTimer = MOD:ScheduleRepeatingTimer("CheckMovement",0.2)
	end;
end;

function MOD:CheckMovement()
	if(not WorldMapFrame:IsShown()) then return end;
	if GetUnitSpeed("player") ~= 0 then
		WorldMapFrame:SetAlpha(MOD.db.mapAlpha)
	else
		WorldMapFrame:SetAlpha(1)
	end 
end;

function MOD:UpdateWorldMapCoords()
	if(not WorldMapFrame:IsShown()) then return end;
	local a,b=IsInInstance()
	local c,d=GetPlayerMapPosition("player")
	c=parsefloat(100*c,2)
	d=parsefloat(100*d,2)
	if c~=0 and d~=0 then 
		SVUI_WorldMapCoords.playerCoords:SetText(PLAYER..":   "..c..", "..d)
	else 
		SVUI_WorldMapCoords.playerCoords:SetText("")
	end;
	local e=WorldMapDetailFrame:GetEffectiveScale()
	local f=WorldMapDetailFrame:GetWidth()
	local g=WorldMapDetailFrame:GetHeight()
	local h,i=WorldMapDetailFrame:GetCenter()
	local c,d=GetCursorPosition()
	local j=(c/e - (h - (f/2)))/f;
	local k=(i+(g/2)-d/e)/g;
	if j>=0 and k>=0 and j<=1 and k<=1 then 
		j=parsefloat(100*j,2)
		k=parsefloat(100*k,2)
		SVUI_WorldMapCoords.mouseCoords:SetText(MOUSE_LABEL..":   "..j..", "..k)
	else 
		SVUI_WorldMapCoords.mouseCoords:SetText("")
	end 
end;

function MOD:ResetDropDownListPosition(parent)
	DropDownList1:ClearAllPoints()
	DropDownList1:Point("TOPRIGHT",parent,"BOTTOMRIGHT",-17,-4)
end;

function MOD:WorldMapFrame_OnShow()
	if InCombatLockdown()then return end;
	AdjustMapLevel()
end;

function MOD:ToggleTinyWorldMapSetting()
	if InCombatLockdown()then return end;
	if MOD.db.tinyWorldMap then
		BlackoutWorld:SetTexture(nil)
		self:SecureHook("WorldMap_ToggleSizeUp", 'AdjustMapSize')
		self:SecureHook("WorldMapFrame_SetFullMapView", 'SetLargeWorldMap')
		self:SecureHook("WorldMapFrame_SetQuestMapView", 'SetQuestWorldMap')
		if WORLDMAP_SETTINGS.size == WORLDMAP_FULLMAP_SIZE then
			self:SetLargeWorldMap()
		elseif WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE then 
			self:SetSmallWorldMap()
		elseif WORLDMAP_SETTINGS.size == WORLDMAP_QUESTLIST_SIZE then 
			self:SetQuestWorldMap()
		end 
	else
		self:Unhook("WorldMap_ToggleSizeUp")
		self:Unhook("WorldMapFrame_SetFullMapView")
		self:Unhook("WorldMapFrame_SetQuestMapView")
		if WORLDMAP_SETTINGS.size == WORLDMAP_FULLMAP_SIZE then
			WorldMap_ToggleSizeUp()
			WorldMapFrame_SetFullMapView()
		elseif WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE then 
			WorldMap_ToggleSizeDown()
		elseif WORLDMAP_SETTINGS.size == WORLDMAP_QUESTLIST_SIZE then 
			WorldMap_ToggleSizeUp()
			WorldMapFrame_SetQuestMapView()
		end;
		BlackoutWorld:SetTexture(0, 0, 0, 1)
	end 
end;

function MOD:PLAYER_REGEN_ENABLED()
	self:UnregisterEvent('PLAYER_REGEN_ENABLED')
	WorldMapFrameSizeDownButton:Enable()
	WorldMapFrameSizeUpButton:Enable()
end;

function MOD:PLAYER_REGEN_DISABLED()
	WorldMapFrameSizeDownButton:Disable()
	WorldMapFrameSizeUpButton:Disable()
end;

function MOD:LoadWorldMap()
	setfenv(WorldMapFrame_OnShow, setmetatable({ UpdateMicroButtons = function()end }, { __index = _G }))
	WorldMapShowDropDown:Point('BOTTOMRIGHT',WorldMapPositioningGuide,'BOTTOMRIGHT',-2,-4)
	WorldMapZoomOutButton:Point("LEFT",WorldMapZoneDropDown,"RIGHT",0,4)
	WorldMapLevelUpButton:Point("TOPLEFT",WorldMapLevelDropDown,"TOPRIGHT",-2,8)
	WorldMapLevelDownButton:Point("BOTTOMLEFT",WorldMapLevelDropDown,"BOTTOMRIGHT",-2,2)
	WorldMapFrame:SetFrameLevel(4)
	WorldMapDetailFrame:SetFrameLevel(6)
	WorldMapFrame:SetFrameStrata('HIGH')

	self:HookScript(WorldMapFrame,'OnShow','WorldMapFrame_OnShow')
	self:HookScript(WorldMapZoneDropDownButton,'OnClick','ResetDropDownListPosition')
	self:SecureHook("WorldMap_ToggleSizeDown",'SetSmallWorldMap')
	self:RegisterEvent('PLAYER_REGEN_ENABLED')
	self:RegisterEvent('PLAYER_REGEN_DISABLED')

	local CoordsHolder=CreateFrame('Frame','SVUI_WorldMapCoords',WorldMapFrame)
	CoordsHolder:SetFrameLevel(WorldMapDetailFrame:GetFrameLevel()+1)
	CoordsHolder:SetFrameStrata(WorldMapDetailFrame:GetFrameStrata())
	CoordsHolder.playerCoords=CoordsHolder:CreateFontString(nil,'OVERLAY')
	CoordsHolder.mouseCoords=CoordsHolder:CreateFontString(nil,'OVERLAY')
	CoordsHolder.playerCoords:SetTextColor(1,1,0)
	CoordsHolder.mouseCoords:SetTextColor(1,1,0)
	CoordsHolder.playerCoords:SetFontObject(NumberFontNormal)
	CoordsHolder.mouseCoords:SetFontObject(NumberFontNormal)
	CoordsHolder.playerCoords:SetPoint("BOTTOMLEFT",WorldMapDetailFrame,"BOTTOMLEFT",5,5)
	CoordsHolder.playerCoords:SetText(PLAYER..":   0, 0")
	CoordsHolder.mouseCoords:SetPoint("BOTTOMLEFT",CoordsHolder.playerCoords,"TOPLEFT",0,5)
	CoordsHolder.mouseCoords:SetText(MOUSE_LABEL..":   0, 0")

	self.CoordsTimer = self:ScheduleRepeatingTimer('UpdateWorldMapCoords',0.05)
	self:UpdateWorldMapAlpha()

	self:ToggleTinyWorldMapSetting()
	DropDownList1:HookScript('OnShow',function(self)
		if(DropDownList1:GetScale() ~= UIParent:GetScale() and SuperVillain.db.common.tinyWorldMap) then 
			DropDownList1:SetScale(UIParent:GetScale())
		end 
	end)
end
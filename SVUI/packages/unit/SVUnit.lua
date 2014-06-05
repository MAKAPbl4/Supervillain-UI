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
local _G 		= _G;
local unpack 	= _G.unpack;
local select 	= _G.select;
local assert 	= _G.assert;
local pairs 	= _G.pairs;
local ipairs 	= _G.ipairs;
local type 		= _G.type;
local tostring 	= _G.tostring;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
--[[ STRING METHODS ]]--
local find, format = string.find, string.format;
local match, gsub = string.match, string.gsub;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, G = unpack(select(2, ...));
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.")
local MOD = SuperVillain:NewModule('SVUnit', 'AceTimer-3.0', 'AceHook-3.0');
local AceTimer = LibStub:GetLibrary("AceTimer-3.0")
local LSM = LibStub("LibSharedMedia-3.0");
--[[ 
########################################################## 
MODULE DATA
##########################################################
]]--
MOD.BasicFrameLoadList={}
MOD.GroupFrameLoadList={}
MOD.ExtraFrameLoadList={}

MOD.BasicFrames={}
MOD.GroupFrames={}
MOD.ExtraFrames={}

MOD.SecureGroupFunctions={}
MOD.SecureHeaderFunctions={}

MOD.MediaCache={}
MOD.MediaCache["bars"] = {}
MOD.MediaCache["aurabars"] = {}
MOD.MediaCache["fonts"] = {}
MOD.MediaCache["namefonts"] = {}
MOD.MediaCache["aurafonts"] = {}
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function AllowElement(unitFrame)
  if InCombatLockdown()then return end;
  if not unitFrame.isForced then 
    unitFrame.sourceElement = unitFrame.unit;
    unitFrame.unit = 'player'
    unitFrame.isForced = true;
    unitFrame.sourceEvent = unitFrame:GetScript("OnUpdate")
  end;
  unitFrame:SetScript("OnUpdate",nil)
  unitFrame.forceShowAuras=true;
  UnregisterUnitWatch(unitFrame)
  RegisterUnitWatch(unitFrame,true)
  unitFrame:Show()
  if unitFrame:IsVisible() and unitFrame.Update then 
    unitFrame:Update()
  end 
end;

local RegistrationProxy = function(frame,unit)
	local name;
	if not MOD.ExtraFrames[unit] then 
		name = GetUnitFrameActualName(unit)
		if name:find('target') then 
			name = gsub(name,'target','Target')
		end 
	else 
		name = GetUnitFrameActualName(MOD.ExtraFrames[unit])
	end;
	MOD["CreateFrame_"..name](MOD,frame,unit);
	return frame 
end;

local dummy = CreateFrame("Frame")
dummy:Hide()
local KillBlizzardUnit = function(unit)
	local frame;
	if type(unit)=='string' then frame=_G[unit] else frame=unit end;
	if frame then 
		frame:UnregisterAllEvents()
		frame:Hide()
		frame:SetParent(dummy)
		local h = frame.healthbar;
		if h then h:UnregisterAllEvents()end;
		local m = frame.manabar;
		if m then m:UnregisterAllEvents()end;
		local s = frame.spellbar;
		if s then s:UnregisterAllEvents()end;
		local p = frame.powerBarAlt;
		if p then p:UnregisterAllEvents()end 
	end 
end;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:ResetUnitOptions(unit)
	SuperVillain:TableSplice(MOD.db[unit], P.SVUnit[unit])
	if MOD.db[unit].buffs and MOD.db[unit].buffs.sizeOverride then 
		MOD.db[unit].buffs.sizeOverride = P.SVUnit[unit].buffs.sizeOverride or 0 
	end;
	if MOD.db[unit].debuffs and MOD.db[unit].debuffs.sizeOverride then 
		MOD.db[unit].debuffs.sizeOverride = P.SVUnit[unit].debuffs.sizeOverride or 0 
	end;
	MOD:RefreshUnitFrames()
end;

function MOD:RefreshUnitFrames()
	if SuperVillain.protected['SVUnit'].enable~=true then return end;
	MOD:RefreshUnitColors()
	MOD:RefreshUnitFonts()
	MOD:RefreshUnitTextures()
	for unit in pairs(MOD.BasicFrames)do 
		if MOD.db[unit].enable then 
			MOD[unit]:Enable()
			MOD[unit]:Update()
		else 
			MOD[unit]:Disable()
		end 
	end;
	for unit,group in pairs(MOD.ExtraFrames)do 
		if MOD.db[group].enable then 
			MOD[unit]:Enable()
			MOD[unit]:Update()
		else 
			MOD[unit]:Disable()
		end 
	end;

	local _,groupType = IsInInstance()
	local raidDebuffs = ns.oUF_RaidDebuffs or oUF_RaidDebuffs;
	if raidDebuffs then 
		raidDebuffs:ResetDebuffData()
		if groupType == "party" or groupType == "raid" then 
		  raidDebuffs:RegisterDebuffs(SuperVillain.Filter.Raid)
		else 
		  raidDebuffs:RegisterDebuffs(SuperVillain.Filter.CC)
		end 
	end;
	for _,group in pairs(MOD.GroupFrames) do
		group:Update()
		if group.SetConfigEnvironment then 
		  group:SetConfigEnvironment()
		end 
	end;
	if SuperVillain.protected.SVUnit.disableBlizzard then 
		oUF_SuperVillain:DisableBlizzard('party')
	end
	
	MOD:SetFadeManager()
end;

function MOD:SpawnGroupHeader(parentFrame,filter,realName,template1,secureName,template2)
	local name = parentFrame.NameKey or secureName;
	local db = MOD.db[name]
	oUF_SuperVillain:SetActiveStyle("SVUI_"..GetUnitFrameActualName(name))
	local header = oUF_SuperVillain:SpawnHeader(realName, template2, nil, 
		'oUF-initialConfigFunction', ("self:SetWidth(%d); self:SetHeight(%d); self:SetFrameLevel(5)"):format(db.width,db.height),
		'groupFilter',filter,
		'showParty',true,
		'showRaid',true,
		'showSolo',true,
		template1 and 'template', template1
	);
	header.NameKey = name;
	header:SetParent(parentFrame)
	header:Show()
	for method,func in pairs(MOD.SecureHeaderFunctions) do 
		header[method] = func 
	end;
	return header 
end;

function MOD:SetBasicFrame(unit)
	assert(unit, "No unit provided to create or update.")
	if InCombatLockdown()then MOD:FrameForge() return end;
		MOD:UpdateAuraUpvalues();
		local realName = GetUnitFrameActualName(unit);
		realName = realName:gsub("t(arget)", "T%1");
		if not MOD[unit] then 
			MOD[unit] = oUF_SuperVillain:Spawn(unit, "SVUI_"..realName)
			MOD.BasicFrames[unit] = unit 
		end;
		MOD[unit].Update = function()
		MOD["RefreshFrame_"..realName](MOD, unit, MOD[unit], MOD.db[unit]) 
	end;
	if MOD.db[unit].enable then 
		MOD[unit]:Enable()
		MOD[unit].Update()
	else 
		MOD[unit]:Disable()
	end;
	if MOD[unit]:GetParent() ~= SVUI_Parent then 
		MOD[unit]:SetParent(SVUI_Parent)
	end 
end;

function MOD:SetExtraFrame(name,max)
  if InCombatLockdown() then 
  	MOD:FrameForge()
  	return 
  end;
  MOD:UpdateAuraUpvalues();
  for i=1,max do 
    local unit = name..i;
    local realName = GetUnitFrameActualName(unit)
    realName = realName:gsub('t(arget)','T%1')
    if not MOD[unit]then 
      MOD.ExtraFrames[unit] = name;
      MOD[unit] = oUF_SuperVillain:Spawn(unit,'SVUI_'..realName)
      MOD[unit].index = i;
      MOD[unit]:SetParent(SVUI_Parent)
      MOD[unit]:SetID(i)
    end;
    local secureName = GetUnitFrameActualName(name)
    secureName = secureName:gsub('t(arget)','T%1')
    MOD[unit].Update = function()
      MOD["RefreshFrame_"..GetUnitFrameActualName(secureName)](MOD,unit,MOD[unit],MOD.db[name])
    end;
    if MOD.db[name].enable then 
      MOD[unit]:Enable()
      MOD[unit].Update()
      if MOD[unit].isForced then 
        AllowElement(MOD[unit])
      end 
    else 
      MOD[unit]:Disable()
    end 
  end 
end;

function MOD:SetGroupFrame(group,filter,template1,forceUpdate,template2)
  if InCombatLockdown()then MOD:FrameForge() return end;
  if not MOD.db[group] then return end;
  MOD:UpdateAuraUpvalues();
  local db = MOD.db[group]
  if not MOD[group] then 
    local realName = GetUnitFrameActualName(group)
    oUF_SuperVillain:RegisterStyle("SVUI_"..realName, MOD["CreateFrame_"..realName])
    oUF_SuperVillain:SetActiveStyle("SVUI_"..realName)
    if db.gCount then 
      MOD[group] = CreateFrame("Frame", "SVUI_"..realName, SVUI_Parent, "SecureHandlerStateTemplate")
      MOD[group].ExtraFrames = {
	
}
MOD[group].NameKey = group;
      for method, func in pairs(MOD.SecureGroupFunctions)do 
      MOD[group][method] = func 
      end 
    else 
      MOD[group] = MOD:SpawnGroupHeader(SVUI_Parent, filter, "SVUI_"..GetUnitFrameActualName(group), template1, group, template2)
    end;
    MOD[group].db = db;
    MOD.GroupFrames[group] = MOD[group]
    MOD[group]:Show()
  end;
  if db.gCount then 
    if db.enable ~= true and group ~= "raidpet"then 
      UnregisterStateDriver(MOD[group], "visibility")
      MOD[group]:Hide()
      return 
    end;
    if db.rSort then 
      if not MOD[group].ExtraFrames[1] then 
        MOD[group].ExtraFrames[1] = MOD:SpawnGroupHeader(MOD[group], index, "SVUI_"..GetUnitFrameActualName(MOD[group].NameKey).."Group1", template1, nil, template2)
      end 
    else 
      while db.gCount > #MOD[group].ExtraFrames do 
        local index = tostring(#MOD[group].ExtraFrames + 1)
        tinsert(MOD[group].ExtraFrames, MOD:SpawnGroupHeader(MOD[group], index, "SVUI_"..GetUnitFrameActualName(MOD[group].NameKey).."Group"..index, template1, nil, template2))
      end 
    end;
    if MOD[group].SetActiveState then MOD[group]:SetActiveState() end;
    if forceUpdate or not MOD[group].Avatar then 
      MOD[group]:SetConfigEnvironment()
      if not MOD[group].isForced and not MOD[group].blockVisibilityChanges then 
        RegisterStateDriver(MOD[group], "visibility", db.visibility)
      end 
    else 
      MOD[group]:SetConfigEnvironment()
      MOD[group]:Update()
    end;
    if db.enable ~= true and group == "raidpet"then 
      UnregisterStateDriver(MOD[group], "visibility")
      MOD[group]:Hide()
      return 
    end 
  else 
    MOD[group].db = db;
    MOD[group].Update = function()
      local db = MOD.db[group]
      if db.enable ~= true then 
        UnregisterAttributeDriver(MOD[group], "state-visibility")
        MOD[group]:Hide()
        return 
      end;
      MOD["RefreshHeader_"..GetUnitFrameActualName(group)](MOD, MOD[group], db)
      for i = 1, MOD[group]:GetNumChildren()do 
        local childFrame = select(i, MOD[group]:GetChildren())
        MOD["RefreshFrame_"..GetUnitFrameActualName(group)](MOD, childFrame, MOD.db[group])
        if _G[childFrame:GetName().."Target"]then 
          MOD["RefreshFrame_"..GetUnitFrameActualName(group)](MOD, _G[childFrame:GetName().."Target"], MOD.db[group])
        end;
        if _G[childFrame:GetName().."Pet"]then 
          MOD["RefreshFrame_"..GetUnitFrameActualName(group)](MOD, _G[childFrame:GetName().."Pet"], MOD.db[group])
        end 
      end 
    end;
    if forceUpdate then 
      MOD["RefreshHeader_"..GetUnitFrameActualName(group)](MOD, MOD[group], db)
    else 
      MOD[group].Update()
    end 
  end 
end;

function MOD:FrameForge()
	if InCombatLockdown() then 
		MOD:RegisterEvent("PLAYER_REGEN_ENABLED")
		return 
	end
	if MOD["BasicFrameLoadList"]  ~= nil then
		for i, frame in pairs(MOD["BasicFrameLoadList"]) do
			MOD:SetBasicFrame(frame)
		end;
		MOD["BasicFrameLoadList"] = nil;
	end
	if MOD["ExtraFrameLoadList"]  ~= nil then
		for clusterName, clusterCount in pairs(MOD["ExtraFrameLoadList"])do 
			MOD:SetExtraFrame(clusterName, clusterCount)
		end;
		MOD["ExtraFrameLoadList"] = nil;
	end
	if MOD["GroupFrameLoadList"]  ~= nil then
		for group, config in pairs(MOD["GroupFrameLoadList"])do 
			local filter, template1, template2;
			if(type(config) == "table") then 
				filter, template1, template2 = unpack(config)
			end;
			MOD:SetGroupFrame(group, filter, template1, nil, template2)
		end;
		MOD["GroupFrameLoadList"] = nil;
	end
	MOD:UnProtect("FrameForge");
	MOD:Protect("RefreshUnitFrames");
end;

function MOD:KillBlizzardRaidFrames()
	CompactRaidFrameManager:MUNG()
	CompactRaidFrameContainer:MUNG()
	CompactUnitFrameProfiles:MUNG()
	local crfmTest = CompactRaidFrameManager_GetSetting("IsShown")
	if crfmTest and crfmTest ~= "0" then 
		CompactRaidFrameManager_SetSetting("IsShown","0")
	end
end;

function oUF_SuperVillain:DisableBlizzard(unit)
	if (not unit) or InCombatLockdown() then return end
	if (unit == "player") then
		KillBlizzardUnit(PlayerFrame)
		PlayerFrame:RegisterUnitEvent("UNIT_ENTERING_VEHICLE", "player")
		PlayerFrame:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player")
		PlayerFrame:RegisterUnitEvent("UNIT_EXITING_VEHICLE", "player")
		PlayerFrame:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player")
		PlayerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
		PlayerFrame:SetUserPlaced(true)
		PlayerFrame:SetDontSavePosition(true)
		RuneFrame:SetParent(PlayerFrame)
	elseif(unit == "pet") then
		KillBlizzardUnit(PetFrame)
	elseif(unit == "target") then
		KillBlizzardUnit(TargetFrame)
		KillBlizzardUnit(ComboFrame)
	elseif(unit == "focus") then
		KillBlizzardUnit(FocusFrame)
		KillBlizzardUnit(TargetofFocusFrame)
	elseif(unit == "targettarget") then
		KillBlizzardUnit(TargetFrameToT)
	elseif(unit:match"(boss)%d?$" == "boss") then
	local id = unit:match"boss(%d)"
		if(id) then
			KillBlizzardUnit("Boss"..id.."TargetFrame")
		else
			for i = 1, 4 do
				KillBlizzardUnit(("Boss%dTargetFrame"):format(i))
			end
		end
	elseif(unit:match"(party)%d?$" == "party") then
		local id = unit:match"party(%d)"
		if(id) then
			KillBlizzardUnit("PartyMemberFrame"..id)
		else
			for i = 1, 4 do
				KillBlizzardUnit(("PartyMemberFrame%d"):format(i))
			end
		end
	elseif(unit:match"(arena)%d?$" == "arena") then
		local id = unit:match"arena(%d)"
		if(id) then
			KillBlizzardUnit("ArenaEnemyFrame"..id)
			KillBlizzardUnit("ArenaPrepFrame"..id)
			KillBlizzardUnit("ArenaEnemyFrame"..id.."PetFrame")
		else
			for i = 1, 5 do
				KillBlizzardUnit(("ArenaEnemyFrame%d"):format(i))
				KillBlizzardUnit(("ArenaPrepFrame%d"):format(i))
				KillBlizzardUnit(("ArenaEnemyFrame%dPetFrame"):format(i))
			end
		end
	end
end;

function MOD:ADDON_LOADED(_,addon)
	if addon ~= 'Blizzard_ArenaUI' then return end;
	oUF_SuperVillain:DisableBlizzard('arena')
	self:UnregisterEvent("ADDON_LOADED")
end;

function MOD:PLAYER_ENTERING_WORLD()
	self:RefreshUnitFrames()
	-- if self.db.healglow then
	-- 	self:InitHealGlow()
	-- end
	if SuperVillain.class == 'WARLOCK' then
		self:QualifyWarlockShards()
	end
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end;

function MOD:GROUP_ROSTER_UPDATE()
	MOD:KillBlizzardRaidFrames()
	-- if self.db.healglow then
	-- 	self:UpdateGlowRoster()
	-- end
end;

function MOD:PLAYER_REGEN_ENABLED()
	self:FrameForge()
	self:UnregisterEvent('PLAYER_REGEN_ENABLED')
end;

function MOD:UnitFrameThreatIndicator_Initialize(_,obj)
	obj:UnregisterAllEvents()
end;
--[[ 
########################################################## 
BUILD FUNCTION / UPDATE
##########################################################
]]--
function MOD:UpdateThisPackage()
	self:RefreshUnitFrames()
end;

function MOD:ConstructThisPackage()
	self:RefreshUnitColors()
	local SVUI_Parent = CreateFrame("Frame", "SVUI_Parent", SuperVillain.UIParent, "SecureHandlerStateTemplate")
	RegisterStateDriver(SVUI_Parent, "visibility", "[petbattle] hide; show")
	oUF_SuperVillain:RegisterStyle("oUF_SuperVillain", function(frame, name)
		frame:SetScript("OnEnter", UnitFrame_OnEnter)
		frame:SetScript("OnLeave", UnitFrame_OnLeave)
		frame:SetFrameLevel(2)
		RegistrationProxy(frame, name)
	end)
	self:Protect("FrameForge", true);
	self:SetFadeManager();
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	--self:RegisterEvent("PLAYER_REGEN_DISABLED")
	if SuperVillain.protected.SVUnit.disableBlizzard then 
		self:Protect("KillBlizzardRaidFrames", true);
		hooksecurefunc("CompactUnitFrame_RegisterEvents", CompactUnitFrame_UnregisterEvents)
		self:SecureHook("UnitFrameThreatIndicator_Initialize")
		InterfaceOptionsFrameCategoriesButton10:SetScale(0.0001)
		InterfaceOptionsFrameCategoriesButton11:SetScale(0.0001)
		InterfaceOptionsStatusTextPanelPlayer:SetScale(0.0001)
		InterfaceOptionsStatusTextPanelTarget:SetScale(0.0001)
		InterfaceOptionsStatusTextPanelParty:SetScale(0.0001)
		InterfaceOptionsStatusTextPanelPet:SetScale(0.0001)
		InterfaceOptionsStatusTextPanelPlayer:SetAlpha(0)
		InterfaceOptionsStatusTextPanelTarget:SetAlpha(0)
		InterfaceOptionsStatusTextPanelParty:SetAlpha(0)
		InterfaceOptionsStatusTextPanelPet:SetAlpha(0)
		InterfaceOptionsCombatPanelEnemyCastBarsOnPortrait:SetAlpha(0)
		InterfaceOptionsCombatPanelEnemyCastBarsOnPortrait:EnableMouse(false)
		InterfaceOptionsCombatPanelTargetOfTarget:SetScale(0.0001)
		InterfaceOptionsCombatPanelTargetOfTarget:SetAlpha(0)
		InterfaceOptionsCombatPanelEnemyCastBarsOnNameplates:ClearAllPoints()
		InterfaceOptionsCombatPanelEnemyCastBarsOnNameplates:SetPoint(InterfaceOptionsCombatPanelEnemyCastBarsOnPortrait:GetPoint())
		InterfaceOptionsDisplayPanelShowAggroPercentage:SetScale(0.0001)
		InterfaceOptionsDisplayPanelShowAggroPercentage:SetAlpha(0)
		if not IsAddOnLoaded("Blizzard_ArenaUI") then 
			self:RegisterEvent("ADDON_LOADED")
		else 
			oUF_SuperVillain:DisableBlizzard("arena")
		end;
		UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE")
		self:RegisterEvent("GROUP_ROSTER_UPDATE")
	else 
		CompactUnitFrameProfiles:RegisterEvent("VARIABLES_LOADED")
	end;
	local rDebuffs = ns.oUF_RaidDebuffs or oUF_RaidDebuffs;
	if not rDebuffs then return end;
	rDebuffs.ShowDispelableDebuff = true;
	rDebuffs.FilterDispellableDebuff = true;
	rDebuffs.MatchBySpellName = true;
end;
SuperVillain.Registry:NewPackage(MOD:GetName(),"pre");
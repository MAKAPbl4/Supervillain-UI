if select(2, UnitClass('player')) ~= "MONK" then return end

local parent, ns = ...
local oUF = ns.oUF
local floor = math.floor;
local DM_L = {};

if GetLocale() == "enUS" then
	DM_L["Stagger"] = "Stagger"
	DM_L["Light Stagger"] = "Light Stagger"
	DM_L["Moderate Stagger"] = "Moderate Stagger"
	DM_L["Heavy Stagger"] = "Heavy Stagger"

elseif GetLocale() == "frFR" then
	DM_L["Stagger"] = "Report"
	DM_L["Light Stagger"] = "Report mineur"
	DM_L["Moderate Stagger"] = "Report mod??"
	DM_L["Heavy Stagger"] = "Report majeur"

elseif GetLocale() == "itIT" then
	DM_L["Stagger"] = "Noncuranza"
	DM_L["Light Stagger"] = "Noncuranza Parziale"
	DM_L["Moderate Stagger"] = "Noncuranza Moderata"
	DM_L["Heavy Stagger"] = "Noncuranza Totale"

elseif GetLocale() == "deDE" then
	DM_L["Stagger"] = "Staffelung"
	DM_L["Light Stagger"] = "Leichte Staffelung"
	DM_L["Moderate Stagger"] = "Moderate Staffelung"
	DM_L["Heavy Stagger"] = "Schwere Staffelung"

elseif GetLocale() == "zhCN" then
	DM_L["Stagger"] = "醉拳"
	DM_L["Light Stagger"] = "轻度醉拳"
	DM_L["Moderate Stagger"] = "中度醉拳"
	DM_L["Heavy Stagger"] = "重度醉拳"

elseif GetLocale() == "ruRU" then
	DM_L["Stagger"] = "Пошатывание"
	DM_L["Light Stagger"] = "Легкое пошатывание"
	DM_L["Moderate Stagger"] = "Умеренное пошатывание"
	DM_L["Heavy Stagger"] = "Сильное пошатывание"

else
	DM_L["Stagger"] = "Stagger"
	DM_L["Light Stagger"] = "Light Stagger"
	DM_L["Moderate Stagger"] = "Moderate Stagger"
	DM_L["Heavy Stagger"] = "Heavy Stagger"
end	

local STANCE_OF_THE_STURY_OX_ID = 23

local UnitHealthMax = UnitHealthMax
local UnitStagger = UnitStagger
local BREW_COLORS = {
	[124275] = {0, 1, 0, 1}, -- Light
	[124274] = {1, 0.5, 0, 1}, -- Moderate
	[124273] = {1, 0, 0, 1}, -- Heavy
};
local STAGGER_COLORS = {
	[124275] = {0.2, 0.8, 0.2, 1}, -- Light
	[124274] = {1.0, 0.8, 0.2, 1}, -- Moderate
	[124273] = {1.0, 0.4, 0.2, 1}, -- Heavy
};
local staggerColor = {1, 1, 1, 0.5};
local brewColor = {0.91, 0.75, 0.25, 0.5};

local function ScanForDrunkenMaster()
	local name, _, icon, _, _, duration, _, _, _, _, spellID, _, _, value2, value1 = UnitAura("player", DM_L["Light Stagger"], "", "HARMFUL")
	if (not name) then 
		name, _, icon, _, _, duration, _, _, _, _, spellID, _, _, value2, value1 = UnitAura("player", DM_L["Moderate Stagger"], "", "HARMFUL")
		if (not name) then 
			name, _, icon, _, _, duration, _, _, _, _, spellID, _, _, value2, value1 = UnitAura("player", DM_L["Heavy Stagger"], "", "HARMFUL")
		end
	end
	if (spellID) then 
		staggerColor = STAGGER_COLORS[spellID]
		brewColor = STAGGER_COLORS[spellID]
	else
		staggerColor = {1, 1, 1, 0.5}
		brewColor = {0.91, 0.75, 0.25, 0.5}
	end
	if(value1 and (value1 > 0) and duration) then
		return (value1 * floor(duration))
	else
		return 0
	end
end

local Update = function(self, event, unit)
	if unit and unit ~= self.unit then return; end
	local staggerTotal = ScanForDrunkenMaster()

	local stagger = self.DrunkenMaster

	if(stagger.PreUpdate) then
		stagger:PreUpdate()
	end

	local maxHealth = UnitHealthMax("player")
	local staggerPercent = staggerTotal / maxHealth
	local currentStagger = floor(staggerPercent * 100)

	stagger:SetMinMaxValues(0, 50)
	stagger:SetStatusBarColor(unpack(brewColor))
	if currentStagger <= 50 then 
		stagger:SetValue(currentStagger) 
	else 
		stagger:SetValue(50) 
	end

	local icon = stagger.icon
	if(icon) then
		icon:SetVertexColor(unpack(staggerColor))
	end
	
	if(stagger.PostUpdate) then
		stagger:PostUpdate(maxHealth, currentStagger, staggerPercent)
	end
end

local Visibility = function(self, event, unit)
	if(STANCE_OF_THE_STURY_OX_ID ~= GetShapeshiftFormID() or UnitHasVehiclePlayerFrameUI("player")) then
		if self.DrunkenMaster:IsShown() then
			self.DrunkenMaster:Hide()
			self:UnregisterEvent('UNIT_AURA', Update)
		end
	else
		self.DrunkenMaster:Show()
		self:RegisterEvent('UNIT_AURA', Update)
		return Update(self, event, unit)
	end
end

local Path = function(self, ...)
	return (self.DrunkenMaster.Override or Visibility)(self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.unit)
end

local function Enable(self, unit)
	if(unit ~= 'player') then return end
	local element = self.DrunkenMaster
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_DISPLAYPOWER', Path)
		self:RegisterEvent('UPDATE_SHAPESHIFT_FORM', Path)

		if(element:IsObjectType'StatusBar' and not element:GetStatusBarTexture()) then
			element:SetStatusBarTexture(0.91, 0.75, 0.25)
		end

		MonkStaggerBar.Hide = MonkStaggerBar.Show
		MonkStaggerBar:UnregisterEvent'PLAYER_ENTERING_WORLD'
		MonkStaggerBar:UnregisterEvent'PLAYER_SPECIALIZATION_CHANGED'
		MonkStaggerBar:UnregisterEvent'UNIT_DISPLAYPOWER'
		MonkStaggerBar:UnregisterEvent'UPDATE_VEHICLE_ACTION_BAR'
		return true
	end
end

local function Disable(self)
	local element = self.DrunkenMaster
	if(element) then
		element:Hide()
		self:UnregisterEvent('UNIT_AURA', Update)
		self:UnregisterEvent('UNIT_DISPLAYPOWER', Path)
		self:UnregisterEvent('UPDATE_SHAPESHIFT_FORM', Path)

		MonkStaggerBar.Show = nil
		MonkStaggerBar:Show()
		MonkStaggerBar:UnregisterEvent'PLAYER_ENTERING_WORLD'
		MonkStaggerBar:UnregisterEvent'PLAYER_SPECIALIZATION_CHANGED'
		MonkStaggerBar:UnregisterEvent'UNIT_DISPLAYPOWER'
		MonkStaggerBar:UnregisterEvent'UPDATE_VEHICLE_ACTION_BAR'
	end
end

oUF:AddElement("DrunkenMaster", Path, Enable, Disable)
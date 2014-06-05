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
local ipairs    = _G.ipairs;
local type      = _G.type;
local error     = _G.error;
local pcall     = _G.pcall;
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local math 		= _G.math;
--[[ MATH METHODS ]]--
local random = math.random;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, _ = unpack(select(2, ...));
local MOD = SuperVillain:GetModule('SVUnit');
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.")
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local shardColor = {
	[1] = {0.6,0,1},
	[2] = {1,0,0},
	[3] = {1,0.5,0}
}
local shardUnderColor = {
	[1] = {0.4,0.1,1},
	[2] = {0,0,0},
	[3] = {0.5,0.5,0.5}
}
local shardOverColor = {
	[1] = {0.87,0.42,0.93},
	[2] = {0,0,0},
	[3] = {1,1,0}
}
local shardBGColor = {
	[1] = {0,0,0,0.9},
	[2] = {0,0,0},
	[3] = {0.1,0,0}
}
local SPEC_WARLOCK_DESTRUCTION = SPEC_WARLOCK_DESTRUCTION
local SPEC_WARLOCK_AFFLICTION = SPEC_WARLOCK_AFFLICTION
local SPEC_WARLOCK_DEMONOLOGY = SPEC_WARLOCK_DEMONOLOGY
--[[ 
########################################################## 
POSITIONING
##########################################################
]]--
local Reposition = function(self)
	local bar = self.WarlockShards;
	local max = self.MaxClassPower;
	local height = self.db.classbar.height
	local size = (height - 4)
	local width = (size + 2) * max;
	local dbOffset = (height * 0.15)
	bar:ClearAllPoints()
	bar:Size(width, height)
	if(self.db and self.db.classbar.slideLeft and (not self.db.power.text_format or self.db.power.text_format == '')) then
		bar:Point("TOPLEFT", self.InfoPanel, "TOPLEFT", 0, -2)
	else
		bar:Point("TOP", self.InfoPanel, "TOP", 0, -2)
	end

	bar.DemonBar:ClearAllPoints()
	bar.DemonBar:Size(width, (height * 1.25))
	bar.DemonBar:SetPoint("LEFT", bar, "LEFT", 4, dbOffset) 
	for i = 1, max do 
		bar[i]:ClearAllPoints()
		bar[i]:SetHeight(size)
		bar[i]:SetWidth(size)
		if(i == 1) then 
			bar[i]:SetPoint("LEFT", bar)
		else 
			bar[i]:Point("LEFT", bar[i - 1], "RIGHT", -2, 0)
		end 
	end
end;
--[[ 
########################################################## 
CUSTOM HANDLERS
##########################################################
]]--
local UpdateTextures = function(bar, spec, max)
	if max == 0 then max = 4 end
	if spec == SPEC_WARLOCK_DEMONOLOGY then
		bar[1].overlay:SetTexture(0,0,0,0)
		bar[1].underlay:SetTexture(0,0,0,0)
		SuperVillain.Animate:StopFlash(bar[1].overlay)
		bar[1].underlay.anim:Finish()

		bar[2].overlay:SetTexture(0,0,0,0)
		bar[2].underlay:SetTexture(0,0,0,0)
		SuperVillain.Animate:StopFlash(bar[2].overlay)
		bar[2].underlay.anim:Finish()

		bar[3].overlay:SetTexture(0,0,0,0)
		bar[3].underlay:SetTexture(0,0,0,0)
		SuperVillain.Animate:StopFlash(bar[3].overlay)
		bar[3].underlay.anim:Finish()

		bar[4].overlay:SetTexture(0,0,0,0)
		bar[4].underlay:SetTexture(0,0,0,0)
		SuperVillain.Animate:StopFlash(bar[4].overlay)
		bar[4].underlay.anim:Finish()
		bar.CurrentSpec = spec
	elseif spec == SPEC_WARLOCK_AFFLICTION then
		for i = 1, max do
			bar[i]:SetStatusBarTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Class\\SHARD")
			bar[i]:GetStatusBarTexture():SetHorizTile(false)
			bar[i].backdrop:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Class\\SHARD-BG")
			bar[i].overlay:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Class\\SHARD-FG")
			bar[i].underlay:SetTexture('Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Class\\SOUL-ANIM')
			bar[i].backdrop:SetVertexColor(unpack(shardBGColor[spec]))
			bar[i].overlay:SetVertexColor(unpack(shardOverColor[spec]))
			bar[i].underlay:SetVertexColor(unpack(shardUnderColor[spec]))
		end
		bar.CurrentSpec = spec
	elseif spec == SPEC_WARLOCK_DESTRUCTION then
		for i = 1, max do
			bar[i]:SetStatusBarTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Class\\EMBER"..i)
			bar[i]:GetStatusBarTexture():SetHorizTile(false)
			bar[i].backdrop:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Class\\EMBER"..i)
			bar[i].overlay:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Class\\EMBER"..i.."-FG")
			bar[i].underlay:SetTexture('Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Class\\EMBER-ANIM')
			if GetSpecialization() == SPEC_WARLOCK_DESTRUCTION and IsSpellKnown(101508) then -- GREEN FIRE (Codex of Xeroth): 101508
				bar[i].backdrop:SetVertexColor(0,0.15,0)
				bar[i].overlay:SetVertexColor(0.5,1,0)
				bar[i].underlay:SetVertexColor(0,1,0.2,0.8)
			else
				bar[i].backdrop:SetVertexColor(unpack(shardBGColor[spec]))
				bar[i].overlay:SetVertexColor(unpack(shardOverColor[spec]))
				bar[i].underlay:SetVertexColor(unpack(shardUnderColor[spec]))
			end
		end
		bar.CurrentSpec = spec
	end
end;

local Update = function(self, event, unit, powerType)
	local bar = self.WarlockShards;
	local fury = bar.DemonBar;
	if UnitHasVehicleUI("player") then
		bar:Hide()
	else
		bar:Show()
	end
	local spec = GetSpecialization()
	if spec then
		if not bar:IsShown() then 
			bar:Show()
		end
		if not fury:IsShown() then 
			fury:Show()
		end
		for i = 1, 4 do
			bar[i]:Show()
			bar[i]:SetStatusBarColor(unpack(shardColor[spec]))
		end
		if (spec == SPEC_WARLOCK_DESTRUCTION) then
			fury:Hide()
			local maxPower = UnitPowerMax("player", SPELL_POWER_BURNING_EMBERS, true)
			local power = UnitPower("player", SPELL_POWER_BURNING_EMBERS, true)
			local numEmbers = power / MAX_POWER_PER_EMBER
			local numBars = floor(maxPower / MAX_POWER_PER_EMBER)
			bar.number = numBars
			if numBars == 3 then
				bar[4]:Hide()
			else
				bar[4]:Show()
			end
			if bar.CurrentSpec ~= spec then
				UpdateTextures(bar, spec, numBars)
			end
			for i = 1, numBars do
				bar[i]:SetMinMaxValues((MAX_POWER_PER_EMBER * i) - MAX_POWER_PER_EMBER, MAX_POWER_PER_EMBER * i)
				bar[i]:SetValue(power)
				if (power >= MAX_POWER_PER_EMBER * i) then
					bar[i].overlay:Show()
					bar[i].underlay:Show()
					SuperVillain.Animate:Flash(bar[i].overlay,1,true)
					if not bar[i].underlay.anim:IsPlaying() then bar[i].underlay.anim:Play() end
				else
					SuperVillain.Animate:StopFlash(bar[i].overlay)
					bar[i].overlay:Hide()
					bar[i].underlay.anim:Stop()
					bar[i].underlay:Hide()
				end
			end
		elseif ( spec == SPEC_WARLOCK_AFFLICTION ) then
			fury:Hide()
			local numShards = UnitPower("player", SPELL_POWER_SOUL_SHARDS)
			local maxShards = UnitPowerMax("player", SPELL_POWER_SOUL_SHARDS)
			bar.number = maxShards
			if maxShards == 3 then
				bar[4]:Hide()
			else
				bar[4]:Show()
			end
			if bar.CurrentSpec ~= spec then
				UpdateTextures(bar, spec, maxShards)
			end
			for i = 1, maxShards do
				bar[i]:SetMinMaxValues(0, 1)
				if i <= numShards then
					bar[i]:SetValue(1)
					bar[i]:SetAlpha(1)
					bar[i].overlay:Show()
					bar[i].underlay:Show()
					SuperVillain.Animate:Flash(bar[i].overlay,1,true)
					if not bar[i].underlay.anim:IsPlaying() then bar[i].underlay.anim:Play() end
				else
					bar[i]:SetValue(0)
					bar[i]:SetAlpha(0)
					SuperVillain.Animate:StopFlash(bar[i].overlay)
				end
			end
		elseif spec == SPEC_WARLOCK_DEMONOLOGY then
			fury:SetStatusBarColor(unpack(shardColor[spec]))
			local power = UnitPower("player", SPELL_POWER_DEMONIC_FURY)
			local maxPower = UnitPowerMax("player", SPELL_POWER_DEMONIC_FURY)
			bar.number = 1
			if bar.CurrentSpec ~= spec then
				UpdateTextures(bar, spec, 1)
			end
			bar[1]:Hide()
			bar[2]:Hide()
			bar[3]:Hide()
			bar[4]:Hide()
			fury:SetMinMaxValues(0, maxPower)
			fury:SetValue(power)
		end
	else
		if bar:IsShown() then 
			bar:Hide()
		end
	end
	if(bar.PostUpdate) then
		return bar:PostUpdate(unit, spec)
	end
end;
--[[ 
########################################################## 
WARLOCK
##########################################################
]]--
function MOD:CreateWarlockResourceBar(playerFrame)
	local max = 4
	local bar = CreateFrame("Frame",nil,playerFrame)
	bar:SetFrameLevel(playerFrame.InfoPanel:GetFrameLevel() + 30)
	for i = 1, max do 
		bar[i]=CreateFrame("StatusBar", nil, bar)
		bar[i].noupdate = true;
		bar[i]:SetOrientation("VERTICAL")
		bar[i]:SetStatusBarTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Class\\SHARD")
		bar[i]:GetStatusBarTexture():SetHorizTile(false)

		bar[i].backdrop = bar[i]:CreateTexture(nil,'BORDER',nil,1)
		bar[i].backdrop:SetAllPoints(bar[i])
		bar[i].backdrop:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Class\\SHARD-BG")

		bar[i].overlay = bar[i]:CreateTexture(nil,'OVERLAY')
		bar[i].overlay:SetAllPoints(bar[i])
		bar[i].overlay:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Class\\SHARD-FG")
		bar[i].overlay:SetBlendMode("BLEND")
		bar[i].overlay:Hide()

		bar[i].underlay = bar[i]:CreateTexture(nil,'BORDER')
		bar[i].underlay:Height(100)
		bar[i].underlay:Width(100)
		bar[i].underlay:SetPoint("CENTER",bar[i])
		bar[i].underlay:SetTexture('Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Class\\SOUL-ANIM')
		bar[i].underlay:SetBlendMode('ADD')
		bar[i].underlay:Hide()
		SuperVillain.Animate:Sprite(bar[i].underlay,0.15,false,true)

		bar[i].backdrop:SetVertexColor(unpack(shardBGColor[1]))
		bar[i].overlay:SetVertexColor(unpack(shardOverColor[1]))
		bar[i].underlay:SetVertexColor(unpack(shardUnderColor[1]))
	end;

	local demonBar = CreateFrame("StatusBar",nil,bar)
	demonBar.noupdate = true;
	demonBar:SetOrientation("HORIZONTAL")
	demonBar:SetStatusBarTexture(SuperVillain.Textures.lazer)

	local bgFrame = CreateFrame("Frame", nil, demonBar)
	bgFrame:FillInner(demonBar, -2, 10)
	bgFrame:SetFrameLevel(bgFrame:GetFrameLevel() - 1)

	demonBar.bg = bgFrame:CreateTexture(nil, "BACKGROUND")
	demonBar.bg:SetAllPoints(bgFrame)
	demonBar.bg:SetTexture(0.2,0,0,0.5)

	local borderB = bgFrame:CreateTexture(nil,"OVERLAY")
    borderB:SetTexture(0,0,0)
    borderB:SetPoint("BOTTOMLEFT")
    borderB:SetPoint("BOTTOMRIGHT")
    borderB:SetHeight(2)

    local borderT = bgFrame:CreateTexture(nil,"OVERLAY")
    borderT:SetTexture(0,0,0)
    borderT:SetPoint("TOPLEFT")
    borderT:SetPoint("TOPRIGHT")
    borderT:SetHeight(2)

    local borderL = bgFrame:CreateTexture(nil,"OVERLAY")
    borderL:SetTexture(0,0,0)
    borderL:SetPoint("TOPLEFT")
    borderL:SetPoint("BOTTOMLEFT")
    borderL:SetWidth(2)

    local borderR = bgFrame:CreateTexture(nil,"OVERLAY")
    borderR:SetTexture(0,0,0)
    borderR:SetPoint("TOPRIGHT")
    borderR:SetPoint("BOTTOMRIGHT")
    borderR:SetWidth(2)

	bar.DemonBar = demonBar;

	bar.CurrentSpec = 0;
	bar.Override = Update;

	playerFrame.MaxClassPower = max;
	playerFrame.ClassBarRefresh = Reposition;
	bar.Override = Update;

	return bar 
end;

function MOD:QualifyWarlockShards()
	local frame = _G['SVUI_Player'];
	if not frame or not frame.WarlockShards then return end;
	Update(frame, nil, 'player');
end
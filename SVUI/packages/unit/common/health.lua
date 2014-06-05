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
local assert 	= _G.assert;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, G = unpack(select(2, ...));
local MOD = SuperVillain:GetModule('SVUnit');
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.");
local LSM = LibStub("LibSharedMedia-3.0");
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local DEAD_MODEL_FILE = [[Spells\Monk_travelingmist_missile.m2]];
function updateFrequentUpdates(self)
	local health = self.Health
	if health.frequentUpdates and not self:IsEventRegistered("UNIT_HEALTH_FREQUENT") then
		if GetCVarBool("predictedHealth") ~= 1 then
			SetCVar("predictedHealth", 1)
		end

		self:RegisterEvent('UNIT_HEALTH_FREQUENT', Path)

		if self:IsEventRegistered("UNIT_HEALTH") then
			self:UnregisterEvent("UNIT_HEALTH", Path)
		end
	elseif not self:IsEventRegistered("UNIT_HEALTH") then
		self:RegisterEvent('UNIT_HEALTH', Path)

		if self:IsEventRegistered("UNIT_HEALTH_FREQUENT") then
			self:UnregisterEvent("UNIT_HEALTH_FREQUENT", Path)
		end		
	end
end

local CustomUpdate = function(self, event, unit)
	if(self.unit ~= unit) or not unit then return end
	local health = self.Health

	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	local disconnected = not UnitIsConnected(unit)
	local invisible = ((min == max) or UnitIsDeadOrGhost(unit) or disconnected);
	
	if health.fillInverted then
		health:SetReverseFill(true)
	end

	health:SetMinMaxValues(-max, 0)
	health:SetValue(-min)
	health.disconnected = disconnected

	if health.frequentUpdates ~= health.__frequentUpdates then
		health.__frequentUpdates = health.frequentUpdates
		updateFrequentUpdates(self)
	end

	local bg = health.bg;
	local mu = (min / max);

	if(invisible or not health.overlayAnimation) then
		SuperVillain.Animate:StopFlash(health.animation[1])
		SuperVillain.Animate:StopFlash(health.animation[2])
		health.animation[1]:SetAlpha(0)
		health.animation[2]:SetAlpha(0)
	end

	if(invisible) then
		health:SetStatusBarColor(0.6,0.4,1,0.4)
	elseif(health.colorOverlay) then
		local t = health.colors.health
		health:SetStatusBarColor(t[1], t[2], t[3], 0.9)
	else
		health:SetStatusBarColor(1, 0.75 * mu, 0, 0.9) 
	end

	if(bg) then 
		bg:SetVertexColor(0,0,0,0)
	end

	if(health.overlayAnimation and not invisible) then 
		if(mu <= 0.25) then
			SuperVillain.Animate:Flash(health.animation[1],0.75,true)
			SuperVillain.Animate:Flash(health.animation[2],0.25,true)
		else
			SuperVillain.Animate:StopFlash(health.animation[1])
			SuperVillain.Animate:StopFlash(health.animation[2])
			health.animation[1]:SetAlpha(0)
			health.animation[2]:SetAlpha(0)
		end
	end

	if self.ResurrectIcon then 
		self.ResurrectIcon:SetAlpha(min == 0 and 1 or 0)
	end;
	if self.isForced then 
		local current = random(1,max)
		health:SetValue(-current)
	end;

	local portrait = self.Portrait
	if(portrait and portrait:IsObjectType'Model') then
		if(UnitIsDeadOrGhost(unit) and not portrait.isdead) then
			portrait:SetCamDistanceScale(1)
			portrait:SetPortraitZoom(0)
			portrait:SetPosition(4,-1,1)
			portrait:ClearModel()
			portrait:SetModel(DEAD_MODEL_FILE)
			portrait.isdead = true
			portrait.guid = nil
		elseif(not UnitIsDeadOrGhost(unit) and portrait.isdead == true) then
			portrait.isdead = nil
			MOD.Update3DPortrait(self, event, unit)
		end
	end
end;

local Update = function(self, event, unit)
	if(self.unit ~= unit) or not unit then return end
	local health = self.Health
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	local disconnected = not UnitIsConnected(unit)
	if health.fillInverted then
		health:SetReverseFill(true)
	end
	health:SetMinMaxValues(0, max)

	if(disconnected) then
		health:SetValue(max)
	else
		health:SetValue(min)
	end

	health.disconnected = disconnected

	if health.frequentUpdates ~= health.__frequentUpdates then
		health.__frequentUpdates = health.frequentUpdates
		updateFrequentUpdates(self)
	end

	local bg = health.bg;
	local db = self:GetParent().db or SuperVillain.db.SVUnit;
	local r, g, b, t, t2;

	if(health.colorTapping and not UnitPlayerControlled(unit) and UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) and not UnitIsTappedByAllThreatList(unit)) then
		t = health.colors.tapped
	elseif(health.colorDisconnected and not UnitIsConnected(unit)) then
		t = health.colors.disconnected
	elseif(health.colorClass and UnitIsPlayer(unit)) or
		(health.colorClassNPC and not UnitIsPlayer(unit)) or
		(health.colorClassPet and UnitPlayerControlled(unit) and not UnitIsPlayer(unit)) then
		local _, class = UnitClass(unit)
		local tmp = oUF_SuperVillain.colors.class[class] or health.colors.health
		t = {(tmp[1] * 0.75),(tmp[2] * 0.75),(tmp[3] * 0.75)}
		if(bg and db.classbackdrop and UnitIsPlayer(unit)) then
			t2 = t
		end
	elseif(health.colorReaction and UnitReaction(unit, 'player')) then
		t = oUF_SuperVillain.colors.reaction[UnitReaction(unit, "player")]
		if(bg and db.classbackdrop and not UnitIsPlayer(unit) and UnitReaction(unit, "player")) then
			t2 = t
		end
	elseif(health.colorSmooth) then
		r, g, b = oUF_SuperVillain.ColorGradient(min, max, unpack(health.smoothGradient or oUF_SuperVillain.colors.smooth))
	elseif(health.colorHealth) then
		t = health.colors.health
	end

	if(t) then
		r, g, b = t[1], t[2], t[3]
	end

	if(b) then
		if(db.healthclass == true and db.colorhealthbyvalue == true or db.colorhealthbyvalue and self.isForced and not(UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit))) then 
			r, g, b = oUF_SuperVillain.ColorGradient(min,max,1,0,0,1,1,0,r,g,b)
		end
		health:SetStatusBarColor(r, g, b)
		if(bg) then 
			local mu = bg.multiplier or 1
			if(t2) then
				r, g, b = t2[1], t2[2], t2[3] 
			end
			bg:SetVertexColor(r * mu, g * mu, b * mu)
		end
	end

	if self.ResurrectIcon then 
		self.ResurrectIcon:SetAlpha(min == 0 and 1 or 0)
	end;
	if self.isForced then 
		min = random(1,max)
		health:SetValue(min)
	end;
	if self.db and self.db.gridMode then 
		health:SetOrientation("VERTICAL")
	end;

	local portrait = self.Portrait
	if(portrait and portrait:IsObjectType'Model') then
		if(UnitIsDeadOrGhost(unit) and not portrait.isdead) then
			portrait:SetCamDistanceScale(1)
			portrait:SetPortraitZoom(0)
			portrait:SetPosition(4,-1,1)
			portrait:ClearModel()
			portrait:SetModel(DEAD_MODEL_FILE)
			portrait.isdead = true
			portrait.guid = nil
		elseif(not UnitIsDeadOrGhost(unit) and portrait.isdead == true) then
			portrait.isdead = nil
			MOD.Update3DPortrait(self, event, unit)
		end
	end
end
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function MOD:CreateHealthBar(frame,hasbg,text,reverse)
	local healthBar=CreateFrame('StatusBar',nil,frame)
	healthBar:SetFrameStrata("LOW")
	healthBar:SetFrameLevel(4)
	healthBar.colors = {}
	MOD:SetUnitStatusbar(healthBar)
	if hasbg then 
		healthBar.bg=healthBar:CreateTexture(nil,'BORDER')
		healthBar.bg:SetAllPoints()
		healthBar.bg:SetTexture(SuperVillain.Textures.gradient)
		healthBar.bg:SetVertexColor(0.4,0.1,0.1)
		healthBar.bg.multiplier=0.25;
		hooksecurefunc(frame,"SetAlpha",function(this,value)if this.Health:IsShown()and this.Health.bg and value < 1 then this.Health.bg:SetAlpha(value * 0.25)end end)
	end;

	local flasher = CreateFrame('Frame',nil,frame)
	flasher:SetFrameLevel(3)
	flasher:SetAllPoints(healthBar)

	flasher[1] = flasher:CreateTexture(nil,"OVERLAY",nil,1)
	flasher[1]:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\UNIT-LOW-HEALTH-1")
	flasher[1]:SetVertexColor(0.75,0.1,0.1)
	flasher[1]:SetBlendMode('ADD')
	flasher[1]:SetAllPoints(flasher)

	flasher[2] = flasher:CreateTexture(nil,"OVERLAY",nil,2)
	flasher[2]:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\UNIT-LOW-HEALTH-2")
	flasher[2]:SetVertexColor(1,0,0)
	flasher[2]:SetBlendMode('ADD')
	flasher[2]:SetAllPoints(flasher)

	flasher[1]:SetAlpha(0)
	flasher[2]:SetAlpha(0)

	if text then 
		healthBar.value = healthBar:CreateFontString(nil,'OVERLAY')
		healthBar.value.db = 'health'
		MOD:SetUnitFont(healthBar.value)
		healthBar.value:SetParent(frame.InfoPanel)
		local offset = reverse and 2 or -2;
		local direction = reverse and "LEFT" or "RIGHT";
		healthBar.value:Point(direction, healthBar, direction, offset, 0)
	end;

	healthBar.animation = flasher
	healthBar.noupdate = false;
	healthBar.fillInverted = reverse;
	healthBar.colorTapping = true;
	healthBar.colorDisconnected=true
	healthBar.Override = Update;
	return healthBar 
end;

function MOD:RefreshHealthBar(frame)
	if(frame.db and frame.db.portrait) then
		local db = frame.db.portrait
		local useOverlayHealth = (db.enable and db.overlay);
		if useOverlayHealth then
			frame.Health:SetStatusBarTexture(SuperVillain.Textures.gradient)
			frame.Health.Override = CustomUpdate;
		else
			frame.Health:SetStatusBarTexture(LSM:Fetch("statusbar",MOD.db.statusbar))
			frame.Health.Override = Update;
		end
	end;
	MOD:UpdateHealPrediction(frame)
end
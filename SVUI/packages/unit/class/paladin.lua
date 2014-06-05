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

--[[ 
########################################################## 
POSITIONING
##########################################################
]]--
local Reposition = function(self)
	local bar = self.HolyPower;
	local max = self.MaxClassPower;
	local height = self.db.classbar.height
	local size = (height - 4)
	local width = (size + 2) * max;
	bar:ClearAllPoints()
	bar:Size(width, height)
	if(self.db and self.db.classbar.slideLeft and (not self.db.power.text_format or self.db.power.text_format == '')) then
		bar:Point("TOPLEFT", self.InfoPanel, "TOPLEFT", 0, -2)
	else
		bar:Point("TOP", self.InfoPanel, "TOP", 0, -2)
	end
	for i = 1, max do
		bar[i]:ClearAllPoints()
		bar[i]:SetHeight(size)
		bar[i]:SetWidth(size)
		bar[i]:GetStatusBarTexture():SetHorizTile(false)
		if i==1 then 
			bar[i]:SetPoint("LEFT", bar)
		else 
			bar[i]:Point("LEFT", bar[i - 1], "RIGHT", -1, 0) 
		end
	end 
end;

local Update = function(self, event, unit, powerType)
	if self.unit ~= unit or (powerType and powerType ~= 'HOLY_POWER') then return end;
	local bar = self.HolyPower;
	local baseCount = UnitPower('player',SPELL_POWER_HOLY_POWER)
	local maxCount = UnitPowerMax('player',SPELL_POWER_HOLY_POWER)
	for i=1,maxCount do 
		if i <= baseCount then 
			bar[i]:SetAlpha(1)
		else 
			bar[i]:SetAlpha(0)
		end;
		if i > maxCount then 
			bar[i]:Hide()
		else 
			bar[i]:Show()
		end 
	end
	self.MaxClassPower = maxCount
end;
--[[ 
########################################################## 
PALADIN
##########################################################
]]--
function MOD:CreatePaladinResourceBar(playerFrame)
	local max = 5
	local bar = CreateFrame("Frame", nil, playerFrame)
	bar:SetFrameLevel(playerFrame.InfoPanel:GetFrameLevel() + 30)

	for i = 1, max do 
		bar[i] = CreateFrame("StatusBar", nil, bar)
		bar[i]:SetStatusBarTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\HAMMER")
		bar[i]:GetStatusBarTexture():SetHorizTile(false)
		bar[i]:SetStatusBarColor(0.9,0.9,0.8)

		bar[i].backdrop = bar[i]:CreateTexture(nil,"BACKGROUND")
		bar[i].backdrop:SetAllPoints(bar[i])
		bar[i].backdrop:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\HAMMER")
		bar[i].backdrop:SetVertexColor(0,0,0)

		local barAnimation = CreateFrame('Frame',nil,bar[i])
		barAnimation:Size(40,40)
		barAnimation:SetPoint("CENTER",bar[i],"CENTER",0,0)
		local level = barAnimation:GetFrameLevel()
		if(level > 0) then 
			barAnimation:SetFrameLevel(level - 1)
		else 
			barAnimation:SetFrameLevel(0)
		end
		barAnimation[1] = barAnimation:CreateTexture(nil,"BACKGROUND",nil,1)
		barAnimation[1]:Size(40,40)
		barAnimation[1]:SetPoint("CENTER")
		barAnimation[1]:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\SWIRL")
		barAnimation[1]:SetBlendMode("ADD")
		barAnimation[1]:SetVertexColor(0.5,0.5,0.15)
		SuperVillain.Animate:Orbit(barAnimation[1],10)

		barAnimation[2] = barAnimation:CreateTexture(nil,"BACKGROUND",nil,2)
		barAnimation[2]:Size(40,40)
		barAnimation[2]:SetPoint("CENTER")
		barAnimation[2]:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\SWIRL")
		barAnimation[2]:SetTexCoord(1,0,1,1,0,0,0,1)
		barAnimation[2]:SetBlendMode("ADD")
		barAnimation[2]:SetVertexColor(0.5,0.5,0.15)
		SuperVillain.Animate:Orbit(barAnimation[2],10,true)

		bar[i].swirl = barAnimation;
		hooksecurefunc(bar[i], "SetAlpha", function(frame,value)
			if value < 1 then 
				frame.swirl[1].anim:Finish()
				frame.swirl[2].anim:Finish() 
			else 
				if(not frame.swirl[1].anim:IsPlaying()) then 
					frame.swirl[1].anim:Play()
				end;
				if(not frame.swirl[2].anim:IsPlaying()) then 
					frame.swirl[2].anim:Play()
				end 
			end 
		end)
	end;
	playerFrame.MaxClassPower = max;
	playerFrame.ClassBarRefresh = Reposition;
	bar.Override = Update;
	return bar 
end;
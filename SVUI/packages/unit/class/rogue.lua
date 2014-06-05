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
LOCALS
##########################################################
]]--
local cpointColor = {
	[1]={0.69,0.31,0.31},
	[2]={0.69,0.31,0.31},
	[3]={0.65,0.63,0.35},
	[4]={0.65,0.63,0.35},
	[5]={0.33,0.59,0.33}
};

local comboTextures = {
	[1] = [[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\SHURIKEN]],
	[2] = [[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\SHANK]],
	[3] = [[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\KNUCKLES]],
};
--[[ 
########################################################## 
POSITIONING
##########################################################
]]--
local Reposition = function(self)
	local bar = self.HyperCombo.CPoints;
	local max = MAX_COMBO_POINTS;
	local height = self.db.combobar.height
	local isSmall = self.db.combobar.smallIcons
	local size = isSmall and 22 or (height - 4)
	local width = (size + 4) * max;
	bar:ClearAllPoints()
	bar:Size(width, height)
	bar:Point("TOPLEFT", self.ActionPanel, "TOPLEFT", 2, (height * 0.25))
	for i = 1, max do
		bar[i]:ClearAllPoints()
		bar[i]:Size(size, size)
		bar[i].Icon:ClearAllPoints()
		bar[i].Icon:SetAllPoints(bar[i])
		if(bar[i].Blood) then
			bar[i].Blood:ClearAllPoints()
			bar[i].Blood:SetAllPoints(bar[i])
		end
		if i==1 then 
			bar[i]:SetPoint("LEFT", bar)
		else 
			bar[i]:Point("LEFT", bar[i - 1], "RIGHT", -2, 0) 
		end
	end 
end;
--[[ 
########################################################## 
ROGUE COMBO POINTS
##########################################################
]]--
local ShowPoint = function(self)
	self:SetAlpha(1)
end;

local HidePoint = function(self)
	self.Icon:SetTexture(comboTextures[random(1,3)])
	self:SetAlpha(0)
end;

local ShowSmallPoint = function(self)
	self:SetAlpha(1)
end;

local HideSmallPoint = function(self)
	self.Icon:SetVertexColor(unpack(cpointColor[i]))
	self:SetAlpha(0)
end;

function MOD:CreateRogueCombobar(targetFrame, isSmall)
	local max = 5
	local size = isSmall and 22 or 30
	local bar = CreateFrame("Frame",nil,targetFrame)
	bar:SetFrameStrata("DIALOG")
	bar.CPoints = CreateFrame("Frame",nil,bar)
	for i = 1, max do 
		local cpoint = CreateFrame('Frame',nil,bar.CPoints)
		cpoint:Size(size,size)

		local icon = cpoint:CreateTexture(nil,"OVERLAY",nil,1)
		icon:Size(size,size)
		icon:SetPoint("CENTER")
		icon:SetBlendMode("BLEND")

		if(not isSmall) then
			icon:SetTexture(comboTextures[random(1,3)])

			local blood = cpoint:CreateTexture(nil,"OVERLAY",nil,2)
			blood:Size(size,size)
			blood:SetPoint("BOTTOMRIGHT",cpoint,12,-12)
			blood:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Unitframe\Class\COMBO-ANIM]])
			blood:SetBlendMode("ADD")
			cpoint.Blood = blood
			
			SuperVillain.Animate:SmallSprite(blood,0.08,2,true)
		else
			icon:SetTexture([[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\COMBO-POINT-SMALL]])
		end
		cpoint.Icon = icon

		bar.CPoints[i] = cpoint 
	end;

	targetFrame.ComboRefresh = Reposition;
	bar.PointShow = isSmall and ShowSmallPoint or ShowPoint;
	bar.PointHide = isSmall and HideSmallPoint or HidePoint;

	return bar 
end;
--[[ 
########################################################## 
ROGUE COMBO TRACKER
##########################################################
]]--
local RepositionTracker = function(self)
	local bar = self.HyperCombo;
	if not self.db then return end
	local height = self.db.classbar.height
	local size = (height - 4)
	local width = (size + 2) * 3;
	local textwidth = height * 1.25;
	bar:ClearAllPoints()
	bar:Size(width, height)
	if(self.db and self.db.classbar.slideLeft and (not self.db.power.text_format or self.db.power.text_format == '')) then
		bar:Point("TOPLEFT", self.InfoPanel, "TOPLEFT", 0, -2)
	else
		bar:Point("TOP", self.InfoPanel, "TOP", 0, -2)
	end
	if(bar.Tracking) then
		bar.Tracking:ClearAllPoints()
		bar.Tracking:SetHeight(height)
		bar.Tracking:SetWidth(textwidth)
		bar.Tracking:SetPoint("LEFT", bar)
		bar.Tracking.Text:ClearAllPoints()
		bar.Tracking.Text:SetAllPoints(bar.Tracking)
		bar.Tracking.Text:SetFontTemplate([[Interface\AddOns\SVUI\assets\fonts\Combo.ttf]], size, 'OUTLINE')
	end
	if(bar.Anticipation) then
		bar.Anticipation:ClearAllPoints()
		bar.Anticipation:SetHeight(height)
		bar.Anticipation:SetWidth(textwidth)
		bar.Anticipation:SetPoint("LEFT", bar.Tracking, "RIGHT", -2, 0)
		bar.Anticipation.Text:ClearAllPoints()
		bar.Anticipation.Text:SetAllPoints(bar.Anticipation)
		bar.Anticipation.Text:SetFontTemplate([[Interface\AddOns\SVUI\assets\fonts\Combo.ttf]], size, 'OUTLINE')
	end
	if(bar.Guile) then
		bar.Guile:ClearAllPoints()
		bar.Guile:SetHeight(height)
		bar.Guile:SetWidth(textwidth)
		bar.Guile:SetPoint("LEFT", bar.Anticipation, "RIGHT", -2, 0)
		bar.Guile.Text:ClearAllPoints()
		bar.Guile.Text:SetAllPoints(bar.Guile)
		bar.Guile.Text:SetFontTemplate([[Interface\AddOns\SVUI\assets\fonts\Combo.ttf]], size, 'OUTLINE')
	end
end;

function MOD:CreateRoguePointTracker(playerFrame)
	local bar = CreateFrame("Frame",nil,playerFrame)
	bar:SetFrameStrata("DIALOG")
	bar:Size(150, 30)
	local points = CreateFrame('Frame',nil,bar)
	points:SetFrameStrata("DIALOG")
	points:Size(30,30)

	points.Text = points:CreateFontString(nil,'OVERLAY')
	points.Text:SetAllPoints(points)
	points.Text:SetFontTemplate([[Interface\AddOns\SVUI\assets\fonts\Combo.ttf]],30,'OUTLINE')
	points.Text:SetTextColor(1,1,1)

	bar.Tracking = points;

	local anticipation = CreateFrame('Frame',nil,bar)
	anticipation:SetFrameStrata("DIALOG")
	anticipation:Size(30,30)

	anticipation.Text = anticipation:CreateFontString(nil,'OVERLAY')
	anticipation.Text:SetAllPoints(anticipation)
	anticipation.Text:SetFontTemplate([[Interface\AddOns\SVUI\assets\fonts\Combo.ttf]],30,'OUTLINE')
	anticipation.Text:SetTextColor(1,1,1)

	bar.Anticipation = anticipation;

	local guile = CreateFrame('Frame',nil,bar)
	guile:SetFrameStrata("DIALOG")
	guile:Size(30,30)

	guile.Text = guile:CreateFontString(nil,'OVERLAY')
	guile.Text:SetAllPoints(guile)
	guile.Text:SetFontTemplate([[Interface\AddOns\SVUI\assets\fonts\Combo.ttf]],30,'OUTLINE')
	guile.Text:SetTextColor(1,1,1)

	bar.Guile = guile;

	playerFrame.MaxClassPower = 5;
	playerFrame.ClassBarRefresh = RepositionTracker;
	return bar 
end;
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
local munk = {
	[1] = {.57,.87,.35},
	[2] = {.47,.87,.35},
	[3] = {.37,.87,.35},
	[4] = {.27,.87,.33},
	[5] = {.17,.87,.33}
};
--[[ 
########################################################## 
POSITIONING
##########################################################
]]--
local Reposition = function(self)
	local bar = self.MonkHarmony;
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
		bar[i]:SetStatusBarColor(munk[i][1],munk[i][2],munk[i][3])
		if i==1 then 
			bar[i]:SetPoint("LEFT", bar)
		else 
			bar[i]:Point("LEFT", bar[i - 1], "RIGHT", -2, 0) 
		end
	end 
end;

local StartFlash = function(self) SuperVillain.Animate:Flash(self.overlay,1,true) end
local StopFlash = function(self) SuperVillain.Animate:StopFlash(self.overlay) end
--[[ 
########################################################## 
MONK STAGGER BAR
##########################################################
]]--
local function CreateDrunkenMasterBar(playerFrame)
	local stagger = CreateFrame("Statusbar",nil,playerFrame)
	stagger:SetSize(45,90)
	stagger:Point('BOTTOMLEFT', playerFrame, 'BOTTOMRIGHT', 6, 0)
	stagger:SetOrientation("VERTICAL")
	stagger:SetStatusBarTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\STAGGER-BAR")
	stagger:GetStatusBarTexture():SetHorizTile(false)
	stagger.backdrop = stagger:CreateTexture(nil,'BORDER',nil,1)
	stagger.backdrop:SetAllPoints(stagger)
	stagger.backdrop:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\STAGGER-BG")
	stagger.backdrop:SetVertexColor(1,1,1,0.6)
	stagger.overlay = stagger:CreateTexture(nil,'OVERLAY')
	stagger.overlay:SetAllPoints(stagger)
	stagger.overlay:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\STAGGER-FG")
	stagger.overlay:SetVertexColor(1,1,1)
	stagger.icon = stagger:CreateTexture(nil,'OVERLAY')
	stagger.icon:SetAllPoints(stagger)
	stagger.icon:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\STAGGER-ICON")
	stagger:Hide()
	return stagger 
end;
--[[ 
########################################################## 
MONK HARMONY
##########################################################
]]--
function MOD:CreateMonkResourceBar(playerFrame)
	local max = 5
	local bar = CreateFrame("Frame",nil,playerFrame)
	bar:SetFrameLevel(playerFrame.InfoPanel:GetFrameLevel() + 30)
	for i=1, max do 
		bar[i] = CreateFrame("StatusBar", nil, bar)
		bar[i]:SetStatusBarTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\ORB")
		bar[i]:GetStatusBarTexture():SetHorizTile(false)
		bar[i].noupdate = true;
		bar[i].backdrop = bar[i]:CreateTexture(nil, "BACKGROUND")
		bar[i].backdrop:SetAllPoints(bar[i])
		bar[i].backdrop:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\ORB-BG")
		bar[i].glow = bar[i]:CreateTexture(nil, "OVERLAY")
		bar[i].glow:SetAllPoints(bar[i])
		bar[i].glow:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\CHI"..i)
		bar[i].overlay = bar[i]:CreateTexture(nil, "OVERLAY", nil, 1)
		bar[i].overlay:SetAllPoints(bar[i])
		bar[i].overlay:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\CHI"..i)
		bar[i].overlay:SetVertexColor(0, 0, 0)
		bar[i]:SetScript("OnShow", StartFlash)
		bar[i]:SetScript("OnHide", StopFlash)
	end;

	playerFrame.MaxClassPower = max
	playerFrame.DrunkenMaster = CreateDrunkenMasterBar(playerFrame)
	playerFrame.ClassBarRefresh = Reposition

	return bar 
end;
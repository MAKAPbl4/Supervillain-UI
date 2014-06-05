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
local pairs 	= _G.pairs;
local tonumber	= _G.tonumber;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
--[[ STRING METHODS ]]--
local find, format, len, split = string.find, string.format, string.len, string.split;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, G = unpack(select(2, ...));
local MOD = SuperVillain:GetModule('SVOverride');
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local mirrorYOffset={
	["BREATH"] = 96,
	["EXHAUSTION"] = 119,
	["FEIGNDEATH"] = 142
}
local mirrorTypeColor={
	EXHAUSTION = {1,.9,0},
	BREATH = {0.31,0.45,0.63},
	DEATH = {1,.7,0},
	FEIGNDEATH = {1,.7,0}
}
local RegisteredMirrorBars={}
--[[ 
########################################################## 
PRE VARS/FUNCTIONS
##########################################################
]]--
local SetMirrorPosition = function(bar)
	local yOffset = mirrorYOffset[bar.type]
	return bar:Point("TOP", SuperVillain.UIParent, "TOP", 0, -yOffset)
end;

local MirrorBar_OnUpdate = function(self, elapsed)
	if self.paused then
		return 
	end;
	self.lastupdate = (self.lastupdate or 0) + elapsed;
	if self.lastupdate < .1 then
		return 
	end;
	self.lastupdate = 0;
	self:SetValue(GetMirrorTimerProgress(self.type) / 1e3)
end;

local MirrorBar_Start = function(self, min, max, s, t, text)
	if t > 0 then
		self.paused = 1 
	elseif self.paused then 
		self.paused = nil 
	end;
	self.text:SetText(text)
	self:SetMinMaxValues(0, max / 1e3)
	self:SetValue(min / 1e3)
	if not self:IsShown() then
		self:Show()
	end 
end;


local function MirrorBarRegistry(barType)
	if RegisteredMirrorBars[barType] then
		return RegisteredMirrorBars[barType]
	end;
	local bar = CreateFrame('StatusBar', nil, SuperVillain.UIParent)
	bar:SetFixedPanelTemplate("Inset")
	bar:SetScript("OnUpdate", MirrorBar_OnUpdate)
	local r, g, b = unpack(mirrorTypeColor[barType])
	local bg = bar:CreateTexture(nil, 'BACKGROUND')
	bg:SetAllPoints(bar)
	bg:SetTexture([[Interface\BUTTONS\WHITE8X8]])
	bg:SetVertexColor(r, g, b)
	bg:SetAlpha(0.2)
	local border = CreateFrame("Frame", nil, bar)
	border:WrapOuter()
	border:SetFixedPanelTemplate("Default")
	border:SetFrameLevel(0)
	bar.text = bar:CreateFontString(nil, 'OVERLAY')
	bar.text:SetFontTemplate(nil, nil, 'OUTLINE')
	bar.text:SetJustifyH('CENTER')
	bar.text:SetTextColor(1, 1, 1)
	bar.text:SetPoint('LEFT', bar)
	bar.text:SetPoint('RIGHT', bar)
	bar.text:Point('TOP', bar, 0, 2)
	bar.text:SetPoint('BOTTOM', bar)
	bar:Size(222, 18)
	bar:SetStatusBarTexture(SuperVillain.Textures.default)
	bar:SetStatusBarColor(r, g, b)
	bar.type = barType;
	bar.Start = MirrorBar_Start;
	bar.Stop = Stop;
	SetMirrorPosition(bar)
	RegisteredMirrorBars[barType] = bar;
	return bar 
end;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:MIRROR_TIMER_START(event,barType,min,max,s,t,text)
	return MirrorBarRegistry(barType):Start(min,max,s,t,text)
end;
function MOD:MIRROR_TIMER_STOP(event,barType)
	return MirrorBarRegistry(barType):Hide()
end;
function MOD:MIRROR_TIMER_PAUSE(event,paused)
	local pausedValue = (paused > 0 and paused or nil);
	for barType,bar in next,RegisteredMirrorBars do 
		bar.paused = pausedValue; 
	end 
end;
function MOD:PLAYER_ENTERING_WORLD()
	self:ForceCVars()
	for E = 1, MIRRORTIMER_NUMTIMERS do 
		local v, q, r, s, t, u = GetMirrorTimerInfo(E)
		if v ~= "UNKNOWN"then 
			MirrorBarRegistry(v):Start(q, r, s, t, u)
		end 
	end
end;

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
local math 		= _G.math;
--[[ MATH METHODS ]]--
local random = math.random;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, G = unpack(select(2, ...));
local Comix = CreateFrame("Frame");
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local animReady=true;
local playerGUID;
local SPRITEPATH=[[Interface\AddOns\SVUI\assets\artwork\Comics]];
local PREMIUM_OFFSETS={
    [1]={220, 210, 50, -50},
    [2]={230, 210, 50, 5},
    [3]={280, 160, 1, 50},
    [4]={220, 210, 50, -50},
    [5]={210, 190, 50, 50},
    [6]={220, 210, 50, -50},
    [7]={230, 210, 50, 5},
    [8]={280, 160, 1, 50},
    [9]={220, 210, 50, -50},
    [10]={210, 190, 50, 50},
    [11]={220, 210, 50, -50},
    [12]={230, 210, 50, 5},
    [13]={280, 160, 1, 50},
    [14]={220, 210, 50, -50},
    [15]={210, 190, 50, 50},
    [16]={210, 190, 50, 50},
}
local BG_OFFSETS={
    [1]={220, 210, -1, 5},
    [2]={280, 210, -5, 1},
    [3]={280, 210, -1, 5},
    [4]={220, 210, -1, 5},
    [5]={220, 210, -1, 5},
    [6]={220, 210, -1, 5},
    [7]={280, 210, -5, 1},
    [8]={280, 210, -1, 5},
    [9]={220, 210, -1, 5},
    [10]={220, 210, -1, 5},
    [11]={220, 210, -1, 5},
    [12]={280, 210, -5, 1},
    [13]={280, 210, -1, 5},
    [14]={220, 210, -1, 5},
    [15]={220, 210, -1, 5},
    [16]={220, 210, -1, 5},
}
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function Comix:ReadyState(state)
	if(state == nil) then return animReady end
	animReady = state
end;

function Comix:LaunchPopup(l)
	local m,n,p,q,r,s,t,u,v,w,x,y,z;
	if l=="BASIC"then 
		m=random(1,43)
		q=SPRITEPATH.."\\BASIC\\"..m
		s=random(-280,280)
		if s > -30 and s < 30 then s = 150 end;
		t=s*0.5;
		u=random(10,100)
		v=u*0.5;
		ComixBasicPanel.tex:SetTexture(q)
		ComixBasicPanel.anim[1]:SetOffset(s,u)
		ComixBasicPanel.anim[2]:SetOffset(t,v)
		ComixBasicPanel.anim[3]:SetOffset(0,0)
		ComixBasicPanel.anim:Play()
	elseif l=="TOASTY"then
		q=SPRITEPATH.."\\TOASTY\\1"
		ComixToastyPanelBG.tex:SetTexture(q)
		ComixToastyPanelBG:Show()
		ComixToastyPanelBG.anim:Play()
		PlaySoundFile([[Interface\AddOns\SVUI\assets\sounds\toasty.mp3]])
	else 
		m=random(1,16)
		q=SPRITEPATH.."\\PREMIUM\\"..m
		r=SPRITEPATH.."\\BG\\"..m
		o=PREMIUM_OFFSETS[m]
		p=BG_OFFSETS[m]
		s,t,u,v,w,x,y,z=o[1],o[3],o[2],o[4],p[1],p[3],p[2],p[4]
		ComixPremiumPanel.tex:SetTexture(q)
		ComixPremiumPanel.anim[1]:SetOffset(s,u)
		ComixPremiumPanel.anim[2]:SetOffset(t,v)
		ComixPremiumPanel.anim[3]:SetOffset(0,0)
		ComixPremiumPanelBG.tex:SetTexture(r)
		ComixPremiumPanelBG.anim[1]:SetOffset(w,y)
		ComixPremiumPanelBG.anim[2]:SetOffset(x,z)
		ComixPremiumPanelBG.anim[3]:SetOffset(0,0)
		ComixPremiumPanel.anim:Play()
		ComixPremiumPanelBG.anim:Play()
	end 
end;

local Comix_OnEvent = function(self, event, ...)
	local subEvent = select(2,...)
	local guid = select(4,...)
	local ready = self:ReadyState()
	playerGUID = UnitGUID('player')
	if subEvent == "PARTY_KILL" and guid == playerGUID and ready then 
		self:ReadyState(false)
		local rng = random(1,10)
		if rng < 9 then
			self:LaunchPopup("BASIC")
		else
			self:LaunchPopup("PREMIUM")
		end 
	end  
end

function SuperVillain:ToggleComix()
	if not SuperVillain.protected.scripts.comix then 
		Comix:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	else 
		Comix:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", Comix_OnEvent)
	end 
end;

function SuperVillain:ToastyKombat()
	Comix:LaunchPopup("TOASTY")
end;

local function LoadSuperVillainComix()
	local basic = CreateFrame("Frame", "ComixBasicPanel", SuperVillain.UIParent)
	basic:SetSize(100, 100)
	basic:SetFrameStrata("DIALOG")
	basic:Point("CENTER", SuperVillain.UIParent, "CENTER", 0, -50)
	basic.tex = basic:CreateTexture(nil, "ARTWORK")
	basic.tex:FillInner(basic)
	SuperVillain.Animate:RandomSlide(basic, true)
	basic:SetAlpha(0)
	basic.anim[3]:SetScript("OnFinished", function() Comix:ReadyState(true) end)

	local premium = CreateFrame("Frame", "ComixPremiumPanel", SuperVillain.UIParent)
	premium:SetSize(100, 100)
	premium:SetFrameStrata("DIALOG")
	premium:Point("CENTER", SuperVillain.UIParent, "CENTER", 0, -50)
	premium.tex = premium:CreateTexture(nil, "ARTWORK")
	premium.tex:FillInner(premium)
	SuperVillain.Animate:RandomSlide(premium, true)
	premium:SetAlpha(0)
	premium.anim[3]:SetScript("OnFinished", function() Comix:ReadyState(true) end)

	local premiumbg = CreateFrame("Frame", "ComixPremiumPanelBG", SuperVillain.UIParent)
	premiumbg:SetSize(128, 128)
	premiumbg:SetFrameStrata("BACKGROUND")
	premiumbg:Point("CENTER", SuperVillain.UIParent, "CENTER", 0, -50)
	premiumbg.tex = premiumbg:CreateTexture(nil, "ARTWORK")
	premiumbg.tex:FillInner(premiumbg)
	SuperVillain.Animate:RandomSlide(premiumbg, false)
	premiumbg:SetAlpha(0)
	premiumbg.anim[3]:SetScript("OnFinished", function() Comix:ReadyState(true) end)
	--MOD
	local toasty = CreateFrame("Frame", "ComixToastyPanelBG", UIParent)
	toasty:SetSize(256, 256)
	toasty:SetFrameStrata("DIALOG")
	toasty:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
	toasty.tex = toasty:CreateTexture(nil, "ARTWORK")
	toasty.tex:FillInner(toasty)
	SuperVillain.Animate:Slide(toasty, 256, -256, true, true)
	toasty.anim[2]:SetScript("OnFinished", function() Comix:ReadyState(true) end)

	Comix:ReadyState(true)
	SuperVillain:ToggleComix()
end
SuperVillain.Registry:NewScript(LoadSuperVillainComix)
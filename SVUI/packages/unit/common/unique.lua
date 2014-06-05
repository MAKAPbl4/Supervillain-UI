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
--]]
local SuperVillain, L, P, C, G = unpack(select(2, ...));
local MOD = SuperVillain:GetModule('SVUnit');
local LSM = LibStub("LibSharedMedia-3.0");
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local format = string.format
local cos, sin, sqrt2, random, floor, ceil = math.cos, math.sin, math.sqrt(2), math.random, math.floor, math.ceil;
local GetPlayerMapPosition = GetPlayerMapPosition;
--[[ 
########################################################## 
PLAYER ONLY COMPONENTS
##########################################################
]]--
function MOD:CreateRestingIndicator(frame)
	local resting = CreateFrame("Frame",nil,frame)
	resting:SetFrameStrata("MEDIUM")
	resting:SetFrameLevel(20)
	resting:Size(26,26)
	resting:Point("TOPRIGHT",frame,3,3)
	resting.bg = resting:CreateTexture(nil,"OVERLAY",nil,1)
	resting.bg:SetAllPoints(resting)
	resting.bg:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\ZZZ")
	return resting 
end;

function MOD:CreateCombatIndicator(frame)
	local combat = CreateFrame("Frame",nil,frame)
	combat:SetFrameStrata("MEDIUM")
	combat:SetFrameLevel(30)
	combat:Size(26,26)
	combat:Point("TOPRIGHT",frame,3,3)
	combat.bg = combat:CreateTexture(nil,"OVERLAY",nil,5)
	combat.bg:SetAllPoints(combat)
	combat.bg:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\COMBAT")
	SuperVillain.Animate:Pulse(combat)
	combat:SetScript("OnShow", function(this)
		if not this.anim:IsPlaying() then this.anim:Play() end 
	end)
	
	local aggro = CreateFrame("Frame", nil, combat)
	aggro:SetFrameStrata("HIGH")
	aggro:SetFrameLevel(30)
	aggro:Size(52,52)
	aggro:Point("TOPRIGHT",frame,16,16)
	aggro.bg = aggro:CreateTexture(nil, "BORDER")
	aggro.bg:FillInner(aggro)
	aggro.bg:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\ALERT_BALLOON")
	aggro.icon = aggro:CreateTexture(nil, "ARTWORK")
	aggro.icon:FillInner(aggro)
	aggro.icon:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\ALERT_THREAT")
	SuperVillain.Animate:Pulse(aggro)
	aggro:Hide()
	aggro:SetScript("OnShow", function(this)
		if not this.anim:IsPlaying() then this.anim:Play() end 
	end)
	frame.OhShit = aggro
	combat:Hide()
	return combat 
end;

function MOD:CreatePlayerThreat(frame, glow, custom)
	local threat = CreateFrame("Frame", nil, frame)
	threat.glow = frame.ActionPanel;
	threat.PostUpdate = MOD.UpdatePlayerThreat;
	return threat 
end;

function MOD:UpdatePlayerThreat(unit,value,r,g,b)
	local frame = self:GetParent()
	if not unit or frame.unit~=unit or not frame.db or not frame.db.threatEnabled then return end;
	if value and value > 1 then 
		self.glow:SetBackdropBorderColor(r,g,b)
		frame.OhShit:Show() 
	else 
		self.glow:SetBackdropBorderColor(0,0,0,0.9)
		frame.OhShit:Hide()
	end 
end;

function MOD:CreatePvPIndicator(frame)
	local pvp = frame.InfoPanel:CreateFontString(nil,'OVERLAY')
	MOD:SetUnitFont(pvp)
	return pvp 
end;

local ExRep_OnEnter = function(self)if self:IsShown() then UIFrameFadeIn(self,.1,0,1) end end;
local ExRep_OnLeave = function(self)if self:IsShown() then UIFrameFadeOut(self,.2,1,0) end end;

function MOD:CreateExperienceRepBar(frame)
	local db=MOD.db.player;
	if db.playerExpBar then 
		local xp=CreateFrame('StatusBar','PlayerFrameExperienceBar',frame.Power)
		xp:FillInner(frame.Power,0,0)
		xp:SetPanelTemplate()
		xp:SetStatusBarTexture(SuperVillain.Textures.default)
		xp:SetStatusBarColor(0,0.1,0.6)
		--xp:SetBackdropColor(1,1,1,0.8)
		xp:SetFrameLevel(xp:GetFrameLevel() + 2)
		xp.Tooltip=true;
		xp.Rested=CreateFrame('StatusBar',nil,xp)
		xp.Rested:SetAllPoints(xp)
		xp.Rested:SetStatusBarTexture(SuperVillain.Textures.default)
		xp.Rested:SetStatusBarColor(1,0,1,0.6)
		xp.Value=xp:CreateFontString(nil,'TOOLTIP')
		xp.Value:SetAllPoints(xp)
		xp.Value:SetFontTemplate(SuperVillain.Fonts.roboto,10,"NONE")
		xp.Value:SetTextColor(0.2,0.75,1)
		xp.Value:SetShadowColor(0,0,0,0)
		xp.Value:SetShadowOffset(0,0)
		frame:Tag(xp.Value,"[curxp] / [maxxp]")
		xp.Rested:SetBackdrop({bgFile=[[Interface\BUTTONS\WHITE8X8]]})
		xp.Rested:SetBackdropColor(unpack(SuperVillain.Colors.default))
		xp:SetScript('OnEnter', ExRep_OnEnter)
		xp:SetScript('OnLeave', ExRep_OnLeave)
		xp:SetAlpha(0)
		frame.Experience=xp 
	end;
	if db.playerRepBar then 
		local rep=CreateFrame('StatusBar','PlayerFrameReputationBar',frame.Power)
		rep:FillInner(frame.Power,0,0)
		rep:SetPanelTemplate()
		rep:SetStatusBarTexture(SuperVillain.Textures.default)
		rep:SetStatusBarColor(0,0.6,0)
		--rep:SetBackdropColor(1,1,1,0.8)
		rep:SetFrameLevel(rep:GetFrameLevel() + 2)
		rep.Tooltip=true;
		rep.Value=rep:CreateFontString(nil,'TOOLTIP')
		rep.Value:SetAllPoints(rep)
		rep.Value:SetFontTemplate(SuperVillain.Fonts.roboto,10,"NONE")
		rep.Value:SetTextColor(0.1,1,0.2)
		rep.Value:SetShadowColor(0,0,0,0)
		rep.Value:SetShadowOffset(0,0)
		frame:Tag(rep.Value,"[standing]: [currep] / [maxrep]")
		rep:SetScript('OnEnter', ExRep_OnEnter)
		rep:SetScript('OnLeave', ExRep_OnLeave)
		rep:SetAlpha(0)
		frame.Reputation=rep 
	end 
end;
--[[ 
########################################################## 
TARGET ONLY COMPONENTS
##########################################################
]]--
function MOD:CreateLevelText(frame)
	local lvl = frame.InfoPanel:CreateFontString(nil,'OVERLAY')
	lvl:SetFontTemplate(SuperVillain.Fonts.numbers,18,"OUTLINE")
	return lvl 
end;

function MOD:CreateGPS(frame)
	if not frame then return end;
	local gps=CreateFrame("Frame",nil,frame)
	gps:Size(40,40)
	gps:Point('BOTTOMLEFT',frame,'BOTTOMRIGHT', 6, 0)
	gps:EnableMouse(false)
	gps.background = gps:CreateTexture(nil,"BACKGROUND")
	gps.background:WrapOuter(gps,4,4)
	gps.background:SetAlpha(0.3)
	SetPortraitToTexture(gps.background,[[Interface\Addons\SVUI\assets\artwork\Icons\GPS]])

	gps.border = gps:CreateTexture(nil,"BORDER")
	gps.border:WrapOuter(gps,4,4)
	gps.border:SetTexture([[Interface\Addons\SVUI\assets\artwork\Template\ROUND]])
	gps.border:SetGradient(unpack(SuperVillain.Colors.gradient.dark))

	gps.Arrow = gps:CreateTexture(nil,"OVERLAY",nil,-2)
	gps.Arrow:SetTexture([[Interface\AddOns\SVUI\assets\artwork\icons\GPS-ARROW]])
	gps.Arrow:Size(44,44)
	gps.Arrow:SetPoint("CENTER",gps,"CENTER",0,0)
	gps.Arrow:SetGradient(unpack(SuperVillain.Colors.gradient.yellow))

	gps.readout = CreateFrame("Frame",nil,gps)
	gps.readout:Size(40,28)
	gps.readout:SetFrameLevel(gps:GetFrameLevel() + 2)
	gps.readout:SetPoint("CENTER",gps,"CENTER",0,0)

	gps.Text = gps.readout:CreateFontString(nil,"OVERLAY")
	gps.Text:SetFontTemplate(SuperVillain.Fonts.numbers,10,'OUTLINE','CENTER','MIDDLE')
	gps.Text:SetAllPoints(gps.readout)
	MOD:SetUnitFont(gps.Text)
	
	gps.onMouseOver = false;
	gps.outOfRange = false;
	--gps:Hide()
	return gps 
end;

function MOD:CreateXRay(frame)
	local xray=CreateFrame("BUTTON","XRayFocus",frame,"SecureActionButtonTemplate")
	xray:EnableMouse(true)
	xray:RegisterForClicks("AnyUp")
	xray:SetAttribute("type","macro")
	xray:SetAttribute("macrotext","/focus")
	xray:Size(64,64)
	xray:SetFrameStrata("DIALOG")
	xray.icon=xray:CreateTexture(nil,"ARTWORK")
	xray.icon:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\XRAY")
	xray.icon:SetAllPoints(xray)
	xray.icon:SetAlpha(0)
	xray:SetScript("OnLeave",function()GameTooltip:Hide()xray.icon:SetAlpha(0)end)
	xray:SetScript("OnEnter",function(self)
		xray.icon:SetAlpha(1)
		local r,s,b,m=GetScreenHeight(),GetScreenWidth(),self:GetCenter()
		local t,u,v="RIGHT","TOP","BOTTOM"
		if (b < (r / 2)) then t="LEFT" end;
		if (m < (s / 2)) then u,v=v,u end;
		GameTooltip:SetOwner(self,"ANCHOR_NONE")
		GameTooltip:SetPoint(u..t,self,v..t)
		GameTooltip:SetText(FOCUSTARGET.."\n")
	end)
	return xray 
end;

function MOD:CreateXRay_Closer(frame)
	local close=CreateFrame("BUTTON","ClearXRay",frame,"SecureActionButtonTemplate")
	close:EnableMouse(true)
	close:RegisterForClicks("AnyUp")
	close:SetAttribute("type","macro")
	close:SetAttribute("macrotext","/clearfocus")
	close:Size(64,64)
	close:SetFrameStrata("DIALOG")
	close.icon=close:CreateTexture(nil,"ARTWORK")
	close.icon:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\XRAY_CLOSE")
	close.icon:SetAllPoints(close)
	close.icon:SetVertexColor(1,0.2,0.1)
	close:SetScript("OnLeave",function()GameTooltip:Hide()close.icon:SetVertexColor(1,0.2,0.1)end)
	close:SetScript("OnEnter",function(self)close.icon:SetVertexColor(1,1,0.2)local r,s,b,m=GetScreenHeight(),GetScreenWidth(),self:GetCenter()local t,u,v="RIGHT","TOP","BOTTOM"if b<r/2 then t="LEFT"end;if m<s/2 then u,v=v,u end;GameTooltip:SetOwner(self,"ANCHOR_NONE")GameTooltip:SetPoint(u..t,self,v..t)GameTooltip:SetText(CLEAR_FOCUS.."\n")end)
	return close 
end;
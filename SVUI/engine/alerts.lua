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
local type      = _G.type;
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local tinsert   = _G.tinsert;
local string    = _G.string;
local table     = _G.table;
--[[ STRING METHODS ]]--
local lower = string.lower;
--[[ TABLE METHODS ]]--
local tremove, twipe = table.remove, table.wipe;
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, G = unpack(select(2, ...));
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local BUFFER = {};
local NOOP = function() end;
--[[ 
########################################################## 
DEFINITIONS
##########################################################
]]--
SuperVillain.SystemAlert = {};
SuperVillain.ActiveAlerts = {};
SuperVillain.SystemAlert['CLIENT_UPDATE_REQUEST'] = {
	text=L["Detected that your SVUI Config addon is out of date. Update as soon as possible."],
	button1=OKAY,
	OnAccept=NOOP,
	state1=1
};
SuperVillain.SystemAlert['FAILED_UISCALE'] = {
	text = L['You have changed your UIScale, however you still have the AutoScale option enabled in SVUI. Press accept if you would like to disable the Auto Scale option.'],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() SuperVillain.global.common.autoScale = false; ReloadUI(); end,
	timeout = 0,
	whileDead = 1,	
	hideOnEscape = false,
}
SuperVillain.SystemAlert["RL_CLIENT"] = {
	text=L["A setting you have changed requires that you reload your User Interface."],
	button1=ACCEPT,
	button2=CANCEL,
	OnAccept=function()ReloadUI()end,
	timeout=0,
	whileDead=1,
	hideOnEscape=false
};
SuperVillain.SystemAlert["KEYBIND_MODE"] = {
	text=L["Hover your mouse over any actionbutton or spellbook button to bind it. Press the escape key or right click to clear the current actionbutton's keybinding."],
	button1=L['Save'],
	button2=L['Discard'],
	OnAccept=function()local b=SuperVillain:GetModule('SVBar')b:ToggleKeyBindingMode(true,true)end,
	OnCancel=function()local b=SuperVillain:GetModule('SVBar')b:ToggleKeyBindingMode(true,false)end,
	timeout=0,
	whileDead=1,
	hideOnEscape=false
};
SuperVillain.SystemAlert["DELETE_GRAYS"] = {
	text=L["Are you sure you want to delete all your gray items?"],
	button1=YES,
	button2=NO,
	OnAccept=function()local c=SuperVillain:GetModule('SVBag')c:VendorGrays(true)end,
	OnShow=function(a)MoneyFrame_Update(a.moneyFrame,SuperVillain.SystemAlert["DELETE_GRAYS"].Money)end,
	timeout=0,
	whileDead=1,
	hideOnEscape=false,
	hasMoneyFrame=1
};
SuperVillain.SystemAlert["BUY_BANK_SLOT"] = {
	text=CONFIRM_BUY_BANK_SLOT,
	button1=YES,
	button2=NO,
	OnAccept=function(a)PurchaseSlot()end,
	OnShow=function(a)MoneyFrame_Update(a.moneyFrame,GetBankSlotCost())end,
	hasMoneyFrame=1,
	timeout=0,
	hideOnEscape=1
};
SuperVillain.SystemAlert["CANNOT_BUY_BANK_SLOT"] = {
	text=L["Can't buy anymore slots!"],
	button1=ACCEPT,
	timeout=0,
	whileDead=1
};
SuperVillain.SystemAlert["NO_BANK_BAGS"] = {
	text=L['You must purchase a bank slot first!'],
	button1=ACCEPT,
	timeout=0,
	whileDead=1
};
SuperVillain.SystemAlert["RESETMOVERS_CHECK"] = {
	text=L["Are you sure you want to reset every mover back to it's default position?"],
	button1=ACCEPT,
	button2=CANCEL,
	OnAccept=function(a)SuperVillain:ResetUI(true)end,
	timeout=0,
	whileDead=1
};
SuperVillain.SystemAlert["RESET_UI_CHECK"] = {
	text=L["I will attempt to preserve some of your basic settings but no promises. This will clean out everything else. Are you sure you want to reset everything?"],
	button1=ACCEPT,
	button2=CANCEL,
	OnAccept=function(a)SuperVillain:ResetAllUI(true)end,
	timeout=0,
	whileDead=1
};
SuperVillain.SystemAlert["CONFIRM_LOOT_DISTRIBUTION"] = {
	text=CONFIRM_LOOT_DISTRIBUTION,
	button1=YES,
	button2=NO,
	timeout=0,
	hideOnEscape=1
};
SuperVillain.SystemAlert["RESET_PROFILE_PROMPT"] = {
	text=L["Are you sure you want to reset all the settings on this profile?"],
	button1=YES,
	button2=NO,
	timeout=0,
	hideOnEscape=1,
	OnAccept=function()SuperVillain:ResetProfile()end
};
SuperVillain.SystemAlert["BAR6_CONFIRMATION"] = {
	text=L["Enabling/Disabling Bar #6 will toggle a paging option from your main actionbar to prevent duplicating bars, are you sure you want to do this?"],
	button1=YES,
	button2=NO,
	OnAccept=function(a)
		if SuperVillain.db.SVBar['BAR6'].enable~=true then 
			SuperVillain.db.SVBar['BAR6'].enable=true;
			SuperVillain:GetModule("SVBar"):UpdateBarOptions()
			SuperVillain:GetModule("SVBar"):ModifyBAR('BAR1')
			SuperVillain:GetModule("SVBar"):ModifyBAR('BAR6')
		else 
			SuperVillain.db.SVBar['BAR6'].enable=false;
			SuperVillain:GetModule("SVBar"):UpdateBarOptions()
			SuperVillain:GetModule("SVBar"):ModifyBAR('BAR1')
			SuperVillain:GetModule("SVBar"):ModifyBAR('BAR6')
		end 
	end,
	OnCancel=NOOP,
	timeout=0,
	whileDead=1,
	state1=1
};
SuperVillain.SystemAlert["CONFIRM_LOSE_BINDING_CHANGES"] = {
	text=CONFIRM_LOSE_BINDING_CHANGES,
	button1=OKAY,
	button2=CANCEL,
	OnAccept=function(a)SuperVillain:GetModule('SVBar'):ChangeBindingState()SuperVillain:GetModule('SVBar').bindingsChanged=nil end,
	OnCancel=function(a)
		if SVUI_KeyBindPopupCheckButton:GetChecked()then 
			SVUI_KeyBindPopupCheckButton:SetChecked()
		else 
			SVUI_KeyBindPopupCheckButton:SetChecked(1)
		end 
	end,
	timeout=0,
	whileDead=1,
	state1=1
};
SuperVillain.SystemAlert['INCOMPATIBLE_ADDON'] = {
	text=L['INCOMPATIBLE_ADDON'],
	OnAccept=function(a)DisableAddOn(SuperVillain.SystemAlert['INCOMPATIBLE_ADDON'].addon)ReloadUI()end,
	OnCancel=function(a)SuperVillain.protected[lower(SuperVillain.SystemAlert['INCOMPATIBLE_ADDON'].package)].enable=false;ReloadUI()end,
	timeout=0,
	whileDead=1,
	hideOnEscape=false
};
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
local function SysPop_Close_Table()local a=SuperVillain.ActiveAlerts;local b=#a;while b>=1 and not a[b]:IsShown()do tremove(a,b)b=b-1 end end;
local function SysPop_Close_Unique(a)a:Hide()SysPop_Close_Table()end;
local function SysPop_Move(a)if not tContains(SuperVillain.ActiveAlerts,a)then local b=SuperVillain.ActiveAlerts[#SuperVillain.ActiveAlerts]if b then a:SetPoint("TOP",b,"BOTTOM",0,-4)else a:SetPoint("TOP",SuperVillain.UIParent,"TOP",0,-100)end;tinsert(SuperVillain.ActiveAlerts,a)end end;
local function SysPop_Find(a,b)local c=SuperVillain.SystemAlert[a]if not c then return nil end;for d=1,4,1 do local e=_G["SVUI_SystemAlert"..d]if e:IsShown()and e.which==a and not c.multiple or e.data==b then return e end end;return nil end;
local function SysPop_Mod(a,b)local c=SuperVillain.SystemAlert[b]if not c then return nil end;local d=_G[a:GetName().."Text"]local e=_G[a:GetName().."EditBox"]local f=_G[a:GetName().."Button1"]local g,h=a.curMaxH or 0,a.curMaxW or 0;local i=320;if a.numButtons==3 then i=440 elseif c.state1 or c.state2 or c.closeButton then i=420 elseif c.editBoxWidth and c.editBoxWidth>260 then i=i+c.editBoxWidth-260 end;if i>h then a:SetWidth(i)a.curMaxW=i end;local j=32+d:GetHeight()+8+f:GetHeight()if c.hasEditBox then j=j+8+e:GetHeight()elseif c.hasMoneyFrame then j=j+16 elseif c.hasMoneyInputFrame then j=j+22 end;if c.hasItemFrame then j=j+64 end;if j>g then a:SetHeight(j)a.curMaxH=j end end;
local function SysPop_Event_Listener(self,...)self.curMaxH=0;SysPop_Mod(self,self.which);end;
local function SysPop_Event_Show(self,...)PlaySound("igMainMenuOpen")local a=SuperVillain.SystemAlert[self.which]local b=a.OnShow;if b then b(self,self.data)end;if a.hasMoneyInputFrame then _G[self:GetName().."MoneyInputFrameGold"]:SetFocus()end;if a.enterClicksFirstButton then self:SetScript("OnKeyDown",SysPop_Event_KeyDown)end end;
local function SysPop_Event_Hide(self,...)PlaySound("igMainMenuClose")SysPop_Close_Table()local a=SuperVillain.SystemAlert[self.which]local b=a.OnHide;if b then b(self,self.data)end;self.extraFrame:Hide()if a.enterClicksFirstButton then self:SetScript("OnKeyDown",nil)end end;
local function SysPop_Event_Escape(self,...)local a=nil;for b,c in pairs(SuperVillain.ActiveAlerts)do if c:IsShown()and c.hideOnEscape then local d=SuperVillain.SystemAlert[c.which]if d then local e=d.OnCancel;local f=d.noCancelOnEscape;if e and not f then e(c,c.data,"clicked")end;c:Hide()else SysPop_Close_Unique(c)end;a=1 end end;return a end;
local function SysPop_Event_KeyDown(self,key)if GetBindingFromClick(key)=="TOGGLEGAMEMENU"then return SysPop_Event_Escape()elseif GetBindingFromClick(key)=="SCREENSHOT"then RunBinding("SCREENSHOT")return end;local a=SuperVillain.SystemAlert[self.which]if a then if key=="ENTER"and a.enterClicksFirstButton then local b=self:GetName()local c;local d=1;while true do c=_G[b.."Button"..d]if c then if c:IsShown()then SysPop_Event_Click(self,d)return end;d=d+1 else break end end end end end;
local function SysPop_Event_Update(self,elapsed)if self.timeleft and self.timeleft>0 then local which=self.which;local timeleft=self.timeleft-elapsed;if timeleft<=0 then if not SuperVillain.SystemAlert[which].timeoutInformationalOnly then self.timeleft=0;local OnCancel=SuperVillain.SystemAlert[which].OnCancel;if OnCancel then OnCancel(self,self.data,"timeout")end;self:Hide()end;return end;self.timeleft=timeleft end;if self.startDelay then local which=self.which;local timeleft=self.startDelay-elapsed;if timeleft<=0 then self.startDelay=nil;local text=_G[self:GetName().."Text"]text:SetFormattedText(SuperVillain.SystemAlert[which].text,text.text_arg1,text.text_arg2)local a=_G[self:GetName().."Button1"]a:Enable()SysPop_Mod(self,which)return end;self.startDelay=timeleft end;local b=SuperVillain.SystemAlert[self.which].OnUpdate;if b then b(self,elapsed)end end;
local function SysPop_Event_Click(self,a)if not self:IsShown()then return end;local which=self.which;local b=SuperVillain.SystemAlert[which]if not b then return nil end;local c=true;if a==1 then local d=b.OnAccept;if d then c=not d(self,self.data,self.data2)end elseif a==3 then local e=b.OnAlt;if e then e(self,self.data,"clicked")end else local f=b.OnCancel;if f then c=not f(self,self.data,"clicked")end end;if c and which==self.which then self:Hide()end end;
local function SysBox_Event_KeyEnter(self,...)local EditBoxOnEnterPressed,a,b;local c=self:GetParent()if c.which then a=c.which;b=c elseif c:GetParent().which then a=c:GetParent().which;b=c:GetParent()end;if not self.autoCompleteParams or not AutoCompleteEditBox_OnEnterPressed(self)then EditBoxOnEnterPressed=SuperVillain.SystemAlert[a].EditBoxOnEnterPressed;if EditBoxOnEnterPressed then EditBoxOnEnterPressed(self,b.data)end end end;
local function SysBox_Event_KeyEscape(self,...)local e = SuperVillain.SystemAlert[self:GetParent().which].EditBoxOnEscapePressed;if( e )then e(self, self:GetParent().data);end end;
local function SysBox_Event_Change(self,a)if not self.autoCompleteParams or not AutoCompleteEditBox_OnTextChanged(self,a)then local EditBoxOnTextChanged=SuperVillain.SystemAlert[self:GetParent().which].EditBoxOnTextChanged;if EditBoxOnTextChanged then EditBoxOnTextChanged(self,self:GetParent().data)end end end;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function SuperVillain:StaticPopupSpecial_Show(a)
	if a.exclusive then 
		SuperVillain:StaticPopup_HideExclusive()
	end;
	SysPop_Move(a)
	a:Show()
end;

function SuperVillain:StaticPopupSpecial_Hide(a)
	a:Hide()
	SysPop_Close_Table()
end;

function SuperVillain:StaticPopup_Show(a,b,c,d)
	local e=SuperVillain.SystemAlert[a] or nil;
	if (not e) then return nil end;
	if UnitIsDeadOrGhost("player")and not e.whileDead then 
		if e.OnCancel then 
			e.OnCancel()
		end;
		return nil 
	end;
	if InCinematic()and not e.interruptCinematic then 
		if e.OnCancel then e.OnCancel()end;
		return nil 
	end;
	if e.cancels then 
		for f=1,4,1 do 
			local g = _G["SVUI_SystemAlert"..f]
			if g:IsShown() and g.which==e.cancels then 
				g:Hide()
				local OnCancel=SuperVillain.SystemAlert[g.which].OnCancel;
				if OnCancel then 
					OnCancel(g,g.data,"override")
				end 
			end 
		end 
	end;
	local h=nil;
	h=SysPop_Find(a,d)
	if h then
		if not e.noCancelOnReuse then 
			local OnCancel=e.OnCancel;
			if OnCancel then OnCancel(h,h.data,"override")end 
		end;
		--h:Hide()
	end;
	if not h then 
		local f=1;
		if e.preferredIndex then f=e.preferredIndex end;
		for i=f,4 do 
			local g=_G["SVUI_SystemAlert"..i]
			if not g:IsShown()then 
				h=g;
				break 
			end 
		end;
		if not h and e.preferredIndex then 
			for i=1,e.preferredIndex do 
				local g=_G["SVUI_SystemAlert"..i]
				if not g:IsShown()then 
					h=g;
					break 
				end 
			end 
		end 
	end;
	if not h then 
		if e.OnCancel then e.OnCancel()end;
		return nil 
	end;
	h.curMaxH,h.curMaxW=0,0;
	local j=_G[h:GetName().."Text"]
	j:SetFormattedText(e.text,b,c)
	if e.closeButton then 
		local k=_G[h:GetName().."CloseButton"]
		if e.closeButtonIsHide then 
			k:SetNormalTexture("Interface\\Buttons\\UI-Panel-HideButton-Up")
			k:SetPushedTexture("Interface\\Buttons\\UI-Panel-HideButton-Down")
		else 
			k:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
			k:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
		end;
		k:Show()
	else 
		_G[h:GetName().."CloseButton"]:Hide()
	end;
	local l=_G[h:GetName().."EditBox"]
	if e.hasEditBox then 
		l:Show()
		if e.maxLetters then 
			l:SetMaxLetters(e.maxLetters)
			l:SetCountInvisibleLetters(e.countInvisibleLetters)
		end;
		if e.maxBytes then 
			l:SetMaxBytes(e.maxBytes)
		end;
		l:SetText("")
		if e.editBoxWidth then 
			l:SetWidth(e.editBoxWidth)
		else 
			l:SetWidth(130)
		end 
	else 
		l:Hide()
	end;
	if e.hasMoneyFrame then 
		_G[h:GetName().."MoneyFrame"]:Show()
		_G[h:GetName().."MoneyInputFrame"]:Hide()
	elseif e.hasMoneyInputFrame then 
		local m=_G[h:GetName().."MoneyInputFrame"]
		m:Show()
		_G[h:GetName().."MoneyFrame"]:Hide()
		if e.EditBoxOnEnterPressed then 
			m.gold:SetScript("OnEnterPressed",SysBox_Event_KeyEnter)
			m.silver:SetScript("OnEnterPressed",SysBox_Event_KeyEnter)
			m.copper:SetScript("OnEnterPressed",SysBox_Event_KeyEnter)
		else 
			m.gold:SetScript("OnEnterPressed",nil)
			m.silver:SetScript("OnEnterPressed",nil)
			m.copper:SetScript("OnEnterPressed",nil)
		end 
	else
		_G[h:GetName().."MoneyFrame"]:Hide()
		_G[h:GetName().."MoneyInputFrame"]:Hide()
	end;
	if e.hasItemFrame then 
		_G[h:GetName().."ItemFrame"]:Show()
		if d and type(d)=="table"then 
			_G[h:GetName().."ItemFrame"].link=d.link;
			_G[h:GetName().."ItemFrameIconTexture"]:SetTexture(d.texture)
			local n=_G[h:GetName().."ItemFrameText"]
			n:SetTextColor(unpack(d.color or{1,1,1,1}))
			n:SetText(d.name)
			if d.count and d.count>1 then 
				_G[h:GetName().."ItemFrameCount"]:SetText(d.count)
				_G[h:GetName().."ItemFrameCount"]:Show()
			else 
				_G[h:GetName().."ItemFrameCount"]:Hide()
			end 
		end 
	else 
		_G[h:GetName().."ItemFrame"]:Hide()
	end;
	h.which=a;
	h.timeleft=e.timeout;
	h.hideOnEscape=e.hideOnEscape;
	h.exclusive=e.exclusive;
	h.enterClicksFirstButton=e.enterClicksFirstButton;
	h.data=d;
	local o=_G[h:GetName().."Button1"]
	local p=_G[h:GetName().."Button2"]
	local q=_G[h:GetName().."Button3"]
	do 
		assert(#BUFFER==0)
		tinsert(BUFFER,o)
		tinsert(BUFFER,p)
		tinsert(BUFFER,q)
		for i=#BUFFER,1,-1 do 
			BUFFER[i]:SetText(e["button"..i])
			BUFFER[i]:Hide()
			BUFFER[i]:ClearAllPoints()
			if (not (e["button"..i] and (not e["DisplayButton"..i] or e["DisplayButton"..i](h))))then 
				tremove(BUFFER,i)
			end 
		end;
		local r=#BUFFER;
		h.numButtons=r;
		if r==3 then 
			BUFFER[1]:SetPoint("BOTTOMRIGHT",h,"BOTTOM",-72,16)
		elseif r==2 then 
			BUFFER[1]:SetPoint("BOTTOMRIGHT",h,"BOTTOM",-6,16)
		elseif r==1 then 
			BUFFER[1]:SetPoint("BOTTOM",h,"BOTTOM",0,16)
		end;
		for i=1,r do 
			if i>1 then 
				BUFFER[i]:SetPoint("LEFT",BUFFER[i-1],"RIGHT",13,0)
			end;
			local s=BUFFER[i]:GetTextWidth()
			if s>110 then 
				BUFFER[i]:SetWidth(s+20)
			else 
				BUFFER[i]:SetWidth(120)
			end;
			BUFFER[i]:Enable()
			BUFFER[i]:Show()
		end;
		twipe(BUFFER)
	end;
	local t=_G[h:GetName().."AlertIcon"]
	if e.state1 then 
		t:SetTexture(STATICPOPUP_TEXTURE_ALERT)
		if q:IsShown()then 
			t:SetPoint("LEFT",24,10)
		else 
			t:SetPoint("LEFT",24,0)
		end;
		t:Show()
	elseif e.state2 then 
		t:SetTexture(STATICPOPUP_TEXTURE_ALERTGEAR)
		if q:IsShown()then 
			t:SetPoint("LEFT",24,0)
		else 
			t:SetPoint("LEFT",24,0)
		end;
		t:Show()
	else 
		t:SetTexture()
		t:Hide()
	end;
	if e.StartDelay then h.startDelay=e.StartDelay()o:Disable()else h.startDelay=nil;o:Enable()end;
	l.autoCompleteParams=e.autoCompleteParams;
	l.autoCompleteRegex=e.autoCompleteRegex;
	l.autoCompleteFormatRegex=e.autoCompleteFormatRegex;
	l.addHighlightedText=true;
	SysPop_Move(h)
	SysPop_Mod(h,a)
	if (not h:IsShown()) then
		h:Show()
		if e.sound then PlaySound(e.sound)end;
	end
	return h 
end;

function SuperVillain:StaticPopup_Hide(arg1, arg2)
	for i=1,4,1 do 
		local frame = _G["SVUI_SystemAlert"..i]
		if(frame.which == arg1 and not arg2 or arg2 == frame.data) then 
			frame:Hide()
		end 
	end 
end;

local AlertButton_OnClick = function(self)
	SysPop_Event_Click(self:GetParent(), self:GetID())
end

function SuperVillain:LoadSystemAlerts()
	for i = 1, 4 do 
		local alert = CreateFrame('Frame', 'SVUI_SystemAlert'..i, SuperVillain.UIParent, 'StaticPopupTemplate')
		alert:SetID(i)
		alert:SetScript('OnShow',SysPop_Event_Show)
		alert:SetScript('OnHide',SysPop_Event_Hide)
		alert:SetScript('OnUpdate',SysPop_Event_Update)
		alert:SetScript('OnEvent',SysPop_Event_Listener)
		alert.input = _G['SVUI_SystemAlert'..i..'EditBox'];
		alert.input:SetScript('OnEnterPressed',SysBox_Event_KeyEnter)
		alert.input:SetScript('OnEscapePressed',SysBox_Event_KeyEscape)
		alert.input:SetScript('OnTextChanged',SysBox_Event_Change)
		alert.gold = _G["SVUI_SystemAlert"..i.."MoneyInputFrameGold"];
		alert.silver = _G["SVUI_SystemAlert"..i.."MoneyInputFrameSilver"];
		alert.copper = _G["SVUI_SystemAlert"..i.."MoneyInputFrameCopper"];
		alert.buttons = {}
		for b = 1, 3 do
			local button = _G['SVUI_SystemAlert'..i..'Button'..b];
			button:SetScript('OnClick', AlertButton_OnClick)
			alert.buttons[b] = button
		end;
		_G["SVUI_SystemAlert"..i.."ItemFrameNameFrame"]:MUNG()
		_G["SVUI_SystemAlert"..i.."ItemFrame"]:GetNormalTexture():MUNG()
		_G["SVUI_SystemAlert"..i.."ItemFrame"]:SetButtonTemplate()
		_G["SVUI_SystemAlert"..i.."ItemFrameIconTexture"]:SetTexCoord(0.1,0.9,0.1,0.9)
		_G["SVUI_SystemAlert"..i.."ItemFrameIconTexture"]:FillInner()
	end 
end;
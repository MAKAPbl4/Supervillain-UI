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
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local tinsert   = _G.tinsert;
local string    = _G.string;
local math      = _G.math;
local table     = _G.table;
--[[ STRING METHODS ]]--
local lower, upper = string.lower, string.upper;
local find, format, len, split = string.find, string.format, string.len, string.split;
local match, sub, join = string.match, string.sub, string.join;
local gmatch, gsub = string.gmatch, string.gsub;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;  -- Basic
local parsefloat, random = math.parsefloat, math.random;  -- Uncommon
--[[ TABLE METHODS ]]--
local tremove, tcopy, twipe, tsort, tconcat = table.remove, table.copy, table.wipe, table.sort, table.concat;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, G = unpack(select(2, ...));
local MOD = SuperVillain:GetModule('SVChat');
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local defaultIcon="Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\CHATS";
--[[ 
########################################################## 
PRE VARS/FUNCTIONS
##########################################################
]]--
MOD.TabsList = {};
MOD.TabSafety = {};
MOD.LastAddedTab = false;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:RemoveTab(frame,chat)
	if(not frame or not frame.chatID) then return end;
	local name = frame:GetName();
	if(not MOD.TabSafety[name]) then return end;
	MOD.TabSafety[name] = false;
	local chatID = frame.chatID;
	if(MOD.TabsList[chatID]) then
		MOD.TabsList[chatID] = nil;
	end
	frame:ClearAllPoints()
	frame:SetParent(chat)
	frame:Point("TOPLEFT",chat,"BOTTOMLEFT",0,0);
	MOD:RepositionDockedTabs()
end;

function MOD:AddTab(frame,chatID)
	local name = frame:GetName();
	if(MOD.TabSafety[name]) then return end;
	MOD.TabSafety[name] = true;
	MOD.TabsList[chatID] = frame
    frame.chatID = chatID;
    frame:SetParent(SuperDockChatTabBar)
    MOD:RepositionDockedTabs()
end;

function MOD:RepositionDockedTabs()
	local lastTab = MOD.TabsList[1];
	if(lastTab) then
		lastTab:ClearAllPoints()
		lastTab:Point("LEFT",SuperDockChatTabBar,"LEFT",3,0);
	end
	for chatID,frame in pairs(MOD.TabsList) do
		if(frame and chatID ~= 1) then
			frame:ClearAllPoints()
			frame:ClearAllPoints()
			if(not lastTab) then
				frame:Point("LEFT",SuperDockChatTabBar,"LEFT",3,0);
			else
				frame:Point("LEFT",lastTab,"RIGHT",6,0);
			end
			lastTab = frame
		end
	end
end;

function MOD:CreateCustomTab(tab, chatID, enabled)
	if(tab.IsStyled) then return end;
	local tabName = tab:GetName();
	local tabSize = SuperDockChatTabBar.currentSize;
	local tabText = tab.text:GetText() or "Chat "..chatID;

	local holder = CreateFrame("Frame",("SVUI_ChatTab%s"):format(chatID),SuperDockChatTabBar)
	holder:SetWidth(tabSize * 1.75)
	holder:SetHeight(tabSize)
	tab.chatID = chatID;
	tab:SetParent(holder)
	tab:ClearAllPoints()
	tab:SetAllPoints(holder)
	tab:SetFramedButtonTemplate()
	tab.icon=tab:CreateTexture(nil,"BACKGROUND")
	tab.icon:Size(tabSize * 1.25,tabSize)
	tab.icon:Point("CENTER",tab,"CENTER",0,0)
	tab.icon:SetTexture(defaultIcon)
	if(tab.conversationIcon) then
		tab.icon:SetGradient("VERTICAL", 0.1, 0.53, 0.65, 0.3, 0.7, 1)
	else
		tab.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
	end
	tab.icon:SetAlpha(0.5)
	tab.TText = tabText;
	
	--tab.SetWidth = function()end;
	tab.SetHeight = function()end;
	tab.SetSize = function()end;
	tab.SetParent = function()end;
	tab.ClearAllPoints = function()end;
	tab.SetAllPoints = function()end;
	tab.SetPoint = function()end;

	tab:SetScript("OnEnter",function(self)
		local chatFrame = _G["ChatFrame"..self:GetID()];
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT");
		GameTooltip:ClearLines();
		GameTooltip:AddLine(self.TText,1,1,1);
	    if ( chatFrame.isTemporary and chatFrame.chatType == "BN_CONVERSATION" ) then
	        BNConversation_DisplayConversationTooltip(tonumber(chatFrame.chatTarget));
	    else
	        GameTooltip_AddNewbieTip(self, CHAT_OPTIONS_LABEL, 1.0, 1.0, 1.0, NEWBIE_TOOLTIP_CHATOPTIONS, 1);
	    end
		if not self.IsOpen then
			self:SetPanelColor("highlight")
		end
		GameTooltip:Show()
	end);
	tab:SetScript("OnLeave",function(self)
		if not self.IsOpen then
			self:SetPanelColor("default")
		end
		GameTooltip:Hide()
	end);
	tab:SetScript("OnClick",function(self,button)
		FCF_Tab_OnClick(self,button);
		local chatFrame = _G["ChatFrame"..self:GetID()]; 
		if ( chatFrame.isDocked and FCFDock_GetSelectedWindow(GENERAL_CHAT_DOCK) ~= chatFrame ) then
	        self.IsOpen = true
	        self:SetPanelColor("highlight")
	    else
	        self.IsOpen = false
	        self:SetPanelColor("default")
	    end
	end);
	tab.IsStyled = true;
	tab.Holder = holder
	if(enabled == true) then
		MOD:AddTab(holder,chatID)
	end
end;
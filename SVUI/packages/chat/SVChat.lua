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
local MOD = SuperVillain:NewModule('SVChat', 'AceTimer-3.0', 'AceHook-3.0');
local DOCK = SuperVillain:GetModule('SVDock');
local LSM = LibStub("LibSharedMedia-3.0");
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local MaxChatID = 0
local hyperLinkEntered
local internalTest = false
local locale = GetLocale()

local ParseableEvents = {
	"CHAT_MSG_WHISPER_INFORM",
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_OFFICER",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_RAID",
	"CHAT_MSG_RAID_LEADER",
	"CHAT_MSG_INSTANCE_CHAT",
	"CHAT_MSG_INSTANCE_CHAT_LEADER",
	"CHAT_MSG_BN_CONVERSATION",
	"CHAT_MSG_BN_WHISPER",
	"CHAT_MSG_BN_WHISPER_INFORM"
}

local EmotePatterns = {
	["%:%-%@"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\angry.blp]],
	["%:%@"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\angry.blp]],
	["%:%-%)"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\happy.blp]],
	["%:%)"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\happy.blp]],
	["%:D"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\grin.blp]],
	["%:%-D"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\grin.blp]],
	["%;%-D"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\grin.blp]],
	["%;D"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\grin.blp]],
	["%=D"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\grin.blp]],
	["xD"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\grin.blp]],
	["XD"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\grin.blp]],
	["%:%-%("] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\sad.blp]],
	["%:%("] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\sad.blp]],
	["%:o"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\surprise.blp]],
	["%:%-o"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\surprise.blp]],
	["%:%-O"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\surprise.blp]],
	["%:O"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\surprise.blp]],
	["%:%-0"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\surprise.blp]],
	["%:P"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\tongue.blp]],
	["%:%-P"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\tongue.blp]],
	["%:p"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\tongue.blp]],
	["%:%-p"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\tongue.blp]],
	["%=P"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\tongue.blp]],
	["%=p"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\tongue.blp]],
	["%;%-p"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\tongue.blp]],
	["%;p"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\tongue.blp]],
	["%;P"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\tongue.blp]],
	["%;%-P"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\tongue.blp]],
	["%;%-%)"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\winky.blp]],
	["%;%)"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\winky.blp]],
	["%:S"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\hmm.blp]],
	["%:%-S"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\hmm.blp]],
	["%:%,%("] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\weepy.blp]],
	["%:%,%-%("] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\weepy.blp]],
	["%:%'%("] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\weepy.blp]],
	["%:%'%-%("] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\weepy.blp]],
	["%:%F"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\middle_finger.blp]],
	["<3"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\heart.blp]],
	["</3"] = [[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\broken_heart.blp]]
}

local Original_ChatFrame_OnHyperlinkShow = ChatFrame_OnHyperlinkShow
--[[ 
########################################################## 
INIT SETTINGS
##########################################################
]]--
CHAT_GUILD_GET="|Hchannel:GUILD|hG|h %s "
CHAT_OFFICER_GET="|Hchannel:OFFICER|hO|h %s "
CHAT_RAID_GET="|Hchannel:RAID|hR|h %s "
CHAT_RAID_WARNING_GET="RW %s "
CHAT_RAID_LEADER_GET="|Hchannel:RAID|hRL|h %s "
CHAT_PARTY_GET="|Hchannel:PARTY|hP|h %s "
CHAT_PARTY_LEADER_GET="|Hchannel:PARTY|hPL|h %s "
CHAT_PARTY_GUIDE_GET="|Hchannel:PARTY|hPG|h %s "
CHAT_INSTANCE_CHAT_GET="|Hchannel:Battleground|hI.|h %s: "
CHAT_INSTANCE_CHAT_LEADER_GET="|Hchannel:Battleground|hIL.|h %s: "
CHAT_WHISPER_INFORM_GET="to %s "
CHAT_WHISPER_GET="from %s "
CHAT_BN_WHISPER_INFORM_GET="to %s "
CHAT_BN_WHISPER_GET="from %s "
CHAT_SAY_GET="%s "CHAT_YELL_GET="%s "
CHAT_FLAG_AFK="[AFK] "
CHAT_FLAG_DND="[DND] "
CHAT_FLAG_GM="[GM] "
--[[ 
########################################################## 
CORE DATA
##########################################################
]]--
MOD.Keywords = {};
MOD.MessageCache = {};
MOD.MessageCache["list"] = {};
MOD.MessageCache["time"] = {};
MOD.MessageCache["count"] = {};
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local URLChatFrame_OnHyperlinkShow = function(self, link, ...)
	MOD.clickedframe = self
	if (link):sub(1, 3) == "url" then
		local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
		local currentLink = (link):sub(5)
		if (not ChatFrameEditBox:IsShown()) then
			ChatEdit_ActivateChat(ChatFrameEditBox)
		end
		ChatFrameEditBox:Insert(currentLink)
		ChatFrameEditBox:HighlightText()
		return;
	end
	
	ChatFrame_OnHyperlinkShow(self, link, ...)
end

local ChatFrame_OnMouseScroll = function(frame, delta)
	if delta < 0 then
		if IsShiftKeyDown() then
			frame:ScrollToBottom()
		else
			for i = 1, 3 do
				frame:ScrollDown()
			end
		end
	elseif delta > 0 then
		if IsShiftKeyDown() then
			frame:ScrollToTop()
		else
			for i = 1, 3 do
				frame:ScrollUp()
			end
		end
		if MOD.db.scrollDownInterval ~= 0 then
			if frame.ScrollTimer then
				MOD:CancelTimer(frame.ScrollTimer, true)
			end
			frame.ScrollTimer = MOD:ScheduleTimer('ScrollToBottom', MOD.db.scrollDownInterval, frame)
		end		
	end
end

local function ChatSetEmoticon(text)
	for emote,icon in pairs(EmotePatterns) do
		text = gsub(text, emote, "|T" .. icon .. ":16|t");
	end
	return text;
end

local function ChatParseMessage(arg1,arg2,arg3)
	internalTest=true;
	local result = " "..string.link("["..arg2.."]", "url", arg2, "0099FF").." ";
	return result
end;

local function ConcatenateTimeStamp(msg)
	if (MOD.db.timeStampFormat and MOD.db.timeStampFormat ~= 'NONE' ) then
		local timeStamp = BetterDate(MOD.db.timeStampFormat, MOD.timeOverride or time());
		timeStamp = timeStamp:gsub(' ', '')
		timeStamp = timeStamp:gsub('AM', ' AM')
		timeStamp = timeStamp:gsub('PM', ' PM')
		msg = '|cffB3B3B3['..timeStamp..'] |r'..msg
		MOD.timeOverride = nil;
	end
	
	return msg
end

local function ChatAddMessage(chat,text,...)
	internalTest=false;
	if find(text,"%pTInterface%p+") or find(text,"%pTINTERFACE%p+") then 
		internalTest=true 
	end;
	if not internalTest then text=gsub(text,"(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?)(%s?)",ChatParseMessage) end;
	if not internalTest then text=gsub(text,"(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?)(%s?)",ChatParseMessage) end;
	if not internalTest then text=gsub(text,"(%s?)([%w_-]+%.?[%w_-]+%.[%w_-]+:%d%d%d?%d?%d?)(%s?)",ChatParseMessage) end;
	if not internalTest then text=gsub(text,"(%s?)(%a+://[%w_/%.%?%%=~&-'%-]+)(%s?)",ChatParseMessage) end;
	if not internalTest then text=gsub(text,"(%s?)(www%.[%w_/%.%?%%=~&-'%-]+)(%s?)",ChatParseMessage) end;
	if not internalTest then text=gsub(text,"(%s?)([_%w-%.~-]+@[_%w-]+%.[_%w-%.]+)(%s?)",ChatParseMessage) end;
	chat.TempAddMessage(chat,ConcatenateTimeStamp(text),...)
end;
--[[ 
########################################################## 
FUNCTION OVERRIDES
##########################################################
]]--
function ChatFrame_OnHyperlinkShow(chat,link,arg1,arg2)
	local test,text=link:match("(%a+):(.+)")
	if test=="url"then 
		local editBox=LAST_ACTIVE_CHAT_EDIT_BOX or _G[chat:GetName()..'EditBox']
		if editBox then 
			editBox:SetText(text)
			editBox:SetFocus()
			editBox:HighlightText()
		end 
	else 
		Original_ChatFrame_OnHyperlinkShow(chat,link,arg1,arg2)
	end 
end;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:ScrollToBottom(frame)
	frame:ScrollToBottom()
	MOD:CancelTimer(frame.ScrollTimer, true)
end

function MOD:Emotify(text)
	if not text then return end;
	if (not MOD.db.smileys or text:find('/run') or text:find('/dump') or text:find('/script')) then 
		return text 
	end;
	local result="";
	local maxLen=len(text);
	local count=1;
	local temp;
	while count <= maxLen do 
		temp=maxLen;
		local section=find(text, "|H", count, true)
		if section~=nil then temp=section end;
		result = result..ChatSetEmoticon(sub(text, count, temp))
		count = temp + 1;
		if section~=nil then 
			temp=find(text, "|h]|r", count, -1) or find(text, "|h", count, -1)
			temp=temp or maxLen;
			if count < temp then 
				result = result..sub(text, count, temp)
				count = temp + 1;
			end 
		end 
	end;
	return result 
end;

local stopSound = function() MOD.SoundPlayed = nil end;

function MOD:ParseKeyword(testString)
	local result,lCase;
	local pass=true;
	for word in testString:gmatch("[^%s]+") do 
		lCase = word:lower()
		lCase = lCase:gsub("%p","")
		for key,_ in pairs(MOD.Keywords)do 
			if lCase == key:lower() then 
				local update = word:gsub("%p","")
				word = word:gsub(update,SuperVillain.Colors.hexvaluecolor..update..'|r')
				if MOD.db.keywordSound ~= 'None' and not MOD.SoundPlayed then 
					PlaySoundFile(LSM:Fetch("sound",MOD.db.keywordSound),"Master")
					MOD.SoundPlayed = true;
					MOD.SoundTimer = MOD:ScheduleTimer(stopSound,1)
				end 
			end 
		end;
		if pass then 
			result = word;
			pass=false;
		else 
			result = format("%s %s", result, word)
		end 
	end;
	return result 
end;

function MOD:ParseMessage(arg, text, ...)
	if ((arg == "CHAT_MSG_WHISPER" or arg == "CHAT_MSG_BN_WHISPER") and MOD.db.psst ~= "None" and not MOD.SoundPlayed) then 
		if text:sub(1, 3) == "OQ, " then 
			return false, text, ...
		end;
		PlaySoundFile(LSM:Fetch("sound", MOD.db.psst), "Master")
		MOD.SoundPlayed = true;
		MOD.SoundTimer = MOD:ScheduleTimer(stopSound, 1)
	end;
	if not MOD.db.url then 
		text = MOD:ParseKeyword(text)
		text = MOD:Emotify(text)
		return false, text, ...
	end;
	local result, ct = gsub(text, "(%a+)://(%S+)%s?", "%1://%2")
	if ct > 0 then 
		return false, MOD:Emotify(MOD:ParseKeyword(result)), ...
	end;
	result, ct = gsub(text, "www%.([_A-Za-z0-9-]+)%.(%S+)%s?", "www.%1.%2")
	if ct > 0 then 
		return false, MOD:Emotify(MOD:ParseKeyword(result)), ...
	end;
	result, ct = gsub(text, "([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?", "%1@%2%3%4")
	if ct > 0 then 
		return false, MOD:Emotify(MOD:ParseKeyword(result)), ...
	end;
	text = MOD:ParseKeyword(text)
	text = MOD:Emotify(text)
	return false, text, ...
end;

function MOD:TabOnEnter(frame)
	_G[frame:GetName().."Text"]:Show()
	
	if frame.conversationIcon then
		frame.conversationIcon:Show()
	end
end

function MOD:TabOnLeave(frame)
	_G[frame:GetName().."Text"]:Hide()
	
	if frame.conversationIcon then
		frame.conversationIcon:Hide()
	end
end

function MOD:ConfigChatTabs(frame, hook)
	if hook and (not self.hooks or not self.hooks[frame] or not self.hooks[frame].TabOnEnter) then
		self:HookScript(frame, 'TabOnEnter')
		self:HookScript(frame, 'TabOnLeave')
	elseif not hook and self.hooks and self.hooks[frame] and self.hooks[frame].OnEnter then
		self:Unhook(frame, 'TabOnEnter')
		self:Unhook(frame, 'TabOnLeave')	
	end
	
	if not hook then
		_G[frame:GetName().."Text"]:Show()
		
		if frame.owner and frame.owner.button and GetMouseFocus() ~= frame.owner.button then
			frame.owner.button:SetAlpha(1)
		end
		if frame.conversationIcon then
			frame.conversationIcon:Show()
		end
	elseif GetMouseFocus() ~= frame then
		_G[frame:GetName().."Text"]:Hide()

		if frame.owner and frame.owner.button and GetMouseFocus() ~= frame.owner.button then
			frame.owner.button:SetAlpha(1)
		end
		
		if frame.conversationIcon then 
			frame.conversationIcon:Hide()
		end
	end
end

function MOD:ConfigChatFrame(chat)
	local chatName = chat:GetName()
	local textType = {"", "Selected", "Highlight"}
	local font = LSM:Fetch("font", MOD.db.font);
	local fontOutline = MOD.db.fontOutline;
	local tabFont = LSM:Fetch("font", MOD.db.tabFont);
	local tabFontSize = MOD.db.tabFontSize;
	local tabFontOutline = MOD.db.tabFontOutline;
	local tabWidth,tabHeight = MOD.db.tabWidth,MOD.db.tabHeight
	local id = chat:GetID();
	local _, chatFontSize = FCF_GetChatWindowInfo(id);
	chat:SetFont(font, chatFontSize, fontOutline)
	_G[chatName.."TabText"]:SetFontTemplate(tabFont, tabFontSize, tabFontOutline)
	if chat.styled then return end;
	chat:SetFrameLevel(4)
	local chatID = chat:GetID()
	-------------------------------------------
	local tab = _G[chatName.."Tab"]
	for _, i in pairs(textType)do 
		_G[tab:GetName()..i .."Left"]:SetTexture(nil)
		_G[tab:GetName()..i .."Middle"]:SetTexture(nil)
		_G[tab:GetName()..i .."Right"]:SetTexture(nil)
	end;
	tab.text = _G[chatName.."TabText"]
	tab.text:SetTextColor(1, 1, 1)
	tab.text:SetShadowColor(0, 0, 0)
	tab.text:SetShadowOffset(2, -2)
	tab.text:FillInner(tab)
	tab.text:SetJustifyH("CENTER")
	tab.text:SetJustifyV("MIDDLE")
	hooksecurefunc(tab.text, "SetTextColor", function(this, r, g, b, a)
		local r2, g2, b2 = 1, 1, 1;
		if r ~= r2 or g ~= g2 or b ~= b2 then 
			this:SetTextColor(r2, g2, b2)
			this:SetShadowColor(0, 0, 0)
			this:SetShadowOffset(2, -2)
		end 
	end)
	if tab.conversationIcon then 
		tab.conversationIcon:ClearAllPoints()
		tab.conversationIcon:Point("RIGHT", tab.text, "LEFT", -1, 0)
	end;
	if(MOD.db.tabStyled and not tab.IsStyled) then
		local arg3 = (chat.inUse or chat.isDocked or chat.isTemporary)
		MOD:CreateCustomTab(tab, chatID, arg3)
	else
		tab:SetHeight(tabHeight)
		tab:SetWidth(tabWidth)
		tab.SetWidth = function()return end;
	end
	-------------------------------------------
	local editBox = _G[chatName.."EditBox"]
	chat:SetClampRectInsets(0, 0, 0, 0)
	chat:SetClampedToScreen(false)
	chat:Formula409(true)
	_G[chatName.."ButtonFrame"]:MUNG()
	local ebPoint1, ebPoint2, ebPoint3 = select(6, editBox:GetRegions())
	ebPoint1:MUNG()
	ebPoint2:MUNG()
	ebPoint3:MUNG()
	_G[format(editBox:GetName().."FocusLeft", chatID)]:MUNG()
	_G[format(editBox:GetName().."FocusMid", chatID)]:MUNG()
	_G[format(editBox:GetName().."FocusRight", chatID)]:MUNG()
	editBox:SetFixedPanelTemplate("Button", true)
	editBox:SetAltArrowKeyMode(false)
	
	editBox:SetAllPoints(SuperDockAlertLeft)

	editBox:HookScript("OnEditFocusGained", function(this)
		this:Show()
		if not LeftSuperDock:IsShown()then 
			LeftSuperDock.editboxforced = true;
			LeftSuperDockToggleButton:GetScript("OnEnter")(LeftSuperDockToggleButton)
		end
		DOCK:DockAlertLeftOpen(this)
	end)
	editBox:HookScript("OnEditFocusLost", function(this)
		if LeftSuperDock.editboxforced then 
			LeftSuperDock.editboxforced = nil;
			if LeftSuperDock:IsShown()then 
				LeftSuperDockToggleButton:GetScript("OnLeave")(LeftSuperDockToggleButton)
			end 
		end;
		this:Hide()
		DOCK:DockAlertLeftClose()
	end)
	editBox:HookScript("OnTextChanged", function(this)
		local text = this:GetText()
		if InCombatLockdown()then 
			local max = 5;
			if len(text) > max then 
				local testText = true;
				for i = 1, max, 1 do 
					if sub(text, 0 - i, 0 - i)  ~= sub(text, -1 - i, -1 - i) then 
						testText = false;
						break 
					end 
				end;
				if testText then 
					this:Hide()
					return 
				end 
			end 
		end;
		if text:len() < 5 then 
			if text:sub(1, 4) == "/tt " then 
				local name, realm = UnitName("target")
				if name then 
					name = gsub(name, " ", "")
				end;
				if name and not UnitIsSameServer("player", "target") then 
					name = name.."-"..gsub(realm, " ", "")
				end;
				ChatFrame_SendTell(name or L["Invalid Target"], ChatFrame1)
			end;
			if text:sub(1, 4) == "/gr " then 
				this:SetText(MOD:GetGroupDistribution()..text:sub(5))
				ChatEdit_ParseText(this, 0)
			end 
		end;
		local result, ct = gsub(text, "|Kf(%S+)|k(%S+)%s(%S+)|k", "%2 %3")
		if ct > 0 then 
			result = result:gsub("|", "")
			this:SetText(result)
		end 
	end)
	hooksecurefunc("ChatEdit_UpdateHeader", function()
		local attrib = editBox:GetAttribute("chatType")
		if attrib == "CHANNEL" then 
			local channel = GetChannelName(editBox:GetAttribute("channelTarget"))
			if channel == 0 then 
				editBox:SetBackdropBorderColor(unpack(SuperVillain.Colors.dark))
			else 
				editBox:SetBackdropBorderColor(ChatTypeInfo[attrib..channel].r, ChatTypeInfo[attrib..channel].g, ChatTypeInfo[attrib..channel].b)
			end 
		elseif attrib then 
			editBox:SetBackdropBorderColor(ChatTypeInfo[attrib].r, ChatTypeInfo[attrib].g, ChatTypeInfo[attrib].b)
		end 
	end)
	MaxChatID = chatID;
	chat.styled = true 
end;

function MOD:ModifyChatFrames(...)
	for _, name in pairs(CHAT_FRAMES) do
		local chat = _G[name]
		if (chat and not chat.skinApplied) then
			local id = chat:GetID();
			local _, fontSize = FCF_GetChatWindowInfo(id);
			local CHAT_TEXT_FONT = LSM:Fetch("font", MOD.db.font);
			local CHAT_TEXT_OUTLINE = MOD.db.fontOutline;
			MOD:ConfigChatFrame(chat)
			chat:SetFont(CHAT_TEXT_FONT, fontSize, CHAT_TEXT_OUTLINE)
			if CHAT_TEXT_OUTLINE ~= 'NONE' then
				chat:SetShadowColor(0, 0, 0, 0.2)
			else
				chat:SetShadowColor(0, 0, 0, 1)
			end
			chat:SetShadowOffset(1, -1)
			chat:SetTimeVisible(100)	
			chat:SetFading(MOD.db.fade)
			chat:SetScript("OnHyperlinkClick", URLChatFrame_OnHyperlinkShow)
			chat:SetScript("OnMouseWheel", ChatFrame_OnMouseScroll)
			hooksecurefunc(chat, "SetScript", function(f, script, func)
				if script == "OnMouseWheel" and func ~= ChatFrame_OnMouseScroll then
					f:SetScript(script, ChatFrame_OnMouseScroll)
				end
			end)
			chat.skinApplied = true
		end
	end
	MOD:RefreshChatFrames(true)
	if not MOD.HookSecured then
		MOD:SecureHook('FCF_OpenTemporaryWindow', 'ModifyChatFrames')
		MOD.HookSecured = true;
	end
end

function MOD:RefreshChatFonts(dropDown, chatFrame, fontSize)
	if ( not chatFrame ) then
		chatFrame = FCF_GetCurrentChatFrame();
	end
	if ( not fontSize ) then
		fontSize = dropDown and dropDown.value or SuperVillain.db.common.fontSize or 12;
	end
	local editBox = _G[chatFrame:GetName().."EditBox"]
	chatFrame:SetFont(LSM:Fetch("font", MOD.db.font), fontSize, MOD.db.fontOutline)
	if MOD.db.fontOutline ~= 'NONE' then
		chatFrame:SetShadowColor(0, 0, 0, 0.2)
	else
		chatFrame:SetShadowColor(0, 0, 0, 1)
	end
	chatFrame:SetShadowOffset(1, -1)
	MOD:ModifyChatFrames()
end

function MOD:RefreshChatFrames(forced)
	if (not SuperVillain.protected.SVChat.enable or not MOD.db.clamped or (InCombatLockdown() and not forced and MOD.UpdateLocked) or (IsMouseButtonDown("LeftButton") and not forced)) then 
		return 
	end;
	local dockwidth = (SuperVillain.db.SVDock.dockLeftWidth or 350) - 10;
  	local dockheight = (SuperVillain.db.SVDock.dockLeftHeight or 180) - 15;
	for i,name in pairs(CHAT_FRAMES)do 
		local chat = _G[name]
		local id = chat:GetID() 
		local tab = _G[format("ChatFrame%sTab",i)]

		local font = LSM:Fetch("font", MOD.db.font);
		local fontOutline = MOD.db.fontOutline;
		local tabFont = LSM:Fetch("font", MOD.db.tabFont);
		local tabFontSize = MOD.db.tabFontSize;
		local tabFontOutline = MOD.db.tabFontOutline;
		local tabWidth,tabHeight = MOD.db.tabWidth,MOD.db.tabHeight
		local id = chat:GetID();
		local _, chatFontSize = FCF_GetChatWindowInfo(id);

		chat:SetFont(font, chatFontSize, fontOutline)
		_G[name.."TabText"]:SetFontTemplate(tabFont, tabFontSize, tabFontOutline)
		if fontOutline ~= 'NONE' then
			chat:SetShadowColor(0, 0, 0, 0.2)
		else
			chat:SetShadowColor(0, 0, 0, 1)
		end
		chat:SetShadowOffset(1, -1)
		if not chat.isDocked and chat:IsShown() then 
			chat:SetParent(UIParent)
			if not MOD.db.tabStyled then
				tab.owner = chat;
				tab.isDocked = chat.isDocked;
				tab:SetParent(UIParent)
				MOD:ConfigChatTabs(tab, true)
			else
				tab.owner = chat;
				tab.isDocked = false;
				if(tab.Holder) then
					MOD:RemoveTab(tab.Holder,chat)
				end
			end
		else 
			if id == 1 then
				chat:ClearAllPoints()
				chat:Width(dockwidth - 12)
				chat:Height(dockheight)
				chat:Point("BOTTOMRIGHT",SuperDockWindowLeft,"BOTTOMRIGHT",-6,10)
				FCF_SavePositionAndDimensions(chat)
			end;
			chat:SetParent(SuperDockWindowLeft)
			if not MOD.db.tabStyled then
				tab.owner = chat;
				tab.isDocked = chat.isDocked;
				tab:SetParent(SuperDockChatTabBar)
				MOD:ConfigChatTabs(tab, false)
			else
				tab.owner = chat;
				tab.isDocked = true;
				local arg3 = (chat.inUse or chat.isDocked or chat.isTemporary)
				if(tab.Holder and arg3) then
					MOD:AddTab(tab.Holder,id)
				end
			end
			if chat:IsMovable()then 
				chat:SetUserPlaced(true)
			end 
		end 
	end;
	MOD.UpdateLocked=true 
end;

function MOD:ClearAllThrottling()
	twipe(MOD.MessageCache["list"]); twipe(MOD.MessageCache["count"]); twipe(MOD.MessageCache["time"])
end;

function MOD:OnHyperlinkEnter(frame, refString)
	if InCombatLockdown() then return; end
	local linkToken = refString:match("^([^:]+)")
	if hyperlinkTypes[linkToken] then
		ShowUIPanel(GameTooltip)
		GameTooltip:SetOwner(frame, "ANCHOR_CURSOR")
		GameTooltip:SetHyperlink(refString)
		hyperLinkEntered = frame;
		GameTooltip:Show()
	end
end

function MOD:OnHyperlinkLeave(frame, refString)
	local linkToken = refString:match("^([^:]+)")
	if hyperlinkTypes[linkToken] then
		HideUIPanel(GameTooltip)
		hyperLinkEntered = nil;
	end
end

function MOD:OnMessageScrollChanged(frame)
	if hyperLinkEntered == frame then
		HideUIPanel(GameTooltip)
		hyperLinkEntered = false;
	end
end

function MOD:ToggleHyperlinks(enabled)
	for _, frameName in pairs(CHAT_FRAMES) do
		local frame = _G[frameName]
		if (not self.hooks or not self.hooks[frame] or not self.hooks[frame].OnHyperlinkEnter) then
			if not enabled then
				self:Unhook(frame, 'OnHyperlinkEnter')
				self:Unhook(frame, 'OnHyperlinkLeave')
				self:Unhook(frame, 'OnMessageScrollChanged')
			else
				self:HookScript(frame, 'OnHyperlinkEnter')
				self:HookScript(frame, 'OnHyperlinkLeave')
				self:HookScript(frame, 'OnMessageScrollChanged')
			end
		end
	end
end

function MOD:ChatEdit_OnEnterPressed(input)
	local ctype = input:GetAttribute("chatType");
	local attr = (not MOD.db.sticky) and "SAY" or ctype;
	local chat = input:GetParent();
	if not chat.isTemporary and ChatTypeInfo[ctype].sticky == 1 then
		input:SetAttribute("chatType", attr);
	end
end

function MOD:PET_BATTLE_CLOSE()
	for _, frameName in pairs(CHAT_FRAMES) do
		local frame = _G[frameName]
		if frame and _G[frameName.."Tab"]:GetText():match(PET_BATTLE_COMBAT_LOG) then
			FCF_Close(frame)
		end
	end
end

function MOD:CHAT_MSG_CHANNEL(event, message, author, ...)
	local filter = nil
	if locale == 'enUS' or locale == 'enGB' then
		if strfind(message, '[\227-\237]') then
			filter = true
		end
	end
	if filter then
		return true;
	else
		local blockFlag = false
		local msg = author:upper() .. message;
		if author == UnitName("player") then return MOD.ParseMessage(self, event, message, author, ...) end
		if MOD.MessageCache["list"][msg] and MOD.db.throttleInterval ~= 0 then
			if difftime(time(), MOD.MessageCache["time"][msg]) <= MOD.db.throttleInterval then
				blockFlag = true
			end
		end
		if blockFlag then
			return true;
		else
			if MOD.db.throttleInterval ~= 0 then
				MOD.MessageCache["time"][msg] = time()
			end
			return MOD.ParseMessage(self, event, message, author, ...)
		end
	end
end

function MOD:CHAT_MSG_YELL(event, message, author, ...)
	local filter = nil
	if locale == 'enUS' or locale == 'enGB' then
		if strfind(message, '[\227-\237]') then
			filter = true
		end
	end
	if filter then
		return true;
	else
		local blockFlag = false
		local msg = author:upper() .. message;
		if msg == nil then return MOD.ParseMessage(self, event, message, author, ...) end
		if author == UnitName("player") then return MOD.ParseMessage(self, event, message, author, ...) end
		if MOD.MessageCache["list"][msg] and MOD.MessageCache["count"][msg] > 1 and MOD.db.throttleInterval ~= 0 then
			if difftime(time(), MOD.MessageCache["time"][msg]) <= MOD.db.throttleInterval then
				blockFlag = true
			end
		end
		if blockFlag then
			return true;
		else
			if MOD.db.throttleInterval ~= 0 then
				MOD.MessageCache["time"][msg] = time()
			end
			return MOD.ParseMessage(self, event, message, author, ...)
		end
	end
end

function MOD:CHAT_MSG_SAY(event, message, author, ...)
	local filter = nil
	if locale == 'enUS' or locale == 'enGB' then
		if strfind(message, '[\227-\237]') then
			filter = true
		end
	end
	if filter then
		return true;
	else
		return MOD.ParseMessage(self, event, message, author, ...)
	end
end

function MOD:UpdateThisPackage()
	self:RefreshChatFrames(true) 
end;

function MOD:ConstructThisPackage()
	if(not SuperVillain.protected.SVChat.enable) then return end;
	--_G.GeneralDockManager = SuperDockChatTabBar
	self:SecureHook('ChatEdit_OnEnterPressed')
	self:SecureHook('FCF_SetChatWindowFontSize', 'RefreshChatFonts')
	self:RegisterEvent('UPDATE_CHAT_WINDOWS', 'ModifyChatFrames')
	self:RegisterEvent('UPDATE_FLOATING_CHAT_WINDOWS', 'ModifyChatFrames')
	self:RegisterEvent('PET_BATTLE_CLOSE')

	for _,chatName in pairs(CHAT_FRAMES)do 
		local chat = _G[chatName]
		if chat:GetID() ~= 2 then
			chat.TempAddMessage = chat.AddMessage;
			chat.AddMessage = ChatAddMessage
		end
		self:ConfigChatFrame(chat)
	end;
	self:RefreshChatFrames(true)

	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", MOD.CHAT_MSG_CHANNEL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", MOD.CHAT_MSG_YELL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", MOD.CHAT_MSG_SAY)

	for _,event in pairs(ParseableEvents) do
		ChatFrame_AddMessageEventFilter(event, MOD.ParseMessage)
	end

	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_INLINE_TOAST_BROADCAST", MOD.ParseMessage);

	_G.GeneralDockManagerOverflowButton:ClearAllPoints()
	_G.GeneralDockManagerOverflowButton:SetPoint('BOTTOMRIGHT', SuperDockChatTabBar, 'BOTTOMRIGHT', -2, 2)
	_G.GeneralDockManagerOverflowButtonList:SetFixedPanelTemplate('Transparent')

	hooksecurefunc(GeneralDockManagerScrollFrame, 'SetPoint', function(self, point, anchor, attachTo, x, y)
		if anchor == GeneralDockManagerOverflowButton and x == 0 and y == 0 then
			self:SetPoint(point, anchor, attachTo, -2, -6)
		end
	end)

	_G.GeneralDockManager:SetAllPoints(SuperDockChatTabBar)
	hooksecurefunc(GeneralDockManager, 'SetPoint', function(self)
		self:SetAllPoints(SuperDockChatTabBar)
	end)
	
	FriendsMicroButton:MUNG()
	ChatFrameMenuButton:MUNG()

	_G.InterfaceOptionsSocialPanelTimestampsButton:SetAlpha(0)
	_G.InterfaceOptionsSocialPanelTimestampsButton:SetScale(0.000001)
	_G.InterfaceOptionsSocialPanelTimestamps:SetAlpha(0)
	_G.InterfaceOptionsSocialPanelTimestamps:SetScale(0.000001)
	_G.InterfaceOptionsSocialPanelChatStyle:EnableMouse(false)
	_G.InterfaceOptionsSocialPanelChatStyleButton:Hide()
	_G.InterfaceOptionsSocialPanelChatStyle:SetAlpha(0)
end;
SuperVillain.Registry:NewPackage(MOD:GetName())
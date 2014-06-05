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
local MOD = SuperVillain:NewModule('SVOverride', 'AceHook-3.0', 'AceTimer-3.0');
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local UIErrorsFrame = UIErrorsFrame;
local interruptMsg = INTERRUPTED.." %s's \124cff71d5ff\124Hspell:%d\124h[%s]\124h\124r!";
--[[ 
########################################################## 
PRE VARS/FUNCTIONS
##########################################################
]]--
local function SetTimerStyle(bar)
	for i=1, bar:GetNumRegions()do 
		local child = select(i, bar:GetRegions())
		if child:GetObjectType() == "Texture"then
			child:SetTexture(nil)
		elseif child:GetObjectType() == "FontString" then 
			child:SetFontTemplate(nil, 12, 'OUTLINE')
		end 
	end;
	bar:SetStatusBarTexture(SuperVillain.Textures.default)
	bar:SetStatusBarColor(unpack(SuperVillain.Colors.highlight))
	local tempBG = CreateFrame("Frame", nil, bar)
	tempBG:WrapOuter(bar)
	if (bar:GetFrameLevel() - 1)  >= 0 then 
		tempBG:SetFrameLevel(bar:GetFrameLevel() - 1)
	else 
		tempBG:SetFrameLevel(0)
	end;
	tempBG:SetFixedPanelTemplate("Transparent")
	tempBG:SetAlpha(1)
end;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
MOD.LewtRollz = {};
function MOD:START_TIMER(event)
	for _,timer in pairs(TimerTracker.timerList)do 
		if timer["bar"] and not timer["bar"].styled then
			SetTimerStyle(timer["bar"])
			timer["bar"].styled = true 
		end 
	end 
end;

function MOD:PLAYER_REGEN_DISABLED()
	UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
end;

function MOD:PLAYER_REGEN_ENABLED()
	UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE") 
end;

function MOD:COMBAT_LOG_EVENT_UNFILTERED(_,_,b,_,n,_,_,_,_,o,_,_,_,_,_,p,q)
	if MOD.db.interruptAnnounce == "NONE" then return end;
	if not(b == "SPELL_INTERRUPT"and n == UnitGUID("player")) then return end;
	local r, s, t = IsInGroup(), IsInRaid(), IsPartyLFG();
	if not r then return end;
	if MOD.db.interruptAnnounce == "PARTY" then
		SendChatMessage(format(interruptMsg, o, p, q), t and "INSTANCE_CHAT" or "PARTY")
	elseif MOD.db.interruptAnnounce == "RAID" then 
		if s then
			SendChatMessage(format(interruptMsg, o, p, q), t and "INSTANCE_CHAT" or "RAID")
		else
			SendChatMessage(format(interruptMsg, o, p, q), t and "INSTANCE_CHAT" or "PARTY")
		end 
	elseif MOD.db.interruptAnnounce == "SAY" then 
		SendChatMessage(format(interruptMsg, o, p, q), "SAY")
	end 
end;

function MOD:UPDATE_WORLD_STATES()
	local cb = _G["WorldStateCaptureBar1"]
	if cb and cb:IsShown() then
		cb:ClearAllPoints()
		cb:SetPoint("TOP", SVUI_WorldStateHolder, "TOP", 0, 0)
		cb:SetParent(SVUI_WorldStateHolder)
	end
	self:UnregisterEvent("UPDATE_WORLD_STATES")
end

function MOD:PVPMessageEnhancement(m, A)
	local m, d = IsInInstance()
	if d == "pvp" or d == "arena" then
		RaidNotice_AddMessage(RaidBossEmoteFrame, A, ChatTypeInfo["RAID_BOSS_EMOTE"])
	end 
end;

function MOD:ForceCVars()
	if not GetCVarBool("lockActionBars") and SuperVillain.protected.SVBar.enable then
		SetCVar("lockActionBars", 1)
	end 
end;

function MOD:ConstructThisPackage()
	HelpOpenTicketButtonTutorial:MUNG()
	TalentMicroButtonAlert:MUNG()
	HelpPlate:MUNG()
	HelpPlateTooltip:MUNG()
	CompanionsMicroButtonAlert:MUNG()

	self:CreateAlertOverride()
	self:SecureHook('AlertFrame_FixAnchors',SuperVillain.PostAlertMove)
	self:SecureHook('AlertFrame_SetLootAnchors')
	self:SecureHook('AlertFrame_SetLootWonAnchors')
	self:SecureHook('AlertFrame_SetMoneyWonAnchors')
	self:SecureHook('AlertFrame_SetAchievementAnchors')
	self:SecureHook('AlertFrame_SetCriteriaAnchors')
	self:SecureHook('AlertFrame_SetChallengeModeAnchors')
	self:SecureHook('AlertFrame_SetDungeonCompletionAnchors')
	self:SecureHook('AlertFrame_SetScenarioAnchors')
	self:SecureHook('AlertFrame_SetGuildChallengeAnchors')
	self:SecureHook('AlertFrame_SetStorePurchaseAnchors')

	UIPARENT_MANAGED_FRAME_POSITIONS["GroupLootContainer"] = nil;

	DurabilityFrame:SetFrameStrata("HIGH")
	hooksecurefunc(DurabilityFrame, "SetPoint", function(_, _, anchor)
		if anchor == "MinimapCluster"or anchor == _G["MinimapCluster"] then
			DurabilityFrame:ClearAllPoints()
			DurabilityFrame:Point("RIGHT", Minimap, "RIGHT")
			DurabilityFrame:SetScale(0.6)
		end 
	end)

	TicketStatusFrame:ClearAllPoints()
	TicketStatusFrame:SetPoint("TOPLEFT",SuperVillain.UIParent,'TOPLEFT',250,-5)
	SuperVillain:SetSVMovable(TicketStatusFrame,"GM_MOVE",L["GM Ticket Frame"])

	HelpOpenTicketButton:SetParent(Minimap)
	HelpOpenTicketButton:ClearAllPoints()
	HelpOpenTicketButton:SetPoint("TOPRIGHT",Minimap,"TOPRIGHT")

	hooksecurefunc(VehicleSeatIndicator,"SetPoint",function(a,a,b)
		if b=="MinimapCluster"or b==_G["MinimapCluster"]then 
			VehicleSeatIndicator:ClearAllPoints()
			if VehicleSeat_MOVE then 
				VehicleSeatIndicator:Point("TOPLEFT",VehicleSeat_MOVE,"TOPLEFT",0,0)
			else 
				VehicleSeatIndicator:Point("TOPLEFT",SuperVillain.UIParent,"TOPLEFT",22,-45)
				SuperVillain:SetSVMovable(VehicleSeatIndicator,"VehicleSeat_MOVE",L["Vehicle Seat Frame"])
			end;
			VehicleSeatIndicator:SetScale(0.8)
		end 
	end)
	VehicleSeatIndicator:SetPoint('TOPLEFT',MinimapCluster,'TOPLEFT',2,2)

	local altPower=CreateFrame('Frame','AltPowerBarHolder',UIParent)
	altPower:SetPoint('TOP',SuperVillain.UIParent,'TOP',0,-18)
	altPower:Size(128,50)
	PlayerPowerBarAlt:ClearAllPoints()
	PlayerPowerBarAlt:SetPoint('CENTER',altPower,'CENTER')
	PlayerPowerBarAlt:SetParent(altPower)
	PlayerPowerBarAlt.ignoreFramePositionManager=true;
	SuperVillain:SetSVMovable(altPower,'AltPowerBar_MOVE',L['Alternative Power'])
	
	LootFrame:UnregisterAllEvents();
	
	self:ConfigLootFrame();

	function _G.GroupLootDropDown_GiveLoot(this)
		if lastQuality >= MASTER_LOOT_THREHOLD then 
			local confirmed = SuperVillain:StaticPopup_Show("CONFIRM_LOOT_DISTRIBUTION",ITEM_QUALITY_COLORS[lastQuality].hex..lastName..FONT_COLOR_CODE_CLOSE,this:GetText());
			if confirmed then confirmed.data = this.value end 
		else 
			GiveMasterLoot(lastID, this.value)
		end;
		CloseDropDownMenus()
		SuperVillain.SystemAlert["CONFIRM_LOOT_DISTRIBUTION"].OnAccept = function(this,index) GiveMasterLoot(lastID,index) end;
	end;

	tinsert(UISpecialFrames,'SVUI_LootFrame');

	UIParent:UnregisterEvent('MIRROR_TIMER_START')
	UIParent:UnregisterEvent('LOOT_BIND_CONFIRM')
	UIParent:UnregisterEvent('CONFIRM_DISENCHANT_ROLL')
	UIParent:UnregisterEvent('CONFIRM_LOOT_ROLL')

	self:RegisterEvent('MIRROR_TIMER_START')
	self:RegisterEvent('MIRROR_TIMER_STOP')
	self:RegisterEvent('MIRROR_TIMER_PAUSE')
	self:RegisterEvent('START_TIMER')

	if(SuperVillain.protected.common.hideErrorFrame) then
		self:RegisterEvent('PLAYER_REGEN_DISABLED')
		self:RegisterEvent('PLAYER_REGEN_ENABLED')
	end

	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent('CHAT_MSG_BG_SYSTEM_HORDE','PVPMessageEnhancement')
	self:RegisterEvent('CHAT_MSG_BG_SYSTEM_ALLIANCE','PVPMessageEnhancement')
	self:RegisterEvent('CHAT_MSG_BG_SYSTEM_NEUTRAL','PVPMessageEnhancement')
	self:RegisterEvent('CONFIRM_DISENCHANT_ROLL', 'AutoConfirmLoot')
	self:RegisterEvent('CONFIRM_LOOT_ROLL', 'AutoConfirmLoot')
	self:RegisterEvent('LOOT_BIND_CONFIRM', 'AutoConfirmLoot')
	self:RegisterEvent("LOOT_OPENED");
	self:RegisterEvent("LOOT_SLOT_CLEARED");
	self:RegisterEvent("LOOT_CLOSED");
	self:RegisterEvent("OPEN_MASTER_LOOT_LIST");
	self:RegisterEvent("UPDATE_MASTER_LOOT_LIST");
	self:RegisterEvent('CVAR_UPDATE','ForceCVars')
	self:RegisterEvent('PLAYER_ENTERING_WORLD')
	self:RegisterEvent('UPDATE_WORLD_STATES')

	if SuperVillain.protected.SVOverride.lootRoll then 
		self:RegisterEvent('LOOT_HISTORY_ROLL_CHANGED');
		self:RegisterEvent("START_LOOT_ROLL");
		UIParent:UnregisterEvent("START_LOOT_ROLL");
		UIParent:UnregisterEvent("CANCEL_LOOT_ROLL");
	end;

	SuperVillain:SetSVMovable(LossOfControlFrame,'LossOfControlFrame_MOVE',L['Loss Control Icon']);

	local wsc = CreateFrame("Frame", "SVUI_WorldStateHolder", SuperVillain.UIParent)
	wsc:SetSize(200,20)
	wsc:SetPoint("TOP", SuperVillain.UIParent, "TOP", 0, -60)
	SuperVillain:SetSVMovable(wsc, 'SVUI_WorldStateHolder_MOVE', L['Capture Bars'])
end;
SuperVillain.Registry:NewPackage(MOD:GetName());
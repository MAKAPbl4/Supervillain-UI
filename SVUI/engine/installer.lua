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
local type 		= _G.type;
local string 	= _G.string;
local math 		= _G.math;
local table     = _G.table;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ MATH METHODS ]]--
local random = math.random;
local tcopy = table.copy;
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
local CURRENT_PAGE, MAX_PAGE, XOFF = 0, 8, (GetScreenWidth() * 0.025)
local okToResetMOVE=false
local SVUI_ConfigAlert;
local mungs = false;
local user_music_vol;
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function rng()
	local x,y = random(10,70), random(10,70)
	return x,y
end;

local function SetConfigAlertAnim(f)
	local x = x or 50;
	local y = y or 150;
	f.trans = f:CreateAnimationGroup()
	f.trans[1] = f.trans:CreateAnimation("Translation")
	f.trans[1]:SetOrder(1)
	f.trans[1]:SetDuration(0.3)
	f.trans[1]:SetOffset(x,y)
	f.trans[1]:SetScript("OnPlay",function()f:SetScale(0.01)f:SetAlpha(1)end)
	f.trans[1]:SetScript("OnUpdate",function(self)f:SetScale(0.1+(1*f.trans[1]:GetProgress()))end)
	f.trans[2] = f.trans:CreateAnimation("Translation")
	f.trans[2]:SetOrder(2)
	f.trans[2]:SetDuration(0.7)
	f.trans[2]:SetOffset(x*.5,y*.5)
	f.trans[3] = f.trans:CreateAnimation("Translation")
	f.trans[3]:SetOrder(3)
	f.trans[3]:SetDuration(0.1)
	f.trans[3]:SetOffset(0,0)
	f.trans[3]:SetScript("OnStop",function()f:SetAlpha(0)end)
	f.trans:SetScript("OnFinished",f.trans[3]:GetScript("OnStop"))
end;

local function PopAlert()
	if not SVUI_ConfigAlert then return end;
	local x,y = rng()
	if(SVUI_ConfigAlert:IsShown()) then
		SVUI_ConfigAlert:Hide()
	end
	SVUI_ConfigAlert:Show()
	SVUI_ConfigAlert.bg.anim:Play()
	SVUI_ConfigAlert.bg.trans[1]:SetOffset(x,y)
	SVUI_ConfigAlert.fg.trans[1]:SetOffset(x,y)
	SVUI_ConfigAlert.bg.trans[2]:SetOffset(x*.5,y*.5)
	SVUI_ConfigAlert.fg.trans[2]:SetOffset(x*.5,y*.5)
	SVUI_ConfigAlert.bg.trans:Play()
	SVUI_ConfigAlert.fg.trans:Play()
		
	PlaySoundFile("Sound\\Interface\\uCharacterSheetOpen.wav")
end

local function CopyLayout(saved, preset)
	if(type(saved) == "string") then
		if(not SuperVillain.db[saved]) then return; end
		local tmp = saved
		saved = SuperVillain.db[tmp]
	end

    if(type(saved) == "table" and type(preset) == 'table') then 
        for key,val in pairs(preset) do
        	if(saved[key] ~= nil) then
        		if(type(val) == "table") then
        			CopyLayout(saved[key], val)
        		else
	            	saved[key] = val
	            end
            end 
        end 
    end;
end

local function SetInstallButton(button)
    if(not button) then return end;
    button.Left:SetAlpha(0)
    button.Middle:SetAlpha(0)
    button.Right:SetAlpha(0)
    button:SetNormalTexture("")
    button:SetPushedTexture("")
    button:SetPushedTexture("")
    button:SetDisabledTexture("")
    button:Formula409()
    button:SetFrameLevel(button:GetFrameLevel() + 1)
end;

local function forceCVars()
	SetCVar("alternateResourceText",1)
	SetCVar("statusTextDisplay","BOTH")
	SetCVar("mapQuestDifficulty",1)
	SetCVar("ShowClassColorInNameplate",1)
	SetCVar("screenshotQuality",10)
	SetCVar("chatMouseScroll",1)
	SetCVar("chatStyle","classic")
	SetCVar("WholeChatWindowClickable",0)
	SetCVar("ConversationMode","inline")
	SetCVar("showTutorials",0)
	SetCVar("UberTooltips",1)
	SetCVar("threatWarning",3)
	SetCVar('alwaysShowActionBars',1)
	SetCVar('lockActionBars',1)
	SetCVar('SpamFilter',0)
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:SetValue('SHIFT')
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:RefreshValue()
end;

local function BarShuffle()
	local bar2=SuperVillain.db.SVBar.Bar2.enable;
	local base=30;
	local bS=SuperVillain.db.SVBar.Bar1.buttonspacing;
	local tH=SuperVillain.db.SVBar.Bar1.buttonsize + base;
	local b2h=bar2 and tH or base;
	local sph=(400 - b2h);
	SuperVillain.db.SVBar.Bar1.heightMult=1
	if not SuperVillain.db.moveables then SuperVillain.db.moveables = {} end
	SuperVillain.db.moveables.SVUI_SpecialAbility_MOVE="BOTTOMSVUIParentBOTTOM0"..sph;
	SuperVillain.db.moveables.SVUI_ActionBar2_MOVE="BOTTOMSVUI_ActionBar1TOP0-1";
	SuperVillain.db.moveables.SVUI_ActionBar3_MOVE="BOTTOMRIGHTSVUI_ActionBar1BOTTOMLEFT-40";
	SuperVillain.db.moveables.SVUI_ActionBar5_MOVE="BOTTOMLEFTSVUI_ActionBar1BOTTOMRIGHT40";
	if bar2 then
		SuperVillain.db.moveables.SVUI_PetActionBar_MOVE="BOTTOMLEFTSVUI_ActionBar2TOPLEFT02"
		SuperVillain.db.moveables.SVUI_StanceBar_MOVE="BOTTOMRIGHTSVUI_ActionBar2TOPRIGHT02";
	else
		SuperVillain.db.moveables.SVUI_PetActionBar_MOVE="BOTTOMLEFTSVUI_ActionBar1TOPLEFT02"
		SuperVillain.db.moveables.SVUI_StanceBar_MOVE="BOTTOMRIGHTSVUI_ActionBar1TOPRIGHT02";
	end
end;

local function UFMoveBottomQuadrant(toggle)
	if not SuperVillain.db.moveables then SuperVillain.db.moveables = {} end
	if not toggle then
		SuperVillain.db.moveables.SVUI_Player_MOVE="BOTTOMSVUIParentBOTTOM-278182"
		SuperVillain.db.moveables.SVUI_PlayerCastbar_MOVE="BOTTOMSVUIParentBOTTOM-278122"
		SuperVillain.db.moveables.SVUI_Target_MOVE="BOTTOMSVUIParentBOTTOM278182"
		SuperVillain.db.moveables.SVUI_TargetCastbar_MOVE="BOTTOMSVUIParentBOTTOM278122"
		SuperVillain.db.moveables.SVUI_Pet_MOVE="BOTTOMSVUIParentBOTTOM0182"
		SuperVillain.db.moveables.SVUI_TargetTarget_MOVE="BOTTOMSVUIParentBOTTOM0225"
		SuperVillain.db.moveables.SVUI_Focus_MOVE="BOTTOMSVUIParentBOTTOM310432"
		SuperVillain.db.moveables.SVUI_ThreatBar_MOVE = "BOTTOMRIGHTSVUIParentBOTTOMRIGHT-495182"
	elseif toggle=="shift" then
		SuperVillain.db.moveables.SVUI_Player_MOVE="BOTTOMSVUIParentBOTTOM-278210"
		SuperVillain.db.moveables.SVUI_PlayerCastbar_MOVE="BOTTOMSVUIParentBOTTOM-278150"
		SuperVillain.db.moveables.SVUI_Target_MOVE="BOTTOMSVUIParentBOTTOM278210"
		SuperVillain.db.moveables.SVUI_TargetCastbar_MOVE="BOTTOMSVUIParentBOTTOM278150"
		SuperVillain.db.moveables.SVUI_Pet_MOVE="BOTTOMSVUIParentBOTTOM0210"
		SuperVillain.db.moveables.SVUI_TargetTarget_MOVE="BOTTOMSVUIParentBOTTOM0253"
		SuperVillain.db.moveables.SVUI_Focus_MOVE="BOTTOMSVUIParentBOTTOM310432"
		SuperVillain.db.moveables.SVUI_ThreatBar_MOVE = "BOTTOMRIGHTSVUIParentBOTTOMRIGHT-495210"
	else
		local c=136;
		local d=135;
		local e=80;
		SuperVillain.db.moveables.SVUI_Player_MOVE="BOTTOMSVUIParentBOTTOM"..-c..""..d;
		SuperVillain.db.moveables.SVUI_PlayerCastbar_MOVE="BOTTOMSVUIParentBOTTOM"..-c..""..(d-60);
		SuperVillain.db.moveables.SVUI_Target_MOVE="BOTTOMSVUIParentBOTTOM"..c..""..d;
		SuperVillain.db.moveables.SVUI_TargetCastbar_MOVE="BOTTOMSVUIParentBOTTOM"..c..""..(d-60);
		SuperVillain.db.moveables.SVUI_Pet_MOVE="BOTTOMSVUIParentBOTTOM"..-c..""..e;
		SuperVillain.db.moveables.SVUI_TargetTarget_MOVE="BOTTOMSVUIParentBOTTOM"..c..""..e;
		SuperVillain.db.moveables.SVUI_Focus_MOVE="BOTTOMSVUIParentBOTTOM"..c..""..(d+150);
		SuperVillain.db.moveables.SVUI_ThreatBar_MOVE = "BOTTOMRIGHTSVUIParentBOTTOMRIGHT-495"..d;
	end
end;

local function UFMoveLeftQuadrant(toggle)
	if not SuperVillain.db.moveables then SuperVillain.db.moveables = {} end
	if not toggle then
		SuperVillain.db.moveables.SVUI_Assist_MOVE = "TOPLEFTSVUIParentTOPLEFT"..XOFF.."-250"
		SuperVillain.db.moveables.SVUI_Tank_MOVE = "TOPLEFTSVUIParentTOPLEFT"..XOFF.."-175"
		SuperVillain.db.moveables.SVUI_Raidpet_MOVE = "TOPLEFTSVUIParentTOPLEFT"..XOFF.."-325"
		SuperVillain.db.moveables.SVUI_Party_MOVE = "BOTTOMLEFTSVUIParentBOTTOMLEFT"..XOFF.."400"
		SuperVillain.db.moveables.SVUI_Raid10_MOVE = "BOTTOMLEFTSVUIParentBOTTOMLEFT"..XOFF.."400"
		SuperVillain.db.moveables.SVUI_Raid25_MOVE = "BOTTOMLEFTSVUIParentBOTTOMLEFT"..XOFF.."400"
		SuperVillain.db.moveables.SVUI_Raid40_MOVE = "BOTTOMLEFTSVUIParentBOTTOMLEFT"..XOFF.."400"
	else
		SuperVillain.db.moveables.SVUI_Assist_MOVE = "TOPLEFTSVUIParentTOPLEFT4-250"
		SuperVillain.db.moveables.SVUI_Tank_MOVE = "TOPLEFTSVUIParentTOPLEFT4-175"
		SuperVillain.db.moveables.SVUI_Raidpet_MOVE = "TOPLEFTSVUIParentTOPLEFT4-325"
		SuperVillain.db.moveables.SVUI_Party_MOVE = "BOTTOMLEFTSVUIParentBOTTOMLEFT4300"
		SuperVillain.db.moveables.SVUI_Raid40_MOVE = "BOTTOMLEFTSVUIParentBOTTOMLEFT4300"
		SuperVillain.db.moveables.SVUI_Raid10_MOVE = "BOTTOMLEFTSVUIParentBOTTOMLEFT4300"
		SuperVillain.db.moveables.SVUI_Raid25_MOVE = "BOTTOMLEFTSVUIParentBOTTOMLEFT4300"
	end
end;

local function UFMoveTopQuadrant(toggle)
	if not SuperVillain.db.moveables then SuperVillain.db.moveables = {} end
	if not toggle then
		SuperVillain.db.moveables.GM_MOVE="TOPLEFTSVUIParentTOPLEFT250-25"
		SuperVillain.db.moveables.LootFrame_MOVE="BOTTOMSVUIParentBOTTOM0350"
		SuperVillain.db.moveables.AltPowerBar_MOVE="TOPSVUIParentTOP0-40"
		SuperVillain.db.moveables.LossOfControlFrame_MOVE="BOTTOMSVUIParentBOTTOM0350"
		SuperVillain.db.moveables.BNET_MOVE="TOPRIGHTSVUIParentTOPRIGHT-4-250"
	else
		SuperVillain.db.moveables.GM_MOVE="TOPLEFTSVUIParentTOPLEFT344-25"
		SuperVillain.db.moveables.LootFrame_MOVE="BOTTOMSVUIParentBOTTOM0254"
		SuperVillain.db.moveables.AltPowerBar_MOVE="TOPSVUIParentTOP0-39"
		SuperVillain.db.moveables.LossOfControlFrame_MOVE="BOTTOMSVUIParentBOTTOM0443"
		SuperVillain.db.moveables.BNET_MOVE="TOPRIGHTSVUIParentTOPRIGHT-4-248"
	end
end;

local function UFMoveRightQuadrant(toggle)
	if not SuperVillain.db.moveables then SuperVillain.db.moveables = {} end
	local dH=SuperVillain.db.SVDock.dockRightHeight + 60
	if not toggle or toggle=="high" then
		SuperVillain.db.moveables.SVUI_BossHolder_MOVE="RIGHTSVUIParentRIGHT-1050"
		SuperVillain.db.moveables.SVUI_ArenaHolder_MOVE="RIGHTSVUIParentRIGHT-1050"
		SuperVillain.db.moveables.Tooltip_MOVE="BOTTOMRIGHTSVUIParentBOTTOMRIGHT-284"..dH;
	else
		SuperVillain.db.moveables.SVUI_BossHolder_MOVE="RIGHTSVUIParentRIGHT-1050"
		SuperVillain.db.moveables.SVUI_ArenaHolder_MOVE="RIGHTSVUIParentRIGHT-1050"
		SuperVillain.db.moveables.Tooltip_MOVE="BOTTOMRIGHTSVUIParentBOTTOMRIGHT-284"..dH;
	end
end;

local function initChat(mungs)
	forceCVars()
	FCF_ResetChatWindows()
	FCF_SetLocked(ChatFrame1,1)
	FCF_DockFrame(ChatFrame2)
	FCF_SetLocked(ChatFrame2,1)
	FCF_OpenNewWindow(LOOT)
	FCF_DockFrame(ChatFrame3)
	FCF_SetLocked(ChatFrame3,1)
	for i=1, NUM_CHAT_WINDOWS do
		local chat = _G["ChatFrame"..i]
		local chatID = chat:GetID()
		if i==1 then 
			chat:ClearAllPoints()
			chat:Point("BOTTOMLEFT", LeftSuperDock, "BOTTOMLEFT", 5, 5)
			chat:Point("TOPRIGHT", LeftSuperDock, "TOPRIGHT", -5, -10)
		end;
		FCF_SavePositionAndDimensions(chat)
		FCF_StopDragging(chat)
		FCF_SetChatWindowFontSize(nil, chat, 12)
		if i==1 then 
			FCF_SetWindowName(chat, GENERAL)
		elseif i==2 then 
			FCF_SetWindowName(chat, GUILD_EVENT_LOG)
		elseif i==3 then 
			FCF_SetWindowName(chat, LOOT)
		end 
	end;
	ChatFrame_RemoveAllMessageGroups(ChatFrame1)
	ChatFrame_AddMessageGroup(ChatFrame1,"SAY")
	ChatFrame_AddMessageGroup(ChatFrame1,"EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1,"YELL")
	ChatFrame_AddMessageGroup(ChatFrame1,"GUILD")
	ChatFrame_AddMessageGroup(ChatFrame1,"OFFICER")
	ChatFrame_AddMessageGroup(ChatFrame1,"GUILD_ACHIEVEMENT")
	ChatFrame_AddMessageGroup(ChatFrame1,"WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1,"MONSTER_SAY")
	ChatFrame_AddMessageGroup(ChatFrame1,"MONSTER_EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1,"MONSTER_YELL")
	ChatFrame_AddMessageGroup(ChatFrame1,"MONSTER_BOSS_EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1,"PARTY")
	ChatFrame_AddMessageGroup(ChatFrame1,"PARTY_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1,"RAID")
	ChatFrame_AddMessageGroup(ChatFrame1,"RAID_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1,"RAID_WARNING")
	ChatFrame_AddMessageGroup(ChatFrame1,"INSTANCE_CHAT")
	ChatFrame_AddMessageGroup(ChatFrame1,"INSTANCE_CHAT_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1,"BATTLEGROUND")
	ChatFrame_AddMessageGroup(ChatFrame1,"BATTLEGROUND_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1,"BG_HORDE")
	ChatFrame_AddMessageGroup(ChatFrame1,"BG_ALLIANCE")
	ChatFrame_AddMessageGroup(ChatFrame1,"BG_NEUTRAL")
	ChatFrame_AddMessageGroup(ChatFrame1,"SYSTEM")
	ChatFrame_AddMessageGroup(ChatFrame1,"ERRORS")
	ChatFrame_AddMessageGroup(ChatFrame1,"AFK")
	ChatFrame_AddMessageGroup(ChatFrame1,"DND")
	ChatFrame_AddMessageGroup(ChatFrame1,"IGNORED")
	ChatFrame_AddMessageGroup(ChatFrame1,"ACHIEVEMENT")
	ChatFrame_AddMessageGroup(ChatFrame1,"BN_WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1,"BN_CONVERSATION")
	ChatFrame_AddMessageGroup(ChatFrame1,"BN_INLINE_TOAST_ALERT")
	ChatFrame_AddMessageGroup(ChatFrame1,"COMBAT_FACTION_CHANGE")
	ChatFrame_AddMessageGroup(ChatFrame1,"SKILL")
	ChatFrame_AddMessageGroup(ChatFrame1,"LOOT")
	ChatFrame_AddMessageGroup(ChatFrame1,"MONEY")
	ChatFrame_AddMessageGroup(ChatFrame1,"COMBAT_XP_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame1,"COMBAT_HONOR_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame1,"COMBAT_GUILD_XP_GAIN")
	ChatFrame_RemoveAllMessageGroups(ChatFrame3)
	ChatFrame_AddMessageGroup(ChatFrame3,"COMBAT_FACTION_CHANGE")
	ChatFrame_AddMessageGroup(ChatFrame3,"SKILL")
	ChatFrame_AddMessageGroup(ChatFrame3,"LOOT")
	ChatFrame_AddMessageGroup(ChatFrame3,"MONEY")
	ChatFrame_AddMessageGroup(ChatFrame3,"COMBAT_XP_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame3,"COMBAT_HONOR_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame3,"COMBAT_GUILD_XP_GAIN")
	ChatFrame_AddChannel(ChatFrame1,GENERAL)
	ToggleChatColorNamesByClassGroup(true,"SAY")
	ToggleChatColorNamesByClassGroup(true,"EMOTE")
	ToggleChatColorNamesByClassGroup(true,"YELL")
	ToggleChatColorNamesByClassGroup(true,"GUILD")
	ToggleChatColorNamesByClassGroup(true,"OFFICER")
	ToggleChatColorNamesByClassGroup(true,"GUILD_ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true,"ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true,"WHISPER")
	ToggleChatColorNamesByClassGroup(true,"PARTY")
	ToggleChatColorNamesByClassGroup(true,"PARTY_LEADER")
	ToggleChatColorNamesByClassGroup(true,"RAID")
	ToggleChatColorNamesByClassGroup(true,"RAID_LEADER")
	ToggleChatColorNamesByClassGroup(true,"RAID_WARNING")
	ToggleChatColorNamesByClassGroup(true,"BATTLEGROUND")
	ToggleChatColorNamesByClassGroup(true,"BATTLEGROUND_LEADER")
	ToggleChatColorNamesByClassGroup(true,"INSTANCE_CHAT")
	ToggleChatColorNamesByClassGroup(true,"INSTANCE_CHAT_LEADER")
	ToggleChatColorNamesByClassGroup(true,"CHANNEL1")
	ToggleChatColorNamesByClassGroup(true,"CHANNEL2")
	ToggleChatColorNamesByClassGroup(true,"CHANNEL3")
	ToggleChatColorNamesByClassGroup(true,"CHANNEL4")
	ToggleChatColorNamesByClassGroup(true,"CHANNEL5")
	ToggleChatColorNamesByClassGroup(true,"CHANNEL6")
	ToggleChatColorNamesByClassGroup(true,"CHANNEL7")
	ToggleChatColorNamesByClassGroup(true,"CHANNEL8")
	ToggleChatColorNamesByClassGroup(true,"CHANNEL9")
	ToggleChatColorNamesByClassGroup(true,"CHANNEL10")
	ToggleChatColorNamesByClassGroup(true,"CHANNEL11")
	ChangeChatColor("CHANNEL1",195/255,230/255,232/255)
	ChangeChatColor("CHANNEL2",232/255,158/255,121/255)
	ChangeChatColor("CHANNEL3",232/255,228/255,121/255)
	if not mungs then
		if SuperVillain.Chat then 
			SuperVillain.Chat:UpdateThisPackage(true)
			if SuperVillain.db['RightSuperDockFaded']then RightSuperDockToggleButton:Click()end;
			if SuperVillain.db['LeftSuperDockFaded']then LeftSuperDockToggleButton:Click()end 
		end
		PopAlert()
	end
end;
--[[ 
########################################################## 
GLOBAL/MODULE FUNCTIONS
##########################################################
]]--
function SuperVillain:SetUserScreen(rez, preserve)
	if not preserve then
		if okToResetMOVE then 
			SuperVillain:ResetMovables("")
			okToResetMOVE = false;
		end;
		SuperVillain:TableSplice(SuperVillain.db.SVUnit, C.SVUnit)
	end

	if not SuperVillain.db.moveables then SuperVillain.db.moveables = {} end
	if rez == "low" then 
		if not preserve then 
			SuperVillain.db.SVDock.dockLeftWidth = 350;
			SuperVillain.db.SVDock.dockLeftHeight = 180;
			SuperVillain.db.SVDock.dockRightWidth = 350;
			SuperVillain.db.SVDock.dockRightHeight = 180;
			SuperVillain.db.SVAura.wrapAfter = 10
			SuperVillain.db.SVUnit.fontSize = 10;
			SuperVillain.db.SVUnit.player.width = 200;
			SuperVillain.db.SVUnit.player.castbar.width = 200;
			SuperVillain.db.SVUnit.player.classbar.fill = "fill"
			SuperVillain.db.SVUnit.player.health.text_format = "[healthcolor][health:current]"
			SuperVillain.db.SVUnit.target.width = 200;
			SuperVillain.db.SVUnit.target.castbar.width = 200;
			SuperVillain.db.SVUnit.target.health.text_format = "[healthcolor][health:current]"
			SuperVillain.db.SVUnit.pet.power.enable = false;
			SuperVillain.db.SVUnit.pet.width = 200;
			SuperVillain.db.SVUnit.pet.height = 26;
			SuperVillain.db.SVUnit.targettarget.debuffs.enable = false;
			SuperVillain.db.SVUnit.targettarget.power.enable = false;
			SuperVillain.db.SVUnit.targettarget.width = 200;
			SuperVillain.db.SVUnit.targettarget.height = 26;
			SuperVillain.db.SVUnit.boss.width = 200;
			SuperVillain.db.SVUnit.boss.castbar.width = 200;
			SuperVillain.db.SVUnit.arena.width = 200;
			SuperVillain.db.SVUnit.arena.castbar.width = 200 
		end;
		if not mungs then
			UFMoveBottomQuadrant(true)
			UFMoveLeftQuadrant(true)
			UFMoveTopQuadrant(true)
			UFMoveRightQuadrant(true)
		end
		SuperVillain.ghettoMonitor = true 
	else 
		SuperVillain.db.SVDock.dockLeftWidth = C.SVDock.dockLeftWidth;
		SuperVillain.db.SVDock.dockLeftHeight = C.SVDock.dockLeftHeight;
		SuperVillain.db.SVDock.dockRightWidth = C.SVDock.dockRightWidth;
		SuperVillain.db.SVDock.dockRightHeight = C.SVDock.dockRightHeight;
		SuperVillain.db.SVAura.wrapAfter = C.SVAura.wrapAfter;
		if not mungs then
			UFMoveBottomQuadrant()
			UFMoveLeftQuadrant()
			UFMoveTopQuadrant()
			UFMoveRightQuadrant()
		end
		SuperVillain.ghettoMonitor = nil 
	end;

	if not preserve and not mungs then
		BarShuffle()
		SuperVillain:Refresh_SVUI_Config()
		PopAlert()
	end
end;

function SuperVillain:SetColorTheme(style, preserve)
	style = style or "default";

	if not preserve then
		SuperVillain:TableSplice(SuperVillain.db.media, C.media)
	end

	local presets = SuperVillain:GetPresetData("media", style)
	CopyLayout("media", presets)
	SuperVillain.protected.mediastyle = style;

	if(style == "default") then 
		SuperVillain.db.SVUnit.healthclass = true;
	else
		SuperVillain.db.SVUnit.healthclass = false;
	end;
	--SuperVillain:ShowDebug("Installer", "DB", SuperVillain.db.media)
	if not preserve and not mungs then
		SuperVillain:Refresh_SVUI_System(true)
		PopAlert()
	end
end;

function SuperVillain:SetUnitframeLayout(style, preserve)
	style = style or "default";

	if not SuperVillain.db.moveables then SuperVillain.db.moveables = {} end

	if not preserve then
		SuperVillain:TableSplice(SuperVillain.db.SVUnit, C.SVUnit)
		SuperVillain:TableSplice(SuperVillain.db.SVStats, C.SVStats)
		if okToResetMOVE then
			SuperVillain:ResetMovables('')
			okToResetMOVE = false
		end
	end

	local presets = SuperVillain:GetPresetData("units", style)
	CopyLayout("SVUnit", presets)
	SuperVillain.protected.unitstyle = style

	if(SuperVillain.protected.mediastyle == "default") then 
		SuperVillain.db.SVUnit.healthclass = true;
	end;

	if not preserve and not mungs then
		if SuperVillain.protected.barstyle and (SuperVillain.protected.barstyle == "twosmall" or SuperVillain.protected.barstyle == "twobig") then 
			UFMoveBottomQuadrant("shift")
		else
			UFMoveBottomQuadrant()
		end
		SuperVillain:Refresh_SVUI_Config()
		PopAlert()
	end
end;

function SuperVillain:SetupBarLayout(style, preserve)
	style = style or "default";

	if not SuperVillain.db.moveables then SuperVillain.db.moveables={} end;
	if not preserve then 
		SuperVillain:TableSplice(SuperVillain.db.SVBar,C.SVBar)
		if okToResetMOVE then
			SuperVillain:ResetMovables('')
			okToResetMOVE=false
		end
	end;

	local presets = SuperVillain:GetPresetData("bars", style)
	CopyLayout("SVBar", presets)
	SuperVillain.protected.barstyle = style;

	if not preserve and not mungs then
		if(style == 'twosmall' or style == 'twobig') then 
			UFMoveBottomQuadrant("shift")
		else
			UFMoveBottomQuadrant()
		end
		BarShuffle()
		SuperVillain:Refresh_SVUI_Config()
		PopAlert()
	end
end;

function SuperVillain:SetupAuralayout(style, preserve)
	style = style or "default";
	local presets = SuperVillain:GetPresetData("auras", style)
	CopyLayout("SVUnit", presets)
	--SuperVillain:ShowDebug("Installer", style, presets)
	SuperVillain.protected.aurastyle = style;
	if not preserve and not mungs then
		SuperVillain:Refresh_SVUI_Config()
		PopAlert()
	end
end;

local function InstallComplete()
	SuperVillain.protected.install_complete = SuperVillain.version;
	StopMusic()
	SetCVar("Sound_MusicVolume",user_music_vol)
	okToResetMOVE = false;
	ReloadUI()
end;

local function InstallMungsChoice()
	mungs = true;
	okToResetMOVE = false;
	initChat(true);
	SuperVillain:SetUserScreen('high');
	SuperVillain:SetColorTheme();
	SuperVillain.protected.unitstyle = nil;
	SuperVillain:SetUnitframeLayout();
	SuperVillain.protected.barstyle = nil;
	SuperVillain:SetupBarLayout();
	SuperVillain:SetupAuralayout();
	SuperVillain.protected.install_complete = SuperVillain.version;
	StopMusic()
	SetCVar("Sound_MusicVolume",user_music_vol)
	ReloadUI()
end;

local function ResetAll()
	SVUI_InstallNextButton:Disable()
	SVUI_InstallPrevButton:Disable()
	SVUI_InstallOption01Button:Hide()
	SVUI_InstallOption01Button:SetScript("OnClick",nil)
	SVUI_InstallOption01Button:SetText("")
	SVUI_InstallOption02Button:Hide()
	SVUI_InstallOption02Button:SetScript("OnClick",nil)
	SVUI_InstallOption02Button:SetText("")
	SVUI_InstallOption1Button:Hide()
	SVUI_InstallOption1Button:SetScript("OnClick",nil)
	SVUI_InstallOption1Button:SetText("")
	SVUI_InstallOption2Button:Hide()
	SVUI_InstallOption2Button:SetScript('OnClick',nil)
	SVUI_InstallOption2Button:SetText('')
	SVUI_InstallOption3Button:Hide()
	SVUI_InstallOption3Button:SetScript('OnClick',nil)
	SVUI_InstallOption3Button:SetText('')
	SVUI_InstallOption4Button:Hide()
	SVUI_InstallOption4Button:SetScript('OnClick',nil)
	SVUI_InstallOption4Button:SetText('')
	SVUI_SetupHolder.SubTitle:SetText("")
	SVUI_SetupHolder.Desc1:SetText("")
	SVUI_SetupHolder.Desc2:SetText("")
	SVUI_SetupHolder.Desc3:SetText("")
	SVUI_SetupHolder:Size(550,400)
end;

local function SetPage(newPage)
	CURRENT_PAGE=newPage;
	ResetAll()
	InstallStatus.text:SetText(CURRENT_PAGE.." / "..MAX_PAGE)
	local setupFrame=SVUI_SetupHolder;
	if newPage ~= MAX_PAGE then  
		SVUI_InstallNextButton:Enable()
		SVUI_InstallNextButton:Show()
	end;
	if newPage ~= 1 then 
		SVUI_InstallPrevButton:Enable()
		SVUI_InstallPrevButton:Show()
	end;

	--[[
		more useful globalstrings

		CUSTOM 
		SETTINGS 
		DEFAULT 
		DEFAULTS 
		USE 
		UIOPTIONS_MENU 
		LFGWIZARD_TITLE 
		CONTINUE
	]]--

	if newPage==1 then
		SVUI_InstallPrevButton:Disable()
		SVUI_InstallPrevButton:Hide()
		okToResetMOVE=true
		setupFrame.SubTitle:SetText(format(L["This is Supervillain UI version %s!"],SuperVillain.version))
		setupFrame.Desc1:SetText(L["Before I can turn you loose, persuing whatever villainy you feel will advance your professional career... I need to ask some questions and turn a few screws first."])
		setupFrame.Desc2:SetText(L["At any time you can get to the config options by typing the command /sv. For quick changes to frame, bar or color sets, call your henchman by clicking the button on the bottom right of your screen. (Its the one with his stupid face on it)"])
		setupFrame.Desc3:SetText(L["CHOOSE_OR_DIE"])
		SVUI_InstallOption01Button:Show()
		SVUI_InstallOption01Button:SetScript("OnClick",InstallMungsChoice)
		SVUI_InstallOption01Button:SetText(USE.."\n"..DEFAULT.."\n"..SETTINGS)
		SVUI_InstallOption02Button:Show()
		SVUI_InstallOption02Button:SetScript("OnClick",InstallComplete)
		SVUI_InstallOption02Button:SetText(CANCEL.."\n"..SETTINGS)
	elseif newPage==2 then
		setupFrame.SubTitle:SetText(CHAT)
		setupFrame.Desc1:SetText(L["Whether you want to or not, you will be needing a communicator so other villains can either update you on their doings-of-evil or inform you about the MANY abilities of Chuck Norris"])
		setupFrame.Desc2:SetText(L["The chat windows function the same as standard chat windows, you can right click the tabs and drag them, rename them, slap them around, you know... whatever. Clickity-click to setup your chat windows."])
		setupFrame.Desc3:SetText(L["CHOOSE_OR_DIE"])
		SVUI_InstallOption1Button:Show()
		SVUI_InstallOption1Button:SetScript("OnClick",function()
			initChat(false)
		end)
		SVUI_InstallOption1Button:SetText(CHAT_DEFAULTS)
		SetCVar("Sound_MusicVolume",100)
		SetCVar("Sound_EnableMusic",1)
		StopMusic()
		PlayMusic([[Interface\AddOns\SVUI\assets\sounds\SuperVillain.mp3]])
	elseif newPage==3 then
		local rez = GetCVar("gxResolution")
		setupFrame.SubTitle:SetText(RESOLUTION)
		setupFrame.Desc1:SetText(format(L["Your current resolution is %s, this is considered a %s resolution."], rez, (SuperVillain.ghettoMonitor and LOW or HIGH)))
		if SuperVillain.ghettoMonitor then 
			setupFrame.Desc2:SetText(L["This resolution requires that you change some settings to get everything to fit on your screen."].." "..L["Click the button below to resize your chat frames, unitframes, and reposition your actionbars."].." "..L["You may need to further alter these settings depending how low your resolution is."])
			setupFrame.Desc3:SetText(L["CHOOSE_OR_DIE"])
		else 
			setupFrame.Desc2:SetText(L["This resolution doesn't require that you change settings for the UI to fit on your screen."].." "..L["Click the button below to resize your chat frames, unitframes, and reposition your actionbars."].." "..L["This is completely optional."])
			setupFrame.Desc3:SetText(L["CHOOSE_OR_DIE"])
		end;
		SVUI_InstallOption1Button:Show()
		SVUI_InstallOption1Button:SetScript('OnClick',function()
			SuperVillain:SetUserScreen('high')
			SVUI_SetupHolder.Desc1:SetText(L['|cffFF9F00'..HIGH..'!|r'])
			SVUI_SetupHolder.Desc2:SetText(L['So what you think your better than me with your big monitor? HUH?!?!'])
			SVUI_SetupHolder.Desc3:SetText(L['Dont forget whos in charge here! But enjoy the incredible detail.'])
		end)
		SVUI_InstallOption1Button:SetText(HIGH.."\n"..RESOLUTION)
		SVUI_InstallOption2Button:Show()
		SVUI_InstallOption2Button:SetScript('OnClick',function()
			SuperVillain:SetUserScreen('low')
			SVUI_SetupHolder.Desc1:SetText(L['|cffFF9F00'..LOW..'|r'])
			SVUI_SetupHolder.Desc2:SetText(L['Why are you playing this on what I would assume is a calculator display?'])
			SVUI_SetupHolder.Desc3:SetText(L['Enjoy the ONE incredible pixel that fits on this screen.'])
		end)
		SVUI_InstallOption2Button:SetText(LOW.."\n"..RESOLUTION)
	elseif newPage==4 then
		setupFrame.SubTitle:SetText(COLOR.." "..SETTINGS)
		setupFrame.Desc1:SetText(L['Choose a theme layout you wish to use for your initial setup.'])
		setupFrame.Desc2:SetText(L['You can always change fonts and colors of any element of Supervillain UI from the in-game configuration.'])
		setupFrame.Desc3:SetText(L["CHOOSE_OR_DIE"])
		SVUI_InstallOption1Button:Show()
		SVUI_InstallOption1Button:SetScript('OnClick',function()
			SuperVillain:SetColorTheme('kaboom')
			SVUI_SetupHolder.Desc1:SetText(L['|cffFF9F00KABOOOOM!|r'])
			SVUI_SetupHolder.Desc2:SetText(L['This theme tells the world that you are a villain who can put on a show']..CONTINUED)
			SVUI_SetupHolder.Desc3:SetText(CONTINUED..L['or better yet, you ARE the show!'])
		end)
		SVUI_InstallOption1Button:SetText(L["Kaboom!"])
		SVUI_InstallOption2Button:Show()
		SVUI_InstallOption2Button:SetScript('OnClick',function()
			SuperVillain:SetColorTheme('dark')
			SVUI_SetupHolder.Desc1:SetText(L['|cffAF30FFThe Darkest Night|r'])
			SVUI_SetupHolder.Desc2:SetText(L['This theme indicates that you have no interest in wasting time']..CONTINUED)
			SVUI_SetupHolder.Desc3:SetText(CONTINUED..L[' the dying begins NOW!'])
		end)
		SVUI_InstallOption2Button:SetText(L["Darkness"])
		SVUI_InstallOption3Button:Show()
		SVUI_InstallOption3Button:SetScript('OnClick',function()
			SuperVillain:SetColorTheme()
			SVUI_SetupHolder.Desc1:SetText(L['|cffFFFF00'..CLASS_COLORS..'|r'])
			SVUI_SetupHolder.Desc2:SetText(L['This theme is for villains who take pride in their class']..CONTINUED)
			SVUI_SetupHolder.Desc3:SetText(CONTINUED..L[' villains know how to reprezent!'])
		end)
		SVUI_InstallOption3Button:SetText(CLASS_COLORS)
		SVUI_InstallOption4Button:Show()
		SVUI_InstallOption4Button:SetScript('OnClick',function()
			SuperVillain:SetColorTheme('vintage')
			SVUI_SetupHolder.Desc1:SetText(L['|cff00FFFFPlain and Simple|r'])
			SVUI_SetupHolder.Desc2:SetText(L['This theme is for any villain who sticks to their traditions']..CONTINUED)
			SVUI_SetupHolder.Desc3:SetText(CONTINUED..L["you don't need fancyness to kick some ass!"])
		end)
		SVUI_InstallOption4Button:SetText(L["Vintage"])
	elseif newPage==5 then
		setupFrame.SubTitle:SetText(UNITFRAME_LABEL.." "..SETTINGS)
		setupFrame.Desc1:SetText(L["You can now choose what primary unitframe style you wish to use."])
		setupFrame.Desc2:SetText(L["This will change the layout of your unitframes (ie.. Player, Target, Pet, Party, Raid ...etc)."])
		setupFrame.Desc3:SetText(L["CHOOSE_OR_DIE"])
		SVUI_InstallOption1Button:Show()
		SVUI_InstallOption1Button:SetScript('OnClick',function()
			SuperVillain.protected.unitstyle=nil;
			SuperVillain:SetUnitframeLayout('super')
			SVUI_SetupHolder.Desc1:SetText(L['|cff00FFFFLets Do This|r'])
			SVUI_SetupHolder.Desc2:SetText(L['This layout is anything but minimal! Using this is like being at a rock concert']..CONTINUED)
			SVUI_SetupHolder.Desc3:SetText(CONTINUED..L["then annihilating the crowd with frickin lazer beams!"])
		end)
		SVUI_InstallOption1Button:SetText(L['Super'])
		SVUI_InstallOption2Button:Show()
		SVUI_InstallOption2Button:SetScript('OnClick',function()
			SuperVillain.protected.unitstyle=nil;
			SuperVillain:SetUnitframeLayout('simple')
			SVUI_SetupHolder.Desc1:SetText(L['|cff00FFFFSimply Simple|r'])
			SVUI_SetupHolder.Desc2:SetText(L['This layout is for the villain who just wants to get things done!']..CONTINUED)
			SVUI_SetupHolder.Desc3:SetText(CONTINUED..L["but he still wants to see your face before he hits you!"])
		end)
		SVUI_InstallOption2Button:SetText(L['Simple'])
		SVUI_InstallOption3Button:Show()
		SVUI_InstallOption3Button:SetScript('OnClick',function()
			SuperVillain.protected.unitstyle=nil;
			SuperVillain:SetUnitframeLayout('compact')
			SVUI_SetupHolder.Desc1:SetText(L['|cff00FFFFEl Compacto|r'])
			SVUI_SetupHolder.Desc2:SetText(L['Just the necessities so you can see more of the world around you']..CONTINUED)
			SVUI_SetupHolder.Desc3:SetText(CONTINUED..L["you dont need no fanciness getting in the way of world domination do you?"])
		end)
		SVUI_InstallOption3Button:SetText(L['Compact'])
	elseif newPage==6 then
		setupFrame.SubTitle:SetText(ACTIONBAR_LABEL.." "..SETTINGS)
		setupFrame.Desc1:SetText(L["Choose a layout for your action bars."])
		setupFrame.Desc2:SetText(L["Sometimes you need big buttons, sometimes you don't. Your choice here."])
		setupFrame.Desc3:SetText(L["CHOOSE_OR_DIE"])
		SVUI_InstallOption1Button:Show()
		SVUI_InstallOption1Button:SetScript('OnClick',function()
			SuperVillain.protected.barstyle=nil;
			SuperVillain:SetupBarLayout('onesmall')
			SVUI_SetupHolder.Desc1:SetText(L['|cff00FFFFLean And Clean|r'])
			SVUI_SetupHolder.Desc2:SetText(L['Lets keep it slim and deadly, not unlike a ninja sword.'])
			SVUI_SetupHolder.Desc3:SetText(L["You dont ever even look at your bar hardly, so pick this one!"])
		end)
		SVUI_InstallOption1Button:SetText(L['Small Row'])
		SVUI_InstallOption2Button:Show()
		SVUI_InstallOption2Button:SetScript('OnClick',function()
			SuperVillain.protected.barstyle=nil;
			SuperVillain:SetupBarLayout('twosmall')
			SVUI_SetupHolder.Desc1:SetText(L['|cff00FFFFMore For Less|r'])
			SVUI_SetupHolder.Desc2:SetText(L['Granted, you dont REALLY need the buttons due to your hotkey-leetness, you just like watching cooldowns!'])
			SVUI_SetupHolder.Desc3:SetText(L["Sure thing cowboy, your secret is safe with me!"])
		end)
		SVUI_InstallOption2Button:SetText(L['Small X2'])
		SVUI_InstallOption3Button:Show()
		SVUI_InstallOption3Button:SetScript('OnClick',function()
			SuperVillain.protected.barstyle=nil;
			SuperVillain:SetupBarLayout('default')
			SVUI_SetupHolder.Desc1:SetText(L['|cff00FFFFWhat Big Buttons You Have|r'])
			SVUI_SetupHolder.Desc2:SetText(L['The better to PEW-PEW you with my dear!'])
			SVUI_SetupHolder.Desc3:SetText(L["When you have little time for mouse accuracy, choose this set!"])
		end)
		SVUI_InstallOption3Button:SetText(L['Big Row'])
		SVUI_InstallOption4Button:Show()
		SVUI_InstallOption4Button:SetScript('OnClick',function()
			SuperVillain.protected.barstyle=nil;
			SuperVillain:SetupBarLayout('twobig')
			SVUI_SetupHolder.Desc1:SetText(L['|cff00FFFFThe Double Down|r'])
			SVUI_SetupHolder.Desc2:SetText(L['Lets be honest for a moment. Who doesnt like a huge pair in their face?'])
			SVUI_SetupHolder.Desc3:SetText(L["Double your bars then double their size for maximum button goodness!"])
		end)
		SVUI_InstallOption4Button:SetText(L['Big X2'])
	elseif newPage==7 then
		setupFrame.SubTitle:SetText(AURAS.." "..SETTINGS)
		setupFrame.Desc1:SetText(L["Select the type of aura system you want to use with SVUI's unitframes. The \"Icons\" set will display only icons and aurabars won't be used. The \"Bars\" set will display only aurabars and icons won't be used (duh). The \"Vintage\" set will use the original game style and \"The Works!\" set does just what it says.... icons, bars and awesomeness."])
		setupFrame.Desc2:SetText(L["If you have an icon or aurabar that you don't want to display simply hold down shift and right click the icon for it to suffer a painful death."])
		setupFrame.Desc3:SetText(L["CHOOSE_OR_DIE"])

		SVUI_InstallOption1Button:Show()
		SVUI_InstallOption1Button:SetScript('OnClick',function()
			SuperVillain:SetupAuralayout()
		end)
		SVUI_InstallOption1Button:SetText(L['Vintage'])

		SVUI_InstallOption2Button:Show()
		SVUI_InstallOption2Button:SetScript('OnClick',function()
			SuperVillain:SetupAuralayout('icons')
		end)
		SVUI_InstallOption2Button:SetText(L['Icons'])

		SVUI_InstallOption3Button:Show()
		SVUI_InstallOption3Button:SetScript('OnClick',function()
			SuperVillain:SetupAuralayout('bars')
		end)
		SVUI_InstallOption3Button:SetText(L['Bars'])

		SVUI_InstallOption4Button:Show()
		SVUI_InstallOption4Button:SetScript('OnClick',function()
			SuperVillain:SetupAuralayout('theworks')
		end)
		SVUI_InstallOption4Button:SetText(L['The Works!'])

	elseif newPage==8 then
		SVUI_InstallNextButton:Disable()
		SVUI_InstallNextButton:Hide()
		setupFrame.SubTitle:SetText(BASIC_OPTIONS_TOOLTIP..CONTINUED..AUCTION_TIME_LEFT0)
		setupFrame.Desc1:SetText(L["Thats it! All done! Now we just need to hand these choices off to the henchmen so they can get you ready to (..insert evil tasks here..)!"])
		setupFrame.Desc2:SetText(L["Click the button below to reload and get on your way! Good luck villain!"])
		SVUI_InstallOption1Button:Show()
		SVUI_InstallOption1Button:SetScript("OnClick",InstallComplete)
		SVUI_InstallOption1Button:SetText(L["THE_BUTTON_BELOW"])
		SVUI_SetupHolder:Size(550,350)
	end 
end;

local function NextPage()
	if CURRENT_PAGE ~= MAX_PAGE then 
		CURRENT_PAGE = CURRENT_PAGE + 1;
		SetPage(CURRENT_PAGE)
	end 
end;

local function PreviousPage()
	if CURRENT_PAGE ~= 1 then 
		CURRENT_PAGE = CURRENT_PAGE - 1;
		SetPage(CURRENT_PAGE)
	end 
end;

function SuperVillain:ResetInstallation()
	mungs = true;
	okToResetMOVE = false;
	initChat(true);
	SuperVillain.db = SuperVillain.loaded.profile
	SuperVillain:SetUserScreen();

	if SuperVillain.protected.mediastyle then
        SuperVillain:SetColorTheme(SuperVillain.protected.mediastyle)
    else
    	SuperVillain.protected.mediastyle = nil;
    	SuperVillain:SetColorTheme()
    end

    if SuperVillain.protected.unitstyle then 
        SuperVillain:SetUnitframeLayout(SuperVillain.protected.unitstyle)
    else
    	SuperVillain.protected.unitstyle = nil;
    	SuperVillain:SetUnitframeLayout()
    end

    if SuperVillain.protected.barstyle then 
        SuperVillain:SetupBarLayout(SuperVillain.protected.barstyle)
    else
    	SuperVillain.protected.barstyle = nil;
    	SuperVillain:SetupBarLayout()
    end

    if SuperVillain.protected.aurastyle then 
        SuperVillain:SetupAuralayout(SuperVillain.protected.aurastyle)
    else
    	SuperVillain.protected.aurastyle = nil;
    	SuperVillain:SetupAuralayout()
    end

	SuperVillain.protected.install_complete = SuperVillain.version;
	SuperVillain:ResetMovables('')
	ReloadUI()
end;

function SuperVillain:Install()
	if(not user_music_vol) then
		user_music_vol = GetCVar("Sound_MusicVolume") 
	end
	if not SVUI_ConfigAlert then 
		SVUI_ConfigAlert = CreateFrame("Frame", "SVUI_ConfigAlert", UIParent)
		SVUI_ConfigAlert:SetFrameStrata("TOOLTIP")
		SVUI_ConfigAlert:SetFrameLevel(979)
		SVUI_ConfigAlert:Size(300,300)
		SVUI_ConfigAlert:Point("CENTER",200,-150)
		SVUI_ConfigAlert:Hide()
		SVUI_ConfigAlert.bg = CreateFrame("Frame",nil,SVUI_ConfigAlert)
		SVUI_ConfigAlert.bg:Size(300,300)
		SVUI_ConfigAlert.bg:Point("CENTER")
		SVUI_ConfigAlert.bg:SetFrameStrata("TOOLTIP")
		SVUI_ConfigAlert.bg:SetFrameLevel(979)
		local bgtex = SVUI_ConfigAlert.bg:CreateTexture(nil,'BACKGROUND')
		bgtex:SetAllPoints()
		bgtex:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\SAVED-BG")
		SVUI_ConfigAlert.fg = CreateFrame("Frame",nil,SVUI_ConfigAlert)
		SVUI_ConfigAlert.fg:Size(300,300)
		SVUI_ConfigAlert.fg:Point("CENTER",bgtex,"CENTER")
		SVUI_ConfigAlert.fg:SetFrameStrata("TOOLTIP")
		SVUI_ConfigAlert.fg:SetFrameLevel(999)
		local fgtex = SVUI_ConfigAlert.fg:CreateTexture(nil,'ARTWORK')
		fgtex:SetAllPoints()
		fgtex:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\SAVED-FG")
		SetConfigAlertAnim(SVUI_ConfigAlert.bg, SVUI_ConfigAlert)
		SetConfigAlertAnim(SVUI_ConfigAlert.fg, SVUI_ConfigAlert)
		SuperVillain.Animate:Orbit(SVUI_ConfigAlert.bg,10)
	end;
	if not SVUI_SetupHolder then 
		local d=CreateFrame("Button", "SVUI_SetupHolder", UIParent)
		d.SetPage=SetPage;
		d:Size(550,400)
		d:SetPanelTemplate("Action")
		d:SetPoint("CENTER")
		d:SetFrameStrata('TOOLTIP')
		d.Title=d:CreateFontString(nil,'OVERLAY')
		d.Title:SetFontTemplate(nil,17,nil)
		d.Title:Point("TOP",0,-5)
		d.Title:SetText(L["Supervillain UI Installation"])

		d.Next=CreateFrame("Button","SVUI_InstallNextButton",d,"UIPanelButtonTemplate")
		d.Next:Formula409()
		d.Next:Size(110,25)
		d.Next:Point("BOTTOMRIGHT",15,5)
		SetInstallButton(d.Next)
		d.Next.texture=d.Next:CreateTexture(nil,"BORDER")
		d.Next.texture:Size(110,75)
		d.Next.texture:Point("RIGHT")
		d.Next.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION-ARROW")
		d.Next.texture:SetVertexColor(1,0.5,0)
		d.Next.text=d.Next:CreateFontString(nil,'OVERLAY')
		d.Next.text:SetFontTemplate()
		d.Next.text:SetPoint("CENTER")
		d.Next.text:SetText(CONTINUE)
		d.Next:Disable()
		d.Next:SetScript("OnClick",NextPage)
		d.Next:SetScript("OnEnter",function(this)
			this.texture:SetVertexColor(1,1,0)
		end)
		d.Next:SetScript("OnLeave",function(this)
			this.texture:SetVertexColor(1,0.5,0)
		end)

		d.Prev=CreateFrame("Button","SVUI_InstallPrevButton",d,"UIPanelButtonTemplate")
		d.Prev:Formula409()
		d.Prev:Size(110,25)
		d.Prev:Point("BOTTOMLEFT",-15,5)
		SetInstallButton(d.Prev)
		d.Prev.texture=d.Prev:CreateTexture(nil,"BORDER")
		d.Prev.texture:Size(110,75)
		d.Prev.texture:Point("LEFT")
		d.Prev.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION-ARROW")
		d.Prev.texture:SetTexCoord(1,0,1,1,0,0,0,1)
		d.Prev.texture:SetVertexColor(1,0.5,0)
		d.Prev.text=d.Prev:CreateFontString(nil,'OVERLAY')
		d.Prev.text:SetFontTemplate()
		d.Prev.text:SetPoint("CENTER")
		d.Prev.text:SetText(PREVIOUS)
		d.Prev:Disable()
		d.Prev:SetScript("OnClick",PreviousPage)
		d.Prev:SetScript("OnEnter",function(this)
			this.texture:SetVertexColor(1,1,0)
		end)
		d.Prev:SetScript("OnLeave",function(this)
			this.texture:SetVertexColor(1,0.5,0)
		end)
		d.Status=CreateFrame("Frame","InstallStatus",d)
		d.Status:SetFrameLevel(d.Status:GetFrameLevel()+2)
		d.Status:Size(150,30)
		d.Status:Point("BOTTOM",d,"TOP",0,2)
		d.Status.text=d.Status:CreateFontString(nil,'OVERLAY')
		d.Status.text:SetFontTemplate(self.Fonts.numbers,22,"OUTLINE")
		d.Status.text:SetPoint("CENTER")
		d.Status.text:SetText(CURRENT_PAGE.." / "..MAX_PAGE)

		d.Option01 = CreateFrame("Button","SVUI_InstallOption01Button",d,"UIPanelButtonTemplate")
		d.Option01:Formula409()
		d.Option01:Size(160,30)
		d.Option01:Point("BOTTOM",0,15)
		d.Option01:SetText("")
		SetInstallButton(d.Option01)
		d.Option01.texture=d.Option01:CreateTexture(nil,"BORDER")
		d.Option01.texture:Size(160,160)
		d.Option01.texture:Point("CENTER",d.Option01,"BOTTOM",0,-15)
		d.Option01.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION")
		d.Option01.texture:SetGradient("VERTICAL",0,0.3,0,0,0.7,0)
		d.Option01:SetScript("OnEnter",function(this)
			this.texture:SetVertexColor(0.5,1,0.4)
		end)
		d.Option01:SetScript("OnLeave",function(this)
			this.texture:SetGradient("VERTICAL",0,0.3,0,0,0.7,0)
		end)
		hooksecurefunc(d.Option01,"SetWidth",function(g,h)
			g.texture:Size(h,h)
			g.texture:Point("CENTER",g,"BOTTOM",0,-(h*0.09))
		end)
		d.Option01:SetFrameLevel(d.Option01:GetFrameLevel()+10)
		d.Option01:Hide()

		d.Option02=CreateFrame("Button","SVUI_InstallOption02Button",d,"UIPanelButtonTemplate")
		d.Option02:Formula409()
		d.Option02:Size(110,30)
		d.Option02:Point('BOTTOMLEFT',d,'BOTTOM',4,15)
		d.Option02:SetText("")
		SetInstallButton(d.Option02)
		d.Option02.texture=d.Option02:CreateTexture(nil,"BORDER")
		d.Option02.texture:Size(110,110)
		d.Option02.texture:Point("CENTER",d.Option02,"BOTTOM",0,-15)
		d.Option02.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION")
		d.Option02.texture:SetGradient("VERTICAL",0.3,0,0,0.7,0,0)
		d.Option02:SetScript("OnEnter",function(this)
			this.texture:SetVertexColor(0.5,1,0.4)
		end)
		d.Option02:SetScript("OnLeave",function(this)
			this.texture:SetGradient("VERTICAL",0.3,0,0,0.7,0,0)
		end)
		hooksecurefunc(d.Option02,"SetWidth",function(g,h)
			g.texture:Size(h,h)
			g.texture:Point("CENTER",g,"BOTTOM",0,-(h*0.09))
		end)
		d.Option02:SetScript('OnShow',function()
			d.Option01:SetWidth(110)
			d.Option01:ClearAllPoints()
			d.Option01:Point('BOTTOMRIGHT',d,'BOTTOM',-4,15)
		end)
		d.Option02:SetScript('OnHide',function()
			d.Option01:SetWidth(160)
			d.Option01:ClearAllPoints()
			d.Option01:Point("BOTTOM",0,15)
		end)
		d.Option02:SetFrameLevel(d.Option01:GetFrameLevel()+10)
		d.Option02:Hide()

		d.Option1=CreateFrame("Button","SVUI_InstallOption1Button",d,"UIPanelButtonTemplate")
		d.Option1:Formula409()
		d.Option1:Size(160,30)
		d.Option1:Point("BOTTOM",0,15)
		d.Option1:SetText("")
		SetInstallButton(d.Option1)
		d.Option1.texture=d.Option1:CreateTexture(nil,"BORDER")
		d.Option1.texture:Size(160,160)
		d.Option1.texture:Point("CENTER",d.Option1,"BOTTOM",0,-15)
		d.Option1.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION")
		d.Option1.texture:SetGradient("VERTICAL",0.3,0.3,0.3,0.7,0.7,0.7)
		d.Option1:SetScript("OnEnter",function(this)
			this.texture:SetVertexColor(0.5,1,0.4)
		end)
		d.Option1:SetScript("OnLeave",function(this)
			this.texture:SetGradient("VERTICAL",0.3,0.3,0.3,0.7,0.7,0.7)
		end)
		hooksecurefunc(d.Option1,"SetWidth",function(g,h)
			g.texture:Size(h,h)
			g.texture:Point("CENTER",g,"BOTTOM",0,-(h*0.09))
		end)
		d.Option1:SetFrameLevel(d.Option1:GetFrameLevel()+10)
		d.Option1:Hide()
		
		d.Option2=CreateFrame("Button","SVUI_InstallOption2Button",d,"UIPanelButtonTemplate")
		d.Option2:Formula409()
		d.Option2:Size(110,30)
		d.Option2:Point('BOTTOMLEFT',d,'BOTTOM',4,15)
		d.Option2:SetText("")
		SetInstallButton(d.Option2)
		d.Option2.texture=d.Option2:CreateTexture(nil,"BORDER")
		d.Option2.texture:Size(110,110)
		d.Option2.texture:Point("CENTER",d.Option2,"BOTTOM",0,-15)
		d.Option2.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION")
		d.Option2.texture:SetGradient("VERTICAL",0.3,0.3,0.3,0.7,0.7,0.7)
		d.Option2:SetScript("OnEnter",function(this)
			this.texture:SetVertexColor(0.5,1,0.4)
		end)
		d.Option2:SetScript("OnLeave",function(this)
			this.texture:SetGradient("VERTICAL",0.3,0.3,0.3,0.7,0.7,0.7)
		end)
		hooksecurefunc(d.Option2,"SetWidth",function(g,h)
			g.texture:Size(h,h)
			g.texture:Point("CENTER",g,"BOTTOM",0,-(h*0.09))
		end)
		d.Option2:SetScript('OnShow',function()
			d.Option1:SetWidth(110)
			d.Option1:ClearAllPoints()
			d.Option1:Point('BOTTOMRIGHT',d,'BOTTOM',-4,15)
		end)
		d.Option2:SetScript('OnHide',function()
			d.Option1:SetWidth(160)
			d.Option1:ClearAllPoints()
			d.Option1:Point("BOTTOM",0,15)
		end)
		d.Option2:SetFrameLevel(d.Option1:GetFrameLevel()+10)
		d.Option2:Hide()

		d.Option3=CreateFrame("Button","SVUI_InstallOption3Button",d,"UIPanelButtonTemplate")
		d.Option3:Formula409()
		d.Option3:Size(100,30)
		d.Option3:Point('LEFT',d.Option2,'RIGHT',4,0)
		d.Option3:SetText("")
		SetInstallButton(d.Option3)
		d.Option3.texture=d.Option3:CreateTexture(nil,"BORDER")
		d.Option3.texture:Size(100,100)
		d.Option3.texture:Point("CENTER",d.Option3,"BOTTOM",0,-9)
		d.Option3.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION")
		d.Option3.texture:SetGradient("VERTICAL",0.3,0.3,0.3,0.7,0.7,0.7)
		d.Option3:SetScript("OnEnter",function(this)
			this.texture:SetVertexColor(0.5,1,0.4)
		end)
		d.Option3:SetScript("OnLeave",function(this)
			this.texture:SetGradient("VERTICAL",0.3,0.3,0.3,0.7,0.7,0.7)
		end)
		d.Option3:SetScript('OnShow',function()
			d.Option1:SetWidth(100)
			d.Option1:ClearAllPoints()
			d.Option1:Point('RIGHT',d.Option2,'LEFT',-4,0)
			d.Option2:SetWidth(100)
			d.Option2:ClearAllPoints()
			d.Option2:Point('BOTTOM',d,'BOTTOM',0,15)
		end)
		d.Option3:SetScript('OnHide',function()
			d.Option1:SetWidth(160)
			d.Option1:ClearAllPoints()
			d.Option1:Point("BOTTOM",0,15)
			d.Option2:SetWidth(110)
			d.Option2:ClearAllPoints()
			d.Option2:Point('BOTTOMLEFT',d,'BOTTOM',4,15)
		end)
		d.Option3:SetFrameLevel(d.Option1:GetFrameLevel()+10)
		d.Option3:Hide()

		d.Option4=CreateFrame("Button","SVUI_InstallOption4Button",d,"UIPanelButtonTemplate")
		d.Option4:Formula409()
		d.Option4:Size(100,30)
		d.Option4:Point('LEFT',d.Option3,'RIGHT',4,0)
		d.Option4:SetText("")
		SetInstallButton(d.Option4)
		d.Option4.texture=d.Option4:CreateTexture(nil,"BORDER")
		d.Option4.texture:Size(100,100)
		d.Option4.texture:Point("CENTER",d.Option4,"BOTTOM",0,-9)
		d.Option4.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION")
		d.Option4.texture:SetGradient("VERTICAL",0.3,0.3,0.3,0.7,0.7,0.7)
		d.Option4:SetScript("OnEnter",function(this)
			this.texture:SetVertexColor(0.5,1,0.4)
		end)
		d.Option4:SetScript("OnLeave",function(this)
			this.texture:SetGradient("VERTICAL",0.3,0.3,0.3,0.7,0.7,0.7)
		end)
		d.Option4:SetScript('OnShow',function()
			d.Option1:Width(100)
			d.Option2:Width(100)
			d.Option1:ClearAllPoints()
			d.Option1:Point('RIGHT',d.Option2,'LEFT',-4,0)
			d.Option2:ClearAllPoints()
			d.Option2:Point('BOTTOMRIGHT',d,'BOTTOM',-4,15)
		end)
		d.Option4:SetScript("OnHide", function()
			d.Option1:SetWidth(160)
			d.Option1:ClearAllPoints()
			d.Option1:Point("BOTTOM", 0, 15)
			d.Option2:SetWidth(110)
			d.Option2:ClearAllPoints()
			d.Option2:Point("BOTTOMLEFT", d, "BOTTOM", 4, 15)
		end)

		d.Option4:SetFrameLevel(d.Option1:GetFrameLevel()+10)
		d.Option4:Hide()

		d.SubTitle=d:CreateFontString(nil,'OVERLAY')
		d.SubTitle:SetFontTemplate(nil,15,nil)
		d.SubTitle:Point("TOP",0,-40)d.Desc1=d:CreateFontString(nil,'OVERLAY')
		d.Desc1:SetFontTemplate()
		d.Desc1:Point("TOPLEFT",20,-75)
		d.Desc1:Width(d:GetWidth()-40)
		d.Desc2=d:CreateFontString(nil,'OVERLAY')
		d.Desc2:SetFontTemplate()
		d.Desc2:Point("TOPLEFT",20,-125)
		d.Desc2:Width(d:GetWidth()-40)
		d.Desc3=d:CreateFontString(nil,'OVERLAY')
		d.Desc3:SetFontTemplate()
		d.Desc3:Point("TOPLEFT",20,-175)
		d.Desc3:Width(d:GetWidth()-40)
		local e=CreateFrame("Button","SVUI_InstallCloseButton",d,"UIPanelCloseButton")
		e:SetPoint("TOPRIGHT",d,"TOPRIGHT")
		e:SetScript("OnClick",function()d:Hide()end)
		d.tutorialImage=d:CreateTexture('InstallTutorialImage','OVERLAY')
		d.tutorialImage:Size(256,128)
		d.tutorialImage:SetTexture('Interface\\AddOns\\SVUI\\assets\\artwork\\SPLASH')
		d.tutorialImage:Point('BOTTOM',0,70)
	end;
	
	SetCVar("Sound_MusicVolume",100)
	SetCVar("Sound_EnableMusic",1)
	StopMusic()
	PlayMusic([[Interface\AddOns\SVUI\assets\sounds\SuperVillain.mp3]])
	SVUI_SetupHolder:SetScript("OnHide",function()
		StopMusic()
		SetCVar("Sound_MusicVolume",user_music_vol)
	end)
	SVUI_SetupHolder:Show()
	NextPage()
end;
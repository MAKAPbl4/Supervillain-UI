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
local MOD = SuperVillain:NewModule('SVHenchmen', 'AceHook-3.0');
SuperVillain.Henchmen = MOD;
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local HenchmenFrame = CreateFrame("Frame", "HenchmenFrame", UIParent);
local TOTAL_OPTIONS = 4;
local SUBOPTIONS = {};
local HENCHMEN_OPTIONS = {
	[1]={"Adjust My Colors!","Color Themes","Click here to change your current color theme to one of the default sets."},
	[2]={"Adjust My Frames!","Frame Styles","Click here to change your current frame styles to one of the default sets."},
	[3]={"Adjust My Bars!","Bar Layouts","Click here to change your current actionbar layout to one of the default sets."},
	[4]={"Adjust My Auras!","Aura Layouts","Click here to change your buff/debuff layout to one of the default sets."},
	[5]={"Show Me All Options!","Config Screen","Click here to access the entire SVUI configuration."}
};
local MINION_OPTIONS = {
	[1]={"Accept Quests","Your minions will automatically accept quests for you", "autoquestaccept"},
	[2]={"Complete Quests","Your minions will automatically complete quests for you", "autoquestcomplete"},
	[3]={"Select Rewards","Your minions will automatically select quest rewards for you", "autoquestreward"},
	[4]={"Greed Roll","Your minions will automatically roll greed (or disenchant if available) on green quality items for you", "autoRoll"},
	[5]={"Watch Factions","Your minions will automatically change your tracked reputation to the last faction you were awarded points for", "autorepchange"},
};
local HENCHMEN_MODELS = {
	--Rascal Bot
	[1] = {
		["displayId"] = 49084,
		["emotes"] = {67,113,69,70,73,75},
	},
	--Macabre Marionette
	[2] = {
		["displayId"] = 29404,
		["emotes"] = {67,113,69,70,73,75},
	},
	--Bishibosh
	[3] = {
		["displayId"] = 45613,
		["emotes"] = {0,5,10,69},
	},
	--Gilgoblin
	[4] = {
		["displayId"] = 34770,
		["emotes"] = {70,82},
	},
	--Burgle
	[5] = {
		["displayId"] = 45562,
		["emotes"] = {69},
	},
	--Augh
	[6] = {
		["displayId"] = 37339,
		["emotes"] = {60,60,60},
	},
	--Defias Henchman
	[7] = {
		["displayId"] = 2323,
		["emotes"] = {67,113,69,70,73,75},
	}
};
local HENCHMEN_OFFSET = {
	[1]=0,
	[2]=20,
	[3]=40,
	[4]=-40,
	[5]=-20
};
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function Tooltip_Show(self)
	GameTooltip:SetOwner(HenchmenFrame,"ANCHOR_TOP",0,12)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(self.ttText)
	GameTooltip:Show()
end;

local function Tooltip_Hide(self)
	GameTooltip:Hide()
end;

local function ToggleSubOptions(self)
	if not InCombatLockdown()then 
		local name=self:GetName()
		for _,frame in pairs(SUBOPTIONS)do 
			frame.anim:Finish()
			frame:Hide()
		end;
		if not self.isopen then 
			for i=1,self.suboptions do 
				_G[name.."Sub"..i]:Show()
				_G[name.."Sub"..i].anim:Play()
				_G[name.."Sub"..i].anim:Finish()
			end;
			self.isopen=true 
		else
			self.isopen=false 
		end 
	end 
end;

local function UpdateHenchmanModel(hide)
	if(not hide and not HenchmenFrameModel:IsShown()) then
		local mod = random(1,#HENCHMEN_MODELS)
		local id = HENCHMEN_MODELS[mod].displayId
		local emoteList = HENCHMEN_MODELS[mod].emotes
		local emote = random(1,#emoteList)
		HenchmenFrameModel:ClearModel()
		HenchmenFrameModel:SetDisplayInfo(id)
		HenchmenFrameModel:SetAnimation(emoteList[emote])
		HenchmenFrameModel:Show()
	else
		HenchmenFrameModel:Hide()
	end 
end;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
local hideAlert = function()SVUI_ModeAlert:Hide()end;
function SuperVillain:ToggleHenchman()
	if InCombatLockdown()then return end;
	if not HenchmenFrame:IsShown()then 
		HenchmenFrameBG:Show()

		UpdateHenchmanModel()

		HenchmenFrame.anim:Finish()
		HenchmenFrame:Show()
		HenchmenFrame.anim:Play()
		-- if em == 4 then 
		-- 	HenchmenCalloutFramePic:SetTexture([[Interface\Addons\SVUI\assets\artwork\Henchmen\CALL-HENCHMAN-SRSLY]])
		-- elseif em > 4 then 
		-- 	HenchmenCalloutFramePic:SetTexture([[Interface\Addons\SVUI\assets\artwork\Henchmen\CALL-HENCHMAN-WTF]])
		-- else 
		-- 	HenchmenCalloutFramePic:SetTexture([[Interface\Addons\SVUI\assets\artwork\Henchmen\CALL-HENCHMAN-NORMAL]])
		-- end;
		HenchmenCalloutFramePic:SetTexture([[Interface\Addons\SVUI\assets\artwork\Henchmen\CALL-HENCHMAN-NORMAL]])
		HenchmenCalloutFrame.anim:Finish()
		HenchmenCalloutFrame:Show()
		HenchmenCalloutFrame:SetAlpha(1)
		HenchmenCalloutFrame.anim:Play()
		UIFrameFadeOut(HenchmenCalloutFrame,5)
		for i=1,5 do 
			local option=_G["HenchmenOptionButton"..i]
			option.anim:Finish()
			option:Show()
			option.anim:Play()

			local minion=_G["MinionOptionButton"..i]
			minion.anim:Finish()
			minion:Show()
			minion.anim:Play()
		end;
		RightSuperDockToggleButton.icon:SetGradient(unpack(SuperVillain.Colors.gradient.green))
		if SVUI_ModeAlert:IsShown()then 
			SuperVillain.Modes:EndJobModes()
			PlaySoundFile([[Sound\Interface\LevelUp.wav]])
			UIFrameFadeOut(SVUI_ModeAlert,0.5,1,0)
			SuperVillain:SetTimeout(0.5,hideAlert)
		end 
	else 
		UpdateHenchmanModel(true)
		for _,frame in pairs(SUBOPTIONS)do
			frame.anim:Finish()
			frame:Hide()
		end;
		HenchmenOptionButton1.isopen=false;
		HenchmenOptionButton2.isopen=false;
		HenchmenOptionButton3.isopen=false;
		HenchmenCalloutFrame.anim:Finish()
		HenchmenCalloutFrame:Hide()
		HenchmenFrame.anim:Finish()
		HenchmenFrame:Hide()
		HenchmenFrameBG:Hide()
		for i=1,5 do 
			local option=_G["HenchmenOptionButton"..i]
			option.anim:Finish()
			option:Hide()

			local minion=_G["MinionOptionButton"..i]
			minion.anim:Finish()
			minion:Hide()
		end;
		RightSuperDockToggleButton.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
	end 
end;

function MOD:CreateMinionOptions(i)
	local lastIndex = i - 1;
	local dialogs = MINION_OPTIONS[i]
	local offsetX = HENCHMEN_OFFSET[i] * -1
	local option = CreateFrame("Frame", "MinionOptionButton"..i, HenchmenFrame)
	option:SetSize(148,50)
	if i==1 then 
		option:Point("TOPRIGHT",HenchmenFrame,"TOPLEFT",-32,-32)
	else 
		option:Point("TOP",_G["MinionOptionButton"..lastIndex],"BOTTOM",offsetX,-32)
	end;
	local iTex = [[Interface\Addons\SVUI\assets\artwork\Henchmen\MINION-ON]];
	local setting = dialogs[3];
	local dbSet = SuperVillain.protected.SVHenchmen[setting];
	option.setting = function(toggle)
		if(toggle == nil) then
			return SuperVillain.protected.SVHenchmen[setting]
		else
			SuperVillain.protected.SVHenchmen[setting] = toggle;
		end
	end
	if(not dbSet) then
		iTex = [[Interface\Addons\SVUI\assets\artwork\Henchmen\MINION-OFF]]
	end
	SuperVillain.Animate:Slide(option,-500,-500)
	option:SetFrameStrata("DIALOG")
	option:SetFrameLevel(24)
	option:EnableMouse(true)
	option.bg = option:CreateTexture(nil,"BORDER")
	option.bg:SetPoint("TOPLEFT",option,"TOPLEFT",-4,4)
	option.bg:SetPoint("BOTTOMRIGHT",option,"BOTTOMRIGHT",4,-24)
	option.bg:SetTexture([[Interface\Addons\SVUI\assets\artwork\Henchmen\OPTION-LEFT]])
	option.bg:SetVertexColor(1,1,1,0.6)
	option.txt = option:CreateFontString(nil,"DIALOG")
	option.txt:FillInner(option)
	option.txt:SetFontTemplate(SuperVillain.Fonts.dialog,12,"NONE","CENTER","MIDDLE")
	option.txt:SetText(dialogs[1])
	option.txt:SetTextColor(0,0,0)
	option.txthigh = option:CreateFontString(nil,"HIGHLIGHT")
	option.txthigh:FillInner(option)
	option.txthigh:SetFontTemplate(SuperVillain.Fonts.dialog,12,"OUTLINE","CENTER","MIDDLE")
	option.txthigh:SetText(dialogs[1])
	option.txthigh:SetTextColor(0,1,1)
	option.ttText = dialogs[2]
	option.indicator = option:CreateTexture(nil,"OVERLAY")
	option.indicator:SetSize(100,32)
	option.indicator:Point("RIGHT", option , "LEFT", -5, 0)
	option.indicator:SetTexture(iTex)
	option:SetScript("OnEnter", Tooltip_Show)
	option:SetScript("OnLeave", Tooltip_Hide)
	option:SetScript("OnMouseUp",function(self) 
		if(not self.setting()) then
			self.indicator:SetTexture([[Interface\Addons\SVUI\assets\artwork\Henchmen\MINION-ON]])
			self.setting(true)
		else
			self.indicator:SetTexture([[Interface\Addons\SVUI\assets\artwork\Henchmen\MINION-OFF]])
			self.setting(false)
		end
	end)
end;

function MOD:CreateHenchmenOptions(i)
	local lastIndex = i - 1;
	local dialogs = HENCHMEN_OPTIONS[i]
	local offsetX = HENCHMEN_OFFSET[i]
	local option = CreateFrame("Frame", "HenchmenOptionButton"..i, HenchmenFrame)
	option:SetSize(148,50)
	if i==1 then 
		option:Point("TOPLEFT",HenchmenFrame,"TOPRIGHT",32,-32)
	else 
		option:Point("TOP",_G["HenchmenOptionButton"..lastIndex],"BOTTOM",offsetX,-32)
	end;
	SuperVillain.Animate:Slide(option,500,-500)
	option:SetFrameStrata("DIALOG")
	option:SetFrameLevel(24)
	option:EnableMouse(true)
	option.bg = option:CreateTexture(nil,"BORDER")
	option.bg:SetPoint("TOPLEFT",option,"TOPLEFT",-4,4)
	option.bg:SetPoint("BOTTOMRIGHT",option,"BOTTOMRIGHT",4,-24)
	option.bg:SetTexture([[Interface\Addons\SVUI\assets\artwork\Henchmen\OPTION-RIGHT]])
	option.bg:SetVertexColor(1,1,1,0.6)
	option.txt = option:CreateFontString(nil,"DIALOG")
	option.txt:FillInner(option)
	option.txt:SetFontTemplate(SuperVillain.Fonts.dialog,12,"NONE","CENTER","MIDDLE")
	option.txt:SetText(dialogs[1])
	option.txt:SetTextColor(0,0,0)
	option.txthigh = option:CreateFontString(nil,"HIGHLIGHT")
	option.txthigh:FillInner(option)
	option.txthigh:SetFontTemplate(SuperVillain.Fonts.dialog,12,"OUTLINE","CENTER","MIDDLE")
	option.txthigh:SetText(dialogs[1])
	option.txthigh:SetTextColor(0,1,1)
	option.ttText = dialogs[3]
	option:SetScript("OnEnter", Tooltip_Show)
	option:SetScript("OnLeave", Tooltip_Hide)
end;

function MOD:CreateHenchmenSubOptions(buttonIndex,optionIndex)
	local parent = _G["HenchmenOptionButton"..buttonIndex]
	local name = format("HenchmenOptionButton%dSub%d",buttonIndex,optionIndex);
	local calc = 90 * optionIndex;
	local yOffset = 180 - calc;
	local frame = CreateFrame("Frame",name,HenchmenFrame)
	frame:SetSize(122,50)
	frame:Point("BOTTOMLEFT", parent, "TOPRIGHT", 75, yOffset)
	frame:SetFrameStrata("DIALOG")
	frame:SetFrameLevel(24)
	frame:EnableMouse(true)
	frame.bg = frame:CreateTexture(nil,"BORDER")
	frame.bg:SetPoint("TOPLEFT",frame,"TOPLEFT",-12,12)
	frame.bg:SetPoint("BOTTOMRIGHT",frame,"BOTTOMRIGHT",12,-18)
	frame.bg:SetTexture([[Interface\Addons\SVUI\assets\artwork\Henchmen\CALLOUT]])
	frame.bg:SetVertexColor(1,1,1,0.6)
	frame.txt = frame:CreateFontString(nil,"DIALOG")
	frame.txt:FillInner(frame)
	frame.txt:SetFontTemplate(false,12,"OUTLINE","CENTER","MIDDLE")
	frame.txt:SetTextColor(1,1,1)
	frame.txthigh = frame:CreateFontString(nil,"HIGHLIGHT")
	frame.txthigh:FillInner(frame)
	frame.txthigh:SetFontTemplate(false,12,"OUTLINE","CENTER","MIDDLE")
	frame.txthigh:SetTextColor(1,1,0)
	SuperVillain.Animate:Slide(frame,500,0)
	tinsert(SUBOPTIONS,frame)
end;

function MOD:CreateHenchmenFrame()
	HenchmenFrame:SetParent(SuperVillain.UIParent)
	HenchmenFrame:SetPoint("CENTER",UIParent,"CENTER",0,0)
	HenchmenFrame:SetWidth(500)
	HenchmenFrame:SetHeight(500)
	HenchmenFrame:SetFrameStrata("DIALOG")
	HenchmenFrame:SetFrameLevel(24)
	SuperVillain.Animate:Slide(HenchmenFrame,0,-500)

	local model = CreateFrame("PlayerModel", "HenchmenFrameModel", HenchmenFrame)
	model:SetPoint("TOPLEFT",HenchmenFrame,25,-25)
	model:SetPoint("BOTTOMRIGHT",HenchmenFrame,-25,25)
	model:SetFrameStrata("DIALOG")
	model:SetPosition(0,0,0)
	model:Hide()

	HenchmenFrame:Hide()

	local default_callout = [[Interface\Addons\SVUI\assets\artwork\Henchmen\CALL-HENCHMAN-NORMAL]];
	local HenchmenCalloutFrame = CreateFrame("Frame","HenchmenCalloutFrame",SuperVillain.UIParent)
	HenchmenCalloutFrame:SetPoint("BOTTOM",UIParent,"BOTTOM",100,150)
	HenchmenCalloutFrame:SetWidth(256)
	HenchmenCalloutFrame:SetHeight(128)
	HenchmenCalloutFrame:SetFrameStrata("DIALOG")
	HenchmenCalloutFrame:SetFrameLevel(24)
	SuperVillain.Animate:Slide(HenchmenCalloutFrame,-356,-278)
	HenchmenCalloutFramePic = HenchmenCalloutFrame:CreateTexture("HenchmenCalloutFramePic","ARTWORK")
	HenchmenCalloutFramePic:SetTexture(default_callout)
	HenchmenCalloutFramePic:SetAllPoints(HenchmenCalloutFrame)
	HenchmenCalloutFrame:Hide()

	local HenchmenFrameBG = CreateFrame("Frame","HenchmenFrameBG",SuperVillain.UIParent)
	HenchmenFrameBG:SetAllPoints(WorldFrame)
	HenchmenFrameBG:SetBackdrop({bgFile = [[Interface\BUTTONS\WHITE8X8]]})
	HenchmenFrameBG:SetBackdropColor(0,0,0,0.9)
	HenchmenFrameBG:SetFrameStrata("DIALOG")
	HenchmenFrameBG:SetFrameLevel(22)
	HenchmenFrameBG:Hide()
	HenchmenFrameBG:SetScript("OnMouseUp",function(a)SuperVillain.ToggleHenchman()end)

	for i=1, 5 do 
		MOD:CreateHenchmenOptions(i)
		MOD:CreateMinionOptions(i)
	end
	------------------------------------------------------------------------
	MOD:CreateHenchmenSubOptions(1,1)
	HenchmenOptionButton1Sub1.txt:SetText("KABOOM!")
	HenchmenOptionButton1Sub1.txthigh:SetText("KABOOM!")
	HenchmenOptionButton1Sub1:SetScript("OnMouseUp",function()
		SuperVillain:SetColorTheme("kaboom", true)
		SuperVillain:Refresh_SVUI_System(true)
		SuperVillain.ToggleHenchman()
	end)
	MOD:CreateHenchmenSubOptions(1,2)
	HenchmenOptionButton1Sub2.txt:SetText("Darkness")
	HenchmenOptionButton1Sub2.txthigh:SetText("Darkness")
	HenchmenOptionButton1Sub2:SetScript("OnMouseUp",function()
		SuperVillain:SetColorTheme("dark", true)
		SuperVillain:Refresh_SVUI_System(true)
		SuperVillain.ToggleHenchman()
	end)
	MOD:CreateHenchmenSubOptions(1,3)
	HenchmenOptionButton1Sub3.txt:SetText("Classy")
	HenchmenOptionButton1Sub3.txthigh:SetText("Classy")
	HenchmenOptionButton1Sub3:SetScript("OnMouseUp",function()
		SuperVillain:SetColorTheme("default", true)
		SuperVillain:Refresh_SVUI_System(true)
		SuperVillain.ToggleHenchman()
	end)
	MOD:CreateHenchmenSubOptions(1,4)
	HenchmenOptionButton1Sub4.txt:SetText("Vintage")
	HenchmenOptionButton1Sub4.txthigh:SetText("Vintage")
	HenchmenOptionButton1Sub4:SetScript("OnMouseUp",function()
		SuperVillain:SetColorTheme("vintage", true)
		SuperVillain:Refresh_SVUI_System(true)
		SuperVillain.ToggleHenchman()
	end)
	HenchmenOptionButton1.suboptions = 4;
	HenchmenOptionButton1.isopen = false;
	HenchmenOptionButton1:SetScript("OnMouseUp",ToggleSubOptions)
	------------------------------------------------------------------------
	MOD:CreateHenchmenSubOptions(2,1)
	HenchmenOptionButton2Sub1.txt:SetText("SUPER: Elaborate Frames")
	HenchmenOptionButton2Sub1.txthigh:SetText("SUPER: Elaborate Frames")
	HenchmenOptionButton2Sub1:SetScript("OnMouseUp",function()
		SuperVillain:SetUnitframeLayout("super", true)
		SuperVillain:Refresh_SVUI_System(true)
		SuperVillain.ToggleHenchman()
	end)
	MOD:CreateHenchmenSubOptions(2,2)
	HenchmenOptionButton2Sub2.txt:SetText("Simple: Basic Frames")
	HenchmenOptionButton2Sub2.txthigh:SetText("Simple: Basic Frames")
	HenchmenOptionButton2Sub2:SetScript("OnMouseUp",function()
		SuperVillain:SetUnitframeLayout("simple", true)
		SuperVillain:Refresh_SVUI_System(true)
		SuperVillain.ToggleHenchman()
	end)
	MOD:CreateHenchmenSubOptions(2,3)
	HenchmenOptionButton2Sub3.txt:SetText("Compact: Minimal Frames")
	HenchmenOptionButton2Sub3.txthigh:SetText("Compact: Minimal Frames")
	HenchmenOptionButton2Sub3:SetScript("OnMouseUp",function()
		SuperVillain:SetUnitframeLayout("compact", true)
		SuperVillain:Refresh_SVUI_System(true)
		SuperVillain.ToggleHenchman()
	end)
	HenchmenOptionButton2.suboptions = 3;
	HenchmenOptionButton2.isopen = false;
	HenchmenOptionButton2:SetScript("OnMouseUp",ToggleSubOptions)
	------------------------------------------------------------------------
	MOD:CreateHenchmenSubOptions(3,1)
	HenchmenOptionButton3Sub1.txt:SetText("One Row: Small Buttons")
	HenchmenOptionButton3Sub1.txthigh:SetText("One Row: Small Buttons")
	HenchmenOptionButton3Sub1:SetScript("OnMouseUp",function()
		SuperVillain:SetupBarLayout("onesmall", true)
		SuperVillain:Refresh_SVUI_System(true)
		SuperVillain.ToggleHenchman()
	end)
	MOD:CreateHenchmenSubOptions(3,2)
	HenchmenOptionButton3Sub2.txt:SetText("Two Rows: Small Buttons")
	HenchmenOptionButton3Sub2.txthigh:SetText("Two Rows: Small Buttons")
	HenchmenOptionButton3Sub2:SetScript("OnMouseUp",function()
		SuperVillain:SetupBarLayout("twosmall", true)
		SuperVillain:Refresh_SVUI_System(true)
		SuperVillain.ToggleHenchman()
	end)
	MOD:CreateHenchmenSubOptions(3,3)
	HenchmenOptionButton3Sub3.txt:SetText("One Row: Large Buttons")
	HenchmenOptionButton3Sub3.txthigh:SetText("One Row: Large Buttons")
	HenchmenOptionButton3Sub3:SetScript("OnMouseUp",function()
		SuperVillain:SetupBarLayout("default", true)
		SuperVillain:Refresh_SVUI_System(true)
		SuperVillain.ToggleHenchman()
	end)
	MOD:CreateHenchmenSubOptions(3,4)
	HenchmenOptionButton3Sub4.txt:SetText("Two Rows: Large Buttons")
	HenchmenOptionButton3Sub4.txthigh:SetText("Two Rows: Large Buttons")
	HenchmenOptionButton3Sub4:SetScript("OnMouseUp",function()
		SuperVillain:SetupBarLayout("twobig", true)
		SuperVillain:Refresh_SVUI_System(true)
		SuperVillain.ToggleHenchman()
	end)
	HenchmenOptionButton3.suboptions = 4;
	HenchmenOptionButton3.isopen = false;
	HenchmenOptionButton3:SetScript("OnMouseUp",ToggleSubOptions)
	------------------------------------------------------------------------
	MOD:CreateHenchmenSubOptions(4,1)
	HenchmenOptionButton4Sub1.txt:SetText("Icons Only")
	HenchmenOptionButton4Sub1.txthigh:SetText("Icons Only")
	HenchmenOptionButton4Sub1:SetScript("OnMouseUp",function()
		SuperVillain:SetupAuralayout("icons", true)
		SuperVillain:Refresh_SVUI_System(true)
		SuperVillain.ToggleHenchman()
	end)
	MOD:CreateHenchmenSubOptions(4,2)
	HenchmenOptionButton4Sub2.txt:SetText("Bars Only")
	HenchmenOptionButton4Sub2.txthigh:SetText("Bars Only")
	HenchmenOptionButton4Sub2:SetScript("OnMouseUp",function()
		SuperVillain:SetupAuralayout("bars", true)
		SuperVillain:Refresh_SVUI_System(true)
		SuperVillain.ToggleHenchman()
	end)
	MOD:CreateHenchmenSubOptions(4,3)
	HenchmenOptionButton4Sub3.txt:SetText("The Works: Bars and Icons")
	HenchmenOptionButton4Sub3.txthigh:SetText("The Works: Bars and Icons")
	HenchmenOptionButton4Sub3:SetScript("OnMouseUp",function()
		SuperVillain:SetupAuralayout("theworks", true)
		SuperVillain:Refresh_SVUI_System(true)
		SuperVillain.ToggleHenchman()
	end)
	HenchmenOptionButton4.suboptions = 3;
	HenchmenOptionButton4.isopen = false;
	HenchmenOptionButton4:SetScript("OnMouseUp",ToggleSubOptions)
	------------------------------------------------------------------------
	HenchmenOptionButton5:SetScript("OnMouseUp",function() 
		SuperVillain.ToggleConfig(); 
		SuperVillain.ToggleHenchman(); 
	end)
	------------------------------------------------------------------------
	for _,frame in pairs(SUBOPTIONS) do 
		frame.anim:Finish()
		frame:Hide()
	end
end;

function SuperVillain:HenchmanSays(msg)
	HenchmenSpeechBubble.message = msg;
	HenchmenSpeechBubble:Show();
end;

function MOD:CreateHenchmanSpeech()
	local bubble = CreateFrame("Frame", "HenchmenSpeechBubble", SuperVillain.UIParent)
	bubble:SetSize(256,128)
	bubble:Point("BOTTOMRIGHT", RightSuperDockToggleButton, "TOPLEFT", 0, 0)
	bubble:SetFrameStrata("DIALOG")
	bubble:SetFrameLevel(24)
	bubble.bg = bubble:CreateTexture(nil,"BORDER")
	bubble.bg:SetAllPoints(bubble)
	bubble.bg:SetTexture([[Interface\Addons\SVUI\assets\artwork\Henchmen\SPEECH]])
	bubble.bg:SetVertexColor(1,1,1)
	bubble.txt = bubble:CreateFontString(nil,"DIALOG")
	bubble.txt:Point("TOPLEFT", bubble, "TOPLEFT", 5, -5)
	bubble.txt:Point("BOTTOMRIGHT", bubble, "BOTTOMRIGHT", -5, 20)
	bubble.txt:SetFontTemplate(SuperVillain.Fonts.dialog,12,"NONE")
	bubble.txt:SetText("")
	bubble.txt:SetTextColor(0,0,0)
	bubble.txt:SetWordWrap(true)
	bubble:Hide()
	bubble:SetScript('OnShow', function(self)
		if self.message then
			self.txt:SetText(self.message)
			SuperVillain:SetTimeout(5, function() self:Hide() end)	
			self.message = nil
		else
			self:Hide()
		end
	end)
	bubble:SetScript('OnEnter', function(self)
		UIFrameFadeOut(self, 0.5, 1, 0)
		SuperVillain:SetTimeout(0.5, function() self:Hide() end)	
	end)
end;
--[[ 
########################################################## 
BUILD FUNCTION / UPDATE
##########################################################
]]--
function MOD:ConstructThisPackage()
	self:CreateHenchmenFrame()
	self:CreateHenchmanSpeech()
	self:LoadAllMinions()
end;

SuperVillain.Registry:NewPackage(MOD:GetName(),"post")
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
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;
--[[ TABLE METHODS ]]--
local tremove, twipe = table.remove, table.wipe;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain:NewModule('SVAura', 'AceHook-3.0');
local LSM = LibStub("LibSharedMedia-3.0")
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local buffCache = {}
local invertMap1 = {DOWN_RIGHT="TOPLEFT",DOWN_LEFT="TOPRIGHT",UP_RIGHT="BOTTOMLEFT",UP_LEFT="BOTTOMRIGHT",RIGHT_DOWN="TOPLEFT",RIGHT_UP="BOTTOMLEFT",LEFT_DOWN="TOPRIGHT",LEFT_UP="BOTTOMRIGHT"};
local showMap1 = {DOWN_RIGHT=1,DOWN_LEFT=-1,UP_RIGHT=1,UP_LEFT=-1,RIGHT_DOWN=1,RIGHT_UP=1,LEFT_DOWN=-1,LEFT_UP=-1};
local showMap2 = {DOWN_RIGHT=-1,DOWN_LEFT=-1,UP_RIGHT=1,UP_LEFT=1,RIGHT_DOWN=-1,RIGHT_UP=1,LEFT_DOWN=-1,LEFT_UP=1};
local toggleMap = {RIGHT_DOWN=true,RIGHT_UP=true,LEFT_DOWN=true,LEFT_UP=true};
local SVAuraFade = 5;
local hyperTextures = {
	[1]="Interface\\Addons\\SVUI\\assets\\artwork\\Auras\\STATS",
	[2]="Interface\\Addons\\SVUI\\assets\\artwork\\Auras\\HEART",
	[3]="Interface\\Addons\\SVUI\\assets\\artwork\\Auras\\POWER",
	[4]="Interface\\Addons\\SVUI\\assets\\artwork\\Auras\\HASTE",
	[5]="Interface\\Addons\\SVUI\\assets\\artwork\\Auras\\SPELL",
	[6]="Interface\\Addons\\SVUI\\assets\\artwork\\Auras\\HASTE",
	[7]="Interface\\Addons\\SVUI\\assets\\artwork\\Auras\\CRIT",
	[8]="Interface\\Addons\\SVUI\\assets\\artwork\\Auras\\MASTERY"
};
local RefHyperBuffs = {
	[1]={1126,115921,20217},
	[2]={21562,109773,469},
	[3]={57330,19506,6673},
	[4]={1459,61316,77747,109773},
	[5]={55610,113742,30809},
	[6]={24907,51470},
	[7]={17007,1459,61316,116781},
	[8]={19740,116956},
};
local SVUI_ConsolidatedBuffs = CreateFrame('Frame', 'SVUI_ConsolidatedBuffs', UIParent)
local CB_WIDTH = 36;
local CB_HEIGHT = 228;
--[[ 
########################################################## 
PRE VARS/FUNCTIONS
##########################################################
]]--
local AuraButton_OnEnter = function(self)
	GameTooltip:Hide()
	GameTooltip:SetOwner(self,"ANCHOR_BOTTOMLEFT",-3,self:GetHeight()+2)
	GameTooltip:ClearLines()
	local parent = self:GetParent()
	local id = parent:GetID()
	if parent.spellName then 
		GameTooltip:SetUnitConsolidatedBuff("player",id)
		GameTooltip:AddLine("________________________")
	end;
	GameTooltip:AddLine("Consolidated Buff:  ".._G[("RAID_BUFF_%d"):format(id)])
	GameTooltip:Show()
end;

local AuraButton_OnLeave = function(self)
	GameTooltip:Hide()
end;

local shadowTex = SuperVillain.Textures.shadow;
local function SetAuraTemplate(aura)
    if aura.styled then return end;
    if aura.SetNormalTexture then aura:SetNormalTexture("") end
	if aura.SetHighlightTexture then aura:SetHighlightTexture("") end
	if aura.SetPushedTexture then aura:SetPushedTexture("") end
	if aura.SetDisabledTexture then aura:SetDisabledTexture("") end
    aura:SetBackdrop({
    	bgFile = [[Interface\BUTTONS\WHITE8X8]],
		tile = false, 
		tileSize = 0, 
		edgeFile = [[Interface\BUTTONS\WHITE8X8]],
        edgeSize = 2,
        insets = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0
        }
    })
    aura:SetBackdropColor(0, 0, 0, 0)
    aura:SetBackdropBorderColor(0, 0, 0)
    local cd = aura:GetName() and _G[aura:GetName().."Cooldown"]
    if cd then 
        cd:ClearAllPoints()
        cd:FillInner(aura,0,0)
    end;
    aura.styled = true
end;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:CreateIcon(aura)
	SetAuraTemplate(aura)
	local font = LSM:Fetch("font",MOD.db.font)
	aura.texture = aura:CreateTexture(nil,"BORDER")
	aura.texture:FillInner(aura, 2, 2)
	aura.texture:SetTexCoord(0.1,0.9,0.1,0.9)
	aura.count = aura:CreateFontString(nil,"ARTWORK")
	aura.count:SetPoint("BOTTOMRIGHT",(-1 + MOD.db.countOffsetH),(1 + MOD.db.countOffsetV))
	aura.count:SetFontTemplate(font, MOD.db.fontSize, MOD.db.fontOutline)
	aura.time = aura:CreateFontString(nil,"ARTWORK")
	aura.time:SetPoint("TOP", aura, "BOTTOM", 1 + MOD.db.timeOffsetH, 0 + MOD.db.timeOffsetV)
	aura.time:SetFontTemplate(font, MOD.db.fontSize, MOD.db.fontOutline)
	aura.highlight = aura:CreateTexture(nil, "HIGHLIGHT")
	aura.highlight:SetTexture(0,0,0,0.45)
	aura.highlight:FillInner()
	SuperVillain.Animate:Flash(aura)
	aura:SetScript("OnAttributeChanged",MOD.OnAttributeChanged)
end;

function MOD:UpdateConsolidatedBuff(current)
	local expires = (self.expiration - current);
	local calc = 0;
	self.expiration = expires;
	self.bar:SetValue(expires)
	if self.nextUpdate > 0 then 
		self.nextUpdate = self.nextUpdate - current;
		return 
	end;
	if self.expiration <= 0 then 
		self:SetScript("OnUpdate",nil)
		return 
	end;

	if expires < 60 then 
		if expires >= SVAuraFade then
			self.nextUpdate = 0.51;
		else
			self.nextUpdate = 0.051;
		end 
	elseif expires < 3600 then
		calc = floor((expires / 60) + .5);
		self.nextUpdate = calc > 1 and ((expires - calc) * 29.5) or (expires - 59.5);
	elseif expires < 86400 then
		calc = floor((expires / 3600) + .5);
		self.nextUpdate = calc > 1 and ((expires - calc) * 1799.5) or (expires - 3570);
	else
		calc = floor((expires / 86400) + .5);
		self.nextUpdate = calc > 1 and ((expires - calc) * 43199.5) or (expires - 86400);
	end
end;

function MOD:RefreshAuraTime(elapsed)
	if(self.offset) then 
		local expiration = select(self.offset, GetWeaponEnchantInfo())
		if expiration then 
			self.timeLeft = expiration / 1e3 
		else 
			self.timeLeft = 0 
		end 
	else 
		self.timeLeft = self.timeLeft - elapsed 
	end;

	if(self.nextUpdate > 0) then 
		self.nextUpdate = self.nextUpdate - elapsed;
		return 
	end;

	local expires = self.timeLeft
	local calc = 0;
	local remaining = 0;
	if expires < 60 then 
		if expires >= SVAuraFade then
			remaining = floor(expires)
			self.nextUpdate = 0.51
			self.time:SetFormattedText("|cffffff00%d|r", remaining)
		else
			remaining = expires
			self.nextUpdate = 0.051
			self.time:SetFormattedText("|cffff0000%.1f|r", remaining)
		end 
	elseif expires < 3600 then
		remaining = ceil(expires / 60);
		calc = floor((expires / 60) + .5);
		self.nextUpdate = calc > 1 and ((expires - calc) * 29.5) or (expires - 59.5);
		self.time:SetFormattedText("|cffffffff%dm|r", remaining)
	elseif expires < 86400 then
		remaining = ceil(expires / 3600);
		calc = floor((expires / 3600) + .5);
		self.nextUpdate = calc > 1 and ((expires - calc) * 1799.5) or (expires - 3570);
		self.time:SetFormattedText("|cff66ffff%dh|r", remaining)
	else
		remaining = ceil(expires / 86400);
		calc = floor((expires / 86400) + .5);
		self.nextUpdate = calc > 1 and ((expires - calc) * 43199.5) or (expires - 86400);
		self.time:SetFormattedText("|cff6666ff%dd|r", remaining)
	end

	if(self.timeLeft > SVAuraFade) then 
		SuperVillain.Animate:StopFlash(self)
	else 
		SuperVillain.Animate:Flash(self,1)
	end 
end;

function MOD:AuraUpdate(button, auraIndex)
	local filter = button:GetParent():GetAttribute('filter')
	local unit = button:GetParent():GetAttribute("unit")
	local name,_,icon,count,dispelType,val,expires = UnitAura(unit,auraIndex,filter)
	if name then 
		if val > 0 and expires then 
			local timeLeft = expires - GetTime()
			if not button.timeLeft then 
				button.timeLeft = timeLeft;
				button:SetScript("OnUpdate", MOD.RefreshAuraTime)
			else 
				button.timeLeft = timeLeft 
			end;
			button.nextUpdate = -1;
			MOD.RefreshAuraTime(button,0)
		else 
			button.timeLeft=nil;
			button.time:SetText("")
			button:SetScript("OnUpdate",nil)
		end;
		if count > 1 then 
			button.count:SetText(count)
		else 
			button.count:SetText("")
		end;
		if filter=="HARMFUL" then 
			local color=DebuffTypeColor[dispelType or ""] 
			button:SetBackdropBorderColor(color.r,color.g,color.b)
		else 
			button:SetBackdropBorderColor(unpack(SuperVillain.Colors.dark));
		end;
		button.texture:SetTexture(icon)
		button.offset=nil 
	end;
end;

function MOD:TempEnchantUpdate(button, auraIndex)
	local quality = GetInventoryItemQuality("player",auraIndex)
	button.texture:SetTexture(GetInventoryItemTexture("player",auraIndex))
	local offset=2;
	local enchantIndex = button:GetName():sub(-1)
	if enchantIndex:match("2") then 
		offset=5 
	end;
	if quality then 
		button:SetBackdropBorderColor(GetItemQualityColor(quality))
	end;
	local enchantInfo=select(offset,GetWeaponEnchantInfo())
	if enchantInfo then 
		button.offset = offset;
		button:SetScript("OnUpdate",MOD. RefreshAuraTime)
		button.nextUpdate = -1;
		MOD.RefreshAuraTime(button,0)
	else 
		button.timeLeft = nil;
		button.offset = nil;
		button:SetScript("OnUpdate",nil)
		button.time:SetText("")
	end 
end;

function MOD:OnAttributeChanged(attribute, value)
	if(attribute == "index") then
		MOD:AuraUpdate(self, value)
	elseif(attribute == "target-slot") then
		MOD:TempEnchantUpdate(self, value)
	end
end

function MOD:UpdateHeader(auraHeader)
	if not auraHeader then return end;
	local db = MOD.db.debuffs;
	local font=LSM:Fetch("font",MOD.db.font)
	if auraHeader:GetAttribute('filter') == 'HELPFUL' then 
		db = MOD.db.buffs;
		auraHeader:SetAttribute("consolidateTo",MOD.db.hyperBuffs.enable==true and 1 or 0)
		auraHeader:SetAttribute('weaponTemplate',("SVUI_AuraTemplate%d"):format(db.size))
	end;
	auraHeader:SetAttribute("separateOwn",db.isolate)
	auraHeader:SetAttribute("sortMethod",db.sortMethod)
	auraHeader:SetAttribute("sortDir",db.sortDir)
	auraHeader:SetAttribute("maxWraps",db.maxWraps)
	auraHeader:SetAttribute("wrapAfter",db.wrapAfter)
	auraHeader:SetAttribute("point",invertMap1[db.showBy])
	if toggleMap[db.showBy]then 
		auraHeader:SetAttribute("minWidth", ((db.wrapAfter==1 and 0 or db.wrapXOffset) + db.size) * db.wrapAfter)
		auraHeader:SetAttribute("minHeight", (db.wrapYOffset + db.size) * db.maxWraps)
		auraHeader:SetAttribute("xOffset", showMap1[db.showBy] * (db.wrapXOffset + db.size))
		auraHeader:SetAttribute("yOffset", 0)
		auraHeader:SetAttribute("wrapOffsetH", 0)
		auraHeader:SetAttribute("wrapOffsetV", showMap2[db.showBy] * (db.wrapYOffset + db.size))
	else 
		auraHeader:SetAttribute("minWidth", (db.wrapXOffset + db.size)*db.maxWraps)
		auraHeader:SetAttribute("minHeight", ((db.wrapAfter==1 and 0 or db.wrapYOffset) + db.size) * db.wrapAfter)
		auraHeader:SetAttribute("xOffset", 0)
		auraHeader:SetAttribute("yOffset", showMap2[db.showBy] * (db.wrapYOffset + db.size))
		auraHeader:SetAttribute("wrapOffsetH", showMap1[db.showBy] * (db.wrapXOffset + db.size))
		auraHeader:SetAttribute("wrapOffsetV", 0)
	end;
	auraHeader:SetAttribute("template",("SVUI_AuraTemplate%d"):format(db.size))
	local i=1;
	local auraChild=select(i,auraHeader:GetChildren())
	while(auraChild) do 
		if ((floor(auraChild:GetWidth() * 100 + 0.5) / 100) ~= db.size) then 
			auraChild:SetSize(db.size,db.size)
		end;
		if(auraChild.time) then 
			auraChild.time:ClearAllPoints()
			auraChild.time:SetPoint("TOP", auraChild, 'BOTTOM', 1 + MOD.db.timeOffsetH, MOD.db.timeOffsetV)
			auraChild.count:ClearAllPoints()
			auraChild.count:SetPoint("BOTTOMRIGHT", -1 + MOD.db.countOffsetH, MOD.db.countOffsetV)
		end;
		if (i > (db.maxWraps * db.wrapAfter) and auraChild:IsShown()) then 
			auraChild:Hide()
		end;
		i = i + 1;
		auraChild = select(i, auraHeader:GetChildren())
	end 
end;

function MOD:CreateAuraHeader(filter)
	local frameName="SVUI_PlayerDebuffs"
	if filter=="HELPFUL" then frameName="SVUI_PlayerBuffs" end;
	local auraHeader=CreateFrame("Frame", frameName, Auras_SVAnchor, "SecureAuraHeaderTemplate")
	auraHeader:SetClampedToScreen(true)
	auraHeader:SetAttribute("unit","player")
	auraHeader:SetAttribute("filter",filter)
	RegisterStateDriver(auraHeader,"visibility","[petbattle] hide; show")
	RegisterAttributeDriver(auraHeader,"unit","[vehicleui] vehicle; player")
	if filter=="HELPFUL" then 
		auraHeader:SetAttribute('consolidateDuration',-1)
		auraHeader:SetAttribute("includeWeapons",1)
	end;
	MOD:UpdateHeader(auraHeader)
	auraHeader:Show()
	return auraHeader 
end;

function MOD:UpdateReminder(event,arg)
	if(event == "UNIT_AURA" and arg ~= "player") then return end;
	for i=1,NUM_LE_RAID_BUFF_TYPES do 
		local name,_,_,duration,expiration = GetRaidBuffTrayAuraInfo(i)
		local buff = SVUI_ConsolidatedBuffs[i]
		if name then 
			local timeLeft = expiration - GetTime()
			buff.expiration = timeLeft;
			buff.duration = duration;
			buff.nextUpdate = 0;
			buff.bar:SetMinMaxValues(0,duration)
			buff.bar:SetValue(timeLeft)
			buff:SetAlpha(0.1)
			if(duration == 0 and expiration == 0) then 
				buff:SetScript('OnUpdate',nil)
				buff.spellName = nil;
				buff.empty:SetAlpha(0)
			else
				buff:SetAlpha(1)
				buff:SetScript('OnUpdate',MOD.UpdateConsolidatedBuff)
				buff.spellName = name
				buff.empty:SetAlpha(1)
			end;
		else
			buff.spellName = nil;
			buff.bar:SetValue(0)
			buff:SetAlpha(0.1)
			buff.empty:SetAlpha(0)
			buff:SetScript('OnUpdate',nil)
		end 
	end 
end;

function MOD:CreateConsolidatedBuffs(index)
	SVUI_ConsolidatedBuffs:SetParent(SuperVillain.UIParent)
	SVUI_ConsolidatedBuffs:Width(CB_WIDTH)
	SVUI_ConsolidatedBuffs:Height(CB_HEIGHT)
	SVUI_ConsolidatedBuffs:Point('RIGHT', Auras_SVAnchor, 'RIGHT', 0, 0)
	for i=1,NUM_LE_RAID_BUFF_TYPES do 
		SVUI_ConsolidatedBuffs[i] = self:CreateHyperBuff(i)
		SVUI_ConsolidatedBuffs[i]:SetID(i)
	end;
	self:Update_ConsolidatedBuffsSettings()
end;

function MOD:CreateHyperBuff(index)
	local buff = CreateFrame("Button", nil, SVUI_ConsolidatedBuffs)
	local texture = hyperTextures[index]
	local bar = CreateFrame('StatusBar',nil,buff)
	bar:SetAllPoints(buff)
	bar:SetStatusBarTexture(texture)
	bar:SetOrientation("VERTICAL")
	bar:SetMinMaxValues(0,100)
	bar:SetValue(0)
	local bg = bar:CreateTexture(nil,"BACKGROUND",nil,-2)
	bg:WrapOuter(buff,1,1)
	bg:SetTexture(texture)
	bg:SetVertexColor(0,0,0,0.5)
	local empty = bar:CreateTexture(nil,"BACKGROUND",nil,-1)
	empty:SetAllPoints(buff)
	empty:SetTexture(texture)
	empty:SetDesaturated(true)
	empty:SetVertexColor(0.5,0.5,0.5)
	empty:SetBlendMode("ADD")
	buff.bar = bar;
	buff.bg = bg;
	buff.empty = empty;
	buff:SetAlpha(0.1)
	return buff 
end;

function MOD:RunConsolidatedBuffs()
	SVUI_ConsolidatedBuffs:Show()
	BuffFrame:RegisterUnitEvent('UNIT_AURA',"player")
	MOD:RegisterEvent("UNIT_AURA",'UpdateReminder')
	MOD:RegisterEvent("GROUP_ROSTER_UPDATE",'UpdateReminder')
	MOD:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED",'UpdateReminder')
	SuperVillain.RegisterCallback(MOD,"RoleChanged","Update_ConsolidatedBuffsSettings")
	MOD:UpdateReminder()
end;

function MOD:EndConsolidatedBuffs()
	SVUI_ConsolidatedBuffs:Hide()
	BuffFrame:UnregisterEvent('UNIT_AURA')
	MOD:UnregisterEvent("UNIT_AURA")
	MOD:UnregisterEvent("GROUP_ROSTER_UPDATE")
	MOD:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	SuperVillain.UnregisterCallback(MOD,"RoleChanged","Update_ConsolidatedBuffsSettings")
end;

function MOD:ToggleConsolidatedBuffs()
	if MOD.db.hyperBuffs.enable then 
		MOD:RunConsolidatedBuffs()
	else 
		MOD:EndConsolidatedBuffs()
	end
end;

function MOD:Update_ConsolidatedBuffsSettings(event)
	SVUI_ConsolidatedBuffs:Width(CB_WIDTH)
	SVUI_ConsolidatedBuffs:Height(CB_HEIGHT)
	SVUI_ConsolidatedBuffs:Point('RIGHT',Auras_SVAnchor,'RIGHT',0,0)
	twipe(buffCache)
	if MOD.db.hyperBuffs.filter then 
		if SuperVillain.ClassRole == 'C' then 
			buffCache[3]=true;
			buffCache[4]=2 
		else 
			buffCache[5]=3;
			buffCache[6]=4 
		end 
	end
	for i=1,NUM_LE_RAID_BUFF_TYPES do 
		local buff = SVUI_ConsolidatedBuffs[i]
		if(buff) then
			buff:ClearAllPoints()
			buff:Size(CB_WIDTH - 1)
			if i==1 then 
				buff:Point("TOP", SVUI_ConsolidatedBuffs, "TOP", 0, 0)
			else 
				buff:Point("TOP", SVUI_ConsolidatedBuffs[buffCache[i-1] or i-1], "BOTTOM", 0, -4)
			end;
			if buffCache[i] then 
				buff:Hide()
			else 
				buff:Show()
			end;
			local tip = _G[("ConsolidatedBuffsTooltipBuff%d"):format(i)]
			tip:ClearAllPoints()
			tip:SetAllPoints(SVUI_ConsolidatedBuffs[i])
			tip:SetParent(SVUI_ConsolidatedBuffs[i])
			tip:SetAlpha(0)
			tip:SetScript("OnEnter",AuraButton_OnEnter)
			tip:SetScript("OnLeave",AuraButton_OnLeave)
		end
	end
	if not event then 
		MOD:ToggleConsolidatedBuffs()
	end 
end;

function MOD:UpdateThisPackage()
	SVAuraFade = self.db.fadeBy
  	self:UpdateHeader(SVUI_PlayerBuffs);
  	self:UpdateHeader(SVUI_PlayerDebuffs);
end;

function MOD:ConstructThisPackage()
	if not SuperVillain.protected.SVAura.enable then return end;
	if SuperVillain.protected.SVAura.disableBlizzard then 
		BuffFrame:MUNG()
		ConsolidatedBuffs:MUNG()
		TemporaryEnchantFrame:MUNG()
		InterfaceOptionsFrameCategoriesButton12:SetScale(0.0001)
	end;
	local Auras_SVAnchor = CreateFrame('Frame', 'Auras_SVAnchor', SuperVillain.UIParent)
	Auras_SVAnchor:SetSize(80, Minimap:GetHeight())
	Auras_SVAnchor:Point("TOPRIGHT", Minimap, "TOPLEFT", -8, 0)
	self.BuffFrame = self:CreateAuraHeader("HELPFUL")
	self.BuffFrame:SetPoint("TOPRIGHT", Auras_SVAnchor, "TOPRIGHT", -44, 0)
	self.DebuffFrame = self:CreateAuraHeader("HARMFUL")
	self.DebuffFrame:SetPoint( "BOTTOMRIGHT", Auras_SVAnchor, "BOTTOMRIGHT", -44, 0)

	self:CreateConsolidatedBuffs()

	SuperVillain:SetSVMovable(Auras_SVAnchor,"SVUI_Auras_MOVE",L["Auras Frame"])
end;
SuperVillain.Registry:NewPackage(MOD:GetName())
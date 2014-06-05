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
local table 	= _G.table;
--[[ STRING METHODS ]]--
local find, format, match, sub = string.find, string.format, string.match, string.sub;
--[[ MATH METHODS ]]--
local floor = math.floor;
--[[ TABLE METHODS ]]--
local twipe, tconcat = table.wipe, table.concat;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain:NewModule('SVTip', 'AceTimer-3.0', 'AceHook-3.0')
local LSM = LibStub("LibSharedMedia-3.0");
--[[ 
########################################################## 
LOCAL VARIABLES
##########################################################
]]--
local _G = getfenv(0);
local GameTooltip, GameTooltipStatusBar = _G["GameTooltip"], _G["GameTooltipStatusBar"];
local playerGUID = UnitGUID("player");
local targetList, inspectCache = {}, {};
local NIL_COLOR = { r = 1, g = 1, b = 1 };
local TAPPED_COLOR = { r = .6, g = .6, b = .6 };
local tooltips={
	GameTooltip,ItemRefTooltip,ItemRefShoppingTooltip1,
	ItemRefShoppingTooltip2,ItemRefShoppingTooltip3,AutoCompleteBox,
	FriendsTooltip,ConsolidatedBuffsTooltip,ShoppingTooltip1,
	ShoppingTooltip2,ShoppingTooltip3,WorldMapTooltip,
	WorldMapCompareTooltip1,WorldMapCompareTooltip2,
	WorldMapCompareTooltip3,DropDownList1MenuBackdrop,
	DropDownList2MenuBackdrop,DropDownList3MenuBackdrop,BNToastFrame
};
local classification={
	worldboss = format("|cffAF5050 %s|r",BOSS),
	rareelite = format("|cffAF5050+ %s|r",ITEM_QUALITY3_DESC),
	elite = "|cffAF5050+|r",
	rare = format("|cffAF5050 %s|r",ITEM_QUALITY3_DESC)
};
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function GetLevelLine(this,start)
	for i=start, this:NumLines() do 
		local tip = _G["GameTooltipTextLeft"..i]
		if tip:GetText() and tip:GetText():find(LEVEL) then 
			return tip 
		end 
	end 
end;

local function RemoveTrashLines(this)
	for i=3,this:NumLines() do 
		local tip = _G["GameTooltipTextLeft"..i]
		local tipText = tip:GetText()
		if tipText:find(PVP) or tipText:find(FACTION_ALLIANCE) or tipText:find(FACTION_HORDE) then 
			tip:SetText(nil)
			tip:Hide()
		end 
	end 
end;

local function GetTalentSpec(unit,isPlayer)
	local spec;
	if isPlayer then 
		spec = GetSpecialization()
	else 
		spec = GetInspectSpecialization(unit)
	end;
	if spec ~= nil and spec > 0 then 
		if not isPlayer then 
			local byRole = GetSpecializationRoleByID(spec)
			if byRole ~= nil then 
				local _,byRoleData = GetSpecializationInfoByID(spec)
				return byRoleData 
			end 
		else 
			local _,specData = GetSpecializationInfo(spec)
			return specData 
		end 
	end 
end;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:GameTooltip_ShowCompareItem(tip, shift)
	if not tip then tip = GameTooltip end;
	local _,link = tip:GetItem()
	if not link then return; end
	local shoppingTooltip1, shoppingTooltip2, shoppingTooltip3 = unpack(tip.shoppingTooltips)
	local item1 = nil;
	local item2 = nil;
	local item3 = nil;
	local side = "left"
	if shoppingTooltip1:SetHyperlinkCompareItem(link, 1, shift, tip) then item1 = true end;
	if shoppingTooltip2:SetHyperlinkCompareItem(link, 2, shift, tip) then item2 = true end;
	if shoppingTooltip3:SetHyperlinkCompareItem(link, 3, shift, tip) then item3 = true end;
	local rightDist = 0;
	local leftPos = tip:GetLeft()
	local rightPos = tip:GetRight()
	if not rightPos then rightPos = 0 end;
	if not leftPos then leftPos = 0 end;
	rightDist = GetScreenWidth() - rightPos;
	if(leftPos and (rightDist < leftPos)) then
		side = "left"
	else
		side = "right"
	end;

	if(tip:GetAnchorType() and (tip:GetAnchorType() ~= "ANCHOR_PRESERVE")) then 
		local totalWidth = 0;
		if item1 then
			totalWidth = totalWidth + shoppingTooltip1:GetWidth()
		end;
		if item2 then
			totalWidth = totalWidth + shoppingTooltip2:GetWidth()
		end;
		if item3 then
			totalWidth = totalWidth + shoppingTooltip3:GetWidth()
		end;
		if(side == "left" and (totalWidth > leftPos)) then
			tip:SetAnchorType(tip:GetAnchorType(), (totalWidth - leftPos), 0)
		elseif(side == "right" and ((rightPos + totalWidth) > GetScreenWidth())) then 
			tip:SetAnchorType(tip:GetAnchorType(), -((rightPos + totalWidth) - GetScreenWidth()), 0)
		end 
	end;

	if item3 then
		shoppingTooltip3:SetOwner(tip, "ANCHOR_NONE")
		shoppingTooltip3:ClearAllPoints()
		if(side and side == "left") then
			shoppingTooltip3:SetPoint("TOPRIGHT", tip, "TOPLEFT", -2, -10)
		else
			shoppingTooltip3:SetPoint("TOPLEFT", tip, "TOPRIGHT", 2, -10)
		end;
		shoppingTooltip3:SetHyperlinkCompareItem(link, 3, shift, tip)
		shoppingTooltip3:Show()
	end;

	if item1 then
		if item3 then 
			shoppingTooltip1:SetOwner(shoppingTooltip3, "ANCHOR_NONE")
		else
			shoppingTooltip1:SetOwner(tip, "ANCHOR_NONE")
		end;
		shoppingTooltip1:ClearAllPoints()
		
		if(side and side == "left") then
			if item3 then 
				shoppingTooltip1:SetPoint("TOPRIGHT", shoppingTooltip3, "TOPLEFT", -2, 0)
			else
				shoppingTooltip1:SetPoint("TOPRIGHT", tip, "TOPLEFT", -2, -10)
			end 
		else
			if item3 then
				shoppingTooltip1:SetPoint("TOPLEFT", shoppingTooltip3, "TOPRIGHT", 2, 0)
			else
				shoppingTooltip1:SetPoint("TOPLEFT", tip, "TOPRIGHT", 2, -10)
			end 
		end;
		shoppingTooltip1:SetHyperlinkCompareItem(link, 1, shift, tip)
		shoppingTooltip1:Show()

		if item2 then
			shoppingTooltip2:SetOwner(shoppingTooltip1, "ANCHOR_NONE")
			shoppingTooltip2:ClearAllPoints()
			if (side and side == "left") then
				shoppingTooltip2:SetPoint("TOPRIGHT", shoppingTooltip1, "TOPLEFT", -2, 0)
			else
				shoppingTooltip2:SetPoint("TOPLEFT", shoppingTooltip1, "TOPRIGHT", 2, 0)
			end;
			shoppingTooltip2:SetHyperlinkCompareItem(link, 2, shift, tip)
			shoppingTooltip2:Show()
		end 
	end 
end;


function MOD:GameTooltip_SetDefaultAnchor(a, s)
	if SuperVillain.protected.SVTip.enable ~= true then return end;
	if a:GetAnchorType() ~= "ANCHOR_NONE" then return end;
	if InCombatLockdown()and MOD.db.visibility.combat then 
		a:Hide()
		return 
	end;
	if s then 
		if MOD.db.cursorAnchor then 
			a:SetOwner(s, "ANCHOR_CURSOR")
			if not GameTooltipStatusBar.anchoredToTop then 
				GameTooltipStatusBar:ClearAllPoints()
				GameTooltipStatusBar:SetPoint("BOTTOMLEFT", GameTooltip, "TOPLEFT", 1, 3)
				GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", GameTooltip, "TOPRIGHT", -1, 3)
				GameTooltipStatusBar.text:Point("CENTER", GameTooltipStatusBar, 0, 3)
				GameTooltipStatusBar.anchoredToTop = true 
			end;
			return 
		else 
			a:SetOwner(s, "ANCHOR_NONE")
			a:ClearAllPoints()
			if GameTooltipStatusBar.anchoredToTop then 
				GameTooltipStatusBar:ClearAllPoints()
				GameTooltipStatusBar:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 1, -3)
				GameTooltipStatusBar:SetPoint("TOPRIGHT", GameTooltip, "BOTTOMRIGHT", -1, -3)
				GameTooltipStatusBar.text:Point("CENTER", GameTooltipStatusBar, 0, -3)
				GameTooltipStatusBar.anchoredToTop = nil 
			end 
		end 
	end;
	if not SuperVillain:TestMovableMoved("SVUI_ToolTip_MOVE")then 
		if SVUI_ContainerFrame and SVUI_ContainerFrame:IsShown()then 
			a:SetPoint("BOTTOMLEFT", SVUI_ContainerFrame, "TOPLEFT", 0, 18)
		elseif RightSuperDock:GetAlpha() == 1 and RightSuperDock:IsShown() then 
			a:SetPoint("BOTTOMRIGHT", RightSuperDock, "TOPRIGHT", -44, 18)
		else 
			a:SetPoint("BOTTOMRIGHT", SuperVillain.UIParent, "BOTTOMRIGHT", -44, 78)
		end 
	else
		local t = SuperVillain:FetchScreenRegions(SVUI_ToolTip_MOVE)
		if t == "TOPLEFT" then 
			a:SetPoint("TOPLEFT", SVUI_ToolTip_MOVE, "TOPLEFT", 0, 0)
		elseif t == "TOPRIGHT" then 
			a:SetPoint("TOPRIGHT", SVUI_ToolTip_MOVE, "TOPRIGHT", 0, 0)
		elseif t == "BOTTOMLEFT"or t == "LEFT" then 
			a:SetPoint("BOTTOMLEFT", SVUI_ToolTip_MOVE, "BOTTOMLEFT", 0, 0)
		else 
			a:SetPoint("BOTTOMRIGHT", SVUI_ToolTip_MOVE, "BOTTOMRIGHT", 0, 0)
		end 
	end 
end;


function MOD:INSPECT_READY(_,guid)
	if MOD.lastGUID ~= guid then return end;
	local unit="mouseover"
	if UnitExists(unit) then 
		local itemLevel = SuperVillain:ParseGearSlots(unit, true)
		local spec = GetTalentSpec(unit)
		inspectCache[guid] = {time=GetTime()}
		if spec then 
			inspectCache[guid].talent=spec 
		end;
		if itemLevel then 
			inspectCache[guid].itemLevel=itemLevel 
		end;
		GameTooltip:SetUnit(unit)
	end;
	MOD:UnregisterEvent("INSPECT_READY")
end;

function MOD:ShowInspectInfo(this,unit,unitLevel,r,g,b,iteration)
	local inspectable = CanInspect(unit)
	if not inspectable or unitLevel < 10 or iteration > 1 then return end;
	local guid = UnitGUID(unit)
	if guid == playerGUID then 
		this:AddDoubleLine(L["Talent Specialization:"],GetTalentSpec(unit,true),nil,nil,nil,r,g,b)
		this:AddDoubleLine(L["Item Level:"],floor(select(2,GetAverageItemLevel())),nil,nil,nil,1,1,1)
	elseif inspectCache[guid] then 
		local talent=inspectCache[guid].talent;
		local itemLevel=inspectCache[guid].itemLevel;
		if GetTime() - inspectCache[guid].time > 900 or not talent or not itemLevel then 
			inspectCache[guid] = nil;
			return MOD:ShowInspectInfo(this,unit,unitLevel,r,g,b,iteration+1)
		end;
		this:AddDoubleLine(L["Talent Specialization:"],talent,nil,nil,nil,r,g,b)
		this:AddDoubleLine(L["Item Level:"],itemLevel,nil,nil,nil,1,1,1)
	else 
		if not inspectable or InspectFrame and InspectFrame:IsShown() then 
			return 
		end;
		MOD.lastGUID = guid;
		NotifyInspect(unit)
		MOD:RegisterEvent("INSPECT_READY")
	end 
end;

function MOD:GameTooltip_OnTooltipSetUnit(this)
	local unit = select(2,this:GetUnit())
	if this:GetOwner() ~= UIParent and MOD.db.visibility.unitFrames ~= 'NONE' then 
		local vis = MOD.db.visibility.unitFrames;
		if vis=='ALL' or not (vis == 'SHIFT' and IsShiftKeyDown() or vis== 'CTRL' and IsControlKeyDown() or vis=='ALT' and IsAltKeyDown()) then 
			this:Hide()
			return 
		end 
	end;
	if not unit then 
		local mFocus=GetMouseFocus()
		if mFocus and mFocus:GetAttribute("unit") then 
			unit=mFocus:GetAttribute("unit")
		end;
		if not unit or not UnitExists(unit) then return end 
	end;
	RemoveTrashLines(this)
	local unitLevel = UnitLevel(unit)
	local colors,qColor,totColor;
	local lvlLine;
	if UnitIsPlayer(unit) then 
		local className,classToken = UnitClass(unit)
		local unitName,unitRealm = UnitName(unit)
		local guildName, guildRankName, guildRankIndex = GetGuildInfo(unit)
		local pvpName = UnitPVPName(unit)
		local realmRelation=UnitRealmRelationship(unit)
		colors = RAID_CLASS_COLORS[classToken]
		if MOD.db.playerTitles and pvpName then 
			unitName = pvpName 
		end;
		if unitRealm and unitRealm ~= "" then 
			if IsShiftKeyDown() then 
				unitName = unitName.."-"..unitRealm 
			elseif realmRelation==LE_REALM_RELATION_COALESCED then 
				unitName = unitName..FOREIGN_SERVER_LABEL 
			elseif realmRelation==LE_REALM_RELATION_VIRTUAL then 
				unitName = unitName..INTERACTIVE_SERVER_LABEL 
			end 
		end;
		GameTooltipTextLeft1:SetFormattedText("|c%s%s|r",colors.colorStr,unitName)
		if guildName then 
			if guildRankIndex and IsShiftKeyDown() then 
				guildName = guildName.."-"..guildRankIndex 
			end;
			if MOD.db.guildRanks then 
				GameTooltipTextLeft2:SetText(("<|cff00ff10%s|r> [|cff00ff10%s|r]"):format(guildName,guildRankName))
			else 
				GameTooltipTextLeft2:SetText(("<|cff00ff10%s|r>"):format(guildName))
			end;
			lvlLine = GetLevelLine(this,3)
		else
			lvlLine = GetLevelLine(this,2)
		end;
		if lvlLine then 
			qColor = GetQuestDifficultyColor(unitLevel)
			local race,_ = UnitRace(unit)
			lvlLine:SetFormattedText("|cff%02x%02x%02x%s|r %s |c%s%s|r", qColor.r*255, qColor.g*255, qColor.b*255, unitLevel > 0 and unitLevel or "??", race, colors.colorStr, className)
		end;
		if MOD.db.inspectInfo and IsShiftKeyDown() then 
			MOD:ShowInspectInfo(this,unit,unitLevel,colors.r,colors.g,colors.b,0)
		end 
	else 
		if UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) then 
			colors=TAPPED_COLOR 
		else 
			colors=FACTION_BAR_COLORS[UnitReaction(unit,"player")]
		end;
		lvlLine = GetLevelLine(this,2)
		if lvlLine then
			local unitType = UnitClassification(unit)
			local unitCreature = UnitCreatureType(unit)
			local temp = ""
			if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then 
				unitLevel=UnitBattlePetLevel(unit)
				local ab=C_PetJournal.GetPetTeamAverageLevel()
				if ab then 
					qColor=GetRelativeDifficultyColor(ab,unitLevel)
				else 
					qColor=GetQuestDifficultyColor(unitLevel)
				end 
			else 
				qColor=GetQuestDifficultyColor(unitLevel)
			end;
			if UnitIsPVP(unit) then 
				temp = format(" (%s)",PVP)
			end;
			lvlLine:SetFormattedText("|cff%02x%02x%02x%s|r%s %s%s", qColor.r*255, qColor.g*255, qColor.b*255, unitLevel > 0 and unitLevel or "??", classification[unitType] or "", unitCreature or "", temp)
		end 
	end;
	if MOD.db.targetInfo then
		if unit~="player" and UnitExists(targettarget) then 
			local targettarget = unit.."target"
			if UnitIsPlayer(targettarget) and not UnitHasVehicleUI(targettarget) then 
				totColor=RAID_CLASS_COLORS[select(2,UnitClass(targettarget))]
			else 
				totColor=FACTION_BAR_COLORS[UnitReaction(targettarget,"player")]
			end;
			GameTooltip:AddDoubleLine(format("%s:",TARGET), format("|cff%02x%02x%02x%s|r", totColor.r*255, totColor.g*255, totColor.b*255, UnitName(targettarget)))
		end;
		if IsInGroup() then 
			for i=1,GetNumGroupMembers() do 
				local grouptarget = IsInRaid() and "raid"..i or "party"..i;
				if UnitIsUnit(grouptarget.."target",unit) and not UnitIsUnit(grouptarget,"player") then 
					local _,classToken = UnitClass(grouptarget)
					tinsert(targetList, format("|c%s%s|r", RAID_CLASS_COLORS[classToken].colorStr, UnitName(grouptarget)))
				end 
			end;
			local maxTargets = #targetList;
			if maxTargets > 0 then 
				GameTooltip:AddLine(format("%s (|cffffffff%d|r): %s",L['Targeted By:'], maxTargets, tconcat(targetList,", ")), nil, nil, nil, true)
				twipe(targetList)
			end 
		end;
	end;
	if colors then 
		GameTooltipStatusBar:SetStatusBarColor(colors.r,colors.g,colors.b)
	else 
		GameTooltipStatusBar:SetStatusBarColor(0.6,0.6,0.6)
	end 
end;

function MOD:GameTooltipStatusBar_OnValueChanged(this,value)
	if not value or not MOD.db.healthBar.text or not this.text then return end;
	local unit = select(2,this:GetParent():GetUnit())
	if not unit then 
		local mFocus = GetMouseFocus()
		if mFocus and mFocus:GetAttribute("unit") then 
			unit = mFocus:GetAttribute("unit")
		end 
	end;
	local min,max = this:GetMinMaxValues()
	if value > 0 and max==1 then 
		this.text:SetText(format("%d%%",floor(value * 100)))
		this:SetStatusBarColor(TAPPED_COLOR.r,TAPPED_COLOR.g,TAPPED_COLOR.b)
	elseif value==0 or unit and UnitIsDeadOrGhost(unit) then 
		this.text:SetText(DEAD)
	else 
		this.text:SetText(TruncateNumericString(value).." / "..TruncateNumericString(max))
	end 
end;

function MOD:GameTooltip_OnTooltipSetItem(this)
	if not this.itemCleared then
		local key,itemID = this:GetItem()
		local left = "";
		local right = "";
		if itemID ~= nil and MOD.db.spellID then 
			left = "|cFFCA3C3CSpell ID: |r"
			right = ("|cFFCA3C3C%s|r %s"):format(ID,itemID):match(":(%w+)")
		end;
		if left ~= "" or right ~= "" then 
			this:AddLine(" ")
			this:AddDoubleLine(left,right)
		end;
		this.itemCleared = true 
	end
end;

function MOD:GameTooltip_ShowStatusBar(this,...)
	local bar = _G[this:GetName() .. "StatusBar" .. this.shownStatusBars]
	if bar and not bar.styled then 
		bar:Formula409()
		bar:SetStatusBarTexture(SuperVillain.Textures.default)
		bar:SetFixedPanelTemplate('Inset',true)
		if not bar.border then 
			local border=CreateFrame("Frame",nil,bar)
			border:WrapOuter(bar,1,1)
			border:SetFrameLevel(bar:GetFrameLevel() - 1)
			border:SetBackdrop({
				edgeFile=[[Interface\BUTTONS\WHITE8X8]],
				edgeSize=1,
				insets={left=1,right=1,top=1,bottom=1}
			})
			border:SetBackdropBorderColor(0,0,0,1)
			bar.border=border 
		end;
		bar.styled=true 
	end 
end;

function MOD:MODIFIER_STATE_CHANGED(_,mod)
	if (mod=="LSHIFT"or mod=="RSHIFT") and UnitExists("mouseover") then 
		GameTooltip:SetUnit('mouseover')
	end 
end;

function MOD:SetUnitAura(this,unit,index,filter)
	local _,_,_,_,_,_,_,caster,_,_,spellID=UnitAura(unit,index,filter)
	if spellID and MOD.db.spellID then 
		if caster then 
			local name=UnitName(caster)
			local _,class=UnitClass(caster)
			local color=RAID_CLASS_COLORS[class]
			if color then 
				this:AddDoubleLine(("|cFFCA3C3C%s|r %d"):format(ID,spellID),format("|c%s%s|r",color.colorStr,name))
			end
		else 
			this:AddLine(("|cFFCA3C3C%s|r %d"):format(ID,spellID))
		end;
		this:Show()
	end 
end;

function MOD:SetHyperUnitAura(this,unit,index,filter)
	if unit ~= "player" then return end
	local auraName,_,_,_,_,_,_,caster,_,shouldConsolidate,spellID = UnitAura(unit,index,filter)
	if shouldConsolidate then 
		if caster then 
			local name=UnitName(caster)
			local _,class=UnitClass(caster)
			local color=RAID_CLASS_COLORS[class]
			if color then 
				this:AddDoubleLine(("|cFFCA3C3C%s|r"):format(auraName),format("|c%s%s|r",color.colorStr,name))
			end
		else 
			this:AddLine(("|cFFCA3C3C%s|r"):format(auraName))
		end;
		this:Show()
	end 
end;

function MOD:GameTooltip_OnTooltipSetSpell(parent)
	local ref = select(3,parent:GetSpell())
	if not ref or not MOD.db.spellID then return end;
	local text = ("|cFFCA3C3C%s|r %d"):format(ID,ref)
	local max = parent:NumLines()
	local check;
	for i=1,max do 
		local tip=_G[("GameTooltipTextLeft%d"):format(i)]
		if tip and tip:GetText() and tip:GetText():find(text) then 
			check=true;
			break 
		end 
	end;
	if not check then 
		parent:AddLine(text)
		parent:Show()
	end 
end;

function MOD:ConstructThisPackage()
	BNToastFrame:Point('TOPRIGHT',SVUI_MinimapFrame,'BOTTOMLEFT',0,-10)
	SuperVillain:SetSVMovable(BNToastFrame,'BNET_MOVE',L['BNet Frame'])
	self:SecureHook(BNToastFrame,"SetPoint",function(self,anchor,parent,relative,x,y)
		if parent ~= BNET_MOVE then 
			BNToastFrame:ClearAllPoints()
			BNToastFrame:Point('TOPLEFT',BNET_MOVE,'TOPLEFT')
		end
	end)
	if not SuperVillain.protected.SVTip.enable then return end;
	GameTooltipStatusBar:Height(MOD.db.healthBar.height)
	GameTooltipStatusBar:SetStatusBarTexture(SuperVillain.Textures.bar)
	GameTooltipStatusBar:SetFixedPanelTemplate('Inset',true)
	GameTooltipStatusBar:SetScript("OnValueChanged",self.OnValueChanged)
	GameTooltipStatusBar:ClearAllPoints()
	GameTooltipStatusBar:SetPoint("TOPLEFT",GameTooltip,"BOTTOMLEFT",1,-3)
	GameTooltipStatusBar:SetPoint("TOPRIGHT",GameTooltip,"BOTTOMRIGHT",-1,-3)
	GameTooltipStatusBar.text=GameTooltipStatusBar:CreateFontString(nil,"OVERLAY")
	GameTooltipStatusBar.text:Point("CENTER",GameTooltipStatusBar,0,-3)
	GameTooltipStatusBar.text:SetFontTemplate(LSM:Fetch("font",MOD.db.healthBar.font),MOD.db.healthBar.fontSize,"OUTLINE")
	if not GameTooltipStatusBar.border then 
		local border=CreateFrame("Frame",nil,GameTooltipStatusBar)
		border:WrapOuter(GameTooltipStatusBar,1,1)
		border:SetFrameLevel(GameTooltipStatusBar:GetFrameLevel() - 1)
		border:SetBackdrop({edgeFile=[[Interface\BUTTONS\WHITE8X8]],edgeSize=1})
		border:SetBackdropBorderColor(0,0,0,1)
		GameTooltipStatusBar.border=border 
	end;
	local anchor=CreateFrame('Frame','GameTooltipAnchor',SuperVillain.UIParent)
	anchor:Point('BOTTOMRIGHT',RightSuperDock,'TOPRIGHT',0,60)
	anchor:Size(130,20)
	anchor:SetFrameLevel(anchor:GetFrameLevel() + 50)
	SuperVillain:SetSVMovable(anchor,'SVUI_ToolTip_MOVE',L['Tooltip'])
	self:SecureHook('GameTooltip_SetDefaultAnchor')
	self:SecureHook('GameTooltip_ShowStatusBar')
	if self.db.spellID then
		self:SecureHook("SetItemRef", function(link,text,button,chatFrame)
			if find(link,"^spell:") then 
				local ref = sub(link,7)
				ItemRefTooltip:AddLine(("|cFFCA3C3C%s|r %d"):format(ID,ref))
				ItemRefTooltip:Show()
			end 
		end)
	end
	self:SecureHook("GameTooltip_ShowCompareItem")
	self:SecureHook(GameTooltip,"SetUnitAura")
	self:SecureHook(GameTooltip,"SetUnitBuff","SetUnitAura")
	self:SecureHook(GameTooltip,"SetUnitDebuff","SetUnitAura")
	self:SecureHook(GameTooltip,"SetUnitConsolidatedBuff","SetHyperUnitAura")
	self:HookScript(GameTooltip,"OnTooltipSetSpell","GameTooltip_OnTooltipSetSpell")
	self:HookScript(GameTooltip,'OnTooltipCleared',function(this)
		this.itemCleared = nil 
	end)
	self:HookScript(GameTooltip,'OnTooltipSetItem','GameTooltip_OnTooltipSetItem')
	self:HookScript(GameTooltip,'OnTooltipSetUnit','GameTooltip_OnTooltipSetUnit')
	self:HookScript(GameTooltipStatusBar,'OnValueChanged','GameTooltipStatusBar_OnValueChanged')
	self:RegisterEvent("MODIFIER_STATE_CHANGED")
	for _,tooltip in pairs(tooltips)do 
		self:HookScript(tooltip,'OnShow',function(this)
			this:SetBackdrop({
				bgFile=[[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]],
				edgeFile=[[Interface\BUTTONS\WHITE8X8]],
				tile=false,
				edgeSize=1
			})
			this:SetBackdropColor(0,0,0,0.8)
			this:SetBackdropBorderColor(0,0,0)
		end)
	end 
end;
SuperVillain.Registry:NewPackage(MOD:GetName())
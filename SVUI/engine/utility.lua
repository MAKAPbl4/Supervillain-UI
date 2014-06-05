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
local tinsert   = _G.tinsert;
local string    = _G.string;
local math      = _G.math;
local bit       = _G.bit;
local table     = _G.table;
--[[ STRING METHODS ]]--
local lower, upper = string.lower, string.upper;
local find, format, len, split = string.find, string.format, string.len, string.split;
local match, sub, join = string.match, string.sub, string.join;
local gmatch, gsub = string.gmatch, string.gsub;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;  -- Basic
local fmod, modf, sqrt = math.fmod, math.modf, math.sqrt;   -- Algebra
local atan2, cos, deg, rad, sin = math.atan2, math.cos, math.deg, math.rad, math.sin;  -- Trigonometry
local parsefloat, huge, random = math.parsefloat, math.huge, math.random;  -- Uncommon
--[[ BINARY METHODS ]]--
local band, bor = bit.band, bit.bor;
--[[ TABLE METHODS ]]--
local tremove, tcopy, twipe, tsort, tconcat, tdump = table.remove, table.copy, table.wipe, table.sort, table.concat, table.dump;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, G = unpack(select(2, ...));
local LSM = LibStub("LibSharedMedia-3.0")
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local PointIndexes = {
    ["TOP"] = "TOP",
    ["BOTTOM"] = "BOTTOM",
    ["LEFT"] = "LEFT",
    ["RIGHT"] = "RIGHT",
    ["TOPRIGHT"] = "UP AND RIGHT",
    ["TOPLEFT"] = "UP AND LEFT",
    ["BOTTOMRIGHT"] = "DOWN AND RIGHT",
    ["BOTTOMLEFT"] = "DOWN AND LEFT",
    ["CENTER"] = "CENTER",
    ["RIGHTTOP"] = "RIGHT AND UP",
    ["LEFTTOP"] = "LEFT AND UP",
    ["RIGHTBOTTOM"] = "RIGHT AND DOWN",
    ["LEFTBOTTOM"] = "LEFT AND DOWN",
    ["INNERRIGHT"] = "INNER RIGHT",
    ["INNERLEFT"] = "INNER LEFT",
    ["INNERTOPRIGHT"] = "INNER TOP RIGHT",
    ["INNERTOPLEFT"] = "INNER TOP LEFT",
    ["INNERBOTTOMRIGHT"] = "INNER BOTTOM RIGHT",
    ["INNERBOTTOMLEFT"] = "INNER BOTTOM LEFT",
};

local PointInversions = {
    TOP = "BOTTOM",
    BOTTOM = "TOP",
    LEFT = "RIGHT",
    RIGHT = "LEFT",
    TOPRIGHT = "BOTTOMRIGHT",
    TOPLEFT = "BOTTOMLEFT",
    BOTTOMRIGHT = "TOPRIGHT",
    BOTTOMLEFT = "TOPLEFT",
    CENTER = "CENTER",
    RIGHTTOP = "TOPLEFT",
    LEFTTOP = "TOPRIGHT",
    RIGHTBOTTOM = "BOTTOMLEFT",
    LEFTBOTTOM = "BOTTOMRIGHT",
    INNERRIGHT = "RIGHT",
    INNERLEFT = "LEFT",
    INNERTOPRIGHT = "TOPRIGHT",
    INNERTOPLEFT = "TOPLEFT",
    INNERBOTTOMRIGHT = "BOTTOMRIGHT",
    INNERBOTTOMLEFT = "BOTTOMLEFT",
};

local PointTranslations = {
    TOP = "TOP",
    BOTTOM = "BOTTOM",
    LEFT = "LEFT",
    RIGHT = "RIGHT",
    TOPRIGHT = "TOPRIGHT",
    TOPLEFT = "TOPLEFT",
    BOTTOMRIGHT = "BOTTOMRIGHT",
    BOTTOMLEFT = "BOTTOMLEFT",
    CENTER = "CENTER",
    RIGHTTOP = "TOPRIGHT",
    LEFTTOP = "TOPLEFT",
    RIGHTBOTTOM = "BOTTOMRIGHT",
    LEFTBOTTOM = "BOTTOMLEFT",
    INNERRIGHT = "RIGHT",
    INNERLEFT = "LEFT",
    INNERTOPRIGHT = "TOPRIGHT",
    INNERTOPLEFT = "TOPLEFT",
    INNERBOTTOMRIGHT = "BOTTOMRIGHT",
    INNERBOTTOMLEFT = "BOTTOMLEFT",
};

local ItemUpgradeAdjustment = {
    ["0"]=0,["1"]=8,["373"]=4,["374"]=8,["375"]=4,["376"]=4,
    ["377"]=4,["379"]=4,["380"]=4,["445"]=0,["446"]=4,["447"]=8,
    ["451"]=0,["452"]=8,["453"]=0,["454"]=4,["455"]=8,["456"]=0,
    ["457"]=8,["458"]=0,["459"]=4,["460"]=8,["461"]=12,["462"]=16,
    ["465"]=0,["466"]=4,["467"]=8,["468"]=0,["469"]=4,["470"]=8,
    ["471"]=12,["472"]=16,["491"]=0,["492"]=4,["493"]=8,["494"]=0,
    ["495"]=4,["496"]=8,["497"]=12,["498"]=16,["499"]=16,
};

local EquipmentSlots = {
    ["HeadSlot"] = {true,true},
    ["NeckSlot"] = {true,false},
    ["ShoulderSlot"] = {true,true},
    ["BackSlot"] = {true,false},
    ["ChestSlot"] = {true,true},
    ["WristSlot"] = {true,true},
    ["MainHandSlot"] = {true,true,true},
    ["SecondaryHandSlot"] = {true,true},
    ["HandsSlot"] = {true,true,true},
    ["WaistSlot"] = {true,true,true},
    ["LegsSlot"] = {true,true,true},
    ["FeetSlot"] = {true,true,true},
    ["Finger0Slot"] = {true,false,true},
    ["Finger1Slot"] = {true,false,true},
    ["Trinket0Slot"] = {true,false,true},
    ["Trinket1Slot"] = {true,false,true}
};

local HeirLoomIDs = {
    44102,42944,44096,42943,42950,48677,42946,42948,42947,42992,50255,44103,
    44107,44095,44098,44097,44105,42951,48683,48685,42949,48687,42984,44100,
    44101,44092,48718,44091,42952,48689,44099,42991,42985,48691,44094,44093,
    42945,48716
};
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function DD_OnClick(btn)
    btn.func()
    btn:GetParent():Hide()
end

local function DD_OnEnter(btn)
    btn.hoverTex:Show()
end

local function DD_OnLeave(btn)
    btn.hoverTex:Hide()
end

local function GetHeirloomLevel(unit, itemID)
    if(not itemID) then return; end
    local baseLevel = UnitLevel(unit)
    if baseLevel > 85 then baseLevel = 85 end;
    if baseLevel > 80 then
        for i=1, #HeirLoomIDs do 
            if(HeirLoomIDs[i] == itemID) then 
                baseLevel = 80;
            end
        end
        if baseLevel > 80 then 
            return (((baseLevel - 81) * 12.2) + 272)
        end
    elseif baseLevel > 67 then 
        return (((baseLevel - 68) * 6) + 130) 
    elseif baseLevel > 59 then 
        return (((baseLevel - 60) * 3) + 85) 
    end
    return baseLevel
end
--[[ 
########################################################## 
UTILITY FUNCTIONS
##########################################################
]]--
function SuperVillain:AddonMessage(msg,toon) 
    if type(msg) == "table" then 
        msg = tostring(msg) 
    end;
    local msgFrom = toon and SuperVillain.name or "SVUI";
    print("|cffffcc1a" .. msgFrom .. ":|r", msg) 
end;

function SuperVillain:ColorGradient(perc, ...)
    if perc >= 1 then
        return select(select('#', ...) - 2, ...)
    elseif perc <= 0 then
        return ...
    end
    local num = select('#', ...) / 3
    local segment, relperc = modf(perc*(num-1))
    local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)
    return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end;

function SuperVillain:TableSplice(targetTable, mergeTable)
    if type(targetTable) ~= "table" then targetTable = {} end

    if type(mergeTable) == 'table' then 
        for key,val in pairs(mergeTable) do 
            if type(val) == "table" then 
                val = self:TableSplice(targetTable[key], val)
            end;
            targetTable[key] = val 
        end 
    end;
    return targetTable 
end

function SuperVillain:KrazyGlue(frame, parent)
    if(not parent) then return end
    for i = 1, frame:GetNumRegions()do 
        local target = select(i, frame:GetRegions())
        if(target) then
            if(target.SetParent) then 
                target:SetParent(parent)
            elseif(target:GetParent()) then
                target:GetParent():SetParent(parent)
            end
        end 
    end 
end;

function SuperVillain:GetPointTable()
    return PointIndexes
end;

function SuperVillain:ReversePoint(frame, point, target, x, y)
    if((not frame) or (not point)) then return; end
    local anchor = PointInversions[point];
    local relative = PointTranslations[point];
    x = x or 0;
    y = y or 0;
    target = target or frame:GetParent()
    frame:SetPoint(anchor, target, relative, x, y)
    --[[ auto-set specific properties to save on logic ]]--
    frame.initialAnchor = anchor;
end;

function SuperVillain:SetUIMenu(list, frame, parent, bottom, xOffset, yOffset, widthOverride)
    if not parent then parent = UIParent end;
    if not frame.buttons then
        frame.buttons = {}
        frame:SetFrameStrata("DIALOG")
        frame:SetClampedToScreen(true)
        tinsert(UISpecialFrames, frame:GetName())
        frame:Hide()
    end
    xOffset = xOffset or 0
    yOffset = yOffset or 0
    widthOverride = widthOverride or 135
    for i=1, #frame.buttons do
        frame.buttons[i]:Hide()
    end
    for i=1, #list do 
        if not frame.buttons[i] then
            frame.buttons[i] = CreateFrame("Button", nil, frame)
            frame.buttons[i].hoverTex = frame.buttons[i]:CreateTexture(nil, 'OVERLAY')
            frame.buttons[i].hoverTex:SetAllPoints()
            frame.buttons[i].hoverTex:SetTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
            frame.buttons[i].hoverTex:SetBlendMode("ADD")
            frame.buttons[i].hoverTex:Hide()
            frame.buttons[i].text = frame.buttons[i]:CreateFontString(nil, 'BORDER')
            frame.buttons[i].text:SetAllPoints()
            frame.buttons[i].text:SetFontTemplate()
            frame.buttons[i].text:SetJustifyH("LEFT")
            frame.buttons[i]:SetScript("OnEnter", DD_OnEnter)
            frame.buttons[i]:SetScript("OnLeave", DD_OnLeave)           
        end
        frame.buttons[i]:Show()
        frame.buttons[i]:SetHeight(16)
        frame.buttons[i]:SetWidth(widthOverride)
        frame.buttons[i].text:SetText(list[i].text)
        frame.buttons[i].func = list[i].func
        frame.buttons[i]:SetScript("OnClick", DD_OnClick)
        if i == 1 then
            frame.buttons[i]:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
        else
            frame.buttons[i]:SetPoint("TOPLEFT", frame.buttons[i-1], "BOTTOMLEFT")
        end
    end
    frame:SetHeight((#list * 16) + 20)
    frame:SetWidth(widthOverride + 20)    
    frame:ClearAllPoints()
    if bottom then
        frame:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", xOffset, yOffset)
    else
        frame:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", xOffset, yOffset)
    end
    ToggleFrame(frame)
end;

function SuperVillain:ParseGearSlots(unit, inspecting, levelCallback, duraCallback)
    local category = (inspecting) and "Inspect" or "Character";
    local averageLevel,totalSlots,upgradeAdjust,globalName = 0,0,0;
    for slotName,flags in pairs(EquipmentSlots) do
        globalName = format("%s%s", category, slotName)
        local slotId = GetInventorySlotInfo(slotName)
        local iLink = GetInventoryItemLink(unit, slotId)
        if(iLink ~= nil) then 
            local _,_,quality,iLevel = GetItemInfo(iLink)
            local _,itemId,_,_,_,_,_,_,_,_,_,upgradeId = split(":", iLink)
            if iLevel ~= nil then
                if(quality == 7) then 
                    iLevel = GetHeirloomLevel(unit, itemId)
                end 
                if(upgradeId) then
                    upgradeId = match(upgradeId, "(%d+)\124h%[")
                    upgradeAdjust = ItemUpgradeAdjustment[upgradeId]
                    if(upgradeAdjust) then
                        iLevel = iLevel + upgradeAdjust
                    end;
                end
                totalSlots = totalSlots + 1;
                averageLevel = averageLevel + iLevel
                if(flags[1] and levelCallback and type(levelCallback) == "function") then
                    levelCallback(globalName, iLevel)
                end
            end
        end
        if(slotId ~= nil) then
            if(not inspecting and flags[2] and duraCallback and type(duraCallback) == "function") then
                duraCallback(globalName, slotId)
            end
        end
    end;
    if(averageLevel < 1 or totalSlots < 15) then 
        return 
    end;
    return floor(averageLevel / totalSlots)
end;
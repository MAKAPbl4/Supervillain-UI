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
local LSM = LibStub("LibSharedMedia-3.0")
--[[ 
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local select  = _G.select;
local pairs   = _G.pairs;
local ipairs  = _G.ipairs;
local type    = _G.type;
local string  = _G.string;
local math    = _G.math;
local table   = _G.table;
local GetTime = _G.GetTime;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ MATH METHODS ]]--
local floor = math.floor;  -- Basic
--[[ TABLE METHODS ]]--
local twipe, tsort = table.wipe, table.sort;
--[[ 
########################################################## 
LOCALIZED GLOBALS
##########################################################
]]--
local STANDARD_TEXT_FONT = _G.STANDARD_TEXT_FONT
local UNIT_NAME_FONT = _G.UNIT_NAME_FONT
local DAMAGE_TEXT_FONT = _G.DAMAGE_TEXT_FONT
local SVUI_CLASS_COLORS = _G.SVUI_CLASS_COLORS
local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local threshold;
local droodSpell1, droodSpell2 = GetSpellInfo(110309), GetSpellInfo(4987);
local RefClassData = {
  PALADIN = {
    ['ROLE'] = {"C","T","M"},
    ['DISPELL'] = {
      ['Poison'] = true,
      ['Magic'] = false,
      ['Disease'] = true
    },
    ['MagicSpec'] = 1
  },
  PRIEST = {
    ['ROLE'] = {"C","C","C"},
    ['DISPELL'] = {
      ['Magic'] = true,
      ['Disease'] = true
    },
    ['MagicSpec'] = false
  },
  WARLOCK = {
    ['ROLE'] = {"C","C","C"},
    ['DISPELL'] = false,
    ['MagicSpec'] = false
  },
  WARRIOR = {
    ['ROLE'] = {"M","M","T"},
    ['DISPELL'] = false,
    ['MagicSpec'] = false
  },
  HUNTER = {
    ['ROLE'] = {"M","M","M"},
    ['DISPELL'] = false,
    ['MagicSpec'] = false
  },
  SHAMAN = {
    ['ROLE'] = {"C","M","C"},
    ['DISPELL'] = {
      ['Magic'] = false,
      ['Curse'] = true
    },
    ['MagicSpec'] = 3
  },
  ROGUE = {
    ['ROLE'] = {"M","M","M"},
    ['DISPELL'] = false,
    ['MagicSpec'] = false
  },
  MAGE = {
    ['ROLE'] = {"C","C","C"},
    ['DISPELL'] = {['Curse'] = true},
    ['MagicSpec'] = false
  },
  DEATHKNIGHT = {
    ['ROLE'] = {"T","M","M"},
    ['DISPELL'] = false,
    ['MagicSpec'] = false
  },
  DRUID = {
    ['ROLE'] = {"C","M","T","C"},
    ['DISPELL'] = {
      ['Magic'] = false,
      ['Curse'] = true,
      ['Poison'] = true,
      ['Disease'] = false
    },
    ['MagicSpec'] = 4
  },
  MONK = {
    ['ROLE'] = {"T","C","M"},
    ['DISPELL'] = {
      ['Magic'] = false,
      ['Disease'] = true,
      ['Poison'] = true
    },
    ['MagicSpec'] = 2
  }
};
--[[ 
########################################################## 
PRE VARS/FUNCTIONS
##########################################################
]]--
local function GetTalentInfo(arg)
  if type(arg) == "number" then 
    return arg == GetActiveSpecGroup();
  else
    return false;
  end 
end;

local function gradient_colored_media()
  local r1,g1,b1 = unpack(SuperVillain.Colors.special)
  local r2,g2,b2 = unpack(SuperVillain.Colors.default)
  SuperVillain.Colors.gradient.special = {"VERTICAL",r1,g1,b1,r2,g2,b2};
end;

local function class_colored_media()
  local cColor1 = SVUI_CLASS_COLORS[SuperVillain.class];
  local cColor2 = RAID_CLASS_COLORS[SuperVillain.class];
  local r1,g1,b1 = cColor1.r,cColor1.g,cColor1.b
  local r2,g2,b2 = cColor2.r*.25, cColor2.g*.25, cColor2.b*.25
  local ir1,ig1,ib1 = (1 - r1), (1 - g1), (1 - b1)
  local ir2,ig2,ib2 = (1 - cColor2.r)*.25, (1 - cColor2.g)*.25, (1 - cColor2.b)*.25
  SuperVillain.db.media.colors.class = {r = r1, g = g1, b = b1, a = 1};
  SuperVillain.db.media.colors.bizzaro = {r = ir1, g = ig1, b = ib1, a = 1};
  SuperVillain.db.media.colors.gradient.class = {"VERTICAL",r2,g2,b2,r1,g1,b1};
  SuperVillain.db.media.colors.gradient.bizzaro = {"VERTICAL",ir2,ig2,ib2,ir1,ig1,ib1};
end;

local function SetFont(fontObject, font, fontSize, fontOutline, fontAlpha, color, shadowColor, offsetX, offsetY)
  if not font then return end;
  fontObject:SetFont(font,fontSize,fontOutline);
  if fontAlpha then 
    fontObject:SetAlpha(fontAlpha)
  end;
  if color and type(color) == "table" then 
    fontObject:SetTextColor(unpack(color))
  end;
  if shadowColor and type(shadowColor) == "table" then 
    fontObject:SetShadowColor(unpack(shadowColor))
  end;
  if offsetX and offsetY then 
    fontObject:SetShadowOffset(offsetX,offsetY)
  end;
end;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
SuperVillain.ClassDispell = RefClassData[SuperVillain.class]['DISPELL'];

function SuperVillain:Refresh_SVUI_Media()
  local fontsize = self.db.common.fontSize
  local unicodesize = self.db.common.unicodeFontSize
  class_colored_media();
  self.Filter:SetRepository(self.global.Filters);
  self.Colors:SetRepository(self.db.media.colors, self.db.media.unitframes);
  self.Fonts:SetRepository(self.db.media.fonts);
  self.Textures:SetRepository(self.db.media.textures);
  gradient_colored_media();
  self.Templates:SetRepository(self.db.media.templates);

  local NUMBER_TEXT_FONT = LSM:Fetch("font", self.protected.common.numberFont);
  local GIANT_TEXT_FONT = LSM:Fetch("font", self.protected.common.giantFont);
  STANDARD_TEXT_FONT = LSM:Fetch("font", self.protected.common.font);
  UNIT_NAME_FONT = LSM:Fetch("font", self.protected.common.nameFont);
  DAMAGE_TEXT_FONT = LSM:Fetch("font", self.protected.common.combatFont);
  NAMEPLATE_FONT = STANDARD_TEXT_FONT
  CHAT_FONT_HEIGHTS = {8,9,10,11,12,13,14,15,16,17,18,19,20}
  UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = fontsize

  SetFont(GameFont_Gigantic, GIANT_TEXT_FONT, fontsize*3, "THICKOUTLINE", 32)
  SetFont(SystemFont_Shadow_Huge1, GIANT_TEXT_FONT, fontsize*1.8, "OUTLINE")
  SetFont(SystemFont_OutlineThick_Huge2, GIANT_TEXT_FONT, fontsize*1.8, "THICKOUTLINE")

  SetFont(QuestFont_Large, UNIT_NAME_FONT, fontsize+4)
  SetFont(ZoneTextString, UNIT_NAME_FONT, fontsize*4.2, "OUTLINE")
  SetFont(SubZoneTextString, UNIT_NAME_FONT, fontsize*3.2, "OUTLINE")
  SetFont(PVPInfoTextString, UNIT_NAME_FONT, fontsize*1.9, "OUTLINE")
  SetFont(PVPArenaTextString, UNIT_NAME_FONT, fontsize*1.9, "OUTLINE")
  SetFont(SystemFont_Shadow_Outline_Huge2, UNIT_NAME_FONT, fontsize*1.8, "OUTLINE")

  SetFont(NumberFont_OutlineThick_Mono_Small, NUMBER_TEXT_FONT, fontsize, "OUTLINE")
  SetFont(NumberFont_Outline_Huge, NUMBER_TEXT_FONT, fontsize*2, "THICKOUTLINE", 28)
  SetFont(NumberFont_Outline_Large, NUMBER_TEXT_FONT, fontsize+4, "OUTLINE")
  SetFont(NumberFont_Outline_Med, NUMBER_TEXT_FONT, fontsize+2, "OUTLINE")
  SetFont(NumberFontNormal, NUMBER_TEXT_FONT, fontsize, "OUTLINE")

  SetFont(GameFontHighlight, STANDARD_TEXT_FONT, fontsize)
  SetFont(GameFontWhite, STANDARD_TEXT_FONT, fontsize, 'OUTLINE', 1, {1,1,1})
  SetFont(GameFontWhiteSmall, STANDARD_TEXT_FONT, fontsize, 'NONE', 1, {1,1,1})
  SetFont(GameFontBlack, STANDARD_TEXT_FONT, fontsize, 'NONE', 1, {0,0,0})
  SetFont(GameFontBlackSmall, STANDARD_TEXT_FONT, fontsize, 'NONE', 1, {0,0,0})
  SetFont(GameFontNormal, STANDARD_TEXT_FONT, fontsize)
  SetFont(QuestFont, STANDARD_TEXT_FONT, fontsize)
  SetFont(SystemFont_Large, STANDARD_TEXT_FONT, fontsize+2)
  SetFont(GameFontNormalMed3, STANDARD_TEXT_FONT, fontsize+1)
  SetFont(SystemFont_Med1, STANDARD_TEXT_FONT, fontsize)
  SetFont(SystemFont_Med3, STANDARD_TEXT_FONT, fontsize)
  SetFont(SystemFont_Outline_Small, STANDARD_TEXT_FONT, fontsize, "OUTLINE")
  SetFont(SystemFont_Shadow_Large, STANDARD_TEXT_FONT, fontsize+2)
  SetFont(SystemFont_Shadow_Med1, STANDARD_TEXT_FONT, fontsize)
  SetFont(SystemFont_Shadow_Med3, STANDARD_TEXT_FONT, fontsize)
  SetFont(SystemFont_Shadow_Small, STANDARD_TEXT_FONT, fontsize)
  SetFont(SystemFont_Small, STANDARD_TEXT_FONT, fontsize)
  SetFont(FriendsFont_Normal, STANDARD_TEXT_FONT, fontsize)
  SetFont(FriendsFont_Small, STANDARD_TEXT_FONT, fontsize-2)
  SetFont(FriendsFont_Large, STANDARD_TEXT_FONT, fontsize)
  SetFont(FriendsFont_UserText, STANDARD_TEXT_FONT, fontsize)

  SetFont(SystemFont_Shadow_Huge3, DAMAGE_TEXT_FONT, 200, "THICKOUTLINE")
  SetFont(CombatTextFont, DAMAGE_TEXT_FONT, 200, "THICKOUTLINE")

  local UNICODE_FONT = self.Fonts.roboto;

  SetFont(GameTooltipHeader, UNICODE_FONT, unicodesize+2)
  SetFont(Tooltip_Med, UNICODE_FONT, unicodesize)
  SetFont(Tooltip_Small, UNICODE_FONT, unicodesize)
  SetFont(GameFontNormalSmall, UNICODE_FONT, unicodesize)
  SetFont(GameFontHighlightSmall, UNICODE_FONT, unicodesize)
  SetFont(NumberFont_Shadow_Med, UNICODE_FONT, unicodesize)
  SetFont(NumberFont_Shadow_Small, UNICODE_FONT, unicodesize)
  SetFont(SystemFont_Tiny, UNICODE_FONT, unicodesize)

  collectgarbage('collect');
end;

function SuperVillain:DispellAvailable(debuffType)
    if not self.ClassDispell then return end;
    if self.ClassDispell[debuffType] then 
      return true 
    end 
end;

function SuperVillain:DefinePlayerRole()
  local spec = GetSpecialization()
  local role;
  if spec then
    role = RefClassData[self.class]['ROLE'][spec]
    if role == "T" and UnitLevel('player') == MAX_PLAYER_LEVEL then
      local bonus,pvp = GetCombatRatingBonus(COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN),false;
      if bonus > GetDodgeChance() and bonus > GetParryChance() then 
        role = "M"
      end;
    end;
  else
    local intellect = select(2,UnitStat("player",4))
    local agility = select(2,UnitStat("player",2))
    local baseAP,posAP,negAP = UnitAttackPower("player")
    local totalAP = baseAP + posAP + negAP;
    if totalAP > intellect or agility > intellect then 
      role="M"
    else 
      role="C"
    end 
  end;
  if self.ClassRole ~= role then 
    self.ClassRole = role;
    self.CallBackHandler:Fire("RoleChanged")
  end;
  if RefClassData[self.class]['MagicSpec'] then 
    if GetTalentInfo(RefClassData[self.class]['MagicSpec']) then 
      self.ClassDispell.Magic=true 
    else 
      self.ClassDispell.Magic=false 
    end 
  end
end;
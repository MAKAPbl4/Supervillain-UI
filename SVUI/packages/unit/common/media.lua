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
local unpack  = _G.unpack;
local select  = _G.select;
local pairs   = _G.pairs;
local ipairs  = _G.ipairs;
local type    = _G.type;
local tinsert   = _G.tinsert;
local string  = _G.string;
local math    = _G.math;
local table   = _G.table;
--[[ STRING METHODS ]]--
local find, format, len, split = string.find, string.format, string.len, string.split;
local gmatch, gsub, join = string.gmatch, string.gsub, string.join;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round, min = math.abs, math.ceil, math.floor, math.round, math.min;
--[[ TABLE METHODS ]]--
local twipe = table.wipe;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, G = unpack(select(2, ...));
local MOD = SuperVillain:GetModule('SVUnit');
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.")
local LSM = LibStub("LibSharedMedia-3.0");
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local CURRENT_BAR_TEXTURE = SuperVillain.Textures.bar;
local CURRENT_AURABAR_TEXTURE = SuperVillain.Textures.glow;
local CURRENT_FONT = SuperVillain.Fonts.Display;
local CURRENT_FONTSIZE = 10;
local CURRENT_FONTOUTLINE = "OUTLINE";
local CURRENT_AURABAR_FONT = SuperVillain.Fonts.Alert;
local CURRENT_AURABAR_FONTSIZE = 14
local CURRENT_AURABAR_FONTOUTLINE = "NONE"
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:UpdateUnitMediaLocals()
  CURRENT_BAR_TEXTURE = LSM:Fetch("statusbar", MOD.db.statusbar)
  CURRENT_AURABAR_TEXTURE = LSM:Fetch("statusbar", MOD.db.auraBarStatusbar);
  CURRENT_FONT = LSM:Fetch("font", MOD.db.font)
  CURRENT_FONTSIZE = MOD.db.fontSize
  CURRENT_FONTOUTLINE = MOD.db.fontOutline
  CURRENT_AURABAR_FONT = LSM:Fetch("font", MOD.db.auraFont);
  CURRENT_AURABAR_FONTSIZE = MOD.db.auraFontSize
  CURRENT_AURABAR_FONTOUTLINE = MOD.db.auraFontOutline
end;

function MOD:SetUnitFont(element, unitName)
  if(not element) then return; end
  if(not unitName or not MOD.db[unitName] or not MOD.db[unitName].name) then
    element:SetFontTemplate(CURRENT_FONT, CURRENT_FONTSIZE, CURRENT_FONTOUTLINE)
    MOD.MediaCache["fonts"][element] = true;
  else
    local db = MOD.db[unitName].name;
    local font = LSM:Fetch("font", db.font);
    element:SetFontTemplate(font, db.fontSize, db.fontOutline)
    if(not MOD.MediaCache["namefonts"][unitName]) then
      MOD.MediaCache["namefonts"][unitName] = {}
    end
    MOD.MediaCache["namefonts"][unitName][element] = true;
  end
end;

function MOD:UpdateUnitFont(unitName)
  if(not unitName) then return; end
  local t = MOD.MediaCache["namefonts"][unitName];
  local db = MOD.db[unitName].name;

  if(db and t) then
    for element in pairs(t) do
      local font = LSM:Fetch("font", db.font);
      element:SetFontTemplate(font, db.fontSize, db.fontOutline)
    end
  end
end;

function MOD:RefreshAuraBarFonts()
  MOD:UpdateUnitMediaLocals()
  for element in pairs(MOD.MediaCache["aurafonts"]) do 
    element.spelltime:SetFontTemplate(CURRENT_AURABAR_FONT, CURRENT_AURABAR_FONTSIZE, CURRENT_AURABAR_FONTOUTLINE, "RIGHT")
    element.spellname:SetFontTemplate(CURRENT_AURABAR_FONT, CURRENT_AURABAR_FONTSIZE, CURRENT_AURABAR_FONTOUTLINE, "LEFT")
  end;
end;

function MOD:RefreshUnitFonts()
  MOD:UpdateUnitMediaLocals()
  for element in pairs(MOD.MediaCache["fonts"]) do 
    element:SetFontTemplate(CURRENT_FONT, CURRENT_FONTSIZE, CURRENT_FONTOUTLINE)
  end; 
end;

function MOD:SetUnitStatusbar(element)
  if(not element or element.noupdate or element:GetObjectType() ~= "StatusBar") then return; end
  element:SetStatusBarTexture(CURRENT_BAR_TEXTURE)
  MOD.MediaCache["bars"][element] = true;
end;

function MOD:RefreshUnitTextures()
  MOD:UpdateUnitMediaLocals()
  for element in pairs(MOD.MediaCache["bars"]) do 
    element:SetStatusBarTexture(CURRENT_BAR_TEXTURE)
  end;
  for element in pairs(MOD.MediaCache["aurabars"]) do
    element.auraBarTexture = CURRENT_AURABAR_TEXTURE
  end;
end;

function MOD:RefreshUnitColors()
  local db = SuperVillain.db.media.unitframes 
  for i,setting in pairs(db) do
    if setting and type(setting) == "table" then
      if(setting.r)then
        oUF_SuperVillain.colors[i] = SuperVillain.Colors:Extract(setting);
      else
        local bt={}
        for x,color in pairs(setting) do
          if(color.r)then
            bt[x]={color.r,color.g,color.b};
          else
            bt[x]=color;
          end
          oUF_SuperVillain.colors[i]=bt;
        end
      end
    elseif setting then
      oUF_SuperVillain.colors[i]=setting;
    end
  end;
  local hC=SuperVillain.Colors:Extract("health")
  local r,g,b=hC[1],hC[2],hC[3]
  oUF_SuperVillain.colors.smooth = {1, 0, 0, 1, 1, 0, r, g, b}; --0.1,0.6,0.02
end
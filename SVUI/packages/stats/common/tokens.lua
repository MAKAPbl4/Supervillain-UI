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

STATS:Extend EXAMPLE USAGE: MOD:Extend(newStat,eventList,onEvents,update,click,focus,blur)

########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack 	= _G.unpack;
local select 	= _G.select;
local pairs 	= _G.pairs;
local ipairs 	= _G.ipairs;
local type 		= _G.type;
local error 	= _G.error;
local pcall 	= _G.pcall;
local assert 	= _G.assert;
local tostring 	= _G.tostring;
local tonumber 	= _G.tonumber;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local lower, upper = string.lower, string.upper;
local find, format, len, split = string.find, string.format, string.len, string.split;
local match, sub, join = string.match, string.sub, string.join;
local gmatch, gsub = string.gmatch, string.gsub;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round, mod = math.abs, math.ceil, math.floor, math.round, math.fmod;  -- Basic
--[[ TABLE METHODS ]]--
local twipe, tsort = table.wipe, table.sort;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain:GetModule('SVStats');
--[[ 
########################################################## 
GOLD STATS
##########################################################
]]--
local TokenEvents = {'PLAYER_ENTERING_WORLD','PLAYER_MONEY','CURRENCY_DISPLAY_UPDATE'};
local TokenMenuFrame = CreateFrame("Frame", "SVUI_TokenMenu", SuperVillain.UIParent);
local TokenMenuList = {};
local TokenParent;

local function TokenInquiry(id, weekly, capped)
  local name, amount, tex, week, weekmax, maxed, discovered = GetCurrencyInfo(id)
  local r, g, b = 1, 1, 1
  for i = 1, GetNumWatchedTokens() do
    local _, _, _, itemID = GetBackpackCurrencyInfo(i)
    if id == itemID then r, g, b = 0.23, 0.88, 0.27 end
  end
  if weekly then
    if discovered then
      if id == 390 then
        MOD.tooltip:AddDoubleLine("\124T"..tex..":12\124t "..name, "Current: "..amount.." | ".." Weekly: "..week.." / "..weekmax, r, g, b, r, g, b)
      else
        MOD.tooltip:AddDoubleLine("\124T"..tex..":12\124t "..name, "Current: "..amount.." / "..maxed.." | ".." Weekly: "..week.." / "..weekmax, r, g, b, r, g, b)
      end
    end
  elseif capped then
    if id == 392 or id == 395 then maxed = 4000 end
    if id == 396 then maxed = 3000 end
    if discovered then
      MOD.tooltip:AddDoubleLine("\124T"..tex..":12\124t "..name, amount.." / "..maxed, r, g, b, r, g, b)
    end
  else
    if discovered then
      MOD.tooltip:AddDoubleLine("\124T"..tex..":12\124t "..name, amount, r, g, b, r, g, b)
    end
  end
end

local function AddToTokenMenu(id)
	local name, _, tex, _, _, _, _ = GetCurrencyInfo(id)
	local itemName = "\124T"..tex..":12\124t "..name;
	local fn = function() 
		SVUI_DATA["Accountant"][SuperVillain.realm]["tokens"][SuperVillain.name] = id;
		MOD.TokensEventHandler(TokenParent)
	end; 
	tinsert(TokenMenuList, {text = itemName, func = fn});
end

function MOD:LoadTokenCache()
	TokenMenuFrame:SetPanelTemplate("Button");
	local prof1, prof2, archaeology, _, cooking = GetProfessions()
	if archaeology then
		AddToTokenMenu(398)
		AddToTokenMenu(384)
		AddToTokenMenu(393)
		AddToTokenMenu(677)
		AddToTokenMenu(400)
		AddToTokenMenu(394)
		AddToTokenMenu(397)
		AddToTokenMenu(676)
		AddToTokenMenu(401)
		AddToTokenMenu(385)
		AddToTokenMenu(399)
	end
	if cooking then
		AddToTokenMenu(81)
		AddToTokenMenu(402)
	end
	if(prof1 == 9 or prof2 == 9) then
		AddToTokenMenu(61)
		AddToTokenMenu(361)
		AddToTokenMenu(698)
	end
	AddToTokenMenu(697, false, true)
	AddToTokenMenu(738)
	AddToTokenMenu(615)
	AddToTokenMenu(614)
	AddToTokenMenu(395, false, true)
	AddToTokenMenu(396, false, true)
	AddToTokenMenu(390, true)
	AddToTokenMenu(392, false, true)
	AddToTokenMenu(391)
	AddToTokenMenu(241)
	AddToTokenMenu(416)
	AddToTokenMenu(515)
	AddToTokenMenu(776)
	AddToTokenMenu(777)
	AddToTokenMenu(789)
end;

function MOD:TokensEventHandler(event,...)
	if not IsLoggedIn() or not self then return end;
	local id = SVUI_DATA["Accountant"][SuperVillain.realm]["tokens"][SuperVillain.name];
	local _, current, tex = GetCurrencyInfo(id)
	local currentText = "\124T"..tex..":12\124t " .. current;
	self.text:SetText(currentText)
end;

function MOD:Tokens_OnEnter()
	MOD:Tip(self)
	MOD.tooltip:AddLine(SuperVillain.name .. "\'s Tokens")

	MOD.tooltip:AddLine(" ")
	MOD.tooltip:AddLine("Common")
	TokenInquiry(241)
	TokenInquiry(416)
	TokenInquiry(515)
	TokenInquiry(776)
	TokenInquiry(777)
	TokenInquiry(789)

	MOD.tooltip:AddLine(" ")
	MOD.tooltip:AddLine("Raiding and Dungeons")
	TokenInquiry(697, false, true)
	TokenInquiry(738)
	TokenInquiry(615)
	TokenInquiry(614)
	TokenInquiry(395, false, true)
	TokenInquiry(396, false, true)

	MOD.tooltip:AddLine(" ")
	MOD.tooltip:AddLine("PvP")
	TokenInquiry(390, true)
	TokenInquiry(392, false, true)
	TokenInquiry(391)

	local prof1, prof2, archaeology, _, cooking = GetProfessions()
	if(archaeology or cooking or prof1 == 9 or prof2 == 9) then
		MOD.tooltip:AddLine(" ")
		MOD.tooltip:AddLine("Professions")
	end
	if cooking then
		TokenInquiry(81)
		TokenInquiry(402)
	end
	if(prof1 == 9 or prof2 == 9) then
		TokenInquiry(61)
		TokenInquiry(361)
		TokenInquiry(698)
	end
	if archaeology then
		TokenInquiry(398)
		TokenInquiry(384)
		TokenInquiry(393)
		TokenInquiry(677)
		TokenInquiry(400)
		TokenInquiry(394)
		TokenInquiry(397)
		TokenInquiry(676)
		TokenInquiry(401)
		TokenInquiry(385)
		TokenInquiry(399)
	end
	MOD.tooltip:AddLine(" ")
  	MOD.tooltip:AddDoubleLine("[Shift + Click]", "Change Watched Token", 0,1,0, 0.5,1,0.5)
	MOD:ShowTip(true)
end;

function MOD:Tokens_OnClick(button)
	TokenParent = self;
	SuperVillain:SetUIMenu(TokenMenuList, TokenMenuFrame, self, true, 0, 0, 200) 
end;

MOD:Extend('Tokens', TokenEvents, MOD.TokensEventHandler, nil, MOD.Tokens_OnClick, MOD.Tokens_OnEnter)
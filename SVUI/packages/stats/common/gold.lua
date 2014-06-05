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
local StatEvents = {'PLAYER_ENTERING_WORLD','PLAYER_MONEY','SEND_MAIL_MONEY_CHANGED','SEND_MAIL_COD_CHANGED','PLAYER_TRADE_MONEY','TRADE_MONEY_CHANGED'};
local gains = 0;
local loss = 0;
local recorded = 0;
local copperFormat = join("","%d",L.copperabbrev)
local silverFormat = join("","%d",L.silverabbrev," %.2d",L.copperabbrev)
local goldFormat = join("","%s",L.goldabbrev," %.2d",L.silverabbrev," %.2d",L.copperabbrev)
local tiptext = join("","|cffaaaaaa",L["Reset Data: Hold Left Ctrl + Shift then Click"],"|r")
local serverGold = {};

local function FormatCurrency(amount)
	if not amount then return end;
	local gold, silver, copper = floor(abs(amount/10000)), abs(mod(amount/100,100)), abs(mod(amount,100))
	if gold ~= 0 then 
		return format(goldFormat, BreakUpLargeNumbers(gold), silver, copper)
	elseif silver ~= 0 then 
		return format(silverFormat, silver, copper)
	else 
		return format(copperFormat, copper)
	end 
end;

function MOD:LoadServerGold()
	local totalGold = 0;
	for name,amount in pairs(SVUI_DATA["Accountant"][SuperVillain.realm]["gold"])do 
		if SVUI_DATA["Accountant"][SuperVillain.realm]["gold"][name] then 
			serverGold[name] = amount;
			totalGold = totalGold + amount
		end 
	end;
	serverGold['total'] = totalGold;
end;

function MOD:GoldEventHandler(event,...)
	if not IsLoggedIn() then return end;
	local current = GetMoney()
	recorded = SVUI_DATA["Accountant"][SuperVillain.realm]["gold"][SuperVillain.name] or GetMoney();
	local adjusted = current - recorded;
	if recorded > current then 
		loss = loss - adjusted 
	else 
		gains = gains + adjusted 
	end;
	self.text:SetText(FormatCurrency(current))
	SVUI_DATA["Accountant"][SuperVillain.realm]["gold"][SuperVillain.name] = GetMoney()
end;

function MOD:Gold_OnClick(button)
	if IsLeftControlKeyDown() and IsShiftKeyDown() then
		SVUI_DATA["Accountant"][SuperVillain.realm]["gold"] = {};
		SVUI_DATA["Accountant"][SuperVillain.realm]["gold"][SuperVillain.name] = GetMoney();
		MOD.GoldEventHandler(self)
		MOD.tooltip:Hide()
	else 
		ToggleAllBags()
	end 
end;

function MOD:Gold_OnEnter()
	MOD:Tip(self)
	MOD.tooltip:AddLine(L['Session:'])
	MOD.tooltip:AddDoubleLine(L["Earned:"],FormatCurrency(gains),1,1,1,1,1,1)
	MOD.tooltip:AddDoubleLine(L["Spent:"],FormatCurrency(loss),1,1,1,1,1,1)
	if gains < loss then 
		MOD.tooltip:AddDoubleLine(L["Deficit:"],FormatCurrency(gains - loss),1,0,0,1,1,1)
	elseif (gains - loss) > 0 then 
		MOD.tooltip:AddDoubleLine(L["Profit:"],FormatCurrency(gains - loss),0,1,0,1,1,1)
	end;
	MOD.tooltip:AddLine(" ")
	local cash = SVUI_DATA["Accountant"][SuperVillain.realm]["gold"][SuperVillain.name];
	MOD.tooltip:AddLine(L[""..SuperVillain.name..": "])
	MOD.tooltip:AddDoubleLine(L["Total: "], FormatCurrency(cash), 1,1,1,1,1,1)
	MOD.tooltip:AddLine(" ")

	MOD.tooltip:AddLine(L["Characters: "])
	for name,amount in pairs(serverGold)do
		if(name ~= SuperVillain.name and name ~= 'total') then
			cash = cash + amount;
			MOD.tooltip:AddDoubleLine(name, FormatCurrency(amount), 1,1,1,1,1,1)
		end
	end;
	MOD.tooltip:AddLine(" ")
	MOD.tooltip:AddLine(L["Server: "])
	MOD.tooltip:AddDoubleLine(L["Total: "], FormatCurrency(cash), 1,1,1,1,1,1)
	MOD.tooltip:AddLine(" ")
	MOD.tooltip:AddLine(tiptext)
	MOD:ShowTip()
end;

MOD:Extend('Gold', StatEvents, MOD.GoldEventHandler, nil, MOD.Gold_OnClick, MOD.Gold_OnEnter)
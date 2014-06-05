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
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;  -- Basic
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
TIME STATS
##########################################################
]]--
local a={TIMEMANAGER_PM,TIMEMANAGER_AM}
local c=''
local d=''
local e=join("","%02d",":|r%02d")
local f=join("","","%d",":|r%02d"," %s|r")
local h="%d:%02d:%02d"
local i="%d:%02d"
local j="%s%s |cffaaaaaa(%s, %s/%s)"
local k="%s%s |cffaaaaaa(%s)"
local l="%s: "
local m,n={r=0.3,g=1,b=0.3},{r=.8,g=.8,b=.8}
local o={"%dd %02dh %02dm","%dd %dh %02dm","%02dh %02dm","%dh %02dm","%dh %02dm","%dm"}
local p,q,s;
local t=false;
local Time_OnUpdate,u;
local v,w,x,y,z,A;
local B,C,D,E,F,G,H,I,J;

local function N(O,P)
	local Q;
	if MOD.db.time24==true then 
		return O,P,-1;
	else 
		if O >= 12 then 
			if O > 12 then 
				O=O-12 
			end;
			Q=1 
		else 
			if O==0 then 
				O=12 
			end;
			Q=2 
		end 
	end;
	return O,P,Q 
end;

local function R(tooltip)
	if tooltip and MOD.db.localtime or not tooltip and not MOD.db.localtime then 
		return N(GetGameTime())
	else 
		local S=date("*t")
		return N(S["hour"],S["min"])
	end 
end;

local function T(U)
	local V=floor(U/3600)
	local W=floor(U/60-V*60)
	local X=U-V*3600-W*60;
	return V,W,X 
end;

local function Y(X)
	local Z,O,P,_=ChatFrame_TimeBreakDown(floor(X))
	if not type(Z)=='number'or not type(O)=='number'or not type(P)=='number'or not type(_)=='number' then return'N/A'end;
	if Z>0 and o[O>10 and 1 or 2]then 
		return format(o[O>10 and 1 or 2],Z,O,P)
	end;
	if O>0 and o[O>10 and 3 or 4]then 
		return format(o[O>10 and 3 or 4],O,P)
	end;
	if P>0 and o[P>10 and 5 or 6]then 
		return format(o[P>10 and 5 or 6],P)
	end 
end;

local function a0()GameTimeFrame:Click()end;

local function a1(a2)MOD.tooltip:Hide()t=false end;

local function a3(a2)MOD:Tip(a2)t=true;MOD.tooltip:AddLine(VOICE_CHAT_BATTLEGROUND)for a4=1,GetNumWorldPVPAreas()do A,v,w,x,y,z=GetWorldPVPAreaInfo(a4)if z then if w then y=WINTERGRASP_IN_PROGRESS elseif y==nil then y=QUEUE_TIME_UNAVAILABLE else local O,P,_=T(y)if O>0 then y=format(h,O,P,_)else y=format(i,P,_)end end;MOD.tooltip:AddDoubleLine(format(l,v),y,1,1,1,n.r,n.g,n.b)end end;local a5,a6;for a4=1,GetNumSavedInstances()do B,A,C,A,D,E,A,F,G,H,I,J=GetSavedInstanceInfo(a4)if F and D or E and B then local a7,a8,a9,aa;if not a5 then MOD.tooltip:AddLine(" ")MOD.tooltip:AddLine(L["Saved Raid(s)"])a5=true end;if E then a6=m else a6=n end;if I and I>0 and J and J>0 then MOD.tooltip:AddDoubleLine(format(j,G,H:match("Heroic")and"H"or"N",B,J,I),Y(C),1,1,1,a6.r,a6.g,a6.b)else MOD.tooltip:AddDoubleLine(format(k,G,H:match("Heroic")and"H"or"N",B),Y(C),1,1,1,a6.r,a6.g,a6.b)end end end;local ab=IsQuestFlaggedCompleted(32099)local ac=IsQuestFlaggedCompleted(32098)local ad=IsQuestFlaggedCompleted(32519)local ae=IsQuestFlaggedCompleted(32518)local af=IsQuestFlaggedCompleted(33117)local ag=IsQuestFlaggedCompleted(33118)MOD.tooltip:AddLine(" ")MOD.tooltip:AddLine(L["World Boss(s)"])MOD.tooltip:AddDoubleLine(L['Sha of Anger']..':',ab and L['Defeated']or L['Undefeated'],1,1,1,0.8,0.8,0.8)MOD.tooltip:AddDoubleLine(L['Galleon']..':',ac and L['Defeated']or L['Undefeated'],1,1,1,0.8,0.8,0.8)MOD.tooltip:AddDoubleLine(L['Oondasta']..':',ad and L['Defeated']or L['Undefeated'],1,1,1,0.8,0.8,0.8)MOD.tooltip:AddDoubleLine(L['Nalak']..':',ae and L['Defeated']or L['Undefeated'],1,1,1,0.8,0.8,0.8)MOD.tooltip:AddDoubleLine(L['Celestials']..':',af and L['Defeated']or L['Undefeated'],1,1,1,0.8,0.8,0.8)MOD.tooltip:AddDoubleLine(L['Ordos']..':',ag and L['Defeated']or L['Undefeated'],1,1,1,0.8,0.8,0.8)local ah;local ai,aj,Q=R(true)MOD.tooltip:AddLine(" ")if Q==-1 then MOD.tooltip:AddDoubleLine(MOD.db.localtime and TIMEMANAGER_TOOLTIP_REALMTIME or TIMEMANAGER_TOOLTIP_LOCALTIME,format(e,ai,aj),1,1,1,n.r,n.g,n.b)else MOD.tooltip:AddDoubleLine(MOD.db.localtime and TIMEMANAGER_TOOLTIP_REALMTIME or TIMEMANAGER_TOOLTIP_LOCALTIME,format(f,ai,aj,a[Q]),1,1,1,n.r,n.g,n.b)end;MOD:ShowTip()end;

local ak=3;

function Time_OnUpdate(a2, al)
	ak = ak - al;
	if ak > 0 then
		return 
	end;
	if t then
		a3(a2)
	end;
	local ai, aj, Q = R(false)
	if ai == p and aj == q and Q == s and not(ak < -15000) then
		ak = 5;
		return 
	end;
	if GameTimeFrame.flashInvite then
		SuperVillain.Animate:Flash(a2, 0.53)
	else
		SuperVillain.Animate:StopFlash(a2)
	end;
	p = ai;
	q = aj;
	s = Q;
	if Q == -1 then
		a2.text:SetFormattedText(c, ai, aj)
	else
		a2.text:SetFormattedText(d, ai, aj, a[Q])
	end;
	u = a2;
	ak = 5
	if(TimeManagerClockButton and TimeManagerClockButton:IsShown()) then
		TimeManagerClockButton:MUNG()
	end
end;

local K=function()
	local M=SuperVillain.Colors:Hex("highlight");
	local r,g,b=unpack(SuperVillain.Colors.highlight)
	c=join("","%02d",M,":|r%02d")
	d=join("","","%d",M,":|r%02d",M," %s|r")
	if u~=nil then 
		Time_OnUpdate(u,20000)
	end 
end;

SuperVillain.Colors:Register(K)

MOD:Extend('Time',nil,nil,Time_OnUpdate,a0,a3,a1)
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
SYSTEM STATS
##########################################################
]]--
local a,b=6,5;
local c={"|cff0CD809","|cffE8DA0F","|cffFF9000","|cffD80909"}
local d=false;
local e="%.2f Mbps"
local f="%.2f%%"
local g="%d ms"
local h="%d kb"
local i="%.2f mb"
local j=0;
local k=0;
local function l(m)local n=10^1;if m>999 then local o=m/1024*n/n;return format(i,o)else local o=m*n/n;return format(h,o)end end;
local p={}
local q={}
local function r()local s=GetNumAddOns()if s==#p then return end;p={}q={}for t=1,s do p[t]={t,select(2,GetAddOnInfo(t)),0,IsAddOnLoaded(t)}q[t]={t,select(2,GetAddOnInfo(t)),0,IsAddOnLoaded(t)}end end;local function u()UpdateAddOnMemoryUsage()j=0;for t=1,#p do p[t][3]=GetAddOnMemoryUsage(p[t][1])j=j+p[t][3]end;sort(p,function(v,w)if v and w then return v[3]>w[3]end end)end;
local function x()UpdateAddOnCPUUsage()local y=0;local z=0;for t=1,#q do y=GetAddOnCPUUsage(q[t][1])q[t][3]=y;z=z+y end;sort(q,function(v,w)if v and w then return v[3]>w[3]end end)return z end;local function A()collectgarbage("collect")ResetCPUUsage()end;
local function B(C)
	d=true;
	local D=GetCVar("scriptProfile")=="1"
	MOD:Tip(C)
	u()
	k=GetAvailableBandwidth()
	MOD.tooltip:AddDoubleLine(L['Home Latency:'],format(g,select(3,GetNetStats())),0.69,0.31,0.31,0.84,0.75,0.65)
	if k~=0 then 
		MOD.tooltip:AddDoubleLine(L['Bandwidth'],format(e,k),0.69,0.31,0.31,0.84,0.75,0.65)
		MOD.tooltip:AddDoubleLine(L['Download'],format(f,GetDownloadedPercentage()*100),0.69,0.31,0.31,0.84,0.75,0.65)
		MOD.tooltip:AddLine(" ")
	end;
	local z=nil;
	MOD.tooltip:AddDoubleLine(L['Total Memory:'],l(j),0.69,0.31,0.31,0.84,0.75,0.65)
	if D then 
		z=x()
		MOD.tooltip:AddDoubleLine(L['Total CPU:'],format(g,z),0.69,0.31,0.31,0.84,0.75,0.65)
	end;
	local E,F;
	if IsShiftKeyDown() or not D then 
		MOD.tooltip:AddLine(" ")
		for t=1,#p do 
			if p[t][4]then 
				E=p[t][3]/j;
				F=1-E;
				MOD.tooltip:AddDoubleLine(p[t][2],l(p[t][3]),1,1,1,E,F+.5,0)
			end 
		end 
	end;
	if D and not IsShiftKeyDown()then 
		MOD.tooltip:AddLine(" ")
		for t=1,#q do 
			if q[t][4]then 
				E=q[t][3]/z;
				F=1-E;
				MOD.tooltip:AddDoubleLine(q[t][2],format(g,q[t][3]),1,1,1,E,F+.5,0)
			end 
		end;
		MOD.tooltip:AddLine(" ")
		MOD.tooltip:AddLine(L['(Hold Shift) Memory Usage'])
	end;
	MOD:ShowTip()
end;
local function G(C)d=false;MOD.tooltip:Hide()end;
local function H(C,I)a=a-I;b=b-I;if a<0 then r()a=10 end;if b<0 then local J=floor(GetFramerate())local K=select(4,GetNetStats())C.text:SetFormattedText("FPS: %s%d|r MS: %s%d|r",c[J>=30 and 1 or J>=20 and J<30 and 2 or J>=10 and J<20 and 3 or 4],J,c[K<150 and 1 or K>=150 and K<300 and 2 or K>=300 and K<500 and 3 or 4],K)b=1;if d then B(C)end end end;
MOD:Extend('System',nil,nil,H,A,B,G)
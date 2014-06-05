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
local type 		= _G.type;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;
--[[ TABLE METHODS ]]--
local tremove = table.remove;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, G = unpack(select(2, ...));
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local timeOutQueue={};
local timeOutManager;
local timerFont = SuperVillain.Fonts.numbers
--[[ 
########################################################## 
LOCAL UNUSED
##########################################################
]]--
--[[
local function TickTock(expires,fadeTime)
	local calcTime,newTime,nextTime;
	if expires < 60 then 
		if expires >= fadeTime then 
			return floor(expires), "|cffffff00%d|r", 0.51 
		else 
			return expires, "|cffff0000%.1f|r", 0.051 
		end 
	elseif expires < 3600 then
		newTime = expires / 60;
		calcTime = floor(newTime + .5);
		nextTime = calcTime > 1 and ((expires - calcTime) * 29.5) or (expires - 59.5);
		return ceil(newTime),  "|cffffffff%dm|r", nextTime;
	elseif expires < 86400 then
		newTime = expires / 3600;
		calcTime = floor(newTime + .5);
		nextTime = calcTime > 1 and ((expires - calcTime) * 1799.5) or (expires - 3570);
		return ceil(newTime),  "|cff66ffff%dh|r", nextTime;
	else
		newTime = expires / 86400;
		calcTime = floor(newTime + .5);
		nextTime = calcTime > 1 and ((expires - calcTime) * 43199.5) or (expires - 86400);
		return ceil(newTime),  "|cff6666ff%dd|r", nextTime
	end 
end;
]]--
--[[ 
########################################################## 
GLOBAL TIMEOUT QUEUE
##########################################################
]]--
function SuperVillain:SetTimeout(duration,timeOutFunction,...)
	if type(duration)~="number" or type(timeOutFunction)~="function" then 
		return false 
	end;
	if timeOutManager==nil then 
		timeOutManager=CreateFrame("Frame","SVUI_TimeOutManager",SuperVillain.UIParent)
		timeOutManager:SetScript("OnUpdate",function(_,value)
			local queued = #timeOutQueue;
			local count = 1;
			while count <= queued do 
				local nextProcess = tremove(timeOutQueue, count)
				local time = tremove(nextProcess,1)
				local func = tremove(nextProcess,1)
				local args = tremove(nextProcess,1)
				if time > value then 
					tinsert(timeOutQueue, count, {time - value, func, args})
					count = count + 1 
				else 
					queued = queued - 1;
					func(unpack(args))
				end 
			end 
		end)
	end;
	tinsert(timeOutQueue, {duration, timeOutFunction, {...}})
	return true 
end;
--[[ 
########################################################## 
TIMER FUNCTIONS
##########################################################
]]--
local Cooldown_ForceUpdate = function(self)
	self.nextUpdate = 0;
	self:Show()
end;

local Cooldown_StopTimer = function(self)
	self.enable = nil;
	self:Hide()
end;

local Cooldown_OnUpdate = function(self, elapsed)
	if self.nextUpdate > 0 then 
		self.nextUpdate = self.nextUpdate - elapsed;
		return 
	end;
	local expires = (self.duration - (GetTime() - self.start));
	if expires > 0.05 then 
		if (self.fontScale * self:GetEffectiveScale() / UIParent:GetScale()) < 0.5 then 
			self.text:SetText('')
			self.nextUpdate = 500 
		else 
			local timeLeft = 0;
			local calc = 0;
			if expires < 4 then
				self.nextUpdate = 0.051
				self.text:SetFormattedText("|cffff0000%.1f|r", expires)
			elseif expires < 60 then 
				self.nextUpdate = 0.51
				self.text:SetFormattedText("|cffffff00%d|r", floor(expires)) 
			elseif expires < 3600 then
				timeLeft = ceil(expires / 60);
				calc = floor((expires / 60) + .5);
				self.nextUpdate = calc > 1 and ((expires - calc) * 29.5) or (expires - 59.5);
				self.text:SetFormattedText("|cffffffff%dm|r", timeLeft)
			elseif expires < 86400 then
				timeLeft = ceil(expires / 3600);
				calc = floor((expires / 3600) + .5);
				self.nextUpdate = calc > 1 and ((expires - calc) * 1799.5) or (expires - 3570);
				self.text:SetFormattedText("|cff66ffff%dh|r", timeLeft)
			else
				timeLeft = ceil(expires / 86400);
				calc = floor((expires / 86400) + .5);
				self.nextUpdate = calc > 1 and ((expires - calc) * 43199.5) or (expires - 86400);
				self.text:SetFormattedText("|cff6666ff%dd|r", timeLeft)
			end
		end
	else 
		Cooldown_StopTimer(self)
	end 
end;

local function ModifyCoolSize(self, size, override)
	local newSize = floor(size + .5) / 36;
	override = override or self:GetParent():GetParent().SizeOverride;
	if override then
		newSize = override / 20 
	end;
	if newSize == self.fontScale then 
		return 
	end;
	self.fontScale = newSize;
	if newSize < 0.5 and not override then 
		self:Hide()
	else 
		self:Show()
		self.text:SetFont(timerFont, newSize * 15, 'OUTLINE')
		if self.enable then 
			Cooldown_ForceUpdate(self)
		end 
	end 
end;

local function CreateCoolTimer(self)
	local timer = CreateFrame('Frame', nil, self)
	timer:Hide()
	timer:SetAllPoints()
	timer:SetScript('OnUpdate', Cooldown_OnUpdate)

	local timeText = timer:CreateFontString(nil,'OVERLAY')
	timeText:SetPoint('CENTER',1,1)
	timeText:SetJustifyH("CENTER")
	timer.text = timeText;

	self.timer = timer;

	ModifyCoolSize(self.timer, self:GetSize(), self.SizeOverride)
	self:SetScript('OnSizeChanged',function(_,...)
		ModifyCoolSize(timer,...)
	end)
	
	return self.timer 
end;

local Cooldown_OnLoad = function(self, start, duration, elapsed)
	if start > 0 and duration > 2.5 then 
		local timer = self.timer or CreateCoolTimer(self)
		timer.start = start;
		timer.duration = duration;
		timer.enable = true;
		timer.nextUpdate = 0;
		
		if timer.fontScale >= 0.5 then 
			timer:Show()
		end 
	else 
		local timer = self.timer;
		if timer then 
			Cooldown_StopTimer(timer)
		end 
	end;
	if self.timer then 
		if elapsed and elapsed > 0 then 
			self.timer:SetAlpha(0)
		else 
			self.timer:SetAlpha(1)
		end 
	end 
end;

function SuperVillain:AddCD(cooldown)
	if not SuperVillain.protected.common.cooldown.enable then return end;
	hooksecurefunc(cooldown,"SetCooldown",Cooldown_OnLoad)
end;
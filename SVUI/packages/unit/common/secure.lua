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
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain:GetModule('SVUnit');
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.")
--[[ 
########################################################## 
LOCAL VARIABLES
##########################################################
]]--
local definedEnvs,tags={},{};
local format,twipe,ceil,sqrt,min,random = string.format,table.wipe,math.ceil,math.sqrt,math.min,math.random;
local CharacterSelect = {"Munglunch", "Elv", "Tukz", "Azilroka", "Sortokk", "AlleyKat", "Quokka", "Haleth", "P3lim", "Haste", "Totalpackage", "Kryso", "Thepilli", "Doonga", "Judicate", "Cazart506", "Movster", "MuffinMonster", "Joelsoul", "Trendkill09", "Luamar", "Zharooz", "Lyn3x5", "Madh4tt3r", "Xarioth", "Sinnisterr", "Melonmaniac", "Hojowameeat", "Xandeca", "Bkan", "Daigan", "AtomicKiller", "Meljen", "Moondoggy", "Stormblade", "Schreibstift", "Anj", "Risien", "", ""};
local _PROXY;
local _ENV = {
	UnitPower = function(unit, g)
		if unit:find('target') or unit:find('focus') then 
			return UnitPower(unit, g)
		end;
		return random(1, UnitPowerMax(unit, g)or 1)
	end, 
	UnitHealth = function(unit)
		if unit:find('target') or unit:find('focus') then 
			return UnitHealth(unit)
		end;
		return random(1, UnitHealthMax(unit))
	end, 
	UnitName = function(unit)
		if unit:find('target') or unit:find('focus') then 
			return UnitName(unit)
		end;
		local randomSelect = random(1, 40)
		local name = CharacterSelect[randomSelect];
		return name
	end, 
	UnitClass = function(unit)
		if unit:find('target') or unit:find('focus') then 
			return UnitClass(unit)
		end;
		local token = CLASS_SORT_ORDER[random(1, #(CLASS_SORT_ORDER))]
		return LOCALIZED_CLASS_NAMES_MALE[token], token 
	end,
	Hex = function(r, g, b)
		if type(r) == "table" then
			if r.r then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return format("|cff%02x%02x%02x", r*255, g*255, b*255)
	end,
	ColorGradient = oUF_SuperVillain.ColorGradient,
};
local _GSORT = {
	['CLASS']=function(frame)
		frame:SetAttribute("groupingOrder","DEATHKNIGHT,DRUID,HUNTER,MAGE,PALADIN,PRIEST,SHAMAN,WARLOCK,WARRIOR,MONK")
		frame:SetAttribute('sortMethod','NAME')
		frame:SetAttribute("sortMethod",'CLASS')
	end,
	['MTMA']=function(frame)
		frame:SetAttribute("groupingOrder","MAINTANK,MAINASSIST,NONE")
		frame:SetAttribute('sortMethod','NAME')
		frame:SetAttribute("sortMethod",'ROLE')
	end,
	['ROLE']=function(frame)
		frame:SetAttribute("groupingOrder","TANK,HEALER,DAMAGER,NONE")
		frame:SetAttribute('sortMethod','NAME')
		frame:SetAttribute("sortMethod",'ASSIGNEDROLE')
	end,
	['ROLE_TDH']=function(frame)
		frame:SetAttribute("groupingOrder","TANK,DAMAGER,HEALER,NONE")
		frame:SetAttribute('sortMethod','NAME')
		frame:SetAttribute("sortMethod",'ASSIGNEDROLE')
	end,
	['ROLE_HTD']=function(frame)
		frame:SetAttribute("groupingOrder","HEALER,TANK,DAMAGER,NONE")
		frame:SetAttribute('sortMethod','NAME')
		frame:SetAttribute("sortMethod",'ASSIGNEDROLE')
	end,
	['ROLE_HDT']=function(frame)
		frame:SetAttribute("groupingOrder","HEALER,DAMAGER,TANK,NONE")
		frame:SetAttribute('sortMethod','NAME')
		frame:SetAttribute("sortMethod",'ASSIGNEDROLE')
	end,
	['NAME']=function(frame)
		frame:SetAttribute("groupingOrder","1,2,3,4,5,6,7,8")
		frame:SetAttribute('sortMethod','NAME')
		frame:SetAttribute("sortMethod",nil)
	end,
	['GROUP']=function(frame)
		frame:SetAttribute("groupingOrder","1,2,3,4,5,6,7,8")
		frame:SetAttribute('sortMethod','INDEX')
		frame:SetAttribute("sortMethod",'GROUP')
	end,
	['PETNAME']=function(frame)
		frame:SetAttribute("groupingOrder","1,2,3,4,5,6,7,8")
		frame:SetAttribute('sortMethod','NAME')
		frame:SetAttribute("sortMethod",nil)
		frame:SetAttribute("filterOnPet",true)
	end
};
local _POINTMAP = {
	["DOWN_RIGHT"] = {[1]="TOP",[2]="TOPLEFT",[3]="LEFT",[4]="RIGHT",[5]="LEFT",[6]=1,[7]=-1,[8]=false},
	["DOWN_LEFT"] = {[1]="TOP",[2]="TOPRIGHT",[3]="RIGHT",[4]="LEFT",[5]="RIGHT",[6]=1,[7]=-1,[8]=false},
	["UP_RIGHT"] = {[1]="BOTTOM",[2]="BOTTOMLEFT",[3]="LEFT",[4]="RIGHT",[5]="LEFT",[6]=1,[7]=1,[8]=false},
	["UP_LEFT"] = {[1]="BOTTOM",[2]="BOTTOMRIGHT",[3]="RIGHT",[4]="LEFT",[5]="RIGHT",[6]=-1,[7]=1,[8]=false},
	["RIGHT_DOWN"] = {[1]="LEFT",[2]="TOPLEFT",[3]="TOP",[4]="BOTTOM",[5]="TOP",[6]=1,[7]=-1,[8]=true},
	["RIGHT_UP"] = {[1]="LEFT",[2]="BOTTOMLEFT",[3]="BOTTOM",[4]="TOP",[5]="BOTTOM",[6]=1,[7]=1,[8]=true},
	["LEFT_DOWN"] = {[1]="RIGHT",[2]="TOPRIGHT",[3]="TOP",[4]="BOTTOM",[5]="TOP",[6]=-1,[7]=-1,[8]=true},
	["LEFT_UP"] = {[1]="RIGHT",[2]="BOTTOMRIGHT",[3]="BOTTOM",[4]="TOP",[5]="BOTTOM",[6]=-1,[7]=1,[8]=true},
	["UP"] = {[1]="BOTTOM",[2]="BOTTOM",[3]="BOTTOM",[4]="TOP",[5]="TOP",[6]=1,[7]=1,[8]=false},
	["DOWN"] = {[1]="TOP",[2]="TOP",[3]="TOP",[4]="BOTTOM",[5]="BOTTOM",[6]=1,[7]=1,[8]=false},
	["CUSTOM1"] = {
		['TOPTOP'] = 'UP_RIGHT',
		['BOTTOMBOTTOM'] = 'TOP_RIGHT',
		['LEFTLEFT'] = 'RIGHT_UP',
		['RIGHTRIGHT'] = 'LEFT_UP',
		['RIGHTTOP'] = 'LEFT_DOWN',
		['LEFTTOP'] = 'RIGHT_DOWN',
		['LEFTBOTTOM'] = 'RIGHT_UP',
		['RIGHTBOTTOM'] = 'LEFT_UP',
		['BOTTOMRIGHT'] = 'UP_LEFT',
		['BOTTOMLEFT'] = 'UP_RIGHT',
		['TOPRIGHT'] = 'DOWN_LEFT',
		['TOPLEFT'] = 'DOWN_RIGHT'
	}
};
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function dbMapping(frame)
	local db = MOD.db[frame.NameKey]
	if db.showBy=="UP" then 
		db.showBy="UP_RIGHT"
	end;
	if db.showBy=="DOWN" then 
		db.showBy="DOWN_RIGHT"
	end 
end;

local function SetProxyEnv()
	if(_PROXY ~= nil) then return end;
	_PROXY = setmetatable(_ENV, {__index = _G, __newindex = function(_,key,value) _G[key]=value end});
	tags['namecolor'] = oUF_SuperVillain.Tags.Methods['namecolor']
	for i=1, 30 do
		tags['name:'..i] = oUF_SuperVillain.Tags.Methods['name:'..i]
	end
	tags['healthcolor'] = oUF_SuperVillain.Tags.Methods['healthcolor']
	tags['health:current'] = oUF_SuperVillain.Tags.Methods['health:current']
	tags['health:deficit'] = oUF_SuperVillain.Tags.Methods['health:deficit']
	tags['health:current-percent'] = oUF_SuperVillain.Tags.Methods['health:current-percent']
	tags['health:current-max'] = oUF_SuperVillain.Tags.Methods['health:current-max']
	tags['health:current-max-percent'] = oUF_SuperVillain.Tags.Methods['health:current-max-percent']
	tags['health:max'] = oUF_SuperVillain.Tags.Methods['health:max']
	tags['health:percent'] = oUF_SuperVillain.Tags.Methods['health:percent']
	tags['powercolor'] = oUF_SuperVillain.Tags.Methods['powercolor']
	tags['power:current'] = oUF_SuperVillain.Tags.Methods['power:current']
	tags['power:deficit'] = oUF_SuperVillain.Tags.Methods['power:deficit']
	tags['power:current-percent'] = oUF_SuperVillain.Tags.Methods['power:current-percent']
	tags['power:current-max'] = oUF_SuperVillain.Tags.Methods['power:current-max']
	tags['power:current-max-percent'] = oUF_SuperVillain.Tags.Methods['power:current-max-percent']
	tags['power:max'] = oUF_SuperVillain.Tags.Methods['power:max']
	tags['power:percent'] = oUF_SuperVillain.Tags.Methods['power:percent']
end;
local function AllowElement(unitFrame)
	if InCombatLockdown()then return end;
	if not unitFrame.isForced then 
		unitFrame.sourceElement = unitFrame.unit;
		unitFrame.unit = 'player'
		unitFrame.isForced = true;
		unitFrame.sourceEvent = unitFrame:GetScript("OnUpdate")
	end;
	unitFrame:SetScript("OnUpdate",nil)
	unitFrame.forceShowAuras=true;
	UnregisterUnitWatch(unitFrame)
	RegisterUnitWatch(unitFrame,true)
	unitFrame:Show()
	if unitFrame:IsVisible() and unitFrame.Update then 
		unitFrame:Update()
	end 
end;
local function RestrictElement(unitFrame)
	if InCombatLockdown()then return end;
	if not unitFrame.isForced then 
		return 
	end;
	unitFrame.forceShowAuras = nil;
	unitFrame.isForced = nil;
	UnregisterUnitWatch(unitFrame)
	RegisterUnitWatch(unitFrame)
	if unitFrame.sourceEvent then 
		unitFrame:SetScript("OnUpdate",unitFrame.sourceEvent)
		unitFrame.sourceEvent = nil 
	end;
	unitFrame.unit = unitFrame.sourceElement or unitFrame.unit;
	if unitFrame:IsVisible() and unitFrame.Update then 
		unitFrame:Update()
	end 
end;
local function AllowChildren(group,...)
	group.isForced = true;
	for i=1,select("#",...) do 
		local childFrame = select(i,...)
		childFrame:RegisterForClicks(nil)
		childFrame:SetID(i)
		childFrame.TargetGlow:SetAlpha(0)
		AllowElement(childFrame)
	end 
end;
local function RestrictChildren(group,...)
	group.isForced = nil;
	local db = MOD.db or SuperVillain.db.SVUnit;
	for i=1,select("#",...) do 
		local childFrame = select(i,...)
		childFrame:RegisterForClicks(db.fastClickTarget and 'AnyDown' or 'AnyUp')
		childFrame.TargetGlow:SetAlpha(1)
		RestrictElement(childFrame)
	end 
end;
local function ChangeGroupIndex(group)
	if not group:GetParent().forceShow and not group.forceShow then return end;
	if not group:IsShown() then return end;
	local max = MAX_RAID_MEMBERS;
	local db = group.db;
	if db then
		local newIndex = db.rSort and ( -min(db.gCount * (db.gRowCol * 5), max) + 1 ) or -4;
		if group:GetAttribute("startingIndex") ~= newIndex then 
			group:SetAttribute("startingIndex", newIndex)
			AllowChildren(group,group:GetChildren())
		end
	end
end;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:DetachSubFrames(...)
	for i=1,select("#",...) do 
		local frame=select(i,...)
		frame:ClearAllPoints()
	end 
end;

function MOD:SwapElement(unitName,count)
	if InCombatLockdown()then return end;
	for i=1,count do 
		if self[unitName..i] and not self[unitName..i].isForced then 
			AllowElement(self[unitName..i])
		elseif self[unitName..i] then 
			RestrictElement(self[unitName..i])
		end 
	end 
end;

local attrOverride = {
	["showRaid"] = true,
	["showParty"] = true,
	["showSolo"] = true
}
	
function MOD:UpdateGroupConfig(parentFrame, setForced)
	if InCombatLockdown()then return end;
	SetProxyEnv()
	
	parentFrame.forceShow = setForced;
	parentFrame.forceShowAuras = setForced;
	parentFrame.isForced = setForced;
	if setForced then 
		for _,func in pairs(tags) do 
			if type(func) == 'function' then 
				if not definedEnvs[func] then 
					definedEnvs[func] = getfenv(func)
					setfenv(func,_PROXY)
				end 
			end 
		end;
		RegisterStateDriver(parentFrame,'visibility','show')
	else 
		for func,fenv in pairs(definedEnvs)do 
			setfenv(func,fenv)
			definedEnvs[func] = nil 
		end;
		RegisterStateDriver(parentFrame,"visibility",parentFrame.db.visibility)
		parentFrame:GetScript("OnEvent")(parentFrame,"PLAYER_ENTERING_WORLD")
	end;
	for i=1,#parentFrame.ExtraFrames do 
		local groupFrame = parentFrame.ExtraFrames[i]
		local db = groupFrame.db;
		if groupFrame:IsShown()then 
			groupFrame.forceShow=parentFrame.forceShow;
			groupFrame.forceShowAuras=parentFrame.forceShowAuras;
			groupFrame:HookScript("OnAttributeChanged",ChangeGroupIndex)
			if setForced then 
				for attr in pairs(attrOverride)do 
					groupFrame:SetAttribute(attr,nil)
				end;
				ChangeGroupIndex(groupFrame)
				groupFrame:Update()
			else 
				for attr in pairs(attrOverride)do 
					groupFrame:SetAttribute(attr,true)
				end;
				RestrictChildren(groupFrame,groupFrame:GetChildren())
				groupFrame:SetAttribute('startingIndex',1)
				groupFrame:Update()
			end 
		end 
	end;
	parentFrame:SetActiveState()
end;

function MOD:PLAYER_REGEN_DISABLED()
	for _,frame in pairs(MOD.GroupFrames) do 
		if frame.forceShow then 
			MOD:UpdateGroupConfig(frame)
		end 
	end;
	for _,name in pairs(MOD) do 
		local temp=self[name]
		if temp and temp.forceShow then 
			self:RestrictElement(temp)
		end 
	end;
	for i=1,5 do 
		if self['arena'..i]and self['arena'..i].isForced then 
			self:RestrictElement(self['arena'..i])
		end 
	end;
	for i=1,4 do 
		if self['boss'..i]and self['boss'..i].isForced then 
			self:RestrictElement(self['boss'..i])
		end 
	end 
end;
--[[ 
########################################################## 
HEADER FUNCTIONS MODEL
##########################################################
]]--
MOD.SecureHeaderFunctions = {
	Update = function(this)
		local unitName = this.NameKey;
		local db = MOD.db[unitName]
		MOD["RefreshHeader_"..GetUnitFrameActualName(unitName)](MOD,this,db)
		local index=1;
		local childFrame=this:GetAttribute("child"..index)
		while childFrame do 
			MOD["RefreshFrame_"..GetUnitFrameActualName(unitName)](MOD,childFrame,db)
			if _G[childFrame:GetName()..'Pet'] then 
				MOD["RefreshFrame_"..GetUnitFrameActualName(unitName)](MOD,_G[childFrame:GetName()..'Pet'],db)
			end;
			if _G[childFrame:GetName()..'Target'] then 
				MOD["RefreshFrame_"..GetUnitFrameActualName(unitName)](MOD,_G[childFrame:GetName()..'Target'],db)
			end;
			index= index + 1;
			childFrame = this:GetAttribute("child"..index)
		end 
	end,
	ClearAllAttributes = function(this)
		this:Hide()
		this:SetAttribute("showPlayer",true)
		this:SetAttribute("showSolo",true)
		this:SetAttribute("showParty",true)
		this:SetAttribute("showRaid",true)
		this:SetAttribute("columnSpacing",nil)
		this:SetAttribute("columnAnchorPoint",nil)
		this:SetAttribute("sortMethod",nil)
		this:SetAttribute("groupFilter",nil)
		this:SetAttribute("groupingOrder",nil)
		this:SetAttribute("maxColumns",nil)
		this:SetAttribute("nameList",nil)
		this:SetAttribute("point",nil)
		this:SetAttribute("sortDir",nil)
		this:SetAttribute("sortMethod","NAME")
		this:SetAttribute("startingIndex",nil)
		this:SetAttribute("strictFiltering",nil)
		this:SetAttribute("unitsPerColumn",nil)
		this:SetAttribute("xOffset",nil)
		this:SetAttribute("yOffset",nil)
	end
};
--[[ 
########################################################## 
GROUP FUNCTIONS MODEL
##########################################################
]]--
MOD.SecureGroupFunctions = {
	SetConfigEnvironment = function(this)
		local db = MOD.db[this.NameKey]
		local anchorPoint;
		local widthCalc,heightCalc,xCalc,yCalc = 0,0,0,0;
		local sorting = db.showBy;
		local pointMap = _POINTMAP[sorting]
		local point1,point2,point3,point4,point5,horizontal,vertical,isHorizontal = pointMap[1],pointMap[2],pointMap[3],pointMap[4],pointMap[5],pointMap[6],pointMap[7],pointMap[8];
		for i=1,db.gCount do 
			local frame = this.ExtraFrames[i]
			if frame then 
				dbMapping(frame)
				if isHorizontal then 
					frame:SetAttribute("xOffset",db.wrapXOffset * horizontal)
					frame:SetAttribute("yOffset",0)
					frame:SetAttribute("columnSpacing",db.wrapYOffset)
				else 
					frame:SetAttribute("xOffset",0)
					frame:SetAttribute("yOffset",db.wrapYOffset * vertical)
					frame:SetAttribute("columnSpacing",db.wrapXOffset)
				end;
				if not frame.isForced then 
					if not frame.initialized then 
						frame:SetAttribute("startingIndex",db.rSort and (-min(db.gCount * db.gRowCol * 5, MAX_RAID_MEMBERS) + 1) or -4)
						frame:Show()
						frame.initialized=true 
					end;
					frame:SetAttribute('startingIndex',1)
				end;
				frame:ClearAllPoints()
				if db.rSort and db.invertGroupingOrder then 
					frame:SetAttribute("columnAnchorPoint",point4)
				else 
					frame:SetAttribute("columnAnchorPoint",point3)
				end;
				MOD:DetachSubFrames(frame:GetChildren())
				frame:SetAttribute("point",point1)
				if not frame.isForced then 
					frame:SetAttribute("maxColumns",db.rSort and db.gCount or 1)
					frame:SetAttribute("unitsPerColumn",db.rSort and (db.gRowCol * 5) or 5)
					_GSORT[db.sortMethod](frame)
					frame:SetAttribute('sortDir',db.sortDir)
					frame:SetAttribute("showPlayer",db.showPlayer)
				end;
				if i==1 and db.rSort then 
					frame:SetAttribute("groupFilter","1,2,3,4,5,6,7,8")
				else 
					frame:SetAttribute("groupFilter",tostring(i))
				end 
			end;
			local anchorPoint=point2
			if db.rSort and db.startFromCenter then 
				anchorPoint=point5
			end;
			if (i - 1) % db.gRowCol==0 then 
				if isHorizontal then 
					if frame then 
						frame:SetPoint(anchorPoint, this, anchorPoint, 0, heightCalc * vertical)
					end;
					heightCalc=heightCalc + db.height + db.wrapYOffset;
					yCalc = yCalc + 1 
				else 
					if frame then 
						frame:SetPoint(anchorPoint, this, anchorPoint, widthCalc * horizontal, 0)
					end;
					widthCalc=widthCalc + db.width + db.wrapXOffset;
					xCalc = xCalc + 1 
				end 
			else 
				if isHorizontal then 
					if yCalc==1 then 
						if frame then 
							frame:SetPoint(anchorPoint, this, anchorPoint, widthCalc * horizontal, 0)
						end;
						widthCalc=widthCalc + (db.width + db.wrapXOffset) * 5;
						xCalc = xCalc + 1 
					elseif frame then 
						frame:SetPoint(anchorPoint, this, anchorPoint, (((db.width + db.wrapXOffset) * 5) * ((i - 1) % db.gRowCol)) * horizontal, ((db.height + db.wrapYOffset) * (yCalc - 1)) * vertical)
					end 
				else 
					if xCalc==1 then 
						if frame then 
							frame:SetPoint(anchorPoint, this, anchorPoint, 0, heightCalc * vertical)
						end;
						heightCalc=heightCalc + (db.height + db.wrapYOffset) * 5;
						yCalc = yCalc + 1 
					elseif frame then 
						frame:SetPoint(anchorPoint, this, anchorPoint, ((db.width + db.wrapXOffset) * (xCalc - 1)) * horizontal, (((db.height + db.wrapYOffset) * 5) * ((i - 1) % db.gRowCol)) * vertical)
					end 
				end 
			end;
			if heightCalc == 0 then 
				heightCalc = heightCalc + (db.height + db.wrapYOffset) * 5 
			elseif widthCalc == 0 then 
				widthCalc = widthCalc + (db.width + db.wrapXOffset) * 5 
			end 
		end;
		this:SetSize(widthCalc - db.wrapXOffset, heightCalc - db.wrapYOffset)
	end,
	Update = function(this)
		local unitName = this.NameKey;
		MOD[unitName].db = MOD.db[unitName]
		for i=1,#this.ExtraFrames do 
			this.ExtraFrames[i].db = MOD.db[unitName]
			this.ExtraFrames[i]:Update()
		end 
	end,
	SetActiveState = function(this)
		if not this.isForced then 
			for i=1,#this.ExtraFrames do
				local frame = this.ExtraFrames[i]
				if i <= this.db.gCount and this.db.rSort and i <= 1 or not this.db.rSort then 
					frame:Show()
				else 
					if frame.forceShow then 
						frame:Hide()
						RestrictChildren(frame,frame:GetChildren())
						frame:SetAttribute('startingIndex',1)
					else 
						frame:ClearAllAttributes()
					end 
				end 
			end 
		end 
	end
};

MOD:RegisterEvent('PLAYER_REGEN_DISABLED')
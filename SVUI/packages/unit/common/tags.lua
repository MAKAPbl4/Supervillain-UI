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
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.")
local Astrolabe = DongleStub("Astrolabe-1.0")
--[[ 
########################################################## 
LOCAL VARIABLES
##########################################################
]]--
local twipe,format,sub,gsub,len,byte=table.wipe,string.format,string.sub,string.gsub,string.len,string.byte;
local formatting={
	['CURRENT'] = '%s',
	['CURRENT_MAX'] = '%s - %s',
	['CURRENT_PERCENT'] = '%s - %s%%',
	['CURRENT_MAX_PERCENT'] = '%s - %s | %s%%',
	['PERCENT']='%s%%',
	['DEFICIT'] = '-%s'
};
local Harmony={[0]={1,1,1},[1]={.57,.63,.35,1},[2]={.47,.63,.35,1},[3]={.37,.63,.35,1},[4]={.27,.63,.33,1},[5]={.17,.63,.33,1}}
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local radian90=(3.141592653589793 / 2)
local function cartography(unit,checkMap)
	local plot1,plot2,plot3,plot4;
	if unit=="player" or UnitIsUnit("player", unit) then 
		plot1,plot2,plot3,plot4=Astrolabe:GetCurrentPlayerPosition()
	else 
		plot1,plot2,plot3,plot4=Astrolabe:GetUnitPosition(unit, checkMap or WorldMapFrame:IsVisible())
	end;
	if not (plot1 and plot4) then 
		return false 
	else 
		return true,plot1,plot2,plot3,plot4 
	end 
end;
local function Measure(unit1,unit2,checkMap)
	local allowed,plot1,plot2,plot3,plot4 = cartography(unit1,checkMap)
	if not allowed then return end;
	local allowed,plot5,plot6,plot7,plot8 = cartography(unit2,checkMap)
	if not allowed then return end;
	local distance,deltaX,deltaY = Astrolabe:ComputeDistance(plot1,plot2,plot3,plot4,plot5,plot6,plot7,plot8)
	if distance and deltaX and deltaY then 
		return distance, -radian90 - GetPlayerFacing() - atan2(deltaY, deltaX) 
	elseif distance then 
		return distance 
	end
end;
local function SetTagStyle(style,min,max)
	if max == 0 then max = 1 end;
	local result;
	local tagFormat = formatting[style]
	if style == 'DEFICIT' then 
		local result = max - min;
		if result <= 0 then 
			return ''
		else 
			return format(tagFormat, TruncateNumericString(result))
		end 
	elseif style == 'PERCENT' then 
		result = format(tagFormat, format("%.1f", min / max * 100))
		result = result:gsub(".0%%","%%")
		return result 
	elseif style == 'CURRENT' or (style == 'CURRENT_MAX' or style == 'CURRENT_MAX_PERCENT' or style == 'CURRENT_PERCENT') and min == max then 
		return format(formatting['CURRENT'], TruncateNumericString(min))
	elseif style == 'CURRENT_MAX' then 
		return format(tagFormat, TruncateNumericString(min), TruncateNumericString(max))
	elseif style == 'CURRENT_PERCENT' then 
		result = format(tagFormat, TruncateNumericString(min), format("%.1f", min / max * 100))
		result = result:gsub(".0%%","%%")
		return result 
	elseif style == 'CURRENT_MAX_PERCENT' then 
		result = format(tagFormat, TruncateNumericString(min), TruncateNumericString(max), format("%.1f", min / max * 100))
		result = result:gsub(".0%%","%%")
		return result 
	end 
end;
local function TrimTagText(text,limit,ellipsis)
	local length = text:len()
	if length <= limit then 
		return text 
	else 
		local overall,charPos=0,1;
		while charPos <= length do 
			overall = overall + 1;
			local parse = text:byte(charPos)
			if parse > 0 and parse <= 127 then 
				charPos = charPos + 1 
			elseif parse >= 192 and parse <= 223 then 
				charPos = charPos + 2 
			elseif parse >= 224 and parse <= 239 then 
				charPos = charPos + 3 
			elseif parse >= 240 and parse <= 247 then 
				charPos = charPos + 4 
			end;
			if overall == limit then break end 
		end;
		if overall == limit and charPos <= length then 
			return text:sub(1, charPos - 1)..(ellipsis and '...' or '') 
		else 
			return text 
		end 
	end 
end;
local function GetClassPower(class)
	local currentPower,maxPower,r,g,b=0,0,0,0,0;
	local spec=GetSpecialization()
	if class=='PALADIN'then 
		currentPower=UnitPower('player',SPELL_POWER_HOLY_POWER)
		maxPower=UnitPowerMax('player',SPELL_POWER_HOLY_POWER)
		r,g,b=228/255,225/255,16/255 
	elseif class=='MONK'then 
		currentPower=UnitPower("player",SPELL_POWER_CHI)
		maxPower=UnitPowerMax("player",SPELL_POWER_CHI)
		r,g,b=unpack(Harmony[currentPower])
	elseif class=='DRUID' and GetShapeshiftFormID()==MOONKIN_FORM then 
		currentPower=UnitPower('player',SPELL_POWER_ECLIPSE)
		maxPower=UnitPowerMax('player',SPELL_POWER_ECLIPSE)
		if GetEclipseDirection()=='moon'then 
			r,g,b=.80,.82,.60 
		else 
			r,g,b=.30,.52,.90 
		end 
	elseif class=='PRIEST' and spec==SPEC_PRIEST_SHADOW and UnitLevel("player") > SHADOW_ORBS_SHOW_LEVEL then 
		currentPower=UnitPower("player",SPELL_POWER_SHADOW_ORBS)
		maxPower=UnitPowerMax("player",SPELL_POWER_SHADOW_ORBS)
		r,g,b=1,1,1 
	elseif class=='WARLOCK'then 
		if spec==SPEC_WARLOCK_DESTRUCTION then 
			currentPower=UnitPower("player",SPELL_POWER_BURNING_EMBERS,true)
			maxPower=UnitPowerMax("player",SPELL_POWER_BURNING_EMBERS,true)
			currentPower=math.floor(currentPower / 10)
			maxPower=math.floor(maxPower / 10)
			r,g,b=230/255,95/255,95/255 
		elseif spec==SPEC_WARLOCK_AFFLICTION then 
			currentPower=UnitPower("player",SPELL_POWER_SOUL_SHARDS)
			maxPower=UnitPowerMax("player",SPELL_POWER_SOUL_SHARDS)
			r,g,b=148/255,130/255,201/255 
		elseif spec==SPEC_WARLOCK_DEMONOLOGY then 
			currentPower=UnitPower("player",SPELL_POWER_DEMONIC_FURY)
			maxPower=UnitPowerMax("player",SPELL_POWER_DEMONIC_FURY)
			r,g,b=148/255,130/255,201/255 
		end 
	end;
	return currentPower,maxPower,r,g,b
end;

local function UnitName(unit)
	local name=_G.UnitName(unit)
	if name==UNKNOWN and SuperVillain.class=="MONK" and UnitIsUnit(unit,"pet") then 
		name=("%s\'s Spirit"):format(_G.UnitName("player"))
	else 
		return name 
	end 
end;
--[[ 
########################################################## 
TAG EVENTS
##########################################################
]]--
oUF_SuperVillain.Tags.Events['namecolor']='UNIT_NAME_UPDATE';
for i=1, 30 do
	oUF_SuperVillain.Tags.Events['name:'..i] = 'UNIT_NAME_UPDATE';
end

oUF_SuperVillain.Tags.Events['healthcolor']='UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED';
oUF_SuperVillain.Tags.Events['health:current']='UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED';
oUF_SuperVillain.Tags.Events['health:deficit']='UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED';
oUF_SuperVillain.Tags.Events['health:current-percent']='UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED';
oUF_SuperVillain.Tags.Events['health:current-max']='UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED';
oUF_SuperVillain.Tags.Events['health:current-max-percent']='UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED';
oUF_SuperVillain.Tags.Events['health:max']='UNIT_MAXHEALTH';
oUF_SuperVillain.Tags.Events['health:percent']='UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED';

oUF_SuperVillain.Tags.Events['powercolor']='UNIT_POWER_FREQUENT UNIT_MAXPOWER';
oUF_SuperVillain.Tags.Events['power:current']='UNIT_POWER_FREQUENT UNIT_MAXPOWER';
oUF_SuperVillain.Tags.Events['power:current-max']='UNIT_POWER_FREQUENT UNIT_MAXPOWER';
oUF_SuperVillain.Tags.Events['power:current-percent']='UNIT_POWER_FREQUENT UNIT_MAXPOWER';
oUF_SuperVillain.Tags.Events['power:current-max-percent']='UNIT_POWER_FREQUENT UNIT_MAXPOWER';
oUF_SuperVillain.Tags.Events['power:percent']='UNIT_POWER_FREQUENT UNIT_MAXPOWER';
oUF_SuperVillain.Tags.Events['power:deficit']='UNIT_POWER_FREQUENT UNIT_MAXPOWER';
oUF_SuperVillain.Tags.Events['power:max']='UNIT_MAXPOWER';

oUF_SuperVillain.Tags.Events['classpowercolor']='UNIT_POWER PLAYER_TALENT_UPDATE UPDATE_SHAPESHIFT_FORM';
oUF_SuperVillain.Tags.Events['classpower:current']='UNIT_POWER PLAYER_TALENT_UPDATE UPDATE_SHAPESHIFT_FORM';
oUF_SuperVillain.Tags.Events['classpower:deficit']='UNIT_POWER PLAYER_TALENT_UPDATE UPDATE_SHAPESHIFT_FORM';
oUF_SuperVillain.Tags.Events['classpower:current-percent']='UNIT_POWER PLAYER_TALENT_UPDATE UPDATE_SHAPESHIFT_FORM';
oUF_SuperVillain.Tags.Events['classpower:current-max']='UNIT_POWER PLAYER_TALENT_UPDATE UPDATE_SHAPESHIFT_FORM';
oUF_SuperVillain.Tags.Events['classpower:current-max-percent']='UNIT_POWER PLAYER_TALENT_UPDATE UPDATE_SHAPESHIFT_FORM';
oUF_SuperVillain.Tags.Events['classpower:percent']='UNIT_POWER PLAYER_TALENT_UPDATE UPDATE_SHAPESHIFT_FORM';

oUF_SuperVillain.Tags.Events['altpowercolor']="UNIT_POWER UNIT_MAXPOWER";
oUF_SuperVillain.Tags.Events['altpower:percent']="UNIT_POWER UNIT_MAXPOWER";
oUF_SuperVillain.Tags.Events['altpower:current']="UNIT_POWER";
oUF_SuperVillain.Tags.Events['altpower:current-percent']="UNIT_POWER UNIT_MAXPOWER";
oUF_SuperVillain.Tags.Events['altpower:deficit']="UNIT_POWER UNIT_MAXPOWER";
oUF_SuperVillain.Tags.Events['altpower:current-max']="UNIT_POWER UNIT_MAXPOWER";
oUF_SuperVillain.Tags.Events['altpower:current-max-percent']="UNIT_POWER UNIT_MAXPOWER";

oUF_SuperVillain.Tags.Events['threatcolor']='UNIT_THREAT_LIST_UPDATE GROUP_ROSTER_UPDATE';
oUF_SuperVillain.Tags.Events['threat:percent']='UNIT_THREAT_LIST_UPDATE GROUP_ROSTER_UPDATE';
oUF_SuperVillain.Tags.Events['threat:current']='UNIT_THREAT_LIST_UPDATE GROUP_ROSTER_UPDATE';

oUF_SuperVillain.Tags.Events['afk']='PLAYER_FLAGS_CHANGED';
oUF_SuperVillain.Tags.Events['difficultycolor']='UNIT_LEVEL PLAYER_LEVEL_UP';
oUF_SuperVillain.Tags.Events['smartlevel']='UNIT_LEVEL PLAYER_LEVEL_UP';
oUF_SuperVillain.Tags.Events['absorbs']='UNIT_ABSORB_AMOUNT_CHANGED';
oUF_SuperVillain.Tags.Events['incomingheals:personal']='UNIT_HEAL_PREDICTION';
oUF_SuperVillain.Tags.Events['incomingheals:others']='UNIT_HEAL_PREDICTION';
oUF_SuperVillain.Tags.Events['incomingheals']='UNIT_HEAL_PREDICTION';
--[[ 
########################################################## 
TAG METHODS
##########################################################
]]--
--[[ NAME ]]--
oUF_SuperVillain.Tags.Methods['namecolor'] = function(unit)
	local unitReaction = UnitReaction(unit, 'player')
	local _,classToken = UnitClass(unit)
	if UnitIsPlayer(unit) then 
		local class = RAID_CLASS_COLORS[classToken]
		if not class then return "" end
		return Hex(class.r,class.g,class.b)
	elseif unitReaction then 
		local reaction = oUF_SuperVillain['colors'].reaction[unitReaction]
		return Hex(reaction[1],reaction[2],reaction[3])
	else 
		return '|cFFC2C2C2'
	end 
end;

for i=1, 30 do
	oUF_SuperVillain.Tags.Methods['name:'..i] = function(unit) 
		local name = UnitName(unit) 
		local result = (name ~= nil) and TrimTagText(name,i) or ""
		return result
	end;
end

--[[ HEALTH ]]--
oUF_SuperVillain.Tags.Methods['healthcolor']=function(f)if UnitIsDeadOrGhost(f)or not UnitIsConnected(f)then return Hex(0.84,0.75,0.65)else local r,g,b=oUF_SuperVillain.ColorGradient(UnitHealth(f),UnitHealthMax(f),0.89,0.21,0.21,0.85,0.53,0.25,0.23,0.89,0.33)return Hex(r,g,b)end end;
oUF_SuperVillain.Tags.Methods['health:current']=function(f)local i=UnitIsDead(f)and DEAD or UnitIsGhost(f)and L['Ghost']or not UnitIsConnected(f)and L['Offline']if i then return i else return SetTagStyle('CURRENT',UnitHealth(f),UnitHealthMax(f))end end;
oUF_SuperVillain.Tags.Methods['health:deficit']=function(f)local i=UnitIsDead(f)and DEAD or UnitIsGhost(f)and L['Ghost']or not UnitIsConnected(f)and L['Offline']if i then return i else return SetTagStyle('DEFICIT',UnitHealth(f),UnitHealthMax(f))end end;
oUF_SuperVillain.Tags.Methods['health:current-percent']=function(f)local i=UnitIsDead(f)and DEAD or UnitIsGhost(f)and L['Ghost']or not UnitIsConnected(f)and L['Offline']if i then return i else return SetTagStyle('CURRENT_PERCENT',UnitHealth(f),UnitHealthMax(f))end end;
oUF_SuperVillain.Tags.Methods['health:current-max']=function(f)local i=UnitIsDead(f)and DEAD or UnitIsGhost(f)and L['Ghost']or not UnitIsConnected(f)and L['Offline']if i then return i else return SetTagStyle('CURRENT_MAX',UnitHealth(f),UnitHealthMax(f))end end;
oUF_SuperVillain.Tags.Methods['health:current-max-percent']=function(f)local i=UnitIsDead(f)and DEAD or UnitIsGhost(f)and L['Ghost']or not UnitIsConnected(f)and L['Offline']if i then return i else return SetTagStyle('CURRENT_MAX_PERCENT',UnitHealth(f),UnitHealthMax(f))end end;
oUF_SuperVillain.Tags.Methods['health:max']=function(f)local d=UnitHealthMax(f)return SetTagStyle('CURRENT',d,d)end;
oUF_SuperVillain.Tags.Methods['health:percent']=function(f)local i=UnitIsDead(f)and DEAD or UnitIsGhost(f)and L['Ghost']or not UnitIsConnected(f)and L['Offline']if i then return i else return SetTagStyle('PERCENT',UnitHealth(f),UnitHealthMax(f))end end;

--[[ POWER ]]--
oUF_SuperVillain.Tags.Methods['powercolor']=function(f)local j,k,l,m,n=UnitPowerType(f)local o=oUF_SuperVillain['colors'].power[k]if o then return Hex(o[1],o[2],o[3])else return Hex(l,m,n)end end;
oUF_SuperVillain.Tags.Methods['power:current']=function(f)local j=UnitPowerType(f)local p=UnitPower(f,j)return p==0 and' 'or SetTagStyle('CURRENT',p,UnitPowerMax(f,j))end;
oUF_SuperVillain.Tags.Methods['power:current-max']=function(f)local j=UnitPowerType(f)local p=UnitPower(f,j)return p==0 and' 'or SetTagStyle('CURRENT_MAX',p,UnitPowerMax(f,j))end;
oUF_SuperVillain.Tags.Methods['power:current-percent']=function(f)local j=UnitPowerType(f)local p=UnitPower(f,j)return p==0 and' 'or SetTagStyle('CURRENT_PERCENT',p,UnitPowerMax(f,j))end;
oUF_SuperVillain.Tags.Methods['power:current-max-percent']=function(f)local j=UnitPowerType(f)local p=UnitPower(f,j)return p==0 and' 'or SetTagStyle('CURRENT_MAX_PERCENT',p,UnitPowerMax(f,j))end;
oUF_SuperVillain.Tags.Methods['power:percent']=function(f)local j=UnitPowerType(f)local p=UnitPower(f,j)return p==0 and' 'or SetTagStyle('PERCENT',p,UnitPowerMax(f,j))end;
oUF_SuperVillain.Tags.Methods['power:deficit']=function(f)local j=UnitPowerType(f)return SetTagStyle('DEFICIT',UnitPower(f,j),UnitPowerMax(f,j),r,g,b)end;
oUF_SuperVillain.Tags.Methods['power:max']=function(f)local d=UnitPowerMax(f,UnitPowerType(f))return SetTagStyle('CURRENT',d,d)end;

oUF_SuperVillain.Tags.Methods['classpowercolor']=function()local v,v,r,g,b=GetClassPower(SuperVillain.class)return Hex(r,g,b)end;
oUF_SuperVillain.Tags.Methods['classpower:current']=function()local p,d=GetClassPower(SuperVillain.class)if p==0 then return " " else return SetTagStyle('CURRENT',p,d)end end;
oUF_SuperVillain.Tags.Methods['classpower:deficit']=function()local p,d=GetClassPower(SuperVillain.class)if p==0 then return " " else return SetTagStyle('DEFICIT',p,d)end end;
oUF_SuperVillain.Tags.Methods['classpower:current-percent']=function()local p,d=GetClassPower(SuperVillain.class)if p==0 then return " " else return SetTagStyle('CURRENT_PERCENT',p,d)end end;
oUF_SuperVillain.Tags.Methods['classpower:current-max']=function()local p,d=GetClassPower(SuperVillain.class)if p==0 then return " " else return SetTagStyle('CURRENT_MAX',p,d)end end;
oUF_SuperVillain.Tags.Methods['classpower:current-max-percent']=function()local p,d=GetClassPower(SuperVillain.class)if p==0 then return " " else return SetTagStyle('CURRENT_MAX_PERCENT',p,d)end end;
oUF_SuperVillain.Tags.Methods['classpower:percent']=function()local p,d=GetClassPower(SuperVillain.class)if p==0 then return " " else return SetTagStyle('PERCENT',p,d)end end;

oUF_SuperVillain.Tags.Methods['altpowercolor']=function(a)local c=UnitPower(a,ALTERNATE_POWER_INDEX)if c>0 then local e,r,g,b=UnitAlternatePowerTextureInfo(a,2)if not r then r,g,b=1,1,1 end;return Hex(r,g,b)else return " " end end;
oUF_SuperVillain.Tags.Methods['altpower:percent']=function(a)local c=UnitPower(a,ALTERNATE_POWER_INDEX)if c>0 then local d=UnitPowerMax(a,ALTERNATE_POWER_INDEX)return SetTagStyle('PERCENT',c,d)else return " " end end
oUF_SuperVillain.Tags.Methods['altpower:current']=function(a)local c=UnitPower(a,ALTERNATE_POWER_INDEX)if c>0 then return c else return " " end end
oUF_SuperVillain.Tags.Methods['altpower:current-percent']=function(a)local c=UnitPower(a,ALTERNATE_POWER_INDEX)if c>0 then local d=UnitPowerMax(a,ALTERNATE_POWER_INDEX)return SetTagStyle('CURRENT_PERCENT',c,d)else return " " end end
oUF_SuperVillain.Tags.Methods['altpower:deficit']=function(a)local c=UnitPower(a,ALTERNATE_POWER_INDEX)if c>0 then local d=UnitPowerMax(a,ALTERNATE_POWER_INDEX)return SetTagStyle('DEFICIT',c,d)else return " " end end;
oUF_SuperVillain.Tags.Methods['altpower:current-max']=function(a)local c=UnitPower(a,ALTERNATE_POWER_INDEX)if c>0 then local d=UnitPowerMax(a,ALTERNATE_POWER_INDEX)return SetTagStyle('CURRENT_MAX',c,d)else return " " end end;
oUF_SuperVillain.Tags.Methods['altpower:current-max-percent']=function(a)local c=UnitPower(a,ALTERNATE_POWER_INDEX)if c>0 then local d=UnitPowerMax(a,ALTERNATE_POWER_INDEX)SetTagStyle('CURRENT_MAX_PERCENT',c,d)else return " " end end;

--[[ THREAT ]]--
oUF_SuperVillain.Tags.Methods['threatcolor']=function(f)local i=select(2,UnitDetailedThreatSituation("player",f))if i then return Hex(GetThreatStatusColor(i)) else return "|cFF808080" end end;
oUF_SuperVillain.Tags.Methods['threat:percent']=function(f)if UnitCanAttack('player',f)then local i,y=select(2,UnitDetailedThreatSituation('player',f))if i then return format('%.0f%%',y)end;return L["None"]end;return " " end;
oUF_SuperVillain.Tags.Methods['threat:current']=function(f)if UnitCanAttack('player',f)then local i,v,v,z=select(2,UnitDetailedThreatSituation('player',f))if i then return TruncateNumericString(z)end;return L["None"]end;return " " end;

--[[ MISC ]]--
oUF_SuperVillain.Tags.Methods['difficultycolor'] = function(unit)
	local r, g, b = 0.55, 0.57, 0.61;
	if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
		level = UnitBattlePetLevel(unit)
		local pta = C_PetJournal.GetPetTeamAverageLevel()
		if pta < level or pta > level then 
			local s = GetRelativeDifficultyColor(pta, level)
			r, g, b = s.r, s.g, s.b 
		else
			local s = QuestDifficultyColors["difficult"]
			r, g, b = s.r, s.g, s.b 
		end 
	else	
		local diff = UnitLevel(unit) - UnitLevel('player')
		if diff >= 5 then
			r, g, b = 0.69, 0.31, 0.31 
		elseif diff >= 3 then 
			r, g, b = 0.71, 0.43, 0.27 
		elseif diff >= -2 then 
			r, g, b = 0.84, 0.75, 0.65 
		elseif -diff <= GetQuestGreenRange() then 
			r, g, b = 0.33, 0.59, 0.33 
		else
			r, g, b = 0.55, 0.57, 0.61 
		end 
	end;
	return Hex(r, g, b)
end;

oUF_SuperVillain.Tags.Methods['smartlevel'] = function(unit)
	local level = UnitLevel(unit)
	if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
		return UnitBattlePetLevel(unit)
	-- elseif level == UnitLevel('player') then 
	-- 	return " " 
	elseif level > 0 then 
		return level 
	else
		return "??"
	end 
end;

oUF_SuperVillain.Tags.Methods['absorbs'] = function(unit)
	local asrb = UnitGetTotalAbsorbs(unit) or 0;
	if asrb == 0 then
		return " " 
	else
		return TruncateNumericString(asrb)
	end 
end;

oUF_SuperVillain.Tags.Methods['incomingheals'] = function(unit)
	local inc1 = UnitGetIncomingHeals(unit, 'player') or 0;
	local inc2 = UnitGetIncomingHeals(unit) or 0;
	local incAll = inc1 + inc2;
	if incAll == 0 then
		return " " 
	else
		return TruncateNumericString(incAll)
	end 
end;

local taggedUnits = {}
local groupTagManager = CreateFrame("Frame")
groupTagManager:RegisterEvent("GROUP_ROSTER_UPDATE")
groupTagManager:SetScript("OnEvent", function()
	local group, count;
	twipe(taggedUnits)
	if IsInRaid() then
		group = "raid"
		count = GetNumGroupMembers()
	elseif IsInGroup() then 
		group = "party"
		count = GetNumGroupMembers() - 1;
		taggedUnits["player"] = true 
	else
		group = "solo"
		count = 1 
	end;
	for i = 1, count do 
		local realName = group..i;
		if not UnitIsUnit(realName, "player") then
			taggedUnits[realName] = true 
		end 
	end 
end);

oUF_SuperVillain.Tags.Methods['incomingheals:personal'] = function(unit)
	local inc = UnitGetIncomingHeals(unit, 'player') or 0;
	if inc == 0 then
		return " " 
	else
		return TruncateNumericString(inc)
	end 
end;

oUF_SuperVillain.Tags.Methods['incomingheals:others'] = function(unit)
	local inc = UnitGetIncomingHeals(unit) or 0;
	if inc == 0 then
		return " " 
	else
		return TruncateNumericString(inc)
	end 
end;

oUF_SuperVillain.Tags.Methods['afk']=function(unit)
	local afk,dnd = UnitIsAFK(unit),UnitIsDND(unit)
	if afk then 
		return('|cffFFFFFF[|r|cffFF0000%s|r|cFFFFFFFF]|r'):format(DEFAULT_AFK_MESSAGE)
	elseif dnd then 
		return('|cffFFFFFF[|r|cffFF0000%s|r|cFFFFFFFF]|r'):format(L['DND'])
	else 
		return ""
	end 
end;

--[[ UTILITY ]]--
oUF_SuperVillain.Tags.Methods['pvptimer']=function(unit)
	if UnitIsPVPFreeForAll(unit) or UnitIsPVP(unit)then 
		local clock = GetPVPTimer()
		if clock ~= 301000 and clock ~= -1 then 
			local dur1 = floor(clock / 1000 / 60)
			local dur2 = floor(clock / 1000 - dur1 * 60)
			return("%s (%01.f:%02.f)"):format(PVP,dur1,dur2)
		else 
			return PVP 
		end 
	else 
		return ""
	end 
end;

oUF_SuperVillain.Tags.Methods['nearbyplayers:8']=function(unit)
	local N,distance=0;
	if UnitIsConnected(unit)then 
		for P,_ in pairs(H)do 
			if not UnitIsUnit(unit,P) and UnitIsConnected(P)then 
				distance=Measure(unit,P,true)
				if distance and distance <= 8 then 
					N=N+1 
				end 
			end 
		end 
	end;
	return N
end;

oUF_SuperVillain.Tags.Methods['nearbyplayers:10']=function(unit)
	local N,distance=0;
	if UnitIsConnected(unit)then 
		for P,_ in pairs(H)do 
			if not UnitIsUnit(unit,P) and UnitIsConnected(P)then 
				distance = Measure(unit,P,true)
				if distance and distance <= 10 then 
					N=N+1 
				end 
			end 
		end 
	end;
	return N 
end;

oUF_SuperVillain.Tags.Methods['nearbyplayers:30']=function(unit)
	local N,distance=0;
	if UnitIsConnected(unit)then 
		for P,_ in pairs(H)do 
			if not UnitIsUnit(unit,P) and UnitIsConnected(P)then 
				distance = Measure(unit,P,true)
				if distance and distance <= 30 then 
					N=N+1 
				end 
			end 
		end 
	end;
	return N 
end;

oUF_SuperVillain.Tags.Methods['distance']=function(unit)
	if not UnitIsConnected(unit) or UnitIsUnit(unit,'player')then return "" end;
	local dst=Measure('player',unit,true)
	if dst and dst > 0 then 
		return format('%d',dst)
	end;
	return ""
end;
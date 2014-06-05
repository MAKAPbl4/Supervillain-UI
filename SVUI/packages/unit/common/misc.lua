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
local MOD = SuperVillain:GetModule('SVUnit');
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.");
local LSM = LibStub("LibSharedMedia-3.0");
--[[ 
########################################################## 
LOCAL VARIABLES
##########################################################
]]--
local roleIconTextures = {
	TANK = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\TANK]],
	HEALER = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\HEALER]],
	DAMAGER = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\DPS]]
}
local roleIconSmalls = {
	TANK = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\TINY-TANK]],
	HEALER = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\TINY-HEALER]],
	DAMAGER = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\TINY-DPS]]
}
local roleIconColors = {
	TANK = {0,0.6,1},
	HEALER = {0.2,1,0.2},
	DAMAGER = {1,0.2,0}
}
local fadeManager = CreateFrame("Frame",nil,UIParent)
fadeManager.fadeRoles = false;
fadeManager.fadeNames = false;
fadeManager.fadeFrames = {};
--[[ 
########################################################## 
NAME
##########################################################
]]--
function MOD:CreateNameText(frame,unitName)
	local parent = frame.InfoPanel or frame;
	local name = parent:CreateFontString(nil,'OVERLAY')
	name:SetShadowOffset(2, -2)
	name:SetShadowColor(0,0,0,1)
	name:SetFontTemplate()
	if unitNmae == "target" then
		name:SetPoint('TOPRIGHT',parent)
	else
		name:SetPoint('CENTER',parent)
	end
	MOD:SetUnitFont(name, unitName)
	return name;
end;

function MOD:UpdateNameSettings(frame)
	local db=frame.db;
	if not db or not db.name then return end;
	local name=frame.Name;
	local parent=frame.Name:GetParent()
	if not db.power or not db.power.hideonnpc or db.power.text_format == '' then 
		local point = db.name.position;
		name:ClearAllPoints()
		SuperVillain:ReversePoint(name, point, parent, db.name.xOffset, db.name.yOffset)
	end;
	frame:Tag(name,db.name.text_format) 
end;

function MOD:GridNameToggle(frame,unit)
	if not frame.Name or not frame.db then return end;
	local db=frame.db;
	if db.gridMode then 
		frame.Name:Hide()
	end 
end;
--[[ 
########################################################## 
TARGET GLOW
##########################################################
]]--
function MOD:CreateTargetGlow(frame)
	local shadow=CreateFrame("Frame",nil,frame)
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(frame:GetFrameStrata())
	shadow:WrapOuter(frame,3,3)
	shadow:SetBackdrop({
		edgeFile=SuperVillain.Textures.shadow,
		edgeSize=SuperVillain:Scale(3),
		insets={
			left=SuperVillain:Scale(5),
			right=SuperVillain:Scale(5),
			top=SuperVillain:Scale(5),
			bottom=SuperVillain:Scale(5)
		}
	})
	shadow:SetBackdropColor(0,0,0,0)
	shadow:SetBackdropBorderColor(0,0,0,0.9)
	shadow:Hide()
	return shadow 
end;

function MOD:UpdateTargetGlow(zzz)
	if not self.unit then return end;
	local unit = self.unit;
	if UnitIsUnit(unit,'target')then 
		self.TargetGlow:Show()
		local reaction=UnitReaction(unit,'player')
		if UnitIsPlayer(unit)then 
			local L,class=UnitClass(unit)
			if class then 
				local colors=RAID_CLASS_COLORS[class]
				self.TargetGlow:SetBackdropBorderColor(colors.r,colors.g,colors.b)
			else 
				self.TargetGlow:SetBackdropBorderColor(1,1,1)
			end 
		elseif reaction then 
			local colors=FACTION_BAR_COLORS[reaction]
			self.TargetGlow:SetBackdropBorderColor(colors.r,colors.g,colors.b)
		else 
			self.TargetGlow:SetBackdropBorderColor(1,1,1)
		end 
	else 
		self.TargetGlow:Hide()
	end
end;
--[[ 
########################################################## 
RAID DEBUFFS / DEBUFF HIGHLIGHT
##########################################################
]]--
local AURA_FONT = [[Interface\AddOns\SVUI\assets\fonts\Display.ttf]];
local AURA_FONTSIZE = 10;
local AURA_OUTLINE = 'OUTLINE';
function MOD:CreateRaidDebuffs(frame)
	local raidDebuff = CreateFrame('Frame',nil,frame)
	raidDebuff:SetFixedPanelTemplate("Slot")
	raidDebuff.icon = raidDebuff:CreateTexture(nil,'OVERLAY')
	raidDebuff.icon:SetTexCoord(0.1,0.9,0.1,0.9)
	raidDebuff.icon:FillInner(raidDebuff)
	raidDebuff.count = raidDebuff:CreateFontString(nil,'OVERLAY')
	raidDebuff.count:SetFontTemplate(AURA_FONT,AURA_FONTSIZE,AURA_OUTLINE)
	raidDebuff.count:SetPoint('BOTTOMRIGHT',0,2)
	raidDebuff.count:SetTextColor(1,.9,0)
	raidDebuff.time = raidDebuff:CreateFontString(nil,'OVERLAY')
	raidDebuff.time:SetFontTemplate(AURA_FONT,AURA_FONTSIZE,AURA_OUTLINE)
	raidDebuff.time:SetPoint('CENTER')
	raidDebuff.time:SetTextColor(1,.9,0)
	raidDebuff:SetParent(frame.InfoPanel)
	return raidDebuff
end;

function MOD:CreateAfflicted(frame)
	local holder = CreateFrame('Frame',nil,frame.Health)
	holder:SetFrameLevel(30)
	holder:SetAllPoints(frame.Health)
	local afflicted = holder:CreateTexture(nil,"OVERLAY",nil,7)
	afflicted:FillInner(holder)
	afflicted:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\UNIT-AFFLICTED")
	afflicted:SetVertexColor(0,0,0,0)
	afflicted:SetBlendMode("ADD")
	frame.AfflictedFilter=true;
	frame.AfflictedAlpha=0.75;
	
	return afflicted
end;

local function UpdateFillBar(frame, previousTexture, bar, amount)
	if ( amount == 0 ) then
		bar:Hide();
		return previousTexture;
	end
	local orientation = frame.Health:GetOrientation()
	bar:ClearAllPoints()
	if orientation == 'HORIZONTAL' then
		bar:SetPoint("TOPLEFT", previousTexture, "TOPRIGHT");
		bar:SetPoint("BOTTOMLEFT", previousTexture, "BOTTOMRIGHT");
	else
		bar:SetPoint("BOTTOMRIGHT", previousTexture, "TOPRIGHT");
		bar:SetPoint("BOTTOMLEFT", previousTexture, "TOPLEFT");	
	end
	local totalWidth, totalHeight = frame.Health:GetSize();
	if orientation == 'HORIZONTAL' then
		bar:SetWidth(totalWidth);
	else
		bar:SetHeight(totalHeight);
	end
	return bar:GetStatusBarTexture();
end

function MOD:CreateThreat(frame, glow, custom)
	local threat = CreateFrame("Frame", nil, frame)
	threat.glow = frame.ActionPanel.glow;
	threat.PostUpdate = MOD.UpdateThreat;
	return threat 
end;

function MOD:UpdateThreat(unit,value,r,g,b)
	local frame = self:GetParent()
	if not unit or frame.unit~=unit or not frame.db or not frame.db.threatEnabled then return end;
	if value and value > 1 then 
		self.glow:SetBackdropBorderColor(r,g,b)
	else 
		self.glow:SetBackdropBorderColor(0,0,0,0.9)
	end 
end;
--[[ 
########################################################## 
VARIOUS ICONS
##########################################################
]]--
function MOD:CreateResurectionIcon(frame)
	local rez=frame.InfoPanel:CreateTexture(nil,"OVERLAY")
	rez:Point('CENTER',frame.Health.value,'CENTER')
	rez:Size(30,25)
	rez:SetDrawLayer('OVERLAY',7)
	return rez 
end;

function MOD:CreateReadyCheckIcon(frame)
	local rdy=frame.InfoPanel:CreateTexture(nil,"OVERLAY",nil,7)
	rdy:Size(12)
	rdy:Point("BOTTOM",frame.Health,"BOTTOM",0,2)
	return rdy 
end;

function MOD:CreateTrinket(frame)
	local trinket=CreateFrame("Frame",nil,frame)
	trinket.bg=CreateFrame("Frame",nil,trinket)
	trinket.bg:SetFixedPanelTemplate("Default")
	trinket.bg:SetFrameLevel(trinket:GetFrameLevel()-1)
	trinket:FillInner(trinket.bg)
	return trinket 
end;

function MOD:CreatePVPSpecIcon(frame)
	local pvp=CreateFrame("Frame",nil,frame)
	pvp.bg=CreateFrame("Frame",nil,pvp)
	pvp.bg:SetFixedPanelTemplate("Default")
	pvp.bg:SetFrameLevel(pvp:GetFrameLevel()-1)
	pvp:FillInner(pvp.bg)
	return pvp 
end;
--[[ 
########################################################## 
CONFIGURABLE ICONS
##########################################################
]]--
function MOD:CreateRaidIcon(frame)
	local rIcon = frame.InfoPanel:CreateTexture(nil,"OVERLAY",nil,2)
	rIcon:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
	rIcon:Size(18)
	rIcon:Point("CENTER",frame.InfoPanel,"TOP",0,2)
	return rIcon 
end;

function MOD:CreateRoleIcon(frame)
	local parent=frame.InfoPanel or frame;
	local rIconHolder = CreateFrame('Frame',nil,parent)
	rIconHolder:SetAllPoints()
	local rIcon = rIconHolder:CreateTexture(nil,"ARTWORK",nil,2)
	rIcon:Size(14)
	rIcon:Point("BOTTOMRIGHT",rIconHolder,"BOTTOMRIGHT")
	rIcon.Override = MOD.UpdateRoleIcon;
	frame:RegisterEvent("UNIT_CONNECTION",MOD.UpdateRoleIcon)
	fadeManager.fadeFrames[frame]=true;
	return rIcon 
end;

function MOD:UpdateRoleIcon()
	local lfd = self.LFDRole;
	if not self.db or not self.db.icons then return end;
	local db = self.db.icons.roleIcon;
	if not db or db and not db.enable then lfd:Hide()return end;
	local unitRole=UnitGroupRolesAssigned(self.unit)
	if self.isForced and unitRole=='NONE'then 
		local rng=random(1,3)
		unitRole = rng==1 and "TANK" or rng==2 and "HEALER" or rng==3 and "DAMAGER" 
	end;
	if unitRole~='NONE' and self.isForced or UnitIsConnected(self.unit) then
		if(lfd:GetHeight() <= 13) then
			lfd:SetTexture(roleIconSmalls[unitRole])
			local c = roleIconColors[unitRole]
			if c then
				lfd:SetVertexColor(unpack(c))
			end
		else
			lfd:SetTexture(roleIconTextures[unitRole])
			lfd:SetVertexColor(1,1,1)
		end
		lfd:Show()
	else
		lfd:Hide()
	end 
end;

function MOD:CreateRaidRoleFrames(frame)
	local parent=frame.InfoPanel or frame;
	local raidRoles=CreateFrame('Frame',nil,frame)
	raidRoles:Size(24,12)
	raidRoles:Point("TOPLEFT",frame.ActionPanel,"TOPLEFT",-2,4)
	raidRoles:SetFrameLevel(parent:GetFrameLevel() + 50)

	frame.Leader=raidRoles:CreateTexture(nil,'OVERLAY')
	frame.Leader:Size(12,12)
	frame.Leader:SetTexture([[Interface\Addons\SVUI\assets\artwork\Icons\LEADER]])
	frame.Leader:SetVertexColor(1,0.85,0)
	frame.Leader:Point("LEFT")

	frame.MasterLooter=raidRoles:CreateTexture(nil,'OVERLAY')
	frame.MasterLooter:Size(12,12)
	frame.MasterLooter:SetTexture([[Interface\Addons\SVUI\assets\artwork\Icons\LOOTER]])
	frame.MasterLooter:SetVertexColor(1,0.6,0)
	frame.MasterLooter:Point("RIGHT")

	frame.Leader.PostUpdate=MOD.RaidRoleUpdate;
	frame.MasterLooter.PostUpdate=MOD.RaidRoleUpdate;
	return raidRoles 
end;

function MOD:RaidRoleUpdate()
	local frame = self:GetParent()
	local leaderIcon = frame.Leader;
	local looterIcon = frame.MasterLooter;
	if not leaderIcon or not looterIcon then return end;
		local unit = frame.unit;
		local db = frame.db;
		local leaderShown = leaderIcon:IsShown()
		local looterShown = looterIcon:IsShown()
		leaderIcon:ClearAllPoints()
		looterIcon:ClearAllPoints()
		if db and db.icons and db.icons.raidRoleIcons then
			local settings = db.icons.raidRoleIcons
			if leaderShown and settings.position == "TOPLEFT"then 
				leaderIcon:Point("LEFT", frame, "LEFT")
				looterIcon:Point("RIGHT", frame, "RIGHT")
			elseif leaderShown and settings.position == "TOPRIGHT" then 
				leaderIcon:Point("RIGHT", frame, "RIGHT")
				looterIcon:Point("LEFT", frame, "LEFT")
			elseif looterShown and settings.position == "TOPLEFT" then 
				looterIcon:Point("LEFT", frame, "LEFT")
			else 
			looterIcon:Point("RIGHT", frame, "RIGHT")
		end 
	end 
end;
--[[ 
########################################################## 
FADEFRAME MANAGER
##########################################################
]]--
fadeManager:SetScript("OnEvent",function(self,event,...)
	if event == 'PLAYER_REGEN_DISABLED' then
		for frame,_ in pairs(fadeManager.fadeFrames) do
			if frame.Name and fadeManager.fadeNames == true then 
				frame.Name:SetAlpha(0.4)
				local f1,f2,f3=frame.Name:GetFont()
				frame.Name.OldOutline=f3
				frame.Name:SetFont(f1,f2,nil)
			end
			if frame.LFDRole and fadeManager.fadeRoles == true then frame.LFDRole:SetAlpha(0) end
		end
	elseif event == 'PLAYER_REGEN_ENABLED' then
		for frame,_ in pairs(fadeManager.fadeFrames) do
			if frame.Name and fadeManager.fadeNames == true then 
				frame.Name:SetAlpha(1)
				local f1,f2,f3=frame.Name:GetFont()
				frame.Name:SetFont(f1,f2,frame.Name.OldOutline or 'OUTLINE')
			end
			if frame.LFDRole and fadeManager.fadeRoles == true then frame.LFDRole:SetAlpha(1) end
		end
	end;
end)

function MOD:SetFadeManager()
	if MOD.db.combatFadeRoles ~= true and MOD.db.combatFadeNames ~= true then
		fadeManager:UnregisterAllEvents()
		fadeManager.fadeRoles = false;
		fadeManager.fadeNames = false;
	else
		fadeManager:RegisterEvent('PLAYER_REGEN_ENABLED')
		fadeManager:RegisterEvent('PLAYER_REGEN_DISABLED')
		fadeManager.fadeRoles = MOD.db.combatFadeRoles;
		fadeManager.fadeNames = MOD.db.combatFadeNames;
	end;
end;
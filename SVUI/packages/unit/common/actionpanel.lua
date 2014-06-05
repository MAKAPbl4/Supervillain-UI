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
LOCAL FUNCTIONS
##########################################################
]]--
local PanelPostUpdate = function(self,colors)
	self.left:SetTexture(unpack(colors))
	self.right:SetTexture(unpack(colors))
	self.top:SetTexture(unpack(colors))
	self.bottom:SetTexture(unpack(colors))
	self.EliteRarePanel.top:SetVertexColor(unpack(colors))
	self.EliteRarePanel.bottom:SetVertexColor(unpack(colors))
	self.EliteRarePanel.right:SetVertexColor(unpack(colors))
end

local TappedPostUpdate = function(self, unit, marked)
	local tapped = self.TAP;
	if(marked) then
		tapped:Hide()
	else
		if UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) then 
			tapped:Show()
		else
			tapped:Hide()
		end
	end
end

local function CreateActionPanel(frame, offset)
    if(frame.ActionPanel) then return; end
    offset = offset or 2

    local panel = CreateFrame('Frame', nil, frame)
    panel:Point('TOPLEFT', frame, 'TOPLEFT', -1, 1)
    panel:Point('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', 1, -1)

    --[[ UNDERLAY BORDER ]]--
    local borderLeft = panel:CreateTexture(nil, "BORDER")
    borderLeft:SetTexture(0, 0, 0)
    borderLeft:SetPoint("TOPLEFT")
    borderLeft:SetPoint("BOTTOMLEFT")
    borderLeft:SetWidth(offset)

    local borderRight = panel:CreateTexture(nil, "BORDER")
    borderRight:SetTexture(0, 0, 0)
    borderRight:SetPoint("TOPRIGHT")
    borderRight:SetPoint("BOTTOMRIGHT")
    borderRight:SetWidth(offset)

    local borderTop = panel:CreateTexture(nil, "BORDER")
    borderTop:SetTexture(0, 0, 0)
    borderTop:SetPoint("TOPLEFT")
    borderTop:SetPoint("TOPRIGHT")
    borderTop:SetHeight(offset)

    local borderBottom = panel:CreateTexture(nil, "BORDER")
    borderBottom:SetTexture(0, 0, 0)
    borderBottom:SetPoint("BOTTOMLEFT")
    borderBottom:SetPoint("BOTTOMRIGHT")
    borderBottom:SetHeight(offset)

    --[[ OVERLAY BORDER ]]--
    panel.left = panel:CreateTexture(nil, "OVERLAY")
	panel.left:SetTexture(0, 0, 0)
	panel.left:SetPoint("TOPLEFT")
	panel.left:SetPoint("BOTTOMLEFT")
	panel.left:SetWidth(2)

	panel.right = panel:CreateTexture(nil, "OVERLAY")
	panel.right:SetTexture(0, 0, 0)
	panel.right:SetPoint("TOPRIGHT")
	panel.right:SetPoint("BOTTOMRIGHT")
	panel.right:SetWidth(2)

	panel.top = panel:CreateTexture(nil, "OVERLAY")
	panel.top:SetTexture(0, 0, 0)
	panel.top:SetPoint("TOPLEFT")
	panel.top:SetPoint("TOPRIGHT")
	panel.top:SetHeight(2)

	panel.bottom = panel:CreateTexture(nil, "OVERLAY")
	panel.bottom:SetTexture(0, 0, 0)
	panel.bottom:SetPoint("BOTTOMLEFT")
	panel.bottom:SetPoint("BOTTOMRIGHT")
	panel.bottom:SetHeight(2)

    panel.glow = CreateFrame('Frame', nil, panel)
    panel.glow:Point('TOPLEFT', panel, 'TOPLEFT', -3, 3)
    panel.glow:Point('BOTTOMRIGHT', panel, 'BOTTOMRIGHT', 3, -3)
    panel.glow:SetBackdrop({
        edgeFile = SuperVillain.Textures.shadow,
        edgeSize = 3,
        insets = {
            left = 2,
            right = 2,
            top = 2,
            bottom = 2
        }
    });
    panel.glow:SetBackdropBorderColor(0,0,0,0.5)

    panel:SetBackdrop({
        bgFile = [[Interface\BUTTONS\WHITE8X8]], 
        edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
        tile = false, 
        tileSize = 0, 
        edgeSize = 1, 
        insets = 
        {
            left = 0, 
            right = 0, 
            top = 0, 
            bottom = 0, 
        }, 
    })
    panel:SetBackdropColor(0,0,0)
    panel:SetBackdropBorderColor(0,0,0)

    panel:SetFrameStrata("BACKGROUND")
    panel:SetFrameLevel(0)
    return panel
end;
--[[ 
########################################################## 
ACTIONPANEL / INFOPANEL
##########################################################
]]--
function MOD:SetActionPanel(frame, padding)
	local offset = padding or 2;
	frame.ActionPanel = CreateActionPanel(frame, offset)

	frame.InfoPanel = CreateFrame("Frame", nil, frame) 
	frame.InfoPanel:Point("TOPLEFT", frame.ActionPanel, "TOPLEFT", 2, -2)
	frame.InfoPanel:Point("BOTTOMRIGHT", frame.ActionPanel, "BOTTOMRIGHT", -2, 2)
	frame.InfoPanel:SetFrameStrata("MEDIUM")
	frame.InfoPanel:SetFrameLevel(frame.InfoPanel:GetFrameLevel() + 30)

	frame.HealthAnchor = CreateFrame("Frame", nil, frame)
	frame.HealthAnchor:SetAllPoints(frame)
end;

function MOD:SetDeluxeActionPanel(frame, padding, isPlayer)
	local offset = padding or 2;
	frame.ActionPanel = CreateActionPanel(frame, offset)

	frame.InfoPanel = CreateFrame("Frame", nil, frame)
	frame.InfoPanel:Point("TOPLEFT", frame.ActionPanel, "BOTTOMLEFT", -1, 1)
	frame.InfoPanel:Point("TOPRIGHT", frame.ActionPanel, "BOTTOMRIGHT", 1, 1)
	frame.InfoPanel:SetHeight(30)
	frame.InfoPanel:SetFrameStrata("MEDIUM")
	frame.InfoPanel.bg = frame:CreateTexture(nil, "BACKGROUND", nil, -7)
	frame.InfoPanel.bg:FillInner(frame.InfoPanel)
	frame.InfoPanel.bg:SetTexture(1, 1, 1, 1)
	frame.InfoPanel.bg:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, 0, 0, 0, 0.7)

	frame.HealthAnchor = CreateFrame("Frame", nil, frame)
	frame.HealthAnchor:SetAllPoints(frame)

	if(not isPlayer) then
		frame.ActionPanel:SetFrameLevel(1)
		local eholder = CreateFrame("Frame", nil, frame.ActionPanel)
		eholder:SetAllPoints(frame)
		eholder:SetFrameStrata("BACKGROUND")
		eholder:SetFrameLevel(0)
		eholder.top = eholder:CreateTexture(nil, "OVERLAY", nil, 1)
		eholder.top:SetPoint("BOTTOMLEFT", eholder, "TOPLEFT", 0, 0)
		eholder.top:SetPoint("BOTTOMRIGHT", eholder, "TOPRIGHT", 0, 0)
		eholder.top:SetHeight(frame.ActionPanel:GetWidth() * 0.15)
		eholder.top:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\ELITE-TOP")
		eholder.top:SetVertexColor(1, 0.75, 0)
		eholder.top:SetBlendMode("BLEND")
		eholder.bottom = eholder:CreateTexture(nil, "OVERLAY", nil, 1)
		eholder.bottom:SetPoint("TOPLEFT", eholder, "BOTTOMLEFT", 0, 0)
		eholder.bottom:SetPoint("TOPRIGHT", eholder, "BOTTOMRIGHT", 0, 0)
		eholder.bottom:SetHeight(frame.ActionPanel:GetWidth() * 0.15)
		eholder.bottom:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\ELITE-BOTTOM")
		eholder.bottom:SetVertexColor(1, 0.75, 0)
		eholder.bottom:SetBlendMode("BLEND")
		eholder.right = eholder:CreateTexture(nil, "OVERLAY", nil, 1)
		eholder.right:SetPoint("TOPLEFT", eholder, "TOPRIGHT", 0, 0)
		eholder.right:SetPoint("BOTTOMLEFT", eholder, "BOTTOMRIGHT", 0, 0)
		eholder.right:SetWidth(frame.ActionPanel:GetHeight() * 2.25)
		eholder.right:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\ELITE-RIGHT")
		eholder.right:SetVertexColor(1, 0.75, 0)
		eholder.right:SetBlendMode("BLEND")
		eholder:SetAlpha(0.7)
		frame.ActionPanel.EliteRarePanel = eholder;
		frame.ActionPanel.EliteRarePanel:Hide()
		frame.ActionPanel.PostUpdate = PanelPostUpdate
	end
end;

function MOD:SetActionPanelIcons(frame, isTappable)
	local disco = CreateFrame("Frame", nil, frame.Health)
	local size = frame.Health:GetHeight() or 50;

	disco.DEAD = CreateFrame("Frame", nil, frame.Health)
	disco.DEAD:EnableMouse(false)
	disco.DEAD:SetSize(size, size)
	disco.DEAD:SetPoint("CENTER")
	disco.DEAD:SetFrameStrata("LOW")
	disco.DEAD:SetFrameLevel(frame.Health:GetFrameLevel() + 50)
	disco.DEAD.icon = disco.DEAD:CreateTexture(nil, "OVERLAY")
	disco.DEAD.icon:SetAllPoints()
	disco.DEAD.icon:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\UNIT_DEAD")
	disco.DEAD.icon:SetAlpha(0.5)
	disco.DEAD:Hide()

	disco.DC = CreateFrame("Frame", nil, frame.Health)
	disco.DC:EnableMouse(false)
	disco.DC:SetSize(size, size)
	disco.DC:SetPoint("CENTER")
	disco.DC:SetFrameStrata("LOW")
	disco.DC:SetFrameLevel(frame.Health:GetFrameLevel() + 50)
	disco.DC.icon = disco.DC:CreateTexture(nil, "OVERLAY")
	disco.DC.icon:SetAllPoints()
	disco.DC.icon:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\UNIT_DC")
	disco.DC.icon:SetAlpha(0.5)
	disco.DC:Hide()

	if(isTappable) then
		disco.TAP = CreateFrame("Frame", nil, frame.Health)
		disco.TAP:EnableMouse(false)
		disco.TAP:SetAllPoints(frame.Health)
		disco.TAP:SetFrameStrata("LOW")
		disco.TAP:SetFrameLevel(frame.Health:GetFrameLevel() + 50)
		disco.TAP.icon = disco.TAP:CreateTexture(nil, "OVERLAY")
		disco.TAP.icon:SetAllPoints()
		disco.TAP.icon:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\UNIT_TAPPED")
		disco.TAP.icon:SetAlpha(0.5)
		disco.TAP:Hide()
		disco.PostUpdate = TappedPostUpdate
	end

	frame.DiscoDead = disco
end;

function MOD:UpdateTargetGlow(zzz)
	if not self.unit then return end;
	local unit = self.unit;
	if(UnitIsUnit(unit, "target")) then 
		self.TargetGlow:Show()
		local reaction = UnitReaction(unit, "player")
		if(UnitIsPlayer(unit)) then 
			local L, class = UnitClass(unit)
			if class then 
				local colors = RAID_CLASS_COLORS[class]
				self.TargetGlow:SetBackdropBorderColor(colors.r, colors.g, colors.b)
			else 
				self.TargetGlow:SetBackdropBorderColor(1, 1, 1)
			end 
		elseif(reaction) then 
			local colors = FACTION_BAR_COLORS[reaction]
			self.TargetGlow:SetBackdropBorderColor(colors.r, colors.g, colors.b)
		else 
			self.TargetGlow:SetBackdropBorderColor(1, 1, 1)
		end 
	else 
		self.TargetGlow:Hide()
	end 
end;
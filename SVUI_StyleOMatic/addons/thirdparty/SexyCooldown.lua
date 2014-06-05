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
local pairs 	= _G.pairs;
local string 	= _G.string;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, G = unpack(SVUI);
local MOD = SuperVillain:GetModule('SVStyle');
--[[ 
########################################################## 
SEXYCOOLDOWN
##########################################################
]]--
local function StyleSexyCooldown()
	local function SCDStripStyleSettings(bar)
		bar.optionsTable.args.icon.args.borderheader = nil
		bar.optionsTable.args.icon.args.border = nil
		bar.optionsTable.args.icon.args.borderColor = nil
		bar.optionsTable.args.icon.args.borderSize = nil
		bar.optionsTable.args.icon.args.borderInset = nil
		bar.optionsTable.args.bar.args.bnbheader = nil
		bar.optionsTable.args.bar.args.texture = nil
		bar.optionsTable.args.bar.args.backgroundColor = nil
		bar.optionsTable.args.bar.args.border = nil
		bar.optionsTable.args.bar.args.borderColor = nil
		bar.optionsTable.args.bar.args.borderSize = nil
		bar.optionsTable.args.bar.args.borderInset = nil
	end
	local function StyleSexyCooldownBar(bar)
		SCDStripStyleSettings(bar)
		MOD:ApplyFrameStyle(bar)
		SuperVillain:AddToDisplayAudit(bar)
		if MOD:IsAddonReady("DockletSexyCooldown") then
			bar:ClearAllPoints()
			bar:Point('BOTTOMRIGHT', SVUI_ActionBar1, 'TOPRIGHT', 0, 2)
			bar:Point("BOTTOMLEFT", SVUI_ActionBar1, "TOPLEFT", 0, 2)
			bar:SetHeight(SVUI_ActionBar1Button1:GetHeight())
		end
	end
	local function StyleSexyCooldownIcon(bar, icon)
		if not icon.styled then
			MOD:ApplyFrameStyle(icon, false, true)
			MOD:ApplyFrameStyle(icon.overlay,"Transparent",true)
			icon.styled = true
		end
		icon.overlay.tex:SetTexCoord(0.1,0.9,0.1,0.9)
		icon.tex:SetTexCoord(0.1,0.9,0.1,0.9)
	end
	local function StyleSexyCooldownBackdrop(bar)
		bar:SetFixedPanelTemplate("Transparent")
	end
	local function HookSCDBar(bar)
		if bar.hooked then return end
		hooksecurefunc(bar, "UpdateBarLook", StyleSexyCooldownBar)
		hooksecurefunc(bar, "UpdateSingleIconLook", StyleSexyCooldownIcon)
		hooksecurefunc(bar, "UpdateBarBackdrop", StyleSexyCooldownBackdrop)
		bar.settings.icon.borderInset = 0
		bar.hooked = true
	end
	for _, bar in ipairs(SexyCooldown2.bars) do
		HookSCDBar(bar)
		bar:UpdateBarLook()
	end
	hooksecurefunc(SexyCooldown2, 'CreateBar', function(self)
		for _, bar in ipairs(self.bars) do
			HookSCDBar(bar)
			bar:UpdateBarLook()
		end
	end)
end
MOD:SaveAddonStyle("SexyCooldown", StyleSexyCooldown)
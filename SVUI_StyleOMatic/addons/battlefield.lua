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
local SuperVillain, L, P, C, G = unpack(SVUI);
local MOD = SuperVillain:GetModule("SVStyle");
--[[ 
########################################################## 
BATTLEFIELD STYLER
##########################################################
]]--
local function BattlefieldStyle()
	if SuperVillain.db.SVStyle.blizzard.enable~=true or SuperVillain.db.SVStyle.blizzard.bgmap~=true then return end;
	BattlefieldMinimap:SetClampedToScreen(true)
	BattlefieldMinimapCorner:MUNG()
	BattlefieldMinimapBackground:MUNG()
	BattlefieldMinimapTab:MUNG()
	BattlefieldMinimapTabLeft:MUNG()
	BattlefieldMinimapTabMiddle:MUNG()
	BattlefieldMinimapTabRight:MUNG()
	BattlefieldMinimap:SetFixedPanelTemplate("Transparent")
	BattlefieldMinimap.Panel:Point("BOTTOMRIGHT", -4, 2)
	BattlefieldMinimap:SetFrameStrata("LOW")
	BattlefieldMinimapCloseButton:ClearAllPoints()
	BattlefieldMinimapCloseButton:SetPoint("TOPRIGHT", -4, 0)
	MOD:ApplyCloseButtonStyle(BattlefieldMinimapCloseButton)
	BattlefieldMinimapCloseButton:SetFrameStrata("MEDIUM")
	BattlefieldMinimap:EnableMouse(true)
	BattlefieldMinimap:SetMovable(true)
	BattlefieldMinimap:SetScript("OnMouseUp", function(f, g)
		if g == "LeftButton"then 
			BattlefieldMinimapTab:StopMovingOrSizing()BattlefieldMinimapTab:SetUserPlaced(true)
			if OpacityFrame:IsShown()then 
				OpacityFrame:Hide()
			end 
		elseif g == "RightButton"then 
			ToggleDropDownMenu(1, nil, BattlefieldMinimapTabDropDown, f:GetName(), 0, -4)
			if OpacityFrame:IsShown()then 
				OpacityFrame:Hide()
			end 
		end 
	end)
	BattlefieldMinimap:SetScript("OnMouseDown", function(f, g)
		if g == "LeftButton"then 
			if BattlefieldMinimapOptions and BattlefieldMinimapOptions.locked then 
				return 
			else 
				BattlefieldMinimapTab:StartMoving()
			end 
		end 
	end)
	hooksecurefunc("BattlefieldMinimap_UpdateOpacity", function(opacity)
		local h = 1.0-BattlefieldMinimapOptions.opacity or 0;
		BattlefieldMinimap.Panel:SetAlpha(h)
	end)
	local i;
	BattlefieldMinimap:HookScript("OnEnter", function()
		i = BattlefieldMinimapOptions.opacity or 0;
		BattlefieldMinimap_UpdateOpacity(0)
	end)
	BattlefieldMinimap:HookScript("OnLeave", function()
		if i then 
			BattlefieldMinimap_UpdateOpacity(i)i = nil 
		end 
	end)
	BattlefieldMinimapCloseButton:HookScript("OnEnter", function()
		i = BattlefieldMinimapOptions.opacity or 0;
		BattlefieldMinimap_UpdateOpacity(0)
	end)
	BattlefieldMinimapCloseButton:HookScript("OnLeave", function()
		if i then 
			BattlefieldMinimap_UpdateOpacity(i)i = nil 
		end 
	end)
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveBlizzardStyle("Blizzard_BattlefieldMinimap",BattlefieldStyle)
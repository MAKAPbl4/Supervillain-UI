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
HELPERS
##########################################################
]]--
local regularButtons = {
	"SVUI_KeyBindPopupSaveButton",
	"SVUI_KeyBindPopupDiscardButton",
	"SVUI_Mentalo",
	"SVUI_MentaloPrecisionUpButton",
	"SVUI_MentaloPrecisionDownButton",
	"SVUI_MentaloPrecisionLeftButton",
	"SVUI_MentaloPrecisionRightButton",
	"SVUI_GetMailButton",
	"SVUI_GetGoldButton",
};
local closeButtons = {
	"SVUI_InstallCloseButton",
	"ItemRefCloseButton",
	"SVUI_BankContainerFrameCloseButton",
	"SVUI_ContainerFrameCloseButton",
};
local editBoxes = {
	"SVUI_MentaloPrecisionSetX",
	"SVUI_MentaloPrecisionSetY",
};
local checkBoxes = {
	"SVUI_KeyBindPopupCheckButton",
};
--[[ 
########################################################## 
ALERTFRAME STYLER
##########################################################
]]--
local function SVUICoreStyle()
	for i = 1, 4 do
		local alert = _G["SVUI_SystemAlert"..i];
		if(alert) then
			for b = 1, 3 do
				alert.buttons[b]:SetButtonTemplate()
			end;
			alert:Formula409()
			MOD:ApplyAlertStyle(alert)
			alert.input:SetEditboxTemplate()
			alert.input.Panel:Point("TOPLEFT", -2, -4)
			alert.input.Panel:Point("BOTTOMRIGHT", 2, 4)
			alert.gold:SetEditboxTemplate()
			alert.silver:SetEditboxTemplate()
			alert.copper:SetEditboxTemplate()
		end
	end

	for _,frame in pairs(regularButtons) do
		if(_G[frame]) then
			_G[frame]:SetButtonTemplate()
		end
	end

	for _,frame in pairs(closeButtons) do
		if(_G[frame]) then
			MOD:ApplyCloseButtonStyle(_G[frame])
		end
	end

	for _,frame in pairs(editBoxes) do
		if(_G[frame]) then
			_G[frame]:SetEditboxTemplate()
		end
	end

	for _,frame in pairs(checkBoxes) do
		if(_G[frame]) then
			_G[frame]:SetCheckboxTemplate(true)
		end
	end
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveCustomStyle(SVUICoreStyle)
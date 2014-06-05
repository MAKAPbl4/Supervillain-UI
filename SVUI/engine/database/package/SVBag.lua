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
local SuperVillain, L, P, C = unpack(select(2, ...));
--[[ 
########################################################## 
DB PROFILE VARS
##########################################################
]]--
C['SVBag'] = {
	['sortInverted'] = false,
	['xOffset'] = 0,
	['yOffset'] = 0,
	['bagSize'] = 34,
	['bankSize'] = 34,
	['alignToChat'] = false,
	['bagWidth'] = 450,
	['bankWidth'] = 450,
	['currencyFormat'] = 'ICON',
	['ignoreItems'] = '',
	['bagTools'] = true,
	['bagBar'] = {
		['showBy'] = 'VERTICAL',
		['sortDirection'] = 'ASCENDING',
		['size'] = 30,
		['spacing'] = 4,
		['showBackdrop'] = false,
		['mouseover'] = false,
	},
};
--[[ 
########################################################## 
DB PROTECTED VARS
##########################################################
]]--
P['SVBag'] = {
	['enable'] = true,
	["bagBar"]=false
};
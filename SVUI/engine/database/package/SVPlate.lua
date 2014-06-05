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
--[[ 
########################################################## 
DB PROFILE VARS
##########################################################
]]--
C['SVPlate'] = {
	['font'] = 'SVUI Name Font',
	['fontSize'] = 10,
	['fontOutline'] = 'OUTLINE',
	["comboPoints"] = true,
	['nonTargetAlpha'] = 0.6,
	['combatHide'] = false,
	['colorNameByValue'] = true,
	['showthreat'] = true,
	['targetcount'] = true,
	['pointer'] = {
		['enable'] = true,
		['colorMatchHealthBar'] = true,
		['color'] = { r = 0.7, g = 0, b = 1 },
	},
	['healthBar'] = {
		['lowThreshold'] = 0.4,
		['width'] = 108,
		['height'] = 9,
		['text'] = {
			['enable'] = false,
			['format'] = 'CURRENT',
			['xOffset'] = 0,
			['yOffset'] = 0,
			['attachTo'] = 'CENTER',
		},
	},
	['castBar'] = {
		['height'] = 6,
		['color'] = {
			r = 1,
			g = 0.81,
			b = 0,
		},
		['noInterrupt'] = {
			r = 0.78,
			g = 0.25,
			b = 0.25,
		},
	},
	['raidHealIcon'] = {
		['xOffset'] =  -4,
		['yOffset'] = 6,
		['size'] = 36,
		['attachTo'] = 'LEFT',
	},
	['threat'] = {
		['enable'] = true,
		['goodScale'] = 1,
		['badScale'] = 1,
		["goodColor"] = {
			r = 0.29,
			g = 0.68,
			b = 0.3,
		},
		["badColor"] = {
			r = 0.78,
			g = 0.25,
			b = 0.25,
		},
		["goodTransitionColor"] = {
			r = 0.85,
			g = 0.77,
			b = 0.36,
		},
		["badTransitionColor"] = {
			r = 0.94,
			g = 0.6,
			b = 0.06,
		},
	},
	['auras'] = {
		['font'] = 'SVUI Number Font',
		['fontSize'] = 7,
		['fontOutline'] = 'OUTLINE',
		['numAuras'] = 5,
		['additionalFilter'] = 'CC'
	},
	['reactions'] = {
		["tapped"] = {
			r = 0.6,
			g = 0.6,
			b = 0.6,
		},
		["friendlyNPC"] = {
			r = 0.31,
			g = 0.45,
			b = 0.63,
		},
		["friendlyPlayer"] = {
			r = 0.29,
			g = 0.68,
			b = 0.3,
		},
		["neutral"] = {
			r = 0.85,
			g = 0.77,
			b = 0.36,
		},
		["enemy"] = {
			r = 0.78,
			g = 0.25,
			b = 0.25,
		},
	},
};
--[[ 
########################################################## 
DB PROTECTED VARS
##########################################################
]]--
P['SVPlate'] = {
	['enable'] = true,
};
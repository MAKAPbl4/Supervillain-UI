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
credit: Elv.                               Filter methods adapted from ElvUI #
##############################################################################
--]]
local SuperVillain, L, P, C, G = unpack(select(2, ...));
--[[ 
########################################################## 
DB STATIC VARS
##########################################################
]]--
G['Filters'] = {
	["CC"] = {},
	["Shield"] = {},
	["Player"] = {},
	["Blocked"] = {},
	["Allowed"] = {},
	["Strict"] = {},
	["Raid"] = {}
}

local CLASS_WATCH_INDEX = {
	PRIEST = {
		{-- Weakened Soul
			["enabled"] = true, 
			["id"] = 6788, 
			["point"] = "TOPRIGHT", 
			["color"] = {["r"] = 1, ["g"] = 0, ["b"] = 0}, 
			["anyUnit"] = true, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Prayer of Mending
			["enabled"] = true, 
			["id"] = 41635, 
			["point"] = "BOTTOMRIGHT", 
			["color"] = {["r"] = 0.2, ["g"] = 0.7, ["b"] = 0.2}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Renew
			["enabled"] = true, 
			["id"] = 139, 
			["point"] = "BOTTOMLEFT", 
			["color"] = {["r"] = 0.4, ["g"] = 0.7, ["b"] = 0.2}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Power Word: Shield
			["enabled"] = true, 
			["id"] = 17, 
			["point"] = "TOPLEFT", 
			["color"] = {["r"] = 0.81, ["g"] = 0.85, ["b"] = 0.1}, 
			["anyUnit"] = true, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Power Word: Shield Power Insight
			["enabled"] = true, 
			["id"] = 123258, 
			["point"] = "TOPLEFT", 
			["color"] = {["r"] = 0.81, ["g"] = 0.85, ["b"] = 0.1}, 
			["anyUnit"] = true, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Power Infusion
			["enabled"] = true, 
			["id"] = 10060, 
			["point"] = "RIGHT", 
			["color"] = {["r"] = 0.89, ["g"] = 0.09, ["b"] = 0.05}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Guardian Spirit
			["enabled"] = true, 
			["id"] = 47788, 
			["point"] = "LEFT", 
			["color"] = {["r"] = 0.86, ["g"] = 0.44, ["b"] = 0}, 
			["anyUnit"] = true, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Pain Suppression
			["enabled"] = true, 
			["id"] = 33206, 
			["point"] = "LEFT", 
			["color"] = {["r"] = 0.89, ["g"] = 0.09, ["b"] = 0.05}, 
			["anyUnit"] = true, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
	},
	DRUID = {
		{-- Rejuvenation
			["enabled"] = true, 
			["id"] = 774, 
			["point"] = "TOPRIGHT", 
			["color"] = {["r"] = 0.8, ["g"] = 0.4, ["b"] = 0.8}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Regrowth
			["enabled"] = true, 
			["id"] = 8936, 
			["point"] = "BOTTOMLEFT", 
			["color"] = {["r"] = 0.2, ["g"] = 0.8, ["b"] = 0.2}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Lifebloom
			["enabled"] = true, 
			["id"] = 33763, 
			["point"] = "TOPLEFT", 
			["color"] = {["r"] = 0.4, ["g"] = 0.8, ["b"] = 0.2}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Wild Growth
			["enabled"] = true, 
			["id"] = 48438, 
			["point"] = "BOTTOMRIGHT", 
			["color"] = {["r"] = 0.8, ["g"] = 0.4, ["b"] = 0}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
	},
	PALADIN = {
		{-- Beacon of Light
			["enabled"] = true, 
			["id"] = 53563, 
			["point"] = "TOPRIGHT", 
			["color"] = {["r"] = 0.7, ["g"] = 0.3, ["b"] = 0.7}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Hand of Protection
			["enabled"] = true, 
			["id"] = 1022, 
			["point"] = "BOTTOMRIGHT", 
			["color"] = {["r"] = 0.2, ["g"] = 0.2, ["b"] = 1}, 
			["anyUnit"] = true, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Hand of Freedom
			["enabled"] = true, 
			["id"] = 1044, 
			["point"] = "BOTTOMRIGHT", 
			["color"] = {["r"] = 0.89, ["g"] = 0.45, ["b"] = 0}, 
			["anyUnit"] = true, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Hand of Salvation
			["enabled"] = true, 
			["id"] = 1038, 
			["point"] = "BOTTOMRIGHT", 
			["color"] = {["r"] = 0.93, ["g"] = 0.75, ["b"] = 0}, 
			["anyUnit"] = true, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Hand of Sacrifice
			["enabled"] = true, 
			["id"] = 6940, 
			["point"] = "BOTTOMRIGHT", 
			["color"] = {["r"] = 0.89, ["g"] = 0.1, ["b"] = 0.1}, 
			["anyUnit"] = true, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Hand of Purity
			["enabled"] = true, 
			["id"] = 114039, 
			["point"] = "BOTTOMRIGHT", 
			["color"] = {["r"] = 0.64, ["g"] = 0.41, ["b"] = 0.72}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Sacred Shield
			["enabled"] = true, 
			["id"] = 20925, 
			["point"] = "TOPLEFT", 
			["color"] = {["r"] = 0.93, ["g"] = 0.75, ["b"] = 0},
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Eternal Flame
			["enabled"] = true, 
			["id"] = 114163, 
			["point"] = "BOTTOMLEFT", 
			["color"] = {["r"] = 0.87, ["g"] = 0.7, ["b"] = 0.03}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
	},
	SHAMAN = {
		{-- Riptide
			["enabled"] = true, 
			["id"] = 61295, 
			["point"] = "TOPRIGHT", 
			["color"] = {["r"] = 0.7, ["g"] = 0.3, ["b"] = 0.7}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Earth Shield
			["enabled"] = true, 
			["id"] = 974, 
			["point"] = "BOTTOMLEFT", 
			["color"] = {["r"] = 0.2, ["g"] = 0.7, ["b"] = 0.2}, 
			["anyUnit"] = true, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Earthliving
			["enabled"] = true, 
			["id"] = 51945, 
			["point"] = "BOTTOMRIGHT", 
			["color"] = {["r"] = 0.7, ["g"] = 0.4, ["b"] = 0.4}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
	},
	MONK = {
		{--Renewing Mist
			["enabled"] = true, 
			["id"] = 119611, 
			["point"] = "TOPLEFT", 
			["color"] = {["r"] = 0.8, ["g"] = 0.4, ["b"] = 0.8}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Life Cocoon
			["enabled"] = true, 
			["id"] = 116849, 
			["point"] = "TOPRIGHT", 
			["color"] = {["r"] = 0.2, ["g"] = 0.8, ["b"] = 0.2}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Enveloping Mist
			["enabled"] = true, 
			["id"] = 132120, 
			["point"] = "BOTTOMLEFT", 
			["color"] = {["r"] = 0.4, ["g"] = 0.8, ["b"] = 0.2}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Zen Sphere
			["enabled"] = true, 
			["id"] = 124081, 
			["point"] = "BOTTOMRIGHT", 
			["color"] = {["r"] = 0.7, ["g"] = 0.4, ["b"] = 0}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
	},
	ROGUE = {
		{-- Tricks of the Trade
			["enabled"] = true, 
			["id"] = 57934, 
			["point"] = "TOPRIGHT", 
			["color"] = {["r"] = 0.89, ["g"] = 0.09, ["b"] = 0.05},
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
	},
	MAGE = {
		{-- Ice Ward
			["enabled"] = true, 
			["id"] = 111264, 
			["point"] = "TOPLEFT", 
			["color"] = {["r"] = 0.2, ["g"] = 0.2, ["b"] = 1}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
	},
	WARRIOR = {
		{-- Vigilance
			["enabled"] = true, 
			["id"] = 114030, 
			["point"] = "TOPLEFT", 
			["color"] = {["r"] = 0.2, ["g"] = 0.2, ["b"] = 1},
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Intervene
			["enabled"] = true, 
			["id"] = 3411, 
			["point"] = "TOPRIGHT", 
			["color"] = {["r"] = 0.89, ["g"] = 0.09, ["b"] = 0.05},
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Safe Guard
			["enabled"] = true, 
			["id"] = 114029, 
			["point"] = "TOPRIGHT", 
			["color"] = {["r"] = 0.89, ["g"] = 0.09, ["b"] = 0.05},
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
	},
	DEATHKNIGHT = {
		{-- Unholy Frenzy
			["enabled"] = true, 
			["id"] = 49016, 
			["point"] = "TOPRIGHT", 
			["color"] = {["r"] = 0.89, ["g"] = 0.09, ["b"] = 0.05},
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},	
	},
	PET = {
		{-- Frenzy
			["enabled"] = true, 
			["id"] = 19615, 
			["point"] = "TOPLEFT", 
			["color"] = {["r"] = 0.89, ["g"] = 0.09, ["b"] = 0.05},
			["anyUnit"] = true, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Mend Pet
			["enabled"] = true, 
			["id"] = 136, 
			["point"] = "TOPRIGHT", 
			["color"] = {["r"] = 0.2, ["g"] = 0.8, ["b"] = 0.2}, 
			["anyUnit"] = true, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
	}
}

G['BuffWatch'] = CLASS_WATCH_INDEX[SuperVillain.class]

G['PetBuffWatch'] = CLASS_WATCH_INDEX.PET
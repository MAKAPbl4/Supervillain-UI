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
local unpack    = _G.unpack;
local select    = _G.select;
local pairs     = _G.pairs;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, G = unpack(select(2, ...));
local LSM = LibStub("LibSharedMedia-3.0");
--[[ 
########################################################## 
DEFINE SHARED MEDIA
##########################################################
]]--
LSM:Register("border","SVUI Shadow",[[Interface\AddOns\SVUI\assets\artwork\Template\GLOW]])
LSM:Register("background","SVUI Button 1",[[Interface\AddOns\SVUI\assets\artwork\Template\SLOT]])
LSM:Register("background","SVUI Button 2",[[Interface\AddOns\SVUI\assets\artwork\Template\BUTTON]])
LSM:Register("background","SVUI Default Backdrop",[[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
LSM:Register("background","SVUI Backdrop 1",[[Interface\AddOns\SVUI\assets\artwork\Template\PATTERN]])
LSM:Register("background","SVUI Backdrop 2",[[Interface\AddOns\SVUI\assets\artwork\Template\PATTERN2]])
LSM:Register("background","SVUI Backdrop 3",[[Interface\AddOns\SVUI\assets\artwork\Template\PATTERN3]])
LSM:Register("background","SVUI Backdrop 4",[[Interface\AddOns\SVUI\assets\artwork\Template\PATTERN4]])
LSM:Register("background","SVUI Backdrop 5",[[Interface\AddOns\SVUI\assets\artwork\Template\PATTERN5]])
LSM:Register("background","SVUI Comic 1",[[Interface\AddOns\SVUI\assets\artwork\Template\COMIC]])
LSM:Register("background","SVUI Comic 2",[[Interface\AddOns\SVUI\assets\artwork\Template\COMIC2]])
LSM:Register("background","SVUI Comic 3",[[Interface\AddOns\SVUI\assets\artwork\Template\COMIC3]])
LSM:Register("background","SVUI Comic 4",[[Interface\AddOns\SVUI\assets\artwork\Template\COMIC4]])
LSM:Register("background","SVUI Comic 5",[[Interface\AddOns\SVUI\assets\artwork\Template\COMIC5]])
LSM:Register("background","SVUI Comic 6",[[Interface\AddOns\SVUI\assets\artwork\Template\COMIC6]])
LSM:Register("background","SVUI Unit BG 1",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\UNIT-BG]])
LSM:Register("background","SVUI Unit BG 2",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\UNIT-BG2]])
LSM:Register("background","SVUI Unit BG 3",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\UNIT-BG3]])
LSM:Register("background","SVUI Unit BG 4",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\UNIT-BG4]])
LSM:Register("background","SVUI Unit BG 5",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\UNIT-BG5]])
LSM:Register("background","SVUI Small BG 1",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\UNIT-SMALLBG]])
LSM:Register("background","SVUI Small BG 2",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\UNIT-SMALLBG2]])
LSM:Register("background","SVUI Small BG 3",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\UNIT-SMALLBG3]])
LSM:Register("background","SVUI Small BG 4",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\UNIT-SMALLBG4]])

LSM:Register("statusbar","SVUI BasicBar",[[Interface\AddOns\SVUI\assets\artwork\Bars\DEFAULT]])
LSM:Register("statusbar","SVUI MultiColorBar",[[Interface\AddOns\SVUI\assets\artwork\Bars\GRADIENT]])
LSM:Register("statusbar","SVUI SmoothBar",[[Interface\AddOns\SVUI\assets\artwork\Bars\SMOOTH]])
LSM:Register("statusbar","SVUI PlainBar",[[Interface\AddOns\SVUI\assets\artwork\Bars\FLAT]])
LSM:Register("statusbar","SVUI FancyBar",[[Interface\AddOns\SVUI\assets\artwork\Bars\TEXTURED]])
LSM:Register("statusbar","SVUI GlossBar",[[Interface\AddOns\SVUI\assets\artwork\Bars\GLOSS]])
LSM:Register("statusbar","SVUI GlowBar",[[Interface\AddOns\SVUI\assets\artwork\Bars\GLOWING]])
LSM:Register("statusbar","SVUI LazerBar",[[Interface\AddOns\SVUI\assets\artwork\Bars\LAZER]])

LSM:Register("sound","Whisper Alert",[[Interface\AddOns\SVUI\assets\sounds\whisper.mp3]])

LSM:Register("font","SVUI Default Font",[[Interface\AddOns\SVUI\assets\fonts\Default.ttf]])
LSM:Register("font","SVUI System Font",[[Interface\AddOns\SVUI\assets\fonts\System.ttf]])
LSM:Register("font","SVUI Dialog Font",[[Interface\AddOns\SVUI\assets\fonts\Dialog.ttf]])
LSM:Register("font","SVUI Narrator Font",[[Interface\AddOns\SVUI\assets\fonts\Narrative.ttf]])
LSM:Register("font","SVUI Number Font",[[Interface\AddOns\SVUI\assets\fonts\Numbers.ttf]])
LSM:Register("font","SVUI Combat Font",[[Interface\AddOns\SVUI\assets\fonts\Combat.ttf]])
LSM:Register("font","SVUI Action Font",[[Interface\AddOns\SVUI\assets\fonts\Action.ttf]])
LSM:Register("font","SVUI Name Font",[[Interface\AddOns\SVUI\assets\fonts\Names.ttf]])
LSM:Register("font","SVUI Alert Font",[[Interface\AddOns\SVUI\assets\fonts\Alert.ttf]])
LSM:Register("font","Roboto",[[Interface\AddOns\SVUI\assets\fonts\Roboto.ttf]],LSM.LOCALE_BIT_ruRU+LSM.LOCALE_BIT_western)
--[[ 
########################################################## 
DB PROFILE VARS
##########################################################
]]--
C['common'] = {
	["fontSize"] = 10,
	["unicodeFontSize"] = 12,
	['MoverAlpha'] = 0.5,
	["cooldown"] = {
		threshold = 3,
		expiringColor = {r=1,g=0,b=0,a=1}
	}
};
C['scripts'] = {
	['totems'] = {
		['showBy'] = 'VERTICAL',
		['sortDirection'] = 'ASCENDING',
		['size'] = 40,
		['spacing'] = 4
	}
};
C["media"] = {
	["fonts"] = {
		["default"] = "SVUI Default Font",
		["system"] = "SVUI System Font",
		["combat"] = "SVUI Combat Font",
		["dialog"] = "SVUI Dialog Font",
		["narrator"] = "SVUI Narrator Font",
		["action"] = "SVUI Action Font",
		["names"] = "SVUI Name Font",
		["alert"] = "SVUI Alert Font",
		["numbers"] = "SVUI Number Font",
		["roboto"] = "Roboto"
	},
	["textures"] = {
		["shadow"] = {"border", "SVUI Shadow"}, 
		["default"] = {"background", "SVUI Default Backdrop"},
		["slot"] = {"background", "SVUI Button 1"}, 
		["button"] = {"background", "SVUI Button 2"}, 
		["pattern"] = {"background", "SVUI Backdrop 1"},
		["elegant"] = {"background", "SVUI Backdrop 4"}, 
		["comic"] = {"background", "SVUI Comic 1"}, 
		["bar"] = {"statusbar", "SVUI BasicBar"}, 
		["gradient"] = {"statusbar", "SVUI MultiColorBar"}, 
		["smooth"] = {"statusbar", "SVUI SmoothBar"}, 
		["flat"] = {"statusbar", "SVUI PlainBar"}, 
		["textured"] = {"statusbar", "SVUI FancyBar"}, 
		["gloss"] = {"statusbar", "SVUI GlossBar"}, 
		["glow"] = {"statusbar", "SVUI GlowBar"},
		["lazer"] = {"statusbar", "SVUI LazerBar"}, 
		["unitlarge"] = {"background", "SVUI Unit BG 3"}, 
		["unitsmall"] = {"background", "SVUI Small BG 3"}
	},
	["colors"] = {
		["default"] = {r = 0.18, g = 0.18, b = 0.18, a = 1}, 
		["special"] = {r = 0.32, g = 0.258, b = 0.21, a = 1},  
		["class"] = {r = 0.15, g = 0.15, b = 0.15, a = 1},
		["bizzaro"] = {r = 0.15, g = 0.15, b = 0.15, a = 1},
		["dark"] = {r = 0, g = 0, b = 0, a = 1}, 
		["light"] = {r = 1, g = 1, b = 1, a = 1},
		["highlight"] = {r = 0.2, g = 0.5, b = 1, a = 1},
		["green"] = {r = 0.25, g = 0.9, b = 0.08, a = 1},
		["red"] = {r = 0.9, g = 0.08, b = 0.08, a = 1},
		["yellow"] = {r = 1, g = 1, b = 0, a = 1},

		["gradient"] = {
			["default"] = {"VERTICAL", 0.08, 0.08, 0.08, 0.22, 0.22, 0.22}, 
			["special"] = {"VERTICAL", 0.33, 0.25, 0.13, 0.47, 0.39, 0.27}, 
			["class"] = {"VERTICAL", 0.08, 0.08, 0.08, 0.2, 0.2, 0.2}, 
			["bizzaro"] = {"VERTICAL", 0.08, 0.08, 0.08, 0.2, 0.2, 0.2},
			["dark"] = {"VERTICAL", 0.02, 0.02, 0.02, 0.22, 0.22, 0.22}, 
			["light"] = {"VERTICAL", 0.75, 0.75, 0.75, 1, 1, 1},
			["highlight"] = {"VERTICAL", 0, 0.2, 0.7, 0.2, 0.5, 1},
			["green"] = {"VERTICAL", 0.08, 0.5, 0, 0.25, 0.9, 0.08}, 
			["red"] = {"VERTICAL", 0.5, 0, 0, 0.9, 0.08, 0.08}, 
			["yellow"] = {"VERTICAL", 1, 0.3, 0, 1, 1, 0},
		},

		["transparent"] = {r = 0, g = 0, b = 0, a = 0.5},
	},
	["unitframes"] = {
	  ["health"] = {r = 0.3, g = 0.5, b = 0.3}, 
	  ["power"] = {
	    ["MANA"] = {r = 0.41, g = 0.85, b = 1}, 
	    ["RAGE"] = {r = 1, g = 0.31, b = 0.31}, 
	    ["FOCUS"] = {r = 1, g = 0.63, b = 0.27}, 
	    ["ENERGY"] = {r = 0.85, g = 0.83, b = 0.25}, 
	    ["RUNES"] = {r = 0.55, g = 0.57, b = 0.61}, 
	    ["RUNIC_POWER"] = {r = 0, g = 0.82, b = 1}, 
	    ["FUEL"] = {r = 0, g = 0.75, b = 0.75}, 
	    ["POWER_TYPE_STEAM"] = {r = 0.55, g = 0.57, b = 0.61}, 
	    ["POWER_TYPE_PYRITE"] = {r = 0.8, g = 0.09, b = 0.17}
	  }, 
	  ["reaction"] = {
	    [1] = {r = 0.92, g = 0.15, b = 0.15}, 
	    [2] = {r = 0.92, g = 0.15, b = 0.15}, 
	    [3] = {r = 0.92, g = 0.15, b = 0.15}, 
	    [4] = {r = 218/255, g = 218/255, b = 32/255}, 
	    [5] = {r = 48/255, g = 218/255, b = 32/255}, 
	    [6] = {r = 48/255, g = 218/255, b = 32/255}, 
	    [7] = {r = 48/255, g = 218/255, b = 32/255}, 
	    [8] = {r = 48/255, g = 218/255, b = 32/255}, 
	  }, 
	  ["Runes"] = {
	    [1] = {r = 1, g = 0, b = 0}, 
	    [2] = {r = 0, g = 0.5, b = 0}, 
	    [3] = {r = 0, g = 1, b = 1}, 
	    [4] = {r = 0.9, g = 0.1, b = 1}
	  }, 
	  ["MonkHarmony"] = {
	    [1] = {r = 0.57, g = 0.87, b = 0.35}, 
	    [2] = {r = 0.47, g = 0.87, b = 0.35}, 
	    [3] = {r = 0.37, g = 0.87, b = 0.35}, 
	    [4] = {r = 0.27, g = 0.87, b = 0.33}, 
	    [5] = {r = 0.17, g = 0.87, b = 0.33}
	  }, 
	  ["WarlockShards"] = {
	    [1] = {r = 148/255, g = 130/255, b = 201/255}, 
	    [2] = {r = 148/255, g = 130/255, b = 201/255}, 
	    [3] = {r = 255/255, g = 15/255, b = 0/255}
	  }, 
	  ["tapped"] = {r = 0.55, g = 0.57, b = 0.61}, 
	  ["disconnected"] = {r = 0.84, g = 0.75, b = 0.65}, 
	  ["casting"] = {r = 0.8, g = 0.8, b = 0}, 
	  ["spark"] = {r = 1, g = 0.72, b = 0}, 
	  ["interrupt"] = {r = 0.78, g = 0.25, b = 0.25}, 
	  ["shield_bars"] = {r = 143/255, g = 101/255, b = 158/255}, 
	  ["buff_bars"] = {r = 0.31, g = 0.31, b = 0.31}, 
	  ["debuff_bars"] = {r = 0.8, g = 0.1, b = 0.1}, 
	  ["predict"] = {
	    ["personal"] = {r = 0, g = 1, b = 0.5, a = 0.25}, 
	    ["others"] = {r = 0, g = 1, b = 0, a = 0.25}, 
	    ["absorbs"] = {r = 1, g = 1, b = 0, a = 0.25}
	  }
	},
	["templates"] = {
		["Default"] = {
			backdrop = {
				bgFile = "blank", 
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
			}, 
			primary = "default", 
			secondary = "dark", 
			gradient = "default", 
			texture = "default", 
			texnoupdate = true, 
			blending = false, 
			padding = 1, 
			shadow = false, 
			noupdate = false, 
		},
		["Transparent"] = {
			backdrop = {
				bgFile = "blank", 
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
			},
			primary = "transparent", 
			secondary = "dark", 
			gradient = false, 
			texture = false, 
			texnoupdate = true, 
			blending = false, 
			padding = 1, 
			shadow = false, 
			noupdate = true, 
		},
		["Component"] = {
			backdrop = {
				bgFile = "blank", 
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
			}, 
			primary = "default", 
			secondary = "dark", 
			gradient = "default", 
			texture = "default", 
			texnoupdate = true, 
			blending = false, 
			padding = 1, 
			shadow = true, 
			noupdate = false, 
		},   
		["Button"] = {
			backdrop = {
				bgFile = "button", 
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
			},
			primary = "default", 
			secondary = "dark", 
			gradient = false, 
			texture = false, 
			texnoupdate = true, 
			blending = false, 
			padding = 1, 
			shadow = true, 
			noupdate = false, 
		},
		["Slot"] = {
			backdrop = {
				bgFile = "default", 
				edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
				tile = false, 
				tileSize = 0, 
				edgeSize = 1, 
				insets = 
				{
					left = 1, 
					right = 1, 
					top = 1, 
					bottom = 1, 
				}, 
			}, 
			primary = "transparent", 
			secondary = "dark", 
			gradient = false, 
			texture = false, 
			texnoupdate = true, 
			blending = false, 
			padding = 1, 
			shadow = true, 
			noupdate = true, 
		},
		["Inset"] = {
			backdrop = {
				bgFile = "default", 
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
			}, 
			primary = "transparent", 
			secondary = "dark", 
			gradient = false, 
			texture = false, 
			texnoupdate = true, 
			blending = false, 
			padding = 1, 
			shadow = false, 
			noupdate = true, 
		},
		["Comic"] = {
			backdrop = {
				bgFile = "comic", 
				edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
				tile = false, 
				tileSize = 0, 
				edgeSize = 2, 
				insets = 
				{
					left = 2, 
					right = 2, 
					top = 2, 
					bottom = 2, 
				}, 
			}, 
			primary = "class", 
			secondary = "dark", 
			gradient = "class", 
			texture = "comic", 
			texnoupdate = false, 
			blending = false, 
			padding = 2, 
			shadow = false, 
			noupdate = false, 
		},
		["Pattern"] = {
			backdrop = {
				bgFile = "pattern", 
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
			}, 
			primary = "special", 
			secondary = "dark", 
			gradient = "special", 
			texture = "pattern", 
			texnoupdate = false, 
			blending = false, 
			padding = 1, 
			shadow = true, 
			noupdate = false, 
		}, 
		["Halftone"] = {
			backdrop = {
				bgFile = "blank", 
				edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
				tile = false, 
				tileSize = 0, 
				edgeSize = 2, 
				insets = 
				{
					left = 2, 
					right = 2, 
					top = 2, 
					bottom = 2, 
				}, 
			}, 
			primary = "default", 
			secondary = "dark", 
			gradient = "dark", 
			texture = "default", 
			texnoupdate = false, 
			blending = false, 
			padding = 2, 
			shadow = true, 
			noupdate = false, 
			extended = {
				TOPLEFT = [[Interface\AddOns\SVUI\assets\artwork\Template\Extended\HALFTONE_TOPLEFT]], 
				TOPRIGHT = [[Interface\AddOns\SVUI\assets\artwork\Template\Extended\HALFTONE_TOPRIGHT]], 
				BOTTOMRIGHT = [[Interface\AddOns\SVUI\assets\artwork\Template\Extended\HALFTONE_BOTTOMRIGHT]], 
				BOTTOMLEFT = [[Interface\AddOns\SVUI\assets\artwork\Template\Extended\HALFTONE_BOTTOMLEFT]],
			}, 
		}, 
		["Action"] = {
			backdrop = {
				bgFile = "blank", 
				edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
				tile = false, 
				tileSize = 0, 
				edgeSize = 2, 
				insets = 
				{
					left = 2, 
					right = 2, 
					top = 2, 
					bottom = 2, 
				}, 
			}, 
			primary = "default", 
			secondary = "dark", 
			gradient = "special", 
			texture = "default", 
			texnoupdate = false, 
			blending = false, 
			padding = 2, 
			shadow = true, 
			noupdate = false, 
			extended = {
				TOPLEFT = [[Interface\AddOns\SVUI\assets\artwork\Template\Extended\ACTION_TOPLEFT]], 
				TOPRIGHT = [[Interface\AddOns\SVUI\assets\artwork\Template\Extended\ACTION_TOPRIGHT]], 
				BOTTOMRIGHT = [[Interface\AddOns\SVUI\assets\artwork\Template\Extended\ACTION_BOTTOMRIGHT]], 
				BOTTOMLEFT = [[Interface\AddOns\SVUI\assets\artwork\Template\Extended\ACTION_BOTTOMLEFT]],
			}, 
		},  
		["UnitLarge"] = {
			backdrop = false, 
			primary = "special", 
			secondary = "dark", 
			gradient = false, 
			texture = "unitlarge", 
			texnoupdate = false, 
			blending = false, 
			padding = 1, 
			shadow = false, 
			noupdate = false, 
		}, 
		["UnitSmall"] = {
			backdrop = false, 
			primary = "special", 
			secondary = "dark", 
			gradient = false, 
			texture = "unitsmall", 
			texnoupdate = false, 
			blending = false, 
			padding = 1, 
			shadow = false, 
			noupdate = false, 
		} 
	}
};
--[[ 
########################################################## 
DB PROTECTED VARS
##########################################################
]]--
P['common'] = {
	["taintLog"] = false,
	["stickyFrames"] = true,
	['loginmessage'] = true,
	['hideErrorFrame'] = true,
	['font'] = "SVUI System Font",
	['nameFont'] = "SVUI Name Font",
	['numberFont'] = "SVUI Number Font",
	['combatFont'] = "SVUI Combat Font",
	['giantFont'] = "SVUI Action Font",
	['threatbar'] = true,
	["cooldown"] = {
		enable = true,
	}
};
P['scripts'] = {
	['bubbles'] = true,
	["comix"] = true,
	['totems'] = true,
	['questWatch'] = true
};
P['docklets'] = {
	['DockletMain'] = "None",
	['MainWindow'] = "None",
	['DockletExtra'] = "None",
	['ExtraWindow'] = "None",
	['enableExtra'] = false,
	['DockletCombatFade'] = true
};
P['mounts'] = {
	["GROUND"] = false,
	["FLYING"] = false,
	["SWIMMING"] = false,
	["SPECIAL"] = false
};
P['mountNames'] = {
	["GROUND"] = "",
	["FLYING"] = "",
	["SWIMMING"] = "",
	["SPECIAL"] = ""
};
--[[ 
########################################################## 
DB GLOBAL VARS
##########################################################
]]--
G["common"]={
	["autoScale"]=true,
};
G["classtimer"]={};
G["SVPlate"]={
	["filter"]={}
};
G['SVUnit']={};
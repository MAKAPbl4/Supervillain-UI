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
LOCALIZED GLOBALS
##########################################################
]]--
local SVUI_CLASS_COLORS = _G.SVUI_CLASS_COLORS
local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, G = unpack(select(2, ...));
local scc = SVUI_CLASS_COLORS[SuperVillain.class];
local rcc = RAID_CLASS_COLORS[SuperVillain.class];
local r2 = .1 + (rcc.r * .1)
local g2 = .1 + (rcc.g * .1)
local b2 = .1 + (rcc.b * .1)
--[[ 
########################################################## 
LAYOUT PRESETS
##########################################################
]]--
local presets = {
	["media"] = {
		["default"] = {
			["colors"] = {
				["highlight"] = {r = rcc.r, g = rcc.g, b = rcc.b, a = 1},
				["default"] = {r = .2, g = .2, b = .2, a = 1},
				["special"] = {r = r2, g = g2, b = b2, a = 1},
			},
			["textures"] = {
				["pattern"] = {"background", "SVUI Backdrop 3"},
				["comic"] = {"background", "SVUI Comic 6"},
				["unitlarge"] = {"background", "SVUI Unit BG 3"},
				["unitsmall"] = {"background", "SVUI Small BG 3"},
			},
			["unitframes"] = {
				["buff_bars"] = {r = scc.r, g = scc.g, b = scc.b, a = 1},
				["health"] = {r = .16, g = .86, b = .22, a = 1},
				["casting"] = {r = .91, g = .91, b = 0, a = 1},
				["spark"] = {r = 1, g = .72, b = 0, a = 1},
			},
		},
		["kaboom"] = {
			["colors"] = {
				["highlight"] = {r = .2, g = .5, b = 1, a = 1},
				["default"] = {r = .2, g = .2, b = .2, a = 1},
				["special"] = {r = .1, g = .12, b = .14, a = 1},
			},
			["textures"] = {
				["pattern"] = {"background", "SVUI Backdrop 4"},
				["comic"] = {"background", "SVUI Comic 5"},
				["unitlarge"] = {"background", "SVUI Unit BG 4"},
				["unitsmall"] = {"background", "SVUI Small BG 4"},
			},
			["unitframes"] = {
				["buff_bars"] = {r = .51, g = .79, b = 0, a = 1},
				["health"] = {r = .16, g = .86, b = .22, a = 1},
				["casting"] = {r = .91, g = .91, b = 0, a = 1},
				["spark"] = {r = 1, g = .72, b = 0, a = 1},
			},
		},
		["vintage"] = {
			["colors"] = {
				["highlight"] = {r = .2, g = .5, b = 1, a = 1},
				["default"] = {r = .2, g = .2, b = .2, a = 1},
				["special"] = {r = .37, g = .32, b = .29, a = 1},
			},
			["textures"] = {
				["pattern"] = {"background", "SVUI Backdrop 2"},
				["comic"] = {"background", "SVUI Comic 2"},
				["unitlarge"] = {"background", "SVUI Unit BG 2"},
				["unitsmall"] = {"background", "SVUI Small BG 2"},
			},
			["unitframes"] = {
				["buff_bars"] = {r = .91, g = .91, b = .31, a = 1},
				["health"] = {r = .1, g = .6, b = .02, a = 1},
				["casting"] = {r = .91, g = .91, b = .31, a = 1},
				["spark"] = {r = 1, g = .72, b = 0, a = 1},
			},
		},
		["dark"] = {
			["colors"] = {
				["highlight"] = {r = .2, g = .5, b = 1, a = 1},
				["default"] = {r = .2, g = .2, b = .2, a = 1},
				["special"] = {r = .1, g = .12, b = .14, a = 1},
			},
			["textures"] = {
				["pattern"] = {"background", "SVUI Backdrop 1"},
				["comic"] = {"background", "SVUI Comic 3"},
				["unitlarge"] = {"background", "SVUI Unit BG 5"},
				["unitsmall"] = {"background", "SVUI Small BG 1"},
			},
			["unitframes"] = {
				["buff_bars"] = {r = .45, g = .55, b = .15, a = 1},
				["health"] = {r = .06, g = .06, b = .06, a = 1},
				["casting"] = {r = .8, g = .8, b = 0, a = 1},
				["spark"] = {r = 1, g = .72, b = 0, a = 1},
			},
		},
	},
	["auras"] = {
		["default"] = {
			["player"] = {
				["buffs"] = {
					enable = false,
					attachTo = "DEBUFFS",
					anchorPoint = 'TOPLEFT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'RIGHT',
				},
				["debuffs"] = {
					enable = false,
					attachTo = "FRAME",
					anchorPoint = 'TOPLEFT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'RIGHT',
				},
				["aurabar"] = {
					enable = false
				}
			},
			["target"] = {
				["smartAuraDisplay"] = "DISABLED",
				["buffs"] = {
					enable = true,
					attachTo = "FRAME",
					anchorPoint = 'TOPRIGHT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'LEFT',
				},
				["debuffs"] = {
					enable = true,
					attachTo = "BUFFS",
					anchorPoint = 'TOPRIGHT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'LEFT',
				},
				["aurabar"] = {
					enable = false
				}
			},
			["focus"] = {
				["smartAuraDisplay"] = "DISABLED",
				["buffs"] = {
					enable = false,
					attachTo = "FRAME",
					anchorPoint = 'TOPRIGHT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'LEFT',
				},
				["debuffs"] = {
					enable = true,
					attachTo = "FRAME",
					anchorPoint = 'TOPRIGHT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'LEFT',
				},
				["aurabar"] = {
					enable = false
				}
			}
		},
		["icons"] = {
			["player"] = {
				["buffs"] = {
					enable = true,
					attachTo = "FRAME",
					anchorPoint = 'TOPLEFT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'RIGHT',
				},
				["debuffs"] = {
					enable = true,
					attachTo = "BUFFS",
					anchorPoint = 'TOPLEFT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'RIGHT',
				},
				["aurabar"] = {
					enable = false
				}
			},
			["target"] = {
				["smartAuraDisplay"] = "DISABLED",
				["buffs"] = {
					enable = true,
					attachTo = "FRAME",
					anchorPoint = 'TOPRIGHT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'LEFT',
				},
				["debuffs"] = {
					enable = true,
					attachTo = "BUFFS",
					anchorPoint = 'TOPRIGHT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'LEFT',
				},
				["aurabar"] = {
					enable = false
				}
			},
			["focus"] = {
				["smartAuraDisplay"] = "DISABLED",
				["buffs"] = {
					enable = false,
					attachTo = "FRAME",
					anchorPoint = 'TOPRIGHT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'LEFT',
				},
				["debuffs"] = {
					enable = true,
					attachTo = "FRAME",
					anchorPoint = 'TOPRIGHT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'LEFT',
				},
				["aurabar"] = {
					enable = false
				}
			}
		},
		["bars"] = {
			["player"] = {
				["buffs"] = {
					enable = false,
					attachTo = "FRAME"
				},
				["debuffs"] = {
					enable = false,
					attachTo = "FRAME"
				},
				["aurabar"] = {
					enable = true,
					attachTo = "FRAME"
				}
			},
			["target"] = {
				["smartAuraDisplay"] = "SHOW_DEBUFFS_ON_FRIENDLIES",
				["buffs"] = {
					enable = false,
					attachTo = "FRAME"
				},
				["debuffs"] = {
					enable = false,
					attachTo = "FRAME"
				},
				["aurabar"] = {
					enable = true,
					attachTo = "FRAME"
				}
			},
			["focus"] = {
				["smartAuraDisplay"] = "SHOW_DEBUFFS_ON_FRIENDLIES",
				["buffs"] = {
					enable = false,
					attachTo = "FRAME"
				},
				["debuffs"] = {
					enable = false,
					attachTo = "FRAME"
				},
				["aurabar"] = {
					enable = true,
					attachTo = "FRAME"
				}
			}
		},
		["theworks"] = {
			["player"] = {
				["buffs"] = {
					enable = true,
					attachTo = "FRAME",
					anchorPoint = 'TOPLEFT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'RIGHT',
				},
				["debuffs"] = {
					enable = true,
					attachTo = "BUFFS",
					anchorPoint = 'TOPLEFT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'RIGHT',
				},
				["aurabar"] = {
					enable = true,
					attachTo = "DEBUFFS"
				}
			},
			["target"] = {
				["smartAuraDisplay"] = "SHOW_DEBUFFS_ON_FRIENDLIES",
				["buffs"] = {
					enable = true,
					attachTo = "FRAME",
					anchorPoint = 'TOPRIGHT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'LEFT',
				},
				["debuffs"] = {
					enable = true,
					attachTo = "BUFFS",
					anchorPoint = 'TOPRIGHT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'LEFT',
				},
				["aurabar"] = {
					enable = true,
					attachTo = "DEBUFFS"
				}
			},
			["focus"] = {
				["smartAuraDisplay"] = "SHOW_DEBUFFS_ON_FRIENDLIES",
				["buffs"] = {
					enable = true,
					attachTo = "FRAME",
					anchorPoint = 'TOPRIGHT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'LEFT',
				},
				["debuffs"] = {
					enable = true,
					attachTo = "BUFFS",
					anchorPoint = 'TOPRIGHT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'LEFT',
				},
				["aurabar"] = {
					enable = true,
					attachTo = "DEBUFFS"
				}
			}
		},
	},
	["bars"] = {
		["default"] = {
			["Bar1"] = {
				buttonsize = 40
			},
			["Bar2"] = {
				enable = false
			},
			["Bar3"] = {
				buttons = 6,
				buttonspacing = 3,
				buttonsPerRow = 6,
				buttonsize = 40
			},
			["Bar5"] = {
				buttons = 6,
				buttonspacing = 3,
				buttonsPerRow = 6,
				buttonsize = 40
			}
		},
		["onesmall"] = {
			["Bar1"] = {
				buttonsize = 32
			},
			["Bar2"] = {
				enable = false
			},
			["Bar3"] = {
				buttons = 6,
				buttonspacing = 2,
				buttonsPerRow = 6,
				buttonsize = 32
			},
			["Bar5"] = {
				buttons = 6,
				buttonspacing = 2,
				buttonsPerRow = 6,
				buttonsize = 32
			}
		},
		["twosmall"] = {
			["Bar1"] = {
				buttonsize = 32
			},
			["Bar2"] = {
				enable = true,
				buttonsize = 32
			},
			["Bar3"] = {
				buttons = 12,
				buttonspacing = 2,
				buttonsPerRow = 6,
				buttonsize = 32
			},
			["Bar5"] = {
				buttons = 12,
				buttonspacing = 2,
				buttonsPerRow = 6,
				buttonsize = 32
			}
		},
		["twobig"] = {
			["Bar1"] = {
				buttonsize = 40
			},
			["Bar2"] = {
				enable = true,
				buttonsize = 40
			},
			["Bar3"] = {
				buttons = 12,
				buttonspacing = 3,
				buttonsPerRow = 6,
				buttonsize = 40
			},
			["Bar5"] = {
				buttons = 12,
				buttonspacing = 3,
				buttonsPerRow = 6,
				buttonsize = 40
			}
		},
	},
	["units"] = {
		["default"] = {
			["player"] = {
				width = 235,
				height = 70,
				portrait = {
					enable = true,
					overlay = true,
					style = "3D",
				}
			},
			["target"] = {
				width = 235,
				height = 70,
				portrait = {
					enable = true,
					overlay = true,
					style = "3D",
				}
			},
			["pet"] = {
				width = 130,
				height = 30,
				portrait = {
					enable = true,
					overlay = true,
					style = "3D",
				},
				name = {
					position = "CENTER"
				},
			},
			["targettarget"] = {
				width = 130,
				height = 30,
				portrait = {
					enable = true,
					overlay = true,
					style = "3D",
				},
				name = {
					position = "CENTER"
				},
			},
			["boss"] = {
				width = 200,
				height = 45,
				portrait = {
					enable = true,
					overlay = true,
					style = "3D",
				}
			},
			["party"] = {
				width = 75,
				height = 70,
				gridMode = false,
				wrapXOffset = 9,
				wrapYOffset = 13,
				portrait = {
					enable = true,
					overlay = true,
					style = "3D",
				},
				name = {
					position = "INNERTOPLEFT"
				},
			},
			["raid10"] = {
				width = 50,
				height = 30,
				gridMode = false,
				wrapXOffset = 6,
				wrapYOffset = 6,
			},
			["raid25"] = {
				width = 50,
				height = 30,
				gridMode = false,
				wrapXOffset = 6,
				wrapYOffset = 6,
			},
			["raid40"] = {
				width = 50,
				height = 30,
				gridMode = false,
				wrapXOffset = 6,
				wrapYOffset = 6,
			},
		},
		["super"] = {
			["player"] = {
				width = 235,
				height = 70,
				portrait = {
					enable = true,
					overlay = true,
					style = "3D",
				}
			},
			["target"] = {
				width = 235,
				height = 70,
				portrait = {
					enable = true,
					overlay = true,
					style = "3D",
				}
			},
			["pet"] = {
				width = 150,
				height = 30,
				portrait = {
					enable = true,
					overlay = true,
					style = "3D",
				},
				name = {
					position = "CENTER"
				},
			},
			["targettarget"] = {
				width = 150,
				height = 30,
				portrait = {
					enable = true,
					overlay = true,
					style = "3D",
				},
				name = {
					position = "CENTER"
				},
			},
			["boss"] = {
				width = 200,
				height = 45,
				portrait = {
					enable = true,
					overlay = true,
					style = "3D",
				}
			},
			["party"] = {
				width = 75,
				height = 70,
				gridMode = false,
				wrapXOffset = 9,
				wrapYOffset = 13,
				portrait = {
					enable = true,
					overlay = true,
					style = "3D",
				},
				name = {
					position = "INNERTOPLEFT"
				},
			},
			["raid10"] = {
				width = 50,
				height = 30,
				gridMode = false,
				wrapXOffset = 6,
				wrapYOffset = 6,
			},
			["raid25"] = {
				width = 50,
				height = 30,
				gridMode = false,
				wrapXOffset = 6,
				wrapYOffset = 6,
			},
			["raid40"] = {
				width = 50,
				height = 30,
				gridMode = false,
				wrapXOffset = 6,
				wrapYOffset = 6,
			},
		},
		["simple"] = {
			["player"] = {
				width = 235,
				height = 70,
				portrait = {
					enable = true,
					overlay = false,
					style = "2D",
				}
			},
			["target"] = {
				width = 235,
				height = 70,
				portrait = {
					enable = true,
					overlay = false,
					style = "2D",
				}
			},
			["pet"] = {
				width = 150,
				height = 30,
				portrait = {
					enable = true,
					overlay = false,
					style = "2D",
				},
				name = {
					position = "INNERLEFT"
				},
			},
			["targettarget"] = {
				width = 150,
				height = 30,
				portrait = {
					enable = true,
					overlay = false,
					style = "2D",
				},
				name = {
					position = "INNERLEFT"
				},
			},
			["boss"] = {
				width = 200,
				height = 45,
				portrait = {
					enable = true,
					overlay = false,
					style = "2D",
				}
			},
			["party"] = {
				width = 100,
				height = 35,
				gridMode = false,
				wrapXOffset = 9,
				wrapYOffset = 13,
				portrait = {
					enable = true,
					overlay = false,
					style = "2D",
				},
				name = {
					position = "INNERRIGHT"
				},
			},
			["raid10"] = {
				width = 50,
				height = 30,
				gridMode = false,
				wrapXOffset = 6,
				wrapYOffset = 6,
			},
			["raid25"] = {
				width = 50,
				height = 30,
				gridMode = false,
				wrapXOffset = 6,
				wrapYOffset = 6,
			},
			["raid40"] = {
				width = 50,
				height = 30,
				gridMode = false,
				wrapXOffset = 6,
				wrapYOffset = 6,
			},
		},
		["compact"] = {
			["player"] = {
				width = 235,
				height = 50,
				portrait = {
					enable = false
				}
			},
			["target"] = {
				width = 235,
				height = 50,
				portrait = {
					enable = false
				}
			},
			["pet"] = {
				width = 130,
				height = 30,
				portrait = {
					enable = false
				},
				name = {
					position = "CENTER"
				},
			},
			["targettarget"] = {
				width = 130,
				height = 30,
				portrait = {
					enable = false
				},
				name = {
					position = "CENTER"
				},
			},
			["boss"] = {
				width = 200,
				height = 45,
				portrait = {
					enable = false
				}
			},
			["party"] = {
				width = 70,
				height = 30,
				gridMode = false,
				wrapXOffset = 9,
				wrapYOffset = 13,
				portrait = {
					enable = false
				},
				name = {
					position = "INNERTOPLEFT"
				},
			},
			["raid10"] = {
				width = 50,
				height = 30,
				gridMode = false,
				wrapXOffset = 6,
				wrapYOffset = 6,
			},
			["raid25"] = {
				width = 50,
				height = 30,
				gridMode = false,
				wrapXOffset = 6,
				wrapYOffset = 6,
			},
			["raid40"] = {
				width = 50,
				height = 30,
				gridMode = false,
				wrapXOffset = 6,
				wrapYOffset = 6,
			},
		},
	}	
};

function SuperVillain:GetPresetData(category, theme)
	if(presets[category]) then
		theme = theme or "default"
		return presets[category][theme] or {}
	end
end
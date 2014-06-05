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
local unpack 	 =  _G.unpack;
local pairs 	 =  _G.pairs;
local tinsert 	 =  _G.tinsert;
local table 	 =  _G.table;
--[[ TABLE METHODS ]]--
local tsort = table.sort;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, G = unpack(SVUI);
local MOD = SuperVillain:GetModule('SVLaborer')
SuperVillain.Options.args.SVLaborer = {
	type = 'group',
	name = L['Laborer'], 	
	get = function(key)return SuperVillain.db.SVLaborer[key[#key]]end,
	set = function(key, value)MOD:ChangeDBVar(value, key[#key]) end, 
	args = {
		intro = {
			order = 1, 
			type = 'description', 
			name = L["Options for laborer modes"]
		},
		fontSize = {
			order = 2,
			name = L["Font Size"],
			desc = L["Set the font size of the log window."],
			type = "range",
			min = 6,
			max = 22,
			step = 1,
			set = function(j,value)MOD:ChangeDBVar(value,j[#j]);MOD:UpdateLogWindow()end
		},
		fishing = {
			order = 3, 
			type = "group", 
			name = L["Fishing Mode Settings"], 
			guiInline = true, 
			args = {
				enable = {
					type = "toggle", 
					order = 1, 
					name = L['Enable'], 
					desc = L['Enable/Disable the fishing mode.'], 
					get = function(key)return SuperVillain.protected.SVLaborer[key[#key]]end, 
					set = function(key, value)
						SuperVillain.protected.SVLaborer.fishing.enable = value;
						SuperVillain:StaticPopup_Show("RL_CLIENT")
					end
				},
				autoequip = {
					type = "toggle", 
					order = 2, 
					name = L['AutoEquip'], 
					desc = L['Enable/Disable automatically equipping fishing gear.'], 
					get = function(key)return SuperVillain.db.SVLaborer.fishing[key[#key]]end,
					set = function(key, value)MOD:ChangeDBVar(value, key[#key], "fishing")end
				}
			}	
		},
		cooking = {
			order = 4, 
			type = "group", 
			name = L["Cooking Mode Settings"], 
			guiInline = true, 
			args = {
				enable = {
					type = "toggle", 
					order = 1, name = L['Enable'], 
					desc = L['Enable/Disable the cooking mode.'], 
					get = function(key)return SuperVillain.protected.SVLaborer[key[#key]]end, 
					set = function(key, value)SuperVillain.protected.SVLaborer.cooking.enable = value;SuperVillain:StaticPopup_Show("RL_CLIENT")end
				},
				autoequip = {
					type = "toggle", 
					order = 2, 
					name = L['AutoEquip'], 
					desc = L['Enable/Disable automatically equipping cooking gear.'], 
					get = function(key)return SuperVillain.db.SVLaborer.cooking[key[#key]]end,
					set = function(key, value)MOD:ChangeDBVar(value, key[#key], "cooking")end
				}
			}
		},
		archaeology = {
			order = 5, 
			type = "group", 
			name = L["Archaeology Mode Settings"], 
			guiInline = true, 
			args = {
				enable = {
					type = "toggle", 
					order = 1, 
					name = L['Enable'], 
					desc = L['Enable/Disable the archaeology mode.'], 
					get = function(key)return SuperVillain.protected.SVLaborer[key[#key]]end, 
					set = function(key, value)SuperVillain.protected.SVLaborer.archaeology.enable = value;SuperVillain:StaticPopup_Show("RL_CLIENT")end
				}
			}
		},
		farming = {
			order = 6, 
			type = "group", 
			name = L["Farming Mode Settings"], 
			guiInline = true, 
			get = function(key)return SuperVillain.db.SVLaborer.farming[key[#key]]end, 
			set = function(key, value)SuperVillain.db.SVLaborer.farming[key[#key]] = value end, 
			args = {
				enable = {
					type = "toggle", 
					order = 1, 
					name = L['Enable'], 
					desc = L['Enable/Disable the farming mode.'], 
					get = function(key)return SuperVillain.protected.SVLaborer[key[#key]]end, 
					set = function(key, value)
						SuperVillain.protected.SVLaborer.farming.enable = value;
						SuperVillain:StaticPopup_Show("RL_CLIENT")
					end
				},
				buttonsize = {
					type = 'range', 
					name = L['Button Size'], 
					desc = L['The size of the action buttons.'], 
					min = 15, 
					max = 60, 
					step = 1, 
					order = 2, 
					set = function(key, value)
						MOD:ChangeDBVar(value, key[#key],"farming");
						MOD.Farming:UpdateLayout()
					end, 
					disabled = function()return not SuperVillain.protected.SVLaborer.farming.enable end
				},
				buttonspacing = {
					type = 'range', 
					name = L['Button Spacing'], 
					desc = L['The spacing between buttons.'], 
					min = 1, 
					max = 10, 
					step = 1, 
					order = 3, 
					set = function(key, value)
						MOD:ChangeDBVar(value, key[#key],"farming");
						MOD.Farming:UpdateLayout()
					end, 
					disabled = function()return not SuperVillain.protected.SVLaborer.farming.enable end
				},
				onlyactive = {
					order = 4, 
					type = 'toggle', 
					name = L['Only active buttons'], 
					desc = L['Only show the buttons for the seeds, portals, tools you have in your bags.'], 
					set = function(key, value)
						MOD:ChangeDBVar(value, key[#key],"farming");
						MOD.Farming:UpdateLayout()
					end, 
					disabled = function()return not SuperVillain.protected.SVLaborer.farming.enable end
				},
				droptools = {
					order = 5, 
					type = 'toggle', 
					name = L['Drop '], 
					desc = L['Automatically drop tools from your bags when leaving the farming area.'], 
					disabled = function()return not SuperVillain.protected.SVLaborer.farming.enable end
				},
				toolbardirection = {
					order = 6, 
					type = 'select', 
					name = L['Bar Direction'], 
					desc = L['The direction of the bar buttons (Horizontal or Vertical).'], 
					set = function(key, value)MOD:ChangeDBVar(value, key[#key],"farming");MOD.Farming:UpdateLayout()end, 
					disabled = function()return not SuperVillain.protected.SVLaborer.farming.enable end, 
					values = {
							['VERTICAL'] = L['Vertical'], ['HORIZONTAL'] = L['Horizontal']
					}
				}
			}
		}
	}
}
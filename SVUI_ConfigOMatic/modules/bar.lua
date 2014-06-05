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
local MOD = SuperVillain:GetModule('SVBar');
--[[ 
########################################################## 
SET PACKAGE OPTIONS
##########################################################
]]--
local bar_configs;
local function BarConfigLoader()
	local b={["TOPLEFT"]="TOPLEFT",["TOPRIGHT"]="TOPRIGHT",["BOTTOMLEFT"]="BOTTOMLEFT",["BOTTOMRIGHT"]="BOTTOMRIGHT"}
	for d=1,6 do 
		local name=L['Bar ']..d;
		bar_configs["Bar"..d] = {
			order = d,
			name = name,
			type = "group",
			order = (d + 10),
			guiInline = false,
			disabled = function()return not SuperVillain.protected.SVBar.enable end,
			get = function(key) 
				return SuperVillain.db.SVBar["Bar"..d][key[#key]] 
			end, 
			set = function(key, value)
				MOD:ChangeDBVar(value, key[#key], "Bar"..d);
				MOD:RefreshBar("Bar"..d)
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				backdrop = {
					order = 2,
					name = L["Background"],
					type = "toggle"
				},
				mouseover = {
					order = 3,
					name = L["Mouse Over"],
					desc = L["The frame is not shown unless you mouse over the frame."],
					type = "toggle"
				},
				restorePosition = {
					order = 4,
					type = "execute",
					name = L["Restore Bar"],
					desc = L["Restore the actionbars default settings"],
					func = function()
						SuperVillain:TableSplice(SuperVillain.db.SVBar["Bar"..d], P.SVBar["Bar"..d])
						SuperVillain:ResetMovables("Bar "..d)
						MOD:RefreshBar("Bar"..d)
					end
				},
				adjustGroup = {
					name = L["Bar Adjustments"],
					type = "group",
					order = 5,
					guiInline = true,
					args = {
						point = {
							order = 1,
							type = "select",
							name = L["Anchor Point"],
							desc = L["The first button anchors itself to this point on the bar."],
							values = b
						},
						buttons = {
							order = 2,
							type = "range",
							name = L["Buttons"],
							desc = L["The amount of buttons to display."],
							min = 1,
							max = NUM_ACTIONBAR_BUTTONS,
							step = 1
						},
						buttonsPerRow = {
							order = 3,
							type = "range",
							name = L["Buttons Per Row"],
							desc = L["The amount of buttons to display per row."],
							min = 1,
							max = NUM_ACTIONBAR_BUTTONS,
							step = 1
						},
						buttonsize = {
							type = "range",
							name = L["Button Size"],
							desc = L["The size of the action buttons."],
							min = 15,
							max = 60,
							step = 1,
							order = 4,
							disabled = function()return not SuperVillain.protected.SVBar.enable end
						},
						buttonspacing = {
							type = "range",
							name = L["Button Spacing"],
							desc = L["The spacing between buttons."],
							min = 1,
							max = 10,
							step = 1,
							order = 5,
							disabled = function()return not SuperVillain.protected.SVBar.enable end
						},
						alpha = {
							order = 6,
							type = "range",
							name = L["Alpha"],
							isPercent = true,
							min = 0,
							max = 1,
							step = 0.01
						},
					}
				},
				pagingGroup = {
					name = L["Bar Paging"],
					type = "group",
					order = 6,
					guiInline = true,
					args = {
						useCustomStates = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							desc = L["Allow the use of custom paging for this bar"],
							get = function()return SuperVillain.db.SVBar["Bar"..d].useCustomStates end,
							set = function(e,f)
								SuperVillain.db.SVBar["Bar"..d][e[#e]] = f;
								MOD.db["Bar"..d][e[#e]] = f;
								MOD:UpdateBarPagingDefaults();
								MOD:RefreshBar("Bar"..d)
							end
						},
						resetStates = {
							order = 2,
							type = "execute",
							name = L["Restore Defaults"],
							desc = L["Restore default paging attributes for this bar"],
							func = function()
								SuperVillain.db.SVBar["Bar"..d].customStates[SuperVillain.class] = SuperVillain.protected.SVBar.defaultStates["Bar"..d][SuperVillain.class];
								MOD.db["Bar"..d].customStates[SuperVillain.class] = SuperVillain.protected.SVBar.defaultStates["Bar"..d][SuperVillain.class];
								MOD:UpdateBarPagingDefaults();
								MOD:RefreshBar("Bar"..d)
							end
						},
						customStates = {
							order = 3,
							type = "input",
							width = "full",
							name = L["Paging"],
							desc = L["|cffFF0000ADVANCED:|r Set the paging attributes for this bar"],
							get = function(e)return SuperVillain.db.SVBar["Bar"..d].customStates[SuperVillain.class] end,
							set = function(e,f)
								SuperVillain.db.SVBar["Bar"..d].customStates[SuperVillain.class] = f;
								MOD.db["Bar"..d].customStates[SuperVillain.class] = f;
								MOD:UpdateBarPagingDefaults();
								MOD:RefreshBar("Bar"..d)
							end,
							disabled = function()return not SuperVillain.db.SVBar["Bar"..d].useCustomStates end,
						},

					}
				}
			}
		}
	end;
	bar_configs["Micro"] = {
		order = d,
		name = L["Micro Menu"],
		type = "group",
		order = 100,
		guiInline = false,
		disabled = function()return not SuperVillain.protected.SVBar.enable end,
		get = function(key) 
			return SuperVillain.db.SVBar["Micro"][key[#key]] 
		end, 
		set = function(key, value)
			MOD:ChangeDBVar(value, key[#key], "Micro");
			MOD:UpdateMicroButtons()
		end,
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"]
			},
			mouseover = {
				order = 2,
				name = L["Mouse Over"],
				desc = L["The frame is not shown unless you mouse over the frame."],
				type = "toggle"
			},
			buttonsize = {
				order = 3,
				type = "range",
				name = L["Button Size"],
				desc = L["The size of the action buttons."],
				min = 15,
				max = 60,
				step = 1,
				disabled = function()return not SuperVillain.protected.SVBar.enable end
			},
			buttonspacing = {
				order = 4,
				type = "range",
				name = L["Button Spacing"],
				desc = L["The spacing between buttons."],
				min = 1,
				max = 10,
				step = 1,
				disabled = function()return not SuperVillain.protected.SVBar.enable end
			},
		}
	}
	bar_configs["Pet"] = {
		order = d,
		name = L["Pet Bar"],
		type = "group",
		order = 200,
		guiInline = false,
		disabled = function()return not SuperVillain.protected.SVBar.enable end,
		get = function(e)return SuperVillain.db.SVBar["Pet"][e[#e]]end,
		set = function(e,f)SuperVillain.db.SVBar["Pet"][e[#e]] = f;MOD:RefreshBar("Pet")end,
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"]
			},
			backdrop = {
				order = 2,
				name = L["Background"],
				type = "toggle"
			},
			mouseover = {
				order = 3,
				name = L["Mouse Over"],
				desc = L["The frame is not shown unless you mouse over the frame."],
				type = "toggle"
			},
			restorePosition = {
				order = 4,
				type = "execute",
				name = L["Restore Bar"],
				desc = L["Restore the actionbars default settings"],
				func = function()
					SuperVillain:TableSplice(SuperVillain.db.SVBar["Pet"],P.SVBar["Pet"])
					SuperVillain:ResetMovables("Pet Bar")
					MOD:RefreshBar("Pet")
				end
			},
			adjustGroup = {
				name = L["Bar Adjustments"],
				type = "group",
				order = 5,
				guiInline = true,
				args = {	
					point = {
						order = 1,
						type = "select",
						name = L["Anchor Point"],
						desc = L["The first button anchors itself to this point on the bar."],
						values = b
					},
					buttons = {
						order = 2,
						type = "range",
						name = L["Buttons"],
						desc = L["The amount of buttons to display."],
						min = 1,
						max = NUM_PET_ACTION_SLOTS,
						step = 1
					},
					buttonsPerRow = {
						order = 3,
						type = "range",
						name = L["Buttons Per Row"],
						desc = L["The amount of buttons to display per row."],
						min = 1,
						max = NUM_PET_ACTION_SLOTS,
						step = 1
					},
					buttonsize = {
						order = 4,
						type = "range",
						name = L["Button Size"],
						desc = L["The size of the action buttons."],
						min = 15,
						max = 60,
						step = 1,
						disabled = function()return not SuperVillain.protected.SVBar.enable end
					},
					buttonspacing = {
						order = 5,
						type = "range",
						name = L["Button Spacing"],
						desc = L["The spacing between buttons."],
						min = 1,
						max = 10,
						step = 1,
						disabled = function()return not SuperVillain.protected.SVBar.enable end
					},
					alpha = {
						order = 6,
						type = "range",
						name = L["Alpha"],
						isPercent = true,
						min = 0,
						max = 1,
						step = 0.01
					},
				}
			},
			customGroup = {
				name = L["Stateful Options"],
				type = "group",
				order = 6,
				guiInline = true,
				args = {
					visibility = {
						type = "input",
						order = 13,
						name = L["Visibility State"],
						desc = L["This works like a macro, you can run different situations to get the actionbar to show/hide differently.\n Example: '[combat] show;hide'"],
						width = "full",
						multiline = true,
						set = function(e,f)SuperVillain.db.SVBar["Pet"]["visibility"] = f;MOD:RefreshButtons()end
					}
				}
			}
		}
	}
	bar_configs["Stance"] = {
		order = d,
		name = L["Stance Bar"],
		type = "group",
		order = 300,
		guiInline = false,
		disabled = function()return not SuperVillain.protected.SVBar.enable end,
		get = function(e)return SuperVillain.db.SVBar["Stance"][e[#e]]end,
		set = function(e,f)SuperVillain.db.SVBar["Stance"][e[#e]] = f;MOD:RefreshBar("Stance")end,
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"]
			},
			backdrop = {
				order = 2,
				name = L["Background"],
				type = "toggle"
			},
			mouseover = {
				order = 3,
				name = L["Mouse Over"],
				desc = L["The frame is not shown unless you mouse over the frame."],
				type = "toggle"
			},
			restorePosition = {
				order = 4,
				type = "execute",
				name = L["Restore Bar"],
				desc = L["Restore the actionbars default settings"],
				func = function()
					SuperVillain:TableSplice(SuperVillain.db.SVBar["Stance"],P.SVBar["Stance"])
					SuperVillain:ResetMovables("Stance Bar")
					MOD:RefreshBar("Stance")
				end
			},
			adjustGroup = {
				name = L["Bar Adjustments"],
				type = "group",
				order = 5,
				guiInline = true,
				args = {
					point = {
						order = 1,
						type = "select",
						name = L["Anchor Point"],
						desc = L["The first button anchors itself to this point on the bar."],
						values = b
					},
					buttons = {
						order = 2,
						type = "range",
						name = L["Buttons"],
						desc = L["The amount of buttons to display."],
						min = 1,
						max = NUM_STANCE_SLOTS,
						step = 1
					},
					buttonsPerRow = {
						order = 3,
						type = "range",
						name = L["Buttons Per Row"],
						desc = L["The amount of buttons to display per row."],
						min = 1,
						max = NUM_STANCE_SLOTS,
						step = 1
					},
					buttonsize = {
						order = 4,
						type = "range",
						name = L["Button Size"],
						desc = L["The size of the action buttons."],
						min = 15,
						max = 60,
						step = 1,
						disabled = function()return not SuperVillain.protected.SVBar.enable end
					},
					buttonspacing = {
						order = 5,
						type = "range",
						name = L["Button Spacing"],
						desc = L["The spacing between buttons."],
						min = 1,
						max = 10,
						step = 1,
						disabled = function()return not SuperVillain.protected.SVBar.enable end
					},
					alpha = {
						order = 6,
						type = "range",
						name = L["Alpha"],
						isPercent = true,
						min = 0,
						max = 1,
						step = 0.01
					}, 
				}
			},
			customGroup = {
				name = L["Stateful Options"],
				type = "group",
				order = 6,
				guiInline = true,
				args = {
					style = {
						order = 13,
						type = "select",
						name = L["Style"],
						desc = L["This setting will be updated upon changing stances."],
						values = {
							["darkenInactive"] = L["Darken Inactive"],
							["classic"] = L["Classic"]
						}
					}
				}
			}
		}
	}
end;
SuperVillain.Options.args.SVBar={
	type="group",
	name=L["ActionBars"],
	childGroups="tab",
	get = function(key)
		return SuperVillain.db.SVBar[key[#key]]
	end,
	set = function(key,value)
		MOD:ChangeDBVar(value, key[#key]);
		MOD:RefreshButtons()
	end,
	args={
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			get = function(e)return SuperVillain.protected.SVBar[e[#e]]end,
			set = function(e,f)SuperVillain.protected.SVBar[e[#e]] = f;SuperVillain:StaticPopup_Show("RL_CLIENT")end
		},
		barGroup={
			order=2,
			type='group',
			name=L['Bar Options'],
			childGroups="tree",
			args={
				commonGroup={
					order=1,
					type='group',
					name=L['General Settings'],
					args={
						macrotext = {
							type = "toggle", 
							name = L["Macro Text"], 
							desc = L["Display macro names on action buttons."], 
							order = 2, 
							disabled = function()return not SuperVillain.protected.SVBar.enable end
						},
						hotkeytext = {
							type = "toggle", 
							name = L["Keybind Text"], 
							desc = L["Display bind names on action buttons."], 
							order = 3, 
							disabled = function()return not SuperVillain.protected.SVBar.enable end
						},
						keyDown = {
							type = "toggle", 
							name = L["Key Down"], 
							desc = OPTION_TOOLTIP_ACTION_BUTTON_USE_KEY_DOWN, 
							order = 4, 
							disabled = function()return not SuperVillain.protected.SVBar.enable end
						},
						showGrid = {
							type = "toggle", 
							name = ALWAYS_SHOW_MULTIBARS_TEXT, 
							desc = OPTION_TOOLTIP_ALWAYS_SHOW_MULTIBARS, 
							order = 5, 
							disabled = function()return not SuperVillain.protected.SVBar.enable end
						},
						unlock = {
							type = "select", 
							width = "full", 
							name = PICKUP_ACTION_KEY_TEXT, 
							desc = L["The button you must hold down in order to drag an ability to another action button."], 
							disabled = function()return not SuperVillain.protected.SVBar.enable end, 
							order = 6, 
							values = {
								["SHIFT"] = SHIFT_KEY, 
								["ALT"] = ALT_KEY, 
								["CTRL"] = CTRL_KEY
							}
						},
						unc = {
							type = "color", 
							order = 7, 
							name = L["Out of Range"], 
							desc = L["Color of the actionbutton when out of range."],
							hasAlpha = true,
							get = function(key)
								local color = SuperVillain.db.SVBar[key[#key]]
								return color.r, color.g, color.b, color.a 
							end, 
							set = function(key, rValue, gValue, bValue, aValue)
								SuperVillain.db.SVBar[key[#key]] = {r = rValue, g = gValue, b = bValue, a = aValue}
								MOD:RefreshButtons()
							end, 
						},
						unpc = {
							type = "color", 
							order = 8, 
							name = L["Out of Power"], 
							desc = L["Color of the actionbutton when out of power (Mana, Rage, Focus, Holy Power)."],
							hasAlpha = true, 
							get = function(key)
								local color = SuperVillain.db.SVBar[key[#key]]
								return color.r, color.g, color.b, color.a 
							end, 
							set = function(key, rValue, gValue, bValue, aValue)
								SuperVillain.db.SVBar[key[#key]] = {r = rValue, g = gValue, b = bValue, a = aValue}
								MOD:RefreshButtons()
							end,
						},
						rightClickSelf = {
							type = "toggle", 
							name = L["Self Cast"], 
							desc = L["Right-click any action button to self cast"], 
							order = 9, 
							disabled = function()return not SuperVillain.protected.SVBar.enable end
						}
					}
				},
				fontGroup={
					order=2,
					type='group',
					disabled=function()return not SuperVillain.protected.SVBar.enable end,
					name=L['Fonts'],
					args = {
						font = {
							type = "select",
							width = "full",
							dialogControl = "LSM30_Font",
							order = 1,
							name = L["Font"],
							values = AceGUIWidgetLSMlists.font
						},
						fontSize = {
							order = 2,
							width = "full",
							name = L["Font Size"],
							type = "range",
							min = 6,
							max = 22,
							step = 1
						},
						fontOutline = {
							order = 3,
							width = "full",
							name = L["Font Outline"],
							desc = L["Set the font outline."],
							type = "select",
							values = {
								["NONE"] = L["None"],
								["OUTLINE"] = "OUTLINE",
								["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
								["THICKOUTLINE"] = "THICKOUTLINE"
							}
						},
						cooldownSize = {
							order = 4,
							width = "full",
							name = L["Cooldown Font Size"],
							type = "range",
							min = 6,
							max = 22,
							step = 1
						},
					}
				}
			}
		}
	}
}
bar_configs = SuperVillain.Options.args.SVBar.args.barGroup.args
BarConfigLoader();
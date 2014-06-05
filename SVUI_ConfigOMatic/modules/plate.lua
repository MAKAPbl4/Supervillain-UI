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
local MOD = SuperVillain:GetModule('SVPlate');
--[[ 
########################################################## 
SET PACKAGE OPTIONS
##########################################################
]]--
local positionTable = {
	TOPLEFT = "TOPLEFT", 
	LEFT = "LEFT", 
	BOTTOMLEFT = "BOTTOMLEFT", 
	RIGHT = "RIGHT", 
	TOPRIGHT = "TOPRIGHT", 
	BOTTOMRIGHT = "BOTTOMRIGHT", 
	CENTER = "CENTER", 
	TOP = "TOP", 
	BOTTOM = "BOTTOM",
	RIGHTTOP = "RIGHTTOP",
    LEFTTOP = "LEFTTOP",
    RIGHTBOTTOM = "RIGHTBOTTOM",
    LEFTBOTTOM = "LEFTBOTTOM"
};

local activeFilter,filters;

local function UpdateFilterGroupOptions()
	if not activeFilter or not SuperVillain.global['SVPlate']['filter'][activeFilter] then 
		SuperVillain.Options.args.SVPlate.args.filters.args.filterGroup=nil;
		return 
	end;
	SuperVillain.Options.args.SVPlate.args.filters.args.filterGroup = {
		type = "group",
		name = activeFilter,
		guiInline = true,
		order = -10,
		get = function(d)return SuperVillain.global["SVPlate"]["filter"][activeFilter][d[#d]] end,
		set = function(d,e)
			SuperVillain.global["SVPlate"]["filter"][activeFilter][d[#d]] = e;
			MOD:PlateIteration("AssertFiltering")
			MOD:UpdateAllPlates()
			UpdateFilterGroupOptions()
		end,
		args = {
			enable = {
				type = "toggle",
				order = 1,
				name = L["Enable"],
				desc = L["Use this filter."]
			},
			hide = {
				type = "toggle",
				order = 2,
				name = L["Hide"],
				desc = L["Prevent any nameplate with this unit name from showing."]
			},
			customColor = {
				type = "toggle",
				order = 3,
				name = L["Custom Color"],
				desc = L["Disable threat coloring for this plate and use the custom color."]
			},
			color = {
				type = "color",
				order = 4,
				name = L["Color"],
				get = function(d)local f = SuperVillain.global["SVPlate"]["filter"][activeFilter][d[#d]]if f then return f.r,f.g,f.b,f.a end end,
				set = function(d,g,h,i)
					SuperVillain.global["SVPlate"]["filter"][activeFilter][d[#d]] = {}
					local f = SuperVillain.global["SVPlate"]["filter"][activeFilter][d[#d]]
					if f then 
						f.r,f.g,f.b = g,h,i;
						UpdateFilterGroupOptions()
						MOD:PlateIteration("CheckFilterAndHealers")
						MOD:UpdateAllPlates()
					end 
				end
			},
			customScale = {
				type = "range",
				name = L["Custom Scale"],
				desc = L["Set the scale of the nameplate."],
				min = 0.67,
				max = 2,
				step = 0.01
			}
		}
	}
end;

SuperVillain.Options.args.SVPlate={
	type="group",
	name=L["NamePlates"],
	childGroups="tab",
	args={
		commonGroup={
			order=1,
			type='group',
			name=L['NamePlate Options'],
			childGroups="tree",
			args={
				intro={order=1,type="description",name=L["NAMEPLATE_DESC"]},
				enable={
					order=2,type="toggle",name=L["Enable"],
					get=function(d)return SuperVillain.protected.SVPlate[d[#d]]end,
					set=function(d,e)SuperVillain.protected.SVPlate[d[#d]]=e;SuperVillain:StaticPopup_Show("RL_CLIENT")end,
				},
				common = {
					order = 1,
					type = "group",
					name = L["General"],
					get = function(d)return SuperVillain.db.SVPlate[d[#d]]end,
					set = function(d,e)MOD:ChangeDBVar(e,d[#d]);MOD:UpdateAllPlates() end,
					disabled = function()return not SuperVillain.protected.SVPlate.enable end,
					args = {
						combatHide = {
							type = "toggle",
							order = 1,
							name = L["Combat Toggle"],
							desc = L["Toggle the nameplates to be visible outside of combat and visible inside combat."],
							set = function(d,e)MOD:ChangeDBVar(e,d[#d])MOD:CombatToggle()end
						},
						comboPoints = {
							type = "toggle",
							order = 2,
							name = L["Combo Points"],
							desc = L["Display combo points on nameplates."]
						},
						colorNameByValue = {
							type = "toggle",
							order = 3,
							name = L["Color Name By Health Value"]
						},
						targetcount = {
							type = "toggle",
							order = 4,
							name = L["Target Count"],
							desc = L["Display the number of party / raid members targetting the nameplate unit."]
						},
						showthreat = {
							type = "toggle",
							order = 5,
							name = L["Threat Text"],
							desc = L["Display threat level as text on targeted,	boss or mouseover nameplate."]
						},
						nonTargetAlpha = {
							type = "range",
							order = 6,
							name = L["Non-Target Alpha"],
							desc = L["Alpha of nameplates that are not your current target."],
							min = 0,
							max = 1,
							step = 0.01,
							isPercent = true
						},
						fontGroup = {
							order = 100,
							type = "group",
							guiInline = true,
							name = L["Fonts"],
							args = {
								font = {
									type = "select",
									dialogControl = "LSM30_Font",
									order = 4,
									name = L["Font"],
									values = AceGUIWidgetLSMlists.font
								},
								fontSize = {
									order = 5,
									name = L["Font Size"],
									type = "range",
									min = 6,
									max = 22,
									step = 1
								},
								fontOutline = {
									order = 6,
									name = L["Font Outline"],
									desc = L["Set the font outline."],
									type = "select",
									values = {
										["NONE"] = L["None"],
										["OUTLINE"] = "OUTLINE",
										["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
										["THICKOUTLINE"] = "THICKOUTLINE"
									}
								}
							}
						},
						reactions = {
							order = 200,
							type = "group",
							name = L["Reaction Coloring"],
							guiInline = true,
							get = function(d)local f = SuperVillain.db.SVPlate.reactions[d[#d]]return f.r,f.g,f.b,f.a end,
							set = function(d,r2,g2,b2) local e = {r=r2,g=g2,b=b2,a=1} MOD:ChangeDBVar(e,d[#d],"reactions") MOD:UpdateAllPlates() end,
							args = {
								friendlyNPC = {
									type = "color",
									order = 1,
									name = L["Friendly NPC"],
									hasAlpha = false
								},
								friendlyPlayer = {
									name = L["Friendly Player"],
									order = 2,
									type = "color",
									hasAlpha = false
								},
								neutral = {
									name = L["Neutral"],
									order = 3,
									type = "color",
									hasAlpha = false
								},
								enemy = {
									name = L["Enemy"],
									order = 4,
									type = "color",
									hasAlpha = false
								},
								tapped = {
									name = L["Tagged NPC"],
									order = 5,
									type = "color",
									hasAlpha = false
								}
							}
						},
					}
				},
				healthBar = {
					type = "group",
					order = 2,
					name = L["Health Bar"],
					disabled = function()return not SuperVillain.protected.SVPlate.enable end,
					get = function(d)return SuperVillain.db.SVPlate.healthBar[d[#d]]end,
					set = function(d,e)MOD:ChangeDBVar(e,d[#d],"healthBar");MOD:UpdateAllPlates()end,
					args = {
						width = {
							type = "range",
							order = 1,
							name = L["Width"],
							desc = L["Controls the width of the nameplate"],
							type = "range",
							min = 50,
							max = 125,
							step = 1
						},
						height = {
							type = "range",
							order = 2,
							name = L["Height"],
							desc = L["Controls the height of the nameplate"],
							type = "range",
							min = 4,
							max = 30,
							step = 1
						},
						lowThreshold = {
							type = "range",
							order = 3,
							name = L["Low Health Threshold"],
							desc = L["Color the border of the nameplate yellow when it reaches this point,it will be colored red when it reaches half this value."],
							isPercent = true,
							min = 0,
							max = 1,
							step = 0.01
						},
						fontGroup = {
							order = 4,
							type = "group",
							name = L["Fonts"],
							guiInline = true,
							get = function(d)return SuperVillain.db.SVPlate.healthBar.text[d[#d]]end,
							set = function(d,e)MOD:ChangeDBVar(e,d[#d],"healthBar","text");MOD:UpdateAllPlates()end,
							args = {
								enable = {
									type = "toggle",
									name = L["Enable"],
									order = 1
								},
								attachTo = {
									type = "select",
									order = 2,
									name = L["Attach To"],
									values = {
										TOPLEFT = "TOPLEFT",
										LEFT = "LEFT",
										BOTTOMLEFT = "BOTTOMLEFT",
										RIGHT = "RIGHT",
										TOPRIGHT = "TOPRIGHT",
										BOTTOMRIGHT = "BOTTOMRIGHT",
										CENTER = "CENTER",
										TOP = "TOP",
										BOTTOM = "BOTTOM"
									}
								},
								format = {
									type = "select",
									order = 3,
									name = L["Format"],
									values = {
										["CURRENT_MAX_PERCENT"] = L["Current - Max | Percent"],
										["CURRENT_PERCENT"] = L["Current - Percent"],
										["CURRENT_MAX"] = L["Current - Max"],
										["CURRENT"] = L["Current"],
										["PERCENT"] = L["Percent"],
										["DEFICIT"] = L["Deficit"]
									}
								},
								xOffset = {
									type = "range",
									order = 4,
									name = L["X-Offset"],
									min = -150,
									max = 150,
									step = 1
								},
								yOffset = {
									type = "range",
									order = 5,
									name = L["Y-Offset"],
									min = -150,
									max = 150,
									step = 1
								}
							}
						}
					}
				},
				castBar = {
					type = "group",
					order = 3,
					name = L["Cast Bar"],
					disabled = function()return not SuperVillain.protected.SVPlate.enable end,
					get = function(d)return SuperVillain.db.SVPlate.castBar[d[#d]]end,
					set = function(d,e)MOD:ChangeDBVar(e,d[#d],"castBar");MOD:UpdateAllPlates()end,
					args = {
						height = {
							type = "range",
							order = 1,
							name = L["Height"],
							type = "range",
							min = 4,
							max = 30,
							step = 1
						},
						colors = {
							order = 100,
							type = "group",
							name = L["Colors"],
							guiInline = true,
							get = function(d)local f = SuperVillain.db.SVPlate.castBar[d[#d]]return f.r,f.g,f.b,f.a end,
							set = function(d,r2,g2,b2)
								local e = {r=r2,g=g2,b=b2,a=1}
								MOD:ChangeDBVar(e,d[#d],"castBar")
								MOD:UpdateAllPlates()
							end,
							args = {
								color = {
									type = "color",
									order = 1,
									name = L["Can Interrupt"],
									hasAlpha = false
								},
								noInterrupt = {
									name = "No Interrupt",
									order = 2,
									type = "color",
									hasAlpha = false
								}
							}
						}
					}
				},
				pointer = {
					type = "group",
					order = 4,
					name = L["Target Indicator"],
					get = function(d)return SuperVillain.db.SVPlate.pointer[d[#d]]end,
					set = function(d,e)MOD:ChangeDBVar(e,d[#d],"pointer");WorldFrame.elapsed = 3;MOD:UpdateAllPlates()end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"]
						},
						colorMatchHealthBar = {
							order = 2,
							type = "toggle",
							name = L["Color By Healthbar"],
							desc = L["Match the color of the healthbar."],
							set = function(d,e)
								MOD:ChangeDBVar(e,d[#d],"pointer","colorMatchHealthBar");
								if not e then 
									local color = SuperVillain.db.SVPlate.pointer.color;
									MOD:ColorTI(color.r,color.g,color.b)
								else 
									WorldFrame.elapsed = 3 
								end 
							end
						},
						color = {
							type = "color",
							name = L["Color"],
							order = 3,
							disabled = function()return SuperVillain.db.SVPlate.pointer.colorMatchHealthBar end,
							get = function(d)local f = SuperVillain.db.SVPlate.pointer[d[#d]]return f.r,f.g,f.b,f.a end,
							set = function(d,r2,g2,b2)
								local e = {r=r2,g=g2,b=b2,a=1}
								MOD:ChangeDBVar(e,d[#d],"pointer")
								MOD:UpdateAllPlates()
							end,
						}
					}
				},
				raidHealIcon = {
					type = "group",
					order = 5,
					name = L["Raid/Healer Icon"],
					get = function(d)return SuperVillain.db.SVPlate.raidHealIcon[d[#d]]end,
					set = function(d,e)MOD:ChangeDBVar(e,d[#d],"raidHealIcon")MOD:UpdateAllPlates()end,
					args = {
						attachTo = {
							type = "select",
							order = 1,
							name = L["Attach To"],
							values = positionTable
						},
						xOffset = {
							type = "range",
							order = 2,
							name = L["X-Offset"],
							min = -150,
							max = 150,
							step = 1
						},
						yOffset = {
							type = "range",
							order = 3,
							name = L["Y-Offset"],
							min = -150,
							max = 150,
							step = 1
						},
						size = {
							order = 4,
							type = "range",
							name = L["Size"],
							width = "full",
							min = 10,
							max = 200,
							step = 1
						},
					}
				},
				auras = {
					type = "group",
					order = 4,
					name = L["Auras"],
					get = function(d)return SuperVillain.db.SVPlate.auras[d[#d]]end,
					set = function(d,e)MOD:ChangeDBVar(e,d[#d],"auras")MOD:UpdateAllPlates()end,
					args = {
						numAuras = {
							type = "range",
							order = 1,
							name = L["Number of Auras"],
							min = 2,
							max = 8,
							step = 1
						},
						additionalFilter = {
							type = "select",
							order = 2,
							name = L["Additional Filter"],
							values = function()filters = {}filters[""] = NONE;for j in pairs(SuperVillain.global.Filters)do filters[j] = j end;return filters end
						},
						configureButton = {
							order = 4,
							name = L["Configure Selected Filter"],
							type = "execute",
							width = "full",
							func = function()SuperVillain:SetToFilterConfig(SuperVillain.db.SVPlate.auras.additionalFilter)end
						},
						fontGroup = {
							order = 100,
							type = "group",
							guiInline = true,
							name = L["Fonts"],
							args = {
								font = {
									type = "select",
									dialogControl = "LSM30_Font",
									order = 4,
									name = L["Font"],
									values = AceGUIWidgetLSMlists.font
								},
								fontSize = {
									order = 5,
									name = L["Font Size"],
									type = "range",
									min = 6,
									max = 22,
									step = 1
								},
								fontOutline = {
									order = 6,
									name = L["Font Outline"],
									desc = L["Set the font outline."],
									type = "select",
									values = {
										["NONE"] = L["None"],
										["OUTLINE"] = "OUTLINE",
										["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
										["THICKOUTLINE"] = "THICKOUTLINE"
									}
								}
							}
						}
					}
				},
				threat = {
					type = "group",
					order = 6,
					name = L["Threat"],
					get = function(d)return SuperVillain.db.SVPlate.threat[d[#d]]end,
					set = function(d,e)MOD:ChangeDBVar(e,d[#d],"threat")MOD:UpdateAllPlates()end,
					args = {
						enable = {
							type = "toggle",
							order = 1,
							name = L["Enable"]
						},
						scaling = {
							type = "group",
							name = L["Scaling"],
							guiInline = true,
							order = 2,
							args = {
								goodScale = {
									type = "range",
									name = L["Good"],
									order = 1,
									min = 0.5,
									max = 1.5,
									step = 0.01,
									isPercent = true
								},
								badScale = {
									type = "range",
									name = L["Bad"],
									order = 1,
									min = 0.5,
									max = 1.5,
									step = 0.01,
									isPercent = true
								}
							}
						},
						colors = {
							order = 3,
							type = "group",
							name = L["Colors"],
							guiInline = true,
							get = function(d)local f = SuperVillain.db.SVPlate.threat[d[#d]]return f.r,f.g,f.b,f.a end,
							set = function(d,r2,g2,b2)
								local e = {r=r2,g=g2,b=b2,a=1}
								MOD:ChangeDBVar(e,d[#d],"threat")
								MOD:UpdateAllPlates()
							end,
							args = {
								goodColor = {
									type = "color",
									order = 1,
									name = L["Good"],
									hasAlpha = false
								},
								badColor = {
									name = L["Bad"],
									order = 2,
									type = "color",
									hasAlpha = false
								},
								goodTransitionColor = {
									name = L["Good Transition"],
									order = 3,
									type = "color",
									hasAlpha = false
								},
								badTransitionColor = {
									name = L["Bad Transition"],
									order = 4,
									type = "color",
									hasAlpha = false
								}
							}
						}
					}
				},
				filters = {
					type = "group",
					order = 200,
					name = L["Filters"],
					disabled = function()return not SuperVillain.protected.SVPlate.enable end,
					args = {
						addname = {
							type = "input",
							order = 1,
							name = L["Add Name"],
							get = function(d)return""end,
							set = function(d,e)
								if SuperVillain.global["SVPlate"]["filter"][e]then 
									SuperVillain:AddonMessage(L["Filter already exists!"])
									return 
								end;
								SuperVillain.global["SVPlate"]["filter"][e] = {
									["enable"] = true,
									["hide"] = false,
									["customColor"] = false,
									["customScale"] = 1,
									["color"] = {
										g = 104/255,
										h = 138/255,
										i = 217/255
									}
								}
								UpdateFilterGroupOptions()
								MOD:UpdateAllPlates()
							end
						},
						deletename = {
							type = "input",
							order = 2,
							name = L["Remove Name"],
							get = function(d)return""end,
							set = function(d,e)
								if G["SVPlate"]["filter"][e]then 
									SuperVillain.global["SVPlate"]["filter"][e].enable = false;
									SuperVillain:AddonMessage(L["You can't remove a default name from the filter,disabling the name."])
								else 
									SuperVillain.global["SVPlate"]["filter"][e] = nil;
									SuperVillain.Options.args.SVPlate.args.filters.args.filterGroup = nil 
								end;
								UpdateFilterGroupOptions()
								MOD:UpdateAllPlates()
							end
						},
						selectFilter = {
							order = 3,
							type = "select",
							name = L["Select Filter"],
							get = function(d)return activeFilter end,
							set = function(d,e)activeFilter = e;UpdateFilterGroupOptions()end,
							values = function()
								filters = {}
								if(SuperVillain.global["SVPlate"]["filter"]) then
									for j in pairs(SuperVillain.global["SVPlate"]["filter"])do 
										filters[j] = j 
									end;
								end
								return filters 
							end
						}
					}
				}
			}
		}
	}
}
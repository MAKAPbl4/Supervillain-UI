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
local string     =  _G.string;
local find,gsub = string.find, string.gsub;
--[[ TABLE METHODS ]]--
local tsort = table.sort;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, G = unpack(SVUI);
local MOD = SuperVillain:GetModule('SVUnit');
local _, ns = ...;
local oUF_SuperVillain = ns.oUF;
local ACD = LibStub("AceConfigDialog-3.0");
--[[ 
########################################################## 
LOCAL VARS/FUNCTIONS
##########################################################
]]--
local filterList = {};
local positionTable = SuperVillain:GetPointTable();
local textStringFormats = {
	["health"] = {
		[""] = "None",
		["[health:current]"] = "Current",
		["[health:deficit]"] = "Deficit",
		["[health:percent]"] = "Percent",
		["[health:current-percent]"] = "Current - Percent",
		["[health:current-max]"] = "Current - Maximum",
		["[health:current-max-percent]"] = "Current - Maximum - Percent",
	},
	["power"] = {
		[""] = "None",
		["[power:current]"] = "Current",
		["[power:deficit]"] = "Deficit",
		["[power:percent]"] = "Percent",
		["[power:current-percent]"] = "Current - Percent",
		["[power:current-max]"] = "Current - Maximum",
		["[power:current-max-percent]"] = "Current - Maximum - Percent",
	},
	["classpower"] = {
		[""] = "None",
		["[classpower:current]"] = "Current",
		["[classpower:deficit]"] = "Deficit",
		["[classpower:percent]"] = "Percent",
		["[classpower:current-percent]"] = "Current - Percent",
		["[classpower:current-max]"] = "Current - Maximum",
		["[classpower:current-max-percent]"] = "Current - Maximum - Percent",
	},
	["altpower"] = {
		[""] = "None",
		["[altpower:current]"] = "Current",
		["[altpower:deficit]"] = "Deficit",
		["[altpower:percent]"] = "Percent",
		["[altpower:current-percent]"] = "Current - Percent",
		["[altpower:current-max]"] = "Current - Maximum",
		["[altpower:current-max-percent]"] = "Current - Maximum - Percent",
	},
};

--[[
[""] = "[threatcolor]",
[""] = "[threat:percent]",
[""] = "[threat:current]",
[""] = "[afk]",
[""] = "[difficultycolor]",
[""] = "[smartlevel]",
[""] = "[absorbs]",
[""] = "[incomingheals:personal]",
[""] = "[incomingheals:others]",
[""] = "[incomingheals]",
]]--
--[[ 
########################################################## 
SET PACKAGE OPTIONS
##########################################################
]]--
function MOD:SetCastbarConfigGroup(u, i, j, s)
	local k = {
		order = 800, 
		type = "group", 
		name = L["Castbar"], 
		get = function(l)return SuperVillain.db.SVUnit[j]["castbar"][l[#l]]end, 
		set = function(l, m)SuperVillain.db.SVUnit[j]["castbar"][l[#l]] = m;i(MOD, j, s)end, 
		args = {
			enable = {type = "toggle", order = 1, name = L["Enable"]}, 
			matchsize = {order = 2, type = "execute", name = L["Match Frame Width"], func = function()SuperVillain.db.SVUnit[j]["castbar"]["width"] = SuperVillain.db.SVUnit[j]["width"]i(MOD, j, s)end}, 
			forceshow = {
				order = 3, 
				name = SHOW.." / "..HIDE, 
				func = function()
					local v = GetUnitFrameActualName(j)
					v = "SVUI_"..v;
					v = v:gsub("t(arget)", "T%1")
					if s then 
						for w = 1, s do 
							local castbar = _G[v..w].Castbar;
							if not castbar.oldHide then 
								castbar.oldHide = castbar.Hide;
								castbar.Hide = castbar.Show;
								castbar:Show()
							else 
								castbar.Hide = castbar.oldHide;
								castbar.oldHide = nil;
								castbar:Hide()
								castbar.lastUpdate = 0 
							end 
						end 
					else 
						local castbar = _G[v].Castbar;
						if not castbar.oldHide then 
							castbar.oldHide = castbar.Hide;
							castbar.Hide = castbar.Show;
							castbar:Show()
						else 
							castbar.Hide = castbar.oldHide;
							castbar.oldHide = nil;
							castbar:Hide()
							castbar.lastUpdate = 0 
						end 
					end 
				end, 
				type = "execute"
			}, 
			configureButton = {order = 4, name = L["Coloring"], type = "execute", func = function()ACD:SelectGroup("SVUI", "SVUnit", "common", "allColorsGroup", "castBars")end}, 
			width = {order = 5, name = L["Width"], type = "range", min = 50, max = 600, step = 1}, 
			height = {order = 6, name = L["Height"], type = "range", min = 10, max = 85, step = 1}, 
			icon = {order = 7, name = L["Icon"], type = "toggle"}, 
			latency = {order = 9, name = L["Latency"], type = "toggle"}, 
			format = {order = 12, type = "select", name = L["Format"], values = {["CURRENTMAX"] = L["Current / Max"], ["CURRENT"] = L["Current"], ["REMAINING"] = L["Remaining"]}}, 
			spark = {order = 14, type = "toggle", name = L["Spark"]}
		}
	}
	if u then 
		k.args.ticks = {order = 13, type = "toggle", name = L["Ticks"], desc = L["Display tick marks on the castbar."]}
		k.args.displayTarget = {order = 14, type = "toggle", name = L["Display Target"], desc = L["Display the target of your current cast."]}
	end;
	return k 
end;

function MOD:SetAuraConfigGroup(p, q, r, i, j, s)
	local k = {
		order = q == "buffs" and 600 or 700, 
		type = "group", 
		name = q == "buffs" and L["Buffs"] or L["Debuffs"], 
		get = function(l)return SuperVillain.db.SVUnit[j][q][l[#l]]end, 
		set = function(l, m)
			SuperVillain.db.SVUnit[j][q][l[#l]] = m;
			i(MOD,j,s)
		end, 
		args = {
			enable = {type = "toggle", order = 1, name = L["Enable"]}, 
			perrow = {type = "range", order = 2, name = L["Per Row"], min = 1, max = 20, step = 1}, 
			numrows = {type = "range", order = 3, name = L["Num Rows"], min = 1, max = 4, step = 1}, 
			sizeOverride = {type = "range", order = 3, name = L["Size Override"], desc = L["If not set to 0 then override the size of the aura icon to this."], min = 0, max = 60, step = 1}, 
			xOffset = {order = 4, type = "range", name = L["xOffset"], min = -60, max = 60, step = 1}, 
			yOffset = {order = 5, type = "range", name = L["yOffset"], min = -60, max = 60, step = 1}, 
			anchorPoint = {type = "select", order = 8, name = L["Anchor Point"], desc = L["What point to anchor to the frame you set to attach to."], values = positionTable},
			verticalGrowth = {type = "select", order = 9, name = L["Vertical Growth"], desc = L["The vertical direction that the auras will position themselves"], values = {UP = "UP", DOWN = "DOWN"}},
			horizontalGrowth = {type = "select", order = 10, name = L["Horizontal Growth"], desc = L["The horizontal direction that the auras will position themselves"], values = {LEFT = "LEFT", RIGHT = "RIGHT"}},
			filters = {name = L["Filters"], guiInline = true, type = "group", order = 500, args = {}}
		}
	}
	if q == "buffs"then 
		k.args.attachTo = {type = "select", order = 7, name = L["Attach To"], desc = L["What to attach the buff anchor frame to."], values = {["FRAME"] = L["Frame"], ["DEBUFFS"] = L["Debuffs"]}}
	else 
		k.args.attachTo = {type = "select", order = 7, name = L["Attach To"], desc = L["What to attach the buff anchor frame to."], values = {["FRAME"] = L["Frame"], ["BUFFS"] = L["Buffs"]}}
	end;
	if p then 
		k.args.filters.args.filterPlayer = {order = 10, type = "toggle", name = L["Only Show Your Auras"], desc = L["Don't display auras that are not yours."]}
		k.args.filters.args.filterBlocked = {order = 11, type = "toggle", name = L["Force Blocked List"], desc = L["Don't display any auras found on the Blocked filter."]}
		k.args.filters.args.filterAllowed = {order = 12, type = "toggle", name = L["Force Allowed List"], desc = L["If no other filter options are being used then it will block anything not on the Allowed filter."]}
		k.args.filters.args.filterInfinite = {order = 13, type = "toggle", name = L["Block Auras Without Duration"], desc = L["Don't display auras that have no duration."]}
		k.args.filters.args.filterDispellable = {order = 13, type = "toggle", name = L["Block Non-Dispellable Auras"], desc = L["Don't display auras that cannot be purged or dispelled by your class."]}
		if q == "buffs"then 
			k.args.filters.args.filterRaid = {order = 14, type = "toggle", name = L["Block Raid Buffs"], desc = L["Don't display raid buffs."]}
		end;
		k.args.filters.args.useFilter = {
			order = 15, 
			name = L["Additional Filter"], 
			desc = L["Select an additional filter to use."], 
			type = "select", 
			values = function()
				filterList = {}
				filterList[""] = NONE;
				for n in pairs(SuperVillain.global.Filters)do 
					filterList[n] = n 
				end;
				return filterList 
			end
		}
	
	else 
		k.args.filters.args.filterPlayer = {
			order = 10,
			guiInline = true,
			type = "group",
			name = L["Only Show Your Auras"],
			args = {
				friendly = {
					order = 2,
					type = "toggle",
					name = L["Friendly"],
					desc = L["If the unit is friendly to you."].." "..L["Don't display auras that are not yours."],
					get = function(l)return SuperVillain.db.SVUnit[j][q].filterPlayer.friendly end,
					set = function(l, m)
					SuperVillain.db.SVUnit[j][q].filterPlayer.friendly = m;
						i(MOD,j,s)
					end
				},
				enemy = {
					order = 3,
					type = "toggle",
					name = L["Enemy"],
					desc = L["If the unit is an enemy to you."].." "..L["Don't display auras that are not yours."],
					get = function(l)return SuperVillain.db.SVUnit[j][q].filterPlayer.enemy end,
					set = function(l, m)
						SuperVillain.db.SVUnit[j][q].filterPlayer.enemy = m;
						i(MOD,j,s)
					end
				}
			}
		}
		k.args.filters.args.filterBlocked = {
			order = 11, 
			guiInline = true, 
			type = "group", 
			name = L["Force Blocked List"], 
			args = {
				friendly = {
					order = 2, 
					type = "toggle", 
					name = L["Friendly"], 
					desc = L["If the unit is friendly to you."].." "..L["Don't display any auras found on the Blocked filter."], 
					get = function(l)return SuperVillain.db.SVUnit[j][q].filterBlocked.friendly end, 
					set = function(l, m)SuperVillain.db.SVUnit[j][q].filterBlocked.friendly = m;i(MOD, j, s)end
				}, 
				enemy = {
					order = 3, 
					type = "toggle", 
					name = L["Enemy"], 
					desc = L["If the unit is an enemy to you."].." "..L["Don't display any auras found on the Blocked filter."], 
					get = function(l)return SuperVillain.db.SVUnit[j][q].filterBlocked.enemy end, 
					set = function(l, m)SuperVillain.db.SVUnit[j][q].filterBlocked.enemy = m;i(MOD, j, s)end
				}
			}
		}
		k.args.filters.args.filterAllowed = {
			order = 12, 
			guiInline = true, 
			type = "group", 
			name = L["Force Allowed List"], 
			args = {
				friendly = {
					order = 2, 
					type = "toggle", 
					name = L["Friendly"], 
					desc = L["If the unit is friendly to you."].." "..L["If no other filter options are being used then it will block anything not on the Allowed filter."], 
					get = function(l)return SuperVillain.db.SVUnit[j][q].filterAllowed.friendly end, 
					set = function(l, m)SuperVillain.db.SVUnit[j][q].filterAllowed.friendly = m;i(MOD, j, s)end
				}, 
				enemy = {
					order = 3, 
					type = "toggle", 
					name = L["Enemy"], 
					desc = L["If the unit is an enemy to you."].." "..L["If no other filter options are being used then it will block anything not on the Allowed filter."], 
					get = function(l)return SuperVillain.db.SVUnit[j][q].filterAllowed.enemy end, 
					set = function(l, m)SuperVillain.db.SVUnit[j][q].filterAllowed.enemy = m;i(MOD, j, s)end
				}
			}
		}
		k.args.filters.args.filterInfinite = {
			order = 13, 
			guiInline = true, 
			type = "group", 
			name = L["Block Auras Without Duration"], 
			args = {
				friendly = {
					order = 2, 
					type = "toggle", 
					name = L["Friendly"], 
					desc = L["If the unit is friendly to you."].." "..L["Don't display auras that have no duration."], 
					get = function(l)return SuperVillain.db.SVUnit[j][q].filterInfinite.friendly end, 
					set = function(l, m)SuperVillain.db.SVUnit[j][q].filterInfinite.friendly = m;i(MOD, j, s)end
				}, 
				enemy = {
					order = 3, 
					type = "toggle", 
					name = L["Enemy"], 
					desc = L["If the unit is an enemy to you."].." "..L["Don't display auras that have no duration."], 
					get = function(l)return SuperVillain.db.SVUnit[j][q].filterInfinite.enemy end, 
					set = function(l, m)SuperVillain.db.SVUnit[j][q].filterInfinite.enemy = m;i(MOD, j, s)end
				}
			}
		}
		k.args.filters.args.filterDispellable = {
			order = 13, 
			guiInline = true, 
			type = "group",
			name = L["Block Non-Dispellable Auras"], 
			args = {
				friendly = {
					order = 2, 
					type = "toggle", 
					name = L["Friendly"], 
					desc = L["If the unit is friendly to you."].." "..L["Don't display auras that cannot be purged or dispelled by your class."], 
					get = function(l)return SuperVillain.db.SVUnit[j][q].filterDispellable.friendly end, 
					set = function(l, m)SuperVillain.db.SVUnit[j][q].filterDispellable.friendly = m;i(MOD, j, s)end
					}, 
				enemy = {
					order = 3, 
					type = "toggle", 
					name = L["Enemy"], 
					desc = L["If the unit is an enemy to you."].." "..L["Don't display auras that cannot be purged or dispelled by your class."], 
					get = function(l)return SuperVillain.db.SVUnit[j][q].filterDispellable.enemy end, 
					set = function(l, m)SuperVillain.db.SVUnit[j][q].filterDispellable.enemy = m;i(MOD, j, s)end
				}
			}
		}
		if q == "buffs"then 
			k.args.filters.args.filterRaid = {
				order = 14, 
				guiInline = true, 
				type = "group", 
				name = L["Block Raid Buffs"], 
				args = {
					friendly = {
						order = 2, 
						type = "toggle", 
						name = L["Friendly"], 
						desc = L["If the unit is friendly to you."].." "..L["Don't display raid (consolidated) buffs."], 
						get = function(l)return SuperVillain.db.SVUnit[j][q].filterRaid.friendly end, 
						set = function(l, m)SuperVillain.db.SVUnit[j][q].filterRaid.friendly = m;i(MOD, j, s)end
					}, 
					enemy = {
						order = 3, 
						type = "toggle", 
						name = L["Enemy"], desc = L["If the unit is an enemy to you."].." "..L["Don't display raid (consolidated) buffs."], 
						get = function(l)return SuperVillain.db.SVUnit[j][q].filterRaid.enemy end, 
						set = function(l, m)SuperVillain.db.SVUnit[j][q].filterRaid.enemy = m;i(MOD, j, s)end
					}
				}
			}
		end;
		k.args.filters.args.useFilter = {
			order = 15, 
			name = L["Additional Filter"], 
			desc = L["Select an additional filter to use."], 
			type = "select", 
			values = function()
				filterList = {}
				filterList[""] = NONE;
				for n in pairs(SuperVillain.global.Filters)do 
					filterList[n] = n 
				end;
				return filterList 
			end
		}
	end;
	return k 
end;

function MOD:SetHealthConfigGroup(partyRaid, updateFunction, unitName, arg)
	local healthOptions = {
		order = 100, 
		type = "group", 
		name = L["Health"], 
		get = function(key) 
			return SuperVillain.db.SVUnit[unitName]["health"][key[#key]] 
		end, 
		set = function(key, value)
			MOD:ChangeDBVar(value, key[#key], unitName, "health");
			updateFunction(MOD, unitName, arg)
		end,
		args = {
			commonGroup = {
				order = 2, 
				type = "group", 
				guiInline = true, 
				name = L["Base Settings"],
				args = {
					reversed = {type = "toggle", order = 1, name = L["Reverse Fill"], desc = L["Invert this bars fill direction"]}, 
					position = {type = "select", order = 2, name = L["Text Position"], desc = L["Set the anchor for this bars value text"], values = positionTable}, 
					configureButton = {
						order = 4, 
						width = "full", 
						name = L["Coloring"], 
						type = "execute", 
						func = function()ACD:SelectGroup("SVUI", "SVUnit", "common", "allColorsGroup", "healthGroup")end
					}, 
					xOffset = {order = 5, type = "range", width = "full", name = L["Text xOffset"], desc = L["Offset position for text."], min = -300, max = 300, step = 1}, 
					yOffset = {order = 6, type = "range", width = "full", name = L["Text yOffset"], desc = L["Offset position for text."], min = -300, max = 300, step = 1}, 
				}
			}, 
			formatGroup = {
				order = 100, 
				type = "group", 
				guiInline = true, 
				name = L["Text Settings"],
				set = function(key, value)
					MOD:ChangeDBVar(value, key[#key], unitName, "health");
					local pre = SuperVillain.db.SVUnit[unitName]["health"].text_colored and "[healthcolor]" or "";
					local tag = SuperVillain.db.SVUnit[unitName]["health"].text_type;
					value = pre..tag;
					MOD:ChangeDBVar(value, "text_format", unitName, "health");
					updateFunction(MOD, unitName, arg)
				end,
				args = {
					text_colored = {
						order = 1, 
						name = L["Colored"], 
						type = "toggle", 
						desc = L["Use various name coloring methods"]
					},
					text_type = {
						order = 2, 
						name = L["Text Format"], 
						type = "select", 
						desc = L["TEXT_FORMAT_DESC"], 
						values = textStringFormats["health"] 
					}
				}
			}
		}
	}
	if partyRaid then 
		healthOptions.args.frequentUpdates = {
			type = "toggle", 
			order = 1, 
			name = L["Frequent Updates"], 
			desc = L["Rapidly update the health, uses more memory and cpu. Only recommended for healing."]
		}
		healthOptions.args.orientation = {
			type = "select", 
			order = 2, 
			name = L["Orientation"], 
			desc = L["Direction the health bar moves when gaining/losing health."], 
			values = {["HORIZONTAL"] = L["Horizontal"], ["VERTICAL"] = L["Vertical"]}
		}
	end;
	return healthOptions 
end;

function MOD:SetPowerConfigGroup(playerTarget, updateFunction, unitName, args)
	local powerOptions = {
		order = 200, 
		type = "group", 
		name = L["Power"],
		get = function(key) 
			return SuperVillain.db.SVUnit[unitName]["power"][key[#key]] 
		end, 
		set = function(key, value)
			MOD:ChangeDBVar(value, key[#key], unitName, "power");
			updateFunction(MOD, unitName, args)
		end,
		args = {
			enable = {type = "toggle", order = 1, name = L["Enable"]}, 
			commonGroup = {
				order = 2, 
				type = "group", 
				guiInline = true, 
				name = L["Base Settings"],
				args = {
					position = {type = "select", order = 3, name = L["Text Position"], desc = L["Set the anchor for this bars value text"], values = positionTable}, 
					configureButton = {
						order = 4, 
						name = L["Coloring"], 
						width = "full", 
						type = "execute", 
						func = function()ACD:SelectGroup("SVUI", "SVUnit", "common", "allColorsGroup", "powerGroup")end
					}, 
					height = {
						type = "range", 
						name = L["Height"], 
						order = 5, 
						width = "full", 
						min = 3, 
						max = 50, 
						step = 1
					}, 
					xOffset = {order = 6, type = "range", width = "full", name = L["Text xOffset"], desc = L["Offset position for text."], min = -300, max = 300, step = 1}, 
					yOffset = {order = 7, type = "range", width = "full", name = L["Text yOffset"], desc = L["Offset position for text."], min = -300, max = 300, step = 1}, 
				}
			}, 
			formatGroup = {
				order = 100, 
				type = "group", 
				guiInline = true, 
				name = L["Text Settings"],
				set = function(key, value)
					MOD:ChangeDBVar(value, key[#key], unitName, "power");
					local pre = SuperVillain.db.SVUnit[unitName]["power"].text_colored and "[powercolor]" or "";
					local tag = SuperVillain.db.SVUnit[unitName]["power"].text_type;
					value = pre..tag;
					MOD:ChangeDBVar(value, "text_format", unitName, "power");
					updateFunction(MOD, unitName, arg)
				end,
				args = {
					text_colored = {
						order = 1, 
						name = L["Colored"], 
						type = "toggle", 
						desc = L["Use various name coloring methods"]
					},
					text_type = {
						order = 2, 
						name = L["Text Format"], 
						type = "select", 
						desc = L["TEXT_FORMAT_DESC"], 
						values = textStringFormats["power"], 
					}
				}
			}
		}
	}

	if(playerTarget) then 
		powerOptions.args.attachTextToPower = {
			type = "toggle", 
			order = 2, 
			name = L["Attach Text to Power"]
		}
	end

	if(unitName == "player" and SuperVillain.class == "DRUID") then 
		powerOptions.args.druidMana = {
			type = "toggle", 
			order = 12, 
			name = L["Druid Mana"], 
			desc = L["Display druid mana bar when in cat or bear form and when mana is not 100%."]
		}
	end

	return powerOptions 
end;

function MOD:SetNameConfigGroup(updateFunction, unitName, args)
	local k = {
		order = 400, 
		type = "group", 
		name = L["Name"],
		get = function(key) 
			return SuperVillain.db.SVUnit[unitName]["name"][key[#key]] 
		end, 
		set = function(key, value)
			MOD:ChangeDBVar(value, key[#key], unitName, "name");
			updateFunction(MOD, unitName, args)
		end,
		args = {
			commonGroup = {
				order = 2, 
				type = "group", 
				guiInline = true, 
				name = L["Base Settings"], 
				args = {
					position = {
						type = "select", 
						order = 3, 
						name = L["Text Position"], 
						desc = L["Set the anchor for this units name text"], 
						values = positionTable
					}, 
					xOffset = {
						order = 6, 
						type = "range", 
						width = "full", 
						name = L["Text xOffset"], 
						desc = L["Offset position for text."], 
						min = -300, 
						max = 300, 
						step = 1
					}, 
					yOffset = {
						order = 7, 
						type = "range", 
						width = "full", 
						name = L["Text yOffset"], 
						desc = L["Offset position for text."], 
						min = -300, 
						max = 300, 
						step = 1
					}, 
				}
			}, 
			fontGroup = {
				order = 4, 
				type = "group", 
				guiInline = true, 
				name = L["Fonts"],
				set = function(key, value)
					MOD:ChangeDBVar(value, key[#key], unitName, "name");
					MOD:UpdateUnitFont(unitName)
				end,
				args = {
					font = {
						type = "select", 
						dialogControl = "LSM30_Font", 
						order = 0, 
						name = L["Default Font"], 
						desc = L["The font used to show unit names."], 
						values = AceGUIWidgetLSMlists.font
					}, 
					fontOutline = {
						order = 1, 
						name = L["Font Outline"], 
						desc = L["Set the font outline."], 
						type = "select", 
						values = {["NONE"] = L["None"], ["OUTLINE"] = "OUTLINE", ["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE", ["THICKOUTLINE"] = "THICKOUTLINE"}
					}, 
					fontSize = {
						order = 2, 
						name = L["Font Size"], 
						desc = L["Set the font size."], 
						type = "range", 
						width = "full", 
						min = 6, 
						max = 22, 
						step = 1
					}
				}
			}, 
			formatGroup = {
				order = 100, 
				type = "group", 
				guiInline = true, 
				name = L["Text Settings"],
				set = function(key, value)
					MOD:ChangeDBVar(value, key[#key], unitName, "name");
					local pre = SuperVillain.db.SVUnit[unitName]["name"].text_colored and "[namecolor]" or "";
					local post = SuperVillain.db.SVUnit[unitName]["name"].text_smartlevel and " [difficultycolor][smartlevel] [shortclassification]" or "";
					local length = SuperVillain.db.SVUnit[unitName]["name"].text_length;
					local tag = "[name:" .. length .. "]";
					value = pre..tag..post;
					MOD:ChangeDBVar(value, "text_format", unitName, "name");
					updateFunction(MOD, unitName, args)
				end,
				args = {
					text_colored = {
						order = 1, 
						name = L["Colored"], 
						type = "toggle", 
						desc = L["Use various name coloring methods"]
					}, 
					text_smartlevel = {
						order = 2, 
						name = L["Unit Level"], 
						type = "toggle", 
						desc = L["Display the units level"]
					}, 
					text_length = {
						order = 3, 
						name = L["Name Length"],
						desc = L["TEXT_FORMAT_DESC"], 
						type = "range", 
						width = "full", 
						min = 1, 
						max = 30, 
						step = 1
					}
				}
			}
		}
	}
	return k 
end;

local function getAvailablePortraitConfig(unit)
	local db = SuperVillain.db.SVUnit[unit].portrait;
	if db.overlay then
		return {["3D"] = L["3D"]}
	else
		return {["2D"] = L["2D"], ["3D"] = L["3D"]}
	end
end

function MOD:SetPortraitConfigGroup(i, j, s)
	local k = {
		order = 400, 
		type = "group", 
		name = L["Portrait"], 
		get = function(l)return SuperVillain.db.SVUnit[j]["portrait"][l[#l]]end, 
		set = function(l, m)SuperVillain.db.SVUnit[j]["portrait"][l[#l]] = m;i(MOD, j, s)end, 
		args = {
			enable = {
				type = "toggle", 
				order = 1, 
				name = L["Enable"]
			}, 
			width = {type = "range", order = 2, name = L["Width"], min = 15, max = 150, step = 1}, 
			overlay = {type = "toggle", name = L["Overlay"], desc = L["Overlay the healthbar"], order = 3, disabled = function() return SuperVillain.db.SVUnit[j]["portrait"].style == "2D" end}, 
			rotation = {type = "range", name = L["Model Rotation"], order = 4, min = 0, max = 360, step = 1}, 
			camDistanceScale = {type = "range", name = L["Camera Distance Scale"], desc = L["How far away the portrait is from the camera."], order = 5, min = 0.01, max = 4, step = 0.01}, 
			style = {type = "select", name = L["Style"], desc = L["Select the display method of the portrait. NOTE: if overlay is set then only 3D will be available"], order = 6, values = function() return getAvailablePortraitConfig(j) end}
		}
	}
	return k 
end;

function MOD:SetIconConfigGroup(i, j, s)
	local iconGroup = SuperVillain.db.SVUnit[j]["icons"]
	local grouporder = 1
	local k = {
		order = 5000, 
		type = "group", 
		name = L["Icons"], 
		args = {}
	};

	if(iconGroup["raidicon"]) then
		k.args.raidicon = {
			order = grouporder, 
			type = "group",
			guiInline = true,
			name = L["Raid Marker"], 
			get = function(l)return SuperVillain.db.SVUnit[j]["icons"]["raidicon"][l[#l]]end, 
			set = function(l, m)SuperVillain.db.SVUnit[j]["icons"]["raidicon"][l[#l]] = m;i(MOD, j, s)end, 
			args = {
				enable = {type = "toggle", order = 1, name = L["Enable"]}, 
				attachTo = {type = "select", order = 2, name = L["Position"], values = positionTable}, 
				size = {type = "range", name = L["Size"], order = 3, min = 8, max = 60, step = 1}, 
				xOffset = {order = 4, type = "range", name = L["xOffset"], min = -300, max = 300, step = 1}, 
				yOffset = {order = 5, type = "range", name = L["yOffset"], min = -300, max = 300, step = 1}
			}
		}
		grouporder = grouporder + 1
	end

	if(iconGroup["combatIcon"]) then
		k.args.combatIcon = {
			order = grouporder, 
			type = "group",
			guiInline = true,
			name = L["Combat"], 
			get = function(l)return SuperVillain.db.SVUnit[j]["icons"]["combatIcon"][l[#l]]end, 
			set = function(l, m)SuperVillain.db.SVUnit[j]["icons"]["combatIcon"][l[#l]] = m;i(MOD, j, s)end, 
			args = {
				enable = {type = "toggle", order = 1, name = L["Enable"]}, 
				attachTo = {type = "select", order = 2, name = L["Position"], values = positionTable}, 
				size = {type = "range", name = L["Size"], order = 3, min = 8, max = 60, step = 1}, 
				xOffset = {order = 4, type = "range", name = L["xOffset"], min = -300, max = 300, step = 1}, 
				yOffset = {order = 5, type = "range", name = L["yOffset"], min = -300, max = 300, step = 1}
			}
		}
		grouporder = grouporder + 1
	end

	if(iconGroup["restIcon"]) then
		k.args.restIcon = {
			order = grouporder, 
			type = "group",
			guiInline = true,
			name = L["Resting"], 
			get = function(l)return SuperVillain.db.SVUnit[j]["icons"]["restIcon"][l[#l]]end, 
			set = function(l, m)SuperVillain.db.SVUnit[j]["icons"]["restIcon"][l[#l]] = m;i(MOD, j, s)end, 
			args = {
				enable = {type = "toggle", order = 1, name = L["Enable"]}, 
				attachTo = {type = "select", order = 2, name = L["Position"], values = positionTable}, 
				size = {type = "range", name = L["Size"], order = 3, min = 8, max = 60, step = 1}, 
				xOffset = {order = 4, type = "range", name = L["xOffset"], min = -300, max = 300, step = 1}, 
				yOffset = {order = 5, type = "range", name = L["yOffset"], min = -300, max = 300, step = 1}
			}
		}
		grouporder = grouporder + 1
	end

	if(iconGroup["classicon"]) then
		k.args.classicon = {
			order = grouporder, 
			type = "group",
			guiInline = true,
			name = L["Class"], 
			get = function(l)return SuperVillain.db.SVUnit[j]["icons"]["classicon"][l[#l]]end, 
			set = function(l, m)SuperVillain.db.SVUnit[j]["icons"]["classicon"][l[#l]] = m;i(MOD, j, s)end, 
			args = {
				enable = {type = "toggle", order = 1, name = L["Enable"]}, 
				attachTo = {type = "select", order = 2, name = L["Position"], values = positionTable}, 
				size = {type = "range", name = L["Size"], order = 3, min = 8, max = 60, step = 1}, 
				xOffset = {order = 4, type = "range", name = L["xOffset"], min = -300, max = 300, step = 1}, 
				yOffset = {order = 5, type = "range", name = L["yOffset"], min = -300, max = 300, step = 1}
			}
		}
		grouporder = grouporder + 1
	end

	if(iconGroup["eliteicon"]) then
		k.args.eliteicon = {
			order = grouporder, 
			type = "group",
			guiInline = true,
			name = L["Elite / Rare"], 
			get = function(l)return SuperVillain.db.SVUnit[j]["icons"]["eliteicon"][l[#l]]end, 
			set = function(l, m)SuperVillain.db.SVUnit[j]["icons"]["eliteicon"][l[#l]] = m;i(MOD, j, s)end, 
			args = {
				enable = {type = "toggle", order = 1, name = L["Enable"]}, 
				attachTo = {type = "select", order = 2, name = L["Position"], values = positionTable}, 
				size = {type = "range", name = L["Size"], order = 3, min = 8, max = 60, step = 1}, 
				xOffset = {order = 4, type = "range", name = L["xOffset"], min = -300, max = 300, step = 1}, 
				yOffset = {order = 5, type = "range", name = L["yOffset"], min = -300, max = 300, step = 1}
			}
		}
		grouporder = grouporder + 1
	end

	if(iconGroup["roleIcon"]) then
		k.args.roleIcon = {
			order = grouporder, 
			type = "group",
			guiInline = true,
			name = L["Role"], 
			get = function(l)return SuperVillain.db.SVUnit[j]["icons"]["roleIcon"][l[#l]]end, 
			set = function(l, m)SuperVillain.db.SVUnit[j]["icons"]["roleIcon"][l[#l]] = m;i(MOD, j, s)end, 
			args = {
				enable = {type = "toggle", order = 1, name = L["Enable"]}, 
				attachTo = {type = "select", order = 2, name = L["Position"], values = positionTable}, 
				size = {type = "range", name = L["Size"], order = 3, min = 8, max = 60, step = 1}, 
				xOffset = {order = 4, type = "range", name = L["xOffset"], min = -300, max = 300, step = 1}, 
				yOffset = {order = 5, type = "range", name = L["yOffset"], min = -300, max = 300, step = 1}
			}
		}
		grouporder = grouporder + 1
	end

	if(iconGroup["raidRoleIcons"]) then
		k.args.raidRoleIcons = {
			order = grouporder, 
			type = "group",
			guiInline = true,
			name = L["Leader / MasterLooter"], 
			get = function(l)return SuperVillain.db.SVUnit[j]["icons"]["raidRoleIcons"][l[#l]]end, 
			set = function(l, m)SuperVillain.db.SVUnit[j]["icons"]["raidRoleIcons"][l[#l]] = m;i(MOD, j, s)end, 
			args = {
				enable = {type = "toggle", order = 1, name = L["Enable"]}, 
				attachTo = {type = "select", order = 2, name = L["Position"], values = positionTable}, 
				size = {type = "range", name = L["Size"], order = 3, min = 8, max = 60, step = 1}, 
				xOffset = {order = 4, type = "range", name = L["xOffset"], min = -300, max = 300, step = 1}, 
				yOffset = {order = 5, type = "range", name = L["yOffset"], min = -300, max = 300, step = 1}
			}
		}
		grouporder = grouporder + 1
	end

	return k 
end;

function MOD:SetAurabarConfigGroup(h, i, j)
	local k = {
		order = 1100, 
		type = "group", 
		name = L["Aura Bars"], 
		get = function(l)return SuperVillain.db.SVUnit[j]["aurabar"][l[#l]]end, 
		set = function(l, m)SuperVillain.db.SVUnit[j]["aurabar"][l[#l]] = m;i(MOD, j);MOD:RefreshUnitFrames()end, 
		args = {
			commonGroup = {
				order = 1, 
				type = "group", 
				guiInline = true, 
				name = L["General"], 
				args = {
					enable = {
						type = "toggle", 
						order = 1, 
						name = L["Enable"]
					}, 
					configureButton1 = {
						order = 2, 
						name = L["Coloring"], 
						type = "execute", func = function()ACD:SelectGroup("SVUI", "SVUnit", "common", "allColorsGroup", "auraBars")end
					}, 
					configureButton2 = {
						order = 3, 
						name = L["Coloring (Specific)"], 
						type = "execute", func = function()SuperVillain:SetToFilterConfig("AuraBar Colors")end
					}, 
					anchorPoint = {
						type = "select", 
						order = 4, 
						name = L["Anchor Point"], desc = L["What point to anchor to the frame you set to attach to."], values = {["ABOVE"] = L["Above"], ["BELOW"] = L["Below"]}
					}, 
					attachTo = {
						type = "select", 
						order = 5, 
						name = L["Attach To"], desc = L["The object you want to attach to."], 
						values = {["FRAME"] = L["Frame"], ["DEBUFFS"] = L["Debuffs"], ["BUFFS"] = L["Buffs"]}
					}, 
					height = {
						type = "range", 
						order = 6, 
						name = L["Height"], min = 6, max = 40, step = 1
					}, 
					statusbar = {
						type = "select", 
						dialogControl = "LSM30_Statusbar", 
						order = 7, 
						name = L["StatusBar Texture"], 
						desc = L["Aurabar texture."], 
						values = AceGUIWidgetLSMlists.statusbar
					}
				}
			}, 
			fontGroup = {
				order = 2, 
				type = "group", 
				guiInline = true, 
				name = L["Fonts"], 
				args = {
					font = {
						type = "select", 
						dialogControl = "LSM30_Font", 
						order = 0, 
						name = L["Default Font"], 
						desc = L["The font that the unitframes will use."], 
						values = AceGUIWidgetLSMlists.font, 
						get = function()return SuperVillain.db.SVUnit[j]["aurabar"].font end, 
						set = function(l, m)SuperVillain.db.SVUnit[j]["aurabar"].font = m;MOD:RefreshUnitFonts()end
					}, 
					fontSize = {
						order = 1, 
						name = L["Font Size"], 
						desc = L["Set the font size for unitframes."], 
						type = "range", 
						min = 6, 
						max = 22, 
						step = 1, 
						get = function()return SuperVillain.db.SVUnit[j]["aurabar"].fontSize end, 
						set = function(l, m)SuperVillain.db.SVUnit[j]["aurabar"].fontSize = m;MOD:RefreshUnitFonts()end
					}, 
					fontOutline = {
						order = 2, 
						name = L["Font Outline"], 
						desc = L["Set the font outline."], 
						type = "select", 
						values = {["NONE"] = L["None"], ["OUTLINE"] = "OUTLINE", ["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE", ["THICKOUTLINE"] = "THICKOUTLINE"}, 
						get = function()return SuperVillain.db.SVUnit[j]["aurabar"].fontOutline end, 
						set = function(l, m)SuperVillain.db.SVUnit[j]["aurabar"].fontOutline = m;MOD:RefreshUnitFonts()end
					}
				}
			}, 
			filterGroup = {
				order = 3, 
				type = "group", 
				guiInline = true, 
				name = L["Filtering and Sorting"], 
				args = {
					sort = {
						type = "select", 
						order = 7, 
						name = L["Sort Method"], 
						values = {["TIME_REMAINING"] = L["Time Remaining"], ["TIME_REMAINING_REVERSE"] = L["Time Remaining Reverse"], ["TIME_DURATION"] = L["Duration"], ["TIME_DURATION_REVERSE"] = L["Duration Reverse"], ["NAME"] = NAME, ["NONE"] = NONE}
					}, 
					filters = {
						name = L["Filters"], 
						guiInline = true, 
						type = "group", 
						order = 500, 
						args = {}
					}, 
					friendlyAuraType = {
						type = "select", 
						order = 16, 
						name = L["Friendly Aura Type"], desc = L["Set the type of auras to show when a unit is friendly."], values = {["HARMFUL"] = L["Debuffs"], ["HELPFUL"] = L["Buffs"]}
					}, 
					enemyAuraType = {
						type = "select", 
						order = 17, 
						name = L["Enemy Aura Type"], desc = L["Set the type of auras to show when a unit is a foe."], values = {["HARMFUL"] = L["Debuffs"], ["HELPFUL"] = L["Buffs"]}
					}
				}
			}
		}
	};
	if h then 
		k.args.filterGroup.args.filters.args.filterPlayer = {
			order = 10, 
			type = "toggle", 
			name = L["Only Show Your Auras"], desc = L["Don't display auras that are not yours."]
		}
		k.args.filterGroup.args.filters.args.filterBlocked = {
			order = 11, 
			type = "toggle", 
			name = L["Force Blocked List"], desc = L["Don't display any auras found on the Blocked filter."]
		}
		k.args.filterGroup.args.filters.args.filterAllowed = {
			order = 12, 
			type = "toggle", 
			name = L["Force Allowed List"], desc = L["If no other filter options are being used then it will block anything not on the Allowed filter, otherwise it will simply add auras on the whitelist in addition to any other filter settings."]
		}
		k.args.filterGroup.args.filters.args.filterInfinite = {
			order = 13, 
			type = "toggle", 
			name = L["Block Auras Without Duration"], desc = L["Don't display auras that have no duration."]
		}
		k.args.filterGroup.args.filters.args.filterDispellable = {
			order = 13, 
			type = "toggle", 
			name = L["Block Non-Dispellable Auras"], desc = L["Don't display auras that cannot be purged or dispelled by your class."]
		}
		k.args.filterGroup.args.filters.args.filterRaid = {
			order = 14, 
			type = "toggle", 
			name = L["Block Raid Buffs"], desc = L["Don't display raid buffs such as Blessing of Kings or Mark of the Wild."]
		}
		k.args.filterGroup.args.filters.args.useFilter = {
			order = 15, 
			name = L["Additional Filter"], 
			desc = L["Select an additional filter to use. If the selected filter is a whitelist and no other filters are being used (with the exception of Only Show Your Auras) then it will block anything not on the whitelist, otherwise it will simply add auras on the whitelist in addition to any other filter settings."], 
			type = "select", 
			values = function()
				filterList = {}
				filterList[""] = NONE;
				for n in pairs(SuperVillain.global.Filters)do 
					filterList[n] = n 
				end;
				return filterList 
			end
		}
	else 
		k.args.filterGroup.args.filters.args.filterPlayer = {
			order = 10, guiInline = true, 
			type = "group", 
			name = L["Only Show Your Auras"], 
			args = {
				friendly = {
					order = 2, 
					type = "toggle", 
					name = L["Friendly"], desc = L["If the unit is friendly to you."].." "..L["Don't display auras that are not yours."], 
					get = function(l)return SuperVillain.db.SVUnit[j]["aurabar"].filterPlayer.friendly end, 
					set = function(l, m)SuperVillain.db.SVUnit[j]["aurabar"].filterPlayer.friendly = m;i(MOD, j)end
				}, 
				enemy = {
					order = 3, 
					type = "toggle", 
					name = L["Enemy"], desc = L["If the unit is an enemy to you."].." "..L["Don't display auras that are not yours."], 
					get = function(l)return SuperVillain.db.SVUnit[j]["aurabar"].filterPlayer.enemy end, 
					set = function(l, m)SuperVillain.db.SVUnit[j]["aurabar"].filterPlayer.enemy = m;i(MOD, j)end
				}
			}
		}
		k.args.filterGroup.args.filters.args.filterBlocked = {
			order = 11, guiInline = true, 
			type = "group", 
			name = L["Force Blocked List"], 
			args = {
				friendly = {
					order = 2, 
					type = "toggle", 
					name = L["Friendly"], desc = L["If the unit is friendly to you."].." "..L["Don't display any auras found on the Blocked filter."], 
					get = function(l)return SuperVillain.db.SVUnit[j]["aurabar"].filterBlocked.friendly end, 
					set = function(l, m)SuperVillain.db.SVUnit[j]["aurabar"].filterBlocked.friendly = m;i(MOD, j)end
				}, 
				enemy = {
					order = 3, 
					type = "toggle", 
					name = L["Enemy"], desc = L["If the unit is an enemy to you."].." "..L["Don't display any auras found on the Blocked filter."], 
					get = function(l)return SuperVillain.db.SVUnit[j]["aurabar"].filterBlocked.enemy end, 
					set = function(l, m)SuperVillain.db.SVUnit[j]["aurabar"].filterBlocked.enemy = m;i(MOD, j)end
				}
			}
		}
		k.args.filterGroup.args.filters.args.filterAllowed = {
			order = 12, guiInline = true, 
			type = "group", 
			name = L["Force Allowed List"], 
			args = {
				friendly = {
					order = 2, 
					type = "toggle", 
					name = L["Friendly"], desc = L["If the unit is friendly to you."].." "..L["If no other filter options are being used then it will block anything not on the Allowed filter, otherwise it will simply add auras on the whitelist in addition to any other filter settings."], 
					get = function(l)return SuperVillain.db.SVUnit[j]["aurabar"].filterAllowed.friendly end, 
					set = function(l, m)SuperVillain.db.SVUnit[j]["aurabar"].filterAllowed.friendly = m;i(MOD, j)end
				}, 
				enemy = {
					order = 3, 
					type = "toggle", 
					name = L["Enemy"], desc = L["If the unit is an enemy to you."].." "..L["If no other filter options are being used then it will block anything not on the Allowed filter, otherwise it will simply add auras on the whitelist in addition to any other filter settings."], 
					get = function(l)return SuperVillain.db.SVUnit[j]["aurabar"].filterAllowed.enemy end, 
					set = function(l, m)SuperVillain.db.SVUnit[j]["aurabar"].filterAllowed.enemy = m;i(MOD, j)end
				}
			}
		}
		k.args.filterGroup.args.filters.args.filterInfinite = {
			order = 13, guiInline = true, 
			type = "group", 
			name = L["Block Auras Without Duration"], 
			args = {
				friendly = {
					order = 2, 
					type = "toggle", 
					name = L["Friendly"], desc = L["If the unit is friendly to you."].." "..L["Don't display auras that have no duration."], 
					get = function(l)return SuperVillain.db.SVUnit[j]["aurabar"].filterInfinite.friendly end, 
					set = function(l, m)SuperVillain.db.SVUnit[j]["aurabar"].filterInfinite.friendly = m;i(MOD, j)end
				}, 
				enemy = {
					order = 3, 
					type = "toggle", 
					name = L["Enemy"], desc = L["If the unit is an enemy to you."].." "..L["Don't display auras that have no duration."], 
					get = function(l)return SuperVillain.db.SVUnit[j]["aurabar"].filterInfinite.enemy end, 
					set = function(l, m)SuperVillain.db.SVUnit[j]["aurabar"].filterInfinite.enemy = m;i(MOD, j)end
				}
			}
		}
		k.args.filterGroup.args.filters.args.filterDispellable = {
			order = 13, guiInline = true, 
			type = "group", 
			name = L["Block Non-Dispellable Auras"], 
			args = {
				friendly = {
				order = 2, 
				type = "toggle", 
				name = L["Friendly"], desc = L["If the unit is friendly to you."].." "..L["Don't display auras that cannot be purged or dispelled by your class."], 
				get = function(l)return SuperVillain.db.SVUnit[j]["aurabar"].filterDispellable.friendly end, 
				set = function(l, m)SuperVillain.db.SVUnit[j]["aurabar"].filterDispellable.friendly = m;i(MOD, j)end}, enemy = {
				order = 3, 
				type = "toggle", 
				name = L["Enemy"], desc = L["If the unit is an enemy to you."].." "..L["Don't display auras that cannot be purged or dispelled by your class."], 
				get = function(l)return SuperVillain.db.SVUnit[j]["aurabar"].filterDispellable.enemy end, 
				set = function(l, m)SuperVillain.db.SVUnit[j]["aurabar"].filterDispellable.enemy = m;i(MOD, j)end}
			}
		}
		k.args.filterGroup.args.filters.args.filterRaid = {
			order = 14, guiInline = true, 
			type = "group", 
			name = L["Block Raid Buffs"], 
			args = {
				friendly = {
				order = 2, 
				type = "toggle", 
				name = L["Friendly"], desc = L["If the unit is friendly to you."].." "..L["Don't display raid buffs such as Blessing of Kings or Mark of the Wild."], 
				get = function(l)return SuperVillain.db.SVUnit[j]["aurabar"].filterRaid.friendly end, 
				set = function(l, m)SuperVillain.db.SVUnit[j]["aurabar"].filterRaid.friendly = m;i(MOD, j)end}, enemy = {
				order = 3, 
				type = "toggle", 
				name = L["Enemy"], desc = L["If the unit is an enemy to you."].." "..L["Don't display raid buffs such as Blessing of Kings or Mark of the Wild."], 
				get = function(l)return SuperVillain.db.SVUnit[j]["aurabar"].filterRaid.enemy end, 
				set = function(l, m)SuperVillain.db.SVUnit[j]["aurabar"].filterRaid.enemy = m;i(MOD, j)end}
			}
		}
		k.args.filterGroup.args.filters.args.useFilter = {
			order = 15, 
			name = L["Additional Filter"], 
			desc = L["Select an additional filter to use. If the selected filter is a whitelist and no other filters are being used (with the exception of Only Show Your Auras) then it will block anything not on the whitelist, otherwise it will simply add auras on the whitelist in addition to any other filter settings."], 
			type = "select", 
			values = function()
				filterList = {}
				filterList[""] = NONE;
				for n in pairs(SuperVillain.global.Filters)do 
					filterList[n] = n 
				end;
				return filterList 
			end
		}
	end;
	return k 
end;

SuperVillain.Options.args.SVUnit = {
	type = "group", 
	name = L["UnitFrames"], 
	childGroups = "tree", 
	get = function(key)
		return SuperVillain.db.SVUnit[key[#key]]
	end, 
	set = function(key, value)
		MOD:ChangeDBVar(value, key[#key]);
		MOD:RefreshUnitFrames();
	end,
	disabled = function()
		return not SuperVillain.protected.SVUnit.enable 
	end, 
	args = {
		enable = {
			order = 1, 
			type = "toggle", 
			name = L["Enable"], 
			get = function(l)
				return SuperVillain.protected.SVUnit.enable end, 
			set = function(l, m)
				SuperVillain.protected.SVUnit.enable = m;
				SuperVillain:StaticPopup_Show("RL_CLIENT")
			end
		}, 
		common = {
			order = 200, 
			type = "group", 
			name = L["General"], 
			guiInline = true, 
			args = {
				commonGroup = {
					order = 1, 
					type = "group", 
					guiInline = true, 
					name = L["General"], 
					args = {
						disableBlizzard = {
							order = 1, 
							name = L["Disable Blizzard"], 
							desc = L["Disables the blizzard party/raid frames."], 
							type = "toggle", 
							get = function(key)
								return SuperVillain.protected.SVUnit.disableBlizzard 
							end, 
							set = function(key, value)
								SuperVillain.protected["SVUnit"].disableBlizzard = value;
								SuperVillain:StaticPopup_Show("RL_CLIENT")
							end
						}, 
						fastClickTarget = {
							order = 2, 
							name = L["Fast Clicks"], 
							desc = L["Immediate mouse-click-targeting"], 
							type = "toggle"
						}, 
						debuffHighlighting = {
							order = 3, 
							name = L["Debuff Highlight"], 
							desc = L["Color the unit if there is a debuff that can be dispelled by your class."], 
							type = "toggle"
						}, 
						combatFadeNames = {
							order = 4, 
							name = L["Name Fading"], 
							desc = L["Fade Names in Combat"], 
							type = "toggle", 
							get = function(key)
								return SuperVillain.db.SVUnit.combatFadeNames 
							end, 
							set = function(key, value)
								MOD:ChangeDBVar(value, key[#key]);
								MOD:SetFadeManager()
							end
						}, 
						combatFadeRoles = {
							order = 5, 
							name = L["Role Fading"], 
							desc = L["Fade Role Icons in Combat"], 
							type = "toggle", 
							get = function(key)
								return SuperVillain.db.SVUnit.combatFadeRoles 
							end, 
							set = function(key, value)
								MOD:ChangeDBVar(value, key[#key]);
								MOD:SetFadeManager()
							end
						}, 
						OORAlpha = {
							order = 6, 
							name = L["Range Fading"], 
							desc = L["The transparency of units that are out of range."], 
							type = "range", 
							min = 0, 
							max = 1, 
							step = 0.01, 
							width = "full",
							set = function(key, value)
								MOD:ChangeDBVar(value, key[#key]);
							end
						}
					}
				}, 
				backgroundGroup = {
					order = 2, 
					type = "group", 
					guiInline = true, 
					name = "Unit Backgrounds (3D Portraits Only)", 
					get = function(key)
						return SuperVillain.db.media.textures[key[#key]][2]
					end,
					set = function(key, value)
						SuperVillain.db.media.textures[key[#key]] = {"background", value}
						SuperVillain:Refresh_SVUI_System(true)
					end,
					args = {
						unitlarge = {
							type = "select", 
							dialogControl = "LSM30_Background", 
							order = 2, 
							name = "Unit Background", 
							values = AceGUIWidgetLSMlists.background,
						}, 
						unitsmall = {
							type = "select", 
							dialogControl = "LSM30_Background", 
							order = 3, 
							name = "Small Unit Background", 
							values = AceGUIWidgetLSMlists.background,
						}
					}
				}, 
				barGroup = {
					order = 3, 
					type = "group", 
					guiInline = true, 
					name = L["Bars"],
					get = function(key)
						return SuperVillain.db.SVUnit[key[#key]]
					end,
					set = function(key, value)
						MOD:ChangeDBVar(value, key[#key]);
						MOD:RefreshUnitTextures()
					end,
					args = {
						smoothbars = {
							type = "toggle", 
							order = 1, 
							name = L["Smooth Bars"], 
							desc = L["Bars will transition smoothly."]
						}, 
						statusbar = {
							type = "select", 
							dialogControl = "LSM30_Statusbar", 
							order = 2, 
							name = L["StatusBar Texture"], 
							desc = L["Main statusbar texture."], 
							values = AceGUIWidgetLSMlists.statusbar
						},
						auraBarStatusbar = {
							type = "select", 
							dialogControl = "LSM30_Statusbar", 
							order = 3, 
							name = L["AuraBar Texture"], 
							desc = L["Main statusbar texture."], 
							values = AceGUIWidgetLSMlists.statusbar
						},
					}
				},
				fontGroup = {
					order = 4, 
					type = "group", 
					guiInline = true, 
					name = L["Fonts"],
					set = function(key, value)
						MOD:ChangeDBVar(value, key[#key]);
						MOD:RefreshUnitFonts()
					end,
					args = {
						font = {
							type = "select", 
							dialogControl = "LSM30_Font", 
							order = 1, 
							name = L["Default Font"], 
							desc = L["The font that the unitframes will use."], 
							values = AceGUIWidgetLSMlists.font, 
						},  
						fontOutline = {
							order = 2, 
							name = L["Font Outline"], 
							desc = L["Set the font outline."], 
							type = "select", 
							values = {
								["NONE"] = L["None"], ["OUTLINE"] = "OUTLINE", ["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE", ["THICKOUTLINE"] = "THICKOUTLINE"
							},
						},
						fontSize = {
							order = 3, 
							name = L["Font Size"], 
							desc = L["Set the font size for unitframes."], 
							type = "range", 
							min = 6, 
							max = 22, 
							step = 1,
						},
						auraFont = {
							type = "select", 
							dialogControl = "LSM30_Font", 
							order = 4, 
							name = L["Aura Font"], 
							desc = L["The font that the aura icons and aurabar will use."], 
							values = AceGUIWidgetLSMlists.font,
							set = function(key, value)
								MOD:ChangeDBVar(value, key[#key]);
								MOD:RefreshAuraBarFonts()
							end,
						},  
						auraFontOutline = {
							order = 5, 
							name = L["Aura Font Outline"], 
							desc = L["Set the aura icons and aurabar font outline."], 
							type = "select", 
							values = {
								["NONE"] = L["None"], ["OUTLINE"] = "OUTLINE", ["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE", ["THICKOUTLINE"] = "THICKOUTLINE"
							},
							set = function(key, value)
								MOD:ChangeDBVar(value, key[#key]);
								MOD:RefreshAuraBarFonts()
							end,
						},
						auraFontSize = {
							order = 6, 
							name = L["Aura Font Size"], 
							desc = L["Set the font size for aura icons and aurabars."], 
							type = "range", 
							min = 6, 
							max = 22, 
							step = 1,
							set = function(key, value)
								MOD:ChangeDBVar(value, key[#key]);
								MOD:RefreshAuraBarFonts()
							end,
						},
					}
				},
				allColorsGroup = {
					order = 5, 
					type = "group", 
					guiInline = true, 
					name = L["Colors"],
					args = {
						healthGroup = {
							order = 9, 
							type = "group", guiInline = true, 
							name = HEALTH, 
							args = { 
								healthclass = {
									order = 1, 
									type = "toggle", 
									name = L["Class Health"], 
									desc = L["Color health by classcolor or reaction."], 
									get = function(key)
										return SuperVillain.db.SVUnit[key[#key]]
									end, 
									set = function(key, value)
										MOD:ChangeDBVar(value, key[#key]);
										MOD:RefreshUnitFrames()
									end
								}, 
								colorhealthbyvalue = {
									order = 2, 
									type = "toggle", 
									name = L["Health By Value"], 
									desc = L["Color health by amount remaining."], 
									get = function(key)
										return SuperVillain.db.SVUnit[key[#key]]
									end, 
									set = function(key, value)
										MOD:ChangeDBVar(value, key[#key]);
										MOD:RefreshUnitFrames()
									end
								}, 
								classbackdrop = {
									order = 3, 
									type = "toggle", 
									name = L["Class Backdrop"], 
									desc = L["Color the health backdrop by class or reaction."], 
									get = function(key)
										return SuperVillain.db.SVUnit[key[#key]]
									end, 
									set = function(key, value)
										MOD:ChangeDBVar(value, key[#key]);
										MOD:RefreshUnitFrames()
									end
								},
								forceHealthColor = {
									order = 4, 
									type = "toggle", 
									name = L["Overlay Health Color"], 
									desc = L["Force custom health color when using portrait overlays."], 
									get = function(key)
										return SuperVillain.db.SVUnit[key[#key]]
									end, 
									set = function(key, value)
										MOD:ChangeDBVar(value, key[#key]);
										MOD:RefreshUnitFrames()
									end
								},
								overlayAnimation = {
									order = 5, 
									type = "toggle", 
									name = L["Overlay Animations"], 
									desc = L["Toggle health animations on portrait overlays."], 
									get = function(key)
										return SuperVillain.db.SVUnit[key[#key]]
									end, 
									set = function(key, value)
										MOD:ChangeDBVar(value, key[#key]);
										MOD:RefreshUnitFrames()
									end
								},
								health = {
									order = 7, 
									type = "color", 
									name = L["Health"],
									get = function(key)
										local color = SuperVillain.db.media.unitframes["health"]
										return color.r, color.g, color.b, color.a 
									end, 
									set = function(key, rValue, gValue, bValue)
										SuperVillain.db.media.unitframes["health"] = {r = rValue, g = gValue, b = bValue}
										MOD:RefreshUnitFrames()
									end, 
								}, 
								tapped = {
									order = 8, 
									type = "color", 
									name = L["Tapped"],
									get = function(key)
										local color = SuperVillain.db.media.unitframes["tapped"]
										return color.r, color.g, color.b, color.a 
									end, 
									set = function(key, rValue, gValue, bValue)
										SuperVillain.db.media.unitframes["tapped"] = {r = rValue, g = gValue, b = bValue}
										MOD:RefreshUnitFrames()
									end, 
								}, 
								disconnected = {
									order = 9, 
									type = "color", 
									name = L["Disconnected"],
									get = function(key)
										local color = SuperVillain.db.media.unitframes["disconnected"]
										return color.r, color.g, color.b, color.a 
									end, 
									set = function(key, rValue, gValue, bValue)
										SuperVillain.db.media.unitframes["disconnected"] = {r = rValue, g = gValue, b = bValue}
										MOD:RefreshUnitFrames()
									end, 
								}
							}
						}, 
						powerGroup = {
							order = 10, 
							type = "group", 
							guiInline = true, 
							name = L["Powers"],
							args = {
								powerclass = {
									order = 0, 
									type = "toggle", 
									name = L["Class Power"], 
									desc = L["Color power by classcolor or reaction."], 
									get = function(key)
										return SuperVillain.db.SVUnit[key[#key]]
									end, 
									set = function(key, value)
										MOD:ChangeDBVar(value, key[#key]);
										MOD:RefreshUnitFrames()
									end
								}, 
								MANA = {
									order = 2, 
									name = MANA, 
									type = "color",
									get = function(key)
										local color = SuperVillain.db.media.unitframes.power["MANA"]
										return color.r, color.g, color.b, color.a 
									end, 
									set = function(key, rValue, gValue, bValue)
										SuperVillain.db.media.unitframes.power["MANA"] = {r = rValue, g = gValue, b = bValue}
										MOD:RefreshUnitFrames()
									end, 
								}, 
								RAGE = {
									order = 3, 
									name = RAGE, 
									type = "color",
									get = function(key)
										local color = SuperVillain.db.media.unitframes.power["RAGE"]
										return color.r, color.g, color.b, color.a 
									end, 
									set = function(key, rValue, gValue, bValue)
										SuperVillain.db.media.unitframes.power["RAGE"] = {r = rValue, g = gValue, b = bValue}
										MOD:RefreshUnitFrames()
									end, 
								}, 
								FOCUS = {
									order = 4, 
									name = FOCUS, 
									type = "color",
									get = function(key)
										local color = SuperVillain.db.media.unitframes.power["FOCUS"]
										return color.r, color.g, color.b, color.a 
									end, 
									set = function(key, rValue, gValue, bValue)
										SuperVillain.db.media.unitframes.power["FOCUS"] = {r = rValue, g = gValue, b = bValue}
										MOD:RefreshUnitFrames()
									end, 
								}, 
								ENERGY = {
									order = 5, 
									name = ENERGY, 
									type = "color",
									get = function(key)
										local color = SuperVillain.db.media.unitframes.power["ENERGY"]
										return color.r, color.g, color.b, color.a 
									end, 
									set = function(key, rValue, gValue, bValue)
										SuperVillain.db.media.unitframes.power["ENERGY"] = {r = rValue, g = gValue, b = bValue}
										MOD:RefreshUnitFrames()
									end, 
								}, 
								RUNIC_POWER = {
									order = 6, 
									name = RUNIC_POWER, 
									type = "color",
									get = function(key)
										local color = SuperVillain.db.media.unitframes.power["RUNIC_POWER"]
										return color.r, color.g, color.b, color.a 
									end, 
									set = function(key, rValue, gValue, bValue)
										SuperVillain.db.media.unitframes.power["RUNIC_POWER"] = {r = rValue, g = gValue, b = bValue}
										MOD:RefreshUnitFrames()
									end, 
								}
							}
						}, 
						castBars = {
							order = 11, 
							type = "group", 
							guiInline = true, 
							name = L["Castbar"],
							args = {
								castClassColor = {
									order = 0, 
									type = "toggle", 
									name = L["Class Castbars"], 
									desc = L["Color castbars by the class or reaction type of the unit."], 
									get = function(key)
										return SuperVillain.db.SVUnit[key[#key]]
									end, 
									set = function(key, value)
										MOD:ChangeDBVar(value, key[#key]);
										MOD:RefreshUnitFrames()
									end
								}, 
								casting = {
									order = 3, 
									name = L["Interruptable"], 
									type = "color",
									get = function(key)
										local color = SuperVillain.db.media.unitframes["casting"]
										return color.r, color.g, color.b, color.a 
									end, 
									set = function(key, rValue, gValue, bValue)
										SuperVillain.db.media.unitframes["casting"] = {r = rValue, g = gValue, b = bValue}
										MOD:RefreshUnitFrames()
									end,
								}, 
								spark = {
									order = 4, 
									name = "Spark Color", 
									type = "color",
									get = function(key)
										local color = SuperVillain.db.media.unitframes["spark"]
										return color.r, color.g, color.b, color.a 
									end, 
									set = function(key, rValue, gValue, bValue)
										SuperVillain.db.media.unitframes["spark"] = {r = rValue, g = gValue, b = bValue}
										MOD:RefreshUnitFrames()
									end,
								}, 
								interrupt = {
									order = 5, 
									name = L["Non-Interruptable"], 
									type = "color",
									get = function(key)
										local color = SuperVillain.db.media.unitframes["interrupt"]
										return color.r, color.g, color.b, color.a 
									end, 
									set = function(key, rValue, gValue, bValue)
										SuperVillain.db.media.unitframes["interrupt"] = {r = rValue, g = gValue, b = bValue}
										MOD:RefreshUnitFrames()
									end,
								}
							}
						}, 
						auraBars = {
							order = 11, 
							type = "group", 
							guiInline = true, 
							name = L["Aura Bars"], 
							args = {
								auraBarByType = {
									order = 1, 
									name = L["By Type"], 
									desc = L["Color aurabar debuffs by type."], 
									type = "toggle",
									get = function(key)
										return SuperVillain.db.SVUnit[key[#key]]
									end, 
									set = function(key, value)
										MOD:ChangeDBVar(value, key[#key]);
										MOD:RefreshUnitFrames()
									end
								}, 
								auraBarShield = {
									order = 2, 
									name = L["Color Shield Buffs"], 
									desc = L["Color all buffs that reduce incoming damage."], 
									type = "toggle",
									get = function(key)
										return SuperVillain.db.SVUnit[key[#key]]
									end, 
									set = function(key, value)
										MOD:ChangeDBVar(value, key[#key]);
										MOD:RefreshUnitFrames()
									end
								}, 
								buff_bars = {
									order = 10, 
									name = L["Buffs"], 
									type = "color",
									get = function(key)
										local color = SuperVillain.db.media.unitframes["buff_bars"]
										return color.r, color.g, color.b, color.a 
									end, 
									set = function(key, rValue, gValue, bValue)
										SuperVillain.db.media.unitframes["buff_bars"] = {r = rValue, g = gValue, b = bValue}
										MOD:RefreshUnitFrames()
									end,
								}, 
								debuff_bars = {
									order = 11, 
									name = L["Debuffs"], 
									type = "color",
									get = function(key)
										local color = SuperVillain.db.media.unitframes["debuff_bars"]
										return color.r, color.g, color.b, color.a 
									end, 
									set = function(key, rValue, gValue, bValue)
										SuperVillain.db.media.unitframes["debuff_bars"] = {r = rValue, g = gValue, b = bValue}
										MOD:RefreshUnitFrames()
									end,
								}, 
								shield_bars = {
									order = 12, 
									name = L["Shield Buffs Color"], 
									type = "color",
									get = function(key)
										local color = SuperVillain.db.media.unitframes["shield_bars"]
										return color.r, color.g, color.b, color.a 
									end, 
									set = function(key, rValue, gValue, bValue)
										SuperVillain.db.media.unitframes["shield_bars"] = {r = rValue, g = gValue, b = bValue}
										MOD:RefreshUnitFrames()
									end,
								}
							}
						}, 
						predict = {
							order = 12, 
							name = L["Heal Prediction"], 
							type = "group",
							args = {
								personal = {
									order = 1, 
									name = L["Personal"], 
									type = "color", 
									hasAlpha = true,
									get = function(key)
										local color = SuperVillain.db.media.unitframes.predict["personal"]
										return color.r, color.g, color.b, color.a 
									end, 
									set = function(key, rValue, gValue, bValue)
										SuperVillain.db.media.unitframes.predict["personal"] = {r = rValue, g = gValue, b = bValue}
										MOD:RefreshUnitFrames()
									end,
								}, 
								others = {
									order = 2, 
									name = L["Others"], 
									type = "color", 
									hasAlpha = true,
									get = function(key)
										local color = SuperVillain.db.media.unitframes.predict["others"]
										return color.r, color.g, color.b, color.a 
									end, 
									set = function(key, rValue, gValue, bValue)
										SuperVillain.db.media.unitframes.predict["others"] = {r = rValue, g = gValue, b = bValue}
										MOD:RefreshUnitFrames()
									end,
								}, 
								absorbs = {
									order = 2, 
									name = L["Absorbs"], 
									type = "color", 
									hasAlpha = true,
									get = function(key)
										local color = SuperVillain.db.media.unitframes.predict["absorbs"]
										return color.r, color.g, color.b, color.a 
									end, 
									set = function(key, rValue, gValue, bValue)
										SuperVillain.db.media.unitframes.predict["absorbs"] = {r = rValue, g = gValue, b = bValue}
										MOD:RefreshUnitFrames()
									end,
								}
							}
						}
					}
				}
			}
		}
	}
}
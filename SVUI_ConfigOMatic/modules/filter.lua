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
local MOD = SuperVillain:GetModule('SVUnit');
local selectedSpell,filterType,filters;
local tinsert=table.insert;
local function generateFilterOptions()
	if filterType == 'AuraBar Colors' then 

		SuperVillain.Options.args.filters.args.filterGroup = {
			type = "group",
			name = filterType,
			guiInline = true,
			order = 10,
			args = {
				addSpell = {
					order = 1,
					name = L["Add Spell"],
					desc = L["Add a spell to the filter."],
					type = "input",
					guiInline = true,
					get = function(e)return""end,
					set = function(e, arg)
						if not SuperVillain.global.SVUnit.AuraBarColors[arg] then 
							SuperVillain.global.SVUnit.AuraBarColors[arg] = false 
						end;
						generateFilterOptions()
						MOD:SetBasicFrame("player")
						MOD:SetBasicFrame("target")
						MOD:SetBasicFrame("focus")
					end
				},
				removeSpell = {
					order = 2,
					name = L["Remove Spell"],
					desc = L["Remove a spell from the filter."],
					type = "input",
					guiInline = true,
					get = function(e)return""end,
					set = function(e, arg)
						if G["SVUnit"].AuraBarColors[arg]then 
							SuperVillain.global.SVUnit.AuraBarColors[arg] = false;
							SuperVillain:AddonMessage(L["You may not remove a spell from a default filter that is not customly added. Setting spell to false instead."])
						else 
							SuperVillain.global.SVUnit.AuraBarColors[arg] = nil 
						end;
						selectedSpell = nil;
						generateFilterOptions()
						MOD:SetBasicFrame("player")
						MOD:SetBasicFrame("target")
						MOD:SetBasicFrame("focus")
					end
				},
				selectSpell = {
					name = L["Select Spell"],
					type = "select",
					order = 3,
					guiInline = true,
					get = function(e)return selectedSpell end,
					set = function(e, arg)
						selectedSpell = arg;
						generateFilterOptions()
					end,
					values = function()
						local filters = {}
						filters[""] = NONE;
						for g in pairs(SuperVillain.global.SVUnit.AuraBarColors)do 
							filters[g] = g 
						end;
						return filters 
					end
				}
			}
		}

		if not selectedSpell or SuperVillain.global.SVUnit.AuraBarColors[selectedSpell] == nil then 
			SuperVillain.Options.args.filters.args.spellGroup = nil; 
			return 
		end;

		SuperVillain.Options.args.filters.args.spellGroup = {
			type = "group",
			name = selectedSpell,
			order = 15,
			guiInline = true,
			args = {
				color = {
					name = L["Color"],
					type = "color",
					order = 1,
					get = function(e)
						local abColor = SuperVillain.global.SVUnit.AuraBarColors[selectedSpell]
						if type(abColor) == "boolean"then 
							return 0, 0, 0, 1 
						else 
							return abColor.r, abColor.g, abColor.b, abColor.a 
						end 
					end,
					set = function(e, i, j, k)
						if type(SuperVillain.global.SVUnit.AuraBarColors[selectedSpell]) ~= "table"then 
							SuperVillain.global.SVUnit.AuraBarColors[selectedSpell] = {}
						end;
						local abColor = SuperVillain.global.SVUnit.AuraBarColors[selectedSpell]
						abColor.r, abColor.g, abColor.b = i, j, k;
						MOD:SetBasicFrame("player")
						MOD:SetBasicFrame("target")
						MOD:SetBasicFrame("focus")
					end
				},
				removeColor = {
					type = "execute",
					order = 2,
					name = L["Restore Defaults"],
					func = function(e, arg)
						SuperVillain.global.SVUnit.AuraBarColors[selectedSpell] = false;
						MOD:SetBasicFrame("player")
						MOD:SetBasicFrame("target")
						MOD:SetBasicFrame("focus")
					end
				}
			}
		}

	elseif filterType == 'Buff Indicator (Pet)' then

		local watchedBuffs={}

		if not SuperVillain.global.PetBuffWatch then 
			SuperVillain.global.PetBuffWatch = {}
		end;
		for o,f in pairs(SuperVillain.global.PetBuffWatch)do 
			tinsert(watchedBuffs,f)
		end;

		SuperVillain.Options.args.filters.args.filterGroup = {
			type = "group", 
			name = filterType, 
			guiInline = true, 
			order = -10, 
			childGroups = "select", 
			args = {
				addSpellID = {
					order = 1, 
					name = L["Add SpellID"], 
					desc = L["Add a spell to the filter."], 
					type = "input", 
					get = function(e)return""end, 
					set = function(e, arg)
						if not tonumber(arg)then 
							SuperVillain:AddonMessage(L["Value must be a number"])
						elseif not GetSpellInfo(arg)then 
							SuperVillain:AddonMessage(L["Not valid spell id"])
						else 
							tinsert(SuperVillain.global.PetBuffWatch, {["enable"] = true, ["id"] = tonumber(arg), ["point"] = "TOPRIGHT", ["color"] = {["r"] = 1, ["g"] = 0, ["b"] = 0}, ["anyUnit"] = true})
							generateFilterOptions()
							MOD:SetBasicFrame("pet")
							selectedSpell = nil 
						end 
					end
				}, 
				removeSpellID = {
					order = 2, 
					name = L["Remove SpellID"], 
					desc = L["Remove a spell from the filter."], 
					type = "input", 
					get = function(e)return""end, 
					set = function(e, arg)
						if not tonumber(f)then 
							SuperVillain:AddonMessage(L["Value must be a number"])
						elseif not GetSpellInfo(f)then 
							SuperVillain:AddonMessage(L["Not valid spell id"])
						else 
							local p;
							for q, r in pairs(SuperVillain.global.PetBuffWatch)do 
								if r["id"] == tonumber(f)then 
									p = r;
									if G.PetBuffWatch[q]then 
										SuperVillain.global.PetBuffWatch[q].enable = false;
									else 
										SuperVillain.global.PetBuffWatch[q] = nil 
									end 
								end 
							end;
							if p == nil then 
								SuperVillain:AddonMessage(L["Spell not found in list."])
							else 
								generateFilterOptions()
							end 
						end;
						selectedSpell = nil;
						generateFilterOptions()
						MOD:SetBasicFrame("pet")
					end
				}, 
				selectSpell = {
					name = L["Select Spell"], 
					type = "select", 
					order = 3, 
					values = function()
						local values = {}
						watchedBuffs = {}
						for o, f in pairs(SuperVillain.global.PetBuffWatch)do 
							tinsert(watchedBuffs, f)
						end;
						for o, l in pairs(watchedBuffs)do 
							if l.id then 
								local name = GetSpellInfo(l.id)
								values[l.id] = name 
							end 
						end;
						return values 
					end, 
					get = function(e)return selectedSpell end, 
					set = function(e, arg)selectedSpell = arg; generateFilterOptions()end
				}
			}
		}

		local registeredSpell;

		for t,l in pairs(SuperVillain.global.PetBuffWatch)do 
			if l.id == selectedSpell then 
				registeredSpell = t 
			end 
		end;

		if selectedSpell and registeredSpell then 
			local currentSpell = GetSpellInfo(selectedSpell)
			SuperVillain.Options.args.filters.args.filterGroup.args[currentSpell] = {
				name = currentSpell.." ("..selectedSpell..")", 
				type = "group", 
				get = function(e)return SuperVillain.global.PetBuffWatch[registeredSpell][e[#e]] end, 
				set = function(e, arg)
					SuperVillain.global.PetBuffWatch[registeredSpell][e[#e]] = arg;
					MOD:SetBasicFrame("pet")
				end, 
				order = -10, 
				args = {
					enable = {
						name = L["Enable"], 
						order = 0, 
						type = "toggle"
					}, 
					point = {
						name = L["Anchor Point"], 
						order = 1, 
						type = "select", 
						values = {
							["TOPLEFT"] = "TOPLEFT", 
							["TOPRIGHT"] = "TOPRIGHT", 
							["BOTTOMLEFT"] = "BOTTOMLEFT", 
							["BOTTOMRIGHT"] = "BOTTOMRIGHT", 
							["LEFT"] = "LEFT", 
							["RIGHT"] = "RIGHT", 
							["TOP"] = "TOP", 
							["BOTTOM"] = "BOTTOM"
						}
					}, 
					xOffset = {order = 2, type = "range", name = L["xOffset"], min = -75, max = 75, step = 1}, 
					yOffset = {order = 2, type = "range", name = L["yOffset"], min = -75, max = 75, step = 1}, 
					style = {
						name = L["Style"], 
						order = 3, 
						type = "select", 
						values = {["coloredIcon"] = L["Colored Icon"], ["texturedIcon"] = L["Textured Icon"], ["NONE"] = NONE}
					}, 
					color = {
						name = L["Color"], 
						type = "color", 
						order = 4, 
						get = function(e)
							local abColor = SuperVillain.global.PetBuffWatch[registeredSpell][e[#e]]
							return abColor.r,  abColor.g,  abColor.b,  abColor.a 
						end, 
						set = function(e, i, j, k)
							local abColor = SuperVillain.global.PetBuffWatch[registeredSpell][e[#e]]
							abColor.r,  abColor.g,  abColor.b = i, j, k;
							MOD:SetBasicFrame("pet")
						end
					}, 
					displayText = {
						name = L["Display Text"],
						type = "toggle",
						order = 5
					},
					textColor = {
						name = L["Text Color"],
						type = "color",
						order = 6,
						get = function(e)
							local abColor = SuperVillain.global.PetBuffWatch[registeredSpell][e[#e]]
							if abColor then 
								return abColor.r,abColor.g,abColor.b,abColor.a 
							else 
								return 1,1,1,1 
							end 
						end,
						set = function(e,i,j,k)
							local abColor = SuperVillain.global.PetBuffWatch[registeredSpell][e[#e]]
							abColor.r,abColor.g,abColor.b = i,j,k;
							MOD:SetBasicFrame("pet")
						end
					},
					textThreshold = {
						name = L["Text Threshold"],
						desc = L["At what point should the text be displayed. Set to -1 to disable."],
						type = "range",
						order = 6,
						min = -1,
						max = 60,
						step = 1
					},
					anyUnit = {
						name = L["Show Aura From Other Players"],
						order = 7,
						type = "toggle"
					},
					onlyShowMissing = {
						name = L["Show When Not Active"],
						order = 8,
						type = "toggle",
						disabled = function()return SuperVillain.global.PetBuffWatch[registeredSpell].style == "text"end
					}
				}
			}
		end;

		watchedBuffs = nil;

	elseif filterType == 'Buff Indicator' then

		local watchedBuffs={}

		if not SuperVillain.global.BuffWatch then 
			SuperVillain.global.BuffWatch = {}
		end;
		for o,f in pairs(SuperVillain.global.BuffWatch) do 
			tinsert(watchedBuffs,f)
		end;

		SuperVillain.Options.args.filters.args.filterGroup = {
			type = "group", 
			name = filterType, 
			guiInline = true, 
			order = -10, 
			childGroups = "select", 
			args = {
				addSpellID = {
					order = 1, 
					name = L["Add SpellID"], 
					desc = L["Add a spell to the filter."], 
					type = "input", 
					get = function(e)return""end, 
					set = function(e, arg)
						if not tonumber(f)then 
							SuperVillain:AddonMessage(L["Value must be a number"])
						elseif not GetSpellInfo(f)then 
							SuperVillain:AddonMessage(L["Not valid spell id"])
						else 
							tinsert(SuperVillain.global.BuffWatch, {["enable"] = true, ["id"] = tonumber(f), ["point"] = "TOPRIGHT", ["color"] = {["r"] = 1, ["g"] = 0, ["b"] = 0}, ["anyUnit"] = false})
							generateFilterOptions()
							for t = 10, 40, 15 do 
								MOD:UpdateAuraWatchFromHeader("raid"..t)
							end;
							MOD:UpdateAuraWatchFromHeader("party")
							MOD:UpdateAuraWatchFromHeader("raidpet", true)
							selectedSpell = nil 
						end 
					end
				}, 
				removeSpellID = {
					order = 2, 
					name = L["Remove SpellID"], 
					desc = L["Remove a spell from the filter."], 
					type = "input", 
					get = function(e)return""end, 
					set = function(e, arg)
						if not tonumber(f)then 
							SuperVillain:AddonMessage(L["Value must be a number"])
						elseif not GetSpellInfo(f)then 
							SuperVillain:AddonMessage(L["Not valid spell id"])
						else 
							local p;
							for q, r in pairs(SuperVillain.global.BuffWatch)do 
								if r["id"] == tonumber(f)then 
									p = r;
									if G.BuffWatch[q]then 
										SuperVillain.global.BuffWatch[q].enable = false;
									else 
										SuperVillain.global.BuffWatch[q] = nil 
									end 
								end 
							end;
							if p == nil then 
								SuperVillain:AddonMessage(L["Spell not found in list."])
							else 
								generateFilterOptions()
							end 
						end;
						selectedSpell = nil;
						generateFilterOptions()
						for t = 10, 40, 15 do 
							MOD:UpdateAuraWatchFromHeader("raid"..t)
						end;
						MOD:UpdateAuraWatchFromHeader("party")
						MOD:UpdateAuraWatchFromHeader("raidpet", true)
					end
				}, 
				selectSpell = {
					name = L["Select Spell"], 
					type = "select", 
					order = 3, 
					values = function()
						local values = {}
						watchedBuffs = {}
						for o, f in pairs(SuperVillain.global.BuffWatch)do 
							tinsert(watchedBuffs, f)
						end;
						for o, l in pairs(watchedBuffs)do 
							if l.id then 
								local name = GetSpellInfo(l.id)
								values[l.id] = name 
							end 
						end;
						return values 
					end, 
					get = function(e)return selectedSpell end, 
					set = function(e, arg)selectedSpell = arg;generateFilterOptions()end
				}
			}
		}
		local registeredSpell;
		for t,l in pairs(SuperVillain.global.BuffWatch)do if l.id==selectedSpell then registeredSpell=t end end;
		if selectedSpell and registeredSpell then 
			local currentSpell=GetSpellInfo(selectedSpell)
			SuperVillain.Options.args.filters.args.filterGroup.args[currentSpell] = {
				name = currentSpell.." ("..selectedSpell..")", 
				type = "group", 
				get = function(e)return SuperVillain.global.BuffWatch[registeredSpell][e[#e]]end, 
				set = function(e, arg)
					SuperVillain.global.BuffWatch[registeredSpell][e[#e]] = arg;
					for t = 10, 40, 15 do 
						MOD:UpdateAuraWatchFromHeader("raid"..t)
					end;
					MOD:UpdateAuraWatchFromHeader("party")
					MOD:UpdateAuraWatchFromHeader("raidpet", true)
				end, 
				order = -10, 
				args = {
					enable = {name = L["Enable"], order = 0, type = "toggle"}, 
					point = {
						name = L["Anchor Point"], 
						order = 1, 
						type = "select", 
						values = {
							["TOPLEFT"] = "TOPLEFT", 
							["TOPRIGHT"] = "TOPRIGHT", 
							["BOTTOMLEFT"] = "BOTTOMLEFT", 
							["BOTTOMRIGHT"] = "BOTTOMRIGHT", 
							["LEFT"] = "LEFT", 
							["RIGHT"] = "RIGHT", 
							["TOP"] = "TOP", 
							["BOTTOM"] = "BOTTOM"
						}
					}, 
					xOffset = {order = 2, type = "range", name = L["xOffset"], min = -75, max = 75, step = 1}, 
					yOffset = {order = 2, type = "range", name = L["yOffset"], min = -75, max = 75, step = 1}, 
					style = {name = L["Style"], order = 3, type = "select", values = {["coloredIcon"] = L["Colored Icon"], ["texturedIcon"] = L["Textured Icon"], ["NONE"] = NONE}}, 
					color = {
						name = L["Color"], 
						type = "color", 
						order = 4, 
						get = function(e)
							local abColor = SuperVillain.global.BuffWatch[registeredSpell][e[#e]]
							return abColor.r,  abColor.g,  abColor.b,  abColor.a 
						end, 
						set = function(e, i, j, k)
							local abColor = SuperVillain.global.BuffWatch[registeredSpell][e[#e]]
							abColor.r,  abColor.g,  abColor.b = i, j, k;
							for t = 10, 40, 15 do 
								MOD:UpdateAuraWatchFromHeader("raid"..t)
							end;
							MOD:UpdateAuraWatchFromHeader("party")
							MOD:UpdateAuraWatchFromHeader("raidpet", true)
						end
					}, 
					displayText = {
						name = L["Display Text"], 
						type = "toggle", 
						order = 5
					}, 
					textColor = {
						name = L["Text Color"], 
						type = "color", 
						order = 6, 
						get = function(e)
							local abColor = SuperVillain.global.BuffWatch[registeredSpell][e[#e]]
							if abColor then 
								return abColor.r,  abColor.g,  abColor.b,  abColor.a 
							else 
								return 1, 1, 1, 1 
							end 
						end, 
						set = function(e, i, j, k)
							SuperVillain.global.BuffWatch[registeredSpell][e[#e]] = SuperVillain.global.BuffWatch[registeredSpell][e[#e]] or {}
							local abColor = SuperVillain.global.BuffWatch[registeredSpell][e[#e]]
							abColor.r,  abColor.g,  abColor.b = i, j, k;
							for t = 10, 40, 15 do 
								MOD:UpdateAuraWatchFromHeader("raid"..t)
							end;
							MOD:UpdateAuraWatchFromHeader("party")
							MOD:UpdateAuraWatchFromHeader("raidpet", true)
						end
					}, 
					textThreshold = {
						name = L["Text Threshold"], 
						desc = L["At what point should the text be displayed. Set to -1 to disable."], 
						type = "range", 
						order = 6, 
						min = -1, 
						max = 60, 
						step = 1
					}, 
					anyUnit = {
						name = L["Show Aura From Other Players"], 
						order = 7, 
						type = "toggle"
					}, 
					onlyShowMissing = {
						name = L["Show When Not Active"], 
						order = 8, 
						type = "toggle", 
						disabled = function()return SuperVillain.global.BuffWatch[registeredSpell].style == "text" end
					}
				}
			}
		end;
		watchedBuffs=nil 
	else 
		if not filterType or not SuperVillain.Filter[filterType]then 
			SuperVillain.Options.args.filters.args.filterGroup = nil;
			SuperVillain.Options.args.filters.args.spellGroup = nil;
			return 
		end;
		SuperVillain.Options.args.filters.args.filterGroup = {
			type = "group",
			name = filterType,
			guiInline = true,
			order = 10,
			args = {
				addSpell = {
					order = 1,
					name = L["Add Spell"],
					desc = L["Add a spell to the filter."],
					type = "input",
					get = function(e)return""end,
					set = function(e, arg)
						if not SuperVillain.Filter[filterType][arg]then 
							SuperVillain.Filter[filterType][arg] = {
								["enable"] = true,
								["priority"] = 0
							}
						end;
						generateFilterOptions()
						MOD:RefreshUnitFrames()
					end
				},
				removeSpell = {	
					order = 2,
					name = L["Remove Spell"],
					desc = L["Remove a spell from the filter."],
					type = "input",
					get = function(e)return""end,
					set = function(e, arg)
						if G.Filters[filterType] then 
							if G.Filters[filterType][arg] then 
								SuperVillain.Filter[filterType][arg].enable = false;
								SuperVillain:AddonMessage(L["You may not remove a spell from a default filter that is not customly added. Setting spell to false instead."])
							else 
								SuperVillain.Filter[filterType][arg] = nil 
							end 
						else 
							SuperVillain.Filter[filterType][arg] = nil 
						end;
						generateFilterOptions()
						MOD:RefreshUnitFrames()
					end
				},
				selectSpell = {	
					name = L["Select Spell"],
					type = "select",
					order = 3,
					guiInline = true,
					get = function(e)return selectedSpell end,
					set = function(e, arg)selectedSpell = arg;generateFilterOptions()end,
					values = function()
						local filters = {}
						local list = SuperVillain.Filter[filterType]
						filters[""] = NONE;
						for g in pairs(list)do
							filters[g] = g 
						end;
						return filters 
					end
				}
			}
		}

		if not selectedSpell or not SuperVillain.Filter[filterType][selectedSpell]then 
			SuperVillain.Options.args.filters.args.spellGroup = nil;
			return 
		end;

		SuperVillain.Options.args.filters.args.spellGroup = {
			type = "group", 
			name = selectedSpell, 
			order = 15, 
			guiInline = true, 
			args = {
				enable = {
					name = L["Enable"], 
					type = "toggle", 
					get = function()
						if selectedFolder or not selectedSpell then 
							return false 
						else 
							return SuperVillain.Filter[filterType][selectedSpell].enable 
						end 
					end, 
					set = function(e, arg)
						SuperVillain.Filter[filterType][selectedSpell].enable = arg;
						generateFilterOptions()
						MOD:RefreshUnitFrames()
					end
				}, 
				priority = {
					name = L["Priority"], 
					type = "range", 
					get = function()
						if selectedFolder or not selectedSpell then 
							return 0 
						else 
							return SuperVillain.Filter[filterType][selectedSpell].priority 
						end 
					end, 
					set = function(e, arg)
						SuperVillain.Filter[filterType][selectedSpell].priority = arg;
						generateFilterOptions()
						MOD:RefreshUnitFrames()
					end, 
					min = 0, 
					max = 99, 
					step = 1, 
					desc = L["Set the priority order of the spell, please note that prioritys are only used for the raid debuff package, not the standard buff/debuff package. If you want to disable set to zero."]
				}
			}
		}
	end;
	MOD:RefreshUnitFrames()
end;
SuperVillain.Options.args.filters = {
	type = "group",
	name = L["Filters"],
	order = -10,
	args = {	
		createFilter = {	
			order = 1,
			name = L["Create Filter"],
			desc = L["Create a filter, once created a filter can be set inside the buffs/debuffs section of each unit."],
			type = "input",
			get = function(e)return""end,
			set = function(e, arg)
				SuperVillain.Filter[arg] = {}
				SuperVillain.Filter[arg]["spells"] = {}
			end
		},
		deleteFilter = {
			type = "select",
			order = 2,
			name = L["Delete Filter"],
			desc = L["Delete a created filter, you cannot delete pre-existing filters, only custom ones."],
			get = function(e)return""end,
			set = function(e, arg)
				if G.Filters[arg] then 
					SuperVillain:AddonMessage(L["You can't remove a pre-existing filter."])
				else 
					SuperVillain.Filter[arg] = nil;
					filterType = nil;
					selectedSpell = nil;
					SuperVillain.Options.args.filters.args.filterGroup = nil 
				end 
			end,
			values = function()
				filters = {}
				filters[""] = NONE;
				for g in pairs(SuperVillain.global.Filters) do
					if not G.Filters[g]then
						filters[g] = g
					end  
				end;
				return filters 
			end
		},
		selectFilter = {
			order = 3,
			type = "select",
			name = L["Select Filter"],
			get = function(e)return filterType end,
			set = function(e, arg)
				if arg == "" then 
					filterType = nil;
					selectedSpell = nil 
				else 
					filterType = arg 
				end; 
				generateFilterOptions() 
			end,
			values = function()
				filters = {}
				filters[""] = NONE;
				for g in pairs(SuperVillain.global.Filters) do 
					filters[g] = g 
				end;
				filters["Buff Indicator"] = "Buff Indicator"
				filters["Buff Indicator (Pet)"] = "Buff Indicator (Pet)"
				filters["AuraBar Colors"] = "AuraBar Colors"
				return filters 
			end
		}
	}
}

local aceConfig = LibStub("AceConfigDialog-3.0")

function SuperVillain:SetToFilterConfig(newFilter)
	filterType = newFilter or "Buff Indicator"
	generateFilterOptions()
	aceConfig:SelectGroup("SVUI", "filters")
end
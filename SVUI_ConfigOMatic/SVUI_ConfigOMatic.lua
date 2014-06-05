﻿--[[
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
local Ace3Config = LibStub("AceConfig-3.0");
local Ace3ConfigDialog = LibStub("AceConfigDialog-3.0");
Ace3Config:RegisterOptionsTable("SVUI", SuperVillain.Options);
Ace3ConfigDialog:SetDefaultSize("SVUI", 890, 651);
local AceGUI = LibStub("AceGUI-3.0", true);
local posOpts={TOPLEFT='TOPLEFT',LEFT='LEFT',BOTTOMLEFT='BOTTOMLEFT',RIGHT='RIGHT',TOPRIGHT='TOPRIGHT',BOTTOMRIGHT='BOTTOMRIGHT',CENTER='CENTER',TOP='TOP',BOTTOM='BOTTOM'};
local GEAR = SuperVillain:GetModule('SVGear');
local BAG = SuperVillain:GetModule('SVBag');
local sortingFunction = function(arg1, arg2) return arg1 < arg2 end;
--[[ 
########################################################## 
SET PACKAGE OPTIONS
##########################################################
]]--
SuperVillain.Options.args = {
	SVUI_Header = {
		order = 1, 
		type = "header", 
		name = "You are using |cffff9900Super Villain UI|r - "..L["Version"]..format(": |cff99ff33%s|r", SuperVillain.version), 
		width = "full"
	}
};

SuperVillain.Options.args.primary = {
	type = "group", 
	order = 1, 
	name = L["Main"], 
	get = function(j)return SuperVillain.db.common[j[#j]]end, 
	set = function(j, value)SuperVillain.db.common[j[#j]] = value end, 
	args = {
		introGroup1 = {
			order = 1, 
			name = "", 
			type = "description", 
			width = "full", 
			image = function()return "Interface\\AddOns\\SVUI\\assets\\artwork\\SPLASH", 256, 128 end, 
		}, 
		introGroup2 = {
			order = 2, 
			name = L["Here are a few basic quick-change options to possibly save you some time."], 
			type = "description", 
			width = "full", 
			fontSize = "large", 
		}, 
		quickGroup1 = {
			order = 3, 
			name = "", 
			type = "group", 
			width = "full", 
			guiInline = true, 
			args = {
				Install = {
					order = 3, 
					width = "full", 
					type = "execute", 
					name = L["Install"], 
					desc = L["Run the installation process."], 
					func = function() SuperVillain:Install()SuperVillain:ToggleConfig() end
				},
				ToggleAnchors = {
					order = 4, 
					width = "full", 
					type = "execute", 
					name = L["Move Frames"], 
					desc = L["Unlock various elements of the UI to be repositioned."], 
					func = function() SuperVillain:UseMentalo() end
				},
				ResetAllMovers = {
					order = 5, 
					width = "full", 
					type = "execute", 
					name = L["Reset Anchors"], 
					desc = L["Reset all frames to their original positions."], 
					func = function() SuperVillain:ResetUI() end
				},
				toggleKeybind = {
					order = 6, 
					width = "full", 
					type = "execute", 
					name = L["Keybind Mode"], 
					func = function()
						SuperVillain:GetModule("SVBar"):ToggleKeyBindingMode()
						SuperVillain:ToggleConfig()
						GameTooltip:Hide()
					end, 
					disabled = function() return not SuperVillain.protected.SVBar.enable end
				}
			}, 
		}, 
		quickGroup2 = {
			order = 4, 
			name = "", 
			type = "group", 
			width = "full", 
			guiInline = true, 
			args = {}, 
		}, 	
	}
};

SuperVillain.Options.args.common = {
	type = "group", 
	order = 2, 
	name = L["General"], 
	childGroups = "tab", 
	get = function(j)return SuperVillain.db.common[j[#j]]end, 
	set = function(j, value)SuperVillain.db.common[j[#j]] = value end, 
	args = {
		commonGroup = {
			order = 1, 
			type = 'group', 
			name = L['General Options'], 
			childGroups = "tree", 
			args = {
				common = {
					order = 2, 
					type = "group", 
					name = L["Basic"], 
					args = {
						autoScale = {
							order = 5,
							name = L["Auto Scale"],
							desc = L["Automatically scale the User Interface based on your screen resolution"],
							type = "toggle",
							get = function(j)return SuperVillain.global.common.autoScale end,
							set = function(j,value)SuperVillain.global.common.autoScale = value;SuperVillain:StaticPopup_Show("RL_CLIENT")end
						},
						loot = {
							order = 6,
							type = "toggle",
							name = L['Loot'],
							desc = L['Enable/Disable the loot frame.'],
							get = function(j)return SuperVillain.protected.SVOverride.loot end,
							set = function(j,value)SuperVillain.protected.SVOverride.loot = value;SuperVillain:StaticPopup_Show("RL_CLIENT")end
						},
						lootRoll = {
							order = 7,
							type = "toggle",
							name = L['Loot Roll'],
							desc = L['Enable/Disable the loot roll frame.'],
							get = function(j)return SuperVillain.protected.SVOverride.lootRoll end,
							set = function(j,value)SuperVillain.protected.SVOverride.lootRoll = value;SuperVillain:StaticPopup_Show("RL_CLIENT")end
						},
						comixEnabled = {
							order = 8,
							type = 'toggle',
							name = L["Enable Comic Popups"],
							get = function(j)return SuperVillain.protected.scripts.comix end,
							set = function(j,value)SuperVillain.protected.scripts.comix = value;SuperVillain:ToggleComix()end
						},
						chatBubbles = {
							order = 9,
							type = "toggle",
							width = "full",
							name = L['Chat Bubbles Style'],
							desc = L['Style the blizzard chat bubbles.'],
							get = function(j)return SuperVillain.protected.scripts.bubbles end,
							set = function(j,value)SuperVillain.protected.scripts.bubbles = value;SuperVillain:StaticPopup_Show("RL_CLIENT")end
						},
						hideErrorFrame = {
							order = 11,
							name = L["Hide Error Text"],
							desc = L["Hides the red error text at the top of the screen while in combat."],
							type = "toggle",
							get = function(j)return SuperVillain.protected.common.hideErrorFrame end,
							set = function(j,value)SuperVillain.protected.common.hideErrorFrame = value;SuperVillain:StaticPopup_Show("RL_CLIENT")end
						},
						movertransparancy = {
							order = 13,
							type = 'range',
							isPercent = true,
							name = L["Mover Transparency"],
							desc = L["Changes the transparency of all the moveables."],
							min = 0,
							max = 1,
							step = 0.01,
							set = function(j,value)SuperVillain.db.common.MoverAlpha = value;SuperVillain:GetModule('Misc'):UpdateMoverTransparancy()end,
							get = function(j)return SuperVillain.db.common.MoverAlpha end
						},
						LoginMessage = {
							order = 14,
							type = 'toggle',
							name = L['Login Message'],
							get = function(j)return SuperVillain.protected.common.loginmessage end,
							set = function(j,value)SuperVillain.protected.common.loginmessage = value end
						},
					}
				}, 
				media = {
					order = 3,
					type = "group", 
					name = L["Media"], 
					get = function(j)return SuperVillain.db.common[j[#j]]end, 
					set = function(j, value)SuperVillain.db.common[j[#j]] = value end, 
					args = {
						texture = {
							order = 1, 
							type = "group", 
							name = L["Textures"], 
							guiInline = true,
							get = function(key)
								return SuperVillain.db.media.textures[key[#key]][2]
							end,
							set = function(key, value)
								SuperVillain.db.media.textures[key[#key]] = {"background", value}
								SuperVillain:Refresh_SVUI_System(true)
							end,
							args = {
								pattern = {
									type = "select",
									dialogControl = 'LSM30_Background',
									order = 1,
									name = L["Primary Texture"],
									values = AceGUIWidgetLSMlists.background
								},
								comic = {
									type = "select",
									dialogControl = 'LSM30_Background',
									order = 1,
									name = L["Secondary Texture"],
									values = AceGUIWidgetLSMlists.background
								}						
							}
						}, 
						fonts = {
							order = 2, 
							type = "group", 
							name = L["Fonts"], 
							guiInline = true, 
							args = {
								fontSize = {
									order = 1,
									name = L["Font Size"],
									desc = L["Set/Override the global UI font size. |cffFF0000NOTE:|r |cffFF9900This WILL affect configurable fonts.|r"],
									type = "range",
									width = "full",
									min = 6,
									max = 22,
									step = 1,
									set = function(j,value)SuperVillain.db.common[j[#j]] = value;SuperVillain:FontSizeUpdate()end
								},
								unicodeFontSize = {
									order = 2,
									name = L["Unicode Font Size"],
									desc = L["Set/Override the global font size used by unstyled text. |cffFF0000(ie, Character stats, tooltips, other smaller texts)|r"],
									type = "range",
									width = "full",
									min = 6,
									max = 22,
									step = 1,
									set = function(j,value)SuperVillain.db.common[j[#j]] = value;SuperVillain:FontSizeUpdate()end
								},
								font = {
									type = "select",
									dialogControl = 'LSM30_Font',
									order = 3,
									name = L["Default Font"],
									desc = L["Set/Override the global UI font. |cff00FF00NOTE:|r |cff00FF99This WILL NOT affect configurable fonts.|r"],
									values = AceGUIWidgetLSMlists.font,
									get = function(j)return SuperVillain.protected.common[j[#j]]end,
									set = function(j,value)SuperVillain.protected.common[j[#j]] = value;SuperVillain:Refresh_SVUI_Media()end
								},
								nameFont = {
									type = "select",
									dialogControl = 'LSM30_Font',
									order = 4,
									name = L["Unit Name Font"],
									desc = L["Set/Override the global name font. |cff00FF00NOTE:|r |cff00FF99This WILL NOT affect styled nameplates or unitframes.|r"],
									values = AceGUIWidgetLSMlists.font,
									get = function(j)return SuperVillain.protected.common[j[#j]]end,
									set = function(j,value)SuperVillain.protected.common[j[#j]] = value;SuperVillain:Refresh_SVUI_Media()end
								},
								combatFont = {
									type = "select",
									dialogControl = 'LSM30_Font',
									order = 5,
									name = L["CombatText Font"],
									desc = L["Set/Override the font that combat text will use. |cffFF0000NOTE:|r |cffFF9900This requires a game restart or re-log for this change to take effect.|r"],
									values = AceGUIWidgetLSMlists.font,
									get = function(j)return SuperVillain.protected.common[j[#j]]end,
									set = function(j,value)SuperVillain.protected.common[j[#j]] = value;SuperVillain:Refresh_SVUI_Media()SuperVillain:StaticPopup_Show("RL_CLIENT")end
								},
								numberFont = {
									type = "select",
									dialogControl = 'LSM30_Font',
									order = 6,
									name = L["Numbers Font"],
									desc = L["Set/Override the global font used for numbers. |cff00FF00NOTE:|r |cff00FF99This WILL NOT affect all numbers.|r"],
									values = AceGUIWidgetLSMlists.font,
									get = function(j)return SuperVillain.protected.common[j[#j]]end,
									set = function(j,value)SuperVillain.protected.common[j[#j]] = value;SuperVillain:Refresh_SVUI_Media()end
								},					
							}
						}, 
						colors = {
							order = 3, 
							type = "group", 
							name = L["Colors"], 
							guiInline = true,
							get = function(key)
								local color = SuperVillain.db.media.colors[key[#key]]
								return color.r,color.g,color.b,color.a 
							end,
							set = function(key, rValue, gValue, bValue, aValue)
								SuperVillain.db.media.colors[key[#key]] = {r = rValue, g = gValue, b = bValue, a = aValue}
								SuperVillain:Refresh_SVUI_Media()
							end,
							args = {
								default = {
									type = "color",
									order = 1,
									name = L["Default Color"],
									desc = L["Main color used by most UI elements. (ex: Backdrop Color)"],
									hasAlpha = false
								},
								special = {
									type = "color",
									order = 2,
									name = L["Accent Color"],
									desc = L["Color used in various frame accents.  (ex: Dressing Room Backdrop Color)"],
									hasAlpha = true
								},
								resetbutton = {
									type = "execute",
									order = 3,
									name = L["Restore Defaults"],
									func = function()
										SuperVillain.db.media.colors.default = {r = 0.15, g = 0.15, b = 0.15, a = 1};
										SuperVillain.db.media.colors.special = {r = 0.4, g = 0.32, b = 0.2, a = 1};
										SuperVillain:Refresh_SVUI_Media()
										SuperVillain:UpdateFrameTemplates()
									end
								}
							}
						}
					}
				}, 
				threat = {
					order = 7, 
					type = "group", 
					name = L['Threat Thermometer'], 
					args = {
						enable = {order = 1, type = "toggle", name = L["Enable"], get = function(j)return SuperVillain.protected.common.threatbar end, set = function(j, value)SuperVillain.protected.common.threatbar = value;SuperVillain:StaticPopup_Show("RL_CLIENT")end}
					}
				}, 
				totems = {
					order = 8, 
					type = "group", 
					name = L["Totems"], 
					get = function(j)
						return SuperVillain.db.scripts.totems[j[#j]]
					end, 
					set = function(j, value) 
						SuperVillain.db.scripts.totems[j[#j]] = value;
						SuperVillain:UpdateTotems()
					end, 
					args = {
						enable = {
							order = 1, 
							type = "toggle", 
							name = L["Enable"], 
							get = function(j)
								return SuperVillain.protected.scripts.totems 
							end, 
							set = function(j, value)
								SuperVillain.protected.scripts.totems = value;
								SuperVillain:StaticPopup_Show("RL_CLIENT")
							end
						},
						size = {
							order = 2, 
							type = 'range', 
							name = L["Button Size"], 
							min = 24, 
							max = 60, 
							step = 1
						},
						spacing = {
							order = 3, 
							type = 'range', 
							name = L['Button Spacing'], 
							min = 1, 
							max = 10, 
							step = 1
						},
						sortDirection = {
							order = 4, 
							type = 'select', 
							name = L["Sort Direction"], 
							values = {
								['ASCENDING'] = L['Ascending'], 
								['DESCENDING'] = L['Descending']
							}
						},
						showBy = {
							order = 5, 
							type = 'select', 
							name = L['Bar Direction'], 
							values = {
								['VERTICAL'] = L['Vertical'], 
								['HORIZONTAL'] = L['Horizontal']
							}
						}
					}
				}, 
				cooldown = {
					type = "group", 
					order = 10, 
					name = L['Cooldown Text'], 
					get = function(j)local k = SuperVillain.db.common.cooldown[j[#j]]return k.r, k.g, k.b, k.a end, 
					set = function(j, l, m, n)SuperVillain.db.common.cooldown[j[#j]] = {}local k = SuperVillain.db.common.cooldown[j[#j]]k.r, k.g, k.b = l, m, n;SuperVillain:UpdateCooldownSettings()end, 
					args = {
						enable = {
							type = "toggle", 
							order = 1, 
							name = L["Enable"], 
							desc = L["Display cooldown text on anything with the cooldown spiril."], 
							get = function(j)return SuperVillain.protected.common.cooldown[j[#j]]end, 
							set = function(j,value)SuperVillain.protected.common.cooldown[j[#j]] = value;SuperVillain:StaticPopup_Show("RL_CLIENT")end
						},
						threshold = {
							type = "range", 
							name = L["Low Threshold"], 
							desc = L["Threshold before text turns red and is in decimal form. Set to -1 for it to never turn red"], 
							min = -1, 
							max = 20, 
							step = 1, 
							order = 2, 
							get = function(j)return SuperVillain.db.common.cooldown[j[#j]]end, 
							set = function(j,value)SuperVillain.db.common.cooldown[j[#j]] = value;SuperVillain:UpdateCooldownSettings()end
						}
					}
				},
				gear={
					order = 11,
					type = 'group',
					name = L['Gear Managment'],
					get = function(a)return SuperVillain.db.SVGear[a[#a]]end,
					set = function(a,b)SuperVillain.db.SVGear[a[#a]]=b;GEAR:RefreshGear()end,
					args={
						intro={
							order=1,
							type='description',
							name=L["EQUIPMENT_DESC"]
						},
						specialization={
							order=2,
							type="group",
							name=L["Specialization"],
							guiInline=true,
							disabled=function()return GetNumEquipmentSets()==0 end,
							args={
								enable={
									type="toggle",
									order=1,
									name=L["Enable"],
									desc=L['Enable/Disable the specialization switch.'],
									get=function(e)return SuperVillain.db.SVGear.specialization.enable end,
									set=function(e,value)SuperVillain.db.SVGear.specialization.enable=value end
								},
								primary={
									type="select",
									order=2,
									name=L["Primary Talent"],
									desc=L["Choose the equipment set to use for your primary specialization."],
									disabled=function()return not SuperVillain.db.SVGear.specialization.enable end,
									values=function()
										local h={["none"]=L["No Change"]}
										for i=1,GetNumEquipmentSets()do 
											local name=GetEquipmentSetInfo(i)
											if name then h[name]=name end 
										end;
										tsort(h,sortingFunction)
										return h 
									end
								},
								secondary={
									type="select",
									order=3,
									name=L["Secondary Talent"],
									desc=L["Choose the equipment set to use for your secondary specialization."],
									disabled=function()return not SuperVillain.db.SVGear.specialization.enable end,
									values=function()
										local h={["none"]=L["No Change"]}
										for i=1,GetNumEquipmentSets()do 
											local name,l,l,l,l,l,l,l,l=GetEquipmentSetInfo(i)
											if name then h[name]=name end 
										end;
										tsort(h,sortingFunction)
										return h 
									end
								}

							}
						},
						battleground = {
							order = 3,
							type = "group",
							name = L["Battleground"],
							guiInline = true,
							disabled = function()return GetNumEquipmentSets() == 0 end,
							args = {
								enable = {
									type = "toggle",
									order = 1,
									name = L["Enable"],
									desc = L["Enable/Disable the battleground switch."],
									get = function(e)return SuperVillain.db.SVGear.battleground.enable end,
									set = function(e,value)SuperVillain.db.SVGear.battleground.enable = value end
								},
								equipmentset = {
									type = "select",
									order = 2,
									name = L["Equipment Set"],
									desc = L["Choose the equipment set to use when you enter a battleground or arena."],
									disabled = function()return not SuperVillain.db.SVGear.battleground.enable end,
									values = function()
										local h = {["none"] = L["No Change"]}
										for i = 1,GetNumEquipmentSets()do 
											local name = GetEquipmentSetInfo(i)
											if name then h[name] = name end 
										end;
										tsort(h,sortingFunction)
										return h 
									end
								}
							}
						},
						intro2 = {
							type = "description",
							name = L["DURABILITY_DESC"],
							order = 4
						},
						durability = {
							type = "group",
							name = DURABILITY,
							guiInline = true,
							order = 5,
							get = function(e)return SuperVillain.db.SVGear.durability[e[#e]]end,
							set = function(e,value)SuperVillain.db.SVGear.durability[e[#e]] = value;GEAR:RefreshGear()end,
							args = {
								enable = {
									type = "toggle",
									order = 1,
									name = L["Enable"],
									desc = L["Enable/Disable the display of durability information on the character screen."]
								},
								onlydamaged = {
									type = "toggle",
									order = 2,
									name = L["Damaged Only"],
									desc = L["Only show durability information for items that are damaged."],
									disabled = function()return not SuperVillain.db.SVGear.durability.enable end
								}
							}
						},
						intro3 = {
							type = "description",
							name = L["ITEMLEVEL_DESC"],
							order = 6
						},
						itemlevel = {
							type = "group",
							name = STAT_AVERAGE_ITEM_LEVEL,
							guiInline = true,
							order = 7,
							get = function(e)return SuperVillain.db.SVGear.itemlevel[e[#e]]end,
							set = function(e,value)SuperVillain.db.SVGear.itemlevel[e[#e]] = value;GEAR:RefreshGear()end,
							args = {
								enable = {
									type = "toggle",
									order = 1,
									name = L["Enable"],
									desc = L["Enable/Disable the display of item levels on the character screen."]
								}
							}
						},
						misc = {
							type = "group",
							name = L["Miscellaneous"],
							guiInline = true,
							order = 8,
							get = function(e)return SuperVillain.db.SVGear.misc[e[#e]]end,
							set = function(e,value)SuperVillain.db.SVGear.misc[e[#e]] = value end,
							disabled = function()return not SuperVillain.protected.SVBag.enable end,
							args = {
								setoverlay = {
									type = "toggle",
									order = 1,
									name = L["Equipment Set Overlay"],
									desc = L["Show the associated equipment sets for the items in your bags (or bank)."],
									set = function(e,value)
										SuperVillain.db.SVGear.misc[e[#e]] = value;
										BAG:ToggleEquipmentOverlay()
									end
								}
							}
						}
					}
				} 
			}, 
		}, 
	}
};

local q, r, dnt = "", "", "";
local s = "\n";
local p = "\n"..format("|cff4f4f4f%s|r", "---------------------------------------------");
local t = {"Munglunch", "Elv", "Tukz", "Azilroka", "Sortokk", "AlleyKat", "Quokka", "Haleth", "P3lim", "Haste", "Totalpackage", "Kryso", "Thepilli"};
local u = {"Wowinterface Community", "Doonga - (The man who keeps me busy)", "Judicate", "Cazart506", "Movster", "MuffinMonster", "Joelsoul", "Trendkill09", "Luamar", "Zharooz", "Lyn3x5", "Madh4tt3r", "Xarioth", "Sinnisterr", "Melonmaniac", "Hojowameeat", "Xandeca", "Bkan", "Daigan - (My current 2nd in command)", "AtomicKiller", "Meljen", "Moondoggy", "Stormblade", "Schreibstift", "Anj", "Risien"};
local v = {"Movster", "Cazart506", "Other Silent Partners.."};
local credit_header = format("|cffff9900%s|r", "SUPERVILLAIN CREDITS:")..p;
local credit_sub = format("|cffff9900%s|r", "CREATED BY:").."  Munglunch"..p;
local credit_sub2 = format("|cffff9900%s|r", "USING ORIGINAL CODE BY:").."  Elv, Tukz, Azilroka, Sortokk"..p;
local special_thanks = format("|cffff9900%s|r", "A VERY SPECIAL THANKS TO:  ")..format("|cffffff00%s|r", "Movster").."  ..who inspired me to bring this project back to life!"..p;
local coding = format("|cff3399ff%s|r", L['CODE MONKEYS  (aka ORIGINAL AUTHORS):'])..p;
local testing = format("|cffaa33ff%s|r", L['PERFECTIONISTS  (aka TESTERS):'])..p;
local doners = format("|cff99ff33%s|r", L['KINGPINS  (aka INVESTORS):'])..p;

tsort(t, function(o,n) return o < n end)
for _, x in pairs(t) do
	q = q..s..x 
end;
tsort(u, function(o,n) return o < n end)
for _, y in pairs(u) do
	r = r..s..y 
end;
tsort(u, function(o,n) return o < n end)
for _, z in pairs(v) do
	dnt = dnt..s..z 
end;

local creditsString = credit_header..'\n'..credit_sub..'\n'..credit_sub2..'\n'..special_thanks..'\n\n'..coding..q..'\n\n'..testing..r..'\n\n'..doners..dnt..'\n\n';

SuperVillain.Options.args.credits = {
	type = "group", 
	name = L["Credits"], 
	order = -1, 
	args = {
		new = {
			order = 1, 
			type = "description", 
			name = creditsString
		}
	}
}

SuperVillain.Options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(SuperVillain.data)
Ace3Config:RegisterOptionsTable("SVProfiles", SuperVillain.Options.args.profiles)
SuperVillain.Options.args.profiles.order = -10;

LibStub('LibDualSpec-1.0'):EnhanceOptions(SuperVillain.Options.args.profiles, SuperVillain.data)
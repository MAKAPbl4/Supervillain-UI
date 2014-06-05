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
local _, ns = ...
local oUF_SuperVillain = ns.oUF
local ACD = LibStub("AceConfigDialog-3.0")
--[[
##################################################################################################
##################################################################################################
##################################################################################################
]]
SuperVillain.Options.args.SVUnit.args.player={
	name = L['Player Frame'],
	type = 'group',
	order = 300,
	childGroups = "tab",
	get = function(l)return SuperVillain.db.SVUnit['player'][l[#l]]end,
	set = function(l,m)MOD:ChangeDBVar(m, l[#l], "player");MOD:SetBasicFrame('player')end,
	args = {
		enable = {
			type = 'toggle',
			order = 1,
			name = L['Enable']
		},
		resetSettings = {
			type = 'execute',
			order = 2,
			name = L['Restore Defaults'],
			func = function(l,m)
				MOD:ResetUnitOptions('player')
				SuperVillain:ResetMovables('Player Frame')
			end
		},
		tabGroups = {
			order = 3,
			type = 'group',
			name = L['Unit Options'],
			childGroups = "tree",
			args = {
				commonGroup = {
					order = 1,
					type = 'group',
					name = L['General Settings'],
					args = {
						showAuras = {
							order = 3,
							type = "execute",
							name = L["Show Auras"],
							func = function()local U = SVUI_Player;if U.forceShowAuras then U.forceShowAuras = nil else U.forceShowAuras = true end;MOD:SetBasicFrame("player")end
						},
						width = {
							order = 4,
							name = L["Width"],
							type = "range",
							min = 50,
							max = 500,
							step = 1,
							set = function(l, m)
								if SuperVillain.db.SVUnit["player"].castbar.width == SuperVillain.db.SVUnit["player"][l[#l]] then 
									SuperVillain.db.SVUnit["player"].castbar.width = m 
								end;
								MOD:ChangeDBVar(m, l[#l], "player");
								MOD:SetBasicFrame("player")
							end
						},
						height = {
							order = 5,
							name = L["Height"],
							type = "range",
							min = 10,
							max = 250,
							step = 1
						},
						lowmana = {
							order = 6,
							name = L["Low Mana Threshold"],
							desc = L["When you mana falls below this point, text will flash on the player frame."],
							type = "range",
							min = 0,
							max = 100,
							step = 1
						},
						combatfade = {
							order = 7,
							name = L["Combat Fade"],
							desc = L["Fade the unitframe when out of combat, not casting, no target exists."],
							type = "toggle",
							set = function(l, m)
								MOD:ChangeDBVar(m, l[#l], "player");
								MOD:SetBasicFrame("player")
								if m == true then 
									SVUI_Pet:SetParent(SVUI_Player)
								else 
									SVUI_Pet:SetParent(SVUI_Parent)
								end 
							end
						},
						predict = {
							order = 8,
							name = L["Heal Prediction"],
							desc = L["Show a incomming heal prediction bar on the unitframe. Also display a slightly different colored bar for incoming overheals."],
							type = "toggle"
						},
						restIcon = {
							order = 9,
							name = L["Rest Icon"],
							desc = L["Display the rested icon on the unitframe."],
							type = "toggle"
						},
						hideonnpc = {
							type = "toggle",
							order = 10,
							name = L["Text Toggle On NPC"],
							desc = L["Power text will be hidden on NPC targets, in addition the name text will be repositioned to the power texts anchor point."],
							get = function(l)return SuperVillain.db.SVUnit["player"]["power"].hideonnpc end,
							set = function(l, m)SuperVillain.db.SVUnit["player"]["power"].hideonnpc = m;MOD:SetBasicFrame("player")end
						},
						threatEnabled = {
							type = "toggle",
							order = 11,
							name = L["Show Threat"]
						},
						playerExpBar = {
							order = 12,
							name = "Playerframe Experience Bar",
							desc = "Show player experience on power bar mouseover",
							type = "toggle",
							set = function(l, m)MOD:ChangeDBVar(m, l[#l], "player");SuperVillain:StaticPopup_Show("RL_CLIENT")end
						},
						playerRepBar = {
							order = 13,
							name = "Playerframe Reputation Bar",
							desc = "Show player reputations on power bar mouseover",
							type = "toggle",
							set = function(l, m)MOD:ChangeDBVar(m, l[#l], "player");SuperVillain:StaticPopup_Show("RL_CLIENT")end
						},
					}
				},
				health = MOD:SetHealthConfigGroup(false, MOD.SetBasicFrame, "player"), 
				power = MOD:SetPowerConfigGroup(true, MOD.SetBasicFrame, "player"), 
				name = MOD:SetNameConfigGroup(MOD.SetBasicFrame, "player"), 
				portrait = MOD:SetPortraitConfigGroup(MOD.SetBasicFrame, "player"), 
				buffs = MOD:SetAuraConfigGroup(true, "buffs", false, MOD.SetBasicFrame, "player"), 
				debuffs = MOD:SetAuraConfigGroup(true, "debuffs", false, MOD.SetBasicFrame, "player"), 
				castbar = MOD:SetCastbarConfigGroup(true, MOD.SetBasicFrame, "player"), 
				aurabar = MOD:SetAurabarConfigGroup(true, MOD.SetBasicFrame, "player"), 
				icons = MOD:SetIconConfigGroup(MOD.SetBasicFrame, "player"), 
				classbar = {
					order = 1000,
					type = "group",
					name = L["Classbar"],
					get = function(l)return SuperVillain.db.SVUnit["player"]["classbar"][l[#l]]end,
					set = function(l, m)MOD:ChangeDBVar(m, l[#l], "player", "classbar");MOD:SetBasicFrame("player")end,
					args = {
						enable = {
							type = "toggle",
							order = 1,
							name = L["Enable"]
						},
						height = {
							type = "range",
							order = 2,
							name = L["Height"],
							min = 15,
							max = 45,
							step = 1
						},
						slideLeft = {
							type = "toggle",
							order = 3,
							name = L["Slide Left"]
						},
						detachFromFrame = {
							type = "toggle",
							order = 4,
							name = L["Detach From Frame"]
						},
						detachedWidth = {
							type = "range",
							order = 5,
							name = L["Detached Width"],
							disabled = function()return not SuperVillain.db.SVUnit["player"]["classbar"].detachFromFrame end,
							min = 15,
							max = 450,
							step = 1
						}
					}
				},
				pvp = {
					order = 450,
					type = "group",
					name = PVP,
					get = function(l)return SuperVillain.db.SVUnit["player"]["pvp"][l[#l]]end,
					set = function(l, m)MOD:ChangeDBVar(m, l[#l], "player", "pvp");MOD:SetBasicFrame("player")end,
					args = {
						position = {
							type = "select",
							order = 2,
							name = L["Position"],
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
						text_format = {
							order = 100,
							name = L["Text Format"],
							type = "input",
							width = "full",
							desc = L["TEXT_FORMAT_DESC"]
						}
					}
				},
				stagger = {
					order = 1400,
					type = "group",
					name = L["Stagger Bar"],
					get = function(l)return SuperVillain.db.SVUnit["player"]["stagger"][l[#l]]end,
					set = function(l, m)MOD:ChangeDBVar(m, l[#l], "player", "stagger");MOD:SetBasicFrame("player")end,
					disabled = SuperVillain.class ~= "MONK",
					args = {
						enable = {
							type = "toggle",
							order = 1,
							name = L["Enable"]
						}
					}
				}
			}
		}
	}
}
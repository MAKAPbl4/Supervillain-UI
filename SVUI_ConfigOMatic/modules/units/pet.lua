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
SuperVillain.Options.args.SVUnit.args.pet = {
	name = L["Pet Frame"], 
	type = "group", 
	order = 800, 
	childGroups = "select", 
	get = function(l)return SuperVillain.db.SVUnit["pet"][l[#l]]end, 
	set = function(l, m)MOD:ChangeDBVar(m, l[#l], "pet");MOD:SetBasicFrame("pet")end, 
	args = {
		enable = {type = "toggle", order = 1, name = L["Enable"]}, 
		resetSettings = {type = "execute", order = 2, name = L["Restore Defaults"], func = function(l, m)MOD:ResetUnitOptions("pet")SuperVillain:ResetMovables("Pet Frame")end}, 
		tabGroups = {
			order = 3, 
			type = "group", 
			name = L["Unit Options"], 
			childGroups = "tree", 
			args = {
				commonGroup = {
					order = 1, 
					type = "group", 
					name = L["General Settings"], 
					args = {
						showAuras = {
							order = 3, 
							type = "execute", 
							name = L["Show Auras"], 
							func = function()local U = SVUI_Pet;if U.forceShowAuras then U.forceShowAuras = nil else U.forceShowAuras = true end;MOD:SetBasicFrame("pet")end
						}, 
						width = {order = 4, name = L["Width"], type = "range", min = 50, max = 500, step = 1}, 
						height = {order = 5, name = L["Height"], type = "range", min = 10, max = 250, step = 1}, 
						rangeCheck = {
							order = 6, 
							name = L["Range Check"], 
							desc = L["Check if you are in range to cast spells on this specific unit."], 
							type = "toggle"
						}, 
						predict = {
							order = 7, 
							name = L["Heal Prediction"], 
							desc = L["Show a incomming heal prediction bar on the unitframe. Also display a slightly different colored bar for incoming overheals."], 
							type = "toggle"
						}, 
						hideonnpc = {
							type = "toggle", 
							order = 10, 
							name = L["Text Toggle On NPC"], 
							desc = L["Power text will be hidden on NPC targets, in addition the name text will be repositioned to the power texts anchor point."], 
							get = function(l)return SuperVillain.db.SVUnit["pet"]["power"].hideonnpc end, 
							set = function(l, m)SuperVillain.db.SVUnit["pet"]["power"].hideonnpc = m;MOD:SetBasicFrame("pet")end
						}, 
						threatEnabled = {type = "toggle", order = 13, name = L["Show Threat"]
						}, 
						buffIndicator = {
							order = 600, 
							type = "group", 
							name = L["Buff Indicator"], 
							get = function(l)return SuperVillain.db.SVUnit["pet"]["buffIndicator"][l[#l]]end, 
							set = function(l, m)MOD:ChangeDBVar(m, l[#l], "pet", "buffIndicator");MOD:SetBasicFrame("pet")end, 
							args = {
								enable = {
									type = "toggle", 
									name = L["Enable"], 
									order = 1
								}, 
								size = {
									type = "range", 
									name = L["Size"], 
									desc = L["Size of the indicator icon."], 
									order = 3, 
									min = 4, 
									max = 15, 
									step = 1
								}
							}
						}, 
					}
				}, 
				health = MOD:SetHealthConfigGroup(false, MOD.SetBasicFrame, "pet"), 
				power = MOD:SetPowerConfigGroup(false, MOD.SetBasicFrame, "pet"), 
				portrait = MOD:SetPortraitConfigGroup(MOD.SetBasicFrame, "pet"), 
				name = MOD:SetNameConfigGroup(MOD.SetBasicFrame, "pet"), 
				buffs = MOD:SetAuraConfigGroup(true, "buffs", false, MOD.SetBasicFrame, "pet"), 
				debuffs = MOD:SetAuraConfigGroup(true, "debuffs", false, MOD.SetBasicFrame, "pet")
			}
		}
	}
}
--[[
##################################################################################################
##################################################################################################
##################################################################################################
]]
SuperVillain.Options.args.SVUnit.args.pettarget = {
	name = L["PetTarget Frame"], 
	type = "group", order = 900, 
	childGroups = "select", 
	get = function(l)return SuperVillain.db.SVUnit["pettarget"][l[#l]]end, 
	set = function(l, m)MOD:ChangeDBVar(m, l[#l], "pettarget");MOD:SetBasicFrame("pettarget")end, 
	args = {
		enable = {type = "toggle", order = 1, name = L["Enable"]}, 
		resetSettings = {type = "execute", order = 2, name = L["Restore Defaults"], func = function(l, m)MOD:ResetUnitOptions("pettarget")SuperVillain:ResetMovables("PetTarget Frame")end}, 
		tabGroups = {
			order = 3, 
			type = "group", 
			name = L["Unit Options"], 
			childGroups = "tree", 
			args = {
				commonGroup = {
					order = 1, 
					type = "group", 
					name = L["General Settings"], 
					args = {
						showAuras = {
							order = 3, 
							type = "execute", 
							name = L["Show Auras"], 
							func = function()local U = SVUI_PetTarget;if U.forceShowAuras then U.forceShowAuras = nil else U.forceShowAuras = true end;MOD:SetBasicFrame("pettarget")end
						}, 
						width = {order = 4, name = L["Width"], type = "range", min = 50, max = 500, step = 1}, 
						height = {order = 5, name = L["Height"], type = "range", min = 10, max = 250, step = 1}, 
						rangeCheck = {order = 6, name = L["Range Check"], desc = L["Check if you are in range to cast spells on this specific unit."], type = "toggle"}, 
						hideonnpc = {
							type = "toggle", 
							order = 7, 
							name = L["Text Toggle On NPC"], 
							desc = L["Power text will be hidden on NPC targets, in addition the name text will be repositioned to the power texts anchor point."], 
							get = function(l)return SuperVillain.db.SVUnit["pettarget"]["power"].hideonnpc end, 
							set = function(l, m)SuperVillain.db.SVUnit["pettarget"]["power"].hideonnpc = m;MOD:SetBasicFrame("pettarget")end
						}, 
						threatEnabled = {type = "toggle", order = 13, name = L["Show Threat"]}
					}
				}, 
				health = MOD:SetHealthConfigGroup(false, MOD.SetBasicFrame, "pettarget"), 
				power = MOD:SetPowerConfigGroup(false, MOD.SetBasicFrame, "pettarget"), 
				name = MOD:SetNameConfigGroup(MOD.SetBasicFrame, "pettarget"), 
				buffs = MOD:SetAuraConfigGroup(false, "buffs", false, MOD.SetBasicFrame, "pettarget"), 
				debuffs = MOD:SetAuraConfigGroup(false, "debuffs", false, MOD.SetBasicFrame, "pettarget")
			}
		}
	}
}
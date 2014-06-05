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
SuperVillain.Options.args.SVUnit.args.focus = {
	name = L["Focus Frame"], 
	type = "group", 
	order = 600, 
	childGroups = "select", 
	get = function(l)return SuperVillain.db.SVUnit["focus"][l[#l]]end, 
	set = function(l, m)MOD:ChangeDBVar(m, l[#l], "focus");MOD:SetBasicFrame("focus")end, 
	args = {
		enable = {type = "toggle", order = 1, name = L["Enable"]}, 
		resetSettings = {type = "execute", order = 2, name = L["Restore Defaults"], func = function(l, m)MOD:ResetUnitOptions("focus");SuperVillain:ResetMovables("Focus Frame")end}, 
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
							func = function()local U = SVUI_Focus;if U.forceShowAuras then U.forceShowAuras = nil else U.forceShowAuras = true end;MOD:SetBasicFrame("focus")end
						}, 
						width = {
							order = 4, 
							name = L["Width"], 
							type = "range", 
							min = 50, 
							max = 500, 
							step = 1
						}, 
						height = {
							order = 5, 
							name = L["Height"], 
							type = "range", 
							min = 10, 
							max = 250, 
							step = 1
						}, 
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
							get = function(l)return SuperVillain.db.SVUnit["focus"]["power"].hideonnpc end, 
							set = function(l, m)SuperVillain.db.SVUnit["focus"]["power"].hideonnpc = m;MOD:SetBasicFrame("focus")end
						}, 
						smartAuraDisplay = {
							type = "select", 
							name = L["Smart Auras"], 
							desc = L["When set the Buffs and Debuffs will toggle being displayed depending on if the unit is friendly or an enemy. This will not effect the aurabars package."], 
							order = 11, 
							values = {["DISABLED"] = L["Disabled"], ["SHOW_DEBUFFS_ON_FRIENDLIES"] = L["Friendlies: Show Debuffs"], ["SHOW_BUFFS_ON_FRIENDLIES"] = L["Friendlies: Show Buffs"]}
						}, 
						threatEnabled = {
							type = "toggle", 
							order = 13, 
							name = L["Show Threat"]
						}, 
					}
				}, 
				health = MOD:SetHealthConfigGroup(false, MOD.SetBasicFrame, "focus"), 
				power = MOD:SetPowerConfigGroup(nil, MOD.SetBasicFrame, "focus"), 
				name = MOD:SetNameConfigGroup(MOD.SetBasicFrame, "focus"), 
				buffs = MOD:SetAuraConfigGroup(false, "buffs", false, MOD.SetBasicFrame, "focus"), 
				debuffs = MOD:SetAuraConfigGroup(false, "debuffs", false, MOD.SetBasicFrame, "focus"), 
				castbar = MOD:SetCastbarConfigGroup(false, MOD.SetBasicFrame, "focus"), 
				aurabar = MOD:SetAurabarConfigGroup(false, MOD.SetBasicFrame, "focus"), 
				icons = MOD:SetIconConfigGroup(MOD.SetBasicFrame, "focus")
			}
		}
	}
}
--[[
##################################################################################################
##################################################################################################
##################################################################################################
]]
SuperVillain.Options.args.SVUnit.args.focustarget = {
	name = L["FocusTarget Frame"], 
	type = "group", 
	order = 700, 
	childGroups = "select", 
	get = function(l)return SuperVillain.db.SVUnit["focustarget"][l[#l]]end, 
	set = function(l, m)MOD:ChangeDBVar(m, l[#l], "focustarget");MOD:SetBasicFrame("focustarget")end, 
	args = {
		enable = {type = "toggle", order = 1, name = L["Enable"]}, 
		resetSettings = {type = "execute", order = 2, name = L["Restore Defaults"], func = function(l, m)MOD:ResetUnitOptions("focustarget")SuperVillain:ResetMovables("FocusTarget Frame")end}, 
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
						showAuras = {order = 3, type = "execute", name = L["Show Auras"], func = function()local U = SVUI_FocusTarget;if U.forceShowAuras then U.forceShowAuras = nil else U.forceShowAuras = true end;MOD:SetBasicFrame("focustarget")end}, 
						width = {order = 4, name = L["Width"], type = "range", min = 50, max = 500, step = 1}, 
						height = {order = 5, name = L["Height"], type = "range", min = 10, max = 250, step = 1}, 
						rangeCheck = {order = 6, name = L["Range Check"], desc = L["Check if you are in range to cast spells on this specific unit."], type = "toggle"}, 
						hideonnpc = {type = "toggle", order = 7, name = L["Text Toggle On NPC"], desc = L["Power text will be hidden on NPC targets, in addition the name text will be repositioned to the power texts anchor point."], get = function(l)return SuperVillain.db.SVUnit["focustarget"]["power"].hideonnpc end, set = function(l, m)SuperVillain.db.SVUnit["focustarget"]["power"].hideonnpc = m;MOD:SetBasicFrame("focustarget")end}, 
						threatEnabled = {type = "toggle", order = 13, name = L["Show Threat"]}
					}
				}, 
				health = MOD:SetHealthConfigGroup(false, MOD.SetBasicFrame, "focustarget"), 
				power = MOD:SetPowerConfigGroup(false, MOD.SetBasicFrame, "focustarget"), 
				name = MOD:SetNameConfigGroup(MOD.SetBasicFrame, "focustarget"), 
				buffs = MOD:SetAuraConfigGroup(false, "buffs", false, MOD.SetBasicFrame, "focustarget"), 
				debuffs = MOD:SetAuraConfigGroup(false, "debuffs", false, MOD.SetBasicFrame, "focustarget"), 
				icons = MOD:SetIconConfigGroup(MOD.SetBasicFrame, "focustarget")
			}
		}
	}
}
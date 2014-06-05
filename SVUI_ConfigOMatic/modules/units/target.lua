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
SuperVillain.Options.args.SVUnit.args.target={
	name=L['Target Frame'],
	type='group',
	order=400,
	childGroups="tab",
	get=function(l)return SuperVillain.db.SVUnit['target'][l[#l]]end,
	set=function(l,m)MOD:ChangeDBVar(m, l[#l], "target");MOD:SetBasicFrame('target')end,
	args={
		enable={type='toggle',order=1,name=L['Enable']},
		resetSettings={type='execute',order=2,name=L['Restore Defaults'],func=function(l,m)MOD:ResetUnitOptions('target')SuperVillain:ResetMovables('Target Frame')end},
		tabGroups={
			order=3,
			type='group',
			name=L['Unit Options'],
			childGroups="tree",
			args={
				commonGroup = {
					order = 1,
					type = "group",
					name = L["General Settings"],
					args = {
						showAuras = {
							order = 3,
							type = "execute",
							name = L["Show Auras"],
							func = function()local U = SVUI_Target;if U.forceShowAuras then U.forceShowAuras = nil else U.forceShowAuras = true end;MOD:SetBasicFrame("target")end
						},
						width = {
							order = 4,
							name = L["Width"],
							type = "range",
							min = 50,
							max = 500,
							step = 1,
							set = function(l, m)if SuperVillain.db.SVUnit["target"].castbar.width == SuperVillain.db.SVUnit["target"][l[#l]]then SuperVillain.db.SVUnit["target"].castbar.width = m end;MOD:ChangeDBVar(m, l[#l], "target");MOD:SetBasicFrame("target")end
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
						middleClickFocus = {
							order = 8,
							name = L["Middle Click - Set Focus"],
							desc = L["Middle clicking the unit frame will cause your focus to match the unit."],
							type = "toggle",
							disabled = function()return IsAddOnLoaded("Clique")end
						},
						hideonnpc = {
							type = "toggle",
							order = 10,
							name = L["Text Toggle On NPC"],
							desc = L["Power text will be hidden on NPC targets, in addition the name text will be repositioned to the power texts anchor point."],
							get = function(l)return SuperVillain.db.SVUnit["target"]["power"].hideonnpc end,
							set = function(l, m)SuperVillain.db.SVUnit["target"]["power"].hideonnpc = m;MOD:SetBasicFrame("target")end
						},
						smartAuraDisplay = {
							type = "select",
							name = L["Smart Auras"],
							desc = L["When set the Buffs and Debuffs will toggle being displayed depending on if the unit is friendly or an enemy. This will not effect the aurabars package."],
							order = 11,
							values = {
								["DISABLED"] = L["Disabled"],
								["SHOW_DEBUFFS_ON_FRIENDLIES"] = L["Friendlies: Show Debuffs"],
								["SHOW_BUFFS_ON_FRIENDLIES"] = L["Friendlies: Show Buffs"]
							}
						},
						threatEnabled = {
							type = "toggle",
							order = 12,
							name = L["Show Threat"]
						}
					}
				},
				combobar = {
					order = 800,
					type = "group",
					name = L["Combobar"],
					get = function(l)return SuperVillain.db.SVUnit["target"]["combobar"][l[#l]]end,
					set = function(l, m)MOD:ChangeDBVar(m, l[#l], "target", "combobar");MOD:SetBasicFrame("target")end,
					args = {
						enable = {
							type = "toggle",
							order = 1,
							name = L["Enable"]
						},
						smallIcons = {
							type = "toggle",
							name = L["Small Points"],
							order = 2
						},
						height = {
							type = "range",
							order = 3,
							name = L["Height"],
							min = 15,
							max = 45,
							step = 1
						},
						autoHide = {
							type = "toggle",
							name = L["Auto-Hide"],
							order = 4
						},
						hudStyle = {
							type = "toggle",
							order = 5,
							name = "Use HUD Style"
						},
						hudScale = {
							type = "range",
							order = 6,
							name = "HUD Scale",
							disabled = function()return not SuperVillain.db.SVUnit["target"]["combobar"].hudStyle end,
							min = 15,
							max = 100,
							step = 1
						}
					}
				},
				health = MOD:SetHealthConfigGroup(false, MOD.SetBasicFrame, "target"), 
				power = MOD:SetPowerConfigGroup(true, MOD.SetBasicFrame, "target"), 
				name = MOD:SetNameConfigGroup(MOD.SetBasicFrame, "target"), 
				portrait = MOD:SetPortraitConfigGroup(MOD.SetBasicFrame, "target"), 
				buffs = MOD:SetAuraConfigGroup(false, "buffs", false, MOD.SetBasicFrame, "target"), 
				debuffs = MOD:SetAuraConfigGroup(false, "debuffs", false, MOD.SetBasicFrame, "target"), 
				castbar = MOD:SetCastbarConfigGroup(false, MOD.SetBasicFrame, "target"), 
				aurabar = MOD:SetAurabarConfigGroup(false, MOD.SetBasicFrame, "target"), 
				icons = MOD:SetIconConfigGroup(MOD.SetBasicFrame, "target")
			}
		}
	}
}
--[[
##################################################################################################
##################################################################################################
##################################################################################################
]]
SuperVillain.Options.args.SVUnit.args.targettarget={
	name=L['TargetTarget Frame'],
	type='group',
	order=500,
	childGroups="tab",
	get=function(l)return SuperVillain.db.SVUnit['targettarget'][l[#l]]end,
	set=function(l,m)MOD:ChangeDBVar(m, l[#l], "targettarget");MOD:SetBasicFrame('targettarget')end,
	args={
		enable={type='toggle',order=1,name=L['Enable']},
		resetSettings={type='execute',order=2,name=L['Restore Defaults'],func=function(l,m)MOD:ResetUnitOptions('targettarget')SuperVillain:ResetMovables('TargetTarget Frame')end},
		tabGroups={
			order=3,
			type='group',
			name=L['Unit Options'],
			childGroups="tree",
			args={
				commonGroup = {
					order = 1,
					type = "group",
					name = L["General Settings"],
					args = {
						showAuras = {
							order = 3,
							type = "execute",
							name = L["Show Auras"],
							func = function()local U = SVUI_TargetTarget;if U.forceShowAuras then U.forceShowAuras = nil else U.forceShowAuras = true end;MOD:SetBasicFrame("targettarget")end
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
						hideonnpc = {
							type = "toggle",
							order = 7,
							name = L["Text Toggle On NPC"],
							desc = L["Power text will be hidden on NPC targets, in addition the name text will be repositioned to the power texts anchor point."],
							get = function(l)return SuperVillain.db.SVUnit["targettarget"]["power"].hideonnpc end,
							set = function(l, m)SuperVillain.db.SVUnit["targettarget"]["power"].hideonnpc = m;MOD:SetBasicFrame("targettarget")end
						},
						threatEnabled = {
							type = "toggle",
							order = 11,
							name = L["Show Threat"]
						}
					}
				},
				health = MOD:SetHealthConfigGroup(false, MOD.SetBasicFrame, "targettarget"), 
				power = MOD:SetPowerConfigGroup(nil, MOD.SetBasicFrame, "targettarget"), 
				name = MOD:SetNameConfigGroup(MOD.SetBasicFrame, "targettarget"), 
				portrait = MOD:SetPortraitConfigGroup(MOD.SetBasicFrame, "targettarget"), 
				buffs = MOD:SetAuraConfigGroup(false, "buffs", false, MOD.SetBasicFrame, "targettarget"), 
				debuffs = MOD:SetAuraConfigGroup(false, "debuffs", false, MOD.SetBasicFrame, "targettarget"), 
				icons = MOD:SetIconConfigGroup(MOD.SetBasicFrame, "targettarget")
			}
		}
	}
}
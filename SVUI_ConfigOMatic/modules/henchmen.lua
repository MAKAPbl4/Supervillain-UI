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
local MOD = SuperVillain:GetModule('SVHenchmen');
local DOCK = SuperVillain:GetModule('SVDock');
--[[ 
########################################################## 
SET PACKAGE OPTIONS
##########################################################
]]--
SuperVillain.Options.args.SVHenchmen={
	type = "group", 
	name = L["Henchmen"],
	get = function(a)return SuperVillain.db.SVHenchmen[a[#a]]end, 
	set = function(a,b)MOD:ChangeDBVar(b,a[#a]); end, 
	args = {
		intro = {
			order = 1, 
			type = "description", 
			name = L["Adjust the behavior and features that your henchmen will use."]
		},
		common = {
			order = 2, 
			type = "group", 
			name = L["General"], 
			guiInline = true, 
			args = {
				automationGroup1 = {
					order = 1, 
					type = "group", 
					guiInline = true, 
					name = L["Task Minions"],
					desc = L['Minions that can make certain tasks easier by handling them automatically.'],
					args = {
						mailOpener = {
							order = 1,
							type = 'toggle',
							name = L["Enable Mail Helper"],
							get = function(j)return SuperVillain.protected.SVHenchmen.mailOpener end,
							set = function(j,value)SuperVillain.protected.SVHenchmen.mailOpener = value;MOD:ToggleMailMinions()end
						},
						autoAcceptInvite = {
							order = 2,
							name = L['Accept Invites'],
							desc = L['Automatically accept invites from guild/friends.'],
							type = 'toggle',
							get = function(j)return SuperVillain.protected.SVHenchmen.autoAcceptInvite end,
							set = function(j,value)SuperVillain.protected.SVHenchmen.autoAcceptInvite = value end
						},
						vendorGrays = {
							order = 3,
							name = L['Vendor Grays'],
							desc = L['Automatically vendor gray items when visiting a vendor.'],
							type = 'toggle',
							get = function(j)return SuperVillain.protected.SVHenchmen.vendorGrays end,
							set = function(j,value)SuperVillain.protected.SVHenchmen.vendorGrays = value end
						},
						autoRoll = {
							order = 4,
							name = L['Auto Greed/DE'],
							desc = L['Automatically select greed or disenchant (when available) on green quality items. This will only work if you are the max level.'],
							type = 'toggle',
							get = function(j)return SuperVillain.protected.SVHenchmen.autoRoll end,
							set = function(j,value)SuperVillain.protected.SVHenchmen.autoRoll = value end,
							disabled = function()return not SuperVillain.protected.SVOverride.lootRoll end
						},
						pvpautorelease = {
							order = 5,
							type = "toggle",
							name = L['PvP Autorelease'],
							desc = L['Automatically release body when killed inside a battleground.'],
							get = function(j)return SuperVillain.protected.SVHenchmen.pvpautorelease end,
							set = function(j,value)SuperVillain.protected.SVHenchmen.pvpautorelease = value;SuperVillain:StaticPopup_Show("RL_CLIENT")end
						},
						autorepchange = {
							order = 6,
							type = "toggle",
							name = L['Track Reputation'],
							desc = L['Automatically change your watched faction on the reputation bar to the faction you got reputation points for.'],
							get = function(j)return SuperVillain.protected.SVHenchmen.autorepchange end,
							set = function(j,value)SuperVillain.protected.SVHenchmen.autorepchange = value end
						},
						skipcinematics = {
							order = 7,
							type = "toggle",
							name = L['Skip Cinematics'],
							desc = L['Automatically skip any cinematic sequences.'],
							get = function(j)return SuperVillain.protected.SVHenchmen.skipcinematics end,
							set = function(j,value)SuperVillain.protected.SVHenchmen.skipcinematics = value;SuperVillain:StaticPopup_Show("RL_CLIENT") end
						},
						autoRepair = {
							order = 8,
							name = L['Auto Repair'],
							desc = L['Automatically repair using the following method when visiting a merchant.'],
							type = 'select',
							values = {
								['NONE'] = NONE,
								['GUILD'] = GUILD,
								['PLAYER'] = PLAYER
							},
							get = function(j)return SuperVillain.protected.SVHenchmen.autoRepair end,
							set = function(j,value)SuperVillain.protected.SVHenchmen.autoRepair = value end
						},
					}
				},
				automationGroup2 = {
					order = 2, 
					type = "group", 
					guiInline = true, 
					name = L["Quest Minions"],
					desc = L['Minions that can make questing easier by automatically accepting/completing quests.'],
					args = {
						autoquestaccept = {
							order = 1,
							type = "toggle",
							name = L['Accept Quests'],
							desc = L['Automatically accepts quests as they are presented to you.'],
							get = function(j)return SuperVillain.protected.SVHenchmen.autoquestaccept end,
							set = function(j,value) SuperVillain.protected.SVHenchmen.autoquestaccept = value end
						},
						autoquestcomplete = {
							order = 2,
							type = "toggle",
							name = L['Complete Quests'],
							desc = L['Automatically complete quests when possible.'],
							get = function(j)return SuperVillain.protected.SVHenchmen.autoquestcomplete end,
							set = function(j,value)SuperVillain.protected.SVHenchmen.autoquestcomplete = value end
						},
						autoquestreward = {
							order = 3,
							type = "toggle",
							name = L['Select Quest Reward'],
							desc = L['Automatically select the quest reward with the highest vendor sell value.'],
							get = function(j)return SuperVillain.protected.SVHenchmen.autoquestreward end,
							set = function(j,value)SuperVillain.protected.SVHenchmen.autoquestreward = value end
						},
						autodailyquests = {
							order = 4,
							type = "toggle",
							name = L['Only Automate Dailies'],
							desc = L['Force the auto accept functions to only respond to daily quests. NOTE: This does not apply to daily heroics for some reason.'],
							get = function(j)return SuperVillain.protected.SVHenchmen.autodailyquests end,
							set = function(j,value)SuperVillain.protected.SVHenchmen.autodailyquests = value end
						},
						autopvpquests = {
							order = 5,
							type = "toggle",
							name = L['Accept PVP Quests'],
							get = function(j)return SuperVillain.protected.SVHenchmen.autopvpquests end,
							set = function(j,value)SuperVillain.protected.SVHenchmen.autopvpquests = value end
						},
					}
				}, 
			}
		}
	}
}
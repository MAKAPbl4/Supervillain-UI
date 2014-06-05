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
local MOD = SuperVillain:GetModule('SVTip');
local LSM = LibStub("LibSharedMedia-3.0");
--[[ 
########################################################## 
SET PACKAGE OPTIONS
##########################################################
]]--
SuperVillain.Options.args.SVTip={
	type="group",
	name=L["Tooltip"],
	childGroups="tab",
	get=function(a)return SuperVillain.db.SVTip[a[#a]]end,
	set=function(a,b)SuperVillain.db.SVTip[a[#a]]=b end,
	args={
		commonGroup={
			order=1,
			type='group',
			name=L['Tooltip Options'],
			childGroups="tree",
			args={
				intro={order=1,type="description",name=L["TOOLTIP_DESC"]},
				enable={order=2,type="toggle",name=L["Enable"],get=function(a)return SuperVillain.protected.SVTip[a[#a]]end,set=function(a,b)SuperVillain.protected.SVTip[a[#a]]=b;SuperVillain:StaticPopup_Show("RL_CLIENT")end},
				common={
					order=3,
					type="group",
					name=L["General"],
					disabled=function()return not SuperVillain.protected.SVTip.enable end,
					args={
						cursorAnchor={order=1,type='toggle',name=L['Cursor Anchor'],desc=L['Should tooltip be anchored to mouse cursor']},
						targetInfo={order=2,type='toggle',name=L["Target Info"],desc=L["When in a raid group display if anyone in your raid is targeting the current tooltip unit."]},
						playerTitles={order=3,type='toggle',name=L['Player Titles'],desc=L['Display player titles.']},
						guildRanks={order=4,type='toggle',name=L['Guild Ranks'],desc=L['Display guild ranks if a unit is guilded.']},
						talentInfo={order=5,type='toggle',name=L['Talent Spec'],desc=L['Display the players talent spec in the tooltip, this may not immediately update when mousing over a unit.']},
						itemCount={order=6,type='toggle',name=L['Item Count'],desc=L['Display how many of a certain item you have in your possession.']},
						spellID={order=7,type='toggle',name=L['Spell/Item IDs'],desc=L['Display the spell or item ID when mousing over a spell or item tooltip.']}
					}
				},
				visibility={
					order=100,
					type="group",
					name=L["Visibility"],
					get=function(a)return SuperVillain.db.SVTip.visibility[a[#a]]end,
					set=function(a,b)SuperVillain.db.SVTip.visibility[a[#a]]=b end,
					args={
						combat={order=1,type='toggle',name=COMBAT,desc=L["Hide tooltip while in combat."]},
						unitFrames={order=2,type='select',name=L['Unitframes'],desc=L["Don't display the tooltip when mousing over a unitframe."],values={['ALL']=L['Always Hide'],['NONE']=L['Never Hide'],['SHIFT']=SHIFT_KEY,['ALT']=ALT_KEY,['CTRL']=CTRL_KEY}}
					}
				},
				healthBar={
					order=200,
					type="group",
					name=L["Health Bar"],
					get=function(a)return SuperVillain.db.SVTip.healthBar[a[#a]]end,
					set=function(a,b)SuperVillain.db.SVTip.healthBar[a[#a]]=b end,
					args={
						height = {
							order = 1, 
							name = L["Height"], 
							type = "range", 
							min = 1, 
							max = 15, 
							step = 1, 
							width = "full", 
							set = function(a,b)SuperVillain.db.SVTip.healthBar.height = b;GameTooltipStatusBar:Height(b)end
						},
						fontGroup = {
							order = 2, 
							name = L["Fonts"], 
							type = "group", 
							guiInline = true, 
							args = {
								text = {
									order = 1, 
									type = "toggle", 
									name = L["Text"], 
									set = function(a,b)SuperVillain.db.SVTip.healthBar.text = b;if b then GameTooltipStatusBar.text:Show()else GameTooltipStatusBar.text:Hide()end end
								},
								font = {
									type = "select", 
									dialogControl = "LSM30_Font", 
									order = 2, 
									width = "full", 
									name = L["Font"], 
									values = AceGUIWidgetLSMlists.font, 
									set = function(a,b)SuperVillain.db.SVTip.healthBar.font = b;GameTooltipStatusBar.text:SetFontTemplate(LSM:Fetch("font",SuperVillain.db.SVTip.healthBar.font), SuperVillain.db.SVTip.healthBar.fontSize,"OUTLINE")end
								},
								fontSize = {
									order = 3, 
									name = L["Font Size"], 
									type = "range", 
									min = 6, 
									max = 22, 
									step = 1, 
									width = "full", 
									set = function(a,b)SuperVillain.db.SVTip.healthBar.fontSize = b;GameTooltipStatusBar.text:SetFontTemplate(LSM:Fetch("font",SuperVillain.db.SVTip.healthBar.font),SuperVillain.db.SVTip.healthBar.fontSize,"OUTLINE")end
								}
							}
						}
					}
				}
			}
		}
	}
}
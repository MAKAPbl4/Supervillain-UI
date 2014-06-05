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

SuperVillain.Options.args.SVUnit.args.party ={
	name = L['Party Frames'],
	type = 'group',
	order = 1100,
	childGroups = "tab",
	get = function(l)return
	SuperVillain.db.SVUnit['party'][l[#l]]end,
	set = function(l, m)MOD:ChangeDBVar(m, l[#l], "party");MOD:SetGroupFrame('party')end,
	args ={
		enable ={
			type = 'toggle',
			order = 1,
			name = L['Enable'],
		},
		configureToggle ={
			order = 2,
			type = 'execute',
			name = L['Display Frames'],
			func = function()MOD:UpdateGroupConfig(SVUI_Party, SVUI_Party.forceShow ~= true or nil)end,
		},
		resetSettings ={
			type = 'execute',
			order = 3,
			name = L['Restore Defaults'],
			func = function(l, m)MOD:ResetUnitOptions('party')SuperVillain:ResetMovables('Party Frames')end,
		},
		tabGroups={
			order=3,
			type='group',
			name=L['Unit Options'],
			childGroups="tree",
			args={
				common ={
					order = 4,
					type = 'group',
					name = L['General'],
					args ={
						hideonnpc ={
							type = 'toggle',
							order = 2,
							name = L['Text Toggle On NPC'],
							desc = L['Power text will be hidden on NPC targets, in addition the name text will be repositioned to the power texts anchor point.'],
							get = function(l)return SuperVillain.db.SVUnit['party']['power'].hideonnpc end,
							set = function(l, m)SuperVillain.db.SVUnit['party']['power'].hideonnpc = m;MOD:SetGroupFrame('party')end,
						},
						rangeCheck ={
							order = 3,
							name = L["Range Check"],
							desc = L["Check if you are in range to cast spells on this specific unit."],
							type = "toggle",
						},
						predict ={
							order = 4,
							name = L['Heal Prediction'],
							desc = L['Show a incomming heal prediction bar on the unitframe. Also display a slightly different colored bar for incoming overheals.'],
							type = 'toggle',
						},
						threatEnabled ={
							type = 'toggle',
							order = 5,
							name = L['Show Threat'],
						},
						colorOverride ={
							order = 6,
							name = L['Class Color Override'],
							desc = L['Override the default class color setting.'],
							type = 'select',
							values ={
								['USE_DEFAULT'] = L['Use Default'],
								['FORCE_ON'] = L['Force On'],
								['FORCE_OFF'] = L['Force Off'],
							},
						},
						positionsGroup ={
							order = 100,
							name = L['Size and Positions'],
							type = 'group',
							guiInline = true,
							set = function(l, m)MOD:ChangeDBVar(m, l[#l], "party");MOD:SetGroupFrame('party', nil, nil, true)end,
							args ={
								gridMode ={
									order = 1,
									name = L["Enable Grid mode"],
									type = 'toggle',
									set = function(l, m)MOD:ChangeDBVar(m, l[#l], "party");MOD:SetGroupFrame('party')end,
								},
								width ={
									order = 2,
									name = L['Width'],
									type = 'range',
									min = 10,
									max = 500,
									step = 1,
									set = function(l, m)MOD:ChangeDBVar(m, l[#l], "party");MOD:SetGroupFrame('party')end,
								},
								height ={
									order = 3,
									name = L['Height'],
									type = 'range',
									min = 10,
									max = 500,
									step = 1,
									set = function(l, m)MOD:ChangeDBVar(m, l[#l], "party");MOD:SetGroupFrame('party')end,
								},
								spacer ={
									order = 4,
									name = '',
									type = 'description',
									width = 'full',
								},
								showBy ={
									order = 5,
									name = L['Growth Direction'],
									desc = L['Growth direction from the first unitframe.'],
									type = 'select',
									values ={
										DOWN_RIGHT = format(L['%s and then %s'], L['Down'], L['Right']),
										DOWN_LEFT = format(L['%s and then %s'], L['Down'], L['Left']),
										UP_RIGHT = format(L['%s and then %s'], L['Up'], L['Right']),
										UP_LEFT = format(L['%s and then %s'], L['Up'], L['Left']),
										RIGHT_DOWN = format(L['%s and then %s'], L['Right'], L['Down']),
										RIGHT_UP = format(L['%s and then %s'], L['Right'], L['Up']),
										LEFT_DOWN = format(L['%s and then %s'], L['Left'], L['Down']),
										LEFT_UP = format(L['%s and then %s'], L['Left'], L['Up']),
									},
								},
								gCount ={
									order = 7,
									type = 'range',
									name = L['Number of Groups'],
									min = 1,
									max = 8,
									step = 1,
									set = function(l, m)
										MOD:ChangeDBVar(m, l[#l], "party");
										MOD:SetGroupFrame('party')
										if SVUI_Party.isForced then 
											MOD:UpdateGroupConfig(SVUI_Party)
											MOD:UpdateGroupConfig(SVUI_Party, true)
										end 
									end,
								},
								gRowCol ={
									order = 8,
									type = 'range',
									name = L['Groups Per Row/Column'],
									min = 1,
									max = 8,
									step = 1,
									set = function(l, m)
										MOD:ChangeDBVar(m, l[#l], "party");
										MOD:SetGroupFrame('party')
										if SVUI_Party.isForced then 
											MOD:UpdateGroupConfig(SVUI_Party)
											MOD:UpdateGroupConfig(SVUI_Party, true)
										end 
									end,
								},
								wrapXOffset ={
									order = 9,
									type = 'range',
									name = L['Horizontal Spacing'],
									min = 0,
									max = 50,
									step = 1,
								},
								wrapYOffset ={
									order = 10,
									type = 'range',
									name = L['Vertical Spacing'],
									min = 0,
									max = 50,
									step = 1,
								},
							},
						},
						visibilityGroup ={
							order = 200,
							name = L['Visibility'],
							type = 'group',
							guiInline = true,
							set = function(l, m)MOD:ChangeDBVar(m, l[#l], "party");MOD:SetGroupFrame('party', nil, nil, true)end,
							args ={
								showPlayer ={
									order = 1,
									type = 'toggle',
									name = L['Display Player'],
									desc = L['When true, the header includes the player when not in a raid.'],
								},
								visibility ={
									order = 2,
									type = 'input',
									name = L['Visibility'],
									desc = L['The following macro must be true in order for the group to be shown, in addition to any filter that may already be set.'],
									width = 'full',
									desc = L['TEXT_FORMAT_DESC'],
								},
							},
						},
						sortingGroup ={
							order = 300,
							type = 'group',
							guiInline = true,
							name = L['Grouping & Sorting'],
							set = function(l, m)MOD:ChangeDBVar(m, l[#l], "party");MOD:SetGroupFrame('party', nil, nil, true)end,
							args ={
								sortMethod ={
									order = 1,
									name = L['Group By'],
									desc = L['Set the order that the group will sort.'],
									type = 'select',
									values ={
										['CLASS'] = CLASS,
										['ROLE'] = ROLE,
										['NAME'] = NAME,
										['MTMA'] = L['Main Tanks / Main Assist'],
										['GROUP'] = GROUP,
									},
								},
								sortDir ={
									order = 2,
									name = L['Sort Direction'],
									desc = L['Defines the sort order of the selected sort method.'],
									type = 'select',
									values ={
										['ASC'] = L['Ascending'],
										['DESC'] = L['Descending'],
									},
								},
								spacer ={
									order = 3,
									type = 'description',
									width = 'full',
									name = ' ',
								},
								rSort ={
									order = 4,
									name = L['Raid-Wide Sorting'],
									desc = L['Enabling this allows raid-wide sorting however you will not be able to distinguish between groups.'],
									type = 'toggle',
								},
								invertGroupingOrder ={
									order = 5,
									name = L['Invert Grouping Order'],
									desc = L['Enabling this inverts the grouping order when the raid is not full, this will reverse the direction it starts from.'],
									disabled = function()return not SuperVillain.db.SVUnit['party'].rSort end,
									type = 'toggle',
								},
								startFromCenter ={
									order = 6,
									name = L['Start Near Center'],
									desc = L['The initial group will start near the center and grow out.'],
									disabled = function()return not SuperVillain.db.SVUnit['party'].rSort end,
									type = 'toggle',
								},
							},
						},

					},
				},
				buffIndicator ={
					order = 600,
					type = 'group',
					name = L['Buff Indicator'],
					get = function(l)return
					SuperVillain.db.SVUnit['party']['buffIndicator'][l[#l]]end,
					set = function(l, m)MOD:ChangeDBVar(m, l[#l], "party", "buffIndicator");MOD:SetGroupFrame('party')end,
					args ={
						enable ={
							type = 'toggle',
							name = L['Enable'],
							order = 1,
						},
						size ={
							type = 'range',
							name = L['Size'],
							desc = L['Size of the indicator icon.'],
							order = 2,
							min = 4,
							max = 15,
							step = 1,
						},
						configureButton ={
							type = 'execute',
							name = L['Configure Auras'],
							func = function()SuperVillain:SetToFilterConfig('Buff Indicator')end,
							order = 3,
						},

					},
				},
				health = MOD:SetHealthConfigGroup(true, MOD.SetGroupFrame, 'party'),
				power = MOD:SetPowerConfigGroup(false, MOD.SetGroupFrame, 'party'),
				name = MOD:SetNameConfigGroup(MOD.SetGroupFrame, 'party'),
				portrait = MOD:SetPortraitConfigGroup(MOD.SetGroupFrame, 'party'),
				buffs = MOD:SetAuraConfigGroup(true, 'buffs', true, MOD.SetGroupFrame, 'party'),
				debuffs = MOD:SetAuraConfigGroup(true, 'debuffs', true, MOD.SetGroupFrame, 'party'),
				petsGroup ={
					order = 800,
					type = 'group',
					name = L['Party Pets'],
					get = function(l)return SuperVillain.db.SVUnit['party']['petsGroup'][l[#l]]end,
					set = function(l, m)MOD:ChangeDBVar(m, l[#l], "party", "petsGroup");MOD:SetGroupFrame('party')end,
					args ={
						enable ={
							type = 'toggle',
							name = L['Enable'],
							order = 1,
						},
						width ={
							order = 2,
							name = L['Width'],
							type = 'range',
							min = 10,
							max = 500,
							step = 1,
						},
						height ={
							order = 3,
							name = L['Height'],
							type = 'range',
							min = 10,
							max = 250,
							step = 1,
						},
						anchorPoint ={
							type = 'select',
							order = 5,
							name = L['Anchor Point'],
							desc = L['What point to anchor to the frame you set to attach to.'],
							values = {TOPLEFT='TOPLEFT',LEFT='LEFT',BOTTOMLEFT='BOTTOMLEFT',RIGHT='RIGHT',TOPRIGHT='TOPRIGHT',BOTTOMRIGHT='BOTTOMRIGHT',CENTER='CENTER',TOP='TOP',BOTTOM='BOTTOM'},
						},
						xOffset ={
							order = 6,
							type = 'range',
							name = L['xOffset'],
							desc = L['An X offset (in pixels) to be used when anchoring new frames.'],
							min =  - 500,
							max = 500,
							step = 1,
						},
						yOffset ={
							order = 7,
							type = 'range',
							name = L['yOffset'],
							desc = L['An Y offset (in pixels) to be used when anchoring new frames.'],
							min =  - 500,
							max = 500,
							step = 1,
						},
						text_length = {
							order = 8, 
							name = L["Name Length"],
							desc = L["TEXT_FORMAT_DESC"], 
							type = "range", 
							width = "full", 
							min = 1, 
							max = 30, 
							step = 1,
							set = function(key, value)
								MOD:ChangeDBVar(value, key[#key], "party", "petsGroup");
								local tag = "[name:" .. value .. "]";
								MOD:ChangeDBVar(tag, "text_format", "party", "petsGroup");
							end,
						}
					},
				},
				targetsGroup ={
					order = 900,
					type = 'group',
					name = L['Party Targets'],
					get = function(l)return
					SuperVillain.db.SVUnit['party']['targetsGroup'][l[#l]]end,
					set = function(l, m)MOD:ChangeDBVar(m, l[#l], "party", "targetsGroup");MOD:SetGroupFrame('party')end,
					args ={
						enable ={
							type = 'toggle',
							name = L['Enable'],
							order = 1,
						},
						width ={
							order = 2,
							name = L['Width'],
							type = 'range',
							min = 10,
							max = 500,
							step = 1,
						},
						height ={
							order = 3,
							name = L['Height'],
							type = 'range',
							min = 10,
							max = 250,
							step = 1,
						},
						anchorPoint ={
							type = 'select',
							order = 5,
							name = L['Anchor Point'],
							desc = L['What point to anchor to the frame you set to attach to.'],
							values = {TOPLEFT='TOPLEFT',LEFT='LEFT',BOTTOMLEFT='BOTTOMLEFT',RIGHT='RIGHT',TOPRIGHT='TOPRIGHT',BOTTOMRIGHT='BOTTOMRIGHT',CENTER='CENTER',TOP='TOP',BOTTOM='BOTTOM'},
						},
						xOffset ={
							order = 6,
							type = 'range',
							name = L['xOffset'],
							desc = L['An X offset (in pixels) to be used when anchoring new frames.'],
							min =  - 500,
							max = 500,
							step = 1,
						},
						yOffset ={
							order = 7,
							type = 'range',
							name = L['yOffset'],
							desc = L['An Y offset (in pixels) to be used when anchoring new frames.'],
							min =  - 500,
							max = 500,
							step = 1,
						},
						text_length = {
							order = 8, 
							name = L["Name Length"],
							desc = L["TEXT_FORMAT_DESC"], 
							type = "range", 
							width = "full", 
							min = 1, 
							max = 30, 
							step = 1,
							set = function(key, value)
								MOD:ChangeDBVar(value, key[#key], "party", "targetsGroup");
								local tag = "[name:" .. value .. "]";
								MOD:ChangeDBVar(tag, "text_format", "party", "targetsGroup");
							end,
						}
					},
				},
				icons = MOD:SetIconConfigGroup(MOD.SetGroupFrame, 'party')
			}
		}
	},
}
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
--]]
local SuperVillain, L, P, C, G = unpack(select(2, ...));
--[[ 
########################################################## 
DB PROFILE VARS
##########################################################
]]--
C["SVUnit"] = {
	["smoothbars"] = false, 
	["statusbar"] = "SVUI BasicBar", 
	["auraBarStatusbar"] = "SVUI GlowBar", 

	["font"] = "SVUI Number Font", 
	["fontSize"] = 12, 
	["fontOutline"] = "OUTLINE", 

	["auraFont"] = "SVUI Alert Font", 
	["auraFontSize"] = 12, 
	["auraFontOutline"] = "NONE", 

	["OORAlpha"] = 0.5, 
	["combatFadeRoles"] = true, 
	["combatFadeNames"] = true, 
	["debuffHighlighting"] = true, 
	["smartRaidFilter"] = true, 
	["fastClickTarget"] = false, 
	["healglow"] = true, 
	["glowtime"] = 0.8, 
	["glowcolor"] = {r = 1, g = 1, b = 0}, 
	["autoRoleSet"] = false, 
	["healthclass"] = true,
	["forceHealthColor"] = false,
	["overlayAnimation"] = true, 
	["powerclass"] = false, 
	["colorhealthbyvalue"] = true, 
	["customhealthbackdrop"] = true, 
	["classbackdrop"] = false, 
	["auraBarByType"] = true, 
	["auraBarShield"] = true, 
	["castClassColor"] = false, 
	["player"] = {
		["enable"] = true, 
		["width"] = 235, 
		["height"] = 70, 
		["lowmana"] = 30, 
		["combatfade"] = false, 
		["predict"] = true, 
		["threatEnabled"] = true, 
		["playerExpBar"] = false, 
		["playerRepBar"] = false, 
		["health"] = 
		{
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_format"] = "[healthcolor][health:current]", 
			["position"] = "INNERRIGHT", 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
			["reversed"] = false, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 11, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["power"] = 
		{
			["enable"] = true, 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_type"] = "", 
			["text_format"] = "", 
			["height"] = 15, 
			["position"] = "INNERLEFT", 
			["hideonnpc"] = false, 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
			["detachFromFrame"] = false, 
			["detachedWidth"] = 250, 
			["attachTextToPower"] = false, 
			["druidMana"] = true, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 11, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["name"] = 
		{
			["position"] = "CENTER", 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_length"] = 21, 
			["text_format"] = "", 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 13, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["pvp"] = 
		{
			["font"] = "SVUI Number Font", 
			["fontSize"] = 12, 
			["fontOutline"] = "OUTLINE", 
			["position"] = "BOTTOM", 
			["text_format"] = "||cFFB04F4F[pvptimer][mouseover]||r", 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
		}, 
		["portrait"] = 
		{
			["enable"] = true, 
			["width"] = 50, 
			["overlay"] = true, 
			["camDistanceScale"] = 1.4, 
			["rotation"] = 0, 
			["style"] = "3D", 
		}, 
		["buffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 8, 
			["numrows"] = 1, 
			["attachTo"] = "DEBUFFS", 
			["anchorPoint"] = "TOPLEFT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = true, 
			["filterRaid"] = true, 
			["filterBlocked"] = true, 
			["filterAllowed"] = true, 
			["filterInfinite"] = true, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 0, 
			["yOffset"] = 8, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = true, 
			["perrow"] = 8, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "TOPLEFT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = false, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = false, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] =  0, 
			["yOffset"] = 8, 
			["sizeOverride"] = 0, 
		}, 
		["aurabar"] = 
		{
			["enable"] = false, 
			["anchorPoint"] = "ABOVE", 
			["attachTo"] = "DEBUFFS", 
			["filterPlayer"] = true, 
			["filterRaid"] = true, 
			["filterBlocked"] = true, 
			["filterAllowed"] = true, 
			["filterInfinite"] = true, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["friendlyAuraType"] = "HELPFUL", 
			["enemyAuraType"] = "HARMFUL", 
			["height"] = 18, 
			["sort"] = "TIME_REMAINING", 
		}, 
		["castbar"] = 
		{
			["enable"] = true, 
			["width"] = 235, 
			["height"] = 20, 
			["detachFromFrame"] = false, 
			["icon"] = true, 
			["latency"] = false, 
			["format"] = "REMAINING", 
			["ticks"] = false, 
			["spark"] = true, 
			["displayTarget"] = false, 
		}, 
		["classbar"] = 
		{
			["enable"] = true, 
			["slideLeft"] = true, 
			["inset"] = "inset", 
			["height"] = 30, 
			["detachFromFrame"] = false, 
			["detachedWidth"] = 250, 
		}, 
		["icons"] = 
		{
			["raidicon"] = 
			{
				["enable"] = true, 
				["size"] = 30, 
				["attachTo"] = "INNERRIGHT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
			["combatIcon"] = {
				["enable"] = true, 
				["size"] = 26, 
				["attachTo"] = "INNERTOPRIGHT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
			["restIcon"] = {
				["enable"] = true, 
				["size"] = 26, 
				["attachTo"] = "INNERTOPRIGHT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
		}, 
		["stagger"] = 
		{
			["enable"] = true, 
		}, 
	}, 
	["target"] = {
		["enable"] = true, 
		["width"] = 235, 
		["height"] = 70, 
		["threatEnabled"] = true, 
		["rangeCheck"] = true, 
		["predict"] = true, 
		["smartAuraDisplay"] = "DISABLED", 
		["middleClickFocus"] = true, 
		["health"] = 
		{
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_format"] = "[healthcolor][health:current]", 
			["position"] = "INNERLEFT", 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
			["reversed"] = true, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 11, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["power"] = 
		{
			["enable"] = true, 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_type"] = "", 
			["text_format"] = "", 
			["height"] = 13, 
			["position"] = "CENTER", 
			["hideonnpc"] = true, 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
			["attachTextToPower"] = false, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 11, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["name"] = 
		{
			["position"] = "INNERRIGHT", 
			["text_colored"] = true, 
			["text_smartlevel"] = true, 
			["text_length"] = 18, 
			["text_format"] = "[namecolor][name:18] [shortclassification]", 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 13, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["level"] = 
		{
			["enable"] = true, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 18, 
			["fontOutline"] = "OUTLINE", 
			["position"] = "BOTTOMRIGHT", 
			["text_format"] = "[difficultycolor][smartlevel]", 
		}, 
		["portrait"] = 
		{
			["enable"] = true, 
			["width"] = 50, 
			["overlay"] = true, 
			["rotation"] = 0, 
			["camDistanceScale"] = 1.4, 
			["style"] = "3D", 
		}, 
		["buffs"] = 
		{
			["enable"] = true, 
			["perrow"] = 8, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "TOPRIGHT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "LEFT", 
			["filterPlayer"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterRaid"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterBlocked"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "", 
			["xOffset"] = 0, 
			["yOffset"] = 8, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = true, 
			["perrow"] = 8, 
			["numrows"] = 1, 
			["attachTo"] = "BUFFS", 
			["anchorPoint"] = "TOPRIGHT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "LEFT", 
			["filterPlayer"] = 
			{
				friendly = false, 
				enemy = true, 
			}, 
			["filterBlocked"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "", 
			["xOffset"] = 0, 
			["yOffset"] = 8, 
			["sizeOverride"] = 0, 
		}, 
		["aurabar"] = 
		{
			["enable"] = false, 
			["anchorPoint"] = "ABOVE", 
			["attachTo"] = "DEBUFFS", 
			["filterPlayer"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterBlocked"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterRaid"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "", 
			["friendlyAuraType"] = "HELPFUL", 
			["enemyAuraType"] = "HARMFUL", 
			["height"] = 18, 
			["sort"] = "TIME_REMAINING", 
		}, 
		["castbar"] = 
		{
			["enable"] = true, 
			["width"] = 235, 
			["height"] = 20, 
			["detachFromFrame"] = false, 
			["icon"] = true, 
			["format"] = "REMAINING", 
			["spark"] = true, 
		}, 
		["combobar"] = 
		{
			["enable"] = true, 
			["height"] = 30, 
			["smallIcons"] = false, 
			["hudStyle"] = false, 
			["hudScale"] = 64, 
			["autoHide"] = true, 
		}, 
		["icons"] = 
		{
			["raidicon"] = 
			{
				["enable"] = true, 
				["size"] = 30, 
				["attachTo"] = "INNERLEFT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}
		}, 
		["misc"] = 
		{
			["xray"] = 
			{
				["enable"] = true, 
			}, 
			["gps"] = 
			{
				["enable"] = true, 
			}, 
		}, 
	}, 
	["targettarget"] = {
		["enable"] = true, 
		["rangeCheck"] = true, 
		["threatEnabled"] = false, 
		["width"] = 150, 
		["height"] = 30, 
		["health"] = 
		{
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_type"] = "", 
			["text_format"] = "", 
			["position"] = "INNERRIGHT", 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
			["reversed"] = false, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 9, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["power"] = 
		{
			["enable"] = false, 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_type"] = "", 
			["text_format"] = "", 
			["height"] = 7, 
			["position"] = "INNERLEFT", 
			["hideonnpc"] = false, 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 9, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["name"] = 
		{
			["position"] = "CENTER", 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_length"] = 10, 
			["text_format"] = "[namecolor][name:10]", 
			["xOffset"] = 0, 
			["yOffset"] = 1, 
			["font"] = "SVUI Narrator Font", 
			["fontSize"] = 14, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["portrait"] = 
		{
			["enable"] = true, 
			["width"] = 45, 
			["overlay"] = true, 
			["rotation"] = 0, 
			["camDistanceScale"] = 1, 
			["style"] = "3D", 
		}, 
		["buffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 7, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "BOTTOMLEFT", 
			["verticalGrowth"] = "DOWN", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = 
			{
				friendly = true, 
				enemy = false, 
			}, 
			["filterRaid"] = 
			{
				friendly = true, 
				enemy = false, 
			}, 
			["filterBlocked"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = true, 
				enemy = false, 
			}, 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "", 
			["xOffset"] =  0, 
			["yOffset"] =  -8, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 5, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "TOPLEFT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = 
			{
				friendly = false, 
				enemy = true, 
			}, 
			["filterBlocked"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "", 
			["xOffset"] =  0, 
			["yOffset"] =  8, 
			["sizeOverride"] = 0, 
		}, 
		["icons"] = 
		{
			["raidicon"] = 
			{
				["enable"] = true, 
				["size"] = 18, 
				["attachTo"] = "INNERRIGHT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
		}, 
	}, 
	["focus"] = {
		["enable"] = true, 
		["rangeCheck"] = true, 
		["threatEnabled"] = true, 
		["width"] = 170, 
		["height"] = 30, 
		["predict"] = false, 
		["smartAuraDisplay"] = "DISABLED", 
		["health"] = 
		{
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_type"] = "", 
			["text_format"] = "", 
			["position"] = "INNERRIGHT", 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
			["reversed"] = false, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["power"] = 
		{
			["enable"] = true, 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_type"] = "", 
			["text_format"] = "", 
			["height"] = 7, 
			["position"] = "INNERLEFT", 
			["hideonnpc"] = false, 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["name"] = 
		{
			["position"] = "CENTER", 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_length"] = 15, 
			["text_format"] = "[namecolor][name:15]", 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
			["font"] = "SVUI Narrator Font", 
			["fontSize"] = 14, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["buffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 7, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "BOTTOMRIGHT", 
			["verticalGrowth"] = "DOWN", 
			["horizontalGrowth"] = "LEFT", 
			["filterPlayer"] = 
			{
				friendly = true, 
				enemy = false, 
			}, 
			["filterRaid"] = 
			{
				friendly = true, 
				enemy = false, 
			}, 
			["filterBlocked"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = true, 
				enemy = false, 
			}, 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "", 
			["xOffset"] = 0, 
			["yOffset"] = -8, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = true, 
			["perrow"] = 5, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "TOPRIGHT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "LEFT", 
			["filterPlayer"] = 
			{
				friendly = false, 
				enemy = true, 
			}, 
			["filterBlocked"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "", 
			["xOffset"] = 0, 
			["yOffset"] = 8, 
			["sizeOverride"] = 0, 
		}, 
		["castbar"] = 
		{
			["enable"] = true, 
			["width"] = 170, 
			["height"] = 18, 
			["icon"] = true, 
			["format"] = "REMAINING", 
			["spark"] = true, 
		}, 
		["aurabar"] = 
		{
			["enable"] = false, 
			["anchorPoint"] = "ABOVE", 
			["attachTo"] = "FRAME", 
			["filterPlayer"] = 
			{
				friendly = false, 
				enemy = true, 
			}, 
			["filterBlocked"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterRaid"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["useFilter"] = "", 
			["friendlyAuraType"] = "HELPFUL", 
			["enemyAuraType"] = "HARMFUL", 
			["height"] = 18, 
			["sort"] = "TIME_REMAINING", 
		}, 
		["icons"] = 
		{
			["raidicon"] = 
			{
				["enable"] = true, 
				["size"] = 18, 
				["attachTo"] = "INNERLEFT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
		}, 
	}, 
	["focustarget"] = {
		["enable"] = false, 
		["rangeCheck"] = true, 
		["threatEnabled"] = false, 
		["width"] = 150, 
		["height"] = 26, 
		["health"] = 
		{
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_type"] = "", 
			["text_format"] = "", 
			["position"] = "INNERRIGHT", 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
			["reversed"] = false, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["power"] = 
		{
			["enable"] = false, 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_type"] = "", 
			["text_format"] = "", 
			["height"] = 7, 
			["position"] = "INNERLEFT", 
			["hideonnpc"] = false, 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["name"] = 
		{
			["position"] = "CENTER", 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_length"] = 15, 
			["text_format"] = "[namecolor][name:15]", 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["font"] = "SVUI Narrator Font", 
			["fontSize"] = 14, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["buffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 7, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "BOTTOMLEFT", 
			["verticalGrowth"] = "DOWN", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = 
			{
				friendly = true, 
				enemy = false, 
			}, 
			["filterRaid"] = 
			{
				friendly = true, 
				enemy = false, 
			}, 
			["filterBlocked"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = true, 
				enemy = false, 
			}, 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "", 
			["xOffset"] = 0, 
			["yOffset"] = -8, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 5, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "TOPLEFT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = 
			{
				friendly = false, 
				enemy = true, 
			}, 
			["filterBlocked"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "", 
			["xOffset"] = 0, 
			["yOffset"] = 8, 
			["sizeOverride"] = 0, 
		}, 
		["icons"] = 
		{
			["raidicon"] = 
			{
				["enable"] = true, 
				["size"] = 18, 
				["attachTo"] = "INNERLEFT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
		}, 
	}, 
	["pet"] = {
		["enable"] = true, 
		["rangeCheck"] = true, 
		["threatEnabled"] = true, 
		["width"] = 150, 
		["height"] = 30, 
		["predict"] = false, 
		["health"] = 
		{
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_type"] = "", 
			["text_format"] = "", 
			["position"] = "INNERRIGHT", 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["reversed"] = false, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["power"] = 
		{
			["enable"] = false, 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_type"] = "", 
			["text_format"] = "", 
			["height"] = 7, 
			["position"] = "INNERLEFT", 
			["hideonnpc"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["name"] = 
		{
			["position"] = "CENTER", 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_length"] = 8, 
			["text_format"] = "[namecolor][name:8]", 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["font"] = "SVUI Narrator Font", 
			["fontSize"] = 14, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["portrait"] = 
		{
			["enable"] = true, 
			["width"] = 45, 
			["overlay"] = true, 
			["rotation"] = 0, 
			["camDistanceScale"] = 1, 
			["style"] = "3D", 
		}, 
		["buffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 7, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "BOTTOMLEFT", 
			["verticalGrowth"] = "DOWN", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = true, 
			["filterRaid"] = true, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = true, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 0, 
			["yOffset"] = -8, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 5, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "BOTTOMRIGHT", 
			["verticalGrowth"] = "DOWN", 
			["horizontalGrowth"] = "LEFT", 
			["filterPlayer"] = false, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = false, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 0, 
			["yOffset"] = 8, 
			["sizeOverride"] = 0, 
		}, 
		["castbar"] = 
		{
			["enable"] = true, 
			["width"] = 130, 
			["height"] = 8, 
			["icon"] = false, 
			["format"] = "REMAINING", 
			["spark"] = false, 
		}, 
		["buffIndicator"] = 
		{
			["enable"] = true, 
			["size"] = 8, 
		}, 
	}, 
	["pettarget"] = {
		["enable"] = false, 
		["rangeCheck"] = true, 
		["threatEnabled"] = false, 
		["width"] = 130, 
		["height"] = 26, 
		["health"] = 
		{
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_type"] = "", 
			["text_format"] = "", 
			["position"] = "INNERRIGHT", 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["reversed"] = false, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["power"] = 
		{
			["enable"] = false, 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_type"] = "", 
			["text_format"] = "", 
			["height"] = 7, 
			["position"] = "INNERLEFT", 
			["hideonnpc"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["name"] = 
		{
			["position"] = "CENTER", 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_length"] = 15, 
			["text_format"] = "[namecolor][name:15]", 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["font"] = "SVUI Narrator Font", 
			["fontSize"] = 14, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["buffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 7, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "BOTTOMLEFT", 
			["verticalGrowth"] = "DOWN", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = 
			{
				friendly = true, 
				enemy = false, 
			}, 
			["filterRaid"] = 
			{
				friendly = true, 
				enemy = false, 
			}, 
			["filterBlocked"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = true, 
				enemy = false, 
			}, 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "", 
			["xOffset"] = 0, 
			["yOffset"] = -8, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 5, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "BOTTOMRIGHT", 
			["verticalGrowth"] = "DOWN", 
			["horizontalGrowth"] = "LEFT", 
			["filterPlayer"] = 
			{
				friendly = false, 
				enemy = true, 
			}, 
			["filterBlocked"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "", 
			["xOffset"] = 0, 
			["yOffset"] = 8, 
			["sizeOverride"] = 0, 
		}, 
	}, 
	["boss"] = {
		["enable"] = true, 
		["rangeCheck"] = true, 
		["showBy"] = "UP", 
		["width"] = 200, 
		["height"] = 45, 
		["health"] = 
		{
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_format"] = "[healthcolor][health:current]", 
			["position"] = "TOPRIGHT", 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["reversed"] = true, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 12, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["power"] = 
		{
			["enable"] = true, 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_format"] = "[powercolor][power:current]", 
			["height"] = 7, 
			["position"] = "BOTTOMRIGHT", 
			["hideonnpc"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 12, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["portrait"] = 
		{
			["enable"] = true, 
			["width"] = 35, 
			["overlay"] = true, 
			["rotation"] = 0, 
			["camDistanceScale"] = 1, 
			["style"] = "3D", 
		}, 
		["name"] = 
		{
			["position"] = "INNERLEFT", 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_length"] = 15, 
			["text_format"] = "[namecolor][name:15]", 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 12, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["buffs"] = 
		{
			["enable"] = true, 
			["perrow"] = 2, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "LEFT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "LEFT", 
			["filterPlayer"] = false, 
			["filterRaid"] = false, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = false, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] =  -8, 
			["yOffset"] =  0, 
			["sizeOverride"] = 40, 
		}, 
		["debuffs"] = 
		{
			["enable"] = true, 
			["perrow"] = 3, 
			["numrows"] = 1, 
			["attachTo"] = "BUFFS", 
			["anchorPoint"] = "LEFT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "LEFT", 
			["filterPlayer"] = true, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = false, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] =  -8, 
			["yOffset"] =  0, 
			["sizeOverride"] = 40, 
		}, 
		["castbar"] = 
		{
			["enable"] = true, 
			["width"] = 200, 
			["height"] = 18, 
			["icon"] = true, 
			["format"] = "REMAINING", 
			["spark"] = true, 
		}, 
		["icons"] = 
		{
			["raidicon"] = 
			{
				["enable"] = true, 
				["size"] = 18, 
				["attachTo"] = "INNERRIGHT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
		}, 
	}, 
	["arena"] = {
		["enable"] = true, 
		["rangeCheck"] = true, 
		["showBy"] = "UP", 
		["width"] = 215, 
		["height"] = 45, 
		["pvpSpecIcon"] = true, 
		["predict"] = false, 
		["colorOverride"] = "USE_DEFAULT", 
		["health"] = 
		{
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_format"] = "[healthcolor][health:current]", 
			["position"] = "TOPRIGHT", 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["reversed"] = true, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 12, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["power"] = 
		{
			["enable"] = true, 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_format"] = "[powercolor][power:current]", 
			["height"] = 7, 
			["position"] = "BOTTOMRIGHT", 
			["hideonnpc"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 12, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["name"] = 
		{
			["position"] = "INNERLEFT", 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_length"] = 15, 
			["text_format"] = "[namecolor][name:15]", 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 12, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["portrait"] = 
		{
			["enable"] = true, 
			["width"] = 45, 
			["overlay"] = true, 
			["rotation"] = 0, 
			["camDistanceScale"] = 1, 
			["style"] = "3D", 
		}, 
		["buffs"] = 
		{
			["enable"] = true, 
			["perrow"] = 3, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "LEFT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "LEFT", 
			["filterPlayer"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterRaid"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterBlocked"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "Shield", 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["xOffset"] = -8, 
			["yOffset"] = 0, 
			["sizeOverride"] = 40, 
		}, 
		["debuffs"] = 
		{
			["enable"] = true, 
			["perrow"] = 3, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "LEFT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "LEFT", 
			["filterPlayer"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterBlocked"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "CC", 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["xOffset"] = -8, 
			["yOffset"] = 0, 
			["sizeOverride"] = 40, 
		}, 
		["castbar"] = 
		{
			["enable"] = true, 
			["width"] = 215, 
			["height"] = 18, 
			["icon"] = true, 
			["format"] = "REMAINING", 
			["spark"] = true, 
		}, 
		["pvpTrinket"] = 
		{
			["enable"] = true, 
			["position"] = "INNERLEFT", 
			["size"] = 45, 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
		}, 
	}, 
	["party"] = {
		["enable"] = true, 
		["rangeCheck"] = true, 
		["threatEnabled"] = true, 
		["visibility"] = "[@raid6, exists][nogroup] hide;show", 
		["showBy"] = "UP_RIGHT", 
		["wrapXOffset"] = 9, 
		["wrapYOffset"] = 13, 
		["gCount"] = 1, 
		["gRowCol"] = 1, 
		["sortMethod"] = "GROUP", 
		["sortDir"] = "ASC", 
		["rSort"] = false, 
		["invertGroupingOrder"] = false, 
		["startFromCenter"] = false, 
		["showPlayer"] = true, 
		["predict"] = false, 
		["colorOverride"] = "USE_DEFAULT", 
		["gridMode"] = false, 
		["width"] = 70, 
		["height"] = 70, 
		["health"] = 
		{
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_type"] = "", 
			["text_format"] = "", 
			["position"] = "BOTTOM", 
			["orientation"] = "HORIZONTAL", 
			["frequentUpdates"] = true, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["reversed"] = false, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["power"] = 
		{
			["enable"] = true, 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_type"] = "", 
			["text_format"] = "", 
			["height"] = 7, 
			["position"] = "BOTTOMRIGHT", 
			["hideonnpc"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["name"] = 
		{
			["position"] = "INNERTOPLEFT", 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_length"] = 10, 
			["text_format"] = "[namecolor][name:10]", 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["font"] = "SVUI Narrator Font", 
			["fontSize"] = 13, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["buffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 2, 
			["numrows"] = 2, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "RIGHTTOP", 
			["verticalGrowth"] = "DOWN", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = true, 
			["filterRaid"] = true, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = true, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 8, 
			["yOffset"] = 0, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = true, 
			["perrow"] = 2, 
			["numrows"] = 2, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "RIGHTTOP", 
			["verticalGrowth"] = "DOWN", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = false, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = false, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 8, 
			["yOffset"] = 0, 
			["sizeOverride"] = 0, 
		}, 
		["buffIndicator"] = 
		{
			["enable"] = true, 
			["size"] = 8, 
			["fontSize"] = 11, 
		}, 
		["petsGroup"] = 
		{
			["enable"] = false, 
			["width"] = 30, 
			["height"] = 30, 
			["anchorPoint"] = "BOTTOMLEFT", 
			["xOffset"] =  - 1, 
			["yOffset"] = 0, 
			["text_length"] = 3, 
			["text_format"] = "[name:3]", 
		}, 
		["targetsGroup"] = 
		{
			["enable"] = false, 
			["width"] = 30, 
			["height"] = 30, 
			["anchorPoint"] = "TOPLEFT", 
			["xOffset"] =  - 1, 
			["yOffset"] = 0, 
			["text_length"] = 3, 
			["text_format"] = "[name:3]", 
		}, 
		["icons"] = 
		{
			["raidicon"] = 
			{
				["enable"] = true, 
				["size"] = 25, 
				["attachTo"] = "INNERBOTTOMLEFT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
			["roleIcon"] = 
			{
				["enable"] = true, 
				["size"] = 18, 
				["attachTo"] = "INNERBOTTOMRIGHT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
			["raidRoleIcons"] = 
			{
				["enable"] = true, 
				["size"] = 18, 
				["attachTo"] = "TOPLEFT", 
				["xOffset"] = 0, 
				["yOffset"] = -4, 
			}, 
		}, 
		["portrait"] = 
		{
			["enable"] = true, 
			["width"] = 45, 
			["overlay"] = true, 
			["rotation"] = 0, 
			["camDistanceScale"] = 1, 
			["style"] = "3D", 
		}, 
	}, 
	["raid10"] = {
		["enable"] = true, 
		["rangeCheck"] = true, 
		["threatEnabled"] = true, 
		["visibility"] = "[@raid6, noexists][@raid11, exists] hide;show", 
		["showBy"] = "RIGHT_DOWN", 
		["wrapXOffset"] = 8, 
		["wrapYOffset"] = 8, 
		["gCount"] = 2, 
		["gRowCol"] = 1, 
		["sortMethod"] = "GROUP", 
		["sortDir"] = "ASC", 
		["showPlayer"] = true, 
		["predict"] = false, 
		["colorOverride"] = "USE_DEFAULT", 
		["gridMode"] = false, 
		["width"] = 75, 
		["height"] = 34, 
		["health"] = 
		{
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_type"] = "", 
			["text_format"] = "", 
			["position"] = "BOTTOM", 
			["orientation"] = "HORIZONTAL", 
			["frequentUpdates"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["reversed"] = false, 
			["font"] = "SVUI Default Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["power"] = 
		{
			["enable"] = true, 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_type"] = "", 
			["text_format"] = "", 
			["height"] = 4, 
			["position"] = "BOTTOMRIGHT", 
			["hideonnpc"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["font"] = "SVUI Default Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["name"] = 
		{
			["position"] = "INNERTOPLEFT", 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_length"] = 4, 
			["text_format"] = "[namecolor][name:4]", 
			["yOffset"] = 4, 
			["xOffset"] = 0, 
			["font"] = "SVUI Default Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["buffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 3, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "RIGHT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = true, 
			["filterRaid"] = true, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = true, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 8, 
			["yOffset"] = 0, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 3, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "RIGHT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = false, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = false, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 8, 
			["yOffset"] = 0, 
			["sizeOverride"] = 0, 
		}, 
		["buffIndicator"] = 
		{
			["enable"] = true, 
			["size"] = 8, 
		}, 
		["rdebuffs"] = 
		{
			["enable"] = true, 
			["size"] = 26, 
			["xOffset"] = 0, 
			["yOffset"] = 2, 
		}, 
		["icons"] = 
		{
			["raidicon"] = 
			{
				["enable"] = true, 
				["size"] = 15, 
				["attachTo"] = "INNERBOTTOMRIGHT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
			["roleIcon"] = 
			{
				["enable"] = true, 
				["size"] = 12, 
				["attachTo"] = "INNERBOTTOMLEFT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
			["raidRoleIcons"] = 
			{
				["enable"] = true, 
				["size"] = 18, 
				["attachTo"] = "TOPLEFT", 
				["xOffset"] = 0, 
				["yOffset"] = -4, 
			}, 
		}, 
	}, 
	["raid25"] = {
		["enable"] = true, 
		["rangeCheck"] = true, 
		["threatEnabled"] = true, 
		["visibility"] = "[@raid11, noexists][@raid26, exists] hide;show", 
		["showBy"] = "RIGHT_DOWN", 
		["wrapXOffset"] = 8, 
		["wrapYOffset"] = 8, 
		["gCount"] = 5, 
		["gRowCol"] = 1, 
		["sortMethod"] = "GROUP", 
		["sortDir"] = "ASC", 
		["showPlayer"] = true, 
		["predict"] = false, 
		["colorOverride"] = "USE_DEFAULT", 
		["gridMode"] = false, 
		["width"] = 50, 
		["height"] = 30, 
		["health"] = 
		{
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_type"] = "", 
			["text_format"] = "", 
			["position"] = "BOTTOM", 
			["orientation"] = "HORIZONTAL", 
			["frequentUpdates"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["reversed"] = false, 
			["font"] = "SVUI Default Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["power"] = 
		{
			["enable"] = true, 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_type"] = "", 
			["text_format"] = "", 
			["height"] = 4, 
			["position"] = "BOTTOMRIGHT", 
			["hideonnpc"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["font"] = "SVUI Default Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["name"] = 
		{
			["position"] = "INNERTOPLEFT", 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_length"] = 4, 
			["text_format"] = "[namecolor][name:4]", 
			["yOffset"] = 4, 
			["xOffset"] = 0, 
			["font"] = "SVUI Default Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["buffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 3, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "RIGHT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = true, 
			["filterRaid"] = true, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = true, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 8, 
			["yOffset"] = 0, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 3, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "RIGHT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = false, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = false, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 8, 
			["yOffset"] = 0, 
			["sizeOverride"] = 0, 
		}, 
		["buffIndicator"] = 
		{
			["enable"] = true, 
			["size"] = 8, 
		}, 
		["rdebuffs"] = 
		{
			["enable"] = true, 
			["size"] = 26, 
			["xOffset"] = 0, 
			["yOffset"] = 2, 
		}, 
		["icons"] = 
		{
			["raidicon"] = 
			{
				["enable"] = true, 
				["size"] = 15, 
				["attachTo"] = "INNERBOTTOMRIGHT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
			["roleIcon"] = 
			{
				["enable"] = true, 
				["size"] = 12, 
				["attachTo"] = "INNERBOTTOMLEFT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
			["raidRoleIcons"] = 
			{
				["enable"] = true, 
				["size"] = 18, 
				["attachTo"] = "TOPLEFT", 
				["xOffset"] = 0, 
				["yOffset"] = -4, 
			}, 
		}, 
	}, 
	["raid40"] = {
		["enable"] = true, 
		["rangeCheck"] = true, 
		["threatEnabled"] = true, 
		["visibility"] = "[@raid26, noexists] hide;show", 
		["showBy"] = "RIGHT_DOWN", 
		["wrapXOffset"] = 8, 
		["wrapYOffset"] = 8, 
		["gCount"] = 8, 
		["gRowCol"] = 1, 
		["sortMethod"] = "GROUP", 
		["sortDir"] = "ASC", 
		["showPlayer"] = true, 
		["predict"] = false, 
		["colorOverride"] = "USE_DEFAULT", 
		["gridMode"] = false, 
		["width"] = 50, 
		["height"] = 30, 
		["health"] = 
		{
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_type"] = "", 
			["text_format"] = "", 
			["position"] = "BOTTOM", 
			["orientation"] = "HORIZONTAL", 
			["frequentUpdates"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["reversed"] = false, 
			["font"] = "SVUI Default Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["power"] = 
		{
			["enable"] = false, 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_type"] = "", 
			["text_format"] = "", 
			["height"] = 4, 
			["position"] = "BOTTOMRIGHT", 
			["hideonnpc"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["font"] = "SVUI Default Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["name"] = 
		{
			["position"] = "INNERTOPLEFT", 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_length"] = 4, 
			["text_format"] = "[namecolor][name:4]", 
			["yOffset"] = 4, 
			["xOffset"] = 0, 
			["font"] = "SVUI Default Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["buffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 3, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "RIGHT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = true, 
			["filterRaid"] = true, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = true, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 8, 
			["yOffset"] = 0, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 3, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "RIGHT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = false, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = false, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 8, 
			["yOffset"] = 0, 
			["sizeOverride"] = 0, 
		}, 
		["rdebuffs"] = 
		{
			["enable"] = true, 
			["size"] = 22, 
			["xOffset"] = 0, 
			["yOffset"] = 2, 
		}, 
		["buffIndicator"] = 
		{
			["enable"] = true, 
			["size"] = 8, 
		}, 
		["icons"] = 
		{
			["raidicon"] = 
			{
				["enable"] = true, 
				["size"] = 15, 
				["attachTo"] = "INNERBOTTOMRIGHT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
			["roleIcon"] = 
			{
				["enable"] = true, 
				["size"] = 12, 
				["attachTo"] = "INNERBOTTOMLEFT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
			["raidRoleIcons"] = 
			{
				["enable"] = true, 
				["size"] = 18, 
				["attachTo"] = "TOPLEFT", 
				["xOffset"] = 0, 
				["yOffset"] = -4, 
			}, 
		}, 
	}, 
	["raidpet"] = {
		["enable"] = false, 
		["rangeCheck"] = true, 
		["threatEnabled"] = true, 
		["visibility"] = "[group:raid] show; hide", 
		["showBy"] = "DOWN_RIGHT", 
		["wrapXOffset"] = 3, 
		["wrapYOffset"] = 3, 
		["gCount"] = 2, 
		["gRowCol"] = 1, 
		["sortMethod"] = "PETNAME", 
		["sortDir"] = "ASC", 
		["rSort"] = true, 
		["invertGroupingOrder"] = false, 
		["startFromCenter"] = false, 
		["predict"] = false, 
		["colorOverride"] = "USE_DEFAULT", 
		["gridMode"] = false, 
		["width"] = 80, 
		["height"] = 30, 
		["health"] = 
		{
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_format"] = "[healthcolor][health:deficit]", 
			["position"] = "BOTTOM", 
			["orientation"] = "HORIZONTAL", 
			["frequentUpdates"] = true, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["reversed"] = false, 
			["font"] = "SVUI Default Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["name"] = 
		{
			["position"] = "INNERTOPLEFT", 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_length"] = 4, 
			["text_format"] = "[namecolor][name:4]", 
			["yOffset"] = 4, 
			["xOffset"] = -4, 
			["font"] = "SVUI Default Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["buffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 3, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "RIGHT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = true, 
			["filterRaid"] = true, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = true, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 8, 
			["yOffset"] = 0, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 3, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "RIGHT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = false, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = false, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 8, 
			["yOffset"] = 0, 
			["sizeOverride"] = 0, 
		}, 
		["buffIndicator"] = 
		{
			["enable"] = true, 
			["size"] = 8, 
		}, 
		["rdebuffs"] = 
		{
			["enable"] = true, 
			["size"] = 26, 
			["xOffset"] = 0, 
			["yOffset"] = 2, 
		}, 
		["icons"] = 
		{
			["raidicon"] = 
			{
				["enable"] = true, 
				["size"] = 18, 
				["attachTo"] = "INNERTOPLEFT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
		}, 
	}, 
	["tank"] = {
		["enable"] = true, 
		["threatEnabled"] = true, 
		["rangeCheck"] = true, 
		["gridMode"] = false, 
		["width"] = 120, 
		["height"] = 28, 
		["health"] = 
		{
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_format"] = "[healthcolor][health:deficit]", 
			["position"] = "INNERRIGHT", 
			["orientation"] = "HORIZONTAL", 
			["frequentUpdates"] = true, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["reversed"] = false, 
			["font"] = "SVUI Default Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["name"] = 
		{
			["position"] = "INNERLEFT", 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_length"] = 8, 
			["text_format"] = "[namecolor][name:8]", 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["font"] = "SVUI Default Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["targetsGroup"] = 
		{
			["enable"] = false, 
			["anchorPoint"] = "RIGHT", 
			["xOffset"] = 1, 
			["yOffset"] = 0, 
			["width"] = 120, 
			["height"] = 28, 
		}, 
	}, 
	["assist"] = {
		["enable"] = true, 
		["threatEnabled"] = true, 
		["rangeCheck"] = true, 
		["gridMode"] = false, 
		["width"] = 120, 
		["height"] = 28, 
		["health"] = 
		{
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_format"] = "[healthcolor][health:deficit]", 
			["position"] = "INNERRIGHT", 
			["orientation"] = "HORIZONTAL", 
			["frequentUpdates"] = true, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["reversed"] = false, 
			["font"] = "SVUI Default Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["name"] = 
		{
			["position"] = "INNERLEFT", 
			["text_colored"] = true, 
			["text_smartlevel"] = false, 
			["text_length"] = 8, 
			["text_format"] = "[namecolor][name:8]", 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["font"] = "SVUI Default Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["targetsGroup"] = 
		{
			["enable"] = false, 
			["anchorPoint"] = "RIGHT", 
			["xOffset"] = 1, 
			["yOffset"] = 0, 
			["width"] = 120, 
			["height"] = 28, 
		}, 
	}, 
};
--[[ 
########################################################## 
DB PROTECTED VARS
##########################################################
]]--
P["SVUnit"] = {
	["enable"] = true, 
	["disableBlizzard"] = true
};
--[[ 
########################################################## 
DB STATIC VARS  **Courtesy of ElvUI**
##########################################################
]]--
local function SpellName(id)
	local name, _, _, _, _, _, _, _, _ = GetSpellInfo(id) 	
	if not name then
		print('|cffFF9900SVUI:|r Spell not found: (#ID) '..id)
		name = "Voodoo Doll";
	end
	return name
end;

G["SVUnit"] = {
	["ChannelTicks"] = {
		--Warlock
		[SpellName(1120)] = 6, --"Drain Soul"
		[SpellName(689)] = 6, -- "Drain Life"
		[SpellName(108371)] = 6, -- "Harvest Life"
		[SpellName(5740)] = 4, -- "Rain of Fire"
		[SpellName(755)] = 6, -- Health Funnel
		[SpellName(103103)] = 4, --Malefic Grasp
		--Druid
		[SpellName(44203)] = 4, -- "Tranquility"
		[SpellName(16914)] = 10, -- "Hurricane"
		--Priest
		[SpellName(15407)] = 3, -- "Mind Flay"
		[SpellName(129197)] = 3, -- "Mind Flay (Insanity)"
		[SpellName(48045)] = 5, -- "Mind Sear"
		[SpellName(47540)] = 2, -- "Penance"
		[SpellName(64901)] = 4, -- Hymn of Hope
		[SpellName(64843)] = 4, -- Divine Hymn
		--Mage
		[SpellName(5143)] = 5, -- "Arcane Missiles"
		[SpellName(10)] = 8, -- "Blizzard"
		[SpellName(12051)] = 4, -- "Evocation"
		
		--Monk
		[SpellName(115175)] = 9, -- "Smoothing Mist"
	},
	["ChannelTicksSize"] = {
	    --Warlock
	    [SpellName(1120)] = 2, --"Drain Soul"
	    [SpellName(689)] = 1, -- "Drain Life"
		[SpellName(108371)] = 1, -- "Harvest Life"
		[SpellName(103103)] = 1, -- "Malefic Grasp"
	},
	["HastedChannelTicks"] = {
		[SpellName(64901)] = true, -- Hymn of Hope
		[SpellName(64843)] = true, -- Divine Hymn
	},
	["AuraBarColors"] = {
		[SpellName(2825)] = {250/255, 146/255, 27/255},	--Bloodlust
		[SpellName(32182)] = {250/255, 146/255, 27/255}, --Heroism
		[SpellName(80353)] = {250/255, 146/255, 27/255}, --Time Warp
		[SpellName(90355)] = {250/255, 146/255, 27/255}, --Ancient Hysteria
		[SpellName(84963)] = {250/255, 146/255, 27/255}, --Inquisition
		[SpellName(86659)] = {250/255, 146/255, 27/255}, --Guardian of Ancient Kings
	},
	["InvalidSpells"] = {
		[65148] = true, --Sacred Shield
	}
}
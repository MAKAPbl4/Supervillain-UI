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
local unpack 	= _G.unpack;
local select 	= _G.select;
local pairs 	= _G.pairs;
local string 	= _G.string;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, G = unpack(SVUI);
local MOD = SuperVillain:GetModule('SVStyle');
--[[ 
########################################################## 
DBM
##########################################################
]]--
local function StyleDBM(event, addon)
	if event == 'PLAYER_ENTERING_WORLD' then
		local croprwicons = true
		local buttonsize = 22
		local function StyleBars(self)
			for bar in self:GetBarIterator() do
				if not bar.injected then
					bar.ApplyStyle = function()
						local frame = bar.frame
						local tbar = _G[frame:GetName()..'Bar']
						local spark = _G[frame:GetName()..'BarSpark']
						local texture = _G[frame:GetName()..'BarTexture']
						local icon1 = _G[frame:GetName()..'BarIcon1']
						local icon2 = _G[frame:GetName()..'BarIcon2']
						local name = _G[frame:GetName()..'BarName']
						local timer = _G[frame:GetName()..'BarTimer']
						if not icon1.overlay then
							icon1.overlay = CreateFrame('Frame', '$parentIcon1Overlay', tbar)
							icon1.overlay:SetFixedPanelTemplate()
							icon1.overlay:SetFrameLevel(0)
							icon1.overlay:Size(buttonsize)
							icon1.overlay:Point('BOTTOMRIGHT', frame, 'BOTTOMLEFT', -2, 0)
						end
						if not icon2.overlay then
							icon2.overlay = CreateFrame('Frame', '$parentIcon2Overlay', tbar)
							icon2.overlay:SetFixedPanelTemplate()
							icon2.overlay:SetFrameLevel(0)
							icon2.overlay:Size(buttonsize)
							icon2.overlay:Point('BOTTOMLEFT', frame, 'BOTTOMRIGHT', 2, 0)
						end
						if bar.color then
							tbar:SetStatusBarColor(bar.color.r, bar.color.g, bar.color.b)
						else
							tbar:SetStatusBarColor(bar.owner.options.StartColorR, bar.owner.options.StartColorG, bar.owner.options.StartColorB)
						end
						if bar.enlarged then
							frame:SetWidth(bar.owner.options.HugeWidth)
							tbar:SetWidth(bar.owner.options.HugeWidth)
							frame:SetScale(bar.owner.options.HugeScale)
						else
							frame:SetWidth(bar.owner.options.Width)
							tbar:SetWidth(bar.owner.options.Width)
							frame:SetScale(bar.owner.options.Scale)
						end
						spark:SetAlpha(0)
						spark:SetTexture(nil)
						icon1:SetTexCoord(0.1,0.9,0.1,0.9)
						icon1:ClearAllPoints()
						icon1:FillInner(icon1.overlay)
						icon2:SetTexCoord(0.1,0.9,0.1,0.9)
						icon2:ClearAllPoints()
						icon2:FillInner(icon2.overlay)
						texture:SetTexture(SuperVillain.Textures.default)
						tbar:FillInner(frame)
						frame:SetFixedPanelTemplate()
						name:ClearAllPoints()
						name:SetWidth(165)
						name:SetHeight(8)
						name:SetJustifyH('LEFT')
						name:SetShadowColor(0, 0, 0, 0)
						timer:ClearAllPoints()
						timer:SetJustifyH('RIGHT')
						timer:SetShadowColor(0, 0, 0, 0)
						frame:SetHeight(buttonsize)
						name:Point('LEFT', frame, 'LEFT', 4, 0)
						timer:Point('RIGHT', frame, 'RIGHT', -4, 0)
						name:SetFontTemplate(SuperVillain.Fonts.default, 12, 'OUTLINE')
						timer:SetFontTemplate(SuperVillain.Fonts.default, 12, 'OUTLINE')
						name:SetTextColor(bar.owner.options.TextColorR, bar.owner.options.TextColorG, bar.owner.options.TextColorB)
						timer:SetTextColor(bar.owner.options.TextColorR, bar.owner.options.TextColorG, bar.owner.options.TextColorB)
						if bar.owner.options.IconLeft then icon1:Show() icon1.overlay:Show() else icon1:Hide() icon1.overlay:Hide() end
						if bar.owner.options.IconRight then icon2:Show() icon2.overlay:Show() else icon2:Hide() icon2.overlay:Hide() end
						tbar:SetAlpha(1)
						frame:SetAlpha(1)
						texture:SetAlpha(1)
						frame:Show()
						bar:Update(0)
						bar.injected = true
					end
					bar:ApplyStyle()
				end
			end
		end
		local StyleBossTitle = function()
			local anchor = DBMBossHealthDropdown:GetParent()
			if not anchor.styled then
				local header = {anchor:GetRegions()}
				if header[1]:IsObjectType('FontString') then
					header[1]:SetFontTemplate(SuperVillain.Fonts.default, 12, 'OUTLINE')
					header[1]:SetTextColor(1, 1, 1)
					header[1]:SetShadowColor(0, 0, 0, 0)
					anchor.styled = true	
				end
				header = nil
			end
			anchor = nil
		end
		local StyleBoss = function()
			local count = 1
			while _G[format('DBM_BossHealth_Bar_%d', count)] do
				local bar = _G[format('DBM_BossHealth_Bar_%d', count)]
				local background = _G[bar:GetName()..'BarBorder']
				local progress = _G[bar:GetName()..'Bar']
				local name = _G[bar:GetName()..'BarName']
				local timer = _G[bar:GetName()..'BarTimer']
				local prev = _G[format('DBM_BossHealth_Bar_%d', count-1)]	
				local _, anch, _ ,_, _ = bar:GetPoint()
				bar:ClearAllPoints()
				if count == 1 then
					if DBM_SavedOptions.HealthFrameGrowUp then
						bar:Point('BOTTOM', anch, 'TOP' , 0 , 12)
					else
						bar:Point('TOP', anch, 'BOTTOM' , 0, -buttonsize)
					end
				else
					if DBM_SavedOptions.HealthFrameGrowUp then
						bar:Point('TOPLEFT', prev, 'TOPLEFT', 0, buttonsize + 4)
					else
						bar:Point('TOPLEFT', prev, 'TOPLEFT', 0, -(buttonsize + 4))
					end
				end
				bar:SetFixedPanelTemplate('Transparent')
				background:SetNormalTexture(nil)
				progress:SetStatusBarTexture(SuperVillain.Textures.default)
				progress:ClearAllPoints()
				progress:FillInner(bar)
				name:ClearAllPoints()
				name:SetJustifyH('LEFT')
				name:SetShadowColor(0, 0, 0, 0)
				timer:ClearAllPoints()
				timer:SetJustifyH('RIGHT')
				timer:SetShadowColor(0, 0, 0, 0)
				bar:SetHeight(buttonsize)
				name:Point('LEFT', bar, 'LEFT', 4, 0)
				timer:Point('RIGHT', bar, 'RIGHT', -4, 0)
				name:SetFontTemplate(SuperVillain.Fonts.default, 12, 'OUTLINE')
				timer:SetFontTemplate(SuperVillain.Fonts.default, 12, 'OUTLINE')
				count = count + 1
			end
		end
		hooksecurefunc(DBT, 'CreateBar', StyleBars)
		hooksecurefunc(DBM.BossHealth, 'Show', StyleBossTitle)
		hooksecurefunc(DBM.BossHealth, 'AddBoss', StyleBoss)
		hooksecurefunc(DBM.BossHealth, 'UpdateSettings', StyleBoss)
		if not DBM_SavedOptions['DontShowRangeFrame'] then
			DBM.RangeCheck:Show()
			DBM.RangeCheck:Hide()
			DBMRangeCheck:HookScript('OnShow', function(self) self:SetFixedPanelTemplate('Transparent') end)
			DBMRangeCheckRadar:SetFixedPanelTemplate('Transparent')
		end
		if not DBM_SavedOptions['DontShowInfoFrame'] then
			DBM.InfoFrame:Show(5, 'test')
			DBM.InfoFrame:Hide()
			DBMInfoFrame:HookScript('OnShow', function(self) self:SetFixedPanelTemplate('Transparent') end)
		end
		if croprwicons then
			local RaidNotice_AddMessage_ = RaidNotice_AddMessage
			RaidNotice_AddMessage = function(noticeFrame, textString, colorInfo)
				if textString:find(' |T') then
					textString = gsub(textString,'(:12:12)',':18:18:0:0:64:64:5:59:5:59')
				end
				return RaidNotice_AddMessage_(noticeFrame, textString, colorInfo)
			end
		end
	end
	if addon == 'DBM-GUI' then
		DBM_GUI_OptionsFrame:HookScript('OnShow', function()
			MOD:ApplyFrameStyle(DBM_GUI_OptionsFrame)
			MOD:ApplyFrameStyle(DBM_GUI_OptionsFrameBossMods)
			MOD:ApplyFrameStyle(DBM_GUI_OptionsFrameDBMOptions)
			MOD:ApplyFrameStyle(DBM_GUI_OptionsFramePanelContainer, 'Transparent', true)
		end)
		MOD:ApplyTabStyle(DBM_GUI_OptionsFrameTab1)
		MOD:ApplyTabStyle(DBM_GUI_OptionsFrameTab2)
		DBM_GUI_OptionsFrameOkay:SetButtonTemplate()
		DBM_GUI_OptionsFrameWebsiteButton:SetButtonTemplate()
		MOD:ApplyScrollStyle(DBM_GUI_OptionsFramePanelContainerFOVScrollBar)
		MOD:SafeEventRemoval("DBM", event)
	end
end
MOD:SaveAddonStyle("DBM", StyleDBM, 'ADDON_LOADED')
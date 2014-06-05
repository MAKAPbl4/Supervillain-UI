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
local unpack    = _G.unpack;
local select    = _G.select;
local pairs     = _G.pairs;
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local tinsert   = _G.tinsert;
local string    = _G.string;
local math      = _G.math;
local table     = _G.table;
--[[ STRING METHODS ]]--
local find, format, len, split = string.find, string.format, string.len, string.split;
local match, sub, join = string.match, string.sub, string.join;
--[[ MATH METHODS ]]--
local abs, ceil, floor = math.abs, math.ceil, math.floor;  -- Basic
local parsefloat = math.parsefloat;  -- Uncommon
--[[ TABLE METHODS ]]--
local tremove, tcopy, twipe, tsort, tconcat = table.remove, table.copy, table.wipe, table.sort, table.concat;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, G = unpack(select(2, ...));
local MOD = SuperVillain:GetModule('SVUnit');
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.");
local LSM = LibStub("LibSharedMedia-3.0");
--[[ 
########################################################## 
LOCAL VARIABLES
##########################################################
]]--
local ticks = {}
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function HideTicks()
	for i=1,#ticks do 
		ticks[i]:Hide()
	end 
end;
local function SetCastTicks(bar,count,mod)
	mod = mod or 0;
	HideTicks()
	if count and count <= 0 then return end;
	local barWidth = bar:GetWidth()
	local offset = barWidth / count + mod;
	for i=1,count do 
		if not ticks[i] then 
			ticks[i] = bar:CreateTexture(nil,'OVERLAY')
			ticks[i]:SetTexture(SuperVillain.Textures.lazer)
			ticks[i]:SetVertexColor(0,0,0,0.8)
			ticks[i]:Width(1)
			ticks[i]:SetHeight(bar:GetHeight())
		end;
		ticks[i]:ClearAllPoints()
		ticks[i]:SetPoint("RIGHT", bar, "LEFT", offset * i, 0)
		ticks[i]:Show()
	end 
end;
local function SetCastbarFading(frame,castbar,texture)
	local fader=CreateFrame("Frame",nil,frame)
	fader:SetFrameLevel(2)
	fader:FillInner(castbar)
	fader:SetBackdrop({bgFile=texture})
	fader:SetBackdropColor(0,0,0,0)
	fader:SetAlpha(0)
	fader:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	fader:RegisterEvent("UNIT_SPELLCAST_START")
	fader:RegisterEvent("UNIT_SPELLCAST_STOP")
	fader:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	fader:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	fader:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	fader:RegisterEvent("UNIT_SPELLCAST_FAILED")
	fader:RegisterEvent("UNIT_SPELLCAST_FAILED_QUIET")
	fader.mask=CreateFrame("Frame",nil,frame)
	fader.mask:SetBackdrop({bgFile=texture})
	fader.mask:FillInner(castbar)
	fader.mask:SetFrameLevel(2)
	fader.mask:SetBackdropColor(0,0,0,0)
	fader.mask:SetAlpha(0)
	fader.txt=fader:CreateFontString(nil,"OVERLAY")
	fader.txt:SetFont(SuperVillain.Fonts.alert,16)
	fader.txt:SetAllPoints(fader)
	fader.txt:SetJustifyH("CENTER")
	fader.txt:SetJustifyV("CENTER")
	fader.txt:SetText("")
	fader.anim=fader:CreateAnimationGroup("Flash")
	fader.anim.fadein=fader.anim:CreateAnimation("ALPHA","FadeIn")
	fader.anim.fadein:SetChange(1)
	fader.anim.fadein:SetOrder(1)
	fader.anim.fadeout1=fader.anim:CreateAnimation("ALPHA","FadeOut")
	fader.anim.fadeout1:SetChange(-.25)
	fader.anim.fadeout1:SetOrder(2)
	fader.anim.fadeout2=fader.anim:CreateAnimation("ALPHA","FadeOut")
	fader.anim.fadeout2:SetChange(-.75)
	fader.anim.fadeout2:SetOrder(3)
	fader.anim.fadein:SetDuration(0)
	fader.anim.fadeout1:SetDuration(.8)
	fader.anim.fadeout2:SetDuration(.4)
	fader:SetScript("OnEvent",function(self,event,...)
		local T=...
		if T~="player" then return end;
		if event=="UNIT_SPELLCAST_START" then 
			self.fails=nil;
			self.isokey=nil;
			self.ischanneling=nil;
			self:SetAlpha(0)
			self.mask:SetAlpha(1)
			if self.anim:IsPlaying() then 
				self.anim:Stop()
			end 
		elseif event=="UNIT_SPELLCAST_CHANNEL_START" then 
			self:SetAlpha(0)
			self.mask:SetAlpha(1)
			if self.anim:IsPlaying() then 
				self.anim:Stop()
			end;
			self.iscasting=nil;
			self.fails=nil;
			self.isokey=nil 
		elseif event=="UNIT_SPELLCAST_SUCCEEDED" then 
			self.fails=nil;
			self.isokey=true;
			self.fails_a=nil 
		elseif event=="UNIT_SPELLCAST_FAILED" or event=="UNIT_SPELLCAST_FAILED_QUIET" then 
			self.fails=true;
			self.isokey=nil;
			self.fails_a=nil 
		elseif event=="UNIT_SPELLCAST_INTERRUPTED" then 
			self.fails=nil;
			self.isokey=nil;
			self.fails_a=true 
		elseif event=="UNIT_SPELLCAST_STOP" then 
			if self.fails or self.fails_a then 
				self:SetBackdropColor(1,0.2,0.2,0.5)
				self.txt:SetText(SPELL_FAILED_FIZZLE)
				self.txt:SetTextColor(1,0.8,0,0.5)
			elseif self.isokey then 
				self:SetBackdropColor(0.2,1,0.2,0.5)
				self.txt:SetText(SUCCESS)
				self.txt:SetTextColor(0.5,1,0.4,0.5)
			end;
			self.mask:SetAlpha(0)
			self:SetAlpha(0)
			if not self.anim:IsPlaying() then 
				self.anim:Play()
			end 
		elseif event=="UNIT_SPELLCAST_CHANNEL_STOP" then 
			self.mask:SetAlpha(0)
			self:SetAlpha(0)
			if self.fails_a then 
				self:SetBackdropColor(1,0.2,0.2,0.5)
				self.txt:SetText(SPELL_FAILED_FIZZLE)
				self.txt:SetTextColor(0.5,1,0.4,0.5)
				if not self.anim:IsPlaying() then 
					self.anim:Play()
				end 
			end 
		end 
	end)
end;
local CustomCastDelayText = function(self, value)
	local db=self:GetParent().db;
	if not db then return end;
	if self.channeling then 
		if db.castbar.format=='CURRENT' then 
			self.Time:SetText(("%.1f |cffaf5050%.1f|r"):format(abs(value - self.max), self.delay))
		elseif db.castbar.format=='CURRENTMAX' then 
			self.Time:SetText(("%.1f / %.1f |cffaf5050%.1f|r"):format(value, self.max, self.delay))
		elseif db.castbar.format=='REMAINING' then 
			self.Time:SetText(("%.1f |cffaf5050%.1f|r"):format(value, self.delay))
		end 
	else 
		if db.castbar.format=='CURRENT' then 
			self.Time:SetText(("%.1f |cffaf5050%s %.1f|r"):format(value, "+", self.delay))
		elseif db.castbar.format=='CURRENTMAX' then 
			self.Time:SetText(("%.1f / %.1f |cffaf5050%s %.1f|r"):format(value, self.max, "+", self.delay))
		elseif db.castbar.format=='REMAINING'then 
			self.Time:SetText(("%.1f |cffaf5050%s %.1f|r"):format(abs(value - self.max), "+", self.delay))
		end 
	end 
end;
local CustomTimeText = function(self, value)
	local db=self:GetParent().db;
	if not db then return end;
	if self.channeling then 
		if db.castbar.format=='CURRENT' then 
			self.Time:SetText(("%.1f"):format(abs(value - self.max)))
		elseif db.castbar.format=='CURRENTMAX' then 
			self.Time:SetText(("%.1f / %.1f"):format(value, self.max))
			self.Time:SetText(("%.1f / %.1f"):format(abs(value - self.max), self.max))
		elseif db.castbar.format=='REMAINING' then 
			self.Time:SetText(("%.1f"):format(value))
		end 
	else 
		if db.castbar.format=='CURRENT' then 
			self.Time:SetText(("%.1f"):format(value))
		elseif db.castbar.format=='CURRENTMAX' then 
			self.Time:SetText(("%.1f / %.1f"):format(value, self.max))
		elseif db.castbar.format=='REMAINING' then 
			self.Time:SetText(("%.1f"):format(abs(value - self.max)))
		end 
	end 
end;
local CustomCastTimeUpdate = function(self, duration)
	if(self.Time) then
		if(self.delay ~= 0) then
			if(self.CustomDelayText) then
				self:CustomDelayText(duration)
			else
				self.Time:SetFormattedText("%.1f|cffff0000-%.1f|r", duration, self.delay)
			end
		else
			if(self.CustomTimeText) then
				self:CustomTimeText(duration)
			else
				self.Time:SetFormattedText("%.1f", duration)
			end
		end
	end
	if(self.Spark) then
		local xOffset = 0
		local yOffset = 0
		if self.Spark.xOffset then
			xOffset = self.Spark.xOffset
			yOffset = self.Spark.yOffset
		end
		if(self:GetReverseFill()) then
			self.Spark:SetPoint("CENTER", self, "RIGHT", -((duration / self.max) * self:GetWidth() + xOffset), yOffset)
		else
			self.Spark:SetPoint("CENTER", self, "LEFT", ((duration / self.max) * self:GetWidth() + xOffset), yOffset)
		end
	end
end
local CustomCastBarUpdate = function(self, elapsed)
	self.lastUpdate = (self.lastUpdate or 0) + elapsed

	if not (self.casting or self.channeling) then
		self.unitName = nil
		self.casting = nil
		self.castid = nil
		self.channeling = nil

		self:SetValue(1)
		self:Hide()
		return
	end

	if(self.Spark and self.Spark[1]) then self.Spark[1]:Hide(); self.Spark[1].overlay:Hide() end
	if(self.Spark and self.Spark[2]) then self.Spark[2]:Hide(); self.Spark[2].overlay:Hide() end

	if(self.casting) then
		if self.Spark then 
			if self.Spark.iscustom then 
				self.Spark.xOffset = -12
				self.Spark.yOffset = 0 
			end
			if(self.Spark[1]) then
				self.Spark[1]:Show()
				self.Spark[1].overlay:Show()
				if not self.Spark[1].anim:IsPlaying()  then self.Spark[1].anim:Play() end
			end
		end

		local duration = self.duration + self.lastUpdate

		if(duration >= self.max) then
			self.casting = nil
			self:Hide()

			if(self.PostCastStop) then self:PostCastStop(self.__owner.unit) end
			return
		end
			
		CustomCastTimeUpdate(self, duration)

		self.duration = duration
		self:SetValue(duration)
	elseif(self.channeling) then
		if self.Spark then 
			if self.Spark.iscustom then 
				self.Spark.xOffset = 12
				self.Spark.yOffset = 4 
			end
			if(self.Spark[2]) then 
				self.Spark[2]:Show()
				self.Spark[2].overlay:Show()
				if not self.Spark[2].anim:IsPlaying()  then self.Spark[2].anim:Play() end
			end
		end
		local duration = self.duration - self.lastUpdate

		if(duration <= 0) then
			self.channeling = nil
			self:Hide()

			if(self.PostChannelStop) then self:PostChannelStop(self.__owner.unit) end
			return
		end
	
		CustomCastTimeUpdate(self, duration)

		self.duration = duration
		self:SetValue(duration)
	end
	
	self.lastUpdate = 0
end;
local CustomChannelUpdate = function(self, unit, index, hasTicks, storage)
	local db=self:GetParent().db;
	if not db then return end;
	if not(unit=="player" or unit=="vehicle") then return end;
	if hasTicks then
		local activeTicks = storage.ChannelTicks[index]
		if activeTicks and storage.ChannelTicksSize[index] and storage.HastedChannelTicks[index] then 
			local mod1 = 1 / activeTicks;
			local haste = UnitSpellHaste("player") * 0.01;
			local mod2 = mod1 / 2;
			local total = 0;
			if haste >= mod2 then total = total + 1 end;
			local calc1 = tonumber(parsefloat(mod2 + mod1, 2))
			while haste >= calc1 do 
				calc1 = tonumber(parsefloat(mod2 + mod1 * total, 2))
				if haste >= calc1 then 
					total = total + 1 
				end 
			end;
			local activeSize = storage.ChannelTicksSize[index]
			local sizeMod = activeSize / 1 + haste;
			local calc2 = self.max - sizeMod * activeTicks + total;
			if self.chainChannel then 
				self.extraTickRatio = calc2 / sizeMod;
				self.chainChannel = nil 
			end;
			SetCastTicks(self, activeTicks + total, self.extraTickRatio)
		elseif activeTicks and storage.ChannelTicksSize[index] then 
			local haste = UnitSpellHaste("player") * 0.01;
			local activeSize = storage.ChannelTicksSize[index]
			local sizeMod = activeSize / 1 + haste;
			local calc2 = self.max - sizeMod * activeTicks;
			if self.chainChannel then 
				self.extraTickRatio = calc2 / sizeMod;
				self.chainChannel = nil 
			end;
			SetCastTicks(self, activeTicks, self.extraTickRatio)
		elseif activeTicks then 
			SetCastTicks(self, activeTicks)
		else 
			HideTicks()
		end 
	else 
		HideTicks()
	end 
end;
local CustomInterruptible = function(self, unit, colors, useClass)
	local r1,g1,b1=colors.casting[1],colors.casting[2],colors.casting[3]
	local r2,g2,b2=colors.spark[1],colors.spark[2],colors.spark[3]
	if useClass then 
		local colorOverride;
		if UnitIsPlayer(unit) then 
			local _,class=UnitClass(unit)
			colorOverride=colors.class[class]
		elseif UnitReaction(unit,'player') then 
			colorOverride=colors.reaction[UnitReaction(unit,"player")]
		end;
		if colorOverride then 
			r1,g1,b1=colorOverride[1],colorOverride[2],colorOverride[3]
		end 
	end;
	if self.interrupt and unit~="player" and UnitCanAttack("player",unit) then 
		r1,g1,b1=colors.interrupt[1],colors.interrupt[2],colors.interrupt[3]
	end;
	self:SetStatusBarColor(r1,g1,b1)
	if(self.Spark and self.Spark[1]) then
		self.Spark[1]:SetVertexColor(r2,g2,b2)
		self.Spark[2]:SetVertexColor(r2,g2,b2)
	end
	if self.bg:IsShown() then 
		self.bg:SetVertexColor(r1*0.1, g1*0.1, b1*0.1, 0.8)
	end 
end;
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function MOD:CreateCastbar(frame, reversed, moverName, ryu, useFader, isBoss)
	local colors = oUF_SuperVillain.colors;
	local castbar = CreateFrame("StatusBar", nil, frame)
	castbar.OnUpdate = CustomCastBarUpdate;
	castbar.CustomDelayText = CustomCastDelayText;
	castbar.CustomTimeText = CustomTimeText;
	castbar.PostCastStart = MOD.PostCastStart;
	castbar.PostChannelStart = MOD.PostCastStart;
	castbar.PostCastStop = MOD.PostCastStop;
	castbar.PostChannelStop = MOD.PostCastStop;
	castbar.PostChannelUpdate = MOD.PostChannelUpdate;
	castbar.PostCastInterruptible = MOD.PostCastInterruptible;
	castbar.PostCastNotInterruptible = MOD.PostCastNotInterruptible;
	castbar:SetClampedToScreen(true)
	castbar:SetFrameLevel(2)

	castbar.Time = castbar:CreateFontString(nil, "OVERLAY")
	castbar.Time:SetFont(SuperVillain.Fonts.numbers, 14)
	castbar.Time:SetShadowOffset(1, -1)
	castbar.Time:SetTextColor(1, 1, 1, 0.9)

	castbar.Text = castbar:CreateFontString(nil, "OVERLAY")
	castbar.Text:SetFont(SuperVillain.Fonts.alert, 14)
	castbar.Text:SetShadowOffset(1, -1)
	castbar.Text:SetTextColor(1, 1, 1)

	castbar.LatencyTexture = castbar:CreateTexture(nil, "OVERLAY")


	local iconHolder = CreateFrame("Frame", nil, castbar)
	local castbarHolder = CreateFrame("Frame", nil, castbar)
	iconHolder:SetFixedPanelTemplate("Inset", false)
	
	
	local hadouken = CreateFrame("Frame", nil, castbar)

	if ryu then
		castbar:SetStatusBarTexture(SuperVillain.Textures.lazer)

	    local bgFrame = CreateFrame("Frame", nil, castbar)
		bgFrame:FillInner(castbar, -2, 10)
		bgFrame:SetFrameLevel(bgFrame:GetFrameLevel() - 1)

		castbar.bg = bgFrame:CreateTexture(nil, "BACKGROUND")
		castbar.bg:SetAllPoints(bgFrame)
		castbar.bg:SetTexture(SuperVillain.Textures.glow)
	    castbar.bg:SetVertexColor(0,0,0,0.8)

		local borderB = bgFrame:CreateTexture(nil,"OVERLAY")
	    borderB:SetTexture(0,0,0)
	    borderB:SetPoint("BOTTOMLEFT")
	    borderB:SetPoint("BOTTOMRIGHT")
	    borderB:SetHeight(2)

	    local borderT = bgFrame:CreateTexture(nil,"OVERLAY")
	    borderT:SetTexture(0,0,0)
	    borderT:SetPoint("TOPLEFT")
	    borderT:SetPoint("TOPRIGHT")
	    borderT:SetHeight(2)

	    local borderL = bgFrame:CreateTexture(nil,"OVERLAY")
	    borderL:SetTexture(0,0,0)
	    borderL:SetPoint("TOPLEFT")
	    borderL:SetPoint("BOTTOMLEFT")
	    borderL:SetWidth(2)

	    local borderR = bgFrame:CreateTexture(nil,"OVERLAY")
	    borderR:SetTexture(0,0,0)
	    borderR:SetPoint("TOPRIGHT")
	    borderR:SetPoint("BOTTOMRIGHT")
	    borderR:SetWidth(2)

	    castbar.LatencyTexture:SetTexture(SuperVillain.Textures.lazer)
		castbar.noupdate = true;
		castbar.pewpew = true
		hadouken.iscustom = true;
		hadouken:SetHeight(50)
		hadouken:SetWidth(50)
		hadouken:SetAlpha(0.9)
		castbarHolder:Point("TOP", frame, "BOTTOM", 0, isBoss and -4 or -35)

		if reversed then 
			castbar:SetReverseFill(true)
			hadouken[1] = hadouken:CreateTexture(nil, "ARTWORK")
			hadouken[1]:SetAllPoints(hadouken)
			hadouken[1]:SetBlendMode("ADD")
			hadouken[1]:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Castbar\\SPARK_SKULLS_LEFT")
			hadouken[1]:SetVertexColor(colors.spark[1],colors.spark[2],colors.spark[3])
			hadouken[1].overlay = hadouken:CreateTexture(nil, "OVERLAY")
			hadouken[1].overlay:SetHeight(50)
			hadouken[1].overlay:SetWidth(50)
			hadouken[1].overlay:SetPoint("CENTER", hadouken)
			hadouken[1].overlay:SetBlendMode("ADD")
			hadouken[1].overlay:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Castbar\\SPARK_SKULLS_LEFT")
			hadouken[1].overlay:SetVertexColor(1, 1, 1)

			SuperVillain.Animate:Sprite(hadouken[1],false,false,true)

			hadouken[2] = hadouken:CreateTexture(nil, "ARTWORK")
			hadouken[2]:FillInner(hadouken, 4, 4)
			hadouken[2]:SetBlendMode("ADD")
			hadouken[2]:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Castbar\\CHANNEL_LEFT")
			hadouken[2]:SetVertexColor(colors.spark[1],colors.spark[2],colors.spark[3])
			hadouken[2].overlay = hadouken:CreateTexture(nil, "OVERLAY")
			hadouken[2].overlay:SetHeight(50)
			hadouken[2].overlay:SetWidth(50)
			hadouken[2].overlay:SetPoint("CENTER", hadouken)
			hadouken[2].overlay:SetBlendMode("ADD")
			hadouken[2].overlay:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Castbar\\CHANNEL_LEFT")
			hadouken[2].overlay:SetVertexColor(1, 1, 1)

			SuperVillain.Animate:Sprite(hadouken[2],false,false,true)

			castbar:Point("BOTTOMLEFT", castbarHolder, "BOTTOMLEFT", 1, 1)
			castbar.Time:Point("RIGHT", castbar, "RIGHT", -4, 0)
			castbar.Time:SetJustifyH("RIGHT")
			castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, 0)
			castbar.Text:SetJustifyH("LEFT")
			iconHolder:Point("LEFT", castbar, "RIGHT", 6, 0)
		else
			hadouken[1] = hadouken:CreateTexture(nil, "ARTWORK")
			hadouken[1]:SetAllPoints(hadouken)
			hadouken[1]:SetBlendMode("ADD")
			hadouken[1]:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Castbar\\SPARK")
			hadouken[1]:SetVertexColor(colors.spark[1],colors.spark[2],colors.spark[3])
			hadouken[1].overlay = hadouken:CreateTexture(nil, "OVERLAY")
			hadouken[1].overlay:SetHeight(50)
			hadouken[1].overlay:SetWidth(50)
			hadouken[1].overlay:SetPoint("CENTER", hadouken)
			hadouken[1].overlay:SetBlendMode("ADD")
			hadouken[1].overlay:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Castbar\\SPARK")
			hadouken[1].overlay:SetVertexColor(1, 1, 1)

			SuperVillain.Animate:Sprite(hadouken[1],false,false,true)

			hadouken[2] = hadouken:CreateTexture(nil, "ARTWORK")
			hadouken[2]:FillInner(hadouken, 4, 4)
			hadouken[2]:SetBlendMode("ADD")
			hadouken[2]:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Castbar\\CHANNEL")
			hadouken[2]:SetVertexColor(colors.spark[1],colors.spark[2],colors.spark[3])
			hadouken[2].overlay = hadouken:CreateTexture(nil, "OVERLAY")
			hadouken[2].overlay:SetHeight(50)
			hadouken[2].overlay:SetWidth(50)
			hadouken[2].overlay:SetPoint("CENTER", hadouken)
			hadouken[2].overlay:SetBlendMode("ADD")
			hadouken[2].overlay:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Castbar\\CHANNEL")
			hadouken[2].overlay:SetVertexColor(1, 1, 1)

			SuperVillain.Animate:Sprite(hadouken[2],false,false,true)
			
			castbar:Point("BOTTOMRIGHT", castbarHolder, "BOTTOMRIGHT", -1, 1)
			castbar.Text:Point("RIGHT", castbar, "RIGHT", -4, 0)
			castbar.Text:SetJustifyH("RIGHT")
			castbar.Time:SetPoint("LEFT", castbar, "LEFT", 4, 0)
			castbar.Time:SetJustifyH("LEFT")
			iconHolder:Point("RIGHT", castbar, "LEFT", -6, 0)
		end;
	else
		castbar.pewpew = false

		castbar.Text:Point("RIGHT", castbar, "RIGHT", -4, 0)
		castbar.Text:SetJustifyH("RIGHT")
		castbar.Time:SetPoint("LEFT", castbar, "LEFT", 4, 0)
		castbar.Time:SetJustifyH("LEFT")

		MOD:SetUnitStatusbar(castbar)
		castbar.bg = castbar:CreateTexture(nil, "BACKGROUND")
		castbar.bg:WrapOuter(castbar)
		MOD:SetUnitStatusbar(castbar.bg)
	    MOD:SetUnitStatusbar(castbar.LatencyTexture)
	    castbar.bg:SetVertexColor(0,0,0,0.5)

		castbarHolder:Point("TOP", frame, "BOTTOM", 0, -1)
		castbar:WrapOuter(castbarHolder, 0, 2)
		if reversed then 
			castbar:SetReverseFill(true)
			iconHolder:Point("LEFT", castbar, "RIGHT", 6, 0)
		else
			iconHolder:Point("RIGHT", castbar, "LEFT", -6, 0)
		end
	end;

	castbar:SetStatusBarColor(colors.casting[1],colors.casting[2],colors.casting[3])
	castbar.LatencyTexture:SetVertexColor(0.1, 1, 0.2, 0.5)

	castbar.Spark = hadouken;
	castbar.Holder = castbarHolder;
	if moverName then 
		SuperVillain:SetSVMovable(castbar.Holder, frame:GetName().."Castbar_MOVE", moverName, nil, -6, nil, "ALL, SOLO")
	end;
	local buttonIcon = iconHolder:CreateTexture(nil, "ARTWORK")
	buttonIcon:FillInner()
	buttonIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	buttonIcon.bg = iconHolder;
	castbar.Icon = buttonIcon;
	local shieldIcon = iconHolder:CreateTexture(nil, "OVERLAY")
	shieldIcon:Point("TOPLEFT",buttonIcon,"TOPLEFT",-7,7)
	shieldIcon:Point("BOTTOMRIGHT",buttonIcon,"BOTTOMRIGHT",7,-8)
	shieldIcon:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Castbar\\SHIELD_ICON")
	castbar.Shield = shieldIcon;
	if useFader then
		SetCastbarFading(frame, castbar, SuperVillain.Textures.lazer)
	end;
	return castbar 
end;
--[[ 
########################################################## 
UPDATE
##########################################################
]]--
function MOD:PostCastStart(unit,index,...)
	local db=self:GetParent().db;
	if not db or not db.castbar then return end;
	if unit=="vehicle" then unit="player" end;
	if db.castbar.displayTarget and self.curTarget then 
		self.Text:SetText(sub(index..' --> '..self.curTarget, 0, floor(32 / 245 * self:GetWidth() / SuperVillain.db['SVUnit'].fontSize * 12)))
	else 
		self.Text:SetText(sub(index, 0, floor(32 / 245 * self:GetWidth() / SuperVillain.db['SVUnit'].fontSize * 12)))
	end;
	self.unit=unit;
	if unit == "player" or unit == "target" then 
		CustomChannelUpdate(self, unit, index, db.castbar.ticks, SuperVillain.global.SVUnit)
		CustomInterruptible(self, unit, oUF_SuperVillain.colors, MOD.db.castClassColor)
	end; 
end;
function MOD:PostCastStop(unit,...)
	self.chainChannel=nil;
	self.prevSpellCast=nil 
end;
function MOD:PostChannelUpdate(unit,index)
	local db=self:GetParent().db;
	if not db or not(unit=="player" or unit=="vehicle") then return end;
	CustomChannelUpdate(self, unit, index, db.castbar.ticks, SuperVillain.global.SVUnit)
end;
function MOD:PostCastInterruptible(unit)
	if unit=="vehicle" or unit=="player" then return end;
	CustomInterruptible(self, unit, oUF_SuperVillain.colors, MOD.db.castClassColor)
end;
function MOD:PostCastNotInterruptible(unit)
	local colors=oUF_SuperVillain.colors;
	self:SetStatusBarColor(colors.casting[1],colors.casting[2],colors.casting[3])
	if(self.Spark and self.Spark[1]) then
		print("Setting Spark Colors")
		self.Spark[1]:SetVertexColor(colors.spark[1],colors.spark[2],colors.spark[3])
		self.Spark[2]:SetVertexColor(colors.spark[1],colors.spark[2],colors.spark[3])
	end
end;
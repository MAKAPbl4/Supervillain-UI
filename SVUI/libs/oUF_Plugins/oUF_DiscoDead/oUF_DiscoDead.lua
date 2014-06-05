local parent, ns = ...
local oUF = ns.oUF

local Update = function(self, event, unit)
	if(self.unit ~= unit) or not unit then return end
	local discdead = self.DiscoDead
	local dc = discdead.DC
	local dead = discdead.DEAD
	local marked = false
	local size = self.Health:GetHeight() or self:GetHeight();

	if(discdead.PreUpdate) then
		discdead:PreUpdate()
	end

	local IsConnected = UnitIsConnected(unit)
	local IsDead = UnitIsDeadOrGhost(unit)
	if(not IsConnected) then
		dc:ClearAllPoints()
		dc:Size(size,size)
		dc:SetPoint("CENTER")
		dc:Show()
		marked = true
		if dead:IsShown() then dead:Hide()end;
	elseif(IsDead) then
		dead:ClearAllPoints()
		dead:Size(size,size)
		dead:SetPoint("CENTER")
		dead:Show()
		marked = true
		if dc:IsShown() then dc:Hide()end;
	else
		if dead:IsShown() then dead:Hide()end;
		if dc:IsShown() then dc:Hide()end;

	end

	if(discdead.PostUpdate) then
		return discdead:PostUpdate(unit, marked)
	end
end

local Path = function(self, ...)
	return (self.DiscoDead.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate')
end

local Enable = function(self, unit)
	local discdead = self.DiscoDead
	if(discdead) then
		discdead.__owner = self
		discdead.ForceUpdate = ForceUpdate

		self:RegisterEvent("UNIT_HEALTH", Path, true)
		self:RegisterEvent("UNIT_CONNECTION", Path, true)
		if(discdead.TAP) then
			self:RegisterEvent("UNIT_COMBAT", Path, true)
		end
		if(discdead.DC and discdead.DC.icon and discdead.DC.icon:IsObjectType"Texture" and not discdead.DC.icon:GetTexture()) then
			discdead.DC.icon:SetTexture([[Interface\CharacterFrame\Disconnect-Icon]])
		end
		if(discdead.DEAD and discdead.DEAD.icon and discdead.DEAD.icon:IsObjectType"Texture" and not discdead.DEAD.icon:GetTexture()) then
			discdead.DEAD.icon:SetTexture([[Interface\TARGETINGFRAME\TargetDead]])
		end

		return true
	end
end

local Disable = function(self)
	local discdead = self.DiscoDead
	if(discdead) then
		self:UnregisterEvent("UNIT_HEALTH", Path)
		self:UnregisterEvent("UNIT_CONNECTION", Path)
		if(discdead.TAP) then
			self:UnregisterEvent("UNIT_COMBAT", Path)
		end
	end
end

oUF:AddElement('DiscoDead', Path, Enable, Disable)

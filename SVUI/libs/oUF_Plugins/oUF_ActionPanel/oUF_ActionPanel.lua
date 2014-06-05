local parent, ns = ...
local oUF = ns.oUF

local Update = function(self, event, unit)
	if(self.unit ~= unit) or not unit then return end
	local panel = self.ActionPanel
	local t = {0,0,0};

	if(panel.PreUpdate) then
		panel:PreUpdate()
	end

	local category = UnitClassification(unit)
	if(category == "elite") then 
		t = {1,0.75,0,0.7};
		if panel.EliteRarePanel then 
			panel.EliteRarePanel:Show()
		end;
	elseif(category == "rare" or category == "rareelite") then
		t = {0.59,0.79,1,0.7};
		if panel.EliteRarePanel then 
			panel.EliteRarePanel:Show()
		end;
	else
		if panel.EliteRarePanel then 
			panel.EliteRarePanel:Hide()
		end;
	end

	if(panel.PostUpdate) then
		return panel:PostUpdate(t)
	end
end

local Path = function(self, ...)
	return (self.ActionPanel.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate')
end

local Enable = function(self, unit)
	local panel = self.ActionPanel
	if(panel and panel.EliteRarePanel) then
		panel.__owner = self
		panel.ForceUpdate = ForceUpdate
		self:RegisterEvent("UNIT_TARGET", Path, true)
		self:RegisterEvent("PLAYER_TARGET_CHANGED", Path, true)

		return true
	end
end

local Disable = function(self)
	local panel = self.ActionPanel
	if(panel) then
		if(self:IsEventRegistered("PLAYER_TARGET_CHANGED")) then
			self:UnregisterEvent("PLAYER_TARGET_CHANGED", Path)
		end
		if(self:IsEventRegistered("UNIT_TARGET")) then
			self:UnregisterEvent("UNIT_TARGET", Path)
		end
	end
end

oUF:AddElement('ActionPanel', Path, Enable, Disable)

local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'oUF not loaded')

local Astrolabe = DongleStub("Astrolabe-1.0")
local cos, sin, sqrt2, max, atan2, floor = math.cos, math.sin, math.sqrt(2), math.max, math.atan2, math.floor
local _FRAMES, OnUpdateFrame = {}
local tinsert, tremove = table.insert, table.remove
local radian90 = (3.141592653589793 / 2)

local function cartography(unit,checkMap)
	local plot1,plot2,plot3,plot4;
	if unit=="player" or UnitIsUnit("player", unit) then 
		plot1,plot2,plot3,plot4=Astrolabe:GetCurrentPlayerPosition()
	else 
		plot1,plot2,plot3,plot4=Astrolabe:GetUnitPosition(unit, checkMap or WorldMapFrame:IsVisible())
	end;
	if not (plot1 and plot4) then 
		return false 
	else 
		return true,plot1,plot2,plot3,plot4 
	end 
end;

local function MeasureDistance(unit1,unit2,checkMap)
	local allowed,plot1,plot2,plot3,plot4=cartography(unit1,checkMap)
	if not allowed then return end;
	local allowed,plot5,plot6,plot7,plot8=cartography(unit2,checkMap)
	if not allowed then return end;
	local distance,deltaX,deltaY=Astrolabe:ComputeDistance(plot1,plot2,plot3,plot4,plot5,plot6,plot7,plot8)
	if distance and deltaX and deltaY then 
		return distance, -radian90 - GetPlayerFacing() - atan2(deltaY, deltaX) 
	elseif distance then 
		return distance 
	end
end;

local function CalculateCorner(r)
	return 0.5 + cos(r) / sqrt2, 0.5 + sin(r) / sqrt2;
end

local function RotateTexture(texture, angle)
	local LRx, LRy = CalculateCorner(angle + 0.785398163);
	local LLx, LLy = CalculateCorner(angle + 2.35619449);
	local ULx, ULy = CalculateCorner(angle + 3.92699082);
	local URx, URy = CalculateCorner(angle - 0.785398163);
	
	texture:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy);
end

local minThrottle = 0.02
local numArrows, inRange, unit, angle, GPS, distance
local Update = function(self, elapsed)
	if self.elapsed and self.elapsed > (self.throttle or minThrottle) then
		numArrows = 0
		for _, object in next, _FRAMES do
			if(object:IsShown()) then
				GPS = object.GPS
				unit = object.unit
				if(unit) then
					if(GPS.PreUpdate) then GPS:PreUpdate(frame) end

					if unit and GPS.outOfRange then
						inRange = UnitInRange(unit)
					end

					if not unit or not (UnitInParty(unit) or UnitInRaid(unit)) or UnitIsUnit(unit, "player") or not UnitIsConnected(unit) or (GPS.onMouseOver and (GetMouseFocus() ~= object)) or (GPS.outOfRange and inRange) then
						GPS:Hide()
					else
						distance, angle = MeasureDistance("player", unit, GPS.onMouseOver == false)
						if not angle then 
							GPS:Hide()
						else
							GPS:Show()
							
							if GPS.Arrow then
								RotateTexture(GPS.Arrow, angle)
							end

							if GPS.Text then
								local out = floor(tonumber(distance))
								GPS.Text:SetText(out)
								if(out <= 100) then
									GPS.Text:SetTextColor(0.2,0.8,0.1)
								elseif(out <= 300) then
									GPS.Text:SetTextColor(0.8,0.8,0)
								else
									GPS.Text:SetTextColor(0.8,0.2,0.2)
								end
							end
							
							if(GPS.PostUpdate) then GPS:PostUpdate(frame, distance, angle) end
							numArrows = numArrows + 1
						end
					end				
				else
					GPS:Hide()
				end
			end
		end

		self.elapsed = 0
		self.throttle = max(minThrottle, 0.005 * numArrows)
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end
end

local Enable = function(self)
	local GPS = self.GPS
	if GPS then
		tinsert(_FRAMES, self)

		if not OnUpdateFrame then
			OnUpdateFrame = CreateFrame("Frame")
			OnUpdateFrame:SetScript("OnUpdate", Update)
		end

		OnUpdateFrame:Show()
		return true
	end
end
 
local Disable = function(self)
	local GPS = self.GPS
	if GPS then
		for k, frame in next, _FRAMES do
			if(frame == self) then
				tremove(_FRAMES, k)
				GPS:Hide()
				break
			end
		end

		if #_FRAMES == 0 and OnUpdateFrame then
			OnUpdateFrame:Hide()
		end
	end
end
 
oUF:AddElement('GPS', nil, Enable, Disable)
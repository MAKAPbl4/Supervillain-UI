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
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain:GetModule('SVBar');
local LibAB = LibStub("LibActionButton-1.0");
--[[ 
########################################################## 
PACKAGE PLUGIN
##########################################################
]]--
function MOD:CreateActionBars()
  for i=1,6 do 
    local barID = "Bar"..i;
    local presets = MOD.BarPresets[barID];
    local parent = _G[presets.setpoint[2]]
    local buttonMax = _G[presets.max];
    local thisBar = CreateFrame('Frame', 'SVUI_Action'..barID, SuperVillain.UIParent, 'SecureHandlerStateTemplate')
    thisBar:Point(presets.setpoint[1], parent, presets.setpoint[3], presets.setpoint[4], presets.setpoint[5])
    local bg = CreateFrame('Frame', nil, thisBar)
    bg:SetAllPoints()
    bg:SetFrameLevel(0);
    thisBar:SetFrameLevel(5);
    bg:SetPanelTemplate('Component')
    bg:SetPanelColor('dark')
    thisBar.backdrop = bg;
    thisBar.ID = barID;
    MOD.Storage[barID].buttons = {}
    for k=1,buttonMax do 
      MOD.Storage[barID].buttons[k] = LibAB:CreateButton(k, "SVUI_Action"..barID.."Button"..k, thisBar, nil)
      MOD.Storage[barID].buttons[k]:SetState(0, "action", k)
      for x=1,14 do 
        local calc = (x - 1) * buttonMax + k;
        MOD.Storage[barID].buttons[k]:SetState(x, "action", calc)
      end;
      if k==12 then 
        MOD.Storage[barID].buttons[k]:SetState(12, "custom", {
          func=function(...) 
            if UnitExists('vehicle') then 
              VehicleExit() 
            else 
              PetDismiss() 
            end 
          end,
          texture = "Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down", 
          tooltip = LEAVE_VEHICLE
        });
      end 
    end;
    MOD:SetBarConfigData(barID)
    if i==1 then 
      thisBar:SetAttribute("hasTempBar",true)
    else 
      thisBar:SetAttribute("hasTempBar",false)
    end;
    thisBar:SetAttribute("_onstate-page",[[
      if HasTempShapeshiftActionBar() and self:GetAttribute("hasTempBar") then
        newstate = GetTempShapeshiftBarIndex() or newstate
      end 
      if newstate ~= 0 then
        self:SetAttribute("state", newstate)
        control:ChildUpdate("state", newstate)
      else
        local newCondition = self:GetAttribute("newCondition")
        if newCondition then
          newstate = SecureCmdOptionParse(newCondition)
          self:SetAttribute("state", newstate)
          control:ChildUpdate("state", newstate)
        end
      end
    ]])
    MOD.Storage[barID].bar = thisBar;
    MOD:RefreshBar(barID)
    SuperVillain:SetSVMovable(thisBar,'SVUI_Action'..barID..'_MOVE',L[barID],nil,nil,nil,'ALL,ACTIONBARS')
  end 
end;
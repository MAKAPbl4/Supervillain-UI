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
--[[ 
########################################################## 
PACKAGE PLUGIN
##########################################################
]]--
local ActionMask = {
  PET_MODE_ASSIST = true,
  PET_MODE_DEFENSIVE = true,
  PET_MODE_PASSIVE = true,
  PET_ACTION_ATTACK = true
}
function MOD:RefreshPet(event,arg)
  if event == "UNIT_AURA" and arg ~= "pet" then return end;
  for i=1,NUM_PET_ACTION_SLOTS,1 do 
    local name = "PetActionButton"..i;
    local button = _G[name]
    local icon = _G[name.."Icon"]
    local auto = _G[name.."AutoCastable"]
    local shine = _G[name.."Shine"]
    local checked = button:GetCheckedTexture()
    local actionName,subtext,actionIcon,isToken,isActive,autoCastAllowed,autoCastEnabled = GetPetActionInfo(i)
    button:SetChecked(0)
    button:SetBackdropBorderColor(0,0,0)
    checked:SetAlpha(0)
    if(not isToken) then 
      icon:SetTexture(actionIcon)
      button.tooltipName=actionName 
    else 
      icon:SetTexture(_G[actionIcon])
      button.tooltipName=_G[actionName]
    end;
    button.isToken = isToken;
    button.tooltipSubtext = subtext;

    if arg and actionName ~= "PET_ACTION_FOLLOW" then
      if(IsPetAttackAction(i)) then PetActionButton_StartFlash(button) end
    else
      if(IsPetAttackAction(i)) then PetActionButton_StopFlash(button) end
    end;

    if autoCastAllowed then 
      auto:Show()
    else 
      auto:Hide()
    end;

    if (isActive and actionName ~= "PET_ACTION_FOLLOW") then
      button:SetChecked(1)
      checked:SetAlpha(1)
      button:SetBackdropBorderColor(0.4,0.8,0)
    else
      button:SetChecked(0)
      checked:SetAlpha(0)
      button:SetBackdropBorderColor(0,0,0)
    end;

    if(autoCastEnabled) then 
      AutoCastShine_AutoCastStart(shine)
    else
      AutoCastShine_AutoCastStop(shine)
    end

    button:SetAlpha(1)
    if actionIcon then 
      icon:Show()
      if GetPetActionSlotUsable(i)then 
        SetDesaturation(icon,nil)
      else 
        SetDesaturation(icon,1)
      end;
    else 
      icon:Hide() 
    end;
    if(not PetHasActionBar() and actionIcon and actionName ~= "PET_ACTION_FOLLOW") then 
      PetActionButton_StopFlash(button)
      SetDesaturation(icon,1)
      button:SetChecked(0)
    end;
  end
end;

function MOD:CreatePetBar()
    local barID = "Pet";
    local presets = MOD.BarPresets[barID];
    local parent = _G[presets.setpoint[2]]
    local buttonMax = _G[presets.max];
    if MOD.db['Bar2'].enable then 
        parent = _G["SVUI_ActionBar2"]
    end;
    local petBar=CreateFrame('Frame','SVUI_PetActionBar',SuperVillain.UIParent,'SecureHandlerStateTemplate')
    petBar:Point(presets.setpoint[1], parent, presets.setpoint[3], presets.setpoint[4], presets.setpoint[5]);
    petBar:SetFrameLevel(5);
    local bg = CreateFrame('Frame', nil, petBar)
    bg:SetAllPoints();
    bg:SetFrameLevel(0);
    bg:SetPanelTemplate('Component')
    bg:SetPanelColor('dark')
    petBar.backdrop = bg;
    petBar.ID = barID;
    for i=1,buttonMax do 
        MOD.Storage[barID].buttons[i] = _G["PetActionButton"..i]
    end
    petBar:SetAttribute("_onstate-show",[[    
        if newstate == "hide" then
          self:Hide();
        else
          self:Show();
        end 
    ]]);
    MOD.Storage[barID].bar = petBar;
    PetActionBarFrame.showgrid=1;
    PetActionBar_ShowGrid();
    MOD:RefreshBar("Pet")
    MOD:UpdateBarBindings(true,false)
    MOD:RegisterEvent('PLAYER_CONTROL_GAINED','RefreshPet')
    MOD:RegisterEvent('PLAYER_ENTERING_WORLD','RefreshPet')
    MOD:RegisterEvent('PLAYER_CONTROL_LOST','RefreshPet')
    MOD:RegisterEvent('PET_BAR_UPDATE','RefreshPet')
    MOD:RegisterEvent('UNIT_PET','RefreshPet')
    MOD:RegisterEvent('UNIT_FLAGS','RefreshPet')
    MOD:RegisterEvent('UNIT_AURA','RefreshPet')
    MOD:RegisterEvent('PLAYER_FARSIGHT_FOCUS_CHANGED','RefreshPet')
    MOD:RegisterEvent('PET_BAR_UPDATE_COOLDOWN',PetActionBar_UpdateCooldowns)
    SuperVillain:SetSVMovable(petBar,'SVUI_PetActionBar_MOVE',L['Pet Bar'],nil,nil,nil,'ALL,ACTIONBARS')
end;
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
function MOD:SetStanceBarButtons(...)
  local maxForms=GetNumShapeshiftForms();
  local currentForm=GetShapeshiftForm();
  local maxButtons = NUM_STANCE_SLOTS;
  local texture,name,isActive,isCastable,_;
  for i=1,maxButtons do
    local button = _G["SVUI_StanceBarButton"..i]
    local icon = _G["SVUI_StanceBarButton"..i.."Icon"]
    local cd = _G["SVUI_StanceBarButton"..i.."Cooldown"]
    if i <= maxForms then 
      texture,name,isActive,isCastable=GetShapeshiftFormInfo(i)
      if texture=="Interface\\Icons\\Spell_Nature_WispSplode" and MOD.db.Stance.style=='darkenInactive' then 
        _,_,texture=GetSpellInfo(name)
      end;
      icon:SetTexture(texture)
      if texture then 
        cd:SetAlpha(1)
      else 
        cd:SetAlpha(0)
      end;
      if isActive then 
        StanceBarFrame.lastSelected = button:GetID()
        if maxForms==1 then 
          button:SetChecked(1)
        else
          if button.checked then button.checked:SetTexture(0,0.5,0,0.2) end
          button:SetBackdropBorderColor(0.4,0.8,0)
          button:SetChecked(MOD.db.Stance.style~='darkenInactive')
        end 
      else 
        if maxForms==1 or currentForm==0 then 
          button:SetChecked(0)
        else
          button:SetBackdropBorderColor(0,0,0)
          button:SetChecked(MOD.db.Stance.style=='darkenInactive')
          if button.checked then 
            button.checked:SetAlpha(1)
            if MOD.db.Stance.style=='darkenInactive' then 
              button.checked:SetTexture(0,0,0,0.75)
            else 
              button.checked:SetTexture(1,1,1,0.25)
            end
          end
        end 
      end;
      if isCastable then 
        icon:SetVertexColor(1.0,1.0,1.0)
      else 
        icon:SetVertexColor(0.4,0.4,0.4)
      end 
    end 
  end 
end;

function MOD:UPDATE_SHAPESHIFT_FORMS(event)
  if InCombatLockdown() or not _G["SVUI_StanceBar"] then return end;
  local bar = _G["SVUI_StanceBar"];
  for i=1,#MOD.Storage["Stance"].buttons do 
    MOD.Storage["Stance"].buttons[i]:Hide()
  end;
  local ready=false;
  local maxForms=GetNumShapeshiftForms()
  for i=1,NUM_STANCE_SLOTS do 
    if not MOD.Storage["Stance"].buttons[i]then 
      MOD.Storage["Stance"].buttons[i] = CreateFrame("CheckButton", format("SVUI_StanceBarButton%d",i), bar, "StanceButtonTemplate")
      MOD.Storage["Stance"].buttons[i]:SetID(i)
      ready=true 
    end;
    if i <= maxForms then 
      MOD.Storage["Stance"].buttons[i]:Show()
    else 
      MOD.Storage["Stance"].buttons[i]:Hide()
    end 
  end;
  MOD:RefreshBar("Stance")
  if event == 'UPDATE_SHAPESHIFT_FORMS' then 
    MOD:SetStanceBarButtons()
  end;
  if not C_PetBattles.IsInBattle() or ready then 
    if maxForms==0 then 
      UnregisterStateDriver(bar,"show")
      bar:Hide()
    else 
      bar:Show()
      RegisterStateDriver(bar,"show",'[petbattle] hide;show')
    end 
  end 
end;

function MOD:UPDATE_SHAPESHIFT_COOLDOWN()
  local maxForms = GetNumShapeshiftForms()
  for i=1,NUM_STANCE_SLOTS do 
    if i <= maxForms then 
      local cooldown = _G["SVUI_StanceBarButton"..i.."Cooldown"]
      local start,duration,enable=GetShapeshiftFormCooldown(i)
      CooldownFrame_SetTimer(cooldown,start,duration,enable)
    end 
  end
end;

function MOD:CreateStanceBar()
  local barID = "Stance";
  local presets = MOD.BarPresets[barID];
  local parent = _G[presets.setpoint[2]]
  local buttonMax = _G[presets.max];
  local maxForms = GetNumShapeshiftForms();
  if MOD.db['Bar2'].enable then 
    parent=_G["SVUI_ActionBar2"]
  else 
    parent=_G["SVUI_ActionBar1"]
  end;
  local stanceBar=CreateFrame('Frame','SVUI_StanceBar',SuperVillain.UIParent,'SecureHandlerStateTemplate')
  stanceBar:Point(presets.setpoint[1], parent, presets.setpoint[3], presets.setpoint[4], presets.setpoint[5]);
  stanceBar:SetFrameLevel(5);
  local bg = CreateFrame('Frame', nil, stanceBar)
  bg:SetAllPoints();
  bg:SetFrameLevel(0);
  bg:SetPanelTemplate('Component')
  bg:SetPanelColor('dark')
  stanceBar.backdrop = bg;
  stanceBar.ID = barID;
  for i=1,NUM_STANCE_SLOTS do
    MOD.Storage[barID].buttons[i] = _G["SVUI_StanceBarButton"..i]
  end
  stanceBar:SetAttribute("_onstate-show",[[    
    if newstate == "hide" then
      self:Hide();
    else
      self:Show();
    end 
  ]]);
  MOD.Storage[barID].bar = stanceBar;
  MOD:RegisterEvent('UPDATE_SHAPESHIFT_FORMS')
  MOD:RegisterEvent('UPDATE_SHAPESHIFT_COOLDOWN')
  MOD:RegisterEvent('UPDATE_SHAPESHIFT_USABLE','SetStanceBarButtons')
  MOD:RegisterEvent('UPDATE_SHAPESHIFT_FORM','SetStanceBarButtons')
  MOD:RegisterEvent('ACTIONBAR_PAGE_CHANGED','SetStanceBarButtons')
  MOD:UPDATE_SHAPESHIFT_FORMS()
  SuperVillain:SetSVMovable(stanceBar,'SVUI_StanceBar_MOVE',L['Stance Bar'],nil,-3,nil,'ALL,ACTIONBARS')
  MOD:RefreshBar("Stance")
  MOD:SetStanceBarButtons()
  MOD:UpdateBarBindings(false,true)
end;
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

local LibAB=LibStub("LibActionButton-1.0")
local format,find=string.format,string.find;
local keyBindManager=CreateFrame("Frame", "SVUI_KeyBindManager", SuperVillain.UIParent);
local _G,TIMER = getfenv(0),0;
--[[ 
########################################################## 
PACKAGE PLUGIN
##########################################################
]]--
function MOD:CreateBindPkg()
  MOD:RefreshButtons()
  keyBindManager:SetFrameStrata("DIALOG")
  keyBindManager:SetFrameLevel(99)
  keyBindManager:EnableMouse(true)
  keyBindManager:EnableKeyboard(true)
  keyBindManager:EnableMouseWheel(true)
  keyBindManager.texture = keyBindManager:CreateTexture()
  keyBindManager.texture:SetAllPoints(a)
  keyBindManager.texture:SetTexture(0, 0, 0, .25)
  keyBindManager:Hide()
  MOD:HookScript(GameTooltip, "OnUpdate", "BindingTooltip_OnUpdate")
  
  hooksecurefunc(GameTooltip, "Hide", function(this)
    for _, tip in pairs(this.shoppingTooltips)do 
      tip:Hide()
    end 
  end)

  keyBindManager:SetScript("OnEnter", function(this)
    local h = this.button:GetParent()
    if h and h._fade then 
      MOD:Button_OnEnter(this.button)
    end 
  end)

  keyBindManager:SetScript("OnLeave", function(this)
    this:ClearAllPoints()
    this:Hide()
    GameTooltip:Hide()
    local h = this.button:GetParent()
    if h and h._fade then 
      MOD:Button_OnLeave(this.button)
    end 
  end)

  keyBindManager:SetScript("OnKeyUp", function(this, event)
    MOD:BindingDelegation(event)
  end)

  keyBindManager:SetScript("OnMouseUp", function(this, event)
    MOD:BindingDelegation(event)
  end)

  keyBindManager:SetScript("OnMouseWheel", function(this, delta)
    if delta > 0 then 
      MOD:BindingDelegation("MOUSEWHEELUP")
    else 
      MOD:BindingDelegation("MOUSEWHEELDOWN")
    end 
  end)

  local B = EnumerateFrames()
  while B do 
    MOD:SetBindingButton(B)
    B = EnumerateFrames(B)
  end;

  for l = 1, 12 do 
    local sb = _G["SpellButton"..l]
    sb:HookScript("OnEnter", function(this)
      MOD:RefreshBindings(this, "SPELL")
    end)
  end;

  for btn, _ in pairs(MOD.ButtonCache)do 
    MOD:SetBindingButton(btn, true)
  end;

  if not IsAddOnLoaded("Blizzard_MacroUI")then 
    MOD:SecureHook("LoadAddOn", "SetBindingMacro")
  else 
    MOD:SetBindingMacro("Blizzard_MacroUI")
  end;

  MOD:SecureHook("ActionButton_UpdateFlyout", "RefreshAllFlyouts")
  MOD:RefreshAllFlyouts()

  local pop = CreateFrame("Frame", "SVUI_KeyBindPopup", UIParent)
  pop:SetFrameStrata("DIALOG")
  pop:SetToplevel(true)
  pop:EnableMouse(true)
  pop:SetMovable(true)
  pop:SetFrameLevel(99)
  pop:SetClampedToScreen(true)
  pop:SetWidth(360)
  pop:SetHeight(130)
  pop:SetFixedPanelTemplate("Transparent")
  pop:Hide()

  local moveHandle = CreateFrame("Button", nil, pop)
  moveHandle:SetFixedPanelTemplate("Button", true)
  moveHandle:SetWidth(100)
  moveHandle:SetHeight(25)
  moveHandle:SetPoint("CENTER", pop, "TOP")
  moveHandle:SetFrameLevel(moveHandle:GetFrameLevel() + 2)
  moveHandle:EnableMouse(true)
  moveHandle:RegisterForClicks("AnyUp", "AnyDown")
  moveHandle:SetScript("OnMouseDown", function()
    pop:StartMoving()
  end)
  moveHandle:SetScript("OnMouseUp", function()
    pop:StopMovingOrSizing()
  end)

  local moveText = moveHandle:CreateFontString("OVERLAY")
  moveText:SetFontTemplate()
  moveText:SetPoint("CENTER", moveHandle, "CENTER")
  moveText:SetText("Key Binds")

  local moveDesc = pop:CreateFontString("ARTWORK")
  moveDesc:SetFontObject("GameFontHighlight")
  moveDesc:SetJustifyV("TOP")
  moveDesc:SetJustifyH("LEFT")
  moveDesc:SetPoint("TOPLEFT", 18, -32)
  moveDesc:SetPoint("BOTTOMRIGHT", -18, 48)
  moveDesc:SetText(L["Hover your mouse over any actionbutton or spellbook button to bind it. Press the escape key or right click to clear the current actionbutton's keybinding."])

  local checkButton = CreateFrame("CheckButton", "SVUI_KeyBindPopupCheckButton", pop, "OptionsCheckButtonTemplate")
  _G["SVUI_KeyBindPopupCheckButtonText"]:SetText(CHARACTER_SPECIFIC_KEYBINDINGS)
  checkButton:SetScript("OnShow", function(this)
    this:SetChecked(GetCurrentBindingSet() == 2)
  end)
  checkButton:SetScript("OnClick", function(this)
    if MOD.bindingsChanged then 
      SuperVillain:StaticPopup_Show("CONFIRM_LOSE_BINDING_CHANGES")
    else 
      MOD:ChangeBindingState()
    end 
  end)
  checkButton:SetScript("OnEnter", function(this)
    GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
    GameTooltip:SetText(CHARACTER_SPECIFIC_KEYBINDING_TOOLTIP, nil, nil, nil, nil, 1)
  end)
  checkButton:SetScript("OnLeave", GameTooltip_Hide)

  local saveButton = CreateFrame("Button", "SVUI_KeyBindPopupSaveButton", pop, "OptionsButtonTemplate")
  _G["SVUI_KeyBindPopupSaveButtonText"]:SetText(L["Save"])
  saveButton:Width(150)
  saveButton:SetScript("OnClick", function(this)
    MOD:ToggleKeyBindingMode(true, true)
  end)

  local discardButton = CreateFrame("Button", "SVUI_KeyBindPopupDiscardButton", pop, "OptionsButtonTemplate")
  discardButton:Width(150)
  _G["SVUI_KeyBindPopupDiscardButtonText"]:SetText(L["Discard"])
  discardButton:SetScript("OnClick", function(this)
    MOD:ToggleKeyBindingMode(true, false)
  end)
  checkButton:SetPoint("BOTTOMLEFT", discardButton, "TOPLEFT", 0, 2)
  saveButton:SetPoint("BOTTOMRIGHT", -14, 10)
  discardButton:SetPoint("BOTTOMLEFT", 14, 10)
end;

function MOD:ToggleKeyBindingMode(deactivate, saveRequested)
  if not deactivate then
    keyBindManager.active=true;
    SuperVillain:StaticPopupSpecial_Show(SVUI_KeyBindPopup)
    MOD:RegisterEvent('PLAYER_REGEN_DISABLED','ToggleKeyBindingMode',true,false)
  else
    if saveRequested then 
      SaveBindings(GetCurrentBindingSet())SuperVillain:AddonMessage(L['Bindings Stored'])
    else 
      LoadBindings(GetCurrentBindingSet())SuperVillain:AddonMessage(L['Discarded'])
    end;
    keyBindManager.active=false;
    keyBindManager:ClearAllPoints()
    keyBindManager:Hide()
    GameTooltip:Hide()
    MOD:UnregisterEvent("PLAYER_REGEN_DISABLED")
    SuperVillain:StaticPopupSpecial_Hide(SVUI_KeyBindPopup)
    MOD.bindingsChanged=false
  end
end;

function MOD:BindingDelegation(event)
  MOD.bindingsChanged=true;
  if event=="ESCAPE" or event=="RightButton" then 
    for i=1, #keyBindManager.button.bindings do 
      SetBinding(keyBindManager.button.bindings[i])
    end;
    SuperVillain:AddonMessage(format(L["All keybindings cleared for |cff00ff00%s|r."], keyBindManager.button.name))
    MOD:RefreshBindings(keyBindManager.button, keyBindManager.spellmacro)
    if keyBindManager.spellmacro~="MACRO" then 
      GameTooltip:Hide()
    end;
    return 
  end;
  if event=="LSHIFT" or event=="RSHIFT" or event=="LCTRL" or event=="RCTRL" or event=="LALT" or event=="RALT" or event=="UNKNOWN" or event=="LeftButton" then return end;
  if event=="MiddleButton" then event="BUTTON3" end;
  if event:find('Button%d') then 
    event=event:upper()
  end;
  local altText=IsAltKeyDown() and "ALT-" or "";
  local ctrlText=IsControlKeyDown() and "CTRL-" or "";
  local shiftText=IsShiftKeyDown() and "SHIFT-" or "";
  if not keyBindManager.spellmacro or keyBindManager.spellmacro=="PET" or keyBindManager.spellmacro=="STANCE" or keyBindManager.spellmacro=="FLYOUT" then 
    SetBinding(altText..ctrlText..shiftText..event, keyBindManager.button.bindstring)
  else 
    SetBinding(altText..ctrlText..shiftText..event, keyBindManager.spellmacro.." "..keyBindManager.button.name)
  end;
  SuperVillain:AddonMessage(altText..ctrlText..shiftText..event..L[" |cff00ff00bound to |r"]..keyBindManager.button.name..".")
  MOD:RefreshBindings(keyBindManager.button, keyBindManager.spellmacro)
  if keyBindManager.spellmacro~="MACRO" then 
    GameTooltip:Hide()
  end 
end;

function MOD:RefreshBindings(bindTarget,bindType)
  if not keyBindManager.active or InCombatLockdown() then return end;
  keyBindManager.button=bindTarget;
  keyBindManager.spellmacro=bindType;
  keyBindManager:ClearAllPoints()
  keyBindManager:SetAllPoints(bindTarget)
  keyBindManager:Show()
  ShoppingTooltip1:Hide()
  local flyout=bindTarget.FlyoutArrow;
  if flyout and flyout:IsShown()then 
    keyBindManager:EnableMouse(false)
  elseif not keyBindManager:IsMouseEnabled()then 
    keyBindManager:EnableMouse(true)
  end;
  if bindType=="FLYOUT" then 
    keyBindManager.button.name=GetSpellInfo(bindTarget.spellID)
    keyBindManager.button.bindstring="SPELL "..keyBindManager.button.name;
    GameTooltip:AddLine(L['Trigger'])
    GameTooltip:Show()
    GameTooltip:SetScript("OnHide",function(l)
      l:SetOwner(keyBindManager,"ANCHOR_TOP")
      l:SetPoint("BOTTOM",keyBindManager,"TOP",0,1)
      l:AddLine(keyBindManager.button.name,1,1,1)
      keyBindManager.button.bindings={GetBindingKey(keyBindManager.button.bindstring)}
      if #keyBindManager.button.bindings==0 then 
        l:AddLine(L["No bindings set."],.6,.6,.6)
      else 
        l:AddDoubleLine(L["Binding"],L["Key"],.6,.6,.6,.6,.6,.6)
        for e=1,#keyBindManager.button.bindings do 
          l:AddDoubleLine(e,keyBindManager.button.bindings[e])
        end 
      end;
      l:Show()
      l:SetScript("OnHide",nil)
    end)
  elseif bindType=="SPELL" then 
    keyBindManager.button.id=SpellBook_GetSpellBookSlot(keyBindManager.button)
    keyBindManager.button.name=GetSpellBookItemName(keyBindManager.button.id, SpellBookFrame.bookType)
    GameTooltip:AddLine(L['Trigger'])
    GameTooltip:Show()
    GameTooltip:SetScript("OnHide",function(l)
      l:SetOwner(keyBindManager,"ANCHOR_TOP")
      l:SetPoint("BOTTOM",keyBindManager,"TOP",0,1)
      l:AddLine(keyBindManager.button.name,1,1,1)
      keyBindManager.button.bindings={GetBindingKey(bindType.." "..keyBindManager.button.name)}
      if #keyBindManager.button.bindings==0 then 
        l:AddLine(L["No bindings set."],.6,.6,.6)
      else 
        l:AddDoubleLine(L["Binding"],L["Key"],.6,.6,.6,.6,.6,.6)
        for e=1,#keyBindManager.button.bindings do 
          l:AddDoubleLine(e,keyBindManager.button.bindings[e])
        end 
      end;
      l:Show()
      l:SetScript("OnHide",nil)
    end)
  elseif bindType=="MACRO" then 
    keyBindManager.button.id=keyBindManager.button:GetID()
    if floor(.5 + select(2,MacroFrameTab1Text:GetTextColor()) * 10) / 10 == .8 then 
      keyBindManager.button.id=keyBindManager.button.id + 36
    end;
    keyBindManager.button.name=GetMacroInfo(keyBindManager.button.id)
    GameTooltip:SetOwner(keyBindManager,"ANCHOR_TOP")
    GameTooltip:SetPoint("BOTTOM",keyBindManager,"TOP",0,1)
    GameTooltip:AddLine(keyBindManager.button.name,1,1,1)
    keyBindManager.button.bindings={GetBindingKey(bindType.." "..keyBindManager.button.name)}
    if #keyBindManager.button.bindings==0 then 
      GameTooltip:AddLine(L["No bindings set."],.6,.6,.6)
    else 
      GameTooltip:AddDoubleLine(L["Binding"],L["Key"],.6,.6,.6,.6,.6,.6)
      for e=1,#keyBindManager.button.bindings do 
        GameTooltip:AddDoubleLine(L["Binding"]..e, keyBindManager.button.bindings[e],1,1,1)
      end 
    end;
    GameTooltip:Show()
  elseif bindType=="STANCE" or bindType=="PET" then 
    keyBindManager.button.id=tonumber(bindTarget:GetID())
    keyBindManager.button.name=bindTarget:GetName()
    if not keyBindManager.button.name then return end;
    if ((not keyBindManager.button.id) or (keyBindManager.button.id < 1) or (keyBindManager.button.id > (bindType == "STANCE" and 10 or 12))) then 
      keyBindManager.button.bindstring="CLICK "..keyBindManager.button.name..":LeftButton"
    else 
      keyBindManager.button.bindstring=(bindType=="STANCE" and "StanceButton" or "BONUSACTIONBUTTON")..keyBindManager.button.id 
    end;
    GameTooltip:AddLine(L['Trigger'])
    GameTooltip:Show()
    GameTooltip:SetScript("OnHide",function(l)
      l:SetOwner(keyBindManager,"ANCHOR_NONE")
      l:SetPoint("BOTTOM",keyBindManager,"TOP",0,1)
      l:AddLine(keyBindManager.button.name,1,1,1)
      keyBindManager.button.bindings={GetBindingKey(keyBindManager.button.bindstring)}
      if #keyBindManager.button.bindings==0 then 
        l:AddLine(L["No bindings set."],.6,.6,.6)
      else 
        l:AddDoubleLine(L["Binding"],L["Key"],.6,.6,.6,.6,.6,.6)
        for e=1,#keyBindManager.button.bindings do 
          l:AddDoubleLine(e,keyBindManager.button.bindings[e])
        end 
      end;
      l:Show()
      l:SetScript("OnHide",nil)
    end)
  else 
    keyBindManager.button.action=tonumber(bindTarget.action)
    keyBindManager.button.name=bindTarget:GetName()
    if not keyBindManager.button.name then 
      return 
    end;
    if (((not keyBindManager.button.action) or (keyBindManager.button.action < 1) or (keyBindManager.button.action > 132)) and not keyBindManager.button.keyBoundTarget) then 
      keyBindManager.button.bindstring="CLICK "..keyBindManager.button.name..":LeftButton"
    elseif keyBindManager.button.keyBoundTarget then 
      keyBindManager.button.bindstring=keyBindManager.button.keyBoundTarget 
    else 
      local m = 1 + (keyBindManager.button.action - 1) % 12;
      if ((keyBindManager.button.action < 25) or (keyBindManager.button.action > 72)) then 
        keyBindManager.button.bindstring="ACTIONBUTTON"..m;
      elseif ((keyBindManager.button.action < 73) and (keyBindManager.button.action > 60)) then 
        keyBindManager.button.bindstring="MULTIACTIONBAR1BUTTON"..m;
      elseif keyBindManager.button.action < 61 and keyBindManager.button.action > 48 then 
        keyBindManager.button.bindstring="MULTIACTIONBAR2BUTTON"..m;
      elseif keyBindManager.button.action < 49 and keyBindManager.button.action > 36 then 
        keyBindManager.button.bindstring="MULTIACTIONBAR4BUTTON"..m;
      elseif keyBindManager.button.action < 37 and keyBindManager.button.action > 24 then 
        keyBindManager.button.bindstring="MULTIACTIONBAR3BUTTON"..m;
      end 
    end;
    GameTooltip:AddLine(L['Trigger'])
    GameTooltip:Show()
    GameTooltip:SetScript("OnHide",function(l)
      l:SetOwner(keyBindManager,"ANCHOR_TOP")
      l:SetPoint("BOTTOM",keyBindManager,"TOP",0,4)
      l:AddLine(keyBindManager.button.name,1,1,1)
      keyBindManager.button.bindings={GetBindingKey(keyBindManager.button.bindstring)}
      if #keyBindManager.button.bindings==0 then 
        l:AddLine(L["No bindings set."],.6,.6,.6)
      else 
        l:AddDoubleLine(L["Binding"],L["Key"],.6,.6,.6,.6,.6,.6)
        for e=1,#keyBindManager.button.bindings do 
          l:AddDoubleLine(e, keyBindManager.button.bindings[e])
        end 
      end;
      l:Show()
      l:SetScript("OnHide",nil)
    end)
  end 
end;

function MOD:SetBindingButton(button,arg)
  local click1=StanceButton1:GetScript("OnClick")
  local click2=PetActionButton1:GetScript("OnClick")
  local click3=SecureActionButton_OnClick;
  if button.IsProtected and button.GetObjectType and button.GetScript and button:GetObjectType()=="CheckButton" and button:IsProtected() then 
    local r=button:GetScript("OnClick")
    if r==click3 or arg then 
      button:HookScript("OnEnter",function(this)
        MOD:RefreshBindings(this)
      end)
    elseif r==click1 then 
      button:HookScript("OnEnter",function(this)
        MOD:RefreshBindings(this,"STANCE")
      end)
    elseif r==click2 then 
      button:HookScript("OnEnter",function(this)
        MOD:RefreshBindings(this,"PET")
      end)
    end 
  end 
end;

function MOD:SetBindingMacro(arg)
  if arg=="Blizzard_MacroUI" then 
    for i=1,36 do 
      local btn=_G["MacroButton"..i]
      btn:HookScript("OnEnter",function(this)
        MOD:RefreshBindings(this,"MACRO")
      end)
    end 
  end 
end;

function MOD:BindingTooltip_OnUpdate(tooltip,increase)
  TIMER=(TIMER + increase);
  if TIMER < .2 then 
    return 
  else 
    TIMER = 0 
  end;
  if not tooltip.comparing and IsModifiedClick("COMPAREITEMS") then 
    GameTooltip_ShowCompareItem(tooltip)
    tooltip.comparing=true 
  elseif tooltip.comparing and not IsModifiedClick("COMPAREITEMS") then 
    for _,tip in pairs(tooltip.shoppingTooltips)do 
      tip:Hide()
    end;
    tooltip.comparing=false 
  end 
end;

function MOD:RefreshAllFlyouts()
  for i=1,GetNumFlyouts()do 
    local id=GetFlyoutID(i)
    local _,_,max,check = GetFlyoutInfo(id)
    if check then 
      for x=1,max do 
        local btn=_G["SpellFlyoutButton"..x]
        if SpellFlyout:IsShown() and btn and btn:IsShown() then 
          if not btn.hookedFlyout then 
            btn:HookScript("OnEnter",function(this)
              MOD:RefreshBindings(this,"FLYOUT")
            end)
            btn.hookedFlyout=true 
          end 
        end 
      end 
    end 
  end 
end;

function MOD:ChangeBindingState()
  if SVUI_KeyBindPopupCheckButton:GetChecked() then 
    LoadBindings(2)
    SaveBindings(2)
  else 
    LoadBindings(1)
    SaveBindings(1)
  end 
end;
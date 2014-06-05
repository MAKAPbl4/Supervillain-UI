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
local ipairs    = _G.ipairs;
local type      = _G.type;
local error     = _G.error;
local pcall     = _G.pcall;
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local table     = _G.table;
--[[ TABLE METHODS ]]--
local tremove, tcopy, twipe, tsort, tconcat, tdump = table.remove, table.copy, table.wipe, table.sort, table.concat, table.dump;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, G = unpack(select(2, ...));
local LSM = LibStub("LibSharedMedia-3.0")
--[[ 
########################################################## 
LOCALIZED GLOBALS
##########################################################
]]--
local STANDARD_TEXT_FONT = _G.STANDARD_TEXT_FONT
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local AllowedMask = {
    ['UnitLarge'] = true,
    ['UnitSmall'] = true,
    ['Pattern'] = true,
    ['Comic'] = true,
    ['Default'] = true
};
local backdropTemplates = {};
local textureTemplates = {};
local fontTemplates = {};
local fontCommonUpdates = {};

local NewFrame = CreateFrame;
local NewHook = hooksecurefunc;
local screenMod = SuperVillain.mult;
--[[ UPVALUES ]]--
local COLORS = SuperVillain.Colors;
local TEXTURES = SuperVillain.Textures;
local TEMPLATES = SuperVillain.Templates;
local GRADIENTS = COLORS.gradient;
local DEFAULTCOLOR = COLORS.default;
local BORDERCOLOR = COLORS.dark;
local SHADOWTEXTURE = TEXTURES.shadow;
local STANDARDFONTSIZE = C.common.fontSize;
--[[ 
########################################################## 
HANDLERS
##########################################################
]]--
local HookPanelBorderColor = function(self,r,g,b,a)
    if self[1]then 
        self[1]:SetTexture(r,g,b,a)
        self[2]:SetTexture(r,g,b,a)
        self[3]:SetTexture(r,g,b,a)
        self[4]:SetTexture(r,g,b,a)
    end;
end;
    
local HookBackdropBorderColor = function(self,r,g,b,a)
    self.Panel:SetBackdropBorderColor(r,g,b,a)
    if self.ShadowPanel then 
        self.ShadowPanel:SetBackdropBorderColor(r,g,b,0.5)
    end
end;

local HookBackdrop = function(self,...) 
    self.Panel:SetBackdrop(...) 
end;

local HookBackdropColor = function(self,...) 
    self.Panel:SetBackdropColor(...) 
end;
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function UserScale(value)
    return screenMod * floor(value / screenMod + .5);
end;

local function CreateTemplatePanel(frame, padding, color, xOffset, yOffset)
    if(frame.Panel) then return end;

    local size = padding or 0;
    local colorTexture = color or {0,0,0};

    xOffset = xOffset or size;
    yOffset = yOffset or size;

    local panel = NewFrame('Frame', nil, frame)
    panel:Point('TOPLEFT', frame, 'TOPLEFT', (xOffset * -1), yOffset)
    panel:Point('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', xOffset, (yOffset * -1))

    local lvl = frame:GetFrameLevel() - 1
    if(lvl >= 0) then
        panel:SetFrameLevel(lvl)
    end

    if(size > 0 and type(colorTexture) == 'table') then 
        panel[1] = panel:CreateTexture(nil,"BORDER")
        panel[1]:SetTexture(unpack(colorTexture))
        panel[1]:SetPoint("TOPLEFT")
        panel[1]:SetPoint("BOTTOMLEFT")
        panel[1]:SetWidth(size)
        panel[2] = panel:CreateTexture(nil,"BORDER")
        panel[2]:SetTexture(unpack(colorTexture))
        panel[2]:SetPoint("TOPRIGHT")
        panel[2]:SetPoint("BOTTOMRIGHT")
        panel[2]:SetWidth(size)
        panel[3] = panel:CreateTexture(nil,"BORDER")
        panel[3]:SetTexture(unpack(colorTexture))
        panel[3]:SetPoint("TOPLEFT")
        panel[3]:SetPoint("TOPRIGHT")
        panel[3]:SetHeight(size)
        panel[4] = panel:CreateTexture(nil,"BORDER")
        panel[4]:SetTexture(unpack(colorTexture))
        panel[4]:SetPoint("BOTTOMLEFT")
        panel[4]:SetPoint("BOTTOMRIGHT")
        panel[4]:SetHeight(size)
    end;

    return panel
end;

local function CreateShadowPanel(frame, underlay)
    if(frame.ShadowPanel) then return end;

    local parent = (underlay) and frame.Panel or frame
    local panel = NewFrame('Frame', nil, parent)
    panel:Point('TOPLEFT', parent, 'TOPLEFT', -3, 3)
    panel:Point('BOTTOMRIGHT', parent, 'BOTTOMRIGHT', 3, -3)
    panel:SetBackdrop({
        edgeFile = SHADOWTEXTURE,
        edgeSize = 3,
        insets = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0
        }
    });
    panel:SetBackdropBorderColor(0,0,0,0.5)

    return panel
end;

local function CreateSkinPanel(frame, padding, texture, drawLevel, blend, color, colorGradient, xOffset, yOffset)
    local mod = padding or 1;
    xOffset = ((xOffset or mod) - mod);
    yOffset = ((yOffset or mod) - mod);

    local panel = frame:CreateTexture(nil,"BACKGROUND",nil,drawLevel)
    panel:Point('TOPLEFT', frame, 'TOPLEFT', (xOffset * -1), yOffset)
    panel:Point('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', xOffset, (yOffset * -1))

    if(texture) then 
        panel:SetTexture(texture)
        if(blend) then 
            panel:SetBlendMode(blend)
        end;
        if(colorGradient and GRADIENTS[colorGradient]) then
            local useGradient = GRADIENTS[colorGradient]
            panel:SetGradient(unpack(useGradient))
        elseif(color and type(color) == 'table') then 
            panel:SetVertexColor(unpack(color))
        end 
    end;
    panel:SetNonBlocking(true)

    return panel 
end;

local function CreateDeluxePanel(frame, settings, drawLevel)
    if(frame.DeluxePanel or (not settings) or (type(settings) ~= 'table')) then return end;

    local level = (drawLevel or 0) + 1

    local panel = {};
    panel[1] = frame:CreateTexture(nil, "BACKGROUND", nil, level)
    panel[1]:SetTexture(settings.TOPLEFT)
    panel[1]:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    panel[1]:SetPoint("TOPRIGHT", frame, "TOP", 0, 0)
    panel[1]:SetPoint("BOTTOMLEFT", frame, "LEFT", 0, 0)
    panel[1]:SetVertexColor(0.05, 0.05, 0.05, 0.5)
    panel[1]:SetNonBlocking(true)

    panel[2] = frame:CreateTexture(nil, "BACKGROUND", nil, level)
    panel[2]:SetTexture(settings.TOPRIGHT)
    panel[2]:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
    panel[2]:SetPoint("TOPLEFT", frame, "TOP", 0, 0)
    panel[2]:SetPoint("BOTTOMRIGHT", frame, "RIGHT", 0, 0)
    panel[2]:SetVertexColor(0.05, 0.05, 0.05, 0.5)
    panel[2]:SetNonBlocking(true)

    panel[3] = frame:CreateTexture(nil, "BACKGROUND", nil, level)
    panel[3]:SetTexture(settings.BOTTOMRIGHT)
    panel[3]:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
    panel[3]:SetPoint("BOTTOMLEFT", frame, "BOTTOM", 0, 0)
    panel[3]:SetPoint("TOPRIGHT", frame, "RIGHT", 0, 0)
    panel[3]:SetVertexColor(0.1, 0.1, 0.1, 0.5)
    panel[3]:SetNonBlocking(true)

    panel[4] = frame:CreateTexture(nil, "BACKGROUND", nil, level)
    panel[4]:SetTexture(settings.BOTTOMLEFT)
    panel[4]:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
    panel[4]:SetPoint("BOTTOMRIGHT", frame, "BOTTOM", 0, 0)
    panel[4]:SetPoint("TOPLEFT", frame, "LEFT", 0, 0)
    panel[4]:SetVertexColor(0.1, 0.1, 0.1, 0.5)
    panel[4]:SetNonBlocking(true)

    return panel
end;

local function SetTemplateHooks(frame, deepHooks)
    if(not frame.Panel) then return end;
    NewHook(frame.Panel, "SetBackdropBorderColor", HookPanelBorderColor)
    NewHook(frame, "SetBackdropBorderColor", HookBackdropBorderColor)
    if(deepHooks) then
        NewHook(frame, "SetBackdrop", HookBackdrop)
        NewHook(frame, "SetBackdropColor", HookBackdropColor)
    end
end;

local function HasCooldown(n)
    local cd = n and n.."Cooldown"
    return cd and _G[cd]
end

local function CreateButtonPanel(frame, noChecked, brightChecked)
    if(frame.hasPanel) then return end
    
    if(frame.Left) then 
        frame.Left:SetAlpha(0)
    end;

    if(frame.Middle) then 
        frame.Middle:SetAlpha(0)
    end;

    if(frame.Right) then 
        frame.Right:SetAlpha(0)
    end;

    if(frame.SetNormalTexture) then 
        frame:SetNormalTexture("")
    end;

    if(frame.SetDisabledTexture) then 
        frame:SetDisabledTexture("")
    end;

    if(frame.SetHighlightTexture and not frame.hover) then
        local hover = frame:CreateTexture("frame", nil, frame)
        hover:SetTexture(unpack(COLORS.highlight), 0.5)
        hover:FillInner(frame.Panel)
        frame.hover = hover;
        frame:SetHighlightTexture(hover) 
    end;

    if(frame.SetPushedTexture and not frame.pushed) then 
        local pushed = frame:CreateTexture("frame", nil, frame)
        pushed:SetTexture(0.1, 0.8, 0.1, 0.3)
        pushed:FillInner(frame.Panel)
        frame.pushed = pushed;
        frame:SetPushedTexture(pushed)
    end;

    if(not noChecked and frame.SetCheckedTexture) then 
        local checked = frame:CreateTexture("frame", nil, frame)
        if(not brightChecked) then
            checked:SetTexture(TEXTURES.default)
            checked:SetVertexColor(0, 0.5, 0, 0.2)
        else
            checked:SetTexture(TEXTURES.gloss)
            checked:SetVertexColor(0, 1, 0, 1)
        end
        checked:FillInner(frame.Panel)
        frame.checked = checked;
        frame:SetCheckedTexture(checked)
    end;

    local cd = HasCooldown(frame:GetName())
    if cd then 
        cd:ClearAllPoints()
        cd:FillInner()
    end;

    frame.hasPanel = true
end;
--[[ 
########################################################## 
APPENDED POSITIONING METHODS
##########################################################
]]--
local function Size(self,width,height)
    if not self then return end;
    self:SetSize(UserScale(width),UserScale(height or width))
end;

local function Width(self,b)
    if not self then return end;
    self:SetWidth(UserScale(b))
end;

local function Height(self,c)
    if not self then return end;
    self:SetHeight(UserScale(c))
end;

local function Point(self, ...)
    local arg1, arg2, arg3, arg4, arg5 = select(1, ...)
    if not self then return end; 
    local params = { arg1, arg2, arg3, arg4, arg5 }
    for i = 1, #params do 
        if type(params[i]) == "number" then 
            params[i] = UserScale(params[i])
        end 
    end 
    self:SetPoint(unpack(params))
end;

local function WrapOuter(self, target, x, y)
    x = UserScale(x or 1);
    y = UserScale(y or x);
    target = target or self:GetParent()
    if self:GetPoint() then 
        self:ClearAllPoints()
    end;
    self:SetPoint("TOPLEFT", target, "TOPLEFT", -x, y)
    self:SetPoint("BOTTOMRIGHT", target, "BOTTOMRIGHT", x, -y)
end;

local function FillInner(self, target, x, y)
    x = UserScale(x or 1);
    y = UserScale(y or x);
    target = target or self:GetParent()
    if self:GetPoint() then 
        self:ClearAllPoints()
    end;
    self:SetPoint("TOPLEFT", target, "TOPLEFT", x, -y)
    self:SetPoint("BOTTOMRIGHT", target, "BOTTOMRIGHT", -x, y)
end;
--[[ 
########################################################## 
APPENDED DESTROY METHODS
##########################################################
]]--
-- MUNG ( Modify - Until - No - Good )
local Purgatory = NewFrame("Frame", nil)
Purgatory:Hide()

local function MUNG(self)
    if self.UnregisterAllEvents then 
        self:UnregisterAllEvents()
        self:SetParent(Purgatory)
    else 
        self.Show = self.Hide 
    end;
    self:Hide()
end;

local function Formula409(self, option)
    for i = 1, self:GetNumRegions()do 
        local target = select(i, self:GetRegions())
        if(target and (target:GetObjectType() == "Texture")) then 
            if(option and (type(option) == "boolean")) then 
                if target.UnregisterAllEvents then 
                    target:UnregisterAllEvents()
                    target:SetParent(Purgatory)
                else 
                    target.Show = target.Hide 
                end;
                target:Hide()
            elseif(target:GetDrawLayer() == option) then 
                target:SetTexture(nil)
            elseif(option and (type(option) == "string") and (target:GetTexture() ~= option)) then 
                target:SetTexture(nil)
            else 
                target:SetTexture(nil)
            end 
        end 
    end 
end;
--[[ 
########################################################## 
APPENDED TEMPLATING METHODS
##########################################################
]]--
local function SetPanelTemplate(self, templateName, noupdate, overridePadding, xOffset, yOffset)
    if(self.Panel) then return; end
    if(not templateName or not TEMPLATES[templateName]) then templateName = 'Default' end;
    local settings = TEMPLATES[templateName]
    local padding = settings.padding or 1
    local bgColor = COLORS[settings.primary] or DEFAULTCOLOR
    local borderColor = COLORS[settings.secondary] or BORDERCOLOR
    local initLevel = 0;

    if(overridePadding and type(overridePadding) == "number") then
        padding = overridePadding
    end

    xOffset = xOffset or 1
    yOffset = yOffset or 1

    self.Panel = CreateTemplatePanel(self, padding, borderColor, xOffset, yOffset)

    if(settings.shadow) then
        self.ShadowPanel = CreateShadowPanel(self, true)
    end

    if(settings.backdrop) then
        initLevel = 1;
        self.Panel:SetBackdrop(settings.backdrop)
        self.Panel:SetBackdropColor(unpack(bgColor))
        self.Panel:SetBackdropBorderColor(unpack(borderColor))
        if(templateName ~= 'Transparent') then
            SetTemplateHooks(self, true)
        end
    end

    if(settings.texture) then
        local tx = TEXTURES[settings.texture]
        self.SkinPanel = CreateSkinPanel(self.Panel, padding, tx, initLevel, settings.blending, bgColor, settings.gradient, xOffset, yOffset)
        if((not noupdate) and (not settings.texnoupdate) and AllowedMask[templateName]) then
            textureTemplates[#textureTemplates + 1] = self
        end
        self.SkinPanel:SetParent(self.Panel)
    end

    if(settings.extended) then 
        self.DeluxePanel = CreateDeluxePanel(self, settings.extended, initLevel)
    end;

    self.template = templateName;

    if ((not noupdate) and (not settings.noupdate) and settings.backdrop) then
        backdropTemplates[#backdropTemplates + 1] = self
    end;

    local level = self:GetFrameLevel() - 1
    if(level >= 0) then 
        self.Panel:SetFrameLevel(level)
    else 
        self.Panel:SetFrameLevel(0)
    end
end;

local function SetFixedPanelTemplate(self, templateName, noupdate, overridePadding, xOffset, yOffset)
    if(self.Panel) then return; end
    if(not templateName or not TEMPLATES[templateName]) then templateName = 'Default' end;
    local settings = TEMPLATES[templateName]
    local padding = settings.padding or 0
    local bgColor = COLORS[settings.primary] or DEFAULTCOLOR
    local borderColor = COLORS[settings.secondary] or BORDERCOLOR
    local initLevel = 0;

    if(overridePadding and type(overridePadding) == "number") then
        padding = overridePadding
    end

    xOffset = xOffset or 1
    yOffset = yOffset or 1

    self.Panel = CreateTemplatePanel(self, padding, borderColor, xOffset, yOffset)

    if(settings.shadow) then
        self.ShadowPanel = CreateShadowPanel(self)
    end

    if(settings.backdrop) then
        initLevel = 1;
        self:SetBackdrop(settings.backdrop)
        self:SetBackdropColor(unpack(bgColor))
        self:SetBackdropBorderColor(unpack(borderColor))
        if(templateName ~= 'Transparent') then
            SetTemplateHooks(self)
        end
    end

    if(settings.texture) then
        local tx = TEXTURES[settings.texture]
        self.SkinPanel = CreateSkinPanel(self, padding, tx, initLevel, settings.blending, bgColor, settings.gradient)
        if((not noupdate) and (not settings.texnoupdate) and AllowedMask[templateName]) then
            textureTemplates[#textureTemplates + 1] = self
        end
    end

    if(settings.extended) then 
        self.DeluxePanel = CreateDeluxePanel(self, settings.extended, initLevel)
    end;

    self.template = templateName;

    if ((not noupdate) and (not settings.noupdate) and settings.backdrop) then
        backdropTemplates[#backdropTemplates + 1] = self
    end;

    local level = self:GetFrameLevel() - 1
    if(level >= 0) then 
        self.Panel:SetFrameLevel(level)
    else 
        self.Panel:SetFrameLevel(0)
    end
end;

local function SetPanelColor(self, ...)
    local arg1,arg2,arg3,arg4,arg5,arg6,arg7 = select(1, ...)
    if(not self.Panel or not arg1) then return; end 
    if(self.SkinPanel) then
        if(type(arg1) == "string") then
            if(GRADIENTS[arg1]) then
                local d,r,g,b,r2,g2,b2 = unpack(GRADIENTS[arg1])
                if self.BorderPanel then
                    self.SkinPanel:SetGradient(d,r*.5,g*.5,b*.5,r2*.5,g2*.5,b2*.5)
                    self.BorderPanel[1]:SetTexture(r2,g2,b2)
                    self.BorderPanel[2]:SetTexture(r2,g2,b2)
                    self.BorderPanel[3]:SetTexture(r2,g2,b2)
                    self.BorderPanel[4]:SetTexture(r2,g2,b2)
                else
                    self.SkinPanel:SetGradient(d,r,g,b,r2,g2,b2)
                end
            elseif(arg1 == "VERTICAL" or arg1 == "HORIZONTAL") then
                self.SkinPanel:SetGradient(...)
            end;
        end;
    elseif(type(arg1) == "string" and COLORS[arg1]) then
        local r,g,b = unpack(COLORS[arg1])
        if self.BorderPanel then
            self:SetBackdropColor(r*.5,g*.5,b*.5)
            self.BorderPanel[1]:SetTexture(r,g,b)
            self.BorderPanel[2]:SetTexture(r,g,b)
            self.BorderPanel[3]:SetTexture(r,g,b)
            self.BorderPanel[4]:SetTexture(r,g,b)
        else
            self:SetBackdropColor(unpack(COLORS[arg1]))
        end
    elseif(arg1 and type(arg1) == "number") then
        self:SetBackdropColor(...)
    end;
end;
--[[ 
########################################################## 
APPENDED BUTTON TEMPLATING METHODS
##########################################################
]]--
local function SetButtonTemplate(self)
    if self.styled then return end;

    SetFixedPanelTemplate(self, "Button", true, 1)

    if(self.Left) then 
        self.Left:SetAlpha(0)
    end;

    if(self.Middle) then 
        self.Middle:SetAlpha(0)
    end;

    if(self.Right) then 
        self.Right:SetAlpha(0)
    end;

    if(self.SetNormalTexture) then 
        self:SetNormalTexture("")
    end;

    if(self.SetDisabledTexture) then 
        self:SetDisabledTexture("")
    end;

    if(self.SetHighlightTexture and not self.hover) then
        local hover = self:CreateTexture("frame", nil, self)
        hover:SetTexture(unpack(COLORS.highlight), 0.5)
        FillInner(hover, self.Panel)
        self.hover = hover;
        self:SetHighlightTexture(hover) 
    end;

    if(self.SetPushedTexture and not self.pushed) then 
        local pushed = self:CreateTexture("frame", nil, self)
        pushed:SetTexture(0.1, 0.8, 0.1, 0.3)
        FillInner(pushed, self.Panel)
        self.pushed = pushed;
        self:SetPushedTexture(pushed)
    end;

    if(self.SetCheckedTexture and not self.checked) then 
        local checked = self:CreateTexture("frame", nil, self)
        checked:SetTexture(TEXTURES.default)
        checked:SetVertexColor(0, 0.5, 0, 0.2)
        FillInner(checked, self.Panel)
        self.checked = checked;
        self:SetCheckedTexture(checked)
    end;

    self.styled = true
end;

local function SetSlotTemplate(self, underlay, padding, x, y, noChecked)
    if self.styled then return end;
    padding = padding or 1
    if(underlay) then 
        SetPanelTemplate(self, "Slot", true, padding, x, y)
    else
        SetFixedPanelTemplate(self, "Slot", true, padding, x, y)
    end
    CreateButtonPanel(self, noChecked)
    self.styled = true
end;

local function SetCheckboxTemplate(self, underlay, x, y)
    if self.styled then return end;
    if(underlay) then
        SetPanelTemplate(self, "Slot", true, 1, -7, -7)
    else
        SetFixedPanelTemplate(self, "Slot", true, 1, x, y)
    end

    CreateButtonPanel(self, false, true)

    NewHook(self, "SetChecked",function(self,checked)
        local r,g,b = 0,0,0
        if(checked == 1) then
            r,g,b = self:GetCheckedTexture():GetVertexColor()
        end
        self:SetBackdropBorderColor(r,g,b) 
    end)
    
    self.styled = true
end;

local function SetEditboxTemplate(self, x, y)
    if self.styled then return end;
    
    if self.TopLeftTex then MUNG(self.TopLeftTex) end;
    if self.TopRightTex then MUNG(self.TopRightTex) end;
    if self.TopTex then MUNG(self.TopTex) end;
    if self.BottomLeftTex then MUNG(self.BottomLeftTex) end;
    if self.BottomRightTex then MUNG(self.BottomRightTex) end;
    if self.BottomTex then MUNG(self.BottomTex) end;
    if self.LeftTex then MUNG(self.LeftTex) end;
    if self.RightTex then MUNG(self.RightTex) end;
    if self.MiddleTex then MUNG(self.MiddleTex) end;

    SetPanelTemplate(self, "Inset", true, 1, x, y)

    local globalName = self:GetName();
    if globalName then 
        if _G[globalName.."Left"] then MUNG(_G[globalName.."Left"]) end;
        if _G[globalName.."Middle"] then MUNG(_G[globalName.."Middle"]) end;
        if _G[globalName.."Right"] then MUNG(_G[globalName.."Right"]) end;
        if _G[globalName.."Mid"] then MUNG(_G[globalName.."Mid"]) end;
        if globalName:find("Silver") or globalName:find("Copper") then 
            self.Panel:SetPoint("BOTTOMRIGHT", -12, -2) 
        end 
    end
    self.styled = true
end;

local function SetFramedButtonTemplate(self)
    if self.styled then return end;

    SetFixedPanelTemplate(self, "Default", true, 1)

    if(self.Left) then 
        self.Left:SetAlpha(0)
    end;

    if(self.Middle) then 
        self.Middle:SetAlpha(0)
    end;

    if(self.Right) then 
        self.Right:SetAlpha(0)
    end;

    if(self.SetNormalTexture) then 
        self:SetNormalTexture("")
    end;

    if(self.SetDisabledTexture) then 
        self:SetDisabledTexture("")
    end;

    if(self.SetHighlightTexture and not self.hover) then
        local hover = self:CreateTexture("frame", nil, self)
        hover:SetTexture(unpack(COLORS.highlight), 0.5)
        FillInner(hover, self.Panel)
        self.hover = hover;
        self:SetHighlightTexture(hover) 
    end;

    if(self.SetPushedTexture and not self.pushed) then 
        local pushed = self:CreateTexture("frame", nil, self)
        pushed:SetTexture(0.1, 0.8, 0.1, 0.3)
        FillInner(pushed, self.Panel)
        self.pushed = pushed;
        self:SetPushedTexture(pushed)
    end;

    if(self.SetCheckedTexture and not self.checked) then 
        local checked = self:CreateTexture("frame", nil, self)
        checked:SetTexture(TEXTURES.default)
        checked:SetVertexColor(0, 0.5, 0, 0.2)
        FillInner(checked, self.Panel)
        self.checked = checked;
        self:SetCheckedTexture(checked)
    end;

    local cd = HasCooldown(self:GetName())
    if cd then 
        cd:ClearAllPoints()
        cd:FillInner()
    end;

    local border = NewFrame('Frame',nil,self)
    border:Point('TOPLEFT', self, 'TOPLEFT', -2, 2)
    border:Point('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 2, -2)

    border[1] = border:CreateTexture(nil,"BORDER")
    border[1]:SetTexture(unpack(DEFAULTCOLOR))
    border[1]:SetPoint("TOPLEFT")
    border[1]:SetPoint("BOTTOMLEFT")
    border[1]:SetWidth(2)
    border[2] = border:CreateTexture(nil,"BORDER")
    border[2]:SetTexture(unpack(DEFAULTCOLOR))
    border[2]:SetPoint("TOPRIGHT")
    border[2]:SetPoint("BOTTOMRIGHT")
    border[2]:SetWidth(2)
    border[3] = border:CreateTexture(nil,"BORDER")
    border[3]:SetTexture(unpack(DEFAULTCOLOR))
    border[3]:SetPoint("TOPLEFT")
    border[3]:SetPoint("TOPRIGHT")
    border[3]:SetHeight(2)
    border[4] = border:CreateTexture(nil,"BORDER")
    border[4]:SetTexture(unpack(DEFAULTCOLOR))
    border[4]:SetPoint("BOTTOMLEFT")
    border[4]:SetPoint("BOTTOMRIGHT")
    border[4]:SetHeight(2)

    local shadow = NewFrame('Frame',nil,border)
    shadow:Point('TOPLEFT',border,'TOPLEFT',-2,2)
    shadow:Point('BOTTOMRIGHT',border,'BOTTOMRIGHT',2,-2)
    shadow:SetBackdrop({
        edgeFile = SHADOWTEXTURE, 
        edgeSize = 3, 
        insets = {
            left = 2, 
            right = 2, 
            top = 2, 
            bottom = 2
        }
    })
    shadow:SetBackdropBorderColor(0,0,0,0.9)

    self.BorderPanel = border
    self.styled = true
end;
--[[ 
########################################################## 
APPENDED FONT TEMPLATING METHODS
##########################################################
]]--
local function SetFontTemplate(self, font, fontSize, fontStyle, fontJustifyH, fontJustifyV, noUpdate)
    local useCommon = fontSize and (fontSize == STANDARDFONTSIZE);
    font = font or STANDARD_TEXT_FONT
    fontSize = fontSize or STANDARDFONTSIZE;
    fontJustifyH = fontJustifyH or "CENTER";
    fontJustifyV = fontJustifyV or "MIDDLE";
    self.font = font;
    self.fontSize = fontSize;
    self.fontStyle = fontStyle;
    self.fontJustifyH = fontJustifyH;
    self.fontJustifyV = fontJustifyV;
    self:SetFont(font, fontSize, fontStyle)
    if(fontStyle and fontStyle  ~= "NONE") then 
        self:SetShadowColor(0, 0, 0, 0)
    else 
        self:SetShadowColor(0, 0, 0, 0.2)
    end;
    self:SetShadowOffset(1, -1)
    self:SetJustifyH(fontJustifyH)
    self:SetJustifyV(fontJustifyV)
    if(not noUpdate) then
        fontTemplates[#fontTemplates + 1] = self
        if useCommon then
            fontCommonUpdates[#fontCommonUpdates + 1] = self
        end
    end
end;
--[[ 
########################################################## 
ENUMERATION
##########################################################
]]--
local function AppendMethods(OBJECT)
    local META = getmetatable(OBJECT).__index
    if not OBJECT.Size then META.Size = Size end
    if not OBJECT.Width then META.Width = Width end
    if not OBJECT.Height then META.Height = Height end
    if not OBJECT.Point then META.Point = Point end
    if not OBJECT.WrapOuter then META.WrapOuter = WrapOuter end
    if not OBJECT.FillInner then META.FillInner = FillInner end
    if not OBJECT.MUNG then META.MUNG = MUNG end
    if not OBJECT.Formula409 then META.Formula409 = Formula409 end
    if not OBJECT.SetPanelTemplate then META.SetPanelTemplate = SetPanelTemplate end
    if not OBJECT.SetFixedPanelTemplate then META.SetFixedPanelTemplate = SetFixedPanelTemplate end
    if not OBJECT.SetPanelColor then META.SetPanelColor = SetPanelColor end
    if not OBJECT.SetButtonTemplate then META.SetButtonTemplate = SetButtonTemplate end
    if not OBJECT.SetSlotTemplate then META.SetSlotTemplate = SetSlotTemplate end
    if not OBJECT.SetCheckboxTemplate then META.SetCheckboxTemplate = SetCheckboxTemplate end
    if not OBJECT.SetEditboxTemplate then META.SetEditboxTemplate = SetEditboxTemplate end
    if not OBJECT.SetFramedButtonTemplate then META.SetFramedButtonTemplate = SetFramedButtonTemplate end
    if not OBJECT.SetFontTemplate then META.SetFontTemplate = SetFontTemplate end
end

local HANDLER, OBJECT = {["Frame"] = true}, NewFrame("Frame")
AppendMethods(OBJECT)
AppendMethods(OBJECT:CreateTexture())
AppendMethods(OBJECT:CreateFontString())

OBJECT = EnumerateFrames()
while OBJECT do
    if not HANDLER[OBJECT:GetObjectType()] then
		AppendMethods(OBJECT)
		HANDLER[OBJECT:GetObjectType()] = true
	end
	OBJECT = EnumerateFrames(OBJECT)
end
--[[ 
########################################################## 
POST CONFIG UPDATES
##########################################################
]]--
local function UpdateAPILocals()
    COLORS = SuperVillain.Colors;
    TEXTURES = SuperVillain.Textures;
    TEMPLATES = SuperVillain.Templates;
    GRADIENTS = COLORS.gradient;
    DEFAULTCOLOR = COLORS.default;
    BORDERCOLOR = COLORS.dark;
    SHADOWTEXTURE = TEXTURES.shadow;
    STANDARDFONTSIZE = SuperVillain.db.common.fontSize;
end

local function TemplateUpdates()
    UpdateAPILocals()
    for i=1, #backdropTemplates do
        local frame = backdropTemplates[i]
        if frame then
            local settings = TEMPLATES[frame.template]
            if settings.backdrop then
                frame:SetBackdrop(nil)
                frame:SetBackdrop(settings.backdrop)
            end
            if COLORS[settings.primary] then
                frame:SetBackdropColor(unpack(COLORS[settings.primary]))
            end
            if COLORS[settings.secondary] then
                frame:SetBackdropBorderColor(unpack(COLORS[settings.secondary]))
            end
        else 
            tremove(backdropTemplates,i)
        end
    end
end
TEMPLATES:Register(TemplateUpdates)

local function TextureUpdates()
    UpdateAPILocals()
    for i=1, #textureTemplates do
        local frame = textureTemplates[i]
        if frame then
            local settings = TEMPLATES[frame.template]
            if TEXTURES[settings.texture] then
                frame.SkinPanel:SetTexture(TEXTURES[settings.texture])
            end;
            if settings.gradient and GRADIENTS[settings.gradient] then 
                frame:SetPanelColor(unpack(GRADIENTS[settings.gradient]))
            elseif COLORS[settings.primary] then
                frame.SkinPanel:SetVertexColor(unpack(COLORS[settings.primary]))
            end
        else 
            tremove(textureTemplates,i) 
        end
    end
end
TEMPLATES:Register(TextureUpdates)

local function FontTemplateUpdate()
    STANDARDFONTSIZE = SuperVillain.db.common.fontSize;
    for i=1, #fontTemplates do
        local frame = fontTemplates[i] 
        if frame then 
            frame:SetFont(frame.font,frame.fontSize,frame.fontStyle)
        else 
            tremove(fontTemplates,i) 
        end 
    end 
end
TEMPLATES:Register(FontTemplateUpdate)

function SuperVillain:FontSizeUpdate()
    local smallfont = STANDARDFONTSIZE - 2;
    local largefont = STANDARDFONTSIZE + 2;
    self.db.SVAura.fontSize = STANDARDFONTSIZE;
    self.db.SVStats.fontSize = STANDARDFONTSIZE;
    self.db.SVUnit.fontSize = STANDARDFONTSIZE;
    self.db.SVUnit.auraFontSize = smallfont;

    self.db.SVBar.fontSize = smallfont;
    self.db.SVPlate.fontSize = smallfont;

    self.db.SVLaborer.fontSize = largefont;
    
    self.db.SVUnit.player.health.fontSize = largefont;
    self.db.SVUnit.player.power.fontSize = largefont;
    self.db.SVUnit.player.name.fontSize = largefont;
    self.db.SVUnit.player.aurabar.fontSize = STANDARDFONTSIZE;

    self.db.SVUnit.target.health.fontSize = largefont;
    self.db.SVUnit.target.power.fontSize = largefont;
    self.db.SVUnit.target.name.fontSize = largefont;
    self.db.SVUnit.target.aurabar.fontSize = STANDARDFONTSIZE;

    self.db.SVUnit.focus.health.fontSize = largefont;
    self.db.SVUnit.focus.power.fontSize = largefont;
    self.db.SVUnit.focus.name.fontSize = largefont;
    self.db.SVUnit.focus.aurabar.fontSize = STANDARDFONTSIZE;

    self.db.SVUnit.targettarget.health.fontSize = largefont;
    self.db.SVUnit.targettarget.power.fontSize = largefont;
    self.db.SVUnit.targettarget.name.fontSize = largefont;

    self.db.SVUnit.focustarget.health.fontSize = largefont;
    self.db.SVUnit.focustarget.power.fontSize = largefont;
    self.db.SVUnit.focustarget.name.fontSize = largefont;

    self.db.SVUnit.pet.health.fontSize = largefont;
    self.db.SVUnit.pet.power.fontSize = largefont;
    self.db.SVUnit.pet.name.fontSize = largefont;

    self.db.SVUnit.pettarget.health.fontSize = largefont;
    self.db.SVUnit.pettarget.power.fontSize = largefont;
    self.db.SVUnit.pettarget.name.fontSize = largefont;

    self.db.SVUnit.party.health.fontSize = largefont;
    self.db.SVUnit.party.power.fontSize = largefont;
    self.db.SVUnit.party.name.fontSize = largefont;

    self.db.SVUnit.boss.health.fontSize = largefont;
    self.db.SVUnit.boss.power.fontSize = largefont;
    self.db.SVUnit.boss.name.fontSize = largefont;

    self.db.SVUnit.arena.health.fontSize = largefont;
    self.db.SVUnit.arena.power.fontSize = largefont;
    self.db.SVUnit.arena.name.fontSize = largefont;

    self.db.SVUnit.raid10.health.fontSize = largefont;
    self.db.SVUnit.raid10.power.fontSize = largefont;
    self.db.SVUnit.raid10.name.fontSize = largefont;

    self.db.SVUnit.raid25.health.fontSize = largefont;
    self.db.SVUnit.raid25.power.fontSize = largefont;
    self.db.SVUnit.raid25.name.fontSize = largefont;

    self.db.SVUnit.raid40.health.fontSize = largefont;
    self.db.SVUnit.raid40.power.fontSize = largefont;
    self.db.SVUnit.raid40.name.fontSize = largefont;

    self.db.SVUnit.tank.health.fontSize = largefont;
    self.db.SVUnit.assist.health.fontSize = largefont;

    for i=1, #fontCommonUpdates do
        local frame = fontCommonUpdates[i]
        if frame then 
            frame:SetFontTemplate(frame.font, STANDARDFONTSIZE, frame.fontStyle)
        else 
            tremove(fontCommonUpdates, i) 
        end 
    end
    self:Refresh_SVUI_Media()
end;
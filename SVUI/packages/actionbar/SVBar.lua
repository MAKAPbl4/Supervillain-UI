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
local math 		= _G.math;
--[[ STRING METHODS ]]--
local find, format, split = string.find, string.format, string.split;
local gsub = string.gsub;
--[[ MATH METHODS ]]--
local ceil = math.ceil;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, G = unpack(select(2, ...));
local MOD=SuperVillain:NewModule('SVBar','AceHook-3.0', 'AceTimer-3.0');
local LibAB=LibStub("LibActionButton-1.0");
local LSM=LibStub("LibSharedMedia-3.0");
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local maxFlyoutCount=0;
local visibilityData = {
  ["Bar1"]    = "[petbattle] hide; show",
  ["Bar2"]    = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; show",
  ["Bar3"]    = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; show",
  ["Bar4"]    = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; show",
  ["Bar5"]    = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; show",
  ["Bar6"]    = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; show",
  ["Pet"]     = "[petbattle] hide; [pet,novehicleui,nooverridebar,nopossessbar] show; hide",
  ["Stance"]  = "",
};
local CLEANFONT = SuperVillain.Fonts.roboto;
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function FixKeybindText(button)
	local hotkey = _G[button:GetName()..'HotKey']
	local hotkeyText = hotkey:GetText()
	if hotkeyText then
		hotkeyText = gsub(hotkeyText, 'SHIFT%-', "S")
		hotkeyText = gsub(hotkeyText, 'ALT%-',  "A")
		hotkeyText = gsub(hotkeyText, 'CTRL%-',  "C")
		hotkeyText = gsub(hotkeyText, 'BUTTON',  "MB")
		hotkeyText = gsub(hotkeyText, 'MOUSEWHEELUP', "MU")
		hotkeyText = gsub(hotkeyText, 'MOUSEWHEELDOWN', "MD")
		hotkeyText = gsub(hotkeyText, 'NUMPAD',  "NP")
		hotkeyText = gsub(hotkeyText, 'PAGEUP', "PgU")
		hotkeyText = gsub(hotkeyText, 'PAGEDOWN', "PgD")
		hotkeyText = gsub(hotkeyText, 'SPACE', "SP")
		hotkeyText = gsub(hotkeyText, 'INSERT', "IN")
		hotkeyText = gsub(hotkeyText, 'HOME', "HM")
		hotkeyText = gsub(hotkeyText, 'DELETE', "DEL")
		hotkeyText = gsub(hotkeyText, 'NMULTIPLY', "*")
		hotkeyText = gsub(hotkeyText, 'NMINUS', "N-")
		hotkeyText = gsub(hotkeyText, 'NPLUS', "N+")
		-- hotkeyText = gsub(hotkeyText, 'SHIFT%-', L['KEY_SHIFT'])
		-- hotkeyText = gsub(hotkeyText, 'ALT%-', L['KEY_ALT'])
		-- hotkeyText = gsub(hotkeyText, 'CTRL%-', L['KEY_CTRL'])
		-- hotkeyText = gsub(hotkeyText, 'BUTTON', L['KEY_MOUSEBUTTON'])
		-- hotkeyText = gsub(hotkeyText, 'MOUSEWHEELUP', L['KEY_MOUSEWHEELUP'])
		-- hotkeyText = gsub(hotkeyText, 'MOUSEWHEELDOWN', L['KEY_MOUSEWHEELDOWN'])
		-- hotkeyText = gsub(hotkeyText, 'NUMPAD', L['KEY_NUMPAD'])
		-- hotkeyText = gsub(hotkeyText, 'PAGEUP', L['KEY_PAGEUP'])
		-- hotkeyText = gsub(hotkeyText, 'PAGEDOWN', L['KEY_PAGEDOWN'])
		-- hotkeyText = gsub(hotkeyText, 'SPACE', L['KEY_SPACE'])
		-- hotkeyText = gsub(hotkeyText, 'INSERT', L['KEY_INSERT'])
		-- hotkeyText = gsub(hotkeyText, 'HOME', L['KEY_HOME'])
		-- hotkeyText = gsub(hotkeyText, 'DELETE', L['KEY_DELETE'])
		hotkey:SetText(hotkeyText)
	end;
	hotkey:ClearAllPoints()
	hotkey:SetAllPoints()
end;

local function SetFlyoutButton(button)
	if not button or not button.FlyoutArrow or not button.FlyoutArrow:IsShown() or not button.FlyoutBorder then return end;
	local LOCKDOWN=InCombatLockdown()
	button.FlyoutBorder:SetAlpha(0)
	button.FlyoutBorderShadow:SetAlpha(0)
	SpellFlyoutHorizontalBackground:SetAlpha(0)
	SpellFlyoutVerticalBackground:SetAlpha(0)
	SpellFlyoutBackgroundEnd:SetAlpha(0)
	for i=1,GetNumFlyouts()do 
		local id=GetFlyoutID(i)
		local _,_,max,check = GetFlyoutInfo(id)
		if check then 
			maxFlyoutCount=max;
			break 
		end 
	end;
	local offset = 0;
	if SpellFlyout:IsShown() and SpellFlyout:GetParent()==button or GetMouseFocus()==button then offset=5 else offset=2 end;
	if button:GetParent() and button:GetParent():GetParent() and button:GetParent():GetParent():GetName() and button:GetParent():GetParent():GetName()=="SpellBookSpellIconsFrame" then return end;
	if button:GetParent() then 
		local point = SuperVillain:FetchScreenRegions(button:GetParent())
		if strfind(point,"RIGHT") then 
			button.FlyoutArrow:ClearAllPoints()
			button.FlyoutArrow:SetPoint("LEFT",button,"LEFT",-offset,0)
			SetClampedTextureRotation(button.FlyoutArrow,270)
			if not LOCKDOWN then 
				button:SetAttribute("flyoutDirection","LEFT")
			end 
		elseif strfind(point,"LEFT") then 
			button.FlyoutArrow:ClearAllPoints()
			button.FlyoutArrow:SetPoint("RIGHT",button,"RIGHT",offset,0)
			SetClampedTextureRotation(button.FlyoutArrow,90)
			if not LOCKDOWN then 
				button:SetAttribute("flyoutDirection","RIGHT")
			end 
		elseif strfind(point,"TOP") then 
			button.FlyoutArrow:ClearAllPoints()
			button.FlyoutArrow:SetPoint("BOTTOM",button,"BOTTOM",0,-offset)
			SetClampedTextureRotation(button.FlyoutArrow,180)
			if not LOCKDOWN then 
				button:SetAttribute("flyoutDirection","DOWN")
			end 
		elseif point=="CENTER" or strfind(point,"BOTTOM") then 
			button.FlyoutArrow:ClearAllPoints()
			button.FlyoutArrow:SetPoint("TOP",button,"TOP",0,offset)
			SetClampedTextureRotation(button.FlyoutArrow,0)
			if not LOCKDOWN then 
				button:SetAttribute("flyoutDirection","UP")
			end 
		end
	else
		print("No Parent")
	end 
end;

local function ModifyActionButton(parent)
	local button = parent:GetName()
	local icon = _G[button.."Icon"]
	local count = _G[button.."Count"]
	local flash = _G[button.."Flash"]
	local hotkey = _G[button.."HotKey"]
	local border = _G[button.."Border"]
	local normal = _G[button.."NormalTexture"]
	local cooldown = _G[button.."Cooldown"]
	local parentTex = parent:GetNormalTexture()
	local shine = _G[button.."Shine"]
	local highlight = parent:GetHighlightTexture()
	local pushed = parent:GetPushedTexture()
	local checked = parent:GetCheckedTexture()
	if cooldown then
		cooldown.SizeOverride = MOD.db.cooldownSize
	end;
	if highlight then 
		highlight:SetTexture(1,1,1,.2)
	end;
	if pushed then 
		pushed:SetTexture(0,0,0,.4)
	end;
	if checked then 
		checked:SetTexture(1,1,1,.2)
	end;
	if flash then 
		flash:SetTexture(nil)
	end;
	if normal then 
		normal:SetTexture(nil)
		normal:Hide()
		normal:SetAlpha(0)
	end;
	if parentTex then 
		parentTex:SetTexture(nil)
		parentTex:Hide()
		parentTex:SetAlpha(0)
	end;
	if border then border:MUNG()end;
	if count then 
		count:ClearAllPoints()
		count:SetPoint("BOTTOMRIGHT",1,1)
		count:SetShadowOffset(1,-1)
		count:SetFontTemplate(LSM:Fetch("font",MOD.db.font),MOD.db.fontSize,MOD.db.fontOutline)
	end;
	if icon then 
		icon:SetTexCoord(.1,.9,.1,.9)
		icon:SetGradient("VERTICAL",.5,.5,.5,1,1,1)
		icon:FillInner()
	end;
	if shine then shine:SetAllPoints()end;
	if MOD.db.hotkeytext then 
		hotkey:ClearAllPoints()
		hotkey:SetAllPoints()
		hotkey:SetFont(CLEANFONT,10,"OUTLINE")
		hotkey:SetJustifyH("RIGHT")
    	hotkey:SetJustifyV("TOP")
		hotkey:SetShadowOffset(1,-1)
	end;
	if parent.style then 
		parent.style:SetDrawLayer('BACKGROUND',-7)
	end;
	parent.FlyoutUpdateFunc = SetFlyoutButton;
	FixKeybindText(parent)
end;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:GetBarPaging(id)
	local newCondition = self.BarStates[id];
  	local newPage = newCondition .. " " .. self.BarPresets[id].page;
  	return newPage, newCondition;
end;

function MOD:Bar_OnEnter(bar)
	SuperVillain:SecureFadeIn(bar,0.2,bar:GetAlpha(),bar.db.alpha)
end;

function MOD:Bar_OnLeave(bar)
	SuperVillain:SecureFadeOut(bar,1,bar:GetAlpha(),0)
end;

function MOD:Button_OnEnter(button)
	local parent = button:GetParent()
	SuperVillain:SecureFadeIn(parent,0.2,parent:GetAlpha(),parent.db.alpha)
end;

function MOD:Button_OnLeave(button)
	local parent = button:GetParent()
	SuperVillain:SecureFadeOut(parent,0.2,parent:GetAlpha(),0)
end;

function MOD:UpdateAllBindings(event)
	if event == "UPDATE_BINDINGS" then 
		self:UpdateBarBindings(true,true)
	end;
	self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	if InCombatLockdown()then return end;
	for barID,stored in pairs(self.Storage)do
		if barID ~= "Pet" and barID ~= "Stance" then
			local bar = stored.bar;
			local buttons = stored.buttons;
			if not bar or not buttons then return end;
			ClearOverrideBindings(bar);
			local nameMod = bar:GetName().."Button";
			local thisBinding = self.BarPresets[barID].binding;
			for i=1,#buttons do 
				local binding = format(thisBinding, i);
				local btn = nameMod..i;
				for x=1,select('#',GetBindingKey(binding)) do 
					local key = select(x,GetBindingKey(binding))
					if (key and key ~= "") then 
						SetOverrideBindingClick(bar,false,key,btn)
					end;
				end 
			end 
		end
	end;
end;

function MOD:UpdateBarBindings(pet,stance)
	if stance == true then
		local preset = self.BarPresets['Stance'];
		local bindText = preset.binding;
		local max = _G[preset.max];
	  	for i=1,max do
		    if self.db.hotkeytext then
		    	local key = format(bindText, i);
		    	local binding = GetBindingKey(key)
		      	_G["SVUI_StanceBarButton"..i.."HotKey"]:Show()
		      	_G["SVUI_StanceBarButton"..i.."HotKey"]:SetText(binding)
		      	FixKeybindText(_G["SVUI_StanceBarButton"..i])
		    else 
		      	_G["SVUI_StanceBarButton"..i.."HotKey"]:Hide()
		    end 
	  	end
  	end
  	if pet==true then
  		local preset = self.BarPresets['Pet'];
		local bindText = preset.binding;
		local max = _G[preset.max];
	  	for i=1,max do 
		    if self.db.hotkeytext then 
		      	local key = format(bindText, i);
		    	local binding = GetBindingKey(key)
		      	_G["PetActionButton"..i.."HotKey"]:Show()
		      	_G["PetActionButton"..i.."HotKey"]:SetText(binding)
		      	FixKeybindText(_G["PetActionButton"..i])
		    else
	    		_G["PetActionButton"..i.."HotKey"]:Hide()
	    	end;
	  	end
	end
end;

function MOD:ResetAllBindings()
	if InCombatLockdown()then return end;
	for barID,stored in pairs(self.Storage)do
		local bar = stored.bar;
		if not bar then return end;
		ClearOverrideBindings(bar);
	end;
	self:RegisterEvent("PLAYER_REGEN_DISABLED","UpdateAllBindings")
end;

function MOD:SetBarConfigData(barID)
	local thisBinding = self.BarPresets[barID].binding;
	local buttonList = self.Storage[barID].buttons;
	self.BarConfig[barID].hideElements.macro = self.db.macrotext;
	self.BarConfig[barID].hideElements.hotkey = self.db.hotkeytext;
	self.BarConfig[barID].showGrid = self.db.showGrid;
	self.BarConfig[barID].clickOnDown = self.db.keyDown;
	self.BarConfig[barID].colors.range = SuperVillain.Colors:Extract(self.db.unc)
	self.BarConfig[barID].colors.mana = SuperVillain.Colors:Extract(self.db.unpc)
	self.BarConfig[barID].colors.hp = SuperVillain.Colors:Extract(self.db.unpc)
	SetModifiedClick("PICKUPACTION", self.db.unlock)
	for i,button in pairs(buttonList)do
		if thisBinding then
			self.BarConfig[barID].keyBoundTarget=format(thisBinding,i)
		end
		button.keyBoundTarget=self.BarConfig[barID].keyBoundTarget;
		button.postKeybind=self.FixKeybindText;
		button:SetAttribute("buttonlock",true)
		button:SetAttribute("checkselfcast",true)
		button:SetAttribute("checkfocuscast",true)
		button:UpdateConfig(self.BarConfig[barID])
	end
end;

function MOD:UpdateBarPagingDefaults()
	local parse = "[vehicleui,mod:alt,mod:ctrl] %d; [possessbar] %d; [overridebar] %d; [form,noform] 0; [shapeshift] 13; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;";
	if self.db.Bar6.enable then
		parse = "[vehicleui,mod:alt,mod:ctrl] %d; [possessbar] %d; [overridebar] %d; [form,noform] 0; [shapeshift] 13; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;";
	end;
	if self.db.Bar1.useCustomStates then
		parse = parse .. " " .. self.db.Bar1.customStates[SuperVillain.class];
	end
	self.BarStates['Bar1'] = format(parse, GetVehicleBarIndex(), GetVehicleBarIndex(), GetOverrideBarIndex());
	for i=2, 6 do
		if self.db['Bar'..i].useCustomStates then
			self.BarStates['Bar'..i] = self.db['Bar'..i].customStates[SuperVillain.class];
		end
	end;
end;

function MOD:RefreshButtons()
	if InCombatLockdown() then return end;
	self:UpdateBarPagingDefaults()
	for button,_ in pairs(self.ButtonCache)do 
		if button then 
			ModifyActionButton(button)
			self:SaveActionButton(button)
			if(button.FlyoutArrow) then
				SetFlyoutButton(button)
			end
		else 
			self.ButtonCache[button]=nil 
		end 
	end;
	for t=1,6 do 
		self:RefreshBar("Bar"..t)
	end;
	self:RefreshBar("Pet")
	self:RefreshBar("Stance")
	self:UpdateBarBindings(true,true)
	for barID,stored in pairs(self.Storage)do
		if barID ~= "Pet" and barID ~= "Stance" then
			self:SetBarConfigData(barID)
		end
	end;
end;

function MOD:QualifyFlyouts()
	if InCombatLockdown() then return end;
	for button,_ in pairs(self.ButtonCache)do 
		if(button and button.FlyoutArrow) then
			SetFlyoutButton(button)
		end 
	end;
	if self.PostConstructTimer then
		self:CancelTimer(self.PostConstructTimer)
		self.PostConstructTimer = nil
	end
end;

function MOD:Vehicle_Updater()
	local bar = self.Storage['Bar1'].bar
	local space = SuperVillain:Scale(self.db['Bar1'].buttonspacing)
	local total = self.db['Bar1'].buttons;
	local rows = self.db['Bar1'].buttonsPerRow;
	local size = SuperVillain:Scale(self.db['Bar1'].buttonsize)
	local point = self.db['Bar1'].point;
	local columns = ceil(total / rows)
	if (HasOverrideActionBar() or HasVehicleActionBar()) and total==12 then 
		bar.backdrop:ClearAllPoints()
		bar.backdrop:Point(self.db['Bar1'].point, bar, self.db['Bar1'].point)
		bar.backdrop:Width(space + ((size * rows) + (space * (rows - 1)) + space))
		bar.backdrop:Height(space + ((size * columns) + (space * (columns - 1)) + space))
		bar.backdrop:SetFrameLevel(0);
	else 
		bar.backdrop:SetAllPoints()
		bar.backdrop:SetFrameLevel(0);
	end
	self:RefreshBar("Bar1")
end;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:SaveActionButton(parent)
	local button=parent:GetName()
	local cooldown=_G[button.."Cooldown"]
	cooldown.SizeOverride = self.db.cooldownSize
	FixKeybindText(parent)
	if not self.ButtonCache[parent] then 
		SuperVillain:AddCD(cooldown)
		self.ButtonCache[parent]=true 
	end
	parent:SetSlotTemplate(true, 1, 0, 0)
end;

function MOD:RefreshBarButtons(bar,max,hideByScale,isStance)
	if InCombatLockdown() then return end;
	if not bar then return end;
	local db = bar.db;
	local barID = bar.ID;
	local space = db.buttonspacing;
	local cols = db.buttonsPerRow;
	local totalButtons = db.buttons;
	local size = SuperVillain:Scale(db.buttonsize);
	local point = db.point;
	local button,lastButton,lastRow;
	for i=1,max do 
		button=self.Storage[barID].buttons[i]
		lastButton=self.Storage[barID].buttons[i - 1]
		lastRow=self.Storage[barID].buttons[i - cols]
		button:SetParent(bar)
		button:ClearAllPoints()
		button:Size(size)
		button:SetAttribute("showgrid",1)
		if self.db.rightClickSelf then
			button:SetAttribute("unit2", "player")
		end;
		if db.mouseover==true then 
			bar:SetAlpha(0)
			if not self.hooks[bar] then 
				self:HookScript(bar,'OnEnter','Bar_OnEnter')
				self:HookScript(bar,'OnLeave','Bar_OnLeave')
			end
			if not self.hooks[button] then 
				self:HookScript(button,'OnEnter','Button_OnEnter')
				self:HookScript(button,'OnLeave','Button_OnLeave')
			end 
		else 
			bar:SetAlpha(db.alpha)
			if self.hooks[bar] then 
				self:Unhook(bar,'OnEnter')
				self:Unhook(bar,'OnLeave')
			end;
			if self.hooks[button] then 
				self:Unhook(button,'OnEnter')
				self:Unhook(button,'OnLeave')
			end 
		end;
		local anchor1,anchor2 = "TOP","BOTTOM";
	    local x,y = 0,0;
		if i==1 then
			if point=="BOTTOMRIGHT" then 
	        	x,y = -space,space
	      	elseif point=="TOPRIGHT" then 
	        	x,y = -space,-space 
	      	elseif point=="TOPLEFT" then 
	        	x,y = space,-space
	        else
	        	x,y = space,space
	      	end
			button:Point(point,bar,point,x,y)
		elseif (i - 1) % cols==0 then 
			x,y = 0,-space
	      	if point=="BOTTOMLEFT" or point=="BOTTOMRIGHT" then 
	        	y = space;
	        	anchor1 = "BOTTOM"
	        	anchor2 = "TOP"
	      	end
			button:Point(anchor1,lastRow,anchor2,x,y)
		else 
			x,y = space,0
	      	anchor1,anchor2="LEFT","RIGHT";
	      	if point=="BOTTOMRIGHT" or point=="TOPRIGHT" then 
	        	x = -space;
	        	anchor1 = "RIGHT"
	        	anchor2 = "LEFT"
	      	end
			button:Point(anchor1,lastButton,anchor2,x,y)
		end;
		if i > totalButtons then
			if hideByScale then
				button:SetScale(0.000001)
      			button:SetAlpha(0)
			else 
				button:Hide()
			end
		else 
			if hideByScale then
				button:SetScale(1)
      			button:SetAlpha(0)
			else 
				button:Show()
			end
		end;
		if (not isStance or (isStance and not button.FlyoutUpdateFunc)) then 
      		ModifyActionButton(button);
      		self:SaveActionButton(button);
    	end
	end;
end;

function MOD:RefreshBar(id)
	if InCombatLockdown() then return end;
	if not self.Storage[id].bar then return end;

	local bar = self.Storage[id].bar;
	local space = SuperVillain:Scale(self.db[id].buttonspacing);
	local cols = self.db[id].buttonsPerRow;
	local max = self.db[id].buttons;
	local size = SuperVillain:Scale(self.db[id].buttonsize);
	local point = self.db[id].point;
	local rows = ceil(max / cols);
	local presets = self.BarPresets[id];
	local barVisibility = visibilityData[id];
	local isPet = id == "Pet" and true or false;
	local isStance = id == "Stance" and true or false;
	local max = id == "Stance" and GetNumShapeshiftForms() or _G[presets.max];

	bar.db = self.db[id];

	if max < cols then cols = max end;
	if rows < 1 then rows = 1 end;
	bar:Width(space + (size * cols) + ((space * (cols - 1)) + space));
	bar:Height((space + (size * rows)) + ((space * (rows - 1)) + space));
	bar.backdrop:ClearAllPoints()
  	bar.backdrop:SetAllPoints()
	bar._fade = self.db[id].mouseover;

	if self.db[id].backdrop == true then 
		bar.backdrop:Show()
	else 
		bar.backdrop:Hide()
	end;

	self:RefreshBarButtons(bar, max, isPet, isStance);

	if not self.db[id].mouseover then 
		bar:SetAlpha(self.db[id].alpha)
	end;

	if isPet or isStance then
		if self.db[id].enable then 
			bar:SetScale(1)
			bar:SetAlpha(bar.db.alpha)
		else 
			bar:SetScale(0.000001)
			bar:SetAlpha(0)
		end;
		if isPet then
			RegisterStateDriver(bar, "show", barVisibility)
		end
	else
		local barPage,newCondition = self:GetBarPaging(id);

		if newCondition:find("[form,noform]") then
			newCondition = gsub(newCondition," %[form,noform%] 0; ","");
			bar:SetAttribute("hasTempBar", true)
			bar:SetAttribute("newCondition", newCondition)
		else
			bar:SetAttribute("hasTempBar", false)
		end

		RegisterStateDriver(bar, "page", barPage)
		if not self.BarPresets[id].ready then
			self.BarPresets[id].ready = true;
			self:RefreshBar(id) 
			return
		end
		
		if self.db[id].enable == true then
			bar:Show()
			RegisterStateDriver(bar, "visibility", barVisibility)
		else
			bar:Hide()
			UnregisterStateDriver(bar, "visibility")
		end;
		SuperVillain:SetSnapOffset("SVUI_Action"..id.."_MOVE",(space / 2))
	end
end;

function MOD:CreateExtraBars()
	local specialBar = CreateFrame('Frame','SVUI_SpecialAbility',SuperVillain.UIParent)
	specialBar:Point('BOTTOM',SuperVillain.UIParent,'BOTTOM',0,150)
	specialBar:Size(ExtraActionBarFrame:GetSize())
	ExtraActionBarFrame:SetParent(specialBar)
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame:SetPoint('CENTER',specialBar,'CENTER')
	ExtraActionBarFrame.ignoreFramePositionManager=true;
	local max=ExtraActionBarFrame:GetNumChildren()
	for i=1,max do 
		if _G["ExtraActionButton"..i] then 
			_G["ExtraActionButton"..i].noResize=true;
			_G["ExtraActionButton"..i].pushed=true;
			_G["ExtraActionButton"..i].checked=true;
			ModifyActionButton(_G["ExtraActionButton"..i])
			_G["ExtraActionButton"..i]:SetFixedPanelTemplate()
			_G["ExtraActionButton"..i..'Icon']:SetDrawLayer('ARTWORK')
			local checkedTexture=_G["ExtraActionButton"..i]:CreateTexture(nil,'OVERLAY')
			checkedTexture:SetTexture(0.9,0.8,0.1,0.3)
			checkedTexture:FillInner()
			_G["ExtraActionButton"..i]:SetCheckedTexture(checkedTexture)
		end 
	end;
	if HasExtraActionBar()then 
		ExtraActionBarFrame:Show()
	end;
	SuperVillain:SetSVMovable(specialBar,'SVUI_SpecialAbility_MOVE',L['Boss Button'],nil,nil,nil,'ALL,ACTIONBAR')

	local exitButton=CreateFrame("Button",'SVUI_BailOut',SuperVillain.UIParent,"SecureHandlerClickTemplate")
	exitButton:Size(64,64)
	exitButton:Point("TOPLEFT",SVUI_MinimapFrame,"BOTTOMLEFT",2,-2)
	exitButton:SetNormalTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\EXIT")
	exitButton:SetPushedTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\EXIT")
	exitButton:SetHighlightTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\EXIT")
	exitButton:SetFixedPanelTemplate("Transparent")
	exitButton:RegisterForClicks("AnyUp")
	exitButton:SetScript("OnClick",function()
		VehicleExit()
	end)
	RegisterStateDriver(exitButton,"visibility","[vehicleui] show;[target=vehicle,exists] show;hide")
end;
--[[ 
########################################################## 
HOOKED / REGISTERED FUNCTIONS
##########################################################
]]--
function MOD:BlizzardOptionsPanel_OnEvent()
	InterfaceOptionsActionBarsPanelBottomRight.Text:SetText(format(L['Remove Bar %d Action Page'],2))
	InterfaceOptionsActionBarsPanelBottomLeft.Text:SetText(format(L['Remove Bar %d Action Page'],3))
	InterfaceOptionsActionBarsPanelRightTwo.Text:SetText(format(L['Remove Bar %d Action Page'],4))
	InterfaceOptionsActionBarsPanelRight.Text:SetText(format(L['Remove Bar %d Action Page'],5))
	InterfaceOptionsActionBarsPanelBottomRight:SetScript('OnEnter',nil)
	InterfaceOptionsActionBarsPanelBottomLeft:SetScript('OnEnter',nil)
	InterfaceOptionsActionBarsPanelRightTwo:SetScript('OnEnter',nil)
	InterfaceOptionsActionBarsPanelRight:SetScript('OnEnter',nil)
end;

function MOD:ActionButton_ShowOverlayGlow(button)
	if not button.overlay then return end; 
	local border = button:GetWidth() / 3;
	button.overlay:WrapOuter(button,border)
end;
--[[ 
########################################################## 
BUILD FUNCTION / UPDATE
##########################################################
]]--
function MOD:UpdateThisPackage()
	self:RefreshButtons();
end;

function MOD:ConstructThisPackage()
	if not SuperVillain.protected.SVBar.enable then return end;
	self:UpdateBarPagingDefaults();
	self:RemoveDefaults();
	self:Protect("RefreshButtons")
	self:CreateExtraBars();
	self:CreateActionBars();
	self:CreatePetBar();
	self:CreateStanceBar();
	self:CreateMicroBar();
	self:CreateBindPkg();
	self:RegisterEvent("UPDATE_BINDINGS","UpdateAllBindings")
	self:RegisterEvent("PET_BATTLE_CLOSE","UpdateAllBindings")
	self:RegisterEvent('PET_BATTLE_OPENING_DONE','ResetAllBindings')
	self:RegisterEvent('UPDATE_VEHICLE_ACTIONBAR','Vehicle_Updater')
	self:RegisterEvent('UPDATE_OVERRIDE_ACTIONBAR','Vehicle_Updater')
	if C_PetBattles.IsInBattle()then 
		self:ResetAllBindings()
	else 
		self:UpdateAllBindings()
	end;
	self:SecureHook('BlizzardOptionsPanel_OnEvent')
	self:SecureHook('ActionButton_ShowOverlayGlow')
	if not GetCVarBool('lockActionBars')then SetCVar('lockActionBars',1)end;
	SpellFlyout:HookScript("OnShow",function()
		for i=1,maxFlyoutCount do
			if _G["SpellFlyoutButton"..i] then 
				ModifyActionButton(_G["SpellFlyoutButton"..i])
				MOD:SaveActionButton(_G["SpellFlyoutButton"..i])

				_G["SpellFlyoutButton"..i]:HookScript('OnEnter',function(this)
					local parent=this:GetParent()
					local anchor=select(2, parent:GetPoint())
					if not MOD.ButtonCache[anchor] then return end;
					local anchorParent=anchor:GetParent()
					if anchorParent._fade then 
						MOD:Bar_OnEnter(anchorParent)
					end
				end)
				
				_G["SpellFlyoutButton"..i]:HookScript('OnLeave',function(this)
					local parent=this:GetParent()
					local anchor=select(2, parent:GetPoint())
					if not MOD.ButtonCache[anchor] then return end;
					local anchorParent=anchor:GetParent()
					if anchorParent._fade then 
						MOD:Bar_OnLeave(anchorParent)
					end
				end)
			end 
		end;
		SpellFlyout:HookScript('OnEnter',function(this)
			local anchor=select(2,this:GetPoint())
			if not MOD.ButtonCache[anchor] then return end;
			local anchorParent=anchor:GetParent()
			if anchorParent._fade then 
				MOD:Bar_OnEnter(anchorParent)	
			end
		end)
		SpellFlyout:HookScript('OnLeave',function(this)
			local anchor=select(2,this:GetPoint())
			if not MOD.ButtonCache[anchor] then return end;
			local anchorParent=anchor:GetParent()
			if anchorParent._fade then 
				MOD:Bar_OnLeave(anchorParent)
			end 
		end)
	end);
	self.PostConstructTimer = self:ScheduleTimer("QualifyFlyouts", 5)
	MOD.IsLoaded = true
end;
SuperVillain.Registry:NewPackage(MOD:GetName())
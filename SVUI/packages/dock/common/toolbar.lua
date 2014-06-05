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
local SuperVillain, L, P, C, G = unpack(select(2, ...));
local MOD = SuperVillain:GetModule('SVDock');
MOD.BreakingShit = false;
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local tools={};
local defaultIcon="Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\ADDON";
local toolIcons={
	["Alchemy"]="Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\Alchemy",
	["Archaeology"]="Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\Survey",
	["Blacksmithing"]="Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\Blacksmithing",
	["Enchanting"]="Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\Enchanting",
	["Engineering"]="Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\Engineering",
	["Jewelcrafting"]="Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\Jewelcrafting",
	["Leatherworking"]="Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\Leatherworking",
	["Tailoring"]="Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\Tailoring",
	["Inscription"]="Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\Inscription",
	["Mining"]="Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\Mining",
	["Herbalism"]="Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\Herbalism",
	["Skinning"]="Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\Skinning",
	["First Aid"]="Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\FirstAid",
	["Fishing"]="Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\Fishing",
	["Cooking"]="Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\Cooking"
};
local ignoreList={
	["Herbalism"]=true,
	["Skinning"]=true
};
local spellRightClick={
	["Archaeology"]="Survey",
	["Cooking"]="Cooking Fire",
	["Smelting"]="Prospecting",
	["Disenchant"]="Disenchant",
	["Inscription"]="Milling"
};
--[[ 
########################################################## 
PRE VARS/FUNCTIONS
##########################################################
]]--
local button_OnEnter=function(b)
	if not b.IsOpen then
		b:SetPanelColor("class")
      	b.icon:SetGradient(unpack(SuperVillain.Colors.gradient.bizzaro))
	end
	GameTooltip:SetOwner(b,'ANCHOR_TOPLEFT',0,4)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(b.TText,1,1,1)
	GameTooltip:Show()
end;

local button_OnLeave=function(b)
	if not b.IsOpen then
		b:SetPanelColor("default")
		b.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
	end
	GameTooltip:Hide()
end;

local button_OnClick=function(b)
	if InCombatLockdown()then return end;
	if b.FrameName and _G[b.FrameName] then
		SuperDockWindowRight.FrameName=b.FrameName
		if not _G[b.FrameName]:IsShown() then
			if not SuperDockWindowRight:IsShown()then
				SuperDockWindowRight:Show()
			end
			MOD:DockletHide()
			_G[b.FrameName]:Show()
			b.IsOpen=true;
			b:SetPanelColor("green")
			b.icon:SetGradient(unpack(SuperVillain.Colors.gradient.green))
		elseif not SuperDockWindowRight:IsShown()then
			SuperDockWindowRight:Show()
			_G[b.FrameName]:Show()
			b.IsOpen=true;
			b:SetPanelColor("green")
			b.icon:SetGradient(unpack(SuperVillain.Colors.gradient.green))
		end 
	else
		if SuperDockWindowRight:IsShown()then 
			SuperDockWindowRight:Hide()
		else 
			SuperDockWindowRight:Show()
		end
		b.IsOpen=false;
		b:SetPanelColor("default")
		b.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
		if MOD.DefaultWindow and _G[MOD.DefaultWindow] and not _G[MOD.DefaultWindow]:IsShown() then
			SuperDockWindowRight.FrameName = MOD.DefaultWindow
			SuperDockWindowRight:Show()
		end
	end;
end;

local macro_OnEnter = function(b)
	b:SetPanelColor("class")
    b.icon:SetGradient(unpack(SuperVillain.Colors.gradient.bizzaro))
	GameTooltip:SetOwner(b, "ANCHOR_TOPLEFT", 2, 4)
	GameTooltip:ClearLines()
	if not b.TText2 then 
		GameTooltip:AddLine(b.TText, 1, 1, 1)
	else 
		GameTooltip:AddDoubleLine(b.TText, b.TText2, 1, 1, 1)
	end;
	GameTooltip:Show()
end;

local macro_OnLeave=function(b)
	b:SetPanelColor("default")
	b.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
	GameTooltip:Hide()
end;

MOD.ToolsList = {};
MOD.ToolsSafty = {};
MOD.MacroCount = 0;
MOD.LastAddedTool = false;
MOD.LastAddedMacro = false;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
MOD.DefaultWindow = false;
function MOD:RemoveTool(frame)
	if not frame or not frame.listIndex then return end;
	local name = frame:GetName();
	if not MOD.ToolsSafty[name] then return end;
	MOD.ToolsSafty[name] = false;
	local i = frame.listIndex;
	tremove(MOD.ToolsList,i)
	local width;
	local height = SuperDockToolBarRight.currentSize;
	MOD.LastAddedTool = MOD.ToolsList[#MOD.ToolsList];
	width = #MOD.ToolsList * (height + 6)
	SuperDockToolBarRight:ClearAllPoints()
	SuperDockToolBarRight:Point('RIGHT',RightSuperDockToggleButton,'LEFT',-6,0)
	SuperDockToolBarRight:Size(width,height)
	SuperDockMacroBar:ClearAllPoints()
	SuperDockMacroBar:Point('RIGHT',SuperDockToolBarRight,'LEFT',-6,0)
end;

function MOD:AddTool(frame)
	local name = frame:GetName();
	if MOD.ToolsSafty[name] then return end;
	MOD.ToolsSafty[name] = true;
	local width;
	local height = SuperDockToolBarRight.currentSize;
	if not MOD.LastAddedTool or MOD.LastAddedTool == frame then
		frame:Point("RIGHT",SuperDockToolBarRight,"RIGHT",-6,0);
	else
		frame:Point("RIGHT",MOD.LastAddedTool,"LEFT",-6,0);
	end
	tinsert(MOD.ToolsList,frame);
    frame.listIndex = #MOD.ToolsList;
	MOD.LastAddedTool = frame;
	width = #MOD.ToolsList * (height + 6)
	SuperDockToolBarRight:ClearAllPoints()
	SuperDockToolBarRight:Point('RIGHT',RightSuperDockToggleButton,'LEFT',-6,0)
	SuperDockToolBarRight:Size(width,height)
	SuperDockMacroBar:ClearAllPoints()
	SuperDockMacroBar:Point('RIGHT',SuperDockToolBarRight,'LEFT',-6,0)
end;

function MOD:AddMacroTool(frame)
	local width;
	local height = SuperDockToolBarRight.currentSize;
	if not MOD.LastAddedMacro then
		frame:Point("RIGHT",SuperDockMacroBar,"RIGHT",-6,0);
	else
		frame:Point("RIGHT",MOD.LastAddedMacro,"LEFT",-6,0);
	end
	MOD.LastAddedMacro=frame;
	MOD.MacroCount=MOD.MacroCount+1;
	width=MOD.MacroCount*(height+6)
	SuperDockMacroBar:ClearAllPoints()
	SuperDockMacroBar:Size(width,height)
	SuperDockMacroBar:Point('RIGHT',SuperDockToolBarRight,'LEFT',-6,0)
end;

function MOD:CreateBasicToolButton(name,texture,onclick,frameName,isdefault)
	local fName = frameName or name;
	local iconTexture = not texture and defaultIcon or texture;
	local clickFunction = (type(onclick)=="function") and onclick or button_OnClick;
	local color=isdefault and "green" or "light";
	local size=SuperDockToolBarRight.currentSize;
	local i=_G[fName .. "_ToolBarButton"] or CreateFrame("Button",("%s_ToolBarButton"):format(fName),SuperDockToolBarRight)
	MOD:AddTool(i)
	i:Size(size,size)
	i:SetFramedButtonTemplate()
	if(isdefault) then
		i:SetPanelColor(color)
	end
	i.icon=i:CreateTexture(nil,"OVERLAY")
	i.icon:FillInner(i,2,2)
	i.icon:SetTexture(iconTexture)
	i.icon:SetGradient(unpack(SuperVillain.Colors.gradient[color]))
	i.TText="Open "..name;
	i.FrameName=fName;
	if isdefault == true then
		MOD.DefaultWindow = fName;
	end;
	i.IsOpen=isdefault or false;
	i:SetScript("OnEnter",button_OnEnter)
	i:SetScript("OnLeave",button_OnLeave)
	i:SetScript("OnClick",clickFunction)
	_G[fName].ToggleName = fName.."_ToolBarButton";
end;

function MOD:CreateMacroToolButton(name,texture,itemID)
	if name=="Mining" then name="Smelting" end;
	local iconTexture = texture or defaultIcon;
	local size=SuperDockMacroBar.currentSize;
	local i=CreateFrame("Button",("%s_MacroBarButton"):format(itemID),SuperDockMacroBar,"SecureActionButtonTemplate")
	i:Size(size,size)
	MOD:AddMacroTool(i)
	i:SetFramedButtonTemplate()
	i.icon=i:CreateTexture(nil,"OVERLAY")
	i.icon:FillInner(i,2,2)
	i.icon:SetTexture(iconTexture)
	i.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
	i.skillName=name;
	i.itemId=itemID;
	i.TText="Open "..name;
	i:SetAttribute("type","macro")
	if spellRightClick[name] then
		local h=spellRightClick[name]
		i:SetAttribute("macrotext","/cast [mod:shift]"..h.."; "..name)
		i.TText2="Shift-Click to use "..h 
	else 
		i:SetAttribute("macrotext","/cast "..name)
	end;
	i:SetScript("OnEnter",macro_OnEnter)
	i:SetScript("OnLeave",macro_OnLeave)
end;

function MOD:LoadToolBarProfessions()
	local j,k,l,m,n,o=GetProfessions();
	if o~=nil then 
		local t,u,v,w,x,y,z,A,B,C=GetProfessionInfo(o)
		local e=toolIcons[t]or u;
		if not ignoreList[t] then
			MOD:CreateMacroToolButton(t,e,o)
		end
	end;
	if l~=nil then 
		local t,u,v,w,x,y,z,A,B,C=GetProfessionInfo(l)
		local e=toolIcons[t]or u;
		if not ignoreList[t] then
			MOD:CreateMacroToolButton(t,e,l)
		end
	end;
	if n~=nil then 
		local t,u,v,w,x,y,z,A,B,C=GetProfessionInfo(n)
		local e=toolIcons[t]or u;
		if not ignoreList[t] then
			MOD:CreateMacroToolButton(t,e,n)
		end
	end;
	if k~=nil then 
		local t,u,v,w,x,y,z,A,B,C=GetProfessionInfo(k)
		local e=toolIcons[t]or u;
		if not ignoreList[t] then
			MOD:CreateMacroToolButton(t,e,k)
		end
	end;
	if j~=nil then 
		local t,u,v,w,x,y,z,A,B,C=GetProfessionInfo(j)
		local e=toolIcons[t]or u;
		if not ignoreList[t] then
			MOD:CreateMacroToolButton(t,e,j)
		end
	end;
	if MOD.PostConstructTimer then
		MOD:CancelTimer(MOD.PostConstructTimer)
		MOD.PostConstructTimer = nil
	end
end
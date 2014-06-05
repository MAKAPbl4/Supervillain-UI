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
local type 		= _G.type;
local string 	= _G.string;
local math 		= _G.math;
--[[ STRING METHODS ]]--
local format, split = string.format, string.split;
--[[ MATH METHODS ]]--
local min, floor = math.min, math.floor;
local parsefloat = math.parsefloat;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, G = unpack(select(2, ...));
local Sticky = LibStub("LibSimpleSticky-1.0");
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local CurrentFrameTarget = false;
local UpdateFrameTarget = false;
local userHolding = false;
SVUI_MOVED_FRAMES={};
SuperVillain.Movables = {};
local HandledFrames = {};
local DraggableFrames = {
	"AchievementFrame",
	"AuctionFrame",
	"ArchaeologyFrame",
	"BattlefieldMinimap",
	"BarberShopFrame",
	"BlackMarketFrame",
	"CalendarFrame",
	"CharacterFrame",
	"ClassTrainerFrame",
	"DressUpFrame",
	"EncounterJournal",
	"FriendsFrame",
	"GameMenuFrame",
	"GMSurveyFrame",
	"GossipFrame",
	"GuildFrame",
	"GuildBankFrame",
	"GuildRegistrarFrame",
	"HelpFrame",
	"InterfaceOptionsFrame",
	"ItemUpgradeFrame",
	"KeyBindingFrame",
	"LFGDungeonReadyPopup",
	"LossOfControlFrame",
	"MacOptionsFrame",
	"MacroFrame",
	"MailFrame",
	"MerchantFrame",
	"PlayerTalentFrame",
	"PetJournalParent",
	"PVEFrame",
	"PVPFrame",
	"QuestFrame",
	"QuestLogFrame",
	"RaidBrowserFrame",
	"ReadyCheckFrame",
	"ReforgingFrame",
	"ReportCheatingDialog",
	"ReportPlayerNameDialog",
	"RolePollPopup",
	"ScrollOfResurrectionSelectionFrame",
	"SpellBookFrame",
	"TabardFrame",
	"TaxiFrame",
	"TimeManagerFrame",
	"TradeSkillFrame",
	"TradeFrame",
	"TransmorgifyFrame",
	"TutorialFrame",
	"VideoOptionsFrame",
	"VoidStorageFrame",
	--"WorldStateAlwaysUpFrame"
};

local theHand = CreateFrame("Frame", "SVUI_HandOfMentalo", SuperVillain.UIParent)
theHand:SetFrameStrata("DIALOG")
theHand:SetFrameLevel(99)
theHand:SetClampedToScreen(true)
theHand:SetSize(128,128)
theHand:SetPoint("CENTER")
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function TheHand_SetPos(frame)
	theHand:SetPoint("CENTER",frame,"TOP",0,0) 
end

local TheHand_OnUpdate = function(self,elapsed)
	self.elapsedTime = self.elapsedTime + elapsed
	if self.elapsedTime > 0.1 then
		self.elapsedTime = 0
		local x,y = GetCursorPosition()
		local scale = SuperVillain.UIParent:GetEffectiveScale()
		self:SetPoint("CENTER",SuperVillain.UIParent,"BOTTOMLEFT", (x / scale), (y / scale))
	end 
end

local function EnableTheHand()
	theHand:Show()
	theHand.flash:Play()
	theHand:SetScript("OnUpdate",TheHand_OnUpdate) 
end

local function DisableTheHand()
	theHand.flash:Stop()
	theHand:SetScript("OnUpdate",nil)
	theHand.elapsedTime = 0
	theHand:Hide()
end

local function Mentalo_OnSizeChanged(frame)
	if InCombatLockdown()then return end;
	if frame.dirtyWidth and frame.dirtyHeight then 
		frame.Avatar:Size(frame.dirtyWidth,frame.dirtyHeight)
	else 
		frame.Avatar:Size(frame:GetSize())
	end 
end

local function MakeMovable(frame)
	if HandledFrames then 
		for _,f in pairs(HandledFrames)do 
			if frame:GetName()==f then return end 
		end 
	end;
	if SVUI and frame:GetName()=="LossOfControlFrame" then return end;
	frame:EnableMouse(true)
	if frame:GetName()=="LFGDungeonReadyPopup" then 
		LFGDungeonReadyDialog:EnableMouse(false)
	end;
	frame:SetMovable(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetClampedToScreen(true)
	frame:HookScript("OnUpdate",function(this)
		if InCombatLockdown() or this:GetName()=="GameMenuFrame" then return end;
		if this.IsMoving then return end;
		this:ClearAllPoints()
		if this:GetName()=="QuestFrame" then 
			if SVUI_MOVED_FRAMES["GossipFrame"].Points~=nil then 
				this:SetPoint(unpack(SVUI_MOVED_FRAMES["GossipFrame"].Points))
			end 
		elseif SVUI_MOVED_FRAMES[this:GetName()].Points~=nil then 
			this:SetPoint(unpack(SVUI_MOVED_FRAMES[this:GetName()].Points))
		end 
	end)
	frame:SetScript("OnDragStart",function(this)
		if not this:IsMovable() then return end;
		this:StartMoving()
		this.IsMoving=true 
	end)
	frame:SetScript("OnDragStop",function(this)
		if not this:IsMovable() then return end;
		this.IsMoving=false;
		this:StopMovingOrSizing()
		if this:GetName()=="GameMenuFrame"then return end;
		local anchor1,parent,anchor2,x,y=this:GetPoint()
		parent=this:GetParent():GetName()
		this:ClearAllPoints()
		this:SetPoint(anchor1,parent,anchor2,x,y)
		if this:GetName()=="QuestFrame" then 
			SVUI_MOVED_FRAMES["GossipFrame"].Points={anchor1,parent,anchor2,x,y}
		else 
			SVUI_MOVED_FRAMES[this:GetName()].Points={anchor1,parent,anchor2,x,y}
		end 
	end)
	tinsert(HandledFrames,frame:GetName())
end;

local function GrabUsableRegions(frame)
	local parent = frame or SuperVillain.UIParent
	local right = parent:GetRight()
	local top = parent:GetTop()
	local center = parent:GetCenter()
	return right,top,center
end;

local function FindLoc(frame)
	if not frame then return end;
	local anchor1,parent,anchor2,x,y = frame:GetPoint()
	if not parent then 
		parent=SVUIParent 
	end;
	return format('%s\031%s\031%s\031%d\031%d', anchor1, parent:GetName(), anchor2, parsefloat(x), parsefloat(y))
end

local function ghost(list,alpha)
	local frame;
	for f,_ in pairs(list)do 
		frame = _G[f]
		if frame then 
			frame:SetAlpha(alpha)
		end 
	end 
end;

local function SetSVMovable(frame,moveName,title,raised,snap,dragStopFunc)
	if not frame then return end;
	if SuperVillain.Movables[moveName].Created then return end;
	if raised == nil then raised = true end;
	local movable = CreateFrame("Button", moveName, SuperVillain.UIParent)
	movable:SetFrameLevel(frame:GetFrameLevel()  +  1)
	movable:SetClampedToScreen(true)
	movable:SetWidth(frame:GetWidth())
	movable:SetHeight(frame:GetHeight())
	movable.parent = frame;
	movable.name = moveName;
	movable.textString = title;
	movable.postdrag = dragStopFunc;
	movable.overlay = raised;
	movable.snapOffset = snap or -2;
	SuperVillain.Movables[moveName].Avatar = movable;
	SuperVillain["snaps"][#SuperVillain["snaps"]  +  1] = movable;
	if raised == true then 
		movable:SetFrameStrata("DIALOG")
	else 
		movable:SetFrameStrata("BACKGROUND")
	end;
	local anchor1, anchorParent, anchor2, xPos, yPos = split("\031", FindLoc(frame))
	if SuperVillain.db["moveables"]and SuperVillain.db["moveables"][moveName]then 
		if type(SuperVillain.db["moveables"][moveName]) == "table"then 
			movable:SetPoint(SuperVillain.db["moveables"][moveName]["p"], SuperVillain.UIParent, SuperVillain.db["moveables"][moveName]["p2"], SuperVillain.db["moveables"][moveName]["p3"], SuperVillain.db["moveables"][moveName]["p4"])
			SuperVillain.db["moveables"][moveName] = FindLoc(movable)
			movable:ClearAllPoints()
		end;
		anchor1, anchorParent, anchor2, xPos, yPos = split("\031", SuperVillain.db["moveables"][moveName])
		movable:SetPoint(anchor1, anchorParent, anchor2, xPos, yPos)
	else 
		movable:SetPoint(anchor1, anchorParent, anchor2, xPos, yPos)
	end;
	movable:SetFixedPanelTemplate("Transparent")
	movable:SetAlpha(0.4)
	movable:RegisterForDrag("LeftButton", "RightButton")
	movable:SetScript("OnDragStart", function(this)
		if InCombatLockdown()then SuperVillain:AddonMessage(ERR_NOT_IN_COMBAT)return end;
		if SuperVillain.db["common"].stickyFrames then 
			Sticky:StartMoving(this, SuperVillain["snaps"], movable.snapOffset, movable.snapOffset, movable.snapOffset, movable.snapOffset)
		else 
			this:StartMoving()
		end;
		UpdateFrameTarget = this;
		_G["SVUI_MentaloEventHandler"]:Show()
		EnableTheHand()
		userHolding = true 
	end)
	movable:SetScript("OnMouseUp", SuperVillain.MovableFocused)
	movable:SetScript("OnDragStop", function(this)
		if InCombatLockdown()then SuperVillain:AddonMessage(ERR_NOT_IN_COMBAT)return end;
		userHolding = false;
		if SuperVillain.db["common"].stickyFrames then 
			Sticky:StopMoving(this)
		else 
			this:StopMovingOrSizing()
		end;
		local pR, pT, pC = GrabUsableRegions()
		local cX, cY = this:GetCenter()
		local newAnchor;
		if cY  >= (pT  /  2) then 
			newAnchor = "TOP"; 
			cY = (-(pT - this:GetTop()))
		else 
			newAnchor = "BOTTOM"
			cY = this:GetBottom()
		end;
		if cX  >= ((pR  *  2)  /  3) then 
			newAnchor = newAnchor.."RIGHT"
			cX = this:GetRight() - pR 
		elseif cX  <= (pR  /  3) then 
			newAnchor = newAnchor.."LEFT"
			cX = this:GetLeft()
		else 
			cX = cX - pC 
		end;
		if this.positionOverride then 
			this.parent:ClearAllPoints()
			this.parent:Point(this.positionOverride, this, this.positionOverride)
		end;
		this:ClearAllPoints()
		this:Point(newAnchor, SuperVillain.UIParent, newAnchor, cX, cY)
		SuperVillain:SaveMovableLoc(moveName)
		if SVUI_MentaloPrecision then 
			SuperVillain:MentaloFocusUpdate(this)
		end;
		UpdateFrameTarget = nil;
		_G["SVUI_MentaloEventHandler"]:Hide()
		if dragStopFunc ~= nil and type(dragStopFunc) == "function" then 
			dragStopFunc(this, SuperVillain:FetchScreenRegions(this))
		end;
		this:SetUserPlaced(false)
		DisableTheHand()
	end)

	frame:SetScript("OnSizeChanged", Mentalo_OnSizeChanged)
	frame.Avatar = movable;
	frame:ClearAllPoints()
	frame:SetPoint(anchor1, movable, 0, 0)

	local u = movable:CreateFontString(nil, "OVERLAY")
	u:SetFontTemplate()
	u:SetJustifyH("CENTER")
	u:SetPoint("CENTER")
	u:SetText(title or moveName)
	u:SetTextColor(unpack(SuperVillain.Colors.highlight))

	movable:SetFontString(u)
	movable.text = u;
	movable:SetScript("OnEnter", function(this)
		if userHolding then return end;
		this:SetAlpha(1)
		this.text:SetTextColor(1, 1, 1)
		UpdateFrameTarget = this;
		_G["SVUI_MentaloEventHandler"]:GetScript("OnUpdate")(_G["SVUI_MentaloEventHandler"])
		SVUI_Mentalo.Avatar:SetTexture([[Interface\AddOns\SVUI\assets\artwork\MENTALO\MENTALO-ON]])
		TheHand_SetPos(this)
		theHand:Show()
		if CurrentFrameTarget ~= this then 
			SVUI_MentaloPrecision:Hide()
			SuperVillain.MovableFocused(this)
		end 
	end)
	movable:SetScript("OnMouseDown", function(this, arg)
		if arg == "RightButton"then 
			userHolding = false;
			SVUI_MentaloPrecision:Show()
			if SuperVillain.db["common"].stickyFrames then 
				Sticky:StopMoving(this)
			else 
				this:StopMovingOrSizing()
			end 
		end 
	end)
	movable:SetScript("OnLeave", function(this)
		if userHolding then return end;
		this:SetAlpha(0.4)
		this.text:SetTextColor(unpack(SuperVillain.Colors.highlight))
		SVUI_Mentalo.Avatar:SetTexture([[Interface\AddOns\SVUI\assets\artwork\MENTALO\MENTALO-OFF]])
		theHand:Hide()
	end)
	movable:SetScript("OnShow", function(this)this:SetBackdropBorderColor(unpack(SuperVillain.Colors.highlight))end)
	movable:SetMovable(true)
	movable:Hide()
	if dragStopFunc ~= nil and type(dragStopFunc) == "function"then 
		movable:RegisterEvent("PLAYER_ENTERING_WORLD")
		movable:SetScript("OnEvent", function(this, event)
			dragStopFunc(movable, SuperVillain:FetchScreenRegions(movable))
			this:UnregisterAllEvents()
		end)
	end;
	SuperVillain.Movables[moveName].Created = true 
end;
--[[ 
########################################################## 
GLOBAL/MODULE FUNCTIONS
##########################################################
]]--
function SuperVillain:MentaloForced(frame)
	if _G[frame] and _G[frame]:GetScript("OnDragStop") then 
		_G[frame]:GetScript("OnDragStop")(_G[frame])
	end 
end;

function SuperVillain:TestMovableMoved(frame)
	if SuperVillain.db["moveables"] and SuperVillain.db["moveables"][frame] then 
		return true 
	else 
		return false 
	end 
end;

function SuperVillain:SaveMovableLoc(frame)
	if not _G[frame] then return end;
	if not SuperVillain.db.moveables then 
		SuperVillain.db.moveables={}
	end;
	SuperVillain.db.moveables[frame]=FindLoc(_G[frame])
end;

function SuperVillain:SetSnapOffset(frame,snapOffset)
	if not _G[frame] or not SuperVillain.Movables[frame] then return end;
	SuperVillain.Movables[frame].Avatar.snapOffset=snapOffset or -2;
	SuperVillain.Movables[frame]["snapoffset"]=snapOffset or -2 
end;

function SuperVillain:SaveMovableOrigin(frame)
	if not _G[frame] then return end;
	SuperVillain.Movables[frame]["point"]=FindLoc(_G[frame])
	SuperVillain.Movables[frame]["postdrag"](_G[frame],SuperVillain:FetchScreenRegions(_G[frame]))
end;

function SuperVillain:SetSVMovable(frame,moveName,title,raised,snapOffset,dragStopFunc,movableGroup)
	if not movableGroup then movableGroup='ALL,GENERAL' end;
	if SuperVillain.Movables[moveName]==nil then 
		SuperVillain.Movables[moveName]={}
		SuperVillain.Movables[moveName]["parent"]=frame;
		SuperVillain.Movables[moveName]["text"]=title;
		SuperVillain.Movables[moveName]["overlay"]=raised;
		SuperVillain.Movables[moveName]["postdrag"]=dragStopFunc;
		SuperVillain.Movables[moveName]["snapoffset"]=snapOffset;
		SuperVillain.Movables[moveName]["point"]=FindLoc(frame)
		SuperVillain.Movables[moveName]["type"]={}
		local group={split(',',movableGroup)}
		for i=1,#group do 
			local this=group[i]
			SuperVillain.Movables[moveName]["type"][this]=true 
		end 
	end;
	SetSVMovable(frame,moveName,title,raised,snapOffset,dragStopFunc)
end;

function SuperVillain:ToggleMovables(enabled, configType)
	for frameName,_ in pairs(SuperVillain.Movables)do 
		if(_G[frameName]) then 
			local movable = _G[frameName] 
			if(not enabled) then 
				movable:Hide() 
			else 
				if SuperVillain.Movables[frameName]['type'][configType]then 
					movable:Show() 
				else 
					movable:Hide() 
				end 
			end 
		end 
	end 
end;

function SuperVillain:ResetMovables(request)
	if request=="" or request==nil then 
		for name,_ in pairs(SuperVillain.Movables)do 
			local frame=_G[name];
			if SuperVillain.Movables[name]['point'] then
				local u,v,w,x,y=split('\031',SuperVillain.Movables[name]['point'])
				frame:ClearAllPoints()
				frame:SetPoint(u,v,w,x,y)
				for arg,func in pairs(SuperVillain.Movables[name])do 
					if arg=="postdrag" and type(func)=='function' then 
						func(frame,SuperVillain:FetchScreenRegions(frame))
					end 
				end
			end 
		end;
		self.db.moveables=nil 
	else 
		for name,_ in pairs(SuperVillain.Movables)do
			if SuperVillain.Movables[name]['point'] then
				for arg1,arg2 in pairs(SuperVillain.Movables[name])do 
					local mover;
					if arg1=="text" then 
						if request==arg2 then 
							local frame=_G[name]
							local u,v,w,x,y=split('\031',SuperVillain.Movables[name]['point'])
							frame:ClearAllPoints()
							frame:SetPoint(u,v,w,x,y)
							if self.db.moveables then 
								self.db.moveables[name]=nil 
							end;
							if (SuperVillain.Movables[name]["postdrag"]~=nil and type(SuperVillain.Movables[name]["postdrag"])=='function')then 
								SuperVillain.Movables[name]["postdrag"](frame,SuperVillain:FetchScreenRegions(frame))
							end 
						end 
					end 
				end
			end
		end 
	end 
end;

function SuperVillain:SetSVMovablesPositions()
	for name,_ in pairs(SuperVillain.Movables)do 
		local frame=_G[name];
		local anchor1,parent,anchor2,x,y;
		if frame then
			if (SuperVillain.db["moveables"] and SuperVillain.db["moveables"][name] and type(SuperVillain.db["moveables"][name]) =='string') then 
				anchor1,parent,anchor2,x,y = split('\031',SuperVillain.db["moveables"][name])
				frame:ClearAllPoints()
				frame:SetPoint(anchor1,parent,anchor2,x,y)
			elseif SuperVillain.Movables[name]['point'] then 
				anchor1,parent,anchor2,x,y = split('\031',SuperVillain.Movables[name]['point'])
				frame:ClearAllPoints()
				frame:SetPoint(anchor1,parent,anchor2,x,y)
			end
		end
	end 
end;

function SuperVillain:LoadMovables()
	local img = theHand:CreateTexture(nil,"OVERLAY")
	img:SetAllPoints(theHand)
	img:SetTexture([[Interface\AddOns\SVUI\assets\artwork\MENTALO\MENTALO-HAND]])
	SuperVillain.Animate:Flash(img,0.1,true)
	theHand.flash = img.anim;
	theHand.elapsedTime = 0;
	theHand.flash:Stop()
	theHand:Hide()

	for name,_ in pairs(SuperVillain.Movables)do 
		local parent,text,overlay,snapoffset,postdrag;
		for key,value in pairs(SuperVillain.Movables[name])do 
			if key=="parent"then 
				parent=value 
			elseif key=="text"then 
				text=value 
			elseif key=="overlay"then 
				overlay=value 
			elseif key=="snapoffset"then 
				snapoffset=value 
			elseif key=="postdrag"then 
				postdrag=value 
			end 
		end;
		SuperVillain:SetMentaloAlphas()
		SetSVMovable(parent,name,text,overlay,snapoffset,postdrag)
	end 
end;

function SuperVillain:UseMentalo(isConfigMode, configType)
	if(InCombatLockdown()) then return end;
	local enabled = false;
	if(isConfigMode ~= nil and isConfigMode ~= '') then 
		self.ConfigurationMode = isConfigMode 
	end;

	if(not self.ConfigurationMode) then
		if IsAddOnLoaded("SVUI_ConfigOMatic")then 
			LibStub("AceConfigDialog-3.0"):Close("SVUI")
			GameTooltip:Hide()
			self.ConfigurationMode = true 
		else 
			self.ConfigurationMode = false 
		end;
	else
		self.ConfigurationMode = false
	end

	if(SVUI_Mentalo:IsShown()) then
		SVUI_Mentalo:Hide()
	else
		SVUI_Mentalo:Show()
		enabled = true
	end

	if(not configType or (configType and type(configType) ~= 'string')) then 
		configType = 'ALL' 
	end;

	self:ToggleMovables(enabled, configType)
end;

function SuperVillain:MentaloFocus()
	local frame=CurrentFrameTarget;
	local s,t,u=GrabUsableRegions()
	local v,w=frame:GetCenter()
	local x;
	local y=s/3;
	local z=s*2/3;
	local A=t/2;
	if w>=A then x="TOP"else x="BOTTOM"end;
	if v>=z then x=x..'RIGHT'elseif v<=y then x=x..'LEFT'end;
	v=tonumber(SVUI_MentaloPrecisionSetX.CurrentValue)
	w=tonumber(SVUI_MentaloPrecisionSetY.CurrentValue)
	frame:ClearAllPoints()
	frame:Point(x,SuperVillain.UIParent,x,v,w)
	SuperVillain:SaveMovableLoc(frame.name)
end;

function SuperVillain:MentaloFocusUpdate(frame)
	local s,t,u=GrabUsableRegions()
	local v,w=frame:GetCenter()
	local y=(s/3);
	local z=((s*2)/3);
	local A=(t/2);
	if w >= A then w=-(t - frame:GetTop())else w=frame:GetBottom()end;
	if v>=z then v=(frame:GetRight() - s) elseif v <= y then v=frame:GetLeft()else v=(v - u) end;
	v=parsefloat(v,0)
	w=parsefloat(w,0)
	SVUI_MentaloPrecisionSetX:SetText(v)
	SVUI_MentaloPrecisionSetY:SetText(w)
	SVUI_MentaloPrecisionSetX.CurrentValue=v;
	SVUI_MentaloPrecisionSetY.CurrentValue=w;
	SVUI_MentaloPrecision.Title:SetText(frame.textSting)
end;

function SuperVillain:MovableFocused()
	CurrentFrameTarget=self;
	SuperVillain:MentaloFocusUpdate(self)
end;

function SuperVillain:SetMentaloAlphas()
	hooksecurefunc(SuperVillain,'SetSVMovable',function(_,frame)
		frame.Avatar:SetAlpha(SuperVillain.db.common.MoverAlpha)
	end)
	ghost(SuperVillain.Movables,SuperVillain.db.common.MoverAlpha)
end;
--[[ 
########################################################## 
XML FRAME SCRIPT HANDLERS
##########################################################
]]--
function SVUI_MoveEventHandler_OnEvent()
	for _,frame in pairs(DraggableFrames)do 
		if _G[frame] then
			if SVUI_MOVED_FRAMES[frame]==nil then 
				SVUI_MOVED_FRAMES[frame]={}
			end;
			SVUI_MOVED_FRAMES["GameMenuFrame"]={}
			MakeMovable(_G[frame])
		end 
	end
end;

function SVUI_MentaloEventHandler_Update(self)
	_G["SVUI_MentaloEventHandler"] = self;
	local frame = UpdateFrameTarget;
	local rightPos,topPos,centerPos=GrabUsableRegions()
	local centerX,centerY=frame:GetCenter()
	local calc1 = rightPos / 3;
	local calc2 = ((rightPos * 2) / 3);
	local calc3 = topPos / 2;
	local anchor1,anchor2;
	if centerY >= calc3 then 
		anchor1 = "TOP"
		anchor2 = "BOTTOM"
		centerY = -(topPos - frame:GetTop())
	else 
		anchor1 = "BOTTOM"
		anchor2 = "TOP"
		centerY = frame:GetBottom()
	end;
	if centerX >= calc2 then 
		anchor1 = "RIGHT"
		anchor2 = "LEFT"
		centerX = (frame:GetRight() - rightPos) 
	elseif centerX <= calc1 then 
		anchor1 = "LEFT"
		anchor2 = "RIGHT"
		centerX = frame:GetLeft()
	else 
		centerX = (centerX - centerPos) 
	end;
	SVUI_MentaloPrecision:ClearAllPoints()
	SVUI_MentaloPrecision:SetPoint(anchor1,frame,anchor2,0,0)
	SuperVillain:MentaloFocusUpdate(frame)
end;

function SVUI_Mentalo_OnLoad()
	_G["SVUI_Mentalo"]:RegisterEvent('PLAYER_REGEN_DISABLED')
	_G["SVUI_Mentalo"]:RegisterForDrag("LeftButton");
end;

function SVUI_Mentalo_OnEvent()
	if _G["SVUI_Mentalo"]:IsShown() then 
		_G["SVUI_Mentalo"]:Hide()
		SuperVillain:UseMentalo(true)
	end
end;

function SVUI_MentaloLockButton_OnClick()
	SuperVillain:UseMentalo(true)
	if IsAddOnLoaded("SVUI_ConfigOMatic")then 
		LibStub("AceConfigDialog-3.0"):Open('SVUI')
	end;
end;

function SVUI_MentaloPrecisionResetButton_OnClick()
	local name = CurrentFrameTarget.name
	SuperVillain:ResetMovables(name)
end;

function SVUI_MentaloPrecisionInput_EscapePressed(self)
	self:SetText(parsefloat(self.CurrentValue))
	EditBox_ClearFocus(self)
end;

function SVUI_MentaloPrecisionInput_EnterPressed(self)
	local txt = tonumber(self:GetText())
	if(txt) then 
		self.CurrentValue = txt;
		SuperVillain:MentaloFocus()
	end;
	self:SetText(parsefloat(self.CurrentValue))
	EditBox_ClearFocus(self)
end;

function SVUI_MentaloPrecisionInput_FocusLost(self)
	self:SetText(parsefloat(self.CurrentValue))
end;

function SVUI_MentaloPrecisionInput_OnShow(self)
	EditBox_ClearFocus(self)
	self:SetText(parsefloat(self.CurrentValue or 0))
end;

function SVUI_MentaloPrecision_OnLoad()
	_G["SVUI_MentaloPrecisionSetX"].CurrentValue = 0;
	_G["SVUI_MentaloPrecisionSetY"].CurrentValue = 0;
	_G["SVUI_MentaloPrecision"]:EnableMouse(true)
	CurrentFrameTarget = false;
end;
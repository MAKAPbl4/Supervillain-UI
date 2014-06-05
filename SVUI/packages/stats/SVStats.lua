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
local MOD = SuperVillain:NewModule('SVStats', 'AceTimer-3.0', 'AceHook-3.0')
MOD.Anchors = {};
MOD.Statistics = {};
MOD.Databars = {};
MOD.PlotPoints={[1]='middle',[2]='left',[3]='right'};
--[[ 
########################################################## 
LOCALIZED GLOBALS
##########################################################
]]--
local SVUI_CLASS_COLORS = _G.SVUI_CLASS_COLORS
local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS
--[[ 
########################################################## 
LOCAL VARIABLES
##########################################################
]]--
local LDB = LibStub:GetLibrary("LibDataBroker-1.1");
local LSM = LibStub("LibSharedMedia-3.0");
local BGStatPrev
local BGStatString = ''
local classColor = SVUI_CLASS_COLORS[SuperVillain.class]
local dataLayout={['TopLeftDataPanel']={['left']=10,['middle']=5,['right']=2}}
local dataStrings={[10]=DAMAGE,[5]=HONOR,[2]=KILLING_BLOWS,[4]=DEATHS,[3]=HONORABLE_KILLS,[11]=SHOW_COMBAT_HEALING}
local bgToken={WSG=443,TP=626,AV=401,SOTA=512,IOC=540,EOTS=482,TBFG=736,AB=461,TOK=856,SSM=860};
local bgName;
local StatMenuFrame = CreateFrame("Frame", "SVUI_StatMenu", SuperVillain.UIParent)
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function Stat_Blur()
  MOD.tooltip:Hide()
end;

local function GrabPlot(parent,slot,max)
  if max==1 then 
    return'CENTER',parent,'CENTER'
  else 
    if slot==1 then 
      return'CENTER',parent,'CENTER'
    elseif slot==2 then 
      return'RIGHT',parent.holders['middle'],'LEFT',-4,0 
    elseif slot==3 then 
      return'LEFT',parent.holders['middle'],'RIGHT',4,0 
    end 
  end 
end;

local UpdateAnchor = function()
  for _,anchor in pairs(MOD.Anchors)do 
    local w=anchor:GetWidth() / anchor.numPoints - 4;
    local h=anchor:GetHeight() - 4;
    for i=1,anchor.numPoints do 
      local this=MOD.PlotPoints[i]
      anchor.holders[this]:Width(w)
      anchor.holders[this]:Height(h)
      anchor.holders[this]:Point(GrabPlot(anchor,i,numPoints))
    end 
  end 
end;

local function Stat_AltClickMenu(self,list,...)
  SuperVillain:SetUIMenu(list, StatMenuFrame, self, true)
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:Tip(f)
  local p=f:GetParent()
  self.tooltip:Hide()
  self.tooltip:SetOwner(p,p.anchor,p.xOff,p.yOff)
  self.tooltip:ClearLines()
  GameTooltip:Hide()
end;

function MOD:ShowTip(noSpace)
  if(not noSpace) then
    self.tooltip:AddLine(" ")
  end
  self.tooltip:AddDoubleLine("[Alt + Click]","Swap Stats",0,1,0, 0.5,1,0.5)
  self.tooltip:Show()
end;

function MOD:NewAnchor(parent,max,tipAnchor,x,y)
  MOD.Anchors[parent:GetName()]=parent;
  parent.holders={};
  parent.numPoints=max;
  parent.xOff=x;
  parent.yOff=y;
  parent.anchor=tipAnchor;
  for i=1,max do 
    local this=MOD.PlotPoints[i]
    if not parent.holders[this] then
      parent.holders[this]=CreateFrame('Button','DataText'..i,parent)
      parent.holders[this]:RegisterForClicks("AnyUp")
      parent.holders[this].barframe=CreateFrame("Frame",nil,parent.holders[this])
      parent.holders[this].barframe:Point("TOPLEFT",parent.holders[this],"TOPLEFT",24,2)
      parent.holders[this].barframe:Point("BOTTOMRIGHT",parent.holders[this],"BOTTOMRIGHT",3,-2)
      parent.holders[this].barframe:SetFrameLevel(parent.holders[this]:GetFrameLevel()-1)
      parent.holders[this].barframe:SetBackdrop({bgFile=[[Interface\BUTTONS\WHITE8X8]],edgeFile=SuperVillain.Textures.shadow,tile=false,tileSize=0,edgeSize=2,insets={left=0,right=0,top=0,bottom=0}})
      parent.holders[this].barframe:SetBackdropColor(SuperVillain.Colors.transparent)
      parent.holders[this].barframe:SetBackdropBorderColor(0,0,0,0.8)
      parent.holders[this].barframe.icon=CreateFrame("Frame",nil,parent.holders[this].barframe)
      parent.holders[this].barframe.icon:Point("TOPLEFT",parent.holders[this],"TOPLEFT",0,6)
      parent.holders[this].barframe.icon:Point("BOTTOMRIGHT",parent.holders[this],"BOTTOMLEFT",26,-6)
      parent.holders[this].barframe.icon.texture=parent.holders[this].barframe.icon:CreateTexture(nil,"OVERLAY")
      parent.holders[this].barframe.icon.texture:FillInner(parent.holders[this].barframe.icon,2,2)
      parent.holders[this].barframe.icon.texture:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Icons\\SV-SMALL")
      parent.holders[this].barframe.bar=CreateFrame("StatusBar",nil,parent.holders[this].barframe)
      parent.holders[this].barframe.bar:FillInner(parent.holders[this].barframe,2,2)
      parent.holders[this].barframe.bar:SetStatusBarTexture(SuperVillain.Textures.bar)
      parent.holders[this].barframe.bg=parent.holders[this].barframe:CreateTexture(nil,"BORDER")
      parent.holders[this].barframe.bg:FillInner(parent.holders[this].barframe,2,2)
      parent.holders[this].barframe.bg:SetTexture([[Interface\BUTTONS\WHITE8X8]])
      parent.holders[this].barframe.bg:SetGradient(unpack(SuperVillain.Colors.gradient.dark))
      parent.holders[this].barframe.bar.extra=CreateFrame("StatusBar",nil,parent.holders[this].barframe.bar)
      parent.holders[this].barframe.bar.extra:SetAllPoints()
      parent.holders[this].barframe.bar.extra:SetStatusBarTexture(SuperVillain.Textures.bar)
      parent.holders[this].barframe.bar.extra:Hide()
      parent.holders[this].barframe:Hide()
      parent.holders[this].textframe=CreateFrame("Frame",nil,parent.holders[this])
      parent.holders[this].textframe:SetAllPoints(parent.holders[this])
      parent.holders[this].textframe:SetFrameStrata("HIGH")
      parent.holders[this].text=parent.holders[this].textframe:CreateFontString(nil,'OVERLAY',nil,7)
      parent.holders[this].text:SetAllPoints()
      parent.holders[this].text:SetFontTemplate(LSM:Fetch("font",MOD.db.font),MOD.db.fontSize,MOD.db.fontOutline)
      parent.holders[this].text:SetJustifyH("CENTER")
      parent.holders[this].text:SetJustifyV("middle")
    end;
    parent.holders[this].MenuList={};
    parent.holders[this]:Point(GrabPlot(parent,i,max))
  end;
  parent:SetScript('OnSizeChanged',UpdateAnchor)
  UpdateAnchor(parent)
end;

function MOD:Load(parent,config)
  if config['events']then 
    for _,event in pairs(config['events'])do 
      parent:RegisterEvent(event)
    end 
  end;
  if config['event_handler']then 
    parent:SetScript('OnEvent',config['event_handler'])
    config['event_handler'](parent,'SVUI_FORCE_RUN')
  end;
  if config['update_handler']then 
    parent:SetScript('OnUpdate',config['update_handler'])
    config['update_handler'](parent,20000)
  end;
  if config['click_handler']then 
    parent:SetScript('OnClick',function(self, button)
      if IsAltKeyDown() then
        Stat_AltClickMenu(self,self.MenuList);
      else
        if(StatMenuFrame:IsShown()) then
          ToggleFrame(StatMenuFrame)
        end
        config['click_handler'](self, button);
      end
    end)
  else
    parent:SetScript('OnClick',function(self, button)
      if IsAltKeyDown() then
        Stat_AltClickMenu(self,self.MenuList);
      end
    end)
  end;
  if config['focus_handler']then 
    parent:SetScript('OnEnter',config['focus_handler'])
  end;
  if config['blur_handler']then 
    parent:SetScript('OnLeave',config['blur_handler'])
  else 
    parent:SetScript('OnLeave',Stat_Blur)
  end 
end;

function MOD:Extend(newStat,eventList,onEvents,update,click,focus,blur)
  if not newStat then return end;
  MOD.Statistics[newStat]={}
  if type(eventList)=='table'then 
    MOD.Statistics[newStat]['events']=eventList;
    MOD.Statistics[newStat]['event_handler']=onEvents 
  end;
  if update and type(update)=='function'then 
    MOD.Statistics[newStat]['update_handler']=update 
  end;
  if click and type(click)=='function'then 
    MOD.Statistics[newStat]['click_handler']=click 
  end;
  if focus and type(focus)=='function'then 
    MOD.Statistics[newStat]['focus_handler']=focus 
  end;
  if blur and type(blur)=='function'then 
    MOD.Statistics[newStat]['blur_handler']=blur 
  end 
end;

function MOD:SetMenuLists()
  for place,parent in pairs(MOD.Anchors)do
    for h = 1, parent.numPoints do 
      local this = MOD.PlotPoints[h]
      tinsert(parent.holders[this].MenuList,{text = NONE, func = function() MOD:ChangeDBVar(NONE, this, "panels", place); MOD:Generate() end});
      for name,config in pairs(MOD.Statistics)do
        tinsert(parent.holders[this].MenuList,{text = name, func = function() MOD:ChangeDBVar(name, this, "panels", place); MOD:Generate() end});
      end 
    end
  end;
end;

function MOD:Generate()
  for name,obj in LDB:DataObjectIterator() do 
    LDB:UnregisterAllCallbacks(self)
  end;
  local instance,groupType=IsInInstance()
  for place,parent in pairs(MOD.Anchors)do
    for h=1,parent.numPoints do 
      local this=MOD.PlotPoints[h]
      parent.holders[this]:UnregisterAllEvents()
      parent.holders[this]:SetScript('OnUpdate',nil)
      parent.holders[this]:SetScript('OnEnter',nil)
      parent.holders[this]:SetScript('OnLeave',nil)
      parent.holders[this]:SetScript('OnClick',nil)
      parent.holders[this].text:SetFontTemplate(LSM:Fetch("font",MOD.db.font),MOD.db.fontSize,MOD.db.fontOutline)
      parent.holders[this].text:SetText(nil)
      if parent.holders[this].barframe then 
        parent.holders[this].barframe:Hide()
      end;
      parent.holders[this].pointIndex=this;
      if place=='TopLeftDataPanel'and instance and groupType=="pvp" and not MOD.ForceHideBGStats and SuperVillain.db.SVStats.battleground then 
        parent.holders[this]:RegisterEvent('UPDATE_BATTLEFIELD_SCORE')
        parent.holders[this]:SetScript('OnEvent',MOD.UPDATE_BATTLEFIELD_SCORE)
        parent.holders[this]:SetScript('OnEnter',MOD.BattlegroundStats)
        parent.holders[this]:SetScript('OnLeave',MOD.Data_OnLeave)
        parent.holders[this]:SetScript('OnClick',MOD.HideBattlegroundTexts)
        MOD.UPDATE_BATTLEFIELD_SCORE(parent.holders[this])
      else 
        for name,config in pairs(MOD.Statistics)do
          for k,l in pairs(SuperVillain.db.SVStats.panels)do 
            if l and type(l)=='table'then 
              if k==place and SuperVillain.db.SVStats.panels[k][this] and SuperVillain.db.SVStats.panels[k][this]==name then 
                MOD:Load(parent.holders[this],config)
              end 
            elseif l and type(l)=='string'and l==name then 
              if SuperVillain.db.SVStats.panels[k]==name and k==place then 
                MOD:Load(parent.holders[this],config)
              end 
            end 
          end
        end 
      end 
    end
  end;
  if MOD.ForceHideBGStats then MOD.ForceHideBGStats=nil end
end;

function MOD:UPDATE_BATTLEFIELD_SCORE()
  BGStatPrev=self;
  local pointIndex=dataLayout[self:GetParent():GetName()][self.pointIndex]
  for a=1,GetNumBattlefieldScores()do 
    bgName=GetBattlefieldScore(a)
    if bgName==SuperVillain.name then 
      self.text:SetFormattedText(BGStatString,dataStrings[pointIndex],TruncateNumericString(select(pointIndex,GetBattlefieldScore(a))))
      break 
    end 
  end 
end;

function MOD:BattlegroundStats()
  MOD:Tip(self)
  local c=GetCurrentMapAreaID()
  for d=1,GetNumBattlefieldScores()do 
    bgName=GetBattlefieldScore(d)
    if bgName and bgName==SuperVillain.name then 
      MOD.tooltip:AddDoubleLine(L['Stats For:'],bgName,1,1,1,classColor.r,classColor.g,classColor.b)
      MOD.tooltip:AddLine(" ")
      if c==bgToken.WSG or c==bgToken.TP then 
        MOD.tooltip:AddDoubleLine(L['Flags Captured'],GetBattlefieldStatData(d,1),1,1,1)
        MOD.tooltip:AddDoubleLine(L['Flags Returned'],GetBattlefieldStatData(d,2),1,1,1)
      elseif c==bgToken.EOTS then 
        MOD.tooltip:AddDoubleLine(L['Flags Captured'],GetBattlefieldStatData(d,1),1,1,1)
      elseif c==bgToken.AV then 
        MOD.tooltip:AddDoubleLine(L['Graveyards Assaulted'],GetBattlefieldStatData(d,1),1,1,1)
        MOD.tooltip:AddDoubleLine(L['Graveyards Defended'],GetBattlefieldStatData(d,2),1,1,1)
        MOD.tooltip:AddDoubleLine(L['Towers Assaulted'],GetBattlefieldStatData(d,3),1,1,1)
        MOD.tooltip:AddDoubleLine(L['Towers Defended'],GetBattlefieldStatData(d,4),1,1,1)
      elseif c==bgToken.SOTA then 
        MOD.tooltip:AddDoubleLine(L['Demolishers Destroyed'],GetBattlefieldStatData(d,1),1,1,1)
        MOD.tooltip:AddDoubleLine(L['Gates Destroyed'],GetBattlefieldStatData(d,2),1,1,1)
      elseif c==bgToken.IOC or c==bgToken.TBFG or c==bgToken.AB then 
        MOD.tooltip:AddDoubleLine(L['Bases Assaulted'],GetBattlefieldStatData(d,1),1,1,1)
        MOD.tooltip:AddDoubleLine(L['Bases Defended'],GetBattlefieldStatData(d,2),1,1,1)
      elseif c==bgToken.TOK then 
        MOD.tooltip:AddDoubleLine(L['Orb Possessions'],GetBattlefieldStatData(d,1),1,1,1)
        MOD.tooltip:AddDoubleLine(L['Victory Points'],GetBattlefieldStatData(d,2),1,1,1)
      elseif c==bgToken.SSM then 
        MOD.tooltip:AddDoubleLine(L['Carts Controlled'],GetBattlefieldStatData(d,1),1,1,1)
      end;
      break 
    end 
  end;
  MOD:ShowTip()
end;

function MOD:HideBattlegroundTexts()
  MOD.ForceHideBGStats=true;
  MOD:Generate()
  SuperVillain:AddonMessage(L['Battleground statistics temporarily hidden, to show type "/sv bg" or "/sv pvp"'])
end;
--[[ 
########################################################## 
COLOR CALLBACK
##########################################################
]]--
local BGStatColorUpdate=function()
  local a=SuperVillain.Colors:Hex("highlight");
  local b,c,d=unpack(SuperVillain.Colors.highlight)
  BGStatString=string.join("","%s: ","","%s|r")
  if BGStatPrev~=nil then 
    MOD.UPDATE_BATTLEFIELD_SCORE(BGStatPrev)
  end 
end;
SuperVillain.Colors:Register(BGStatColorUpdate);
--[[ 
########################################################## 
BUILD FUNCTION / UPDATE
##########################################################
]]--
function MOD:UpdateThisPackage()
  self:Generate()
end;

function MOD:ConstructThisPackage()
  SVUI_DATA["Accountant"] = SVUI_DATA["Accountant"] or {};
  SVUI_DATA["Accountant"][SuperVillain.realm] = SVUI_DATA["Accountant"][SuperVillain.realm] or {};
  SVUI_DATA["Accountant"][SuperVillain.realm]["gold"] = SVUI_DATA["Accountant"][SuperVillain.realm]["gold"] or {};
  SVUI_DATA["Accountant"][SuperVillain.realm]["gold"][SuperVillain.name] = SVUI_DATA["Accountant"][SuperVillain.realm]["gold"][SuperVillain.name] or 0;
  SVUI_DATA["Accountant"][SuperVillain.realm]["tokens"] = SVUI_DATA["Accountant"][SuperVillain.realm]["tokens"] or {};
  SVUI_DATA["Accountant"][SuperVillain.realm]["tokens"][SuperVillain.name] = SVUI_DATA["Accountant"][SuperVillain.realm]["tokens"][SuperVillain.name] or 738;
  StatMenuFrame:SetPanelTemplate("Button");
	self.tooltip = CreateFrame("GameTooltip", "StatisticTooltip", SuperVillain.UIParent, "GameTooltipTemplate")
	self.tooltip:HookScript('OnShow', function(this)
    this:SetBackdrop({
      bgFile=[[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]],
      edgeFile=[[Interface\BUTTONS\WHITE8X8]],
      tile=false,
      edgeSize=1
    })
    this:SetBackdropColor(0,0,0,0.8)
    this:SetBackdropBorderColor(0,0,0)
  end)
	self:RunTemp()
  self:SetMenuLists()
	self:Generate()
  self:LoadServerGold()
  self:LoadTokenCache()
	self:RegisterEvent('PLAYER_ENTERING_WORLD', 'Generate')
end
SuperVillain.Registry:NewPackage(MOD:GetName());
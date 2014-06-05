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
local tinsert   = _G.tinsert;
local string    = _G.string;
local math      = _G.math;
local bit       = _G.bit;
local table     = _G.table;
--[[ STRING METHODS ]]--
local lower, upper = string.lower, string.upper;
local find, format, len, split = string.find, string.format, string.len, string.split;
local match, sub, join = string.match, string.sub, string.join;
local gmatch, gsub = string.gmatch, string.gsub;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;  -- Basic
local fmod, modf, sqrt = math.fmod, math.modf, math.sqrt;   -- Algebra
local atan2, cos, deg, rad, sin = math.atan2, math.cos, math.deg, math.rad, math.sin;  -- Trigonometry
local parsefloat, huge, random = math.parsefloat, math.huge, math.random;  -- Uncommon
--[[ BINARY METHODS ]]--
local band, bor = bit.band, bit.bor;
--[[ TABLE METHODS ]]--
local tremove, tcopy, twipe, tsort, tconcat, tdump = table.remove, table.copy, table.wipe, table.sort, table.concat, table.dump;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SVUINameSpace, SVUICore = ...;
local SuperVillain = LibStub("AceAddon-3.0"):NewAddon(SVUINameSpace, "AceConsole-3.0", "AceEvent-3.0", 'AceTimer-3.0', 'AceHook-3.0');
local L = LibStub("AceLocale-3.0"):GetLocale(SVUINameSpace, false);
--[[ 
########################################################## 
LOCALS
##########################################################
]]--
local bld = select(2,GetBuildInfo());
local resolution = GetCVar("gxResolution");
--[[ 
########################################################## 
CREATE GLOBAL NAMESPACE
##########################################################
]]--
SuperVillain.CallBackHandler = SuperVillain.CallBackHandler or LibStub("CallbackHandler-1.0"):New(SuperVillain)
SuperVillain.loaded = {};
SuperVillain.loaded["profile"] = {};
SuperVillain.loaded["global"] = {};  
SuperVillain.internal = {};
SuperVillain.internal["profile"] = {};
SuperVillain.Options = { type="group", name="|cff339fffConfig-O-Matic|r", args={}, };
SuperVillain.version = GetAddOnMetadata(..., "Version");
SuperVillain.HVAL = format("|cff%02x%02x%02x",0.2*255,0.5*255,1*255);
SuperVillain.class = select(2,UnitClass("player"));
SuperVillain.name = UnitName("player");
SuperVillain.realm = GetRealmName();
SuperVillain.build = tonumber(bld);
SuperVillain.race = select(2,UnitRace("player"));
SuperVillain.faction = select(2,UnitFactionGroup('player'));
SuperVillain.guid = UnitGUID('player');
SuperVillain.mac = IsMacClient();
SuperVillain.screenheight = tonumber(match(resolution,"%d+x(%d+)"));
SuperVillain.screenwidth = tonumber(match(resolution,"(%d+)x%d+"));
SuperVillain.macheight = tonumber(match(resolution,"%d+x(%d+)"));
SuperVillain.macwidth = tonumber(match(resolution,"(%d+)x%d+"));
SuperVillain.mult = 1;
--[[ INTERNAL HANDLER FRAMES ]]--
SuperVillain.UIParent = CreateFrame('Frame','SVUIParent',UIParent);
SuperVillain.UIParent:SetFrameLevel(UIParent:GetFrameLevel());
SuperVillain.UIParent:SetPoint('CENTER',UIParent,'CENTER');
SuperVillain.UIParent:SetSize(UIParent:GetSize());
--[[ INTERNAL TEMP STORAGE ]]--
SuperVillain.ConfigurationMode = false;
SuperVillain.DisplayAudit = {};
SuperVillain.DynamicOptions = {};
SuperVillain.ClassRole = "";
SuperVillain.ReverseTimer = {};
SuperVillain.snaps = {};
SuperVillain.snaps[#SuperVillain.snaps + 1] = SuperVillain.UIParent;
--[[ 
########################################################## 
BUILD ADDON OBJECTS
##########################################################
]]--
SVUICore[1] = SuperVillain;
SVUICore[2] = L;
SVUICore[3] = SuperVillain.internal["profile"];
SVUICore[4] = SuperVillain.loaded["profile"];
SVUICore[5] = SuperVillain.loaded["global"];
_G[SVUINameSpace] = SVUICore;
--[[ 
########################################################## 
THE CLEANING LADY
##########################################################
]]--
local LemonPledge = 0;
local Consuela = CreateFrame("Frame")
--[[ 
########################################################## 
SYSTEM FUNCTIONS
##########################################################
]]--
function SuperVillain:StaticPopup_Show(arg)
    if arg == "ADDON_ACTION_FORBIDDEN" then 
        StaticPopup_Hide(arg)
    end
end;

function SuperVillain:ResetAllUI(confirmed)
    if InCombatLockdown()then 
        SuperVillain:AddonMessage(ERR_NOT_IN_COMBAT)
        return 
    end;
    if(not confirmed) then 
        self:StaticPopup_Show('RESET_UI_CHECK')
        return 
    end;
    self:ResetInstallation()
end;

function SuperVillain:ResetUI(confirmed)
    if InCombatLockdown()then 
        SuperVillain:AddonMessage(ERR_NOT_IN_COMBAT)
        return 
    end;
    if(not confirmed) then 
        self:StaticPopup_Show('RESETMOVERS_CHECK')
        return 
    end;
    self:ResetMovables()
end;

function SuperVillain:ResetProfile()
    local charKey;
    if SVUI_SAFE_DATA.profileKeys then 
        charKey = SVUI_SAFE_DATA.profileKeys[self.name..' - '..self.realm]
    end;
    if charKey and SVUI_SAFE_DATA.profiles and SVUI_SAFE_DATA.profiles[charKey] then 
        SVUI_SAFE_DATA.profiles[charKey] = nil 
    end;
    SVUI_MOVED_FRAMES = nil;
    ReloadUI()
end;

function SuperVillain:OnProfileReset()
    self:StaticPopup_Show("RESET_PROFILE_PROMPT")
end;

function SuperVillain:ToggleConfig()
    if InCombatLockdown() then 
        SuperVillain:AddonMessage(ERR_NOT_IN_COMBAT) 
        self:RegisterEvent('PLAYER_REGEN_ENABLED')
        return 
    end;
    if not IsAddOnLoaded("SVUI_ConfigOMatic") then 
        local _,_,_,_,_,state = GetAddOnInfo("SVUI_ConfigOMatic")
        if state ~= "MISSING" and state ~= "DISABLED" then 
            LoadAddOn("SVUI_ConfigOMatic")
            if GetAddOnMetadata("SVUI_ConfigOMatic","Version") ~= "3.99" then 
                self:StaticPopup_Show("CLIENT_UPDATE_REQUEST")
            end 
        else 
            SuperVillain:AddonMessage("|cffff0000Error -- Addon 'SVUI_ConfigOMatic' not found or is disabled.|r")
            return 
        end 
    end;
    local aceConfig = LibStub("AceConfigDialog-3.0")
    local switch = not aceConfig.OpenFrames[SVUINameSpace] and "Open" or "Close"
    aceConfig[switch](aceConfig,SVUINameSpace)
    GameTooltip:Hide()
end;

function SuperVillain:TaintHandler(taint,sourceName,sourceFunc)
    if GetCVarBool('scriptErrors') ~= 1 then return end;
    ScriptErrorsFrame_OnError(L["%s: %s has lost it's damn mind and is destroying '%s'."]:format(taint, sourceName or "<name>", sourceFunc or "<func>"),false)
end;
--[[ 
########################################################## 
EVENT HANDLERS
##########################################################
]]--
function SuperVillain:PLAYER_REGEN_ENABLED()
    self:ToggleConfig()
    self:UnregisterEvent('PLAYER_REGEN_ENABLED')
end;

function SuperVillain:PLAYER_REGEN_DISABLED()
    local forceClosed=false;
    if IsAddOnLoaded("SVUI_ConfigOMatic") then 
        local aceConfig=LibStub("AceConfigDialog-3.0")
        if aceConfig.OpenFrames[SVUINameSpace] then 
            self:RegisterEvent('PLAYER_REGEN_ENABLED')
            aceConfig:Close(SVUINameSpace)
            forceClosed = true 
        end 
    end;
    if SuperVillain.Movables then 
        for frame,_ in pairs(self.Movables) do 
            if _G[frame] and _G[frame]:IsShown() then 
                forceClosed = true;
                _G[frame]:Hide()
            end 
        end 
    end;
    if(HenchmenFrame and HenchmenFrame:IsShown()) then 
        HenchmenFrame:Hide()
        HenchmenFrameBG:Hide()
        forceClosed = true;
    end
    if forceClosed==true then 
        SuperVillain:AddonMessage(ERR_NOT_IN_COMBAT)
    end 
end;

function SuperVillain:PLAYER_ENTERING_WORLD()
    self:DefinePlayerRole()
    if(not self.MediaUpdated) then 
        self:Refresh_SVUI_Media()
        self.MediaUpdated = true 
    end;
    local a,b = IsInInstance()
    if(b == "pvp") then 
        self.BGTimer = self:ScheduleRepeatingTimer(RequestBattlefieldScoreData, 5)
    elseif(self.BGTimer) then 
        self:CancelTimer(self.BGTimer)
        self.BGTimer = nil 
    end
end;

function SuperVillain:SPELLS_CHANGED()
    if (self.class ~= "DRUID") then
        self:UnregisterEvent("SPELLS_CHANGED")
        return 
    end;
    if GetSpellInfo(droodSpell1) == droodSpell2 then 
        self.ClassDispell.Disease = true 
    else 
        self.ClassDispell.Disease = false 
    end 
end;
--[[ 
########################################################## 
SYSTEM UPDATES
##########################################################
]]--
function SuperVillain:Refresh_SVUI_Data()
    self.db = self.data.profile;
    self.global = self.data.global;
end;

function SuperVillain:Refresh_SVUI_Config()
    SuperVillain.UIParent:Hide();
    self:Refresh_SVUI_Data();
    self:SetSVMovablesPositions();
    self:Refresh_SVUI_Media();
    self.Registry:Update('SVUnit');
    self.Registry:UpdateAll();
    SuperVillain.UIParent:Show();
    collectgarbage("collect");
end;

function SuperVillain:Refresh_SVUI_System(bypass)
    self.data = LibStub("AceDB-3.0"):New("SVUI_DATA", self.loaded);
    self.data.RegisterCallback(self, "OnProfileChanged", "Refresh_SVUI_System");
    self.data.RegisterCallback(self, "OnProfileCopied", "Refresh_SVUI_System");
    self.data.RegisterCallback(self, "OnProfileReset", "OnProfileReset");

    LibStub("LibDualSpec-1.0"):EnhanceDatabase(self.data, "SVUI");

    self.db = self.data.profile;
    self.global = self.data.global;

    SuperVillain.UIParent:Hide();
    self:SetSVMovablesPositions();
    self:Refresh_SVUI_Media();
    self.Registry:Update('SVUnit');
    self.Registry:UpdateAll();
    SuperVillain.UIParent:Show();
    collectgarbage("collect");
    
    if not bypass then
        if(self.protected.install_complete == nil or (self.protected.install_complete and type(self.protected.install_complete) == 'boolean') or (self.protected.install_complete and type(tonumber(self.protected.install_complete)) == 'number' and tonumber(self.protected.install_complete) < 3.999)) then 
            self:Install(); 
        end
    end
end;
--[[ 
########################################################## 
SVUI LOAD PROCESS
##########################################################
]]--
function SuperVillain:OnInitialize()
    --[[ BEGIN DEPRECATED ]]--
    -- if SVUI_DB then SVUI_DB=nil end;
    -- if ProfileSVUI_DB then ProfileSVUI_DB=nil end;
    -- if MovablesSVUI_DB then MovablesSVUI_DB=nil end;
    -- if ProtectedSVUI_DB then ProtectedSVUI_DB=nil end;
    -- if SVUI_LOGS then SVUI_LOGS=nil end;
    --[[ END DEPRECATED ]]--
    if not SVUI_DATA then SVUI_DATA = {} end;
    if not SVUI_TRACKER then SVUI_TRACKER = {} end;
    if not SVUI_ENEMIES then SVUI_ENEMIES = {} end;
    if not SVUI_DATA["gold"] then SVUI_DATA["gold"] = 0 end;
    self.db = tcopy(self.loaded.profile,true)
    self.global = tcopy(self.loaded.global,true)
    self.protected = tcopy(self.internal.profile,true)


    if SVUI_DATA then 
        if SVUI_DATA.global then 
            self:TableSplice(self.global, SVUI_DATA.global)
        end;

        local charKey;
        if SVUI_DATA.profileKeys then 
            charKey = SVUI_DATA.profileKeys[self.name.." - "..self.realm]
        end;

        if charKey and SVUI_DATA.profiles and SVUI_DATA.profiles[charKey]then 
            self:TableSplice(self.db, SVUI_DATA.profiles[charKey])
        end
    end;

    if SVUI_SAFE_DATA then
        local charKey;
        if SVUI_SAFE_DATA.profileKeys then 
            charKey = SVUI_SAFE_DATA.profileKeys[self.name.." - "..self.realm]
        end;
        if charKey and SVUI_SAFE_DATA.profiles and SVUI_SAFE_DATA.profiles[charKey]then 
            self:TableSplice(self.protected, SVUI_SAFE_DATA.profiles[charKey])
        end 
    end;

    self:UIScale();
    self:Refresh_SVUI_Media();
    self:RegisterEvent('PLAYER_REGEN_DISABLED');
    self:LoadSystemAlerts();
    self.Registry:PreLoad();
end;

function SuperVillain:OnEnable()
    twipe(self.db);
    twipe(self.global);
    twipe(self.protected);

    self.data = LibStub("AceDB-3.0"):New("SVUI_DATA", self.loaded);
    self.data.RegisterCallback(self, "OnProfileChanged", "Refresh_SVUI_System");
    self.data.RegisterCallback(self, "OnProfileCopied", "Refresh_SVUI_System");
    self.data.RegisterCallback(self, "OnProfileReset", "OnProfileReset");
    LibStub("LibDualSpec-1.0"):EnhanceDatabase(self.data, "SVUI");
    self.charSettings = LibStub("AceDB-3.0"):New("SVUI_SAFE_DATA", self.internal)
    self.protected = self.charSettings.profile;
    self.db = self.data.profile;
    self.global = self.data.global;
    
    self:UIScale("PLAYER_LOGIN");
    self.Registry:Load();
    self:DefinePlayerRole();
    self:LoadSlashCommands();
    self:LoadMovables();
    self:SetSVMovablesPositions();
    self.CoreEnabled = true;

    if (self.protected.install_complete == nil or not self.protected.install_version or self.protected.install_version ~= self.version) then 
        self:Install()
        self.protected.install_version = self.version 
    end;

    self:Refresh_SVUI_Media();
    self:SecureHook('StaticPopup_Show')
    self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED","DefinePlayerRole");
    self:RegisterEvent("PLAYER_TALENT_UPDATE","DefinePlayerRole");
    self:RegisterEvent("CHARACTER_POINTS_CHANGED","DefinePlayerRole");
    self:RegisterEvent("UNIT_INVENTORY_CHANGED","DefinePlayerRole");
    self:RegisterEvent("UPDATE_BONUS_ACTIONBAR","DefinePlayerRole");
    self:RegisterEvent('UI_SCALE_CHANGED','UIScale');
    self:RegisterEvent('PLAYER_ENTERING_WORLD');
    self:RegisterEvent("PET_BATTLE_CLOSE",'PushDisplayAudit');
    self:RegisterEvent('PET_BATTLE_OPENING_START',"FlushDisplayAudit");
    self:RegisterEvent("ADDON_ACTION_BLOCKED", "TaintHandler");
    self:RegisterEvent("ADDON_ACTION_FORBIDDEN", "TaintHandler");
    self:RegisterEvent("SPELLS_CHANGED");

    self.Registry:Update('SVMap');
    self.Registry:Update('SVUnit',true);

    _G["SVUI_Mentalo"]:SetFixedPanelTemplate("Component")
    _G["SVUI_Mentalo"]:SetPanelColor("yellow")
    _G["SVUI_MentaloPrecision"]:SetFixedPanelTemplate("Default")

    Consuela:RegisterAllEvents()
    Consuela:SetScript("OnEvent", function(self, event)
        LemonPledge = LemonPledge + 1
        if (InCombatLockdown() and LemonPledge > 25000) or (not InCombatLockdown() and LemonPledge > 10000) or event == "PLAYER_ENTERING_WORLD" then
            collectgarbage("collect");
            LemonPledge = 0;
        end
    end)

    if self.protected.common.loginmessage then 
        print(select(2, self:GetModule('SVChat'):ParseMessage("CHAT_MSG_DUMMY", format(L['LOGIN_MSG'], "|cffffcc1a", "|cffff801a", self.version)))..'.');
    end;
end;

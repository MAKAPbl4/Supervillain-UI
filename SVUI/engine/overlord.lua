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
local type      = _G.type;
local string    = _G.string;
local math      = _G.math;
local table     = _G.table;
local find, format, len, split = string.find, string.format, string.len, string.split;
local tsort,twipe = table.sort,table.wipe;
local floor,ceil  = math.floor, math.ceil;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, G = unpack(select(2, ...));
local MOD = SuperVillain:NewModule('Overlord', "AceEvent-3.0", "AceTimer-3.0", "AceComm-3.0", "AceSerializer-3.0", 'AceConsole-3.0')
--[[ 
########################################################## 
LOCALS
##########################################################
]]--
local TRIGGER_PHRASE = "SVUI_ECHO";
local TRIGGER_RESPONSE = "SVUI_ACK";

function MOD:CallingAllVillains(target)    
    local message = "SVUI"

    if(target and (UnitExists("target") and (UnitIsPlayer("target") or UnitIsFriend("player", "target")))) then
        target = UnitName("target")
        self:SendCommMessage(TRIGGER_PHRASE, message, "WHISPER", target)
    else
        if IsInRaid() then
            self:SendCommMessage(TRIGGER_PHRASE, message, (not IsInRaid(LE_PARTY_CATEGORY_HOME) and IsInRaid(LE_PARTY_CATEGORY_INSTANCE)) and "INSTANCE_CHAT" or "RAID")
        elseif IsInGroup() then
            self:SendCommMessage(TRIGGER_PHRASE, message, (not IsInGroup(LE_PARTY_CATEGORY_HOME) and IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) and "INSTANCE_CHAT" or "PARTY")
        else
            local _,instance = GetInstanceInfo()
            if(instance == "pvp") then
                self:SendCommMessage(TRIGGER_PHRASE, message, "BATTLEGROUND")
            else
                SuperVillain:AddonMessage("No associates found")
                return
            end
        end
    end

    self:RegisterComm(TRIGGER_RESPONSE)
    self.CommTimer = self:ScheduleTimer("OnCommExpired", 15)
    SuperVillain:AddonMessage("Searching for associates...")
end

function MOD:OnCommReceived(prefix, msg, dist, sender)
    if prefix == TRIGGER_PHRASE then
        local responseString = SuperVillain.name .. ":" .. SuperVillain.guid .. ":" .. SuperVillain.version
        self:SendCommMessage(TRIGGER_RESPONSE, responseString, dist, sender)
    elseif prefix == TRIGGER_RESPONSE then
        local name, guid, version = split(":", msg);
        SVUI_TRACKER[name] = {
            ['id'] = guid,
            ['ver'] = version
        };
        SuperVillain:AddonMessage(name .. ": is using SVUI!")
    end
end

function MOD:OnCommExpired()
    if self.CommTimer then
        self:CancelTimer(self.CommTimer)
        self.CommTimer = nil
    end
    self:UnregisterComm(TRIGGER_RESPONSE)
    SuperVillain:AddonMessage("Search complete!")
end

function MOD:ConstructThisPackage()
    self:RegisterComm(TRIGGER_PHRASE)
    self:RegisterChatCommand("villains", "CallingAllVillains")
end
SuperVillain.Registry:NewPackage(MOD:GetName())
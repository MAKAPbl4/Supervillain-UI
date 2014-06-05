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
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C = unpack(select(2, ...));
--[[ 
########################################################## 
PROTOTYPES
##########################################################
]]--
local prototype={
    db = {},
    PackageIsLoaded = false,
    CombatLocked = false,
    ChangeDBVar = function(self,value,key,sub1,sub2)
        --local debug = self:GetName()
        if sub1 and sub2 and self.db[sub1] and self.db[sub1][sub2] then
            --print(debug..": DB[" .. key .. "] " .. sub1 .. "." .. sub2)
            self.db[sub1][sub2][key] = value;
            SuperVillain.db[self:GetName()][sub1][sub2][key] = value;
        elseif sub1 and self.db[sub1] then
            --print(debug..": DB[" .. key .. "] " .. sub1)
            self.db[sub1][key] = value;
            SuperVillain.db[self:GetName()][sub1][key] = value;
        else
            --print(debug..": DB[" .. key .. "]")
            self.db[key] = value;
            SuperVillain.db[self:GetName()][key] = value;
        end
        --print(value)
    end,
    RunTemp = function(self) 
        if self.___tmp then 
            local toRun = self.___tmp; 
            for fnKey=1,#self.___tmp do 
                toRun[fnKey](self) 
            end; 
            self.___tmp = nil 
        end 
    end,
    Protect = function(self,fnKey,autorun)
        SuperVillain.Security:Register(self,fnKey,autorun);
    end,
    UnProtect = function(self,fnKey) 
        SuperVillain.Security:UnRegister(self,fnKey);
    end
};
SuperVillain:SetDefaultModulePrototype(prototype);
SuperVillain:SetDefaultModuleLibraries("AceEvent-3.0");

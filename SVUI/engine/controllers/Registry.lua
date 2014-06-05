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
local type      = _G.type;
local string    = _G.string;
local table     = _G.table;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ TABLE METHODS ]]--
local tdump = table.dump;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C = unpack(select(2, ...));
local MAJOR = "SuperVillain Plugins";
local MINOR = GetAddOnMetadata(..., "Version");
--[[ 
########################################################## 
REGISTRY MASTER METATABLE
##########################################################
]]--
local METAREGISTRY = {}
METAREGISTRY.new = function()
    local module_list = {};
    local update_list = {};
    local plugin_list = {};
    local script_list = {};
    local name_index = {};
    local order = {pre = 1, main = 2, post = 3};
    local INFO_BY = "by";
    local INFO_VERSION = "Version:";
    local INFO_NEW = "Newest:";
    if GetLocale() == "ruRU" then
        INFO_BY = "от";
        INFO_VERSION = "Версия:";
        INFO_NEW = "Последняя:";
    end
    local methods = {
        _loadPkg = function(_, index)
            if not module_list[index] then return end;
            local pkgList = module_list[index]
            for i=1,#pkgList do 
                local name = pkgList[i]
                local MOD = SuperVillain:GetModule(name,true)
                if MOD and not MOD.PackageIsLoaded then
                    if SuperVillain.db[name] then
                        MOD.db = SuperVillain.db[name]
                    end
                    MOD:ConstructThisPackage(); 
                    MOD.ConstructThisPackage = nil;
                    MOD.PackageIsLoaded = true;
                end 
            end
        end,
        NewScript = function(_, fn)
            if(fn and type(fn) == "function") then
                script_list[#script_list  +  1] = fn
            end 
        end,
        NewPackage = function(_, name, priority)
            local MOD = SuperVillain:GetModule(name)
            local key = order[priority] or 1;
            if(not module_list[key]) then 
                module_list[key] = {}
                tinsert(name_index, name)
            end;
            if(not update_list[key]) then 
                update_list[key] = {} 
            end;
            local pkgList = module_list[key] 
            local updList = update_list[key]
            if(SuperVillain.CoreEnabled) then 
                MOD:Enable()
            else 
                if(pkgList and MOD.ConstructThisPackage) then 
                    pkgList[#pkgList  +  1] = name 
                end;
                if(updList and MOD.UpdateThisPackage) then 
                    updList[#updList  +  1] = name 
                end
            end 
        end,
        FetchPlugins = function()
            local list = "";
            for _, plugin in pairs(plugin_list) do
                if plugin.name ~= MAJOR then
                    local author = GetAddOnMetadata(plugin.name, "Author")
                    local Pname = GetAddOnMetadata(plugin.name, "Title") or plugin.name
                    local color = plugin.old and SuperVillain.Colors:Hex(1,0,0) or SuperVillain.Colors:Hex(0,1,0)
                    list = list .. Pname 
                    if author then
                      list = list .. " ".. INFO_BY .." " .. author
                    end
                    list = list .. color .. " - " .. INFO_VERSION .." " .. plugin.version
                    if plugin.old then
                      list = list .. INFO_NEW .. plugin.newversion .. ")"
                    end
                    list = list .. "|r\n"
                end
            end
            return list
        end,
        NewPlugin = function(this, name, func)
            local plugin = {}
            plugin.name = name
            plugin.version = name == MAJOR and MINOR or GetAddOnMetadata(name, "Version")
            plugin.callback = func
            plugin_list[name] = plugin
            local enable, loadable = select(4,GetAddOnInfo("SVUI_ConfigOMatic"))
            local loaded = IsAddOnLoaded("SVUI_ConfigOMatic")
            if(enable and loadable and not loaded) then
                if not this.PluginTempFrame then
                    local tempframe = CreateFrame("Frame")
                    tempframe:RegisterEvent("ADDON_LOADED")
                    tempframe:SetScript("OnEvent", function(self,event,addon)
                        if addon == "SVUI_ConfigOMatic" then
                            for _, plugin in pairs(plugin_list) do
                                if(plugin.callback) then
                                    plugin.callback()
                                end
                            end
                        end
                    end)
                    this.PluginTempFrame = tempframe
                end
            elseif(enable and loadable) then
                if name ~= MAJOR then
                    SuperVillain.Options.args.plugins.args.plugins.name = _:FetchPlugins()
                end
                if(func) then
                    func()
                end
            end
            return plugin
        end,
        PreLoad = function(_)
            _:_loadPkg(1)
        end,
        Load = function(_)
            _:_loadPkg(2)
            _:_loadPkg(3)
            for i=1,#script_list do 
                local fn = script_list[i]
                if(fn and type(fn) == "function") then
                    fn()
                end 
            end
            module_list = nil
            script_list = nil
        end,
        Temp = function(_, name, func)
            local MOD = SuperVillain:GetModule(name)
            if not MOD.___tmp then 
                MOD.___tmp = {}
            end;
            MOD.___tmp[#MOD.___tmp + 1] = func 
        end,
        Update = function(_, name, dataOnly)
            local MOD = SuperVillain:GetModule(name,true);
            if MOD then
                if SuperVillain.db[name] then
                    MOD.db = SuperVillain.db[name]
                end
                if MOD.UpdateThisPackage and not dataOnly then
                    MOD:UpdateThisPackage()
                end
            end
        end,
        UpdateAll = function()
            for priority = 1,3 do
                if update_list[priority] then
                    local updList = update_list[priority]
                    for i=1,#update_list[priority] do
                        local name = updList[i]
                        local MOD = SuperVillain:GetModule(name,true)
                        if MOD then
                            if SuperVillain.db[name] then
                                MOD.db = SuperVillain.db[name]
                            end
                            MOD:UpdateThisPackage()
                        end 
                    end
                end
            end
        end
    };
    local mt ={
        __index = function(t,  k)
            v = rawget(name_index,  k)
            if v then 
                return v
            end
        end, 
        __tostring = function(t) return "SuperVillain.Registry >>> [" .. tdump(name_index) .. "]" end, 
    };
    setmetatable(methods,  mt)
    return methods
end;
do
    SuperVillain.Registry = METAREGISTRY.new();
end;

--[[ 
########################################################## 
LIB FUNCTIONS
##########################################################
]]--
local GetOptions = function()
    local HDR_CONFIG = "Plugins";
    local HDR_INFORMATION = "SuperVillain UI (version %.3f): Plugins";
    if GetLocale() == "ruRU" then
        HDR_CONFIG = "Плагины";
        HDR_INFORMATION = "SuperVillain UI (устарела %.3f): Плагины";
    end
    SuperVillain.Options.args.plugins = {
        order = -10,
        type = "group",
        name = HDR_CONFIG,
        guiInline = false,
        args = {
            pluginheader = {
                order = 1,
                type = "header",
                name = format(HDR_INFORMATION, MINOR),
            },
            plugins = {
                order = 2,
                type = "description",
                name = SuperVillain.Registry:FetchPlugins(),
            },
        }
    }
end;

SuperVillain.Registry:NewPlugin("SuperVillain Plugins", GetOptions)
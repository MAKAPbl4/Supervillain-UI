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
local pcall     = _G.pcall;
local table     = _G.table;
--[[ TABLE METHODS ]]--
local twipe, tdump = table.wipe, table.dump;
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C = unpack(select(2, ...));
--[[ 
########################################################## 
SECURITY MASTER METATABLE
##########################################################
]]--
local METASECURITY = {}
METASECURITY.new = function()
    local log = {};
    local safe_db = {};
    local requests = {};
    local methods = {
        Register = function(_, ns, f, a)
            local name = ns:GetName();
            local func = ns[f];
            assert(type(func) == "function", "Can only Register a valid function.")
            if not requests[name] then requests[name] = {} end;
            if not safe_db[name] then safe_db[name] = {} end;
            safe_db[name][f] = func;
            local handler = _G[name.."SecurityHandler"] or CreateFrame("Frame", name.."SecurityHandler", UIParent);
            local new_function = function(this,...)
                tinsert(requests[name], {...})
                if(InCombatLockdown()) then
                    if not handler:IsEventRegistered('PLAYER_REGEN_ENABLED') then
                        handler:RegisterEvent('PLAYER_REGEN_ENABLED')
                    end;
                    return
                else
                    for i,_ in pairs(requests[name]) do
                        local _, catch = pcall(func, this, requests[name][i])
                        if catch then
                            tinsert(log,catch)
                        end
                    end
                end
                twipe(requests[name]);
            end;
            ns[f] = new_function;
            handler.callback = ns[f];
            handler:SetScript("OnEvent", function(this,event,...)
                if(InCombatLockdown()) then
                    ns.CombatLocked = true;
                elseif event == 'PLAYER_REGEN_ENABLED' then
                    ns.CombatLocked = false;
                    this:UnregisterEvent('PLAYER_REGEN_ENABLED')
                    this:callback()
                end
            end)
            if a then new_function(ns) end;
        end,
        UnRegister = function(_, ns, f)
            local name = ns:GetName();
            local handler = _G[name.."SecurityHandler"];
            if not handler then return end;
            handler.callback = nil;
            handler:SetScript("OnEvent", nil);
            if safe_db[name][f] then
                ns[f] = safe_db[name][f];
            end
        end,
        ErrorLogs = function(t) print("SuperVillain.Security >>> [" .. tdump(log) .. "]") end,
    };
    local mt ={
        __index = function(t,  k)
            v=rawget(requests,  k)
            if v then return v end
        end, 
        __newindex = function(t,  k,  v)
            if rawget(requests,  k) then rawset(requests,  k,  v) return end
        end, 
        __metatable = {}, 
        __pairs = function(t,  k,  v) return next,  requests,  nil end, 
        __ipairs = function()
            local function iter(a,  i)
                i = i + 1
                local v = a[i]
                if v then return i, v end
            end
            return iter, requests, 0
        end, 
        __len = function(t)
            local count = 0
            for _ in pairs(requests) do count = count + 1 end
            return count
        end, 
        __tostring = function(t) return "SuperVillain.Security >>> [" .. tdump(requests) .. "]" end, 
    };
    setmetatable(methods,  mt)
    return methods
end;
do
    SuperVillain.Security = METASECURITY.new();
end;

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
DEFINE MEDIA METATABLES
##########################################################
]]--
local METAFUNC={}
METAFUNC.new = function()
	local db = {};
	local callbacks = {};
	local repo = C.media.templates;
	local cbcount = 0;
	local process = function(t)
		local n = {};
		for k, v in pairs(t) do
			if(type(v) == "table") then
				local st = {}
				for i, s in pairs(v) do
					rawset(st, i, s)
				end
				rawset(n, k, st)
			else
				rawset(n, k, v)
			end
		end
		if SuperVillain.Textures and n.backdrop then
			if n.backdrop.bgFile then
				local bg = n.backdrop.bgFile
				local nbg = [[Interface\BUTTONS\WHITE8X8]]
				if(bg ~= "blank" and SuperVillain.Textures[bg]) then
					nbg = SuperVillain.Textures[bg];
				end
				rawset(n.backdrop, "bgFile", nbg)
			end
		end
		return n
	end;
	do
		for k, t in pairs(C.media.templates) do
			local c = process(t, k);
			rawset(db, k, c);
	    end;
	end;
	local methods={
		Refresh = function(_)
			assert(type(repo) == "table", "Can not refresh without defining a repository.");
			twipe(db)
			for k, t in pairs(repo) do
				local c = process(t, k);
		    	rawset(db, k, c);
		    end;
		    if(cbcount == 0)then return end;
		    for m, h in pairs(callbacks) do
		        local ok, err = pcall(m, h ~= true and h or nil)
		        if not ok then
		            print("SuperVillain.Templates >>> ERROR:",  err)
		        end
		    end
		end, 
		SetRepository = function(_, t)
			assert(type(t) == "table", "Repository must be a table.");
			if type(repo) == "table" and #repo > 0 then repo = {}end;
			repo = t;
			_:Refresh()
		end, 
		Register = function(_, f, h, s)
			assert(type(f) == "function", "Can only Register a valid function.")
		    callbacks[f] = h or true
		    cbcount = cbcount + 1
		end, 
		Unregister = function(_, f)
			assert(type(f) == "function", "Can only Unregister a registered function.")
		    callbacks[f] = nil
		    cbcount = cbcount - 1
		end, 
	};
	local mt ={
		__index = function(t,  k)
         	v=rawget(db,  k)
	        if v then
	            return v
	        end
	        --print("SuperVillain.Templates >>> : Bad Index Called.")
      	end, 
      	__newindex = function(t,  k,  v)
			if rawget(db,  k) then
				rawset(db,  k,  v)
				return
			elseif type(repo) == "table" and repo[k] then
	        	local n = repo[k]
	        	rawset(db,  k,  n)
	        	return
			end
			--print("SuperVillain.Templates >>> : Bad NewIndex Referenced.")
		end, 
		__metatable = {}, 
		__pairs = function(t,  k,  v) return next,  db,  nil end, 
		__ipairs = function()
			local function iter(a,  i)
				i = i + 1
				local v = a[i]
				if v then
					return i,  v
				end
			end
			return iter,  db,  0
		end, 
		__len = function(t)
			local count = 0
			for _ in pairs(db) do count = count + 1 end
			return count
		end, 
		__tostring = function(t) return "SuperVillain.Templates >>> [" .. tdump(db) .. "]" end, 
	};
	setmetatable(methods,  mt)
   	return methods
end;
do
	SuperVillain.Templates = METAFUNC.new();
end;
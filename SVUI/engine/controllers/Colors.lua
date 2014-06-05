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
local error     = _G.error;
local pcall     = _G.pcall;
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local string    = _G.string;
local table     = _G.table;
--[[ STRING METHODS ]]--
local format, gmatch, gsub = string.format, string.gmatch, string.gsub;
--[[ TABLE METHODS ]]--
local tcopy, twipe, tdump = table.copy, table.wipe, table.dump;
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
local METAFUNC = {}
METAFUNC.new = function()
	local db = {};
	local callbacks = {};
	local repo = C.media.colors;
	local branch = C.media.unitframes;
	local cbcount = 0;
	local process = function(t, k)
		if(not t or type(t) ~= "table") then 
			return {0.2, 0.2, 0.2} 
		end

		if(not t.r or not t.g or not t.b) then 
			if(type(t) == "table") then
				local nt = {}
				for i, s in pairs(t) do
					rawset(nt, i, s)
				end
				return nt
			else
				return {0.2, 0.2, 0.2}
			end
		end

		if t.a then 
			return {t.r, t.g, t.b, t.a}
		else 
			return {t.r, t.g, t.b, 1}
		end
	end
	do
		for k, t in pairs(C.media.colors) do
			local c = process(t, k);
			rawset(db, k, c);
	    end;
	end
	local methods = {
		Attach = function()
			return db
		end,
		Hex = function(_,arg1,arg2,arg3)
			local r,g,b;
			if arg1 and type(arg1) == "string" then
				if db[arg1] then
					r,g,b = unpack(db[arg1]);
				elseif repo[arg1] then
					r,g,b = unpack(repo[arg1]);
				elseif branch[arg1] then
					r,g,b = unpack(branch[arg1]);
				end
			else
				r = type(arg1) == "number" and arg1 or 0;
				g = type(arg2) == "number" and arg2 or 0;
				b = type(arg3) == "number" and arg3 or 0;
			end
			r = (r < 0 or r > 1) and 0 or (r * 255);
			g = (g < 0 or g > 1) and 0 or (g * 255);
			b = (b < 0 or b > 1) and 0 or (b * 255);
			return format("|cff%02x%02x%02x",r,g,b)
		end,
		Extract = function(_,key)
			local r,g,b,a = 0,0,0,1;
			if key and type(key) == "string" then
				if branch and branch[key] and branch[key].r then
					r,g,b = branch[key].r, branch[key].g, branch[key].b;
					if branch[key].a then
						a = branch[key].a
						return {r,g,b,a};
					else
						return {r,g,b};
					end
				elseif repo and repo[key] and repo[key].r then
					r,g,b = repo[key].r, repo[key].g, repo[key].b;
					if repo[key].a then
						a = repo[key].a
						return {r,g,b,a};
					else
						return {r,g,b};
					end
				elseif db[key] and db[key].r then
					r,g,b = db[key].r, db[key].g, db[key].b;
					if db[key].a then
						a = db[key].a
						return {r,g,b,a};
					else
						return {r,g,b};
					end
				end
			elseif key and type(key) == "table" and key.r then
				r,g,b = key.r, key.g, key.b;
				if key.a then
					a = key.a
					return {r,g,b,a};
				else
					return {r,g,b};
				end
			end;
			return {r,g,b,a};
		end,
		Refresh = function(_)
			assert(type(repo) == "table", "Can not refresh without defining a repository.");
			twipe(db)
			for k, t in pairs(repo) do
				local c = process(t, k);
		    	rawset(db, k, c);
		    end;
		    if (cbcount == 0)then return end;
		    for m, h in pairs(callbacks) do
		        local ok, err = pcall(m, h ~= true and h or nil)
		        if not ok then
		            print("SuperVillain.Colors >>> ERROR:",  err)
		        end
		    end
		end, 
		SetRepository = function(_, t, t2)
			assert(type(t) == "table", "Repository must be a table.");
			if type(repo) == "table" and #repo > 0 then repo = {}end;
			repo = t;
			if t2 and type(t2) == "table" then
				branch = t2;
			end;
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
	        --print("SuperVillain.Colors >>> : Bad Index Called.")
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
			--print("SuperVillain.Colors >>> : Bad NewIndex Referenced.")
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
		__tostring = function(t) return "SuperVillain.Colors >>> [" .. tdump(db) .. "]" end, 
	};
	setmetatable(methods,  mt)
   	return methods
end;
--[[ 
########################################################## 
CREATE CONTROLLER
##########################################################
]]--
do
	SuperVillain.Colors = METAFUNC.new();
end;
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
local pairs 	= _G.pairs;
local type 		= _G.type;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local format,find = string.format, string.find;
--[[ MATH METHODS ]]--
local floor = math.floor;
--[[ TABLE METHODS ]]--
local twipe = table.wipe;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, G = unpack(SVUI);
local MOD = SuperVillain:GetModule('SVStyle');
local DOCK = SuperVillain:GetModule('SVDock');
MOD.DockedParent = {}
--[[ 
########################################################## 
LOCAL VARIABLES
##########################################################
]]--
local SuperDockWindow = _G["SuperDockWindow"];
local SuperDockletMain = _G["SuperDockletMain"];
local SuperDockletExtra = _G["SuperDockletExtra"];
--[[ 
########################################################## 
DOCKING FUNCTIONS
##########################################################
]]--
function MOD:RegisterAddonDocklets()
	local main=SuperVillain.protected.docklets.DockletMain;
  	local alternate = SuperVillain.protected.docklets.enableExtra and SuperVillain.protected.docklets.DockletExtra or "";

  	if main==nil or main=='None' then return end;
  	
	if find(main,'Skada') or find(alternate,'Skada') then
		if DOCK:IsDockletReady('Skada') then
			MOD:Docklet_Skada()
			if find(alternate,'Skada') and SuperDockletExtra.FrameName ~= 'SkadaHolder2' then
				DOCK.ExtraToolTip = "Skada";
				DOCK:RegisterExtraDocklet("SkadaHolder2")
				--MOD.DockedParent['Skada'] = SuperDockletExtra
			end
			if find(main,'Skada') and SuperDockletMain.FrameName ~= 'SkadaHolder' then
				DOCK.MainToolTip = "Skada";
				DOCK:RegisterMainDocklet("SkadaHolder")
				--MOD.DockedParent['Skada'] = SuperDockletMain
			end
		end;
	end;
	if main=='Omen' or alternate=='Omen' then
		if DOCK:IsDockletReady('Omen') then
			if alternate=='Omen' and SuperDockletExtra.FrameName~='OmenAnchor' then
				DOCK.ExtraToolTip = "Omen";
				DOCK:RegisterExtraDocklet("OmenAnchor")
				MOD:Docklet_Omen(SuperDockletExtra)
				MOD.DockedParent['Omen'] = SuperDockletExtra
			elseif SuperDockletMain.FrameName~='OmenAnchor' then
				DOCK.MainToolTip = "Omen";
				DOCK:RegisterMainDocklet("OmenAnchor")
				MOD:Docklet_Omen(SuperDockletMain)
				MOD.DockedParent['Omen'] = SuperDockletMain
			end
		end;
	end;
	if main=='Recount' or alternate=='Recount' then
		if DOCK:IsDockletReady('Recount') then
			if alternate=='Recount' and SuperDockletExtra.FrameName~='Recount_MainWindow' then
				DOCK.ExtraToolTip = "Recount";
				DOCK:RegisterExtraDocklet("Recount_MainWindow")
				MOD:Docklet_Recount(SuperDockletExtra)
				MOD.DockedParent['Recount'] = SuperDockletExtra
			elseif SuperDockletMain.FrameName~='Recount_MainWindow' then
				DOCK.MainToolTip = "Recount";
				DOCK:RegisterMainDocklet("Recount_MainWindow")
				MOD:Docklet_Recount(SuperDockletMain)
				MOD.DockedParent['Recount'] = SuperDockletMain
			end
		end;
	end;
	if main=='TinyDPS' or alternate=='TinyDPS' then
		if DOCK:IsDockletReady('TinyDPS') then
			if alternate=='TinyDPS' and SuperDockletExtra.FrameName~='tdpsFrame' then
				DOCK.ExtraToolTip = "TinyDPS";
				DOCK:RegisterExtraDocklet("tdpsFrame")
				MOD:Docklet_TinyDPS(SuperDockletExtra)
				MOD.DockedParent['TinyDPS'] = SuperDockletExtra
			elseif SuperDockletMain.FrameName~='tdpsFrame' then
				DOCK.MainToolTip = "TinyDPS";
				DOCK:RegisterMainDocklet("tdpsFrame")
				MOD:Docklet_TinyDPS(SuperDockletMain)
				MOD.DockedParent['TinyDPS'] = SuperDockletMain
			end
		end;
	end;
	if main=='alDamageMeter' or alternate=='alDamageMeter' then
		if DOCK:IsDockletReady('alDamageMeter') then
			if alternate=='alDamageMeter' and SuperDockletExtra.FrameName~='alDamagerMeterFrame' then
				DOCK.ExtraToolTip = "alDamageMeter";
				DOCK:RegisterExtraDocklet("alDamagerMeterFrame")
				MOD:Docklet_alDamageMeter(SuperDockletExtra)
				MOD.DockedParent['alDamageMeter'] = SuperDockletExtra
			elseif SuperDockletMain.FrameName~='alDamagerMeterFrame' then
				DOCK.MainToolTip = "alDamageMeter";
				DOCK:RegisterMainDocklet("alDamagerMeterFrame")
				MOD:Docklet_alDamageMeter(SuperDockletMain)
				MOD.DockedParent['alDamageMeter'] = SuperDockletMain
			end
		end;
	end;
end;
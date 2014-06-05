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
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local lower, trim = string.lower, string.trim
--[[ 
########################################################## 
GLOBAL/MODULE FUNCTIONS
##########################################################
]]--
function FishingMode()
	if InCombatLockdown() then SuperVillain:AddonMessage(ERR_NOT_IN_COMBAT); return; end
	if SuperVillain.Modes.CurrentMode and SuperVillain.Modes.CurrentMode == "Fishing" then SuperVillain.Modes:EndJobModes() else SuperVillain.Modes:SetJobMode("Fishing") end
end
function FarmingMode()
	if InCombatLockdown() then SuperVillain:AddonMessage(ERR_NOT_IN_COMBAT); return; end
	if SuperVillain.Modes.CurrentMode and SuperVillain.CurrentMode == "Farming" then SuperVillain.Modes:EndJobModes() else SuperVillain.Modes:SetJobMode("Farming") end
end
function ArchaeologyMode()
	if InCombatLockdown() then SuperVillain:AddonMessage(ERR_NOT_IN_COMBAT); return; end
	if SuperVillain.Modes.CurrentMode and SuperVillain.Modes.CurrentMode == "Archaeology" then SuperVillain.Modes:EndJobModes() else SuperVillain.Modes:SetJobMode("Archaeology") end
end
function CookingMode()
	if InCombatLockdown() then SuperVillain:AddonMessage(ERR_NOT_IN_COMBAT); return; end
	if SuperVillain.Modes.CurrentMode and SuperVillain.Modes.CurrentMode == "Cooking" then SuperVillain.Modes:EndJobModes() else SuperVillain.Modes:SetJobMode("Cooking") end
end
function SuperVillain:SVUIMasterCommand(msg)
	if msg then
		msg = lower(trim(msg))
		if (msg == "install") then
			SuperVillain:Install()
		elseif (msg == "move" or msg == "mentalo") then
			SuperVillain:UseMentalo()
		elseif (msg == "kb" or msg == "bind") and SuperVillain.protected.SVBar.enable then
			SuperVillain:GetModule("SVBar"):ToggleKeyBindingMode()
		elseif (msg == "reset" or msg == "resetui") then
			SuperVillain:ResetAllUI()
		elseif (msg == "fish" or msg == "fishing") then
			FishingMode()
		elseif (msg == "farm" or msg == "farming") then
			FarmingMode()
		elseif (msg == "cook" or msg == "cooking") then
			ArchaeologyMode()
		elseif (msg == "dig" or msg == "survey" or msg == "archaeology") then
			CookingMode()
		elseif (msg == "bg" or msg == "pvp") then
			local MOD = SuperVillain:GetModule('SVStats')
			MOD.ForceHideBGStats = nil;
			MOD:Generate()
			SuperVillain:AddonMessage(L['Battleground statistics will now show again if you are inside a battleground.'])
		elseif (msg == "toasty" or msg == "kombat") then
			SuperVillain:ToastyKombat()
		elseif (msg == "lol") then
			PlaySoundFile("Sound\\Character\\Human\\HumanVocalFemale\\HumanFemalePissed04.wav")
		else
			SuperVillain:ToggleConfig()
		end
	else
		SuperVillain:ToggleConfig()
	end
end

function SuperVillain:EnableAddon(addon)
	local _, _, _, _, _, reason, _ = GetAddOnInfo(addon)
	if reason ~= "MISSING" then 
		EnableAddOn(addon) 
		ReloadUI() 
	else 
		print("|cffff0000Error, Addon '"..addon.."' not found.|r") 
	end	
end

function SuperVillain:DisableAddon(addon)
	local _, _, _, _, _, reason, _ = GetAddOnInfo(addon)
	if reason ~= "MISSING" then 
		DisableAddOn(addon) 
		ReloadUI() 
	else 
		print("|cffff0000Error, Addon '"..addon.."' not found.|r") 
	end
end

function SuperVillain:LoadSlashCommands()
	SuperVillain:RegisterChatCommand("sv", "SVUIMasterCommand")
	SuperVillain:RegisterChatCommand("svui", "SVUIMasterCommand")
	SuperVillain:RegisterChatCommand("enable", "EnableAddon")
	SuperVillain:RegisterChatCommand("disable", "DisableAddon")
end
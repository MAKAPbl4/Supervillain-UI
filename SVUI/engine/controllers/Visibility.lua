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
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C = unpack(select(2, ...));
--[[ 
########################################################## 
LOCALS
##########################################################
]]--
local SecureFadeManager = CreateFrame("Frame");
local SecureFadeFrames = {};
local StealthFrame = CreateFrame("Frame");
StealthFrame:Hide();
--[[ 
########################################################## 
FRAME VISIBILITY MANAGEMENT
##########################################################
]]--
function SuperVillain:AddToDisplayAudit(frame)
    if frame.IsVisible and frame:GetName() then
        self.DisplayAudit[frame:GetName()] = true
    end 
end;

function SuperVillain:FlushDisplayAudit()
    if InCombatLockdown() then return end;
    for frame,_ in pairs(self.DisplayAudit)do 
        if _G[frame] then 
            _G[frame]:SetParent(StealthFrame)
        end 
    end;
    self:RegisterEvent("PLAYER_REGEN_DISABLED","PushDisplayAudit")
end;

function SuperVillain:PushDisplayAudit()
    if InCombatLockdown() then return end;
    for frame,_ in pairs(self.DisplayAudit)do 
        if _G[frame] then 
            _G[frame]:SetParent(UIParent)
        end 
    end;
    self:UnregisterEvent("PLAYER_REGEN_DISABLED")
end;

function SuperVillain:SecureFade_OnUpdate(value)
    local i=1;
    local this,safeFadeState;
    while SecureFadeFrames[i] do 
        this=SecureFadeFrames[i]
        safeFadeState=SecureFadeFrames[i].safeFadeState;
        safeFadeState.fadeTimer=(safeFadeState.fadeTimer or 0) + value;
        safeFadeState.fadeTimer=safeFadeState.fadeTimer + value;
        if safeFadeState.fadeTimer < safeFadeState.timeToFade then 
            if safeFadeState.mode=="IN" then 
                this:SetAlpha(safeFadeState.fadeTimer / safeFadeState.timeToFade * safeFadeState.endAlpha - safeFadeState.startAlpha + safeFadeState.startAlpha)
            elseif safeFadeState.mode=="OUT" then 
                this:SetAlpha((safeFadeState.timeToFade - safeFadeState.fadeTimer) / safeFadeState.timeToFade * safeFadeState.startAlpha - safeFadeState.endAlpha + safeFadeState.endAlpha)
            end 
        else 
            this:SetAlpha(safeFadeState.endAlpha)
            if safeFadeState.safeFadeClock and safeFadeState.safeFadeClock > 0 then 
                safeFadeState.safeFadeClock=safeFadeState.safeFadeClock - value 
            else 
                SuperVillain:SecureFadeRemoval(this)
                if safeFadeState.finishedFunc then 
                    safeFadeState.finishedFunc(safeFadeState.finishedArg1,safeFadeState.finishedArg2,safeFadeState.finishedArg3,safeFadeState.finishedArg4)
                    safeFadeState.finishedFunc=nil 
                end 
            end 
        end;
        i = i + 1; 
    end;
    if #SecureFadeFrames==0 then 
        SecureFadeManager:SetScript("OnUpdate",nil)
    end 
end;

function SuperVillain:SecureFade(this,safeFadeState)
    if not this then return end;
    if not safeFadeState.mode then 
        safeFadeState.mode="IN"
    end;
    if safeFadeState.mode=="IN" then 
        if not safeFadeState.startAlpha then 
            safeFadeState.startAlpha=0 
        end;
        if not safeFadeState.endAlpha then 
            safeFadeState.endAlpha=1.0 
        end;
    elseif safeFadeState.mode=="OUT" then 
        if not safeFadeState.startAlpha then 
            safeFadeState.startAlpha=1.0 
        end;
        if not safeFadeState.endAlpha then 
            safeFadeState.endAlpha=0 
        end;
    end;
    this:SetAlpha(safeFadeState.startAlpha)
    this.safeFadeState=safeFadeState;
    if not this:IsProtected() then this:Show() end;
    local i=1;
    while SecureFadeFrames[i] do 
        if SecureFadeFrames[i]==this then 
            return 
        end;
        i = i + 1;
    end;
    SecureFadeFrames[#SecureFadeFrames + 1] = this;
    SecureFadeManager:SetScript("OnUpdate",SuperVillain.SecureFade_OnUpdate)
end;

function SuperVillain:SecureFadeIn(this,e,f,g)
    local safeFadeState={}
    safeFadeState.mode="IN"
    safeFadeState.timeToFade=e;
    safeFadeState.startAlpha=f;
    safeFadeState.endAlpha=g;
    SuperVillain:SecureFade(this,safeFadeState)
end;

function SuperVillain:SecureFadeOut(this,e,f,g)
    local safeFadeState={}
    safeFadeState.mode="OUT"
    safeFadeState.timeToFade=e;
    safeFadeState.startAlpha=f;
    safeFadeState.endAlpha=g;
    SuperVillain:SecureFade(this,safeFadeState)
end;

function SuperVillain:SecureFadeRemoval(this)
    local i=1;
    while SecureFadeFrames[i] do 
        if this==SecureFadeFrames[i] then 
            tremove(SecureFadeFrames,i)
            break 
        else 
            i = i + 1;
        end 
    end 
end;
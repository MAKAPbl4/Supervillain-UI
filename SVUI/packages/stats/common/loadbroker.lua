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
DEFINE AND ADD PROCEDURE
##########################################################
]]--
SuperVillain.Registry:Temp("SVStats",function(MOD)
  local len=string.len;
  local hex=SuperVillain.Colors:Hex("highlight") or '|cffFFFFFF';
  local LDB=LibStub:GetLibrary("LibDataBroker-1.1");
  for dataName,dataObj in LDB:DataObjectIterator()do 
  	local OnEnter=nil;
    local OnLeave=nil;
    local lastObj=nil;
  	if dataObj.OnTooltipShow then 
  		OnEnter = function(self)
        MOD:Tip(self)
        dataObj.OnTooltipShow(MOD.tooltip)
        MOD:ShowTip()
      end 
  	end;
  	if dataObj.OnEnter then 
      OnEnter = function(self)
        MOD:Tip(self)
        dataObj.OnEnter(self)
        MOD:ShowTip()
      end 
    end;
  	if dataObj.OnLeave then 
      OnLeave = function(self)
        dataObj.OnLeave(self)
        MOD.tooltip:Hide()
      end 
    end;
  	local OnClick = function(self,e)
  		dataObj.OnClick(self,e)
  	end;
  	local CallBack = function(_,name,_,value,_)
  		if value==nil or len(value) > 5 or value=='n/a' or name==value then 
        lastObj.text:SetText(value~='n/a' and value or name)
      else 
        lastObj.text:SetText(name..': '..hex..value..'|r')
      end 
  	end;
  	local OnEvent = function(self)
  		lastObj=self;
  		LDB:RegisterCallback("LibDataBroker_AttributeChanged_"..dataName.."_text",CallBack)
  		LDB:RegisterCallback("LibDataBroker_AttributeChanged_"..dataName.."_value",CallBack)
  		LDB.callbacks:Fire("LibDataBroker_AttributeChanged_"..dataName.."_text",dataName,nil,dataObj.text,dataObj)
  	end;
  	MOD:Extend(dataName,{'PLAYER_ENTER_WORLD'},OnEvent,nil,OnClick,OnEnter,OnLeave)
  end
end)
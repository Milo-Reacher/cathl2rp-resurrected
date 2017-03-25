--[[
< CATHERINE > - A free role-playing framework for Garry's Mod.
Development and design by L7D.

Catherine is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Catherine.  If not, see <http://www.gnu.org/licenses/>.
]]--

local ITEM = catherine.item.New( "portable_radio" )
ITEM.name = "^Item_Name_PR"
ITEM.desc = "^Item_Desc_PR"
ITEM.cost = 300
ITEM.model = "models/items/battery.mdl"
ITEM.weight = 1
ITEM.category = "^Item_Category_Communication"
ITEM.itemData = {
	freq = "xxx.x",
	toggle = false
}
ITEM.func = { }
ITEM.func.setfreq = {
	text = "^Item_FuncStr01_PR",
	icon = "icon16/database_gear.png",
	canShowIsMenu = true,
	func = function( pl, itemTable )
		local itemData = pl:GetInvItemDatas( itemTable.uniqueID )
		
		catherine.util.StringReceiver( pl, "PortableRadio_UniqueSetFreq", "^Item_RadioFreqQ_PR", itemData.freq or "XXX.X", function( _, val )
			if ( val:find( "^%d%d%d%.%d$" ) ) then
				local one, two, three = val:match( "(%d)%d(%d)%.(%d)" )
				one = tonumber( one ) two = tonumber( two ) three = tonumber( three )
				
				if ( one == 1 and two > 0 and two <= 9 and three > 0 and three <= 9 ) then
					pl:SetInvItemData( itemTable.uniqueID, "freq", val )
					catherine.util.NotifyLang( pl, "Item_Notify_FreqSet_PR", val )
				else
					catherine.util.NotifyLang( pl, "Item_Notify_Error01_PR" )
				end
			else
				catherine.util.NotifyLang( pl, "Item_Notify_Error02_PR" )
			end
		end )
	end
}
ITEM.func.toggle = {
	text = "^Item_FuncStr02_PR",
	icon = "CAT/ui/accept.png",
	canShowIsMenu = true,
	func = function( pl, itemTable )
		local itemData = pl:GetInvItemDatas( itemTable.uniqueID )
		
		pl:SetInvItemData( itemTable.uniqueID, "toggle", !itemData.toggle )
	end
}

if ( CLIENT ) then
	function ITEM:DrawInformation( pl, w, h, itemData )
		if ( itemData.toggle ) then
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( Material( "CAT/ui/accept.png" ) )
			surface.DrawTexturedRect( 5, 5, 16, 16 )
		end
	end
	
	function ITEM:GetDesc( pl, itemData, isInv )
		if ( isInv and itemData ) then
			return LANG( "Item_DataStr01_PR" ) .. " : " .. ( itemData.freq and itemData.freq == "" and "xxx.x" or itemData.freq ) .. "\n" .. LANG( "Item_DataStr02_PR" ) .. " : " .. ( itemData.toggle == true and LANG( "Item_DataStr02_On_PR" ) or LANG( "Item_DataStr02_Off_PR" ) )
		end
	end
end

catherine.item.Register( ITEM )
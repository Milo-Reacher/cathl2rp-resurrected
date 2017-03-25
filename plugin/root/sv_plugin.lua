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

local PLUGIN = PLUGIN

function PLUGIN:ShowSpare2( pl )
	catherine.command.Run( pl, "&uniqueID_charRoot" )
end

function PLUGIN:RootPlayer( pl, target )
	if ( pl:IsTied( ) ) then
		catherine.util.NotifyLang( pl, "Root_Notify_CantRoot" )
		return
	end
	
	if ( !target:IsTied( ) ) then
		catherine.util.NotifyLang( pl, "Root_Notify_CantRoot" )
		return
	end
	
	pl:SetNetVar( "rooting", true )
	
	netstream.Start( pl, "catherine.hl2rp.plugin.root.OpenPanel", {
		target,
		catherine.inventory.Get( target )
	} )
end

function PLUGIN:RootWork( pl, target, workID, data )
	if ( workID == CAT_ROOT_ACTION_GIVE ) then
		local uniqueID = data.uniqueID
		local itemTable = catherine.item.FindByID( uniqueID )
		
		if ( !itemTable ) then
			catherine.util.NotifyLang( pl, "Item_Notify_NoItemData" )
			return
		end

		if ( itemTable.isPersistent ) then
			catherine.util.NotifyLang( pl, "Inventory_Notify_isPersistent" )
			return
		end
		
		local success = catherine.item.Give( target, uniqueID )
		
		if ( !success ) then
			catherine.util.NotifyLang( pl, "Inventory_Notify_HasNotSpaceTarget" )
			return
		end
		
		catherine.item.Take( pl, uniqueID )

		netstream.Start( pl, "catherine.hl2rp.plugin.root.RefreshPanel", {
			target,
			catherine.inventory.Get( target )
		} )
	elseif ( workID == CAT_ROOT_ACTION_TAKE ) then
		local uniqueID = data.uniqueID
		local itemTable = catherine.item.FindByID( uniqueID )

		if ( !itemTable ) then
			catherine.util.NotifyLang( pl, "Item_Notify_NoItemData" )
			return
		end

		if ( itemTable.isPersistent ) then
			catherine.util.NotifyLang( pl, "Inventory_Notify_isPersistent" )
			return
		end
		
		local success = catherine.item.Give( pl, uniqueID )
		
		if ( !success ) then
			catherine.util.NotifyLang( pl, "Inventory_Notify_HasNotSpace" )
			return
		end
		
		hook.Run( "PreItemForceTake", pl, target, itemTable )
		
		catherine.item.Take( target, uniqueID )
		
		hook.Run( "PostItemForceTake", pl, target, itemTable )
		
		netstream.Start( pl, "catherine.hl2rp.plugin.root.RefreshPanel", {
			target,
			catherine.inventory.Get( target )
		} )
	end
end

netstream.Hook( "catherine.hl2rp.plugin.root.Work", function( pl, data )
	PLUGIN:RootWork( pl, data[ 1 ], data[ 2 ], data[ 3 ] )
end )

netstream.Hook( "catherine.hl2rp.plugin.root.RootClose", function( pl )
	pl:SetNetVar( "rooting", false )
end )
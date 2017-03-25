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

local ITEM = catherine.item.New( "flashlight" )
ITEM.name = "^Item_Name_Flashlight"
ITEM.desc = "^Item_Desc_Flashlight"
ITEM.category = "^Item_Category_Other"
ITEM.model = "models/maxofs2d/lamp_flashlight.mdl"
ITEM.cost = 300
ITEM.weight = 0.45
ITEM.onBusinessFactions = {
	FACTION_CITIZEN
}

if ( SERVER ) then
	catherine.item.RegisterHook( "PreItemDrop", ITEM, function( pl )
		if ( pl:FlashlightIsOn( ) ) then
			pl:Flashlight( false )
		end
	end )
	
	catherine.item.RegisterHook( "PreItemStorageMove", ITEM, function( pl, ent, itemTable, data )
		if ( pl:FlashlightIsOn( ) ) then
			pl:Flashlight( false )
		end
	end )
	
	catherine.item.RegisterHook( "PreItemVendorSell", ITEM, function( pl, ent, itemTable, data )
		if ( pl:FlashlightIsOn( ) ) then
			pl:Flashlight( false )
		end
	end )
	
	catherine.item.RegisterHook( "PreItemForceTake", ITEM, function( pl, target, itemTable )
		if ( pl:FlashlightIsOn( ) ) then
			pl:Flashlight( false )
		end
	end )
end

catherine.item.Register( ITEM )
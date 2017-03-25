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

local ITEM = catherine.item.New( "ration", "FOOD" )
ITEM.name = "^Item_Name_Ration"
ITEM.desc = "^Item_Desc_Ration"
ITEM.model = "models/weapons/w_package.mdl"
ITEM.weight = 0.2
ITEM.func = { }
ITEM.func.eat = {
	text = "^Item_FuncStr01_Ration",
	icon = "icon16/arrow_out.png",
	canShowIsWorld = true,
	canShowIsMenu = true,
	func = function( pl, itemTable, ent )
		pl:EmitSound( "physics/flesh/flesh_impact_hard" .. math.random( 1, 5 ) .. ".wav" )
		
		if ( type( ent ) == "Entity" ) then
			ent:Remove( )
		else
			catherine.inventory.Work( pl, CAT_INV_ACTION_REMOVE, {
				uniqueID = itemTable.uniqueID
			} )
		end
		
		local customGiveFunc = hook.Run( "OnRationOpened", pl )
		
		if ( !customGiveFunc ) then
			catherine.item.Give( pl, "breenwater" )
			catherine.item.Give( pl, "citizen_supplement" )
			catherine.cash.Give( pl, hook.Run( "GetRationCash", pl ) or math.random( 20, 40 ) )
		end
	end
}

catherine.item.Register( ITEM )
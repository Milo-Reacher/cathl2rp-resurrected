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

local ITEM = catherine.item.New( "c17x_cold_medicine" )
ITEM.name = "^Item_Name_C17X.ColdMedicine"
ITEM.desc = "^Item_Desc_C17X.ColdMedicine"
ITEM.category = "^Item_Category_Other"
ITEM.model = "models/props_junk/glassjug01.mdl"
ITEM.cost = 150
ITEM.weight = 0.3
ITEM.func = { }
ITEM.func.use = {
	text = "^Item_FuncStr01_C17X.ColdMedicine",
	icon = "icon16/stop.png",
	canShowIsMenu = true,
	canShowIsWorld = true,
	func = function( pl, itemTable, ent )
		pl:EmitSound( "items/medshot4.wav", 80 )
		
		catherine.character.SetCharVar( pl, "disease_cold_active", nil )
		catherine.character.SetCharVar( pl, "disease_cold_countdown", nil )
		catherine.character.SetCharVar( pl, "disease_cold_protect", CurTime( ) + 300 )
		
		if ( !pl.CAT_isLimbForceMotionBlur ) then
			catherine.util.StopMotionBlur( pl )
		end
		
		if ( type( ent ) == "Entity" ) then
			ent:Remove( )
		else
			catherine.inventory.Work( pl, CAT_INV_ACTION_REMOVE, {
				uniqueID = itemTable.uniqueID
			} )
		end
	end
}

if ( CLIENT ) then
	function ITEM:DoRightClick( pl, itemData )
		catherine.item.Work( self.uniqueID, "use", true )
	end
end

catherine.item.Register( ITEM )
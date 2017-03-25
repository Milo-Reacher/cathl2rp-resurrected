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

local ITEM = catherine.item.New( "breenwater", "FOOD" )
ITEM.name = "^Item_Name_BW"
ITEM.desc = "^Item_Desc_BW"
ITEM.cost = 20
ITEM.model = "models/props_junk/PopCan01a.mdl"
ITEM.weight = 0.4
ITEM.healthAdd = 10
ITEM.staminaAdd = 30
ITEM.thirstyRemove = 20
ITEM.hungerRemove = 5
ITEM.onBusinessFactions = {
	FACTION_CWU
}
ITEM.func = { }
ITEM.func.eat = {
	text = "^Item_FuncStr02_Food",
	icon = "icon16/rainbow.png",
	canShowIsWorld = true,
	canShowIsMenu = true,
	func = function( pl, itemTable, ent )
		pl:EmitSound( type( itemTable.eatSound ) == "table" and table.Random( itemTable.eatSound ) or itemTable.eatSound )
		pl:SetHealth( math.Clamp( pl:Health( ) + ( itemTable.healthAdd or 0 ), 0, pl:GetMaxHealth( ) ) )
		
		if ( itemTable.staminaAdd != 0 ) then
			catherine.character.SetCharVar( pl, "stamina", math.Clamp( catherine.character.GetCharVar( pl, "stamina", 0 ) + itemTable.staminaAdd, 0, 100 ) )
		end
		
		if ( itemTable.hungerRemove != 0 ) then
			catherine.character.SetCharVar( pl, "hunger", math.Clamp( catherine.character.GetCharVar( pl, "hunger", 0 ) - itemTable.hungerRemove, 0, 100 ) )
		end
		
		if ( itemTable.thirstyRemove != 0 ) then
			catherine.character.SetCharVar( pl, "thirsty", math.Clamp( catherine.character.GetCharVar( pl, "thirsty", 0 ) - itemTable.thirstyRemove, 0, 100 ) )
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

catherine.item.Register( ITEM )
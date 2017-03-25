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

local ITEM = catherine.item.New( "vegetable_oil", "FOOD" )
ITEM.name = "^Item_Name_VegetableO"
ITEM.desc = "^Item_Desc_VegetableO"
ITEM.model = "models/props_junk/garbage_plasticbottle002a.mdl"
ITEM.weight = 0.4
ITEM.cost = 15
ITEM.thirstyRemove = 5
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
		local startID = pl:GetCharacterID( )
		
		pl:EmitSound( type( itemTable.eatSound ) == "table" and table.Random( itemTable.eatSound ) or itemTable.eatSound )
		
		timer.Simple( math.random( 4, 8 ), function( )
			if ( IsValid( pl ) and pl:GetCharacterID( ) == startID ) then
				local damage = math.random( 30, 70 )

				pl:TakeDamage( 10, pl, pl )
				catherine.util.ScreenColorEffect( pl, Color( 150, 150, 255 ), 0.5, 0.01 )
				catherine.character.SetCharVar( pl, "stamina", 0 )
				catherine.limb.TakeDamage( pl, HITGROUP_STOMACH, math.random( 30, 70 ) )
			end
		end )
		
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
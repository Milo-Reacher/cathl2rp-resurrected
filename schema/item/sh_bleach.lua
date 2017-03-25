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

local ITEM = catherine.item.New( "bleach", "FOOD" )
ITEM.name = "^Item_Name_Bleach"
ITEM.desc = "^Item_Desc_Bleach"
ITEM.cost = 30
ITEM.model = "models/props_junk/garbage_plasticbottle001a.mdl"
ITEM.weight = 0.5
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
				local damage = math.random( 50, 90 )
				
				catherine.limb.TakeDamage( pl, HITGROUP_HEAD, damage )
				catherine.limb.TakeDamage( pl, HITGROUP_CHEST, damage )
				catherine.limb.TakeDamage( pl, HITGROUP_STOMACH, damage )
				pl:TakeDamage( damage, pl, pl )
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
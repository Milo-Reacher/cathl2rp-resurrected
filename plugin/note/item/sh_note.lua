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

local ITEM = catherine.item.New( "note" )
ITEM.name = "^Item_Name_Note"
ITEM.desc = "^Item_Desc_Note"
ITEM.category = "^Item_Category_Other"
ITEM.model = "models/props_c17/paper01.mdl"
ITEM.cost = 100
ITEM.weight = 0.2
ITEM.onBusinessFactions = {
	FACTION_CITIZEN
}
ITEM.func = { }
ITEM.func.use = {
	text = "^Item_FuncStr01_Note",
	canShowIsMenu = true,
	func = function( pl, itemTable )
		local ent = ents.Create( "cat_hl2rp_note" )
		ent:SetPos( catherine.util.GetItemDropPos( pl ) )
		ent:Spawn( )
		ent:EmitSound( "physics/body/body_medium_impact_soft" .. math.random( 1, 7 ) .. ".wav", 70 )
		
		catherine.inventory.Work( pl, CAT_INV_ACTION_REMOVE, {
			uniqueID = itemTable.uniqueID
		} )
	end
}

catherine.item.Register( ITEM )
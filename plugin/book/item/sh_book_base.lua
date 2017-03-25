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

local BASE = catherine.item.New( "BOOK", nil, true )
BASE.name = "Book Base"
BASE.desc = "A Book Base."
BASE.category = "^Item_Category_Book"
BASE.model = "models/props_c17/paper01.mdl"
BASE.cost = 100
BASE.weight = 0.3
BASE.func = { }
BASE.func.use = {
	text = "^Item_FuncStr01_Book",
	icon = "icon16/magnifier.png",
	canShowIsWorld = true,
	func = function( pl, itemTable, ent )
		netstream.Start( pl, "catherine.hl2rp.plugin.book.OpenPanel", {
			ent:EntIndex( ),
			itemTable.uniqueID
		} )
	end
}

catherine.item.Register( BASE )
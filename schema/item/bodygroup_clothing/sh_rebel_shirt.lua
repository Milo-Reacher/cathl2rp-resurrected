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

local ITEM = catherine.item.New( "rebel_shirt", "BODYGROUP_CLOTHING" )
ITEM.name = "^Item_Name_RebelShirt"
ITEM.desc = "^Item_Desc_RebelShirt"
ITEM.cost = 220
ITEM.weight = 0.5
ITEM.bodyGroup = 1
ITEM.bodyGroupSubModelIndex = 8
ITEM.damageScale = 0.1
ITEM.model = "models/humans/tnb/items/shirt_rebel1.mdl"

catherine.item.Register( ITEM )
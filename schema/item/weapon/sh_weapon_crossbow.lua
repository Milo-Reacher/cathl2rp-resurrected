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

local ITEM = catherine.item.New( "weapon_crossbow", "WEAPON" )
ITEM.name = "^Item_Name_CB"
ITEM.desc = "^Item_Desc_CB"
ITEM.cost = 1000
ITEM.model = "models/weapons/w_crossbow.mdl"
ITEM.weight = 4
ITEM.weaponClass = "weapon_crossbow"
ITEM.weaponType = "primary"

catherine.item.Register( ITEM )
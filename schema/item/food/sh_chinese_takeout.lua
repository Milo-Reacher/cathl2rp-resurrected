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

local ITEM = catherine.item.New( "chinese_takeout", "FOOD" )
ITEM.name = "^Item_Name_ChineseT"
ITEM.desc = "^Item_Desc_ChineseT"
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl"
ITEM.weight = 0.6
ITEM.healthAdd = 15
ITEM.cost = 45
ITEM.thirstyRemove = 5
ITEM.hungerRemove = 35
ITEM.onBusinessFactions = {
	FACTION_CWU
}
ITEM.eatSound = {
	"physics/flesh/flesh_impact_hard1.wav",
	"physics/flesh/flesh_impact_hard2.wav",
	"physics/flesh/flesh_impact_hard3.wav",
	"physics/flesh/flesh_impact_hard4.wav",
	"physics/flesh/flesh_impact_hard5.wav"
}

catherine.item.Register( ITEM )
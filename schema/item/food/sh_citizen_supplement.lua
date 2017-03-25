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

local ITEM = catherine.item.New( "citizen_supplement", "FOOD" )
ITEM.name = "^Item_Name_CitizenS"
ITEM.desc = "^Item_Desc_CitizenS"
ITEM.model = "models/props_lab/jar01b.mdl"
ITEM.weight = 0.4
ITEM.cost = 30
ITEM.thirstyRemove = 30
ITEM.hungerRemove = 30
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
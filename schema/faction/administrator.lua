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

local FACTION = catherine.faction.New( "administrator" )
FACTION.name = "^Faction_Name_Administrator"
FACTION.color = Color( 237, 179, 97 )
FACTION.desc = "^Faction_Desc_Administrator"
FACTION.factionImage = "CAT_HL2RP/faction/admin_v2.png"
FACTION.salary = 400
FACTION.isWhitelist = true
FACTION.alwaysRecognized = true
FACTION.models = {
	"models/breen.mdl"
}

function FACTION:PlayerFirstSpawned( pl )
	catherine.item.Give( pl, "portable_radio" )
end

FACTION_ADMIN = catherine.faction.Register( FACTION )
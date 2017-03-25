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

local FACTION = catherine.faction.New( "cwu" )
FACTION.name = "^Faction_Name_CWU"
FACTION.color = Color( 152, 245, 255 )
FACTION.desc = "^Faction_Desc_CWU"
FACTION.factionImage = "CAT_HL2RP/faction/cwu_v2.png"
FACTION.salary = 30
FACTION.isWhitelist = true
FACTION.alwaysRecognized = true
FACTION.models = {
	"models/humans/tnb/citizens/male_01.mdl",
	"models/humans/tnb/citizens/male_02.mdl",
	"models/humans/tnb/citizens/male_03.mdl",
	"models/humans/tnb/citizens/male_04.mdl",
	"models/humans/tnb/citizens/male_05.mdl",
	"models/humans/tnb/citizens/male_06.mdl",
	"models/humans/tnb/citizens/male_07.mdl",
	"models/humans/tnb/citizens/male_08.mdl",
	"models/humans/tnb/citizens/male_09.mdl",
	"models/humans/tnb/citizens/male_10.mdl",
	"models/humans/tnb/citizens/male_11.mdl",
	"models/humans/tnb/citizens/male_12.mdl",
	"models/humans/tnb/citizens/male_13.mdl",
	"models/humans/tnb/citizens/male_14.mdl",
	"models/humans/tnb/citizens/male_15.mdl",
	"models/humans/tnb/citizens/male_16.mdl",
	"models/humans/tnb/citizens/male_18.mdl",
	"models/humans/tnb/citizens/male_20.mdl",
	"models/humans/tnb/citizens/male_21.mdl",
	"models/humans/tnb/citizens/male_22.mdl",
	"models/humans/tnb/citizens/male_23.mdl",
	"models/humans/tnb/citizens/male_24.mdl",
	"models/humans/tnb/citizens/male_25.mdl",
	"models/humans/tnb/citizens/male_26.mdl",
	"models/humans/tnb/citizens/female_01.mdl",
	"models/humans/tnb/citizens/female_02.mdl",
	"models/humans/tnb/citizens/female_03.mdl",
	"models/humans/tnb/citizens/female_04.mdl",
	"models/humans/tnb/citizens/female_05.mdl",
	"models/humans/tnb/citizens/female_06.mdl",
	"models/humans/tnb/citizens/female_07.mdl",
	"models/humans/tnb/citizens/female_08.mdl",
	"models/humans/tnb/citizens/female_10.mdl",
	"models/humans/tnb/citizens/female_11.mdl",
	"models/humans/tnb/citizens/female_12.mdl",
	"models/humans/tnb/citizens/female_14.mdl"
}

function FACTION:PlayerFirstSpawned( pl )
	catherine.cash.Give( pl, 500 )
	catherine.item.Give( pl, "cwu_shirt" )
	catherine.item.Give( pl, "cwu_pants" )
end

FACTION_CWU = catherine.faction.Register( FACTION )
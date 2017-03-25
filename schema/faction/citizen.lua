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

local FACTION = catherine.faction.New( "citizen" )
FACTION.name = "^Faction_Name_Citizen"
FACTION.color = Color( 131, 139, 131 )
FACTION.desc = "^Faction_Desc_Citizen"
FACTION.factionImage = "CAT_HL2RP/faction/citizen_v2.png"
FACTION.salary = 3
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
	local randomNum = math.random( 10000, 99999 )
	
	catherine.item.Give( pl, "cid" )
	pl:SetInvItemDatas( "cid", {
		cid = randomNum,
		name = pl:Name( )
	} )
	pl:SetCharVar( "cid", randomNum )
end

for k, v in pairs( FACTION.models ) do
	catherine.animation.Register( ( v:lower( ):find( "female" ) and "citizen_female" or "citizen_male" ), v )
end

FACTION_CITIZEN = catherine.faction.Register( FACTION )
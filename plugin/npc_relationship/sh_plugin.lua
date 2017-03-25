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
PLUGIN.name = "^NPCRelationship_Plugin_Name"
PLUGIN.author = "L7D"
PLUGIN.desc = "^NPCRelationship_Plugin_Desc"

catherine.language.Merge( "english", {
	[ "NPCRelationship_Plugin_Name" ] = "NPC Relationship",
	[ "NPCRelationship_Plugin_Desc" ] = "Added the NPC Relationship."
} )

catherine.language.Merge( "korean", {
	[ "NPCRelationship_Plugin_Name" ] = "NPC 관계",
	[ "NPCRelationship_Plugin_Desc" ] = "NPC와 플레이어들와의 관계를 생성합니다."
} )

if ( SERVER ) then
	local combineNPCClass = {
		"npc_metropolice",
		"npc_strider",
		"npc_combine_s",
		"npc_helicopter",
		"npc_manhack",
		"npc_rollermine",
		"npc_clawscanner",
		"npc_turret_ceiling",
		"npc_combinedropship",
		"npc_stalker",
		"npc_combinegunship",
		"npc_combine_camera",
		"npc_turret_floor",
		"npc_cscanner",
		"npc_turret_ground"
	}
	local rebelNPCClass = {
		"npc_citizen",
		"npc_alyx",
		"npc_vortigaunt",
		"npc_barney"
	}
	
	function PLUGIN:OnSpawnedInCharacter( pl )
		self:UpdateRelations( pl )
	end
	
	function PLUGIN:PlayerSpawnedNPC( pl, ent )
		for k, v in pairs( player.GetAll( ) ) do
			self:UpdateRelations( v )
		end
	end
	
	function PLUGIN:UpdateRelations( pl )
		for k, v in pairs( ents.FindByClass( "npc_*" ) ) do
			if ( table.HasValue( combineNPCClass, v:GetClass( ):lower( ) ) ) then
				v:AddEntityRelationship( pl, pl:PlayerIsCombine( ) and D_LI or D_HT )
			elseif ( table.HasValue( rebelNPCClass, v:GetClass( ):lower( ) ) ) then
				v:AddEntityRelationship( pl, pl:PlayerIsCombine( ) and D_HT or D_LI )
			end
		end
	end
end
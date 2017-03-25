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

AddCSLuaFile( )

ENT.Type = "anim"
ENT.PrintName = "Catherine HL2RP Breach"
ENT.Author = "L7D"
ENT.Spawnable = false
ENT.AdminSpawnable = false

if ( SERVER ) then
	function ENT:Initialize( )
		self:SetModel( "models/props_wasteland/prison_padlock001a.mdl" )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:DrawShadow( false )
		
		local physObject = self:GetPhysicsObject( )

		if ( IsValid( physObject ) ) then
			physObject:Wake( )
		end
		
		catherine.entity.RegisterUseMenu( self, {
			{
				uniqueID = "ID_BLAST",
				text = "^Breach_BlastStr",
				icon = "icon16/lock_open.png",
				func = function( pl, ent )
					if ( IsValid( self:GetParent( ) ) ) then
						catherine.util.ForceDoorOpen( self:GetParent( ) )
						self:Explode( )
						self:CreateDummyBreach( )
						self:Remove( )
					end
				end
			}
		} )
	end
	
	function ENT:Explode( )
		local eff = EffectData( )
		eff:SetStart( self:GetPos( ) )
		eff:SetOrigin( self:GetPos( ) )
		eff:SetScale( 6 )
		util.Effect( "HelicopterMegaBomb", eff, true, true )

		self:EmitSound( "physics/wood/wood_furniture_break" .. math.random( 1, 2 ) .. ".wav" )
	end
	
	function ENT:CreateDummyBreach( )
		local dummyEnt = ents.Create( "prop_physics" )
		dummyEnt:SetPos( self:GetPos( ) )
		dummyEnt:SetCollisionGroup( COLLISION_GROUP_WORLD )
		dummyEnt:SetAngles( self:GetAngles( ) )
		dummyEnt:SetModel( "models/props_wasteland/prison_padlock001b.mdl" )
		dummyEnt:Spawn( )
		
		timer.Simple( 10, function( )
			if ( IsValid( dummyEnt ) ) then
				dummyEnt:Remove( )
			end
		end )
	end
end
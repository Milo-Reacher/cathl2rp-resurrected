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
ENT.PrintName = "Catherine HL2RP Ration Dispenser"
ENT.Author = "Chessnut, L7D"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables( )
	self:NetworkVar( "Bool", 1, "Active" )
	self:NetworkVar( "Int", 0, "ForceMode" )
end

if ( SERVER ) then
	function ENT:Initialize( )
		self:SetModel( "models/props_junk/gascan001a.mdl" )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:DrawShadow( false )
		
		local dummyEnt = ents.Create( "prop_dynamic" )
		dummyEnt:SetModel( "models/props_combine/combine_dispenser.mdl" )
		dummyEnt:SetPos( self:GetPos( ) )
		dummyEnt:SetAngles( self:GetAngles( ) )
		dummyEnt:SetParent( self )
		dummyEnt:Spawn( )
		dummyEnt:Activate( )
		
		self.dummyEnt = dummyEnt
		
		self:DeleteOnRemove( self.dummyEnt )
		
		local physObject = self:GetPhysicsObject( )
		
		if ( IsValid( physObject ) ) then
			physObject:EnableMotion( false )
			physObject:Sleep( )
		end
	end
	
	function ENT:CreateRation( )
		self:EmitSound( "ambient/machines/combine_terminal_idle4.wav" )
		
		local ent = ents.Create( "prop_physics" )
		ent:SetModel( "models/weapons/w_package.mdl" )
		ent:Fire( "SetParentAttachment", "package_attachment" )
		ent:SetPos( self:GetPos( ) + self:GetForward( ) * -15 + self:GetUp( ) * -20 )
		ent:SetAngles( self:GetAngles( ) )
		ent:SetParent( self.dummyEnt )
		ent:SetNotSolid( true )
		ent:Spawn( )
		
		timer.Simple( 2, function( )
			if ( IsValid( self ) and IsValid( ent ) ) then
				ent:Remove( )
				catherine.item.Spawn( "ration", ent:GetPos( ) + self:GetForward( ) * 2 + self:GetUp( ) * -10, ent:GetAngles( ) )
				self.working = false
				self:SetForceMode( 0 )
			end
		end )
	end
	
	function ENT:Use( pl )
		if ( self.working or ( self.nextCanUse or 0 ) >= CurTime( ) ) then return end
		
		if ( pl:Team( ) == FACTION_CITIZEN ) then
			if ( self:GetActive( ) ) then
				if ( pl:GetNetVar( "dispenseTime", CurTime( ) ) <= CurTime( ) ) then
					if ( pl:HasItem( "cid" ) ) then
						self.working = true
						self:EmitSound( "ambient/machines/combine_terminal_idle2.wav" )
						self:SetForceMode( 1 )
						
						timer.Simple( 5 + math.random( 2, 5 ), function( )
							if ( !IsValid( self ) or !IsValid( pl ) ) then
								self.working = false
								return
							end
							
							pl:SetNetVar( "dispenseTime", CurTime( ) + 900 )
							self:CreateRation( )
							self.dummyEnt:Fire( "SetAnimation", "dispense_package", 0 )
						end )
					else
						self:EmitSound( "buttons/combine_button_locked.wav" )
						self.working = true
						self:SetForceMode( 2 )
						
						timer.Simple( 2, function( )
							if ( !IsValid( self ) ) then return end
							
							self.working = false
							self:SetForceMode( 0 )
						end )
					end
				else
					self:EmitSound( "buttons/combine_button_locked.wav" )
					self.working = true
					self:SetForceMode( 2 )
					
					timer.Simple( 2, function( )
						if ( !IsValid( self ) ) then return end
						
						self.working = false
						self:SetForceMode( 0 )
					end )
				end
			else
				self:EmitSound( "buttons/combine_button_locked.wav" )
				self.working = true
				self:SetForceMode( 2 )
				
				timer.Simple( 2, function( )
					if ( !IsValid( self ) ) then return end
					
					self.working = false
					self:SetForceMode( 0 )
				end )
			end
		elseif ( pl:PlayerIsCombine( ) ) then
			self:SetActive( !self:GetActive( ) )
			
			self:EmitSound( self:GetActive( ) and "buttons/combine_button1.wav" or "buttons/combine_button2.wav" )
		end
		
		self.nextCanUse = CurTime( ) + 1
	end
	
else
	local glowMat = Material( "sprites/glow04_noz" )
	
	function ENT:Draw( )
		local forceMode = self:GetForceMode( )
		local col
		
		if ( forceMode == 0 ) then
			col = self:GetActive( ) and Color( 150, 255, 150 ) or Color( 255, 0, 0 )
		elseif ( forceMode == 1 ) then
			col = Color( 255, 255, 0 )
		elseif ( forceMode == 2 ) then
			col = Color( 255, 0, 0 )
		end
		
		render.SetMaterial( glowMat )
		render.DrawSprite( self:GetPos( ) + self:GetForward( ) * 10 + self:GetRight( ) * 5 + self:GetUp( ) * 13, 20, 20, col )
	end
end
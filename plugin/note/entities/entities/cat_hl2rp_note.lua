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

AddCSLuaFile( )

ENT.Type = "anim"
ENT.PrintName = "Catherine HL2RP Notepad"
ENT.Author = "L7D"
ENT.Spawnable = false
ENT.AdminSpawnable = false

if ( SERVER ) then
	function ENT:Initialize( )
		self:SetModel( "models/props_c17/paper01.mdl" )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:SetHealth( 40 )
		
		local physObject = self:GetPhysicsObject( )
		
		if ( IsValid( physObject ) ) then
			physObject:EnableMotion( true )
			physObject:Wake( )
			physObject:SetMass( 80 )
		end
		
		catherine.entity.RegisterUseMenu( self, {
			{
				uniqueID = "ID_VIEW",
				text = "^Note_ViewStr",
				icon = "icon16/note.png",
				func = function( pl, ent )
					netstream.Start( pl, "catherine.hl2rp.plugin.note.OpenPanel", {
						self:EntIndex( ),
						PLUGIN:GetText( self:GetUniqueID( ) )
					} )
				end
			}
		} )
	end
	
	function ENT:Bomb( )
		local eff = EffectData( )
		eff:SetStart( self:GetPos( ) )
		eff:SetOrigin( self:GetPos( ) )
		eff:SetScale( 8 )
		util.Effect( "GlassImpact", eff, true, true )
		
		self:EmitSound( "physics/body/body_medium_impact_soft" .. math.random( 1, 7 ) .. ".wav" )
	end
	
	function ENT:OnTakeDamage( dmg )
		self:SetHealth( math.max( self:Health( ) - dmg:GetDamage( ), 0 ) )
		
		if ( self:Health( ) <= 0 ) then
			self:Bomb( )
			self:Remove( )
		end
	end
	
	function ENT:OnRemove( )
		if ( catherine.shuttingDown ) then return end
		local uniqueID = self:GetUniqueID( )
		
		if ( PLUGIN.data[ uniqueID ] ) then
			PLUGIN.data[ uniqueID ] = nil
			PLUGIN:DataSave( )
		end
	end
else
	local toscreen = FindMetaTable( "Vector" ).ToScreen
	
	function ENT:DrawEntityTargetID( pl, ent, a )
		local pos = toscreen( self:LocalToWorld( self:OBBCenter( ) ) )
		local x, y = pos.x, pos.y
		
		if ( !self.notepad_title or !self.notepad_desc ) then
			self.notepad_title = LANG( "Item_Name_Note" )
			self.notepad_desc = LANG( "Entity_Desc_Note01" )
		end
		
		draw.SimpleText( self.notepad_title, "catherine_outline20", x, y, Color( 255, 255, 255, a ), 1, 1 )
		draw.SimpleText( self.notepad_desc, "catherine_outline15", x, y + 25, Color( 255, 255, 255, a ), 1, 1 )
	end
	
	function ENT:LanguageChanged( )
		self.notepad_title = LANG( "Item_Name_Note" )
		self.notepad_desc = nil
	end
end

function ENT:CanEdit( pl )
	local owner = self:GetNetVar( "owner", 0 )
	
	if ( owner == pl:GetCharacterID( ) ) then
		return true
	else
		return owner == 0 and true or false
	end
end

function ENT:GetUniqueID( )
	return self:GetNetVar( "uniqueID", 0 )
end
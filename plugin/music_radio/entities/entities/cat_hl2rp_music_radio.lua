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
ENT.PrintName = "Catherine HL2RP Music Radio"
ENT.Author = "L7D"
ENT.Spawnable = false
ENT.AdminSpawnable = false

if ( SERVER ) then
	function ENT:Initialize( )
		self:SetModel( "models/props_lab/citizenradio.mdl" )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:SetHealth( 150 )
		self:SetNetVar( "active", false )
		self:SetNetVar( "musicURL", table.Random( PLUGIN.radioStations ) )
		self:SetNetVar( "currIndex", 1 )
		
		local physObject = self:GetPhysicsObject( )
		
		if ( IsValid( physObject ) ) then
			physObject:EnableMotion( true )
			physObject:Wake( )
			physObject:SetMass( 80 )
		end
		
		catherine.entity.RegisterUseMenu( self, {
			{
				uniqueID = "ID_CHANGEMUSIC",
				text = "^Item_FuncStr02_MusicRadio",
				icon = "icon16/cog_edit.png",
				func = function( pl, ent )
					if ( self:GetNetVar( "active", false ) == true ) then
						self:ChangeMusic( )
					end
				end
			},
			{
				uniqueID = "ID_TOGGLE",
				text = "^Item_FuncStr03_MusicRadio",
				icon = "CAT/ui/accept.png",
				func = function( pl, ent )
					self:SetNetVar( "active", !self:GetNetVar( "active", false ) )
					
					if ( self:GetNetVar( "active", false ) == true ) then
						self:PlayMusic( )
					else
						self:StopMusic( )
					end
				end
			},
			{
				uniqueID = "ID_CHANGEVOLIME",
				text = "^Item_FuncStr04_MusicRadio",
				icon = "icon16/sound.png",
				func = function( pl, ent )
					catherine.util.StringReceiver( pl, "MusicRadio_ChangeVolume", "^Item_VolumeQ_MusicRadio", self:GetNetVar( "volume", 100 ), function( _, val )
						val = tonumber( val )
						
						if ( !val or val <= 0 or val > 100 ) then
							catherine.util.NotifyLang( pl, "Item_VolumeQ_Notify_MusicRadio" )
							return
						end
						
						self:SetNetVar( "volume", val )
						
						if ( self:GetNetVar( "active", false ) == true ) then
							self:ChangeVolume( )
						end
					end )
				end
			}
		} )
	end
	
	function ENT:OnRemove( )
		netstream.Start( nil, "catherine.hl2rp.plugin.musicRadio.StopMusic", self )
		
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
			self:Remove( )
		end
	end
	
	function ENT:PlayMusic( )
		netstream.Start( nil, "catherine.hl2rp.plugin.musicRadio.PlayMusic", self )
	end
	
	function ENT:StopMusic( )
		netstream.Start( nil, "catherine.hl2rp.plugin.musicRadio.StopMusic", self )
	end
	
	function ENT:ChangeVolume( )
		netstream.Start( nil, "catherine.hl2rp.plugin.musicRadio.ChangeVolume", self )
	end
	
	function ENT:ChangeMusic( )
		local index = self:GetNetVar( "currIndex", 1 )
		
		if ( #PLUGIN.radioStations != 0 ) then
			if ( index < #PLUGIN.radioStations ) then
				self:SetNetVar( "musicURL", PLUGIN.radioStations[ index + 1 ] )
				self:SetNetVar( "currIndex", index + 1 )
			else
				self:SetNetVar( "musicURL", PLUGIN.radioStations[ 1 ] )
				self:SetNetVar( "currIndex", 1 )
			end
		end
		
		netstream.Start( nil, "catherine.hl2rp.plugin.musicRadio.ChangeMusic", self )
		
		for i = 1, 2 do
			timer.Simple( i, function( )
				self:EmitSound( "ambient/levels/prison/radio_random" .. math.random( 1, 9 ) .. ".wav", 80 )
			end )
		end
	end
else
	local glowMat = Material( "sprites/glow04_noz" )
	local toscreen = FindMetaTable( "Vector" ).ToScreen
	local soundChanel = { }
	local soundChanelAni = { }
	
	function ENT:Draw( )
		self:DrawModel( )
		
		if ( catherine.util.CalcDistanceByPos( catherine.pl, self ) > 1000 ) then return end
		
		local ang = self:GetAngles( )
		ang:RotateAroundAxis( ang:Up( ), 90 )
		ang:RotateAroundAxis( ang:Forward( ), 90 )
		
		cam.Start3D2D( self:GetPos( ) + self:GetForward( ) * 8.5 + self:GetRight( ) * 5.7 + self:GetUp( ) * 15.5, ang, 0.06 )
			local volume = self:GetNetVar( "volume", "100" )
			
			draw.RoundedBox( 0, 0, 0, 290, 70, Color( 50, 50, 50, 255 ) )
			
			if ( IsValid( self.soundEnt ) ) then
				local start = 0
				
				self.soundEnt:FFT( soundChanel, FFT_1024 )
				
				for k, v in pairs( soundChanel ) do
					if ( start <= 290 ) then
						if ( !soundChanelAni[ k ] ) then soundChanelAni[ k ] = 0 end
						
						soundChanelAni[ k ] = Lerp( 0.3, soundChanelAni[ k ], math.Clamp( v * 200, 0, 60 ) )
						
						draw.RoundedBox( 0, start, 65 - soundChanelAni[ k ], 5, soundChanelAni[ k ], Color( 255, 255, 255, 100 ) )
						start = start + 6
					end
				end
			end
			
			if ( self:GetNetVar( "active" ) ) then
				if ( !self.mr_playing or !self.playingText ) then
					self.mr_playing = LANG( "Item_PlayingUI_MusicRadio" )
					self.playingText = ""
				end
				
				if ( ( self.nextPlayingText or 0 ) <= CurTime( ) ) then
					if ( #self.playingText >= 3 ) then
						self.playingText = ""
					else
						self.playingText = self.playingText .. "."
					end
					
					self.nextPlayingText = CurTime( ) + 0.5
				end
				
				draw.SimpleText( self.mr_playing .. self.playingText, "catherine_normal30", 15, 30, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, 1 )
			else
				if ( !self.mr_stop ) then
					self.mr_stop = LANG( "Item_StopUI_MusicRadio" )
				end
				
				draw.SimpleText( self.mr_stop, "catherine_normal30", 15, 30, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, 1 )
			end
			
			draw.SimpleText( volume .. "%", "catherine_normal50", 270, 30, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, 1 )
		cam.End3D2D( )
		
		local col = Color( 255, 0, 0 )
		
		if ( self:GetNetVar( "active" ) ) then
			col = Color( 0, 255, 0 )
		end
		
		render.SetMaterial( glowMat )
		render.DrawSprite( self:GetPos( ) + self:GetForward( ) * 10 + self:GetRight( ) * 10 + self:GetUp( ) * 4, 10, 10, col )
	end
	
	function ENT:Think( )
		if ( self:GetNetVar( "active", false ) == true ) then
			if ( IsValid( self.soundEnt ) ) then
				if ( ( self.nextPosSet or 0 ) <= CurTime( ) ) then
					self.soundEnt:SetPos( self:GetPos( ) )
					self.nextPosSet = CurTime( ) + 1
				end
			else
				if ( !self.donotThink ) then
					self.donotThink = true
					
					sound.PlayURL( self:GetNetVar( "musicURL", "http://www.kcrw.com/pls/kcrwmusic.pls" ), "3d", function( ent )
						if ( IsValid( ent ) ) then
							ent:SetPos( self:GetPos( ) )
							ent:Play( )
							ent:SetVolume( self:GetNetVar( "volume", 100 ) / 100 )
							
							self.soundEnt = ent
							self.donotThink = false
						end
					end )
				end
			end
		end
	end
	
	function ENT:DrawEntityTargetID( pl, ent, a )
		local pos = toscreen( self:LocalToWorld( self:OBBCenter( ) ) )
		local x, y = pos.x, pos.y
		
		if ( !self.mr_name or !self.mr_desc ) then
			self.mr_name = LANG( "Item_Name_MusicRadio" )
			self.mr_desc = LANG( "Item_Desc_MusicRadio" )
		end
		
		draw.SimpleText( self.mr_name, "catherine_outline20", x, y, Color( 255, 255, 255, a ), 1, 1 )
		draw.SimpleText( self.mr_desc, "catherine_outline15", x, y + 20, Color( 255, 255, 255, a ), 1, 1 )
	end
	
	function ENT:LanguageChanged( )
		self.mr_name = LANG( "Item_Name_MusicRadio" )
		self.mr_desc = LANG( "Item_Desc_MusicRadio" )
		self.mr_playing = LANG( "Item_PlayingUI_MusicRadio" )
	end
	
	netstream.Hook( "catherine.hl2rp.plugin.musicRadio.ChangeVolume", function( data )
		if ( IsValid( data.soundEnt ) ) then
			data.soundEnt:SetVolume( data:GetNetVar( "volume", 100 ) / 100 )
		else
			data.donotThink = true
			
			sound.PlayURL( data:GetNetVar( "musicURL", "http://www.kcrw.com/pls/kcrwmusic.pls" ), "3d", function( ent )
				if ( IsValid( ent ) and IsValid( data ) ) then
					ent:SetPos( data:GetPos( ) )
					ent:Play( )
					ent:SetVolume( data:GetNetVar( "volume", 100 ) / 100 )
					
					data.soundEnt = ent
					data.donotThink = false
				end
			end )
		end
	end )
	
	netstream.Hook( "catherine.hl2rp.plugin.musicRadio.ChangeMusic", function( data )
		if ( IsValid( data.soundEnt ) ) then
			data.soundEnt:Stop( )
			data.soundEnt = nil
			data.donotThink = true
			
			local timerID = "catherine.hl2rp.plugin.musicRadio.ChangeMusicDelay." .. data:EntIndex( )
			
			timer.Remove( timerID )
			timer.Create( timerID, 2, 1, function( )
				if ( !IsValid( data ) ) then return end
				
				sound.PlayURL( data:GetNetVar( "musicURL", "http://www.kcrw.com/pls/kcrwmusic.pls" ), "3d", function( ent )
					if ( IsValid( ent ) and IsValid( data ) ) then
						ent:SetPos( data:GetPos( ) )
						ent:Play( )
						ent:SetVolume( data:GetNetVar( "volume", 100 ) / 100 )
						
						data.soundEnt = ent
						data.donotThink = false
					end
				end )
			end )
		else
			local timerID = "catherine.hl2rp.plugin.musicRadio.ChangeMusicDelay." .. data:EntIndex( )
			
			timer.Remove( timerID )
			timer.Create( timerID, 2, 1, function( )
				if ( !IsValid( data ) ) then return end
				
				sound.PlayURL( data:GetNetVar( "musicURL", "http://www.kcrw.com/pls/kcrwmusic.pls" ), "3d", function( ent )
					if ( IsValid( ent ) and IsValid( data ) ) then
						ent:SetPos( data:GetPos( ) )
						ent:Play( )
						ent:SetVolume( data:GetNetVar( "volume", 100 ) / 100 )
						
						data.soundEnt = ent
					end
				end )
			end )
		end
	end )
	
	netstream.Hook( "catherine.hl2rp.plugin.musicRadio.PlayMusic", function( data )
		data.donotThink = true
		
		if ( !IsValid( data.soundEnt ) ) then
			sound.PlayURL( data:GetNetVar( "musicURL", "http://www.kcrw.com/pls/kcrwmusic.pls" ), "3d", function( ent )
				if ( IsValid( ent ) and IsValid( data ) ) then
					if ( IsValid( data.soundEnt ) or !data.musicStop ) then
						ent:Stop( )
					else
						ent:SetPos( data:GetPos( ) )
						ent:Play( )
						ent:SetVolume( data:GetNetVar( "volume", 100 ) / 100 )
						
						data.soundEnt = ent
						data.donotThink = false
						data.musicStop = false
					end
				end
			end )
		end
	end )
	
	netstream.Hook( "catherine.hl2rp.plugin.musicRadio.StopMusic", function( data )
		if ( IsValid( data.soundEnt ) ) then
			data.soundEnt:Stop( )
			data.soundEnt = nil
		end
		
		data.musicStop = true
	end )
end
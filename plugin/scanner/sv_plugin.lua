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

function PLUGIN:PlayerDeath( pl )
	local ent = self:GetScannerEntity( pl )
	
	if ( IsValid( ent ) ) then
		pl.CAT_deathBody:Remove( )
		ent:TakeDamage( 999 )
	end
end

function PLUGIN:CharacterLoadingStart( pl )
	local ent = self:GetScannerEntity( pl )
	
	if ( IsValid( ent ) ) then
		catherine.player.SetIgnoreGiveFlagWeapon( pl, nil )
		pl:SetViewEntity( NULL )
		pl:UnSpectate( )
		
		pl:SetNetVar( "fakeModel", nil )
		pl:SetNetVar( "isScanner", nil )
		
		ent.CAT_HL2RP_scannerNoSpawn = true
		ent:Remove( )
		pl.CAT_HL2RP_scannerEnt = nil
	end
end

function PLUGIN:PlayerShouldDrown( pl )
	if ( IsValid( self:GetScannerEntity( pl ) ) ) then
		return false
	end
end

function PLUGIN:PlayerCanNoClip( pl )
	if ( IsValid( self:GetScannerEntity( pl ) ) ) then
		return false
	end
end

function PLUGIN:PlayerUse( pl )
	if ( IsValid( self:GetScannerEntity( pl ) ) ) then
		return false
	end
end

function PLUGIN:PlayerShouldOpenRecognizeOrDoorMenu( pl )
	if ( IsValid( self:GetScannerEntity( pl ) ) ) then
		return false
	end
end

function PLUGIN:PlayerShouldWorkItem( pl, itemTable, workID )
	if ( IsValid( self:GetScannerEntity( pl ) ) ) then
		if ( itemTable.uniqueID != "portable_radio" ) then
			catherine.util.NotifyLang( pl, "Scanner_Notify_CantWork" )
			return false
		end
	end
end

function PLUGIN:CombineClassSetFinished( pl )
	if ( pl:Name( ):find( "SCN" ) ) then
		catherine.class.Set( pl, CLASS_CP_SCN )
		
		if ( !IsValid( self:GetScannerEntity( pl ) ) ) then
			self:CreateScanner( pl )
		end
	end
end

function PLUGIN:CombineClassSetFinishedOnNameChanged( pl )
	if ( pl:Name( ):find( "SCN" ) ) then
		catherine.class.Set( pl, CLASS_CP_SCN )
		
		if ( !IsValid( self:GetScannerEntity( pl ) ) ) then
			self:CreateScanner( pl )
		end
	end
end

function PLUGIN:PlayerShouldWorkRagdoll( pl, status, time )
	if ( !IsValid( self:GetScannerEntity( pl ) ) ) then return end
	
	catherine.util.NotifyLang( pl, "Scanner_Notify_CantWork" )
	return false
end

function PLUGIN:PlayerShouldRecoverHealth( pl )
	if ( IsValid( self:GetScannerEntity( pl ) ) ) then
		return false
	end
end

function PLUGIN:PlayerTick( pl )
	if ( IsValid( self:GetScannerEntity( pl ) ) ) then
		if ( ( pl.CAT_HL2RP_nextWaterCheckTick or 0 ) <= CurTime( ) ) then
			if ( pl:Alive( ) and pl:WaterLevel( ) >= 3 ) then
				self:PlayerDeath( pl )
			end
			
			pl.CAT_HL2RP_nextWaterCheckTick = CurTime( ) + 1
		end
	else
		if ( pl.CAT_HL2RP_nextWaterCheckTick ) then
			pl.CAT_HL2RP_nextWaterCheckTick = nil
		end
	end
end

function PLUGIN:CharacterNameChanged( pl, newName )
	if ( pl:Team( ) != FACTION_CP ) then return end
	
	if ( newName:find( "SCN" ) ) then
		catherine.class.Set( pl, CLASS_CP_SCN )
		
		if ( !IsValid( self:GetScannerEntity( pl ) ) ) then
			self:CreateScanner( pl )
		end
	else
		Schema:CharacterNameChanged( pl, newName )
		
		local ent = self:GetScannerEntity( pl )
		
		if ( IsValid( ent ) ) then
			ent:Remove( )
			pl.CAT_HL2RP_scannerEnt = nil
		end
	end
end

function PLUGIN:PostCleanupMapDelayed( )
	for k, v in pairs( player.GetAllByLoaded( ) ) do
		if ( v:Team( ) != FACTION_CP ) then continue end
		
		if ( v:Name( ):find( "SCN" ) ) then
			if ( !IsValid( self:GetScannerEntity( v ) ) ) then
				self:CreateScanner( v )
			end
		end
	end
end

local SCANNER_EMITSOUNDS = {
	"npc/scanner/scanner_scan1.wav",
	"npc/scanner/scanner_scan2.wav",
	"npc/scanner/scanner_scan4.wav",
	"npc/scanner/scanner_scan5.wav",
	"npc/scanner/combat_scan1.wav",
	"npc/scanner/combat_scan2.wav",
	"npc/scanner/combat_scan3.wav",
	"npc/scanner/combat_scan4.wav",
	"npc/scanner/combat_scan5.wav",
	"npc/scanner/scanner_blip1.wav",
	"npc/scanner/cbot_servoscared.wav",
	"npc/scanner/cbot_servochatter.wav"
}

function PLUGIN:KeyPress( pl, key )
	local ent = self:GetScannerEntity( pl )
	
	if ( IsValid( ent ) and ( pl.CAT_HL2RP_scannerKeyDelay or 0 ) <= CurTime( ) ) then
		local sound

		if ( key == IN_USE ) then
			sound = table.Random( SCANNER_EMITSOUNDS )
			pl.CAT_HL2RP_scannerKeyDelay = CurTime( ) + 1.75
		elseif ( key == IN_RELOAD ) then
			sound = "npc/scanner/scanner_talk" .. math.random( 1, 2 ) .. ".wav"
			pl.CAT_HL2RP_scannerKeyDelay = CurTime( ) + 10
		elseif ( key == IN_WALK ) then
			if ( pl:GetViewEntity( ) == ent ) then
				pl:SetViewEntity( NULL )
			else
				pl:SetViewEntity( ent )
			end
		end

		if ( sound ) then
			ent:EmitSound( sound )
		end
	end
end

function PLUGIN:CreateScanner( pl )
	if ( IsValid( self:GetScannerEntity( pl ) ) ) then return end
	
	local ent = ents.Create( "npc_cscanner" )
	ent:SetPos( pl:GetPos( ) )
	ent:SetAngles( pl:GetAngles( ) )
	ent:SetColor( pl:GetColor( ) )
	ent:Spawn( )
	ent:Activate( )
	ent:SetNetVar( "player", pl )
	ent:CallOnRemove( "PlayerRestore", function( )
		if ( !IsValid( pl ) ) then return end
		if ( ent.CAT_HL2RP_scannerNoSpawn ) then return end
		
		catherine.player.SetIgnoreGiveFlagWeapon( pl, nil )
		pl:SetViewEntity( NULL )
		pl:UnSpectate( )
		
		pl:SetNetVar( "fakeModel", nil )
		pl:SetNetVar( "isScanner", nil )
		
		if ( ent:Health( ) > 0 ) then
			pl:Spawn( )
		else
			pl:KillSilent( )
		end
		
		timer.Simple( 0, function( )
			pl:SetPos( ent.CAT_HL2RP_latestPos or pl:GetPos( ) )
		end )
	end )
	
	local trackName = "CAT_HL2RP_Scanner_" .. os.clock( )
	ent.CAT_HL2RP_trackName = trackName
	
	local track = ents.Create( "path_track" )
	track:SetPos( ent:GetPos( ) )
	track:SetName( trackName )
	track:Spawn( )
	
	ent:Fire( "SetFollowTarget", trackName )
	ent:Fire( "InputShouldInspect", false )
	ent:Fire( "SetDistanceOverride", "48" )
	ent:SetKeyValue( "SpawnFlags", 8208 )
	
	pl:SetNetVar( "fakeModel", ent:GetModel( ) )
	pl:SetNetVar( "isScanner", true )
	
	pl.CAT_HL2RP_scannerEnt = ent
	pl:StripWeapons( )
	catherine.player.SetIgnoreGiveFlagWeapon( pl, true )
	pl:Spectate( OBS_MODE_CHASE )
	pl:SpectateEntity( ent )
	pl:SetNoDraw( true )
	pl:SetNotSolid( true )
	
	local timerID = "Catherine.HL2RP.timer.ScannerTick." .. pl:SteamID( )
	
	timer.Create( timerID, 0.4, 0, function( )
		if ( !IsValid( pl ) or !IsValid( ent ) ) then
			if ( IsValid( ent ) ) then
				ent:Remove( )
			end
			
			timer.Remove( timerID )
			return
		end
		
		local vel = pl:KeyDown( IN_SPEED ) and 64 or 128
		local changed = false
		
		if ( pl:KeyDown( IN_FORWARD ) ) then
			track:SetPos( ( ent:GetPos( ) + pl:GetAimVector( ) * vel ) - Vector( 0, 0, 64 ) )
			changed = true
		elseif ( pl:KeyDown( IN_BACK ) ) then
			track:SetPos( ( ent:GetPos( ) + pl:GetAimVector( ) * -vel ) - Vector( 0, 0, 64 ) )
			changed = true
		elseif ( pl:KeyDown( IN_JUMP ) ) then
			track:SetPos( ent:GetPos( ) + Vector( 0, 0, vel ) )
			changed = true	
		elseif ( pl:KeyDown( IN_DUCK ) ) then
			track:SetPos( ent:GetPos( ) - Vector( 0, 0, vel ) )
			changed = true			
		end
		
		if ( changed ) then
			ent:Fire( "SetFollowTarget", trackName )
		end
		
		pl:SetPos( ent:GetPos( ) )
	end )
	
	return ent
end

function PLUGIN:GetScannerEntity( pl )
	return pl.CAT_HL2RP_scannerEnt
end

netstream.Hook( "catherine.hl2rp.plugin.scanner.ReceiveCaptureData", function( pl, data )
	local combines = Schema:GetCombines( )
	
	pl:GetViewEntity( ):EmitSound( "npc/scanner/scanner_photo1.wav", 140 )
	pl:EmitSound( "npc/scanner/combat_scan5.wav" )
	
	for k, v in ipairs( combines ) do
		if ( !v:Alive( ) or v == pl or IsValid( PLUGIN:GetScannerEntity( v ) ) ) then continue end
		
		v:EmitSound( "npc/overwatch/radiovoice/preparevisualdownload.wav" )
	end
	
	netstream.Start( combines, "catherine.hl2rp.plugin.scanner.BroadcastCaptureData", {
		caller = pl,
		captureData = data
	} )
end )
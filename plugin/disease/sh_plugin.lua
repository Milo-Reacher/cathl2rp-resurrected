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
PLUGIN.name = "^Disease_Plugin_Name"
PLUGIN.author = "L7D"
PLUGIN.desc = "^Disease_Plugin_Desc"

catherine.language.Merge( "english", {
	[ "Disease_Plugin_Name" ] = "Disease",
	[ "Disease_Plugin_Desc" ] = "Added the Disease.",
	[ "Disease_UI_Notify" ] = "You have cold symptoms.",
	[ "Disease_UI_Notify2" ] = "You are immune to cold.",
	[ "Disease_Me_Chat" ] = "*coughs*",
	[ "Disease_Critical_Me_Chat" ] = "*severe coughs*",
	[ "Item_Name_ColdMedicine" ] = "Cold Medicine",
	[ "Item_Desc_ColdMedicine" ] = "Cure colds.",
	[ "Item_FuncStr01_ColdMedicine" ] = "Use",
	[ "Item_Name_C17X.ColdMedicine" ] = "C17X Cold Medicine",
	[ "Item_Desc_C17X.ColdMedicine" ] = "Cure colds and protect your body from the cold for short time.",
	[ "Item_FuncStr01_C17X.ColdMedicine" ] = "Use"
} )

catherine.language.Merge( "korean", {
	[ "Disease_Plugin_Name" ] = "질병",
	[ "Disease_Plugin_Desc" ] = "감기에 걸립니다.",
	[ "Disease_UI_Notify" ] = "당신은 감기 증상이 있습니다.",
	[ "Disease_UI_Notify2" ] = "당신은 감기에 면역이 되어있습니다.",
	[ "Disease_Me_Chat" ] = "기침을 한다.",
	[ "Disease_Critical_Me_Chat" ] = "심한 기침을 한다.",
	[ "Item_Name_ColdMedicine" ] = "감기약",
	[ "Item_Desc_ColdMedicine" ] = "감기를 치료합니다.",
	[ "Item_FuncStr01_ColdMedicine" ] = "사용",
	[ "Item_Name_C17X.ColdMedicine" ] = "C17X 감기약",
	[ "Item_Desc_C17X.ColdMedicine" ] = "감기를 치료하고, 짧은 시간동안 감기에 면역이 됩니다.",
	[ "Item_FuncStr01_C17X.ColdMedicine" ] = "사용"
} )

if ( SERVER ) then
	local coughSounds = {
		"ambient/voices/cough1.wav",
		"ambient/voices/cough2.wav",
		"ambient/voices/cough3.wav",
		"ambient/voices/cough4.wav"
	}
	
	function PLUGIN:Cough( pl )
		if ( math.random( 1, 100 ) < 70 ) then
			pl:EmitSound( table.Random( coughSounds ), 100 )
			catherine.chat.RunByID( pl, "me", LANG( pl, "Disease_Me_Chat" ) )
			self:Infect( pl, false )
		else
			pl:EmitSound( table.Random( coughSounds ), 100, 150 )
			catherine.chat.RunByID( pl, "me", LANG( pl, "Disease_Critical_Me_Chat" ) )
			self:Infect( pl, true )
		end
	end
	
	function PLUGIN:Infect( pl, isCritical )
		for k, v in pairs( player.GetAllByLoaded( ) ) do
			if ( v.CAT_HL2RP_diseaseInfect ) then
				v.CAT_HL2RP_diseaseInfect = nil
			end
		end
		
		local playerPos = pl:GetPos( )
		
		if ( isCritical ) then
			for k, v in pairs( ents.FindInSphere( playerPos, 50 + math.random( 5, 25 ) ) ) do
				if ( IsValid( v ) and v:IsPlayer( ) and pl != v and v:IsCharacterLoaded( ) and v:Alive( ) ) then
					local tr = util.TraceLine( {
						start = playerPos,
						endpos = v:GetPos( ),
						filter = pl
					} )
					
					if ( !tr.HitWorld ) then
						v.CAT_HL2RP_diseaseInfect = true
					end
				end
			end
		else
			for k, v in pairs( ents.FindInSphere( playerPos, 30 + math.random( 5, 20 ) ) ) do
				if ( IsValid( v ) and v:IsPlayer( ) and pl != v and v:IsCharacterLoaded( ) and v:Alive( ) ) then
					local tr = util.TraceLine( {
						start = playerPos,
						endpos = v:GetPos( ),
						filter = pl
					} )
					
					if ( !tr.HitWorld ) then
						v.CAT_HL2RP_diseaseInfect = true
					end
				end
			end
		end
	end
	
	function PLUGIN:OnSpawnedInCharacter( pl )
		if ( pl.CAT_HL2RP_diseaseInfect ) then
			pl.CAT_HL2RP_diseaseInfect = nil
		end
		
		if ( !catherine.character.GetCharVar( pl, "disease_cold_active" ) ) then return end
		
		catherine.util.StartMotionBlur( pl, 0.4, 1, 0.02 )
		
		local charID = pl:GetCharacterID( )
		local timerID = "Catherine.HL2RP.plugin.disease.AutoHealCold." .. charID
		local time = catherine.character.GetCharVar( pl, "disease_cold_countdown", 0 )
		
		timer.Remove( timerID )
		timer.Create( timerID, 5, 0, function( )
			if ( !IsValid( pl ) or pl:GetCharacterID( ) != charID ) then
				timer.Remove( timerID )
				return
			end
			
			if ( !catherine.character.GetCharVar( pl, "disease_cold_active" ) ) then
				timer.Remove( timerID )
				return
			end
			
			if ( time - 5 > 0 ) then
				time = time - 5
				catherine.character.SetCharVar( pl, "disease_cold_countdown", time )
			else
				timer.Remove( timerID )
				catherine.character.SetCharVar( pl, "disease_cold_active", nil )
				catherine.character.SetCharVar( pl, "disease_cold_countdown", nil )
				
				if ( !pl.CAT_isLimbForceMotionBlur ) then
					catherine.util.StopMotionBlur( pl )
				end
			end
		end )
	end
	
	function PLUGIN:CreateColdAutoHealTimer( pl )
		local isCritical = ( catherine.configs.enable_rpTime and catherine.environment.GetTemperature( ) <= 7 ) and true or false
		
		local charID = pl:GetCharacterID( )
		local timerID = "Catherine.HL2RP.plugin.disease.AutoHealCold." .. charID
		local time = isCritical and 1500 or ( 100 + math.random( 10, 100 ) )
		
		timer.Remove( timerID )
		timer.Create( timerID, 5, 0, function( )
			if ( !IsValid( pl ) or pl:GetCharacterID( ) != charID ) then
				timer.Remove( timerID )
				return
			end
			
			if ( !catherine.character.GetCharVar( pl, "disease_cold_active" ) ) then
				timer.Remove( timerID )
				return
			end
			
			if ( time - 5 > 0 ) then
				time = time - 5
				catherine.character.SetCharVar( pl, "disease_cold_countdown", time )
			else
				timer.Remove( timerID )
				catherine.character.SetCharVar( pl, "disease_cold_active", nil )
				catherine.character.SetCharVar( pl, "disease_cold_countdown", nil )
				
				if ( !pl.CAT_isLimbForceMotionBlur ) then
					catherine.util.StopMotionBlur( pl )
				end
			end
		end )
	end
	
	function PLUGIN:PlayerShouldDisease( pl )
		local team = pl:Team( )
		
		if ( !pl:Alive( ) ) then
			return false
		end
		
		if ( team == FACTION_CP or team == FACTION_OW ) then
			return false
		end
	end
	
	function PLUGIN:PlayerThink( pl )
		if ( hook.Run( "PlayerShouldDisease", pl ) == false ) then return end
		
		if ( catherine.character.GetCharVar( pl, "disease_cold_active" ) ) then
			if ( ( pl.CAT_HL2RP_nextCough or 0 ) <= CurTime( ) ) then
				self:Cough( pl )
				pl.CAT_HL2RP_nextCough = CurTime( ) + math.random( 5, 60 )
			end
			
			return
		end
		
		if ( catherine.character.GetCharVar( pl, "disease_cold_protect", CurTime( ) - 10 ) > CurTime( ) ) then
			return
		elseif ( catherine.character.GetCharVar( pl, "disease_cold_protect", CurTime( ) + 10 ) <= CurTime( ) ) then
			catherine.character.SetCharVar( pl, "disease_cold_protect", nil )
		end
		
		if ( ( pl.CAT_HL2RP_nextDisease or 0 ) <= CurTime( ) ) then
			if ( pl.CAT_HL2RP_diseaseInfect ) then
				if ( math.random( 1, 800 ) >= 775 ) then
					catherine.util.StartMotionBlur( pl, 0.4, 1, 0.02 )
					catherine.character.SetCharVar( pl, "disease_cold_active", true )
					self:CreateColdAutoHealTimer( pl )
				end
				
				pl.CAT_HL2RP_nextDisease = CurTime( ) + math.random( 200, 400 )
				
				return
			else
				if ( math.random( 1, 1000 ) >= 995 ) then
					catherine.util.StartMotionBlur( pl, 0.4, 1, 0.02 )
					catherine.character.SetCharVar( pl, "disease_cold_active", true )
					self:CreateColdAutoHealTimer( pl )
				end
			end
			
			pl.CAT_HL2RP_nextDisease = CurTime( ) + 400
		end
	end
	
	function PLUGIN:PlayerDeath( pl )
		if ( pl.CAT_HL2RP_diseaseInfect ) then
			pl.CAT_HL2RP_diseaseInfect = nil
		end
		
		if ( catherine.character.GetCharVar( pl, "disease_cold_protect" ) ) then
			catherine.character.SetCharVar( pl, "disease_cold_protect", nil )
		end
		
		if ( catherine.character.GetCharVar( pl, "disease_cold_active" ) ) then
			catherine.character.SetCharVar( pl, "disease_cold_active", nil )
			catherine.character.SetCharVar( pl, "disease_cold_countdown", nil )
		end
	end
else
	function PLUGIN:AddRPInformation( pnl, data, pl )
		if ( catherine.character.GetCharVar( pl, "disease_cold_active" ) ) then
			data[ #data + 1 ] = LANG( "Disease_UI_Notify" )
		end
		
		if ( catherine.character.GetCharVar( pl, "disease_cold_protect" ) ) then
			data[ #data + 1 ] = LANG( "Disease_UI_Notify2" )
		end
	end
end
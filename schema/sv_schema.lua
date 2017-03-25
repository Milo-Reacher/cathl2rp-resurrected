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

CAT_SCHEMA_COMBINEOVERLAY_LOCAL = 1
CAT_SCHEMA_COMBINEOVERLAY_GLOBAL = 2
CAT_SCHEMA_COMBINEOVERLAY_GLOBAL_NOLOCAL = 3

hook.Add( "DataSave", "Schema.DataSave", function( )
	local data = { }
	local data2 = { }
	
	for k, v in pairs( ents.FindByClass( "cat_hl2rp_ration_dispenser" ) ) do
		data[ #data + 1 ] = {
			pos = v:GetPos( ),
			ang = v:GetAngles( ),
			active = v:GetActive( ),
			col = v:GetColor( ),
			mat = v:GetMaterial( )
		}
	end
	
	for k, v in pairs( ents.FindByClass( "cat_hl2rp_static_radio" ) ) do
		data2[ #data2 + 1 ] = {
			pos = v:GetPos( ),
			ang = v:GetAngles( ),
			active = v:GetNetVar( "active", false ),
			freq = v:GetNetVar( "freq", "XXX.X" ),
			col = v:GetColor( ),
			mat = v:GetMaterial( )
		}
	end
	
	catherine.data.Set( "ration_dispenser", data )
	catherine.data.Set( "static_radio", data2 )
end )

hook.Add( "DataLoad", "Schema.DataLoad", function( )
	local data = catherine.data.Get( "ration_dispenser", { } )
	local data2 = catherine.data.Get( "static_radio", { } )
	
	for k, v in pairs( data ) do
		local ent = ents.Create( "cat_hl2rp_ration_dispenser" )
		ent:SetPos( v.pos )
		ent:SetAngles( v.ang )
		ent:Spawn( )
		ent:SetColor( v.col )
		ent:SetMaterial( v.mat )
		
		if ( v.active ) then
			ent:SetActive( true )
		end
	end
	
	for k, v in pairs( data2 ) do
		local ent = ents.Create( "cat_hl2rp_static_radio" )
		ent:SetPos( v.pos )
		ent:SetAngles( v.ang )
		ent:Spawn( )
		ent:SetColor( v.col )
		ent:SetMaterial( v.mat )
		
		ent:SetNetVar( "active", v.active )
		ent:SetNetVar( "freq", v.freq )
	end
end )

function Schema:ShowSpare1( pl )
	if ( !pl:HasItem( "zip_tie" ) ) then return end
	local data = { }
	data.start = pl:GetShootPos( )
	data.endpos = data.start + pl:GetAimVector( ) * 160
	data.filter = pl
	local ent = util.TraceLine( data ).Entity
	
	if ( !IsValid( ent ) ) then
		catherine.util.NotifyLang( pl, "Entity_Notify_NotPlayer" )
		return
	end
	
	if ( ent:GetClass( ) == "prop_ragdoll" ) then
		ent = catherine.entity.GetPlayer( ent )
	end
	
	if ( IsValid( ent ) and ent:IsPlayer( ) ) then
		catherine.player.SetTie( pl, ent, true, nil, true )
	else
		catherine.util.NotifyLang( pl, "Entity_Notify_NotPlayer" )
	end
end

function Schema:GetTieingTime( pl, target, bool )
	local leftArmLimbDmg, rightArmLimbDmg = catherine.limb.GetDamage( pl, HITGROUP_LEFTARM ), catherine.limb.GetDamage( pl, HITGROUP_RIGHTARM )
	local per = math.max( leftArmLimbDmg, rightArmLimbDmg ) / 100
	local per2 = 1 - ( catherine.attribute.GetProgress( pl, CAT_ATT_DEFTNESS ) / 100 )
	
	return bool and ( 1.7 + ( ( 2.5 * per ) + ( 2.5 * per2 ) ) ) or ( 1.3 + ( ( 2.5 * per ) + ( 2.5 * per2 ) ) )
end

function Schema:GetLockTime( pl )
	local leftArmLimbDmg, rightArmLimbDmg = catherine.limb.GetDamage( pl, HITGROUP_LEFTARM ), catherine.limb.GetDamage( pl, HITGROUP_RIGHTARM )
	local per = math.max( leftArmLimbDmg, rightArmLimbDmg ) / 100
	local per2 = 1 - ( catherine.attribute.GetProgress( pl, CAT_ATT_DEFTNESS ) / 100 )
	
	return 1 + ( ( 2 * per ) + ( 2 * per2 ) )
end

function Schema:GetUnlockTime( pl )
	local leftArmLimbDmg, rightArmLimbDmg = catherine.limb.GetDamage( pl, HITGROUP_LEFTARM ), catherine.limb.GetDamage( pl, HITGROUP_RIGHTARM )
	local per = math.max( leftArmLimbDmg, rightArmLimbDmg ) / 100
	local per2 = 1 - ( catherine.attribute.GetProgress( pl, CAT_ATT_DEFTNESS ) / 100 )
	
	return 1 + ( ( 2 * per ) + ( 2 * per2 ) )
end

function Schema:GetHealthRecoverInterval( pl )
	return 8 - ( 4 * ( catherine.attribute.GetProgress( pl, CAT_ATT_MEDICAL ) / 100 ) )
end

function Schema:PlayerTied( pl, target )
	catherine.attribute.AddProgress( pl, CAT_ATT_DEFTNESS, 0.3 )
end

function Schema:PlayerUnTied( pl, target )
	catherine.attribute.AddProgress( pl, CAT_ATT_DEFTNESS, 0.3 )
end

function Schema:DoorLocked( pl, ent )
	catherine.attribute.AddProgress( pl, CAT_ATT_DEFTNESS, 0.1 )
end

function Schema:DoorUnLocked( pl, ent )
	catherine.attribute.AddProgress( pl, CAT_ATT_DEFTNESS, 0.1 )
end

function Schema:PlayerCanSpray( pl )
	return pl:HasItem( "spray_can" )
end

function Schema:GetRationCash( pl )
	return math.random( 20, 40 )
end

function Schema:PlayerShouldHungerThirsty( pl )
	if ( pl:Team( ) == FACTION_OW or pl:Class( ) == CLASS_CP_SCN ) then
		return false
	end
end

function Schema:AdjustRecognizeInfo( pl, target, recognizeList )
	if ( !target:PlayerIsCombine( ) ) then return end
	local combines = self:GetCombines( )
	
	for k, v in pairs( combines ) do
		if ( v == target or !IsValid( v ) ) then continue end
		
		recognizeList[ #recognizeList + 1 ] = v
	end
	
	return recognizeList
end

function Schema:PlayerInteract( pl, target )
	if ( target:IsTied( ) ) then
		return catherine.player.SetTie( pl, target, false )
	end
	
	if ( ( pl:HasItem( "health_kit" ) or pl:HasItem( "health_vial" ) ) and target:Alive( ) and target:Health( ) < target:GetMaxHealth( ) ) then
		if ( !catherine.entity.IsRegisteredUseMenu( target ) ) then
			catherine.entity.RegisterUseMenu( target, {
				{
					uniqueID = "ID_HEAL",
					text = "^Item_FuncStr02_Medical",
					icon = "icon16/heart.png",
					func = function( pl, ent )
						local uniqueID = nil
						
						if ( pl:HasItem( "health_vial" ) ) then
							uniqueID = "health_vial"
						elseif ( pl:HasItem( "health_kit" ) ) then
							uniqueID = "health_kit"
						end
						
						if ( uniqueID ) then
							catherine.item.Work( pl, uniqueID, "heal", true )
						end
					end
				}
			} )
		end
		
		catherine.entity.OpenUseMenu( pl, target )
		
		return true
	end
end

function Schema:SayRadio( pl, text )
	local listeners, isStaticRadio = self:GetRadioListeners( pl )
	local blockPl = nil
	local radioSignal = pl:GetNetVar( "radioSignal", 0 )
	
	if ( !isStaticRadio ) then
		if ( radioSignal == 2 ) then
			local ex = string.Explode( " ", text )
			
			for k, v in pairs( ex ) do
				ex[ k ] = ex[ k ] .. string.rep( ".", math.random( 2, 10 ) )
			end
			
			text = table.concat( ex, "" )
		elseif ( radioSignal == 1 ) then
			text = string.rep( ".", #text )
			
			for k, v in pairs( listeners ) do
				v:EmitSound( "ambient/levels/prison/radio_random" .. math.random( 1, 9 ) .. ".wav", 40 )
			end
			
			blockPl = pl
		elseif ( radioSignal == 0 ) then
			catherine.chat.RunByID( pl, "radio", string.rep( ".", #text ), { pl } )
			pl:EmitSound( "ambient/levels/prison/radio_random" .. math.random( 1, 9 ) .. ".wav", 40 )
			
			return
		end
	end
	
	catherine.chat.RunByID( pl, "radio", text, listeners, blockPl )
end

function Schema:SayRequest( pl, text )
	self:AddCombineOverlayMessage( CAT_SCHEMA_COMBINEOVERLAY_GLOBAL, nil, { "CombineOverlay_Request", { pl:Name( ), text, pl:GetCurrentAreaName( ) or "NONE" } }, 9, Color( 255, 150, 150 ) )
	catherine.chat.RunByID( pl, "request", text, self:GetCombines( ) )
end

function Schema:SayDispatch( pl, text )
	catherine.chat.RunByID( pl, "dispatch", text )
end

function Schema:SayBreenCast( pl, text )
	catherine.chat.RunByID( pl, "breencast", text )
end

function Schema:ChatPrefix( pl, classTable )
	if ( !pl:PlayerIsCombine( ) ) then return end
	local uniqueID = classTable.uniqueID
	
	if ( uniqueID == "ic" or uniqueID == "yell" or uniqueID == "whisper" or uniqueID == "radio" ) then
		return "< :: "
	end
end

function Schema:PlayerScaleDamage( pl, attacker, dmgInfo, hitGroup )
	if ( dmgInfo:IsBulletDamage( ) and ( hitGroup == HITGROUP_STOMACH or hitGroup == HITGROUP_CHEST ) ) then
		local wearingBodyGroups = catherine.character.GetCharVar( pl, "wearing_bodyGroups", { } )
		local scaleAmount = 0
		
		for k, v in pairs( wearingBodyGroups ) do
			local itemTable = catherine.item.FindByID( k )
			
			if ( itemTable and itemTable.damageScale ) then
				scaleAmount = scaleAmount + itemTable.damageScale
			end
		end
		
		if ( scaleAmount != 0 ) then
			local amount = 1 - scaleAmount
			
			dmgInfo:ScaleDamage( amount )
			
			if ( amount == 0 ) then
				return { true, true }
			end
		end
	end
end

function Schema:AdjustPunchDamage( pl, ent )
	return 8 + ( 6 * ( catherine.attribute.GetProgress( pl, CAT_ATT_POWER ) / 100 ) )
end

--[[
	Why?
	https://github.com/Chessnut/NutScript/blob/1.1/gamemode/core/sh_util.lua#L121
]]--

local ADJUST_SOUND = SoundDuration( "npc/metropolice/pain1.wav" ) > 0 and "" or "../../hl2/sound/"

function Schema:OnChatControl( chatInformation )
	local pl = chatInformation.pl
	local uniqueID = chatInformation.uniqueID
	
	if ( uniqueID == "ic" or uniqueID == "radio" or uniqueID == "yell" or uniqueID == "whisper" ) then
		local text = chatInformation.text
		
		if ( uniqueID == "ic" ) then
			for k, v in pairs( ents.FindInSphere( pl:GetPos( ), 100 ) ) do
				if ( v:GetClass( ) == "cat_hl2rp_static_radio" and v:GetNetVar( "active" ) and ( v:GetNetVar( "freq" ) != "XXX.X" or v:GetNetVar( "freq" ) != "" ) ) then
					catherine.command.Run( pl, "&uniqueID_radio", { text } )
					
					return false
				end
			end
		end
		
		local result = {
			sounds = { },
			text = text
		}
		local ex = string.Explode( ", ", text )
		local vol = true
		
		if ( #ex > 5 ) then
			for i = 5, #ex do
				ex[ i ] = nil
			end
		end
		
		if ( uniqueID == "ic" ) then
			vol = 80
		elseif ( uniqueID == "yell" ) then
			vol = 100
		elseif ( uniqueID == "whisper" ) then
			vol = 30
		end
		local team = pl:Team( )
		
		for k, v in pairs( ex ) do
			local lowerText = v:lower( )
			local foundVoice = false
			
			for k1, v1 in pairs( self.vo.normalVoice ) do
				if ( !table.HasValue( v1.faction, team ) ) then continue end
				
				if ( lowerText == v1.command:lower( ) ) then
					local source = type( v1.sound ) == "table" and table.Random( v1.sound ) or v1.sound
					
					if ( ( team == FACTION_CITIZEN or team == FACTION_CWU ) and pl:IsFemale( ) and v1.allowFemale ) then
						source = source:gsub( "male01", "female01" )
					end
					
					source = hook.Run( "AdjustChatVoiceSource", pl, v, v1, source ) or source
					
					result.sounds[ #result.sounds + 1 ] = {
						dir = source,
						len = SoundDuration( ADJUST_SOUND .. source ),
						vol = vol
					}
					result.text = k == 1 and v1.output or ( result.text .. ", " .. v1.output )
					
					foundVoice = true
					
					break
				end
			end
			
			if ( !foundVoice and text != result.text ) then
				result.text = result.text .. ", " .. v
			end
		end
		
		chatInformation.voice = result.sounds
		chatInformation.text = result.text
		
		return chatInformation
	elseif ( uniqueID == "dispatch" ) then
		local text = chatInformation.text
		local lowerText = text:lower( )
		local result = {
			sounds = { },
			text = text
		}
		
		for k, v in pairs( self.vo.dispatchVoice ) do
			if ( lowerText == v.command:lower( ) ) then
				result.sounds[ #result.sounds + 1 ] = {
					dir = v.sound,
					len = SoundDuration( v.sound ),
					vol = true
				}
				result.text = v.output
			end
		end
		
		chatInformation.voice = result.sounds
		chatInformation.text = result.text
		
		return chatInformation
	elseif ( uniqueID == "breencast" ) then
		local text = chatInformation.text
		local lowerText = text:lower( )
		local result = {
			sounds = { },
			text = text
		}
		
		for k, v in pairs( self.vo.breenCast ) do
			if ( lowerText == v.command:lower( ) ) then
				result.sounds[ #result.sounds + 1 ] = {
					dir = v.sound,
					len = SoundDuration( v.sound ),
					vol = true
				}
				result.text = v.output
			end
		end
		
		chatInformation.voice = result.sounds
		chatInformation.text = result.text
		
		return chatInformation
	end
end

function Schema:ChatPosted( chatInformation )
	if ( !chatInformation.voice ) then return end
	local pl = chatInformation.pl
	local len = 0
	
	if ( #chatInformation.voice > 5 ) then
		for i = 5, #chatInformation.voice do
			chatInformation.voice[ i ] = nil
		end
	end
	
	for k, v in pairs( chatInformation.voice ) do
		len = len + ( k == 1 and 0 or v.len + 0.5 )
		
		timer.Simple( len, function( )
			if ( !IsValid( pl ) or !pl:Alive( ) ) then return end
			
			if ( v.vol == true ) then
				pl:EmitSound( v.dir, 70 )
				catherine.util.PlaySimpleSound( chatInformation.target and chatInformation.target or nil, v.dir )
			else
				if ( chatInformation.uniqueID == "radio" ) then
					catherine.util.PlaySimpleSound( chatInformation.target and chatInformation.target or nil, v.dir )
				else
					pl:EmitSound( v.dir, v.vol )
				end
			end
		end )
	end
end

function Schema:PlayerUseDoor( pl, ent )
	local partner = catherine.util.GetDoorPartner( ent )
	local lock = ent.lock or ( IsValid( partner ) and partner.lock )
	
	if ( IsValid( lock ) and !ent:HasSpawnFlags( 256 ) and !ent:HasSpawnFlags( 1024 ) ) then
		ent:Fire( "Open", "", 0 )
		
		return true
	end
	
	if ( ( pl:PlayerIsCombine( ) or pl:Team( ) == FACTION_ADMIN ) and !ent:HasSpawnFlags( 256 ) and !ent:HasSpawnFlags( 1024 ) ) then
		ent:Fire( "Open", "", 0 )
		
		return true
	end
end

function Schema:AddCombineOverlayMessage( targetType, pl, langTable, time, col, textMakeDelay )
	targetType = targetType or CAT_SCHEMA_COMBINEOVERLAY_GLOBAL
	local combines = self:GetCombines( )
	
	if ( targetType == CAT_SCHEMA_COMBINEOVERLAY_LOCAL and IsValid( pl ) ) then
		combines = pl
	elseif ( targetType == CAT_SCHEMA_COMBINEOVERLAY_GLOBAL_NOLOCAL and IsValid( pl ) ) then
		table.RemoveByValue( combines, pl )
	end
	
	for k, v in pairs( type( combines ) == "Player" and { combines } or combines ) do
		netstream.Start( v, "catherine.Schema.AddCombineOverlayMessage", {
			LANG( v, langTable[ 1 ], unpack( langTable[ 2 ] or { } ) ),
			time or 6,
			col or Color( 255, 255, 255 ),
			textMakeDelay or 0.05
		} )
	end
end

function Schema:ClearCombineOverlayMessages( pl )
	if ( !IsValid( pl ) ) then return end
	
	netstream.Start( pl, "catherine.Schema.ClearCombineOverlayMessages" )
end

function Schema:PlayerFootstep( pl, pos, foot, soundName, vol )
	if ( !pl:PlayerIsCombine( ) or !pl:IsRunning( ) ) then return true end
	local sound = "npc/metropolice/gear" .. math.random( 1, 6 ) .. ".wav"
	
	if ( pl:Team( ) == FACTION_OW ) then
		sound = "npc/combine_soldier/gear" .. math.random( 1, 6 ) .. ".wav"
	end
	
	pl:EmitSound( sound, 70 )
	
	return true
end

function Schema:GetHealAmount( pl, itemTable )
	if ( itemTable.uniqueID == "health_kit" ) then
		return 35 + ( 10 * ( catherine.attribute.GetProgress( pl, CAT_ATT_MEDICAL ) / 100 ) )
	elseif ( itemTable.uniqueID == "health_vial" ) then
		return 15 + ( 10 * ( catherine.attribute.GetProgress( pl, CAT_ATT_MEDICAL ) / 100 ) )
	end
end

function Schema:PlayerHealed( pl )
	catherine.attribute.AddProgress( pl, CAT_ATT_MEDICAL, 0.07 )
end

function Schema:PlayerThrowPunch( pl, ent, damage, tr, hit )
	if ( hit ) then
		catherine.attribute.AddProgress( pl, CAT_ATT_POWER, 0.05 )
	end
end

function Schema:GetPlayerPainSound( pl )
	if ( !pl:PlayerIsCombine( ) ) then return end
	local team = pl:Team( )
	
	if ( team == FACTION_CP ) then
		return "npc/metropolice/pain" .. math.random( 1, 3 ) .. ".wav"
	elseif ( team == FACTION_OW ) then
		return "npc/combine_soldier/pain" .. math.random( 1, 3 ) .. ".wav"
	end
end

function Schema:GetPlayerDeathSound( pl )
	if ( !pl:PlayerIsCombine( ) ) then return end
	local team = pl:Team( )
	
	if ( team == FACTION_CP ) then
		return "npc/metropolice/die" .. math.random( 1, 4 ) .. ".wav"
	elseif ( team == FACTION_OW ) then
		return "npc/combine_soldier/die" .. math.random( 1, 3 ) .. ".wav"
	end
end

function Schema:HealthFullRecovered( pl )
	if ( !pl:PlayerIsCombine( ) ) then return end
	
	self:AddCombineOverlayMessage( CAT_SCHEMA_COMBINEOVERLAY_LOCAL, pl, { "CombineOverlay_HealthFullRecovered" }, 4, Color( 150, 255, 150 ) )
end

function Schema:PlayerTakeDamage( pl )
	if ( !pl:PlayerIsCombine( ) ) then return end
	
	if ( ( pl.CAT_HL2RP_nextHurtDelay or CurTime( ) ) <= CurTime( ) ) then
		self:AddCombineOverlayMessage( CAT_SCHEMA_COMBINEOVERLAY_LOCAL, pl, { "CombineOverlay_TakeDmg_Local" }, 7, Color( 255, 150, 0 ) )
		self:AddCombineOverlayMessage( CAT_SCHEMA_COMBINEOVERLAY_GLOBAL_NOLOCAL, pl, { "CombineOverlay_TakeDmg_NoLocal", { pl:Name( ) } }, 7, Color( 255, 150, 0 ) )
		pl.CAT_HL2RP_nextHurtDelay = CurTime( ) + 5
	end
end

function Schema:HealthRecovering( pl )
	if ( !pl:PlayerIsCombine( ) ) then return end
	
	self:AddCombineOverlayMessage( CAT_SCHEMA_COMBINEOVERLAY_LOCAL, pl, { "CombineOverlay_HealthRecovering", { ( pl:Health( ) / pl:GetMaxHealth( ) ) * 100 } }, 4, Color( 255, 150, 150 ) )
end

function Schema:PlayerDeath( pl )
	if ( !pl:PlayerIsCombine( ) ) then return end
	local name = pl:Name( )
	local localMessage = { "CombineOverlay_LocalPlayerDeath_CP" }
	local globalMessage = { "CombineOverlay_PlayerDeath_CP", { name } }
	
	if ( pl:Team( ) == FACTION_OW ) then
		localMessage = { "CombineOverlay_LocalPlayerDeath_OW" }
		globalMessage = { "CombineOverlay_PlayerDeath_OW", { name } }
	end
	
	self:AddCombineOverlayMessage( CAT_SCHEMA_COMBINEOVERLAY_LOCAL, pl, localMessage, 10, Color( 255, 0, 0 ), 0.04 )
	self:AddCombineOverlayMessage( CAT_SCHEMA_COMBINEOVERLAY_GLOBAL_NOLOCAL, pl, globalMessage, 10, Color( 255, 0, 0 ), 0.04 )
	
	for k, v in pairs( self:GetCombines( ) or { } ) do
		v:EmitSound( "npc/overwatch/radiovoice/on1.wav" )
		v:EmitSound( "npc/overwatch/radiovoice/lostbiosignalforunit.wav" )
		
		timer.Simple( 1.5, function( )
			v:EmitSound( "npc/overwatch/radiovoice/off4.wav" )
		end )
	end
end

function Schema:OnSpawnedInCharacter( pl )
	if ( pl:Team( ) == FACTION_CP ) then
		local rankID, classID = self:GetRankByName( pl:Name( ) )
		
		self:AddCombineOverlayMessage( CAT_SCHEMA_COMBINEOVERLAY_LOCAL, pl, { "CombineOverlay_Online" }, 5, Color( 150, 255, 150 ), 0.04 )
		
		if ( pl:Class( ) != nil and pl:Class( ) != classID ) then
			if ( rankID and classID ) then
				catherine.class.Set( pl, classID )
			else
				if ( pl:Class( ) == CLASS_CP_UNIT ) then return end
				
				catherine.class.Set( pl, CLASS_CP_UNIT )
			end
		elseif ( pl:Class( ) == nil ) then
			if ( rankID and classID ) then
				catherine.class.Set( pl, classID )
			else
				if ( pl:Class( ) == CLASS_CP_UNIT ) then return end
				
				catherine.class.Set( pl, CLASS_CP_UNIT )
			end
		end
		
		hook.Run( "CombineClassSetFinished", pl )
		
		pl:SetMaxHealth( 100 )
		pl:SetArmor( 50 )
		
		return
	elseif ( pl:Team( ) == FACTION_OW ) then
		pl:SetMaxHealth( 255 )
		pl:SetHealth( 255 )
		pl:SetArmor( 255 )
		
		return
	end
	
	self:AddCombineOverlayMessage( CAT_SCHEMA_COMBINEOVERLAY_GLOBAL, nil, { "CombineOverlay_RFCitizens" }, 7, Color( 150, 255, 150 ) )
end

function Schema:PlayerFirstSpawned( pl )
	if ( pl:Team( ) == FACTION_CP ) then
		local rankID, classID = self:GetRankByName( pl:Name( ) )
		
		if ( pl:Class( ) != nil and pl:Class( ) != classID ) then
			if ( rankID and classID ) then
				pl:SetModel( self:GetModelByRank( rankID ) )
			end
		elseif ( pl:Class( ) != nil and pl:Class( ) == classID and self:GetModelByRank( rankID ) != pl:GetModel( ) ) then
			pl:SetModel( self:GetModelByRank( rankID ) )
		elseif ( pl:Class( ) == nil ) then
			if ( rankID and classID ) then
				pl:SetModel( self:GetModelByRank( rankID ) )
			end
		end
	elseif ( pl:Team( ) == FACTION_OW ) then
		local rankID = nil
		
		for k, v in pairs( self.OverWatchRankModel ) do
			if ( pl:Name( ):find( k ) ) then
				rankID = k
				break
			end
		end
		
		if ( rankID ) then
			pl:SetModel( self:GetModelByRank( rankID, true ) )
		end
	end
end

function Schema:GetBeepSound( pl, isOff )
	local team = pl:Team( )
	
	if ( team == FACTION_CP ) then
		if ( isOff ) then
			return "npc/metropolice/vo/off" .. math.random( 1, 4 ) .. ".wav"
		else
			return math.random( 1, 9 ) <= 5 and "npc/metropolice/vo/on" .. math.random( 1, 2 ) .. ".wav" or "npc/overwatch/radiovoice/on3.wav"
		end
	elseif ( team == FACTION_OW ) then
		return isOff and "npc/combine_soldier/vo/off" .. math.random( 1, 3 ) .. ".wav" or "npc/combine_soldier/vo/on" .. math.random( 1, 2 ) .. ".wav"
	end
end

function Schema:ChatTypingChanged( pl, bool )
	if ( !pl:Alive( ) or !pl:PlayerIsCombine( ) ) then return end
	
	pl:EmitSound( self:GetBeepSound( pl, !bool ), 40 )
end

function Schema:PostItemTake( pl, itemTable )
	if ( itemTable.uniqueID != "cid" ) then return end
	
	if ( tonumber( pl:GetCharVar( "cid" ) ) == tonumber( pl:GetInvItemData( "cid", "cid" ) ) ) then
		if ( pl:Name( ) != pl:GetInvItemData( "cid", "name" ) ) then
			pl:SetInvItemData( "cid", "name", pl:Name( ) )
		end
	end
end

function Schema:CharacterNameChanged( pl, newName )
	if ( pl:Team( ) == FACTION_CP ) then
		local rankID, classID = self:GetRankByName( pl:Name( ) )
		
		if ( pl:Class( ) != nil and pl:Class( ) != classID ) then
			if ( rankID and classID ) then
				catherine.class.Set( pl, classID )
				pl:SetModel( self:GetModelByRank( rankID ) )
			else
				if ( pl:Class( ) == CLASS_CP_UNIT ) then return end
				
				catherine.class.Set( pl, CLASS_CP_UNIT )
			end
		elseif ( pl:Class( ) != nil and pl:Class( ) == classID and self:GetModelByRank( rankID ) != pl:GetModel( ) ) then
			pl:SetModel( self:GetModelByRank( rankID ) )
		elseif ( pl:Class( ) == nil ) then
			if ( rankID and classID ) then
				catherine.class.Set( pl, classID )
				pl:SetModel( self:GetModelByRank( rankID ) )
			else
				if ( pl:Class( ) == CLASS_CP_UNIT ) then return end
				
				catherine.class.Set( pl, CLASS_CP_UNIT )
			end
		end
		
		hook.Run( "CombineClassSetFinishedOnNameChanged", pl )
	elseif ( pl:Team( ) == FACTION_OW ) then
		local rankID = nil
		
		for k, v in pairs( self.OverWatchRankModel ) do
			if ( pl:Name( ):find( k ) ) then
				rankID = k
				break
			end
		end
		
		if ( rankID ) then
			pl:SetModel( self:GetModelByRank( rankID, true ) )
		end
	elseif ( pl:Team( ) == FACTION_CITIZEN ) then
		catherine.inventory.SetItemData( pl, "cid", "name", newName )
	end
end

function Schema:CharacterLoadingStart( pl )
	if ( !pl:PlayerIsCombine( ) ) then return end
	
	self:ClearCombineOverlayMessages( pl )
end

function Schema:GetRadioListeners( pl, isSignalOnly )
	local listeners = { pl }
	local isStaticRadio = false
	local staticRadios = { }
	
	for k, v in pairs( ents.FindInSphere( pl:GetPos( ), 100 ) ) do
		if ( v:GetClass( ) == "cat_hl2rp_static_radio" and v:GetNetVar( "active" ) and v:GetNetVar( "freq" ) != "XXX.X" and v:GetNetVar( "freq" ) != "" ) then
			staticRadios[ #staticRadios + 1 ] = {
				ent = v,
				freq = v:GetNetVar( "freq" )
			}
			isStaticRadio = true
		end
	end
	
	if ( #staticRadios > 0 ) then
		for k, v in pairs( staticRadios ) do
			for k1, v1 in pairs( player.GetAllByLoaded( ) ) do
				if ( pl == v1 ) then continue end
				
				if ( v1:HasItem( "portable_radio" ) ) then
					local targetItemDatas = v1:GetInvItemDatas( "portable_radio" )
					
					if ( targetItemDatas.freq == v.freq and targetItemDatas.toggle and targetItemDatas.freq and ( targetItemDatas.freq != "xxx.x" and targetItemDatas.freq != "" ) ) then
						listeners[ #listeners + 1 ] = v1
					else
						for k2, v2 in pairs( ents.FindInSphere( v1:GetPos( ), 100 ) ) do
							if ( v2:GetClass( ) == "cat_hl2rp_static_radio" and v2:GetNetVar( "active" ) and v2:GetNetVar( "freq" ) != "XXX.X" and v2:GetNetVar( "freq" ) != "" ) then
								if ( v2:GetNetVar( "freq" ) == v.freq ) then
									listeners[ #listeners + 1 ] = v1
									
									if ( v1.RadioReceived and !isSignalOnly ) then
										v1:RadioReceived( )
									end
								end
							end
						end
					end
				else
					for k2, v2 in pairs( ents.FindInSphere( v1:GetPos( ), 100 ) ) do
						if ( v2:GetClass( ) == "cat_hl2rp_static_radio" and v2:GetNetVar( "active" ) and v2:GetNetVar( "freq" ) != "XXX.X" and v2:GetNetVar( "freq" ) != "" ) then
							if ( v2:GetNetVar( "freq" ) == v.freq ) then
								listeners[ #listeners + 1 ] = v1
								
								if ( v1.RadioReceived and !isSignalOnly ) then
									v1:RadioReceived( )
								end
							end
						end
					end
				end
			end
		end
	else
		local playerFreq = pl:GetInvItemData( "portable_radio", "freq" )
		local playerToggle = pl:GetInvItemData( "portable_radio", "toggle" )
		
		for k, v in pairs( player.GetAllByLoaded( ) ) do
			if ( pl == v ) then continue end
			
			if ( v:HasItem( "portable_radio" ) ) then
				local targetItemDatas = v:GetInvItemDatas( "portable_radio" )
				
				if ( targetItemDatas.freq == playerFreq and targetItemDatas.toggle and playerToggle and targetItemDatas.freq and ( targetItemDatas.freq != "xxx.x" and targetItemDatas.freq != "" ) ) then
					listeners[ #listeners + 1 ] = v
				else
					for k1, v1 in pairs( ents.FindInSphere( v:GetPos( ), 100 ) ) do
						if ( v1:GetClass( ) == "cat_hl2rp_static_radio" and v1:GetNetVar( "active" ) and v1:GetNetVar( "freq" ) != "XXX.X" and v1:GetNetVar( "freq" ) != "" ) then
							if ( v1:GetNetVar( "freq" ) == playerFreq and playerToggle ) then
								listeners[ #listeners + 1 ] = v
								
								if ( v1.RadioReceived and !isSignalOnly ) then
									v1:RadioReceived( )
								end
							end
						end
					end
				end
			else
				for k1, v1 in pairs( ents.FindInSphere( v:GetPos( ), 100 ) ) do
					if ( v1:GetClass( ) == "cat_hl2rp_static_radio" and v1:GetNetVar( "active" ) and v1:GetNetVar( "freq" ) != "XXX.X" and v1:GetNetVar( "freq" ) != "" ) then
						if ( v1:GetNetVar( "freq" ) == playerFreq and playerToggle ) then
							listeners[ #listeners + 1 ] = v
							
							if ( v1.RadioReceived and !isSignalOnly ) then
								v1:RadioReceived( )
							end
						end
					end
				end
			end
		end
	end
	
	return listeners, isStaticRadio
end

function Schema:Think( )
	if ( ( self.NextRadioSignalCheckTick or 0 ) <= CurTime( ) ) then
		self:RadioThink( )
		self.NextRadioSignalCheckTick = CurTime( ) + 2
	end
end

function Schema:PlayerJump( pl, velo )
	catherine.attribute.AddProgress( pl, CAT_ATT_JUMP, 0.009 )
end

local defJumpPower = catherine.configs.playerDefaultJumpPower

function Schema:GetCustomPlayerDefaultJumpPower( pl )
	local jumpAttribute = catherine.attribute.GetProgress( pl, CAT_ATT_JUMP )
	
	return defJumpPower + math.min( jumpAttribute * 1.5, 100 )
end

function Schema:RadioThink( )
	for k, v in pairs( player.GetAllByLoaded( ) ) do
		if ( !v:HasItem( "portable_radio" ) or v:GetInvItemData( "portable_radio", "toggle" ) == false ) then continue end
		local newSignal = self:CalcRadio( v )
		
		if ( v:GetNetVar( "radioSignal", 0 ) != newSignal ) then
			v:SetNetVar( "radioSignal", newSignal )
		end
	end
end

local radioSignalData = {
	{ 5, 800 },
	{ 4, 1800 },
	{ 3, 3000 },
	{ 2, 5000 },
	{ 1, 8000 },
	{ 0, 10000 }
}

function Schema:CalcRadio( pl )
	local listeners = self:GetRadioListeners( pl, true )
	local max = 1000000
	
	for k, v in pairs( listeners ) do
		if ( pl == v ) then continue end
		local dis = catherine.util.CalcDistanceByPos( pl, v )
		
		if ( dis < max ) then
			max = dis
		end
	end
	
	for k, v in pairs( radioSignalData ) do
		if ( v[ 2 ] >= max and radioSignalData[ math.min( k + 1, #radioSignalData ) ][ 2 ] > max ) then
			return v[ 1 ]
		end
	end
	
	return 0
end
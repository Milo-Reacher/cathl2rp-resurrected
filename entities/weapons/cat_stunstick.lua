AddCSLuaFile( )

SWEP.PrintName = "^Weapon_Stunstick_Name"
SWEP.Instructions = "^Weapon_Stunstick_Instructions"
SWEP.Purpose = "^Weapon_Stunstick_Purpose"
SWEP.Author = "L7D, Chessnut"
SWEP.HoldType = "melee"
SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "melee"
SWEP.ViewTranslation = 4

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Damage = 7
SWEP.Primary.Delay = 1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.ViewModel = Model( "models/weapons/v_stunstick.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_stunbaton.mdl" )

SWEP.LowerAngles = Angle( 15, -10, -30 )
SWEP.CanFireLowered = true
SWEP.HitDistance = 48
SWEP.UseHands = false

function SWEP:SetupDataTables( )
	self:NetworkVar( "Bool", 0, "Active" )
end

function SWEP:Precache( )
	util.PrecacheSound( "weapons/stunstick/spark1.wav" )
	util.PrecacheSound( "weapons/stunstick/spark2.wav" )
	util.PrecacheSound( "weapons/stunstick/spark3.wav" )
	util.PrecacheSound( "weapons/stunstick/stunstick_swing1.wav" )
	util.PrecacheSound( "weapons/stunstick/stunstick_swing2.wav" )
	util.PrecacheSound( "weapons/stunstick/stunstick_impact1.wav" )	
	util.PrecacheSound( "weapons/stunstick/stunstick_impact2.wav" )
end

function SWEP:Initialize( )
	self:SetHoldType( self.HoldType )
end

function SWEP:PrimaryAttack( )
	local pl = self.Owner
	
	self:SetNextPrimaryFire( CurTime( ) + self.Primary.Delay )
	
	if ( !pl:GetWeaponRaised( ) ) then return end
	
	local stamina = catherine.character.GetCharVar( pl, "stamina", 100 )
	
	if ( stamina < 10 ) then return end
	
	if ( pl:KeyDown( IN_WALK ) ) then
		if ( SERVER ) then
			local seq = "deactivatebaton"
			
			self:SetActive( !self:GetActive( ) )
			
			if ( self:GetActive( ) ) then
				pl:EmitSound( "weapons/stunstick/spark3.wav", 100, math.random( 70, 130 ) )
				seq = "activatebaton"
			else
				pl:EmitSound( "weapons/stunstick/spark" .. math.random( 1, 2 ) .. ".wav", 100, math.random( 70, 130 ) )
			end
			
			if ( catherine.animation.IsClass( pl, "metrocop" ) ) then
				catherine.animation.StartSequence( pl, seq )
			end
		end
		
		return
	end
	
	local dmg = self.Primary.Damage
	
	self:EmitSound( "weapons/stunstick/stunstick_swing" .. math.random( 1, 2 ) .. ".wav" )
	self:SendWeaponAnim( ACT_VM_HITCENTER )
	
	pl:SetAnimation( PLAYER_ATTACK1 )
	pl:ViewPunch( Angle( 1, 0, 0.125 ) )
	
	if ( SERVER ) then
		catherine.character.SetCharVar( pl, "stamina", stamina - math.Rand( 0.5, 3 ) )
	end
	
	pl:LagCompensation( true )
	
	local data = { }
	data.start = pl:GetShootPos( )
	data.endpos = data.start + pl:GetAimVector( ) * 80
	data.filter = pl
	local tr = util.TraceLine( data )
	
	pl:LagCompensation( false )
	
	if ( SERVER and tr.Hit ) then
		local active = self:GetActive( )
		
		if ( active ) then
			local eff = EffectData( )
			eff:SetStart( tr.HitPos )
			eff:SetOrigin( tr.HitPos )
			eff:SetNormal( tr.HitNormal )
			util.Effect( "StunstickImpact", eff, true, true )
		end
		
		pl:EmitSound( "weapons/stunstick/stunstick_impact" .. math.random( 1, 2 ) .. ".wav" )
		
		local ent = tr.Entity
		
		if ( !IsValid( ent ) ) then return end
		
		if ( ent:GetClass( ) == "prop_ragdoll" ) then
			ent = catherine.entity.GetPlayer( ent )
		end
		
		if ( IsValid( ent ) and ent:IsPlayer( ) ) then
			if ( !ent:Alive( ) ) then return end
			
			ent:ViewPunch( Angle( -20, math.random( -15, 15 ), math.random( -10, 10 ) ) )
			
			if ( !ent:IsRagdolled( ) ) then
				if ( !ent.CAT_HL2RP_stunCount or !ent.CAT_HL2RP_ragdollRunCount ) then
					ent.CAT_HL2RP_stunCount = 0
					ent.CAT_HL2RP_ragdollRunCount = math.random( 4, 8 )
				end
				
				local stunCount = ent.CAT_HL2RP_stunCount
				local timerID = "Catherine.HL2RP.timer.Stunstick.StunCountRemover." .. ent:SteamID( )
				
				catherine.player.SetIgnoreScreenColor( ent, true )
				
				if ( active ) then
					stunCount = stunCount + 1
					
					ent.CAT_HL2RP_stunCount = stunCount
					
					local dmgInfo = DamageInfo( )
					dmgInfo:SetInflictor( self )
					dmgInfo:SetAttacker( pl )
					dmgInfo:SetDamage( dmg / 2.5 )
					dmgInfo:SetDamageType( DMG_CLUB )
					dmgInfo:SetDamagePosition( tr.HitPos )
					dmgInfo:SetDamageForce( pl:GetAimVector( ) * 100 )
					
					ent:DispatchTraceAttack( dmgInfo, data.start, data.endpos )
					
					catherine.util.ScreenColorEffect( ent, Color( 255, 255, 255 ), 0.7, 0.07 )
				else
					local dmgInfo = DamageInfo( )
					dmgInfo:SetInflictor( self )
					dmgInfo:SetAttacker( pl )
					dmgInfo:SetDamage( dmg / 1.5 )
					dmgInfo:SetDamageType( DMG_CLUB )
					dmgInfo:SetDamagePosition( tr.HitPos )
					dmgInfo:SetDamageForce( pl:GetAimVector( ) * 100 )
					
					ent:DispatchTraceAttack( dmgInfo, data.start, data.endpos )
					
					catherine.effect.Create( "BLOOD", {
						ent = ent,
						pos = dmgInfo:GetDamagePosition( ),
						scale = 1,
						decalCount = 1
					} )
					
					catherine.util.ScreenColorEffect( ent, Color( 255, 150, 150 ), 0.7, 0.07 )
				end
				
				catherine.player.SetIgnoreScreenColor( ent, nil )
				
				if ( stunCount >= ent.CAT_HL2RP_ragdollRunCount ) then
					catherine.player.RagdollWork( ent, true, 90 )
					ent.CAT_HL2RP_stunCount = nil
					ent.CAT_HL2RP_ragdollRunCount = nil
					timer.Remove( timerID )
					return
				end
				
				timer.Remove( timerID )
				timer.Create( timerID, 3, stunCount, function( )
					local reStunCount = ent.CAT_HL2RP_stunCount
					
					if ( reStunCount > 0 ) then
						reStunCount = reStunCount - 1
						
						ent.CAT_HL2RP_stunCount = reStunCount
					else
						timer.Remove( timerID )
						ent.CAT_HL2RP_stunCount = nil
						ent.CAT_HL2RP_ragdollRunCount = nil
					end
				end )
			else
				catherine.player.SetIgnoreScreenColor( ent, true )
				
				if ( active ) then
					catherine.util.ScreenColorEffect( ent, Color( 255, 255, 255 ), 0.7, 0.07 )
				else
					catherine.util.ScreenColorEffect( ent, Color( 255, 150, 150 ), 0.7, 0.07 )
				end
				
				if ( active ) then
					if ( ent:Health( ) - dmg <= 15 ) then
					
					else
						local dmgInfo = DamageInfo( )
						dmgInfo:SetInflictor( self )
						dmgInfo:SetAttacker( pl )
						dmgInfo:SetDamage( dmg / 1.5 )
						dmgInfo:SetDamageType( DMG_CLUB )
						dmgInfo:SetDamagePosition( tr.HitPos )
						dmgInfo:SetDamageForce( pl:GetAimVector( ) * 100 )
						
						ent:DispatchTraceAttack( dmgInfo, data.start, data.endpos )
					end
				else
					local dmgInfo = DamageInfo( )
					dmgInfo:SetInflictor( self )
					dmgInfo:SetAttacker( pl )
					dmgInfo:SetDamage( dmg )
					dmgInfo:SetDamageType( DMG_CLUB )
					dmgInfo:SetDamagePosition( tr.HitPos )
					dmgInfo:SetDamageForce( pl:GetAimVector( ) * 100 )
					
					ent:DispatchTraceAttack( dmgInfo, data.start, data.endpos )
					
					catherine.effect.Create( "BLOOD", {
						ent = ent,
						pos = dmgInfo:GetDamagePosition( ),
						scale = 1,
						decalCount = 1
					} )
				end
			end
			
			catherine.player.SetIgnoreScreenColor( ent, nil )
		end
	end
end

function SWEP:SecondaryAttack( )
	local pl = self.Owner
	
	pl:LagCompensation( true )
	
	local data = { }
	data.start = pl:GetShootPos( )
	data.endpos = data.start + pl:GetAimVector( ) * 72
	data.filter = pl
	data.mins = Vector( -8, -8, -30 )
	data.maxs = Vector( 8, 8, 10 )
	local ent = util.TraceHull( data ).Entity
	
	pl:LagCompensation( false )
	
	if ( SERVER and IsValid( ent ) ) then
		local pushed = false
		
		if ( ent:IsDoor( ) ) then
			pl:ViewPunch( Angle( -1.3, 1.8, 0 ) )
			pl:EmitSound( "physics/wood/wood_crate_impact_hard2.wav" )	
			pl:SetAnimation( PLAYER_ATTACK1 )
			
			self:SetNextSecondaryFire( CurTime( ) + 0.4 )
			self:SetNextPrimaryFire( CurTime( ) + 1 )
		elseif ( ent:IsPlayer( ) ) then
			local direct = pl:GetAimVector( ) * 180
			direct.z = 0
			
			ent:SetVelocity( direct )
			
			pushed = true
		else
			local physObject = ent:GetPhysicsObject( )
			
			if ( IsValid( physObject ) ) then
				physObject:SetVelocity( pl:GetAimVector( ) * 180 )
			end
			
			pushed = true
		end
			
		if ( pushed ) then
			self:SetNextSecondaryFire( CurTime( ) + 1.5 )
			self:SetNextPrimaryFire( CurTime( ) + 1.5 )
			pl:EmitSound( "weapons/crossbow/hitbod" .. math.random( 1, 2 ) .. ".wav" )
			
			if ( catherine.animation.IsClass( pl, "metrocop" ) ) then
				catherine.animation.StartSequence( pl, "pushplayer", nil )
			end
		end
	end
end

local STUNSTICK_GLOW_MATERIAL = Material( "effects/stunstick" )
local STUNSTICK_GLOW_MATERIAL2 = Material( "effects/blueflare1" )
local STUNSTICK_GLOW_MATERIAL_NOZ = Material( "sprites/light_glow02_add_noz" )
local col_glow = Color( 128, 128, 128 )

function SWEP:DrawWorldModel( )
	self:DrawModel( )
	
	if ( self:GetActive( ) ) then
		local size = math.Rand( 4.0, 6.0 )
		local glow = math.Rand( 0.6, 0.8 ) * 255
		local att = self:GetAttachment( 1 )
		
		if ( att ) then
			local pos = att.Pos
			
			render.SetMaterial( STUNSTICK_GLOW_MATERIAL2 )
			render.DrawSprite( pos, size * 2, size * 2, Color( glow, glow, glow ) )
			
			render.SetMaterial( STUNSTICK_GLOW_MATERIAL )
			render.DrawSprite( pos, size, size + 3, col_glow )
		end
	end
end

function SWEP:ViewModelDrawn( )
	if ( !self:GetActive( ) ) then return end

	local viewMdl = catherine.pl:GetViewModel( )

	if ( !IsValid( viewMdl ) ) then return end
	
	cam.Start3D( EyePos( ), EyeAngles( ) )
		local size = math.Rand( 3.0, 4.0 )
		local col = Color( 255, 255, 255, 100 + math.sin( RealTime( ) * 2 ) * 20 )
		
		STUNSTICK_GLOW_MATERIAL_NOZ:SetFloat( "$alpha", col.a / 255 )
		
		render.SetMaterial( STUNSTICK_GLOW_MATERIAL_NOZ )
		
		local att = viewMdl:GetAttachment( viewMdl:LookupAttachment( "sparkrear" ) )
		
		if ( att ) then
			render.DrawSprite( att.Pos, size * 10, size * 15, col)
		end
		
		for i = 1, 9 do
			local att = viewMdl:GetAttachment( viewMdl:LookupAttachment( "spark" .. i .. "a" ) )
			
			size = math.Rand( 2.5, 5.0 )
			
			if ( att and att.Pos ) then
				render.DrawSprite( att.Pos, size, size, col )
			end
			
			local att = viewMdl:GetAttachment( viewMdl:LookupAttachment( "spark" .. i .. "b" ) )
			
			size = math.Rand( 2.5, 5.0 )
			
			if ( att and att.Pos ) then
				render.DrawSprite( att.Pos, size, size, col )
			end
		end
	cam.End3D( )
end
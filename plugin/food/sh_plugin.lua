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
PLUGIN.name = "^Food_Plugin_Name"
PLUGIN.author = "L7D"
PLUGIN.desc = "^Food_Plugin_Desc"

catherine.language.Merge( "english", {
	[ "Food_Plugin_Name" ] = "Food",
	[ "Food_Plugin_Desc" ] = "Good stuff.",
	[ "Food_Plugin_NeedFood" ] = "You feeling hungry, need to eat foods.",
	[ "Food_Plugin_NeedWater" ] = "You feeling thirsty, need to drink water."
} )

catherine.language.Merge( "korean", {
	[ "Food_Plugin_Name" ] = "음식",
	[ "Food_Plugin_Desc" ] = "현실감 있게 허기와 갈증을 추가해줍니다.",
	[ "Food_Plugin_NeedFood" ] = "당신은 허기를 느끼고 있습니다, 음식을 먹어야 합니다.",
	[ "Food_Plugin_NeedWater" ] = "당신은 갈증을 느끼고 있습니다, 마실 것을 마셔야 합니다."
} )

if ( SERVER ) then
	function PLUGIN:PlayerDeath( pl )
		catherine.character.SetCharVar( pl, "hunger", 0 )
		catherine.character.SetCharVar( pl, "thirsty", 0 )
	end
	
	function PLUGIN:OnSpawnedInCharacter( pl )
		if ( hook.Run( "PlayerShouldHungerThirsty", pl ) == false ) then
			catherine.character.SetCharVar( pl, "hunger", 0 )
			catherine.character.SetCharVar( pl, "thirsty", 0 )
		end
	end
	
	function PLUGIN:PlayerThink( pl )
		if ( pl.CAT_HL2RP_damageNeed ) then
			if ( pl.CAT_HL2RP_damageWaitTick ) then
				if ( pl.CAT_HL2RP_damageWaitTick <= CurTime( ) ) then
					pl.CAT_HL2RP_damageWaitTick = nil
					pl.CAT_HL2RP_damageDelay = CurTime( ) + 7
				end
			else
				pl.CAT_HL2RP_damageWaitTick = CurTime( ) + 80
			end
			
			if ( pl.CAT_HL2RP_damageDelay and pl.CAT_HL2RP_damageDelay <= CurTime( ) ) then
				if ( pl:Alive( ) ) then
					pl:TakeDamage( math.random( 3, 7 ), pl, pl )
					pl.CAT_HL2RP_damageDelay = CurTime( ) + 7
				else
					pl.CAT_HL2RP_damageNeed = nil
					pl.CAT_HL2RP_damageWaitTick = nil
					pl.CAT_HL2RP_damageDelay = nil
				end
			end
		end
		
		if ( hook.Run( "PlayerShouldHungerThirsty", pl ) == false or !pl:Alive( ) ) then return end
		
		if ( ( catherine.character.GetCharVar( pl, "thirsty", 0 ) >= 95 or catherine.character.GetCharVar( pl, "hunger", 0 ) >= 95 ) and !pl.CAT_HL2RP_damageNeed ) then
			pl.CAT_HL2RP_damageNeed = true
		elseif ( pl.CAT_HL2RP_damageNeed ) then
			pl.CAT_HL2RP_damageNeed = nil
		end
		
		if ( ( pl.CAT_HL2RP_nextHungerTick or 0 ) <= CurTime( ) ) then
			local hunger = catherine.character.GetCharVar( pl, "hunger", 0 )
			
			catherine.character.SetCharVar( pl, "hunger", math.Clamp( hunger + 5, 0, 100 ) )
			
			pl.CAT_HL2RP_nextHungerTick = CurTime( ) + 350 + math.random( 50, 100 )
		end
		
		if ( ( pl.CAT_HL2RP_nextThirstyTick or 0 ) <= CurTime( ) ) then
			local thirsty = catherine.character.GetCharVar( pl, "thirsty", 0 )
			
			catherine.character.SetCharVar( pl, "thirsty", math.Clamp( thirsty + 5, 0, 100 ) )
			
			pl.CAT_HL2RP_nextThirstyTick = CurTime( ) + 150 + math.random( 50, 100 )
		end
	end
else
	function PLUGIN:PostRenderScreenColor( pl, data )
		local choose = math.max( catherine.character.GetCharVar( pl, "hunger", 0 ), catherine.character.GetCharVar( pl, "thirsty", 0 ) )
		
		if ( choose >= 80 ) then
			local per = 0.6 * ( choose / 100 )
			
			return {
				colour = math.max( 0.6 - per, 0.15 )
			}
		end
	end
	
	function PLUGIN:AddRPInformation( pnl, data, pl )
		if ( catherine.character.GetCharVar( pl, "hunger", 0 ) >= 80 ) then
			data[ #data + 1 ] = LANG( "Food_Plugin_NeedFood" )
		end
		
		if ( catherine.character.GetCharVar( pl, "thirsty", 0 ) >= 80 ) then
			data[ #data + 1 ] = LANG( "Food_Plugin_NeedWater" )
		end
	end
	
	do
		catherine.bar.Register( "hunger", false, function( pl )
				return catherine.character.GetCharVar( pl, "hunger", 0 )
			end, function( pl )
				return 100
			end, Color( 139, 90, 0 ), 15
		)
		
		catherine.bar.Register( "thirsty", false, function( pl )
				return catherine.character.GetCharVar( pl, "thirsty", 0 )
			end, function( pl )
				return 100
			end, Color( 99, 184, 255 ), 15
		)
	end
end
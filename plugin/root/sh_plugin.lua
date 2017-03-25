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
PLUGIN.name = "^Root_Plugin_Name"
PLUGIN.author = "L7D"
PLUGIN.desc = "^Root_Plugin_Desc"
CAT_ROOT_ACTION_GIVE = 1
CAT_ROOT_ACTION_TAKE = 2

catherine.util.Include( "sv_plugin.lua" )

catherine.language.Merge( "english", {
	[ "Root_Notify_AlreadyDoing" ] = "You are already rooting another player!",
	[ "Root_Notify_CantRoot" ] = "You can't root this player!",
	[ "Root_Plugin_Name" ] = "Root",
	[ "Root_Plugin_Desc" ] = "Good stuff."
} )

catherine.language.Merge( "korean", {
	[ "Root_Notify_AlreadyDoing" ] = "이미 당신은 루팅을 하고 있습니다!",
	[ "Root_Notify_CantRoot" ] = "이 사람을 루팅할 수 없습니다!",
	[ "Root_Plugin_Name" ] = "루팅",
	[ "Root_Plugin_Desc" ] = "다른 사람의 인벤토리를 볼 수 있습니다."
} )

catherine.command.Register( {
	uniqueID = "&uniqueID_charRoot",
	command = "charroot",
	desc = "Rooting the looking player.",
	runFunc = function( pl, args )
		if ( pl:GetNetVar( "rooting" ) ) then
			catherine.util.NotifyLang( pl, "Root_Notify_AlreadyDoing" )
			return
		end
		
		local data = { }
		data.start = pl:GetShootPos( )
		data.endpos = data.start + pl:GetAimVector( ) * 96
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
			PLUGIN:RootPlayer( pl, ent )
		else
			catherine.util.NotifyLang( pl, "Entity_Notify_NotPlayer" )
		end
	end
} )

if ( CLIENT ) then
	CAT_ITEM_OVERRIDE_DESC_TYPE_ROOT = 4
	CAT_ITEM_OVERRIDE_DESC_TYPE_ROOT_PLAYERINV = 5
	
	netstream.Hook( "catherine.hl2rp.plugin.root.OpenPanel", function( data )
		local pl = data[ 1 ]
		
		if ( !IsValid( pl ) ) then return end
		
		if ( IsValid( catherine.vgui.root ) ) then
			catherine.vgui.root:Remove( )
			catherine.vgui.root = nil
		end
		
		catherine.vgui.root = vgui.Create( "catherine.vgui.root" )
		catherine.vgui.root:InitializeRoot( pl, data[ 2 ] )
	end )
	
	netstream.Hook( "catherine.hl2rp.plugin.root.RefreshPanel", function( data )
		if ( IsValid( catherine.vgui.root ) ) then
			local pl = data[ 1 ]
			
			if ( !IsValid( pl ) ) then return end
			
			catherine.vgui.root:InitializeRoot( pl, data[ 2 ] )
		end
	end )
	
	function PLUGIN:CharacterVarChanged( pl, key )
		if ( key == "_inv" ) then
			if ( IsValid( catherine.vgui.root ) ) then
				catherine.vgui.root:InitializeRoot( nil, nil, true )
			end
		end
	end
end
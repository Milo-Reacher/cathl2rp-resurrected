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
PLUGIN.data = PLUGIN.data or { }

function PLUGIN:DataSave( )
	local data = {
		textData = self.data,
		entData = { }
	}
	
	local entData = data.entData
	
	for k, v in pairs( ents.FindByClass( "cat_hl2rp_note" ) ) do
		entData[ #entData + 1 ] = {
			pos = v:GetPos( ),
			ang = v:GetAngles( ),
			uniqueID = v:GetUniqueID( ),
			owner = v:GetNetVar( "owner" ),
			skin = v:GetSkin( ),
			col = v:GetColor( ),
			mat = v:GetMaterial( )
		}
	end
	
	catherine.data.Set( "note", data )
end

function PLUGIN:DataLoad( )
	local data = catherine.data.Get( "note", { } )
	
	self.data = data.textData or { }
	
	for k, v in pairs( data.entData or { } ) do
		local ent = ents.Create( "cat_hl2rp_note" )
		ent:SetPos( v.pos )
		ent:SetAngles( v.ang )
		ent:Spawn( )
		ent:SetSkin( v.skin or 0 )
		ent:SetColor( v.col or Color( 255, 255, 255, 255 ) )
		ent:SetMaterial( v.mat or "" )
		
		ent:SetNetVar( "uniqueID", v.uniqueID )
		
		if ( v.owner ) then
			ent:SetNetVar( "owner", v.owner )
		end
	end
end

function PLUGIN:GetText( uniqueID )
	return PLUGIN.data[ uniqueID ]
end

function PLUGIN:WriteNote( pl, ent, text )
	if ( !ent:CanEdit( pl ) ) then
		catherine.util.NotifyLang( pl, "Note_Notify_Error03" )
		return
	end
	
	if ( text == "" ) then
		catherine.util.NotifyLang( pl, "Note_Notify_Error01" )
		return
	end
	
	if ( text:utf8len( ) > PLUGIN.textmaxLen ) then
		catherine.util.NotifyLang( pl, "Note_Notify_Error02" )
		return
	end
	
	local uniqueID = "NOTE." .. ent:EntIndex( )
	
	PLUGIN.data[ uniqueID ] = text
	ent:SetNetVar( "uniqueID", uniqueID )
	ent:SetNetVar( "owner", pl:GetCharacterID( ) )
	
	catherine.entity.RegisterUseMenu( ent, {
		{
			uniqueID = "ID_VIEW",
			text = "^Note_ViewStr",
			icon = "icon16/note.png",
			func = function( pl, ent )
				netstream.Start( pl, "catherine.hl2rp.plugin.note.OpenPanel", {
					ent:EntIndex( ),
					PLUGIN:GetText( ent:GetUniqueID( ) )
				} )
			end
		}
	} )
	
	catherine.log.Add( CAT_LOG_FLAG_BASIC, pl:Name( ) .. ", " .. pl:SteamName( ) .. ", " .. pl:SteamID( ) .. " has writed a new note. < Value : " .. text .. " >" )
	
	PLUGIN:DataSave( )
end

netstream.Hook( "catherine.hl2rp.plugin.note.Write", function( pl, data )
	PLUGIN:WriteNote( pl, data[ 1 ], data[ 2 ] )
end )
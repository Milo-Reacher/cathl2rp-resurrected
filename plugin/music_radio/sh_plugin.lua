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
PLUGIN.name = "^MusicRadio_Plugin_Name"
PLUGIN.author = "L7D"
PLUGIN.desc = "^MusicRadio_Plugin_Desc"
PLUGIN.radioStations = {
	"http://www.kcrw.com/pls/kcrwmusic.pls",
	"http://www.dzve.nl/livefeed.m3u"
}

catherine.language.Merge( "english", {
	[ "MusicRadio_Plugin_Name" ] = "Music Radio",
	[ "MusicRadio_Plugin_Desc" ] = "Good stuff.",
	[ "Item_Name_MusicRadio" ] = "Music Radio",
	[ "Item_Desc_MusicRadio" ] = "Played the Music.",
	[ "Item_FuncStr01_MusicRadio" ] = "Place",
	[ "Item_FuncStr02_MusicRadio" ] = "Change Music",
	[ "Item_FuncStr03_MusicRadio" ] = "Toggle",
	[ "Item_FuncStr04_MusicRadio" ] = "Change Volume",
	[ "Item_VolumeQ_MusicRadio" ] = "Would you like to change the volume? (1 ~ 100)",
	[ "Item_VolumeQ_Notify_MusicRadio" ] = "The volume not a valid!",
	[ "Item_PlayingUI_MusicRadio" ] = "Playing ",
	[ "Item_StopUI_MusicRadio" ] = "Stopped "
} )

catherine.language.Merge( "korean", {
	[ "MusicRadio_Plugin_Name" ] = "음악 라디오",
	[ "MusicRadio_Plugin_Desc" ] = "음악 라디오를 추가합니다.",
	[ "Item_Name_MusicRadio" ] = "음악 라디오",
	[ "Item_Desc_MusicRadio" ] = "음악을 재생합니다.",
	[ "Item_FuncStr01_MusicRadio" ] = "장치하기",
	[ "Item_FuncStr02_MusicRadio" ] = "음악 바꾸기",
	[ "Item_FuncStr03_MusicRadio" ] = "전원 켜기/끄기",
	[ "Item_FuncStr04_MusicRadio" ] = "볼륨 조정",
	[ "Item_VolumeQ_MusicRadio" ] = "볼륨을 몇으로 조정하시겠습니까? (1 ~ 100)",
	[ "Item_VolumeQ_Notify_MusicRadio" ] = "올바르지 않은 볼륨 형식입니다!",
	[ "Item_PlayingUI_MusicRadio" ] = "재생중 ",
	[ "Item_StopUI_MusicRadio" ] = "정지됨 "
} )

if ( CLIENT ) then return end

function Schema:DataSave( )
	local data = { }

	for k, v in pairs( ents.FindByClass( "cat_hl2rp_music_radio" ) ) do
		data[ #data + 1 ] = {
			pos = v:GetPos( ),
			ang = v:GetAngles( ),
			active = v:GetNetVar( "active", false ),
			musicURL = v:GetNetVar( "musicURL", "http://www.kcrw.com/pls/kcrwmusic.pls" ),
			currIndex = v:GetNetVar( "currIndex", 1 ),
			volume = v:GetNetVar( "volume", 100 ),
			skin = v:GetSkin( ),
			col = v:GetColor( ),
			mat = v:GetMaterial( )
		}
	end
	
	catherine.data.Set( "music_radio", data )
end

function Schema:DataLoad( )
	local data = catherine.data.Get( "music_radio", { } )

	for k, v in pairs( data ) do
		local ent = ents.Create( "cat_hl2rp_music_radio" )
		ent:SetPos( v.pos )
		ent:SetAngles( v.ang )
		ent:Spawn( )
		ent:SetSkin( v.skin or 0 )
		ent:SetColor( v.col or Color( 255, 255, 255, 255 ) )
		ent:SetMaterial( v.mat or "" )
		
		ent:SetNetVar( "active", v.active )
		ent:SetNetVar( "musicURL", v.musicURL )
		ent:SetNetVar( "volume", v.volume )
		ent:SetNetVar( "currIndex", v.currIndex )
	end
end
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
PLUGIN.name = "^Note_Plugin_Name"
PLUGIN.author = "L7D"
PLUGIN.desc = "^Note_Plugin_Desc"
PLUGIN.textmaxLen = 1000

catherine.util.Include( "sv_plugin.lua" )

catherine.language.Merge( "english", {
	[ "Item_Name_Note" ] = "Notepad",
	[ "Item_Desc_Note" ] = "Can write text on this.",
	[ "Entity_Desc_Note01" ] = "Can write text on this.",
	[ "Entity_Desc_Note02" ] = "Something are writed.",
	[ "Note_Notify_Error01" ] = "Please write text!",
	[ "Note_Notify_Error02" ] = "Text are too long!",
	[ "Note_Notify_Error03" ] = "You can't edit this notepad's value!",
	[ "Item_FuncStr01_Note" ] = "Use",
	[ "Note_WriteStr" ] = "Write",
	[ "Note_ChangeStr" ] = "Change",
	[ "Note_ViewStr" ] = "View",
	[ "Note_Plugin_Name" ] = "Note",
	[ "Note_Plugin_Desc" ] = "Good stuff."
} )

catherine.language.Merge( "korean", {
	[ "Item_Name_Note" ] = "공책",
	[ "Item_Desc_Note" ] = "글씨를 쓸 수 있습니다.",
	[ "Entity_Desc_Note01" ] = "글씨를 쓸 수 있습니다.",
	[ "Entity_Desc_Note02" ] = "무언가가 쓰여있습니다.",
	[ "Note_Notify_Error01" ] = "글씨를 쓰십시오!",
	[ "Note_Notify_Error02" ] = "글씨가 너무 깁니다!",
	[ "Note_Notify_Error03" ] = "당신은 이 공책의 내용을 바꿀 수 없습니다!",
	[ "Item_FuncStr01_Note" ] = "사용",
	[ "Note_WriteStr" ] = "쓰기",
	[ "Note_ChangeStr" ] = "바꾸기",
	[ "Note_ViewStr" ] = "보기",
	[ "Note_Plugin_Name" ] = "공책",
	[ "Note_Plugin_Desc" ] = "공책에 글씨를 쓸 수 있습니다."
} )

if ( CLIENT ) then
	netstream.Hook( "catherine.hl2rp.plugin.note.OpenPanel", function( data )
		if ( IsValid( catherine.vgui.note ) ) then
			catherine.vgui.note:Remove( )
			catherine.vgui.note = nil
		end
		
		catherine.vgui.note = vgui.Create( "catherine.vgui.note" )
		catherine.vgui.note:InitializeNote( Entity( data[ 1 ] ), data[ 2 ] )
	end )
end
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
PLUGIN.name = "^Book_Plugin_Name"
PLUGIN.author = "L7D"
PLUGIN.desc = "^Book_Plugin_Desc"

catherine.language.Merge( "english", {
	[ "Item_Category_Book" ] = "Book",
	[ "Item_FuncStr01_Book" ] = "View",
	[ "Item_Name_Boyhood1" ] = "Boyhood - Chapter I : A Slow Journey",
	[ "Item_Desc_Boyhood1" ] = "A english novel book.",
	[ "Book_UI_Close" ] = "Close",
	[ "Book_Plugin_Name" ] = "Book",
	[ "Book_Plugin_Desc" ] = "Good stuff."
} )

catherine.language.Merge( "korean", {
	[ "Item_Category_Book" ] = "책",
	[ "Item_FuncStr01_Book" ] = "보기",
	[ "Item_Name_Boyhood1" ] = "Boyhood - Chapter I : A Slow Journey",
	[ "Item_Desc_Boyhood1" ] = "A english novel book.",
	[ "Book_UI_Close" ] = "닫기",
	[ "Book_Plugin_Name" ] = "책",
	[ "Book_Plugin_Desc" ] = "책을 추가합니다."
} )

if ( CLIENT ) then
	PLUGIN.amount = PLUGIN.amount or 0
	PLUGIN.alpha = PLUGIN.alpha or 0
	
	netstream.Hook( "catherine.hl2rp.plugin.book.OpenPanel", function( data )
		if ( IsValid( catherine.vgui.book ) ) then
			catherine.vgui.book:Remove( )
			catherine.vgui.book = nil
		end
		
		local itemTable = catherine.item.FindByID( data[ 2 ] )
		
		if ( !itemTable ) then return end
		
		catherine.vgui.book = vgui.Create( "catherine.vgui.book" )
		catherine.vgui.book:InitializeBook( Entity( data[ 1 ] ), itemTable.name, itemTable.html )
	end )
	
	function PLUGIN:HUDDrawTop( )
		if ( IsValid( catherine.vgui.book ) ) then
			self.amount = Lerp( 0.03, self.amount, 5 )
			self.alpha = Lerp( 0.03, self.alpha, 200 )
		else
			if ( self.amount > 0 ) then
				self.amount = Lerp( 0.03, self.amount, -1 )
			end
			
			if ( self.alpha > 0 ) then
				self.alpha = Lerp( 0.03, self.alpha, -1 )
			end
		end
		
		if ( self.alpha > 0 ) then
			draw.RoundedBox( 0, 0, 0, ScrW( ), ScrH( ), Color( 50, 50, 50, self.alpha ) )
		end
		
		if ( self.amount > 0 ) then
			catherine.util.BlurDraw( 0, 0, ScrW( ), ScrH( ), self.amount )
		end
	end
end
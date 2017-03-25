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
local PANEL = { }

function PANEL:Init( )
	catherine.vgui.book = self

	self.ent = nil
	self.entCheck = CurTime( ) + 1
	self.player = catherine.pl
	self.w, self.h = ScrW( ) * 0.7, ScrH( ) * 0.9
	self.x, self.y = ScrW( ) / 2 - self.w / 2, ScrH( ) / 2 - self.h / 2
	self.title = ""
	
	self:SetSize( self.w, self.h )
	self:SetPos( self.x, self.y )
	self:SetTitle( "" )
	self:MakePopup( )
	self:SetDraggable( false )
	self:ShowCloseButton( false )
	self:SetAlpha( 0 )
	self:AlphaTo( 255, 0.2, 0 )
	
	self.html = vgui.Create( "DHTML", self )
	self.html:SetPos( 10, 35 )
	self.html:SetSize( self.w - 20, self.h - 45 )
	
	self.close = vgui.Create( "catherine.vgui.button", self )
	self.close:SetPos( self.w - 30, 0 )
	self.close:SetSize( 30, 23 )
	self.close:SetStr( "X" )
	self.close:SetStrFont( "catherine_normal30" )
	self.close:SetStrColor( Color( 0, 0, 0, 255 ) )
	self.close.Click = function( )
		self:Close( )
	end
end

function PANEL:InitializeBook( ent, title, html )
	if ( !IsValid( ent ) ) then
		self:Close( )
		return
	end
	
	self.ent = ent
	self.title = catherine.util.StuffLanguage( title )
	self.html:SetHTML( type( html ) == "function" and html( ) or html )
end

function PANEL:Paint( w, h )
	catherine.theme.Draw( CAT_THEME_MENU_BACKGROUND, w, h )
	draw.RoundedBox( 0, 0, 0, w, 25, Color( 255, 255, 255, 255 ) )
	
	draw.SimpleText( self.title, "catherine_lightUI20", 10, 13, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, 1 )
end

function PANEL:Think( )
	if ( ( self.entCheck or 0 ) <= CurTime( ) ) then
		if ( !IsValid( self.ent ) and !self.closing ) then
			self:Close( )
			return
		end
		
		self.entCheck = CurTime( ) + 0.5
	end
end

function PANEL:Close( )
	if ( self.closing ) then return end
	
	self.closing = true
	self:Remove( )
	self = nil
	
	--[[ // ?;
	self:AlphaTo( 0, 0,2, 0, function( )
		self:Remove( )
		self = nil
	end )
	--]]
end

vgui.Register( "catherine.vgui.book", PANEL, "DFrame" )
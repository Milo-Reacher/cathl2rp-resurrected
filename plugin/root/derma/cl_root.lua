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
	catherine.vgui.root = self

	self.entCheck = CurTime( ) + 1
	self.player = catherine.pl
	self.w, self.h = ScrW( ) * 0.8, ScrH( ) * 0.8
	self.x, self.y = ScrW( ) / 2 - self.w / 2, ScrH( ) / 2 - self.h / 2

	self:SetSize( self.w, self.h )
	self:SetPos( self.x, self.y )
	self:SetTitle( "" )
	self:MakePopup( )
	self:SetDraggable( false )
	self:ShowCloseButton( false )
	self:SetAlpha( 0 )
	self:AlphaTo( 255, 0.2, 0 )
	
	self.targetInv = vgui.Create( "DPanelList", self )
	self.targetInv:SetPos( 10, 55 )
	self.targetInv:SetSize( self.w / 2 - 20, self.h - 65 )
	self.targetInv:SetSpacing( 5 )
	self.targetInv:EnableHorizontal( false )
	self.targetInv:EnableVerticalScrollbar( true )
	self.targetInv:SetDrawBackground( false )
	
	self.playerInv = vgui.Create( "DPanelList", self )
	self.playerInv:SetPos( self.w / 2, 55 )
	self.playerInv:SetSize( self.w / 2 - 10, self.h - 65 )
	self.playerInv:SetSpacing( 5 )
	self.playerInv:EnableHorizontal( false )
	self.playerInv:EnableVerticalScrollbar( true )
	self.playerInv:SetDrawBackground( false )

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

function PANEL:Paint( w, h )
	catherine.theme.Draw( CAT_THEME_MENU_BACKGROUND, w, h )
	draw.RoundedBox( 0, 0, 0, w, 25, Color( 255, 255, 255, 255 ) )
	
	if ( !IsValid( self.ent ) ) then return end
	local name = self.ent:Name( )
	
	if ( name ) then
		draw.SimpleText( name, "catherine_lightUI20", 10, 13, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, 1 )
		draw.SimpleText( LANG( "Cash_UI_TargetHasStr", catherine.cash.GetCompleteName( self.cash ) ), "catherine_lightUI15", 10, 40, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, 1 )
	end
	
	draw.SimpleText( self.player:Name( ), "catherine_lightUI20", w / 2, 13, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, 1 )
	draw.SimpleText( LANG( "Cash_UI_HasStr", catherine.cash.GetCompleteName( catherine.cash.Get( self.player ) ) ), "catherine_lightUI15", w / 2, 40, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, 1 )
end

function PANEL:InitializeRoot( ent, inv, onlyLocalInv )
	if ( onlyLocalInv ) then
		local tab = { }
		
		for k, v in pairs( catherine.inventory.Get( ) ) do
			local itemTable = catherine.item.FindByID( k )
			
			if ( !itemTable ) then continue end
			
			local category = itemTable.category
			
			tab[ category ] = tab[ category ] or { }
			tab[ category ][ k ] = v
		end
		
		self.playerInventory = tab
		
		self:RebuildRoot( )
	else
		self.ent = ent
		self.cash = catherine.cash.Get( ent )
		
		local tab = { }
		
		for k, v in pairs( inv ) do
			local itemTable = catherine.item.FindByID( k )
			
			if ( !itemTable ) then continue end
			
			local category = itemTable.category
			
			tab[ category ] = tab[ category ] or { }
			tab[ category ][ k ] = v
		end
		
		self.targetInventory = tab
		
		tab = { }
		
		for k, v in pairs( catherine.inventory.Get( ) ) do
			local itemTable = catherine.item.FindByID( k )
			
			if ( !itemTable ) then continue end
			
			local category = itemTable.category
			
			tab[ category ] = tab[ category ] or { }
			tab[ category ][ k ] = v
		end
		
		self.playerInventory = tab
		
		self:RebuildRoot( )
	end
end

function PANEL:RebuildRoot( )
	if ( !self.targetInventory or !self.playerInventory ) then return end
	local pl = self.player
	local target = self.ent
	
	local targetInv_scrollBar = self.targetInv.VBar
	local targetInv_scroll = targetInv_scrollBar.Scroll
	
	local playerInv_scrollBar = self.playerInv.VBar
	local playerInv_scroll = playerInv_scrollBar.Scroll
	
	self.targetInv:Clear( )
	self.playerInv:Clear( )
	
	for k, v in SortedPairs( self.targetInventory ) do
		local form = vgui.Create( "DForm" )
		form:SetSize( self.targetInv:GetWide( ), 54 )
		form:SetName( catherine.util.StuffLanguage( k ) )
		form:SetName( catherine.util.StuffLanguage( k ):upper( ) )
		form.Paint = function( pnl, w, h ) end
		form.Header:SetFont( "catherine_lightUI25" )
		form.Header:SetTall( 25 )
		form.Header:SetTextColor( Color( 255, 255, 255, 255 ) )
		
		local lists = vgui.Create( "DPanelList", form )
		lists:SetSize( form:GetWide( ), form:GetTall( ) )
		lists:SetSpacing( 3 )
		lists:EnableHorizontal( true )
		lists:EnableVerticalScrollbar( false )	
		
		form:AddItem( lists )
		
		for k1, v1 in SortedPairsByMemberValue( v, "uniqueID" ) do
			local w, h = 54, 54
			local itemTable = catherine.item.FindByID( k1 )
			local itemData = v1.itemData
			local overrideItemDesc = itemTable.GetOverrideItemDesc and itemTable:GetOverrideItemDesc( target, itemData, CAT_ITEM_OVERRIDE_DESC_TYPE_ROOT ) or nil
			local itemDesc = itemTable.GetDesc and itemTable:GetDesc( target, itemData, true ) or nil
			local model = itemTable.GetDropModel and itemTable:GetDropModel( ) or itemTable.model
			local noDrawItemCount = hook.Run( "NoDrawItemCount", target, itemTable )
			
			local spawnIcon = vgui.Create( "SpawnIcon" )
			spawnIcon:SetSize( w, h )
			spawnIcon:SetModel( model, itemTable.skin or 0 )
			
			if ( overrideItemDesc ) then
				spawnIcon:SetToolTip( overrideItemDesc )
			else
				spawnIcon:SetToolTip( catherine.item.GetBasicDesc( itemTable ) .. ( itemDesc and "\n" .. itemDesc or "" ) )
			end
			
			spawnIcon.DoClick = function( )
				if ( !IsValid( target ) ) then
					return
				end
				
				netstream.Start( "catherine.hl2rp.plugin.root.Work", {
					self.ent,
					CAT_ROOT_ACTION_TAKE,
					{ uniqueID = k1 }
				} )
			end
			spawnIcon.PaintOver = function( pnl, w, h )
				if ( !IsValid( target ) ) then
					return
				end
				
				if ( v1.itemData.equiped ) then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( Material( "CAT/ui/accept.png" ) )
					surface.DrawTexturedRect( 5, 5, 16, 16 )
				end
				
				if ( itemTable.DrawInformation ) then
					itemTable:DrawInformation( target, w, h, itemData )
				end
				
				if ( !noDrawItemCount and v1.itemCount > 1 ) then
					local count = v1.itemCount
					
					surface.SetFont( "catherine_normal20" )
					local tw, th = surface.GetTextSize( count )
					
					draw.RoundedBox( 0, 5 - tw / 2, h - 20, tw * 2, 20, Color( 255, 255, 255, 200 ) )
					draw.SimpleText( count, "catherine_normal20", 5, h - 20, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT )
				end
			end
			
			lists:AddItem( spawnIcon )
		end
		
		self.targetInv:AddItem( form )
	end
	
	for k, v in SortedPairs( self.playerInventory ) do
		local form = vgui.Create( "DForm" )
		form:SetSize( self.playerInv:GetWide( ), 54 )
		form:SetName( catherine.util.StuffLanguage( k ):upper( ) )
		form.Paint = function( pnl, w, h ) end
		form.Header:SetFont( "catherine_lightUI25" )
		form.Header:SetTall( 25 )
		form.Header:SetTextColor( Color( 255, 255, 255, 255 ) )
		
		local lists = vgui.Create( "DPanelList", form )
		lists:SetSize( form:GetWide( ), form:GetTall( ) )
		lists:SetSpacing( 3 )
		lists:EnableHorizontal( true )
		lists:EnableVerticalScrollbar( false )	
		
		form:AddItem( lists )
		
		for k1, v1 in SortedPairsByMemberValue( v, "uniqueID" ) do
			local w, h = 54, 54
			local itemTable = catherine.item.FindByID( k1 )
			local itemData = pl:GetInvItemDatas( k1 )
			local overrideItemDesc = itemTable.GetOverrideItemDesc and itemTable:GetOverrideItemDesc( pl, itemData, CAT_ITEM_OVERRIDE_DESC_TYPE_ROOT_PLAYERINV ) or nil
			local itemDesc = itemTable.GetDesc and itemTable:GetDesc( pl, itemData, true ) or nil
			local model = itemTable.GetDropModel and itemTable:GetDropModel( ) or itemTable.model
			local noDrawItemCount = hook.Run( "NoDrawItemCount", pl, itemTable )
			
			local spawnIcon = vgui.Create( "SpawnIcon" )
			spawnIcon:SetSize( w, h )
			spawnIcon:SetModel( model, itemTable.skin or 0 )
			
			if ( overrideItemDesc ) then
				spawnIcon:SetToolTip( overrideItemDesc )
			else
				spawnIcon:SetToolTip( catherine.item.GetBasicDesc( itemTable ) .. ( itemDesc and "\n" .. itemDesc or "" ) )
			end
			
			spawnIcon.DoClick = function( )
				netstream.Start( "catherine.hl2rp.plugin.root.Work", {
					self.ent,
					CAT_ROOT_ACTION_GIVE,
					{ uniqueID = k1 }
				} )
			end
			spawnIcon.PaintOver = function( pnl, w, h )
				if ( catherine.inventory.IsEquipped( k1 ) ) then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( Material( "CAT/ui/accept.png" ) )
					surface.DrawTexturedRect( 5, 5, 16, 16 )
				end
				
				if ( itemTable.DrawInformation ) then
					itemTable:DrawInformation( pl, w, h, itemData )
				end
				
				if ( !noDrawItemCount and v1.itemCount > 1 ) then
					local count = v1.itemCount
					
					surface.SetFont( "catherine_normal20" )
					local tw, th = surface.GetTextSize( count )
					
					draw.RoundedBox( 0, 5 - tw / 2, h - 20, tw * 2, 20, Color( 255, 255, 255, 200 ) )
					draw.SimpleText( count, "catherine_normal20", 5, h - 20, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT )
				end
			end
			
			lists:AddItem( spawnIcon )
		end
		
		self.playerInv:AddItem( form )
	end
	
	targetInv_scrollBar:AnimateTo( targetInv_scroll, 0.3, 0, 0.1 )
	playerInv_scrollBar:AnimateTo( playerInv_scroll, 0.3, 0, 0.1 )
end

function PANEL:Think( )
	if ( ( self.entCheck or 0 ) <= CurTime( ) ) then
		if ( !IsValid( self.ent ) and !self.closing ) then
			self:Close( )
			
			return
		end
		
		self.entCheck = CurTime( ) + 0.3
	end
end

function PANEL:Close( )
	if ( self.closing ) then return end
	
	self.closing = true
	
	self:AlphaTo( 0, 0.2, 0, function( )
		self:Remove( )
		self = nil
	end )
	
	netstream.Start( "catherine.hl2rp.plugin.root.RootClose" )
end

vgui.Register( "catherine.vgui.root", PANEL, "DFrame" )
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

Schema.combineOverlayMessage = {
	"^CombineOverlay_Str01",
	"^CombineOverlay_Str02",
	"^CombineOverlay_Str03",
	"^CombineOverlay_Str04",
	"^CombineOverlay_Str05",
	"^CombineOverlay_Str06",
	"^CombineOverlay_Str07",
	"^CombineOverlay_Str08",
	"^CombineOverlay_Str09"
}
Schema.playercombineOverlays = { }
local combineOverlayMaterial

function Schema:GetSchemaInformation( )
	return {
		title = catherine.util.StuffLanguage( Schema.IntroTitle ),
		desc = catherine.util.StuffLanguage( Schema.IntroDesc ),
		author = LANG( "Basic_Schema_Author", Schema.Author )
	}
end

function Schema:PrefixCombineOverlayMessage( )
	return "< ::: "
end

function Schema:GetCharacterPanelLoadModel( characterDatas )
	if ( characterDatas._faction == "cp" and characterDatas._name:find( "SCN" ) ) then
		return "models/combine_scanner.mdl"
	end
	
	return characterDatas._model
end

function Schema:LanguageChanged( )
	self.vo.RegisterHelp( )
end

function Schema:PostRenderScreenColor( pl, data )
	if ( !pl:Alive( ) ) then return end
	if ( catherine.deathColAlpha < 0.6 ) then return end
	local antidepressants = catherine.character.GetCharVar( pl, "antidepressants_status" )
	
	if ( antidepressants == true ) then
		if ( !self.antidepressantsData ) then
			self.antidepressantsData = 0.6
		end
		
		self.antidepressantsData = Lerp( 0.003, self.antidepressantsData, 1 )
	else
		if ( self.antidepressantsData ) then
			self.antidepressantsData = Lerp( 0.003, self.antidepressantsData, 0.6 )
			
			if ( self.antidepressantsData <= 0.63 ) then
				self.antidepressantsData = nil
			end
		end
	end
	
	return {
		colour = self.antidepressantsData and self.antidepressantsData or 0.6
	}
end

function Schema:AutomaticCombineOverlayMessage( )
	local index = #self.playercombineOverlays + 1
	local randMessage = catherine.util.StuffLanguage( table.Random( self.combineOverlayMessage ) )

	self.playercombineOverlays[ index ] = {
		message = "",
		a = 0,
		y = 20 + ( ( index + 1 ) * 20 ),
		time = CurTime( ) + 6,
		textTime = CurTime( ),
		textMakeDelay = 0.03,
		textSubCount = 1,
		gradientW = 0,
		originalMessage = self:PrefixCombineOverlayMessage( ) .. randMessage,
		col = Color( 255, 255, 255 )
	}
end

function Schema:AddCombineOverlayMessage( message, time, col, textMakeDelay )
	local index = #self.playercombineOverlays + 1
	
	self.playercombineOverlays[ index ] = {
		message = "",
		a = 0,
		y = 20 + ( ( index + 1 ) * 20 ),
		time = CurTime( ) + time,
		textTime = CurTime( ),
		textMakeDelay = textMakeDelay,
		textSubCount = 1,
		gradientW = 0,
		originalMessage = self:PrefixCombineOverlayMessage( ) .. message,
		col = col or Color( 255, 255, 255 )
	}
end

function Schema:OverrideCombineOverlayPos( x, y )

end

function Schema:ShouldDrawCombineOverlay( pl )

end

function Schema:HUDDrawBarBottom( x, y )
	if ( !catherine.pl:PlayerIsCombine( ) or hook.Run( "ShouldDrawCombineOverlay", catherine.pl ) == false ) then return end
	local newX, newY = hook.Run( "OverrideCombineOverlayPos", x, y )
	
	self:DrawCombineOverlay( newX or x, newY or y )
end

function Schema:OverwatchHUDBackgroundDraw( )
	self.overwatchHUDData = self.overwatchHUDData or { }
	
	for i = 1, 100 do
		self.overwatchHUDData[ i ] = self.overwatchHUDData[ i ] or {
			w = 0,
			targetW = math.random( 1, 150 ),
			a = math.Rand( 0, 5 )
		}
		
		local data = self.overwatchHUDData[ i ]

		data.w = Lerp( 0.01, data.w, data.targetW + ( 10 / 1 ) * math.sin( CurTime( ) + math.Rand( 0, 2 ) ) )
		
		self.overwatchHUDData[ i ] = data
		
		local h = ScrH( ) * 0.05 + ( ScrH( ) * ( i / 100 ) )
		
		draw.RoundedBox( 0, 0, h, data.w, 5, Color( 255, 255, 255, data.a ) )
		draw.RoundedBox( 0, ScrW( ) - data.w, h, data.w, 5, Color( 255, 255, 255, data.a ) )
	end
end

function Schema:DrawCombineOverlay( x, y )
	for k, v in pairs( self.playercombineOverlays ) do
		if ( v.time <= CurTime( ) ) then
			v.a = Lerp( 0.06, v.a, 0 )
			
			if ( math.Round( v.a ) <= 0 ) then
				table.remove( self.playercombineOverlays, k )
			end
		else
			v.a = Lerp( 0.06, v.a, 255 )
		end
		
		v.y = Lerp( 0.06, v.y, ( y ) + ( k * 20 ) )
		
		if ( v.textTime <= CurTime( ) and v.message:utf8len( ) < v.originalMessage:utf8len( ) ) then
			local text =  v.originalMessage:utf8sub( v.textSubCount, v.textSubCount )
			
			v.message = v.message .. text
			v.textSubCount = v.textSubCount + 1
			v.textTime = CurTime( ) + v.textMakeDelay
			v.gradientW = v.gradientW + 5
		end
		
		surface.SetDrawColor( v.col.r, v.col.g, v.col.b, v.a - 130 )
		surface.SetMaterial( Material( "gui/gradient" ) )
		surface.DrawTexturedRect( x, v.y + 10, v.gradientW, 1 )

		draw.SimpleText( v.message, "catherine_hl2rp_combineOverlay", x, v.y, Color( v.col.r, v.col.g, v.col.b, v.a ), TEXT_ALIGN_LEFT, 1 )
	end
end

function Schema:HUDBackgroundDraw( )
	if ( !catherine.pl:PlayerIsCombine( ) ) then return end
	
	if ( !combineOverlayMaterial ) then
		combineOverlayMaterial = Material( "effects/combine_binocoverlay" )
		combineOverlayMaterial:SetFloat( "$alpha", "0.6" )
		combineOverlayMaterial:Recompute( )
	end
	
	surface.SetDrawColor( 255, 255, 255, 50 )
	surface.SetMaterial( combineOverlayMaterial )
	surface.DrawTexturedRect( 0, 0, ScrW( ), ScrH( ) )
	
	if ( catherine.pl:Team( ) == FACTION_OW ) then
		hook.Run( "OverwatchHUDBackgroundDraw" )
	end
end

function Schema:HUDDraw( )
	local pl = catherine.pl
	if ( !pl:Alive( ) or !pl:HasItem( "portable_radio" ) or pl:GetInvItemData( "portable_radio", "toggle", false ) == false ) then return end
	local freq = pl:GetInvItemData( "portable_radio", "freq", "000.0" )
	local x, y = 15, ScrH( ) * 0.4
	local signal = pl:GetNetVar( "radioSignal", 0 )

	if ( !pl.CAT_HL2RP_radioSignalLast ) then
		pl.CAT_HL2RP_radioSignalLast = signal
	end
	
	if ( !pl.CAT_HL2RP_radioSignalTable ) then
		pl.CAT_HL2RP_radioSignalTable = { }
	end
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( Material( "CAT_HL2RP/antenna.png", "smooth" ) )
	surface.DrawTexturedRect( x, y, 42, 42 )

	if ( signal == 0 ) then
		draw.SimpleText( "X", "catherine_normal20", x + 50, y + 40, Color( 255, 0, 0, 255 ), TEXT_ALIGN_LEFT, 1 )
	else
		if ( pl.CAT_HL2RP_radioSignalLast != signal ) then
			pl.CAT_HL2RP_radioSignalTable = { }
			
			for i = 1, signal do
				local col = Color( 255, 255, 255, 255 )
				
				if ( signal == 1 ) then
					col = Color( 255, 0, 0, 255 )
				elseif ( signal == 2 ) then
					col = Color( 255, 255, 0, 255 )
				end
		
				pl.CAT_HL2RP_radioSignalTable[ #pl.CAT_HL2RP_radioSignalTable + 1 ] = {
					h = 0,
					targetH = 10 * i,
					col = col
				}
			end
			
			pl.CAT_HL2RP_radioSignalLast = signal
		end

		for k, v in pairs( pl.CAT_HL2RP_radioSignalTable ) do
			v.h = math.Approach( v.h, v.targetH, 0.7 )
			draw.RoundedBox( 0, ( x + 40 ) + 7 * k, ( y + 40 ) - v.h, 5, v.h, v.col )
		end
	end
	
	draw.SimpleText( freq, "catherine_normal15", x + 5, y + 55, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, 1 )
end

function Schema:Think( )
	local pl = catherine.pl
	if ( !pl:PlayerIsCombine( ) or !pl:Alive( ) ) then return end
	if ( !pl.CAT_HL2RP_nextCombineOverlay ) then pl.CAT_HL2RP_nextCombineOverlay = CurTime( ) end
	
	if ( pl.CAT_HL2RP_nextCombineOverlay <= CurTime( ) ) then
		self:AutomaticCombineOverlayMessage( )
		pl.CAT_HL2RP_nextCombineOverlay = CurTime( ) + 4
	end
end

catherine.font.Register( "catherine_hl2rp_combineOverlay", {
	font = "Consolas",
	size = 15,
	weight = 1000
} )

netstream.Hook( "catherine.Schema.AddCombineOverlayMessage", function( data )
	Schema:AddCombineOverlayMessage( data[ 1 ], data[ 2 ], data[ 3 ], data[ 4 ] )
end )

netstream.Hook( "catherine.Schema.ClearCombineOverlayMessages", function( )
	Schema.playercombineOverlays = { }
end )
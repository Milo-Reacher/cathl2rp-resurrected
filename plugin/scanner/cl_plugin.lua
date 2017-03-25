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
local isHidden = false
local zoom = 0
local deltaZoom = zoom

netstream.Hook( "catherine.hl2rp.plugin.scanner.BroadcastCaptureData", function( data )
	local caller = data.caller
	local captureData = util.Base64Encode( util.Decompress( data.captureData ) )
	
	if ( catherine.pl:GetNetVar( "isScanner" ) ) then
		PLUGIN:CreateCapturePanel( captureData, true )
	else
		PLUGIN:CreateCapturePanel( captureData )
	end
end )
	
function PLUGIN:CalcView( pl, pos, ang, fov )
	local viewEnt = pl:GetViewEntity( )
	
	if ( IsValid( viewEnt ) and viewEnt:GetClass( ):find( "scanner" ) ) then
		return {
			angles = pl:GetAimVector( ):Angle( ),
			fov = fov - deltaZoom
		}
	end
end

function PLUGIN:PlayerBindPress( pl, code, pressed )
	if ( code:find( "+attack" ) and pressed and pl:GetNetVar( "isScanner" ) and isHidden ) then
		self:Capture( pl )
	end
end

function PLUGIN:Capture( pl )
	if ( ( self.nextCanCapture or 0 ) <= CurTime( ) ) then
		local scrW, scrH = ScrW( ), ScrH( )
		
		local light = DynamicLight( 0 )
		
		if ( light ) then
			light.r = 255
			light.g = 255
			light.b = 255
			light.brightness = 3
			light.Decay = 5000
			light.Size = 3000
			light.DieTime = CurTime( ) + 0.5
			light.pos = self.lastViewEnt:GetPos( )
		end
		
		timer.Simple( 0.05, function( )
			local data = util.Compress( render.Capture( {
				format = "jpeg",
				quality = 35,
				w = scrW / 2 / 2 + 67,
				h = scrH / 2 - 32,
				x = scrW / 2 - scrW / 2 / 2 / 2 - 29,
				y = scrH / 2 - scrH / 4 + 21
			} ) )
			
			netstream.Start( "catherine.hl2rp.plugin.scanner.ReceiveCaptureData", data )
		end )
		
		self.nextCanCapture = CurTime( ) + 10 + math.random( 5, 10 )
	end
end

function PLUGIN:CreateCapturePanel( data, isScanner )
	local prevPanel = self.prevPanel
	local panelW, panelH = 362, 356
	
	if ( isScanner ) then
		if ( IsValid( prevPanel ) ) then
			prevPanel:MoveTo( 0 - panelW, 10, 0.5, 0, nil, function( )
				prevPanel:Remove( )
				prevPanel = nil
			end )
		end
	else
		if ( IsValid( prevPanel ) ) then
			prevPanel:MoveTo( ScrW( ), 10, 0.5, 0, nil, function( )
				prevPanel:Remove( )
				prevPanel = nil
			end )
		end
	end
	
	local code = Format( [[
		<html>
			<body style="background: black; overflow: hidden; margin: 0; padding: 0;">
				<img src="data:image/jpeg;base64,%s" width="%s" height="%s" />
			</body>
		</html>
	]], data, panelW, panelH )
	
	
	if ( isScanner ) then
		local panel = vgui.Create( "DPanel" )
		panel:SetSize( panelW, panelH )
		panel:SetPos( 0 - panelW, 10 )
		panel.Paint = function( pnl, w, h )
			draw.RoundedBox( 0, 0, 0, w, 2, Color( 255, 255, 255, 255 ) )
			draw.RoundedBox( 0, 0, 0, 2, h, Color( 255, 255, 255, 255 ) )
			draw.RoundedBox( 0, w - 2, 0, 2, h, Color( 255, 255, 255, 255 ) )
			draw.RoundedBox( 0, 0, h - 2, w, 2, Color( 255, 255, 255, 255 ) )
		end
		
		local html = vgui.Create( "DHTML", panel )
		html:Dock( FILL )
		html:DockMargin( 4, 4, 4, 4 )
		html:SetHTML( code )
		
		panel:MoveTo( 10, 10, 0.5, 0 )
		self.prevPanel = panel
		
		timer.Simple( 15, function( )
			if ( IsValid( panel ) ) then
				panel:MoveTo( 0 - panelW, 10, 0.5, 0, nil, function( )
					panel:Remove( )
				end )
			end
		end )
	else
		local panel = vgui.Create( "DPanel" )
		panel:SetSize( panelW, panelH )
		panel:SetPos( ScrW( ), 10 )
		panel.Paint = function( pnl, w, h )
			draw.RoundedBox( 0, 0, 0, w, 2, Color( 255, 255, 255, 255 ) )
			draw.RoundedBox( 0, 0, 0, 2, h, Color( 255, 255, 255, 255 ) )
			draw.RoundedBox( 0, w - 2, 0, 2, h, Color( 255, 255, 255, 255 ) )
			draw.RoundedBox( 0, 0, h - 2, w, 2, Color( 255, 255, 255, 255 ) )
		end
		
		local html = vgui.Create( "DHTML", panel )
		html:Dock( FILL )
		html:DockMargin( 4, 4, 4, 4 )
		html:SetHTML( code )
		
		panel:MoveTo( ScrW( ) - panelW - 10, 10, 0.5, 0 )
		self.prevPanel = panel
		
		timer.Simple( 15, function( )
			if ( IsValid( panel ) ) then
				panel:MoveTo( ScrW( ), 10, 0.5, 0, nil, function( )
					panel:Remove( )
				end )
			end
		end )
	end
end

function PLUGIN:PreDrawOpaqueRenderables( )
	local viewEnt = catherine.pl:GetViewEntity( )
	
	if ( IsValid( self.lastViewEnt ) and self.lastViewEnt != viewEnt ) then
		self.lastViewEnt:SetNoDraw( false )
		self.lastViewEnt = nil
		
		isHidden = false
	end
	
	if ( IsValid( viewEnt ) and viewEnt:GetClass( ):find( "scanner" ) ) then
		viewEnt:SetNoDraw( true )
		self.lastViewEnt = viewEnt
		
		isHidden = true
	end
end

function PLUGIN:RenderScreenspaceEffects( )
	if ( isHidden and catherine.pl:GetNetVar( "isScanner" ) ) then
		local tab = { }
		tab[ "$pp_colour_addr" ] = 0.3
		tab[ "$pp_colour_addg" ] = 0.1
		tab[ "$pp_colour_addb" ] = 0
		tab[ "$pp_colour_brightness" ] = 0
		tab[ "$pp_colour_contrast" ] = 1
		tab[ "$pp_colour_colour" ] = 0.9
		tab[ "$pp_colour_mulr" ] = 0
		tab[ "$pp_colour_mulg" ] = 0
		tab[ "$pp_colour_mulb" ] = 0
		
		DrawColorModify( tab )
	end
end

function PLUGIN:ShouldDrawBar( pl )
	if ( pl:GetNetVar( "isScanner" ) ) then
		return false
	end
end

function PLUGIN:PlayerCanNoClip( pl )
	if ( pl:GetNetVar( "isScanner" ) ) then
		return false
	end
end

function PLUGIN:InputMouseApply( cmd, x, y, ang )
	zoom = math.Clamp( zoom + cmd:GetMouseWheel( ) * 1.5, 0, 40 )
	deltaZoom = Lerp( FrameTime( ) * 2, deltaZoom, zoom )
end

function PLUGIN:AdjustMouseSensitivity( )
	if ( catherine.pl:GetNetVar( "isScanner" ) and isHidden ) then
		return 0.3
	end
end

function PLUGIN:HUDDraw( )
	if ( !isHidden or !catherine.pl:GetNetVar( "isScanner" ) or !catherine.pl:Alive( ) ) then return end
	local scrW, scrH = ScrW( ), ScrH( )
	
	draw.NoTexture( )
	surface.SetDrawColor( 0, 0, 0, 100 )
	catherine.geometry.DrawCircle( scrW / 2, scrH / 2, scrH / 4 - 20, scrW, 10, 360, 50 )
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	
	surface.DrawLine( scrW / 2 - scrW / 2 / 2 / 2 - 30, scrH / 2 - scrH / 2 / 2 + 20, scrW / 2 + scrW / 2 / 2 / 2 + 30, scrH / 2 - scrH / 2 / 2 + 20 )
	surface.DrawLine( scrW / 2 - scrW / 2 / 2 / 2 - 30, scrH / 2 + scrH / 2 / 2 - 20, scrW / 2 + scrW / 2 / 2 / 2 + 30, scrH / 2 + scrH / 2 / 2 - 20 )
	surface.DrawLine( scrW / 2 - scrW / 2 / 2 / 2 - 30, scrH / 2 + scrH / 2 / 2, scrW / 2 - scrW / 2 / 2 / 2 - 30, scrH / 4 )
	surface.DrawLine( scrW / 2 + scrW / 2 / 2 / 2 + 30, scrH / 2 + scrH / 2 / 2, scrW / 2 + scrW / 2 / 2 / 2 + 30, scrH / 4 )
	
	local pl = catherine.pl
	local pos = pl:GetPos( )
	local ang = pl:GetAngles( )
	
	draw.SimpleText( "SCANNER SYSTEM", "catherine_hl2rp_scanner25", 10, 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, 1 )
	draw.SimpleText( "POWER ( " .. pl:Health( ) .. "% )", "catherine_hl2rp_scanner25", scrW - 10, 75, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, 1 )
	draw.SimpleText( "POSITION ( X:" .. math.floor( pos[ 1 ] ) .. ", Y:" .. math.floor( pos[ 2 ] ) .. ", Z:" .. math.floor( pos[ 3 ] ) .. " )", "catherine_hl2rp_scanner15", scrW - 10, scrH - 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, 1 )
	draw.SimpleText( "ANGLES ( P:" .. math.floor( ang[ 1 ] ) .. ", Y:" .. math.floor( ang[ 2 ] ) .. ", R:" .. math.floor( ang[ 3 ] ) .. " )", "catherine_hl2rp_scanner15", scrW - 10, scrH - 40, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, 1 )
	draw.SimpleText( "UNIT #" .. pl:Name( ) .. "", "catherine_hl2rp_scanner30", scrW - 10, 50, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, 1 )
	draw.SimpleText( "ZOOM  ( " .. ( math.Round( zoom / 40, 2 ) * 100 ) .. "% )", "catherine_hl2rp_scanner15", scrW - 10, scrH - 60, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, 1 )
	
	local nextCanCapture = math.floor( ( self.nextCanCapture or 0 ) - CurTime( ) )
	
	if ( nextCanCapture > 0 ) then
		draw.SimpleText( "RECHARGING ... ( " .. ( nextCanCapture ) .. " sec )", "catherine_hl2rp_scanner20", scrW - 10, 120, Color( 255, 255, 0, 255 ), TEXT_ALIGN_RIGHT, 1 )
	else
		draw.SimpleText( "READY", "catherine_hl2rp_scanner25", scrW - 10, 120, Color( 0, 255, 0, 255 ), TEXT_ALIGN_RIGHT, 1 )
	end
	
	for k, v in pairs( Schema:GetCombines( ) ) do
		draw.SimpleText( v:Name( ) .. " ( HP " .. v:Health( ) .. "%, AREA : "  .. ( v:GetCurrentAreaName( ) or "NONE" ) .. " )", "catherine_hl2rp_scanner15", 10, 40 + ( k * 20 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, 1 )
	end
	
	local viewEnt = self.lastViewEnt
	
	if ( IsValid( viewEnt ) ) then
		local data = { }
		data.start = viewEnt:GetPos( )
		data.endpos = data.start + pl:GetAimVector( ) * 500
		data.filter = viewEnt
		local ent = util.TraceLine( data ).Entity
		
		ent = ( IsValid( ent ) and ent:IsPlayer( ) ) and ent:Name( ) or "NULL"
		
		draw.SimpleText( "TARGET ( " .. ent .. " )", "catherine_hl2rp_scanner20", scrW - 10, scrH - 120, Color( 0, 255, 255, 255 ), TEXT_ALIGN_RIGHT, 1 )
	end
end

function PLUGIN:ShouldDrawCombineOverlay( pl )
	if ( pl:GetNetVar( "isScanner" ) ) then
		return false
	end
end

catherine.font.Register( "catherine_hl2rp_scanner15", {
	font = "Consolas",
	size = 15,
	weight = 1000
} )

catherine.font.Register( "catherine_hl2rp_scanner20", {
	font = "Consolas",
	size = 20,
	weight = 1000
} )

catherine.font.Register( "catherine_hl2rp_scanner25", {
	font = "Consolas",
	size = 25,
	weight = 1000
} )

catherine.font.Register( "catherine_hl2rp_scanner30", {
	font = "Consolas",
	size = 30,
	weight = 1000
} )
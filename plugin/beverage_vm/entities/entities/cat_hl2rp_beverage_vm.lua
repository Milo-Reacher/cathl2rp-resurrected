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

AddCSLuaFile( )

ENT.Type = "anim"
ENT.PrintName = "Catherine HL2RP Beverage Vending Machine"
ENT.Author = "L7D"
ENT.Spawnable = false
ENT.AdminSpawnable = false

if ( SERVER ) then
	function ENT:Initialize( )
		self:SetModel( "models/props_interiors/vendingmachinesoda01a.mdl" )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:SetNetVar( "offline", false )
		self:SetNetVar( "sellingItems", PLUGIN.defaultSellingItems )
		self:SetNetVar( "mode", 0 )
		
		local physObject = self:GetPhysicsObject( )
		
		if ( IsValid( physObject ) ) then
			physObject:EnableMotion( false )
			physObject:Sleep( )
		end
	end
	
	function ENT:GetPositionButton( pl )
		local pos, ang = self:GetPos( ), self:GetAngles( )
		local forward, right, up = self:GetForward( ), self:GetRight( ), self:GetUp( )
		
		local menus = {
			{ pos + forward * 21 + up * 16 + right * 17, "breenwater" },
			{ pos + forward * 21 + up * 14 + right * 17, "red_breenwater" },
			{ pos + forward * 21 + up * 12 + right * 17, "gold_breenwater" }
		}
		local data = { }
		data.start = pl:GetShootPos( )
		data.endpos = data.start + pl:GetAimVector( ) * 96
		data.filter = pl
		local tr = util.TraceLine( data )
		
		if ( tr.Hit and tr.HitPos ) then
			for k, v in pairs( menus ) do
				if ( v[ 1 ]:Distance( tr.HitPos ) <= 5 ) then
					return v[ 2 ]
				end
			end
		end
	end
	
	function ENT:Use( pl )
		if ( ( self.nextCanUse or 0 ) <= CurTime( ) ) then
			self.nextCanUse = CurTime( ) + 1.5
		else
			return
		end
		
		local selectID = self:GetPositionButton( pl )
		
		if ( selectID ) then
			local stock = table.Copy( self:GetNetVar( "sellingItems", self.defaultSellingItems ) )
			
			for k, v in pairs( stock ) do
				if ( k == selectID and stock[ selectID ] <= 0 ) then
					if ( pl:PlayerIsCombine( ) ) then
						local itemTable = catherine.item.FindByID( selectID )
						
						if ( itemTable ) then
							local cost = ( itemTable.cost * PLUGIN.maxItemStockCount ) / PLUGIN.refillDiscont
							
							catherine.util.QueryReceiver( pl, "BVM_RefillQ", LANG( pl, "BVM_Notify_RefillQ", catherine.cash.GetCompleteName( cost ) ), function( _, status )
								if ( status ) then
									if ( !catherine.cash.Has( pl, cost ) ) then
										catherine.util.NotifyLang( pl, "Cash_Notify_HasNot", catherine.cash.GetOnlySingular( ) )
										return
									end
									
									for k1, v1 in pairs( stock ) do
										if ( k1 == k ) then
											stock[ k1 ] = PLUGIN.maxItemStockCount
										end
									end
									
									self:SetNetVar( "sellingItems", stock )
									catherine.cash.Take( pl, cost )
								end
							end )
						end
					end
					
					return
				end
			end
			
			local itemTable = catherine.item.FindByID( selectID )
			
			if ( itemTable ) then
				if ( !catherine.cash.Has( pl, itemTable.cost ) ) then
					catherine.util.NotifyLang( pl, "Cash_Notify_HasNot", catherine.cash.GetOnlySingular( ) )
					return
				end
				
				self:SpawnBeverage( pl, itemTable.uniqueID, itemTable.cost )
				catherine.cash.Take( pl, itemTable.cost )
				stock[ selectID ] = math.max( stock[ selectID ] - 1, 0 )
				self:SetNetVar( "sellingItems", stock )
				self:SetNetVar( "mode", 1 )
				
				timer.Simple( 1.5, function( )
					if ( IsValid( self ) ) then
						self:SetNetVar( "mode", 0 )
					end
				end )
			end
		else
			if ( pl:KeyDown( IN_SPEED ) and pl:PlayerIsCombine( ) ) then
				if ( self:GetNetVar( "offline" ) ) then
					self:SetNetVar( "offline", nil )
					self:DoOnline( )
				else
					self:SetNetVar( "offline", true )
					self:DoOffline( )
				end
			end
		end
	end
	
	function ENT:SpawnBeverage( pl, uniqueID )
		local itemPos = self:GetPos( ) + self:GetForward( ) * 19 + self:GetRight( ) * 4 + self:GetUp( ) * -35
		local ent = catherine.item.Spawn( uniqueID, itemPos )
		
		self:EmitSound( "buttons/button4.wav", 100 )
		self:EmitSound( "buttons/lightswitch2.wav", 100 )
	end
	
	function ENT:DoOnline( )
		self:EmitSound( "ambient/machines/thumper_startup1.wav", 60 )
	end
	
	function ENT:DoOffline( )
		self:EmitSound( "ambient/machines/thumper_shutdown1.wav", 60 )
	end
else
	local glowMat = Material( "sprites/glow04_noz" )
	
	function ENT:GetPositionButton( )
		local pos, ang = self:GetPos( ), self:GetAngles( )
		local forward, right, up = self:GetForward( ), self:GetRight( ), self:GetUp( )
		local menus = {
			{ pos + forward * 21 + up * 16 + right * 17, "breenwater" },
			{ pos + forward * 21 + up * 14 + right * 17, "red_breenwater" },
			{ pos + forward * 21 + up * 12 + right * 17, "gold_breenwater" }
		}
		local data = { }
		data.start = catherine.pl:GetShootPos( )
		data.endpos = data.start + catherine.pl:GetAimVector( ) * 96
		data.filter = catherine.pl
		local tr = util.TraceLine( data )
		
		if ( tr.Hit and tr.HitPos ) then
			for k, v in pairs( menus ) do
				if ( v[ 1 ]:Distance( tr.HitPos ) <= 5 ) then
					return v[ 2 ]
				end
			end
		end
	end
	
	function ENT:Draw( )
		self:DrawModel( )
		
		if ( catherine.util.CalcDistanceByPos( catherine.pl, self ) >= 600 ) then return end
		
		local pos, ang = self:GetPos( ), self:GetAngles( )
		local forward, right, up = self:GetForward( ), self:GetRight( ), self:GetUp( )
		
		ang:RotateAroundAxis( ang:Up( ), 90 )
		ang:RotateAroundAxis( ang:Forward( ), 90 )
		
		local selectID = self:GetPositionButton( )
		local menus = {
			{ pos + forward * 21 + up * 16 + right * 17, "breenwater" },
			{ pos + forward * 21 + up * 14 + right * 17, "red_breenwater" },
			{ pos + forward * 21 + up * 12 + right * 17, "gold_breenwater" }
		}
		local mode = self:GetNetVar( "mode", 0 )
		local isOffline = self:GetNetVar( "offline" )
		
		cam.Start3D2D( pos + forward * 21 + up * 16 + right * 20, ang, 0.1 )
			if ( isOffline ) then
				draw.SimpleText( LANG( "BVM_UI_OfflineNotifyStr" ), "catherine_normal20", 150, 10, Color( 255, 255, 255, 255 ), 1, 0 )
			else
				if ( mode == 0 ) then
					local i = 0
					local data = self:GetNetVar( "sellingItems", PLUGIN.defaultSellingItems )
					
					for k, v in pairs( menus ) do
						local itemTable = catherine.item.FindByID( v[ 2 ] )
						if ( !itemTable ) then continue end
						local itemName = catherine.util.StuffLanguage( itemTable.name )
						local itemCost = itemTable.cost
						local stock = data[ v[ 2 ] ]
						
						if ( selectID == v[ 2 ] ) then
							draw.RoundedBox( 0, 5, 28 + ( 35 * i ), 310, 1, Color( 255, 255, 255, 255 ) )
						else
							draw.RoundedBox( 0, 5, 28 + ( 35 * i ), 310, 1, Color( 0, 0, 0, 255 ) )
						end
						
						if ( stock == 0 ) then
							draw.NoTexture( )
							surface.SetDrawColor( 255, 20, 20, 255 )
							catherine.geometry.DrawCircle( 300, 17 + ( 35 * i ), 3, 5, 90, 360, 100 )
						else
							draw.NoTexture( )
							surface.SetDrawColor( 20, 20, 20, 255 )
							catherine.geometry.DrawCircle( 300, 17 + ( 35 * i ), 3, 5, 90, 360, 100 )
							
							draw.NoTexture( )
							surface.SetDrawColor( 255, 255, 255, 255 )
							catherine.geometry.DrawCircle( 300, 17 + ( 35 * i ), 3, 5, 90, stock / PLUGIN.maxItemStockCount * 360, 100 )
						end
						
						draw.SimpleText( itemName, "catherine_normal15", 10, 10 + ( 35 * i ), Color( 255, 255, 255, 255 ), 0, 0 )
						draw.SimpleText( catherine.cash.GetCompleteName( itemCost ), "catherine_normal15", 280, 10 + ( 35 * i ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, 0 )
						i = i + 1
					end
				elseif ( mode == 1 ) then
					draw.SimpleText( LANG( "BVM_UI_Thx" ), "catherine_normal35", 150, 10, Color( 255, 255, 255, 255 ), 1, 0 )
				end
			end
		cam.End3D2D( )
		
		render.SetMaterial( glowMat )
		render.DrawSprite( self:GetPos( ) + self:GetForward( ) * 18 + self:GetRight( ) * -22.4 + self:GetUp( ) * 9.3, 10, 10, PLUGIN:IsActive( self ) and Color( 150, 255, 150 ) or Color( 255, 0, 0 ) )
	end
end
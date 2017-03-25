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

function PLUGIN:SaveBVMs( )
	local data = { }
	
	for k, v in pairs( ents.FindByClass( "cat_hl2rp_beverage_vm" ) ) do
		data[ #data + 1 ] = {
			pos = v:GetPos( ),
			ang = v:GetAngles( ),
			mat = v:GetMaterial( ),
			col = v:GetColor( ),
			items = table.Copy( v:GetNetVar( "sellingItems", self.defaultSellingItems ) ),
			isOffline = v:GetNetVar( "offline", false )
		}
	end
	
	catherine.data.Set( "bvms", data )
end

function PLUGIN:LoadBVMs( )
	for k, v in pairs( catherine.data.Get( "bvms", { } ) ) do
		local ent = ents.Create( "cat_hl2rp_beverage_vm" )
		ent:SetPos( v.pos )
		ent:SetAngles( v.ang )
		ent:Spawn( )
		ent:Activate( )
		ent:SetColor( v.col or Color( 255, 255, 255, 255 ) )
		ent:SetMaterial( v.mat or "" )
		
		if ( v.isOffline ) then
			ent:SetNetVar( "offline", true )
		end
		
		if ( v.items ) then
			ent:SetNetVar( "sellingItems", v.items )
		else
			ent:SetNetVar( "sellingItems", self.defaultSellingItems )
		end
	end
end

function PLUGIN:DataSave( )
	self:SaveBVMs( )
end

function PLUGIN:DataLoad( )
	self:LoadBVMs( )
end

function PLUGIN:InitPostEntity( )
	for k, v in pairs( ents.FindByClass( "prop_*" ) ) do
		if ( IsValid( v ) and v:GetModel( ):lower( ) == "models/props_interiors/vendingmachinesoda01a.mdl" ) then
			SafeRemoveEntity( v )
		end
	end
end
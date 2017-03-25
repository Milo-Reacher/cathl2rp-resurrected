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

local ITEM = catherine.item.New( "zip_tie" )
ITEM.name = "^Item_Name_ZT"
ITEM.desc = "^Item_Desc_ZT"
ITEM.cost = 10
ITEM.model = "models/gibs/metal_gib4.mdl"
ITEM.weight = 0.3
ITEM.category = "^Item_Category_Other"
ITEM.func = { }
ITEM.func.tie = {
	text = "^Item_FuncStr01_ZT",
	icon = "icon16/key.png",
	canShowIsMenu = true,
	func = function( pl, itemTable )
		local data = { }
		data.start = pl:GetShootPos( )
		data.endpos = data.start + pl:GetAimVector( ) * 160
		data.filter = pl
		local ent = util.TraceLine( data ).Entity
		
		if ( !IsValid( ent ) ) then
			catherine.util.NotifyLang( pl, "Entity_Notify_NotPlayer" )
			return
		end
		
		if ( ent:GetClass( ) == "prop_ragdoll" ) then
			ent = catherine.entity.GetPlayer( ent )
		end
		
		if ( IsValid( ent ) and ent:IsPlayer( ) ) then
			catherine.player.SetTie( pl, ent, true, nil, true )
		else
			catherine.util.NotifyLang( pl, "Entity_Notify_NotPlayer" )
		end
	end
}

catherine.item.Register( ITEM )
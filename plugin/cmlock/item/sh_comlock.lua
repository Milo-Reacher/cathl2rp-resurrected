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

local ITEM = catherine.item.New( "comlock" )
ITEM.name = "^Item_Name_ComLock"
ITEM.desc = "^Item_Desc_ComLock"
ITEM.category = "^Item_Category_Other"
ITEM.model = "models/props_combine/combine_lock01.mdl"
ITEM.cost = 150
ITEM.weight = 0.3
ITEM.func = { }
ITEM.func.place = {
	text = "^Item_FuncStr01_ComLock",
	icon = "icon16/money_add.png",
	canShowIsMenu = true,
	func = function( pl, itemTable )
		local data = { }
		data.start = pl:GetShootPos( )
		data.endpos = data.start + pl:GetAimVector( ) * 128
		data.filter = pl
		
		local tr = util.TraceLine( data )
		
		local ent = tr.Entity
		
		if ( !IsValid( ent ) or !ent:IsDoor( ) or IsValid( ent.lock ) ) then
			catherine.util.NotifyLang( pl, "Entity_Notify_NotDoor" )
			return
		end
		
		local comLockEnt = ents.Create( "cat_hl2rp_comlock" )
		comLockEnt:SetPos( tr.HitPos )
		comLockEnt:Spawn( )
		comLockEnt:Activate( )
		
		local pos, ang = comLockEnt:GetPlacePosition( pl, ent )
		comLockEnt:SetDoor( ent, pos, ang )
		
		catherine.inventory.Work( pl, CAT_INV_ACTION_REMOVE, { uniqueID = itemTable.uniqueID } )
		
		PLUGIN:DataSave( )
	end
}

catherine.item.Register( ITEM )
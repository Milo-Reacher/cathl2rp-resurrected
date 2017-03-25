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

local ITEM = catherine.item.New( "breach" )
ITEM.name = "^Item_Name_Breach"
ITEM.desc = "^Item_Desc_Breach"
ITEM.cost = 150
ITEM.model = "models/props_wasteland/prison_padlock001a.mdl"
ITEM.weight = 0.3
ITEM.func = { }
ITEM.func.place = {
	text = "^Item_FuncStr01_Breach",
	icon = "icon16/link.png",
	canShowIsMenu = true,
	func = function( pl, itemTable )
		local hit = pl:GetEyeTraceNoCursor( )
		local ent = hit.Entity
		
		if ( IsValid( ent ) and ent:GetClass( ) == "prop_door_rotating" ) then
			if ( catherine.util.CalcDistanceByPos( ent, pl ) <= 128 ) then
				local partner = catherine.util.GetDoorPartner( ent )

				if ( !IsValid( ent.lock ) or ( IsValid( partner ) and !IsValid( partner.lock ) ) ) then
					local pos = hit.HitPos + ( hit.HitNormal * 1 ) + Vector( 0, 0, 0 )
					local ang = hit.HitNormal:Angle( ) + Angle( 0, 0, 0 )
					
					local breach = ents.Create( "cat_hl2rp_breach" )
					breach:SetPos( pos )
					breach:SetAngles( ang )
					breach:SetParent( ent )
					breach:Spawn( )
					
					catherine.inventory.Work( pl, CAT_INV_ACTION_REMOVE, {
						uniqueID = itemTable.uniqueID
					} )
				else
					catherine.util.NotifyLang( pl, "Item_Notify_ComLock_Breach" )
				end
			else
				catherine.util.NotifyLang( pl, "Entity_Notify_TooFar" )
			end
		else
			catherine.util.NotifyLang( pl, "Entity_Notify_NotDoor" )
		end
	end
}

if ( CLIENT ) then
	function ITEM:DoRightClick( pl, itemData )
		catherine.item.Work( self.uniqueID, "place", true )
	end
end

catherine.item.Register( ITEM )
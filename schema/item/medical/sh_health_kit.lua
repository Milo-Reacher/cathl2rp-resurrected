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

local ITEM = catherine.item.New( "health_kit" )
ITEM.name = "^Item_Name_HealthK"
ITEM.desc = "^Item_Desc_HealthK"
ITEM.cost = 150
ITEM.model = "models/items/healthkit.mdl"
ITEM.weight = 1
ITEM.category = "^Item_Category_Medical"
ITEM.func = { }
ITEM.func.use = {
	text = "^Item_FuncStr01_Medical",
	icon = "icon16/heart.png",
	canShowIsMenu = true,
	canShowIsWorld = true,
	func = function( pl, itemTable, ent )
		if ( pl:Alive( ) ) then
			local healAmount = hook.Run( "GetHealAmount", pl, itemTable ) or 35

			pl:SetHealth( math.Clamp( pl:Health( ) + healAmount, 0, pl:GetMaxHealth( ) ) )
			pl:EmitSound( "items/medshot4.wav", 80 )
			
			hook.Run( "PlayerHealed", pl )
			
			if ( type( ent ) == "Entity" ) then
				ent:Remove( )
			else
				catherine.inventory.Work( pl, CAT_INV_ACTION_REMOVE, {
					uniqueID = itemTable.uniqueID
				} )
			end
		else
			catherine.util.NotifyLang( pl, "Item_Notify_Error04_Medical" )
		end
	end
}
ITEM.func.heal = {
	text = "^Item_FuncStr02_Medical",
	icon = "icon16/heart.png",
	canShowIsMenu = true,
	func = function( pl, itemTable )
		local tr = { }
		tr.start = pl:GetShootPos( )
		tr.endpos = tr.start + pl:GetAimVector( ) * 160
		tr.filter = pl
		local ent = util.TraceLine( tr ).Entity
	
		if ( IsValid( ent ) and ent:IsPlayer( ) ) then
			if ( ent:Alive( ) ) then
				local healAmount = hook.Run( "GetHealAmount", ent, itemTable ) or 35
			
				ent:SetHealth( math.Clamp( ent:Health( ) + healAmount, 0, ent:GetMaxHealth( ) ) )
				ent:EmitSound( "items/medshot4.wav", 80 )
				
				hook.Run( "PlayerHealed", ent )
				
				catherine.inventory.Work( pl, CAT_INV_ACTION_REMOVE, {
					uniqueID = itemTable.uniqueID
				} )
			else
				catherine.util.NotifyLang( pl, "Item_Notify_Error03_Medical" )
			end
		else
			catherine.util.NotifyLang( pl, "Entity_Notify_NotPlayer" )
		end
	end
}

if ( CLIENT ) then
	function ITEM:DoRightClick( pl, itemData )
		catherine.item.Work( self.uniqueID, "use", true )
	end
end

catherine.item.Register( ITEM )
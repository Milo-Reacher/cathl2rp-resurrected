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

local ITEM = catherine.item.New( "antidepressants" )
ITEM.name = "^Item_Name_AntideP"
ITEM.desc = "^Item_Desc_AntideP"
ITEM.cost = 500
ITEM.model = "models/props_junk/garbage_metalcan002a.mdl"
ITEM.weight = 0.4
ITEM.category = "^Item_Category_Medical"
ITEM.func = { }
ITEM.func.use = {
	text = "^Item_FuncStr01_AntideP",
	icon = "icon16/heart.png",
	canShowIsMenu = true,
	canShowIsWorld = true,
	func = function( pl, itemTable, ent )
		if ( pl:Alive( ) ) then
			local charID = pl:GetCharacterID( )
			local timerID = "Catherine.HL2RP.timer.antidepressants.Work." .. charID
			
			catherine.character.SetCharVar( pl, "antidepressants_status", true )
			catherine.character.SetCharVar( pl, "antidepressants_timeOut", 300 )
			
			local antidepressantsTimeOut = catherine.character.GetCharVar( pl, "antidepressants_timeOut" )
		
			timer.Remove( timerID )
			timer.Create( timerID, 10, 0, function( )
				if ( !IsValid( pl ) or !pl:Alive( ) or charID != pl:GetCharacterID( ) ) then
					timer.Remove( timerID )
					return
				end
				
				if ( antidepressantsTimeOut - 10 > 0 ) then
					antidepressantsTimeOut = antidepressantsTimeOut - 10
					catherine.character.SetCharVar( pl, "antidepressants_timeOut", antidepressantsTimeOut )
				else
					timer.Remove( timerID )
					catherine.character.SetCharVar( pl, "antidepressants_status", nil )
					catherine.character.SetCharVar( pl, "antidepressants_timeOut", nil )
				end
			end )
			
			pl:EmitSound( "items/medshot4.wav", 80 )
			
			if ( type( ent ) == "Entity" ) then
				ent:Remove( )
			else
				catherine.inventory.Work( pl, CAT_INV_ACTION_REMOVE, {
					uniqueID = itemTable.uniqueID
				} )
			end
		else
			catherine.util.NotifyLang( pl, "Item_Notify_Error01_AntideP" )
		end
	end
}

if ( SERVER ) then
	catherine.item.RegisterHook( "PlayerSpawnedInCharacter", ITEM, function( pl )
		local antidepressants = catherine.character.GetCharVar( pl, "antidepressants_status" )
		
		if ( antidepressants == true ) then
			local antidepressantsTimeOut = catherine.character.GetCharVar( pl, "antidepressants_timeOut" )
			local charID = pl:GetCharacterID( )
			local timerID = "Catherine.HL2RP.timer.antidepressants.Work." .. charID
			
			timer.Remove( timerID )
			timer.Create( timerID, 10, 0, function( )
				if ( !IsValid( pl ) or !pl:Alive( ) or charID != pl:GetCharacterID( ) ) then
					timer.Remove( timerID )
					return
				end
				
				if ( antidepressantsTimeOut - 10 > 0 ) then
					antidepressantsTimeOut = antidepressantsTimeOut - 10
					catherine.character.SetCharVar( pl, "antidepressants_timeOut", antidepressantsTimeOut )
				else
					timer.Remove( timerID )
					catherine.character.SetCharVar( pl, "antidepressants_status", nil )
					catherine.character.SetCharVar( pl, "antidepressants_timeOut", nil )
				end
			end )
		end
	end )
	
	catherine.item.RegisterHook( "CharacterLoadingStart", ITEM, function( pl )
		if ( !pl:IsCharacterLoaded( ) ) then return end
		
		if ( catherine.character.GetCharVar( pl, "antidepressants_status" ) == true ) then
			timer.Remove( "Catherine.HL2RP.timer.antidepressants.Work." .. pl:GetCharacterID( ) )
		end
	end )
	
	catherine.item.RegisterHook( "PlayerDeath", ITEM, function( pl )
		if ( !pl:IsCharacterLoaded( ) ) then return end
		
		if ( catherine.character.GetCharVar( pl, "antidepressants_status" ) == true ) then
			catherine.character.SetCharVar( pl, "antidepressants_status", nil )
			catherine.character.SetCharVar( pl, "antidepressants_timeOut", nil )
			timer.Remove( "Catherine.HL2RP.timer.antidepressants.Work." .. pl:GetCharacterID( ) )
		end
	end )
else
	function ITEM:DoRightClick( pl, itemData )
		catherine.item.Work( self.uniqueID, "use", true )
	end
end

catherine.item.Register( ITEM )
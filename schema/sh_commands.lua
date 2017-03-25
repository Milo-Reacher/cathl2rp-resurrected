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

local function checkStaticRadio( pl, text )
	for k, v in pairs( ents.FindInSphere( pl:GetPos( ), 100 ) ) do
		if ( v:GetClass( ) == "cat_hl2rp_static_radio" and v:GetNetVar( "active" ) and v:GetNetVar( "freq" ) != "XXX.X" and v:GetNetVar( "freq" ) != "" ) then
			Schema:SayRadio( pl, text )
			return true
		end
	end
	
	return false
end

catherine.command.Register( {
	uniqueID = "&uniqueID_radio",
	command = "radio",
	syntax = "[Text]",
	desc = "Run a Radio chat.",
	runFunc = function( pl, args )
		local text = table.concat( args, " " )
		
		if ( text == "" ) then
			catherine.util.NotifyLang( pl, "Basic_Notify_InputText" )
			return
		end
		
		if ( pl:HasItem( "portable_radio" ) ) then
			local itemData = pl:GetInvItemDatas( "portable_radio" )
			
			if ( itemData.toggle ) then
				if ( itemData.freq != "xxx.x" and itemData.freq != "" ) then
					Schema:SayRadio( pl, text )
				else
					local success = checkStaticRadio( pl, text )
					
					if ( !success ) then
						catherine.util.NotifyLang( pl, "Item_Notify_Error05_PR" )
					end
				end
			else
				local success = checkStaticRadio( pl, text )
				
				if ( !success ) then
					catherine.util.NotifyLang( pl, "Item_Notify_Error04_PR" )
				end
			end
		else
			local success = checkStaticRadio( pl, text )
			
			if ( !success ) then
				catherine.util.NotifyLang( pl, "Item_Notify_Error03_PR" )
			end
		end
	end
} )

catherine.command.Register( {
	uniqueID = "&uniqueID_request",
	command = "request",
	syntax = "[Text]",
	desc = "Run a Request chat.",
	runFunc = function( pl, args )
		if ( pl:HasItem( "request_device" ) ) then
			local text = table.concat( args, " " )
			
			if ( text != "" ) then
				Schema:SayRequest( pl, text )
			else
				catherine.util.NotifyLang( pl, "Basic_Notify_InputText" )
			end
		else
			catherine.util.NotifyLang( pl, "Item_Notify_Error01_RD" )
		end
	end
} )

catherine.command.Register( {
	uniqueID = "&uniqueID_dispatch",
	command = "dispatch",
	syntax = "[Text]",
	desc = "Run a Dispatch chat.",
	runFunc = function( pl, args )
		local team = pl:Team( )
		
		if (
			pl:Class( ) == CLASS_CP_SCN or
			team == FACTION_ADMIN or
			team == FACTION_OW or
			( team == FACTION_CP and table.HasValue( { "EpU", "SeC", "DvL" }, Schema:GetRankByName( pl:Name( ) ) or "ERROR" ) )
		) then
			local text = table.concat( args, " " )
			
			if ( text != "" ) then
				Schema:SayDispatch( pl, text )
			else
				catherine.util.NotifyLang( pl, "Basic_Notify_InputText" )
			end
		else
			catherine.util.NotifyLang( pl, "Player_Message_HasNotPermission" )
		end
	end
} )

catherine.command.Register( {
	uniqueID = "&uniqueID_breenCast",
	command = "breencast",
	syntax = "[Text]",
	desc = "Run a Breencast chat.",
	runFunc = function( pl, args )
		if ( pl:Team( ) == FACTION_ADMIN ) then
			local text = table.concat( args, " " )
			
			if ( text != "" ) then
				Schema:SayBreenCast( pl, text )
			else
				catherine.util.NotifyLang( pl, "Basic_Notify_InputText" )
			end
		else
			catherine.util.NotifyLang( pl, "Player_Message_HasNotPermission" )
		end
	end
} )

catherine.command.Register( {
	uniqueID = "&uniqueID_dispenserAdd",
	command = "dispenseradd",
	desc = "Add the Dispenser of this position.",
	canRun = function( pl ) return pl:IsAdmin( ) end,
	runFunc = function( pl, args )
		local pos = pl:GetEyeTraceNoCursor( ).HitPos
		local ang = pl:EyeAngles( )
		
		ang.p = 0
		ang.y = ang.y - 180
		
		local ent = ents.Create( "cat_hl2rp_ration_dispenser" )
		ent:SetPos( pos )
		ent:SetAngles( ang )
		ent:Spawn( )
		ent:Activate( )
		
		catherine.util.NotifyLang( pl, "Command_SpawnDispenser_Fin" )
	end
} )
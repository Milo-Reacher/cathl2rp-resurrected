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
PLUGIN.name = "^BVM_Plugin_Name"
PLUGIN.author = "L7D"
PLUGIN.desc = "^BVM_Plugin_Desc"
PLUGIN.defaultSellingItems = {
	[ "breenwater" ] = 50,
	[ "red_breenwater" ] = 30,
	[ "gold_breenwater" ] = 10
}
PLUGIN.maxItemStockCount = 50
PLUGIN.refillDiscont = 2
CAT_HL2RP_BEVERAGE_VM_ACTION_MAIN = 1
CAT_HL2RP_BEVERAGE_VM_ACTION_CHANGE_STATUS = 2
CAT_HL2RP_BEVERAGE_VM_ACTION_REFILL = 3

catherine.util.Include( "sv_plugin.lua" )

catherine.language.Merge( "english", {
	[ "BVM_Notify_RefillQ" ] = "Are you sure refill this beverage?, this work is spend %s.",
	[ "BVM_UI_OfflineNotifyStr" ] = "This vending machine is offline.",
	[ "BVM_UI_Thx" ] = "Thank you!",
	[ "BVM_Notify_Add" ] = "You are added beverage vending machine.",
	[ "BVM_Notify_Remove" ] = "You are removed this beverage vending machine.",
	[ "BVM_Notify_NotValid" ] = "This is not vendor!",
	[ "BVM_Plugin_Name" ] = "Beverage Vending Machine",
	[ "BVM_Plugin_Desc" ] = "Good stuff."
} )

catherine.language.Merge( "korean", {
	[ "BVM_Notify_RefillQ" ] = "당신은 정말로 이 음료를 리필하시겠습니까?, %s 가 소모됩니다.",
	[ "BVM_UI_OfflineNotifyStr" ] = "이 판매기는 판매 중지 되었습니다.",
	[ "BVM_UI_Thx" ] = "고맙습니다!",
	[ "BVM_Notify_Add" ] = "당신은 음료 자동 판매기를 추가했습니다.",
	[ "BVM_Notify_Remove" ] = "당신은 이 음료 자동 판매기를 지우셨습니다.",
	[ "BVM_Notify_NotValid" ] = "이 물체는 음료 자동 판매기가 아닙니다!",
	[ "BVM_Plugin_Name" ] = "음료 자동 판매기",
	[ "BVM_Plugin_Desc" ] = "음료를 판매합니다."
} )

catherine.command.Register( {
	uniqueID = "&uniqueID_beverageVmAdd",
	command = "beveragevmadd",
	desc = "Add the Beverage Vending Machine NPC of this position.",
	canRun = function( pl ) return pl:IsAdmin( ) end,
	runFunc = function( pl, args )
		local pos, ang = pl:GetEyeTraceNoCursor( ).HitPos + Vector( 0, 0, 48 ), pl:EyeAngles( )
		ang.p = 0
		ang.y = ang.y - 180
		
		local ent = ents.Create( "cat_hl2rp_beverage_vm" )
		ent:SetPos( pos )
		ent:SetAngles( ang )
		ent:Spawn( )
		ent:Activate( )
		ent:SetNetVar( "offline", false )
		ent:SetNetVar( "sellingItems", PLUGIN.defaultSellingItems )
		
		PLUGIN:SaveBVMs( )
		
		catherine.util.NotifyLang( pl, "BVM_Notify_Add" )
	end
} )

catherine.command.Register( {
	uniqueID = "&uniqueID_beverageVmRemove",
	command = "beveragevmremove",
	desc = "Remove the looking Beverage Vending Machine NPC.",
	canRun = function( pl ) return pl:IsAdmin( ) end,
	runFunc = function( pl, args )
		local ent = pl:GetEyeTraceNoCursor( ).Entity
		
		if ( IsValid( ent ) and ent:GetClass( ) == "cat_hl2rp_beverage_vm" ) then
			ent:Remove( )
			catherine.util.NotifyLang( pl, "BVM_Notify_Remove" )
			
			PLUGIN:SaveBVMs( )
		else
			catherine.util.NotifyLang( pl, "BVM_Notify_NotValid" )
		end
	end
} )

function PLUGIN:IsActive( ent )
	return !ent:GetNetVar( "offline" )
end
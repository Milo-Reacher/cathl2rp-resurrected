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
PLUGIN.name = "^FlashL_Plugin_Name"
PLUGIN.author = "L7D"
PLUGIN.desc = "^FlashL_Plugin_Desc"

catherine.language.Merge( "english", {
	[ "FlashL_Plugin_Name" ] = "Flashlight",
	[ "FlashL_Plugin_Desc" ] = "Good stuff.",
	[ "Item_Name_Flashlight" ] = "Flashlight",
	[ "Item_Desc_Flashlight" ] = "A regular flashlight with batteries included."
} )

catherine.language.Merge( "korean", {
	[ "FlashL_Plugin_Name" ] = "손전등",
	[ "FlashL_Plugin_Desc" ] = "손전등을 추가합니다.",
	[ "Item_Name_Flashlight" ] = "손전등",
	[ "Item_Desc_Flashlight" ] = "어두운 곳을 환하게 비춰줍니다."
} )

if ( CLIENT ) then return end

function PLUGIN:PlayerSwitchFlashlight( pl )
	if ( pl:PlayerIsCombine( ) or pl:FlashlightIsOn( ) and !pl:HasItem( "flashlight" ) ) then
		return true
	end
	
	if ( pl:HasItem( "flashlight" ) ) then
		return true
	end

	return false
end
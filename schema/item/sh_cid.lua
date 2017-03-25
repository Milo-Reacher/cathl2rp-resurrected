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

local ITEM = catherine.item.New( "cid" )
ITEM.name = "^Item_Name_CID"
ITEM.desc = "^Item_Desc_CID"
ITEM.cost = 0
ITEM.model = "models/gibs/metal_gib4.mdl"
ITEM.weight = 0.1
ITEM.category = "^Item_Category_Wallet"
ITEM.useDynamicItemData = true
ITEM.itemData = {
	cid = "",
	name = ""
}

if ( CLIENT ) then
	function ITEM:GetDesc( pl, itemData, isInv )
		return "#" .. ( itemData.cid or "00000" ) .. ", " .. ( itemData.name or "Citizen" )
	end
end

catherine.item.Register( ITEM )
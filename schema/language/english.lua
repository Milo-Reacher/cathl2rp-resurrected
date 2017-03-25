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

catherine.language.Merge( "english", {
	// Basic
	[ "Basic_Schema_Title" ] = "HALF-LIFE 2",
	[ "Basic_Schema_Desc" ] = "It's safer here.",
	[ "Basic_Schema_IntroTitle" ] = "City 17, 2017",
	[ "Basic_Schema_IntroDesc" ] = "It's safer here.",
	[ "Basic_Schema_Author" ] = "Half-Life 2 schema development and design by '%s'",
	
	// Faction Name
	[ "Faction_Name_Citizen" ] = "Citizen",
	[ "Faction_Name_CWU" ] = "Civil Workers Union",
	[ "Faction_Name_Administrator" ] = "Administrator",
	[ "Faction_Name_OW" ] = "Overwatch Transhuman Arm",
	[ "Faction_Name_CP" ] = "Civil Protection",
	
	// Faction Description
	[ "Faction_Desc_Citizen" ] = "Typical Citizen of the City.",
	[ "Faction_Desc_CWU" ] = "Worker of the Civil Workers Union.",
	[ "Faction_Desc_Administrator" ] = "The City Administrator.",
	[ "Faction_Desc_OW" ] = "Mechanised Infantry units utilized to combat the ongoing insurgency, these units are the Elite of Combine Forces.",
	[ "Faction_Desc_CP" ] = "The Civil Protection are the policing force of the combine, they patrol the cities looking for anyone who's acting uncivil.",

	// Item
	[ "Item_Name_LargeBag" ] = "Large bag",
	[ "Item_Desc_LargeBag" ] = "It seems to make your inventory's space larger.",
	
	[ "Item_Name_SmallBag" ] = "Small bag",
	[ "Item_Desc_SmallBag" ] = "It seems to make your inventory's space just a bit larger.",
	
	[ "Item_Name_CID" ] = "Citizen ID Card",
	[ "Item_Desc_CID" ] = "A Citizen ID Card.",
	
	[ "Item_Name_PR" ] = "Portable Radio",
	[ "Item_Desc_PR" ] = "Communication to other humans.",
	[ "Item_FuncStr01_PR" ] = "Set Frequency",
	[ "Item_FuncStr02_PR" ] = "Toggle",
	[ "Item_DataStr01_PR" ] = "Frequency",
	[ "Item_DataStr02_PR" ] = "Power",
	[ "Item_DataStr02_On_PR" ] = "On",
	[ "Item_DataStr02_Off_PR" ] = "Off",
	
	[ "Item_RadioFreqQ_PR" ] = "Would you like to set the frequency for radio?",
	[ "Item_Notify_FreqSet_PR" ] = "You have set the portable radio frequency to %s.",
	[ "Item_Notify_Error01_PR" ] = "Radio frequency must be 101.1 ~ 199.9!",
	[ "Item_Notify_Error02_PR" ] = "Radio frequency must be XXX.X!",
	[ "Item_Notify_Error03_PR" ] = "You don't have a Portable Radio!",
	[ "Item_Notify_Error04_PR" ] = "Please turn on a Portable Radio!",
	[ "Item_Notify_Error05_PR" ] = "Please set the frequency!",
	
	[ "Item_Name_RD" ] = "Request Device",
	[ "Item_Desc_RD" ] = "A Request Device, to request the CCA.",
	[ "Item_Notify_Error01_RD" ] = "You don't have a Request Device!",

	[ "Item_Name_SC" ] = "Spray Can",
	[ "Item_Desc_SC" ] = "If you have this, you can paint on a wall. This is uncivil, though.",
	
	[ "Item_Name_BW" ] = "Breen Water",
	[ "Item_Desc_BW" ] = "Slushy drink. Tastes bad.",
	
	[ "Item_Name_RBW" ] = "Red Breen Water",
	[ "Item_Desc_RBW" ] = "Slushy drink. Tastes normal.",
	
	[ "Item_Name_GBW" ] = "Golden Breen Water",
	[ "Item_Desc_GBW" ] = "Slushy drink. Tastes sorta good...",
	
	[ "Item_Name_ChineseT" ] = "Chinese Takeout",
	[ "Item_Desc_ChineseT" ] = "It's filled with cold noodles.",
	
	[ "Item_Name_LargeS" ] = "Large Soda",
	[ "Item_Desc_LargeS" ] = "It's fairly big and filled with liquid.",
	
	[ "Item_Name_Melon" ] = "Melon",
	[ "Item_Desc_Melon" ] = "A big and green fruit.",
	
	[ "Item_Name_MilkC" ] = "Milk Carton",
	[ "Item_Desc_MilkC" ] = "A carton filled with milk.",
	
	[ "Item_Name_MilkJ" ] = "Milk Jugs",
	[ "Item_Desc_MilkJ" ] = "A jug filled with milk.",
	
	[ "Item_Name_VegetableO" ] = "Vegetable Oil",
	[ "Item_Desc_VegetableO" ] = "It isn't very tasty.",
	
	[ "Item_Name_9MM" ] = ".9mm Pistol",
	[ "Item_Desc_9MM" ] = "A standard .9mm USP Match. MPF Units have this.",
	
	[ "Item_Name_AR2" ] = "AR2",
	[ "Item_Desc_AR2" ] = "A Combine gun. It has a small charger filled with electricity, which an arm rapidly triggers when pressing the trigger, firing plasma bullets.",
	
	[ "Item_Name_SMG" ] = "SMG",
	[ "Item_Desc_SMG" ] = "The simple sub machine gun.",
	
	[ "Item_Name_357" ] = ".357 Magnum",
	[ "Item_Desc_357" ] = "A shiny .357 with a strong kickback.",
	
	[ "Item_Name_CB" ] = "Crossbow",
	[ "Item_Desc_CB" ] = "A massive crossbow that seems to have the ability to shoot metal bolts at incredible speeds.",
	
	[ "Item_Name_Buckshot" ] = "Shotgun",
	[ "Item_Desc_Buckshot" ] = "A SPAS-12 shotgun. Seems pretty strong.",
	
	[ "Item_Name_RPG" ] = "RPG",
	[ "Item_Desc_RPG" ] = "A big RPG with remotely controlled rockets.",
	
	[ "Item_Name_CrowB" ] = "Crowbar",
	[ "Item_Desc_CrowB" ] = "A rusted tool that looks like it has seen better days.",
	
	[ "Item_Name_SS" ] = "Stunstick",
	[ "Item_Desc_SS" ] = "An electrified baton powered by a combine battery.",
	
	[ "Item_Name_Ration" ] = "Ration",
	[ "Item_Desc_Ration" ] = "A package containing food and water.",
	[ "Item_FuncStr01_Ration" ] = "Open",
	
	[ "Item_Name_CitizenS" ] = "Citizen Supplements",
	[ "Item_Desc_CitizenS" ] = "Raw nutrients with slight flavoring provided by the Combine.",
	
	[ "Item_Name_Bleach" ] = "Bleach",
	[ "Item_Desc_Bleach" ] = "A bottle of bleach, often used for cleaning. I wouldn't really recommend drinking this..",
	
	[ "Item_Name_ZT" ] = "Zip Tie",
	[ "Item_Desc_ZT" ] = "Tie to player.",
	[ "Item_FuncStr01_ZT" ] = "Tie",

	[ "Item_Category_Communication" ] = "Communication",
	[ "Item_Category_Food" ] = "Food",
	[ "Item_FuncStr01_Food" ] = "Eat",
	[ "Item_FuncStr02_Food" ] = "Drink",
	
	[ "Item_Name_PistolAmmo" ] = ".9mm Pistol Rounds",
	[ "Item_Desc_PistolAmmo" ] = "A greenish catridge with the 9mm bullet label on the side.",
	
	[ "Item_Name_AR2Ammo" ] = "Pulse Energy Cartridge",
	[ "Item_Desc_AR2Ammo" ] = "A curved piece of metal with glowing blue small chargers.",
	
	[ "Item_Name_SMGAmmo" ] = "SMG Round",
	[ "Item_Desc_SMGAmmo" ] = "A light teal box with some inscriptions on the side.",
	
	[ "Item_Name_SMG_G_Ammo" ] = "SMG Grenade",
	[ "Item_Desc_SMG_G_Ammo" ] = "A greenish grenade shaped like a bullet.",
	
	[ "Item_Name_Buckshot_Ammo" ] = "Buckshot Shells",
	[ "Item_Desc_Buckshot_Ammo" ] = "A red box with the Salvotech logo on it.",
	
	[ "Item_Name_Crossbow_Ammo" ] = "Crossbow Bolts",
	[ "Item_Desc_Crossbow_Ammo" ] = "An few orange metal bolts tied together.",
	
	[ "Item_Name_RPGAmmo" ] = "RPG Rocket",
	[ "Item_Desc_RPGAmmo" ] = "A rocket with a grey tip and orange body.",
	
	[ "Item_Name_357Ammo" ] = ".357 Magnum Rounds",
	[ "Item_Desc_357Ammo" ] = "An orange and black container with Magnum on the side.",
	
	[ "Item_Name_CBAmmo" ] = "Energy Orb Cell",
	[ "Item_Desc_CBAmmo" ] = "A small cylindrical piece of material with an orange glow.",
	
	[ "Item_Name_Breach" ] = "Door Breach",
	[ "Item_Desc_Breach" ] = "Used to breach doors.",
	[ "Item_FuncStr01_Breach" ] = "Place",
	[ "Item_Notify_ComLock_Breach" ] = "You can't place a breach on this door!",
	[ "Breach_BlastStr" ] = "Blast",
	
	[ "Item_Name_CWUShirt" ] = "CWU Shirt",
	[ "Item_Desc_CWUShirt" ] = "Civil Workers Union shirt.",
	
	[ "Item_Name_CWUPants" ] = "CWU Pants",
	[ "Item_Desc_CWUPants" ] = "Civil Workers Union pants.",
	
	[ "Item_Name_RebelShirt" ] = "Rebel Shirt",
	[ "Item_Desc_RebelShirt" ] = "A shirt typically used by rebels.",
	
	[ "Item_Name_RebelPants" ] = "Rebel Pants",
	[ "Item_Desc_RebelPants" ] = "A pair of pants typically used by rebels.",
	
	[ "Item_Name_RebelMedicShirt" ] = "Rebel Medic Shirt",
	[ "Item_Desc_RebelMedicShirt" ] = "A rebel shirt, with a red cross on it.",
	
	[ "Item_Name_RebelMedicPants" ] = "Rebel Medic Pants",
	[ "Item_Desc_RebelMedicPants" ] = "A pair of rebel pants, with a red cross on it.",
	
	// Medical
	[ "Item_Category_Medical" ] = "Medical",
	
	[ "Item_Name_HealthK" ] = "Health Kit",
	[ "Item_Desc_HealthK" ] = "A white packet filled with medication.",
	
	[ "Item_Name_HealthV" ] = "Health Vial",
	[ "Item_Desc_HealthV" ] = "A vial filled with green liquid.",
	
	[ "Item_Name_AntideP" ] = "Antidepressants",
	[ "Item_Desc_AntideP" ] = "Its formula seems to make depression lower for a few hours. This is uncivil contraband.",
	[ "Item_FuncStr01_AntideP" ] = "Use",
	[ "Item_Notify_Error01_AntideP" ] = "You can not use this while dead!",
	
	[ "Item_FuncStr01_Medical" ] = "Use",
	[ "Item_FuncStr02_Medical" ] = "Heal",
	[ "Item_Notify_Error01_Medical" ] = "This person doesn't need to be healed!",
	[ "Item_Notify_Error02_Medical" ] = "You don't need to be healed!",
	[ "Item_Notify_Error03_Medical" ] = "This person has already died!",
	[ "Item_Notify_Error04_Medical" ] = "You have already died!",
	
	// Radio
	[ "Item_Name_SR" ] = "Static Radio",
	[ "Item_Desc_SR" ] = "Communication to other people.",
	[ "Item_NoFreq" ] = "No frequency has been set.",
	[ "Item_Freq" ] = "Frequency set to %s.",
	[ "Item_FuncStr01_SR" ] = "Set Frequency",
	[ "Item_FuncStr02_SR" ] = "Toggle",
	[ "Item_FuncStr03_SR" ] = "Place Radio",
	[ "Item_RadioFreqQ_SR" ] = "Would you like to setting frequency for radio?",
	[ "Item_Notify_FreqSet_SR" ] = "You have set the static radio's frequency to %s.",
	[ "Item_Notify_Error01_SR" ] = "Radio frequency must be 101.1 ~ 199.9!",
	[ "Item_Notify_Error02_SR" ] = "Radio frequency must be XXX.X!",
	
	// Alcohol
	[ "Item_Name_Beer" ] = "Beer",
	[ "Item_Desc_Beer" ] = "A bottle filled with cool beer.",
	
	[ "Item_Name_Whisky" ] = "Whiskey",
	[ "Item_Desc_Whisky" ] = "A bottle filled with whiskey.",
	
	[ "Item_Name_Wine" ] = "Wine",
	[ "Item_Desc_Wine" ] = "A bottle of delicious wine.",
	
	// Chat
	[ "Chat_Dispatch" ] = "Combine Dispatch - %s",
	[ "Chat_Radio" ] = "%s radio says %s",
	[ "Chat_Request" ] = "%s request says %s",
	[ "Chat_Breencast" ] = "The breencast screen says: %s",
	
	// Basic
	[ "Basic_Notify_IsNotCombine" ] = "You are not a Combine!",
	
	// Combine Overlay
	[ "CombineOverlay_Str01" ] = "Waiting for a biosignal...",
	[ "CombineOverlay_Str02" ] = "Initializing Heads-up-display...",
	[ "CombineOverlay_Str03" ] = "Ascertaining low-wave radio frequency...",
	[ "CombineOverlay_Str04" ] = "Finding seeders...",
	[ "CombineOverlay_Str05" ] = "Re-localizating peer system...",
	[ "CombineOverlay_Str06" ] = "Regaining equalization modules...",
	[ "CombineOverlay_Str07" ] = "Receiving network messages...",
	[ "CombineOverlay_Str08" ] = "Registering Citadel message frequencies...",
	[ "CombineOverlay_Str09" ] = "Transmitting idle state...",
	
	[ "CombineOverlay_Request" ] = "%s's request - %s ( AREA : %s )",
	[ "CombineOverlay_HealthFullRecovered" ] = "Vital signs recovered ...",
	[ "CombineOverlay_TakeDmg_Local" ] = "WARNING ! Physical bodily trauma detected ...",
	[ "CombineOverlay_TakeDmg_NoLocal" ] = "WARNING ! Unit '%s' has been damaged by unknown problems...",
	[ "CombineOverlay_HealthRecovering" ] = "Vital signs recovering [%s] ...",
	[ "CombineOverlay_LocalPlayerDeath_CP" ] = "ERROR ! Shut Down - ...",
	[ "CombineOverlay_LocalPlayerDeath_OW" ] = "Critical Error - ...",
	[ "CombineOverlay_PlayerDeath_CP" ] = "WARNING ! Unit '%s' vital signs absent, alerting dispatch ...",
	[ "CombineOverlay_PlayerDeath_OW" ] = "WARNING ! Overwatch Unit '%s' vital signs absent, alerting dispatch ...",
	[ "CombineOverlay_Online" ] = "Online",
	[ "CombineOverlay_RFCitizens" ] = "Refreshing citizens list...",
	
	// Attribute
	[ "Jump_Title" ] = "Jump",
	[ "Jump_Desc" ] = "How high you are able to jump.",
	
	[ "Deftness_Title" ] = "Deftness",
	[ "Deftness_Desc" ] = "Your speed.",
	
	[ "Medical_Title" ] = "Medical",
	[ "Medical_Desc" ] = "The amount your health can increase.",
	
	[ "Power_Title" ] = "Power",
	[ "Power_Desc" ] = "The amount your punch damage can increase.",
	
	// Help Category
	[ "Help_Category_CombineVoice" ] = "Combine Voices",
	[ "Help_Desc_CombineVoice" ] = "The list of Combine Voices",
	
	[ "Help_Category_CitizenVoice" ] = "Citizen Voices",
	[ "Help_Desc_CitizenVoice" ] = "The list of Citizen Voices",
	
	// Command
	[ "Command_SpawnDispenser_Fin" ] = "You have added a dispenser.",
	
	// Weapon
	[ "Weapon_Stunstick_Name" ] = "Stunstick",
	[ "Weapon_Stunstick_Instructions" ] = "Primary Fire : Attack.\nSecondary Fire : Push/Knock.\nAlt + Primary Fire : Turn on, off.",
	[ "Weapon_Stunstick_Purpose" ] = "Stunning disobedient characters, pushing them away and knocking on doors."
} )
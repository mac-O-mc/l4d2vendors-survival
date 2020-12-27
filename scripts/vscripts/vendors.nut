//Vendor mutation
//Author: Waifu Enthusiast


//------------------------------------------------------------------------------------------------------
//INCLUDE

//IncludeScript("vendor_itemdata")
IncludeScript("entitygroups/vendors_group")
//IncludeScript("vendors/vendors_manager")

//------------------------------------------------------------------------------------------------------
//MUTATION SETUP

MutationOptions <- {
	
}

MutationState <- {
	vendorTable = {}
	currency = 1
}


function OnGameplayStart() {
	printl( " ** On Gameplay Start" )
	
	PrecacheModel("models/props_office/vending_machine01.mdl")
	PrecacheSound("buttons/bell1.wav")
	PrecacheSound("ambient/generator/Generator_start_run_loop.wav")
	
	local ent = null
	while (ent = Entities.FindByClassname(ent, "player")) {
		printl("Player: " + ent.GetSurvivorSlot())
	}
	
//	CreateVendor(Entities.FindByName(null, "vendorspawn_001"))
//	CreateVendor(Entities.FindByName(null, "vendorspawn_002"))
//	CreateVendor(Entities.FindByName(null, "vendorspawn_003"))
	
/* 	VendorSetItemType(SessionState.vendorTable[0], ITEM_ID.M16)
	VendorSetItemType(SessionState.vendorTable[1], ITEM_ID.LASERSIGHTS_UPGRADE)
	VendorSetItemType(SessionState.vendorTable[2], ITEM_ID.INCENDIARY_UPGRADE) */
	
	//ConvertWeaponsToCurrencyPickups()
}


function OnEntityGroupRegistered( name, group ) {
	printl( " ** Ent Group " + name + " registered ")
}
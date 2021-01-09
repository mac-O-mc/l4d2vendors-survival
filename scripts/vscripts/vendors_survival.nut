//Vendor mutation
//Author: Waifu Enthusiast


//------------------------------------------------------------------------------------------------------
//INCLUDE

IncludeScript("entitygroups/vds_machinegroup")
//IncludeScript("vendors/vendors_manager")

//------------------------------------------------------------------------------------------------------
//MUTATION SETUP

/* MutationState <- {
	survivorteam_currency = 0
} */


function OnGameplayStart() {
	printl( " ** VENDOR SURVIVAL - PRECACHING ASSETS" )
	
	PrecacheModel("models/props_office/vending_machine01.mdl")
	PrecacheSound("buttons/bell1.wav")
	PrecacheSound("ambient/generator/Generator_start_run_loop.wav")
}


function OnEntityGroupRegistered( name, group ) {
	printl( " ** Ent Group " + name + " registered ")
}
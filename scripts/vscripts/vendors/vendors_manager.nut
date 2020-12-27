//Vendor mutation
//Author: Waifu Enthusiast

// this isn't actually used, but only a leftover
//------------------------------------------------------------------------------------------------------
//DECLARE CONSTANTS

const VENDOR_FINISH_TIME		= 2
const MONEY_BIG_THRESHOLD 		= 1000
const UPGRADE_INCENDIARY_AMMO 	= 0
const UPGRADE_EXPLOSIVE_AMMO 	= 1
const UPGRADE_LASER_SIGHT 		= 2

enum ITEM_ID {
    SMG,
    SMG_SILENCED,
    SHOTGUN,
    SHOTGUN_CHROME,
    
    AK47,
    M16,
    DESERT_RIFLE,
    AUTOSHOTGUN,
    SHOTGUN_SPAS,
    HUNTING_RIFLE,
    SNIPER_RIFLE,
    
    PISTOL,
    MAGNUM,
    
    MACHINEGUN,
    GRENADE_LAUNCHER,
    CHAINSAW,
    
    MOLOTOV,
    PIPEBOMB,
    BILE_JAR,
    
    PAIN_PILLS,
    ADRENALINE,
    FIRST_AID_KIT,
    DEFIBRILLATOR,
    
    FIREAXE,
    KATANA,
    
    GAS,
    PROPANE,
    
    INCENDIARY_UPGRADE,
    EXPLOSIVE_UPGRADE,
    LASERSIGHTS_UPGRADE,
    AMMO_REFILL
}


//------------------------------------------------------------------------------------------------------
//VENDOR FUNCTIONALITY

vendorCount <- 0
function ActivateVendor(vendorData, player) {
	printl("Vendor Activated By " + player)
	
	if (PlayerGetCurrency(player) < GetVendorPrice(vendorData)) {
		return false
		//Play sound
		//Make price flash red
		//Lock vendor for a second
	}

	local type = vendorData.itemType;
	if (!type) 
		return false
		
	local itemData = g_vendor_itemData.itemDataArray[type]
	if (!itemData)
		return false
			
	if ("classname" in itemData || "keyvalues" in itemData) {
			
		local kvs = {}
		if ("keyvalues" in itemData)
			kvs = DuplicateTable(itemData)
				
		if ("classname" in itemData)
			kvs.classname <- itemData.classname
			
		kvs.origin 	<- vendorData.entities.deployTarget.GetOrigin()
		kvs.angles 	<- QAngle(0,0,0)
		
		local ent = g_ModeScript.CreateSingleSimpleEntityFromTable(kvs)
		
	}
		
	if ("func" in itemData) {
		
		local params = null
		if ("params" in itemData)
			params = itemData.params
			
		itemData.func(vendorData, player, params)
	}
	
	vendorData.timesUsed++
	return true
}


function VendorSetItemType(vendorData, type) {
	if (vendorData.itemType != type) {
		vendorData.itemType = type;
		
		local displayModel = g_vendor_itemData.itemDataArray[type].display
		vendorData.entities.propItem.SetModel(displayModel)
	}
}


function GetVendorPrice(vendorData) {
	local itemData = itemDataArray[vendorData.itemType]
	return itemData.cost
}


//------------------------------------------------------------------------------------------------------
//CURRENCY MANAGEMENT

function GiveCurrencyToAllSurvivors(quantity) {
	foreach (idx, value in SessionState.currency)
		SessionState.currency[idx] += quantity
}


function PlayerGetCurrency(player) {
	local survivorSlot = player.GetSurvivorSlot()
	return SessionState.currency[survivorSlot]
}

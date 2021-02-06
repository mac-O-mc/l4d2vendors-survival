//Vendor mutation
//Author: Waifu Enthusiast, mac
//IncludeScript("modules/clockwork.nut")
IncludeScript("modules/flamboyance.nut")

//------------------------------------------------------------------------------------------------------
const HUD_LEFT_BOT = 1
const HUD_MID_BOT = 3
const HUD_RIGHT_BOT = 5
const HUD_FAR_LEFT = 7
const HUD_FAR_RIGHT = 8
const HUD_MID_BOX = 9
const HUD_FLAG_NOBG = 64
const HUD_FLAG_TEAM_SURVIVORS = 1024
const HUD_FLAG_TEAM_INFECTED = 2048
const HUD_SPECIAL_MAPNAME = 6
const ZOMBIE_TANK = 8
MutationState <-
{
	intermission = true
	survivorteam_currency = 0
	null_target = null
	last_SI_death_time = Time()
	TickerAdded = false
	KilledMapWeapons = false

	UpdateFuncState =
	{
		ReupdateCount = 0
		SB_HumansPresent = false
		SB_WhoIsNearVendor = false
		SB_IsHumanNearVendor = false
		UpdateTasks = {}
	}
}
MutationOptions <-
{
// == Combo options ==
	layer1_max_combo_time = 0.8
	layer2_max_combo_time = 1.5
	layer3_max_combo_time = 3

// == Vendor shared options ==
// - General
	vd_disabletime = 2

// - Vendors's weapons selection
	T1Weapons =
	[
		"pistol",
		"smg", "smg_silenced", "smg_mp5",
		"pumpshotgun", "shotgun_chrome",
		"sniper_awp", "sniper_scout"
	]
	T2Weapons =
	[
		"rifle", "rifle_desert", "rifle_ak47", "rifle_sg552",
		"autoshotgun", "shotgun_spas",
		"hunting_rifle", "sniper_military"
	]
	SpecialWeapons =
	[
		"pistol_magnum", "rifle_m60", "chainsaw", "grenade_launcher"
	]

// == HUD Options ==
	// HUDTable =
	// {
	// 	Fields = 
	// 	{
	// 		surv_creds_1 = { slot = HUD_FAR_LEFT, special = HUD_SPECIAL_MAPNAME, flags = HUD_FLAG_TEAM_SURVIVORS|HUD_FLAG_TEAM_INFECTED },
	// 		surv_creds_2 = { slot = HUD_MID_BOT, dataval = "Credits: "+MutationState.survivorteam_currency, flags = HUD_FLAG_TEAM_SURVIVORS|HUD_FLAG_TEAM_INFECTED },
	// 	}
	// }

// == Precache options ==
// - Models
	// technically the 'models' and 'sound' part can be omitted iirc
	precache_models =
	[
		"models/props_office/vending_machine01.mdl"
	]
// - Sounds
	precache_sounds = 
	[
		"sound/ambient/generator/generator_start_run_loop.wav",
		"sound/buttons/bell1.wav",
		"sound/level/puck_fail.wav"
	]

// == Weapon options ==
// - Weapons to remove
	map_weaponsToRemove = 
	[
		"smg", "smg_silenced", "smg_mp5", "pumpshotgun", "shotgun_chrome", "sniper_awp", "sniper_scout",
		"rifle", "rifle_desert", "rifle_ak47", "rifle_m60", "rifle_sg552", "autoshotgun", "shotgun_spas" "hunting_rifle", "sniper_military",
		"chainsaw", "melee",
		"grenade_launcher", "molotov","pipe_bomb", "vomitjar",
		// I still want the starter pistols tho
		"ammo", "pistol", "pistol_magnum", "upgradepack_explosive", "upgradepack_incendiary", "upgrade_item", 
		"first_aid_kit", "defibrillator" // , "pain_pills", "adrenaline"
	]
}
// precache every model and sound that we only need to precache if it isn't
foreach( path in MutationOptions.precache_models )
{
	if( !IsModelPrecached( path ) )
	{
		PrecacheModel( path )
		printl( "CHALLENGESCRIPT Precaching model: "+path )
	}
}
foreach( path in MutationOptions.precache_sounds )
{
	if( !IsSoundPrecached( path ) )
	{
		PrecacheSound( path )
		printl( "CHALLENGESCRIPT Precaching sound: "+path )
	}
}
function OnGameplayStart()
{
	HUDSetLayout(MutationOptions.HUDTable)
	// null target for disabling vendors
	if( !MutationState.null_target )
	{
		local null_target = null
		if( null_target = Entities.FindByName(null_target,"null_target") )
			MutationState.null_target = null_target
		else
			MutationState.null_target = SpawnEntityFromTable("info_target", { targetname = "null_target" })
	}
}

// ----------------------
//   == Helper Funcs ==
// // ----------------------
// function Ticker_AnnounceCombo(combotext, timeout = 3)
// {
// 	if( !MutationState.TickerAdded )
// 		Ticker_AddToHud(g_ModeScript.MutationOptions.HUDTable, "")

// 	Ticker_NewStr(combotext, timeout)
// }
function RemovePlayerWeapon(classname, player)
{
	local wepent = null
	while( wepent = Entities.FindByClassnameWithin(wepent, classname, player.GetOrigin(), 1 ) )
	{
		if(wepent.GetRootMoveParent().GetClassname() == "player")
		{
			wepent.Kill()
			break
		}
	}
}
function AddUpdateTask(reupdates, func)
{
	if(!type(reupdates) == "integer")
		throw("Key 'reupdates' expected integer; got "+type(reupdates))

	local UpdateTask = { ReupdatesToWait = reupdates, Func = func, LastUpdate = MutationState.UpdateFuncState.ReupdateCount }

	MutationState.UpdateFuncState.UpdateTasks[UniqueString()] <- ThinkTask
}

// ----------------------
//   == Thinkers ==
// ----------------------
function Update()
{
	if(MutationState.UpdateFuncState.ReupdateCount > 0 && MutationState.UpdateFuncState.UpdateTasks.len() != 0)
	{
		local curtime = Time()
		local toDelete = []

		foreach(ID, Task in MutationState.UpdateFuncState.UpdateTasks)
		{
			local wait_count = Task.LastUpdate + Task.ReupdatesToWait
			if (MutationState.UpdateFuncState.ReupdateCount > wait_count)
			{
				Task.Func.call(this)
				toDelete.push(ID)
		
				foreach(ID in toDelete)
				{
					if (ID in MutationState.UpdateFuncState.UpdateTasks)
						delete MutationState.UpdateFuncState.UpdateTasks[ID]
				}
			}
		}
	}
	MutationState.UpdateFuncState.ReupdateCount++
}

// ----------------------
//   == Game Events ==
// ----------------------
function OnGameEvent_survival_goal_reached( params )
{
	::Flamboyance.PrintToChatAll("shit the event works!")
}
function OnGameEvent_round_start_post_nav( params )
{
	MutationState.intermission = true
}
function OnGameEvent_survival_round_start( params )
{
	MutationState.intermission = false
}
function OnGameEvent_zombie_death( params )
{
	local victim = EntIndexToHScript(params.victim)
	if( victim.IsPlayer() )
	{
		local attacker = EntIndexToHScript(params.attacker)
		if( attacker.IsPlayer() && attacker.IsValid() )
		{
			if( attacker.IsSurvivor() )
			{
				local currency_earned = 1
				if( attacker.GetZombieType() == ZOMBIE_TANK )
					currency_earned += 2

				local last_killed_SI_interval = Time() - MutationState.last_SI_death_time
				local layer1_max_combo_time = MutationOptions.layer1_max_combo_time
				local layer2_max_combo_time = MutationOptions.layer2_max_combo_time
				local layer3_max_combo_time = MutationOptions.layer3_max_combo_time
				if( last_killed_SI_interval <= layer3_max_combo_time )
				{
					if(last_killed_SI_interval <= layer1_max_combo_time )
					{
						::Flamboyance.PrintToChatClient(attacker, "FAST COMBO!", "Orange")
						currency_earned += 2
					}
					else if(last_killed_SI_interval > layer1_max_combo_time && last_killed_SI_interval <= layer2_max_combo_time )
					{
						::Flamboyance.PrintToChatClient(attacker, "COMBO!", "Orange")
						currency_earned += 1
					}
					else if(last_killed_SI_interval > layer2_max_combo_time && last_killed_SI_interval <= layer3_max_combo_time )
					{
						::Flamboyance.PrintToChatClient(attacker, "LATE COMBO!", "Orange")
						currency_earned += 0.5
					}
				//	Ticker_AnnounceCombo(GetCharacterDisplayName(attacker)+" did a combo!", 3)
				//	EmitSoundOnClient("Bot.StuckSound", attacker)
					QueueSpeak(attacker, PlayerTaunt, 1, "IsNotSpeaking, IsTalk")
				}
				MutationState.last_SI_death_time = Time()
				MutationState.survivorteam_currency+=currency_earned
			}
		}
	}
}
function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID(params.userid)
	if( player.IsSurvivor() )
	{
		// no starter pistols FOREVER
		RemovePlayerWeapon("weapon_pistol", player)
		if( !MutationState.KilledMapWeapons )
		{
			EntFire( "weapon_spawn", "Kill" )
			foreach( wep in g_ModeScript.MutationOptions.map_weaponsToRemove )
			{
				EntFire( "weapon_"+wep, "Kill" )
				EntFire( "weapon_"+wep+"_spawn", "Kill", null, 0.5 )
			}
			MutationState.KilledMapWeapons = true
		}
	//	QueueGivePistol()
	}

	// Perhaps implement a system that makes the worth of an SI increase as it deals more damage?
}
function OnGameEvent_player_incapacitated( params )
{
	local incapped = GetPlayerFromUserID(params.userid)
	if( incapped.IsSurvivor() )
	{
		if( !MutationState.KilledMapWeapons )
		{
			EntFire( "weapon_spawn", "Kill" )
			foreach( wep in g_ModeScript.MutationOptions.map_weaponsToRemove )
			{
				EntFire( "weapon_"+wep, "Kill" )
				EntFire( "weapon_"+wep+"_spawn", "Kill", null, 0.5 )
			}
			MutationState.KilledMapWeapons = true
		}
	}

	// Perhaps implement a system that makes the worth of an SI increase as it deals more damage?
}

// -----------------------
//   == Script Events ==
// -----------------------
// Params:
// @entid		-> int,	entity index of the "point_script_use_target"
// @usemodel	-> string, name for the usemodel entity
// @cost		-> int, the cost of the vendor before it ask to be disabled
//
// PLEASE DON'T TOUCH THIS CODE ITS AN UNSTABLE HACK >:O
function OnScriptEvent_vendor_disable( params )
{
	local usetarget = EntIndexToHScript(params.entid)
	local usemodel = params.usemodel
	local cost = params.cost
	local disabled_at_time = Time()
	local vd_disabletime = MutationOptions.vd_disabletime
	local usetarget_name = usetarget.GetName()
	local usetarget_new_name = usetarget_name+"_temp"

	local usetarget_new = null
	usetarget_new = Entities.FindByName(usetarget_new, usetarget_name+"_temp")
	if( !usetarget_new )
	{
		usetarget_new = SpawnEntityFromTable("point_script_use_target", { 
			targetname = usetarget_new_name
			origin = usetarget.GetOrigin()
			vscripts = "vds_surv/vd_usetarget"
			model = "null_target"
		} )
	}
	EntFire(usemodel, "StopGlowing")
	EntFire(usetarget_name, "Kill", null, 0)
	EntFire(usetarget_new_name, "RunScriptCode", "CurrencyCost <- "+cost, vd_disabletime-0.5 )
	EntFire(usetarget_new_name, "RunScriptCode", "RefreshCostText()", vd_disabletime-0.3 )
	EntFire(usetarget_new_name, "SetUseModel", usemodel, vd_disabletime)
	EntFire(usemodel, "StartGlowing", null, vd_disabletime)
	EntFire(usetarget_new_name, "AddOutput", "targetname "+usetarget_name, vd_disabletime+0.1)
}
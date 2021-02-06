//Vendor mutation Survival mode branch
//Author: Waifu Enthusiast + mac

//------------------------------------------------------------------------------------------------------
// Quick Setup
CurrencyCost <- "FREE"
LastTerrorPlayerUsingMe <- null

const T2_CHANCE_MAX = 20
const USE_DURATION = 3
local T2_BONUS_CAP = T2_CHANCE_MAX * 0.75
local ADREN_SPEEDBUFF = Convars.GetFloat("adrenaline_backpack_speedup")

const SNDLVL_80dB = 80
const SNDLVL_90dB = 90
const SNDLVL_100dB = 100
const SNDLVL_110dB = 110
const SNDLVL_120dB = 120
const SNDLVL_130dB = 130
const SNDLVL_140dB = 140
const SNDLVL_300dB = 300

local MutationState = g_ModeScript.MutationState
local MutationOptions = g_ModeScript.MutationOptions
local T1Weapons = MutationOptions.T1Weapons
local T2Weapons = MutationOptions.T2Weapons
local SpecialWeapons = MutationOptions.SpecialWeapons
IncludeScript( "vds_surv/vd_utility" )
// --------------------------
// -- Functions --
function RefreshCostText()
{
	self.SetProgressBarSubText( "Cost: " + CurrencyCost )
}
function InitiateDisable()
{
	local SCRIPTEVENT_PARAMS = {
		entid = self.GetEntityIndex()
		usemodel = self.GetUseModelName()
		cost = CurrencyCost
	}
	FireScriptEvent("vendor_disable", SCRIPTEVENT_PARAMS)
}

// -- Hooks --
function OnPostSpawn()
{
	self.SetProgressBarText( "Buy a weapon" )
	self.SetProgressBarFinishTime( USE_DURATION )	// doesn't work with adrenaline, maybe we ought to use filter_health
	EntFire( self.GetUseModelName(), "startglowing" )
	EntFire( self.GetUseModelName(), "SetGlowRange", 110 )
	RefreshCostText()
}
self.ConnectOutput("OnUseStarted", "UseStart")
// Entity specific only
function UseStart()
{
	LastTerrorPlayerUsingMe = EHandleToPlayer(PlayerUsingMe)
	if( type(CurrencyCost) == "string" && CurrencyCost == "FREE" || type(CurrencyCost) != "string" && CurrencyCost <= MutationState.survivorteam_currency )
	{
		self.SetProgressBarText( "Purchasing.." );
		QueueSpeak(LastTerrorPlayerUsingMe, "PlayerLookHere", 0, "IsTalk:1")
		EmitAmbientSoundOn("ambient/generator/generator_start_run_loop.wav", 100, SNDLVL_110dB, 100, LastTerrorPlayerUsingMe)
	}
	else
	{
		EmitAmbientSoundOn("level/puck_fail.wav", 100, SNDLVL_90dB, 100, LastTerrorPlayerUsingMe)
		self.StopUse()
		InitiateDisable()
	}
	return false
}
function OnUseFinished()
{
	// Setup the random weapon to gib (Only T1 and T2)
	// and also set the correct credit price later
	local RandomWeapon = null
	RandomWeapon = T1Weapons[RandomInt(1,T1Weapons.len()-1)]
	if( type(CurrencyCost) != "string" ) 
	{
		if(CurrencyCost >= 6)
		{
			local T2Chance_Bonus = MathRound(CurrencyCost / 6)
			if(T2Chance_Bonus >= T2_BONUS_CAP)
				T2Chance_Bonus = T2_BONUS_CAP
			
			local T2Chance_Final = RandomInt( T2Chance_Bonus, T2_CHANCE_MAX )
			if(T2Chance_Final == T2_CHANCE_MAX)
				RandomWeapon = T2Weapons[RandomInt(1,T2Weapons.len()-1)]

		}
		CurrencyCost = CurrencyCost + MathRound(CurrencyCost / 2) + RandomInt(0,1) + floor(CurrencyCost / 6)
	}
	else
	{
		CurrencyCost = 1
	}
	EmitSoundOn("Bot.StuckSound", LastTerrorPlayerUsingMe)
//	EmitAmbientSoundOn("buttons/bell1.wav", 100, SNDLVL_300dB, 100, LastTerrorPlayerUsingMe)
	LastTerrorPlayerUsingMe.GiveItem(RandomWeapon)
	LastTerrorPlayerUsingMe.SwitchToItem(RandomWeapon)

	InitiateDisable()
}
function OnUseStop( timeleft )
{
	self.SetProgressBarText( "Buy a weapon" );
	RefreshCostText()

	StopAmbientSoundOn("ambient/generator/generator_start_run_loop.wav", LastTerrorPlayerUsingMe)
//	LastTerrorPlayerUsingMe.SetContextNum("worldtalk",0,2)
}

function OnGameEvent_player_hurt( params )
{
	local PlayerHurt = PlayerInstanceFromIndex( params.userid )
	if ( LastTerrorPlayerUsingMe == PlayerHurt )
		self.StopUse()
}
//Vendor mutation Survival mode branch
//Author: Waifu Enthusiast + mac

//------------------------------------------------------------------------------------------------------
// Quick Setup
CurrencyCost <- 0
LastTerrorPlayerUsingMe <- null
local GLOW_RANGE	= 100
const SNDLVL_80dB = 80
const SNDLVL_90dB = 90
const SNDLVL_100dB = 100
const SNDLVL_110dB = 110

T1Weapons <- [
	"pistol",

	"smg",
	"smg_silenced",
	"smg_mp5",
	
	"pumpshotgun",
	"shotgun_chrome",
	
	"sniper_awp",
	"sniper_scout",
]

T2Weapons <- [
	"rifle",
	"rifle_desert",
	"rifle_ak47",
	"rifle_sg552",
	
	"hunting_rifle",
	"sniper_military",
	
	"autoshotgun",
	"shotgun_spas",
]

SpecialWeapons <- [
	"pistol_magnum",
	
	"chainsaw",
	"grenade_launcher",
]

IncludeScript( "vds_surv/vd_utility" )

// FUNCTIONS
function OnPostSpawn()
{
	self.SetProgressBarText( "Buy a weapon" );
	self.SetProgressBarSubText( "Cost: " + CurrencyCost );
	self.SetProgressBarFinishTime( 3 );
	SetGlowRange( GLOW_RANGE )
}

// why the hell does this brick point_script_use_target?
/*  function OnUseStart()
{
} */

function UseStart()
{
	LastTerrorPlayerUsingMe <- EHandleToPlayer(PlayerUsingMe)
	self.SetProgressBarText( "Purchasing.." );

	QueueSpeak(LastTerrorPlayerUsingMe, "PlayerWaitHere", 0, "")
	EmitSoundOn("dlc.Generator_start_run_loop", LastTerrorPlayerUsingMe)
}
self.ConnectOutput("OnUseStarted","UseStart()")

function OnUseFinished()
{
	CurrencyCost <- CurrencyCost + 1
	EmitAmbientSoundOn("buttons/bell1.wav", 10, SNDLVL_80dB, 100, LastTerrorPlayerUsingMe)
	local RandomT1Weapon = T1Weapons[(RandomInt(1,T1Weapons.len()))]
	LastTerrorPlayerUsingMe.GiveItem(RandomT1Weapon)
	LastTerrorPlayerUsingMe.SwitchToItem(RandomT1Weapon)
}	

function OnUseStop( timeleft )
{
	self.SetProgressBarText( "Buy a weapon" );
	self.SetProgressBarSubText( "Cost: " + CurrencyCost );

	StopSoundOn("dlc.Generator_start_run_loop", LastTerrorPlayerUsingMe)
//	LastTerrorPlayerUsingMe.SetContextNum("worldtalk",0,2)
	printl("Use Stopped")
}

function SetGlowRange( glowrange )
{
	// set the default glow distance
	EntFire( self.GetUseModelName(), "startglowing" );
	EntFire( self.GetUseModelName(), "SetGlowRange", glowrange )
}

function OnGameEvent_player_hurt( params )
{
	local PlayerHurt = PlayerInstanceFromIndex( params.userid )
	if ( LastTerrorPlayerUsingMe == PlayerHurt )
	{
		self.StopUse()
	}
}
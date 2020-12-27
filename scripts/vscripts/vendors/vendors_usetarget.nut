//Vendor mutation Survival mode branch
//Author: Waifu Enthusiast + mac

//------------------------------------------------------------------------------------------------------
// Quick Setup
CurrencyCost <- 0
LastTerrorPlayerUsingMe <- null
local GLOW_RANGE	= 100

const SNDLVL_80dB = 80

IncludeScript( "vendors/vendors_utility" )

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
self.ConnectOutput("OnUseStarted","UseStart")

function OnUseFinished()
{
	CurrencyCost <- CurrencyCost + 1
	EmitAmbientSoundOn("buttons/bell1.wav", 10, SNDLVL_80dB, 100, LastTerrorPlayerUsingMe)
	LastTerrorPlayerUsingMe.GiveItem("sniper_awp")	// this is not good for final
	LastTerrorPlayerUsingMe.SwitchToItem("sniper_awp")	// this is not good for final
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

// test
// use script events if this doesn't work
function OnGameEvent_player_hurt( params )
{
	local PlayerHurt = PlayerInstanceFromIndex( params.userid )
	if ( LastTerrorPlayerUsingMe == PlayerHurt )
	{
		self.StopUse()
	}
}
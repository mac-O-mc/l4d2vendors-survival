//---------------------------------------------------------
// Include all entity group interfaces needed for this mode
// Entities in the MapSpawns table will be included and spawned on map start by default unless otherwise specified.
// MapSpawn table contains at minimum the group name. E.g., [ "WallBarricade" ]
// and at most four parameters: group name, spawn location, file to include, and spawn flags. E.g., [ "WallBarricade", "wall_barricade_spawn", "wall_barricade_group", SPAWN_FLAGS.SPAWN ]
// If you provide only the group name the spawn location and file to include will be generated, and the default 'spawn' flag will be used
// E.g., [ "WallBarricade" ]
// If you provide two parameters it assumes they are the group name and spawn flag, and will auto generate the spawn location and file to include
// E.g., [ "WallBarricade", SPAWN_FLAGS.NOSPAWN ]
// If you provide three parameters it assumes group name, spawn location, and file to include.  It will use the default 'spawn' flag
// E.g., [ "WallBarricade", "my_barricade_spawn", "my_barricade_group" ]
//---------------------------------------------------------
MapSpawns <- 
[
	["vds_machine", "vendormachine_spawn", "vds_machinegroup", SPAWN_FLAGS.SPAWN]
]

printl("VSCRIPT: Running c12m2_traintunnel_vendors_survival.nut")
printl("SCRIPT does nothing extraordinary for now")

MapOptions <-
{
	precache_models =
	[
		"models/v_models/v_cola.mdl",
		"models/w_models/weapons/w_cola.mdl"
	]
	precache_sounds =
	[
		"sound/player/items/attach_cola_bottles_01.wav",
		"sound/player/items/attach_cola_bottles_interrupt.wav" // custom sound
		"sound/player/items/gas_can_fill_interrupt_01.wav",
		"sound/player/items/gas_can_fill_pour_01.wav"
	]
}
// precache every model and sound that we only need to precache if it isn't
foreach( path in MapOptions.precache_models )
{
	if( !IsModelPrecached( path ) )
	{
		PrecacheModel( path )
		printl( "MAPSCRIPT Precaching model: "+path )
	}
}
foreach( path in MapOptions.precache_sounds )
{
	if( !IsSoundPrecached( path ) )
	{
		PrecacheSound( path )
		printl( "MAPSCRIPT Precaching sound: "+path )
	}
}
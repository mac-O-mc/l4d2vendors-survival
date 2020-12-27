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
	["VendorMachine", "vendormachine_spawn", "vendors_group", SPAWN_FLAGS.SPAWN],
]

printl("Loaded c5m2_park_vendors.nut; does nothing for now")
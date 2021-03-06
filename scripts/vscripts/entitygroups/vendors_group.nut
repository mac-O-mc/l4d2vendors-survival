//-------------------------------------------------------
// Handgenerated from 'ammo_crate.vmf'
//-------------------------------------------------------
VendorMachine <-
{
	//-------------------------------------------------------
	// Required Interface functions
	//-------------------------------------------------------
	function GetPrecacheList()
	{
		local precacheModels =
		[
			EntityGroup.SpawnTables.vendormachine,
		]
		return precacheModels
	}

	//-------------------------------------------------------
	function GetSpawnList()
	{
		local spawnEnts =
		[
			EntityGroup.SpawnTables.vendormachine,
			EntityGroup.SpawnTables.vendormachine_usetarget,
		]
		return spawnEnts
	}

	//-------------------------------------------------------
	function GetEntityGroup()
	{
		return EntityGroup
	}

	//-------------------------------------------------------
	// Table of entities that make up this group
	//-------------------------------------------------------
	EntityGroup =
	{
		SpawnTables =
		{
			vendormachine = 
			{
				SpawnInfo =
				{
					classname = "prop_dynamic"
					fademindist = "-1"
					fadescale = "1"
					glowbackfacemult = "1.0"
					MaxAnimTime = "10"
					MinAnimTime = "5"
					model = "models/props_office/vending_machine01.mdl"
					renderamt = "255"
					rendercolor = "255 255 255"
					solid = "6"
					targetname = "vendormachine"
					origin = Vector( 2, -0, -0 )
				}
			}
			vendormachine_usetarget = 
			{
				SpawnInfo =
				{
					classname = "point_script_use_target"
					model = "vendormachine"
					origin = Vector( 0, -24, 0 )
					targetname = "vendormachine_usetarget"
					vscripts = "vendors/vendors_usetarget"
				/*	connections =
					{
						OnUser1 =
						{
							cmd1 = "ammo_crate_open_sndPlaySound01"
							cmd2 = "ammo_crate_templateForceSpawn01"
							cmd3 = "ammo_crate_lid_rotatorOpen01"
							cmd4 = "ammo_crate_static_lidKill01"
							cmd5 = "ammo_crate_lidEnable01"
							cmd6 = "ammo_crate_buttonKill01"
							cmd7 = "!selfKill01"
						}
					} */
				}
			}
		} // SpawnTables
	} // EntityGroup
} // VendorMachine

RegisterEntityGroup( "VendorMachine", VendorMachine )

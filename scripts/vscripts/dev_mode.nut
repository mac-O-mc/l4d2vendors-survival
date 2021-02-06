//-----------------------------------------------------

local Dev_Convar_Value = Convars.GetFloat("developer")

if ( Dev_Convar_Value < 1)
{
	Convars.SetValue("developer", "1")
	Convars.SetValue("survival_round_restart_delay","1")
	Msg("DEV ENABLED\n");
}
else if ( Dev_Convar_Value == 1)
{
	Convars.SetValue("developer", "2")
	Msg("VERBOSE DEV ENABLED\n");
}
else if ( Dev_Convar_Value == 2)
{
	Convars.SetValue("developer", "3")
	Msg("A VERBOSER DEV ENABLED\n");
}
else if ( Dev_Convar_Value == 3)
{
	Convars.SetValue("developer", "4")
	Msg("EVEN MORE VERBOSER DEV ENABLED\n");
}
else
{
	Convars.SetValue("developer", "0")
	Convars.SetValue("survival_round_restart_delay","0")
	Msg("DEV DISABLED\n");
}
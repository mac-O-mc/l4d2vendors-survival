//-----------------------------------------------------

local Dev_Convar_Value = Convars.GetFloat("developer")

if ( Dev_Convar_Value < 1)
{
	Convars.SetValue("developer", "1")
	Msg("DEV ENABLED\n");
}
else if ( Dev_Convar_Value == 1)
{
	Convars.SetValue("developer", "2")
	Msg("VERBOSE DEV ENABLED\n");
}
else
{
	Convars.SetValue("developer", "0")
	Msg("DEV DISABLED\n");
}
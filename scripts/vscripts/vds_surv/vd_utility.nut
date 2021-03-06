//Vendor mutation
//Author: Waifu Enthusiast

//------------------------------------------------------------------------------------------------------
//UTILITY

function EHandleToPlayer(ehandle) {
	local player = null
	while (player = Entities.FindByClassname(player, "player")) {
		
		if (ehandle == player.GetEntityHandle())
			return player
	}
	return null
}
/* function EHandleToSurvivorSlot(ehandle) {
	local player = null
	while (player = Entities.FindByClassname(player, "player")) {
		
		if (ehandle != player.GetEntityHandle())
			continue
			
		if (!player.IsPlayer())
			return null
			
		if (!player.IsSurvivor())
			return null
			
		return player.GetSurvivorSlot()
		
	}
	return null
} */

function MathRound(floatnum)
{
	local floornum = floor(floatnum)
	local ceilnum = ceil(floatnum)
	if(floatnum - floornum >= 0.5)
		return ceilnum
	else
		return floatnum
}
function MathToClosestMultipleOf(num, factor)
{
	return factor * (MathRound(num / factor))
}
function onCastSpell(player, variant)
	if not Cooldown(player,"Anti Trade",30003,25) then return false end

	local formula,pid = (player:getStorageValue(49999)*0.4) + 4, player:getTarget()


	if  player:getHealth() > formula then
		doCreatureAddHealth(player, -formula)
	else 
		doCreatureAddHealth(player, -getCreatureHealth(player)+1)
	end

doPlayerAddMana(player, formula*2)



end
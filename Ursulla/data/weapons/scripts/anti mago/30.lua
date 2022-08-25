local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setFormula(COMBAT_FORMULA_SKILL, 0, 0, 1, 0)


function onUseWeapon(player, variant)

	local pid = getCreatureTarget(creature)
	
	if isPlayer(pid) then
	doPlayerAddMana(pid, -getCreatureMaxMana(pid)*0.001)
	doPlayerAddMana(creature, getCreatureMaxMana(pid)*0.001) 
	end
	
	return combat:execute(player, variant)

end
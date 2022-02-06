local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 26)
combat:setParameter(COMBAT_PARAM_USECHARGES, true)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)

function onGetFormulaValues(player, skill, attack, factor)
	local min = (player:getLevel() / 5) + (skill + attack)*0.5  + (FORCA(player) * 2.5)
    return -min, -min
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

function onCastSpell(player, variant)


	if not Cooldown(player,"Barbarian impact",30002,5) then return false end

	local pid = player:getTarget()
	

		if (pid:getHealth() < (pid:getMaxHealth() * 0.5) and getPlayerStorageValue(player, 29997) ~= 1)  then 
			doCreatureAddHealth(pid,-FORCA(player),true) 
		end
		if (pid:getHealth() < (pid:getMaxHealth() * 0.5) and getPlayerStorageValue(player, 29997) == 1) then 
			doCreatureAddHealth(pid,-FORCA(player),true) 
		end		

	
	return combat:execute(player, variant)

end
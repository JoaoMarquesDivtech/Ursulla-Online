local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 49)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 56)

function onGetFormulaValues(player, level, maglevel)
	local min = (INTELIGENCIA(player)*3) + (level / 5) + (maglevel * 0.5) 
	return -min, -min
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")


function onCastSpell(player, variant)

    if not Cooldown(player,"Shock Strike",30000,3) then return false end
	
	return combat:execute(player, variant)
end

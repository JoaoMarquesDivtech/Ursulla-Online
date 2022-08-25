local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HOLYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 40)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 38)


function onGetFormulaValues(player, level, maglevel)
    local inteligencia = player:getStorageValue(50000)
	local min = (level / 5) + (maglevel)  + (INTELIGENCIA(player)*2.5)
	return -min, -min
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(player, variant)
     
	if not Cooldown(player,"light Strike",30000,3) then return false end
	
	return combat:execute(player, variant)
	
end

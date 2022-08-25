local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 47)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 30)

function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel) + 8 + (INTELIGENCIA(player)*2)
	return -min, -min
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(player, variant)
     
	if not Cooldown(player,"Element Strike",30000,3) then return false end
	return combat:execute(player, variant)
end

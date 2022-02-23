local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat:setParameter(COMBAT_PARAM_EFFECT, 40)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)


function onGetFormulaValues(player, level, maglevel)
	local min = ((level / 5) + (maglevel) + 8 + (INTELIGENCIA(player)*2.6))*0.8
	return min, min
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(player, variant)


if not Cooldown(player,"nature cure",30002,9) then return false end

return combat:execute(player, variant)
end

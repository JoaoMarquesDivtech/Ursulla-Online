local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 3)

function onGetFormulaValues(player, level, skill)
    local min = (skill + (level / 5) + (PRECISAO(player) * 2.5) + DESTREZA(player))
	return -min, -min
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

function onCastSpell(player, variant)

    if not Cooldown(player,"Arc Strike",30000,3) then return false end
	
	return combat:execute(player, variant)
end

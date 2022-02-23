local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 2)

function onGetFormulaValues(player, level, skill)
    local min = (skill + (level / 5) + (PRECISAO(player) * 2.5) + (DESTREZA(player)*0.8))
	return -min, -min
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

function onCastSpell(player, variant)

    if not Cooldown(player,"Camp Strike",30000,3) then return false end
	
	return combat:execute(player, variant)
end

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 28)
combat:setArea(createCombatArea(AREA_CROSS1X1))

function onGetFormulaValues(player, level, skill)
    local min = (skill + (level / 5) + (PRECISAO(player)) + (DESTREZA(player)*2.7))*3
	return -min, -min
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

function onCastSpell(player, variant)

    if not Cooldown(player,"Arc Gran Strike",30003,22) then return false end
	
	return combat:execute(player, variant)
end

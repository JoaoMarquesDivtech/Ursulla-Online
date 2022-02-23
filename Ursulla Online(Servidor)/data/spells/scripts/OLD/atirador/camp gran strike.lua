local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 28)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)

function onGetFormulaValues(player, level, skill)
    local min = (skill + (level / 5) + (PRECISAO(player) * 2.5) + (DESTREZA(player)*0.8))*3
	return -min, -min
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

function onCastSpell(creature, variant)

    if not Cooldown(creature,"Camp Gran Strike",30003,22) then return false end
	
	return combat:execute(creature, variant)
end

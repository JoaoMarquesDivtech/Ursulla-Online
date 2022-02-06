local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setArea(createCombatArea(AREA_WALLFIELD))


local combat2 = Combat()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat2:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 3)

function onGetFormulaValues(player, level, skill)
    local min = (skill + (level / 5) + (PRECISAO(player)) + (DESTREZA(player)*2.4))
	return -min, -min
end

combat2:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

function onTargetCreature(player, target)	
	return combat2:execute(player, Variant(target:getPosition()))	
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

function onCastSpell(player, variant)

    if not Cooldown(player,"Arc Multistrike",30001,10) then return false end
	
	
	return combat:execute(player, variant)
end

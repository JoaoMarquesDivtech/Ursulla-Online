local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 24)

function onGetFormulaValues(player, level, skill)
    local min = (skill + (level / 5) + (PRECISAO(player) * 2.7) + (DESTREZA(player)*0.8))
	return -min, -min
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")


local condition = createConditionObject(CONDITION_HASTE)
setConditionParam(condition, CONDITION_PARAM_SPEED, -150)
setConditionParam(condition, CONDITION_PARAM_TICKS, 2000)
setConditionParam(condition, CONDITION_PARAM_BUFF, TRUE)
setCombatCondition(combat, condition)

local condition = createConditionObject(CONDITION_DRUNK)
setConditionParam(condition, CONDITION_PARAM_TICKS, 2000)
setConditionParam(condition, CONDITION_PARAM_BUFF, TRUE)
setCombatCondition(combat, condition)

function onCastSpell(creature, variant)

    if not Cooldown(creature,"Camp allowed",30002,16) then return false end
	
	return combat:execute(creature, variant)
end

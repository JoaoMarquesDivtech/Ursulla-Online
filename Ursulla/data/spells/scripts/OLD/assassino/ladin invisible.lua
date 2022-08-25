local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local condition = Condition(CONDITION_INVISIBLE)
condition:setParameter(CONDITION_PARAM_TICKS, 8000)
combat:setCondition(condition)

local condition2 = createConditionObject(CONDITION_HASTE)
setConditionParam(condition2, CONDITION_PARAM_SPEED, 350)
setConditionParam(condition2, CONDITION_PARAM_TICKS, 8000)
setConditionParam(condition2, CONDITION_PARAM_BUFF, TRUE)
setCombatCondition(combat, condition2)

function onCastSpell(player, variant)

     if not Cooldown(player,"Ladin invisible",30003,25) then return false end

   
	return combat:execute(player, variant)
end

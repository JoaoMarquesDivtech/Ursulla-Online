local conditionAttrib = createConditionObject(CONDITION_ATTRIBUTES)
setConditionParam(conditionAttrib, CONDITION_PARAM_TICKS, 30000)
setConditionParam(conditionAttrib, CONDITION_PARAM_SKILL_SHIELDPERCENT, 40)
setConditionParam(conditionAttrib, CONDITION_PARAM_BUFF_SPELL, 1)

local condition2 = createConditionObject(CONDITION_HASTE)
setConditionParam(condition2, CONDITION_PARAM_SPEED, -100)
setConditionParam(condition2, CONDITION_PARAM_TICKS, 30000)
setConditionParam(condition2, CONDITION_PARAM_BUFF, TRUE)
setCombatCondition(combat, condition2)


local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, 0)
setCombatCondition(combat, conditionAttrib)

function onCastSpell(cid, var)

    if not Cooldown(cid,"Guardian Defensive",30003,30) then return false end 
	 
	return doCombat(cid, combat, var)
end

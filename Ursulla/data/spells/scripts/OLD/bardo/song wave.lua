local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 20)
combat:setArea(createCombatArea(AREA_SQUAREWAVE5))


function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel*1.5) + (INTELIGENCIA(player)*2.5)
	return -min, -min
end


combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local condition = createConditionObject(CONDITION_DRUNK)
setConditionParam(condition, CONDITION_PARAM_TICKS, 3000)
setConditionParam(condition, CONDITION_PARAM_BUFF, TRUE)
setCombatCondition(combat, condition)

function onCastSpell(player, variant)
     
	if not Cooldown(player,"song wave",30001,9) then return false end
	return combat:execute(player, variant)
end

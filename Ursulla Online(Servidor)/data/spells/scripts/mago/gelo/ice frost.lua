local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 44)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 29)
combat:setArea(createCombatArea(AREA_CIRCLE2X2))

function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel)  + (INTELIGENCIA(player)*2.4)
	return -min, -min
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local condition = createConditionObject(CONDITION_HASTE)
setConditionParam(condition, CONDITION_PARAM_SPEED, -80)
setConditionParam(condition, CONDITION_PARAM_TICKS, 3000)
setConditionParam(condition, CONDITION_PARAM_BUFF, TRUE)
setCombatCondition(combat, condition)


function onCastSpell(player, variant)
     
	if not Cooldown(player,"ice frost",30002,14) then return false end
	
	return combat:execute(player, variant)

	
end

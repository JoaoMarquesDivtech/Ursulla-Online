local condition = Condition(CONDITION_DROWN)
condition:setParameter(CONDITION_PARAM_TICKS, -1)
condition:setParameter(CONDITION_PARAM_PERIODICDAMAGE, -10)
condition:setParameter(CONDITION_PARAM_TICKINTERVAL, 2000)

function onStepIn(creature, item, position, fromPosition)
	if not isPlayer(creature) then
		return true
	end

	if math.random(2) == 1 then
		position:sendMagicEffect(CONST_ME_BUBBLES)
	end
	creature:addCondition(condition)
end

function onStepOut(creature, item, position, fromPosition)


	creature:removeCondition(CONDITION_DROWN)
end

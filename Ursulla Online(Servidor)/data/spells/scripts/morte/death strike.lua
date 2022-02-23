local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_DEATH)

function onGetFormulaValues(player, level, maglevel)
	local min = (INTELIGENCIA(player)*3) + (level / 5) + (maglevel*0.3) 
	return -min, -min
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")


local condition = createConditionObject(CONDITION_HASTE)
setConditionParam(condition, CONDITION_PARAM_SPEED, 300)
setConditionParam(condition, CONDITION_PARAM_TICKS, 3000)
setConditionParam(condition, CONDITION_PARAM_BUFF_SPELL, 1)


local combat2 = Combat()
setCombatParam(combat2, COMBAT_PARAM_AGGRESSIVE, 0)
setCombatParam(combat2,COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_RED)
setCombatCondition(combat2, condition)


function onCastSpell(player, variant)

    if not Cooldown(player,"Death Strike",30000,3) then return false end
	
	if #getCreatureSummons(player) == 1 then
		local pid = player:getTarget()
		local mid = player:getSummons()[1]
		combat2:execute(player, Variant(mid:getPosition()))
	end
	
	return combat:execute(player, variant)
end

local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local condition = Condition(CONDITION_MANASHIELD)
condition:setParameter(CONDITION_PARAM_TICKS, 28000)
combat:setCondition(condition)

function onCastSpell(player, variant)
    
	if not Cooldown(player,"Anti Shield",30001,30) then return false end
	return combat:execute(player, variant)
	
end

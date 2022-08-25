local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_WEAPONTYPE)
combat:setParameter(COMBAT_PARAM_USECHARGES, true)

function onGetFormulaValues(player, skill, attack, factor)
    local forca = player:getStorageValue(50001)
	local min = ((player:getLevel() / 5) + (skill + attack)*0.5  + (forca))*1.5
    return -min, -min
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")


local condition = createConditionObject(CONDITION_HASTE)
setConditionParam(condition, CONDITION_PARAM_SPEED, -200)
setConditionParam(condition, CONDITION_PARAM_TICKS, 2000)
setConditionParam(condition, CONDITION_PARAM_BUFF, TRUE)
setCombatCondition(combat, condition)

function onCastSpell(player, variant)

    if not Cooldown(player,"Paladin Allowed",30001,11) then return false end
	
	return combat:execute(player, variant)
end

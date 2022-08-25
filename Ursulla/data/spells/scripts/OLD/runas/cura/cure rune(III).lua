local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)
combat:setParameter(COMBAT_PARAM_TARGETCASTERORTOPMOST, true)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

function onGetFormulaValues(player, level, maglevel)
    local inteligencia = player:getStorageValue(50000)
	local min = (inteligencia*3)+ (maglevel * 0.3) + 10
	local max = (inteligencia*3)+ (maglevel * 0.3) + 10
	return min, max
end
combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(creature, variant, isHotkey)
if not Cooldown(creature,"Cure Rune",30010,8) then return false end
	return combat:execute(creature, variant)
end

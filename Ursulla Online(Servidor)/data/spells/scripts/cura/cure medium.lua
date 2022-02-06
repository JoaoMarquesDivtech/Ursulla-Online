local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

function onGetFormulaValues(player, level, maglevel)
	local min = ((level / 5) + (maglevel) + 40)*2
	local max = ((level / 5) + (maglevel) + 40)*2
	return min, max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(cid, variant)


if not Cooldown(cid,"Cure min",29999,13) then return false end

return combat:execute(cid, variant)
end

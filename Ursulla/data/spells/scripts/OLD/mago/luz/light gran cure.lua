local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat:setParameter(COMBAT_PARAM_EFFECT, 40)
combat:setParameter(COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)


function onGetFormulaValues(player, level, maglevel)
    local inteligencia = player:getStorageValue(50000)
	local min = ((level / 5) + (maglevel) + (INTELIGENCIA(player)*3))*3
	return min, min
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(player, variant)

if not Cooldown(player,"light gran cure",30003,25) then return false end



return combat:execute(player, variant)

end

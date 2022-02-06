local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 51)
combat:setArea(createCombatArea(AREA_SQUAREWAVE5 ))


function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel) + (INTELIGENCIA(player)*3)
	return -min, -min
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(player, variant)
     
	if not Cooldown(player,"Nature Wave",30001,9) then return false end
	
	return combat:execute(player, variant)
end

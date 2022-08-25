local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 20)
combat:setArea(createCombatArea(AREA_CIRCLE2X2))


function onGetFormulaValues(player, level, maglevel)
	local min = (player:getHealth()*0.1) + (VITALIDADE(player)*4) + (level / 5) + (maglevel*1.5) + (INTELIGENCIA(player)*1.5)
	return -min, -min
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(player, variant)
	if not Cooldown(player,"blood explosion",30003,22) then return false end
		
	player:addHealth(-(VITALIDADE(player)*4))
	
	return combat:execute(player, variant)
	
end

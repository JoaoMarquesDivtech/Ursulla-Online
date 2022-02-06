local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 24)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)

function onGetFormulaValues(player, level, maglevel)
	local min = (level / 10) + (INTELIGENCIA(player)*2.5)+ (maglevel *1.5) 
	return -min, -min
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onTargetCreature(player, target)

	target:setStorageValue(79000, 0)
	
	addEvent(function()
		if player:isRemoved() or target:isRemoved() then return false end
		target:setStorageValue(79000, -1)
	end,3000)
	
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

function onCastSpell(player, variant)
    
	if not Cooldown(player,"Song Silence",30000,15) then return false end
	
    return combat:execute(player, variant)	
	
end

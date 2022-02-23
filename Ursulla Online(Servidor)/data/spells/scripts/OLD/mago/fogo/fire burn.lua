local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 7)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_FIRE)
combat:setArea(createCombatArea(AREA_SQUARE2X2))


function onGetFormulaValues(player, level, maglevel)
    local inteligencia = player:getStorageValue(50000)
	local min = (INTELIGENCIA(player)*3)+(level / 5) + (maglevel * 0.5)
	return -min, -min
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local combat2 = Combat()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, 16)


function onGetFormulaValues(player, level, maglevel)
    local inteligencia = player:getStorageValue(50000)
	local min = ((INTELIGENCIA(player)*2.7)+(level / 5) + (maglevel * 0.3))*0.3
	return -min, -min
end

combat2:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")


function onTargetCreature(player, target)

	for i = 1,5 do
	addEvent(function()
	    if target:isRemoved() then return false end
		combat2:execute(player, Variant(target:getPosition()))
	end,i*700)
	end
	
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")


function onCastSpell(creature, variant)
	if not Cooldown(creature,"Fire Burn",30003,20) then return false end


	return combat:execute(creature, variant)
	
end

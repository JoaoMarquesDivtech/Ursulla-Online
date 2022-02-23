local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 7)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_FIRE)
combat:setArea(createCombatArea(AREA_WALLFIELD))


function onGetFormulaValues(player, level, maglevel)
	local min = (INTELIGENCIA(player)*3) + (maglevel) + 2
	return -min, -min
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local combat2 = Combat()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, 16)


function onGetFormulaValues(player, level, maglevel)
    local inteligencia = player:getStorageValue(50000)
	local min = ((INTELIGENCIA(player)*3)+ (maglevel))*0.1 + 1
	return -min, -min
end

combat2:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onTargetCreature(player, target)

	for i = 1,5 do
	addEvent(function()
	    if target:isRemoved() then return false end
		combat2:execute(player, Variant(target:getPosition()))
	end,i*700)
	end
	
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")


function onCastSpell(player, variant)

	if not Cooldown(player,"Fire Ball",30000,5) then return false end

	return combat:execute(player, variant)
	
end

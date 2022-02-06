local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 51)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 39)
combat:setArea(createCombatArea(AREA_CIRCLE2X2))


function onGetFormulaValues(player, level, maglevel)
	local min = ((level / 5) + (maglevel) + (INTELIGENCIA(player)*3))*1.2
	return -min, -min
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local combat2 = Combat()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, 47)


function onGetFormulaValues(player, level, maglevel)
	local min = ((level / 5) + (maglevel) + (INTELIGENCIA(player)*3))*0.3
	return -min, -min
end

combat2:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onTargetCreature(player, target)

	 for i= 0,3 do 
		addEvent(function()
			if target:isRemoved() or player:isRemoved() then return false end
			combat2:execute(player, Variant(target:getPosition()))
		end,i*1200)
	 end
	
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

function onCastSpell(player, variant)
     
    if not Cooldown(player,"Nature Rage",30003,17) then return false end


	return combat:execute(player, variant)
end

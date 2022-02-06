local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 56)
combat:setParameter(COMBAT_PARAM_EFFECT, 49)

function onGetFormulaValues(player, level, maglevel)
	local min = ((INTELIGENCIA(player)*2.5)+(level / 5) + (maglevel * 0.5))*0.5
	return -min, -min
end


combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local combat2 = Combat()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, 49)
combat2:setParameter(COMBAT_PARAM_BLOCKARMOR, true)

function onGetFormulaValues(player, level, maglevel)
    local inteligencia = player:getStorageValue(50000)
	local min = ((inteligencia*3) + (level / 5) + (maglevel * 0.5))*0.3
	return -min, -min
end

combat2:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local combat3 = Combat()
combat3:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat3:setParameter(COMBAT_PARAM_EFFECT, 48)
combat3:setArea(createCombatArea(AREA_CIRCLE2X2))

function onGetFormulaValues(player, level, maglevel)
    local inteligencia = player:getStorageValue(50000)
	local min = ((inteligencia*3)+(level / 5) + (maglevel * 0.5))*2
	return -min, -min
end

combat3:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")


function onCastSpell(player, variant)
    if not Cooldown(player,"Shock Charge",30001,25) then return false end
	
	
    local pid = player:getTarget()
	
	for i= 1,10 do
		addEvent(function()
			if player:isRemoved() or pid:isRemoved() then return false end
			if i==10 then
				combat3:execute(player, Variant(pid:getPosition()))
			else
				combat2:execute(player, Variant(pid:getPosition()))		
			end
		end,i*550)
	end
	
	return combat:execute(player, variant)
	
end

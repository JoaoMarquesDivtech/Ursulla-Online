local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_DEATH)

function onGetFormulaValues(player, level, maglevel)
	local min = (INTELIGENCIA(player)*3)+(level / 5) + (maglevel * 0.5)
	return -min, -min
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local combat2 = Combat()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)

function onGetFormulaValues(player, level, maglevel)
	local min = ((INTELIGENCIA(player)*3)+(level / 5) + (maglevel * 0.5))*0.2 
	return -min, -min
end

combat2:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")


function onCastSpell(creature, variant)
    if not Cooldown(creature,"Death Curse",30002,23) then return false end
	
     local pid = creature:getTarget()
	
	for i = 1,10 do
		addEvent(function()
			if pid:isRemoved() or player:isRemoved() then return false end
			combat2:execute(creature, Variant(player:getPosition()))
			if i==10 and isPlayer(pid) and player:getHealth()>=player:getMaxHealth()*0.4 then
				doCreatureAddHealth(pid, -getCreatureMaxHealth(pid)*0.10)
			end
		end,i*900)
	end
	
	return combat:execute(creature, variant)
end

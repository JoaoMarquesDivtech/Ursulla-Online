local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat:setParameter(COMBAT_PARAM_EFFECT, 40)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

function onGetFormulaValues(player, level, maglevel)
    local vitalidade = player:getMaxHealth()
    local min = ((vitalidade * 0.05) + (level / 5) + (maglevel * 0.5))
    return min, min
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")


local combat2 = Combat()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat2:setParameter(COMBAT_PARAM_EFFECT, 40)
combat2:setParameter(COMBAT_PARAM_AGGRESSIVE, false)


function onGetFormulaValues(player, level, maglevel)
    local vitalidade = player:getMaxHealth()
    local min = ((vitalidade * 0.05) + (level / 5) + (maglevel * 0.5))*0.5
    return min, min
end

combat2:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")


function onCastSpell(player, variant)


if not Cooldown(player,"Templar Reveal",30001,25) then return false end

    if player:getHealth() < player:getMaxHealth()*0.5 then
		for i=0,7 do
			addEvent(function()
				if player:isRemoved() then return false end
				combat2:execute(player, Variant(player:getPosition()))
			end,i*400)
		end
	end
	
    return combat:execute(player, variant)
	

end
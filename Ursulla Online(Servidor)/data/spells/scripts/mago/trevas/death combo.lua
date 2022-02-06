local combat2 = Combat()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)

function onGetFormulaValues(player, level, maglevel)
	local min = ((INTELIGENCIA(player)*3)+ (level / 5) + (maglevel * 0.5))*0.3
	return -min, -min
end

combat2:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")


function onCastSpell(player, variant)
    if not Cooldown(player,"Death Combo",30003,12) then return false end
	
    local pid = player:getTarget()
	
	for i=0,4 do
		addEvent(function()
			if player:isRemoved() or pid:isRemoved() then return false end
				if #player:getSummons()==1 then
					combat2:execute(player, variant)
					doSendDistanceShoot(player:getSummons()[1]:getPosition(), pid:getPosition(), 11)
				end	
			doSendDistanceShoot(player:getPosition(), pid:getPosition(), 11)
			combat2:execute(player, variant)	
		end,i*100)
	end
	
	return true
end
	
	


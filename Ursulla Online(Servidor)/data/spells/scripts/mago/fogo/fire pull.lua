local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 7)
setCombatParam(combat, COMBAT_PARAM_CREATEITEM, 1492)



function onGetFormulaValues(player, level, maglevel)
	local min = ((INTELIGENCIA(player)*2.5)+ (level / 5) + (maglevel*1.5))*0.6
	return -min, -min
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(player, variant)

    if not Cooldown(player,"Fire Pull",30002,14) then return false end
	
    local pid = player:getTarget()

    for i = 1, 5 do
		addEvent(function()
			if player:isRemoved() or pid:isRemoved() then return false end
			local cidpos = player:getPosition()
			doSendDistanceShoot(cidpos, {x = cidpos.x - 7, y = cidpos.y - 6, z = cidpos.z}, 4)
	end,i*100)
	end

    local pidpos = pid:getPosition()
	
	for i = 1, 5 do
		addEvent(function()
			if player:isRemoved() or pid:isRemoved() then return false end
			doSendDistanceShoot({x = pidpos.x - 7, y = pidpos.y - 6, z = pidpos.z}, pidpos,4)
			combat:execute(player, positionToVariant(pidpos))
		end,i*300)
	end
	
end

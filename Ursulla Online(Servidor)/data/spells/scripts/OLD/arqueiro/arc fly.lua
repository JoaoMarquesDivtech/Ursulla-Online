local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setArea(createCombatArea(AREA_SQUARE2X2))


local combat2 = Combat()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)


function onGetFormulaValues(player, level, skill)
    local min = (skill + (level / 5) + (PRECISAO(player)) + (DESTREZA(player)*2.5))
	return -min, -min
end

combat2:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

function onTargetCreature(player, target)
		
		addEvent(function()
			if player:isRemoved() or target:isRemoved() then return false end
			local cidpos = player:getPosition()
			doSendDistanceShoot(cidpos, {x = cidpos.x - 7, y = cidpos.y - 6, z = cidpos.z},3)
		end, math.random(5,200))
		
		addEvent(function()
			if target:isRemoved() or player:isRemoved() then return false end
			local pidpos = target:getPosition()
			doSendDistanceShoot({x = pidpos.x - 7, y = pidpos.y - 6, z = pidpos.z}, pidpos, 3)
			combat2:execute(player, Variant(pidpos))
		end,500)
	
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

function onCastSpell(player, variant)

    if not Cooldown(player,"Arc Fly",30002,17) then return false end

	return combat:execute(player, variant)
end

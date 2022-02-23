local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 2)

function onGetFormulaValues(player, level, skill)
    local min = (skill + (level / 5) + (PRECISAO(player) * 2.5) + (DESTREZA(player)*0.8))*0.5
	return -min, -min
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")


function DistAtack(player)
	for i = 0,10 do
		addEvent(function()
			local target = player:getTarget()
			if target==nil then 
				return false 
			end
			local cidpos, pidpos = player:getPosition(),target:getPosition()
			if (cidpos:getDistance(pidpos))<=4 and cidpos:isSightClear(pidpos) then
				return combat:execute(player, Variant(pidpos))
			end
		end,i*400)
	end	
end

function onCastSpell(player, variant)

    if not Cooldown(player,"Camp Multiples",30000,19) then return false end
	
	DistAtack(player)
	
	return true
end

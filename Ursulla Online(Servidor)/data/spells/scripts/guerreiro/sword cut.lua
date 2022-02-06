local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setParameter(COMBAT_PARAM_USECHARGES, true)

function onGetFormulaValues(player, skill, attack, factor)
    local força = player:getStorageValue(50001)
	local min = (player:getLevel() / 5) + (skill + attack)*0.5  + (força * 2.5)
    return -min, -min
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

function onCastSpell(player, variant)


if not Cooldown(player,"Sword Cut",30000,3) then return false end


	local pid, mid = player:getTarget(),  player:getSummons()[1]

	addEvent(function()
		if #player:getSummons()==1 then  
			if player:isRemoved() or pid == mid or pid:isRemoved() then return false end

			local midpos, pidpos = mid:getPosition(),  pid:getPosition()
			doSendDistanceShoot(midpos, pidpos, 25)
			doTeleportThing(mid, pidpos)
			combat:execute(player, variant)
		end
	end,100)

	return combat:execute(player, variant)

end
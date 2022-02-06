local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 26)
combat:setParameter(COMBAT_PARAM_USECHARGES, true)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)

function onGetFormulaValues(player, skill, attack, factor)
	local min = (player:getLevel() / 5) + (skill + attack)*0.5  + (FORCA(player) * 2.5)
    return -min, -min
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(player, variant)


if not Cooldown(player,"Barbarian Combo",30001,12) then return false end

local pid = player:getTarget()


	for i= 0,1 do 
		addEvent(function()
			if player:isRemoved() or pid:isRemoved() then return false end
				combat:execute(player, variant)
			if player:getStorageValue(29997) == 1 then
				combat:execute(player, variant)
			end
		end,i*200)
	end
	
	return true

end
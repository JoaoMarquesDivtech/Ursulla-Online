local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 2)

function onGetFormulaValues(player, level, skill)
    local min = (skill + (level / 5) + (PRECISAO(player) * 2.5) + (DESTREZA(player)*0.5))
	return -min, -min
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")


function onCastSpell(player, variant)

    if not Cooldown(player,"Camp Combo",30001,11) then return false end

    local pid = player:getTarget()
	
	for i=0,2 do
		addEvent(function()
			if pid:isRemoved() or player:isRemoved() then return false end
			combat:execute(player, Variant(pid:getPosition()))
		end,i*200)
	end
	
end

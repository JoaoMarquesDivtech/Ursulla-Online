local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setParameter(COMBAT_PARAM_USECHARGES, true)

function onGetFormulaValues(player, skill, attack, factor)
	local min = ((player:getLevel() / 5) + (skill + attack)*0.5  + (PRECISAO(player) * 1.5))
    return -min, -min
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local combat2 = Combat()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GREEN_RINGS)

function onGetFormulaValues(player, skill, attack, factor)
	local min = ((player:getLevel() / 5) + (skill + attack)*0.5  + (PRECISAO(player) * 1.5))*0.1
    return -min, -min
end

combat2:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

function onTargetCreature(player, target)

	for i=1,10 do
		addEvent(function()
			if player:isRemoved() or target:isRemoved() then return false end
			combat2:execute(player, Variant(target:getPosition()))
		end,i*225)
	end
	
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

function onCastSpell(player, variant)


	if not Cooldown(player,"Ladin Poison",30002,23) then return false end

	return combat:execute(player, variant)

end
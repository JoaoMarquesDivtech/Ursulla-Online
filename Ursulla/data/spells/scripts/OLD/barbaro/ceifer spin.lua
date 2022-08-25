local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_USECHARGES, true)
combat:setArea(createCombatArea(AREA_SQUARE1X1))


function onGetFormulaValues(player, skill, attack, factor)
	local min = (player:getLevel() / 5) + (skill + attack)* 0.5  + (FORCA(player) * 2.5)
    return -min, -min
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")


local combat2 = Combat()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, 1)
combat2:setParameter(COMBAT_PARAM_EFFECT, 1)

function onGetFormulaValues(player, skill, attack, factor)
	local min = ((player:getLevel() / 5) + (skill + attack)*0.5   + (FORCA(player) * 2.5))*0.2
    return -min, -min
end

combat2:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")


function onTargetCreature(player, target)

	for i=1,5 do
		addEvent(function()
			if target:isRemoved() or player:isRemoved() then return false end
			combat2:execute(player, Variant(target:getPosition()))
		end,i*500)
	end
	
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")


function onCastSpell(player, variant)

	if not Cooldown(player, "Ceifer Spin", 30001, 19) then return false end

	return combat:execute(player, variant)	
end

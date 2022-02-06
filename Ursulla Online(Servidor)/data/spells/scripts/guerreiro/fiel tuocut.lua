local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_USECHARGES, true)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)

function onGetFormulaValues(player, skill, attack, factor)
	local min = ((player:getLevel() / 5) + (skill + attack)*0.5  + (FORCA(player) * 2.5))
    return -min, -min
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

function onTargetCreature(creature, target)
	return doChallengeCreature(creature, target)
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")


function onCastSpell(player, variant)


	if not Cooldown(player,"Fiel TuoCut",30001,12) then return false end

	local pid = player:getTarget()

	addEvent(function()
		if pid:isRemoved() or player:isRemoved() then return false end
		combat:execute(player,variant)
	end,200)

	return combat:execute(player, variant)

end
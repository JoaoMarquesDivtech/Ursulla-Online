local combat = Combat()
combat:setArea(createCombatArea(AREA_CIRCLE2X2))


function onTargetCreature(creature, target)
	return doChallengeCreature(creature, target)
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

function onCastSpell(creature, variant)
    if not Cooldown(creature,"Guardian Atract",30002,2) then return false end
		
	return combat:execute(creature, variant)
end

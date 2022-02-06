local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setArea(createCombatArea(AREA_CIRCLE2X2))


function onGetFormulaValues(player, level, maglevel)
	local min = (VITALIDADE(player)*1.6) + (INTELIGENCIA(player)*2.6) + (level / 5) + (maglevel*0.3) 
	return -min, -min
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")


function onTargetCreature(player, target)

	local leech = ((VITALIDADE(player)*2.6) +(INTELIGENCIA(player)*1.6) + (player:getLevel() / 5) + (player:getMagicLevel()*0.3))*0.1
	
	target:getPosition():sendMagicEffect(1)
	
	target:getPosition():sendDistanceEffect(player:getPosition(), 41)
	
	player:addHealth(leech)
	
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

function onCastSpell(player, variant)

    if not Cooldown(player,"Blood wave",30001,16) then return false end
		
	return combat:execute(player, variant)
end



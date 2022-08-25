local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HOLYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 40)
combat:setParameter(COMBAT_PARAM_USECHARGES, true)

function onGetFormulaValues(player, skill, attack, factor)
    local forca = player:getStorageValue(50001)
	local min = ((player:getLevel() / 5) + ((skill + attack) * 0.5)  + (forca))*0.4
    return -min, -min
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

function onTargetCreature(player, target)
	return doChallengeCreature(player, target)
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")




function onCastSpell(player, variant)


	if not Cooldown(player,"Templar Blessed",30002,22) then return false end

    for i = 0,5 do 
		addEvent(function()
			local spectators = Game.getSpectators(getCreaturePosition(player),false,false, 1, 1, 1, 1) 
			for j= 1, #spectators do
				if spectators[j]:isRemoved() or player:isRemoved() then return false end
				combat:execute(player, Variant(spectators[j]:getPosition()))
			end
		end,i*900)
	end
	
	  
	end

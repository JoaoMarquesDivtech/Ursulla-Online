
function onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)

	
	
    if (not attacker or not creature) then  
    	return primaryDamage, primaryType, secondaryDamage, secondaryType 
    end

	
    if primaryType == COMBAT_HEALING then
    	return primaryDamage, primaryType, secondaryDamage, secondaryType 
    end
	
	
    if primaryDamage <= (DEFESA(creature)*0.85) then 
		primaryDamage = 0
		creature:say("Block!", TALKTYPE_MONSTER_SAY)
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	

    if  creature:isPlayer() then
        primaryDamage = primaryDamage - (DEFESA(creature)*0.85)
    end


    return primaryDamage, primaryType, secondaryDamage, secondaryType
end
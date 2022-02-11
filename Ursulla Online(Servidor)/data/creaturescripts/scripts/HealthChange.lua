


function onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
 



    if (not attacker or not creature) then  
    	return primaryDamage, primaryType, secondaryDamage, secondaryType 
    end

    if primaryType == COMBAT_HEALING then

    	return primaryDamage, primaryType, secondaryDamage, secondaryType 
    end

    if ((AGILIDADE(creature) * 3) >= math.random (0, 1000) and creature:isPlayer()) then
        primaryDamage = 0
        secondaryDamage = 0
        creature:say("DODGE!", TALKTYPE_MONSTER_SAY)
        creature:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT)
    end

    if (attacker:isPlayer() and (CRITICO(creature) * 3) >= math.random (0, 1000)) then
		primaryDamage = primaryDamage + math.ceil(primaryDamage * CRITICAL.PERCENT)
		attacker:getPosition():sendMagicEffect(173)
	end


    if primaryDamage <= (DEFESA(creature)*0.85) then 
		primaryDamage = 0
        print("Defendi2")
		creature:say("Block!", TALKTYPE_MONSTER_SAY)
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
    if  creature:isPlayer() then
        primaryDamage = primaryDamage - (DEFESA(creature)*0.85)
    end


    return primaryDamage, primaryType, secondaryDamage, secondaryType
end
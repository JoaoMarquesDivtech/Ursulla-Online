--[[
    Dodge & Critical fixado por Movie (Movie#4361)
    Disponibilizado para o TibiaKing e não autorizo outras reproduções
    Mantenha os créditos <3
--]]

function onManaChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    
    if (not attacker or not creature) then  
        return primaryDamage, primaryType, secondaryDamage, secondaryType 
    end
    
    if ((AGILIDADE(creature) * 3) >= math.random (0, 1000) and creature:isPlayer())  then
        primaryDamage = 0
        secondaryDamage = 0
        creature:say("DODGE!", TALKTYPE_MONSTER_SAY)
        creature:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT)
    end
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end
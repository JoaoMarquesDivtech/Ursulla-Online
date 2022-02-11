local storage = {
    {nome = "Habilidades de fogo", storageExperiencia = 3000, storageExperienciaAting = 3010, nivel = 3020, dano = 1, type = COMBAT_FIREDAMAGE},
    {nome = "Habilidades de eletricidade", storageExperiencia = 3001, storageExperienciaAting = 3011,  nivel = 3021, dano = 1, type = COMBAT_ENERGYDAMAGE},
    {nome = "Habilidades fisicas", storageExperiencia = 3002, storageExperienciaAting = 3012,  nivel = 3022, dano = 1, type = COMBAT_PHYSICALDAMAGE},
    {nome = "Pericia com veneno", storageExperiencia = 3003, storageExperienciaAting = 3013,  nivel = 3023, dano = 1, type = COMBAT_EARTHDAMAGE},
    {nome = "Habilidades de gelo", storageExperiencia = 3004, storageExperienciaAting = 3014,  nivel = 3024, dano = 1, type = COMBAT_ICEDAMAGE},
    {nome = "Habilidades Sagradas", storageExperiencia = 3005, storageExperienciaAting = 3015,  nivel = 3025, dano = 1, type = COMBAT_HOLYDAMAGE},
    {nome = "Habilidades Sombrias", storageExperiencia = 3006, storageExperienciaAting = 3016,  nivel = 3026, dano = 1, type = COMBAT_DEATHDAMAGE}
}

local function onMastery(cid ,storage1, storage2, storage3, tipo)
    local experiencia, experiencia1, nivel = cid:getStorageValue(storage1), cid:getStorageValue(storage2), cid:getStorageValue(storage3)
    if(experiencia == -1) then
        cid:setStorageValue(storage1, 0)
    end
    if(experiencia1 == -1) then
        cid:setStorageValue(storage2, 1)
    end
    if(nivel == -1) then
        cid:setStorageValue(storage3, 1)
    end

    cid:setStorageValue(storage1, experiencia + 1)

    local experiencia, experiencia1 = cid:getStorageValue(storage1), cid:getStorageValue(storage2)
    cid:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Experiencia em "..tipo.." ("..experiencia.."/"..experiencia1..")")

    if(experiencia == experiencia1 or experiencia >= experiencia1)  then
        cid:setStorageValue(storage1, 0)
        cid:setStorageValue(storage2, experiencia1 + 150)
        cid:setStorageValue(storage3, nivel + 1)

        cid:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Voc� aumentou de nivel na mastery em "..tipo.." para o nivel:"..nivel..".")
        cid:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voc� aumentou de nivel na mastery em "..tipo.." para o nivel:"..nivel..".")
    end

end


function onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if (attacker and creature) then
        if(attacker:isPlayer()) then
            for i=1,7 do
                if (primaryType == storage[i].type) then 
                    onMastery(attacker, storage[i].storageExperiencia, storage[i].storageExperienciaAting, storage[i].nivel, storage[i].nome) 
                    primaryDamage = primaryDamage + (attacker:getStorageValue(storage[i].nivel) * storage[i].dano) 
                end
            end
        end
    end
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end
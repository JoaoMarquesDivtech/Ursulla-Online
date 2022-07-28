local storage = {
    {nome = "Magias do Fogo", storageExperiencia = 3000, storageExperienciaAting = 3010, nivel = 3020, dano = 0.5, type = COMBAT_FIREDAMAGE},
    {nome = "Magias de Eletricidade", storageExperiencia = 3001, storageExperienciaAting = 3011,  nivel = 3021, dano = 0.4, type = COMBAT_ENERGYDAMAGE},
    {nome = "Habilidades fisicas", storageExperiencia = 3002, storageExperienciaAting = 3012,  nivel = 3022, dano = 0.1, type = COMBAT_PHYSICALDAMAGE},
    {nome = "Magias de Terra", storageExperiencia = 3003, storageExperienciaAting = 3013,  nivel = 3023, dano = 0.2, type = COMBAT_EARTHDAMAGE},
    {nome = "Magias de gelo", storageExperiencia = 3004, storageExperienciaAting = 3014,  nivel = 3024, dano = 0.3, type = COMBAT_ICEDAMAGE},
    {nome = "Habilidades Sagradas", storageExperiencia = 3005, storageExperienciaAting = 3015,  nivel = 3025, dano = 0.2, type = COMBAT_HOLYDAMAGE},
    {nome = "Habilidades Sombrias", storageExperiencia = 3006, storageExperienciaAting = 3016,  nivel = 3026, dano = 0.4, type = COMBAT_DEATHDAMAGE},
    {nome = "Magias do Som", storageExperiencia = 3007, storageExperienciaAting = 3017,  nivel = 3027, dano = 0.3, type = COMBAT_SONGDAMAGE},
    {nome = "Magias de Sangue", storageExperiencia = 3008, storageExperienciaAting = 3018,  nivel = 3028, dano = 0.1, type = COMBAT_BLOODDAMAGE},
    {nome = "Magias de Ar", storageExperiencia = 3009, storageExperienciaAting = 3019,  nivel = 3029, dano = 0.2, type = COMBAT_AIRDAMAGE}
}

local function onMastery(cid ,storage, storage2, storage3, tipo, dano)
    local experiencia, experiencia1, nivel = cid:getStorageValue(storage), cid:getStorageValue(storage2), cid:getStorageValue(storage3)
    if(experiencia == -1) then
        cid:setStorageValue(storage1, 0)
    end
    if(experiencia1 == -1) then
        cid:setStorageValue(storage2, 1)
    end
    if(nivel == -1) then
        cid:setStorageValue(storage3, 1)
    end

    dano = dano*-1
    dano = math.floor( dano/100>=5 and 5 or dano/100)
    dano = math.floor( dano == 0 and 1 or dano)

    cid:setStorageValue(storage, experiencia + dano)
    local experiencia, experiencia1 = cid:getStorageValue(storage), cid:getStorageValue(storage2)
    cid:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Experiencia em "..tipo.." ("..experiencia.."/"..experiencia1..")")

    
    if(experiencia == experiencia1 or experiencia >= experiencia1)  then
        cid:setStorageValue(storage, 0)
        cid:setStorageValue(storage2, experiencia1 + 150)
        cid:setStorageValue(storage3, nivel + 1)

        cid:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Voc� aumentou de nivel na mastery em "..tipo.." para o nivel:"..nivel..".")
        cid:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voc� aumentou de nivel na mastery em "..tipo.." para o nivel:"..nivel..".")
    end

end


function onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if (attacker and creature) then
        if(attacker:isPlayer()) then
            for i=1,10 do
                if (primaryType == storage[i].type) then 
                    onMastery(attacker, storage[i].storageExperiencia, storage[i].storageExperienciaAting, storage[i].nivel, storage[i].nome, primaryDamage) 
                    print(primaryDamage)
                    primaryDamage = primaryDamage + (attacker:getStorageValue(storage[i].nivel) * storage[i].dano)*-1 
                    print(primaryDamage)
                end
            end
        end
    end
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end
function VITALIDADE(self)
	if self:isMonster() then return 0 end
	return self:getStorageValue(49998) + self:getStorageValue(50008)
end

function SABEDORIA(self)
	if self:isMonster() then return 0 end
	return self:getStorageValue(49999) + self:getStorageValue(50009)
end

function INTELIGENCIA(self)
	if self:isMonster() then return 0 end
	return self:getStorageValue(50000) + self:getStorageValue(50010)
end

function FORCA(self)
	if self:isMonster() then return 0 end
	return self:getStorageValue(50001) + self:getStorageValue(50011)
end

function DESTREZA(self)
	if self:isMonster() then return 0 end
	return self:getStorageValue(50002) + self:getStorageValue(50012)
end

function PRECISAO(self)
	if self:isMonster() then return 0 end
	return self:getStorageValue(50003) + self:getStorageValue(50013)
end

function CRITICO(self)
	if self:isMonster() then return 0 end
	return self:getStorageValue(48901) + self:getStorageValue(48911)
end

function PERICIA(self)
	if self:isMonster() then return 0 end
	return self:getStorageValue(50004) + self:getStorageValue(50014)
end

function VELOCIDADE(self)
	if self:isMonster() then return 0 end
	return self:getStorageValue(50005) + self:getStorageValue(50015)
end

function AGILIDADE(self)
	if self:isMonster() then return 0 end
	return self:getStorageValue(48900) + self:getStorageValue(48910) 
end

function DEFESA(self)
	if self:isMonster() then return 0 end
	return self:getStorageValue(50006) + self:getStorageValue(50016) + self:getStorageValue(23000)
end




local storage = {
    {id = "FireSkill", nome = "Magias do Fogo", storageExperiencia = 3000, storageExperienciaAting = 3010, nivel = 3020, dano = 1, type = COMBAT_FIREDAMAGE},
    {id = "EnergySkill",nome = "Magias de Eletricidade", storageExperiencia = 3001, storageExperienciaAting = 3011,  nivel = 3021, dano = 1, type = COMBAT_ENERGYDAMAGE},
    {id = "PhysicalSkill",nome = "Habilidades fisicas", storageExperiencia = 3002, storageExperienciaAting = 3012,  nivel = 3022, dano = 1, type = COMBAT_PHYSICALDAMAGE},
    {id = "EarthSkill",nome = "Magias de Terra", storageExperiencia = 3003, storageExperienciaAting = 3013,  nivel = 3023, dano = 1, type = COMBAT_EARTHDAMAGE},
    {id = "IceSkill",nome = "Magias de gelo", storageExperiencia = 3004, storageExperienciaAting = 3014,  nivel = 3024, dano = 1, type = COMBAT_ICEDAMAGE},
    {id = "HolySkill",nome = "Habilidades Sagradas", storageExperiencia = 3005, storageExperienciaAting = 3015,  nivel = 3025, dano = 1, type = COMBAT_HOLYDAMAGE},
    {id = "DeathSkill",nome = "Habilidades Sombrias", storageExperiencia = 3006, storageExperienciaAting = 3016,  nivel = 3026, dano = 1, type = COMBAT_DEATHDAMAGE},
    {id = "SongSkill",nome = "Magias do Som", storageExperiencia = 3007, storageExperienciaAting = 3017,  nivel = 3027, dano = 1, type = COMBAT_SONGDAMAGE},
    {id = "BloodSkill",nome = "Magias de Sangue", storageExperiencia = 3008, storageExperienciaAting = 3018,  nivel = 3028, dano = 1, type = COMBAT_BLOODDAMAGE},
    {id = "AirSkill",nome = "Magias de Ar", storageExperiencia = 3009, storageExperienciaAting = 3019,  nivel = 3029, dano = 1, type = COMBAT_AIRDAMAGE}
}

function getSkillLevel(player, magia)	
	for i = 1,10 do
		if(storage[i].id == magia) then

			local level = player:getStorageValue(storage[i].nivel)
			if level == -1 then
				player:setStorageValue(storage[i].nivel, 0)
			end

			return level

		end
	end
end

function getSkillPercent(player, magia)

	for i = 1,10 do
		if(storage[i].id == magia) then
			local experiencia, experienciaating =  player:getStorageValue(storage[i].storageExperiencia), player:getStorageValue(storage[i].storageExperienciaAting)
			

			if (experiencia <= -1 or experiencia == nil) or (experienciaating <= 0 or experienciaating == nil) then
				player:setStorageValue(storage[i].storageExperiencia, 0)
				player:setStorageValue(storage[i].storageExperienciaAting, 10)
			end
			local Porcetagem
			if(experiencia ~= 0) then
				Porcetagem = (experiencia)*100/experienciaating
			else
				Porcetagem = 0
			end
			
			return Porcetagem
		end
	end
end
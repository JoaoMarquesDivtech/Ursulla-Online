local OPCODE = 200




local attributes = {
	["stamina"] = {neededPoints = 1, increaseBy = 5, storage = 49998},
	["wisdom"] = {neededPoints = 1, increaseBy = 5, storage = 49999},
	["intelligence"] = {neededPoints = 1, increaseBy = 1, storage = 50000},
	["strength"] = {neededPoints = 1, increaseBy = 1, storage = 50001},
	["dexterity"] = {neededPoints = 1, increaseBy = 1, storage = 50002},
	["precision"] = {neededPoints = 1, increaseBy = 1, criticalIncreaseBy = 1, storage = 50003},
	["expertise"] = {neededPoints = 1, increaseBy = 1, storage = 50004},
	["speed"] = {neededPoints = 1, increaseBy = 1, storage = 50005},
	["agility"] = {neededPoints = 1, increaseBy = 1, storage = 48900},
	["defense"] = {neededPoints = 1, increaseBy = 1, storage = 50006},
}

local pointsStorage = 45200
local sucessEffect = 15
local failEffect = 3

function refresh(player)
	local staminaValue = tostring(player:getStorageValue(attributes.stamina.storage))
	local wisdomValue = tostring(player:getStorageValue(attributes.wisdom.storage))
	local intelligenceValue = tostring(player:getStorageValue(attributes.intelligence.storage))
	local strengthValue = tostring(player:getStorageValue(attributes.strength.storage))
	local dexterityValue = tostring(player:getStorageValue(attributes.dexterity.storage))
	local precisionValue = tostring(player:getStorageValue(attributes.precision.storage))
	local expertiseValue = tostring(player:getStorageValue(attributes.expertise.storage))
	local speedValue = tostring(player:getStorageValue(attributes.speed.storage))
	local agilityValue = tostring(player:getStorageValue(attributes.agility.storage))
	local defenseValue = tostring(player:getStorageValue(attributes.defense.storage))
	local pointsValue = tostring(player:getStorageValue(pointsStorage))
	local FireSkill = tostring(getSkillLevel(player,"FireSkill"))
	local EarthSkill = tostring(getSkillLevel(player,"EarthSkill"))
	local IceSkill = tostring(getSkillLevel(player,"IceSkill"))
	local DeathSkill = tostring(getSkillLevel(player,"DeathSkill"))
	local EnergySkill = tostring(getSkillLevel(player,"EnergySkill"))
	local AirSkill = tostring(getSkillLevel(player,"AirSkill"))
	local BloodSkill = tostring(getSkillLevel(player,"BloodSkill"))
	local SongSkill = tostring(getSkillLevel(player,"SongSkill"))
	local HolySkill = tostring(getSkillLevel(player,"HolySkill"))
	local FireSkillPercent = tostring(getSkillPercent(player,"FireSkill"))
	local EarthSkillPercent = tostring(getSkillPercent(player,"EarthSkill"))
	local IceSkillPercent = tostring(getSkillPercent(player,"IceSkill"))
	local DeathSkillPercent = tostring(getSkillPercent(player,"DeathSkill"))
	local EnergySkillPercent = tostring(getSkillPercent(player,"EnergySkill"))
	local AirSkillPercent = tostring(getSkillPercent(player,"AirSkill"))
	local BloodSkillPercent = tostring(getSkillPercent(player,"BloodSkill"))
	local SongSkillPercent = tostring(getSkillPercent(player,"SongSkill"))
	local HolySkillPercent = tostring(getSkillPercent(player,"HolySkill"))



	local data = "refresh,"..pointsValue..","..staminaValue..","..wisdomValue..","..intelligenceValue..","..strengthValue..","..dexterityValue..","..precisionValue..","..expertiseValue..","..speedValue ..","..agilityValue ..","..defenseValue..","..FireSkill..","..IceSkill..","..EarthSkill..","..DeathSkill..","..EnergySkill..","..AirSkill..","..BloodSkill..","..SongSkill..","..HolySkill	..","..FireSkillPercent..","..IceSkillPercent..","..EarthSkillPercent..","..DeathSkillPercent..","..EnergySkillPercent..","..AirSkillPercent..","..BloodSkillPercent..","..SongSkillPercent..","..HolySkillPercent
	sendBuffer(player, data)
end



local function att(player, atr)
	local var = 0
	if player:getStorageValue(atr) >= 100 then  var = 6
		elseif player:getStorageValue(atr) >= 90 then  var = 5 
		elseif player:getStorageValue(atr) >= 80 then  var = 4 
		elseif player:getStorageValue(atr) >= 70 then  var = 3 
		elseif player:getStorageValue(atr) >= 60 then var = 2 
		elseif player:getStorageValue(atr) < 60 then  var = 1
	end
return var
end

function addStamina(player)
	local currentPoints = player:getStorageValue(pointsStorage)	
	if currentPoints >= att(player, attributes.stamina.storage) then
		player:setMaxHealth(player:getMaxHealth() + attributes.stamina.increaseBy)
		player:addHealth(attributes.stamina.increaseBy)
		player:setStorageValue(attributes.stamina.storage, player:getStorageValue(attributes.stamina.storage) + 1)
		player:setStorageValue(pointsStorage, currentPoints - att(player, attributes.stamina.storage))
		player:getPosition():sendMagicEffect(sucessEffect)
	else
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Voc� precisa de "..att(player, attributes.stamina.storage).." pontos para distribuir!")
	end
end

function addWisdom(player)
	local currentPoints = player:getStorageValue(pointsStorage)
	if currentPoints >= att(player, attributes.wisdom.storage) then
		player:setMaxMana(player:getMaxMana() + attributes.wisdom.increaseBy)
		player:addMana(attributes.wisdom.increaseBy)
		player:setStorageValue(attributes.wisdom.storage, player:getStorageValue(attributes.wisdom.storage) + 1)
		player:setStorageValue(pointsStorage, currentPoints - att(player, attributes.wisdom.storage))
		player:getPosition():sendMagicEffect(sucessEffect)
	else
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Voc� precisa de "..att(player, attributes.wisdom.storage).." pontos para distribuir!")
	end
end

function addIntelligence(player)
	local currentPoints = player:getStorageValue(pointsStorage)
	if currentPoints >= att(player, attributes.intelligence.storage) then
		player:setStorageValue(attributes.intelligence.storage, player:getStorageValue(attributes.intelligence.storage) + attributes.intelligence.increaseBy)
		player:setStorageValue(pointsStorage, currentPoints - att(player, attributes.intelligence.storage))
		player:getPosition():sendMagicEffect(sucessEffect)
	else
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Voc� precisa de "..att(player, attributes.intelligence.storage).." pontos para distribuir!")	
	end
end

function addStrength(player, atr)
	local currentPoints = player:getStorageValue(pointsStorage)
	if currentPoints >= att(player, attributes.strength.storage) then
		player:setStorageValue(attributes.strength.storage, player:getStorageValue(attributes.strength.storage) + attributes.strength.increaseBy)
		player:setStorageValue(pointsStorage, currentPoints - attributes.strength.neededPoints)
		player:getPosition():sendMagicEffect(sucessEffect)
	else
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Voc� precisa de "..att(player, attributes.strength.storage).." pontos para distribuir!")	
	end
end

function addDexterity(player, atr)
	local currentPoints = player:getStorageValue(pointsStorage)	
	if currentPoints >= att(player, attributes.dexterity.storage) then
		player:setStorageValue(attributes.dexterity.storage, player:getStorageValue(attributes.dexterity.storage) + attributes.dexterity.increaseBy)
		player:setStorageValue(pointsStorage, currentPoints - att(player, attributes.dexterity.storage))
		player:getPosition():sendMagicEffect(sucessEffect)
	else
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Voc� precisa de "..att(player, attributes.dexterity.storage).." pontos para distribuir!")	
	end
end

function addPrecision(player, atr)
	local currentPoints = player:getStorageValue(pointsStorage)
	if currentPoints >= attributes.precision.neededPoints then
		player:setStorageValue(attributes.precision.storage, player:getStorageValue(attributes.precision.storage) + attributes.precision.increaseBy)
		player:setStorageValue(48901, player:getStorageValue(48901) + attributes.precision.increaseBy)
		player:setStorageValue(pointsStorage, currentPoints - att(player, attributes.precision.storage))
		player:getPosition():sendMagicEffect(sucessEffect)
	else
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Voc� precisa de "..att(player, attributes.precision.storage).." pontos para distribuir!")
	end
end

function addExpertise(player, atr)
	local currentPoints = player:getStorageValue(pointsStorage)
	if currentPoints >= attributes.expertise.neededPoints then
		player:setStorageValue(attributes.expertise.storage, player:getStorageValue(attributes.expertise.storage) + attributes.expertise.increaseBy)
		player:setStorageValue(pointsStorage, currentPoints - att(player, attributes.expertise.storage))
		player:getPosition():sendMagicEffect(sucessEffect)
	else
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Voc� precisa de "..att(player, attributes.expertise.storage).." pontos para distribuir!")
	end
end

function addSpeed(player, atr)
	local currentPoints = player:getStorageValue(pointsStorage)	
	if currentPoints >= att(player, attributes.speed.storage) then
		player:changeSpeed(4)
		player:setStorageValue(attributes.speed.storage, player:getStorageValue(attributes.speed.storage) + attributes.speed.increaseBy)
		player:setStorageValue(pointsStorage, currentPoints - att(player, attributes.speed.storage))
		player:getPosition():sendMagicEffect(sucessEffect)
	else
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Voc� precisa de "..att(player, attributes.speed.storage).." pontos para distribuir!")
	end
end

function addAgility(player, atr)
	local currentPoints = player:getStorageValue(pointsStorage)
	if currentPoints >= att(player, attributes.agility.storage) then
		player:setStorageValue(attributes.agility.storage, player:getStorageValue(attributes.agility.storage) + attributes.agility.increaseBy)
		player:setStorageValue(pointsStorage, currentPoints - att(player, attributes.agility.storage))
		player:getPosition():sendMagicEffect(sucessEffect)
	else
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Voc� precisa de "..att(player, attributes.agility.storage).." pontos para distribuir!")
	end
end

function addDefense(player, atr)
	local currentPoints = player:getStorageValue(pointsStorage)
	if currentPoints >= att(player, attributes.defense.storage) then
		player:setStorageValue(attributes.defense.storage, player:getStorageValue(attributes.defense.storage) + attributes.defense.increaseBy)
		player:setStorageValue(pointsStorage, currentPoints - att(player, attributes.defense.storage))
		player:getPosition():sendMagicEffect(sucessEffect)
	else
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Voc� precisa de "..att(player, attributes.defense.storage).." pontos para distribuir!")
	end
end

function onExtendedOpcode(player, opcode, buffer)
	if opcode == OPCODE then
		local data = stringSplit(buffer, ",")

		if data[1] == "refresh" then
			refresh(player)
		elseif data[1] == "addStamina" then
			addStamina(player)
			refresh(player)
		elseif data[1] == "addWisdom" then
			addWisdom(player)
			refresh(player)
		elseif data[1] == "addIntelligence" then
			addIntelligence(player)
			refresh(player)
		elseif data[1] == "addStrength" then
			addStrength(player)
			refresh(player)
		elseif data[1] == "addDexterity" then
			addDexterity(player)
			refresh(player)
		elseif data[1] == "addPrecision" then
			addPrecision(player)
			refresh(player)
		elseif data[1] == "addExpertise" then
			addExpertise(player)
			refresh(player)
		elseif data[1] == "addSpeed" then
			addSpeed(player)
			refresh(player)
		elseif data[1] == "addAgility" then
			addAgility(player)
			refresh(player)
		elseif data[1] == "addDefense" then
			addDefense(player)
			refresh(player)
		end
	end
end

function sendBuffer(player, buffer)
	player.sendExtendedOpcode(player, OPCODE, buffer)
end

function stringSplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end


function onAdvance(player, skill, oldlevel, newlevel)
    local cid = player:getId()
        if (skill == SKILL_LEVEL) then
        if (getPlayerStorageValue(cid, 45199) < newlevel) then
            if (getPlayerStorageValue(cid, 45200) < 0) then
                    setPlayerStorageValue(cid, 45200, 0)
                setPlayerStorageValue(cid, 45199, 0)
            end
 
            setPlayerStorageValue(cid, 45199, newlevel)
            setPlayerStorageValue(cid, 45200, getPlayerStorageValue(cid, 45200) + (newlevel - oldlevel) * 1)
			player:say("+ Pontos de habilidade", TALKTYPE_MONSTER_SAY)
        end
        end
 
  return true
end
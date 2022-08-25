local events = {
    'ElementalSpheresOverlords',
    'BigfootBurdenVersperoth',
    'Razzagorn',
    'Shatterer',
    'Zamulosh',	
	'The Hunger',
	'The Rage',
	'Eradicator',
	'Eradicator1',
	'Rupture',
	'World Devourer',	
    'Tarbaz',
    'Shulgrax',
    'Ragiaz',
    'Plagirath',
    'Mazoran',
    'Destabilized',
    'BigfootBurdenWiggler',
    'SvargrondArenaKill',
    'NewFrontierShardOfCorruption',
    'NewFrontierTirecz',
    'ServiceOfYalaharDiseasedTrio',
    'ServiceOfYalaharAzerus',
    'ServiceOfYalaharQuaraLeaders',
    'InquisitionBosses',
    'InquisitionUngreez',
    'KillingInTheNameOfKills',
	'KillingInTheNameOfKillss',
	'KillingInTheNameOfKillsss',
    'MastersVoiceServants',
    'SecretServiceBlackKnight',
    'ThievesGuildNomad',
    'WotELizardMagistratus',
    'WotELizardNoble',
    'WotEKeeper',
    'WotEBosses',
    'WotEZalamon',
    'WarzoneThree',
    'PlayerDeath',
    'AdvanceSave',
    'bossesWarzone',
    'AdvanceRookgaard',
    'PythiusTheRotten',
    'DropLoot',
    'Yielothax',
    'BossParticipation',
    'Energized Raging Mage',
    'Raging Mage', 
    'modalMD1',
	'VibrantEgg',
    'DeathCounter',
    'KillCounter',
    'bless1'
 
}
 
local function onMovementRemoveProtection(cid, oldPosition, time)
    local player = Player(cid)
    if not player then
        return true
    end
 
    local playerPosition = player:getPosition()
    if (playerPosition.x ~= oldPosition.x or playerPosition.y ~= oldPosition.y or playerPosition.z ~= oldPosition.z) or player:getTarget() then
        player:setStorageValue(Storage.combatProtectionStorage, 0)
        return true
    end
 
    addEvent(onMovementRemoveProtection, 1000, cid, oldPosition, time - 1) 
end
 
function onLogin(player)

	
	local loginStr = 'Welcome to ' .. configManager.getString(configKeys.SERVER_NAME) .. '!'
	if player:getLastLoginSaved() <= 0 then
		loginStr = loginStr .. ' Por favor, Escolha sua roupa.'
		player:sendTutorial(1)
	else
		if loginStr ~= '' then
			player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)
		end

		loginStr = string.format('Your last visit was on %s.', os.date('%a %b %d %X %Y', player:getLastLoginSaved()))
	end
 
    player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)
   
    local playerId = player:getId()
 
    -- Stamina
    nextUseStaminaTime[playerId] = 1
 
    -- STAMINA DEVIDO A QUEDAS START
   
    --local stamina_full = 42 * 60 -- config. 42 = horas
   -- if player:getStamina() >= stamina_full then
      --  player:sendCancelMessage("Your stamina is already full.")
   -- elseif player:getPremiumDays() < 1 then
     --   player:sendCancelMessage("You must have a premium account.")
   -- else
      --  player:setStamina(stamina_full)
     -- player:sendTextMessage(MESSAGE_INFO_DESCR, "Your stamina has been refilled.")      
   -- end
   
    -- STAMINA DEVIDO A QUEDAS END
   
    -- Promotion
   --[[ local vocation = player:getVocation()
    local promotion = vocation:getPromotion()
    if player:isPremium() then
        local value = player:getStorageValue(Storage.Promotion)
        if not promotion and value ~= 1 then
            player:setStorageValue(Storage.Promotion, 1)
        elseif value == 1 then
            player:setVocation(promotion)
        end
    elseif not promotion then
        player:setVocation(vocation:getDemotion())
    end--]]
   --   Primeiro Login
   --   Sistemas
   if player:getStorageValue(80000)==-1 then 
   doCreatureSay(player, "Onde estou? Devo falar com esta chama! (Diga oi para ela!)", TALKTYPE_ORANGE_1)
   player:setStorageValue(80000,0) 
   end 
   
   player:setStorageValue(23000,0)
	
   --miss
   if player:getStorageValue(79000)==0 then 
   player:setStorageValue(79000,-1) 
   end 
   
   
   if player:getStorageValue(45200)<0 then player:setStorageValue(45200,0) end 
   if player:getStorageValue(48900)<0 then player:setStorageValue(48900,0) end 
   if player:getStorageValue(48901)<0 then player:setStorageValue(48901,0) end 
   for i = 49998,50006 do
		if (player:getStorageValue(i)<0) then 
			player:setStorageValue(i,0) 
		end
   end
   for i = 50008,50016 do
		if (player:getStorageValue(i)<0) then 
			player:setStorageValue(i,0) 
		end
   end   
   player:changeSpeed(4*player:getStorageValue(50005))
   setPlayerStorageValue(cid, 29997,0)--Barbarian
     -- ABRIR CHANNELS
    player:openChannel(7)   -- help channel
    player:openChannel(3)   -- world chat 

    -- Rewards
    local rewards = #player:getRewardList()
    if(rewards > 0) then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have %d %s in your reward chest.", rewards, rewards > 1 and "rewards" or "reward"))
    end
 
    -- Update player id
    local stats = player:inBossFight()
    if stats then
        stats.playerId = player:getId()
    end
     
   
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, 'Bem vindo ao mundo de MMORPG-Ursulla Online!!')
	



	
	if player:getStorageValue(50006) == -1 then
	player:setStorageValue(50006, 0)
	end
	
    --Geral
	player:registerEvent("HealthChange")
	player:registerEvent("Mastery")
    player:registerEvent("DodgeMana")
    player:registerEvent("IconMap")		
    player:registerEvent("Combat")
    player:registerEvent("Attributes")	
    player:registerEvent("SkillPointSystem")
	player:registerEvent("ClientVersion")	
    player:registerEvent("GameSpells")	
	
    -- Events
    for i = 1, #events do
        player:registerEvent(events[i])
    end
    

 
    if player:getStorageValue(Storage.combatProtectionStorage) <= os.time() then
        player:setStorageValue(Storage.combatProtectionStorage, os.time() + 10)
        onMovementRemoveProtection(playerId, player:getPosition(), 10)
    end
	
	if player:getDodgeLevel() == -1 then
	player:setDodgeLevel(0)
    end
    if player:getCriticalLevel() == -1 then
	player:setCriticalLevel(0)
    end


	
    return true
end
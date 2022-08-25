function Player.allowMovement(self, allow)
	return self:setStorageValue(STORAGE.blockMovementStorage, allow and -1 or 1)
end


function Player.setExhaustion(self, value, time)
    return self:setStorageValue(value, time + os.time())
end

function Player.getExhaustion(self, value)
    local storage = self:getStorageValue(value)
    if storage < 0 then
       return 0
    end
   return storage - os.time()
end

function Player.checkExhaustion(self, value)
    local storage = self:getStorageValue(value)
    if storage >= 1 then
       return true  
	elseif storage <=0 then
	return false   
    end
  
end

function Player.depositMoney(self, amount)
	if not self:removeMoney(amount) then
		return false
	end

	self:setBankBalance(self:getBankBalance() + amount)
	return true
end

local foodCondition = Condition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)

function Player.feed(self, food)
	local condition = self:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)
	if condition then
		condition:setTicks(condition:getTicks() + (food * 1000))
	else
		local vocation = self:getVocation()
		if not vocation then
			return nil
		end

		foodCondition:setTicks(food * 1000)
		foodCondition:setParameter(CONDITION_PARAM_HEALTHGAIN, vocation:getHealthGainAmount())
		foodCondition:setParameter(CONDITION_PARAM_HEALTHTICKS, vocation:getHealthGainTicks() * 1000)
		foodCondition:setParameter(CONDITION_PARAM_MANAGAIN, vocation:getManaGainAmount())
		foodCondition:setParameter(CONDITION_PARAM_MANATICKS, vocation:getManaGainTicks() * 1000)

		self:addCondition(foodCondition)
	end
	return true
end

function Player.getBlessings(self)
	local blessings = 0
	for i = 1, 5 do
		if self:hasBlessing(i) then
			blessings = blessings + 1
		end
	end
	return blessings
end

function Player.getClosestFreePosition(self, position, extended)
	if self:getAccountType() >= ACCOUNT_TYPE_GOD then
		return position
	end
	return Creature.getClosestFreePosition(self, position, extended)
end

function Player.getCookiesDelivered(self)
	local storage, amount = {
		STORAGE.WHATAFOOLISHQUEST.COOKIEDELIVERY.SIMONTHEBEGGAR, STORAGE.WHATAFOOLISHQUEST.COOKIEDELIVERY.MARKWIN, STORAGE.WHATAFOOLISHQUEST.COOKIEDELIVERY.ARIELLA,
		STORAGE.WHATAFOOLISHQUEST.COOKIEDELIVERY.HAIRYCLES, STORAGE.WHATAFOOLISHQUEST.COOKIEDELIVERY.DJINN, STORAGE.WHATAFOOLISHQUEST.COOKIEDELIVERY.AVARTAR,
		STORAGE.WHATAFOOLISHQUEST.COOKIEDELIVERY.ORCKING, STORAGE.WHATAFOOLISHQUEST.COOKIEDELIVERY.LORBAS, STORAGE.WHATAFOOLISHQUEST.COOKIEDELIVERY.WYDA,
		STORAGE.WHATAFOOLISHQUEST.COOKIEDELIVERY.HJAERN
	}, 0
	for i = 1, #storage do
		if self:getStorageValue(storage[i]) == 1 then
			amount = amount + 1
		end
	end
	return amount
end

function Player.getDepotItems(self, depotId)
	return self:getDepotChest(depotId, true):getItemHoldingCount()
end

function Player.getLossPercent(self)
	local lossPercent = {
		[0] = 100,
		[1] = 70,
		[2] = 45,
		[3] = 25,
		[4] = 10,
		[5] = 0
	}

	return lossPercent[self:getBlessings()]
end

function Player.hasAllowMovement(self)
	return self:getStorageValue(STORAGE.blockMovementStorage) ~= 1
end


function Player.isPremium(self)
	return self:getPremiumDays() > 0 or configManager.getBoolean(configKeys.FREE_PREMIUM)
end

function Player.isUsingOtClient(self)
	return self:getClient().os >= CLIENTOS_OTCLIENT_LINUX
end

function Player.sendCancelMessage(self, message)
	if type(message) == "number" then
		message = Game.getReturnMessage(message)
	end
	return self:sendTextMessage(MESSAGE_STATUS_SMALL, message)
end

function Player.sendExtendedOpcode(self, opcode, buffer)
	if not self:isUsingOtClient() then
		return false
	end

	local networkMessage = NetworkMessage()
 	networkMessage:addByte(0x32)
 	networkMessage:addByte(opcode)
 	networkMessage:addString(buffer)
	networkMessage:sendToPlayer(self, false) 
 	networkMessage:delete()
	return true
end

function Player.transferMoneyTo(self, target, amount)
	local balance = self:getBankBalance()
	if amount > balance then
		return false
	end

	local targetPlayer = Player(target)
	if targetPlayer then
		targetPlayer:setBankBalance(targetPlayer:getBankBalance() + amount)
	else
		if not playerExists(target) then
			return false
		end
		db.query("UPDATE `players` SET `balance` = `balance` + '" .. amount .. "' WHERE `name` = " .. db.escapeString(target))
	end

	self:setBankBalance(self:getBankBalance() - amount)
	return true
end

function Player.withdrawMoney(self, amount)
	local balance = self:getBankBalance()
	if amount > balance or not self:addMoney(amount) then
		return false
	end

	self:setBankBalance(balance - amount)
	return true
end

APPLY_SKILL_MULTIPLIER = true
local addSkillTriesFunc = Player.addSkillTries
function Player.addSkillTries(...)
	APPLY_SKILL_MULTIPLIER = false
	local ret = addSkillTriesFunc(...)
	APPLY_SKILL_MULTIPLIER = true
	return ret
end

local addManaSpentFunc = Player.addManaSpent
function Player.addManaSpent(...)
	APPLY_SKILL_MULTIPLIER = false
	local ret = addManaSpentFunc(...)
	APPLY_SKILL_MULTIPLIER = true
	return ret
end




function CooldownS(self,seconds)

    local storage = 60997

	if (Player.getExhaustion(self,storage)>0) then
        doPlayerSendCancel(self, "Você esta cheio, espere " .. Player.getExhaustion(self,storage) .. " segundos para comer!")
		return false
	else
		Player.setExhaustion(self, storage, seconds)
		return true
	end
end


function Cooldown(self,spell,storage,waittime)
--miss!
	if self:getStorageValue(79000)==0 then
		if math.random(0,100)>=50 then
			self:say("Errou!", TALKTYPE_MONSTER_SAY)
			return false
		end
	end
--miss!

	local seconds = waittime-waittime*(self:getStorageValue(50004)*(0.0005))
	if (Player.getExhaustion(self,storage)>0) then
		doPlayerSendCancel(self, ""..spell..":[" .. Player.getExhaustion(self,storage) .. "]")
		return false
	else
		Player.setExhaustion(self, storage, seconds)
		return true
	end
	
end


function reset(creature)
	local player = Player(creature)
	local j, classe, nivel = 0, player:getVocation(), player:getLevel()

	player:setMaxHealth(nivel* classe:getHealthGain() + 100)
	player:setMaxMana(nivel*classe:getManaGain())
	player:addHealth(nivel* classe:getHealthGain() + 100)
	player:addMana(nivel* classe:getManaGain())
	
	player:changeSpeed(cid, -4* player:getStorageValue(50005))
	
	for i= 49998, 50006 do
		j = j + player:getStorageValue(i)
		player:setStorageValue(i, 0)
	end
	j = j + player:getStorageValue(48900)
	Player.setDodgeLevel(player, 0)
	Player.setCriticalLevel(player, 0)


	player:setStorageValue(45200, j + player:getStorageValue(45200))
end



function createCondition(typeC, rounds, interval, attr, combat)
	local condition = Condition(typeC)
	condition:setParameter(CONDITION_PARAM_SUBID, Gstorage)
	condition:addDamage(rounds, interval, (attr))
	setCombatCondition(combat, condition)
end

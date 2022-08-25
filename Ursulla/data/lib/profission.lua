STORAGEVALUE_MINER = 13000


-- Minerador--

function setMiner(self)
    return self:setStorageValue(STORAGEVALUE_MINER, 0)  
end

function isMiner(self)
    if self:getStorageValue(STORAGEVALUE_MINER) == 0 then
		return true
	else
		return false
	end
end

function getMinerLevel(self)

	if self:getStorageValue(STORAGEVALUE_MINER + 1) == -1 then
		setMinerLevel(self, 0)
	end	

	return self:getStorageValue(STORAGEVALUE_MINER + 1)
end

function setMinerLevel(self, value)
	self:setStorageValue(STORAGEVALUE_MINER + 1, value)
end

function getMinerExp(self)
	return self:getStorageValue(STORAGEVALUE_MINER + 2)
end

function setMinerExp(self, value)
	self:setStorageValue(STORAGEVALUE_MINER + 2, value)
end

function getMinerTargetExp(self)

	if self:getStorageValue(STORAGEVALUE_MINER + 3) == -1 then
		setMinerTargetExp(self, 400)
	end	
	
	return self:getStorageValue(STORAGEVALUE_MINER + 3)
end

function setMinerTargetExp(self, value)
	self:setStorageValue(STORAGEVALUE_MINER + 3, value)
end

local minerios = {
[1] = {1294, 2230, 3976},
[3] = {26544},
[10] = {26545},
[20] = {26546},
[30] = {26547}
}

local getItems = {}

function onMiner(self, item, fromPosition, target, toPosition, isHotkey)
	
	
	if not (target:getId() >= 26527 and target:getId() <= 26543) then
		return true
	end
	
	local thisId, thisExp = target:getId(), 3
	
	
	
	if math.random(0,100) >= 35 then
		target:transform(math.random(3610,3614))
		target:getPosition():sendMagicEffect(3)

		addEvent(function()
			target:getPosition():sendMagicEffect(3)
			target:transform(thisId)	
		end, math.random(30000, 140000))
	end
	
	if math.random(0,100) <= 1 then
		self:getPosition():sendMagicEffect(3)
	    self:sendTextMessage(MESSAGE_STATUS_DEFAULT, "Sua picareta quebrou!")		
		item:remove()
	end
	
	for i,v in ipairs (minerios) do
		if getMinerLevel(self) >= i then
			for x,z in ipairs(minerios[i]) do
				table.insert(getItems, z)
			end
		end
	end
	
	if math.random(0,100)>=20 then
		self:addItem(getItems[math.random(1, #getItems)])
		target:getPosition():sendMagicEffect(4)
	else
		return target:getPosition():sendMagicEffect(3)
	end
	
	
	if not isMiner(self) then
		if getMinerLevel(self) <= 5 then
			setMinerExp(self, getMinerExp(self) + thisExp)
		end
	else 
		setMinerExp(self, getMinerExp(self) + thisExp)
	end

	self:sendTextMessage(MESSAGE_STATUS_DEFAULT, "Exp de mineração: ("..getMinerExp(self).."/"..getMinerTargetExp(self)..") do nivel: ("..getMinerLevel(self)..")")
	
	if getMinerExp(self) >= getMinerTargetExp(self) then
		setMinerExp(self, 0)	
		setMinerLevel(self, getMinerLevel(self) + 1)
		setMinerTargetExp(self, getMinerTargetExp(self) + 500)
        self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce avançou do nivel de mineração de "..(getMinerLevel(self) - 1).." para "..getMinerLevel(self).."!")		
	end	
	
	return true
	
end


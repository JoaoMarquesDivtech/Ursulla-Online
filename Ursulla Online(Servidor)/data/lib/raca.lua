STORAGEVALUE_HUMAN = 72000
STORAGEVALUE_ELF = 72001



function isHuman(self)
    if self:getStorageValue(STORAGEVALUE_HUMAN) == 0 then
	return true
	else
	return false
	end
end

function isElf(self)
    if self:getStorageValue(STORAGEVALUE_ELF) == 0 then
	return true
	else
	return false
	end
end


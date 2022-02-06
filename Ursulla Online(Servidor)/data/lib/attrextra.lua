function VITALIDADE(self)
	return self:getStorageValue(49998) + self:getStorageValue(50008)
end

function SABEDORIA(self)
	return self:getStorageValue(49999) + self:getStorageValue(50009)
end

function INTELIGENCIA(self)
	return self:getStorageValue(50000) + self:getStorageValue(50010)
end

function FORCA(self)
	return self:getStorageValue(50001) + self:getStorageValue(50011)
end

function DESTREZA(self)
	return self:getStorageValue(50002) + self:getStorageValue(50012)
end

function PRECISAO(self)
	return self:getStorageValue(50003) + self:getStorageValue(50013)
end

function CRITICO(self)
	return self:getStorageValue(48901) + self:getStorageValue(48911)
end

function PERICIA(self)
	return self:getStorageValue(50004) + self:getStorageValue(50014)
end

function VELOCIDADE(self)
	return self:getStorageValue(50005) + self:getStorageValue(50015)
end

function AGILIDADE(self)
	return self:getStorageValue(48900) + self:getStorageValue(48910) 
end

function DEFESA(self)
	return self:getStorageValue(50006) + self:getStorageValue(50016) + self:getStorageValue(23000)
end
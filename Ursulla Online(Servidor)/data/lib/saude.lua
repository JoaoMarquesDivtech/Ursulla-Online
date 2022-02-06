Saude = {
WATER = 60999,
PROTEIN = 61000,
CARBO = 61001,
IRON = 61002,
ZINC = 61003,
VITAMIN = 61004,
FIBER = 61005
}

Resist = {
Veneno = 60006,
Fogo = 60007,
Gelo = 60008,
Trevas = 60009,
Agua = 60010,
Luz = 60011
}




function Player.getSValue(self,S)
	return self:getStorageValue(Saude.S)
end

function Player.setSValue(self, S, value)
	self:setStorageValue(Saude.S, value)
	
	if Player.getSValue(self)>100 then
		self:setStorageValue(Saude.S, 100)
	end
end


local function V_S(self, value)
	local cont = 0
	
    for i = 0, 29 do  
		addEvent(function()
			if self:isRemoved() then return false end
			self:addHealth(value)
		end, i*3000)
	end

end



function checkS(self)
	local var= 0


	if self:getStorageValue(60998) == -1 then 
		for x, count in pairs(Saude) do 
			self:setStorageValue(count, 100)
		end
		self:setStorageValue(60998, 0)
	end



    for x, count in pairs(Saude) do
		if self:getStorageValue(count) < 0 then
			self:setStorageValue(count, 0)     
		end
    end
	

    for x, count in pairs(Saude) do  
		if self:getStorageValue(count)>=30 then
			var = 1    
		end
	end
	
	if var == 0 then 
		V_S(self, -1)
	end
	

	
	if Player.getSValue(Player(self),ZINC) >= 60 then
		V_S(self , 1)
	end
	
    for x, count in pairs(Saude) do 
        if self:getStorageValue(count)<=1 then
			self:setStorageValue(count, 0)
			print(self:getStorageValue(count))
		else
			self:setStorageValue(count, self:getStorageValue(count)-1)
			print(self:getStorageValue(count))
		end
	end
	
	
end
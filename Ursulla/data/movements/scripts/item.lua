--Inteligencia = 50010
--Forca = 50011
--Pericia = 50014
--Defesa = 50016
--Agilidade = 48900

-- Defesa = 50004
-- Desvio = 48900


local config = {
[26400] = {[50014] = 20},
[26401] = {[50014] = 20},
[26402] = {[50010] = 3},
[26403] = {[50010] =  3},
[26404] = {[50014] = 3},
[26405] = {[50014] = 3},
[26406] = {[50016] = 2},
[26407] = {[50016] = 2},
[26408] = {[48900] = 4},
[26409] = {[48900] =  4},
[26440] = {[50010] = 4},
[26441] = {[50010] = 4},
[26442] = {[50010] = 6},
[26443] = {[50010] = 6},
[26444] = {[50014] = 2},
[26445] = {[50014] = 2},
[26446] = {[50014] = 5},
[26447] = {[50014] =  5}
}

function onEquip(player, item, slot)

        local ID  = item:getId()		
			for i,x in pairs(config[ID]) do
				player:setStorageValue(i, player:getStorageValue(i) + x)	
			end
		item:transform(ID+1)
		return true

end



 
function onDeEquip(player, item, slot)
        local ID  = item:getId()
		
		
		for i,x in pairs(config[ID]) do
			if player:getStorageValue(i) >= x then
				player:setStorageValue(i, player:getStorageValue(i) - x)		
			end
		end

		item:transform(ID-1)		
		
		return true

end

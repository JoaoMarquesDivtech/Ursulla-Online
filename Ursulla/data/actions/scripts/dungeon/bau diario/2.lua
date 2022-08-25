local t = {
storage = 40001, -- Só mexa se necessário.
temp = 24 -- Tempo em horas.
}

local rewards = {26383,26384,26385}

function onUse(cid, item, fromPos, itemEx, toPos)
    if getPlayerStorageValue(cid , 3003) == -1 and getPlayerStorageValue(cid , 3004) == -1 and getPlayerStorageValue(cid , 3005) == -1 then 
	doPlayerSendTextMessage(cid, 25, "Pegue os outros baus primeiro!")
	return false
	end
    if getPlayerStorageValue(cid, t.storage) < os.time() then
	   local ramdom = math.random(1,#rewards)
       doPlayerSendTextMessage(cid, 25, "Parabens! Você encontrou: Pedra da alma.")
       doPlayerAddItem(cid, rewards[ramdom],3)
       setPlayerStorageValue(cid, t.storage, os.time() + t.temp * 60 * 60)
	   doTeleportThing(cid, {x = 1234, y = 925, z = 5})
    else
       doPlayerSendTextMessage(cid, 25, "Você precisa esperar ".. getPlayerStorageValue(cid, t.storage) - os.time() .." segundos para usar novamente.")
    end
    return true
end
local t = {
storage = 40000, -- S� mexa se necess�rio.
temp = 24 -- Tempo em horas.
}

local rewards = {26382,26383}

function onUse(cid, item, fromPos, itemEx, toPos)
    if getPlayerStorageValue(cid, t.storage) < os.time() then
	   local ramdom = math.random(1,#rewards)
       doPlayerSendTextMessage(cid, 25, "Parabens! Voc� encontrou: Pedra da alma.")
       doPlayerAddItem(cid, rewards[ramdom],2)
       setPlayerStorageValue(cid, t.storage, os.time() + t.temp * 60 * 60)
	   doTeleportThing(cid, {x = 1045, y = 1053, z = 7})
    else
       doPlayerSendTextMessage(cid, 25, "Voc� precisa esperar ".. getPlayerStorageValue(cid, t.storage) - os.time() .." segundos para usar novamente.")
    end
    return true
end
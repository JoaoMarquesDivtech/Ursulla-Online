local t = {
storage = 46000, -- Só mexa se necessário.
}


function onUse(cid, item, fromPos, itemEx, toPos)
    if (getPlayerStorageValue(cid, t.storage) ~= 1) then
       doPlayerSendTextMessage(cid, 25, "Parabens você derrubou o império de Groter! Vá falar com o buck!")
       setPlayerStorageValue(cid, 20000, 26)
	   doTeleportThing(cid, {x = 1266, y = 957, z = 5})
	   doPlayerAddExp(cid, 20000)
    else
       doPlayerSendTextMessage(cid, 25, "Você ja concluiu o Bau!")
    end
    return true
end
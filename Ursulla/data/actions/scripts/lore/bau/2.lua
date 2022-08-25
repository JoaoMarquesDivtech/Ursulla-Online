local t = {
storage = 46001, -- Só mexa se necessário.
}


function onUse(cid, item, fromPos, itemEx, toPos)
    if (getPlayerStorageValue(cid, t.storage) ~= 1) then
       doPlayerSendTextMessage(cid, 25, "Parabens! Você derrubou a familia Bisel, Vá falar com o fideli!")
       setPlayerStorageValue(cid, 20000, 36)
	   doTeleportThing(cid, {x = 1272, y = 822, z = 4})
	   doPlayerAddExp(cid, 20000)
    else
       doPlayerSendTextMessage(cid, 25, "Você ja concluiu o Bau!")
    end
    return true
end
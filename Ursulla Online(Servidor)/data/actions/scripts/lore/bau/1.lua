local t = {
storage = 46000, -- S� mexa se necess�rio.
}


function onUse(cid, item, fromPos, itemEx, toPos)
    if (getPlayerStorageValue(cid, t.storage) ~= 1) then
       doPlayerSendTextMessage(cid, 25, "Parabens voc� derrubou o imp�rio de Groter! V� falar com o buck!")
       setPlayerStorageValue(cid, 20000, 26)
	   doTeleportThing(cid, {x = 1266, y = 957, z = 5})
	   doPlayerAddExp(cid, 20000)
    else
       doPlayerSendTextMessage(cid, 25, "Voc� ja concluiu o Bau!")
    end
    return true
end
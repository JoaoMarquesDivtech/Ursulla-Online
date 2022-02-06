function onStepIn(cid, item, position, fromPosition)
    if cid:getStorageValue(20000) == -1 then
	doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Fale com o Bron antes!.")
	doTeleportThing(cid, {x = 1045, y = 1053, z = 7})	
	end
	return true
end

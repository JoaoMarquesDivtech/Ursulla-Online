function onStepIn(cid, item, position, fromPosition)
    if getPlayerStorageValue(cid, 20007) <= 0 then
	doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Você não pode entrar aqui!")
	doTeleportThing(cid, {x = 974, y = 868, z = 4})	
	getCreaturePosition(cid):sendMagicEffect(3)		
	else
	return true
	end
end

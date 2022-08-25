function onStepIn(cid, item, position, fromPosition)
    if cid:getStorageValue(20001) == -1 and isElf(Player(cid)) then
	doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Fale com o Harry antes!.")
	doTeleportThing(cid, {x = 998, y = 1618, z = 3})	
	end
	return true
end

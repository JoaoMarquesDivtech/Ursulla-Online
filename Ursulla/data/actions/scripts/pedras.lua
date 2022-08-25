function onUse(player, item, fromPosition, target, toPosition, isHotkey)   

local IName = item:getName()


    if IName == "talent crystal" then
		player:setStorageValue(45200, player:getStorageValue(45200)+1)    	
		item:remove()
	elseif IName == "teleport crystal" then
	
		local templo, storage, segundos = player:getTown():getTemplePosition(), 30016, 1*(60*60*24)

		if player:getCondition(CONDITION_INFIGHT) then
			doPlayerSendCancel(player, "Voce não pode voltar ao templo enquanto estiver batalhando!")
			return false
		end	
		if Player.getExhaustion(player,storage) <= 0 then
			doSendMagicEffect(player:getPosition(), 53)
			doPlayerSendCancel(player, "Você foi teleportado para o templo, porem só pode se fazer isso uma vez ao dia.")
			Player.setExhaustion(player, storage, segundos)
			doTeleportThing(player, templo)
		else
			doPlayerSendCancel(player, "Voce precisa esperar " .. (Player.getExhaustion(player, storage)) .. " segundos para usar novamente.")
		end
	return true
	end
return true
end

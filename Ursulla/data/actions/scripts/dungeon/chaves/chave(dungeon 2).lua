function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(3004) < 1 then
		player:setStorageValue(3004, 1)
		
		local key = Game.createItem(2088,1) -- key (null)
		key:setActionId(15000)
		player:addItemEx(key, 1) -- key (actionId)
		
		
	    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce achou uma chave!.")
		
		
		Game.createMonster("minotauro mago", {x = 949, y = 688, z = 8})
		Game.createMonster("minotauro mago", {x = 949, y = 690, z = 8})
		Game.createMonster("minotauro mago", {x = 949, y = 692, z = 8})
		Game.createMonster("minotauro mago", {x = 949, y = 694, z = 8})
		Game.createMonster("minotauro mago", {x = 949, y = 696, z = 8})
		Game.createMonster("minotauro mago", {x = 949, y = 698, z = 8})
		Game.createMonster("minotauro mago", {x = 949, y = 700, z = 8})
		
		Game.createMonster("minotauro mago", {x = 959, y = 688, z = 8})
		Game.createMonster("minotauro mago", {x = 959, y = 690, z = 8})
		Game.createMonster("minotauro mago", {x = 959, y = 692, z = 8})
		Game.createMonster("minotauro mago", {x = 959, y = 694, z = 8})
		Game.createMonster("minotauro mago", {x = 959, y = 696, z = 8})
		Game.createMonster("minotauro mago", {x = 959, y = 698, z = 8})
		Game.createMonster("minotauro mago", {x = 959, y = 700, z = 8})
		
		
		
		
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Este baú esta vazio!.")
	end
	return true
end

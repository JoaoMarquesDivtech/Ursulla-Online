function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(3000) < 1 then
		player:setStorageValue(3000, 1)
		player:addItem(1955, 1)
		player:addItem(2649, 1)
		player:addItem(2461, 1)
		player:addItem(8704, 5)
		player:addItem(7620, 5)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce achou um livro sagrado e outros items!.")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Este baú esta vazio!.")
	end
	return true
end

local storage = 71000
local quantidadeMaximaDeMagias = 10


function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	
	local numeroDeMagiasDoPlayer = player:getStorageValue(storage)
	local nomeDoItem = item:getAttribute("name")

	if not(numeroDeMagiasDoPlayer >= quantidadeMaximaDeMagias) then
		if (not player:hasLearnedSpell(nomeDoItem)) then
			player:learnSpell(nomeDoItem)
			item:remove()
			doSendMagicEffect(player:getPosition(), CONST_ME_MAGIC_GREEN)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce ja aprendeu esta habilidade!")	
		end
		return true
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce ja tem o numero maximo de magias!")	
	end
end

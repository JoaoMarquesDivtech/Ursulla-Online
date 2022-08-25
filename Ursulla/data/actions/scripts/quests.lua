local config = {
    rewards = {
        [3002] = {id = {[13295] = 1}, msgext ="Parabens, Você achou um item!", experience = "50"},
        [3003] = {id = {[2147] = 7}, msgext ="Parabens, Você achou um item!", experience = "3000"},
        [3004] = {id = {[2132] = 1}, msgext ="Parabens, Você achou um item!", experience = "500"},
        [3005] = {id = {[8300] = 1}, msgext ="Parabens, Você achou um item!", experience = "500"},
        [3006] = {id = {[2196] = 1}, msgext ="Parabens, Você achou um item!", experience = "50"},
        [3007] = {id = {[26406] = 1}, msgext ="Parabens, Você achou um item!", experience = "120"},
        [3008] = {id = {[2641] = 1}, msgext ="Parabens, Você achou um item!", experience = "140"},
        [3009] = {id = {[26408] = 1}, msgext ="Parabens, Você achou um item!", experience = "150"},
        [3010] = {id = {[23539] = 1}, msgext ="Parabens, Você achou um item!", experience = "200"},
        [3011] = {id = {[2323] = 1}, msgext ="Parabens, Você achou um item!", experience = "240"},
        [3012] = {id = {[2124] = 1}, msgext ="Parabens, Você achou um item!", experience = "160"},
        [3014] = {id = {[26411] = 1}, msgext ="Parabens, Você achou um item!", experience = "160"},
        [3015] = {id = {[26413] = 1}, msgext ="Voce achou algum item!", experience = "40000"},
        [3016] = {id = {[8300] = 1}, msgext ="Parabens, Você achou um item!", experience = "160"},
        [3017] = {id = {[26442] = 1}, msgext ="Parabens, Você achou um item!", experience = "400"},
        [3019] = {id = {[26444] = 1}, msgext ="Parabens, Você achou um item!", experience = "1400"},
        [3020] = {id = {[26446] = 1}, msgext ="Parabens, Você achou um item!", experience = "1400"},
        [3021] = {id = {[26383] = 1}, msgext ="Parabens, Você achou um item!", experience = "10000"},
        [3022] = {id = {[2476] = 1}, msgext ="Parabens, Você achou um item!", experience = "2000"},
        [3023] = {id = {[2477] = 1}, msgext ="Parabens, Você achou um item!", experience = "2000"},
        [3024] = {id = {[2645] = 1}, msgext ="Parabens, Você achou um item!", experience = "20000"}
    },
    successEffect = 11,
    failEffect = 3,   
}

local messages = {
    sucess = "Você achou um item!",
    gotTheReward = "Você ja pegou este item!",
    noCap = "Você esta pesado demais para pegar este item!",
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)

    local storage, aid, minCap = item:getActionId() ,item:getActionId(), item:getCapacity()	


    if player:getStorageValue(storage) ~= -1 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, messages.gotTheReward)
        player:getPosition():sendMagicEffect(config.failEffect)
        return false
    end


    if player:getCapacity() < minCap then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, messages.noCap)
        player:getPosition():sendMagicEffect(config.failEffect)
        return false
    end

    for id, count in pairs(config.rewards[aid].id) do
        player:addItem(id, count)
    end
	
	player:setStorageValue(storage, 0)
	
	if config.rewards[aid].msgext then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, config.rewards[aid].msgext)
	end
	
	if config.rewards[aid].experience then
	player:addExperience(config.rewards[aid].experience, true)
	end
	
    player:getPosition():sendMagicEffect(config.successEffect)
    return true
end
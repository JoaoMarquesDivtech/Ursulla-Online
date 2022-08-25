 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
 
local count = {}
local transfer = {}
 
function onCreatureAppear(cid)          npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)       npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)        end
function onThink()      npcHandler:onThink()        end
 
local voices = { {text = 'Não se esqueça de depositar seu dinheiro aqui antes de sair para a aventura.'} }
if VoiceModule then
    npcHandler:addModule(VoiceModule:new(voices))
end
--------------------------------guild bank-----------------------------------------------
local receiptFormat = 'Date: %s\nType: %s\nGold Amount: %d\nReceipt Owner: %s\nRecipient: %s\n\n%s'
local function getReceipt(info)
    local receipt = Game.createItem(info.success and 24301 or 24302)
    receipt:setAttribute(ITEM_ATTRIBUTE_TEXT, receiptFormat:format(os.date('%d. %b %Y - %H:%M:%S'), info.type, info.amount, info.owner, info.recipient, info.message))
 
    return receipt
end
 
local function getGuildIdByName(name, func)
    db.asyncStoreQuery('SELECT `id` FROM `guilds` WHERE `name` = ' .. db.escapeString(name),
        function(resultId)
            if resultId then
                func(result.getNumber(resultId, 'id'))
                result.free(resultId)
            else
                func(nil)
            end
        end
    )
end
 
local function getGuildBalance(id)
    local guild = Guild(id)
    if guild then
        return guild:getBankBalance()
    else
        local balance
        local resultId = db.storeQuery('SELECT `balance` FROM `guilds` WHERE `id` = ' .. id)
        if resultId then
            balance = result.getNumber(resultId, 'balance')
            result.free(resultId)
        end
 
        return balance
    end
end
 
local function setGuildBalance(id, balance)
    local guild = Guild(id)
    if guild then
        guild:setBankBalance(balance)
    else
        db.query('UPDATE `guilds` SET `balance` = ' .. balance .. ' WHERE `id` = ' .. id)
    end
end
 
local function transferFactory(playerName, amount, fromGuildId, info)
    return function(toGuildId)
        if not toGuildId then
            local player = Player(playerName)
            if player then
                info.success = false
                info.message = 'Lamentamos informá-lo de que não pudemos atender à sua solicitação, porque não encontramos a guilda destinatária.'
                local inbox = player:getInbox()
                local receipt = getReceipt(info)
                inbox:addItemEx(receipt, INDEX_WHEREEVER, FLAG_NOLIMIT)
            end
        else
            local fromBalance = getGuildBalance(fromGuildId)
            if fromBalance < amount then
                info.success = false
                info.message = 'Lamentamos informá-lo de que não pudemos atender ao seu pedido, devido à falta do valor necessário na conta da sua guilda.'
            else
                info.success = true
                info.message = 'Temos o prazer de informar que sua solicitação de transferência foi realizada com sucesso.'
                setGuildBalance(fromGuildId, fromBalance - amount)
                setGuildBalance(toGuildId, getGuildBalance(toGuildId) + amount)
            end
 
            local player = Player(playerName)
            if player then
                local inbox = player:getInbox()
                local receipt = getReceipt(info)
                inbox:addItemEx(receipt, INDEX_WHEREEVER, FLAG_NOLIMIT)
            end
        end
    end
end
--------------------------------guild bank-----------------------------------------------
 
local function greetCallback(cid)
    count[cid], transfer[cid] = nil, nil
    return true
end
 
local function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end
    local player = Player(cid)
---------------------------- help ------------------------
    if msgcontains(msg, 'conta do banco') then
        npcHandler:say({
            'Toda pessoa neste mundo tem uma grande vantagem, que você pode acessar seu dinheiro em todas as agências de banco!',
            'Gostaria de saber mais sobre as funções {basicas} da sua conta bancária, as funções {avançadas}, ou talvez já esteja entediado?'
        }, cid)
        npcHandler.topic[cid] = 0
        return true
---------------------------- balance ---------------------
--------------------------------guild bank-----------------------------------------------
    elseif msgcontains(msg, 'saldo da guilda') then
        npcHandler.topic[cid] = 0
        if not player:getGuild() then
            npcHandler:say('Você não é membro de uma guilda.', cid)
            return false
        end            
        npcHandler:say('O saldo da sua conta da guilda é {' .. player:getGuild():getBankBalance() .. '} ouros.', cid)
        return true
--------------------------------bank-----------------------------------------------
    elseif msgcontains(msg, 'saldo') then
        npcHandler.topic[cid] = 0
        if player:getBankBalance() >= 100000000 then
            npcHandler:say('Acho que você deve ser um dos habitantes mais ricos do mundo! O saldo da sua conta é ' .. player:getBankBalance() .. ' ouros.', cid)
            return true
        elseif player:getBankBalance() >= 10000000 then
            npcHandler:say('Você ganhou dez milhões e ainda cresce! O saldo da sua conta é ' .. player:getBankBalance() .. ' ouros.', cid)
            return true
        elseif player:getBankBalance() >= 1000000 then
            npcHandler:say('Uau, você atingiu o número mágico de um milhão de ouros! O saldo da sua conta é ' .. player:getBankBalance() .. ' ouros!', cid)
            return true
        elseif player:getBankBalance() >= 100000 then
            npcHandler:say('Você certamente ganhou um bom dinheiro. O saldo da sua conta é ' .. player:getBankBalance() .. ' ouros.', cid)
            return true
        else
            npcHandler:say('O saldo da sua conta é ' .. player:getBankBalance() .. ' ouros.', cid)
            return true
        end
---------------------------- deposit ---------------------
--------------------------------guild bank-----------------------------------------------
    elseif msgcontains(msg, 'deposito de guilda') then
        if not player:getGuild() then
            npcHandler:say('Você não é membro de uma guilda.', cid)
            npcHandler.topic[cid] = 0
            return false
        end
       -- count[cid] = player:getMoney()
       -- if count[cid] < 1 then
           -- npcHandler:say('You do not have enough gold.', cid)
           -- npcHandler.topic[cid] = 0
           -- return false
        --end
        if string.match(msg, '%d+') then
            count[cid] = getMoneyCount(msg)
            if count[cid] < 1 then
                npcHandler:say('Você não tem dinheiro suficiente.', cid)
                npcHandler.topic[cid] = 0
                return false
            end
            npcHandler:say('Você realmente gostaria de depositar ' .. count[cid] .. ' ouros no {saldo da guilda}?', cid)
            npcHandler.topic[cid] = 23
            return true
        else
            npcHandler:say('Diga-me quanto ouro você gostaria de depositar.', cid)
            npcHandler.topic[cid] = 41
            return true
        end
    elseif npcHandler.topic[cid] == 41 then
        count[cid] = getMoneyCount(msg)
        if isValidMoney(count[cid]) then
            npcHandler:say('Você realmente gostaria de depositar ' .. count[cid] .. ' ouros no {saldo da guilda}??', cid)
            npcHandler.topic[cid] = 23
            return true
        else
            npcHandler:say('Você não tem dinheiro suficiente para isto.', cid)
            npcHandler.topic[cid] = 0
            return true
        end
    elseif npcHandler.topic[cid] == 23 then
        if msgcontains(msg, 'sim') then        
            npcHandler:say('Certo, fizemos um pedido para depositar o valor de ' .. count[cid] .. ' ouro para a conta da sua guilda. Por favor, verifique sua caixa de entrada para confirmação.', cid)
            local guild = player:getGuild()
            local info = {
                type = 'Guild Deposit',
                amount = count[cid],
                owner = player:getName() .. ' of ' .. guild:getName(),
                recipient = guild:getName()
            }
            local playerBalance = player:getBankBalance()
            if playerBalance < tonumber(count[cid]) then
                info.message = 'Lamentamos informá-lo de que não pudemos atender à sua solicitação, devido à falta do valor necessário em sua conta bancária.'
                info.success = false
            else
                info.message = 'Temos o prazer de informar que sua solicitação de transferência foi realizada com sucesso.'
                info.success = true
                guild:setBankBalance(guild:getBankBalance() + tonumber(count[cid]))
                player:setBankBalance(playerBalance - tonumber(count[cid]))                        
            end
 
            local inbox = player:getInbox()
            local receipt = getReceipt(info)
            inbox:addItemEx(receipt, INDEX_WHEREEVER, FLAG_NOLIMIT)
        elseif msgcontains(msg, 'no') then
            npcHandler:say('Como quiser. Posso fazer mais alguma coisa por você?', cid)
        end
        npcHandler.topic[cid] = 0
        return true
--------------------------------guild bank-----------------------------------------------
    elseif msgcontains(msg, 'depositar') then
        count[cid] = player:getMoney()
        if count[cid] < 1 then
            npcHandler:say('Você não tem ouro suficiente.', cid)
            npcHandler.topic[cid] = 0
            return false
        end
        if msgcontains(msg, 'tudo') then
            count[cid] = player:getMoney()
            npcHandler:say('Você realmente gostaria de depositar ' .. count[cid] .. ' ouros?', cid)
            npcHandler.topic[cid] = 2
            return true
        else
            if string.match(msg,'%d+') then
                count[cid] = getMoneyCount(msg)
                if count[cid] < 1 then
                    npcHandler:say('Você não tem ouro suficiente.', cid)
                    npcHandler.topic[cid] = 0
                    return false
                end
                npcHandler:say('Você realmente gostaria de depositar ' .. count[cid] .. ' ouros?', cid)
                npcHandler.topic[cid] = 2
                return true
            else
                npcHandler:say('Diga-me quanto ouro você gostaria de depositar.', cid)
                npcHandler.topic[cid] = 1
                return true
            end
        end
        if not isValidMoney(count[cid]) then
            npcHandler:say('Desculpe, mas você não pode depositar tanto.', cid)
            npcHandler.topic[cid] = 0
            return false
        end
    elseif npcHandler.topic[cid] == 1 then
        count[cid] = getMoneyCount(msg)
        if isValidMoney(count[cid]) then
            npcHandler:say('Você realmente gostaria de depositar ' .. count[cid] .. ' ouros?', cid)
            npcHandler.topic[cid] = 40
            return true
        else
            npcHandler:say('Você não tem dinheiro suficiente para isto.', cid)
            npcHandler.topic[cid] = 0
            return true
        end
    elseif npcHandler.topic[cid] == 40 then
        if msgcontains(msg, 'sim') then
            if player:getMoney() >= tonumber(count[cid]) then
                player:depositMoney(count[cid])
                npcHandler:say('Tudo bem, nós adicionamos a quantidade de ' .. count[cid] .. ' ouro para o seu {saldo}. Você pode {retirar} seu dinheiro a qualquer hora que quiser.', cid)
            else
                npcHandler:say('Você não tem dinheiro suficiente para isto.', cid)
            end
        elseif msgcontains(msg, 'não') then
            npcHandler:say('Como quiser. Posso fazer mais alguma coisa por você?', cid)
        end
        npcHandler.topic[cid] = 0
        return true
---------------------------- withdraw --------------------
--------------------------------guild bank-----------------------------------------------
    elseif msgcontains(msg, 'retirada da guilda') then
        if not player:getGuild() then
            npcHandler:say('Sinto muito, mas parece que você não está atualmente em nenhuma guilda.', cid)
            npcHandler.topic[cid] = 0
            return false
        elseif player:getGuildLevel() < 2 then
            npcHandler:say('Apenas os líderes ou vice-líderes da guilda podem retirar dinheiro da conta da guilda.', cid)
            npcHandler.topic[cid] = 0
            return false
        end
 
        if string.match(msg,'%d+') then
            count[cid] = getMoneyCount(msg)
            if isValidMoney(count[cid]) then
                npcHandler:say('Tem certeza que deseja retirar ' .. count[cid] .. ' ouros da sua conta da guilda?', cid)
                npcHandler.topic[cid] = 25
            else
                npcHandler:say('Não há ouro suficiente na sua conta da guilda.', cid)
                npcHandler.topic[cid] = 0
            end
            return true
        else
            npcHandler:say('Por favor, me diga quanto ouro você gostaria de retirar da sua conta da guilda.', cid)
            npcHandler.topic[cid] = 24
            return true
        end
    elseif npcHandler.topic[cid] == 24 then
        count[cid] = getMoneyCount(msg)
        if isValidMoney(count[cid]) then
            npcHandler:say('Tem certeza que deseja retirar ' .. count[cid] .. ' ouro da sua conta da guilda?', cid)
            npcHandler.topic[cid] = 25
        else
            npcHandler:say('Não há ouro suficiente na sua conta da guilda.', cid)
            npcHandler.topic[cid] = 0
        end
        return true
    elseif npcHandler.topic[cid] == 25 then
        if msgcontains(msg, 'yes') then
            local guild = player:getGuild()
            local balance = guild:getBankBalance()
            npcHandler:say('Fizemos um pedido de retirada ' .. count[cid] .. ' ouros da sua conta da guilda. Verifique sua caixa de entrada para confirmação.', cid)
            local info = {
                type = 'Guild Withdraw',
                amount = count[cid],
                owner = player:getName() .. ' of ' .. guild:getName(),
                recipient = player:getName()
            }
            if balance < tonumber(count[cid]) then
                info.message = 'Lamentamos informá-lo de que não pudemos atender ao seu pedido, devido à falta do valor necessário na conta da sua guilda.'
                info.success = false
            else
                info.message = 'Temos o prazer de informar que sua solicitação de transferência foi realizada com sucesso.'
                info.success = true
                guild:setBankBalance(balance - tonumber(count[cid]))
                local playerBalance = player:getBankBalance()
                player:setBankBalance(playerBalance + tonumber(count[cid]))                        
            end
 
            local inbox = player:getInbox()
            local receipt = getReceipt(info)
            inbox:addItemEx(receipt, INDEX_WHEREEVER, FLAG_NOLIMIT)
            npcHandler.topic[cid] = 0
        elseif msgcontains(msg, 'no') then
            npcHandler:say('Como quiser. Há algo mais que eu posso fazer por você?', cid)
            npcHandler.topic[cid] = 0
        end
        return true
--------------------------------bank-----------------------------------------------
    elseif msgcontains(msg, 'retirar') then
        if string.match(msg,'%d+') then
            count[cid] = getMoneyCount(msg)
            if isValidMoney(count[cid]) then
                npcHandler:say('Tem certeza que deseja retirar ' .. count[cid] .. ' ouro da sua conta bancária?', cid)
                npcHandler.topic[cid] = 7
            else
                npcHandler:say('Não há ouro suficiente em sua conta.', cid)
                npcHandler.topic[cid] = 0
            end
            return true
        else
            npcHandler:say('Por favor me diga quanto ouro você gostaria de sacar.', cid)
            npcHandler.topic[cid] = 6
            return true
        end
    elseif npcHandler.topic[cid] == 6 then
        count[cid] = getMoneyCount(msg)
        if isValidMoney(count[cid]) then
            npcHandler:say('Tem certeza que deseja retirar ' .. count[cid] .. ' ouros da sua conta bancária?', cid)
            npcHandler.topic[cid] = 7
        else
            npcHandler:say('Não há ouro suficiente em sua conta.', cid)
            npcHandler.topic[cid] = 0
        end
        return true
    elseif npcHandler.topic[cid] == 7 then
        if msgcontains(msg, 'sim') then
            if player:getFreeCapacity() >= getMoneyWeight(count[cid]) then
                if not player:withdrawMoney(count[cid]) then
                    npcHandler:say('Não há ouro suficiente em sua conta.', cid)
                else
                    npcHandler:say('Olha Você aqui, ' .. count[cid] .. ' ouros. Por favor, deixe-me saber se há algo mais que eu possa fazer por você.', cid)
                end
            else
                npcHandler:say('Uau, espere um pouco, você não tem espaço em seu inventário para carregar todas aquelas moedas. Eu não quero que você deixe cair no chão, talvez volte com um carrinho!', cid)
            end
            npcHandler.topic[cid] = 0
        elseif msgcontains(msg, 'no') then
            npcHandler:say('O cliente é rei! Volte a qualquer hora que quiser se quiser {retirar} seu dinheiro.', cid)
            npcHandler.topic[cid] = 0
        end
        return true
---------------------------- transfer --------------------
--------------------------------guild bank-----------------------------------------------
    elseif msgcontains(msg, 'transferência de guilda') then
        if not player:getGuild() then
            npcHandler:say('Sinto muito, mas parece que você não está atualmente em nenhuma guilda.', cid)
            npcHandler.topic[cid] = 0
            return false
        elseif player:getGuildLevel() < 2 then
            npcHandler:say('Apenas os líderes ou vice-líderes da guilda podem transferir dinheiro da conta da guilda.', cid)
            npcHandler.topic[cid] = 0
            return false
        end
 
        if string.match(msg, '%d+') then
            count[cid] = getMoneyCount(msg)
            if isValidMoney(count[cid]) then
                transfer[cid] = string.match(msg, 'to%s*(.+)$')
                if transfer[cid] then
                    npcHandler:say('Então você gostaria de transferir ' .. count[cid] .. ' ouros de sua conta de guilda para guilda ' .. transfer[cid] .. '?', cid)
                    npcHandler.topic[cid] = 28
                else
                    npcHandler:say('Qual guilda você gostaria de transferir ' .. count[cid] .. ' ouros?', cid)
                    npcHandler.topic[cid] = 27
                end
            else
                npcHandler:say('Não há ouro suficiente na sua conta da guilda.', cid)
                npcHandler.topic[cid] = 0
            end
        else
            npcHandler:say('Por favor, diga-me a quantidade de ouro que você gostaria de transferir.', cid)
            npcHandler.topic[cid] = 26
        end
        return true
    elseif npcHandler.topic[cid] == 26 then
        count[cid] = getMoneyCount(msg)
        if player:getGuild():getBankBalance() < count[cid] then
            npcHandler:say('Não há ouro suficiente na sua conta da guilda.', cid)
            npcHandler.topic[cid] = 0
            return true
        end
        if isValidMoney(count[cid]) then
            npcHandler:say('Qual guilda você gostaria de transferir ' .. count[cid] .. ' ouros?', cid)
            npcHandler.topic[cid] = 27
        else
            npcHandler:say('Não há ouro suficiente na sua conta.', cid)
            npcHandler.topic[cid] = 0
        end
        return true
    elseif npcHandler.topic[cid] == 27 then
        transfer[cid] = msg
        if player:getGuild():getName() == transfer[cid] then
            npcHandler:say('Preencha este campo com a pessoa que receberá seu ouro!', cid)
            npcHandler.topic[cid] = 0
            return true
        end
        npcHandler:say('Então você gostaria de transferir ' .. count[cid] .. ' ouro de sua conta de guilda para guilda' .. transfer[cid] .. '?', cid)
        npcHandler.topic[cid] = 28
        return true
    elseif npcHandler.topic[cid] == 28 then
        if msgcontains(msg, 'sim') then
            npcHandler:say('Fizemos um pedido de transferência ' .. count[cid] .. ' ouro de sua conta de guilda para guilda ' .. transfer[cid] .. '. Verifique sua caixa de entrada para confirmação.', cid)
            local guild = player:getGuild()
            local balance = guild:getBankBalance()
            local info = {
                type = 'Guild to Guild Transfer',
                amount = count[cid],
                owner = player:getName() .. ' of ' .. guild:getName(),
                recipient = transfer[cid]
            }
            if balance < tonumber(count[cid]) then
                info.message = 'Lamentamos informá-lo de que não pudemos atender ao seu pedido, devido à falta do valor necessário na conta da sua guilda.'
                info.success = false
                local inbox = player:getInbox()
                local receipt = getReceipt(info)
                inbox:addItemEx(receipt, INDEX_WHEREEVER, FLAG_NOLIMIT)
            else
                getGuildIdByName(transfer[cid], transferFactory(player:getName(), tonumber(count[cid]), guild:getId(), info))                  
            end
            npcHandler.topic[cid] = 0
        elseif msgcontains(msg, 'não') then
            npcHandler:say('Certo, há algo mais que eu possa fazer por você?', cid)
        end
        npcHandler.topic[cid] = 0
--------------------------------guild bank-----------------------------------------------
    elseif msgcontains(msg, 'transferir') then
        npcHandler:say('Por favor, diga-me a quantidade de ouro que você gostaria de transferir.', cid)
        npcHandler.topic[cid] = 11
    elseif npcHandler.topic[cid] == 11 then
        count[cid] = getMoneyCount(msg)
        if player:getBankBalance() < count[cid] then
            npcHandler:say('Não há ouro suficiente em sua conta.', cid)
            npcHandler.topic[cid] = 0
            return true
        end
        if isValidMoney(count[cid]) then
            npcHandler:say('Quem você gostaria de transferir ' .. count[cid] .. ' ouros?', cid)
            npcHandler.topic[cid] = 12
        else
            npcHandler:say('Não há ouro suficiente em sua conta.', cid)
            npcHandler.topic[cid] = 0
        end
    elseif npcHandler.topic[cid] == 12 then
        transfer[cid] = msg
        if player:getName() == transfer[cid] then
            npcHandler:say('Preencha este campo com a pessoa que receberá seu ouro!', cid)
            npcHandler.topic[cid] = 0
            return true
        end
        if playerExists(transfer[cid]) then
		  local arrayDenied = {"accountmanager", "rooksample", "druidsample", "sorcerersample", "knightsample", "paladinsample"}
		    if isInArray(arrayDenied, string.gsub(transfer[cid]:lower(), " ", "")) then
                npcHandler:say('Este jogador não existe.', cid)
                npcHandler.topic[cid] = 0
                return true
            end
            npcHandler:say('Então você gostaria de transferir ' .. count[cid] .. ' ouros para ' .. transfer[cid] .. '?', cid)
            npcHandler.topic[cid] = 13
        else
            npcHandler:say('Este jogador não existe.', cid)
            npcHandler.topic[cid] = 0
        end
    elseif npcHandler.topic[cid] == 13 then
        if msgcontains(msg, 'sim') then
            if not player:transferMoneyTo(transfer[cid], count[cid]) then
                npcHandler:say('Você não pode transferir dinheiro para esta conta.', cid)
            else
                npcHandler:say('Muito bem. Você transferiu ' .. count[cid] .. ' ouros para ' .. transfer[cid] ..'.', cid)
                transfer[cid] = nil
            end
        elseif msgcontains(msg, 'não') then
            npcHandler:say('Certo, há algo mais que eu possa fazer por você?', cid)
        end
        npcHandler.topic[cid] = 0
---------------------------- money exchange --------------
    elseif msgcontains(msg, 'trocar bronze') then
        npcHandler:say('Quantas moedas de prata você gostaria de obter?', cid)
        npcHandler.topic[cid] = 14
    elseif npcHandler.topic[cid] == 14 then
        if getMoneyCount(msg) < 1 then
            npcHandler:say('Desculpe, você não tem moedas de ouro suficientes.', cid)
            npcHandler.topic[cid] = 0
        else
            count[cid] = getMoneyCount(msg)
            npcHandler:say('Então você gostaria que eu mudasse ' .. count[cid] * 100 .. ' de suas moedas de ouro em ' .. count[cid] .. ' moedas de prata?', cid)
            npcHandler.topic[cid] = 15
        end
    elseif npcHandler.topic[cid] == 15 then
        if msgcontains(msg, 'sim') then
            if player:removeItem(2148, count[cid] * 100) then
                player:addItem(2152, count[cid])
                npcHandler:say('Pronto amigo!.', cid)
            else
                npcHandler:say('Desculpe, você não tem moedas de ouro suficientes.', cid)
            end
        else
            npcHandler:say('Bem, posso te ajudar com outra coisa?', cid)
        end
        npcHandler.topic[cid] = 0
    elseif msgcontains(msg, 'trocar prata') then
        npcHandler:say('Você gostaria de transformar suas moedas de prata em {bronze} ou {ouro}?', cid)
        npcHandler.topic[cid] = 16
    elseif npcHandler.topic[cid] == 16 then
        if msgcontains(msg, 'bronze') then
            npcHandler:say('Quantas moedas de prata você gostaria de transformar em bronze?', cid)
            npcHandler.topic[cid] = 17
        elseif msgcontains(msg, 'ouro') then
            npcHandler:say('Quantas moedas de ouro você gostaria de obter?', cid)
            npcHandler.topic[cid] = 19
        else
            npcHandler:say('Bem, posso te ajudar com outra coisa?', cid)
            npcHandler.topic[cid] = 0
        end
    elseif npcHandler.topic[cid] == 17 then
        if getMoneyCount(msg) < 1 then
            npcHandler:say('Desculpe, você não tem moedas de prata suficientes.', cid)
            npcHandler.topic[cid] = 0
        else
            count[cid] = getMoneyCount(msg)
            npcHandler:say('Então você gostaria que eu mudasse ' .. count[cid] .. ' de suas moedas de prata em ' .. count[cid] * 100 .. ' moedas de bronze para você?', cid)
            npcHandler.topic[cid] = 18
        end
    elseif npcHandler.topic[cid] == 18 then
        if msgcontains(msg, 'sim') then
            if player:removeItem(2152, count[cid]) then
                player:addItem(2148, count[cid] * 100)
                npcHandler:say('Tome aqui.', cid)
            else
                npcHandler:say('Desculpe, você não tem moedas de prata suficientes.', cid)
            end
        else
            npcHandler:say('Bem, posso te ajudar com outra coisa?', cid)
        end
        npcHandler.topic[cid] = 0
    elseif npcHandler.topic[cid] == 19 then
        if getMoneyCount(msg) < 1 then
            npcHandler:say('Desculpe, você não tem moedas de prata suficientes.', cid)
            npcHandler.topic[cid] = 0
        else
            count[cid] = getMoneyCount(msg)
            npcHandler:say('Então você gostaria que eu mudasse ' .. count[cid] * 100 .. ' de suas moedas de prata em ' .. count[cid] .. ' moedas de ouro para você?', cid)
            npcHandler.topic[cid] = 20
        end
    elseif npcHandler.topic[cid] == 20 then
        if msgcontains(msg, 'sim') then
            if player:removeItem(2152, count[cid] * 100) then
                player:addItem(2160, count[cid])
                npcHandler:say('Tome aqui.', cid)
            else
                npcHandler:say('Desculpe, você não tem moedas de prata suficientes.', cid)
            end
        else
            npcHandler:say('Bem, posso te ajudar com outra coisa?', cid)
        end
        npcHandler.topic[cid] = 0
    elseif msgcontains(msg, 'trocar ouro') then
        npcHandler:say('Quantas moedas de ouro você gostaria de transformar em prata?', cid)
        npcHandler.topic[cid] = 21
    elseif npcHandler.topic[cid] == 21 then
        if getMoneyCount(msg) < 1 then
            npcHandler:say('Desculpe, você não tem moedas de ouro suficientes.', cid)
            npcHandler.topic[cid] = 0
        else
            count[cid] = getMoneyCount(msg)
            npcHandler:say('Então você gostaria que eu mudasse ' .. count[cid] .. ' de suas moedas de ouro em ' .. count[cid] * 100 .. ' moedas de prata para você?', cid)
            npcHandler.topic[cid] = 22
        end
    elseif npcHandler.topic[cid] == 22 then
        if msgcontains(msg, 'sim') then
            if player:removeItem(2160, count[cid]) then
                player:addItem(2152, count[cid] * 100)
                npcHandler:say('Aqui está.', cid)
            else
                npcHandler:say('Desculpe, você não tem moedas de ouro suficientes.', cid)
            end
        else
            npcHandler:say('Bem, posso te ajudar com outra coisa?', cid)
        end
        npcHandler.topic[cid] = 0
    end
    return true
end
 
keywordHandler:addKeyword({'dinheiro'}, StdModule.say, {npcHandler = npcHandler, text = 'Podemos {mudar} dinheiro para você. Você também pode acessar sua {conta do banco}.'})
keywordHandler:addKeyword({'como trocar'}, StdModule.say, {npcHandler = npcHandler, text = 'Existem três tipos diferentes de moedas no Ursulla: 100 moedas de ouro equivalem a 1 moeda de platina, 100 moedas de platina equivalem a 1 moeda de cristal. Portanto, se você deseja transformar 100 moedas de bronze em 1 moeda de prata, basta dizer \'{trocar bronze}\' e depois \'1 de prata \'.'})
keywordHandler:addKeyword({'banco'}, StdModule.say, {npcHandler = npcHandler, text = 'Podemos te explicar {como trocar} dinheiro, você também pode acessar sua {conta do banco}.'})
keywordHandler:addKeyword({'avançado'}, StdModule.say, {npcHandler = npcHandler, text = 'Sua conta bancária será usada automaticamente quando você quiser {alugar} uma casa ou fazer uma oferta em um item no {mercado}. Deixe-me saber se você deseja saber como funciona.'})
keywordHandler:addKeyword({'ajuda'}, StdModule.say, {npcHandler = npcHandler, text = 'Você pode verificar o {saldo} de sua conta bancária, {depositar} dinheiro ou {retirar}. Você também pode {transferir} dinheiro para outros personagens, desde que eles tenham uma vocação, você tambem pode saber {como trocar}, e usar {comandos de guilda}'})
keywordHandler:addKeyword({'funções'}, StdModule.say, {npcHandler = npcHandler, text = 'Você pode verificar o {saldo} de sua conta bancária, {depositar} dinheiro ou {retirar}. Você também pode {transferir} dinheiro para outros personagens, desde que eles tenham uma vocação.'})
keywordHandler:addKeyword({'basico'}, StdModule.say, {npcHandler = npcHandler, text = 'Você pode verificar o {saldo} de sua conta bancária, {depositar} dinheiro ou {retirar}. Você também pode {transferir} dinheiro para outros personagens, desde que eles tenham uma vocação.'})
keywordHandler:addKeyword({'trabalho'}, StdModule.say, {npcHandler = npcHandler, text = 'Eu trabalho neste banco, posso trocar dinheiro para você e ajudá-lo com sua conta bancária.'})
keywordHandler:addKeyword({'comandos de guilda'}, StdModule.say, {npcHandler = npcHandler, text = 'Voce pode ver o {saldo da guilda}, tambem pode fazer {deposito de guilda} ou fazer {transferência de guilda}, por ultimo {transferência de guilda}!'})
 
npcHandler:setMessage(MESSAGE_GREET, "Sim? O que posso fazer por você, |PLAYERNAME|? Negócios bancários, talvez? {ajuda}")
npcHandler:setMessage(MESSAGE_FAREWELL, "Tenha um bom dia.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Tenha um bom dia.")
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
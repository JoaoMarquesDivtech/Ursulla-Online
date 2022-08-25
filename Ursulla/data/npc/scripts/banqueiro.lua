 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
 
local count = {}
local transfer = {}
 
function onCreatureAppear(cid)          npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)       npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)        end
function onThink()      npcHandler:onThink()        end
 
local voices = { {text = 'N�o se esque�a de depositar seu dinheiro aqui antes de sair para a aventura.'} }
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
                info.message = 'Lamentamos inform�-lo de que n�o pudemos atender � sua solicita��o, porque n�o encontramos a guilda destinat�ria.'
                local inbox = player:getInbox()
                local receipt = getReceipt(info)
                inbox:addItemEx(receipt, INDEX_WHEREEVER, FLAG_NOLIMIT)
            end
        else
            local fromBalance = getGuildBalance(fromGuildId)
            if fromBalance < amount then
                info.success = false
                info.message = 'Lamentamos inform�-lo de que n�o pudemos atender ao seu pedido, devido � falta do valor necess�rio na conta da sua guilda.'
            else
                info.success = true
                info.message = 'Temos o prazer de informar que sua solicita��o de transfer�ncia foi realizada com sucesso.'
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
            'Toda pessoa neste mundo tem uma grande vantagem, que voc� pode acessar seu dinheiro em todas as ag�ncias de banco!',
            'Gostaria de saber mais sobre as fun��es {basicas} da sua conta banc�ria, as fun��es {avan�adas}, ou talvez j� esteja entediado?'
        }, cid)
        npcHandler.topic[cid] = 0
        return true
---------------------------- balance ---------------------
--------------------------------guild bank-----------------------------------------------
    elseif msgcontains(msg, 'saldo da guilda') then
        npcHandler.topic[cid] = 0
        if not player:getGuild() then
            npcHandler:say('Voc� n�o � membro de uma guilda.', cid)
            return false
        end            
        npcHandler:say('O saldo da sua conta da guilda � {' .. player:getGuild():getBankBalance() .. '} ouros.', cid)
        return true
--------------------------------bank-----------------------------------------------
    elseif msgcontains(msg, 'saldo') then
        npcHandler.topic[cid] = 0
        if player:getBankBalance() >= 100000000 then
            npcHandler:say('Acho que voc� deve ser um dos habitantes mais ricos do mundo! O saldo da sua conta � ' .. player:getBankBalance() .. ' ouros.', cid)
            return true
        elseif player:getBankBalance() >= 10000000 then
            npcHandler:say('Voc� ganhou dez milh�es e ainda cresce! O saldo da sua conta � ' .. player:getBankBalance() .. ' ouros.', cid)
            return true
        elseif player:getBankBalance() >= 1000000 then
            npcHandler:say('Uau, voc� atingiu o n�mero m�gico de um milh�o de ouros! O saldo da sua conta � ' .. player:getBankBalance() .. ' ouros!', cid)
            return true
        elseif player:getBankBalance() >= 100000 then
            npcHandler:say('Voc� certamente ganhou um bom dinheiro. O saldo da sua conta � ' .. player:getBankBalance() .. ' ouros.', cid)
            return true
        else
            npcHandler:say('O saldo da sua conta � ' .. player:getBankBalance() .. ' ouros.', cid)
            return true
        end
---------------------------- deposit ---------------------
--------------------------------guild bank-----------------------------------------------
    elseif msgcontains(msg, 'deposito de guilda') then
        if not player:getGuild() then
            npcHandler:say('Voc� n�o � membro de uma guilda.', cid)
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
                npcHandler:say('Voc� n�o tem dinheiro suficiente.', cid)
                npcHandler.topic[cid] = 0
                return false
            end
            npcHandler:say('Voc� realmente gostaria de depositar ' .. count[cid] .. ' ouros no {saldo da guilda}?', cid)
            npcHandler.topic[cid] = 23
            return true
        else
            npcHandler:say('Diga-me quanto ouro voc� gostaria de depositar.', cid)
            npcHandler.topic[cid] = 41
            return true
        end
    elseif npcHandler.topic[cid] == 41 then
        count[cid] = getMoneyCount(msg)
        if isValidMoney(count[cid]) then
            npcHandler:say('Voc� realmente gostaria de depositar ' .. count[cid] .. ' ouros no {saldo da guilda}??', cid)
            npcHandler.topic[cid] = 23
            return true
        else
            npcHandler:say('Voc� n�o tem dinheiro suficiente para isto.', cid)
            npcHandler.topic[cid] = 0
            return true
        end
    elseif npcHandler.topic[cid] == 23 then
        if msgcontains(msg, 'sim') then        
            npcHandler:say('Certo, fizemos um pedido para depositar o valor de ' .. count[cid] .. ' ouro para a conta da sua guilda. Por favor, verifique sua caixa de entrada para confirma��o.', cid)
            local guild = player:getGuild()
            local info = {
                type = 'Guild Deposit',
                amount = count[cid],
                owner = player:getName() .. ' of ' .. guild:getName(),
                recipient = guild:getName()
            }
            local playerBalance = player:getBankBalance()
            if playerBalance < tonumber(count[cid]) then
                info.message = 'Lamentamos inform�-lo de que n�o pudemos atender � sua solicita��o, devido � falta do valor necess�rio em sua conta banc�ria.'
                info.success = false
            else
                info.message = 'Temos o prazer de informar que sua solicita��o de transfer�ncia foi realizada com sucesso.'
                info.success = true
                guild:setBankBalance(guild:getBankBalance() + tonumber(count[cid]))
                player:setBankBalance(playerBalance - tonumber(count[cid]))                        
            end
 
            local inbox = player:getInbox()
            local receipt = getReceipt(info)
            inbox:addItemEx(receipt, INDEX_WHEREEVER, FLAG_NOLIMIT)
        elseif msgcontains(msg, 'no') then
            npcHandler:say('Como quiser. Posso fazer mais alguma coisa por voc�?', cid)
        end
        npcHandler.topic[cid] = 0
        return true
--------------------------------guild bank-----------------------------------------------
    elseif msgcontains(msg, 'depositar') then
        count[cid] = player:getMoney()
        if count[cid] < 1 then
            npcHandler:say('Voc� n�o tem ouro suficiente.', cid)
            npcHandler.topic[cid] = 0
            return false
        end
        if msgcontains(msg, 'tudo') then
            count[cid] = player:getMoney()
            npcHandler:say('Voc� realmente gostaria de depositar ' .. count[cid] .. ' ouros?', cid)
            npcHandler.topic[cid] = 2
            return true
        else
            if string.match(msg,'%d+') then
                count[cid] = getMoneyCount(msg)
                if count[cid] < 1 then
                    npcHandler:say('Voc� n�o tem ouro suficiente.', cid)
                    npcHandler.topic[cid] = 0
                    return false
                end
                npcHandler:say('Voc� realmente gostaria de depositar ' .. count[cid] .. ' ouros?', cid)
                npcHandler.topic[cid] = 2
                return true
            else
                npcHandler:say('Diga-me quanto ouro voc� gostaria de depositar.', cid)
                npcHandler.topic[cid] = 1
                return true
            end
        end
        if not isValidMoney(count[cid]) then
            npcHandler:say('Desculpe, mas voc� n�o pode depositar tanto.', cid)
            npcHandler.topic[cid] = 0
            return false
        end
    elseif npcHandler.topic[cid] == 1 then
        count[cid] = getMoneyCount(msg)
        if isValidMoney(count[cid]) then
            npcHandler:say('Voc� realmente gostaria de depositar ' .. count[cid] .. ' ouros?', cid)
            npcHandler.topic[cid] = 40
            return true
        else
            npcHandler:say('Voc� n�o tem dinheiro suficiente para isto.', cid)
            npcHandler.topic[cid] = 0
            return true
        end
    elseif npcHandler.topic[cid] == 40 then
        if msgcontains(msg, 'sim') then
            if player:getMoney() >= tonumber(count[cid]) then
                player:depositMoney(count[cid])
                npcHandler:say('Tudo bem, n�s adicionamos a quantidade de ' .. count[cid] .. ' ouro para o seu {saldo}. Voc� pode {retirar} seu dinheiro a qualquer hora que quiser.', cid)
            else
                npcHandler:say('Voc� n�o tem dinheiro suficiente para isto.', cid)
            end
        elseif msgcontains(msg, 'n�o') then
            npcHandler:say('Como quiser. Posso fazer mais alguma coisa por voc�?', cid)
        end
        npcHandler.topic[cid] = 0
        return true
---------------------------- withdraw --------------------
--------------------------------guild bank-----------------------------------------------
    elseif msgcontains(msg, 'retirada da guilda') then
        if not player:getGuild() then
            npcHandler:say('Sinto muito, mas parece que voc� n�o est� atualmente em nenhuma guilda.', cid)
            npcHandler.topic[cid] = 0
            return false
        elseif player:getGuildLevel() < 2 then
            npcHandler:say('Apenas os l�deres ou vice-l�deres da guilda podem retirar dinheiro da conta da guilda.', cid)
            npcHandler.topic[cid] = 0
            return false
        end
 
        if string.match(msg,'%d+') then
            count[cid] = getMoneyCount(msg)
            if isValidMoney(count[cid]) then
                npcHandler:say('Tem certeza que deseja retirar ' .. count[cid] .. ' ouros da sua conta da guilda?', cid)
                npcHandler.topic[cid] = 25
            else
                npcHandler:say('N�o h� ouro suficiente na sua conta da guilda.', cid)
                npcHandler.topic[cid] = 0
            end
            return true
        else
            npcHandler:say('Por favor, me diga quanto ouro voc� gostaria de retirar da sua conta da guilda.', cid)
            npcHandler.topic[cid] = 24
            return true
        end
    elseif npcHandler.topic[cid] == 24 then
        count[cid] = getMoneyCount(msg)
        if isValidMoney(count[cid]) then
            npcHandler:say('Tem certeza que deseja retirar ' .. count[cid] .. ' ouro da sua conta da guilda?', cid)
            npcHandler.topic[cid] = 25
        else
            npcHandler:say('N�o h� ouro suficiente na sua conta da guilda.', cid)
            npcHandler.topic[cid] = 0
        end
        return true
    elseif npcHandler.topic[cid] == 25 then
        if msgcontains(msg, 'yes') then
            local guild = player:getGuild()
            local balance = guild:getBankBalance()
            npcHandler:say('Fizemos um pedido de retirada ' .. count[cid] .. ' ouros da sua conta da guilda. Verifique sua caixa de entrada para confirma��o.', cid)
            local info = {
                type = 'Guild Withdraw',
                amount = count[cid],
                owner = player:getName() .. ' of ' .. guild:getName(),
                recipient = player:getName()
            }
            if balance < tonumber(count[cid]) then
                info.message = 'Lamentamos inform�-lo de que n�o pudemos atender ao seu pedido, devido � falta do valor necess�rio na conta da sua guilda.'
                info.success = false
            else
                info.message = 'Temos o prazer de informar que sua solicita��o de transfer�ncia foi realizada com sucesso.'
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
            npcHandler:say('Como quiser. H� algo mais que eu posso fazer por voc�?', cid)
            npcHandler.topic[cid] = 0
        end
        return true
--------------------------------bank-----------------------------------------------
    elseif msgcontains(msg, 'retirar') then
        if string.match(msg,'%d+') then
            count[cid] = getMoneyCount(msg)
            if isValidMoney(count[cid]) then
                npcHandler:say('Tem certeza que deseja retirar ' .. count[cid] .. ' ouro da sua conta banc�ria?', cid)
                npcHandler.topic[cid] = 7
            else
                npcHandler:say('N�o h� ouro suficiente em sua conta.', cid)
                npcHandler.topic[cid] = 0
            end
            return true
        else
            npcHandler:say('Por favor me diga quanto ouro voc� gostaria de sacar.', cid)
            npcHandler.topic[cid] = 6
            return true
        end
    elseif npcHandler.topic[cid] == 6 then
        count[cid] = getMoneyCount(msg)
        if isValidMoney(count[cid]) then
            npcHandler:say('Tem certeza que deseja retirar ' .. count[cid] .. ' ouros da sua conta banc�ria?', cid)
            npcHandler.topic[cid] = 7
        else
            npcHandler:say('N�o h� ouro suficiente em sua conta.', cid)
            npcHandler.topic[cid] = 0
        end
        return true
    elseif npcHandler.topic[cid] == 7 then
        if msgcontains(msg, 'sim') then
            if player:getFreeCapacity() >= getMoneyWeight(count[cid]) then
                if not player:withdrawMoney(count[cid]) then
                    npcHandler:say('N�o h� ouro suficiente em sua conta.', cid)
                else
                    npcHandler:say('Olha Voc� aqui, ' .. count[cid] .. ' ouros. Por favor, deixe-me saber se h� algo mais que eu possa fazer por voc�.', cid)
                end
            else
                npcHandler:say('Uau, espere um pouco, voc� n�o tem espa�o em seu invent�rio para carregar todas aquelas moedas. Eu n�o quero que voc� deixe cair no ch�o, talvez volte com um carrinho!', cid)
            end
            npcHandler.topic[cid] = 0
        elseif msgcontains(msg, 'no') then
            npcHandler:say('O cliente � rei! Volte a qualquer hora que quiser se quiser {retirar} seu dinheiro.', cid)
            npcHandler.topic[cid] = 0
        end
        return true
---------------------------- transfer --------------------
--------------------------------guild bank-----------------------------------------------
    elseif msgcontains(msg, 'transfer�ncia de guilda') then
        if not player:getGuild() then
            npcHandler:say('Sinto muito, mas parece que voc� n�o est� atualmente em nenhuma guilda.', cid)
            npcHandler.topic[cid] = 0
            return false
        elseif player:getGuildLevel() < 2 then
            npcHandler:say('Apenas os l�deres ou vice-l�deres da guilda podem transferir dinheiro da conta da guilda.', cid)
            npcHandler.topic[cid] = 0
            return false
        end
 
        if string.match(msg, '%d+') then
            count[cid] = getMoneyCount(msg)
            if isValidMoney(count[cid]) then
                transfer[cid] = string.match(msg, 'to%s*(.+)$')
                if transfer[cid] then
                    npcHandler:say('Ent�o voc� gostaria de transferir ' .. count[cid] .. ' ouros de sua conta de guilda para guilda ' .. transfer[cid] .. '?', cid)
                    npcHandler.topic[cid] = 28
                else
                    npcHandler:say('Qual guilda voc� gostaria de transferir ' .. count[cid] .. ' ouros?', cid)
                    npcHandler.topic[cid] = 27
                end
            else
                npcHandler:say('N�o h� ouro suficiente na sua conta da guilda.', cid)
                npcHandler.topic[cid] = 0
            end
        else
            npcHandler:say('Por favor, diga-me a quantidade de ouro que voc� gostaria de transferir.', cid)
            npcHandler.topic[cid] = 26
        end
        return true
    elseif npcHandler.topic[cid] == 26 then
        count[cid] = getMoneyCount(msg)
        if player:getGuild():getBankBalance() < count[cid] then
            npcHandler:say('N�o h� ouro suficiente na sua conta da guilda.', cid)
            npcHandler.topic[cid] = 0
            return true
        end
        if isValidMoney(count[cid]) then
            npcHandler:say('Qual guilda voc� gostaria de transferir ' .. count[cid] .. ' ouros?', cid)
            npcHandler.topic[cid] = 27
        else
            npcHandler:say('N�o h� ouro suficiente na sua conta.', cid)
            npcHandler.topic[cid] = 0
        end
        return true
    elseif npcHandler.topic[cid] == 27 then
        transfer[cid] = msg
        if player:getGuild():getName() == transfer[cid] then
            npcHandler:say('Preencha este campo com a pessoa que receber� seu ouro!', cid)
            npcHandler.topic[cid] = 0
            return true
        end
        npcHandler:say('Ent�o voc� gostaria de transferir ' .. count[cid] .. ' ouro de sua conta de guilda para guilda' .. transfer[cid] .. '?', cid)
        npcHandler.topic[cid] = 28
        return true
    elseif npcHandler.topic[cid] == 28 then
        if msgcontains(msg, 'sim') then
            npcHandler:say('Fizemos um pedido de transfer�ncia ' .. count[cid] .. ' ouro de sua conta de guilda para guilda ' .. transfer[cid] .. '. Verifique sua caixa de entrada para confirma��o.', cid)
            local guild = player:getGuild()
            local balance = guild:getBankBalance()
            local info = {
                type = 'Guild to Guild Transfer',
                amount = count[cid],
                owner = player:getName() .. ' of ' .. guild:getName(),
                recipient = transfer[cid]
            }
            if balance < tonumber(count[cid]) then
                info.message = 'Lamentamos inform�-lo de que n�o pudemos atender ao seu pedido, devido � falta do valor necess�rio na conta da sua guilda.'
                info.success = false
                local inbox = player:getInbox()
                local receipt = getReceipt(info)
                inbox:addItemEx(receipt, INDEX_WHEREEVER, FLAG_NOLIMIT)
            else
                getGuildIdByName(transfer[cid], transferFactory(player:getName(), tonumber(count[cid]), guild:getId(), info))                  
            end
            npcHandler.topic[cid] = 0
        elseif msgcontains(msg, 'n�o') then
            npcHandler:say('Certo, h� algo mais que eu possa fazer por voc�?', cid)
        end
        npcHandler.topic[cid] = 0
--------------------------------guild bank-----------------------------------------------
    elseif msgcontains(msg, 'transferir') then
        npcHandler:say('Por favor, diga-me a quantidade de ouro que voc� gostaria de transferir.', cid)
        npcHandler.topic[cid] = 11
    elseif npcHandler.topic[cid] == 11 then
        count[cid] = getMoneyCount(msg)
        if player:getBankBalance() < count[cid] then
            npcHandler:say('N�o h� ouro suficiente em sua conta.', cid)
            npcHandler.topic[cid] = 0
            return true
        end
        if isValidMoney(count[cid]) then
            npcHandler:say('Quem voc� gostaria de transferir ' .. count[cid] .. ' ouros?', cid)
            npcHandler.topic[cid] = 12
        else
            npcHandler:say('N�o h� ouro suficiente em sua conta.', cid)
            npcHandler.topic[cid] = 0
        end
    elseif npcHandler.topic[cid] == 12 then
        transfer[cid] = msg
        if player:getName() == transfer[cid] then
            npcHandler:say('Preencha este campo com a pessoa que receber� seu ouro!', cid)
            npcHandler.topic[cid] = 0
            return true
        end
        if playerExists(transfer[cid]) then
		  local arrayDenied = {"accountmanager", "rooksample", "druidsample", "sorcerersample", "knightsample", "paladinsample"}
		    if isInArray(arrayDenied, string.gsub(transfer[cid]:lower(), " ", "")) then
                npcHandler:say('Este jogador n�o existe.', cid)
                npcHandler.topic[cid] = 0
                return true
            end
            npcHandler:say('Ent�o voc� gostaria de transferir ' .. count[cid] .. ' ouros para ' .. transfer[cid] .. '?', cid)
            npcHandler.topic[cid] = 13
        else
            npcHandler:say('Este jogador n�o existe.', cid)
            npcHandler.topic[cid] = 0
        end
    elseif npcHandler.topic[cid] == 13 then
        if msgcontains(msg, 'sim') then
            if not player:transferMoneyTo(transfer[cid], count[cid]) then
                npcHandler:say('Voc� n�o pode transferir dinheiro para esta conta.', cid)
            else
                npcHandler:say('Muito bem. Voc� transferiu ' .. count[cid] .. ' ouros para ' .. transfer[cid] ..'.', cid)
                transfer[cid] = nil
            end
        elseif msgcontains(msg, 'n�o') then
            npcHandler:say('Certo, h� algo mais que eu possa fazer por voc�?', cid)
        end
        npcHandler.topic[cid] = 0
---------------------------- money exchange --------------
    elseif msgcontains(msg, 'trocar bronze') then
        npcHandler:say('Quantas moedas de prata voc� gostaria de obter?', cid)
        npcHandler.topic[cid] = 14
    elseif npcHandler.topic[cid] == 14 then
        if getMoneyCount(msg) < 1 then
            npcHandler:say('Desculpe, voc� n�o tem moedas de ouro suficientes.', cid)
            npcHandler.topic[cid] = 0
        else
            count[cid] = getMoneyCount(msg)
            npcHandler:say('Ent�o voc� gostaria que eu mudasse ' .. count[cid] * 100 .. ' de suas moedas de ouro em ' .. count[cid] .. ' moedas de prata?', cid)
            npcHandler.topic[cid] = 15
        end
    elseif npcHandler.topic[cid] == 15 then
        if msgcontains(msg, 'sim') then
            if player:removeItem(2148, count[cid] * 100) then
                player:addItem(2152, count[cid])
                npcHandler:say('Pronto amigo!.', cid)
            else
                npcHandler:say('Desculpe, voc� n�o tem moedas de ouro suficientes.', cid)
            end
        else
            npcHandler:say('Bem, posso te ajudar com outra coisa?', cid)
        end
        npcHandler.topic[cid] = 0
    elseif msgcontains(msg, 'trocar prata') then
        npcHandler:say('Voc� gostaria de transformar suas moedas de prata em {bronze} ou {ouro}?', cid)
        npcHandler.topic[cid] = 16
    elseif npcHandler.topic[cid] == 16 then
        if msgcontains(msg, 'bronze') then
            npcHandler:say('Quantas moedas de prata voc� gostaria de transformar em bronze?', cid)
            npcHandler.topic[cid] = 17
        elseif msgcontains(msg, 'ouro') then
            npcHandler:say('Quantas moedas de ouro voc� gostaria de obter?', cid)
            npcHandler.topic[cid] = 19
        else
            npcHandler:say('Bem, posso te ajudar com outra coisa?', cid)
            npcHandler.topic[cid] = 0
        end
    elseif npcHandler.topic[cid] == 17 then
        if getMoneyCount(msg) < 1 then
            npcHandler:say('Desculpe, voc� n�o tem moedas de prata suficientes.', cid)
            npcHandler.topic[cid] = 0
        else
            count[cid] = getMoneyCount(msg)
            npcHandler:say('Ent�o voc� gostaria que eu mudasse ' .. count[cid] .. ' de suas moedas de prata em ' .. count[cid] * 100 .. ' moedas de bronze para voc�?', cid)
            npcHandler.topic[cid] = 18
        end
    elseif npcHandler.topic[cid] == 18 then
        if msgcontains(msg, 'sim') then
            if player:removeItem(2152, count[cid]) then
                player:addItem(2148, count[cid] * 100)
                npcHandler:say('Tome aqui.', cid)
            else
                npcHandler:say('Desculpe, voc� n�o tem moedas de prata suficientes.', cid)
            end
        else
            npcHandler:say('Bem, posso te ajudar com outra coisa?', cid)
        end
        npcHandler.topic[cid] = 0
    elseif npcHandler.topic[cid] == 19 then
        if getMoneyCount(msg) < 1 then
            npcHandler:say('Desculpe, voc� n�o tem moedas de prata suficientes.', cid)
            npcHandler.topic[cid] = 0
        else
            count[cid] = getMoneyCount(msg)
            npcHandler:say('Ent�o voc� gostaria que eu mudasse ' .. count[cid] * 100 .. ' de suas moedas de prata em ' .. count[cid] .. ' moedas de ouro para voc�?', cid)
            npcHandler.topic[cid] = 20
        end
    elseif npcHandler.topic[cid] == 20 then
        if msgcontains(msg, 'sim') then
            if player:removeItem(2152, count[cid] * 100) then
                player:addItem(2160, count[cid])
                npcHandler:say('Tome aqui.', cid)
            else
                npcHandler:say('Desculpe, voc� n�o tem moedas de prata suficientes.', cid)
            end
        else
            npcHandler:say('Bem, posso te ajudar com outra coisa?', cid)
        end
        npcHandler.topic[cid] = 0
    elseif msgcontains(msg, 'trocar ouro') then
        npcHandler:say('Quantas moedas de ouro voc� gostaria de transformar em prata?', cid)
        npcHandler.topic[cid] = 21
    elseif npcHandler.topic[cid] == 21 then
        if getMoneyCount(msg) < 1 then
            npcHandler:say('Desculpe, voc� n�o tem moedas de ouro suficientes.', cid)
            npcHandler.topic[cid] = 0
        else
            count[cid] = getMoneyCount(msg)
            npcHandler:say('Ent�o voc� gostaria que eu mudasse ' .. count[cid] .. ' de suas moedas de ouro em ' .. count[cid] * 100 .. ' moedas de prata para voc�?', cid)
            npcHandler.topic[cid] = 22
        end
    elseif npcHandler.topic[cid] == 22 then
        if msgcontains(msg, 'sim') then
            if player:removeItem(2160, count[cid]) then
                player:addItem(2152, count[cid] * 100)
                npcHandler:say('Aqui est�.', cid)
            else
                npcHandler:say('Desculpe, voc� n�o tem moedas de ouro suficientes.', cid)
            end
        else
            npcHandler:say('Bem, posso te ajudar com outra coisa?', cid)
        end
        npcHandler.topic[cid] = 0
    end
    return true
end
 
keywordHandler:addKeyword({'dinheiro'}, StdModule.say, {npcHandler = npcHandler, text = 'Podemos {mudar} dinheiro para voc�. Voc� tamb�m pode acessar sua {conta do banco}.'})
keywordHandler:addKeyword({'como trocar'}, StdModule.say, {npcHandler = npcHandler, text = 'Existem tr�s tipos diferentes de moedas no Ursulla: 100 moedas de ouro equivalem a 1 moeda de platina, 100 moedas de platina equivalem a 1 moeda de cristal. Portanto, se voc� deseja transformar 100 moedas de bronze em 1 moeda de prata, basta dizer \'{trocar bronze}\' e depois \'1 de prata \'.'})
keywordHandler:addKeyword({'banco'}, StdModule.say, {npcHandler = npcHandler, text = 'Podemos te explicar {como trocar} dinheiro, voc� tamb�m pode acessar sua {conta do banco}.'})
keywordHandler:addKeyword({'avan�ado'}, StdModule.say, {npcHandler = npcHandler, text = 'Sua conta banc�ria ser� usada automaticamente quando voc� quiser {alugar} uma casa ou fazer uma oferta em um item no {mercado}. Deixe-me saber se voc� deseja saber como funciona.'})
keywordHandler:addKeyword({'ajuda'}, StdModule.say, {npcHandler = npcHandler, text = 'Voc� pode verificar o {saldo} de sua conta banc�ria, {depositar} dinheiro ou {retirar}. Voc� tamb�m pode {transferir} dinheiro para outros personagens, desde que eles tenham uma voca��o, voc� tambem pode saber {como trocar}, e usar {comandos de guilda}'})
keywordHandler:addKeyword({'fun��es'}, StdModule.say, {npcHandler = npcHandler, text = 'Voc� pode verificar o {saldo} de sua conta banc�ria, {depositar} dinheiro ou {retirar}. Voc� tamb�m pode {transferir} dinheiro para outros personagens, desde que eles tenham uma voca��o.'})
keywordHandler:addKeyword({'basico'}, StdModule.say, {npcHandler = npcHandler, text = 'Voc� pode verificar o {saldo} de sua conta banc�ria, {depositar} dinheiro ou {retirar}. Voc� tamb�m pode {transferir} dinheiro para outros personagens, desde que eles tenham uma voca��o.'})
keywordHandler:addKeyword({'trabalho'}, StdModule.say, {npcHandler = npcHandler, text = 'Eu trabalho neste banco, posso trocar dinheiro para voc� e ajud�-lo com sua conta banc�ria.'})
keywordHandler:addKeyword({'comandos de guilda'}, StdModule.say, {npcHandler = npcHandler, text = 'Voce pode ver o {saldo da guilda}, tambem pode fazer {deposito de guilda} ou fazer {transfer�ncia de guilda}, por ultimo {transfer�ncia de guilda}!'})
 
npcHandler:setMessage(MESSAGE_GREET, "Sim? O que posso fazer por voc�, |PLAYERNAME|? Neg�cios banc�rios, talvez? {ajuda}")
npcHandler:setMessage(MESSAGE_FAREWELL, "Tenha um bom dia.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Tenha um bom dia.")
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = -1 -- edite a ordem do npc
local storage = 20016
local t = {
[1] = {keyword = "academia", text = "para entrar na academia você precisa se registrar por 5000 moedas de bronze, você deseja se {escrever}? "}, -- palavra-chave, texto
[2] = {keyword = "escrever", text = "Obrigado por se escrever?"},
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
			if getPlayerStorageValue(cid, storage) == npcOrder + 1 then
				doTeleportThing(cid, {x = 1251, y = 892, z = 4})	
                npcHandler:releaseFocus(cid)				
            elseif (getPlayerStorageValue(cid, storage) == npcOrder) then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá "..getPlayerName(cid).."! Voce deseja entrar na {academia} da cidade de groter?", cid)
                talkState[talkUser] = 1
            else
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid).."! Talvez possamos conversar outra hora...", cid)
                talkState[talkUser] = 0
                npcHandler:releaseFocus(cid)
            end
        else
            return false
        end    
    elseif t[talkState[talkUser]] and msgcontains(msg, t[talkState[talkUser]].keyword) then
            npcHandler:say(t[talkState[talkUser]].text, cid)
            if (talkState[talkUser] == #t) and (getPlayerMoney(cid)>=5000) and (getPlayerLevel(cid)>=8) then
			    doPlayerRemoveMoney(cid, 10)
				doTeleportThing(cid, {x = 1251, y = 892, z = 4})
				talkState[talkUser] = 0
				npcHandler:say("Boa sorte na dungeon!!", cid)
				setPlayerStorageValue(cid, storage, npcOrder+1)
			elseif 	(getPlayerMoney(cid)<10) or (getPlayerLevel(cid)<8) then
			npcHandler:say("Você não tem os requisitos minimos para entrar na dungeon!", cid)
            else
                talkState[talkUser] = talkState[talkUser] + 1
            end
    elseif msgcontains(msg, "bye","tchau") then
        npcHandler:say("Tchau!", cid)
        talkState[talkUser] = 0
        npcHandler:releaseFocus(cid)
    else
        npcHandler:say("O que?", cid)
    end
    return true
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

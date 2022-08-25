
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = 36 -- edite a ordem do npc
local storage = 20000
local t = {
[1] = {keyword = "academia", text = "Para entrar voce precisa estar cadastrado, você deseja se {cadastrar}, São 1000 ouros! "}, -- palavra-chave, texto
[2] = {keyword = "cadastrar", text = "Obrigado!"},
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
		    if (getPlayerStorageValue(cid, storage) >= 37) then
			    npcHandler:say("Olá "..getPlayerName(cid).."! Pode entrar!!", cid)
				doTeleportThing(cid, {x = 1251, y = 892, z = 4})
				npcHandler:releaseFocus(cid)
            elseif (getPlayerStorageValue(cid, storage) == npcOrder) then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá "..getPlayerName(cid).."! Voce deseja entrar na {academia} da cidade de brain?!", cid)
                talkState[talkUser] = 1
            else
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid).."! A cidade está um caos, não é hora para isso!", cid)
                talkState[talkUser] = 0
                npcHandler:releaseFocus(cid)
            end
        else
            return false
        end    
    elseif t[talkState[talkUser]] and msgcontains(msg, t[talkState[talkUser]].keyword) then
            npcHandler:say(t[talkState[talkUser]].text, cid)
            if (talkState[talkUser] == #t) and (getPlayerMoney(cid)>=1000) then
			    doPlayerRemoveMoney(cid, 1000)
				setPlayerStorageValue(cid, storage, npcOrder + 1)
				talkState[talkUser] = 0
				npcHandler:say("Você está cadastrado agora!", cid)
				npcHandler:releaseFocus(cid)
			elseif 	(getPlayerMoney(cid)<1000) then
			npcHandler:say("Você não tem dinheiro!", cid)
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

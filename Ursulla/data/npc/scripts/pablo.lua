
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = -1 -- edite a ordem do npc
local storage = 25005
local t = {
[1] = {keyword = "lobos", text = "Se você me {ajudar} eu posso te recompensar com roupas do grupo: {hunter}"}, -- palavra-chave, texto
[2] = {keyword = "ajudar", text = "Me traga: {15} wolf paws! para provar que você matou os lobos"}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
			if not isHuman(Player(cid)) then 
			npcHandler:say("Saia elfo!!", cid)
			npcHandler:releaseFocus(cid)	
		    elseif (getPlayerStorageValue(cid, storage) == 0) and getPlayerItemCount(cid, 5897) >= 15 then
			doPlayerRemoveItem(cid, 5897, 15)
			doPlayerAddOutfit(cid, 129, 0)
			doPlayerAddOutfit(cid, 137, 0)
			setPlayerStorageValue(cid, storage, 1)
			npcHandler:say("É um alivio!!", cid)
			npcHandler:releaseFocus(cid)			
			elseif (getPlayerStorageValue(cid, storage) == 1) then
			npcHandler:say("Agora me traga: {50}  green piece of cloth!", cid)
			setPlayerStorageValue(cid, storage, 2)
			elseif (getPlayerStorageValue(cid, storage) == 2) and getPlayerItemCount(cid, 5910) >= 50 then
			doPlayerRemoveItem(cid, 5910, 50)
			npcHandler:say("Obrigado por isso!!", cid)
			setPlayerStorageValue(cid, storage, 3)
			doPlayerAddOutfit(cid, 129, 1)
			doPlayerAddOutfit(cid, 137, 1)
			elseif (getPlayerStorageValue(cid, storage) == 3) then
			npcHandler:say("Agora me traga: {50}  green piece of cloth e {50} wolf paws!", cid)		
			setPlayerStorageValue(cid, storage, 4)			
			elseif (getPlayerStorageValue(cid, storage) == 4) and getPlayerItemCount(cid, 5910) >= 50 and getPlayerItemCount(cid, 5897) >= 50 then
			doPlayerRemoveItem(cid, 5910, 50)
			doPlayerRemoveItem(cid, 5897, 50)
			npcHandler:say("Você foi extremamente util para mim!", cid)
			setPlayerStorageValue(cid, storage, 5)
			doPlayerAddOutfit(cid, 129, 2)
			doPlayerAddOutfit(cid, 137, 2)			
            elseif (getPlayerStorageValue(cid, storage) == npcOrder) then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid).."! Eu moro aqui nessa casa, tem tido ataques constantes nessa area por {lobos}...", cid)
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
            if talkState[talkUser] == #t then
                setPlayerStorageValue(cid, storage, npcOrder + 1)
                talkState[talkUser] = 0
				npcHandler:releaseFocus(cid)
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

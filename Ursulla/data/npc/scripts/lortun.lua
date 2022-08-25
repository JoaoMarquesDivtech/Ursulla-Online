
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = -1 -- edite a ordem do npc
local storage = 25002
local t = {
[1] = {keyword = "ajudar", text = "Eu posso te recompensar com roupas do grupo: {knight}"}, -- palavra-chave, texto
[2] = {keyword = "knight", text = "Sim, mas só se você trazer o que eu {preciso}!"},
[3] = {keyword = "preciso", text = "Me traga: {1} sword"}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
		    if isElf(Player(cid)) then 
			npcHandler:say("Saia elfo!!", cid)
			npcHandler:releaseFocus(cid)	
		    elseif (getPlayerStorageValue(cid, storage) == 0) and getPlayerItemCount(cid, 2376) >= 1 then
				doPlayerRemoveItem(cid, 2376, 1)
				doPlayerAddOutfit(cid, 131, 0)
				doPlayerAddOutfit(cid, 139, 0)
				setPlayerStorageValue(cid, storage, 1)
				npcHandler:say("Obrigado!", cid)
			elseif (getPlayerStorageValue(cid, storage) == 1) then
				npcHandler:say("Agora me traga: {1} goblin helmet e {50} honeycombs!", cid)
				setPlayerStorageValue(cid, storage, 2)
			elseif (getPlayerStorageValue(cid, storage) == 2) and getPlayerItemCount(cid, 26410) >= 1 and getPlayerItemCount(cid, 5902) >= 50 then
				doPlayerRemoveItem(cid, 5902, 50)
				doPlayerRemoveItem(cid, 26410, 1)
				setPlayerStorageValue(cid, storage, 3)
				doPlayerAddOutfit(cid, 131, 1)
				doPlayerAddOutfit(cid, 139, 1)
				npcHandler:say("Obrigado!!!", cid)		
				npcHandler:releaseFocus(cid)			
			elseif (getPlayerStorageValue(cid, storage) == 3) then
			npcHandler:say("Agora me traga: {100} wolf paws e {50} honeycombs!", cid)
			setPlayerStorageValue(cid, storage, 4)			
			elseif (getPlayerStorageValue(cid, storage) == 4) and getPlayerItemCount(cid, 5897) >= 100 and getPlayerItemCount(cid, 5902) >= 50 then
			doPlayerRemoveItem(cid, 5897, 100)
			doPlayerRemoveItem(cid, 5902, 50)
			setPlayerStorageValue(cid, storage, 3)
			doPlayerAddOutfit(cid, 131, 2)
			doPlayerAddOutfit(cid, 139, 2)	
            npcHandler:say("Obrigado!!!!", cid)		
			npcHandler:releaseFocus(cid)			
            elseif (getPlayerStorageValue(cid, storage) == npcOrder) then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid).."! Eu sou um guarda desse castelo! você quer me {ajudar} em uma coisa?", cid)
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

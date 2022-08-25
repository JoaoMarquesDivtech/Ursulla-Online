
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = -1 -- edite a ordem do npc
local storage = 25003
local t = {
[1] = {keyword = "ajudar", text = "Eu posso te recompensar com roupas do grupo: {nightmare}"}, -- palavra-chave, texto
[2] = {keyword = "nightmare", text = "Sim, mas só se você trazer o que eu {preciso}!"},
[3] = {keyword = "preciso", text = "Me traga: {25} white piece of cloth e 10 {coal} "}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
		    if isElf(Player(cid)) then 
			npcHandler:say("Saia elfo!!", cid)
			npcHandler:releaseFocus(cid)	
		    elseif (getPlayerStorageValue(cid, storage) == 0) and getPlayerItemCount(cid, 5909) >= 25 and getPlayerItemCount(cid, 13757)>=10 then
			doPlayerRemoveItem(cid, 5909, 1)
			doPlayerRemoveItem(cid, 13757, 1)
			doPlayerAddOutfit(cid, 268, 0)
			doPlayerAddOutfit(cid, 269, 0)
			setPlayerStorageValue(cid, storage, 1)
			npcHandler:say("Obrigado!", cid)
			elseif (getPlayerStorageValue(cid, storage) == 1) then
			npcHandler:say("Agora me traga: {40} tarantula egg e {50} honeycombs!", cid)
			setPlayerStorageValue(cid, storage, 2)
			elseif (getPlayerStorageValue(cid, storage) == 2) and getPlayerItemCount(cid, 11198) >= 40 and getPlayerItemCount(cid, 5902) >= 50 then
			doPlayerRemoveItem(cid, 5902, 50)
			doPlayerRemoveItem(cid, 11198, 40)
			setPlayerStorageValue(cid, storage, 3)
			doPlayerAddOutfit(cid, 268, 1)
			doPlayerAddOutfit(cid, 269, 1)
            npcHandler:say("Obrigado!!!", cid)		
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

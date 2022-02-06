
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = -1 -- edite a ordem do npc
local storage = 25000
local t = {
[1] = {keyword = "quer", text = "Eu posso te recompensar com roupas do grupo: {citizen}"}, -- palavra-chave, texto
[2] = {keyword = "citizen", text = "Sim, mas só se você trazer o que eu {preciso}!"},
[3] = {keyword = "preciso", text = "Me traga : {35} white piece of cloth e {30} tusk"}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
		    if not isElf(Player(cid)) then 
			npcHandler:say("Saia daqui, sua raça é diferente da minha!!", cid)
			npcHandler:releaseFocus(cid)	
		    elseif (getPlayerStorageValue(cid, storage) == 0) and getPlayerItemCount(cid, 5810) >= 35 and getPlayerItemCount(cid, 3956) >=30 then
			doPlayerRemoveItem(cid, 5810, 35)
			doPlayerRemoveItem(cid, 3956, 30)
			doPlayerAddOutfit(cid, 922, 1)
			doPlayerAddOutfit(cid, 923, 1)
			setPlayerStorageValue(cid, storage, 1)
			npcHandler:say("Obrigado!", cid)
            elseif (getPlayerStorageValue(cid, storage) == npcOrder) then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid).."! Eu posso fazer seu cajado, você {quer}?", cid)
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

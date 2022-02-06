
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = 2 -- edite a ordem do npc
local storage = 20001
local t = {
[1] = {keyword = "preparar", text = "Eu vou te dar um livro de magias, O livro de {magias} contém todas as magias que você pode usar no momento, tambem te darei um item que combina com sua classe."}, 
[2] = {keyword = "magias", text = "Você inicia com uma magia inicial, as outras magias você consegue usando pedra de monstros que normalmente são encontradas nas dungeons, a dungeon mais proxima fica no pais de Gringard, um pais humano! {entendido}?"}, 
[3] = {keyword = "entendido", text = "Nós temos paz com o pais de Gringard! Enfim tome isto e procure o Tony para ele te encaminhar!"} 
}
local classe = {
[1] = {id = 2397},
[2] = {id = 2398},
[3] = {id = 23719},
[4] = {id = 23721},
[5] = {id = 2403},
[6] = {id = 2389},
[17] = {id = 2071}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) == npcOrder) or getPlayerStorageValue(cid, storage) == npcOrder then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid).."! O Brint te enviou aqui para eu te {preparar} né?", cid)
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
				doPlayerAddItem(cid, classe[getPlayerVocation(cid)].id, 1)
				doPlayerAddItem(cid, 2175, 1)
                talkState[talkUser] = 0
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

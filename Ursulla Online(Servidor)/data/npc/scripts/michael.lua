
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = 15 -- edite a ordem do npc
local storage = 20000
local t = {
[1] = {keyword = "dizer", text = "Entendo! mas essa informa��o � velha aqui, eu vou te informar de tudo, voce esta disposto a {ajudar} a salvar vidas de pessoa inocente evitando esse colapso?"}, -- palavra-chave, texto
[2] = {keyword = "ajudar", text = "Existe uma gangue chamada bisel, uma gangue do submundo ilegal, e ela cresceu muito economicamente nas ultimas decadas, mas com esse poder todo o lider da gangue deduziu que o poder da gangue est� mais {poderosa} que a for�a militar da cidade de Groter, assim ele iniciou uma guerra civil...!"},
[3] = {keyword = "poderosa", text = "Eu sou um grande amigo do Kai faz tempos, Eu vou te mandar para um... um amigo, ele se encontra em um restaurante aqui no subsolo de Groter mesmo, o nome dele � Milhe!!"}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) == npcOrder) or getPlayerStorageValue(cid, storage) == npcOrder then
                npcHandler:addFocus(cid)
                npcHandler:say("Hm! O Kai te mandou aqui para {dizer} oque?", cid)
                talkState[talkUser] = 1
            else
                npcHandler:addFocus(cid)
                npcHandler:say("Ol�, "..getPlayerName(cid).."! Talvez possamos conversar outra hora...", cid)
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


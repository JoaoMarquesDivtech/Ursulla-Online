
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = 6 -- edite a ordem do npc
local storage = 20001
local t = {
[1] = {keyword = "ensinar", text = "Existem os paises, cada pais tem uma {raça} domintante, O nosso pais é chamado de Driad, e O pais de Driad é dominado por elfos!"}, -- palavra-chave, texto
[2] = {keyword = "raça", text = "Existem diversas raças neste mundo, se acostume! mas não se assuste! o pais mais proximo do nosso é o pais de Gringard e é um pais humano, os elfos da floresta e os humanos não possui nem um {conflito}!"},
[3] = {keyword = "conflito", text = "Acontece de {paises} terem richas, por exemplo os elfos não se dão muito bem com os anões e nem com os orcs!"},
[4] = {keyword = "paises", text = "Se acostume com essas regras, pois é muito importante! Falando nisso você pode ir para Gringard a qualquer momento, vá de barco ou andando, a caminhada é longe! tudo {ok}?"},
[5] = {keyword = "ok", text = "Agora que você entendeu, vá até o nosso mago, o Paul!"}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) == npcOrder) then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid).."! Eu sinto que devo te {ensinar} o senso comum deste mundo..", cid)
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
            else
                talkState[talkUser] = talkState[talkUser] + 1
            end
    elseif msgcontains(msg, "bye","tchau") then
        npcHandler:say("Tchau!", cid)
        talkState[talkUser] = 0
        npcHandler:releaseFocus(cid)
    else
        npcHandler:say("Não entendi..", cid)
    end
    return true
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

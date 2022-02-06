
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = 14 -- edite a ordem do npc
local storage = 20000
local t = {
[1] = {keyword = "feitos", text = "Na {cidade} da onde eu venho não existe o cáos que nem ocorre aqui em Groter ou em Brain!"}, -- palavra-chave, texto
[2] = {keyword = "cidade", text = "A cidade de Norton é a cidade da calma, pois só permitem {escolhidos} para entrar lá, tambem é conhecida como cidade dos druidas!"},
[3] = {keyword = "escolhidos", text = "Pela sua determinação aqui em Groter da para ver que você é uma pessoa que só quer ver o bem da cidade! Vá para Norton! Eu te dei a aura de um escolhido!"}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) >= npcOrder and getPlayerStorageValue(cid, 20007) == -1) then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid).."! Aqueles {feitos} la em Brain, Foi você não foi??", cid)
                talkState[talkUser] = 1
            else
                npcHandler:addFocus(cid)
                npcHandler:say("Está tudo uma confusão, Fale comigo quando as coisas tiverem mais calmas!!", cid)
                talkState[talkUser] = 0
                npcHandler:releaseFocus(cid)
            end
        else
            return false
        end    
    elseif t[talkState[talkUser]] and msgcontains(msg, t[talkState[talkUser]].keyword) then
            npcHandler:say(t[talkState[talkUser]].text, cid)
            if talkState[talkUser] == #t then
                setPlayerStorageValue(cid, 20007, 0)
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


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
[1] = {keyword = "feitos", text = "Na {cidade} da onde eu venho n�o existe o c�os que nem ocorre aqui em Groter ou em Brain!"}, -- palavra-chave, texto
[2] = {keyword = "cidade", text = "A cidade de Norton � a cidade da calma, pois s� permitem {escolhidos} para entrar l�, tambem � conhecida como cidade dos druidas!"},
[3] = {keyword = "escolhidos", text = "Pela sua determina��o aqui em Groter da para ver que voc� � uma pessoa que s� quer ver o bem da cidade! V� para Norton! Eu te dei a aura de um escolhido!"}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) >= npcOrder and getPlayerStorageValue(cid, 20007) == -1) then
                npcHandler:addFocus(cid)
                npcHandler:say("Ol�, "..getPlayerName(cid).."! Aqueles {feitos} la em Brain, Foi voc� n�o foi??", cid)
                talkState[talkUser] = 1
            else
                npcHandler:addFocus(cid)
                npcHandler:say("Est� tudo uma confus�o, Fale comigo quando as coisas tiverem mais calmas!!", cid)
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
        npcHandler:say("N�o entendi..", cid)
    end
    return true
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

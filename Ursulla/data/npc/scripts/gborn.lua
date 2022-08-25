local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = 0 -- edite a ordem do npc
local storage = 20001
local t = {
[1] = {keyword = "elfo", text = "Os elfos da floresta são mais rapidos e tem mais destreza, porem você sabe que pode {focar} em outras coisas como ser forte ou ter mais afinidade com a magia! os elfos da floresta não podemos ser ladrões nem se especializar em algumas sub-classes de guerreiro!"}, -- palavra-chave, texto
[2] = {keyword = "focar", text = "A forma de decidir como você vai ser neste mundo é usado os comandos !points e !pointcheck, use para decidir o que você vai ser, {ok}?"}, 
[3] = {keyword = "ok", text = "Agora vá até o Brint, aproveite e explore a cidade de dryadalis, o brint está na area de treinamento, procure-o!"}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) <= 0)  then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid).."!, eu sou o gborn, fico contente por receber mais um {elfo} da floresta", cid)
                talkState[talkUser] = 1
			else 
			    npcHandler:say("Você está fazendo o que aqui?", cid)
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

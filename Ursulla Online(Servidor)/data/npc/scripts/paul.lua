
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = 7 -- edite a ordem do npc
local storage = 20001
local t = {
[1] = {keyword = "diretriz", text = "Existem torres dos magos, temos uma torre de mago aqui em Dryadalis, porem nós elfos da floresta usamos as torres de Gringard ja que os humanos tem mais habilidade na magia! se acostume pois você sempre estara indo lá e escolhendo sua {build} de magias!"}, -- palavra-chave, texto
[2] = {keyword = "build", text = "Voce que escolhe qual magias você vai ter, sendo no maximo 8 magias, existem pedras magicas que aumentam esse limite mas eu nunca vi uma de perto! Voce quer {começar}?"},
[3] = {keyword = "começar", text = "Mas antes me traga 1 moeda de prata, para liberar sua sub-classe!"}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) == npcOrder) or getPlayerStorageValue(cid, storage) == npcOrder then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid).."! Então o bill te mandou aqui? eu que irei te dar a {diretriz} da sua classe!", cid)
                talkState[talkUser] = 1
			elseif (getPlayerStorageValue(cid, storage) == npcOrder+1) and getPlayerMoney(cid)>=100 then
			    doPlayerRemoveMoney(cid, 100)
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid)..", Vá la em baixo e fale com o Cris! ele te levará ao especialista da sua classe para você fazer sua escolha!", cid)
				setPlayerStorageValue(cid, storage, 9)
				doPlayerAddExp(cid, 2000)
                talkState[talkUser] = 1	
            else
                npcHandler:addFocus(cid)
                npcHandler:say("Esta fazendo o que?", cid)
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

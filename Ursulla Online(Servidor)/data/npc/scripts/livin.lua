
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = 17 -- edite a ordem do npc
local storage = 20000
local t = {
[1] = {keyword = "poder", text = "Eu não queria te pedir isso mas para começar voce tera que fazer uns trabalhos {sujos}! após isso eu te levarei na base da familia bisel para conhecer todos!"}, -- palavra-chave, texto
[2] = {keyword = "sujos", text = "Eu venho fazendo que os mensageiros de Brain não voltem para a cidade de brain para informar o que esta acontecendo aqui e assim conseguir {poderio} militar para a cidade de Groter!"},
[3] = {keyword = "poderio", text = "Sim! isso dificutaria todo o trabalho que estamos fazendo aqui, então eu peço que voce volte até a cidade de Brain e informe ao Lorde Kai que esta tudo bem ja que eles confiam em você, após isso volte aqui!!"}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) == npcOrder) or getPlayerStorageValue(cid, storage) == npcOrder then
                npcHandler:addFocus(cid)
                npcHandler:say("O milhe, te mandou aqui? eu faço parte da familia bisel, e seria otimo se você como um aventureiro nos ajudasse a tomar o {poder} da cidade! A familia bisel só vai progredir esta cidade mais e mais!", cid)
                talkState[talkUser] = 1
			elseif (getPlayerStorageValue(cid, storage) == 19) then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid)..", Você fez tudo perfeitamente! A base fica aqui mesmo no subsolo, fica abaixo do abatedouro! vá e fale com o representante da familia bisel, ele se chama {Drake}!", cid)
				doPlayerAddExp(cid, 3000)
				setPlayerStorageValue(cid, storage, 20)
                talkState[talkUser] = 0
				npcHandler:releaseFocus(cid)	
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
        npcHandler:say("O que?", cid)
    end
    return true
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)


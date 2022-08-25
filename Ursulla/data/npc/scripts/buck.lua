
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = 23 -- edite a ordem do npc
local storage = 20000
local t = {
[1] = {keyword = "falar", text = "Isso � urgente, teremos que assassinar esse general antes que {ele} entregue a localiza��o da nossa base!"}, -- palavra-chave, texto
[2] = {keyword = "ele", text = "Oh! voc� devia ter perguntado ao misael a localiza��o desse general, voc� t�ra que falar com o misael e saber onde est� esse general, eu estou confiando a nossa {causa} a voc�!"},
[3] = {keyword = "causa", text = "Obrigado por tudo que voce esta fazendo, nossos assassinos est�o todos ocupados e eu terei que pedir isso a voc�!"}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) == npcOrder) or getPlayerStorageValue(cid, storage) == npcOrder then
                npcHandler:addFocus(cid)
                npcHandler:say("Ola eu sou o lider da familia Bisel, Voce tem algo para me {falar}?! ", cid)
                talkState[talkUser] = 1
			elseif (getPlayerStorageValue(cid, storage) == 21) then
                npcHandler:addFocus(cid)
                npcHandler:say("Ah n�o! Se for isso teremos que atacar antes! Fale com o nosso lider urgente! o nome do lider da familia bisel se chama Buck, v� at� ele urgente, se tiver vivo ap�s isso venha para eu conversar com voc�!", cid)
				setPlayerStorageValue(cid, storage, 22)
                talkState[talkUser] = 0
				npcHandler:releaseFocus(cid)	
			elseif (getPlayerStorageValue(cid, storage) == 24) then
			    doPlayerAddExp(cid, 20000)
				npcHandler:say("N�s seremos eternamente gratos a voc�, Obrigado por tudo que voce fez!", cid)
				setPlayerStorageValue(cid, storage, 25)
				npcHandler:releaseFocus(cid)
			elseif (getPlayerStorageValue(cid, storage) == 26) then
			    doPlayerAddExp(cid, 20000)
				npcHandler:say("Voc� � incrivel, agora dominamos a cidade, como recompensa eu estou liberando a academia de Groter para voc�! V� se cadastrar com o gerente, seja l� quem for!", cid)
				setPlayerStorageValue(cid, storage, 36)
				npcHandler:releaseFocus(cid)	
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



local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = 9 -- edite a ordem do npc
local storage = 20001
local t = {
[1] = {keyword = "explicar", text = "� bem simples, cada classe inicial tem varias vertentes, assim apronfundando a classe para o {estilo} que se encaixe melhor para voc�!"}, -- palavra-chave, texto
[2] = {keyword = "estilo", text = "Voce tem que saber qual � seu estilo e adequar sua nova classe a ele, n�o existe bastante informa��es sobre as vertentes das classes iniciais, � um mundo totalmente desconhecido! {ok}?"},
[3] = {keyword = "ok", text = "Que bom que voc� entendeu, eu vou te mandar para um especialista da sua classe, deixe me ver.. no momento que voc� liberar sua sub-classe poder� aprender magias nos topos das torres de cria��o de magias! "}
}

local classe = {
[1] = {frase = "O especialista da sua classe � um guerreiro que fica nas muralhas de Dryadalis, o nome dele � natanael!!"},
[2] = {frase = "O seu especialista � um grande defensor, ele esta em algum lugar nas muralhas de Dryadalis! o nome dele � Lionel"},
[3] = {frase = "O especialista da sua classe � um mago muito renomado, ele est� na torre dos magos de Dryadalis! o nome dele � Yaki"},
[4] = {frase = "O seu especialista � um druida famoso, ele est� em algum lugar no vale dos pandas, o nome dele � curly!"},
[6] = {frase = "O especialista da classe arqueira, � um famoso arqueiro, ele tem uma casa de treinamentos aqui em Dryadalis, procure-o, o nome dele � Hood!"},
[17] = {frase = "O especialista da classe poeta est� em algum lugar aqui na cidade de Dryadalis, procure-o, o nome dele � Gil!"},
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) == npcOrder) or getPlayerStorageValue(cid, storage) == npcOrder then
                npcHandler:addFocus(cid)
                npcHandler:say("Ol�, "..getPlayerName(cid)..", Eu primeiro vou {explicar} para voc� o conceito de ter uma classe e depois te mandarei para o encarregado ok?!", cid)
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
                talkState[talkUser] = talkState[talkUser] + 1
				npcHandler:say(classe[getPlayerVocation(cid)].frase, cid)
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

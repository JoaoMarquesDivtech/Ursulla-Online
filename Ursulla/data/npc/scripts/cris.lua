
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
[1] = {keyword = "explicar", text = "É bem simples, cada classe inicial tem varias vertentes, assim apronfundando a classe para o {estilo} que se encaixe melhor para você!"}, -- palavra-chave, texto
[2] = {keyword = "estilo", text = "Voce tem que saber qual é seu estilo e adequar sua nova classe a ele, não existe bastante informações sobre as vertentes das classes iniciais, é um mundo totalmente desconhecido! {ok}?"},
[3] = {keyword = "ok", text = "Que bom que você entendeu, eu vou te mandar para um especialista da sua classe, deixe me ver.. no momento que você liberar sua sub-classe poderá aprender magias nos topos das torres de criação de magias! "}
}

local classe = {
[1] = {frase = "O especialista da sua classe é um guerreiro que fica nas muralhas de Dryadalis, o nome dele é natanael!!"},
[2] = {frase = "O seu especialista é um grande defensor, ele esta em algum lugar nas muralhas de Dryadalis! o nome dele é Lionel"},
[3] = {frase = "O especialista da sua classe é um mago muito renomado, ele está na torre dos magos de Dryadalis! o nome dele é Yaki"},
[4] = {frase = "O seu especialista é um druida famoso, ele está em algum lugar no vale dos pandas, o nome dele é curly!"},
[6] = {frase = "O especialista da classe arqueira, é um famoso arqueiro, ele tem uma casa de treinamentos aqui em Dryadalis, procure-o, o nome dele é Hood!"},
[17] = {frase = "O especialista da classe poeta está em algum lugar aqui na cidade de Dryadalis, procure-o, o nome dele é Gil!"},
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) == npcOrder) or getPlayerStorageValue(cid, storage) == npcOrder then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid)..", Eu primeiro vou {explicar} para você o conceito de ter uma classe e depois te mandarei para o encarregado ok?!", cid)
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

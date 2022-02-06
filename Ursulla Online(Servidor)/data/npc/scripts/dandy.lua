
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end


local t = {
[1] = {keyword = "refinar", text = "Para refinar você {precisara} de 10 pedras da alma de tier iguais, você tambem precisará de um martelo refinador!"}, -- palavra-chave, texto
[2] = {keyword = "precisara", text = "Após isso, só precisar ir em uma sala de refinação la em baixo e refinar, cada vez maior o tier, maior a chance de quebrar uma pedra da alma!"} -- palavra-chave, texto
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid).."! Eu posso te dar as informações para refinar!, Eu posso te ensinar sobre {refinar}!", cid)
                talkState[talkUser] = 1
        else
            return false
    end    	
    elseif msgcontains(msg, "bye","tchau") then
        npcHandler:say("Tchau!", cid)
        talkState[talkUser] = 0
        npcHandler:releaseFocus(cid)
    else
        npcHandler:say("O que?", cid)
    end
	for i = 1, #t do
    if msgcontains(msg, t[i].keyword) then
    npcHandler:say(t[i].text, cid)
	end	
	end
    return true
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

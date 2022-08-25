
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = 21 -- edite a ordem do npc
local storage = 20000
local t = {
[1] = {keyword = "infiltrado", text = "Eu irei fazer isso, Mas eu tenho que te pedir uma coisa, primeiro vou explicar {ok}?"}, -- palavra-chave, texto
[2] = {keyword = "ok", text = "Após eu assassinar o neto do lorde... sim foi eu! enfim a segurança foi reforçada e estão suspeitando de mim, roubar a carta é facil e eu farei, porem eu fiquei sabendo de uma {coisa} extremamente séria! !"},
[3] = {keyword = "coisa", text = "Eu descobri que um dos generais de groter acabou descobrindo nossa base, ele vai ordernar um ataque na nossa base, e espero que isso não aconteça, enfim corra! e avise isso para drake!!"}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) == npcOrder) or getPlayerStorageValue(cid, storage) == npcOrder then
                npcHandler:addFocus(cid)
                npcHandler:say("Entao o Drake te mandou aqui? ninguem pode saber que eu sou {infiltrado}, então fale baixo! ", cid)
                talkState[talkUser] = 1
			elseif (getPlayerStorageValue(cid, storage) == 24) then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid)..", Ah! o general!! ele se encontra no castelo do rei, eu tenho um amigo infiltrado lá, o nome dele é minio, procure por ele no castelo do lorde! ele conseguirar te por para dentro, mas uma coisa é certa, vá preparado!", cid)
				setPlayerStorageValue(cid, storage, 25)
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


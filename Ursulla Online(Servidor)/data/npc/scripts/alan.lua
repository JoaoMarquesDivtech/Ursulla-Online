
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = -1 -- edite a ordem do npc
local storage = 20050
local t = {
[1] = {keyword = "resetar", text = "Posso te resetar, A primeira vez séra gratis, porem das proximas eu cobrarei esmeraldas, {ok}?!"}, -- palavra-chave, texto
[2] = {keyword = "ok", text = "Você esta {ciente} que seus pontos iram ser resetados?"},
[3] = {keyword = "ciente", text = "Seus pontos foram resetados!"}
}



function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid).."! Eu sou um mago, posso {resetar} seus pontos!", cid)
                talkState[talkUser] = 1
        else
            return false
        end    
	elseif msgcontains(msg, "resetar") and getPlayerItemCount(cid,26394)>=2 and getPlayerStorageValue(cid,storage)==npcOrder + 1  then	
	doPlayerRemoveItem(cid,26394,2)
	reset(cid)	
	npcHandler:say("Seus pontos foram resetados!", cid)
	elseif msgcontains(msg, "resetar") and getPlayerItemCount(cid,26394) < 2 and getPlayerStorageValue(cid,storage)==npcOrder + 1  then	
	npcHandler:say("Você não tem as esmeraldas!", cid)
    npcHandler:releaseFocus(cid)
    elseif t[talkState[talkUser]] and msgcontains(msg, t[talkState[talkUser]].keyword) and getPlayerStorageValue(cid,storage)==npcOrder then
            npcHandler:say(t[talkState[talkUser]].text, cid)
            if talkState[talkUser] == #t then
                setPlayerStorageValue(cid, storage, npcOrder + 1)
                talkState[talkUser] = 0
				reset(cid)
				npcHandler:say("Seus pontos foram resetados!!", cid)
            else
                talkState[talkUser] = talkState[talkUser] + 1
            end
    elseif msgcontains(msg, "bye","tchau") then
        npcHandler:say("Tchau!", cid)
        talkState[talkUser] = 0
        npcHandler:releaseFocus(cid)
    else
        npcHandler:say("Estranho..", cid)
    end
    return true
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

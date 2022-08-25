
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = -1 -- edite a ordem do npc
local storage = 20004
local t = {
[1] = {keyword = "resetar", text = "Posso te resetar, A primeira vez séra gratis, porem das proximas eu cobrarei esmeraldas, {ok}?!"}, -- palavra-chave, texto
[2] = {keyword = "ok", text = "Você esta {ciente} que seus pontos iram ser resetados?"},
[3] = {keyword = "ciente", text = "Seus pontos foram resetados!"}
}


function resetar(cid)
cid:setStorageValue(45200,player:getLevel())
cid:setMaxHealth(player:getMaxHealth() - 5*player:getStorageValue(49998))
cid:setMaxMana(player:getMaxMana() - 5*player:getStorageValue(49999))

for i= 49998, 50006 do
player:setStorageValue(i, 0)
end
Player.setDodgeLevel(player, 0)
Player.setCriticalLevel(player, 0)
player:changeSpeed(-4*player:getStorageValue(50005))
npcHandler:say("Seus pontos foram resetados!", cid)
end


function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) == npcOrder) then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid).."! Eu sou um mago, posso {resetar} seus pontos!", cid)
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
	elseif msgcontains(msg, "resetar") and cid:getItemCount(26394)>=2  then	
	cid:removeItem(26394,2)
	resetar(cid)
	
    elseif t[talkState[talkUser]] and msgcontains(msg, t[talkState[talkUser]].keyword) then
            npcHandler:say(t[talkState[talkUser]].text, cid)
            if talkState[talkUser] == #t then
                setPlayerStorageValue(cid, storage, npcOrder + 1)
                talkState[talkUser] = 0
				resetar(cid)
            else
                talkState[talkUser] = talkState[talkUser] + 1
            end
    elseif msgcontains(msg, "bye","tchau") then
        npcHandler:say("Tchau!", cid)
        talkState[talkUser] = 0
        npcHandler:releaseFocus(cid)
    else
        npcHandler:say("Não entendi..", cid)
    end
    return true
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

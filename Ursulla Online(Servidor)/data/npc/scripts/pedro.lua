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
[1] = {keyword = "deseja", text = "Eu vou te contar, por essas bandas existem {monstros} desastrosos que aparecem aqui e ali e levam uma ou das ovelhas.."}, -- palavra-chave, texto
[2] = {keyword = "monstros", text = "Esses monstros são lobisomens, eu fiquei sabendo que aquela vila na caverna é almadiçoada e é cheia deles! voce poderia me {ajudar} a livrar esse mundo desses monstros?"}, 
[3] = {keyword = "ajudar", text = "Me traga: {30} warewolf fur e {10} warewolf fangs!"}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) <= 0)  then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid).."! Ola, eu sou o pedro, você {deseja} algo?", cid)
                talkState[talkUser] = 1
			elseif (getPlayerStorageValue(cid, storage) == npcOrder+2) then
			    npcHandler:say("Você ja fez essa missão..", cid)
				talkState[talkUser] = 0
				npcHandler:releaseFocus(cid)
            end
        else
            return false
        end    
    elseif t[talkState[talkUser]] and msgcontains(msg, t[talkState[talkUser]].keyword) and (getPlayerStorageValue(cid, storage) == -1) then
            npcHandler:say(t[talkState[talkUser]].text, cid)
            if talkState[talkUser] == #t then
                setPlayerStorageValue(cid, storage, npcOrder + 1)
                talkState[talkUser] = 0
				npcHandler:releaseFocus(cid)
            else
                talkState[talkUser] = talkState[talkUser] + 1
            end
	elseif 	msgcontains(msg, "deseja") and (getPlayerStorageValue(cid, storage) == npcOrder+1) then
			if getPlayerItemCount(cid, 11234)>=30 and getPlayerItemCount(cid, 24708)>=10 then 
	        npcHandler:say("Obrigado e tome este cavalo como recompensa e mais isso!!!", cid)
			doPlayerRemoveItem(cid,11234,30)
			doPlayerRemoveItem(cid,24708,10)
			doPlayerAddExp(cid, 10000)
			doPlayerAddMoney(cid, 10000)
			doPlayerAddMount(cid, 17)
			setPlayerStorageValue(cid, storage, npcOrder + 2)
			npcHandler:releaseFocus(cid)
	        else
			npcHandler:say("Você não tem nada!!", cid)
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

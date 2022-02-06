
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = -1 -- edite a ordem do npc
local storage = 20002
local t = {
[1] = {keyword = "deseja", text = "Eu vou te explicar a situa��o... Existe uma mulher chamada mama e h� muito tempo eu criei uma divida com ela, Ela � dona da maior {base} de bandidos desta regi�o..."}, -- palavra-chave, texto
[2] = {keyword = "base", text = "Esta base de bandidos est� protegida at� os trinques, mas voltando... com essa historia de dever ela mandou matar o meu irm�o e roubar todos os pertences dele, ai eu te pe�o uma coisa, traga um colar de heran�a da familia que est� com a mama e vinge minha familia matando aquele {monstro}.."}, 
[3] = {keyword = "monstro", text = "A base fica ao redor da cidade de brain e mama sempre est� usando essa amuleto, tome cuidado ela � muito forte!"}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) <= 0)  then
                npcHandler:addFocus(cid)
                npcHandler:say("Ol�, "..getPlayerName(cid).."! Ola, eu sou o mathias.. voc� {deseja} algo?", cid)
                talkState[talkUser] = 1
			elseif (getPlayerStorageValue(cid, storage) > npcOrder+2) then	
			    npcHandler:say("Voc� ja fez essa miss�o..", cid)
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
				npcHandler:releaseFocus(cid)
            else
                talkState[talkUser] = talkState[talkUser] + 1
            end
	elseif 	msgcontains(msg, "deseja") and (getPlayerStorageValue(cid, storage) == npcOrder+1) and getPlayerItemCount(cid, 26393)>=1 then
			if getPlayerItemCount(cid, 26393)>=1  then 
	        npcHandler:say("Muitooo Obrigado!!!!!!!! TOME ISTO!!!!", cid)
			doPlayerRemoveItem(cid,26393,1)
			doPlayerAddItem(cid, 26382, 2)
			doPlayerAddItem(cid, 26383, 1)
			doPlayerAddExp(cid, 3000)
			doPlayerAddMoney(cid, 400)
			setPlayerStorageValue(cid, storage, npcOrder + 2)
			npcHandler:releaseFocus(cid)
	        else
			npcHandler:say("Por que voc� est� brincando comigo?", cid)
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

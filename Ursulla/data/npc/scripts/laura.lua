local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState 
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = 1 -- edite a ordem do npc
local storage = 20000


function creatureSayCallback(cid, type, msg)
local talkUser, msg, player = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg), Player(cid)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) >= 1) then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá "..getPlayerName(cid).."! Voce deseja entrar na dungeon da cidade de groter?", cid)
                talkState = 1
            else
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid).."! Talvez possamos conversar outra hora...", cid)
                talkState = 0
                npcHandler:releaseFocus(cid)
            end
        else
            return false
        end    
    elseif msgcontains(msg, "yes") or msgcontains(msg, "sim") and talkState==1 then
            if (getPlayerMoney(cid)>=400) and player:getItemCount(26553)>=1 then
				player:removeItem(26553,1)			
			    doPlayerRemoveMoney(cid, 400)
				doTeleportThing(cid, {x = 1241, y = 808, z = 5})
				talkState = 0
				npcHandler:say("Boa sorte na dungeon!!", cid)
				npcHandler:releaseFocus(cid)		
			elseif 	(getPlayerMoney(cid)<400) then
				npcHandler:say("Você precisa de 4 moedas de prata para entrar aqui!", cid)
		        npcHandler:releaseFocus(cid)		
			elseif player:getItemCount(26553)==0 then
				npcHandler:say("Você precisa de uma chave de platina para entrar aqui!", cid)
		        npcHandler:releaseFocus(cid)		
			end
    elseif msgcontains(msg, "no") or msgcontains(msg, "não") and talkState==1 then
		npcHandler:say("Tudo bem então, até logo!", cid)
		npcHandler:releaseFocus(cid)			
    elseif msgcontains(msg, "bye","tchau") then
        npcHandler:say("Tchau!", cid)
        talkState = 0
        npcHandler:releaseFocus(cid)
    else
        npcHandler:say("O que?", cid)
    end
    return true
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)



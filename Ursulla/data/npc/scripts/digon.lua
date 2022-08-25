
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = 13 -- edite a ordem do npc
local storage = 20000


function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
			if getPlayerVocation(cid)~=17 then 
			npcHandler:say("Olá, "..getPlayerName(cid).."! Você não é um poeta para estar aqui!", cid)
			npcHandler:releaseFocus(cid)
            elseif (getPlayerStorageValue(cid, storage) == npcOrder)  then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid).."! Então eu vou te dar a diretriz de alguma {especialização}, não tem nada para se basear porque os conceitos basicos que eu vou passar para você é o maximo de informação que eu tenho...Talvez outros aventureiros possam te informar sobre as especialização, se for esse o caso saia e volte outra hora, pois só se pode escolher uma vez a especialização!!", cid)
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
    elseif msgcontains(msg, "especialização") then
            npcHandler:say("As diretrizes que eu posso te encaminhar são: {Trovador} e {Bardo}", cid)	
    elseif msgcontains(msg, "Bardo") then
            npcHandler:say("Voce virou um Bardo! Os bardos são os que nascem com o dom de tocar, Eles usam instrumentos como arma!", cid)
            setPlayerStorageValue(cid, storage, npcOrder + 1)
			doPlayerSetVocation(cid,22)
			npcHandler:releaseFocus(cid)
	elseif  msgcontains(msg, "Trovador") then
            npcHandler:say("Voce virou um Trovador! Os grandes poetas do mundo, eles usam instrumentos como arma!", cid)
            setPlayerStorageValue(cid, storage, npcOrder + 1)
			doPlayerSetVocation(cid,18)		
            npcHandler:releaseFocus(cid)			
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

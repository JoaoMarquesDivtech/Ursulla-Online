
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = 10 -- edite a ordem do npc
local storage = 20001


function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
			if getPlayerVocation(cid)~=2 then 
			npcHandler:say("Olá, "..getPlayerName(cid).."! Você não é um defensor para estar aqui!", cid)
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
            npcHandler:say("As diretrizes que eu posso te encaminhar são: {Guardião}, {Paladino} e {Templario}", cid)	
    elseif msgcontains(msg, "Guardião") then
            npcHandler:say("Voce virou um Guardião! Ninguem te derrubára! Guardiões focam nos seus escudos, a arma é pelo seu critério!", cid)
            setPlayerStorageValue(cid, storage, npcOrder + 1)
			doPlayerSetVocation(cid,12)
			npcHandler:releaseFocus(cid)			
	elseif  msgcontains(msg, "Paladino") then
            npcHandler:say("Voce virou um Paladino! A sua defesa é sua gloria! Paladinos focam nos seus escudo, a arma é pelo proprio criterio!", cid)
            setPlayerStorageValue(cid, storage, npcOrder + 1)
			doPlayerSetVocation(cid,13)		
			npcHandler:releaseFocus(cid)			
	elseif  msgcontains(msg, "Templario") then
            npcHandler:say("Voce virou um Templario! A sua defesa é sua fé em deus! Templarios normalmente focam no escudo e a arma é pelo seu proprio clitério!", cid)
            setPlayerStorageValue(cid, storage, npcOrder + 1)
			doPlayerSetVocation(cid,14)	
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

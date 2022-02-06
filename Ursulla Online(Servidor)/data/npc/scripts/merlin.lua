
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
			if getPlayerVocation(cid)~=3 then 
			npcHandler:say("Ol�, "..getPlayerName(cid).."! Voc� n�o � um mago para estar aqui!", cid)
			npcHandler:releaseFocus(cid)
            elseif (getPlayerStorageValue(cid, storage) == npcOrder)  then
                npcHandler:addFocus(cid)
                npcHandler:say("Ol�, "..getPlayerName(cid).."! Ent�o eu vou te dar a diretriz de alguma {especializa��o}, n�o tem nada para se basear porque os conceitos basicos que eu vou passar para voc� � o maximo de informa��o que eu tenho...Talvez outros aventureiros possam te informar sobre as especializa��o, se for esse o caso saia e volte outra hora, pois s� se pode escolher uma vez a especializa��o!!", cid)
                talkState[talkUser] = 1
            else
                npcHandler:addFocus(cid)
                npcHandler:say("Ol�, "..getPlayerName(cid).."! Talvez possamos conversar outra hora...", cid)
                talkState[talkUser] = 0
                npcHandler:releaseFocus(cid)
            end
        else
            return false
        end 
    elseif msgcontains(msg, "especializa��o") then
            npcHandler:say("As diretrizes que eu posso te encaminhar � especialismo em: {Fogo}, {Trevas}, {Raio} e {Gelo}", cid)	
    elseif msgcontains(msg, "Fogo") then
            npcHandler:say("Voce virou um {Mago de Fogo}! O seu unico limite � as cinzas! Essa classe normalmente usa varinhas como arma!", cid)
            setPlayerStorageValue(cid, storage, npcOrder + 1)
			doPlayerSetVocation(cid,15)
			npcHandler:releaseFocus(cid)
	elseif  msgcontains(msg, "Trevas") then
            npcHandler:say("Voce virou um {Mago das Trevas}! O seu maior dom � que a morte n�o � um impedimento! Essa classe normalmente usa varinhas como arma! AH..Soube que o Kai precisa de voc�!", cid)
            setPlayerStorageValue(cid, storage, npcOrder + 1)
			doPlayerSetVocation(cid,16)		
			npcHandler:releaseFocus(cid)			
   elseif  msgcontains(msg, "Raio") then
            npcHandler:say("Voc� virou um {Mago da Raio}! O som dos trov�es � apenas um suspiro seu, Essa classe normalmente usa varinhas como arma! AH..Soube que o Kai precisa de voc�!", cid)
            setPlayerStorageValue(cid, storage, npcOrder + 1)
			doPlayerSetVocation(cid,20)
			npcHandler:releaseFocus(cid)
   elseif  msgcontains(msg, "Gelo") then
            npcHandler:say("Voc� virou um {Mago da Gelo! A nevasca � um refugio de f�rias! Essa classe normalmente usa varinhas como arma! AH..Soube que o Kai precisa de voc�!", cid)
            setPlayerStorageValue(cid, storage, npcOrder + 1)
			doPlayerSetVocation(cid,21)		
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

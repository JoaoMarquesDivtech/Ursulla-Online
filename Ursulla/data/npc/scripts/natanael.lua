
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
			if getPlayerVocation(cid)~=1 then 
			npcHandler:say("Olá, "..getPlayerName(cid).."! Você não é um guerreiro para estar aqui!", cid)
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
	elseif msgcontains(msg, "especialização") and isElf(Player(cid)) then
            npcHandler:say("As diretrizes que eu posso te encaminhar são: {Espadachim}, {Gladiador} ,{Anti Mago} e {soldado}", cid)			
    elseif msgcontains(msg, "Espadachim") then
            npcHandler:say("Voce virou um Espadachim! Tão agil que consegue cortar uma flecha vindo a sua distancia na mais alta potencia, Esta classe se usa katanas, Chamada de Samurai em uma cultura vizinha!", cid)
            setPlayerStorageValue(cid, storage, npcOrder + 1)
			doPlayerSetVocation(cid,7)
	elseif  msgcontains(msg, "gladiador") then
            npcHandler:say("Voce virou um Gladiador! Não só é imortal como mata quem quiser? parace injusto.. esta classe é normalmente é equipada com machados! Chamada de Barbaro em uma cultura vizinha!", cid)
            setPlayerStorageValue(cid, storage, npcOrder + 1)
			doPlayerSetVocation(cid,8)		
	elseif  msgcontains(msg, "soldado") then
            npcHandler:say("Voce virou um Soldado! Parece comum mas você irá se supreender com ele, esta classe normalmente se equipa com armas de curto alcance!!", cid)
            setPlayerStorageValue(cid, storage, npcOrder + 1)
			doPlayerSetVocation(cid,9)			
    elseif  msgcontains(msg, "Anti Mago") then
            npcHandler:say("Voce virou um anti mago! Um veneno natural da magia! Não se sabe qual arma esta classe usa..!..", cid)
            setPlayerStorageValue(cid, storage, npcOrder + 1)
			doPlayerSetVocation(cid,11)						
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

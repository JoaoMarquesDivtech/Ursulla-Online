
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
			npcHandler:say("Olá, "..getPlayerName(cid).."! Você não é um mago para estar aqui!", cid)
			npcHandler:releaseFocus(cid)
            elseif (getPlayerStorageValue(cid, storage) == npcOrder)  then
                npcHandler:addFocus(cid)
                npcHandler:say({"Há muito tempo a especialização que eu tenho foi banida por ser condiferado algo fora dos direitos humanos, antigamente nos chamavam de vampiros ou de manipuladores de sangue.","Mas é uma classe que é algo lindo de se manipular, é a magia que controla a vida, e algo assim não pode ser jogado fora!","A sub-classe é o mago de sangue, você esta {disposto} a virar um?"}, cid)
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
    elseif msgcontains(msg, "disposto") then
            npcHandler:say("Você quer virar um mago de sangue?", cid)	
    elseif msgcontains(msg, "sim") then
            npcHandler:say("Voce virou um {Mago de Sangue}! O dominador da vida, essa classe normalmente usa varinhas como arma!", cid)
            setPlayerStorageValue(cid, storage, npcOrder + 1)
			doPlayerSetVocation(cid,19)
			npcHandler:releaseFocus(cid)		
    elseif msgcontains(msg, "não") then
            npcHandler:say("Então tchau!", cid)
			npcHandler:releaseFocus(cid)					
    elseif msgcontains(msg, "tchau") then
        npcHandler:say("Tchau!", cid)
        talkState[talkUser] = 0
        npcHandler:releaseFocus(cid)
    else
        npcHandler:say("O que?", cid)
    end
    return true
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

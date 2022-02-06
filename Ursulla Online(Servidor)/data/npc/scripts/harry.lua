local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = -1 -- edite a ordem do npc
local storage = 20001
local t = {
[1] = {keyword = "dryadalis", text = "dryadalis é a cidade que é a base do reino dos elfos da {floresta}! um reino não tão rico, porem poderoso em habilidades!"}, -- palavra-chave, texto
[2] = {keyword = "floresta", text = "os elfos da floresta são arqueiros habilidosos, nós somos mais rapidos e nossa destreza é quase perfeita, porem isso não impede os elfos de serem o que bem {quiser}!"}, 
[3] = {keyword = "quiser", text = "Existem diversas classes e os elfos da floresta tem varias diretrizes especiais, Vá até o gborn no segundo andar desse templo para ele te informar melhor sobre o senso comum deste pais!"}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
		    if not isElf(Player(cid)) then 
			npcHandler:say("É de outra raça? você não tem o que fazer aqui!", cid)
			npcHandler:releaseFocus(cid)
            elseif (getPlayerStorageValue(cid, storage) <= 0)  then
                npcHandler:addFocus(cid)
                npcHandler:say("Ola, eu sou o harry, e você é um elfo da floresta, eu sou o receptor de elfos invocados no pais elfico! normalmente os elfos da floresta invocados no mundo de Ursulla são invocados aqui na cidade de {dryadalis}", cid)
                talkState[talkUser] = 1
			else 
			    npcHandler:say("Você está fazendo o que aqui?", cid)
				talkState[talkUser] = 0
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

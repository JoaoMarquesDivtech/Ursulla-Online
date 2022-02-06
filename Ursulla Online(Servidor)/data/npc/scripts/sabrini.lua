
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = 5 -- edite a ordem do npc
local storage = 20001
local t = {
[1] = {keyword = "magia", text = "A magia que eu vou lhe ensinar pode te {curar} em uma batalha! Ela te ajudará bastante nesse seu inicio!"}, -- palavra-chave, texto
[2] = {keyword = "curar", text = "Em uma luta você precisa de uma magia assim, pois monstros estão sempre querendo a sua morte! a magia que regenera cura mais, porem em longo prazo, ja a instantanea, cura menos em comparação a que regenera porem é tudo em uma fração de milesimos! Você deseja {aprender}?"},
[3] = {keyword = "aprender", text = "Para aprender a magia de regeneração diga {regen}, já para aprender a magia de cura instantanea diga {cure}!"}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) == npcOrder) or getPlayerStorageValue(cid, storage) == npcOrder then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid).."!, Tony te mandou para aprender uma {magia}, estou correto?", cid)
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
    elseif t[talkState[talkUser]] and msgcontains(msg, t[talkState[talkUser]].keyword) then
            npcHandler:say(t[talkState[talkUser]].text, cid)     
            talkState[talkUser] = talkState[talkUser] + 1
            
    elseif msgcontains(msg, "bye","tchau") then
        npcHandler:say("Tchau!", cid)
        talkState[talkUser] = 0
        npcHandler:releaseFocus(cid)
    elseif msgcontains(msg, "cure") then
            npcHandler:say("Voce aprendeu a magia de cura e para conjura-la, diga: {cure min}, fale com o bill para ele te ensinar um pouco sobre este mundo e te dar um caminho!", cid)
            setPlayerStorageValue(cid, storage, npcOrder + 1)	
		    playerLearnInstantSpell(cid, "cure min")
	        npcHandler:releaseFocus(cid)
	elseif  msgcontains(msg, "regen") then
            npcHandler:say("Voce aprendeu a magia de cura e para conjura-la, diga: {regen min}, fale com o bill para ele te ensinar um pouco sobre este mundo e te dar um caminho!", cid)
            setPlayerStorageValue(cid, storage, npcOrder + 1)	
		    playerLearnInstantSpell(cid, "regen min")			
			npcHandler:releaseFocus(cid)
    else
        npcHandler:say("O que?", cid)
    end
    return true
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

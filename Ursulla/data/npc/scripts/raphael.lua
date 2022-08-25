
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder, storage = 1 , 20000 -- edite a ordem do npc


function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
local player = Player(cid)

    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) == npcOrder)  then
                npcHandler:addFocus(cid)
				npcHandler:updateFocus()		
                npcHandler:say({"Olá, "..getPlayerName(cid).."! Eu sou o encarregado nesta cidade por determinar as classes dos novos aventureiros!","Existem {diversas} e eu posso te ensinar o inicio de uma da sua escolha para você iniciar a sua jornada!"}, cid)
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
    elseif msgcontains(msg, "classe") and isHuman(Player(cid)) then
			player.sendExtendedOpcode(Player(cid), 103, "showWindow")
            npcHandler:say("Tenha certeza antes de decidir a sua classe, as classes que eu posso te ensinar no momento são: {Guerreiro}, {Mago}, {Druida}, {Arqueiro}, {defensor}, {ladrão} e {poeta}", cid)		
    elseif msgcontains(msg, "guerreiro") then
            npcHandler:say("Voce virou um guerreiro! Fale com o dorbin para receber o item inicial da sua classe..", cid)
            setPlayerStorageValue(cid, storage, npcOrder + 1)
			doPlayerSetVocation(cid,1)
			reset(cid)
			npcHandler:releaseFocus(cid)
	elseif  msgcontains(msg, "Defensor") then
            npcHandler:say("Voce virou um defensor! Fale com o dorbin para receber o item inicial da sua classe..", cid)
            setPlayerStorageValue(cid, storage, npcOrder + 1)
			doPlayerSetVocation(cid,2)		
			reset(cid)
			npcHandler:releaseFocus(cid)
	elseif  msgcontains(msg, "Mago") then
            npcHandler:say("Voce virou um mago! Fale com o dorbin para receber o item inicial da sua classe..", cid)
            setPlayerStorageValue(cid, storage, npcOrder + 1)
			doPlayerSetVocation(cid,3)	
			reset(cid)			
			npcHandler:releaseFocus(cid)
    elseif  msgcontains(msg, "Druida") then
            npcHandler:say("Voce virou um druida! Fale com o dorbin para receber o item inicial da sua classe..", cid)
            setPlayerStorageValue(cid, storage, npcOrder + 1)
			doPlayerSetVocation(cid,4)
			reset(cid)			
			npcHandler:releaseFocus(cid)
    elseif  msgcontains(msg, "Ladrão") then
            npcHandler:say("Voce virou um ladrão! Fale com o dorbin para receber o item inicial da sua classe..", cid)
            setPlayerStorageValue(cid, storage, npcOrder + 1)
			doPlayerSetVocation(cid,5)	
			reset(cid)			
			npcHandler:releaseFocus(cid)
    elseif  msgcontains(msg, "Arqueiro") then
            npcHandler:say("Voce virou um arqueiro, lembre-se que voce pode conjurar flechas usando:{arc conjure}, Fale com o dorbin para receber o item inicial da sua classe..", cid)
            doPlayerAddItem(cid,2389, 10)
			setPlayerStorageValue(cid, storage, npcOrder + 1)
			doPlayerSetVocation(cid,6)	
			reset(cid)			
            npcHandler:releaseFocus(cid)	
    elseif  msgcontains(msg, "Poeta") then
            npcHandler:say("Voce virou um poeta, Fale com o dorbin para receber o item inicial da sua classe..", cid)
			setPlayerStorageValue(cid, storage, npcOrder + 1)
			doPlayerSetVocation(cid,17)	
			reset(cid)			
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

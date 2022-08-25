local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = -1 -- edite a ordem do npc
local storage = 25006
local t = {
[1] = {keyword = "tempo", text = "É algo grandioso o que aconteceu em groter, Eu era muito jovem porem é uma historia linda de se {ouvir}"}, -- palavra-chave, texto
[2] = {keyword = "ouvir", text = {"Com conflitos em brain por mortes desconhecidas, os primeiros habitantes desse pais decidiram vim montar um pequeno forte nesta ilha que você esta pisando, e o lider dessa expedição que se chamava Argus era um homem ambicioso..","Ele aos poucos começou a ficar cego em construir algo gigante e impenetravel, e durou decadas para que ele chegasse a obra prima, e a demora não foi por causa do projeto grandioso que ele decidiu criar e sim por causa de uma sociedade de minotauros na ilha vizinha a Groter","Ele ficou sabendo que os vizinhos da cidade de Brain tinham o mesmo problema e assim eles decidiram fazer dessa sociedade de minotauros uma dungeon, porem com um forte rochoso tão grande e poderoso, os cidadões de Brain ficaram intimidados e decidiram começar uma guerra!","As guerras duraram centenas de anos, pois Groter tem uma defesa impenetravel e Brain tem os invocados que são guerreiros formidaveis e potentes, a guerra acabou quando os lideres das cidades de Gringard decidiram se unificar e virar um só..","Você deve estar se perguntando onde está a parte gloriosa e linda por trás de milhões de mortos na guerra interna de Gringard, enfim a parte linda e gloriosa é esse forte gigante que você esta em {cima}!"}},
[3] = {keyword = "cima", text = "Eu acabei me tornando general de Groter após ter feito varias conquistas nessas guerras, e agora eu vou {pedir} algo para você!"},
[4] = {keyword = "pedir", text = "Para suplimentos do nosso exercito você seria capaz de me {trazer} equipamentos? estamos em falta esses tempos.."},
[4] = {keyword = "trazer", text = "Me traga {5} guardian shields."}

}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
			if not isHuman(Player(cid)) then 
				npcHandler:say("Você não é da minha raça, saia daqui!", cid)
				npcHandler:releaseFocus(cid)	
			elseif (getPlayerStorageValue(cid, storage) == npcOrder) then
                npcHandler:addFocus(cid)
                npcHandler:say({"Eu sou um grande guerreiro do pais de Gringard, eu participei de grandes guerras, inclusive participei da ascensção de Groter..!",
								"A ascensção de groter é uma historia que vai tomar um pouco do seu {tempo}.."}, cid)
                talkState[talkUser] = 1	
		    elseif (getPlayerStorageValue(cid, storage) == 0) and getPlayerItemCount(cid, 2515) >= 5 then 
				doPlayerRemoveItem(cid, 2515, 5)
				doPlayerAddOutfit(cid, 134)
				doPlayerAddOutfit(cid, 142)
				setPlayerStorageValue(cid, storage, 1)
				npcHandler:say({"Obrigado! Você foi muito util!","Eu preciso de 5 {knight axes} agora!"}, cid)
			elseif (getPlayerStorageValue(cid, storage) == 0) and getPlayerItemCount(cid, 12495) < 15 and getPlayerItemCount(cid, 5910) < 30 then 	
				npcHandler:say({"Você não tem nada ai, seu inutil!"}, cid)
			elseif (getPlayerStorageValue(cid, storage) == 1) and getPlayerItemCount(cid, 5910) < 5 then	
				npcHandler:say("Eu preciso de 5 {knight axes} agora!", cid)	
			elseif (getPlayerStorageValue(cid, storage) == 1) and getPlayerItemCount(cid, 2430) >= 5 then
				doPlayerRemoveItem(cid, 2430, 5)
				npcHandler:say({"Obrigado por isso!","Agora me traga 2 {knight armors} e 2 {knight legs}"}, cid)
				setPlayerStorageValue(cid, storage, 2)
				doPlayerAddOutfit(cid, 134, 1)
				doPlayerAddOutfit(cid, 142, 1)
			elseif (getPlayerStorageValue(cid, storage) == 2) and getPlayerItemCount(cid, 2476) < 2 and getPlayerItemCount(cid, 2477) < 2 then	
				npcHandler:say("Eu preciso de 2 {knight armors} e 2 {knight legs} agora!", cid)			
			elseif (getPlayerStorageValue(cid, storage) == 1) and getPlayerItemCount(cid, 2476) >= 2 and getPlayerItemCount(cid, 2477) >= 2 then
				doPlayerRemoveItem(cid, 2476, 2)
				doPlayerRemoveItem(cid, 2477, 2)
				npcHandler:say({"Obrigado por isso!","Você terminou tudo que tem para fazer aqui!"}, cid)
				setPlayerStorageValue(cid, storage, 3)
				doPlayerAddOutfit(cid, 134, 2)
				doPlayerAddOutfit(cid, 142, 2)	
			elseif (getPlayerStorageValue(cid, storage) == 3) then
				npcHandler:say("Você ja fez tudo que tem para fazer aqui!", cid)						
            else
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid).."! Talvez posssamos conversar outra hora...", cid)
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

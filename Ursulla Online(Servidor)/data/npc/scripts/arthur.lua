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
[1] = {keyword = "tempo", text = "� algo grandioso o que aconteceu em groter, Eu era muito jovem porem � uma historia linda de se {ouvir}"}, -- palavra-chave, texto
[2] = {keyword = "ouvir", text = {"Com conflitos em brain por mortes desconhecidas, os primeiros habitantes desse pais decidiram vim montar um pequeno forte nesta ilha que voc� esta pisando, e o lider dessa expedi��o que se chamava Argus era um homem ambicioso..","Ele aos poucos come�ou a ficar cego em construir algo gigante e impenetravel, e durou decadas para que ele chegasse a obra prima, e a demora n�o foi por causa do projeto grandioso que ele decidiu criar e sim por causa de uma sociedade de minotauros na ilha vizinha a Groter","Ele ficou sabendo que os vizinhos da cidade de Brain tinham o mesmo problema e assim eles decidiram fazer dessa sociedade de minotauros uma dungeon, porem com um forte rochoso t�o grande e poderoso, os cidad�es de Brain ficaram intimidados e decidiram come�ar uma guerra!","As guerras duraram centenas de anos, pois Groter tem uma defesa impenetravel e Brain tem os invocados que s�o guerreiros formidaveis e potentes, a guerra acabou quando os lideres das cidades de Gringard decidiram se unificar e virar um s�..","Voc� deve estar se perguntando onde est� a parte gloriosa e linda por tr�s de milh�es de mortos na guerra interna de Gringard, enfim a parte linda e gloriosa � esse forte gigante que voc� esta em {cima}!"}},
[3] = {keyword = "cima", text = "Eu acabei me tornando general de Groter ap�s ter feito varias conquistas nessas guerras, e agora eu vou {pedir} algo para voc�!"},
[4] = {keyword = "pedir", text = "Para suplimentos do nosso exercito voc� seria capaz de me {trazer} equipamentos? estamos em falta esses tempos.."},
[4] = {keyword = "trazer", text = "Me traga {5} guardian shields."}

}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
			if not isHuman(Player(cid)) then 
				npcHandler:say("Voc� n�o � da minha ra�a, saia daqui!", cid)
				npcHandler:releaseFocus(cid)	
			elseif (getPlayerStorageValue(cid, storage) == npcOrder) then
                npcHandler:addFocus(cid)
                npcHandler:say({"Eu sou um grande guerreiro do pais de Gringard, eu participei de grandes guerras, inclusive participei da ascens��o de Groter..!",
								"A ascens��o de groter � uma historia que vai tomar um pouco do seu {tempo}.."}, cid)
                talkState[talkUser] = 1	
		    elseif (getPlayerStorageValue(cid, storage) == 0) and getPlayerItemCount(cid, 2515) >= 5 then 
				doPlayerRemoveItem(cid, 2515, 5)
				doPlayerAddOutfit(cid, 134)
				doPlayerAddOutfit(cid, 142)
				setPlayerStorageValue(cid, storage, 1)
				npcHandler:say({"Obrigado! Voc� foi muito util!","Eu preciso de 5 {knight axes} agora!"}, cid)
			elseif (getPlayerStorageValue(cid, storage) == 0) and getPlayerItemCount(cid, 12495) < 15 and getPlayerItemCount(cid, 5910) < 30 then 	
				npcHandler:say({"Voc� n�o tem nada ai, seu inutil!"}, cid)
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
				npcHandler:say({"Obrigado por isso!","Voc� terminou tudo que tem para fazer aqui!"}, cid)
				setPlayerStorageValue(cid, storage, 3)
				doPlayerAddOutfit(cid, 134, 2)
				doPlayerAddOutfit(cid, 142, 2)	
			elseif (getPlayerStorageValue(cid, storage) == 3) then
				npcHandler:say("Voc� ja fez tudo que tem para fazer aqui!", cid)						
            else
                npcHandler:addFocus(cid)
                npcHandler:say("Ol�, "..getPlayerName(cid).."! Talvez posssamos conversar outra hora...", cid)
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

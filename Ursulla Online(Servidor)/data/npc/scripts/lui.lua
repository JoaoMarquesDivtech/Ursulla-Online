local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = -1 -- edite a ordem do npc
local storage = 25000
local t = {
[1] = {keyword = "pegar", text = "Então eu posso te contar uma {historia}?"}, -- palavra-chave, texto
[2] = {keyword = "historia", text = {"Os primeiros habitantes de Brain eram pessoas normais, eles chegaram aqui pelos mares vindo de terras desconheplayeras, e logo quando chegaram acharam desta terra, uma terra prospera e bonita..","Estava tudo indo bem, porem vinham acontecendo desaparecimentos pela noite, porem nada que assustasse os novos habitantes de Brain, porem os casos de desaparecimentos e mortes vinham crescendo bastante e isso fez os grandes lideres de brain a investigar isso..","Após longos meses de investigações, eles descobiram uma {caverna} no centro da cidade, bem escondida, onde os mais sorrateiros goblins viviam, e era literalmente uma nação dentro de uma caverna."}},
[3] = {keyword = "caverna", text = "Os grandes lideres deciriram fechar a caverna e fazer dela uma dungeon, e assim se iniciou a {grande} cidade de Brain!"},
[4] = {keyword = "grande", text = "Essa é a historia desta cidade! enfim.. eu estou precisando de umas {coisas}, enfim você pode me trazer elas? juro que te recompensarei.."},
[5] = {keyword = "coisas", text = "Me traga 30 {green pieces of cloths} e 15 {goblin ears}"}
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
                npcHandler:say({"Olá, eu moro aqui nesta casa remota há muito tempo, meu pai se estabeleceu e eu conheço a maioria das hitorias de Brain!",
								"Eu posso {pegar} um pouco do seu tempo?"}, cid)
                talkState[talkUser] = 1	
		    elseif (getPlayerStorageValue(cid, storage) == 0) and getPlayerItemCount(cid, 12495) >= 15 and getPlayerItemCount(cid, 5910) >= 30 then 
				doPlayerRemoveItem(cid, 12495, 10)
				doPlayerRemoveItem(cid, 5910, 30)
				doPlayerAddOutfit(cid, 128, 1)
				doPlayerAddOutfit(cid, 136, 1)
				setPlayerStorageValue(cid, storage, 1)
				npcHandler:say({"Obrigado! Você foi muito util!","Fale com o guilar la fora que ele pode precisar de algo de você!"}, cid)
			elseif (getPlayerStorageValue(cid, storage) == 0) and getPlayerItemCount(cid, 12495) < 15 and getPlayerItemCount(cid, 5910) < 30 then 	
				npcHandler:say({"Você não tem nada ai, seu inutil!"}, cid)
			elseif (getPlayerStorageValue(cid, storage) == 1) then
				npcHandler:say("Fale com o guilar la fora!", cid)
				setPlayerStorageValue(cid, storage, 2)
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

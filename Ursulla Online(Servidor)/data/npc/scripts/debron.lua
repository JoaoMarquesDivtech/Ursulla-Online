
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = -1 -- edite a ordem do npc
local storage = 25001
local t = {
[1] = {keyword = "dificil", text = "Sim, é dificil pois, aparecem constantemente invasores querendo pular o muro, e eu tenho que estar o tempo todo {defendendo} ou checando e de alguma forma deixando todos seguros no forte"}, -- palavra-chave, texto
[2] = {keyword = "defendendo", text = {"Minha familia tambem mora aqui, então é algo que eu tambem preciso fazer, Groter saiu recentemente de uma guerra e temos que crescer economicamente, e por isso meu papel é muito importante neste momento!","Temos potencial para sermos os maiores do pais de Gringard, pois o nosso forte tem uma defesa invencivel.","Eu preciso que você me {faça} umas coisas, pois eu não posso sair daqui."}},
[3] = {keyword = "faça", text = "Me traga : {35} white piece of cloth, eu preciso disso para uma magia de defesa que estou criando para Groter."}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
		    if isElf(Player(cid)) then 
				npcHandler:say("Saia elfo!!", cid)
				npcHandler:releaseFocus(cid)	
		    elseif (getPlayerStorageValue(cid, storage) == 0) and getPlayerItemCount(cid, 5909) >= 35 then
				doPlayerRemoveItem(cid, 5909, 35)
				doPlayerAddOutfit(cid, 130, 0)
				doPlayerAddOutfit(cid, 138, 0)
				setPlayerStorageValue(cid, storage, 1)
				npcHandler:say({"Obrigado!","Tome estas roupas como recompensa!"}, cid)
		    elseif (getPlayerStorageValue(cid, storage) == 0) and getPlayerItemCount(cid, 5909) < 35 then
				npcHandler:say("Você não tem os items.", cid)				
			elseif (getPlayerStorageValue(cid, storage) == 1) then
				npcHandler:say("Agora para eu finalizar me traga: {70} white piece of cloth, {1} novice staff e {1} soul stone!", cid)
				setPlayerStorageValue(cid, storage, 2)
			elseif (getPlayerStorageValue(cid, storage) == 2) and getPlayerItemCount(cid, 5896) >= 50 and getPlayerItemCount(cid, 5909) >= 70 then
				doPlayerRemoveItem(cid, 5909, 70)
				npcHandler:say({"Você foi muito util!","Tome mais estas roupas como recompensa!"}, cid)
				setPlayerStorageValue(cid, storage, 3)
				doPlayerAddOutfit(cid, 130, 1)
				doPlayerAddOutfit(cid, 138, 1)
			elseif (getPlayerStorageValue(cid, storage) == 2) and getPlayerItemCount(cid, 5896) < 50 and getPlayerItemCount(cid, 5909) < 70 then		
				npcHandler:say({"Você não tem os items!"}, cid)			
            elseif (getPlayerStorageValue(cid, storage) == npcOrder) then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, Eu moro aqui em Groter há anos, eu trabalho como o principal defensor do forte de Groter, pois sou um mago muito poderoso, minha vida é um tanto {dificil}..", cid)
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

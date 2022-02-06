
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = -1 -- edite a ordem do npc
local storage = 19950
local t = {
[1] = {keyword = "ajudar", text = {"Monstros invadiram o templo, é uma historia longa..", "Eles entraram pela noite e por isso não percebemos","Presumo que tenham sido trolls, existem rumores de que esses {monstros} sempre aparecem pela noite na cidade e roubam ou matam alguem!"}}, -- palavra-chave, texto
[2] = {keyword = "monstros", text = {"Não tem como saber.. mas eu tenho suspeita de um pequeno esgoto que a cidade deixou de usar! a entrada desse esgoto fica ali no bosque logo na saida deste templo..","Eles roubaram {algo} preciso e preciso que você recupere imediatamente!"}},
[3] = {keyword = "algo", text = "Foi um livro sagrado, que contem segredos de alto escalão da igreja, então recupere-os e eu te recompesarei."}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) == npcOrder) then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid).."! Eu sou o padre da cidade de Brain e estou precisando de ajuda urgentemente! Voce está disposto a me {ajudar}?", cid)
                talkState[talkUser] = 1
			elseif (getPlayerStorageValue(cid, storage) == npcOrder+1) then
			    npcHandler:addFocus(cid)
				npcHandler:say("Você tem o livro?",cid)
				talkState[talkUser] = 10
            else
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid).."! Talvez possamos conversar outra hora...", cid)
                talkState[talkUser] = 0
                npcHandler:releaseFocus(cid)
			end	
            return false
        end   
	elseif getPlayerItemCount(cid, 1955) >= 1 and (msgcontains(msg, "yes") or msgcontains(msg, "sim")) and talkState[talkUser]==10 then
		doPlayerRemoveItem(cid, 1955, 1)
		doPlayerAddItem(cid, 2152, 5)
		setPlayerStorageValue(cid, storage, npcOrder + 2)
		doPlayerAddExp(cid, 3000)
		npcHandler:say({"Oh, obrigado!! eu vou ser eternamente grato pelo que você fez agora! eu estava a um tempo tentando solucionar isso..","Agora você tem permissão para se tornar um aventureiro, fale com a Renata na guilda dos aventureiros! lá onde você tomara seus primeiros passos para virar um aventureiro!"}, cid)
		talkState[talkUser] = 0			
	elseif (msgcontains(msg, "yes") or msgcontains(msg, "sim")) and talkState[talkUser]==10 then
		npcHandler:say({"Não me faça perder tempo!","Você não tem o livro!!"}, cid)	
	elseif msgcontains(msg, "no") or msgcontains(msg, "não") and talkState[talkUser]==10 then
		npcHandler:say({"Não me faça perder tempo!","Seu inutil!"}, cid)		
    elseif t[talkState[talkUser]] and msgcontains(msg, t[talkState[talkUser]].keyword) then
            npcHandler:say(t[talkState[talkUser]].text, cid)
            if talkState[talkUser] == #t then
                setPlayerStorageValue(cid, storage, npcOrder + 1)
                talkState[talkUser] = 0
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

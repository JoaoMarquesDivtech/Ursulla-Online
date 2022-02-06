local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = 2 -- edite a ordem do npc
local storage = 25000
local t = {
[1] = {keyword = "algo", text = "Essa pequena fazenda é essencial para o desenvolvimento de Brain, como você sabe o principal foco da economia de Brain é a exploração de dungeons, e as poucas fazendas destas regiões são mais que {uteis}!"}, -- palavra-chave, texto
[2] = {keyword = "uteis", text = {"Nossa fazenda esta precisando de produtos de criaturas para o desenvolvimento, e se nós não focarmos nisso, a vida em Brain podera estar em risco no futuro..","Então eu preciso que você me traga essas coisas, os invocados sempre são inpecavéis quando solicitamos algo, eu juro que te recompensarei..","Você quer me {ajudar}?"}},
[3] = {keyword = "ajudar", text = "Então me traga 40 {chicken feathers} e 30 {wools} e 5 {black wools}"}
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
                npcHandler:say("Então o lui, te mandou aqui? eu tenho {algo} para você!", cid)
                talkState[talkUser] = 1	
		    elseif (getPlayerStorageValue(cid, storage) == 3) and getPlayerItemCount(cid, 12404) >= 5 and getPlayerItemCount(cid, 11236) >= 30 and getPlayerItemCount(cid, 5890) >= 40 then 
				doPlayerRemoveItem(cid, 12404, 5)
				doPlayerRemoveItem(cid, 11236, 30)
				doPlayerRemoveItem(cid, 5890, 40)
				doPlayerAddOutfit(cid, 128, 2)
				doPlayerAddOutfit(cid, 136, 2)
				setPlayerStorageValue(cid, storage, 4)
				npcHandler:say({"Obrigado! Você foi muito util! Não tenho mais nada pra você"}, cid)
		    elseif (getPlayerStorageValue(cid, storage) == 3) and getPlayerItemCount(cid, 12404) < 5 and getPlayerItemCount(cid, 11236) < 30 and getPlayerItemCount(cid, 5890) < 40 then 
				npcHandler:say({"Você não tem nada ai, seu inutil!"}, cid)
			elseif (getPlayerStorageValue(cid, storage) == 4) then
                npcHandler:addFocus(cid)
                npcHandler:say("Você ja terminou tudo aqui!", cid)
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

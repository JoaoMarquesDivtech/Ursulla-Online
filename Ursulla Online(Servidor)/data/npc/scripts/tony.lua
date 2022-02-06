
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = 3 -- edite a ordem do npc
local storage = 20001
local t = {
[1] = {keyword = "sobreviventes", text = "Eu irei te testar e lhe ensinarei uma magia se fizer isto! ainda irei te dar o passe para ser um aventureiro, você podera entrar em qualquer {dungeon} após esse teste!"}, -- palavra-chave, texto
[2] = {keyword = "dungeon", text = "Normalmente as cidades ficam em volta de dungeons e elas são a principal {renda} das cidades, isso não acontece em dryadalis, nossa antiga dungeon desabou após um terremoto causado por um fator desconhecido!"},
[3] = {keyword = "renda", text = "Nós elfos tivemos que nos ajustar, e agora nossa unica fonte de renda é a {caça} e vivemos disso!"},
[4] = {keyword = "caça", text = "Por isso traga para mim 10 {beetroots}!"}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
		    if (getPlayerStorageValue(cid, storage) == npcOrder+1) and getPlayerItemCount(cid, 8845) >= 10 then
			    doPlayerRemoveItem(cid, 8845, 10)
                npcHandler:say("Você foi muito bem! Obrigado, Agora vá até a loja de porções e fale com o Sabrini!", cid)
				setPlayerStorageValue(cid, storage, npcOrder + 2)
                npcHandler:releaseFocus(cid)
            elseif (getPlayerStorageValue(cid, storage) == npcOrder) then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid)..", os elfos da floresta são {sobreviventes} natos, somos muito habilidosos!!", cid)
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

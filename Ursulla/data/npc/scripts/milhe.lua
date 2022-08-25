
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = 16 -- edite a ordem do npc
local storage = 20000
local t = {
[1] = {keyword = "mandou", text = "Vou te explicar uma coisa que eu expliquei ao michael a muito tempo quando ele chegou aqui na cidade {ok}?"}, -- palavra-chave, texto
[2] = {keyword = "ok", text = "O lorde de Groter é um soberano que usa seu povo exclusivamente para estorqui-lo e os que ele não da para estorquir ele joga no subsolo onde nós somos usados como {escravos} fazendo todo trabalho sujo que os frescos la de cima não conseguem fazer!"},
[3] = {keyword = "escravos", text = "A familia {bisel} crescem porque eles conquistaram o povo! eles nos dão coisas para comer, para beber e locais para nós podermos dormir em paz! parece pouco, mas ao viver sob a cidade de Groter isso é {muito}!"},
[4] = {keyword = "muito", text = "Mesmo sabendo disso você esta de qual lado? {Groter} ou {Bisel}"}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) == npcOrder) or getPlayerStorageValue(cid, storage) == npcOrder then
                npcHandler:addFocus(cid)
                npcHandler:say("Ah! Então o michael te {mandou} aqui para proteger o reino de Groter hahaha?", cid)
                talkState[talkUser] = 1
			elseif (getPlayerStorageValue(cid, storage) == 17) then
                npcHandler:addFocus(cid)
                npcHandler:say("Ninguem fala mal da familia Bisel no meu estabelecimento! ja que você parece ser da causa, va e fale com o  Livin! ele se encontra na casa dele aqui no subsolo mesmo!", cid)
				talkState[talkUser] = 0
				npcHandler:releaseFocus(cid)
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
	elseif msgcontains(msg, "groter") and (getPlayerStorageValue(cid, storage) == npcOrder) then
    setPlayerStorageValue(cid, storage, 27)
	npcHandler:say("Aquela general de Groter falou com voce antes? Maldita Garbiela, Morra!!!", cid)
	doCreatureSay(cid, "Sinto que deveriar procurar por esta Gabriela!", TALKTYPE_ORANGE_1)
	Game.createMonster("ladrao", {x = 1239, y = 921, z = 7})
    Game.createMonster("ladrao", {x = 1240, y = 925, z = 7})
	elseif msgcontains(msg, "bisel") and (getPlayerStorageValue(cid, storage) == npcOrder) then
    setPlayerStorageValue(cid, storage, 17)
    npcHandler:say("Você esta certo!!", cid)	
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


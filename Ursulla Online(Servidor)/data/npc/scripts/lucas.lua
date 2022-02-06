
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end


local t = {
[1] = {keyword = "classes", text = "As classes s�o o sustento de vida dos aventureiros e � essencial se quiser viver neste mundo, eu posso te ensinar mais sobre, as classes s�o: {Guerreiro}, {Defensor}, {Mago}, {Druida}, {Ladr�o} e {Arqueiro}!"}, -- palavra-chave, texto
[2] = {keyword = "guerreiro", text = "O guerreiro � uma classe do tipo fisico e normalmente eles focam nas habilidades de {For�a} e {Vida}, e jamais deve focar em inteligencia, destreza ou precis�o..!"},
[3] = {keyword = "Defensor", text = "O  defensor � uma classe duravel e normalmente distribuem em {Vitalidade}, {Defesa} e as vezes em {for�a}! Jamais deve focar em destreza ou precis�o!"},
[4] = {keyword = "Mago", text = "Mago � uma classe do tipo magica e normalmente distribuem em {Inteligencia}, {Sabedoria} e as vezes em {pericia}, Jamais deve focar em for�a, destreza, precis�o!"},
[5] = {keyword = "Druida", text = "Druida � uma classe do tipo magica e normalmente distribuem em {Inteligencia}, {Sabedoria} e as vezes em {pericia}, Jamais deve focar em for�a, destreza, precis�o!"},
[6] = {keyword = "Ladr�o", text = "Ladr�o � uma classe fisica que foca em {Precis�o} e {Pericia}, jamais deve focar em inteligencia ou destreza!"},
[7] = {keyword = "Arqueiro", text = "Arqueiro � uma classe a distancia fisica, ela foca em {precis�o} e {destreza}, Sendo que quando focada em destreza ela d� mais dano em habilidades multi-alvos, e precis�o da mais dano em habilidades com foco! Jamais deve focar em for�a ou inteligencia!"},
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
                npcHandler:addFocus(cid)
                npcHandler:say("Ol�, "..getPlayerName(cid).."! Eu sou o especialista em classes da cidade, Eu posso te ensinar sobre as {classes}!", cid)
                talkState[talkUser] = 1
        else
            return false
    end    	
    elseif msgcontains(msg, "bye","tchau") then
        npcHandler:say("Tchau!", cid)
        talkState[talkUser] = 0
        npcHandler:releaseFocus(cid)
    else
        npcHandler:say("O que?", cid)
    end
	for i = 1, #t do
    if msgcontains(msg, t[i].keyword) then
    npcHandler:say(t[i].text, cid)
	end	
	end
    return true
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

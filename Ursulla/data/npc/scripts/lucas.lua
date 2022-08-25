
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end


local t = {
[1] = {keyword = "classes", text = "As classes são o sustento de vida dos aventureiros e é essencial se quiser viver neste mundo, eu posso te ensinar mais sobre, as classes são: {Guerreiro}, {Defensor}, {Mago}, {Druida}, {Ladrão} e {Arqueiro}!"}, -- palavra-chave, texto
[2] = {keyword = "guerreiro", text = "O guerreiro é uma classe do tipo fisico e normalmente eles focam nas habilidades de {Força} e {Vida}, e jamais deve focar em inteligencia, destreza ou precisão..!"},
[3] = {keyword = "Defensor", text = "O  defensor é uma classe duravel e normalmente distribuem em {Vitalidade}, {Defesa} e as vezes em {força}! Jamais deve focar em destreza ou precisão!"},
[4] = {keyword = "Mago", text = "Mago é uma classe do tipo magica e normalmente distribuem em {Inteligencia}, {Sabedoria} e as vezes em {pericia}, Jamais deve focar em força, destreza, precisão!"},
[5] = {keyword = "Druida", text = "Druida é uma classe do tipo magica e normalmente distribuem em {Inteligencia}, {Sabedoria} e as vezes em {pericia}, Jamais deve focar em força, destreza, precisão!"},
[6] = {keyword = "Ladrão", text = "Ladrão é uma classe fisica que foca em {Precisão} e {Pericia}, jamais deve focar em inteligencia ou destreza!"},
[7] = {keyword = "Arqueiro", text = "Arqueiro é uma classe a distancia fisica, ela foca em {precisão} e {destreza}, Sendo que quando focada em destreza ela dá mais dano em habilidades multi-alvos, e precisão da mais dano em habilidades com foco! Jamais deve focar em força ou inteligencia!"},
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid).."! Eu sou o especialista em classes da cidade, Eu posso te ensinar sobre as {classes}!", cid)
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

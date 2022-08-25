
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end


local t = {
[1] = {keyword = "pontos", text = "Pontos são usados para focar em certas habilidades que voce quer destacar, As habilidades são: {Stamina}, {Sabedoria}, {Inteligencia}, {Força}, {Destreza}, {Precisão} e {Pericia}, {Velocidade}, {Agilidade} e {Defesa}!"}, -- palavra-chave, texto
[2] = {keyword = "vida", text = "A habilidade de {Vida} aumenta sua durabilidade no campo de batalha, normalmente os que melhoram essa habilidade são classes duraveis que ficam na linha de frente!"},
[3] = {keyword = "sabedoria", text = "A habilidade de {sabedoria} aumenta a quantidade de mana maxima, mana é usada para usar habilidades."},
[4] = {keyword = "inteligencia", text = "A {Inteligencia} aumenta o poder de habilidades magicas, é inutil para classes do tipo fisica!"},
[5] = {keyword = "força", text = "{Força} aumenta a sua potencia em habilidades fisicas, classes fisicas que ficam na linha de frente normalmente melhoram essa habilidade, é inutil para magos ou para classes de distancia!"},
[6] = {keyword = "destreza", text = "A {Destreza} aumenta o dominio de habilidades a distancia em multi-alvos, Boa para atiradores que desejam focar mais de um alvo ao mesmo tempo!"},
[7] = {keyword = "precisão", text = "{Precisão}, Aumenta o chance de critico e aumenta o dominio de habilidades a distancia focado em apenas um alvo, tambem bastante usado por classes assassinas!"},
[8] = {keyword = "pericia", text = "Aumenta uma leve redução de uso entre as habilidades! Tambem chamado de Cooldown Reduction.."},
[9] = {keyword = "velocidade", text = "Aumenta a velocidade de movimento! "},
[9] = {keyword = "agilidade", text = "Aumenta a chance de desvio, Bastante usada em classes com pouca defesa e com  muita defesa!"},
[9] = {keyword = "defesa", text = "Aumenta o bloqueio de dano geral, Bastante usada em classes tanques!"},
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid).."! Eu sou o especialista em habilidades da cidade, Eu posso te ensinar sobre os {pontos}!", cid)
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

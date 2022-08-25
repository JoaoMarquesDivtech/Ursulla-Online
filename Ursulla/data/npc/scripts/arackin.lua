
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = 14 -- edite a ordem do npc
local storage = 20000
local t = {
[1] = {keyword = "magias", text = "Ola eu sou o grande {criador} de magias desta cidade, e crio magias de todos os tipos para todas as classes e sub-classes imaginaveis!"}, -- palavra-chave, texto
[2] = {keyword = "criador", text = " Normalmente eu {aceito} pedras da alma para criar magias, e cada vez mais potente sendo a magia irá precisar de pedras da alma mais potentes, Pedras da almas são divididas em 10 niveis..!"},
[3] = {keyword = "aceito", text = "Pedras da almas contém muitos segredos, enfim, você deseja algo?!"}
}

local vocacions = {
[7] = {classe = {"Espadachim"}, texto = {"Copia","Giro"}, magias = {"Sword Duplicate","Sword Spin"}},
[8] = {classe = {"Gladiador"}, texto = {"Combo","Impacto"}, magias = {"Barbarian Combo","Barbarian Impact"}},
[9] = {classe = {"Soldado"},texto = {"Dois cortes","Desafio"}, magias = {"Fiel TuoCut","Fiel Challenge"}},
[10] =  {classe = {"Ceifador"},texto = {"Combo","Giro"}, magias = {"Ceifer Combo","Ceifer Spin"}},
[11] = {classe = {"Anti Mago"},texto = {"Escudo de Mana","Giro"}, magias = {"Anti Shield","Anti Spin"}},
[12] = {classe = {"Guardiao"},texto = {"Lentidão","Atrair"}, magias = {"Guardian Allowed","Guardian Atract"}},
[13] = {classe = {"Paladino"},texto = {"Lentidão","Defensiva"}, magias = {"Paladin Allowed","Paladin Defensive"}},
[14] = {classe = {"Templario"},texto = {"Giro","Recussitar"}, magias = {"Templar Spin","Templar Reveal"}},
[15] = {classe = {"Mago de Fogo"},texto = {"Onda","Meteoro"}, magias = {"Fire Wave","Fire Pull"}},
[16] = {classe = {"Mago das Trevas"},texto = {"Recussitar","Combo"}, magias = {"Death Summon","Death Combo"}},
[18] = {classe = {"Trovador"},texto = {"Onda","Inspirar"}, magias = {"Song Wave","Song Inspire"}},
[20] = {classe = {"Mago de Raio"},texto = {"Carga","Onda"}, magias = {"Shock Charge","Shock Beam"}},
[21] = {classe = {"Mago do Gelo"},texto = {"Onda","Nevasca"}, magias = {"Ice Wave","Ice Frost"}},
[22] = {classe = {"Bardo"},texto = {"Onda","Cura"}, magias = {"Song Wave","Song Heal"}},
[23] = {classe = {"Druida da Luz"},texto = {"Curar","Foco"}, magias = {"light cure","light beam"}},
[24] = {classe = {"Druida da Natureza"},texto = {"Curar","Onda"}, magias = {"Nature Cure","Nature Wave"}},
[27] = {classe = {"Assassino"},texto = {"Combo","Envenenar"}, magias = {"Assassin Combo","Assassin Poison"}},
[28] = {classe = {"Ladino"},texto = {"Combo","Envenenar"}, magias = {"Ladin Combo","Ladin Poison"}},
[29] = {classe = {"Caçador"},texto = {"Multi Alvos","Chuva de Flechas"}, magias = {"Arc MultiStrike","Arc Fly"}},
[30] = {classe = {"Atirador"},texto = {"Combo","Paralisia"}, magias = {"Camp Combo","Camp Allowed"}},
[31] = {classe = {"Campeao"},texto = {"Combo"}, magias = {"Champ Combo"}}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) >= npcOrder)  or (getPlayerStorageValue(cid, 20001) >= 11) then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid)..", Eu sou o {unico} que sou especialista em magias na região de brain!!", cid)
                talkState[talkUser] = 1
            elseif (getPlayerStorageValue(cid, storage) < npcOrder) then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid).."! Talvez possamos conversar outra hora...", cid)
                talkState[talkUser] = 0
                npcHandler:releaseFocus(cid)
            end
        else
            return false
        end
    elseif msgcontains(msg, "bye","tchau" or "tchau") then    	
	npcHandler:say("Tchau...", cid)	
	npcHandler:releaseFocus(cid)	
	elseif (getPlayerStorageValue(cid, storage) >= 0) or (getPlayerStorageValue(cid, 20001) >= 11) then
	local pad = vocacions[getPlayerVocation(cid)]
	local lista = "As Magias que voce pode criar são:"
	for i=1,#pad.magias do
	lista = lista.." {("..pad.texto[i]
	lista = lista..")}"
	end
	
	if msgcontains(msg,"lista") then
	npcHandler:say(lista,cid)		
    elseif msgcontains(msg,"unico") then
    npcHandler:say("Tem duas variaveis importantes para você começar, são elas: {criar}, {lista} e {requisitos}?!",cid)
    elseif msgcontains(msg,"criar") then
    npcHandler:say("Para criar uma magia diga para mim: {(nome da magia)}, Para saber os nomes das magias diga 'lista' !",cid)
    elseif msgcontains(msg,"requisitos") then
    npcHandler:say("Para criar magias eu cobro: 1 pedra da alma(II), 2 pedra da alma(I), 30 moedas de prata e não ter aprendido a magia!",cid)
    end	
	
	for i =1, #pad.magias do
	if msgcontains(msg,pad.texto[i]) then
    if getPlayerItemCount(cid, 26382)>=2 and getPlayerItemCount(cid, 26383)>=1 and getPlayerMoney(cid)>=3000 and not getPlayerLearnedInstantSpell(cid, pad.magias[i]) then
	doPlayerRemoveItem(cid,26382,2)
	doPlayerRemoveItem(cid,26383,1)
    doPlayerRemoveMoney(cid, 3000)
	playerLearnInstantSpell(cid,pad.magias[i])
	npcHandler:say("Parabens você aprendeu a magia: "..pad.texto[i]..", Para conjurar está magia voce deve falar:"..pad.magias[i].."",cid)
	else
	npcHandler:say("Você não tem os requisitos minimos, diga {requisitos} para se informar melhor!",cid)
    end
    end	
	end
end
    return true
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
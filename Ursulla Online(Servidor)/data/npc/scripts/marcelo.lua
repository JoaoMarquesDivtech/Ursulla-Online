
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder, storage = 1, 20000  -- edite a ordem do npc

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
	[19] = {classe = {"Mago de Sangue"},texto = {"Onda","dominio"}, magias = {"Blood Wave","Blood possession"}},
	[20] = {classe = {"Mago de Raio"},texto = {"Carga","Onda"}, magias = {"Shock Charge","Shock Beam"}},
	[21] = {classe = {"Mago do Gelo"},texto = {"Onda","Nevasca"}, magias = {"Ice Wave","Ice Frost"}},
	[22] = {classe = {"Bardo"},texto = {"Onda","Cura"}, magias = {"Song Wave","Song Heal"}},
	[23] = {classe = {"Druida da Luz"},texto = {"Curar","Foco"}, magias = {"light cure","light beam"}},
	[24] = {classe = {"Druida da Natureza"},texto = {"Curar","Onda"}, magias = {"Nature Cure","Nature Wave"}},
	[25] = {classe = {"Druida Catalizador"},texto = {"Adrenalina","Onda"}, magias = {"Venom Adrennaline","Venom Wave"}},
	[27] = {classe = {"Assassino"},texto = {"Combo","Envenenar"}, magias = {"Assassin Combo","Assassin Poison"}},
	[28] = {classe = {"Ladino"},texto = {"Combo","Envenenar"}, magias = {"Ladin Combo","Ladin Poison"}},
	[29] = {classe = {"Caçador"},texto = {"Multi Alvos","Onda"}, magias = {"Arc MultiStrike","Arc Wave"}},
	[30] = {classe = {"Atirador"},texto = {"Combo","Paralisia"}, magias = {"Camp Combo","Camp Allowed"}},
	[31] = {classe = {"Campeao"},texto = {"Combo"}, magias = {"Champ Combo"}}
}

local falas = {
	["lista"] = {"As Magias que voce pode criar são:"},
	["unico"] = {"Tem duas variaveis importantes para você começar, são elas: {criar}, {lista} e {requisitos}?"},
	["criar"] = {"Para criar uma magia diga para mim: {(nome da magia)}, Para saber os nomes das magias diga {lista}!"},
	["requisitos"] = {"Você precisará de uma quantia de dinheiro para comprar a magia que você quer, para isto diga: {lista}"}
}



function creatureSayCallback(cid, type, msg)
	local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
	if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) >= npcOrder)then
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
		elseif (getPlayerStorageValue(cid, storage) >= npcOrder) then			
			
			local pad = vocacions[getPlayerVocation(cid)]
			
			if pad == nil then 
				npcHandler:say("Você não tem magias para aprender aqui ainda!",cid)
				npcHandler:releaseFocus(cid)
			end
			
			for x,z in pairs(vocacions[getPlayerVocation(cid)].texto) do
			    if x == 1 then
				falas["lista"][1] = "As Magias que voce pode criar são:"
				end
				falas["lista"][1] = falas["lista"][1].." {("..z.."/"..(x*3000)..")}"
			end	
			
			for x, i in pairs(falas) do
				if msgcontains(msg,x) then
					npcHandler:say(i,cid)
				end
			end
	
		for i =1, #pad.magias do

			if msgcontains(msg,pad.texto[i]) then
				if getPlayerLearnedInstantSpell(cid, pad.magias[i]) then 
					npcHandler:say("Você ja aprendeu esta magia!",cid)
				elseif getPlayerMoney(cid)>=(i*3000) then
					doPlayerRemoveMoney(cid, i*3000)
					playerLearnInstantSpell(cid,pad.magias[i])
					npcHandler:say("Parabens você aprendeu a magia: "..pad.texto[i]..", Para conjurar está magia voce deve falar:"..pad.magias[i].."",cid)
				else
					npcHandler:say("Você não tem dinheiro o suficiente para comprar essa magia!",cid)
				end
			end	
	    end
	end
    return true

end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

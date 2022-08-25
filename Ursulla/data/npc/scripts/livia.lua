
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = 1 -- edite a ordem do npc
local storage = 20000
local t = {
[1] = {keyword = "magias", text = "Ola eu sou o grande {criador} de magias desta cidade, e crio magias de todos os tipos para todas as classes e sub-classes imaginaveis!"}, -- palavra-chave, texto
[2] = {keyword = "criador", text = " Normalmente eu {aceito} pedras da alma para criar magias, e cada vez mais potente sendo a magia irá precisar de pedras da alma mais potentes, Pedras da almas são divididas em 10 niveis..!"},
[3] = {keyword = "aceito", text = "Pedras da almas contém muitos segredos, enfim, você deseja algo?!"}
}

local vocacions = {
[7] = {classe = {"Espadachim"}, texto = {"Conexão"}, magias = {"Sword Conect"}},
[8] = {classe = {"Gladiador"}, texto = {"Raiva"}, magias = {"Barbarian Rage"}},
[9] = {classe = {"Cavaleiro"},texto = {"Sangramento","Quebrar"}, magias = {{"Fiel bleeding","Fiel Vanguard"}}},
[10] =  {classe = {"Ceifador"},texto = {"Sangramento"}, magias = {"Ceifer Bleeding"}},
[11] = {classe = {"Anti Mago"},texto = {"Troca","Veneno"}, magias = {"Anti Trade","Anti Poison"}},
[12] = {classe = {"Guardiao"},texto = {"Defensiva"}, magias = {"Guardian Defensive"}},
[13] = {classe = {"Paladino"},texto = {"Luz"}, magias = {"Paladin Light"}},
[14] = {classe = {"Templario"},texto = {"Benção"}, magias = {"Templar Blessed"}},
[15] = {classe = {"Mago de Fogo"},texto = {"Queimar"}, magias = {"Fire Burn"}},
[16] = {classe = {"Mago das Trevas"},texto = {"Maldição"}, magias = {"Death Curse"}},
[18] = {classe = {"Trovador"},texto = {"Inspiração","Silencio"}, magias = {"Song inspire","Song Silence"}},
[19] = {classe = {"Mago de Sangue"},texto = {"Explosão"}, magias = {"Blood Explosion"}},
[20] = {classe = {"Mago de Raio"},texto = {"Tempestade","Statica"}, magias = {"Shock Thunder","Shock Static"}},
[21] = {classe = {"Mago do Gelo"},texto = {"Caos"}, magias = {"Ice Blizzard"}},
[22] = {classe = {"Bardo"},texto = {"Sinfonia"}, magias = {"Song Sinfony"}},
[23] = {classe = {"Druida da Luz"},texto = {"Salvação"}, magias = {"light gran cure"}},
[24] = {classe = {"Druida da Natureza"},texto = {"Raiva"}, magias = {"Nature Rage"}},
[25] = {classe = {"Druida Catalizador"},texto = {"Bloquear"}, magias = {"Venom Block"}},
[27] = {classe = {"Assassino"},texto = {"Invisibilidade"}, magias = {"Assassin invisible"}},
[28] = {classe = {"Ladino"},texto = {"Invisibilidade"}, magias = {"Ladin invisible"}},
[29] = {classe = {"Caçador"},texto = {"Grande Flechada","Chuva de Flechas"}, magias = {"Arc Gran Strike","Arc Fly"}},
[30] = {classe = {"Atirador"},texto = {"Grande Flechada","Rajadas"}, magias = {"Camp Gran Strike","Camp Multiples"}},
[31] = {classe = {"Campeao"},texto = {"Combo"}, magias = {"Champ Combo"}}
}

local falas = {
	["lista"] = {"As Magias que voce pode criar são:"},
	["grande"] = {"Tem duas variaveis importantes para você começar, são elas: {criar}, {lista} e {requisitos}?"},
	["criar"] = {"Para criar uma magia diga para mim: {(nome da magia)}, Para saber os nomes das magias diga {lista}!"},
	["requisitos"] = {"Você precisará de uma quantia de dinheiro para comprar a magia que você quer, para isto diga: {lista}"}
}

function creatureSayCallback(cid, type, msg)

	local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
	
	if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) >= npcOrder) then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid)..", Eu sou uma {grande} especialista da cidade de groter!!", cid)
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
				falas["lista"][1] = falas["lista"][1].." {("..z.."/"..(x*10000)..")}"
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
				elseif getPlayerMoney(cid)>=(i*10000) then
					doPlayerRemoveMoney(cid, i*10000)
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

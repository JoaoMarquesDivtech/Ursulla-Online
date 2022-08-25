
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
[7] = {classe = {"Espadachim"}, texto = {"Cura Media","Cura Maxima","Regeneração Media","Regeneração Maxima"}, magias = {"Cure Medium","Cure Max","Regen Medium","Regen Max"}},
[8] = {classe = {"Gladiador"},texto = {"Cura Media","Cura Maxima","Regeneração Media","Regeneração Maxima"}, magias = {"Cure Medium","Cure Max","Regen Medium","Regen Max"}},
[9] = {classe = {"Soldado"},texto = {"Cura Media","Cura Maxima","Regeneração Media","Regeneração Maxima"}, magias = {"Cure Medium","Cure Max","Regen Medium","Regen Max"}},
[10] =  {classe = {"Ceifador"},texto = {"Cura Media","Cura Maxima","Regeneração Media","Regeneração Maxima"}, magias = {"Cure Medium","Cure Max","Regen Medium","Regen Max"}},
[11] = {classe = {"Anti Mago"},texto = {"Cura Media","Cura Maxima","Regeneração Media","Regeneração Maxima"}, magias = {"Cure Medium","Cure Max","Regen Medium","Regen Max"}},
[12] = {classe = {"Guardiao"},texto = {"Cura Media","Cura Maxima","Regeneração Media","Regeneração Maxima"}, magias = {"Cure Medium","Cure Max","Regen Medium","Regen Max"}},
[13] = {classe = {"Paladino"},texto = {"Cura Media","Cura Maxima","Regeneração Media","Regeneração Maxima"}, magias = {"Cure Medium","Cure Max","Regen Medium","Regen Max"}},
[14] = {classe = {"Templario"},texto = {"Cura Media","Cura Maxima","Regeneração Media","Regeneração Maxima"}, magias = {"Cure Medium","Cure Max","Regen Medium","Regen Max"}},
[15] = {classe = {"Mago de Fogo"},texto = {"Cura Media","Cura Maxima","Regeneração Media","Regeneração Maxima"}, magias = {"Cure Medium","Cure Max","Regen Medium","Regen Max"}},
[16] = {classe = {"Mago das Trevas"},texto = {"Cura Media","Cura Maxima","Regeneração Media","Regeneração Maxima"}, magias = {"Cure Medium","Cure Max","Regen Medium","Regen Max"}},
[18] = {classe = {"Trovador"},texto = {"Cura Media","Cura Maxima","Regeneração Media","Regeneração Maxima"}, magias = {"Cure Medium","Cure Max","Regen Medium","Regen Max"}},
[19] = {classe = {"Mago de sangue"},texto = {"Cura Media","Cura Maxima","Regeneração Media","Regeneração Maxima"}, magias = {"Cure Medium","Cure Max","Regen Medium","Regen Max"}},
[20] = {classe = {"Mago de Raio"},texto = {"Cura Media","Cura Maxima","Regeneração Media","Regeneração Maxima"}, magias = {"Cure Medium","Cure Max","Regen Medium","Regen Max"}},
[21] = {classe = {"Mago do Gelo"},texto = {"Cura Media","Cura Maxima","Regeneração Media","Regeneração Maxima"}, magias = {"Cure Medium","Cure Max","Regen Medium","Regen Max"}},
[22] = {classe = {"Bardo"},texto = {"Cura Media","Cura Maxima","Regeneração Media","Regeneração Maxima"}, magias = {"Cure Medium","Cure Max","Regen Medium","Regen Max"}},
[23] = {classe = {"Druida da Luz"},texto = {"Cura Media","Cura Maxima","Regeneração Media","Regeneração Maxima"}, magias = {"Cure Medium","Cure Max","Regen Medium","Regen Max"}},
[24] = {classe = {"Druida da Natureza"},texto = {"Cura Media","Cura Maxima","Regeneração Media","Regeneração Maxima"}, magias = {"Cure Medium","Cure Max","Regen Medium","Regen Max"}},
[25] = {classe = {"Druida Catalisador"},texto = {"Cura Media","Cura Maxima","Regeneração Media","Regeneração Maxima"}, magias = {"Cure Medium","Cure Max","Regen Medium","Regen Max"}},
[27] = {classe = {"Assassino"},texto = {"Cura Media","Cura Maxima","Regeneração Media","Regeneração Maxima"}, magias = {"Cure Medium","Cure Max","Regen Medium","Regen Max"}},
[28] = {classe = {"Ladino"},texto = {"Cura Media","Cura Maxima","Regeneração Media","Regeneração Maxima"}, magias = {"Cure Medium","Cure Max","Regen Medium","Regen Max"}},
[29] = {classe = {"Caçador"},texto = {"Cura Media","Cura Maxima","Regeneração Media","Regeneração Maxima"}, magias = {"Cure Medium","Cure Max","Regen Medium","Regen Max"}},
[30] = {classe = {"Atirador"},texto = {"Cura Media","Cura Maxima","Regeneração Media","Regeneração Maxima"}, magias = {"Cure Medium","Cure Max","Regen Medium","Regen Max"}},
[31] = {classe = {"Campeao"},texto = {"Cura Media","Cura Maxima","Regeneração Media","Regeneração Maxima"}, magias = {"Cure Medium","Cure Max","Regen Medium","Regen Max"}}
}

local falas = {
	["lista"] = {"As Magias que voce pode criar são:"},
	["druida"] = {"Tem duas variaveis importantes para você começar, são elas: {criar}, {lista} e {requisitos}?"},
	["criar"] = {"Para criar uma magia diga para mim: {(nome da magia)}, Para saber os nomes das magias diga {lista}!"},
	["requisitos"] = {"Você precisará de uma quantia de dinheiro para comprar a magia que você quer, para isto diga: {lista}"}
}



function creatureSayCallback(cid, type, msg)


	local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
	
	if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) >= npcOrder)  then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid)..", Eu sou um renomado {druida}, que ensina novas formas de cura para todos!!!", cid)
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
				falas["lista"][1] = falas["lista"][1].." {("..z.."/"..(x*15000)..")}"
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
				elseif getPlayerMoney(cid)>=(i*15000) then
					doPlayerRemoveMoney(cid, i*15000)
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

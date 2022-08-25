
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = 0
local att, att2
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder, storage = -1 , 20000 -- edite a ordem do npc


local classes = {
[1] = {class = {name = {"Espadachim", "Gladiador", "Cavaleiro", "Ceifador", "Anti Mago"}, id = {7,8,9,10,11}}},
[2] = {class = {name = {"Guardião", "Paladino", "Templario"}, id = {12,13,14}}},
[3] = {class = {name = {"Fogo", "Trevas", "Raio", "Gelo", "Sangue"}, id = {15,16,20,21,19}}},
[4] = {class = {name = {"Luz", "Natureza","Catalisador"}, id = {23,24,25}}},
[5] = {class = {name = {"Assassino","Ladino"}, id = {27,28}}},
[6] = {class = {name = {"Caçador","Atirador"}, id = {29,30}}},
[17] = {class = {name = {"Trovador" , "Bardo"}, id = {18,22}}},
}

local items = {
[7] = {[2412] = 1, [2461] = 1, [2649] = 1, [2510] = 1, [2787] = 10, [2175] = 1},
[8] = {[2380] = 2, [2461] = 1, [2649] = 1, [2787] = 10, [2175] = 1},
[9] = {[2376] = 1, [2461] = 1, [2649] = 1, [2510] = 1, [2787] = 10, [2175] = 1},
[10] = {[2381] = 1, [2461] = 1, [2649] = 1, [2510] = 1, [2787] = 10, [2175] = 1},
[11] = {[2397] = 1, [2461] = 1, [2649] = 1, [2510] = 1, [2787] = 10, [2175] = 1},
[15] = {[23719] = 1, [2461] = 1, [2649] = 1, [2510] = 1, [2787] = 10, [2175] = 1},
[16] = {[23719] = 1, [2461] = 1, [2649] = 1, [2510] = 1, [2787] = 10, [2175] = 1},
[18] = {[2071] = 1, [2461] = 1, [2649] = 1, [2510] = 1, [2787] = 10, [2175] = 1},
[22] = {[2071] = 1, [2461] = 1, [2649] = 1, [2510] = 1, [2787] = 10, [2175] = 1},
[19] = {[23719] = 1, [2461] = 1, [2649] = 1, [2510] = 1, [2787] = 10, [2175] = 1},
[20] = {[23719] = 1, [2461] = 1, [2649] = 1, [2510] = 1, [2787] = 10, [2175] = 1},
[21] = {[23719] = 1, [2461] = 1, [2649] = 1, [2510] = 1, [2787] = 10, [2175] = 1},
[23] = {[23721] = 1, [2461] = 1, [2649] = 1, [2510] = 1, [2787] = 10, [2175] = 1},
[24] = {[23721] = 1, [2461] = 1, [2649] = 1, [2510] = 1, [2787] = 10, [2175] = 1},
[25] = {[23721] = 1, [2461] = 1, [2649] = 1, [2510] = 1, [2787] = 10, [2175] = 1},
[27] = {[2403] = 2, [2461] = 1, [2649] = 1, [2787] = 10, [2175] = 1},
[28] = {[2403] = 2, [2461] = 1, [2649] = 1, [2787] = 10, [2175] = 1},
[29] = {[2456] = 1, [23799] = 100, [2461] = 1, [2649] = 1, [2389] = 3, [2510] = 1, [2787] = 10, [2175] = 1},
[30] = {[2455] = 1, [2543] = 100, [2461] = 1, [2649] = 1, [2389] = 3, [2510] = 1, [2787] = 10, [2175] = 1}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg, player = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg), Player(cid)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) <= npcOrder) then
                npcHandler:addFocus(cid)
                npcHandler:say({"Olá, "..getPlayerName(cid).."! Eu sou o encarregado de dar boas vindas aos seres que são invocados neste mundo e definir a classe de vocês.",
								"E você é um invocado, posso lhe dar as instruções para você começar e virar um aventureiro de sucesso!",
								"Você deseja se tornar um aventureiro?"}, cid)
                talkState = 1
			elseif  (getPlayerStorageValue(cid, storage) == npcOrder + 1) then
                npcHandler:addFocus(cid)
				npcHandler:updateFocus()
			    npcHandler:say("Você deseja se especializar em uma sub-classe?", cid)	
				talkState = 4
            else
                npcHandler:addFocus(cid)
                npcHandler:say("Olá! ah.. Talvez conversaremos outra hora...", cid)
				npcHandler:releaseFocus(cid)
                talkState = 0
            end
        else
            return false
        end   
	elseif talkState == 5 then
		for x,z in pairs(classes[player:getVocation():getId()].class.name) do
			if msgcontains(msg, z) then
				att, att2 = classes[player:getVocation():getId()].class.id[x], classes[player:getVocation():getId()].class.name[x]
				npcHandler:say("Você tem certeza que deseja se tornar um {"..classes[player:getVocation():getId()].class.name[x].."}?", cid)
				talkState = 6
			end
		end			
    elseif (msgcontains(msg, "sim") or msgcontains(msg, "yes")) and talkState == 6  then
			npcHandler:say("Parabens, você se tornou um "..att2.."!", cid)
			setPlayerStorageValue(cid, storage, npcOrder + 2)	
			player:setVocation(att)		
			reset(player)
			for x,z in pairs(items[player:getVocation():getId()]) do
				player:addItem(x, z)
			end
    elseif msgcontains(msg, "sim") and talkState == 4 and player:getStorageValue(storage) == npcOrder+1 then
		local fala = "As classes que você pode aprender são:"		
		for x,z in pairs (classes[player:getVocation():getId()].class.name) do
			fala = fala.." {("..z..")}"
		end
	    npcHandler:say(fala, cid)	
		talkState = 5
    elseif (msgcontains(msg, "sim") or msgcontains(msg, "yes")) and getPlayerStorageValue(cid, storage) == npcOrder and talkState == 1 then
        npcHandler:say("Primeiramente vamos definir sua {classe}, este mundo é repleto de aventuras e de magias, e você precisa de uma base para ficar forte neste mundo!", cid)
		talkState = 2	
    elseif (msgcontains(msg, "não") or msgcontains(msg, "no")) and getPlayerStorageValue(cid, storage) == npcOrder and talkState == 1 then
        npcHandler:say("Estou no aguardo até que você tenha certeza então!", cid)	
		npcHandler:releaseFocus(cid)	
    elseif msgcontains(msg, "classe") and talkState == 2 and (getPlayerStorageValue(cid, storage) == npcOrder) then
            npcHandler:say("Tenha certeza antes de decidir a sua classe, as classes que eu posso te ensinar no momento são: {Guerreiro}, {Mago}, {Druida}, {Arqueiro}, {defensor}, {ladrão} e {poeta}", cid)		
			talkState = 3
	--CLASSES
	elseif talkState == 3 and (getPlayerStorageValue(cid, storage) == npcOrder) then 
		if msgcontains(msg, "guerreiro") then
				npcHandler:say("Voce virou um guerreiro!", cid)
				setPlayerStorageValue(cid, storage, npcOrder + 1)
				doPlayerSetVocation(cid,1)
				npcHandler:releaseFocus(cid)
		elseif  msgcontains(msg, "Defensor") then
				npcHandler:say("Voce virou um defensor!", cid)
				setPlayerStorageValue(cid, storage, npcOrder + 1)
				doPlayerSetVocation(cid,2)		
				npcHandler:releaseFocus(cid)
		elseif  msgcontains(msg, "Mago") then
				npcHandler:say("Voce virou um mago!", cid)
				setPlayerStorageValue(cid, storage, npcOrder + 1)
				doPlayerSetVocation(cid,3)				
				npcHandler:releaseFocus(cid)
		elseif  msgcontains(msg, "Druida") then
				npcHandler:say("Voce virou um druida!", cid)
				setPlayerStorageValue(cid, storage, npcOrder + 1)
				doPlayerSetVocation(cid,4)	
				npcHandler:releaseFocus(cid)
		elseif  msgcontains(msg, "Ladrão") then
				npcHandler:say("Voce virou um ladrão!", cid)
				setPlayerStorageValue(cid, storage, npcOrder + 1)
				doPlayerSetVocation(cid,5)			
				npcHandler:releaseFocus(cid)
		elseif  msgcontains(msg, "Arqueiro") then
				npcHandler:say("Você virou um arqueiro!", cid)
				setPlayerStorageValue(cid, storage, npcOrder + 1)
				doPlayerSetVocation(cid,6)		
				npcHandler:releaseFocus(cid)	
		elseif  msgcontains(msg, "Poeta") then
				npcHandler:say("Você virou um poeta!", cid)
				setPlayerStorageValue(cid, storage, npcOrder + 1)
				doPlayerSetVocation(cid,17)		
				npcHandler:releaseFocus(cid)		
		end		
	--CLASSES
	
	elseif msgcontains(msg, "bye","tchau") then
        npcHandler:say("Tchau!", cid)
        npcHandler:releaseFocus(cid)
    else
        npcHandler:say("Não entendi..", cid)
    end
    return true
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

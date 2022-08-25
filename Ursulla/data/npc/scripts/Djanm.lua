local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npcOrder = -1 -- edite a ordem do npc
local storage = 20008


local human_male = {lookType = 128, lookHead = 0, lookBody = 0, lookLegs = 0, lookFeet = 0, lookTypeEx = 0,}
local human_female = {lookType = 136, lookHead = 0, lookBody = 0, lookLegs = 0, lookFeet = 0, lookTypeEx = 0,}
local elf_female = {lookType = 922, lookHead = 0, lookBody = 0, lookLegs = 0, lookFeet = 0, lookTypeEx = 0,}
local elf_male = {lookType = 923, lookHead = 0, lookBody = 0, lookLegs = 0, lookFeet = 0, lookTypeEx = 0,}


function creatureSayCallback(cid, type, msg)
local player = Player(cid)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"hi", "hello","ola","oi"}, msg) then
            if (getPlayerStorageValue(cid, storage) == npcOrder)  then
                npcHandler:addFocus(cid)
                npcHandler:say("Olá, "..getPlayerName(cid).."! Bem vindo ao mundo de Ursulla, um mundo repleto de aventuras e historias! eu que vou definir sua {Raça}, a raça é o principal fator da sua historia e das suas diretrizes!", cid)
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
    elseif msgcontains(msg, "raça") then
            npcHandler:say("Tenha certeza antes de decidir a sua raça! São apenas duas raças que estão disponiveis no momento: {Humano}", cid)	
    elseif msgcontains(msg, "humano") then
            setPlayerStorageValue(cid, 72000, 0)
			player:setTown(Town(1))
			player:addOutfit(128)
			player:addOutfit(136)
			player:teleportTo({x = 1045, y = 1053, z = 7})        
			if player:getSex() == 0 then			
				doCreatureChangeOutfit(player,human_female)
			else 
				doCreatureChangeOutfit(player,human_male)
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

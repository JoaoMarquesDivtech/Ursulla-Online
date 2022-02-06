
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end


local t = {
[1] = {keyword = "salutant te", text = ""}, -- palavra-chave, texto
[2] = {keyword = "meus rex", text = ""},
[3] = {keyword = "qui omnia videt", text = ""}
}

function creatureSayCallback(cid, type, msg)
local talkUser, msg = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid, string.lower(msg)
    if(not npcHandler:isFocused(cid)) then
        if isInArray({"ativar"}, msg) then
                npcHandler:addFocus(cid)
		        getCreaturePosition(cid):sendMagicEffect(16)
                talkState[talkUser] = 1
        else
            return false
        end    
    elseif t[talkState[talkUser]] and msgcontains(msg, t[talkState[talkUser]].keyword) then
            npcHandler:say(t[talkState[talkUser]].text, cid)
		        getCreaturePosition(cid):sendMagicEffect(15)			
            if talkState[talkUser] == #t then
				doTeleportThing(cid, {x = 865, y = 766, z = 9})
		        getCreaturePosition(cid):sendMagicEffect(16)				
                talkState[talkUser] = 0
            else
                talkState[talkUser] = talkState[talkUser] + 1
            end
    elseif msgcontains(msg, "bye","tchau") then
        npcHandler:say("?", cid)
        talkState[talkUser] = 0
        npcHandler:releaseFocus(cid)
    else
		getCreaturePosition(cid):sendMagicEffect(18)
        doCreatureAddHealth(cid, -100)	
        npcHandler:releaseFocus(cid)		
    end
    return true
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

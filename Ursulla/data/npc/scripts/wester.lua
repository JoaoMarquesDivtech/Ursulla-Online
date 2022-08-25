local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local voices = { {text = 'Venham aqui viajar!!!!'} }
npcHandler:addModule(VoiceModule:new(voices))

local travelNode = keywordHandler:addKeyword({'dryadalis'}, StdModule.say, {npcHandler = npcHandler, text = 'Você deseja viajar?'})
travelNode:addChildKeyword({'sim'}, StdModule.travel, {npcHandler = npcHandler, premium = true, level = 0, cost = 300, destination = Position(844, 1641, 7) })
travelNode:addChildKeyword({'não'}, StdModule.say, {npcHandler = npcHandler, reset = true, text = 'Eu entendo...'})
	

keywordHandler:addKeyword({'passagem'}, StdModule.say, {npcHandler = npcHandler, text = 'No momento eu posso te levar para {Dryadalis}'})
keywordHandler:addKeyword({'trabalho'}, StdModule.say, {npcHandler = npcHandler, text = 'No momento eu posso te levar para {Dryadalis}'})


npcHandler:setMessage(MESSAGE_GREET, 'Bem vindo! Sr/a |PLAYERNAME|. Eu {trabalho} aqui, o que você deseja?')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Tchau! Espero te ver novamente.')

npcHandler:addModule(FocusModule:new())

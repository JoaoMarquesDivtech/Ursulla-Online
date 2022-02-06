local tpId = 5023
local tps = {
        ["rei minotauro"] = {pos = {x = 906, y = 585, z = 11}, toPos = {x = 903, y = 563, z = 11}, time = 120},
        ["o espectador"] = {pos = {x = 865, y = 759, z = 9}, toPos = {x = 861, y = 747, z = 9}, time = 60},
        ["hoggoblin general"] = {pos = {x = 909, y = 1123, z = 11}, toPos = {x = 928, y = 1112, z = 11}, time = 60}
}
 
function removeTp(tp)
        local t = getTileItemById(tp.pos, tpId)
        if t then
                doRemoveItem(t.uid, 1)
                doSendMagicEffect(tp.pos, CONST_ME_POFF)
        end
end
 
function onDeath(cid)

        local tp = tps[getCreatureName(cid)]
        if tp then
                doCreateTeleport(tpId, tp.toPos, tp.pos)
                doCreatureSay(cid, "O teleport irá sumir em "..tp.time.." segundos.", TALKTYPE_ORANGE_1)
                addEvent(removeTp, tp.time*1000, tp)
        end	
        return TRUE
end
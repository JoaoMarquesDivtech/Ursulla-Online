	
	local function conect(cid1,cid2,cid3,i) 
		if cid1:isRemoved() or cid2:isRemoved() then return false end
		doSendDistanceShoot(getCreaturePosition(cid1), getCreaturePosition(cid2), 25)
		combat:execute(creature, positionToVariant(getCreaturePosition(cid2)))
	
		addEvent(function()
		if cid2:isRemoved() or cid3:isRemoved() or (i == 0) then return false end
		doSendDistanceShoot(getCreaturePosition(cid2), getCreaturePosition(cid3), 25)
		combat2:execute(creature, positionToVariant(getCreaturePosition(cid3)))
		end,200)
		
		addEvent(function()
		if cid3:isRemoved() or cid1:isRemoved() then return false end
		doSendDistanceShoot(getCreaturePosition(cid3), getCreaturePosition(cid1), 25)
		combat2:execute(creature, positionToVariant(getCreaturePosition(cid1)))
		end,400)	
	end



local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setParameter(COMBAT_PARAM_USECHARGES, true)

function onGetFormulaValues(player, skill, attack, factor)
    local força = player:getStorageValue(50001)
	local min = ((player:getLevel() / 5) + (skill * attack * 0.02)  + (força * 2.5))*0.25
    return -min, -min
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local combat2 = Combat()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat2:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)

function onGetFormulaValues(player, skill, attack, factor)
    local força = player:getStorageValue(50001)
	local min = ((player:getLevel() / 5) + (skill * attack * 0.02)  + (força * 2))*0.2
    return min, min
end

combat2:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

function onCastSpell(creature, variant)
	
	if #getCreatureSummons(creature)== 0 then 
		creature:sendCancelMessage("Voce tem que ter um clone para isto!")
		return false
	end
		
	if not Cooldown(creature,"Sword Conect",30003,35) then return false end		
	
	local pid = creature:getTarget()
	local mid = creature:getSummons()[1]
   
	for i = 0,20 do
		addEvent(function()
			if pid:isRemoved() or mid:isRemoved() or creature:isRemoved()  then return false end
			conect(creature,pid,mid,1)
		end,i*400)
	end
	
end


function onCastSpell(player, variant)

	if player:getStorageValue(50000)==0 then
		doPlayerSendCancel(player,"Você não tem inteligencia suficiente.") 
		return false
	end

	if not Cooldown(player,"Death Summon",30001,15) then return false end


	local cidpos = player:getPosition()


	if #getCreatureSummons(player)==0 then 
		monster=  "esqueleto["..(((player:getStorageValue(50000)- (player:getStorageValue(50000)%10)))/10).."]"
		local mid = Game.createMonster(monster, cidpos)
		mid:setMaxHealth(player:getStorageValue(50000)*10)
		mid:addHealth(player:getStorageValue(50000)*10)
		mid:setMaster(player)		
	else 
		local mid = player:getSummons()[1] 	
		local midpos = mid:getPosition()
		
		monster2=  "esqueleto demonio["..(((player:getStorageValue(50000)- (player:getStorageValue(50000)%10)))/10).."]"
		
		doRemoveCreature(mid)	 

		local mid2 = Game.createMonster(monster2, midpos)
		
		mid2:setMaxHealth(player:getStorageValue(50000)*20)
		mid2:addHealth(player:getStorageValue(50000)*20)
		mid2:setMaster(player)
	 
		addEvent(function()
			if not mid2:isRemoved() then
				cidpos = getCreaturePosition(player)
				doSendDistanceShoot(getCreaturePosition(mid2), cidpos, CONST_ANI_DEATH)
				doRemoveCreature(mid2)
			end
		end,9000)

	end
	
	return true

end
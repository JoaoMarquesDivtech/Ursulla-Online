function onCastSpell(player, variant)
	if not Cooldown(player,"Sword Duplicate",30001,35) then return false end

	if #getCreatureSummons(player)<=1 then
	
       	local mid = Game.createMonster("duplicate", player:getPosition())
 
		doCreatureChangeOutfit(mid,getCreatureOutfit(player))
		
		mid:setMaxHealth(player:getMaxHealth())
		doCreatureAddHealth(mid,player:getMaxHealth())
		
		mid:setMaster(player)
		
		
		local cidpos, midpos = player:getPosition(),mid:getPosition()

		doSendDistanceShoot(cidpos, midpos, 25)
		
		addEvent(function()
			if not mid:isRemoved() then
				local cidpos, midpos = getCreaturePosition(cid) ,getCreaturePosition(mid)
				doSendDistanceShoot(midpos, cidpos, 25)
				doRemoveCreature(mid)
			end
		end,20000)
	end

	return combat:execute(cid, variant)
end
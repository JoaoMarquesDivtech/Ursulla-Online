function onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)



if isPlayer(creature) and isPlayer(attacker) then

	
	
	
	local party = creature:getParty()
	local party2 = attacker:getParty()
	
if party:getLeader() == party2:getLeader() then			
primaryDamage = 0
end	
end	

return primaryDamage, primaryType, secondaryDamage, secondaryType
end 
function onThink(interval)
	local players = Game.getPlayers()
	if #players == 0 then
		return true
	end

	local player
	
	for i = 1, #players do
		player = players[i]	
		checkS(player)
	end
	return true
end

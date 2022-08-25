local spawns = {
	-- Vampires
	[1]  = {position = Position(32962, 32412, 12), monster = 'Arachir The Ancient One'},
}

function onThink(interval, lastExecution, thinkInterval)
	if math.random(1000) > 50 then
		return true
	end

	local spawn = spawns[math.random(#spawns)]
	Game.createMonster(spawn.monster, spawn.position, false, true)
	return true
end

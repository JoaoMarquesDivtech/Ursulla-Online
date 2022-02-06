local config = {
	-- ordered by chance, the last chance being 100
	{chance = 5,  monster = 'Lobisomem',   message = 'GRRRRRRRRRRRRRRR!'},
	{chance = 70, monster = 'Humano da caverna Enraivado', message = 'Eu vou te matar!!!!'}
}

function onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
	local targetMonster = creature:getMonster()
	if not targetMonster or targetMonster:getMaster() then
		return true
	end

	local chance = math.random(100)
	for i = 1, #config do
		if chance <= config[i].chance then
			local spawnMonster = Game.createMonster(config[i].monster, targetMonster:getPosition(), true, true)
			if spawnMonster then
				spawnMonster:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				targetMonster:say(config[i].message, TALKTYPE_MONSTER_SAY)
			end
			break
		end
	end
	return true
end
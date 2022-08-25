function onCastSpell(player, variant)
	getCreaturePosition(player):sendMagicEffect(CONST_ME_MAGIC_RED)
	return player:addItem(2543, 20)
end

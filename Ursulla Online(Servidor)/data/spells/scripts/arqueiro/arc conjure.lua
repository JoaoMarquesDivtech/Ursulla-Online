function onCastSpell(player, variant)
	getCreaturePosition(player):sendMagicEffect(CONST_ME_MAGIC_BLUE)
		return player:addItem(23839, 20)
end

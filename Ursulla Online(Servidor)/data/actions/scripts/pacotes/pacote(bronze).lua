function onUse(player, item, fromPosition, target, toPosition, isHotkey)


    doPlayerAddPremiumDays(player, 31)
	doPlayerAddMount(player, 24)
    
	doSendMagicEffect(getCreaturePosition(player), 28)
    item:remove()
	
	doCreatureSay(player, "Parabens você agora é um membro do pacote Bronze!", TALKTYPE_ORANGE_1)
	
	return true
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)

    doPlayerAddPremiumDays(player, 50)
	doPlayerAddMount(player, 24)
	

	--Ranger
	doPlayerAddOutfit(player, 683)
	doPlayerAddOutfit(player, 683, 1)
	doPlayerAddOutfit(player, 683, 2)
	
	--Ranger
	doPlayerAddOutfit(player, 684)
	doPlayerAddOutfit(player, 684, 1)
	doPlayerAddOutfit(player, 684, 2)

	
	doSendMagicEffect(getCreaturePosition(player), 28)
	doCreatureSay(player, "Parabens você agora é um membro do pacote Prata!", TALKTYPE_ORANGE_1)
    
    item:remove()
	
	return true
end

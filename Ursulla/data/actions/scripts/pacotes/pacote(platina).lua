function onUse(player, item, fromPosition, target, toPosition, isHotkey)

    doPlayerAddPremiumDays(player, 100)
	doPlayerAddMount(player, 24)
	doPlayerAddMount(player, 50)


    --Demon
	doPlayerAddOutfit(player, 542)
	doPlayerAddOutfit(player, 542, 1)
	doPlayerAddOutfit(player, 542, 2)

	--Demon
	doPlayerAddOutfit(player, 541)
	doPlayerAddOutfit(player, 541, 1)
	doPlayerAddOutfit(player, 541, 2)


	--Ranger
	doPlayerAddOutfit(player, 683)
	doPlayerAddOutfit(player, 683, 1)
	doPlayerAddOutfit(player, 683, 2)
	
    --Ranger
	doPlayerAddOutfit(player, 684)
	doPlayerAddOutfit(player, 684, 1)
	doPlayerAddOutfit(player, 684, 2)
	
	
	doSendMagicEffect(getCreaturePosition(player), 28)
	doCreatureSay(player, "Parabens você agora é um membro do pacote Platina!", TALKTYPE_ORANGE_1)
	
    item:remove()
	
	return true
end

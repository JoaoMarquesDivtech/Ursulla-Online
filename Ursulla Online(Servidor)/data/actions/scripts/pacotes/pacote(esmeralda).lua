function onUse(player, item, fromPosition, target, toPosition, isHotkey)

    doPlayerAddPremiumDays(player, 120)
	doPlayerAddMount(player, 24)
	doPlayerAddMount(player, 50)
	
	
    --Demon(Female)
	doPlayerAddOutfit(player, 542)
	doPlayerAddOutfit(player, 542, 1)
	doPlayerAddOutfit(player, 542, 2)
	--Conjurer(Female)
	doPlayerAddOutfit(player, 635)
	doPlayerAddOutfit(player, 635, 1)
	doPlayerAddOutfit(player, 635, 2)
	--Demon
	doPlayerAddOutfit(player, 541)
	doPlayerAddOutfit(player, 541, 1)
	doPlayerAddOutfit(player, 541, 2)
	--Conjurer(Female)
	doPlayerAddOutfit(player, 634)
	doPlayerAddOutfit(player, 634, 1)
	doPlayerAddOutfit(player, 634, 2)	

	--Ranger
	doPlayerAddOutfit(player, 683)
	doPlayerAddOutfit(player, 683, 1)
	doPlayerAddOutfit(player, 683, 2)
    
	--Ranger
	doPlayerAddOutfit(player, 684)
	doPlayerAddOutfit(player, 684, 1)
	doPlayerAddOutfit(player, 684, 2)

	

	doPlayerAddItem(player, 26394,10)
	
	doCreatureSay(player, "Parabens você agora é um membro do pacote Esmeralda, o mais alto pacote do Ursulla Online!", TALKTYPE_ORANGE_1)
    item:remove()
	
	return true
end

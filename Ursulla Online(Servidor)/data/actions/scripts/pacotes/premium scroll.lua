function onUse(player, item, fromPosition, target, toPosition, isHotkey)


    doPlayerAddPremiumDays(player, 31)
    item:remove()
	
	return true
end

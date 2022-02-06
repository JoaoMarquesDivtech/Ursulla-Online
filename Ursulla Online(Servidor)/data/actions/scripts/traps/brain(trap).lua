function onUse(player, item, fromPosition, target, toPosition, isHotkey)

    local ver = 0

		 for i = 0,30 do	 
         addEvent(function()
		    if ver == 1 then return false end
			if player:isRemoved() then 
				ver = 1			
			end
			if i == 30 and ver == 0 then
            doTeleportThing(player, 994, 1096, 10)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Ufa!")
			end
			end, 500*i)
		 end
        doTeleportThing(player, {x = 1010, y = 1097, z = 10})
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Tenho de sobreviver..")

	return true
end

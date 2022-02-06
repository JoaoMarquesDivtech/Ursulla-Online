-- <action itemid="ITEMID" script="other/stamina_refuel.lua"/> 

local stamina_full = 42 * 60 -- config. 42 = horas

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	
	if player:getStamina() >= stamina_full then
		player:sendCancelMessage("Sua stamina está cheia!")
	elseif player:getPremiumDays() < 1 then
		player:sendCancelMessage("Você não é premium.")
	else
		player:setStamina(stamina_full)
		player:sendTextMessage(MESSAGE_INFO_DESCR, "Sua stamina voltou ao normal!")
		item:remove(1)
	end
	
	return true
end
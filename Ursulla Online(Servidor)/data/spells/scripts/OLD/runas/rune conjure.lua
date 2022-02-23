local config = {
[15] = {ID={26415,26416,26417,26418,26419}},
[16] = {ID={26420,26421,26422,26423,26424}},
[19] = {ID={26420,26421,26422,26423,26424}},
[20] = {ID={26425,26426,26427,26428,26429}},
[21] = {ID={26430,26431,26432,26433,26434}},
[22] = {ID={26435,26436,26437,26438,26439}},
[23] = {ID={26435,26436,26437,26438,26439}},
[24] = {ID={26435,26436,26437,26438,26439}},
[25] = {ID={2293,2269,26437,26438,26439}}
}

function onCastSpell(creature, variant)

if config[getPlayerVocation(creature)] == nil then 
	creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você não tem uma sub-classe adequada para isto!")
	return false
end

local runa = config[getPlayerVocation(creature)]

if creature:getItemCount(2260)>=1 and creature:getItemCount(26382)>=1 then
	creature:removeItem(2260,1)	    
	creature:removeItem(26383,1)	    
else 
	getCreaturePosition(creature):sendMagicEffect(3)		
	return false
end




local tier = math.random(0, creature:getStorageValue(49999))
if (tier>=25) then tier = 25 end
if (tier<=5) then tier = 5 end
tier = ((tier-(tier%5))/5)

getCreaturePosition(creature):sendMagicEffect(CONST_ME_MAGIC_BLUE)
creature:addItem(runa.ID[tier], math.random(1,3))


end

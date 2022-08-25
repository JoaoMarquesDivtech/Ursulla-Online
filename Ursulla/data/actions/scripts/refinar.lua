function onUse(creature, item, fromPosition, itemEx, toPosition)



local cpos = creature:getPosition()
local chao = Tile(cpos):getGround()
if chao:getActionId() == 666 then

if itemEx:getId() >= 26382 and itemEx:getId() <= 26390  then 

else 
creature:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, 'Não consigo refinar esse item!')
return false
end

local quebrar = (itemEx:getId()-26382)*10

if math.random(0,100)<=quebrar then 
itemEx:remove(10)
creature:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT)
creature:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, 'O item quebrou!')
return false
end

if itemEx:remove(10) then
creature:addItem(itemEx:getId()+1,1)
creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
else
creature:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, 'Acho que preciso de mais!!')
end


else 
creature:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, 'Local inapropriado!!!')
end




end
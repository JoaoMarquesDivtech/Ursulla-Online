


local magias = {
	{Nome= RACE_VENOM, chance = 15, tipo = "Natureza"},
	{Nome= RACE_UNDEAD, chance = 6, tipo = "Morte" },
	{Nome= RACE_FIRE, chance = 8, tipo = "Fogo"},
	{Nome= RACE_ENERGY, chance = 5, tipo = "Eletrico"},
}




function onKill(creature, target)
    if target:isMonster()  then

        local tier = ((target:getMaxHealth() - target:getMaxHealth()%2000)/2000) + 1

        local race = target:getType():getRace()
        for i =1, #magias do
            if(race == magias[i].Nome) then
                if(math.random(1,1000)<=magias[i].chance) then
                    if(creature:isPlayer()) then
                        local item = creature:addItem(8983, 1)
                        item:setAttribute("description", magias[i].tipo.."/+"..tier)
                    end
                end
            end
        end
    end
    return true
end


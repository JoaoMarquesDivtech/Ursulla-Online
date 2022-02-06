local condition = createConditionObject(CONDITION_HASTE)
setConditionParam(condition, CONDITION_PARAM_SPEED, 200)
setConditionParam(condition, CONDITION_PARAM_TICKS, 1000)
setConditionParam(condition, CONDITION_PARAM_BUFF_SPELL, 1)


local combat = Combat()
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, 0)
setCombatParam(combat,COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_RED)
setCombatCondition(combat, condition)


function onCastSpell(player, variant)
  
	if not Cooldown(player,"Barbarian Rage",30003,24) then return false end

    player:setStorageValue(29997,1)
	
    for i= 1,10 do
		addEvent(function()	
			if player:isRemoved() then return false end  
			combat:execute(player, Variant(player:getPosition()))
			if (i == 10) then 
				player:setStorageValue(29997,0) 
			end
		end,i*1000)
	end

	
	return combat:execute(player, variant)
	
end

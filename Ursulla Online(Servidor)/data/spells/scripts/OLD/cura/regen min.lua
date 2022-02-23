local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

function onGetFormulaValues(player, level, maglevel)
	local min = ((level / 5) + (maglevel) + 50)*0.1
	local max = ((level / 5) + (maglevel) + 50)*0.1
	return min, max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(player, variant)
  
	if not Cooldown(player,"Regen min",29999,15) then return false end
   
    for i= 0,9 do
		addEvent(function()	
			if player:isRemoved() then return false end
			combat:execute(player, Variant(player:getPosition()))
		end,i*1000)
	end
	
	
	return true
end

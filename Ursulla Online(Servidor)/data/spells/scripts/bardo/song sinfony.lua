local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 20)
combat:setArea(createCombatArea(AREA_CIRCLE2X2))


function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel*1.5) + (INTELIGENCIA(player)*1.5)
	return -min, -min
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(player, variant)
     
	if not Cooldown(player,"song sinfony",30003,10) then return false end
	
	for i=1,8 do
		addEvent(function()
			if player:isRemoved() then return false end
			combat:execute(player, Variant(player:getPosition()))
		end,i*600)
	end
	
end

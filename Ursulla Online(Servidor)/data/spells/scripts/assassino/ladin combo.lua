local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_USECHARGES, true)


function onGetFormulaValues(player, skill, attack, factor)
	local min = ((player:getLevel() / 5) + (skill + attack)*0.5  + (PRECISAO(player) * 2))*0.3
    return -min, -min
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

function onCastSpell(player, variant)

	if not Cooldown(player,"Ladin combo",30001,7) then return false end

	local pid = player:getTarget()
	
	for i=0,2 do
		addEvent(function()
		if pid:isRemoved() or player:isRemoved() then return false end
		combat:execute(player, variant)
		end,i*210)
	end

end
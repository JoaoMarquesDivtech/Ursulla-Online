local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_USECHARGES, true)

function onGetFormulaValues(player, skill, attack, factor)
	local min = ((player:getLevel() / 5) +(skill + attack)*0.5   + (FORCA(player)  * 3))*0.35
    return -min, -min
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

function onCastSpell(player, variant)

	if not Cooldown(player,"Ceifer Combo",30002,14) then return false end

	local pid = player:getTarget()

	for i=1,2 do
	addEvent(function()
		local pos = pid:getPosition()
		if pid:isRemoved() or player:isRemoved() then return false end
		combat:execute(player,Variant(pos))
	end,i*200)
	end


	return combat:execute(player, variant)
end
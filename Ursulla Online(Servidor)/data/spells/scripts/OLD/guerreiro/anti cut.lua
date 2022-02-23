local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 2)
combat:setParameter(COMBAT_PARAM_USECHARGES, true)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)

function onGetFormulaValues(player, skill, attack, factor)
	local min = (player:getLevel() / 5) + (skill + attack)*0.5  + (FORCA(player) * 2) + (SABEDORIA(player) * 0.5)
    return -min, -min
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

function onCastSpell(player, variant)
		
	if not Cooldown(player,"Anti Cut",30000,4) then return false end


	local pid, formula = player:getTarget(),(player:getStorageValue(49999)*0.4) + 4

	if isPlayer(pid) then
		pid:addMana(-formula, true)
	end

	player:addMana(formula, true)

	return combat:execute(player, variant)
end
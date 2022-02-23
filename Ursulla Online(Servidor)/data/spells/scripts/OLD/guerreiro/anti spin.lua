local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 2)
combat:setParameter(COMBAT_PARAM_USECHARGES, true)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setArea(createCombatArea(AREA_SQUARE1X1))


function onGetFormulaValues(player, skill, attack, factor)
	local min = (player:getLevel() / 5) + (skill + attack)*0.5  + (FORCA(player) * 2) + (SABEDORIA(player) * 0.25)
    return -min, -min
end


combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(player, variant)

	if not Cooldown(player,"Anti Spin",30002,14) then return false end

	local formula, spectators = (player:getStorageValue(49999)*0.4) + 4, Game.getSpectators(player:getPosition(),false,false, 1, 1, 1, 1)


	for j=1,#spectators do
		if isPlayer(spectators[j]) and spectators[j] ~= player then
			player:addMana(-formula, true)
			player:addMana(formula, true)
		elseif isCreature(spectators[j]) and spectators[j] ~= player then
			player:addMana(formula, true)
		end
	end

	return combat:execute(player, variant)
end
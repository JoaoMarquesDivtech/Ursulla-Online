local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setParameter(COMBAT_PARAM_USECHARGES, true)
combat:setArea(createCombatArea(AREA_SQUARE1X1))

function onGetFormulaValues(player, skill, attack, factor)
    local forca = player:getStorageValue(50001)
	local min = (player:getLevel() / 5) + (skill + attack)*0.5  + (forca * 2.5)
    return -min, -min
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

function onCastSpell(player, variant)
   
   if not Cooldown(player,"Sword Spin",30002,8) then return false end
	
	
	if #player:getSummons()[1] == 1 then
		local pos = player:getSummons()[1]:getPosition()
		combat:execute(player, positionToVariant(pos))
	end
	
	return combat:execute(player, variant)
end

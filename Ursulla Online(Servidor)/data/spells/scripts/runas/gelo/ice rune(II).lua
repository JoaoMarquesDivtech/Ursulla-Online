local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICEAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ICE)
combat:setArea(createCombatArea(AREA_CIRCLE3X3))

function onGetFormulaValues(player, level, maglevel)
    local inteligencia = player:getStorageValue(50000)
	local min = (inteligencia*2.7)+ (maglevel * 0.3)
	local max = (inteligencia*2.7)+ (maglevel * 0.3) 
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(creature, variant, isHotkey)
if not Cooldown(creature,"Ice Rune",30010,9) then return false end
if creature:isPlayer() then
		local city = CityWars.getPlayerWar(creature)
		if city and not city:onCastSpell(creature, 'areaSpell') then
			return false
		end
	end
	return combat:execute(creature, variant)
end

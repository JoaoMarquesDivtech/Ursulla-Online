local combat = Combat()
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_EARTH)
combat:setParameter(COMBAT_PARAM_CREATEITEM, ITEM_WILDGROWTH)

function onCastSpell(creature, variant, isHotkey)

	if not Cooldown(creature,"Prision Rune",30010,8) then return false end

	return combat:execute(creature, variant)
end

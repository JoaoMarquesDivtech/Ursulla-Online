local combat = Combat()
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)
combat:setParameter(COMBAT_PARAM_CREATEITEM, ITEM_MAGICWALL)

function onCastSpell(creature, variant, isHotkey)
	if not Cooldown(creature,"Prision Rune",30010,6) then return false end


	return combat:execute(creature, variant)
end

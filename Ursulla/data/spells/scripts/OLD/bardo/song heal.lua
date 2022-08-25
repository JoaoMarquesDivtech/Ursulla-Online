local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat:setParameter(COMBAT_PARAM_EFFECT, 19)
combat:setArea(createCombatArea(AREA_CIRCLE2X2))
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)


local combat2 = Combat()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat2:setParameter(COMBAT_PARAM_EFFECT, 19)
combat2:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel*2) + (INTELIGENCIA(player)*3)
	return min, min
end

combat2:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onTargetCreature(player, target)

	local party = player:getParty()
	
	if isMonster(target) then return true end
	
	if not party then
		return combat2:execute(player, Variant(target:getPosition()))
	end

	local membersList = party:getMembers()
	membersList[#membersList + 1] = party:getLeader()
	
	if membersList == nil or type(membersList) ~= 'table' or #membersList <= 1 then
		return true
	end
	
	for i = 1,#membersList do
		if target == membersList[i] then 
			return combat2:execute(player, Variant(target:getPosition()))
		end
	end

end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

function onCastSpell(player, variant)
     
	if not Cooldown(player,"song heal",30003,15) then return false end
	
	for i=1,9 do
		addEvent(function()
			if player:isRemoved() then return false end
			combat:execute(player, Variant(player:getPosition()))
		end,i*600)
	end
	
	return combat:execute(player, variant)
	
end

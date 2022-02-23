local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat:setParameter(COMBAT_PARAM_EFFECT, 40)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)


function onGetFormulaValues(player, level, maglevel)
	local min = ((level / 5) + (maglevel) + 8 + (INTELIGENCIA(player)*2))*0.5
	return min, min
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")


function onCastSpell(player, variant)

    if not Cooldown(player,"Light Regen",30004,35) then return false end

	for i=0,15 do
		addEvent(function()
			if player:isRemoved() then return false end
			doCombat(player, combat, Variant(player:getPosition()))
		end,i*1500)
	end
	
	local party = player:getParty()
	if not party then
		return false
	end

	local membersList = party:getMembers()
	membersList[#membersList + 1] = party:getLeader()
	
	if membersList == nil or type(membersList) ~= 'table' or #membersList <= 1 then
		return false
	end
	
	
	local spectators = Game.getSpectators(player:getPosition(),false,false, 2, 2, 2, 2)
	
	for i = 1,#spectators do
		for j = 1,#membersList do
			if (spectators[i] == membersList[j]) then 
				for i=0,15 do
					addEvent(function()
						if membersList[j]:isRemoved() then return false end
						combat:execute(player, Variant(membersList[j]:getPosition()))
					end,i*1500)
				end
			end
		end
	end



	return true
end

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 49)

function onGetFormulaValues(player, level, maglevel)
	local min = ((INTELIGENCIA(player)*1) + (level / 5) + (maglevel * 0.5))*0.1
	return -min, -min
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")




function onTargetCreature(player, target)

	local spectators = Game.getSpectators(target:getPosition(),false,false, 1, 1, 1, 1)
	if #spectators == 1 then return false end
	
	local nex = {}
	
	for i = 1,#spectators do
		if spectators[i] ~= target and spectators[i]~=player then 
			table.insert(nex, spectators[i])
		end	
	end
	
	if nex == nil then return false end
	
	local atc = math.random(1, #nex)
	
	if math.random(1,100)<=3 then return false end
	
	addEvent(function()
	    if nex[atc]:isRemoved() or player:isRemoved() or target:isRemoved()  then return false end
		target:getPosition():sendDistanceEffect(nex[atc]:getPosition(), 56)
		combat:execute(player, Variant(nex[atc]:getPosition()))
	end,100)
	
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

function onCastSpell(player, variant)

    if not Cooldown(player,"Shock Static",30004,18) then return false end
	
	player:getPosition():sendDistanceEffect(player:getTarget():getPosition(), 56)
	
	return combat:execute(player, variant)
end

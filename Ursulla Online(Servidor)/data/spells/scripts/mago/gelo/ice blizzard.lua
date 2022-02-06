--Spell by Jovial/Edited by Taag
local water = {490, 491, 492, 493, 4608, 4609, 4610, 4611, 4612, 4613, 4614, 4615, 4616, 4617, 4618, 4619, 4620, 4621, 4622, 4623, 4624, 4625}

local combat = createCombatObject()

local meteor = createCombatObject()
setCombatParam(meteor, COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
setCombatParam(meteor, COMBAT_PARAM_EFFECT, 44)


function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel) + 8 + (INTELIGENCIA(player)*3)
	return -min, -min
end

meteor:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local condition = createConditionObject(CONDITION_HASTE)
setConditionParam(condition, CONDITION_PARAM_SPEED, -80)
setConditionParam(condition, CONDITION_PARAM_TICKS, 3000)
setConditionParam(condition, CONDITION_PARAM_BUFF, TRUE)
setCombatCondition(meteor, condition)


local meteor_water = createCombatObject()
setCombatParam(meteor_water, COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
setCombatParam(meteor_water, COMBAT_PARAM_EFFECT, CONST_ME_LOSEENERGY)
setCombatFormula(meteor_water, COMBAT_FORMULA_LEVELMAGIC, -4.6, -200, -4.2, -200)

combat_arr = {
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
{1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1},
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
}

local combat_area = createCombatArea(combat_arr)
setCombatArea(combat, combat_area)

local function meteorCast(p)
	doCombat(p.player, p.combat, positionToVariant(p.pos))
end


function onTargetTile(player, pos)
	if (math.random(0, 3) == 1) then
		local ground = getThingfromPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0})
		if (isInArray(water, ground.itemid) == TRUE) then
			local newpos = {x = pos.x - 7, y = pos.y - 6, z = pos.z}
			doSendDistanceShoot(newpos, pos, 29)
			addEvent(meteorCast, 200, {player = player, pos = pos, combat = meteor_water})
		else
			local newpos = {x = pos.x - 7, y = pos.y - 6, z = pos.z}
			doSendDistanceShoot(newpos, pos, 29)
			addEvent(meteorCast, 200, {player = player,pos = pos, combat = meteor})
		end
	end
end

setCombatCallback(combat, CALLBACK_PARAM_TARGETTILE, "onTargetTile")

function onCastSpell(player, var)
	return doCombat(player, combat, var)
end

function onCastSpell(player, var)

    if not Cooldown(player,"Ice Blizzard",30003,25) then return false end

    for i=1,5 do
		addEvent(function()
			if player:isRemoved() then return false end
			doCombat(player, combat, Variant(player:getPosition()))
			end,i*400)
	end

end
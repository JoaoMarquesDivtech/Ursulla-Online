local json = require('data/creaturescripts/scripts/json')

local spellList = {
    ["Warrior Strike"] = {level = 1, mana = 10, storage = 30000, cooldown = 5, vocations = {1}, icon = "1", description = "..."},
    ["Defensive Strike"] = {level = 1, mana = 10, storage = 30000, cooldown = 6, vocations = {2}, icon = "2", description = "..."},
    ["Energy Strike"] = {level = 1, mana = 10, storage = 30000, cooldown = 4, vocations = {3}, icon = "2", description = "..."},
    ["Element Strike"] = {level = 1, mana = 10, storage = 30000, cooldown = 4, vocations = {4}, icon = "1", description = "..."},
    ["Assassin Strike"] = {level = 1, mana = 10, storage = 30000, cooldown = 3, vocations = {5}, icon = "1", description = "..."},
    ["Arc Strike"] = {level = 1, mana = 10, storage = 30000, cooldown = 3, vocations = {6}, icon = "1", description = "..."},
    ["Camp Strike"] = {level = 1, mana = 10, storage = 30000, cooldown = 3, vocations = {30}, icon = "1", description = "..."},
    ["Arc Conjure"] = {level = 1, mana = 5, storage = 0, cooldown = 0, vocations = {6}, icon = "2", description = "Conjura 20 flechas!"},
}

local opcodeNumber = 107

local function sendPlayerLevel(player)
    local buffer = {["getPlayerLevel"] = player:getLevel()}
    sendBuffer(player, json.encode(buffer))
end

local function sendSpells(player)
    local spells = {}
    local vocation = player:getVocation()

    for inst, values in pairs(spellList) do
        if table.find(values.vocations, vocation) then
            local inside = {name = inst, lvl, values.level, mana = values.mana, storage = values.storage, cooldown = values.cooldown,
                vocation = values.vocation, icon = "img/"..values.icon, description = values.description
            }
            table.insert(spells, inside)
        end
    end

    table.sort(spells, function(a, b) return (a.lvl < b.lvl) end)

    local buffer = {["getSpells"] = spells}
    sendBuffer(player, json.encode(buffer))
end

local function sendBuffer(player, buffer)
    player.sendExtendedOpcode(player, opcodeNumber, buffer)
end

function onExtendedOpcode(player, opcode, buffer)
    if opcode == opcodeNumber then
        if buffer == "getPlayerLevel" then
		    print("Entrou no retorno de level")
            sendPlayerLevel(player)
        elseif buffer == "getSpells" then
            sendSpells(player)
			print("Entrou no retorno de spells")
        end
    end
end

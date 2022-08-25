local OPCODE = 55
local VERSION = "1.0"
local MESSAGE = "O seu cliente esta desatualizado, é de extrema importância que você faca o download do novo client ("..VERSION..") em nosso website."

function onExtendedOpcode(player, opcode, buffer)
    if opcode == OPCODE then
        local data = stringSplit(buffer, ",")

        if data[1] == "clientVersion" then
            CLIENT_VERSION = data[2]
            if CLIENT_VERSION ~= VERSION then
                player:sendTextMessage(MESSAGE_STATUS_WARNING, MESSAGE)
            end
        end
    end
end

function stringSplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end
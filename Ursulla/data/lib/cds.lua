--Functions

function Cooldown(self,spell,storage,waittime)

--miss!
if self:getStorageValue(79000)==0 then
if math.random(0,100)>=50 then
self:say("Errou!", TALKTYPE_MONSTER_SAY)
return false
end
end
--miss!

local seconds = waittime-waittime*(self:getStorageValue(50004)*(0.0005))

if (Player.getExhaustion(self,storage)>0) then
doPlayerSendCancel(self, ""..spell..":[" .. Player.getExhaustion(self,storage) .. "]")
return false
else
Player.setExhaustion(self, storage, seconds)
return true
end

end




-- CONSTANTS
Cooldowns = {
--Cura
["cure min"] = {Storage = 29999, CD = 9},
["regen min"] = {Storage = 29999, CD = 9},
["cure medium"] = {Storage = 29999, CD = 10},
["regen medium"] = {Storage = 29999, CD = 10},
["cure max"] = {Storage = 29999, CD = 11},
["regen max"] = {Storage = 29999, CD = 11},

--Runa
["Runa"] = {Storage = 30010, CD = 10},

--Sub Guerreiros--Sub Guerreiros--Sub Guerreiros--Sub Guerreiros--Sub Guerreiros

["warrior strike"] = {Storage = 30000, CD = 5},

--Cavaleiro
["fiel cut"] = {Storage = 30000, CD = 5},
["fiel tuocut"] = {Storage = 30001, CD = 13},
["fiel vanguard"] = {Storage = 30002, CD = 6},
["fiel bleeding"] = {Storage = 30003, CD = 22},
["fiel challenge"] = {Storage = 30004, CD = 12},

--Gladiador
["barbarian shot"] = {Storage = 30000, CD = 3},
["barbarian combo"] = {Storage = 30001, CD = 13},
["barbarian impact"] = {Storage = 30002, CD = 24},
["barbarian rage"] = {Storage = 30003, CD = 25},

--Espadachim
["sword cut"] = {Storage = 30000, CD = 3},
["sword duplicate"] = {Storage = 30001, CD = 40},
["sword spin"] = {Storage = 30002, CD = 40},
["sword conect"] = {Storage = 30003, CD = 8},

--Ceifador
["ceifer cut"] = {Storage = 30000, CD = 8},
["ceifer spin"] = {Storage = 30001, CD = 15},
["ceifer combo"] = {Storage = 30002, CD = 24},
["ceifer bleeding"] = {Storage = 30003, CD = 24},

--Anti Mago
["anti cut"] = {Storage = 30000, CD = 4},
["anti shield"] = {Storage = 30001, CD = 30},
["anti spin"] = {Storage = 30002, CD = 14},
["anti trade"] = {Storage = 30003, CD = 35},
["anti poison"] = {Storage = 30004, CD = 40},

--Sub Guerreiros--Sub Guerreiros--Sub Guerreiros--Sub Guerreiros--Sub Guerreiros

--Sub Arqueiros--Sub Arqueiros--Sub Arqueiros--Sub Arqueiros--Sub Arqueiros

["arc strike"] = {Storage= 30000, CD = 3},

--Cacador
["arc multistrike"] = {Storage= 30001, CD = 9},
["arc fly"] = {Storage= 30002, CD = 17},
["arc gran strike"] = {Storage= 30003, CD = 22},

--Atirador
["camp strike"] = {Storage= 30000, CD = 3},
["camp combo"] = {Storage= 30001, CD = 11},
["camp allowed"] = {Storage= 30002, CD = 16},
["camp gran strike"] = {Storage= 30003, CD = 22},

--Sub Arqueiros--Sub Arqueiros--Sub Arqueiros--Sub Arqueiros--Sub Arqueiros

--Sub Magos--Sub Magos--Sub Magos--Sub Magos
["energy strike"] = {Storage= 30000, CD = 4},

--Fogo
["fire ball"] = {Storage= 30000, CD = 4},
["fire wave"] = {Storage= 30001, CD = 8},
["fire pull"] = {Storage= 30002, CD = 14},
["fire burn"] = {Storage= 30003, CD = 17},

--Gelo
["ice strike"] = {Storage= 30000, CD = 3},
["ice wave"] = {Storage= 30000, CD = 9},
["ice frost"] = {Storage= 30000, CD = 11},
["ice blizzard"] = {Storage= 30000, CD = 26},

--Trevas
["death strike"] = {Storage= 30000, CD = 3},
["death summon"] = {Storage= 30001, CD = 18},
["death curse"] = {Storage= 30002, CD = 29},
["death combo"] = {Storage= 30003, CD = 12},

--Raio
["shock strike"] = {Storage= 30000, CD = 3},
["shock charge"] = {Storage= 30001, CD = 20},
["shock beam"] = {Storage= 30002, CD = 9},
["shock thunder"] = {Storage= 30003, CD = 26},

--Sub Druidas--Sub Druidas--Sub Druidas--Sub Druidas
["element strike"] = {Storage= 30000, CD = 4},

--Luz
["light strike"] = {Storage= 30000, CD = 4},
["light min cure"] = {Storage= 30001, CD = 9},
["light cure"] = {Storage= 30001, CD = 9},
["light beam"] = {Storage= 30002, CD = 9},
["light gran cure"] = {Storage= 30003, CD = 26},
["light regen"] = {Storage= 30004, CD = 47},

--Natureza
["nature strike"] = {Storage= 30000, CD = 4},
["nature wave"] = {Storage= 30001, CD = 9},
["nature strike"] = {Storage= 30002, CD = 9},
["nature rage"] = {Storage= 30003, CD = 24},


--Sub Assassinos--Sub Assassinos--Sub Assassinos--Sub Assassinos
["thief strike"] = {Storage= 30000, CD = 4},

--Ladino
["ladin cut"] = {Storage= 30000, CD = 2},
["ladin combo"] = {Storage= 30001, CD = 9},
["ladin poison"] = {Storage= 30002, CD = 19},
["ladin invisible"] = {Storage= 30003, CD = 30},

--Assassino
["assassin strike"] = {Storage= 30000, CD = 3},
["assassin combo"] = {Storage= 30001, CD = 9},
["assassin poison"] = {Storage= 30002, CD = 19},
["assassin invisible"] = {Storage= 30003, CD = 30},

--Sub Poeta--Sub Poeta--Sub Poeta--Sub Poeta
["song strike"] = {Storage= 30000, CD = 6},
["song wave"] = {Storage= 30001, CD = 9},
["song silence"] = {Storage= 30002, CD = 22},

--Trovador
["song inspire"] = {Storage= 30003, CD = 6},
["song poetize"] = {Storage= 30004, CD = 6},
--Bardo
["song heal"] = {Storage= 30003, CD = 22},
["song sinfony"] = {Storage= 30003, CD = 22},

--Sub Defensor--Sub Defensor--Sub Defensor--Sub Defensor
["defensive strike"] = {Storage= 30000, CD = 6},

--Guardiao
["guardian clock"] = {Storage= 30000, CD = 6},
["guardian allowed"] = {Storage= 30001, CD = 11},
["guardian atract"] = {Storage= 30002, CD = 2},
["guardian defensive"] = {Storage= 30003, CD = 35},

--Templario
["templar clock"] = {Storage= 30000, CD = 6},
["templar reveal"] = {Storage= 30001, CD = 22},
["templar blessed"] = {Storage= 30002, CD = 22},
["templar spin"] = {Storage= 30003, CD = 15},

--Paladino
["paladin clock"] = {Storage= 30000, CD = 5},
["paladin allowed"] = {Storage= 30000, CD = 19},
["paladin defensive"] = {Storage= 30000, CD = 35},
["paladin light"] = {Storage= 30000, CD = 22},

}




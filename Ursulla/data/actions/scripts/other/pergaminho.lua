
local function split(pString, pPattern)
	local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
	local fpat = "(.-)" .. pPattern
	local last_end = 1
	local s, e, cap = pString:find(fpat, 1)
	while s do
	   if s ~= 1 or cap ~= "" then
	  table.insert(Table,cap)
	   end
	   last_end = e+1
	   s, e, cap = pString:find(fpat, last_end)
	end
	if last_end <= #pString then
	   cap = pString:sub(last_end)
	   table.insert(Table, cap)
	end
	return Table
 end



local magias = {
	{Nome= "fire ball", tier = 1, tipo = COMBAT_FIREDAMAGE},
	{Nome= "ice strike", tier = 1, tipo = COMBAT_ICEDAMAGE},
	{Nome= "death strike", tier = 1, tipo = COMBAT_DEATHDAMAGE},
	{Nome= "energy strike", tier = 1, tipo = COMBAT_ENERGYDAMAGE},
	{Nome= "light strike", tier = 1, tipo = COMBAT_HOLYDAMAGE},
	{Nome= "element strike", tier = 1, tipo = COMBAT_EARTHDAMAGE},
}





function onUse(player, item, fromPosition, target, toPosition, isHotkey)

	print("Teste")
	if(item:getName() ~= "Pergaminho de Magia") then
		return false
	end

	local atributos = item:getDescription()
	local table = {}
	local tier, tipo = atributos.split("-", atributos)[0],atributos.split("-", atributos)[1]  

	for i = 1, #magias do
		if(tier == magias[i].tier and tipo == magias[i].tipo) then
			table.insert(magias.nome)	
		end
	end

	item:setAttribute("name", table[math.random(1, #table)])


	return true
end

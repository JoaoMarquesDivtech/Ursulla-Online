local function split (inputstr, sep)
	if sep == nil then
			sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			table.insert(t, str)
	end
	return t
end

local function trim(input)
	return  input:gsub("%s+","")
end



local magias = {
	{Nome= "fire ball", tier = 1, tipo = "Fisico"},
	{Nome= "ice strike", tier = 1, tipo = "Gelo"},
	{Nome= "death strike", tier = 1, tipo = "Morte"},
	{Nome= "energy strike", tier = 1, tipo = "Eletrico"},
	{Nome= "light strike", tier = 1, tipo = "Sagrado"},
	{Nome= "element strike", tier = 1, tipo = "Natureza"}
}


function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local atributos = split(item:getDescription(),".")[4]
	print(atributos)
	local tabela = {}
	local tipo, tier = split(atributos, "/")[1], split(split(atributos, "/")[2],"+")[1]  
	local tier = tonumber(tier)
	local tipo = trim(tipo)
    print(tipo)
    
	for i = 1, #magias do
		if(tier == magias[i].tier and tipo == magias[i].tipo) then
			table.insert(tabela, magias[i].Nome)	
		end
	end

	if(#tabela ~= 0) then
		item:transform(21251)
		item:setAttribute("name", tabela[math.random(1, #tabela)])
		item:setAttribute("description", "Use para aprender a magia contida!")
	end

	return true
end
local config = {
	storage = 7007,
	version = 1, 
	marks = {
		{mark = 8, pos = {x = 1026, y = 1042, z = 7}, desc = "Dungeon!"},
		{mark = 8, pos = {x = 1066, y = 993, z = 7}, desc = "Ursos(Lvl:8)"},
		{mark = 8, pos = {x = 981, y = 958, z = 7}, desc = "Ursos(Lvl:8)"},
		{mark = 8, pos = {x = 1000, y = 899, z = 7}, desc = "Cyclops(Lvl:15)"},
		{mark = 8, pos = {x = 1060, y = 1063, z = 7}, desc = "Troll/Sangue-Sugas(Lvl:1)"},
		{mark = 8, pos = {x = 987, y = 1015, z = 7}, desc = "Morcegos/Lobos(Lvl:1)"},
		{mark = 2, pos = {x = 1070, y = 1097, z = 7}, desc = "Academia!"},
		{mark = 2, pos = {x = 1058, y = 1107, z = 7}, desc = "Biblioteca!"},
		{mark = 2, pos = {x = 1052, y = 973, z = 7}, desc = "Torre do mago(Criar magias)!"},
		{mark = 2, pos = {x = 1095, y = 1079, z = 7}, desc = "Castelo do Lord!"},
		{mark = 3, pos = {x = 1045, y = 1053, z = 7}, desc = "Templo!"},
		{mark = 11, pos = {x = 1013, y = 1103, z = 7}, desc = "Loja de Porções!"},
		{mark = 11, pos = {x = 1041, y = 1094, z = 7}, desc = "Loja de Comidas!"},
		{mark = 11, pos = {x = 1072, y = 1080, z = 7}, desc = "Loja de munições!"},
		{mark = 11, pos = {x = 1025, y = 1081, z = 7}, desc = "Loja de armas!"},
		{mark = 11, pos = {x = 1035, y = 1073, z = 7}, desc = "Banco!"},
		{mark = 8, pos = {x = 955, y = 1650, z = 6}, desc = "Texugo(Lvl:1)"},	
		{mark = 8, pos = {x = 933, y = 1592, z = 7}, desc = "Troll da natureza(Lvl:8)"},	
		{mark = 8, pos = {x = 871, y = 1577, z = 7}, desc = "Duendes(Lvl:20)"},	
		{mark = 8, pos = {x = 1066, y = 1504, z = 7}, desc = "Golem da natureza(Lvl:15)"},	
		{mark = 8, pos = {x = 902, y = 1405, z = 7}, desc = "Macacos(Lvl:15)"},	
		{mark = 8, pos = {x = 1002, y = 1639, z = 3}, desc = "Casa de treinos!"},	
		{mark = 11, pos = {x = 1014, y = 1653, z = 5}, desc = "Venda de produtos de criaturas!"},		
		{mark = 11, pos = {x = 1002, y = 1639, z = 4}, desc = "Loja de munições!"},		
		{mark = 11, pos = {x = 1000, y = 1628, z = 5}, desc = "Loja de porções!"}
	
}
}


function onLogin(cid)
	
		local player = Player(cid)
		
		if(isPlayer(player) == false or player:getStorageValue(config.storage) == config.version) then
		return true
		end

			for _, m  in pairs(config.marks) do
				doAddMapMark(player, m.pos, m.mark, m.desc ~= nil and m.desc or "")
			end
		reset(cid)	
		player:setStorageValue(config.storage, config.version)
	return true
end
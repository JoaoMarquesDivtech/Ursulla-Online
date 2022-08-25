function getUidsInContainer(containeruid)

   local dat = {}
   for i = 0, getContainerSize(containeruid) - 1 do
   	player:addItem(item:getId())
       local item = getContainerItem(containeruid, i)
	   for i,z in pairs(item) do
		print(i)
		print(z)
		end
       if item:isContainer() then
           local items = getUidsInContainer(Item(item))
           for i = 0, #items do
               table.insert(dat, items[i])
           end
       else
           table.insert(dat, item.uid)
       end
   end
return dat
end




local items = {
	[26548] = {[26544] = {1}},
	[26549] = {[26545] = {1}},
	[26550] = {[26546] = {1}},
	[26551] = {[26547] = {1}}
}


function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local var = {}

	
	if target:getId() ~= 1739 then return false end
	

	
	for z,x in pairs (items) do

		var[1] = 1

		for i,j in pairs (items[z]) do
			if var[1] ~= 0 then	
				if target:getItemCountById(i) >= j[1] then
					var[1] = z
				else 
					var[1] = 0
				end	
			else
				var[1] = 0
			end	
		end	
		

		if var[1] ~= 0 then	
			for m,n in pairs(items[var[1]]) do
				for k = 1, #getUidsInContainer(target.uid) do
					print(getUidsInContainer(target.uid)[k])
					if getUidsInContainer(target.uid)[k]:getId() == m then
						getUidsInContainer(target.uid)[k]:remove(n)
					end	
				end

			end
		
			target:addItem(var[1])
		end		
	end

end


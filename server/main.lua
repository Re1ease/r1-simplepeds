local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add("newped", "(ADMIN) Create a new ped", {}, false, function(source, args)
	local src = source
	if not args[1] then print("No argument") return end
	TriggerClientEvent("simplepeds:client:newPed", src, args[1])
end, "admin")

RegisterNetEvent("simplepeds:server:saveNewPed", function(coords, model)
	local src = source
	exports.oxmysql:insert('INSERT INTO simplepeds (coords, model) VALUES (?, ?) ', {json.encode(coords), tostring(model)})
	TriggerClientEvent("simplepeds:client:generatePeds", -1, coords+1000, model)
end)

RegisterNetEvent("simplepeds:server:generatePeds", function()
	local src = source
	exports.oxmysql:query('SELECT * FROM simplepeds', function(result)
		if result then
			if type(next(result)) == "nil" then return end
			for _, v in pairs(result) do
				local c = json.decode(v.coords)
				local coords = vec4(c.x, c.y, c.z, c.w)
				TriggerClientEvent("simplepeds:client:generatePeds", src, coords, v.model)
			end
		end
	end)
end)
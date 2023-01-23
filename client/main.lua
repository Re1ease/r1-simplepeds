local QBCore = exports['qb-core']:GetCoreObject()

local function GeneratePed(coords, m, new)
	local model = GetHashKey(m)
	local w = 1000
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(100)
		w = (w-100)
		if w <= 0 then
			print("Error")
			return false
		end
	end
	local npc = CreatePed(0, m, coords.x, coords.y, coords.z-1001, coords.w, false, true)
	SetEntityInvincible(npc, true)
	SetBlockingOfNonTemporaryEvents(npc, true)
	FreezeEntityPosition(npc, true)
	if GetEntityCoords(npc).z > coords.z then
		SetEntityCoords(npc, coords.x, coords.y, coords.z-0.0000001, 0, 0, 0, 0)
	end
	if new then return true end return false
end

RegisterNetEvent("simplepeds:client:newPed", function(model)
	local ped = PlayerPedId()
	local pCoords = GetEntityCoords(ped)
	local coords = vec4(pCoords.x, pCoords.y, pCoords.z-1, GetEntityHeading(ped))
	local state = GeneratePed(coords, model, true)
	if state then
		TriggerServerEvent("simplepeds:server:saveNewPed", coords, model)
	end
end)

RegisterNetEvent("simplepeds:client:generatePeds", function(coords, model)
	GeneratePed(coords, model, false)
end)

CreateThread(function()
	TriggerServerEvent("simplepeds:server:generatePeds")
end)

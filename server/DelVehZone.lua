local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('vehicleRemove:checkAndRemove', function(netId)
    local src = source
    TriggerClientEvent('vehicleRemove:deleteVehicle', src, netId)
end)

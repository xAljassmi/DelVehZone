local QBCore = exports['qb-core']:GetCoreObject()

local function isInZone()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    for _, v in pairs(Config.Zones) do
        local dist = #(vector3(v.x, v.y, v.z) - playerCoords)
        if dist < v.radius then
            return true
        end
    end
    return false
end

local lastVehicle = nil
local lastInZone = false
local notificationSent = false
local playerExitedZone = false

CreateThread(function()
    while true do
        Wait(1000)
        local playerPed = PlayerPedId()
        local veh = GetVehiclePedIsIn(playerPed, false)
        local inZone = isInZone()

        if veh ~= 0 then
            lastVehicle = veh
            lastInZone = inZone
        end

        if inZone and lastVehicle ~= nil then
            if not notificationSent then
                QBCore.Functions.Notify(Config.NotificationText, "primary", 5000)
                notificationSent = true
            end

            if not IsPedInAnyVehicle(playerPed, false) then
                local netId = NetworkGetNetworkIdFromEntity(lastVehicle)
                Wait(Config.DeleteAfterTime)
                if not IsPedInAnyVehicle(playerPed, false) and isInZone() and lastVehicle == NetworkGetEntityFromNetworkId(netId) then
                    TriggerServerEvent('vehicleRemove:checkAndRemove', netId)
                    lastVehicle = nil
                    notificationSent = false
                end
            elseif Config.DeleteIfPlayerInVehicle then
                local netId = NetworkGetNetworkIdFromEntity(veh)
                Wait(Config.DeleteAfterTime)
                if IsPedInAnyVehicle(playerPed, false) and isInZone() and lastVehicle == NetworkGetEntityFromNetworkId(netId) then
                    TriggerServerEvent('vehicleRemove:checkAndRemove', netId)
                    notificationSent = false
                end
            end
        else
            if not inZone then
                if lastVehicle ~= nil and not IsPedInAnyVehicle(playerPed, false) then
                    local netId = NetworkGetNetworkIdFromEntity(lastVehicle)
                    Wait(Config.DeleteAfterTime)
                    if not isInZone() and lastVehicle == NetworkGetEntityFromNetworkId(netId) then
                        TriggerServerEvent('vehicleRemove:checkAndRemove', netId)
                        lastVehicle = nil
                        notificationSent = false
                    end
                else
                    lastVehicle = nil
                    notificationSent = false
                end
                playerExitedZone = true
            end
        end
    end
end)

RegisterNetEvent('vehicleRemove:deleteVehicle', function(netId)
    local veh = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(veh) then
        SetEntityAsMissionEntity(veh, true, true)
        DeleteEntity(veh)
    end
end)

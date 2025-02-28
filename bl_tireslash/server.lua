RegisterServerEvent('bl_tireslash:sync')
AddEventHandler('bl_tireslash:sync', function(vehicleNetId, tireIndex)
    TriggerClientEvent('bl_tireslash:syncTire', -1, vehicleNetId, tireIndex)
end)
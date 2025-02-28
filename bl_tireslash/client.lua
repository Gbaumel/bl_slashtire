local QBCore = exports['qb-core']:GetCoreObject()

local tireIndices = {
    ['wheel_lf'] = 0,  -- Roda dianteira esquerda
    ['wheel_rf'] = 1,  -- Roda dianteira direita
    ['wheel_lr'] = 4,  -- Roda traseira esquerda
    ['wheel_rr'] = 5   -- Roda traseira direita
}

local animDictCache = {}

local function loadAnimDict(dict)
    if animDictCache[dict] then return end -- Se a animação já estiver carregada, retorna
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    animDictCache[dict] = true
end

local function hasAllowedWeapon()
    local playerPed = PlayerPedId()
    local currentWeapon = GetSelectedPedWeapon(playerPed)
    
    for _, allowedWeapon in ipairs(Config.allowedWeapons) do
        if currentWeapon == allowedWeapon then
            return true
        end
    end
    
    return false
end

-- Função para estourar o pneu
local function slashTire(vehicle, tireIndex)
    if not DoesEntityExist(vehicle) then return end
    if IsVehicleTyreBurst(vehicle, tireIndex, false) then
        QBCore.Functions.Notify(Config.messages.already_slashed, 'error')
        return
    end

    -- Animação de cortar o pneu
    loadAnimDict('melee@knife@streamed_core_fps')
    TaskPlayAnim(PlayerPedId(), 'melee@knife@streamed_core_fps', 'ground_attack_on_spot', 8.0, -8.0, -1, 15, 1.0, false, false, false)
    Wait(1000) -- Tempo da animação

    local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)
    TriggerServerEvent('bl_tireslash:sync', vehicleNetId, tireIndex)

    QBCore.Functions.Notify(Config.messages.tire_slashed, 'success')

    ClearPedTasks(PlayerPedId())
end

local function getTireBonePosition(entity, boneName)
    local boneIndex = GetEntityBoneIndexByName(entity, boneName)
    if boneIndex == -1 then return nil end -- Verifica se o osso existe
    return GetWorldPositionOfEntityBone(entity, boneIndex)
end

-- Função para adicionar interação com os pneus usando ox_target
local function addTireTargetOptions()
    local options = {}

    for tireName, tireIndex in pairs(tireIndices) do
        options[#options + 1] = {
            name = 'slash_tire_' .. tireName,
            icon = 'fas fa-burst',
            label = 'Estourar Pneu',
            distance = Config.interactionDistance,
            onSelect = function(data)
                slashTire(data.entity, tireIndex)
            end,
            canInteract = function(entity, distance, coords)
                if not DoesEntityExist(entity) or not hasAllowedWeapon() then return false end

                local tirePosition = getTireBonePosition(entity, tireName)
                if not tirePosition then return false end

                local playerCoords = GetEntityCoords(PlayerPedId())
                return #(playerCoords - tirePosition) < 1.0 -- Distância de 1.0 metro
            end
        }
    end

    exports.ox_target:addGlobalVehicle(options)
end

CreateThread(function()
    addTireTargetOptions()
end)

RegisterNetEvent('bl_tireslash:syncTire')
AddEventHandler('bl_tireslash:syncTire', function(vehicleNetId, tireIndex)
    local vehicle = NetToVeh(vehicleNetId)
    if DoesEntityExist(vehicle) then
        SetVehicleTyreBurst(vehicle, tireIndex, true, 1000.0)
    end
end)
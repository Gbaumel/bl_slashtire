local QBCore = exports['qb-core']:GetCoreObject()

-- Tabela de índices dos pneus
local tireIndices = {
    ['wheel_lf'] = 0,  -- Roda dianteira esquerda
    ['wheel_rf'] = 1,  -- Roda dianteira direita
    ['wheel_lr'] = 4,  -- Roda traseira esquerda
    ['wheel_rr'] = 5   -- Roda traseira direita
}

-- Função para carregar animações
local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

-- Função para verificar se o jogador está segurando uma das armas permitidas
local function hasAllowedWeapon()
    local playerPed = PlayerPedId()
    local currentWeapon = GetSelectedPedWeapon(playerPed)
    
    -- Verifica se a arma atual está na lista de armas permitidas
    for _, allowedWeapon in ipairs(Config.allowedWeapons) do
        if currentWeapon == allowedWeapon then
            return true
        end
    end
    
    return false
end

-- Função para estourar o pneu
local function slashTire(vehicle, tireIndex)
    if IsVehicleTyreBurst(vehicle, tireIndex, false) then
        QBCore.Functions.Notify(Config.messages.already_slashed, 'error')
        return
    end

    -- Animação de cortar o pneu
    loadAnimDict('melee@knife@streamed_core_fps')
    TaskPlayAnim(PlayerPedId(), 'melee@knife@streamed_core_fps', 'ground_attack_on_spot', 8.0, -8.0, -1, 15, 1.0, false, false, false)
    Wait(1000) -- Tempo da animação

    -- Sincroniza o estouro do pneu com todos os jogadores
    local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)
    TriggerServerEvent('bl_tireslash:sync', vehicleNetId, tireIndex)

    -- Notificação
    QBCore.Functions.Notify(Config.messages.tire_slashed, 'success')

    -- Limpa a animação
    ClearPedTasks(PlayerPedId())
    RemoveAnimDict('melee@knife@streamed_core_fps')
end

-- Função para obter a posição do osso (bone) do pneu
local function getTireBonePosition(entity, boneName)
    local boneIndex = GetEntityBoneIndexByName(entity, boneName)
    if boneIndex == -1 then return nil end -- Verifica se o osso existe
    return GetWorldPositionOfEntityBone(entity, boneIndex)
end

-- Função para adicionar interação com os pneus usando ox_target
local function addTireTargetOptions()
    local options = {
        {
            name = 'slash_tire_lf',
            icon = 'fas fa-burst',
            label = 'Estourar Pneu',
            distance = Config.interactionDistance,
            onSelect = function(data)
                slashTire(data.entity, tireIndices['wheel_lf'])
            end,
            canInteract = function(entity, distance, coords)
                -- Verifica se o jogador está segurando a faca
                if not hasAllowedWeapon() then return false end

                -- Obtém a posição da roda dianteira esquerda
                local tirePosition = getTireBonePosition(entity, 'wheel_lf')
                if not tirePosition then return false end -- Se o osso não existir

                -- Verifica se o jogador está próximo à posição da roda
                local playerCoords = GetEntityCoords(PlayerPedId())
                return #(playerCoords - tirePosition) < 1.0 -- Distância de 1.0 metro
            end
        },
        {
            name = 'slash_tire_rf',
            icon = 'fas fa-burst',
            label = 'Estourar Pneu',
            distance = Config.interactionDistance,
            onSelect = function(data)
                slashTire(data.entity, tireIndices['wheel_rf'])
            end,
            canInteract = function(entity, distance, coords)
                -- Verifica se o jogador está segurando a faca
                if not hasAllowedWeapon() then return false end

                -- Obtém a posição da roda dianteira direita
                local tirePosition = getTireBonePosition(entity, 'wheel_rf')
                if not tirePosition then return false end -- Se o osso não existir

                -- Verifica se o jogador está próximo à posição da roda
                local playerCoords = GetEntityCoords(PlayerPedId())
                return #(playerCoords - tirePosition) < 1.0 -- Distância de 1.0 metro
            end
        },
        {
            name = 'slash_tire_lr',
            icon = 'fas fa-burst',
            label = 'Estourar Pneu',
            distance = Config.interactionDistance,
            onSelect = function(data)
                slashTire(data.entity, tireIndices['wheel_lr'])
            end,
            canInteract = function(entity, distance, coords)
                -- Verifica se o jogador está segurando a faca
                if not hasAllowedWeapon() then return false end

                -- Obtém a posição da roda traseira esquerda
                local tirePosition = getTireBonePosition(entity, 'wheel_lr')
                if not tirePosition then return false end -- Se o osso não existir

                -- Verifica se o jogador está próximo à posição da roda
                local playerCoords = GetEntityCoords(PlayerPedId())
                return #(playerCoords - tirePosition) < 1.0 -- Distância de 1.0 metro
            end
        },
        {
            name = 'slash_tire_rr',
            icon = 'fas fa-burst',
            label = 'Estourar Pneu',
            distance = Config.interactionDistance,
            onSelect = function(data)
                slashTire(data.entity, tireIndices['wheel_rr'])
            end,
            canInteract = function(entity, distance, coords)
                -- Verifica se o jogador está segurando a faca
                if not hasAllowedWeapon() then return false end

                -- Obtém a posição da roda traseira direita
                local tirePosition = getTireBonePosition(entity, 'wheel_rr')
                if not tirePosition then return false end -- Se o osso não existir

                -- Verifica se o jogador está próximo à posição da roda
                local playerCoords = GetEntityCoords(PlayerPedId())
                return #(playerCoords - tirePosition) < 1.0 -- Distância de 1.0 metro
            end
        }
    }

    exports.ox_target:addGlobalVehicle(options)
end

-- Adiciona as opções de interação ao iniciar o script
CreateThread(function()
    addTireTargetOptions()
end)

-- Sincroniza o estouro do pneu com todos os jogadores
RegisterNetEvent('bl_tireslash:syncTire')
AddEventHandler('bl_tireslash:syncTire', function(vehicleNetId, tireIndex)
    local vehicle = NetToVeh(vehicleNetId)
    if DoesEntityExist(vehicle) then
        SetVehicleTyreBurst(vehicle, tireIndex, true, 1000.0)
    end
end)
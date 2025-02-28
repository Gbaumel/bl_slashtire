fx_version 'cerulean'
game 'gta5'

author 'Baumel'
description 'Estoure Rodas com uma faca...'
version '1.0.0'

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

shared_scripts {
    'config.lua'
}

dependencies {
    'qb-core',      -- QBCore
    'ox_target',    -- ox_target para interação
    'ox_lib'        -- ox_lib para notificações (opcional)
}
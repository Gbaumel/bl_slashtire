Config = {}

-- Armas permitidas para estourar rodas
Config.allowedWeapons = {
    `weapon_knife`,       -- Faca
    `weapon_knuckle`      -- Soco inglês
}

-- Distância máxima para interação com os pneus
Config.interactionDistance = 3

-- Notificações (usando ox_lib)
Config.useOxLibNotifications = true

-- Mensagens
Config.messages = {
    no_knife = "Você precisa de algo cortante para fazer isso.",
    tire_slashed = "Pneu estourado com sucesso!",
    already_slashed = "Este pneu já está estourado."
}
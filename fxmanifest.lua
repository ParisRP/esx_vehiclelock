fx_version 'cerulean'
game 'gta5'

author 'Paris RP'
description 'Système de gestion des clés de véhicules avec ESX et esx_vehicleshop'
version '1.0.0'

dependency 'es_extended'
dependency 'mysql-async'
dependency 'esx_vehicleshop' -- Dépendance pour les véhicules du shop

client_scripts {
    'client.lua',
    'config.lua'
}

server_scripts {
    '@es_extended/locale.lua',
    'server.lua',
    'config.lua'
}

files {
    'esx_vehiclelock.sql'
}

locales {
    'locales/fr.lua'
}

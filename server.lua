ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Enregistrer une clé pour un véhicule acheté via esx_vehicleshop
RegisterServerEvent('esx_vehiclelock:registerkey')
AddEventHandler('esx_vehiclelock:registerkey', function(plate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    -- Vérifier si le joueur a acheté le véhicule via esx_vehicleshop
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate AND owner = @owner', {
        ['@plate'] = plate,
        ['@owner'] = xPlayer.identifier
    }, function(result)
        if result[1] then
            -- Enregistrer la clé dans la base de données
            MySQL.Async.execute('INSERT INTO user_vehicles (plate, owner) VALUES (@plate, @owner)', {
                ['@plate'] = plate,
                ['@owner'] = xPlayer.identifier
            })
            TriggerClientEvent('esx:showNotification', _source, 'Clé du véhicule enregistrée avec succès !')
        else
            TriggerClientEvent('esx:showNotification', _source, 'Vous ne possédez pas ce véhicule.')
        end
    end)
end)

-- Suppression d'une clé
RegisterServerEvent('esx_vehiclelock:deletekey')
AddEventHandler('esx_vehiclelock:deletekey', function(plate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.execute('DELETE FROM user_vehicles WHERE plate = @plate AND owner = @owner', {
        ['@plate'] = plate,
        ['@owner'] = xPlayer.identifier
    })
end)

-- Prêter une clé à un autre joueur
RegisterServerEvent('esx_vehiclelock:preterkey')
AddEventHandler('esx_vehiclelock:preterkey', function(target, plate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    -- On peut prêter en modifiant les droits dans la base de données ou en envoyant l'événement à l'autre joueur
    TriggerClientEvent('esx:showNotification', target, 'Vous avez reçu une clé pour le véhicule ['..plate..']')
end)

-- Donne une clé
RegisterServerEvent('esx_vehiclelock:donnerkey')
AddEventHandler('esx_vehiclelock:donnerkey', function(target, plate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.execute('INSERT INTO user_vehicles (plate, owner) VALUES (@plate, @owner)', {
        ['@plate'] = plate,
        ['@owner'] = target
    })
    TriggerClientEvent('esx:showNotification', target, 'Vous avez reçu une clé pour le véhicule ['..plate..']')
end)

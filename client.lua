ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

-- Fonction pour ouvrir le menu des clés
RegisterNetEvent('esx_vehiclelock:openKeyMenu')
AddEventHandler('esx_vehiclelock:openKeyMenu', function()
    ESX.TriggerServerCallback('esx_vehiclelock:allkey', function(mykey)
        local elements = {}

        for i=1, #mykey, 1 do
            if mykey[i].got == 'true' then
                if mykey[i].NB == 1 then
                    table.insert(elements, {label = 'Clé : [' .. mykey[i].plate .. ']', value = mykey[i].plate})
                elseif mykey[i].NB == 2 then
                    table.insert(elements, {label = '[DOUBLE] Véhicule : [' .. mykey[i].plate .. ']', value = nil})
                end
            end
        end

        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'mykey',
            {
                title = 'Mes Clés',
                align = 'top-left',
                elements = elements
            },
            function(data, menu)
                if data.current.value ~= nil then
                    ESX.UI.Menu.CloseAll()
                    ESX.UI.Menu.Open(
                        'default', GetCurrentResourceName(), 'mykey_actions',
                        {
                            title = 'Que voulez-vous faire ?',
                            align = 'top-left',
                            elements = {
                                {label = 'Donner', value = 'donnerkey'},
                                {label = 'Prêter', value = 'preterkey'},
                            },
                        },
                        function(data2, menu2)
                            local player, distance = ESX.Game.GetClosestPlayer()
                            local playerPed = GetPlayerPed(-1)
                            local coords = GetEntityCoords(playerPed, true)
                            local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 71)
                            local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

                            if data2.current.value == 'donnerkey' then
                                ESX.UI.Menu.CloseAll()
                                if distance ~= -1 and distance <= 3.0 then
                                    TriggerServerEvent('esx_vehiclelock:donnerkey', GetPlayerServerId(player), data.current.value)
                                    TriggerServerEvent('esx_vehiclelock:deletekey', data.current.value)
                                    TriggerServerEvent('esx_vehiclelock:changeowner', GetPlayerServerId(player), vehicleProps)
                                end
                            elseif data2.current.value == 'preterkey' then
                                ESX.UI.Menu.CloseAll()
                                if distance ~= -1 and distance <= 3.0 then
                                    TriggerServerEvent('esx_vehiclelock:preterkey', GetPlayerServerId(player), data.current.value)
                                end
                            end
                        end,
                        function(data2, menu2)
                            menu2.close()
                        end
                    )
                end
            end,
            function(data, menu)
                menu.close()
            end
        )
    end)
end)

-- Fonction d'ouverture et fermeture du véhicule
function OpenCloseVehicle()
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed, true)

    local vehicle = nil

    if IsPedInAnyVehicle(playerPed, false) then
        vehicle = GetVehiclePedIsIn(playerPed, false)
    else
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 71)
    end

    ESX.TriggerServerCallback('esx_vehiclelock:mykey', function(gotkey)
        if gotkey then
            local locked = GetVehicleDoorLockStatus(vehicle)
            if locked == 1 or locked == 0 then -- if unlocked
                SetVehicleDoorsLocked(vehicle, 2)
                PlayVehicleDoorCloseSound(vehicle, 1)
                ESX.ShowNotification("Vous avez ~r~fermé~s~ le véhicule.")
            elseif locked == 2 then -- if locked
                SetVehicleDoorsLocked(vehicle, 1)
                PlayVehicleDoorOpenSound(vehicle, 0)
                ESX.ShowNotification("Vous avez ~g~ouvert~s~ le véhicule.")
            end
        else
            ESX.ShowNotification("~r~Vous n'avez pas les clés de ce véhicule.")
        end
    end, GetVehicleNumberPlateText(vehicle))
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        -- Vérifier si la touche Insert (0x2D) est pressée
        if IsControlJustPressed(0, 0x2D) then
            TriggerEvent('esx_vehiclelock:openKeyMenu') -- Ouvre le menu des clés
        end
    end
end)

-- Ouvrir et fermer les portes du véhicule avec "Insert"
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, Config.LockControl) then -- Touche "U"
            OpenCloseVehicle()
        end
    end
end)

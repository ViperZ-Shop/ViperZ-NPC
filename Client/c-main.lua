local PRIMERNPC = Config.PRIMERNPC

function addNPC(x, y, z, h, model, anim)
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do
        Wait(1)
    end

    local npc = CreatePed(4, GetHashKey(model), x, y, z, h, false, true)
    SetEntityHeading(npc, h)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    SetPedFleeAttributes(npc, 0, 0)
    SetPedCombatAttributes(npc, 17, 1)
    FreezeEntityPosition(npc, true)
    SetEntityCanBeDamaged(npc, false)

    while true do
        if not IsPedUsingScenario(npc, anim) then
            TaskStartScenarioInPlace(npc, anim, 0, true)
        end
        Citizen.Wait(1000) 
    end
end

CreateThread(function()
    addNPC(PRIMERNPC.coords.x, PRIMERNPC.coords.y, PRIMERNPC.coords.z, PRIMERNPC.heading, PRIMERNPC.model, PRIMERNPC.animation)
end)
exports.ox_target:addBoxZone({
    coords = vec3(PRIMERNPC.coords.x, PRIMERNPC.coords.y, PRIMERNPC.coords.z + 1),
    size = vec3(2, 2, 2),
    rotation = 0,
    debug = false,
    drawSprite = true,
    distance = PRIMERNPC.distance,  
    options = {
        {
            name = 'box',
            event = 'comprar',
            args = PRIMERNPC.CooldownMinutes,
            icon = 'fas fa-shopping-cart',
            label = 'Comprar',
        }
    }
})


function RealizarCompra(item, cantidad, precio)
    local totalCost = cantidad * precio

    if ESX.PlayerData.money >= totalCost then
        ESX.TriggerServerCallback('comprar_owni', function(success, message)
            if success then
                ESX.ShowNotification('Has comprado ' .. cantidad .. ' ' .. item)
            else
                ESX.ShowNotification(message)
            end
        end, item, cantidad)
    else
        ESX.ShowNotification('No tienes suficiente dinero en efectivo')
    end
end


function OpenCompraMenu()
    local elements = Config.TiendaPrimerNPC.items
    ESX.TriggerServerCallback('esx:getPlayerData', function(playerData)
        if playerData.job.name == 'police' or playerData.job.name == 'ambulance' then
            ESX.ShowNotification('Con estas pintas no me apetece hablar contigo')
        else
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'comprar_menu',
                {
                    title = 'Esto es lo que ofrezco',
                    align = 'bottom-right',
                    elements = elements
                },
                function(data, menu)
                    if data.current.value == 'hablar_jefe' then
                        ESX.ShowNotification('Dirigete hacia la direccion que te he marcado en el GPS')
                        SetNewWaypoint(-2016.9220, 559.3937)
                        talkedToFirstNPC = true
                        menu.close()
                        exports.ox_target:addBoxZone({
                            coords = vec3(-2016.9220, 559.3937, 107.2909 + 1),
                            size = vec3(2, 2, 2),
                            rotation = 0,
                            debug = false,
                            drawSprite = true,
                            distance = 1.5,
                            options = {
                                {
                                    name = 'boss',
                                    event = 'jefe:openMenu',
                                    icon = 'fa-solid fa-user-secret',
                                    label = 'Hablar con el Jefe',
                                }
                            }
                        })
                    else
                        RealizarCompra(data.current.value, 1, data.current.price)
                        menu.close()
                    end
                end,
                function(data, menu)
                    menu.close()
                end
            )
        end
    end)
end

RegisterNetEvent('comprar')
AddEventHandler('comprar', function()
    OpenCompraMenu()
end)


function RealizarCompra(item, cantidad, precio)
    local totalCost = cantidad * precio
    ESX.TriggerServerCallback('esx:getPlayerData', function(playerData)
        if playerData.money >= totalCost then
            ESX.TriggerServerCallback('comprar_owni', function(success, message)
                if success then
                    ESX.ShowNotification('Has comprado ~y~' .. cantidad .. ' ~s~' .. item .. ' por ~g~' .. totalCost .. '€')
                else
                    ESX.ShowNotification(message)
                end
            end, item, cantidad)
        else
            ESX.ShowNotification('No tienes suficiente dinero en efectivo.')
        end
    end)
end


if Config.MostrarBlip then
    local blip = AddBlipForCoord(-1557.6716, -416.5411, 38.0964)
    SetBlipSprite(blip, 162)
    SetBlipColour(blip, 0)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.6) 
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Interactuar NPC")
    EndTextCommandSetBlipName(blip)
end


AddEventHandler('onClientResourceStart', function(resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
        return
    end
    CreateBossNPC()
end)
function CreateBossNPC()
    local npcData = Config.JEFENPC
    local hash = GetHashKey(npcData.model)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(1)
    end

    local ped = CreatePed(4, hash, npcData.coords.x, npcData.coords.y, npcData.coords.z, npcData.heading, false, true)
    SetEntityHeading(ped, npcData.heading)
    SetEntityInvincible(ped, true)  
    SetEntityCanBeDamaged(ped, false)  
    FreezeEntityPosition(ped, true)  
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskStartScenarioInPlace(ped, npcData.animation, 0, true)

    if talkedToFirstNPC then
        exports.ox_target:addBoxZone({
            coords = vec3(npcData.coords.x, npcData.coords.y, npcData.coords.z + 1),
            size = vec3(2, 2, 2),
            rotation = 0,
            debug = false,
            drawSprite = true,
            distance = npcData.distance,
            options = {
                {
                    name = 'boss',
                    event = 'jefe:openMenu',
                    icon = 'fa-solid fa-user-secret',
                    label = 'Hablar con el Jefe',
                }
            }
        })
    end
end

RegisterNetEvent('jefe:openMenu')
AddEventHandler('jefe:openMenu', function()
    local elements = Config.TiendaBossNPC.weapons

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'jefe_menu',
        {
            title = 'Menu del Jefe',
            align = 'bottom-right',
            elements = elements
        },
        function(data, menu)
            TriggerServerEvent('comprar_arma', data.current.value, data.current.price)
        end,
        function(data, menu)
            menu.close()
        end
    )
end)
ESX.RegisterServerCallback('comprar_owni', function(source, cb, item, quantity)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 0  
    if xPlayer.getMoney() >= price * quantity then
        xPlayer.removeMoney(price * quantity)

        xPlayer.addInventoryItem(item, quantity)

        cb(true)
    else
        cb(false, 'No tienes suficiente dinero en ~r~efectivo')
    end
end)


RegisterServerEvent('comprar_arma')
AddEventHandler('comprar_arma', function(weapon, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        xPlayer.addWeapon(weapon, 100) 
        TriggerClientEvent('esx:showNotification', source, 'Has comprado ~y~' .. ESX.GetWeaponLabel(weapon) .. ' ~s~por ~g~$' .. price)
    else
        TriggerClientEvent('esx:showNotification', source, '~r~No tienes suficiente dinero')
    end
end)
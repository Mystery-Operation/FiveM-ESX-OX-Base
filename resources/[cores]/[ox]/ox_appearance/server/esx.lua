do
    local xPlayers = ESX.GetExtendedPlayers()

    for i = 1, #xPlayers do
        local xPlayer = xPlayers[i]
        exports['ox_appearance']:addIdentifier(xPlayer.source, xPlayer.identifier)
        TriggerClientEvent('ox_appearance:outfitNames', xPlayer.source, OutfitNames(xPlayer.identifier))
    end
end

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    if source == 0 or source == '' then
        exports['ox_appearance']:addIdentifier(playerId, xPlayer.identifier)
        TriggerClientEvent('ox_appearance:outfitNames', playerId, OutfitNames(xPlayer.identifier))
    end
end)

RegisterNetEvent('esx_skin:save')
AddEventHandler('esx_skin:save', function(appearance, saveIdentifier)
    local src = source
    local identifier = exports['ox_appearance']:getIdentifier(src)

    exports['ox_appearance']:save(identifier, appearance)
    MySQL.update('UPDATE users SET skin = ? WHERE identifier = ? LIMIT 1', { json.encode(appearance), identifier })
end)

ESX.RegisterServerCallback('esx_skin:getPlayerSkin', function(source, cb)
    local _source = source
    local identifier = Players[_source]
    local appearance = MySQL.scalar.await('SELECT skin FROM users WHERE identifier = ? LIMIT 1', { identifier })
    cb(appearance and json.decode(appearance) or {})
end)

ESX.RegisterServerCallback('ox_appearance:getPlayerSkin', function(source, cb)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local appearance = exports['ox_appearance']:load(xPlayer.source, xPlayer.identifier)
    cb(appearance)
end)

ESX.RegisterCommand('skin', 'admin', function(xPlayer, args, showError)
    xPlayer.triggerEvent('esx_skin:openSaveableMenu', false, false, false)
end, true, {help = 'Verander je uiterlijk', validate = true })

ESX.RegisterCommand('skinreset', 'mod', function(xPlayer, args, showError)
    if args.Speler then
        TriggerClientEvent('ox_appearance:client:skinResetPlayer', args.Speler.source)
    end
end, true, {help = "Doet een skin reset na een relog", validate = false, arguments = {
	{name = 'Speler', help = "Geef het ID van de speler waar je een skinreset voor wilt geven", type = 'player'}
}})

ESX.RegisterCommand('copyoutfit', 'admin', function(xPlayer, args, showError)
    local appearance = exports['ox_appearance']:load(xPlayer.source, xPlayer.identifier)
    TriggerClientEvent('ox_appearance:copySkinValues', xPlayer.source, appearance)
end, true, {help = 'Kopieer outfit', validate = true })
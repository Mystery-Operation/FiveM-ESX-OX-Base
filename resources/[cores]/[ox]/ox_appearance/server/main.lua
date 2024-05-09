Players = {}

exports('getIdentifier', function(src)
	return Players[src]
end)

exports('addIdentifier', function(src, identifier)
	Players[src] = identifier
end)

function SaveAppearance(identifier, appearance)
	SetResourceKvp(('%s:appearance'):format(identifier), json.encode(appearance))

	MySQL.update('UPDATE users SET skin = ? WHERE identifier = ? LIMIT 1', { json.encode(appearance), identifier })
end
exports('save', SaveAppearance)

function LoadAppearance(source, identifier)
	Players[source] = identifier
	local data = GetResourceKvpString(('%s:appearance'):format(identifier))

	return data and json.decode(data) or {}
end
exports('load', LoadAppearance)

function SaveOutfit(identifier, appearance, slot, outfitNames)
	SetResourceKvp(('%s:outfit_%s'):format(identifier, slot), json.encode(appearance))
	SetResourceKvp(('%s:outfits'):format(identifier), json.encode(outfitNames))
end
exports('saveOutfit', SaveOutfit)

function DeleteOutfit(identifier, slot, outfitNames)
	DeleteResourceKvp(('%s:outfit_%s'):format(identifier, slot))
	SetResourceKvp(('%s:outfits'):format(identifier), json.encode(outfitNames))
end
exports('deleteOutfit', DeleteOutfit)

function LoadOutfit(identifier, slot)
	local data = GetResourceKvpString(('%s:outfit_%s'):format(identifier, slot))
	return data and json.decode(data) or {}
end
exports('loadOutfit', LoadOutfit)

function OutfitNames(identifier)
	local data = GetResourceKvpString(('%s:outfits'):format(identifier))
	return data and json.decode(data) or {}
end
exports('outfitNames', OutfitNames)

RegisterNetEvent('ox_appearance:save', function(appearance)
	local identifier = Players[source]

	if identifier then
		SaveAppearance(identifier, appearance)
	end
end)

RegisterNetEvent('ox_appearance:deleteOutfit', function(slot, outfitNames)
	local identifier = Players[source]

	if identifier then
		DeleteOutfit(identifier, slot, outfitNames)
	end
end)

RegisterNetEvent('ox_appearance:saveOutfit', function(appearance, slot, outfitNames)
	local identifier = Players[source]

	if identifier then
		SaveOutfit(identifier, appearance, slot, outfitNames)
	end
end)

RegisterNetEvent('ox_appearance:loadOutfitNames', function()
	local identifier = Players[source]
	TriggerClientEvent('ox_appearance:outfitNames', source, identifier and OutfitNames(identifier) or {})
end)

RegisterNetEvent('ox_appearance:loadOutfit', function(slot)
	local identifier = Players[source]
	TriggerClientEvent('ox_appearance:outfit', source, slot, identifier and LoadOutfit(identifier, slot) or {})
end)

AddEventHandler('playerDropped', function()
	local src = source
    local identifier = Players[src] and Players[src] or nil

	if identifier then
		local appearance = exports['ox_appearance']:load(src, identifier)
		MySQL.update('UPDATE users SET skin = ? WHERE identifier = ? LIMIT 1', { json.encode(appearance), identifier })
		Players[src] = nil
	end
end)
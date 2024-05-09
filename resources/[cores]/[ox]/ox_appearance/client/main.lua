-- // [OX_LIB] \\ --

lib.locale()

-- // [COORDS] \\ --

local shops = {
	clothing = {
		vector4(72.3, -1399.1, 28.4, 0.0), 
		vector4(-708.71, -152.13, 36.4, 120.0), 
		vector4(-165.15, -302.49, 38.6, 260.0), 
		vector4(428.7, -800.1, 28.5, 180.0),
		vector4(-829.4, -1073.7, 10.35, 240.0),
		vector4(-1449.16, -238.35, 48.8, 60.0),
		vector4(11.6, 6514.2, 30.9, 90.0),
		vector4(122.98, -222.27, 53.55, 0.0),
		vector4(1696.3, 4829.3, 41.08, 140.0),
		vector4(617.7, 2763.1, 41.1, 179.4),
		vector4(1190.6, 2713.4, 37.23, 240.0),
		vector4(-1190.6, -770.4, 16.35, 122.8),
		vector4(-3174.0, 1044.6, 19.9, 330.5),
		vector4(-1108.4, 2708.9, 18.1, 280.0)
	},

	barber = {
		vector4(-814.3, -183.8, 36.6, 120.0),
		vector4(136.8, -1708.4, 28.3, 140.0),
		vector4(-1282.6, -1116.8, 6.0, 90.0),
		vector4(1931.5, 3729.7, 31.8, 220.0),
		vector4(1212.8, -472.9, 65.2, 90.0),
		vector4(-34.31, -154.99, 56.05, 350.0),
		vector4(-278.1, 6228.5, 30.7, 50.0)
	},

	tattoos = {
		vector4(1321.6, -1653.6, 51.3, 349.1),
		vector4(-1153.6, -1425.6, 4.9, 0.0),
		vector4(322.1, 180.4, 103.5, 0.0),
		vector4(-3170.0, 1075.0, 20.8, 0.0),
		vector4(1864.6, 3747.7, 33.0, 0.0),
		vector4(-293.7, 6200.0, 31.4, 0.0)
	}
}

-- // [THREADS] \\ --

CreateThread(function()
	for i = 1, #shops.clothing do
		RequestModel('s_f_y_shop_mid', 100)
		cPed = CreatePed('CIVFEMALE', 's_f_y_shop_mid', shops.clothing[i].x, shops.clothing[i].y, shops.clothing[i].z, shops.clothing[i].w, false, false)
		FreezeEntityPosition(cPed, true)
		SetEntityInvincible(cPed, true)
		SetBlockingOfNonTemporaryEvents(cPed, true)
		exports.qtarget:AddTargetEntity(cPed, {
			options = {
				{
					icon = 'fa-solid fa-shirt',
					label = 'Kleding kopen',
					action = function()
						local config = {
							ped = false,
							headBlend = false,
							faceFeatures = false,
							headOverlays = false,
							components = true,
							props = true,
							tattoos = false,
						}	
	
						exports['fivem-appearance']:startPlayerCustomization(function()
						end, config)
					end,
				},
			},
			distance = 3
		})
	end
end)

CreateThread(function()
	for i = 1, #shops.barber do
		RequestModel('s_f_m_fembarber', 100)
		cPed = CreatePed('CIVFEMALE', 's_f_m_fembarber', shops.barber[i].x, shops.barber[i].y, shops.barber[i].z, shops.barber[i].w, false, false)
		FreezeEntityPosition(cPed, true)
		SetEntityInvincible(cPed, true)
		SetBlockingOfNonTemporaryEvents(cPed, true)
		exports.qtarget:AddTargetEntity(cPed, {
			options = {
				{
					icon = 'fa-solid fa-scissors',
					label = 'Haren knippen',
					action = function()
						local config = {
							ped = false,
							headBlend = false,
							faceFeatures = false,
							headOverlays = true,
							components = false,
							props = false,
							tattoos = false,
						}	
	
						exports['fivem-appearance']:startPlayerCustomization(function()
						end, config)
					end,
				},
			},
			distance = 3
		})
	end
end)

CreateThread(function()
	for i = 1, #shops.tattoos do
		RequestModel('u_m_y_tattoo_01', 100)
		cPed = CreatePed('CIVMALE', 'u_m_y_tattoo_01', shops.tattoos[i].x, shops.tattoos[i].y, shops.tattoos[i].z, shops.tattoos[i].w, false, false)
		FreezeEntityPosition(cPed, true)
		SetEntityInvincible(cPed, true)
		SetBlockingOfNonTemporaryEvents(cPed, true)
		exports.qtarget:AddTargetEntity(cPed, {
			options = {
				{
					icon = 'fa-solid fa-pencil',
					label = 'Tattoo zetten',
					action = function()
						local config = {
							ped = false,
							headBlend = false,
							faceFeatures = false,
							headOverlays = false,
							components = false,
							props = false,
							tattoos = true,
						}	
	
						exports['fivem-appearance']:startPlayerCustomization(function()
						end, config)
					end,
				},
			},
			distance = 3
		})
	end
end)

-- // [BLIPS] \\ --

local function createBlip(name, sprite, colour, scale, location)
	local blip = AddBlipForCoord(location.x, location.y)
	SetBlipSprite(blip, sprite)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.65)
	SetBlipColour(blip, colour)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(name)
	EndTextCommandSetBlipName(blip)
end

if GetConvarInt("ox_appearance:disable_blips", 0) == 0 then
	for i = 1, #shops.clothing do
		createBlip(locale('clothing_blip'), 73, 0, 0.7, shops.clothing[i])
	end

	for i = 1, #shops.barber do
		createBlip(locale('barber_blip'), 71, 0, 0.7, shops.barber[i])
	end

	for i = 1, #shops.tattoos do
		createBlip(locale('tattoo_blip'), 75, 0, 0.7, shops.tattoos[i])
	end
end

-- // [EXPORTS & FUNCTIONS] \\ --

local function SetCivilianOutfit()
    local ped = PlayerPedId()
    ESX.TriggerServerCallback('ox_appearance:getPlayerSkin', function(data)
        exports['fivem-appearance']:setPedAppearance(ped, data)
    end)
end

exports('SetCivilianOutfit', SetCivilianOutfit)

local function openShop(shopType)
	exports['fivem-appearance']:startPlayerCustomization(function(appearance)
		if (appearance) then
			if ESX then
				TriggerServerEvent('esx_skin:save', appearance)
			else
				TriggerServerEvent('ox_appearance:save', appearance)
			end
		end
	end, config[shopType])
end

exports("OpenShop", openShop)

local function SetJobOutfit(props, components)
	local ped = PlayerPedId()
    ESX.TriggerServerCallback('ox_appearance:getPlayerSkin', function(data)
        local outfitData = data

		if props and next(props) then
			for k,v in pairs(props) do
				outfitData.props[k] = props[k]
			end
		end

		if components and next(components) then
			for k,v in pairs(components) do
				outfitData.components[k] = components[k]
			end
		end

        exports['fivem-appearance']:setPedAppearance(ped, outfitData)
    end)
end

exports('SetJobOutfit', SetJobOutfit)

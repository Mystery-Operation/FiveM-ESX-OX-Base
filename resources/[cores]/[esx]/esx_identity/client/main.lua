local loadingScreenFinished = false
local ready = false
local guiEnabled = false
local cam = nil
local namereset = false

RegisterNetEvent('esx_identity:alreadyRegistered', function()
    while not loadingScreenFinished do 
        Wait(100) 
    end

    -- TriggerEvent('esx_skin:openSaveableMenu', false, false, true)

    TriggerEvent('esx_skin:playerRegistered')
end)

AddEventHandler('esx:loadingScreenOff', function()
    loadingScreenFinished = true
end)

RegisterNUICallback('ready', function(data, cb)
    ready = true
    cb(1)
end)

if not Config.UseDeferrals then
    function EnableGui(state)
        SetNuiFocus(state, state)
        guiEnabled = state

        -- Setup Cam
        if state and not namereset then
            if not DoesCamExist(cam) then
                local PedCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.1, 1.7, 0.0)
                cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
                SetCamActive(cam, true)
                RenderScriptCams(1, 1, 750, 1, 0)
                SetCamCoord(cam, PedCoords.x, PedCoords.y, PedCoords.z)
                SetCamRot(cam, 0.0, 0.0, GetEntityHeading(PlayerPedId()) + 180)

                SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) - 30)
                SetEntityVisible(PlayerPedId(), 0, 0)
				SetLocalPlayerVisibleLocally(1)
                SetPlayerInvincible(PlayerId(), 1)
                FreezeEntityPosition(PlayerPedId(), true)
                SetPedAoBlobRendering(PlayerPedId(), true)
                SetEntityAlpha(PlayerPedId(), 255)
            end
        else
            DestroyCam(cam, false)
            RenderScriptCams(0, 0, 750, 1, 0)
            cam = nil
        end

        SendNUIMessage({type = "enableui", enable = state, reset = namereset})
    end

    RegisterNetEvent('esx_identity:showRegisterIdentity', function()
        TriggerEvent('esx_skin:resetFirstSpawn')

        if not ESX.PlayerData.dead then EnableGui(true) end
    end)

    RegisterNetEvent('esx_identity:namereset', function()
        namereset = true
        if not ESX.PlayerData.dead then EnableGui(true) end
    end)

    RegisterNUICallback('register', function(data, cb)
        if data.firstname == '' or data.lastname == '' or data.sex == nil or data.dateofbirth == '' or data.height == '' then
            local errorMsg = ''
            if data.firstname == '' then
              errorMsg = 'Vul een geldige voornaam in!'
            elseif data.lastname == '' then
              errorMsg = 'Vul een geldige achternaam in!'
            elseif data.sex == nil then
              errorMsg = 'Vul een geldig geslacht in!'
            elseif data.height == '' then
                errorMsg = 'Vul een geldige lengte in!'
            elseif data.dateofbirth == '' then
              errorMsg = 'Vul een geldige geboortedatum in!'
            end

            SendNUIMessage({
              type = "showError",
              text = errorMsg
            })

            return
        end

        data.firstname = data.firstname:gsub("^%l", string.upper)
        data.lastname = data.lastname:gsub("^%l", string.upper)

        if isValidDate(data.dateofbirth) then
            if tonumber(data.height) <= 220 and tonumber(data.height) >= 120 then
                ESX.TriggerServerCallback('esx_identity:registerIdentity', function(callback)
                    if callback then
                        EnableGui(false)
                        FreezeEntityPosition(PlayerPedId(), false)
                        if not namereset then
                            exports['ox_appearance']:openSaveableMenu(false, false, true)
                        else
                            namereset = false
                        end
                    end
                end, data)
            else
                if tonumber(data.height) <= 120 then
                    SendNUIMessage({
                      type = "showError",
                      text = "Je hebt een te korte lengte ingevuld!"
                    })
                elseif tonumber(data.height) >= 220 then
                    SendNUIMessage({
                        type = "showError",
                        text = "Je hebt een te lange lengte ingevuld!"
                    })
                end
            end
        else
            SendNUIMessage({
                type = "showError",
                text = "Je hebt geen geldige datum ingevuld!"
            })
        end
    end)

    function LoadPlayerModel(skin)
        RequestModel(skin)
        while not HasModelLoaded(skin) do
            Citizen.Wait(0)
        end
    end

    RegisterNUICallback("setPed", function(data, cb)
        local Model = data.gender == 'm' and `mp_m_freemode_01` or `mp_f_freemode_01`
        Citizen.CreateThread(function()

            LoadPlayerModel(Model)
            SetPlayerModel(PlayerId(), Model)
            SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 2)
            SetEntityVisible(PlayerPedId(), true, 0)
            SetPlayerInvincible(PlayerId(), 0)
            FreezeEntityPosition(PlayerPedId(), true)
            SetPedAoBlobRendering(PlayerPedId(), true)

            local alpha = 0
            repeat 
                alpha = alpha + 15
                SetEntityAlpha(PlayerPedId(), alpha, false)
                Wait(10)
            until alpha == 255
        end)
    end)

    CreateThread(function()
        while true do
            local sleep = 1500

            if guiEnabled then
                sleep = 0
                DisableControlAction(0, 1, true) -- LookLeftRight
                DisableControlAction(0, 2, true) -- LookUpDown
                DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
                DisableControlAction(0, 142, true) -- MeleeAttackAlternate
                DisableControlAction(0, 30, true) -- MoveLeftRight
                DisableControlAction(0, 31, true) -- MoveUpDown
                DisableControlAction(0, 21, true) -- disable sprint
                DisableControlAction(0, 24, true) -- disable attack
                DisableControlAction(0, 25, true) -- disable aim
                DisableControlAction(0, 47, true) -- disable weapon
                DisableControlAction(0, 58, true) -- disable weapon
                DisableControlAction(0, 263, true) -- disable melee
                DisableControlAction(0, 264, true) -- disable melee
                DisableControlAction(0, 257, true) -- disable melee
                DisableControlAction(0, 140, true) -- disable melee
                DisableControlAction(0, 141, true) -- disable melee
                DisableControlAction(0, 143, true) -- disable melee
                DisableControlAction(0, 75, true) -- disable exit vehicle
                DisableControlAction(27, 75, true) -- disable exit vehicle
            else
                sleep = 1500
            end

            Wait(sleep)
        end
    end)
end

function isValidDate(str)
    local d, m, y = str:match("(%d+)-(%d+)-(%d+)")
    d, m, y = tonumber(d), tonumber(m), tonumber(y)
    
    if d == nil or m == nil or y == nil then
        return false
    else
        if d < 0 or d > 31 or m < 0 or m > 12 or y < 0 then
            return false
        elseif m == 4 or m == 6 or m == 9 or m == 11 then 
            return d <= 30
        elseif m == 2 then
            if y%400 == 0 or (y%100 ~= 0 and y%4 == 0) then
                return d <= 29
            else
                return d <= 28
            end
        else 
            return d <= 31
        end
    end
end
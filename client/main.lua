local wheelPos = Config.WheelPos
local vehPos = Config.VehPos
local wheel = nil
local vehicle = nil
local isRolling = false
local isLoggedIn = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

Citizen.CreateThread(function()
    local model = `vw_prop_vw_luckywheel_02a`
    local carmodel = Config.Vehicle
    
    Citizen.CreateThread(function()
        while not isLoggedIn do 
            Citizen.Wait(500)
        end

        if isLoggedIn then
            
            -- Wheel
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(0)
            end
            wheel = CreateObject(model, wheelPos.x, wheelPos.y, wheelPos.z, false, false, true)
            SetEntityHeading(wheel, 328.0)
            SetModelAsNoLongerNeeded(model)
            
            -- Car
            RequestModel(carmodel)
            while not HasModelLoaded(carmodel) do
                Citizen.Wait(0)
            end
            
            vehicle = CreateVehicle(carmodel, vehPos, true, false)
            SetModelAsNoLongerNeeded(carmodel)
            FreezeEntityPosition(vehicle, true)
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        if vehicle ~= nil then
            local _heading = GetEntityHeading(vehicle)
            local _z = _heading - 0.3
            SetEntityHeading(vehicle, _z)
        end
        Citizen.Wait(5)
    end
end)


RegisterNetEvent('qb-luckywheel:winCar')
AddEventHandler('qb-luckywheel:winCar', function()
    local vehicleProps = QBCore.Functions.GetVehicleProperties(vehicle)
    TriggerServerEvent('qb-luckywheel:carRedeem', vehicleProps)
end)

RegisterNetEvent('qb-luckywheel:winCarEmail')
AddEventHandler('qb-luckywheel:winCarEmail', function()
    TriggerServerEvent('qb-phone:server:sendNewMail', {
        sender = 'The Diamond Casino',
        subject = 'Your new car!',
        message = 'Your new car is waiting for you at the Caears 24 Parking!',
    })
end)

RegisterNetEvent('qb-luckywheel:doRoll')
AddEventHandler('qb-luckywheel:doRoll', function(_priceIndex)
    isRolling = true
    SetEntityRotation(wheel, 0.0, 0.0, 0.0, 1, true)
    Citizen.CreateThread(function()
        local speedIntCnt = 1
        local rollspeed = 1.0
        local _winAngle = (_priceIndex - 1) * 18
        local _rollAngle = _winAngle + (360 * 8)
        local _midLength = (_rollAngle / 2)
        local intCnt = 0
        while speedIntCnt > 0 do
            local retval = GetEntityRotation(wheel, 1)
            if _rollAngle > _midLength then
                speedIntCnt = speedIntCnt + 1
            else
                speedIntCnt = speedIntCnt - 1
                if speedIntCnt < 0 then
                    speedIntCnt = 0
                end
            end
            intCnt = intCnt + 1
            rollspeed = speedIntCnt / 10
            local _y = retval.y - rollspeed
            _rollAngle = _rollAngle - rollspeed
            SetEntityRotation(wheel, 0.0, _y, -30.9754, 2, true)
            Citizen.Wait(0)
        end
    end)
end)

RegisterNetEvent('qb-luckywheel:rollFinished')
AddEventHandler('qb-luckywheel:rollFinished', function()
    isRolling = false
end)

function doRoll()
    if not isRolling then
        isRolling = true
        local playerPed = PlayerPedId()
        local _lib = 'anim_casino_a@amb@casino@games@lucky7wheel@female'
        if IsPedMale(playerPed) then
            _lib = 'anim_casino_a@amb@casino@games@lucky7wheel@male'
        end
        local lib, anim = _lib, 'enter_right_to_baseidle'
        while (not HasAnimDictLoaded(lib)) do
            RequestAnimDict(lib)
            Citizen.Wait(100)
        end
        local _movePos = vector3(948.32, 45.14, 71.64)
        TaskGoStraightToCoord(playerPed, _movePos.x, _movePos.y, _movePos.z, 1.0, -1, 312.2, 0.0)
        local _isMoved = false
        while not _isMoved do
            local coords = GetEntityCoords(playerPed)
            if coords.x >= (_movePos.x - 0.01) and coords.x <= (_movePos.x + 0.01) and coords.y >= (_movePos.y - 0.01) and coords.y <= (_movePos.y + 0.01) then
                _isMoved = true
            end
            Citizen.Wait(0)
        end
        TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
        while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
            Citizen.Wait(0)
            DisableAllControlActions(0)
        end
        TaskPlayAnim(playerPed, lib, 'enter_to_armraisedidle', 8.0, -8.0, -1, 0, 0, false, false, false)
        while IsEntityPlayingAnim(playerPed, lib, 'enter_to_armraisedidle', 3) do
            Citizen.Wait(0)
            DisableAllControlActions(0)
        end
        TriggerServerEvent('qb-luckywheel:getLucky')
        TaskPlayAnim(playerPed, lib, 'armraisedidle_to_spinningidle_high', 8.0, -8.0, -1, 0, 0, false, false, false)
    
    end
end

-- 3D Text
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local coords = GetEntityCoords(PlayerPedId())
        if #(coords - vector3(wheelPos.x, wheelPos.y, wheelPos.z)) < 1.5 and not isRolling then
            QBCore.Functions.DrawText3D(wheelPos.x, wheelPos.y, wheelPos.z + 1, 'Press ~g~E~w~ To Try Your Luck On The Wheel')
            if IsControlJustReleased(0, 38) then
                doRoll()
            end
        end
    end
end)

ESX = nil
isRoll = false
amount = 50000

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_tpnrp_luckywheel:getLucky')
AddEventHandler('esx_tpnrp_luckywheel:getLucky', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not isRoll then
        if xPlayer ~= nil then
            if xPlayer.getMoney() >= amount then
                xPlayer.removeMoney(amount)
                isRoll = true
                -- local _priceIndex = math.random(1, 20)
                local _randomPrice = math.random(1, 100)
                if _randomPrice == 1 then
                    -- Win car
                    local _subRan = math.random(1,1000)
                    if _subRan <= 1 then
                        _priceIndex = 19
                    else
                        _priceIndex = 3
                    end
                elseif _randomPrice > 1 and _randomPrice <= 6 then
                    -- Win skin AK Gold
                    _priceIndex = 12
                    local _subRan = math.random(1,20)
                    if _subRan <= 2 then
                        _priceIndex = 12
                    else
                        _priceIndex = 7
                    end
                elseif _randomPrice > 6 and _randomPrice <= 15 then
                    -- Black money
                    -- 4, 8, 11, 16
                    local _sRan = math.random(1, 4)
                    if _sRan == 1 then
                        _priceIndex = 4
                    elseif _sRan == 2 then
                        _priceIndex = 8
                    elseif _sRan == 3 then
                        _priceIndex = 11
                    else
                        _priceIndex = 16
                    end
                elseif _randomPrice > 15 and _randomPrice <= 25 then
                    -- Win 300,000$
                    -- _priceIndex = 5
                    local _subRan = math.random(1,20)
                    if _subRan <= 2 then
                        _priceIndex = 5
                    else
                        _priceIndex = 20
                    end
                elseif _randomPrice > 25 and _randomPrice <= 40 then
                    -- 1, 9, 13, 17
                    local _sRan = math.random(1, 4)
                    if _sRan == 1 then
                        _priceIndex = 1
                    elseif _sRan == 2 then
                        _priceIndex = 9
                    elseif _sRan == 3 then
                        _priceIndex = 13
                    else
                        _priceIndex = 17
                    end
                elseif _randomPrice > 40 and _randomPrice <= 60 then
                    local _itemList = {}
                    _itemList[1] = 2
                    _itemList[2] = 6
                    _itemList[3] = 10
                    _itemList[4] = 14
                    _itemList[5] = 18
                    _priceIndex = _itemList[math.random(1, 5)]
                elseif _randomPrice > 60 and _randomPrice <= 100 then
                    local _itemList = {}
                    _itemList[1] = 3
                    _itemList[2] = 7
                    _itemList[3] = 15
                    _itemList[4] = 20
                    _priceIndex = _itemList[math.random(1, 4)]
                end
                -- print("Price " .. _priceIndex)
                SetTimeout(12000, function()
                    isRoll = false
                    -- Give Price
                    if _priceIndex == 1 or _priceIndex == 9 or _priceIndex == 13 or _priceIndex == 17 then
                        -- print("win mu~ 1, giap 3")
                        xPlayer.addInventoryItem("police_helmet_1", 1)
                        xPlayer.addInventoryItem("bullet_wear_1", 1)
                        TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^8Vòng quay: ^1'.. xPlayer.name .. " đã thắng được 1 mũ 1, giáp 1 !")
                    elseif _priceIndex == 2 or _priceIndex == 6 or _priceIndex == 10 or _priceIndex == 14 or _priceIndex == 18 then
                        -- print("banh mi + nuoc")
                        xPlayer.addInventoryItem("bread", 10)
                        xPlayer.addInventoryItem("water", 24)
                        TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^8Vòng quay: ^1'.. xPlayer.name .. " đã thắng được 1 lốc nước suối 24 chai + 10 cái bánh mì!")
                    elseif _priceIndex == 3 or _priceIndex == 7 or _priceIndex == 15 or _priceIndex == 20 then
                        -- print("Win money")
                        local _money = 0
                        if _priceIndex == 3 then
                            _money = 20000
                        elseif _priceIndex == 7 then
                            _money = 30000
                        elseif _priceIndex == 15 then
                            _money = 40000
                        elseif _priceIndex == 20 then
                            _money = 50000
                        end
                        xPlayer.addMoney(_money)
                        TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^8Vòng quay: ^1'.. xPlayer.name .. " đã thắng được " .. ESX.Math.GroupDigits(_money) .. "$")
                    elseif _priceIndex == 4 or _priceIndex == 8 or _priceIndex == 11 or _priceIndex == 16 then
                        -- print("Black money x2")
                        local _blackMoney = 0
                        if _priceIndex == 4 then
                            _blackMoney = 10000
                        elseif _priceIndex == 8 then
                            _blackMoney = 15000
                        elseif _priceIndex == 11 then
                            _blackMoney = 20000
                        elseif _priceIndex == 16 then
                            _blackMoney = 25000
                        end
                        xPlayer.addAccountMoney("black_money", _blackMoney * 10)
                        -- xPlayer.addMoney(_blackMoney * 2)
                        TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^8Vòng quay: ^1'.. xPlayer.name .. " đã thắng được " .. ESX.Math.GroupDigits(_blackMoney * 10) .. "$")
                    elseif _priceIndex == 5 then
                        -- print("Win 300,000$")
                        xPlayer.addMoney(300000)
                        TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^8Vòng quay: ^1'.. xPlayer.name .. " đã thắng được giải 300,000$!")
                    elseif _priceIndex == 12 then
                        -- print("Win ak gold")
                        xPlayer.addInventoryItem("attach_skin_ak", 1)
                        TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^8Vòng quay: ^1'.. xPlayer.name .. " đã thắng được 1 Skin AK Gold!")
                    elseif _priceIndex == 19 then
                        -- print("Win car lp700r")
                        TriggerClientEvent("esx_tpnrp_luckywheel:winCar", _source)
                        TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^8Vòng quay: ^1'.. xPlayer.name .. " đã thắng được 1 Skin AK Gold!")
                    end
                    TriggerClientEvent("esx_tpnrp_luckywheel:rollFinished", -1)
                end)
                TriggerClientEvent("esx_tpnrp_luckywheel:doRoll", -1, _priceIndex)
            else
                TriggerClientEvent("esx_tpnrp_luckywheel:rollFinished", -1)    
                TriggerClientEvent('esx:showNotification', _source, "Bạn không có đủ tiền trong ví để chơi! Yêu cầu " .. ESX.Math.GroupDigits(amount) .. "$ cho 1 lần quay!")
            end
        end
    end
end)

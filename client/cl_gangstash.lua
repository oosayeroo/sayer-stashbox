local QBCore = exports['qb-core']:GetCoreObject()
local PlayerGang = QBCore.Functions.GetPlayerData().gang
local shownGangStash = false

-- UTIL
local function CloseMenuFullGang()
    exports['qb-menu']:closeMenu()
    exports['qb-core']:HideText()
    shownGangStash = false
end

local function comma_valueGang(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k == 0) then
            break
        end
    end
    return formatted
end

--//Events
AddEventHandler('onResourceStart', function(resource)--if you restart the resource
    if resource == GetCurrentResourceName() then
        Wait(200)
        PlayerGang = QBCore.Functions.GetPlayerData().gang
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerGang = QBCore.Functions.GetPlayerData().gang
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(InfoGang)
    PlayerGang = InfoGang
end)

RegisterNetEvent('qb-gangstash:client:Stash1', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "gang1" .. PlayerGang.name, {
        maxweight = Config.GangStashWeight,
        slots = Config.GangStashSlots,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "gang1" .. PlayerGang.name)
end)

RegisterNetEvent('qb-gangstash:client:Stash2', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "gang2" .. PlayerGang.name, {
        maxweight = Config.GangStashWeight,
        slots = Config.GangStashSlots,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "gang2" .. PlayerGang.name)
end)

RegisterNetEvent('qb-gangstash:client:Stash3', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "gang3" .. PlayerGang.name, {
        maxweight = Config.GangStashWeight,
        slots = Config.GangStashSlots,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "gang3" .. PlayerGang.name)
end)

RegisterNetEvent('qb-gangstash:client:Stash4', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "gang4" .. PlayerGang.name, {
        maxweight = Config.GangStashWeight,
        slots = Config.GangStashSlots,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "gang4" .. PlayerGang.name)
end)


RegisterNetEvent('qb-gangstash:client:OpenMenu', function()
    shownGangStash = true
    local GangStash = {
        {
            header = "Gang Stash  - " .. string.upper(PlayerGang.label),
            isMenuHeader = true,
        },
        {
            header = "🗄️ Storage Access",
            txt = "Open"..PlayerGang.label.. "Stash 1",
            params = {
                event = "qb-gangstash:client:Stash1",
            }
        },
        {
            header = "🗄️ Storage Access",
            txt = "Open "..PlayerGang.label.. " Stash 2",
            params = {
                event = "qb-gangstash:client:Stash2",
            }
        },
        {
            header = "🗄️ Storage Access",
            txt = "Open "..PlayerGang.label.. " Stash 3",
            params = {
                event = "qb-gangstash:client:Stash3",
            }
        },
        {
            header = "🗄️ Storage Access",
            txt = "Open "..PlayerGang.label.. " Stash 4",
            params = {
                event = "qb-gangstash:client:Stash4",
            }
        },
        {
            header = "Exit",
            params = {
                event = "qb-menu:closeMenu",
            }
        },
    }
    exports['qb-menu']:openMenu(GangStash)
end)



-- MAIN THREAD

CreateThread(function()
    if Config.UseTarget then
        for gang, zones in pairs(Config.GangStashZones) do
            for index, data in ipairs(zones) do
                exports['qb-target']:AddBoxZone(gang.."-GangStash"..index, data.coords, data.length, data.width, {
                    name = gang.."-GangStash"..index,
                    heading = data.heading,
                    debugPoly = Config.DebugStashZones,
                    minZ = data.minZ,
                    maxZ = data.maxZ,
                }, {
                    options = {
                        {
                            type = "client",
                            event = "qb-gangstash:client:OpenMenu",
                            icon = "fas fa-sign-in-alt",
                            label = "Gang Stash",
                            canInteract = function() return gang == PlayerGang.name end,
                        },
                    },
                    distance = 2.5
                })
            end
        end
    else
        while true do
            local wait = 2500
            local pos = GetEntityCoords(PlayerPedId())
            local inRangeGang = false
            local nearGangStash = false
            if PlayerGang then
                wait = 0
                for k, menus in pairs(Config.GangStash) do
                    for _, coords in ipairs(menus) do
                        if k == PlayerGang.name then
                            if #(pos - coords) < 5.0 then
                                inRangeGang = true
                                if #(pos - coords) <= 1.5 then
                                    nearGangStash = true
                                    if not shownGangStash then 
                                        exports['qb-core']:DrawText('[E] Open Gang Stash', 'left')
                                    end

                                    if IsControlJustReleased(0, 38) then
                                        exports['qb-core']:HideText()
                                        TriggerEvent("qb-gangstash:client:OpenMenu")
                                    end
                                end
                                
                                if not nearGangStash and shownGangStash then
                                    CloseMenuFullGang()
                                    shownGangStash = false
                                end
                            end
                        end
                    end
                end
                if not inRangeGang then
                    Wait(1500)
                    if shownGangStash then
                        CloseMenuFullGang()
                        shownGangStash = false
                    end
                end
            end
            Wait(wait)
        end
    end
end)

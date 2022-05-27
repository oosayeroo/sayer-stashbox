local QBCore = exports['qb-core']:GetCoreObject()
local PlayerJob = QBCore.Functions.GetPlayerData().job
local shownJobStash = false

-- UTIL
local function CloseMenuFull()
    exports['qb-menu']:closeMenu()
    exports['qb-core']:HideText()
    shownJobStash = false
end

local function comma_value(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k == 0) then
            break
        end
    end
    return formatted
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        PlayerJob = QBCore.Functions.GetPlayerData().job
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('qb-jobstash:client:OpenMenu', function()
    if not PlayerJob.name then return end

    local JobStash = {
        {
            header = "Job Stash - " .. string.upper(PlayerJob.label),
            isMenuHeader = true,
        },
        {
            header = "🗄️ Storage Access",
            txt = "Open Storage1",
            params = {
                event = "qb-jobstash:client:Stash1",
            }
        },
        {
            header = "🗄️ Storage Access",
            txt = "Open Storage2",
            params = {
                event = "qb-jobstash:client:Stash2",
            }
        },
        {
            header = "🗄️ Storage Access",
            txt = "Open Storage3",
            params = {
                event = "qb-jobstash:client:Stash3",
            }
        },
        {
            header = "🗄️ Storage Access",
            txt = "Open Storage4",
            params = {
                event = "qb-jobstash:client:Stash4",
            }
        },
        {
            header = "Exit",
            params = {
                event = "qb-menu:closeMenu",
            }
        },
    }
    exports['qb-menu']:openMenu(JobStash)
end)



RegisterNetEvent('qb-jobstash:client:Stash1', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "job1" .. PlayerJob.name, {
        maxweight = 4000000,
        slots = 25,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "job1" .. PlayerJob.name)
end)

RegisterNetEvent('qb-jobstash:client:Stash2', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "job2" .. PlayerJob.name, {
        maxweight = 4000000,
        slots = 25,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "job2" .. PlayerJob.name)
end)

RegisterNetEvent('qb-jobstash:client:Stash3', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "job3" .. PlayerJob.name, {
        maxweight = 4000000,
        slots = 25,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "job3" .. PlayerJob.name)
end)

RegisterNetEvent('qb-jobstash:client:Stash4', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "job4" .. PlayerJob.name, {
        maxweight = 4000000,
        slots = 25,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "job4" .. PlayerJob.name)
end)

-- MAIN THREAD
CreateThread(function()
    if Config.UseTarget then
        for job, zones in pairs(Zones) do
            for index, data in ipairs(zones) do
                exports['qb-target']:AddBoxZone(job.."-JobStash-"..index, data.coords, data.length, data.width, {
                    name = job.."-JobStash-"..index,
                    heading = data.heading,
                    -- debugPoly = true,
                    minZ = data.minZ,
                    maxZ = data.maxZ,
                }, {
                    options = {
                        {
                            type = "client",
                            event = "qb-jobstash:client:OpenMenu",
                            icon = "fas fa-sign-in-alt",
                            label = "Job Stash",
                            canInteract = function() return job == PlayerJob.name end,
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
            local inRangeJobStash = false
            local nearJobStash = false
            if PlayerJob then
                wait = 0
                for k, menus in pairs(Config.JobStash) do
                    for _, coords in ipairs(menus) do
                        if k == PlayerJob.name then
                            if #(pos - coords) < 5.0 then
                                inRangeJobStash = true
                                if #(pos - coords) <= 1.5 then
                                    nearJobStash = true
                                    if not shownJobStash then 
                                        exports['qb-core']:DrawText('[E] Open Job Stash', 'left')
                                        --shownJobStash = true
                                    end

                                    if IsControlJustReleased(0, 38) then
                                        exports['qb-core']:HideText()
                                        TriggerEvent("qb-jobstash:client:OpenMenu")
                                    end
                                end
                                
                                if not nearJobStash and shownJobStash then
                                    CloseMenuFull()
                                    shownJobStash = false
                                end
                            end
                        end
                    end
                end
                if not inRangeJobStash then
                    Wait(1500)
                    if shownJobStash then
                        CloseMenuFull()
                        shownJobStash = false
                    end
                end
            end
            Wait(wait)
        end
    end
end)

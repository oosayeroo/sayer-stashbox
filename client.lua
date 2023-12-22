local QBCore = exports['qb-core']:GetCoreObject()
local PlayerJob = QBCore.Functions.GetPlayerData().job
local PlayerGang = QBCore.Functions.GetPlayerData().gang
local inRangeStash = false
local shownStash = false
local Stash = {}
local StashProp = {}

-- UTIL
local function CloseMenuFull()
    exports['qb-core']:HideText()
    shownStash = false
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        PlayerJob = QBCore.Functions.GetPlayerData().job
        PlayerGang = QBCore.Functions.GetPlayerData().gang
        InitializeStashProps()
        if Config.UseTarget then
            RunTargetThread()
        else
            RunDrawtextThread()
        end
    end
end)

AddEventHandler('onResourceStop', function(t) if t ~= GetCurrentResourceName() then return end
    for k in pairs(Stash) do exports['qb-target']:RemoveZone(k) end
    for _,v in pairs(StashProp) do 
        if DoesEntityExist(v) then
            DeleteEntity(v) 
            DebugCode("Entity = "..v.." = Deleted") 
        else
            DebugCode("Cannot Find Entity "..v)
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    PlayerGang = QBCore.Functions.GetPlayerData().gang
    InitializeStashProps()
    if Config.UseTarget then
        RunTargetThread()
    else
        RunDrawtextThread()
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)
RegisterNetEvent('QBCore:Client:OnGangUpdate', function(InfoGang)
    PlayerGang = InfoGang
end)

RegisterCommand("testPlayerJob", function() 
    DebugCode("PlayerJob.name: "..tostring(PlayerJob.name))
    DebugCode("PlayerJob.label: "..tostring(PlayerJob.label))
    DebugCode("PlayerJob.grade.level: "..tostring(PlayerJob.grade.level))
end, false)

RegisterCommand("testPlayerGang", function() 
    DebugCode("PlayerGang.name: "..tostring(PlayerGang.name))
    DebugCode("PlayerGang.label: "..tostring(PlayerGang.label))
    DebugCode("PlayerGang.grade.level: "..tostring(PlayerGang.grade.level))
end, false)

function RunTargetThread()
    DebugCode("Target Thread Active")
    for k, v in pairs(Config.Stashes) do
        if v.Enable then
            if v.Coords then
                if v.BoxZone then
                    if v.Stashes then
                        local Label = "Open "..((v.Type == 'job' and QBCore.Shared.Jobs[k].label) or (v.Type == 'gang' and QBCore.Shared.Gangs[k].label)).." Stash"
                        Stash["StashBox_"..k] = 
                        exports['qb-target']:AddBoxZone("StashBox_"..k, v.Coords, v.BoxZone.length, v.BoxZone.width, {
                            name = "StashBox_"..k,
                            heading = v.BoxZone.heading,
                            debugPoly = Config.DebugStashZones,
                            minZ = v.Coords.z-2,
                            maxZ = v.Coords.z+2,
                        }, {
                            options = {
                                {
                                    action = function()
                                        OpenStashMenu(k,v.Type,v.Stashes)
                                    end,
                                    icon = "fas fa-box",
                                    label = Label,
                                },
                            },
                            distance = v.Distance
                        })
                        DebugCode("Target Created For: "..tostring(k).." At Coords: "..tostring(v.Coords))
                    end
                end
            end
        end
    end
end

function RunDrawtextThread()
    DebugCode("Drawtext Thread Active")
    CreateThread(function()
        local debugCounter = 0
        while true do
            Wait(0)

            for k, v in pairs(Config.Stashes) do
                if v.Enable and v.Coords and v.Stashes then
                    local Needed = (v.Type == 'job' and PlayerJob) or (v.Type == 'gang' and PlayerGang)
                    local Label = "[E] Open "..((v.Type == 'job' and QBCore.Shared.Jobs[k].label) or (v.Type == 'gang' and QBCore.Shared.Gangs[k].label)).." Stash"

                    if debugCounter % 600 == 0 then  -- Print every 10 seconds
                        DebugCode("Checking stash: " .. k)
                        DebugCode("Player coords: "..GetEntityCoords(PlayerPedId()))
                        DebugCode("Stash coords: "..v.Coords)
                        DebugCode("Needed name: "..Needed.name)
                    end

                    if k == Needed.name and #(GetEntityCoords(PlayerPedId()) - v.Coords) < v.Distance then
                        inRangeStash = true
                        if not shownStash then 
                            DebugCode("In Range Of "..tostring(k))
                            exports['qb-core']:DrawText(Label, 'left')
                            shownStash = true
                        end
                        if IsControlJustReleased(0, 38) then
                            exports['qb-core']:HideText()
                            OpenStashMenu(k, v.Type, v.Stashes)
                            DebugCode("DrawtextThread:Pressed E")
                        end
                    end
                end

                if not inRangeStash and shownStash then
                    CloseMenuFull()
                    shownStash = false
                end
            end

            debugCounter = debugCounter + 1
        end
    end)
end



function OpenStashMenu(job,Type,stashes)
    if Config.Stashes[job].ItemLocked and not QBCore.Functions.HasItem(Config.Stashes[job].ItemLocked) then return end
    inRangeStash = false
    local Needed = PlayerJob
    local Label = ""
    if Type == 'job' then
        Needed = PlayerJob
        Label = QBCore.Shared.Jobs[job].label.." Stash"
    elseif Type == 'gang' then
        Needed = PlayerGang
        Label = QBCore.Shared.Gangs[job].label.." Stash"
    end
    local columns = {
        {
            header = Label,
            isMenuHeader = true,
        }, 
    }
    if Config.ShowImages then
        image = "<img src='nui://"..Config.ImageLink..job..".png' width='100px' style='margin-right: 5px'>"
        columns = {
            {
                header = image,
                text = Label,
                isMenuHeader = true,
            }, 
        }
    end

    for k,v in ipairs(stashes) do
        if v.GradeRequired and Needed.grade.level >= v.GradeRequired then
            local item = {}
            item.header = v.Label
            item.params = {
                event = 'sayer-stashbox:OpenStash',
                args = {
                    id = v.ID,
                    job = job,
                    weight = v.Weight,
                    slots = v.Slots,
                }
            }
            table.insert(columns, item)
        end
    end
    exports['qb-menu']:openMenu(columns, false, true)
end



RegisterNetEvent('sayer-stashbox:OpenStash', function(data)
    local id = data.id
    local job = data.job
    local weight = data.weight
    local slots = data.slots
    TriggerServerEvent("inventory:server:OpenInventory", "stash", job.."_"..id, {
        maxweight = weight,
        slots = slots,
    })
    TriggerEvent("inventory:client:SetCurrentStash", job.."_"..id)
end)

function InitializeStashProps()
    for k, v in pairs(Config.Stashes) do
        if v.Enable and v.Prop.Enable and v.Prop.Model ~= nil then
            if not DoesEntityExist("Prop_"..k) then
                DebugCode("MakingProp: "..tostring(k))
                local model = ''
                model = v.Prop.Model
                RequestModel(model)
                while not HasModelLoaded(model) do
                  Wait(0)
                end
                
                StashProp["Prop_"..k] = CreateObject(GetHashKey(model), vector3(v.Coords.x, v.Coords.y, v.Coords.z - 1), false, false, true)
                PlaceObjectOnGroundProperly(StashProp["Prop_"..k])
                SetEntityHeading(StashProp["Prop_"..k], v.Prop.Heading)
                FreezeEntityPosition(StashProp["Prop_"..k], true)
                SetEntityAsMissionEntity(StashProp["Prop_"..k])
                DebugCode("PropMadeFor: "..tostring(k))
            end
        end
    end
end

function DebugCode(msg)
    if Config.DebugCode then
        print(msg)
    end
end
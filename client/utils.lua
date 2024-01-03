local QBCore = exports['qb-core']:GetCoreObject()
local StashProp = {}
local Stash = {}
local inRangeStash = false
local shownStash = false

local function CloseMenuFull()
    exports['qb-core']:HideText()
    shownStash = false
end

function IsPlayerValid(Type, Need)
    local playerData = QBCore.Functions.GetPlayerData()
    local isdead = playerData.metadata["isdead"]
    local laststand = playerData.metadata["inlaststand"]

    if not isdead or not laststand then
        if Type == 'job' then
            return playerData.job.name == Need
        elseif Type == 'gang' then
            return playerData.gang.name == Need
        elseif Type == 'citizenid' then
            return playerData.citizenid == Need
        end
    end

    return false
end

function GetPlayerMoney(account)
    local has = QBCore.Functions.GetPlayerData().money[account]
    return has
end

function DebugCode(msg)
    if Config.DebugCode then
        print(msg)
    end
end

function RunTargetThread()
    DebugCode("Target Thread Active")

    local function createTargetForStash(k, v)
        local Label = "Open "..((v.Type == 'job' and QBCore.Shared.Jobs[k].label) or (v.Type == 'gang' and QBCore.Shared.Gangs[k].label) or (v.Type == 'citizenid' and "My")).." Stash"
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
                    canInteract = function()
                        return IsPlayerValid(v.Type, k)
                    end,
                    icon = "fas fa-box",
                    label = Label,
                },
            },
            distance = v.Distance
        })
        DebugCode("Target Created For: "..tostring(k).." At Coords: "..tostring(v.Coords))
    end

    for k, v in pairs(Config.Stashes) do
        if v.Enable and v.Coords and v.BoxZone and v.Stashes then
            createTargetForStash(k, v)
        end
    end

    local function createTargetForVault(k, d, j)
        Stash["Vault"..k..d] = 
        exports['qb-target']:AddBoxZone("Vault"..k..d, j.Coords, j.BoxZone.length, j.BoxZone.width, {
            name = "Vault"..k..d,
            heading = j.BoxZone.heading,
            debugPoly = Config.DebugStashZones,
            minZ = j.Coords.z-2,
            maxZ = j.Coords.z+2,
        }, {
            options = {
                {
                    action = function()
                        OpenVaultMenu(k)
                    end,
                    icon = "fas fa-sack-dollar",
                    label = "Bank Vault",
                },
            },
            distance = j.Distance
        })
        DebugCode("Target Created For: "..tostring(k).." Vault At Coords: "..tostring(j.Coords))
    end

    if Config.EnableBankVaults then
        for k, v in pairs(Config.Banks) do
            if v.Enable then
                for d, j in pairs(v.Locations) do
                    if j.Coords and j.BoxZone then
                        createTargetForVault(k, d, j)
                    end
                end
            end
        end
    end
end

function RunDrawtextThread()
    DebugCode("Drawtext Thread Active")
    CreateThread(function()
        while true do
            Wait(0)
            local playerCoords = GetEntityCoords(PlayerPedId())
            local inRange = false

            -- Function to handle stash logic
            local function handleStash(v, k, label)
                if IsPlayerValid(v.Type, k) and #(playerCoords - v.Coords) < v.Distance then
                    if not shownStash then
                        DebugCode("In Range Of " .. tostring(k))
                        exports['qb-core']:DrawText(label, 'left')
                        shownStash = true
                    end
                    if IsControlJustReleased(0, 38) then
                        exports['qb-core']:HideText()
                        OpenStashMenu(k, v.Type, v.Stashes)
                        DebugCode("DrawtextThread:Pressed E")
                    end
                    return true
                end
                return false
            end

            local function handleVault(v, k, label)
                if #(playerCoords - v.Coords) < v.Distance then
                    if not shownStash then
                        DebugCode("In Range Of " .. tostring(k))
                        exports['qb-core']:DrawText(label, 'left')
                        shownStash = true
                    end
                    if IsControlJustReleased(0, 38) then
                        exports['qb-core']:HideText()
                        OpenVaultMenu(k)
                        DebugCode("DrawtextThread:Pressed E")
                    end
                    return true
                end
                return false
            end

            -- Iterate through stashes
            for k, v in pairs(Config.Stashes) do
                if v.Enable and v.Coords and v.Stashes then
                    local Label = "Open "..((v.Type == 'job' and QBCore.Shared.Jobs[k].label) or (v.Type == 'gang' and QBCore.Shared.Gangs[k].label) or (v.Type == 'citizenid' and "My")).." Stash"
                    inRange = handleStash(v, k, Label) or inRange
                end
            end

            -- Iterate through bank vaults
            if Config.EnableBankVaults then
                for k, v in pairs(Config.Banks) do
                    if v.Enable and v.Locations then
                        for d, j in pairs(v.Locations) do
                            if handleVault(j, k, "[E] Bank Vault") then
                                inRange = true
                            end
                        end
                    end
                end
            end

            -- Hide text if not in range
            if not inRange and shownStash then
                CloseMenuFull()
                exports['qb-core']:HideText()
                shownStash = false
            end
        end
    end)
end

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
    for k, v in pairs(Config.Banks) do
        if v.Enable and v.Locations then
            for d,j in pairs(v.Locations) do
                if j.Prop and j.Prop.Enable and j.Prop.Model ~= nil then
                    if not DoesEntityExist("Vault_"..k..d) then
                        DebugCode("MakingProp: "..tostring(k))
                        local model = ''
                        model = j.Prop.Model
                        RequestModel(model)
                        while not HasModelLoaded(model) do
                          Wait(0)
                        end

                        StashProp["Vault_"..k..d] = CreateObject(GetHashKey(model), vector3(j.Coords.x, j.Coords.y, j.Coords.z - 1), false, false, true)
                        PlaceObjectOnGroundProperly(StashProp["Vault_"..k..d])
                        SetEntityHeading(StashProp["Vault_"..k..d], j.Prop.Heading)
                        FreezeEntityPosition(StashProp["Vault_"..k..d], true)
                        SetEntityAsMissionEntity(StashProp["Vault_"..k..d])
                        DebugCode("PropMadeFor Vault: "..tostring(k))
                    end
                elseif j.Ped and j.Ped.Enable and j.Ped.Model ~= nil then
                    if not DoesEntityExist("Vault_"..k..d) then
                        DebugCode("MakingProp: "..tostring(k))
                        local model = ''
                        model = j.Ped.Model
                        RequestModel(model)
                        while not HasModelLoaded(model) do
                          Wait(0)
                        end

                        StashProp["Vault_"..k..d] = CreatePed(0, model, j.Coords.x,j.Coords.y,j.Coords.z-1,j.Coords.w, false, false)
                        SetEntityHeading(StashProp["Vault_"..k..d], j.Ped.Heading)
                        SetEntityInvincible(StashProp["Vault_"..k..d],true)
                        FreezeEntityPosition(StashProp["Vault_"..k..d],true)
                        SetBlockingOfNonTemporaryEvents(StashProp["Vault_"..k..d],true)
                        DebugCode("PedMadeFor Vault: "..tostring(k))
                    end
                end
            end
        end
    end
end

function DeleteAllStashProps()
    for k in pairs(Stash) do exports['qb-target']:RemoveZone(k) end
    for _,v in pairs(StashProp) do 
        if DoesEntityExist(v) then
            DeleteEntity(v) 
            DebugCode("Entity = "..v.." = Deleted") 
        else
            DebugCode("Cannot Find Entity "..v)
        end
    end
end

-- BANK ROB CHECK README FOR ANY INSTRUCTIONS
function BankRobberyCheck()  --this function is run through every time someone tries to access a vault to ensure no powergaming(placing items in a vault after robbing them)
    if Config.PacificHeistScript == 'qb-bankrobbery' then
        QBCore.Functions.TriggerCallback('qb-bankrobbery:server:isRobberyActive', function(robbery)
            return robbery
        end)
    elseif Config.PacificHeistScript == 'rainmad' then
        QBCore.Functions.TriggerCallback('pacificheist:server:isBankHeist', function(robbery)
            return robbery
        end)
    elseif Config.PacificHeistScript == 'lionh34rt' then
        QBCore.Functions.TriggerCallback('qb-bankrobbery:server:RobberyBusy', function(robbery)
            return robbery
        end)
    end
    return false
end

function SendNotify(msg,type,time,title)
    if Config.NotifyScript == nil then DebugCode("Sayer Chopshop: Config.NotifyScript Not Set!") return end
    if not title then title = "Bus Job" end
    if not time then time = 5000 end
    if not type then type = 'success' end
    if not msg then DebugCode("SendNotify Client Triggered With No Message") return end
    if Config.NotifyScript == 'qb' then
        QBCore.Functions.Notify(msg,type,time)
    elseif Config.NotifyScript == 'okok' then
        exports['okokNotify']:Alert(title, msg, time, type, false)
    elseif Config.NotifyScript == 'qs' then
        exports['qs-notify']:Alert(msg, time, type)
    elseif Config.NotifyScript == 'other' then
        -- add your notify here
        exports['yournotifyscript']:Notify(msg,time,type)
    end
end
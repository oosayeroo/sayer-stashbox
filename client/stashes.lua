local QBCore = exports['qb-core']:GetCoreObject()
local PlayerJob = QBCore.Functions.GetPlayerData().job
local PlayerGang = QBCore.Functions.GetPlayerData().gang
local PlayerCitizenid = QBCore.Functions.GetPlayerData().citizenid

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        PlayerJob = QBCore.Functions.GetPlayerData().job
        PlayerGang = QBCore.Functions.GetPlayerData().gang
        PlayerCitizenid = QBCore.Functions.GetPlayerData().citizenid
        InitializeStashProps()
        if Config.UseTarget then
            RunTargetThread()
        else
            RunDrawtextThread()
        end
    end
end)

AddEventHandler('onResourceStop', function(t) if t ~= GetCurrentResourceName() then return end
    DeleteAllStashProps()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    PlayerGang = QBCore.Functions.GetPlayerData().gang
    PlayerCitizenid = QBCore.Functions.GetPlayerData().citizenid
    InitializeStashProps()
    if Config.UseTarget then
        RunTargetThread()
    else
        RunDrawtextThread()
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    DeleteAllStashProps()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)
RegisterNetEvent('QBCore:Client:OnGangUpdate', function(InfoGang)
    PlayerGang = InfoGang
end)


-- ████████████████████████████████████████████████████████████████████████████
-- █░░░░░░░░░░░░░░█░░░░░░░░░░░░░░█░░░░░░░░░░░░░░█░░░░░░░░░░░░░░█░░░░░░██░░░░░░█
-- █░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀░░██░░▄▀░░█
-- █░░▄▀░░░░░░░░░░█░░░░░░▄▀░░░░░░█░░▄▀░░░░░░▄▀░░█░░▄▀░░░░░░░░░░█░░▄▀░░██░░▄▀░░█
-- █░░▄▀░░█████████████░░▄▀░░█████░░▄▀░░██░░▄▀░░█░░▄▀░░█████████░░▄▀░░██░░▄▀░░█
-- █░░▄▀░░░░░░░░░░█████░░▄▀░░█████░░▄▀░░░░░░▄▀░░█░░▄▀░░░░░░░░░░█░░▄▀░░░░░░▄▀░░█
-- █░░▄▀▄▀▄▀▄▀▄▀░░█████░░▄▀░░█████░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█
-- █░░░░░░░░░░▄▀░░█████░░▄▀░░█████░░▄▀░░░░░░▄▀░░█░░░░░░░░░░▄▀░░█░░▄▀░░░░░░▄▀░░█
-- █████████░░▄▀░░█████░░▄▀░░█████░░▄▀░░██░░▄▀░░█████████░░▄▀░░█░░▄▀░░██░░▄▀░░█
-- █░░░░░░░░░░▄▀░░█████░░▄▀░░█████░░▄▀░░██░░▄▀░░█░░░░░░░░░░▄▀░░█░░▄▀░░██░░▄▀░░█
-- █░░▄▀▄▀▄▀▄▀▄▀░░█████░░▄▀░░█████░░▄▀░░██░░▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀░░██░░▄▀░░█
-- █░░░░░░░░░░░░░░█████░░░░░░█████░░░░░░██░░░░░░█░░░░░░░░░░░░░░█░░░░░░██░░░░░░█
-- ████████████████████████████████████████████████████████████████████████████

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
    elseif Type == 'citizenid' then
        Needed = PlayerCitizenid
        Label = "My Stash"
    end
    local columns = {
        {
            header = Label,
            isMenuHeader = true,
        }, 
    }
    if Config.ShowImages then
        if Type ~= 'citizenid' then
            image = "<img src='nui://"..Config.ImageLink.Menu..job..".png' width='100px' style='margin-right: 5px'>"
        else
            image = "<img src='nui://"..Config.ImageLink.Menu.."personal.png' width='100px' style='margin-right: 5px'>"
        end
        columns = {
            {
                header = image,
                text = Label,
                isMenuHeader = true,
            }, 
        }
    end

    for k,v in ipairs(stashes) do
        if Type ~= 'citizenid' then
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
        else
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
    local invID = job.."_"..id
    local arguments = {
        label = job.."_"..id,
        maxweight = weight,
        slots = slots,
    }
    TriggerServerEvent('sayer-stashbox:OpenInventory', invID, arguments)
end)


-- ████████████████████████████████████████████████████████████████████████████
-- █░░░░░░██░░░░░░█░░░░░░░░░░░░░░█░░░░░░██░░░░░░█░░░░░░█████████░░░░░░░░░░░░░░█
-- █░░▄▀░░██░░▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░█████████░░▄▀▄▀▄▀▄▀▄▀░░█
-- █░░▄▀░░██░░▄▀░░█░░▄▀░░░░░░▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░█████████░░░░░░▄▀░░░░░░█
-- █░░▄▀░░██░░▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░█████████████░░▄▀░░█████
-- █░░▄▀░░██░░▄▀░░█░░▄▀░░░░░░▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░█████████████░░▄▀░░█████
-- █░░▄▀░░██░░▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░█████████████░░▄▀░░█████
-- █░░▄▀░░██░░▄▀░░█░░▄▀░░░░░░▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░█████████████░░▄▀░░█████
-- █░░▄▀▄▀░░▄▀▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░█████████████░░▄▀░░█████
-- █░░░░▄▀▄▀▄▀░░░░█░░▄▀░░██░░▄▀░░█░░▄▀░░░░░░▄▀░░█░░▄▀░░░░░░░░░░█████░░▄▀░░█████
-- ███░░░░▄▀░░░░███░░▄▀░░██░░▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█████░░▄▀░░█████
-- █████░░░░░░█████░░░░░░██░░░░░░█░░░░░░░░░░░░░░█░░░░░░░░░░░░░░█████░░░░░░█████
-- ████████████████████████████████████████████████████████████████████████████

function OpenVaultMenu(bank)
    if not Config.Banks[bank] then return end
    local banklabel = Config.Banks[bank].Label
    if not BankRobberyCheck() then
        QBCore.Functions.TriggerCallback('sayer-stashbox:GetBankDetails', function(result)
            if result then
                local upgradeprice = Config.VaultUpgrades[bank][result.Upgrade].UpgradePrice
                local Header = banklabel
                local HeaderText = "Bank"
                if Config.ShowImages then
                    Header = "<img src='nui://"..Config.ImageLink.Menu..bank..".png' width='100px' style='margin-right: 5px'>"
                    HeaderText = banklabel
                end
                local columns = {
                    {
                        header = Header,
                        text = HeaderText,
                        isMenuHeader = true,
                    },
                    {
                        header = "Access Vault",
                        params = {
                            event = 'sayer-stashbox:VaultMenu',
                            args = {
                                bank = bank,
                                upgrade = result.Upgrade,
                            },
                        },
                    },
                }
                if Config.VaultUpgrades[bank][result.Upgrade+1] ~= nil then
                    local item = {
                        header = "Upgrade Membership",
                        params = {
                            event = 'sayer-stashbox:UpgradeVault',
                            args = {
                                bank = bank,
                                upgrade = result.Upgrade,
                            },
                        },
                    }
                    table.insert(columns,item)
                end
                if Config.AllowVaultSharing then
                    local item = {
                        header = "Shared Vaults",
                        params = {
                            event = 'sayer-stashbox:SharedVaultMenu',
                            args = {
                                bank = bank,
                                owner = false,
                            },
                        },
                    }
                    table.insert(columns,item)
                end
                if Config.AllowPoliceSearchVaults then
                    for k,v in pairs(Config.PoliceJobs) do
                        DebugCode("PoliceSearch:k: "..tostring(k))
                        DebugCode("PoliceSearch:v: "..tostring(v))
                        if PlayerJob.name == v then
                            local item = {
                                header = "(PD) - Search Citizens Vault",
                                params = {
                                    event = 'sayer-stashbox:PD:SearchVaultMenu',
                                    args = {
                                        bank = bank,
                                    },
                                },
                            }
                            table.insert(columns,item)
                        end
                    end
                end
                exports['qb-menu']:openMenu(columns, false, true)
            else
                SendNotify("You Do Not Have a Vault With Us!")
                OpenPurchaseVaultMenu(bank)
            end
        end, bank )
    else
        SendNotify("Bank Robbery In Progress, Vaults Sealed", 'error')
    end
end

function OpenPurchaseVaultMenu(bank)
    local price = Config.Banks[bank].PurchaseVaultPrice
    local banklabel = Config.Banks[bank].Label
    local buytext = "Price: $"..tostring(price)
    local Header = banklabel
    local HeaderText = "Bank"
    if Config.ShowImages then
        Header = "<img src='nui://"..Config.ImageLink.Menu..bank..".png' width='100px' style='margin-right: 5px'>"
        HeaderText = banklabel
    end
    local columns = {
        {
            header = Header,
            text = HeaderText,
            isMenuHeader = true,
        },
        {
            header = "Purchase "..banklabel.." Vault",
            text = buytext,
            params = {
                event = 'sayer-stashbox:BuyVault',
                args = {
                    bank = bank,
                },
            },
        },
    }
    if Config.AllowVaultSharing then
        local item = {
            header = "Shared Vaults",
            params = {
                event = 'sayer-stashbox:SharedVaultMenu',
                args = {
                    bank = bank,
                    owner = false,
                },
            },
        }
        table.insert(columns,item)
    end
    if Config.AllowPoliceSearchVaults then
        for k,v in pairs(Config.PoliceJobs) do
            DebugCode("PoliceSearch:k: "..tostring(k))
            DebugCode("PoliceSearch:v: "..tostring(v))
            if PlayerJob.name == v then
                local item = {
                    header = "(PD) - Search Citizens Vault",
                    params = {
                        event = 'sayer-stashbox:PD:SearchVaultMenu',
                        args = {
                            bank = bank,
                        },
                    },
                }
                table.insert(columns,item)
            end
        end
    end
    exports['qb-menu']:openMenu(columns, false, true)
end

RegisterNetEvent('sayer-stashbox:BuyVault',function(data)
    local bank = data.bank
    local price = Config.Banks[bank].PurchaseVaultPrice
    local playermoney = GetPlayerMoney('bank')
    if tonumber(playermoney) >= tonumber(price) then
        DebugCode("Can Buy Vault")
        TriggerServerEvent('sayer-stashbox:PurchaseVault',bank,price)
    else
        SendNotify("Not Enough Money In Bank", 'error')
    end
end)

-- USING VAULT

RegisterNetEvent('sayer-stashbox:VaultMenu', function(data)
    local bank = data.bank
    local upgrade = data.upgrade
    local banklabel = Config.Banks[bank].Label
    local memberlabel = Config.VaultUpgrades[bank][upgrade].Label
    local Header = banklabel
    local HeaderText = "Bank"
    if Config.ShowImages then
        Header = "<img src='nui://"..Config.ImageLink.Menu..bank..".png' width='100px' style='margin-right: 5px'>"
        HeaderText = banklabel
    end
    local columns = {
        {
            header = Header,
            text = HeaderText.."</br>"..memberlabel,
            isMenuHeader = true,
        },
    }
    for k,v in ipairs(Config.VaultUpgrades[bank][upgrade].Stashes) do
        local item = {}
        local header = "Vault "..tostring(k)
        if v.Label then
            header = v.Label
        end
        item.header = header
        item.params = {
            event = 'sayer-stashbox:OpenVault',
            args = {
                bank = bank,
                vault = k,
                weight = v.Weight,
                slots = v.Slots,
            }
        }
        table.insert(columns, item)
    end
    exports['qb-menu']:openMenu(columns, false, true)
end)

RegisterNetEvent('sayer-stashbox:OpenVault', function(data)
    local bank = data.bank
    local vault = data.vault
    local weight = data.weight
    local slots = data.slots
    local citizenid = QBCore.Functions.GetPlayerData().citizenid
    local invID = bank.."_"..citizenid.."_"..vault
    local arguments = {
        label = bank.."_"..citizenid.."_"..vault,
        maxweight = weight,
        slots = slots,
    }
    TriggerServerEvent('sayer-stashbox:OpenInventory', invID, arguments)
end)

--SHARED VAULT

RegisterNetEvent('sayer-stashbox:SharedVaultMenu', function(data)
    local bank = data.bank
    local owner = data.owner
    local banklabel = Config.Banks[bank].Label
    local Header = banklabel
    local HeaderText = "Bank"
    local SharedPrice = Config.Banks[bank].GiveKeyPrice
    if Config.ShowImages then
        Header = "<img src='nui://"..Config.ImageLink.Menu..bank..".png' width='100px' style='margin-right: 5px'>"
        HeaderText = banklabel
    end
    local columns = {
        {
            header = Header,
            text = HeaderText,
            isMenuHeader = true,
        },
        {
            header = "Give Vault Access",
            text = "Price For Key Access: $"..tostring(SharedPrice),
            params = {
                event = 'sayer-stashbox:GiveVaultAccess',
                args = {
                    bank = bank,
                },
            },
        },
        {
            header = "See Shared Vaults",
            params = {
                event = 'sayer-stashbox:GetSharedVaults',
                args = {
                    bank = bank,
                },
            },
        },
    }
    exports['qb-menu']:openMenu(columns, false, true)
end)

RegisterNetEvent('sayer-stashbox:GiveVaultAccess', function(data)
    local bank = data.bank
    local banklabel = Config.Banks[bank].Label
    local delmenu = nil
    local columns = {}
    QBCore.Functions.TriggerCallback('sayer-stashbox:GetPlayers', function(players)
        if players then
            for _,v in pairs(players) do
                local option = {}
                option.value = v.id
                option.text = v.text
                table.insert(columns, option)
            end
            delmenu = exports['qb-input']:ShowInput({
                header = "> Grant "..banklabel.." Vault Access <",
                submitText = "Grant Access!",
                inputs = {
                    {
                        text = "Players",    
                        name = "player",    
                        type = "select",    
                        isRequired = true,
                        options = columns,
                    },
                }
            })
            if delmenu ~= nil then
                if delmenu.player == nil then return end
                TriggerServerEvent('sayer-stashbox:GrantVaultAccess',bank, delmenu.player)
            end
        else
            DebugCode("No Players Found For GiveVaultAccess")
        end
    end)
end) 

RegisterNetEvent('sayer-stashbox:GetSharedVaults', function(data)
    local bank = data.bank
    local banklabel = Config.Banks[bank].Label
    local Header = banklabel
    local HeaderText = "Bank"
    if Config.ShowImages then
        Header = "<img src='nui://"..Config.ImageLink.Menu..bank..".png' width='100px' style='margin-right: 5px'>"
        HeaderText = banklabel
    end
    local columns = {
        {
            header = Header,
            text = HeaderText,
            isMenuHeader = true,
        },
    }
    QBCore.Functions.TriggerCallback('sayer-stashbox:GetSharedVaults', function(result)
        if result ~= nil then
            for k,v in pairs(result) do
                local item = {}
                local header = v.text
                item.header = header
                item.params = {
                    event = 'sayer-stashbox:OpenSharedVault',
                    args = {
                        bank = bank,
                        owner = k,
                        upgrade = v.upgrade,
                        text = v.text,
                    }
                }
                table.insert(columns, item)
            end
            exports['qb-menu']:openMenu(columns, false, true)
        else
            SendNotify("You Dont Hold Any Keys", 'error')
        end
    end, bank )
end)

RegisterNetEvent('sayer-stashbox:OpenSharedVault', function(data)
    local bank = data.bank
    local upgrade = data.upgrade
    local banklabel = Config.Banks[bank].Label
    local owner = data.owner
    local playertext = data.text
    local Header = banklabel
    local HeaderText = "Bank"
    if Config.ShowImages then
        Header = "<img src='nui://"..Config.ImageLink.Menu..bank..".png' width='100px' style='margin-right: 5px'>"
        HeaderText = banklabel
    end
    local columns = {
        {
            header = Header,
            text = HeaderText,
            isMenuHeader = true,
        },
    }
    for k,v in ipairs(Config.VaultUpgrades[bank][upgrade].Stashes) do
        local item = {}
        local header = "Vault "..tostring(k)
        if v.Label then
            header = v.Label
        end
        item.header = header
        item.params = {
            event = 'sayer-stashbox:OpenSharedVaultDrawer',
            args = {
                owner = owner,
                bank = bank,
                vault = k,
                weight = v.Weight,
                slots = v.Slots,
            }
        }
        table.insert(columns, item)
    end
    exports['qb-menu']:openMenu(columns, false, true)
end)

RegisterNetEvent('sayer-stashbox:OpenSharedVaultDrawer', function(data)
    local owner = data.owner
    local bank = data.bank
    local vault = data.vault
    local weight = data.weight
    local slots = data.slots
    local invID = bank.."_"..owner.."_"..vault
    local arguments = {
        label = bank.."_"..owner.."_"..vault,
        maxweight = weight,
        slots = slots,
    }
    TriggerServerEvent('sayer-stashbox:OpenInventory', invID, arguments)
end)

RegisterNetEvent('sayer-stashbox:PD:SearchVaultMenu', function(data)
    if Config.PoliceRequireItem and not QBCore.Functions.HasItem(Config.PoliceRequireItem) then SendNotify("You Need a "..QBCore.Shared.Items[Config.PoliceRequireItem].label.." To Search Vaults") return end
    local bank = data.bank
    local banklabel = Config.Banks[bank].Label
    local delmenu = nil
    local columns = {}
    delmenu = exports['qb-input']:ShowInput({
        header = "> (PD) Search "..banklabel.." Vaults <",
        submitText = "Search!",
        inputs = {
            {
                text = "Citizen ID",    
                name = "cid",    
                type = "text",    
                isRequired = true,
            },
        }
    })
    if delmenu ~= nil then
        if delmenu.cid == nil then return end
        QBCore.Functions.TriggerCallback('sayer-stashbox:PD:GetVault', function(result)
            if result then
                TriggerEvent('sayer-stashbox:PD:VaultMenu',bank, delmenu.cid, tonumber(result.Upgrade))
            end
        end, bank, delmenu.cid )
    end
end) 

RegisterNetEvent('sayer-stashbox:PD:VaultMenu', function(bank, cid, upgrade)
    local banklabel = Config.Banks[bank].Label
    local Header = banklabel
    local HeaderText = "Bank"
    if Config.ShowImages then
        Header = "<img src='nui://"..Config.ImageLink.Menu..bank..".png' width='100px' style='margin-right: 5px'>"
        HeaderText = banklabel
    end
    local columns = {
        {
            header = Header,
            text = HeaderText,
            isMenuHeader = true,
        },
    }
    for k,v in ipairs(Config.VaultUpgrades[bank][upgrade].Stashes) do
        local item = {}
        local header = "Vault "..tostring(k)
        if v.Label then
            header = v.Label
        end
        item.header = header
        item.params = {
            event = 'sayer-stashbox:OpenSharedVaultDrawer',
            args = {
                owner = cid,
                bank = bank,
                vault = k,
                weight = v.Weight,
                slots = v.Slots,
            }
        }
        table.insert(columns, item)
    end
    exports['qb-menu']:openMenu(columns, false, true)
end)
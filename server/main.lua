local QBCore = exports['qb-core']:GetCoreObject()

function DebugCode(msg)
    if Config.DebugCode then
        print(msg)
    end
end

function SendNotify(src, msg, type, time, title)
    if not title then title = "Chop Shop" end
    if not time then time = 5000 end
    if not type then type = 'success' end
    if not msg then DebugCode("SendNotify Server Triggered With No Message") return end
    if Config.NotifyScript == 'qb' then
        TriggerClientEvent('QBCore:Notify', src, msg, type, time)
    elseif Config.NotifyScript == 'okok' then
        TriggerClientEvent('okokNotify:Alert', src, title, msg, time, type, false)
    elseif Config.NotifyScript == 'qs' then
        TriggerClientEvent('qs-notify:Alert', src, msg, time, type)
    elseif Config.NotifyScript == 'other' then
        --add your notify event here
    end
end

QBCore.Functions.CreateCallback('sayer-stashbox:GetPlayers', function(source, cb)
	local PlayerList = nil
    local MyPlayer = QBCore.Functions.GetPlayer(source)
    local myCID = MyPlayer.PlayerData.citizenid
	for k, v in pairs(QBCore.Functions.GetPlayers()) do
		local Player = QBCore.Functions.GetPlayer(v)
        local cid = Player.PlayerData.citizenid
        if cid ~= myCID then
            local item = {}
            item.id = tonumber(v)
            DebugCode("ID = "..item.id)
            item.text = "ID:"..v.." >< "..Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname
            DebugCode("Text = "..item.text)
            if PlayerList == nil then PlayerList = {} end
            table.insert(PlayerList, item)
        end
	end
	cb(PlayerList)
end)

RegisterNetEvent('sayer-stashbox:OpenInventory',function(id,args)
    local inventoryName = id
    local data = args
    exports['qb-inventory']:OpenInventory(source, inventoryName, data)
end)

RegisterNetEvent('sayer-stashbox:PurchaseVault', function(bank,price)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local citizenid = Player.PlayerData.citizenid

    if Player.Functions.RemoveMoney('bank',price) then
        MySQL.rawExecute('SELECT * FROM sayer_vaults WHERE citizenid = ?', { citizenid }, function(result)
            if result[1] then
                local Vaults = json.decode(result[1].vaults)
                if not Vaults[bank].Purchased then
                    Vaults[bank].Purchased = true
                    Vaults[bank].Upgrade = 1
                    local Table = json.encode(Vaults)
                    MySQL.update('UPDATE sayer_vaults SET vaults = ? WHERE citizenid = ?', { Table, citizenid })
                else
                    SendNotify(src,"You Already Bought This Vault", 'error')
                end
            else
                local Vaults = {}
                for k,v in pairs(Config.Banks) do
                    Vaults[k] = {
                        Purchased = false,
                        KeyHolders = {},
                        Upgrade = 0,
                    }
                end
                Vaults[bank].Purchased = true
                Vaults[bank].Upgrade = 1
                local Table = json.encode(Vaults)
                MySQL.insert('INSERT INTO sayer_vaults (citizenid, vaults) VALUES (?, ?)', {
                    citizenid,
                    Table,
                })  
            end
        end)
    else
        SendNotify(src,"Not Enough Money", 'error')
    end
end)

RegisterNetEvent('sayer-stashbox:UpgradeVault', function(data)
    local bank = data.bank
    local upgrade = data.upgrade
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local citizenid = Player.PlayerData.citizenid
    local upgradeprice = Config.VaultUpgrades[bank][upgrade].UpgradePrice
    local maxupgrades = #Config.VaultUpgrades[bank]
    if maxupgrades == upgrade then
        SendNotify(src,"Cannot Upgrade Membership Further", 'error')
        return
    end

    MySQL.rawExecute('SELECT * FROM sayer_vaults WHERE citizenid = ?', { citizenid }, function(result)
        if result[1] then
            local Vaults = json.decode(result[1].vaults)
            if Vaults[bank].Purchased then
                if Player.Functions.RemoveMoney('bank',upgradeprice) then
                    Vaults[bank].Upgrade = Vaults[bank].Upgrade + 1
                    local Table = json.encode(Vaults)
                    MySQL.update('UPDATE sayer_vaults SET vaults = ? WHERE citizenid = ?', { Table, citizenid })
                else
                    SendNotify(src,"Not Enough Money", 'error')
                end
            else
                SendNotify(src,"You Dont Have a Vault Here", 'error')
            end
        else
            SendNotify(src, "Vault Not Found", 'error')
        end
    end)
end)

RegisterNetEvent('sayer-stashbox:GrantVaultAccess', function(bank,player)
    local src = source
    local Owner = QBCore.Functions.GetPlayer(src)
    local Player = QBCore.Functions.GetPlayer(tonumber(player))
    if not Owner then return end
    local ownercitizenid = Owner.PlayerData.citizenid
    local playercitizenid = Player.PlayerData.citizenid
    local shareprice = Config.Banks[bank].GiveKeyPrice

    MySQL.rawExecute('SELECT * FROM sayer_vaults WHERE citizenid = ?', { ownercitizenid }, function(result)
        if result[1] then
            local Vaults = json.decode(result[1].vaults)
            if Vaults[bank].Purchased then
                if #Vaults[bank].KeyHolders == Config.MaxKeyholders then
                    SendNotify(src,"Max Number Of KeyHolders Reached", 'error')
                    return
                end
                if Vaults[bank].KeyHolders[playercitizenid] == nil then
                    if Owner.Functions.RemoveMoney('bank',shareprice) then
                        Vaults[bank].KeyHolders[playercitizenid] = true
                    else
                        SendNotify(src,"Not Enough Money In Bank", 'error')
                    end
                else
                    SendNotify(src, "This Person Is Already a Keyholder", 'error')
                    return
                end
                local Table = json.encode(Vaults)
                MySQL.update('UPDATE sayer_vaults SET vaults = ? WHERE citizenid = ?', { Table, ownercitizenid })
            else
                SendNotify(src,"You Dont Have a Vault Here", 'error')
            end
        else
            SendNotify(src, "Vault Not Found", 'error')
        end
    end)
end)


QBCore.Functions.CreateCallback('sayer-stashbox:GetSharedVaults', function(source, cb, bank)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local citizenid = Player.PlayerData.citizenid
    local ValidVaults = {}
    local Vaults = {}

    MySQL.rawExecute('SELECT * FROM sayer_vaults ', { }, function(result)
        if result then
            for k,v in pairs(result) do
                Vaults = json.decode(v.vaults)
                if Vaults[bank] ~= nil then
                    if Vaults[bank].KeyHolders ~= nil then
                        if Vaults[bank].KeyHolders[citizenid] ~= nil then
                            local owner = QBCore.Functions.GetPlayerByCitizenId(v.citizenid)
                            ValidVaults[v.citizenid] = {
                                text = "Open "..owner.PlayerData.charinfo.firstname..' '..owner.PlayerData.charinfo.lastname.." Vault",
                                upgrade = Vaults[bank].Upgrade,
                            }
                        else
                            DebugCode("v.vaults[bank].KeyHolders[citizenid] returned nil")
                        end
                    else
                        DebugCode("v.vaults[bank].KeyHolders returned nil")
                    end
                else
                    DebugCode("v.vaults[bank] returned nil")
                end
            end
            for k,v in pairs(ValidVaults) do
                DebugCode("ValidVaults:k: "..tostring(k))
                DebugCode("ValidVaults:v.text: "..tostring(v.text))
                DebugCode("ValidVaults:v.upgrade: "..tostring(v.upgrade))
            end
            cb(ValidVaults)
        else
            SendNotify(src, "Vault Not Found", 'error')
        end
    end)
end)

QBCore.Functions.CreateCallback('sayer-stashbox:GetBankDetails', function(source, cb, bank)
    local Player = QBCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid
    if not Config.Banks[bank] then return end

    MySQL.rawExecute('SELECT * FROM sayer_vaults WHERE citizenid = ?', { citizenid }, function(result)
        if result[1] then
            DebugCode("citizenid: "..tostring(result[1].citizenid))
            DebugCode("id: "..tostring(result[1].id))
            local Vaults = json.decode(result[1].vaults)
            for d,j in pairs(Vaults) do
                DebugCode("Vaults:d: "..tostring(d))
                DebugCode("Vaults:j.Purchased: "..tostring(j.Purchased))
                DebugCode("Vaults:j.Upgrade: "..tostring(j.Upgrade))
            end
            if Vaults[bank] == nil then
                Vaults[bank] = {
                    Purchased = false,
                    KeyHolders = {},
                    Upgrade = 0,
                }
                local Table = json.encode(Vaults)
                MySQL.update('UPDATE sayer_vaults SET vaults = ? WHERE citizenid = ?', { Table, citizenid })
            end
            if Vaults[bank].Purchased then
                cb(Vaults[bank])
            else
                cb(nil)
            end
        else
           cb(nil)
        end
    end)
end)

QBCore.Functions.CreateCallback('sayer-stashbox:PD:GetVault', function(source, cb, bank, cid)
    local Player = QBCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid
    if not Config.Banks[bank] then return end

    MySQL.rawExecute('SELECT * FROM sayer_vaults WHERE citizenid = ?', { cid }, function(result)
        if result[1] then
            local Vaults = json.decode(result[1].vaults)
            for d,j in pairs(Vaults) do
                DebugCode("Vaults:d: "..tostring(d))
                DebugCode("Vaults:j.Purchased: "..tostring(j.Purchased))
                DebugCode("Vaults:j.Upgrade: "..tostring(j.Upgrade))
            end
            if Vaults[bank] ~= nil then
                if Vaults[bank].Purchased then
                    cb(Vaults[bank])
                else
                    cb(nil)
                end
            else
                cb(nil)
            end
        else
           cb(nil)
        end
    end)
end)


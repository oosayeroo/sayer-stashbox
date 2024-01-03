Config = {}

Config.UseTarget = true
Config.DebugCode = false
Config.DebugStashZones = false  --true for testing, making zones, false for live server
Config.NotifyScript = 'qb'
Config.ImageLink = {
    Menu = 'sayer-stashbox/images/menus/', --do not change unless you know what youre doing (IMAGE MUST BE NAMED SAME AS THE JOBCODE/GANGCODE FOR EXAMPLE 'police.png')
}
Config.ShowImages = true --enables logos in the menu

Config.EnableBankVaults = true --activate or deactivate the bank vaults (deactivating will not alter the stashes/upgrades etc, will only block access)
Config.PacificHeistScript = 'qb-bankrobbery' -- 'qb-bankrobbery'/ 'rainmad' / 'lionh34rt' supported right now (README)
Config.AllowPoliceSearchVaults = true
Config.PoliceRequireItem = false --can make it so police need an item to search vaults such as "Config.PoliceRequireItem = 'warrant' "
Config.PoliceJobs = {'police', 'sheriff'} --used for searching someones vault
Config.AllowVaultSharing = true --lets players give keys to friends so they can access vaults
Config.MaxKeyholders = 3 --amount of players that can have access to another players vault (for shared vaults)



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
--these are random placements i took from qb-management. please set to your own coords

Config.Stashes = {
    ['police'] = { --the job or gang code that will be used
        Enable = true, --enable/disable the full location
        Type = 'job', --whether it is a job or gang
        Coords = vector3(443.79, -976.27, 30.69), --location to access stash
        Distance = 5.0, --the distance you can interact with stash
        ItemLocked = false, --either false or the itemcode you want to use to access it. for example (ItemLocked = 'police_key')
        BoxZone = {length = 1.0, width = 1.0, heading = 351.0}, --if using target it will use these boxzone settings to create the target
        Prop = {
            Enable = true, --false = no prop/ true = prop
            Model = 'prop_cabinet_02b', --the model of the prop
            Heading = 0.0, --which direction the prop is facing
        },
        Stashes = { --have as many stashes as you want in here. the menu will auto insert in the order they are placed here
            [1] = {
                ID = 'evidence_stash', --id of the stash. DO NOT CHANGE ONCE USED OR WILL LOSE ITEMS. id will be for example 'police_evidence_stash' (MUST BE UNIQUE IN JOB)
                GradeRequired = 1, --job grade. anybody with this grade or higher can see this stash
                Label = "Evidence", --shown in menu
                Weight = 100000, -- the weight the stash will hold
                Slots = 100 --the slots the stash will have
            },
            [2] = {ID = 'evidence2_stash',     GradeRequired = 1,   Label = "Evidence 2",Weight = 100000, Slots = 100},
            [3] = {ID = 'armory_stash',        GradeRequired = 4,   Label = "Armory",Weight = 100000, Slots = 100},
            [4] = {ID = 'dna_stash',           GradeRequired = 1,   Label = "Dna",Weight = 100000, Slots = 100},
        },
    },
    ['ambulance'] = {
        Enable = true,
        Type = 'job',
        Coords = vector3(309.88, -603.0, 43.29),
        Distance = 5.0,
        ItemLocked = false,
        BoxZone = {length = 1.2, width = 0.6, heading = 341.0},
        Prop = {
            Enable = true, 
            Model = 'prop_cabinet_02b', 
            Heading = 0.0, 
        },
        Stashes = {
            [1] = {ID = 'hospital_stash',        GradeRequired = 1, Label = "Hospital Stash1",Weight = 100000, Slots = 100},
            [2] = {ID = 'hospital2_stash',       GradeRequired = 1, Label = "Hospital Stash2",Weight = 100000, Slots = 100},
            [3] = {ID = 'hospital3_stash',       GradeRequired = 1, Label = "Hospital Stash3",Weight = 100000, Slots = 100},
            [4] = {ID = 'hospital4_stash',       GradeRequired = 1, Label = "Hospital Stash4",Weight = 100000, Slots = 100},
            [5] = {ID = 'hospital_manager_stash',GradeRequired = 1, Label = "Manager Stash",Weight = 100000, Slots = 100},
        },
    },
    ['realestate'] = {
        Enable = true,
        Type = 'job',
        Coords = vector3(-716.11, 261.21, 84.14), 
        Distance = 5.0,
        ItemLocked = false,
        BoxZone = {length = 0.6, width = 1.0, heading = 25.0}, 
        Prop = {
            Enable = true, 
            Model = 'prop_cabinet_02b', 
            Heading = 0.0, 
        },
        Stashes = {
            [1] = {ID = 'house_deeds',        GradeRequired = 1,    Label = "House Deeds",Weight = 100000, Slots = 100},
            [2] = {ID = 'employee_files',     GradeRequired = 1,    Label = "Employee Files",Weight = 100000, Slots = 100},
            [3] = {ID = 'manager_files',      GradeRequired = 1,    Label = "Manager Files",Weight = 100000, Slots = 100},
        },
    },
    ['taxi'] = {
        Enable = true,
        Type = 'job',
        Coords = vector3(907.24, -150.19, 74.17),
        Distance = 5.0,
        ItemLocked = false,
        BoxZone = {length = 1.0, width = 3.4, heading = 327.0},
        Prop = {
            Enable = true, 
            Model = 'prop_cabinet_02b', 
            Heading = 0.0, 
        },
        Stashes = {
            [1] = {ID = 'files',              GradeRequired = 1,    Label = "Files",Weight = 100000, Slots = 100},
            [2] = {ID = 'employee_files',     GradeRequired = 1,    Label = "Employee Files",Weight = 100000, Slots = 100},
            [3] = {ID = 'manager_files',      GradeRequired = 1,    Label = "Manager Files",Weight = 100000, Slots = 100},
        },
    },
    ['cardealer'] = {
        Enable = true,
        Type = 'job',
        Coords = vector3(-27.47, -1107.13, 27.27),
        Distance = 5.0,
        ItemLocked = false,
        BoxZone = {length = 2.4, width = 1.05, heading = 340.0},
        Prop = {
            Enable = true, 
            Model = 'prop_cabinet_02b', 
            Heading = 0.0, 
        },
        Stashes = {
            [1] = {ID = 'vehicle_deeds',      GradeRequired = 1,    Label = "Vehicle Deeds",Weight = 100000, Slots = 100},
            [2] = {ID = 'spare_keys',         GradeRequired = 1,    Label = "Spare Keys",Weight = 100000, Slots = 100},
            [3] = {ID = 'manager_files',      GradeRequired = 1,    Label = "Manager Files",Weight = 100000, Slots = 100},
        },
    },
    ['mechanic'] = {
        Enable = true,
        Type = 'job',
        Coords = vector3(-339.53, -156.44, 44.59),
        Distance = 5.0,
        ItemLocked = false,
        BoxZone = {length = 1.15, width = 2.6, heading = 353.0},
        Prop = {
            Enable = false, 
            Model = 'prop_cabinet_02b', 
            Heading = 0.0, 
        },
        Stashes = {
            [1] = {ID = 'spare_parts',        GradeRequired = 1,    Label = "Spare Parts",Weight = 100000, Slots = 100},
            [2] = {ID = 'engine_parts',       GradeRequired = 1,    Label = "Engine Parts",Weight = 100000, Slots = 100},
            [3] = {ID = 'manager_files',      GradeRequired = 1,    Label = "Manager Files",Weight = 100000, Slots = 100},
        },
    },
    -- GANGS ARE BELOW HERE. not setup
    ['lostmc'] = {
        Enable = false,
        Type = 'gang',
        Coords = vector3(0, 0, 0),
        Distance = 5.0,
        ItemLocked = false,
        BoxZone = {length = 0.0, width = 0.0, heading = 0.0},
        Prop = {
            Enable = false, 
            Model = 'prop_cabinet_02b', 
            Heading = 0.0, 
        },
        Stashes = {
            [1] = {ID = 'gang1',GradeRequired = 1,Label = "Gang Stash",Weight = 100000, Slots = 100},
            [2] = {ID = 'gang2',GradeRequired = 1,Label = "Gang Stash",Weight = 100000, Slots = 100},
            [3] = {ID = 'gang3',GradeRequired = 1,Label = "Gang Stash",Weight = 100000, Slots = 100},
        },
    },
    ['ballas'] = {
        Enable = false,
        Type = 'gang',
        Coords = vector3(0, 0, 0),
        Distance = 5.0,
        ItemLocked = false,
        BoxZone = {length = 0.0, width = 0.0, heading = 0.0},
        Prop = {
            Enable = false, 
            Model = 'prop_cabinet_02b', 
            Heading = 0.0, 
        },
        Stashes = {
            [1] = {ID = 'gang1',GradeRequired = 1,Label = "Gang Stash",Weight = 100000, Slots = 100},
            [2] = {ID = 'gang2',GradeRequired = 1,Label = "Gang Stash",Weight = 100000, Slots = 100},
            [3] = {ID = 'gang3',GradeRequired = 1,Label = "Gang Stash",Weight = 100000, Slots = 100},
        },
    },
    ['vagos'] = {
        Enable = false,
        Type = 'gang',
        Coords = vector3(0, 0, 0),
        Distance = 5.0,
        ItemLocked = false,
        BoxZone = {length = 0.0, width = 0.0, heading = 0.0},
        Prop = {
            Enable = false, 
            Model = 'prop_cabinet_02b', 
            Heading = 0.0, 
        },
        Stashes = {
            [1] = {ID = 'gang1',GradeRequired = 1,Label = "Gang Stash",Weight = 100000, Slots = 100},
            [2] = {ID = 'gang2',GradeRequired = 1,Label = "Gang Stash",Weight = 100000, Slots = 100},
            [3] = {ID = 'gang3',GradeRequired = 1,Label = "Gang Stash",Weight = 100000, Slots = 100},
        },
    },
    ['families'] = {
        Enable = false,
        Type = 'gang',
        Coords = vector3(0, 0, 0),
        Distance = 5.0,
        ItemLocked = false,
        BoxZone = {length = 0.0, width = 0.0, heading = 0.0},
        Prop = {
            Enable = false, 
            Model = 'prop_cabinet_02b', 
            Heading = 0.0, 
        },
        Stashes = {
            [1] = {ID = 'gang1',GradeRequired = 1,Label = "Gang Stash",Weight = 100000, Slots = 100},
            [2] = {ID = 'gang2',GradeRequired = 1,Label = "Gang Stash",Weight = 100000, Slots = 100},
            [3] = {ID = 'gang3',GradeRequired = 1,Label = "Gang Stash",Weight = 100000, Slots = 100},
        },
    },
    --CITIZENID STUFF BELOW HERE 
    ['MMP64540'] = { --CHANGE THIS TO A PLAYERS CITIZENID
        Enable = true,
        Type = 'citizenid', --new type to handle personal stashes
        Coords = vector3(425.89, -975.64, 30.71),
        Distance = 5.0,
        ItemLocked = false,
        BoxZone = {length = 2.0, width = 2.0, heading = 0.0},
        Prop = {
            Enable = true, 
            Model = 'prop_ld_int_safe_01', 
            Heading = 0.0, 
        },
        Stashes = {
            [1] = {ID = 'personal_1',Label = "Weapon Stash",Weight = 100000, Slots = 100},
            [2] = {ID = 'personal_2',Label = "Clothes Stash",Weight = 100000, Slots = 100},
            [3] = {ID = 'personal_3',Label = "Item Stash",Weight = 100000, Slots = 100},
        },
    },
}


-- ███████████████████████████████████████████████████████████████████████████████████████████
-- █░░░░░░██░░░░░░█░░░░░░░░░░░░░░█░░░░░░██░░░░░░█░░░░░░█████████░░░░░░░░░░░░░░█░░░░░░░░░░░░░░█
-- █░░▄▀░░██░░▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░█████████░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█
-- █░░▄▀░░██░░▄▀░░█░░▄▀░░░░░░▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░█████████░░░░░░▄▀░░░░░░█░░▄▀░░░░░░░░░░█
-- █░░▄▀░░██░░▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░█████████████░░▄▀░░█████░░▄▀░░█████████
-- █░░▄▀░░██░░▄▀░░█░░▄▀░░░░░░▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░█████████████░░▄▀░░█████░░▄▀░░░░░░░░░░█
-- █░░▄▀░░██░░▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░█████████████░░▄▀░░█████░░▄▀▄▀▄▀▄▀▄▀░░█
-- █░░▄▀░░██░░▄▀░░█░░▄▀░░░░░░▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░█████████████░░▄▀░░█████░░░░░░░░░░▄▀░░█
-- █░░▄▀▄▀░░▄▀▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░█████████████░░▄▀░░█████████████░░▄▀░░█
-- █░░░░▄▀▄▀▄▀░░░░█░░▄▀░░██░░▄▀░░█░░▄▀░░░░░░▄▀░░█░░▄▀░░░░░░░░░░█████░░▄▀░░█████░░░░░░░░░░▄▀░░█
-- ███░░░░▄▀░░░░███░░▄▀░░██░░▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█████░░▄▀░░█████░░▄▀▄▀▄▀▄▀▄▀░░█
-- █████░░░░░░█████░░░░░░██░░░░░░█░░░░░░░░░░░░░░█░░░░░░░░░░░░░░█████░░░░░░█████░░░░░░░░░░░░░░█
-- ███████████████████████████████████████████████████████████████████████████████████████████

Config.Banks = {
    ['pacific'] = {
        Enable = true,
        Label = "Pacific Bank",
        PurchaseVaultPrice = 5000,
        GiveKeyPrice = 2000,
        Locations = {
            {
                Coords = vector3(252.26, 223.31, 106.29),
                BoxZone = {length = 2.0, width = 2.0, heading = 0.0},
                Distance = 5.0,
                Prop = {Enable = false, Model = 'prop_ld_int_safe_01', Heading = 0.0, }, --use only prop or ped. do not use both in one location
                Ped = {Enable = true, Model = 'u_m_m_bankman', Heading = 160.0, },
            },
        },
    },
    ['paleto'] = {
        Enable = true,
        Label = "Paleto Bank",
        PurchaseVaultPrice = 5000,
        GiveKeyPrice = 2000,
        Locations = {
            {
                Coords = vector3(-112.09, 6471.09, 31.63),
                BoxZone = {length = 2.0, width = 2.0, heading = 0.0},
                Distance = 5.0,
                Prop = {Enable = false, Model = 'prop_ld_int_safe_01', Heading = 0.0, },
                Ped = {Enable = true, Model = 'u_m_m_bankman', Heading = 134.0, },
            },
        },
    },
    ['fleeca'] = {
        Enable = true,
        Label = "Fleeca Bank",
        PurchaseVaultPrice = 5000,
        GiveKeyPrice = 2000,
        Locations = { --this is a working example of how you can have multiple locations for the same bank vaults. (access same vaults from different locations)
            {
                Coords = vector3(148.11, -1041.69, 29.37),
                BoxZone = {length = 2.0, width = 2.0, heading = 0.0},
                Distance = 5.0,
                Prop = {Enable = false, Model = 'prop_ld_int_safe_01', Heading = 0.0, },
                Ped = {Enable = true, Model = 'u_m_m_bankman', Heading = 341.0, },
            },
            {
                Coords = vector3(312.34, -279.92, 54.16),
                BoxZone = {length = 2.0, width = 2.0, heading = 0.0},
                Distance = 5.0,
                Prop = {Enable = false, Model = 'prop_ld_int_safe_01', Heading = 0.0, },
                Ped = {Enable = true, Model = 'u_m_m_bankman', Heading = 338.0, },
            },
            {
                Coords = vector3(-352.84, -50.8, 49.04),
                BoxZone = {length = 2.0, width = 2.0, heading = 0.0},
                Distance = 5.0,
                Prop = {Enable = false, Model = 'prop_ld_int_safe_01', Heading = 0.0, },
                Ped = {Enable = true, Model = 'u_m_m_bankman', Heading = 329.0, },
            },
            {
                Coords = vector3(-1213.32, -332.73, 37.78),
                BoxZone = {length = 2.0, width = 2.0, heading = 0.0},
                Distance = 5.0,
                Prop = {Enable = false, Model = 'prop_ld_int_safe_01', Heading = 0.0, },
                Ped = {Enable = true, Model = 'u_m_m_bankman', Heading = 28.0, },
            },
            {
                Coords = vector3(-2961.14, 481.4, 15.7),
                BoxZone = {length = 2.0, width = 2.0, heading = 0.0},
                Distance = 5.0,
                Prop = {Enable = false, Model = 'prop_ld_int_safe_01', Heading = 0.0, },
                Ped = {Enable = true, Model = 'u_m_m_bankman', Heading = 88.0, },
            },
            {
                Coords = vector3(1176.44, 2708.32, 38.09),
                BoxZone = {length = 2.0, width = 2.0, heading = 0.0},
                Distance = 5.0,
                Prop = {Enable = false, Model = 'prop_ld_int_safe_01', Heading = 0.0, },
                Ped = {Enable = true, Model = 'u_m_m_bankman', Heading = 184.0, },
            },
        },
    },
}

Config.VaultUpgrades = { --to find the vault stash in your stashitems look for 'stash-bankname_citizenid_stashid' (for example "stash-pacific_MMP64540_1")
    ['pacific'] = { --this is the bank code used in Config.Banks (so you can have different values for different locations)
        [1] = { --this is the starting vault upgrade when theyve purchased access (number must be 1 for starting value)
            UpgradePrice = 10000, --this is the price to upgrade to the next level (not this level)
            Label = "Bronze Membership",
            Stashes = {
                [1] = {
                    Label = "Custom Vault Name", --if Label = false then will just display "Vault x" with x being replaced by the number value of this stash (in this case 1)
                    Weight = 10000, --weight in the vault stash
                    Slots = 10 --slots in this stash
                },
            },
        },
        [2] = {
            UpgradePrice = 15000,
            Label = "Silver Membership",
            Stashes = {
                [1] = {Label = false,Weight = 10000, Slots = 10}, --this will be the same stash as the one from last upgrade. (you can increase weight n slots but lowering may result in lost items or broken stashes)
                [2] = {Label = false,Weight = 20000, Slots = 20}, --this will be a new available stash
            },
        },
        [3] = {
            UpgradePrice = 15000,
            Label = "Gold Membership",
            Stashes = {
                [1] = {Label = false,Weight = 10000, Slots = 10}, 
                [2] = {Label = false,Weight = 20000, Slots = 20}, 
                [3] = {Label = false,Weight = 50000, Slots = 50}, 
            },
        },
    },
    ['paleto'] = {
        [1] = { 
            UpgradePrice = 10000, 
            Label = "Bronze Membership",
            Stashes = {
                [1] = {Label = false, Weight = 10000, Slots = 10},
            },
        },
        [2] = {
            UpgradePrice = 15000,
            Label = "Silver Membership",
            Stashes = {
                [1] = {Label = false,Weight = 10000, Slots = 10}, 
                [2] = {Label = false,Weight = 10000, Slots = 10},
            },
        },
        [3] = {
            UpgradePrice = 15000,
            Label = "Gold Membership",
            Stashes = {
                [1] = {Label = false,Weight = 10000, Slots = 10}, 
                [2] = {Label = false,Weight = 20000, Slots = 20}, 
                [3] = {Label = false,Weight = 50000, Slots = 50}, 
            },
        },
    },
    ['fleeca'] = {
        [1] = { 
            UpgradePrice = 2000, 
            Label = "Bronze Membership",
            Stashes = {
                [1] = {Label = false, Weight = 5000, Slots = 5},
            },
        },
        [2] = {
            UpgradePrice = 5000,
            Label = "Silver Membership",
            Stashes = {
                [1] = {Label = false,Weight = 5000, Slots = 5}, 
                [2] = {Label = false,Weight = 10000, Slots = 10},
            },
        },
        [3] = {
            UpgradePrice = 15000,
            Label = "Gold Membership",
            Stashes = {
                [1] = {Label = false,Weight = 10000, Slots = 10}, 
                [2] = {Label = false,Weight = 20000, Slots = 20}, 
                [3] = {Label = false,Weight = 50000, Slots = 50}, 
            },
        },
    }
}

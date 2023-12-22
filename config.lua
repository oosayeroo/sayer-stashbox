Config = {}

Config.UseTarget = true
Config.DebugCode = false
Config.DebugStashZones = false  --true for testing, making zones, false for live server
Config.ImageLink = 'sayer-stashbox/images/' --do not change unless you know what youre doing (IMAGE MUST BE NAMED SAME AS THE JOBCODE/GANGCODE FOR EXAMPLE 'police.png')
Config.ShowImages = true --enables job/gang logos in the menu

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
}
Config = {}

Config.Command = 'am'
Config.Keybind = 'GRAVE'
Config.NoClipCommand = 'anoclip'
Config.NoClipKeybind = 'PAGEUP'
Config.NoclipCommand = Config.NoClipCommand
Config.NoclipKeybind = Config.NoClipKeybind
Config.MenuTitle = 'SAdmin'
Config.CoordFinderCommand = 'coordfinder'
Config.Keybind = 'F10'
Config.NoclipCommand = 'noclip'
Config.NoclipKeybind = ''
Config.MenuTitle = 'Snipz Admin'
Config.RefreshInterval = 5000

Config.RemoteFeed = {
    Enabled = true,
    Resource = 'screenshot-basic',
    MaxPlayers = 8,
    RefreshInterval = 3500,
    Quality = 0.35,
    Encoding = 'jpg'
}

Config.AdminCar = {
    Command = 'admincar',
    Garage = nil -- nil mirrors ps-adminmenu admincar by saving the current vehicle as out instead of garaged.
}

Config.ChatSuggestions = {
    Enabled = true,
    -- Set true to show all configured autocomplete entries even when permission state is unavailable.
    -- Command execution still runs through the normal server-side permission checks.
    ShowWithoutPermission = false,
    RefreshCommand = 'adminsuggestions',
    ChatResources = { 'chat', 'qbx_chat_theme', 'qbx_chat' },
    Commands = {
        {
            command = Config.Command,
            help = 'Open the SRP admin menu',
            permission = 'menu',
            showWithoutPermission = true
        },
        {
            command = Config.CoordFinderCommand,
            help = 'Open the coordinate finder',
            permission = 'menu',
            showWithoutPermission = true
        },
        {
            command = Config.NoclipCommand,
            help = 'Toggle admin noclip',
            permission = 'players',
            showWithoutPermission = true
        },
        {
            command = Config.AdminCar.Command,
            help = 'Save your current vehicle as an admin vehicle',
            permission = 'vehicles',
            showWithoutPermission = true
        },
        {
            command = 'adminsuggestions',
            help = 'Refresh Snipz admin chat autocomplete',
            showWithoutPermission = true
        },
        {
            command = 'revive',
            help = 'Revive a player',
            permission = 'revive',
            params = {
                { name = 'id', help = 'Player server ID' }
            }
        },
        {
            command = 'bring',
            help = 'Bring a player to you',
            permission = 'teleport',
            params = {
                { name = 'id', help = 'Player server ID' }
            }
        },
        {
            command = 'goto',
            help = 'Teleport to a player',
            permission = 'teleport',
            params = {
                { name = 'id', help = 'Player server ID' }
            }
        },
        {
            command = 'dv',
            help = 'Delete a nearby vehicle',
            permission = 'vehicles',
            params = {
                { name = 'radius', help = 'Optional cleanup radius' }
            }
        },
        {
            command = 'fix',
            help = 'Repair your current vehicle',
            permission = 'vehicles'
        },
        {
            command = 'weather',
            help = 'Set server weather',
            permission = 'server',
            params = {
                { name = 'type', help = 'Weather type' }
            }
        },
        {
            command = 'time',
            help = 'Set server time',
            permission = 'server',
            params = {
                { name = 'hour', help = '0-23' },
                { name = 'minute', help = '0-59' }
            }
        }
    }
}

Config.Ace = {
    Root = 'snipz_adminmenu',
    DenyMessage = 'You do not have access to the admin menu.'
}

Config.PermissionBridge = {
    Enabled = true,
    UseSnipzAce = true,
    TxAdmin = {
        Enabled = true,
        GrantAll = true,
        GrantedPermissions = {
            'menu',
            'players',
            'spectate',
            'teleport',
            'revive',
            'heal',
            'punish',
            'kick',
            'ban',
            'warn',
            'freeze',
            'vehicles',
            'items',
            'inventory',
            'clothing',
            'ped',
            'accounts',
            'jobs',
            'bucket',
            'server',
            'console',
            'staff',
            'manageAdmins',
            'blips'
        }
    },
    ExternalAce = {
        Enabled = false,
        -- Disabled: this maps menu permissions onto generic `command.*` aces.
        -- Since `add_ace group.admin command allow` grants every `command.*` via
        -- inheritance, leaving this on hands full menu access to every admin and
        -- bypasses the granular snipz_adminmenu.* ACE checks. Re-enable only if you
        -- actually bridge to fxpanel/Badger and understand the command.* leak.
        Enabled = false,
        FullAccess = {
            'fxpanel.admin',
            'fxpanel.owner',
            'badger.admin',
            'badger.owner',
            'BadgerTools.Admin',
            'BadgerStaffPanel.Admin',
            'BadgerStaffPanel.Owner'
        },
        PermissionTemplates = {
            'fxpanel.%s',
            'badger.%s',
            'BadgerStaffPanel.%s'
        },
        PermissionMap = {
            menu = {
                'fxpanel.menu',
                'fxpanel.staff',
                'badger.menu',
                'badger.staff',
                'BadgerStaffPanel.Access',
                'BadgerTools.Spectate',
                'command.adminmenu',
                'command.staff',
                'command.spectate',
                'command.kick',
                'command.ban'
            },
            players = {
                'fxpanel.players',
                'badger.players',
                'BadgerStaffPanel.Players',
                'command.spectate',
                'command.goto',
                'command.bring',
                'command.heal',
                'command.kick',
                'command.ban'
            },
            spectate = { 'BadgerTools.Spectate', 'command.spectate', 'command.spec' },
            teleport = { 'BadgerTools.Teleport', 'command.goto', 'command.bring', 'command.tpm', 'command.tp' },
            revive = { 'BadgerTools.Revive', 'command.revive', 'command.heal' },
            heal = { 'BadgerTools.Heal', 'command.heal', 'command.revive' },
            punish = { 'command.warn', 'command.kick', 'command.ban', 'command.freeze', 'command.jail', 'command.unjail' },
            kick = { 'BadgerTools.Kick', 'command.kick' },
            ban = { 'BadgerTools.Ban', 'command.ban' },
            warn = { 'BadgerTools.Warn', 'command.warn' },
            freeze = { 'BadgerTools.Freeze', 'command.freeze' },
            kill = { 'command.kill' },
            vehicles = { 'BadgerTools.Vehicle', 'command.car', 'command.admincar', 'command.dv', 'command.fix', 'command.repair' },
            items = { 'command.giveitem', 'command.removeitem' },
            inventory = { 'command.inventory', 'command.clearinventory' },
            clothing = { 'command.clothing', 'command.skin' },
            ped = { 'command.ped', 'command.setped' },
            accounts = { 'command.money', 'command.givemoney', 'command.removemoney' },
            jobs = { 'command.setjob' },
            bucket = { 'command.bucket', 'command.routingbucket' },
            server = { 'command.weather', 'command.time', 'command.blackout', 'command.reviveall' },
            console = { 'command.refresh', 'command.ensure', 'command.restart', 'command.start', 'command.stop', 'console.write' },
            ['console.all'] = { 'console.write', 'command.refresh', 'command.ensure', 'command.restart', 'command.start', 'command.stop' },
            staff = { 'command.staff', 'command.duty' },
            manageAdmins = { 'fxpanel.manageadmins', 'fxpanel.manage_admins', 'txadmin.manageadmins', 'txadmin.manage_admins', 'command.add_principal', 'command.remove_principal' },
            blips = { 'command.blips', 'command.names', 'command.ids' },
            destructive = { 'command.deletechar', 'command.wipe', 'command.clearinventory' }
        }
    }
}

Config.Security = {
    ActionCooldown = 650,
    BanFile = 'bans.json',
    WarningsFile = 'warnings.json',
    NotesFile = 'notes.json',
    StaffTagsFile = 'staff_tags.json',
    LogToConsole = true,
    Webhook = ''
}

Config.StaffTags = {
    DefaultLabel = 'Staff',
    DefaultColor = '#ad1457',
    Allowed = {
        { label = 'Staff', color = '#ad1457' },
        { label = 'Trial Staff', color = '#ffc107' },
        { label = 'Developer', color = '#1976d2' },
        { label = 'Admin', color = '#ff9800' },
        { label = 'Senior Admin', color = '#f44336' },
        { label = 'Management', color = '#9c27b0' },
        { label = 'Owner', color = '#f44336' }
    }
}

Config.AdminChat = {
    Webhook = 'https://discord.com/api/webhooks/XXXXXXXXXXXXXXXXXX/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
    Username = 'SAdmin Chat',
    AvatarUrl = 'https://i.ibb.co/rfLTSy2y/SRP.png',
    MaxHistory = 50,
    Templates = {
        'Please keep chat respectful.',
        'Staff is reviewing this now.',
        'Move to support if you need more help.',
        'Reminder: follow server rules and roleplay standards.'
    }
}

Config.Discord = {
    BotToken = 'YOUR_DISCORD_BOT_TOKEN_HERE',
    AvatarSize = 128,
    AvatarCacheSeconds = 3600,
    GuildId = '1353280059557023786',
    RoleTagCacheSeconds = 300,
    RoleTagDebug = false,
    RoleTags = {
        -- Profile shows all matching roles. The side player list uses the first/highest match.
         { roleId = '1357011977511239854', label = 'Management', color = '#a000ff' },
         { roleId = '1397322412336353411', label = 'Chief of Staff', color = '#f44336' },
         { roleId = '1357012229735710910', label = 'Staff', color = '#ad1457' },
         { roleId = '1357017847846666461', label = 'Trial Staff', color = '#ff51c2' },
         { roleId = '1371657273423953951', label = 'Development Lead', color = '#dd4b23' },
         { roleId = '1371657152782930021', label = 'Development', color = '#dd4b23' }
    }
}

Config.Integrations = {
    FxPanelModeration = {
        Enabled = true,
        Resource = 'monitor',
        CheckPermissions = true
    },
    InventoryResource = 'ox_inventory',
    ClothingEvent = 'citgo_appearance:openEditor',
    ClothingFallbackEvents = {
        'illenium-appearance:client:openClothingShopMenu'
    },
    BarberEvent = 'illenium-appearance:client:openBarberShopMenu',
    TattooEvent = 'illenium-appearance:client:openTattooShop',
    FuelResource = 'lc_fuel',
    MechanicResource = 'jg-mechanic',
    MechanicCustomisationEvent = 'jg-mechanic:client:open-customisation-menu',
    MechanicCustomisationId = 'bennys',
    MechanicCustomisationLabel = 'Benny\'s',
    VehicleKeysResource = 'Renewed-Vehiclekeys',
    VehicleKeysEvent = 'vehiclekeys:client:SetOwner',
    VehicleKeyItems = {
        'vehiclekey',
        'vehiclekeys',
        'vehicle_key',
        'vehicle_keys',
        'car_key',
        'car_keys',
        'carkey',
        'carkeys',
        'keys'
    },
    HealthResetEvent = 'visn_are:resetHealthBuffer',
    ReviveEvent = 'visn_are:resetHealthBuffer',
    JailResource = 'xt-prison',
    JailExport = 'SetJailTime',
    JailEvent = 'police:server:JailPlayer',
    JailEventType = 'server',
    UnjailEvent = 'prison:client:UnjailPerson',
    UnjailEventType = 'client'
}

Config.OwnedVehicleMap = {
    Enabled = true,
    CacheSeconds = 10,
    MaxVehicles = 80,
    IncludeLastKnownCoords = true
}

Config.Console = {
    Enabled = true,
    AllowAllPermission = 'console.all',
    MaxConsoleHistory = 120,
    AllowedCommands = {
        'say',
        'status',
        'refresh',
        'ensure',
        'restart',
        'start',
        'stop',
        'weather',
        'time'
    },
    CommandSuggestions = {
        { command = 'say', label = 'Say', template = 'say ' },
        { command = 'status', label = 'Status', template = 'status' },
        { command = 'refresh', label = 'Refresh', template = 'refresh' },
        { command = 'ensure', label = 'Ensure Resource', template = 'ensure ' },
        { command = 'restart', label = 'Restart Resource', template = 'restart ' },
        { command = 'start', label = 'Start Resource', template = 'start ' },
        { command = 'stop', label = 'Stop Resource', template = 'stop ' },
        { command = 'weather', label = 'Weather', template = 'weather CLEAR' },
        { command = 'time', label = 'Time', template = 'time 12 00' }
    }
}

Config.Weather = {
    Resource = 'Renewed-Weathersync',
    CompatExportResource = 'qb-weathersync',
    Presets = {
        'EXTRASUNNY',
        'CLEAR',
        'CLOUDS',
        'OVERCAST',
        'RAIN',
        'THUNDER',
        'FOGGY',
        'SMOG',
        'CLEARING',
        'SNOW',
        'BLIZZARD',
        'XMAS',
        'SNOWLIGHT'
    },
    ExecuteWeatherCommand = nil,
    ExecuteTimeCommand = nil
}

Config.Permissions = {
    menu = 'menu',
    players = 'players',
    spectate = 'spectate',
    teleport = 'teleport',
    revive = 'revive',
    heal = 'heal',
    punish = 'punish',
    kick = 'kick',
    ban = 'ban',
    warn = 'warn',
    freeze = 'freeze',
    kill = 'kill',
    vehicles = 'vehicles',
    items = 'items',
    inventory = 'inventory',
    clothing = 'clothing',
    ped = 'ped',
    accounts = 'accounts',
    jobs = 'jobs',
    bucket = 'bucket',
    server = 'server',
    console = 'console',
    staff = 'staff',
    manageAdmins = 'manageAdmins',
    blips = 'blips',
    destructive = 'destructive'
}

Config.Items = {
    { name = 'water', label = 'Water' },
    { name = 'sandwich', label = 'Sandwich' },
    { name = 'phone', label = 'Phone' },
    { name = 'radio', label = 'Radio' },
    { name = 'lockpick', label = 'Lockpick' },
    { name = 'repairkit', label = 'Repair Kit' },
    { name = 'armor', label = 'Armor' },
    { name = 'bandage', label = 'Bandage' }
}

Config.Vehicles = {
    { model = 'adder', label = 'Adder' },
    { model = 'sultanrs', label = 'Sultan RS' },
    { model = 'elegy', label = 'Elegy RH8' },
    { model = 'police3', label = 'Police Cruiser' },
    { model = 'ambulance', label = 'Ambulance' },
    { model = 'guardian', label = 'Guardian' },
    { model = 'frogger', label = 'Frogger' },
    { model = 'dinghy', label = 'Dinghy' }
}

Config.Peds = {
    { model = 'mp_m_freemode_01', label = 'Male Freemode' },
    { model = 'mp_f_freemode_01', label = 'Female Freemode' },
    { model = 's_m_y_cop_01', label = 'Police Officer' },
    { model = 's_m_m_paramedic_01', label = 'Paramedic' },
    { model = 'a_m_m_business_01', label = 'Business Male' },
    { model = 'a_f_y_business_01', label = 'Business Female' }
}

Config.Weapons = {
    { name = 'WEAPON_PISTOL', label = 'Pistol' },
    { name = 'WEAPON_COMBATPISTOL', label = 'Combat Pistol' },
    { name = 'WEAPON_STUNGUN', label = 'Stun Gun' },
    { name = 'WEAPON_NIGHTSTICK', label = 'Nightstick' },
    { name = 'WEAPON_CARBINERIFLE', label = 'Carbine Rifle' }
}

Config.Jobs = {
    { name = 'unemployed', label = 'Unemployed', grades = { 0 } },
    { name = 'police', label = 'Police', grades = { 0, 1, 2, 3, 4 } },
    { name = 'ambulance', label = 'EMS', grades = { 0, 1, 2, 3, 4 } },
    { name = 'mechanic', label = 'Mechanic', grades = { 0, 1, 2, 3, 4 } },
    { name = 'realestate', label = 'Real Estate', grades = { 0, 1, 2, 3, 4 } }
}

Config.Gangs = {
    { name = 'none', label = 'None', grades = { 0 } },
    { name = 'ballas', label = 'Ballas', grades = { 0, 1, 2, 3, 4 } },
    { name = 'families', label = 'Families', grades = { 0, 1, 2, 3, 4 } },
    { name = 'vagos', label = 'Vagos', grades = { 0, 1, 2, 3, 4 } }
}

Config.Licenses = {
    { name = 'driver', label = 'Driver' },
    { name = 'weapon', label = 'Weapon' },
    { name = 'business', label = 'Business' }
}

Config.TeleportPresets = {
    { name = 'staff_room', label = 'Staff Room', coords = { x = -269.4, y = -955.3, z = 31.2, h = 205.0 } },
    { name = 'pillbox', label = 'Pillbox', coords = { x = 298.3, y = -584.6, z = 43.3, h = 70.0 } },
    { name = 'legion', label = 'Legion Square', coords = { x = 215.8, y = -810.1, z = 30.7, h = 160.0 } },
    { name = 'jail', label = 'Bolingbroke', coords = { x = 1845.9, y = 2585.8, z = 45.7, h = 270.0 } }
}

Config.GymStats = {
    Min = 0,
    Max = 100,
    Stats = {
        { name = 'strength', label = 'Strength' },
        { name = 'stamina', label = 'Stamina' },
        { name = 'shooting', label = 'Shooting' },
        { name = 'driving', label = 'Driving' },
        { name = 'lung_capacity', label = 'Lung Capacity' }
    }
}

Config.AllowedEvents = {
    -- Add server/client events here if you want the Events page to expose them.
    -- Example: {
    --     name = 'my_resource:server:event',
    --     label = 'My Event',
    --     description = 'Runs a configured server event.',
    --     type = 'server',
    --     payload = { reason = 'Admin event' }
    -- }
}

Config = {}

--[[
    Snipz Admin Menu configuration.

    This file ships with sensible, framework-neutral defaults so the menu works
    out of the box on a standard Qbox server. Every optional integration is
    resource-gated: if the resource you point it at is not running, the menu
    silently falls back to its built-in behaviour instead of erroring.

    Anything that is server specific (Discord IDs, webhooks, branding, paid
    resource names) is left blank or commented. Fill in what your server uses.
]]

-- Command + keybind used to open the menu. Players can rebind the key in the
-- FiveM settings > Key Bindings menu.
Config.Command = 'adminmenu'
Config.Keybind = 'F10'

-- Standalone noclip toggle. Leave the keybind blank so staff can bind it
-- themselves, or set e.g. 'PAGEUP'.
Config.NoclipCommand = 'noclip'
Config.NoclipKeybind = ''

-- Coordinate finder / development tool.
Config.CoordFinderCommand = 'coordfinder'
-- Where the coord finder laser starts from: 'body' or 'camera'.
Config.CoordFinderLaserOrigin = 'body'

-- Shown in the NUI header and used as the Discord webhook username.
Config.MenuTitle = 'Snipz Admin'
-- Optional logo URL for the NUI header. Leave blank to show the first letter
-- of Config.MenuTitle instead.
Config.MenuLogo = ''

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
    Garage = nil -- nil mirrors ps-adminmenu admincar by saving the current vehicle as "out" instead of garaged.
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
            help = 'Open the admin menu',
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
            help = 'Refresh admin chat autocomplete',
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
    SnapshotCooldown = 1000,
    ControlInputCooldown = 45,
    StrictAllowLists = true,
    AllowCustomEventPayloads = false,
    MaxPayloadDepth = 4,
    MaxPayloadKeys = 50,
    MaxTextLength = 900,
    MaxItemAmount = 1000,
    MaxWeaponAmmo = 5000,
    MaxMoneyAmount = 10000000,
    MaxBanMinutes = 5256000,
    MaxTeleportCoordinate = 12000.0,
    MinTeleportZ = -1000.0,
    MaxTeleportZ = 3000.0,
    CleanupSpawnedVehiclesOnStop = true,
    AllowedMoneyAccounts = { 'cash', 'bank', 'crypto', 'black_money' },
    BanFile = 'bans.json',
    WarningsFile = 'warnings.json',
    NotesFile = 'notes.json',
    StaffTagsFile = 'staff_tags.json',
    LogToConsole = true,
    -- Optional Discord webhook for the full admin action audit log. Leave blank to disable.
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
    -- Optional Discord webhook that mirrors the staff admin chat. Leave blank to disable.
    Webhook = '',
    Username = 'Admin Chat',
    -- Optional avatar URL for the webhook messages.
    AvatarUrl = '',
    MaxHistory = 50,
    Templates = {
        'Please keep chat respectful.',
        'Staff is reviewing this now.',
        'Move to support if you need more help.',
        'Reminder: follow server rules and roleplay standards.'
    }
}

Config.Discord = {
    -- Optional. A Discord bot token unlocks avatar thumbnails and role-based
    -- staff tags in the menu. Leave blank to disable all Discord lookups.
    BotToken = '',
    AvatarSize = 128,
    AvatarCacheSeconds = 3600,
    -- Your Discord server (guild) ID. Only required if you use RoleTags below.
    GuildId = '',
    RoleTagCacheSeconds = 300,
    RoleTagDebug = false,
    -- Map Discord role IDs to staff tags. The profile shows every matching role;
    -- the side player list uses the first/highest match. Example:
    -- RoleTags = {
    --     { roleId = '000000000000000000', label = 'Management', color = '#a000ff' },
    --     { roleId = '000000000000000000', label = 'Staff',      color = '#ad1457' },
    --     { roleId = '000000000000000000', label = 'Trial Staff', color = '#ff51c2' },
    -- }
    RoleTags = {}
}

Config.Integrations = {
    -- FxPanel / txAdmin moderation history. When enabled, warn/kick/ban/announce
    -- are routed through the `monitor` resource so they appear in txAdmin history.
    -- The acting admin must be authenticated in FxPanel with the matching
    -- players.warn / players.kick / players.ban / announcement permission.
    -- Disabled by default so the menu works without FxPanel configured.
    FxPanelModeration = {
        Enabled = false,
        Resource = 'monitor',
        CheckPermissions = true
    },

    -- Inventory resource for item lists and give/remove/clear item actions.
    -- Common: 'ox_inventory', 'qb-inventory', 'qs-inventory', 'codem-inventory', 'origen_inventory'.
    InventoryResource = 'ox_inventory',

    -- Clothing / appearance editor. The menu fires ClothingEvent if its resource
    -- is running, otherwise it walks ClothingFallbackEvents in order.
    -- Common: 'illenium-appearance', 'fivem-appearance', 'qb-clothing', 'citgo_appearance'.
    ClothingEvent = 'illenium-appearance:client:openClothingShopMenu',
    ClothingFallbackEvents = {
        'qb-clothing:client:openMenu',
        'fivem-appearance:client:openClothes',
        'citgo_appearance:openEditor'
    },
    BarberEvent = 'illenium-appearance:client:openBarberShopMenu',
    TattooEvent = 'illenium-appearance:client:openTattooShop',

    -- Fuel resource for the refuel action. The native fuel level is always set;
    -- this just keeps a fuel script in sync if one is running.
    -- Common: 'LegacyFuel', 'ox_fuel', 'ps-fuel', 'cdn-fuel', 'lc_fuel'.
    FuelResource = 'LegacyFuel',

    -- Optional mechanic resource for the "open customisation" shortcut.
    -- Leave blank to hide it. Example (jg-mechanic):
    --   MechanicResource = 'jg-mechanic',
    --   MechanicCustomisationEvent = 'jg-mechanic:client:open-customisation-menu',
    --   MechanicCustomisationId = 'bennys',
    --   MechanicCustomisationLabel = "Benny's",
    MechanicResource = '',
    MechanicCustomisationEvent = '',
    MechanicCustomisationId = '',
    MechanicCustomisationLabel = '',

    -- Vehicle keys granted after spawning / admin-car / give-keys actions.
    -- The menu tries exports[VehicleKeysResource]:addKey(plate) first, then the event.
    -- Common: 'qb-vehiclekeys', 'Renewed-Vehiclekeys', 'wasabi_carlock', 'MrNewbVehicleKeys', 'cd_garage'.
    VehicleKeysResource = 'qb-vehiclekeys',
    VehicleKeysEvent = 'qb-vehiclekeys:client:AddKeys',
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

    -- Optional event fired after the built-in revive/heal, for medical/injury
    -- systems that need their own reset. Leave blank unless you run one.
    -- Example (Solstice): 'visn_are:resetHealthBuffer'.
    HealthResetEvent = '',
    ReviveEvent = '',

    -- Jail system. The menu calls exports[JailResource][JailExport](...) if both
    -- are set, otherwise it triggers JailEvent / UnjailEvent.
    -- Common: 'qb-prison' (event 'police:server:JailPlayer'),
    --         'xt-prison'  (export 'SetJailTime'),
    --         'rcore_prison'.
    JailResource = 'qb-prison',
    JailExport = '',
    JailEvent = 'police:server:JailPlayer',
    JailEventType = 'server',
    UnjailEvent = 'police:client:UnjailPerson',
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

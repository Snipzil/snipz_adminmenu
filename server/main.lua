local RESOURCE = GetCurrentResourceName()

local bans = {}
local warnings = {}
local notes = {}
local staffTags = {}
local duty = {}
local actionLogs = {}
local chatLogs = {}
local adminChatLogs = {}
local serverConsoleLogs = {}
local lastAction = {}
local lastRemoteFeedRequest = {}
local lastSnapshotRequest = {}
local lastControlInput = {}
local controlSessions = {}
local returnCoords = {}
local chatMuted = {}
local escortSessions = {}
local txAdminAdmins = {}
local discordAvatarCache = {}
local discordRoleTagCache = {}
local currentWeather = 'CLEAR'
local currentTime = { hour = 12, minute = 0 }
local ownedVehicleMapCache = { expiresAt = 0, vehicles = {} }

local actionPermissions = {
    ['duty.toggle'] = 'staff',
    ['admin.chat'] = 'staff',
    ['announce'] = 'server',
    ['player.message'] = 'players',
    ['player.noteAdd'] = 'staff',
    ['player.noteEdit'] = 'staff',
    ['player.noteDelete'] = 'staff',
    ['player.warn'] = 'warn',
    ['player.warnEdit'] = 'warn',
    ['player.warnDelete'] = 'warn',
    ['player.kick'] = 'kick',
    ['player.ban'] = 'ban',
    ['ban.remove'] = 'ban',
    ['player.revive'] = 'revive',
    ['player.reviveRadius'] = 'revive',
    ['player.heal'] = 'heal',
    ['player.feed'] = 'heal',
    ['player.resetStatus'] = 'heal',
    ['player.setArmor'] = 'heal',
    ['player.jail'] = 'punish',
    ['player.unjail'] = 'punish',
    ['player.cuff'] = 'punish',
    ['player.uncuff'] = 'punish',
    ['player.voiceMute'] = 'punish',
    ['player.chatMute'] = 'punish',
    ['player.handsUp'] = 'punish',
    ['player.escort'] = 'punish',
    ['player.seatVehicle'] = 'punish',
    ['player.kill'] = 'kill',
    ['player.freeze'] = 'freeze',
    ['player.slap'] = 'punish',
    ['player.explode'] = 'punish',
    ['player.burn'] = 'punish',
    ['player.ragdoll'] = 'punish',
    ['player.spectate'] = 'spectate',
    ['player.spectateStop'] = 'spectate',
    ['player.control'] = 'spectate',
    ['player.controlStop'] = 'spectate',
    ['player.goto'] = 'teleport',
    ['player.bring'] = 'teleport',
    ['player.return'] = 'teleport',
    ['player.teleportPreset'] = 'teleport',
    ['player.teleportCoords'] = 'teleport',
    ['player.openInventory'] = 'inventory',
    ['player.clearInventory'] = 'inventory',
    ['player.clearVehicleKeys'] = 'inventory',
    ['player.clothing'] = 'clothing',
    ['player.barber'] = 'clothing',
    ['player.tattoo'] = 'clothing',
    ['player.resetAppearance'] = 'clothing',
    ['player.setPed'] = 'staff',
    ['player.giveWeapon'] = 'items',
    ['player.clearWeapons'] = 'items',
    ['player.setBucket'] = 'bucket',
    ['player.setJob'] = 'jobs',
    ['player.setGang'] = 'jobs',
    ['player.setDuty'] = 'jobs',
    ['player.setLicense'] = 'jobs',
    ['player.setGymStats'] = 'staff',
    ['player.deleteCharacter'] = 'destructive',
    ['item.give'] = 'items',
    ['item.remove'] = 'items',
    ['inventory.openStash'] = 'inventory',
    ['inventory.openTrunk'] = 'inventory',
    ['money.add'] = 'accounts',
    ['money.remove'] = 'accounts',
    ['money.set'] = 'accounts',
    ['vehicle.spawn'] = 'vehicles',
    ['vehicle.spawnForPlayer'] = 'vehicles',
    ['vehicle.giveOwned'] = 'vehicles',
    ['vehicle.repair'] = 'vehicles',
    ['vehicle.flip'] = 'vehicles',
    ['vehicle.delete'] = 'vehicles',
    ['vehicle.keys'] = 'vehicles',
    ['vehicle.refuel'] = 'vehicles',
    ['vehicle.clean'] = 'vehicles',
    ['vehicle.impound'] = 'vehicles',
    ['vehicle.maxMods'] = 'vehicles',
    ['vehicle.admincar'] = 'vehicles',
    ['vehicle.customize'] = 'vehicles',
    ['staff.tagSet'] = 'manageAdmins',
    ['staff.tagClear'] = 'manageAdmins',
    ['self.noclip'] = 'players',
    ['self.godmode'] = 'players',
    ['self.invisible'] = 'players',
    ['self.blips'] = 'blips',
    ['server.weather'] = 'server',
    ['server.time'] = 'server',
    ['server.blackout'] = 'server',
    ['server.reviveAll'] = 'revive',
    ['console.execute'] = 'console',
    ['event.trigger'] = 'server'
}

local protectedSelfTargetActions = {
    ['player.spectate'] = 'You cannot spectate yourself.',
    ['player.control'] = 'You cannot control yourself.',
    ['player.cuff'] = 'You cannot cuff yourself from the admin menu.',
    ['player.jail'] = 'You cannot jail yourself from the admin menu.',
    ['player.kick'] = 'You cannot kick yourself from the admin menu.',
    ['player.ban'] = 'You cannot ban yourself from the admin menu.',
    ['player.deleteCharacter'] = 'You cannot delete your own character from the admin menu.'
}

local rateLimitExemptActions = {
    ['player.spectateStop'] = true,
    ['player.controlStop'] = true
}

local function resourceStarted(resourceName)
    return type(resourceName) == 'string' and resourceName ~= '' and GetResourceState(resourceName) == 'started'
end

local function qbxStarted()
    return resourceStarted('qbx_core')
end

local function getQbxPlayer(source)
    if not qbxStarted() then return nil end

    local ok, player = pcall(function()
        return exports.qbx_core:GetPlayer(source)
    end)

    if ok then return player end
    return nil
end

local function loadJsonFile(fileName, fallback)
    local raw = LoadResourceFile(RESOURCE, fileName)
    if not raw or raw == '' then return fallback end

    local ok, decoded = pcall(json.decode, raw)
    if ok and type(decoded) == 'table' then return decoded end

    print(('[%s] Could not parse %s, starting with an empty table.'):format(RESOURCE, fileName))
    return fallback
end

local function saveJsonFile(fileName, data)
    SaveResourceFile(RESOURCE, fileName, json.encode(data), -1)
end

local function now()
    return os.time()
end

local function round(value, places)
    local mult = 10 ^ (places or 0)
    return math.floor((tonumber(value) or 0) * mult + 0.5) / mult
end

local function clamp(value, min, max)
    value = tonumber(value) or min
    if value < min then return min end
    if value > max then return max end
    return value
end

local function cleanText(value, maxLength)
    value = tostring(value or '')
    value = value:gsub('[\r\n]', ' ')
    if maxLength and #value > maxLength then
        value = value:sub(1, maxLength)
    end
    return value
end

local function normalizeImageData(value)
    if type(value) == 'table' then
        value = value.data or value.image or value.url or value.result or value[1]
    end

    if type(value) ~= 'string' or value == '' then return nil end
    return value
end

local function looksLikeImageData(value)
    if type(value) ~= 'string' or value == '' then return false end
    if value:find('^data:image/', 1) or value:find('^https?://', 1) then return true end
    if #value > 256 and value:find('^[A-Za-z0-9%+/%=]+$') then return true end
    return false
end

local function normalizeCaptureCallback(first, second)
    local secondImage = normalizeImageData(second)
    local firstImage = normalizeImageData(first)
    local imageData = secondImage or (looksLikeImageData(firstImage) and firstImage or nil)
    local errorMessage = nil

    if not secondImage and not imageData and first ~= nil then
        errorMessage = first
    elseif secondImage and first then
        errorMessage = first
    end

    if type(errorMessage) == 'table' then
        errorMessage = errorMessage.error or errorMessage.message or json.encode(errorMessage)
    end

    if errorMessage == false then errorMessage = nil end
    if errorMessage ~= nil then errorMessage = cleanText(errorMessage, 160) end

    return errorMessage, imageData
end

local function trim(value)
    return tostring(value or ''):gsub('^%s*(.-)%s*$', '%1')
end

local function normalizedPlate(value)
    return trim(value):upper()
end

local listContains

local function normalizedModel(value)
    return trim(cleanText(value, 80)):lower()
end

local function securityValue(key, fallback)
    local security = Config.Security or {}
    if security[key] == nil then return fallback end
    return security[key]
end

local function strictAllowLists()
    return securityValue('StrictAllowLists', true) ~= false
end

local function configuredEntry(list, value, fields)
    local wanted = trim(cleanText(value, 100)):lower()
    if wanted == '' or type(list) ~= 'table' then return nil end

    for _, entry in ipairs(list) do
        if type(entry) == 'string' and entry:lower() == wanted then
            return { value = entry }
        elseif type(entry) == 'table' then
            for _, field in ipairs(fields or {}) do
                if trim(cleanText(entry[field], 100)):lower() == wanted then
                    return entry
                end
            end
        end
    end

    return nil
end

local function configuredValueOrError(list, value, fields, canonicalField, label)
    local cleaned = cleanText(value, 80)
    if cleaned == '' then return nil, ('%s is required.'):format(label) end
    if not strictAllowLists() or type(list) ~= 'table' or #list == 0 then
        return cleaned
    end

    local entry = configuredEntry(list, cleaned, fields)
    if not entry then
        return nil, ('%s is not configured.'):format(label)
    end

    return cleanText(entry[canonicalField] or entry.value or cleaned, 80), nil, entry
end

local function gradeAllowed(entry, grade)
    if not strictAllowLists() or type(entry) ~= 'table' or type(entry.grades) ~= 'table' or #entry.grades == 0 then
        return true
    end

    for _, value in ipairs(entry.grades) do
        local allowedGrade = type(value) == 'table' and (value.grade or value.level or value.value) or value
        if tonumber(allowedGrade) == tonumber(grade) then
            return true
        end
    end

    return false
end

local function moneyAccountAllowed(account)
    account = cleanText(account, 40)
    local allowed = securityValue('AllowedMoneyAccounts', { 'cash', 'bank', 'crypto', 'black_money' })
    if type(allowed) ~= 'table' or #allowed == 0 then return account ~= '' end
    return listContains(allowed, account)
end

local function weatherAllowed(weather)
    if not strictAllowLists() then return true end
    local presets = (Config.Weather or {}).Presets
    if type(presets) ~= 'table' or #presets == 0 then return true end
    return listContains(presets, weather)
end

local function safePayload(value, depth)
    depth = depth or 0
    local maxDepth = tonumber(securityValue('MaxPayloadDepth', 4)) or 4
    local valueType = type(value)

    if valueType == 'string' then
        return cleanText(value, tonumber(securityValue('MaxTextLength', 900)) or 900)
    end

    if valueType == 'number' then
        if value ~= value or value == math.huge or value == -math.huge then return 0 end
        return value
    end

    if valueType == 'boolean' or value == nil then
        return value
    end

    if valueType ~= 'table' or depth >= maxDepth then
        return nil
    end

    local output = {}
    local count = 0
    local maxKeys = tonumber(securityValue('MaxPayloadKeys', 50)) or 50

    for key, child in pairs(value) do
        count = count + 1
        if count > maxKeys then break end

        local safeKey
        if type(key) == 'number' then
            safeKey = key
        elseif type(key) == 'string' then
            safeKey = cleanText(key, 80)
        end

        if safeKey ~= nil and safeKey ~= '' then
            output[safeKey] = safePayload(child, depth + 1)
        end
    end

    return output
end

local function aceObject(permission)
    if not permission or permission == '' then return Config.Ace.Root end
    if permission == Config.Ace.Root or permission:sub(1, #Config.Ace.Root + 1) == (Config.Ace.Root .. '.') then
        return permission
    end
    return ('%s.%s'):format(Config.Ace.Root, permission)
end

listContains = function(list, value)
    if type(list) ~= 'table' then return false end
    if list[value] == true then return true end

    for _, entry in ipairs(list) do
        if entry == value then return true end
    end

    return false
end

local function shouldRefreshForChatResource(resourceName)
    local config = Config.ChatSuggestions or {}
    local resources = config.ChatResources or { 'chat', 'qbx_chat_theme', 'qbx_chat' }
    return listContains(resources, resourceName)
end

local function asList(value)
    if type(value) == 'table' then return value end
    if type(value) == 'string' and value ~= '' then return { value } end
    return {}
end

local function formatBridgeAceObject(object, permission)
    if type(object) ~= 'string' or object == '' then return nil end

    local formatted = object:gsub('{permission}', tostring(permission or ''))
    if formatted:find('%%s', 1, true) then
        local ok, value = pcall(function()
            return formatted:format(permission or '')
        end)

        if ok then formatted = value end
    end

    return formatted
end

local function aceObjectsAllowed(source, permission, objects)
    for _, object in ipairs(asList(objects)) do
        local formatted = formatBridgeAceObject(object, permission)
        if formatted and IsPlayerAceAllowed(source, formatted) then
            return true
        end
    end

    return false
end

local function hasSnipzAcePermission(source, permission)
    return IsPlayerAceAllowed(source, Config.Ace.Root)
        or IsPlayerAceAllowed(source, aceObject('all'))
        or IsPlayerAceAllowed(source, aceObject(permission))
end

local function hasTxAdminPermission(source, permission)
    local bridge = Config.PermissionBridge or {}
    local txAdmin = bridge.TxAdmin or {}

    if bridge.Enabled == false or txAdmin.Enabled == false or not txAdminAdmins[source] then
        return false
    end

    if txAdmin.GrantAll ~= false then
        return true
    end

    return listContains(txAdmin.GrantedPermissions, permission) or listContains(txAdmin.GrantedPermissions, 'all')
end

local function hasExternalAcePermission(source, permission)
    local bridge = Config.PermissionBridge or {}
    local external = bridge.ExternalAce or {}

    if bridge.Enabled == false or external.Enabled == false then
        return false
    end

    if aceObjectsAllowed(source, permission, external.FullAccess) then
        return true
    end

    if aceObjectsAllowed(source, permission, external.PermissionTemplates) then
        return true
    end

    local map = external.PermissionMap or {}
    return aceObjectsAllowed(source, permission, map[permission])
end

local function hasPermission(source, permission)
    if source == 0 then return true end

    local bridge = Config.PermissionBridge or {}
    if bridge.Enabled ~= false then
        if bridge.UseSnipzAce ~= false and hasSnipzAcePermission(source, permission) then
            return true
        end

        return hasTxAdminPermission(source, permission) or hasExternalAcePermission(source, permission)
    end

    return hasSnipzAcePermission(source, permission)
end

local function fxPanelModerationConfig()
    local integrations = Config.Integrations or {}
    return integrations.FxPanelModeration or {}
end

local function fxPanelModerationEnabled()
    return fxPanelModerationConfig().Enabled == true
end

local function fxPanelModerationResource()
    local resourceName = cleanText(fxPanelModerationConfig().Resource or 'monitor', 64)
    if resourceName == '' then resourceName = 'monitor' end
    return resourceName
end

local function ensureFxPanelModerationPermission(source, permission)
    if source == 0 then
        return false, 'FxPanel moderation actions require an authenticated in-game admin.'
    end

    local resourceName = fxPanelModerationResource()
    if not resourceStarted(resourceName) then
        return false, ('FxPanel moderation resource "%s" is not started.'):format(resourceName)
    end

    local config = fxPanelModerationConfig()
    if config.CheckPermissions ~= false then
        local ok, allowedOrError = pcall(function()
            return exports[resourceName]:hasPermission(source, permission)
        end)

        if not ok then
            return false, ('FxPanel permission check failed: %s'):format(cleanText(allowedOrError, 160))
        end

        if allowedOrError ~= true then
            return false, ('FxPanel denied this action. Missing %s.'):format(permission)
        end
    end

    return true, nil, resourceName
end

local function formatFxPanelDuration(value)
    local minutes = tonumber(value)
    if not minutes or minutes <= 0 then
        local text = cleanText(value, 80)
        if text ~= '' and text ~= '0' then return text end
        return 'permanent'
    end

    minutes = math.floor(minutes)
    local units = {
        { size = 10080, label = 'week' },
        { size = 1440, label = 'day' },
        { size = 60, label = 'hour' },
        { size = 1, label = 'minute' }
    }

    for _, unit in ipairs(units) do
        if minutes % unit.size == 0 then
            local amount = minutes / unit.size
            return ('%s %s%s'):format(amount, unit.label, amount == 1 and '' or 's')
        end
    end

    return ('%s minutes'):format(minutes)
end

local function runFxPanelModerationExport(source, exportName, permission, target, reason, duration)
    if not fxPanelModerationEnabled() then return nil end

    local allowed, permissionError, resourceName = ensureFxPanelModerationPermission(source, permission)
    if not allowed then return false, permissionError end

    local ok, exportError = pcall(function()
        if exportName == 'warnPlayer' then
            exports[resourceName]:warnPlayer(source, target, reason)
        elseif exportName == 'kickPlayer' then
            exports[resourceName]:kickPlayer(source, target, reason)
        elseif exportName == 'banPlayer' then
            exports[resourceName]:banPlayer(source, target, reason, duration)
        elseif exportName == 'sendAnnouncement' then
            exports[resourceName]:sendAnnouncement(source, reason)
        else
            error(('Unknown FxPanel export %s'):format(tostring(exportName)))
        end
    end)

    if not ok then
        return false, ('FxPanel %s export failed: %s'):format(exportName, cleanText(exportError, 160))
    end

    return true
end

local function normalizedChatCommand(command)
    command = cleanText(command, 60):gsub('^/', '')
    return command
end

local function chatSuggestionParams(params)
    local output = {}
    if type(params) ~= 'table' then return output end

    for _, param in ipairs(params) do
        if type(param) == 'table' then
            local name = cleanText(param.name, 40)
            if name ~= '' then
                output[#output + 1] = {
                    name = name,
                    help = cleanText(param.help, 120)
                }
            end
        end
    end

    return output
end

local function shouldSendChatSuggestion(source, suggestion, config)
    local permission = suggestion.permission
    if not permission or permission == '' then return true end
    if hasPermission(source, permission) then return true end

    return config.ShowWithoutPermission == true or suggestion.showWithoutPermission == true
end

local function sendChatSuggestions(source)
    local config = Config.ChatSuggestions or {}
    if config.Enabled == false or source == 0 then return end

    local sent = {}
    local suggestions = {}
    for _, suggestion in ipairs(config.Commands or {}) do
        if type(suggestion) == 'table' then
            local command = normalizedChatCommand(suggestion.command)

            if command ~= '' and not sent[command] and shouldSendChatSuggestion(source, suggestion, config) then
                sent[command] = true
                suggestions[#suggestions + 1] = {
                    name = ('/%s'):format(command),
                    help = cleanText(suggestion.help, 160),
                    params = chatSuggestionParams(suggestion.params)
                }
            end
        end
    end

    if #suggestions > 0 then
        TriggerClientEvent('chat:addSuggestions', source, suggestions)
    end
end

local function refreshChatSuggestionsForAll()
    CreateThread(function()
        Wait(1000)
        for _, player in ipairs(GetPlayers()) do
            sendChatSuggestions(tonumber(player))
        end
    end)
end

local function notify(source, message, notifyType)
    message = cleanText(message, 260)
    notifyType = notifyType or 'inform'

    if source == 0 then
        print(('[%s] %s'):format(RESOURCE, message))
        return
    end

    TriggerClientEvent('snipz_adminmenu:client:toast', source, {
        message = message,
        type = notifyType
    })
end

local function sendResult(source, ok, message, resultType)
    TriggerClientEvent('snipz_adminmenu:client:actionResult', source, {
        ok = ok == true,
        message = message or (ok and 'Action completed.' or 'Action failed.'),
        type = resultType or (ok and 'success' or 'error')
    })
end

local function actorName(source)
    if source == 0 then return 'Console' end
    return GetPlayerName(source) or ('ID %s'):format(source)
end

local function pushLimited(list, entry, maxItems)
    table.insert(list, 1, entry)
    while #list > maxItems do
        table.remove(list)
    end
end

local function logConsole(level, message, source)
    local consoleConfig = Config.Console or {}
    local entry = {
        time = now(),
        level = level or 'info',
        source = source or RESOURCE,
        message = cleanText(message, 500)
    }

    pushLimited(serverConsoleLogs, entry, consoleConfig.MaxConsoleHistory or 120)
end

local function sendWebhook(entry)
    if not Config.Security.Webhook or Config.Security.Webhook == '' then return end

    PerformHttpRequest(Config.Security.Webhook, function() end, 'POST', json.encode({
        username = Config.MenuTitle,
        embeds = {
            {
                title = entry.action or 'Admin Action',
                description = entry.detail or '',
                color = 16719759,
                fields = {
                    { name = 'Actor', value = entry.actor or 'Unknown', inline = true },
                    { name = 'Target', value = entry.target or 'None', inline = true }
                },
                timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
            }
        }
    }), {
        ['Content-Type'] = 'application/json'
    })
end

local function sendAdminChatWebhook(entry)
    local chatConfig = Config.AdminChat or {}
    local webhook = chatConfig.Webhook
    if not webhook or webhook == '' then return false end

    local payload = {
        username = chatConfig.Username or Config.MenuTitle or 'Admin Chat',
        content = ('**%s**: %s'):format(entry.actor or 'Staff', entry.message or '')
    }

    if chatConfig.AvatarUrl and chatConfig.AvatarUrl ~= '' then
        payload.avatar_url = chatConfig.AvatarUrl
    end

    PerformHttpRequest(webhook, function(status)
        if status < 200 or status >= 300 then
            print(('[%s] Admin chat webhook failed with HTTP %s.'):format(RESOURCE, status))
        end
    end, 'POST', json.encode(payload), {
        ['Content-Type'] = 'application/json'
    })

    return true
end

local function logAction(source, action, target, detail)
    local entry = {
        time = now(),
        actor = actorName(source),
        actorId = source,
        action = action,
        target = target or 'None',
        detail = detail or ''
    }

    pushLimited(actionLogs, entry, 100)

    if Config.Security.LogToConsole then
        local line = ('%s -> %s (%s) %s'):format(entry.actor, action, entry.target, entry.detail)
        print(('[%s] %s'):format(RESOURCE, line))
        logConsole('audit', line, RESOURCE)
    end

    sendWebhook(entry)
end

local function getIdentifiers(source)
    local list = GetPlayerIdentifiers(source)
    local identifiers = { list = list }

    for _, identifier in ipairs(list) do
        local key = identifier:match('^([^:]+):')
        if key then identifiers[key] = identifier end
    end

    return identifiers
end

local function primaryIdentifier(source)
    local ids = getIdentifiers(source)
    return ids.license or ids.license2 or ids.fivem or ids.steam or ids.discord or ('source:%s'):format(source)
end

local function discordUserId(discordIdentifier)
    if type(discordIdentifier) ~= 'string' then return nil end
    return discordIdentifier:match('discord:(%d+)')
end

local function discordAvatarUrl(discordIdentifier)
    local discord = Config.Discord or {}
    local token = discord.BotToken
    local userId = discordUserId(discordIdentifier)
    if not userId or not token or token == '' then return nil end

    local cached = discordAvatarCache[userId]
    if cached and cached.expires and cached.expires > now() then
        return cached.url
    end

    if cached and cached.pending then
        return cached.url
    end

    discordAvatarCache[userId] = {
        url = cached and cached.url or nil,
        expires = now() + 30,
        pending = true
    }

    PerformHttpRequest(('https://discord.com/api/v10/users/%s'):format(userId), function(status, body)
        local url = nil
        status = tonumber(status) or 0
        if status >= 200 and status < 300 and body and body ~= '' then
            local ok, data = pcall(json.decode, body)
            if ok and type(data) == 'table' and data.avatar and data.avatar ~= json.null then
                local extension = tostring(data.avatar):sub(1, 2) == 'a_' and 'gif' or 'png'
                local size = tonumber(discord.AvatarSize) or 128
                url = ('https://cdn.discordapp.com/avatars/%s/%s.%s?size=%s'):format(userId, data.avatar, extension, size)
            end
        end

        discordAvatarCache[userId] = {
            url = url,
            expires = now() + (tonumber(discord.AvatarCacheSeconds) or 3600),
            pending = false
        }
    end, 'GET', '', {
        ['Authorization'] = ('Bot %s'):format(token),
        ['Content-Type'] = 'application/json'
    })

    return cached and cached.url or nil
end

local function discordRoleTagsFromRoles(roles)
    local discord = Config.Discord or {}
    local roleTags = discord.RoleTags or {}
    if type(roles) ~= 'table' or type(roleTags) ~= 'table' then return {} end

    local roleSet = {}
    for _, roleId in ipairs(roles) do
        roleSet[tostring(roleId)] = true
    end

    local matches = {}
    for _, entry in ipairs(roleTags) do
        if type(entry) == 'table' then
            local label = cleanText(entry.label or entry.name, 30)
            local ids = asList(entry.roleIds or entry.roles or entry.roleId or entry.role or entry.id)
            for _, rawRoleId in ipairs(ids) do
                local roleId = cleanText(rawRoleId, 40)
                if roleId ~= '' and label ~= '' and roleSet[roleId] then
                    matches[#matches + 1] = {
                        label = label,
                        color = cleanText(entry.color or (Config.StaffTags or {}).DefaultColor or 'red', 20),
                        source = 'discord'
                    }
                    break
                end
            end
        end
    end

    return matches
end

local function cachedDiscordRoleTags(cached)
    if type(cached) ~= 'table' then return {} end
    return cached.tags or (cached.tag and { cached.tag }) or {}
end

local function discordRoleTags(discordIdentifier)
    local discord = Config.Discord or {}
    local token = discord.BotToken
    local guildId = cleanText(discord.GuildId, 32)
    local userId = discordUserId(discordIdentifier)
    if not userId or not token or token == '' or guildId == '' or type(discord.RoleTags) ~= 'table' or #discord.RoleTags == 0 then
        return {}
    end

    local cached = discordRoleTagCache[userId]
    if cached and cached.expires and cached.expires > now() then
        return cachedDiscordRoleTags(cached)
    end

    if cached and cached.pending then
        return cachedDiscordRoleTags(cached)
    end

    local previousTags = cachedDiscordRoleTags(cached)
    discordRoleTagCache[userId] = {
        tags = previousTags,
        expires = now() + 30,
        pending = true
    }

    PerformHttpRequest(('https://discord.com/api/v10/guilds/%s/members/%s'):format(guildId, userId), function(status, body)
        local tags = {}
        local roles = {}
        local validResponse = false
        status = tonumber(status) or 0
        if status >= 200 and status < 300 and body and body ~= '' then
            local ok, data = pcall(json.decode, body)
            if ok and type(data) == 'table' and type(data.roles) == 'table' then
                roles = type(data.roles) == 'table' and data.roles or {}
                tags = discordRoleTagsFromRoles(roles)
                validResponse = true
            end
        elseif status == 404 then
            validResponse = true
        end

        if discord.RoleTagDebug == true then
            local labels = {}
            for _, tag in ipairs(tags) do
                labels[#labels + 1] = tag.label or ''
            end

            local configured = {}
            for _, entry in ipairs(discord.RoleTags or {}) do
                if type(entry) == 'table' then
                    local label = cleanText(entry.label or entry.name, 30)
                    local ids = asList(entry.roleIds or entry.roles or entry.roleId or entry.role or entry.id)
                    local hit = false
                    for _, roleId in ipairs(ids) do
                        if listContains(roles, tostring(roleId)) then
                            hit = true
                            break
                        end
                    end
                    configured[#configured + 1] = ('%s:%s'):format(label, hit and 'yes' or 'no')
                end
            end

            print(('[%s] Discord role tags for %s: status=%s roles=[%s] configured=[%s] matches=[%s]'):format(
                RESOURCE,
                userId,
                status,
                table.concat(roles, ', '),
                table.concat(configured, ', '),
                table.concat(labels, ', ')
            ))
        end

        if not validResponse then
            discordRoleTagCache[userId] = {
                tags = previousTags,
                expires = now() + 30,
                pending = false
            }
            return
        end

        discordRoleTagCache[userId] = {
            tags = tags,
            expires = now() + (tonumber(discord.RoleTagCacheSeconds) or 300),
            pending = false
        }
    end, 'GET', '', {
        ['Authorization'] = ('Bot %s'):format(token),
        ['Content-Type'] = 'application/json'
    })

    return previousTags
end

local function getPlayerData(source)
    local player = getQbxPlayer(source)
    if player and type(player.PlayerData) == 'table' then
        return player.PlayerData, player
    end

    return {}, player
end

local function getGroupInfo(group)
    if type(group) ~= 'table' then
        return { name = 'none', label = 'None', grade = 0, gradeLabel = '0', onduty = false }
    end

    local grade = group.grade
    local gradeLevel = 0
    local gradeLabel = '0'

    if type(grade) == 'table' then
        gradeLevel = tonumber(grade.level or grade.grade or grade.value) or 0
        gradeLabel = tostring(grade.name or grade.label or gradeLevel)
    else
        gradeLevel = tonumber(grade) or 0
        gradeLabel = tostring(gradeLevel)
    end

    return {
        name = group.name or 'none',
        label = group.label or group.name or 'None',
        grade = gradeLevel,
        gradeLabel = gradeLabel,
        onduty = group.onduty == true or group.onDuty == true
    }
end

local function getCharName(source, playerData)
    local charinfo = playerData.charinfo or playerData.charInfo or {}
    local firstName = charinfo.firstname or charinfo.firstName
    local lastName = charinfo.lastname or charinfo.lastName

    if firstName or lastName then
        return cleanText(('%s %s'):format(firstName or '', lastName or ''):gsub('^%s+', ''):gsub('%s+$', ''), 80)
    end

    return GetPlayerName(source) or ('ID %s'):format(source)
end

local function getCoords(source)
    local ped = GetPlayerPed(source)
    if not ped or ped == 0 or not DoesEntityExist(ped) then
        return nil
    end

    local coords = GetEntityCoords(ped)
    return {
        x = round(coords.x, 2),
        y = round(coords.y, 2),
        z = round(coords.z, 2),
        h = round(GetEntityHeading(ped), 2)
    }
end

local function getPlayerHealth(source)
    local ped = GetPlayerPed(source)
    if not ped or ped == 0 or not DoesEntityExist(ped) then
        return { health = 0, armor = 0 }
    end

    local healthOk, healthValue = pcall(GetEntityHealth, ped)
    local armorOk, armorValue = pcall(GetPedArmour, ped)

    return {
        health = clamp((healthOk and healthValue or 100) - 100, 0, 100),
        armor = clamp(armorOk and armorValue or 0, 0, 100)
    }
end

local function formatUptime()
    local seconds = math.floor(GetGameTimer() / 1000)
    local days = math.floor(seconds / 86400)
    seconds = seconds % 86400
    local hours = math.floor(seconds / 3600)
    seconds = seconds % 3600
    local minutes = math.floor(seconds / 60)

    if days > 0 then
        return ('%sd %sh %sm'):format(days, hours, minutes)
    end

    return ('%sh %sm'):format(hours, minutes)
end

local function activeWarnings(identifier)
    return warnings[identifier] or {}
end

local function activeNotes(identifier)
    return notes[identifier] or {}
end

local function configuredStaffTag(label)
    label = cleanText(label, 30)
    if label == '' then return nil end

    local tagConfig = Config.StaffTags or {}
    for _, entry in ipairs(tagConfig.Allowed or {}) do
        if type(entry) == 'table' and tostring(entry.label or ''):lower() == label:lower() then
            return {
                label = cleanText(entry.label, 30),
                color = cleanText(entry.color or tagConfig.DefaultColor or 'red', 20)
            }
        elseif type(entry) == 'string' and entry:lower() == label:lower() then
            return {
                label = cleanText(entry, 30),
                color = cleanText(tagConfig.DefaultColor or 'red', 20)
            }
        end
    end

    return {
        label = label,
        color = cleanText(tagConfig.DefaultColor or 'red', 20)
    }
end

local function manualStaffTag(identifier)
    local tagConfig = Config.StaffTags or {}
    local tag = staffTags[identifier]
    if type(tag) == 'string' and cleanText(tag, 30) ~= '' then
        return {
            label = cleanText(tag, 30),
            color = cleanText(tagConfig.DefaultColor or 'red', 20)
        }
    end

    if type(tag) == 'table' and cleanText(tag.label, 30) ~= '' then
        return {
            label = cleanText(tag.label, 30),
            color = cleanText(tag.color or tagConfig.DefaultColor or 'red', 20)
        }
    end

    return nil
end

local function publicStaffTags(identifier, source, discordIdentifier)
    local tagConfig = Config.StaffTags or {}
    local roleTags = discordRoleTags(discordIdentifier)
    if #roleTags > 0 then return roleTags end

    local manualTag = manualStaffTag(identifier)
    if manualTag then return { manualTag } end

    if duty[source] == true then
        return { {
            label = cleanText(tagConfig.DefaultLabel or 'Staff', 30),
            color = cleanText(tagConfig.DefaultColor or 'red', 20)
        } }
    end

    return {}
end

local function canManageNote(source, note)
    if source == 0 then return true end
    if type(note) ~= 'table' then return false end
    return tonumber(note.actorId) == tonumber(source) or hasPermission(source, 'all')
end

local function warningId(warning, index)
    if type(warning) ~= 'table' then return tostring(index or '') end
    return warning.id or ('legacy:%s:%s:%s'):format(warning.time or 0, index or 0, warning.reason or '')
end

local function publicBanList()
    local list = {}
    local currentTimeValue = now()

    for banId, ban in pairs(bans) do
        if not ban.expires or ban.expires == 0 or ban.expires > currentTimeValue then
            list[#list + 1] = {
                id = banId,
                name = ban.name,
                reason = ban.reason,
                admin = ban.admin,
                created = ban.created,
                expires = ban.expires
            }
        end
    end

    table.sort(list, function(a, b)
        return (a.created or 0) > (b.created or 0)
    end)

    return list
end

local function sortedOptions(list)
    table.sort(list, function(a, b)
        return tostring(a.label or a.name or a.model or '') < tostring(b.label or b.name or b.model or '')
    end)
    return list
end

local function configuredItems()
    local resourceName = Config.Integrations.InventoryResource
    if resourceStarted(resourceName) then
        local ok, items = pcall(function()
            return exports[resourceName]:Items()
        end)

        if ok and type(items) == 'table' then
            local list = {}
            for name, item in pairs(items) do
                if type(item) == 'table' then
                    list[#list + 1] = {
                        name = tostring(item.name or name),
                        label = tostring(item.label or item.name or name)
                    }
                elseif type(name) == 'string' then
                    list[#list + 1] = { name = name, label = name }
                end
            end

            if #list > 0 then return sortedOptions(list) end
        end
    end

    return Config.Items
end

local function configuredVehicles()
    if qbxStarted() then
        local ok, vehicles = pcall(function()
            return exports.qbx_core:GetVehiclesByName()
        end)

        if ok and type(vehicles) == 'table' then
            local list = {}
            for key, vehicle in pairs(vehicles) do
                if type(vehicle) == 'table' then
                    local model = cleanText(vehicle.model or vehicle.name or key, 80)
                    if model ~= '' then
                        local brand = cleanText(vehicle.brand, 60)
                        local label = cleanText(vehicle.name or vehicle.label or model, 80)
                        if brand ~= '' and label:lower():find(brand:lower(), 1, true) ~= 1 then
                            label = ('%s %s'):format(brand, label)
                        end
                        list[#list + 1] = { model = model, label = label }
                    end
                end
            end

            if #list > 0 then return sortedOptions(list) end
        end
    end

    return Config.Vehicles
end

local function configuredJobs()
    if qbxStarted() then
        local ok, jobs = pcall(function()
            return exports.qbx_core:GetJobs()
        end)

        if ok and type(jobs) == 'table' then
            local list = {}
            for name, job in pairs(jobs) do
                if type(job) == 'table' then
                    local grades = {}
                    for grade in pairs(job.grades or {}) do
                        grades[#grades + 1] = tonumber(grade) or 0
                    end
                    table.sort(grades)

                    list[#list + 1] = {
                        name = tostring(job.name or name),
                        label = tostring(job.label or job.name or name),
                        grades = #grades > 0 and grades or { 0 }
                    }
                elseif type(name) == 'string' then
                    list[#list + 1] = { name = name, label = name, grades = { 0 } }
                end
            end

            if #list > 0 then return sortedOptions(list) end
        end
    end

    return Config.Jobs
end

local function configuredGangs()
    if qbxStarted() then
        local ok, gangs = pcall(function()
            return exports.qbx_core:GetGangs()
        end)

        if ok and type(gangs) == 'table' then
            local list = {}
            for name, gang in pairs(gangs) do
                if type(gang) == 'table' then
                    local grades = {}
                    for grade in pairs(gang.grades or {}) do
                        grades[#grades + 1] = tonumber(grade) or 0
                    end
                    table.sort(grades)

                    list[#list + 1] = {
                        name = tostring(gang.name or name),
                        label = tostring(gang.label or gang.name or name),
                        grades = #grades > 0 and grades or { 0 }
                    }
                elseif type(name) == 'string' then
                    list[#list + 1] = { name = name, label = name, grades = { 0 } }
                end
            end

            if #list > 0 then return sortedOptions(list) end
        end
    end

    return Config.Gangs or {}
end

local function currentVehicleInfo(source)
    local ped = GetPlayerPed(source)
    if not ped or ped == 0 then return nil end

    local vehicle = GetVehiclePedIsIn(ped, false)
    if not vehicle or vehicle == 0 then return nil end

    return {
        netId = NetworkGetNetworkIdFromEntity(vehicle),
        model = GetEntityModel(vehicle),
        plate = trim(GetVehicleNumberPlateText(vehicle)),
        seat = -1
    }
end

local function buildPlayerList()
    local list = {}

    for _, value in ipairs(GetPlayers()) do
        local source = tonumber(value)
        local playerData = getPlayerData(source)
        local ids = getIdentifiers(source)
        local identifier = ids.license or ids.license2 or ids.fivem or ids.steam or ids.discord or ('source:%s'):format(source)
        local metadata = playerData.metadata or {}
        local money = playerData.money or {}
        local charinfo = playerData.charinfo or playerData.charInfo or {}
        local health = getPlayerHealth(source)
        local playerStaffTags = publicStaffTags(identifier, source, ids.discord)
        local vehicle = currentVehicleInfo(source)
        local gymStats = {}
        for _, stat in ipairs((Config.GymStats or {}).Stats or {}) do
            local statName = cleanText(stat.name or stat.key, 60)
            if statName ~= '' then
                gymStats[#gymStats + 1] = {
                    name = statName,
                    label = cleanText(stat.label or statName, 80),
                    value = tonumber(metadata[statName]) or 0
                }
            end
        end

        list[#list + 1] = {
            id = source,
            name = GetPlayerName(source) or ('ID %s'):format(source),
            displayName = getCharName(source, playerData),
            citizenid = playerData.citizenid or playerData.citizenId or '',
            license = ids.license or ids.license2 or '',
            discord = ids.discord or '',
            discordAvatar = discordAvatarUrl(ids.discord),
            steam = ids.steam or '',
            fivem = ids.fivem or '',
            identifiers = ids.list,
            ping = GetPlayerPing(source),
            bucket = GetPlayerRoutingBucket(source),
            coords = getCoords(source),
            vehicle = vehicle,
            health = health.health,
            armor = health.armor,
            job = getGroupInfo(playerData.job),
            gang = getGroupInfo(playerData.gang),
            money = {
                cash = tonumber(money.cash) or 0,
                bank = tonumber(money.bank) or 0,
                crypto = tonumber(money.crypto) or tonumber(money.cryptoExchange) or 0,
                black_money = tonumber(money.black_money) or tonumber(money.blackMoney) or 0
            },
            charinfo = {
                firstname = charinfo.firstname or charinfo.firstName or '',
                lastname = charinfo.lastname or charinfo.lastName or '',
                birthdate = charinfo.birthdate or charinfo.dob or '',
                phone = charinfo.phone or charinfo.phoneNumber or '',
                nationality = charinfo.nationality or ''
            },
            metadata = {
                hunger = tonumber(metadata.hunger) or 0,
                thirst = tonumber(metadata.thirst) or 0,
                stress = tonumber(metadata.stress) or 0,
                isdead = metadata.isdead == true or metadata.dead == true,
                inlaststand = metadata.inlaststand == true,
                jail = tonumber(metadata.jail) or 0,
                gym = gymStats
            },
            warnings = activeWarnings(identifier),
            notes = activeNotes(identifier),
            staffTag = playerStaffTags[1],
            staffTags = playerStaffTags,
            duty = duty[source] == true
        }
    end

    table.sort(list, function(a, b)
        return a.id < b.id
    end)

    return list
end

local function onlineCitizenNames(players)
    local names = {}
    for _, player in ipairs(players or {}) do
        if player.citizenid and player.citizenid ~= '' then
            names[player.citizenid] = player.displayName or player.name or player.citizenid
        end
    end
    return names
end

local function qbxOwnedVehicleRows(maxVehicles)
    if not resourceStarted('qbx_vehicles') then return nil end

    local ok, rows = pcall(function()
        return exports.qbx_vehicles:GetPlayerVehicles({ states = { 0 } })
    end)

    if ok and type(rows) == 'table' then
        if type(MySQL) == 'table' and type(MySQL.query) == 'table' and type(MySQL.query.await) == 'function' then
            local limit = math.max(1, math.min(tonumber(maxVehicles) or 80, 250))
            local plateOk, plateRows = pcall(function()
                return MySQL.query.await('SELECT id, plate FROM player_vehicles WHERE state = 0 LIMIT ?', { limit })
            end)

            if plateOk and type(plateRows) == 'table' then
                local platesById = {}
                for _, row in ipairs(plateRows) do
                    if row.id and row.plate then
                        platesById[tonumber(row.id)] = row.plate
                    end
                end

                for _, row in ipairs(rows) do
                    if not row.plate or row.plate == '' then
                        row.plate = platesById[tonumber(row.id)]
                    end
                end
            end
        end

        return rows
    end

    return nil
end

local function mysqlOwnedVehicleRows(maxVehicles)
    if type(MySQL) ~= 'table' or type(MySQL.query) ~= 'table' or type(MySQL.query.await) ~= 'function' then
        return nil
    end

    local limit = math.max(1, math.min(tonumber(maxVehicles) or 80, 250))
    local ok, rows = pcall(function()
        return MySQL.query.await('SELECT id, citizenid, vehicle, mods, garage, state, coords, plate FROM player_vehicles WHERE state = 0 LIMIT ?', { limit })
    end)

    if not ok or type(rows) ~= 'table' then return nil end

    local list = {}
    for _, row in ipairs(rows) do
        local props = {}
        if type(row.mods) == 'string' and row.mods ~= '' then
            local decodedOk, decoded = pcall(json.decode, row.mods)
            if decodedOk and type(decoded) == 'table' then props = decoded end
        end

        local coords = nil
        if type(row.coords) == 'string' and row.coords ~= '' then
            local decodedOk, decoded = pcall(json.decode, row.coords)
            if decodedOk and type(decoded) == 'table' then coords = decoded end
        end

        props.plate = props.plate or row.plate
        list[#list + 1] = {
            id = row.id,
            citizenid = row.citizenid,
            modelName = row.vehicle,
            garage = row.garage,
            state = row.state,
            props = props,
            coords = coords
        }
    end

    return list
end

local function coordTable(coords)
    if type(coords) ~= 'table' then return nil end

    local x = tonumber(coords.x or coords[1])
    local y = tonumber(coords.y or coords[2])
    local z = tonumber(coords.z or coords[3])
    if not x or not y or not z then return nil end

    return {
        x = round(x, 2),
        y = round(y, 2),
        z = round(z, 2),
        h = round(tonumber(coords.h or coords.w or coords.heading or coords[4]) or 0, 2)
    }
end

local function vehicleEntityData(entity)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return nil end

    local ok, data = pcall(function()
        local coords = GetEntityCoords(entity)
        local vehicleId = nil
        local stateOk, entityState = pcall(function()
            return Entity(entity).state
        end)

        if stateOk and entityState then
            vehicleId = tonumber(entityState.vehicleid or entityState.vehicleId)
        end

        return {
            entity = entity,
            netId = NetworkGetNetworkIdFromEntity(entity),
            vehicleId = vehicleId,
            plate = normalizedPlate(GetVehicleNumberPlateText(entity)),
            modelHash = GetEntityModel(entity),
            coords = {
                x = round(coords.x, 2),
                y = round(coords.y, 2),
                z = round(coords.z, 2),
                h = round(GetEntityHeading(entity), 2)
            }
        }
    end)

    if ok then return data end
    return nil
end

local function buildOwnedVehicleList(players)
    local settings = Config.OwnedVehicleMap or {}
    if settings.Enabled == false then return {} end

    local now = os.time()
    if ownedVehicleMapCache.expiresAt > now then
        return ownedVehicleMapCache.vehicles
    end

    local maxVehicles = math.max(1, math.min(tonumber(settings.MaxVehicles) or 80, 250))
    local ownedRows = qbxOwnedVehicleRows(maxVehicles) or mysqlOwnedVehicleRows(maxVehicles) or {}
    local byId = {}
    local byPlate = {}
    local ownerNames = onlineCitizenNames(players)

    for _, row in ipairs(ownedRows) do
        local props = type(row.props) == 'table' and row.props or {}
        local plate = normalizedPlate(row.plate or props.plate)
        local data = {
            id = tonumber(row.id),
            citizenid = cleanText(row.citizenid, 80),
            ownerName = ownerNames[row.citizenid] or cleanText(row.citizenid, 80),
            model = cleanText(row.modelName or row.vehicle or props.model, 80),
            garage = cleanText(row.garage, 80),
            state = tonumber(row.state) or 0,
            plate = plate,
            lastCoords = coordTable(row.coords)
        }

        if data.id then byId[data.id] = data end
        if plate ~= '' then byPlate[plate] = data end
    end

    local outVehicles = {}
    local seen = {}
    local ok, vehicles = pcall(GetAllVehicles)
    if ok and type(vehicles) == 'table' then
        for _, entity in ipairs(vehicles) do
            local entityData = vehicleEntityData(entity)
            local owned = entityData and ((entityData.vehicleId and byId[entityData.vehicleId]) or byPlate[entityData.plate])
            if owned and not seen[owned.id or owned.plate] then
                seen[owned.id or owned.plate] = true
                outVehicles[#outVehicles + 1] = {
                    id = owned.id,
                    netId = entityData.netId,
                    plate = owned.plate ~= '' and owned.plate or entityData.plate,
                    model = owned.model ~= '' and owned.model or tostring(entityData.modelHash or ''),
                    ownerName = owned.ownerName ~= '' and owned.ownerName or 'Unknown Owner',
                    citizenid = owned.citizenid,
                    garage = owned.garage,
                    coords = entityData.coords,
                    stale = false
                }
            end

            if #outVehicles >= maxVehicles then break end
        end
    end

    if settings.IncludeLastKnownCoords ~= false and #outVehicles < maxVehicles then
        for _, owned in pairs(byId) do
            if owned.lastCoords and not seen[owned.id or owned.plate] then
                seen[owned.id or owned.plate] = true
                outVehicles[#outVehicles + 1] = {
                    id = owned.id,
                    plate = owned.plate,
                    model = owned.model,
                    ownerName = owned.ownerName ~= '' and owned.ownerName or 'Unknown Owner',
                    citizenid = owned.citizenid,
                    garage = owned.garage,
                    coords = owned.lastCoords,
                    stale = true
                }
            end

            if #outVehicles >= maxVehicles then break end
        end
    end

    table.sort(outVehicles, function(a, b)
        return tostring(a.plate or '') < tostring(b.plate or '')
    end)

    ownedVehicleMapCache = {
        expiresAt = now + math.max(1, tonumber(settings.CacheSeconds) or 10),
        vehicles = outVehicles
    }

    return outVehicles
end

local function getConfigForNui()
    local remoteFeed = Config.RemoteFeed or {}

    return {
        title = Config.MenuTitle,
        logo = Config.MenuLogo or '',
        command = Config.Command,
        refreshInterval = Config.RefreshInterval,
        items = configuredItems(),
        vehicles = configuredVehicles(),
        peds = Config.Peds,
        weapons = Config.Weapons,
        jobs = configuredJobs(),
        gangs = configuredGangs(),
        licenses = Config.Licenses or {},
        teleportPresets = Config.TeleportPresets or {},
        gymStats = Config.GymStats or {},
        staffTags = (Config.StaffTags or {}).Allowed or {},
        vehicleKeyItems = Config.Integrations.VehicleKeyItems or {},
        console = {
            enabled = Config.Console.Enabled == true,
            allowedCommands = Config.Console.AllowedCommands or {},
            suggestions = Config.Console.CommandSuggestions or {}
        },
        adminChat = {
            templates = (Config.AdminChat or {}).Templates or {}
        },
        remoteFeed = {
            enabled = remoteFeed.Enabled == true,
            resource = remoteFeed.Resource or 'screenshot-basic',
            maxPlayers = tonumber(remoteFeed.MaxPlayers) or 8,
            refreshInterval = tonumber(remoteFeed.RefreshInterval) or 3500
        },
        weather = Config.Weather.Presets,
        events = Config.AllowedEvents
    }
end

local function buildSnapshot(source)
    local players = buildPlayerList()
    local permissions = {}

    for key, permission in pairs(Config.Permissions) do
        permissions[key] = hasPermission(source, permission)
    end

    permissions.all = hasPermission(source, 'all')
    permissions.consoleAll = hasPermission(source, Config.Console.AllowAllPermission)

    return {
        config = getConfigForNui(),
        self = {
            id = source,
            name = actorName(source),
            duty = duty[source] == true,
            permissions = permissions
        },
        server = {
            players = #players,
            maxPlayers = GetConvarInt('sv_maxclients', 48),
            uptime = formatUptime(),
            weather = currentWeather,
            time = currentTime,
            blackout = GlobalState.blackout == true or GlobalState.blackOut == true,
            resource = RESOURCE,
            version = GetResourceMetadata(RESOURCE, 'version', 0) or 'dev'
        },
        players = players,
        ownedVehicles = buildOwnedVehicleList(players),
        bans = publicBanList(),
        warnings = warnings,
        notes = notes,
        actionLogs = actionLogs,
        serverConsoleLogs = serverConsoleLogs,
        chatLogs = chatLogs,
        adminChatLogs = adminChatLogs
    }
end

local function sendSnapshot(source)
    if source ~= 0 and hasPermission(source, 'menu') then
        TriggerClientEvent('snipz_adminmenu:client:snapshot', source, buildSnapshot(source))
    end
end

local function targetOrError(data)
    local target = tonumber(data.target or data.targetId or data.id)
    if not target or not GetPlayerName(target) then
        return nil, 'Player is no longer online.'
    end

    return target
end

local function targetOrSelf(source, data)
    local target = tonumber(data.target or data.targetId or data.id)
    if not target then return source end
    if not GetPlayerName(target) then return nil, 'Player is no longer online.' end
    return target
end

local function safeTeleportCoords(data)
    local coords = {
        x = tonumber(data.x),
        y = tonumber(data.y),
        z = tonumber(data.z),
        h = tonumber(data.h) or 0
    }

    if not coords.x or not coords.y or not coords.z then
        return nil, 'Coordinates are invalid.'
    end

    local limit = tonumber(securityValue('MaxTeleportCoordinate', 12000.0)) or 12000.0
    local minZ = tonumber(securityValue('MinTeleportZ', -1000.0)) or -1000.0
    local maxZ = tonumber(securityValue('MaxTeleportZ', 3000.0)) or 3000.0

    if math.abs(coords.x) > limit or math.abs(coords.y) > limit or coords.z < minZ or coords.z > maxZ then
        return nil, 'Coordinates are outside the configured safe bounds.'
    end

    coords.h = clamp(coords.h, 0, 360)
    return coords
end

local function currentServerVehicleInfo(source)
    if source == 0 or not GetPlayerName(source) then return nil end

    local ped = GetPlayerPed(source)
    if not ped or ped == 0 or not DoesEntityExist(ped) then return nil end

    local vehicleOk, vehicle = pcall(GetVehiclePedIsIn, ped, false)
    if not vehicleOk or not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        return nil
    end

    local driverOk, driver = pcall(GetPedInVehicleSeat, vehicle, -1)
    local plateOk, plate = pcall(GetVehicleNumberPlateText, vehicle)
    local modelOk, modelHash = pcall(GetEntityModel, vehicle)

    return {
        entity = vehicle,
        ped = ped,
        isDriver = driverOk and driver == ped,
        plate = normalizedPlate(plateOk and plate or ''),
        modelHash = modelOk and tonumber(modelHash) or 0
    }
end

local function selfTargetDeniedReason(source, action, data)
    if source == 0 or type(data) ~= 'table' then return nil end

    local target = tonumber(data.target or data.targetId or data.id)
    if target ~= source then return nil end

    if action == 'player.freeze' then
        if data.state == false then return nil end
        return 'You cannot freeze yourself from the admin menu.'
    end

    return protectedSelfTargetActions[action]
end

local function rateLimited(source)
    if source == 0 then return false end

    local current = GetGameTimer()
    local previous = lastAction[source] or 0
    local cooldown = math.max(250, tonumber(securityValue('ActionCooldown', 650)) or 650)
    if current - previous < cooldown then
        return true
    end

    lastAction[source] = current
    return false
end

local function findBanForIdentifiers(identifiers)
    local currentTimeValue = now()

    for banId, ban in pairs(bans) do
        if ban.expires and ban.expires ~= 0 and ban.expires <= currentTimeValue then
            bans[banId] = nil
        else
            for _, identifier in ipairs(identifiers) do
                if ban.identifiers and ban.identifiers[identifier] then
                    return banId, ban
                end
            end
        end
    end

    return nil, nil
end

local function getBanMessage(ban)
    local expires = 'Permanent'
    if ban.expires and ban.expires ~= 0 then
        expires = os.date('%Y-%m-%d %H:%M:%S', ban.expires)
    end

    return ('You are banned from this server.\nReason: %s\nExpires: %s\nBan ID: %s'):format(
        ban.reason or 'No reason provided',
        expires,
        ban.id or 'unknown'
    )
end

local function inventoryResourceStarted()
    local resourceName = Config.Integrations.InventoryResource
    return resourceStarted(resourceName)
end

local function resetHealthBuffer(target)
    local eventName = Config.Integrations.HealthResetEvent or Config.Integrations.ReviveEvent
    if eventName and eventName ~= '' then
        TriggerClientEvent(eventName, target)
    end
end

local function reviveTarget(target)
    if resourceStarted('qbx_medical') then
        local ok, revived = pcall(function()
            return exports.qbx_medical:Revive(target)
        end)
        if ok and revived ~= false then
            resetHealthBuffer(target)
            return
        end
    end

    TriggerClientEvent('snipz_adminmenu:client:revive', target, {
        reviveEvent = Config.Integrations.ReviveEvent,
        healthResetEvent = Config.Integrations.HealthResetEvent
    })
end

local function triggerClothing(target)
    TriggerClientEvent('snipz_adminmenu:client:clothing', target, {
        event = Config.Integrations.ClothingEvent,
        fallbacks = Config.Integrations.ClothingFallbackEvents
    })
end

local function triggerAppearanceAction(target, action)
    TriggerClientEvent('snipz_adminmenu:client:appearanceAction', target, {
        action = action,
        barberEvent = Config.Integrations.BarberEvent,
        tattooEvent = Config.Integrations.TattooEvent,
        clothingEvent = Config.Integrations.ClothingEvent,
        clothingFallbacks = Config.Integrations.ClothingFallbackEvents
    })
end

local function setJailTimeWithExport(target, minutes)
    local resourceName = Config.Integrations.JailResource
    local exportName = Config.Integrations.JailExport

    if not resourceStarted(resourceName) or not exportName or exportName == '' then
        return false
    end

    local ok, result = pcall(function()
        return exports[resourceName][exportName](target, minutes)
    end)

    return ok and result ~= false
end

local function setSyncedWeather(weather)
    local compatResource = Config.Weather.CompatExportResource or 'qb-weathersync'
    if resourceStarted(Config.Weather.Resource) or resourceStarted(compatResource) then
        local ok = pcall(function()
            exports[compatResource]:setWeather(weather)
        end)
        if ok then return true end
    end

    if resourceStarted(Config.Weather.Resource) then
        GlobalState.weather = {
            weather = weather,
            time = 9999999999
        }
        return true
    end

    return false
end

local function setSyncedTime(hour, minute)
    local compatResource = Config.Weather.CompatExportResource or 'qb-weathersync'
    if resourceStarted(Config.Weather.Resource) or resourceStarted(compatResource) then
        local ok = pcall(function()
            exports[compatResource]:setTime(hour, minute)
        end)
        if ok then return true end
    end

    if resourceStarted(Config.Weather.Resource) then
        GlobalState.currentTime = {
            hour = hour,
            minute = minute
        }
        return true
    end

    return false
end

local function setSyncedBlackout(state)
    local compatResource = Config.Weather.CompatExportResource or 'qb-weathersync'
    if resourceStarted(Config.Weather.Resource) or resourceStarted(compatResource) then
        pcall(function()
            exports[compatResource]:setBlackout(state)
        end)
    end

    GlobalState.blackout = state
    GlobalState.blackOut = state
end

local function addItem(target, item, amount, metadata)
    item = cleanText(item, 80)
    amount = clamp(amount, 1, tonumber(securityValue('MaxItemAmount', 1000)) or 1000)
    metadata = safePayload(metadata or {}, 0)

    if inventoryResourceStarted() then
        local ok, result = pcall(function()
            return exports[Config.Integrations.InventoryResource]:AddItem(target, item, amount, metadata)
        end)
        if ok and result ~= false then return true end
    end

    local player = getQbxPlayer(target)
    if player and player.Functions and type(player.Functions.AddItem) == 'function' then
        local ok, result = pcall(player.Functions.AddItem, item, amount, false, metadata)
        return ok and result ~= false
    end

    return false
end

local function removeItem(target, item, amount)
    item = cleanText(item, 80)
    amount = clamp(amount, 1, tonumber(securityValue('MaxItemAmount', 1000)) or 1000)

    if inventoryResourceStarted() then
        local ok, result = pcall(function()
            return exports[Config.Integrations.InventoryResource]:RemoveItem(target, item, amount)
        end)
        if ok and result ~= false then return true end
    end

    local player = getQbxPlayer(target)
    if player and player.Functions and type(player.Functions.RemoveItem) == 'function' then
        local ok, result = pcall(player.Functions.RemoveItem, item, amount)
        return ok and result ~= false
    end

    return false
end

local function inventoryItemCount(target, item)
    item = cleanText(item, 80)
    if item == '' then return 0 end

    if inventoryResourceStarted() then
        local ok, count = pcall(function()
            return exports[Config.Integrations.InventoryResource]:Search(target, 'count', item)
        end)

        if ok then
            if type(count) == 'number' then return math.max(0, count) end
            if type(count) == 'table' then return math.max(0, tonumber(count[item]) or 0) end
        end
    end

    local player = getQbxPlayer(target)
    local playerItems = player and player.PlayerData and player.PlayerData.items
    if type(playerItems) ~= 'table' then return 0 end

    local total = 0
    for _, entry in pairs(playerItems) do
        if type(entry) == 'table' and entry.name == item then
            total = total + (tonumber(entry.amount or entry.count or entry.quantity) or 1)
        end
    end

    return total
end

local function clearVehicleKeyItems(target)
    local removed = {}
    local total = 0

    for _, itemName in ipairs(Config.Integrations.VehicleKeyItems or {}) do
        local item = cleanText(itemName, 80)
        if item ~= '' then
            local count = inventoryItemCount(target, item)
            if count > 0 and removeItem(target, item, count) then
                total = total + count
                removed[#removed + 1] = ('%sx %s'):format(count, item)
            end
        end
    end

    return total, removed
end

local function clearInventory(target)
    if inventoryResourceStarted() then
        local ok, result = pcall(function()
            return exports[Config.Integrations.InventoryResource]:ClearInventory(target)
        end)
        if ok and result ~= false then return true end
    end

    local player = getQbxPlayer(target)
    if player and player.Functions and type(player.Functions.ClearInventory) == 'function' then
        local ok, result = pcall(player.Functions.ClearInventory)
        return ok and result ~= false
    end

    return false
end

local function moneyAction(target, mode, account, amount)
    account = cleanText(account, 40)
    if not moneyAccountAllowed(account) then
        return false
    end

    amount = clamp(amount, 0, tonumber(securityValue('MaxMoneyAmount', 10000000)) or 10000000)

    local player = getQbxPlayer(target)
    if not player or not player.Functions then
        return false
    end

    local method = ({
        add = 'AddMoney',
        remove = 'RemoveMoney',
        set = 'SetMoney'
    })[mode]

    if not method or type(player.Functions[method]) ~= 'function' then
        return false
    end

    local ok, result = pcall(player.Functions[method], account, amount, RESOURCE)
    return ok and result ~= false
end

local function executeConfiguredCommand(template, ...)
    if not template or template == '' then return end

    local args = { ... }
    for index, value in ipairs(args) do
        args[index] = cleanText(value, 40)
    end

    ExecuteCommand(template:format(table.unpack(args)))
end

local function consoleCommandAllowed(source, command)
    if hasPermission(source, Config.Console.AllowAllPermission) then return true end

    local first = command:match('^%s*(%S+)')
    if not first then return false end
    first = first:lower()

    for _, allowed in ipairs(Config.Console.AllowedCommands or {}) do
        if first == allowed:lower() then return true end
    end

    return false
end

local function safeConsoleCommand(value)
    local command = cleanText(value, 180)
    if command == '' then return nil, 'Command is empty.' end
    if command:find('[;&|`<>]', 1) then
        return nil, 'Command contains blocked control characters.'
    end

    return command
end

local handlers = {}

local function releaseMenuFocus(source)
    if source and source > 0 then
        TriggerClientEvent('snipz_adminmenu:client:forceClose', source)
        Wait(75)
    end
end

handlers['duty.toggle'] = function(source)
    duty[source] = not duty[source]
    logAction(source, 'Duty Toggle', actorName(source), duty[source] and 'On duty' or 'Off duty')
    return true, duty[source] and 'Duty enabled.' or 'Duty disabled.'
end

handlers['admin.chat'] = function(source, data)
    local message = cleanText(data.message, 900)
    if message == '' then return false, 'Admin chat message is empty.' end
    local chatConfig = Config.AdminChat or {}

    local entry = {
        time = now(),
        source = source,
        actor = actorName(source),
        message = message
    }

    pushLimited(adminChatLogs, entry, chatConfig.MaxHistory or 50)

    if not sendAdminChatWebhook(entry) then
        return false, 'Admin chat webhook is not configured.'
    end

    logAction(source, 'Admin Chat', 'Discord', message)
    return true, 'Admin chat sent.'
end

handlers.announce = function(source, data)
    local message = cleanText(data.message, 180)
    if message == '' then return false, 'Announcement is empty.' end

    local fxPanelHandled, fxPanelError = runFxPanelModerationExport(source, 'sendAnnouncement', 'announcement', nil, message)
    if fxPanelHandled == false then return false, fxPanelError end

    if fxPanelHandled == true then
        logAction(source, 'Announcement', 'All players', message)
        return true, 'Announcement sent through FxPanel.'
    end

    TriggerClientEvent('snipz_adminmenu:client:announcement', -1, {
        message = message
    })

    logAction(source, 'Announcement', 'All players', message)
    return true, 'Announcement sent.'
end

handlers['player.message'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local message = cleanText(data.message, 220)
    if message == '' then return false, 'Message is empty.' end

    TriggerClientEvent('snipz_adminmenu:client:staffMessage', target, {
        message = message,
        actor = actorName(source)
    })
    logAction(source, 'Message', actorName(target), message)
    return true, 'Message sent.'
end

handlers['player.noteAdd'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local noteText = cleanText(data.note or data.message, 500)
    if noteText == '' then return false, 'Note is empty.' end

    local identifier = primaryIdentifier(target)
    notes[identifier] = notes[identifier] or {}

    local entry = {
        id = ('%s:%s:%s'):format(now(), source, math.random(100000, 999999)),
        time = now(),
        updated = nil,
        actor = actorName(source),
        actorId = source,
        note = noteText
    }

    table.insert(notes[identifier], 1, entry)
    saveJsonFile(Config.Security.NotesFile, notes)
    logAction(source, 'Add Note', actorName(target), noteText)
    return true, 'Note added.'
end

handlers['player.noteEdit'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local noteId = cleanText(data.noteId or data.id, 80)
    local noteText = cleanText(data.note or data.message, 500)
    if noteId == '' then return false, 'Note is missing.' end
    if noteText == '' then return false, 'Note is empty.' end

    local list = notes[primaryIdentifier(target)] or {}
    for _, note in ipairs(list) do
        if note.id == noteId then
            if not canManageNote(source, note) then
                return false, 'You can only edit your own notes.'
            end

            note.note = noteText
            note.updated = now()
            note.updatedBy = actorName(source)
            note.updatedById = source
            saveJsonFile(Config.Security.NotesFile, notes)
            logAction(source, 'Edit Note', actorName(target), noteText)
            return true, 'Note updated.'
        end
    end

    return false, 'Note was not found.'
end

handlers['player.noteDelete'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local noteId = cleanText(data.noteId or data.id, 80)
    if noteId == '' then return false, 'Note is missing.' end

    local identifier = primaryIdentifier(target)
    local list = notes[identifier] or {}
    for index, note in ipairs(list) do
        if note.id == noteId then
            if not canManageNote(source, note) then
                return false, 'You can only delete your own notes.'
            end

            table.remove(list, index)
            saveJsonFile(Config.Security.NotesFile, notes)
            logAction(source, 'Delete Note', actorName(target), note.note or noteId)
            return true, 'Note deleted.'
        end
    end

    return false, 'Note was not found.'
end

handlers['staff.tagSet'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local tag = configuredStaffTag(data.tag or data.label)
    if not tag then return false, 'Staff tag is required.' end

    local identifier = primaryIdentifier(target)
    staffTags[identifier] = {
        label = tag.label,
        color = tag.color,
        actor = actorName(source),
        actorId = source,
        time = now()
    }

    saveJsonFile(Config.Security.StaffTagsFile, staffTags)
    logAction(source, 'Set Staff Tag', actorName(target), tag.label)
    return true, 'Staff tag updated.'
end

handlers['staff.tagClear'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local identifier = primaryIdentifier(target)
    if not staffTags[identifier] then
        return false, 'This player does not have a custom staff tag.'
    end

    local existing = staffTags[identifier]
    local label = type(existing) == 'table' and existing.label or tostring(existing or '')
    staffTags[identifier] = nil
    saveJsonFile(Config.Security.StaffTagsFile, staffTags)
    logAction(source, 'Clear Staff Tag', actorName(target), label)
    return true, 'Staff tag cleared.'
end

local function addLocalWarning(source, target, reason)
    local identifier = primaryIdentifier(target)
    warnings[identifier] = warnings[identifier] or {}
    table.insert(warnings[identifier], 1, {
        id = ('%s:%s:%s'):format(now(), source, math.random(100000, 999999)),
        time = now(),
        admin = actorName(source),
        adminId = source,
        reason = reason
    })

    saveJsonFile(Config.Security.WarningsFile, warnings)
end

handlers['player.warn'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local reason = cleanText(data.reason, 220)
    if reason == '' then reason = 'No reason provided' end

    local fxPanelHandled, fxPanelError = runFxPanelModerationExport(source, 'warnPlayer', 'players.warn', target, reason)
    if fxPanelHandled == false then return false, fxPanelError end

    addLocalWarning(source, target, reason)
    if fxPanelHandled ~= true then
        notify(target, ('Warning: %s'):format(reason), 'warning')
    end

    logAction(source, 'Warn', actorName(target), reason)
    return true, fxPanelHandled == true and 'Warning issued through FxPanel.' or 'Warning issued.'
end

handlers['player.warnEdit'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local warnId = cleanText(data.warningId or data.id, 220)
    local reason = cleanText(data.reason, 220)
    if warnId == '' then return false, 'Warning is missing.' end
    if reason == '' then return false, 'Warning reason is empty.' end

    local list = warnings[primaryIdentifier(target)] or {}
    for index, warning in ipairs(list) do
        if warningId(warning, index) == warnId then
            warning.id = warning.id or warnId
            warning.reason = reason
            warning.updated = now()
            warning.updatedBy = actorName(source)
            warning.updatedById = source
            saveJsonFile(Config.Security.WarningsFile, warnings)
            logAction(source, 'Edit Warning', actorName(target), reason)
            return true, 'Warning updated.'
        end
    end

    return false, 'Warning was not found.'
end

handlers['player.warnDelete'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local warnId = cleanText(data.warningId or data.id, 220)
    if warnId == '' then return false, 'Warning is missing.' end

    local identifier = primaryIdentifier(target)
    local list = warnings[identifier] or {}
    for index, warning in ipairs(list) do
        if warningId(warning, index) == warnId then
            table.remove(list, index)
            saveJsonFile(Config.Security.WarningsFile, warnings)
            logAction(source, 'Delete Warning', actorName(target), warning.reason or warnId)
            return true, 'Warning deleted.'
        end
    end

    return false, 'Warning was not found.'
end

handlers['player.kick'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local reason = cleanText(data.reason, 220)
    if reason == '' then reason = 'Kicked by staff.' end

    local fxPanelHandled, fxPanelError = runFxPanelModerationExport(source, 'kickPlayer', 'players.kick', target, reason)
    if fxPanelHandled == false then return false, fxPanelError end

    logAction(source, 'Kick', actorName(target), reason)
    if fxPanelHandled == true then
        return true, 'Player kicked through FxPanel.'
    end

    DropPlayer(target, reason)
    return true, 'Player kicked.'
end

handlers['player.ban'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local reason = cleanText(data.reason, 220)
    if reason == '' then reason = 'Banned by staff.' end

    local minutes = clamp(data.duration, 0, tonumber(securityValue('MaxBanMinutes', 5256000)) or 5256000)
    local fxPanelDuration = formatFxPanelDuration(minutes)
    local fxPanelHandled, fxPanelError = runFxPanelModerationExport(source, 'banPlayer', 'players.ban', target, reason, fxPanelDuration)
    if fxPanelHandled == false then return false, fxPanelError end

    logAction(source, 'Ban', actorName(target), ('%s (%s)'):format(reason, fxPanelDuration))
    if fxPanelHandled == true then
        return true, 'Player banned through FxPanel.'
    end

    local expires = minutes > 0 and (now() + (minutes * 60)) or 0
    local ids = getIdentifiers(target)
    local idSet = {}

    for _, identifier in ipairs(ids.list) do
        idSet[identifier] = true
    end

    local banId = ('SNIPZ-%s-%s'):format(now(), math.random(1000, 9999))
    bans[banId] = {
        id = banId,
        name = actorName(target),
        reason = reason,
        admin = actorName(source),
        created = now(),
        expires = expires,
        identifiers = idSet
    }

    saveJsonFile(Config.Security.BanFile, bans)
    DropPlayer(target, getBanMessage(bans[banId]))
    return true, 'Player banned.'
end

handlers['ban.remove'] = function(source, data)
    local banId = cleanText(data.banId or data.id, 80)
    if not bans[banId] then return false, 'Ban was not found.' end

    local name = bans[banId].name or banId
    bans[banId] = nil
    saveJsonFile(Config.Security.BanFile, bans)
    logAction(source, 'Unban', name, banId)
    return true, 'Ban removed.'
end

handlers['player.revive'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    reviveTarget(target)

    logAction(source, 'Revive', actorName(target), '')
    return true, 'Player revived.'
end

handlers['player.reviveRadius'] = function(source, data)
    local radius = clamp(data.radius, 1, 100)
    local originCoords = getCoords(source)
    if not originCoords then return false, 'Your coordinates are unavailable.' end
    local origin = vector3(originCoords.x, originCoords.y, originCoords.z)
    local revived = 0

    for _, value in ipairs(GetPlayers()) do
        local target = tonumber(value)
        local ped = GetPlayerPed(target)
        if ped and ped ~= 0 and DoesEntityExist(ped) and #(origin - GetEntityCoords(ped)) <= radius then
            reviveTarget(target)
            revived = revived + 1
        end
    end

    logAction(source, 'Revive Radius', ('%s players'):format(revived), ('%sm'):format(radius))
    return true, ('Revived %s players.'):format(revived)
end

handlers['player.heal'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    TriggerClientEvent('snipz_adminmenu:client:heal', target, {
        armor = data.armor == true,
        healthResetEvent = Config.Integrations.HealthResetEvent
    })

    logAction(source, 'Heal', actorName(target), data.armor and 'Health and armor' or 'Health')
    return true, 'Player healed.'
end

handlers['player.feed'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local updated = false
    if qbxStarted() then
        local ok = pcall(function()
            exports.qbx_core:SetMetadata(target, 'hunger', 100)
            exports.qbx_core:SetMetadata(target, 'thirst', 100)
        end)
        updated = ok
    end

    if not updated then
        TriggerClientEvent('snipz_adminmenu:client:heal', target, {
            armor = false,
            healthResetEvent = Config.Integrations.HealthResetEvent
        })
    end

    logAction(source, 'Food Water', actorName(target), updated and 'Metadata updated' or 'Fallback heal')
    return true, 'Food and water updated.'
end

handlers['player.resetStatus'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local updated = false
    if qbxStarted() then
        local ok = pcall(function()
            exports.qbx_core:SetMetadata(target, 'hunger', 100)
            exports.qbx_core:SetMetadata(target, 'thirst', 100)
            exports.qbx_core:SetMetadata(target, 'stress', 0)
        end)
        updated = ok
    end

    TriggerClientEvent('snipz_adminmenu:client:resetStatus', target, {
        healthResetEvent = Config.Integrations.HealthResetEvent
    })

    logAction(source, 'Reset Status', actorName(target), updated and 'Metadata updated' or 'Client reset')
    return true, 'Status reset.'
end

handlers['player.setArmor'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local amount = clamp(data.amount, 0, 100)
    TriggerClientEvent('snipz_adminmenu:client:setArmor', target, amount)
    logAction(source, 'Set Armor', actorName(target), tostring(amount))
    return true, 'Armor updated.'
end

handlers['player.voiceMute'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local state = data.state == true
    TriggerClientEvent('snipz_adminmenu:client:voiceMute', target, state)
    logAction(source, state and 'Voice Mute' or 'Voice Unmute', actorName(target), '')
    return true, state and 'Voice muted.' or 'Voice unmuted.'
end

handlers['player.chatMute'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local state = data.state == true
    chatMuted[target] = state or nil
    logAction(source, state and 'Chat Mute' or 'Chat Unmute', actorName(target), '')
    return true, state and 'Chat muted.' or 'Chat unmuted.'
end

handlers['player.handsUp'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    TriggerClientEvent('snipz_adminmenu:client:handsUp', target)
    logAction(source, 'Force Hands Up', actorName(target), '')
    return true, 'Hands-up animation requested.'
end

handlers['player.escort'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local state = data.state
    if state == nil then
        state = escortSessions[target] ~= source
    else
        state = state == true
    end

    if state then
        escortSessions[target] = source
        TriggerClientEvent('snipz_adminmenu:client:escort', target, source, true)
        logAction(source, 'Escort Start', actorName(target), '')
        return true, 'Escort started.'
    end

    escortSessions[target] = nil
    TriggerClientEvent('snipz_adminmenu:client:escort', target, source, false)
    logAction(source, 'Escort Stop', actorName(target), '')
    return true, 'Escort stopped.'
end

handlers['player.seatVehicle'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    TriggerClientEvent('snipz_adminmenu:client:seatVehicle', target)
    logAction(source, 'Seat In Vehicle', actorName(target), '')
    return true, 'Seat request sent.'
end

handlers['player.jail'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local eventName = Config.Integrations.JailEvent
    if not eventName or eventName == '' then
        return false, 'Jail integration is not configured.'
    end

    local minutes = clamp(data.minutes or data.duration, 1, 10080)
    local reason = cleanText(data.reason, 180)

    if setJailTimeWithExport(target, minutes) then
        logAction(source, 'Jail', actorName(target), ('%s minutes %s'):format(minutes, reason))
        return true, 'Jail time updated.'
    end

    if Config.Integrations.JailEventType == 'client' then
        TriggerClientEvent(eventName, target, minutes, reason, source)
    else
        TriggerEvent(eventName, target, minutes, reason, source)
    end

    logAction(source, 'Jail', actorName(target), ('%s minutes %s'):format(minutes, reason))
    return true, 'Jail event triggered.'
end

handlers['player.unjail'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local eventName = Config.Integrations.UnjailEvent
    if not eventName or eventName == '' then
        return false, 'Unjail integration is not configured.'
    end

    if setJailTimeWithExport(target, 0) then
        logAction(source, 'Unjail', actorName(target), Config.Integrations.JailResource or '')
        return true, 'Jail time cleared.'
    end

    if Config.Integrations.UnjailEventType == 'client' then
        TriggerClientEvent(eventName, target, source)
    else
        TriggerEvent(eventName, target, source)
    end

    logAction(source, 'Unjail', actorName(target), '')
    return true, 'Unjail event triggered.'
end

handlers['player.cuff'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    TriggerClientEvent('snipz_adminmenu:client:setCuffed', target, true)
    logAction(source, 'Cuff', actorName(target), '')
    return true, 'Player cuffed.'
end

handlers['player.uncuff'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    TriggerClientEvent('snipz_adminmenu:client:setCuffed', target, false)
    logAction(source, 'Uncuff', actorName(target), '')
    return true, 'Player uncuffed.'
end

handlers['player.kill'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    TriggerClientEvent('snipz_adminmenu:client:kill', target)
    logAction(source, 'Kill', actorName(target), '')
    return true, 'Player killed.'
end

handlers['player.freeze'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    TriggerClientEvent('snipz_adminmenu:client:freeze', target, data.state == true)
    logAction(source, 'Freeze', actorName(target), data.state and 'Frozen' or 'Unfrozen')
    return true, data.state and 'Player frozen.' or 'Player unfrozen.'
end

handlers['player.slap'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    TriggerClientEvent('snipz_adminmenu:client:slap', target)
    logAction(source, 'Slap', actorName(target), '')
    return true, 'Player slapped.'
end

handlers['player.explode'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    TriggerClientEvent('snipz_adminmenu:client:explode', target)
    logAction(source, 'Explode', actorName(target), '')
    return true, 'Explosion triggered.'
end

handlers['player.burn'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    TriggerClientEvent('snipz_adminmenu:client:burn', target)
    logAction(source, 'Burn', actorName(target), '')
    return true, 'Fire triggered.'
end

handlers['player.ragdoll'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    TriggerClientEvent('snipz_adminmenu:client:ragdoll', target)
    logAction(source, 'Ragdoll', actorName(target), '')
    return true, 'Player ragdolled.'
end

handlers['player.spectate'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local coords = getCoords(target)
    if not coords then return false, 'Target coordinates are unavailable.' end

    TriggerClientEvent('snipz_adminmenu:client:spectate', source, target, coords)
    logAction(source, 'Spectate', actorName(target), '')
    return true, 'Spectate requested.'
end

handlers['player.spectateStop'] = function(source)
    TriggerClientEvent('snipz_adminmenu:client:spectate', source, false)
    logAction(source, 'Spectate Stop', actorName(source), '')
    return true, 'Spectate stopped.'
end

handlers['player.control'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local coords = getCoords(target)
    if not coords then return false, 'Target coordinates are unavailable.' end

    local previousTarget = controlSessions[source]
    if previousTarget and previousTarget ~= target and GetPlayerName(previousTarget) then
        TriggerClientEvent('snipz_adminmenu:client:controlledState', previousTarget, source, false)
    end

    for admin, controlledTarget in pairs(controlSessions) do
        if admin ~= source and controlledTarget == target then
            controlSessions[admin] = nil
            if GetPlayerName(admin) then
                TriggerClientEvent('snipz_adminmenu:client:controlStop', admin)
            end
        end
    end

    controlSessions[source] = target
    TriggerClientEvent('snipz_adminmenu:client:controlledState', target, source, true)
    TriggerClientEvent('snipz_adminmenu:client:controlStart', source, target, coords)
    logAction(source, 'Control Start', actorName(target), '')
    return true, 'Control started.'
end

handlers['player.controlStop'] = function(source)
    local target = controlSessions[source]
    if target and GetPlayerName(target) then
        TriggerClientEvent('snipz_adminmenu:client:controlledState', target, source, false)
    end

    controlSessions[source] = nil
    lastControlInput[source] = nil
    TriggerClientEvent('snipz_adminmenu:client:controlStop', source)
    logAction(source, 'Control Stop', actorName(source), '')
    return true, 'Control stopped.'
end

handlers['player.goto'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local coords = getCoords(target)
    if not coords then return false, 'Target coordinates are unavailable.' end

    TriggerClientEvent('snipz_adminmenu:client:teleport', source, coords)
    logAction(source, 'Goto', actorName(target), '')
    return true, 'Teleported to player.'
end

handlers['player.bring'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local coords = getCoords(source)
    if not coords then return false, 'Your coordinates are unavailable.' end

    returnCoords[target] = getCoords(target)
    TriggerClientEvent('snipz_adminmenu:client:teleport', target, coords)
    logAction(source, 'Bring', actorName(target), '')
    return true, 'Player brought.'
end

handlers['player.return'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local coords = returnCoords[target]
    if not coords then return false, 'No return location is saved for this player.' end

    TriggerClientEvent('snipz_adminmenu:client:teleport', target, coords)
    returnCoords[target] = nil
    logAction(source, 'Return Player', actorName(target), ('%.2f %.2f %.2f'):format(coords.x or 0, coords.y or 0, coords.z or 0))
    return true, 'Player returned.'
end

local function teleportPreset(name)
    name = cleanText(name, 80)
    for _, preset in ipairs(Config.TeleportPresets or {}) do
        if cleanText(preset.name or preset.label, 80) == name and type(preset.coords) == 'table' then
            return preset
        end
    end

    return nil
end

handlers['player.teleportPreset'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local preset = teleportPreset(data.preset or data.name)
    if not preset then return false, 'Teleport preset was not found.' end

    returnCoords[target] = getCoords(target)
    TriggerClientEvent('snipz_adminmenu:client:teleport', target, preset.coords)
    logAction(source, 'Teleport Preset', actorName(target), preset.label or preset.name or '')
    return true, 'Player teleported.'
end

handlers['player.teleportCoords'] = function(source, data)
    local coords, coordsErr = safeTeleportCoords(data)
    if not coords then return false, coordsErr end

    TriggerClientEvent('snipz_adminmenu:client:teleport', source, coords)
    logAction(source, 'Teleport Coords', actorName(source), ('%.2f %.2f %.2f'):format(coords.x, coords.y, coords.z))
    return true, 'Teleported.'
end

handlers['player.openInventory'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    if inventoryResourceStarted() then
        releaseMenuFocus(source)
        local ok = pcall(function()
            exports[Config.Integrations.InventoryResource]:forceOpenInventory(source, 'player', target)
        end)

        if ok then
            logAction(source, 'Open Inventory', actorName(target), Config.Integrations.InventoryResource)
            return true, 'Inventory opened.'
        end
    end

    return false, 'Inventory integration is not available.'
end

handlers['player.clearInventory'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    if not clearInventory(target) then
        return false, 'Could not clear inventory.'
    end

    logAction(source, 'Clear Inventory', actorName(target), Config.Integrations.InventoryResource or '')
    return true, 'Inventory cleared.'
end

handlers['player.clearVehicleKeys'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local total, removed = clearVehicleKeyItems(target)
    if total <= 0 then
        return false, 'No vehicle key items were found.'
    end

    local detail = table.concat(removed, ', ')
    logAction(source, 'Clear Vehicle Keys', actorName(target), detail)
    return true, ('Removed %s vehicle key item%s.'):format(total, total == 1 and '' or 's')
end

handlers['player.clothing'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    if target == source then
        releaseMenuFocus(source)
    end

    triggerClothing(target)
    logAction(source, 'Clothing Menu', actorName(target), Config.Integrations.ClothingEvent or '')
    return true, 'Clothing menu opened.'
end

handlers['player.barber'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    triggerAppearanceAction(target, 'barber')
    logAction(source, 'Barber Menu', actorName(target), Config.Integrations.BarberEvent or '')
    return true, 'Barber menu opened.'
end

handlers['player.tattoo'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    triggerAppearanceAction(target, 'tattoo')
    logAction(source, 'Tattoo Menu', actorName(target), Config.Integrations.TattooEvent or '')
    return true, 'Tattoo menu opened.'
end

handlers['player.resetAppearance'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    triggerAppearanceAction(target, 'reset')
    logAction(source, 'Reset Appearance', actorName(target), '')
    return true, 'Appearance reset requested.'
end

handlers['player.setPed'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local model, modelErr = configuredValueOrError(Config.Peds or {}, data.model, { 'model', 'name' }, 'model', 'Ped model')
    if not model then return false, modelErr end

    TriggerClientEvent('snipz_adminmenu:client:setPed', target, model)
    logAction(source, 'Set Ped', actorName(target), model)
    return true, 'Ped changed.'
end

handlers['player.giveWeapon'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local weapon, weaponErr = configuredValueOrError(Config.Weapons or {}, data.weapon or data.name, { 'name', 'weapon' }, 'name', 'Weapon')
    if not weapon then return false, weaponErr end

    TriggerClientEvent('snipz_adminmenu:client:giveWeapon', target, weapon, clamp(data.ammo, 1, tonumber(securityValue('MaxWeaponAmmo', 5000)) or 5000))
    logAction(source, 'Give Weapon', actorName(target), weapon)
    return true, 'Weapon given.'
end

handlers['player.clearWeapons'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    TriggerClientEvent('snipz_adminmenu:client:clearWeapons', target)
    logAction(source, 'Clear Weapons', actorName(target), '')
    return true, 'Weapons cleared.'
end

handlers['player.setBucket'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local bucket = clamp(data.bucket, 0, 2147483647)
    local ok = false

    if qbxStarted() then
        ok = pcall(function()
            return exports.qbx_core:SetPlayerBucket(target, bucket)
        end)
    end

    if not ok then
        SetPlayerRoutingBucket(target, bucket)
    end

    logAction(source, 'Set Bucket', actorName(target), tostring(bucket))
    return true, 'Routing bucket updated.'
end

handlers['player.setJob'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local job, jobErr, jobEntry = configuredValueOrError(Config.Jobs or {}, data.job, { 'name', 'job' }, 'name', 'Job')
    if not job then return false, jobErr end
    local grade = clamp(data.grade, 0, 100)
    if not gradeAllowed(jobEntry, grade) then return false, 'Job grade is not configured.' end

    if qbxStarted() then
        local ok = pcall(function()
            exports.qbx_core:SetJob(target, job, grade)
        end)
        if ok then
            logAction(source, 'Set Job', actorName(target), ('%s:%s'):format(job, grade))
            return true, 'Job updated.'
        end
    end

    local player = getQbxPlayer(target)
    if player and player.Functions and type(player.Functions.SetJob) == 'function' then
        local ok = pcall(player.Functions.SetJob, job, grade)
        if ok then
            logAction(source, 'Set Job', actorName(target), ('%s:%s'):format(job, grade))
            return true, 'Job updated.'
        end
    end

    return false, 'Could not update job.'
end

handlers['player.setGang'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local gang, gangErr, gangEntry = configuredValueOrError(Config.Gangs or {}, data.gang or data.name, { 'name', 'gang' }, 'name', 'Gang')
    if not gang then return false, gangErr end
    local grade = clamp(data.grade, 0, 100)
    if not gradeAllowed(gangEntry, grade) then return false, 'Gang grade is not configured.' end

    if qbxStarted() then
        local ok = pcall(function()
            exports.qbx_core:SetGang(target, gang, grade)
        end)
        if ok then
            logAction(source, 'Set Gang', actorName(target), ('%s:%s'):format(gang, grade))
            return true, 'Gang updated.'
        end
    end

    local player = getQbxPlayer(target)
    if player and player.Functions and type(player.Functions.SetGang) == 'function' then
        local ok = pcall(player.Functions.SetGang, gang, grade)
        if ok then
            logAction(source, 'Set Gang', actorName(target), ('%s:%s'):format(gang, grade))
            return true, 'Gang updated.'
        end
    end

    return false, 'Could not update gang.'
end

handlers['player.setDuty'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local state = data.state == true
    local updated = false

    if qbxStarted() then
        updated = pcall(function()
            exports.qbx_core:SetJobDuty(target, state)
        end)
    end

    if not updated then
        local player = getQbxPlayer(target)
        if player and player.Functions then
            if type(player.Functions.SetJobDuty) == 'function' then
                updated = pcall(player.Functions.SetJobDuty, state)
            elseif type(player.Functions.SetDuty) == 'function' then
                updated = pcall(player.Functions.SetDuty, state)
            end
        end
    end

    if not updated then return false, 'Could not update duty.' end

    logAction(source, 'Set Duty', actorName(target), state and 'On' or 'Off')
    return true, state and 'Duty enabled.' or 'Duty disabled.'
end

handlers['player.setLicense'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local license, licenseErr = configuredValueOrError(Config.Licenses or {}, data.license or data.name, { 'name', 'license' }, 'name', 'License')
    if not license then return false, licenseErr end

    local state = data.state ~= false
    local playerData = getPlayerData(target)
    local metadata = playerData.metadata or {}
    local licenses = metadata.licences or metadata.licenses or {}
    if type(licenses) ~= 'table' then licenses = {} end

    licenses[license] = state or nil

    local updated = false
    if qbxStarted() then
        updated = pcall(function()
            exports.qbx_core:SetMetadata(target, 'licences', licenses)
        end)
        if not updated then
            updated = pcall(function()
                exports.qbx_core:SetMetadata(target, 'licenses', licenses)
            end)
        end
    end

    local player = getQbxPlayer(target)
    if not updated and player and player.Functions and type(player.Functions.SetMetaData) == 'function' then
        updated = pcall(player.Functions.SetMetaData, 'licences', licenses)
    end

    if not updated then return false, 'Could not update license.' end

    logAction(source, state and 'Give License' or 'Remove License', actorName(target), license)
    return true, state and 'License granted.' or 'License removed.'
end

handlers['player.setGymStats'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local gymConfig = Config.GymStats or {}
    local allowedStats = {}
    for _, stat in ipairs(gymConfig.Stats or {}) do
        local statName = cleanText(stat.name or stat.key, 60)
        if statName ~= '' then
            allowedStats[statName] = true
        end
    end

    local statName = cleanText(data.stat or data.name or data.key, 60)
    if statName == '' then return false, 'Gym stat is required.' end
    if next(allowedStats) and not allowedStats[statName] then return false, 'Gym stat is not configured.' end

    local minValue = tonumber(gymConfig.Min or gymConfig.min) or 0
    local maxValue = tonumber(gymConfig.Max or gymConfig.max) or 100
    local value = clamp(data.value, minValue, maxValue)
    local updated = false

    if qbxStarted() then
        local ok, result = pcall(function()
            exports.qbx_core:SetMetadata(target, statName, value)
        end)
        updated = ok and result ~= false
    end

    local player = getQbxPlayer(target)
    if not updated and player and player.Functions and type(player.Functions.SetMetaData) == 'function' then
        local ok, result = pcall(function()
            player.Functions.SetMetaData(statName, value)
        end)
        updated = ok and result ~= false
        if not updated then
            ok, result = pcall(function()
                player.Functions.SetMetaData(player, statName, value)
            end)
            updated = ok and result ~= false
        end
    end

    if not updated then return false, 'Could not update gym stat.' end

    logAction(source, 'Set Gym Stat', actorName(target), ('%s: %s'):format(statName, value))
    return true, 'Gym stat updated.'
end

handlers['player.deleteCharacter'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local playerData = getPlayerData(target)
    local citizenid = cleanText(playerData.citizenid or playerData.citizenId, 80)
    if citizenid == '' then return false, 'Citizen ID is missing.' end

    if not qbxStarted() then return false, 'qbx_core is not available.' end

    local ok = pcall(function()
        exports.qbx_core:DeleteCharacter(citizenid)
    end)

    if not ok then return false, 'Could not delete character.' end

    logAction(source, 'Delete Character', actorName(target), citizenid)
    DropPlayer(target, 'Your character was deleted by staff.')
    return true, 'Character deleted.'
end

handlers['item.give'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local item, itemErr = configuredValueOrError(Config.Items or {}, data.item or data.name, { 'name', 'item' }, 'name', 'Item')
    if not item then return false, itemErr end

    local amount = clamp(data.amount, 1, tonumber(securityValue('MaxItemAmount', 1000)) or 1000)
    if not addItem(target, item, amount, data.metadata) then
        return false, 'Could not give item.'
    end

    logAction(source, 'Give Item', actorName(target), ('%sx %s'):format(amount, item))
    return true, 'Item given.'
end

handlers['item.remove'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local item, itemErr = configuredValueOrError(Config.Items or {}, data.item or data.name, { 'name', 'item' }, 'name', 'Item')
    if not item then return false, itemErr end

    local amount = clamp(data.amount, 1, tonumber(securityValue('MaxItemAmount', 1000)) or 1000)
    if not removeItem(target, item, amount) then
        return false, 'Could not remove item.'
    end

    logAction(source, 'Remove Item', actorName(target), ('%sx %s'):format(amount, item))
    return true, 'Item removed.'
end

handlers['inventory.openStash'] = function(source, data)
    if not inventoryResourceStarted() then
        return false, 'Inventory integration is not available.'
    end

    local stash = cleanText(data.stash or data.name, 80)
    if stash == '' then return false, 'Stash name is required.' end

    releaseMenuFocus(source)
    local ok = pcall(function()
        exports[Config.Integrations.InventoryResource]:forceOpenInventory(source, 'stash', stash)
    end)

    if not ok then return false, 'Could not open stash.' end

    logAction(source, 'Open Stash', stash, Config.Integrations.InventoryResource)
    return true, 'Stash opened.'
end

handlers['inventory.openTrunk'] = function(source, data)
    if not inventoryResourceStarted() then
        return false, 'Inventory integration is not available.'
    end

    local plate = cleanText(data.plate, 12):upper()
    if plate == '' then return false, 'Plate is required.' end

    releaseMenuFocus(source)
    local ok = pcall(function()
        exports[Config.Integrations.InventoryResource]:forceOpenInventory(source, 'trunk', plate)
    end)

    if not ok then return false, 'Could not open trunk.' end

    logAction(source, 'Open Trunk', plate, Config.Integrations.InventoryResource)
    return true, 'Trunk opened.'
end

handlers['money.add'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local account = cleanText(data.account or 'cash', 40)
    if not moneyAccountAllowed(account) then return false, 'Money account is not configured.' end
    local amount = clamp(data.amount, 0, tonumber(securityValue('MaxMoneyAmount', 10000000)) or 10000000)
    if not moneyAction(target, 'add', account, amount) then
        return false, 'Could not add money.'
    end

    logAction(source, 'Add Money', actorName(target), ('%s %s'):format(account, amount))
    return true, 'Money added.'
end

handlers['money.remove'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local account = cleanText(data.account or 'cash', 40)
    if not moneyAccountAllowed(account) then return false, 'Money account is not configured.' end
    local amount = clamp(data.amount, 0, tonumber(securityValue('MaxMoneyAmount', 10000000)) or 10000000)
    if not moneyAction(target, 'remove', account, amount) then
        return false, 'Could not remove money.'
    end

    logAction(source, 'Remove Money', actorName(target), ('%s %s'):format(account, amount))
    return true, 'Money removed.'
end

handlers['money.set'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local account = cleanText(data.account or 'cash', 40)
    if not moneyAccountAllowed(account) then return false, 'Money account is not configured.' end
    local amount = clamp(data.amount, 0, tonumber(securityValue('MaxMoneyAmount', 10000000)) or 10000000)
    if not moneyAction(target, 'set', account, amount) then
        return false, 'Could not set money.'
    end

    logAction(source, 'Set Money', actorName(target), ('%s %s'):format(account, amount))
    return true, 'Money set.'
end

handlers['vehicle.spawn'] = function(source, data)
    local model, modelErr = configuredValueOrError(Config.Vehicles or {}, data.model, { 'model', 'name' }, 'model', 'Vehicle model')
    if not model then return false, modelErr end

    TriggerClientEvent('snipz_adminmenu:client:vehicle', source, {
        type = 'spawn',
        model = normalizedModel(model),
        plate = cleanText(data.plate, 8),
        fuelResource = Config.Integrations.FuelResource,
        keysEvent = Config.Integrations.VehicleKeysEvent,
        keysResource = Config.Integrations.VehicleKeysResource
    })

    logAction(source, 'Spawn Vehicle', actorName(source), model)
    return true, 'Vehicle spawned.'
end

handlers['vehicle.spawnForPlayer'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    local model, modelErr = configuredValueOrError(Config.Vehicles or {}, data.model, { 'model', 'name' }, 'model', 'Vehicle model')
    if not model then return false, modelErr end

    TriggerClientEvent('snipz_adminmenu:client:vehicle', target, {
        type = 'spawn',
        model = normalizedModel(model),
        plate = cleanText(data.plate, 8),
        fuelResource = Config.Integrations.FuelResource,
        keysEvent = Config.Integrations.VehicleKeysEvent,
        keysResource = Config.Integrations.VehicleKeysResource
    })

    logAction(source, 'Spawn Vehicle For Player', actorName(target), model)
    return true, 'Vehicle spawned for player.'
end

local function generatedPlate(prefix)
    prefix = cleanText(prefix or 'ADM', 3):upper()
    if prefix == '' then prefix = 'ADM' end
    return ('%s%05d'):format(prefix, math.random(0, 99999)):sub(1, 8)
end

handlers['vehicle.giveOwned'] = function(source, data)
    local target, err = targetOrError(data)
    if not target then return false, err end

    if not resourceStarted('qbx_vehicles') then
        return false, 'qbx_vehicles is not started.'
    end

    local playerData = getPlayerData(target)
    local citizenid = cleanText(playerData.citizenid or playerData.citizenId, 80)
    if citizenid == '' then return false, 'Could not find target citizen ID.' end

    local model, modelErr = configuredValueOrError(Config.Vehicles or {}, data.model, { 'model', 'name' }, 'model', 'Vehicle model')
    if not model then return false, modelErr end
    model = normalizedModel(model)

    local plate = cleanText(data.plate, 15):gsub('^%s*(.-)%s*$', '%1'):upper()
    if plate == '' then plate = generatedPlate(data.prefix) end

    local existsOk, vehicleId = pcall(function()
        return exports.qbx_vehicles:GetVehicleIdByPlate(plate)
    end)

    if existsOk and vehicleId then
        return false, 'This plate is already owned.'
    end

    local adminCar = Config.AdminCar or {}
    local garage = cleanText(data.garage or adminCar.Garage, 50)
    if garage == '' then garage = nil end

    local props = {
        plate = plate,
        model = joaat(model),
        engineHealth = 1000.0,
        bodyHealth = 1000.0,
        fuelLevel = 100.0
    }

    local ok, idOrError, errorResult = pcall(function()
        return exports.qbx_vehicles:CreatePlayerVehicle({
            model = model,
            citizenid = citizenid,
            garage = garage,
            props = props
        })
    end)

    if not ok then
        print(('[%s] Give owned vehicle qbx_vehicles error: %s'):format(RESOURCE, idOrError))
        return false, 'Could not create owned vehicle.'
    end

    if not idOrError then
        local message = type(errorResult) == 'table' and errorResult.message or nil
        return false, message or 'Could not create owned vehicle.'
    end

    logAction(source, 'Give Owned Vehicle', actorName(target), ('%s [%s]'):format(model, plate))
    return true, ('Owned vehicle created. Plate: %s'):format(plate)
end

handlers['vehicle.admincar'] = function(source, data)
    data = type(data) == 'table' and data or {}

    if type(data.props) ~= 'table' then
        TriggerClientEvent('snipz_adminmenu:client:admincar', source)
        logAction(source, 'Admin Car Request', actorName(source), '')
        return true, 'Admin car save requested.'
    end

    if not resourceStarted('qbx_vehicles') then
        return false, 'qbx_vehicles is not started.'
    end

    local playerData = getPlayerData(source)
    local citizenid = cleanText(playerData.citizenid or playerData.citizenId, 80)
    if citizenid == '' then return false, 'Could not find your citizen ID.' end

    local serverVehicle = currentServerVehicleInfo(source)
    if not serverVehicle then return false, 'You must be inside the vehicle you want to save.' end
    if not serverVehicle.isDriver then return false, 'You must be driving the vehicle you want to save.' end

    local model, modelErr = configuredValueOrError(Config.Vehicles or {}, data.model, { 'model', 'name' }, 'model', 'Vehicle model')
    if not model then return false, modelErr end
    model = normalizedModel(model)

    local props = safePayload(type(data.props) == 'table' and data.props or {}, 0) or {}
    local plate = cleanText(data.plate or props.plate, 15):gsub('^%s*(.-)%s*$', '%1'):upper()
    if plate == '' then return false, 'Vehicle plate is required.' end
    if serverVehicle.plate ~= '' and normalizedPlate(plate) ~= serverVehicle.plate then
        return false, 'Vehicle plate no longer matches your current vehicle.'
    end

    local clientHash = tonumber(data.hash) or tonumber(props.model) or joaat(model)
    if serverVehicle.modelHash ~= 0 and tonumber(clientHash) ~= serverVehicle.modelHash then
        return false, 'Vehicle model no longer matches your current vehicle.'
    end

    local existsOk, vehicleId = pcall(function()
        return exports.qbx_vehicles:GetVehicleIdByPlate(plate)
    end)

    if existsOk and vehicleId then
        return false, 'This vehicle is already owned.'
    end

    props.plate = plate
    props.model = serverVehicle.modelHash ~= 0 and serverVehicle.modelHash or clientHash
    props.engineHealth = tonumber(props.engineHealth) or 1000.0
    props.bodyHealth = tonumber(props.bodyHealth) or 1000.0
    props.fuelLevel = tonumber(props.fuelLevel) or 100.0

    local adminCar = Config.AdminCar or {}
    local garage = cleanText(adminCar.Garage, 50)
    if garage == '' then garage = nil end

    local ok, idOrError, errorResult = pcall(function()
        return exports.qbx_vehicles:CreatePlayerVehicle({
            model = model,
            citizenid = citizenid,
            garage = garage,
            props = props
        })
    end)

    if not ok then
        print(('[%s] Admincar qbx_vehicles error: %s'):format(RESOURCE, idOrError))
        return false, 'Could not save vehicle.'
    end

    if not idOrError then
        local message = type(errorResult) == 'table' and errorResult.message or nil
        return false, message or 'Could not save vehicle.'
    end

    logAction(source, 'Admin Car', actorName(source), ('%s [%s]'):format(model, plate))
    return true, ('Vehicle saved to you. Plate: %s'):format(plate)
end

handlers['vehicle.repair'] = function(source, data)
    local target, err = targetOrSelf(source, data)
    if not target then return false, err end

    TriggerClientEvent('snipz_adminmenu:client:vehicle', target, { type = 'repair' })
    logAction(source, 'Repair Vehicle', actorName(target), '')
    return true, 'Vehicle repaired.'
end

handlers['vehicle.flip'] = function(source, data)
    local target, err = targetOrSelf(source, data)
    if not target then return false, err end

    TriggerClientEvent('snipz_adminmenu:client:vehicle', target, { type = 'flip' })
    logAction(source, 'Flip Vehicle', actorName(target), '')
    return true, 'Vehicle flipped.'
end

handlers['vehicle.delete'] = function(source, data)
    local target, err = targetOrSelf(source, data)
    if not target then return false, err end

    TriggerClientEvent('snipz_adminmenu:client:vehicle', target, { type = 'delete' })
    logAction(source, 'Delete Vehicle', actorName(target), '')
    return true, 'Vehicle deleted.'
end

handlers['vehicle.keys'] = function(source, data)
    local target, err = targetOrSelf(source, data)
    if not target then return false, err end

    TriggerClientEvent('snipz_adminmenu:client:vehicle', target, {
        type = 'keys',
        keysEvent = Config.Integrations.VehicleKeysEvent,
        keysResource = Config.Integrations.VehicleKeysResource
    })

    logAction(source, 'Give Vehicle Keys', actorName(target), '')
    return true, 'Vehicle keys triggered.'
end

handlers['vehicle.refuel'] = function(source, data)
    local target, err = targetOrSelf(source, data)
    if not target then return false, err end

    TriggerClientEvent('snipz_adminmenu:client:vehicle', target, {
        type = 'refuel',
        fuelResource = Config.Integrations.FuelResource
    })

    logAction(source, 'Refuel Vehicle', actorName(target), '')
    return true, 'Vehicle refueled.'
end

handlers['vehicle.clean'] = function(source, data)
    local target, err = targetOrSelf(source, data)
    if not target then return false, err end

    TriggerClientEvent('snipz_adminmenu:client:vehicle', target, { type = 'clean' })
    logAction(source, 'Clean Vehicle', actorName(target), '')
    return true, 'Vehicle cleaned.'
end

handlers['vehicle.impound'] = function(source, data)
    local target, err = targetOrSelf(source, data)
    if not target then return false, err end

    TriggerClientEvent('snipz_adminmenu:client:vehicle', target, { type = 'delete' })
    logAction(source, 'Impound Vehicle', actorName(target), '')
    return true, 'Vehicle impounded.'
end

handlers['vehicle.maxMods'] = function(source, data)
    local target, err = targetOrSelf(source, data)
    if not target then return false, err end

    TriggerClientEvent('snipz_adminmenu:client:vehicle', target, { type = 'maxMods' })
    logAction(source, 'Max Vehicle Mods', actorName(target), '')
    return true, 'Vehicle upgraded.'
end

handlers['vehicle.customize'] = function(source)
    if Config.Integrations.MechanicResource and not resourceStarted(Config.Integrations.MechanicResource) then
        return false, 'Mechanic resource is not started.'
    end

    TriggerClientEvent('snipz_adminmenu:client:vehicle', source, {
        type = 'customize',
        mechanicEvent = Config.Integrations.MechanicCustomisationEvent,
        mechanicId = Config.Integrations.MechanicCustomisationId,
        mechanicLabel = Config.Integrations.MechanicCustomisationLabel
    })

    logAction(source, 'Open Mechanic Customization', actorName(source), Config.Integrations.MechanicCustomisationId or '')
    return true, 'Mechanic customization opened.'
end

handlers['self.noclip'] = function(source)
    TriggerClientEvent('snipz_adminmenu:client:toggleNoclip', source)
    logAction(source, 'Noclip Toggle', actorName(source), '')
    return true, 'Noclip toggled.'
end

handlers['self.godmode'] = function(source)
    TriggerClientEvent('snipz_adminmenu:client:toggleGodmode', source)
    logAction(source, 'Godmode Toggle', actorName(source), '')
    return true, 'Godmode toggled.'
end

handlers['self.invisible'] = function(source)
    TriggerClientEvent('snipz_adminmenu:client:toggleInvisible', source)
    logAction(source, 'Invisible Toggle', actorName(source), '')
    return true, 'Invisibility toggled.'
end

handlers['self.blips'] = function(source)
    TriggerClientEvent('snipz_adminmenu:client:toggleBlips', source)
    logAction(source, 'Blips Toggle', actorName(source), '')
    return true, 'Player blips toggled.'
end

handlers['server.weather'] = function(source, data)
    local weather = cleanText(data.weather, 40):upper()
    if weather == '' then return false, 'Weather is required.' end
    if not weatherAllowed(weather) then return false, 'Weather type is not configured.' end

    currentWeather = weather
    local synced = setSyncedWeather(weather)
    if not synced then
        TriggerClientEvent('snipz_adminmenu:client:setWeather', -1, weather)
    end
    executeConfiguredCommand(Config.Weather.ExecuteWeatherCommand, weather)
    logAction(source, 'Set Weather', 'Server', weather)
    return true, 'Weather updated.'
end

handlers['server.time'] = function(source, data)
    local hour = clamp(data.hour, 0, 23)
    local minute = clamp(data.minute, 0, 59)

    currentTime = { hour = hour, minute = minute }
    local synced = setSyncedTime(hour, minute)
    if not synced then
        TriggerClientEvent('snipz_adminmenu:client:setTime', -1, currentTime)
    end
    executeConfiguredCommand(Config.Weather.ExecuteTimeCommand, hour, minute)
    logAction(source, 'Set Time', 'Server', ('%02d:%02d'):format(hour, minute))
    return true, 'Time updated.'
end

handlers['server.blackout'] = function(source, data)
    local state = data.state == true
    setSyncedBlackout(state)
    logAction(source, 'Blackout', 'Server', state and 'Enabled' or 'Disabled')
    return true, state and 'Blackout enabled.' or 'Blackout disabled.'
end

handlers['server.reviveAll'] = function(source)
    local revived = 0
    for _, value in ipairs(GetPlayers()) do
        local target = tonumber(value)
        if target and GetPlayerName(target) then
            reviveTarget(target)
            revived = revived + 1
        end
    end

    logAction(source, 'Revive All', ('%s players'):format(revived), '')
    return true, ('Revived %s players.'):format(revived)
end

handlers['console.execute'] = function(source, data)
    if Config.Console.Enabled ~= true then return false, 'Console is disabled.' end

    local command, commandErr = safeConsoleCommand(data.command)
    if not command then return false, commandErr end
    if not consoleCommandAllowed(source, command) then
        logConsole('warn', ('Denied command from %s: %s'):format(actorName(source), command), 'console')
        return false, 'That command is not allowlisted.'
    end

    logConsole('command', ('%s executed: %s'):format(actorName(source), command), 'console')
    ExecuteCommand(command)
    logAction(source, 'Console Command', 'Server', command)
    logConsole('success', ('Command dispatched: %s'):format(command), 'console')
    return true, 'Command executed.'
end

handlers['event.trigger'] = function(source, data)
    local eventName = cleanText(data.eventName or data.name, 120)
    local allowedEvent

    for _, event in ipairs(Config.AllowedEvents or {}) do
        if event.name == eventName then
            allowedEvent = event
            break
        end
    end

    if not allowedEvent then return false, 'Event is not allowlisted.' end

    local payload = allowedEvent.payload or {}
    local customPayloadAllowed = allowedEvent.allowClientPayload == true
        or allowedEvent.AllowClientPayload == true
        or (securityValue('AllowCustomEventPayloads', false) == true and allowedEvent.allowClientPayload ~= false)

    if customPayloadAllowed then
        payload = data.payload or payload
    end

    if type(payload) == 'string' then
        local ok, decoded = pcall(json.decode, payload)
        payload = ok and type(decoded) == 'table' and decoded or {}
    elseif type(payload) ~= 'table' then
        payload = {}
    end
    payload = safePayload(payload, 0) or {}

    local detail = eventName
    if allowedEvent.type == 'client' then
        local target = tonumber(data.target) or -1
        if target ~= -1 and not GetPlayerName(target) then
            return false, 'Event target is no longer online.'
        end
        TriggerClientEvent(eventName, target, payload)
        detail = ('%s -> target %s'):format(eventName, target)
    elseif allowedEvent.type == 'server' or not allowedEvent.type then
        TriggerEvent(eventName, source, payload)
        detail = ('%s -> server'):format(eventName)
    else
        return false, 'Event type is invalid.'
    end

    logAction(source, 'Trigger Event', allowedEvent.label or eventName, detail)
    logConsole('event', ('%s triggered %s'):format(actorName(source), detail), 'events')
    return true, 'Event triggered.'
end

local function handleAction(source, data)
    if type(data) ~= 'table' then return end
    if source == 0 then return end
    data = safePayload(data, 0) or {}

    local action = cleanText(data.action, 80)
    local permission = actionPermissions[action] or 'menu'

    if not hasPermission(source, permission) then
        sendResult(source, false, Config.Ace.DenyMessage, 'error')
        logAction(source, 'Denied', action, aceObject(permission))
        return
    end

    local handler = handlers[action]
    if not handler then
        sendResult(source, false, 'Unknown action.', 'error')
        return
    end

    local selfTargetReason = selfTargetDeniedReason(source, action, data)
    if selfTargetReason then
        sendResult(source, false, selfTargetReason, 'warning')
        logAction(source, 'Blocked Self Target', action, selfTargetReason)
        return
    end

    if not rateLimitExemptActions[action] and rateLimited(source) then
        sendResult(source, false, 'Slow down before running another action.', 'warning')
        return
    end

    local ok, success, message, resultType = pcall(handler, source, data)
    if not ok then
        print(('[%s] Action error in %s: %s'):format(RESOURCE, action, success))
        sendResult(source, false, 'Action failed on the server.', 'error')
        return
    end

    local successState = success ~= false
    local resultMessage = message or (successState and 'Action completed.' or 'Action failed.')

    if action ~= 'announce' or not successState then
        sendResult(source, successState, resultMessage, resultType)
    end
    sendSnapshot(source)
end

RegisterNetEvent('snipz_adminmenu:server:controlInput', function(payload)
    local source = source
    local target = controlSessions[source]
    if not target or not GetPlayerName(target) or type(payload) ~= 'table' then return end
    if not hasPermission(source, 'spectate') then
        controlSessions[source] = nil
        TriggerClientEvent('snipz_adminmenu:client:controlStop', source)
        return
    end

    local current = GetGameTimer()
    local minInterval = math.max(25, tonumber(securityValue('ControlInputCooldown', 45)) or 45)
    if lastControlInput[source] and current - lastControlInput[source] < minInterval then return end
    lastControlInput[source] = current

    local input = {
        x = math.max(-8.0, math.min(8.0, tonumber(payload.x) or 0.0)),
        y = math.max(-8.0, math.min(8.0, tonumber(payload.y) or 0.0)),
        z = math.max(-8.0, math.min(8.0, tonumber(payload.z) or 0.0)),
        h = tonumber(payload.h) or 0.0
    }

    TriggerClientEvent('snipz_adminmenu:client:controlInput', target, source, input)
end)

RegisterNetEvent('snipz_adminmenu:server:controlStop', function()
    local source = source
    local target = controlSessions[source]
    if target and GetPlayerName(target) then
        TriggerClientEvent('snipz_adminmenu:client:controlledState', target, source, false)
    end

    controlSessions[source] = nil
    lastControlInput[source] = nil
    TriggerClientEvent('snipz_adminmenu:client:controlStop', source)
end)

local allowedInitialViews = {
    home = true,
    players = true,
    monitoring = true,
    moderation = true,
    chats = true,
    items = true,
    vehicles = true,
    coords = true,
    console = true,
    events = true,
    staff = true,
    blips = true,
    settings = true
}

local function openMenu(source, options)
    if not hasPermission(source, 'menu') then
        notify(source, Config.Ace.DenyMessage, 'error')
        logAction(source, 'Denied Open', actorName(source), aceObject('menu'))
        return
    end

    sendChatSuggestions(source)
    local snapshot = buildSnapshot(source)
    if type(options) == 'table' and allowedInitialViews[options.view] then
        snapshot.initialView = options.view
    end

    TriggerClientEvent('snipz_adminmenu:client:open', source, snapshot)
end

local function openCoordFinder(source)
    if not hasPermission(source, 'menu') then
        notify(source, Config.Ace.DenyMessage, 'error')
        logAction(source, 'Denied Coord Finder', actorName(source), aceObject('menu'))
        return
    end

    sendChatSuggestions(source)
    TriggerClientEvent('snipz_adminmenu:client:coordFinder', source)
end

RegisterNetEvent('snipz_adminmenu:server:open', function(options)
    openMenu(source, options)
end)

RegisterNetEvent('snipz_adminmenu:server:coordFinder', function()
    openCoordFinder(source)
end)

RegisterNetEvent('snipz_adminmenu:server:requestSnapshot', function()
    local source = source

    if not hasPermission(source, 'menu') then
        notify(source, Config.Ace.DenyMessage, 'error')
        return
    end

    local current = GetGameTimer()
    local minInterval = math.max(500, tonumber(securityValue('SnapshotCooldown', 1000)) or 1000)
    if lastSnapshotRequest[source] and current - lastSnapshotRequest[source] < minInterval then
        return
    end
    lastSnapshotRequest[source] = current

    sendSnapshot(source)
end)

RegisterNetEvent('snipz_adminmenu:server:requestRemoteFeed', function(targets)
    local source = source
    local config = Config.RemoteFeed or {}

    if config.Enabled ~= true then return end
    if not hasPermission(source, 'spectate') then
        notify(source, Config.Ace.DenyMessage, 'error')
        return
    end
    if type(targets) ~= 'table' then return end

    local interval = math.max(1500, tonumber(config.RefreshInterval) or 3500)
    local maxPlayers = math.max(1, math.min(12, tonumber(config.MaxPlayers) or 8))
    local nowMs = GetGameTimer()
    if lastRemoteFeedRequest[source] and nowMs - lastRemoteFeedRequest[source] < math.floor(interval * 0.75) then
        local seen = {}
        local skipped = 0
        for _, value in ipairs(targets) do
            local target = tonumber(value)
            if target and target ~= source and not seen[target] and GetPlayerName(target) then
                seen[target] = true
                skipped = skipped + 1
                TriggerClientEvent('snipz_adminmenu:client:remoteFeedFrame', source, {
                    target = target
                })
            end

            if skipped >= maxPlayers then
                break
            end
        end
        return
    end
    lastRemoteFeedRequest[source] = nowMs

    local resourceName = config.Resource or 'screenshot-basic'
    local captureResource = nil
    local resourceCandidates = {}
    if resourceName == 'screenshot-basic' then
        resourceCandidates[#resourceCandidates + 1] = 'screencapture'
        resourceCandidates[#resourceCandidates + 1] = 'screenshot-basic'
    else
        resourceCandidates[#resourceCandidates + 1] = resourceName
        resourceCandidates[#resourceCandidates + 1] = 'screenshot-basic'
        resourceCandidates[#resourceCandidates + 1] = 'screencapture'
    end
    local checkedResources = {}
    for _, candidate in ipairs(resourceCandidates) do
        if candidate and candidate ~= '' and not checkedResources[candidate] then
            checkedResources[candidate] = true
            if resourceStarted(candidate) then
                captureResource = candidate
                break
            end
        end
    end

    local encoding = cleanText(config.Encoding or 'jpg', 8)
    local quality = tonumber(config.Quality) or 0.35
    if quality <= 0.0 or quality > 1.0 then quality = 0.35 end

    local seen = {}
    local requested = 0
    for _, value in ipairs(targets) do
        local target = tonumber(value)
        if target and target ~= source and not seen[target] and GetPlayerName(target) then
            seen[target] = true
            requested = requested + 1

            if not captureResource then
                TriggerClientEvent('snipz_adminmenu:client:remoteFeedFrame', source, {
                    target = target,
                    error = ('%s is not started.'):format(resourceName)
                })
            else
                local ok, err = pcall(function()
                    exports[captureResource]:requestClientScreenshot(target, {
                        encoding = encoding,
                        quality = quality
                    }, function(first, second)
                        if not GetPlayerName(source) then return end

                        local errorMessage, imageData = normalizeCaptureCallback(first, second)
                        if errorMessage or not imageData or imageData == '' then
                            TriggerClientEvent('snipz_adminmenu:client:remoteFeedFrame', source, {
                                target = target,
                                error = cleanText(errorMessage or 'No frame returned.', 160)
                            })
                            return
                        end

                        local image = tostring(imageData)
                        if not image:find('^data:', 1) and not image:find('^https?://', 1) then
                            local mime = encoding == 'png' and 'png' or 'jpeg'
                            image = ('data:image/%s;base64,%s'):format(mime, image)
                        end

                        TriggerClientEvent('snipz_adminmenu:client:remoteFeedFrame', source, {
                            target = target,
                            image = image,
                            capturedAt = os.time()
                        })
                    end)
                end)

                if not ok then
                    TriggerClientEvent('snipz_adminmenu:client:remoteFeedFrame', source, {
                        target = target,
                        error = cleanText(err, 160)
                    })
                end
            end
        end

        if requested >= maxPlayers then
            break
        end
    end
end)

RegisterNetEvent('snipz_adminmenu:server:adminAction', function(data)
    handleAction(source, data)
end)

AddEventHandler('snipz_adminmenu:server:consoleLog', function(level, message, sourceName)
    logConsole(level, message, sourceName)
end)

exports('AddConsoleLog', function(level, message, sourceName)
    logConsole(level, message, sourceName)
end)

RegisterCommand(Config.Command, function(source)
    if source == 0 then
        print(('Use /%s in-game.'):format(Config.Command))
        return
    end

    openMenu(source)
end, false)

RegisterCommand(Config.CoordFinderCommand or 'coordfinder', function(source)
    if source == 0 then
        print(('Use /%s in-game.'):format(Config.CoordFinderCommand or 'coordfinder'))
        return
    end

    openCoordFinder(source)
end, false)

local chatSuggestionRefreshCommand = normalizedChatCommand((Config.ChatSuggestions or {}).RefreshCommand or 'adminsuggestions')
if chatSuggestionRefreshCommand ~= '' then
    RegisterCommand(chatSuggestionRefreshCommand, function(source)
        if source == 0 then
            print(('[%s] Refreshed chat autocomplete suggestions for online players.'):format(RESOURCE))
            refreshChatSuggestionsForAll()
            return
        end

        sendChatSuggestions(source)
        notify(source, 'Chat autocomplete refreshed.', 'success')
    end, false)
end

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local source = source
    deferrals.defer()
    Wait(0)

    local identifiers = GetPlayerIdentifiers(source)
    local banId, ban = findBanForIdentifiers(identifiers)

    if ban then
        ban.id = ban.id or banId
        deferrals.done(getBanMessage(ban))
        return
    end

    deferrals.done()
end)

AddEventHandler('playerJoining', function()
    local source = source
    CreateThread(function()
        Wait(3500)
        if GetPlayerName(source) then
            sendChatSuggestions(source)
        end
    end)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if shouldRefreshForChatResource(resourceName) then
        refreshChatSuggestionsForAll()
    end
end)

AddEventHandler('txAdmin:events:adminAuth', function(data)
    if type(data) ~= 'table' then return end

    local source = tonumber(data.netid or data.source or data.id)
    if not source then return end

    if source == -1 then
        txAdminAdmins = {}
        return
    end

    if data.isAdmin == true then
        txAdminAdmins[source] = data.username or true
        sendChatSuggestions(source)
    else
        txAdminAdmins[source] = nil
    end
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    duty[source] = nil
    txAdminAdmins[source] = nil
    returnCoords[source] = nil
    chatMuted[source] = nil
    escortSessions[source] = nil
    lastRemoteFeedRequest[source] = nil
    lastSnapshotRequest[source] = nil
    lastAction[source] = nil
    lastControlInput[source] = nil

    for target, admin in pairs(escortSessions) do
        if admin == source or target == source then
            escortSessions[target] = nil
            if GetPlayerName(target) then
                TriggerClientEvent('snipz_adminmenu:client:escort', target, source, false)
            end
        end
    end

    local controlledTarget = controlSessions[source]
    if controlledTarget and GetPlayerName(controlledTarget) then
        TriggerClientEvent('snipz_adminmenu:client:controlledState', controlledTarget, source, false)
    end
    controlSessions[source] = nil

    for admin, target in pairs(controlSessions) do
        if target == source then
            controlSessions[admin] = nil
            if GetPlayerName(admin) then
                TriggerClientEvent('snipz_adminmenu:client:controlStop', admin)
            end
        end
    end

    logAction(source, 'Player Dropped', actorName(source), cleanText(reason, 120))
end)

AddEventHandler('chatMessage', function(source, name, message)
    if chatMuted[source] then
        CancelEvent()
        notify(source, 'You are chat-muted by staff.', 'warning')
        return
    end

    pushLimited(chatLogs, {
        time = now(),
        source = source,
        name = name,
        message = cleanText(message, 220)
    }, 100)
end)

CreateThread(function()
    bans = loadJsonFile(Config.Security.BanFile, {})
    warnings = loadJsonFile(Config.Security.WarningsFile, {})
    notes = loadJsonFile(Config.Security.NotesFile, {})
    staffTags = loadJsonFile(Config.Security.StaffTagsFile, {})
    math.randomseed(GetGameTimer() + os.time())

    print(('[%s] Loaded. ACE root: %s'):format(RESOURCE, Config.Ace.Root))
    logConsole('info', ('Loaded. ACE root: %s'):format(Config.Ace.Root), RESOURCE)

    refreshChatSuggestionsForAll()
end)

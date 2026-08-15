local menuOpen = false
local latestSnapshot = nil
local frozen = false
local noclip = false
local godmode = false
local invisible = false
local noclipForcedGodmode = false
local noclipForcedInvisible = false
local noclipLandingGodmode = false
local noclipLandingGodmodeStartedAt = 0
local noclipSpeedIndex = 2
local noclipSpeeds = { 0.45, 1.35, 3.0, 6.0, 12.0, 24.0 }
local noclipGhostAlpha = 145
local noclipGhostVehicle = 0
local noclipPosition = nil
local noclipEntity = 0
local noclipCamera = 0
local noclipCameraYaw = 0.0
local noclipCameraPitch = -10.0
local noclipPitchMin = -89.0
local noclipPitchMax = 89.0
local noclipLookSensitivity = 8.0
local noclipCameraDistance = 4.75
local godmodeVehicle = 0
local showingBlips = false
local playerBlips = {}
local spectating = false
local spectateTargetServerId = nil
local spectateReturnCoords = nil
local spectateRequestId = 0
local controlMode = false
local controlTargetServerId = nil
local controlStarting = false
local controlledByServerId = nil
local lastControlSendAt = 0
local lastControlledInputAt = 0
local adminCuffed = false
local frozenEntity = 0
local coordLaser = false
local voiceMuted = false
local escortedByServerId = nil
local spawnedVehicles = {}

local function sendNui(action, payload)
    SendNUIMessage({
        action = action,
        payload = payload or {}
    })
end

local function sendModeState()
    sendNui('modeState', {
        noclip = noclip == true,
        godmode = godmode == true,
        invisible = invisible == true,
        noclipSpeed = noclipSpeedIndex,
        noclipSpeedValue = noclipSpeeds[noclipSpeedIndex] or noclipSpeeds[2],
        control = controlMode == true,
        controlTarget = controlTargetServerId,
        controlledBy = controlledByServerId
    })
end

local function gameNotify(message, notifyType)
    message = tostring(message or '')
    if message == '' then return end

    if lib and lib.notify then
        lib.notify({
            description = message,
            type = notifyType or 'inform'
        })
        return
    end

    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(false, false)
end

local function snapshotPlayer(serverId)
    serverId = tonumber(serverId)
    local players = latestSnapshot and latestSnapshot.players
    if not serverId or type(players) ~= 'table' then return nil end

    for _, player in ipairs(players) do
        if tonumber(player.id) == serverId then
            return player
        end
    end

    return nil
end

local function nuiToast(message, toastType)
    if not menuOpen then
        gameNotify(message, toastType)
        return
    end

    sendNui('toast', {
        message = message,
        type = toastType or 'inform'
    })
end

local function closeMenu(stopCoordLaser, skipFocusThread)
    menuOpen = false
    if stopCoordLaser then
        coordLaser = false
        sendNui('coordOverlay', {
            active = false
        })
    elseif coordLaser then
        sendNui('coordOverlay', {
            active = true
        })
    end
    SetNuiFocusKeepInput(false)
    SetNuiFocus(false, false)
    sendNui('close')

    if not skipFocusThread then
        CreateThread(function()
            Wait(50)
            SetNuiFocusKeepInput(false)
            SetNuiFocus(false, false)
        end)
    end
end

local function requestControl(entity, timeout)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return false end

    timeout = timeout or 750
    local expires = GetGameTimer() + timeout

    NetworkRequestControlOfEntity(entity)
    while DoesEntityExist(entity) and not NetworkHasControlOfEntity(entity) and GetGameTimer() < expires do
        NetworkRequestControlOfEntity(entity)
        Wait(0)
    end

    return DoesEntityExist(entity) and NetworkHasControlOfEntity(entity)
end

local function resourceStarted(resourceName)
    return type(resourceName) == 'string' and resourceName ~= '' and GetResourceState(resourceName) == 'started'
end

local function txAdminBridgeEnabled()
    local bridge = Config.PermissionBridge or {}
    local txAdmin = bridge.TxAdmin or {}
    return bridge.Enabled ~= false and txAdmin.Enabled ~= false
end

CreateThread(function()
    Wait(2500)
    if txAdminBridgeEnabled() then
        TriggerServerEvent('txsv:checkIfAdmin')
    end
end)

local function loadModel(model)
    if type(model) ~= 'string' and type(model) ~= 'number' then return nil end
    local hash = type(model) == 'number' and model or joaat(model)
    if not IsModelInCdimage(hash) then return nil end

    RequestModel(hash)
    local expires = GetGameTimer() + 5000
    while not HasModelLoaded(hash) and GetGameTimer() < expires do
        Wait(0)
    end

    if not HasModelLoaded(hash) then return nil end
    return hash
end

local function currentVehicle()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        if vehicle ~= 0 and DoesEntityExist(vehicle) then return vehicle end
    end

    return 0
end

local function currentPlayerEntity()
    local ped = PlayerPedId()
    local vehicle = currentVehicle()
    return vehicle ~= 0 and vehicle or ped
end

local function entityHasTouchedGround(entity)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return true end
    if IsEntityInWater(entity) then return true end
    if IsEntityInAir(entity) then return false end

    return GetEntityHeightAboveGround(entity) <= 1.25
end

local function settleEntityOnGround(entity, forceGround)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return end

    local coords = GetEntityCoords(entity)
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)

    local timeout = GetGameTimer() + 2000
    while not HasCollisionLoadedAroundEntity(entity) and GetGameTimer() < timeout do
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        Wait(50)
    end

    coords = GetEntityCoords(entity)
    local found, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z + 1000.0, false)
    if found and (forceGround or coords.z < groundZ + 0.75) then
        SetEntityCoordsNoOffset(entity, coords.x, coords.y, groundZ + 1.0, false, false, false)
    end

    SetEntityVelocity(entity, 0.0, 0.0, 0.0)
end

local function applyGodmodeState(state)
    local ped = PlayerPedId()
    local vehicle = currentVehicle()

    SetEntityInvincible(ped, state)
    SetPlayerInvincible(PlayerId(), state)
    SetEntityCanBeDamaged(ped, not state)
    SetPedCanRagdoll(ped, not state)
    SetPedDiesWhenInjured(ped, not state)
    SetEntityProofs(ped, state, state, state, state, state, state, state, state)

    if state then
        SetEntityHealth(ped, GetEntityMaxHealth(ped))
        ClearPedBloodDamage(ped)
    end

    if vehicle ~= 0 and DoesEntityExist(vehicle) then
        SetEntityInvincible(vehicle, state)
        SetEntityCanBeDamaged(vehicle, not state)
        SetEntityProofs(vehicle, state, state, state, state, state, state, state, state)
    end

    if godmodeVehicle ~= 0 and godmodeVehicle ~= vehicle and DoesEntityExist(godmodeVehicle) then
        SetEntityInvincible(godmodeVehicle, false)
        SetEntityCanBeDamaged(godmodeVehicle, true)
        SetEntityProofs(godmodeVehicle, false, false, false, false, false, false, false, false)
    end

    godmodeVehicle = state and vehicle or 0
end

local function releaseControlledState(skipSettle)
    controlledByServerId = nil

    local ped = PlayerPedId()
    local vehicle = currentVehicle()
    local entity = vehicle ~= 0 and vehicle or ped

    FreezeEntityPosition(ped, false)
    if vehicle ~= 0 then
        FreezeEntityPosition(vehicle, false)
    end

    if not skipSettle then
        settleEntityOnGround(entity)
    end
    SetPlayerControl(PlayerId(), true, 0)
end

local function releaseFrozenState()
    if frozenEntity ~= 0 and DoesEntityExist(frozenEntity) then
        FreezeEntityPosition(frozenEntity, false)
    end

    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)

    local vehicle = currentVehicle()
    if vehicle ~= 0 then
        FreezeEntityPosition(vehicle, false)
    end

    frozen = false
    frozenEntity = 0
end

local function closestVehicle(radius)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local closest = 0
    local closestDistance = radius or 7.0

    for _, vehicle in ipairs(GetGamePool('CVehicle')) do
        local distance = #(coords - GetEntityCoords(vehicle))
        if distance < closestDistance then
            closest = vehicle
            closestDistance = distance
        end
    end

    return closest
end

local function teleportTo(coords)
    if type(coords) ~= 'table' then return end

    local x = tonumber(coords.x)
    local y = tonumber(coords.y)
    local z = tonumber(coords.z)
    local h = tonumber(coords.h) or 0.0
    if not x or not y or not z then return end

    local ped = PlayerPedId()
    local entity = IsPedInAnyVehicle(ped, false) and GetVehiclePedIsIn(ped, false) or ped

    RequestCollisionAtCoord(x, y, z)

    local found, groundZ = GetGroundZFor_3dCoord(x, y, z + 1000.0, false)
    if found then z = groundZ + 1.0 end

    SetEntityCoordsNoOffset(entity, x, y, z, false, false, false)
    SetEntityHeading(entity, h)

    local timeout = GetGameTimer() + 2500
    while not HasCollisionLoadedAroundEntity(entity) and GetGameTimer() < timeout do
        RequestCollisionAtCoord(x, y, z)
        Wait(50)
    end

    found, groundZ = GetGroundZFor_3dCoord(x, y, z + 1000.0, false)
    if found then
        SetEntityCoordsNoOffset(entity, x, y, groundZ + 1.0, false, false, false)
    end
end

local function getStreamedPlayerPed(serverId)
    local targetClient = GetPlayerFromServerId(serverId)
    if targetClient == -1 or targetClient == PlayerId() then return 0 end

    local targetPed = GetPlayerPed(targetClient)
    if targetPed and targetPed ~= 0 and DoesEntityExist(targetPed) then
        return targetPed
    end

    return 0
end

local function revivePed(payload)
    payload = type(payload) == 'table' and payload or {}
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, GetEntityHeading(ped), true, false)
    ped = PlayerPedId()
    ClearPedBloodDamage(ped)
    ClearPedTasksImmediately(ped)
    ClearPlayerWantedLevel(PlayerId())
    SetEntityHealth(ped, GetEntityMaxHealth(ped))

    local reviveEvent = type(payload.reviveEvent) == 'string' and payload.reviveEvent or ''
    local healthResetEvent = type(payload.healthResetEvent) == 'string' and payload.healthResetEvent or ''

    if reviveEvent ~= '' then
        TriggerEvent(reviveEvent)
    end
    if healthResetEvent ~= '' and healthResetEvent ~= reviveEvent then
        TriggerEvent(healthResetEvent)
    end
end

local function resetHealthBuffer(data)
    data = type(data) == 'table' and data or {}
    local eventName = type(data.healthResetEvent) == 'string' and data.healthResetEvent or ''
    if eventName and eventName ~= '' then
        TriggerEvent(eventName)
    end
end

local function setVehicleFuel(vehicle, amount, resourceName)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return false end

    amount = tonumber(amount) or 100.0
    if not requestControl(vehicle) then return false end
    SetVehicleFuelLevel(vehicle, amount + 0.0)

    if resourceStarted(resourceName) then
        pcall(function()
            exports[resourceName]:SetFuel(vehicle, amount + 0.0)
        end)
    end

    pcall(function()
        Entity(vehicle).state.fuel = amount + 0.0
    end)

    return true
end

local function repairVehicle(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return false end
    if not requestControl(vehicle) then return false end
    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleDirtLevel(vehicle, 0.0)
    SetVehicleEngineHealth(vehicle, 1000.0)
    SetVehicleBodyHealth(vehicle, 1000.0)
    SetVehiclePetrolTankHealth(vehicle, 1000.0)
    SetVehicleEngineOn(vehicle, true, true, false)
    setVehicleFuel(vehicle, 100.0, Config.Integrations.FuelResource)
    return true
end

local function maxVehicleMods(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return false end

    if not requestControl(vehicle) then return false end
    SetVehicleModKit(vehicle, 0)

    for modType = 0, 49 do
        local maxMod = GetNumVehicleMods(vehicle, modType) - 1
        if maxMod >= 0 then
            SetVehicleMod(vehicle, modType, maxMod, false)
        end
    end

    for _, toggleType in ipairs({ 18, 20, 22 }) do
        ToggleVehicleMod(vehicle, toggleType, true)
    end

    SetVehicleWindowTint(vehicle, 1)
    SetVehicleDirtLevel(vehicle, 0.0)
    repairVehicle(vehicle)
    return true
end

local function giveKeysForVehicle(vehicle, eventName, resourceName)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return false end

    local plate = GetVehicleNumberPlateText(vehicle)
    eventName = type(eventName) == 'string' and eventName or ''
    resourceName = type(resourceName) == 'string' and resourceName or ''

    if resourceStarted(resourceName) then
        local ok, result = pcall(function()
            return exports[resourceName]:addKey(plate)
        end)
        if ok and result ~= false then return true end
    end

    if eventName and eventName ~= '' then
        TriggerEvent(eventName, plate, vehicle)
        return true
    end

    return false
end

local function flipVehicle(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return false end
    if not requestControl(vehicle) then return false end
    local coords = GetEntityCoords(vehicle)
    SetEntityCoords(vehicle, coords.x, coords.y, coords.z + 1.0, false, false, false, false)
    SetEntityRotation(vehicle, 0.0, 0.0, GetEntityHeading(vehicle), 2, true)
    SetVehicleOnGroundProperly(vehicle)
    return true
end

local function deleteVehicle(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return false end
    if not requestControl(vehicle) then return false end
    SetEntityAsMissionEntity(vehicle, true, true)
    DeleteVehicle(vehicle)
    if DoesEntityExist(vehicle) then
        DeleteEntity(vehicle)
    end
    return true
end

local function cleanVehicle(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return false end
    if not requestControl(vehicle) then return false end
    SetVehicleDirtLevel(vehicle, 0.0)
    WashDecalsFromVehicle(vehicle, 1.0)
    return true
end

local function seatInNearestVehicle()
    local ped = PlayerPedId()
    local vehicle = closestVehicle(8.0)
    if vehicle == 0 then
        nuiToast('No nearby vehicle found.', 'error')
        return
    end

    for seat = 0, GetVehicleMaxNumberOfPassengers(vehicle) - 1 do
        if IsVehicleSeatFree(vehicle, seat) then
            TaskWarpPedIntoVehicle(ped, vehicle, seat)
            return
        end
    end

    if IsVehicleSeatFree(vehicle, -1) then
        TaskWarpPedIntoVehicle(ped, vehicle, -1)
        return
    end

    nuiToast('No free vehicle seats found.', 'warning')
end

local function setEscortState(adminServerId, active)
    local ped = PlayerPedId()

    if active then
        local adminPlayer = GetPlayerFromServerId(tonumber(adminServerId) or -1)
        local adminPed = adminPlayer ~= -1 and GetPlayerPed(adminPlayer) or 0
        if adminPed == 0 or not DoesEntityExist(adminPed) then
            nuiToast('Escort failed because the staff member is not nearby.', 'warning')
            return
        end

        escortedByServerId = tonumber(adminServerId)
        AttachEntityToEntity(ped, adminPed, 11816, 0.38, 0.45, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
        nuiToast('You are being escorted by staff.', 'inform')
        return
    end

    if IsEntityAttached(ped) then
        DetachEntity(ped, true, false)
    end
    escortedByServerId = nil
    nuiToast('Escort stopped.', 'inform')
end

local function spawnVehicle(data)
    local model = data and type(data.model) == 'string' and data.model:sub(1, 80) or ''
    if not model or model == '' then return end

    local hash = loadModel(model)
    if not hash or not IsModelAVehicle(hash) then
        nuiToast('Vehicle model could not be loaded.', 'error')
        return
    end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local forward = GetEntityForwardVector(ped)
    local spawnCoords = coords + (forward * 4.0)
    local heading = GetEntityHeading(ped)
    local vehicle = CreateVehicle(hash, spawnCoords.x, spawnCoords.y, spawnCoords.z, heading, true, true)

    if not vehicle or vehicle == 0 then
        nuiToast('Vehicle could not be created.', 'error')
        return
    end

    SetEntityAsMissionEntity(vehicle, true, true)
    spawnedVehicles[#spawnedVehicles + 1] = vehicle

    local plate = data and type(data.plate) == 'string' and data.plate or ''
    if not plate or plate == '' then
        plate = ('ADM%04d'):format(math.random(0, 9999))
    end

    SetVehicleNumberPlateText(vehicle, plate:upper():sub(1, 8))
    SetVehicleOnGroundProperly(vehicle)
    SetVehicleEngineOn(vehicle, true, true, false)
    setVehicleFuel(vehicle, 100.0, data.fuelResource)
    SetPedIntoVehicle(ped, vehicle, -1)
    SetModelAsNoLongerNeeded(hash)

    giveKeysForVehicle(vehicle, data.keysEvent, data.keysResource)
end

local function trim(value)
    return tostring(value or ''):gsub('^%s*(.-)%s*$', '%1')
end

local function vehicleModelName(vehicle)
    local hash = GetEntityModel(vehicle)
    local model

    if resourceStarted('qbx_core') then
        local ok, vehicleData = pcall(function()
            return exports.qbx_core:GetVehiclesByHash(hash)
        end)

        if ok and type(vehicleData) == 'table' then
            model = vehicleData.model or vehicleData.name
        end
    end

    if not model or model == '' then
        local displayName = GetDisplayNameFromVehicleModel(hash)
        if displayName and displayName ~= '' and displayName ~= 'CARNOTFOUND' then
            model = displayName:lower()
        end
    end

    return model, hash
end

local function getVehicleProperties(vehicle)
    if lib and type(lib.getVehicleProperties) == 'function' then
        local ok, props = pcall(lib.getVehicleProperties, vehicle)
        if ok and type(props) == 'table' then
            return props
        end
    end

    local primary, secondary = GetVehicleColours(vehicle)
    local pearlescent, wheel = GetVehicleExtraColours(vehicle)

    return {
        model = GetEntityModel(vehicle),
        plate = trim(GetVehicleNumberPlateText(vehicle)),
        bodyHealth = GetVehicleBodyHealth(vehicle),
        engineHealth = GetVehicleEngineHealth(vehicle),
        tankHealth = GetVehiclePetrolTankHealth(vehicle),
        fuelLevel = GetVehicleFuelLevel(vehicle),
        dirtLevel = GetVehicleDirtLevel(vehicle),
        color1 = primary,
        color2 = secondary,
        pearlescentColor = pearlescent,
        wheelColor = wheel,
        livery = GetVehicleLivery(vehicle),
        windowTint = GetVehicleWindowTint(vehicle)
    }
end

local function saveAdminVehicle()
    local ped = PlayerPedId()
    local vehicle = currentVehicle()

    if vehicle == 0 then
        nuiToast('You need to be inside a vehicle to use admincar.', 'error')
        return
    end

    if GetPedInVehicleSeat(vehicle, -1) ~= ped then
        nuiToast('You need to be driving the vehicle to save it.', 'error')
        return
    end

    local model, hash = vehicleModelName(vehicle)
    if not model or model == '' then
        nuiToast('This vehicle model is not configured in qbx_core.', 'error')
        return
    end

    local props = getVehicleProperties(vehicle)
    props.plate = trim(props.plate or GetVehicleNumberPlateText(vehicle)):upper()
    props.model = hash

    TriggerServerEvent('snipz_adminmenu:server:adminAction', {
        action = 'vehicle.admincar',
        model = model,
        hash = hash,
        plate = props.plate,
        props = props
    })
end

local function giveVehicleKeys(eventName, resourceName)
    eventName = type(eventName) == 'string' and eventName or ''
    resourceName = type(resourceName) == 'string' and resourceName or ''

    if (not eventName or eventName == '') and (not resourceName or resourceName == '') then
        nuiToast('Vehicle key event is not configured.', 'warning')
        return
    end

    local vehicle = currentVehicle()
    if vehicle == 0 then vehicle = closestVehicle(8.0) end
    if vehicle == 0 then
        nuiToast('No nearby vehicle found.', 'error')
        return
    end

    if giveKeysForVehicle(vehicle, eventName, resourceName) then
        nuiToast('Vehicle keys granted.', 'success')
    else
        nuiToast('Vehicle keys could not be granted.', 'error')
    end
end

local function openMechanicCustomisation(data)
    local eventName = data and type(data.mechanicEvent) == 'string' and data.mechanicEvent or ''
    if not eventName or eventName == '' then
        nuiToast('Mechanic customisation event is not configured.', 'warning')
        return
    end

    local vehicle = currentVehicle()
    if vehicle == 0 then vehicle = closestVehicle(8.0) end
    if vehicle == 0 then
        nuiToast('No vehicle found.', 'error')
        return
    end

    closeMenu()
    local mechanicId = data and type(data.mechanicId) == 'string' and data.mechanicId or 'bennys'
    local mechanicLabel = data and type(data.mechanicLabel) == 'string' and data.mechanicLabel or mechanicId
    TriggerEvent(eventName, mechanicId, mechanicLabel)
end

local function setCuffedState(state)
    adminCuffed = state == true

    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped)
    SetEnableHandcuffs(ped, adminCuffed)
    SetPedCanPlayGestureAnims(ped, not adminCuffed)
    DisablePlayerFiring(PlayerId(), adminCuffed)

    if adminCuffed then
        SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
    end

    TriggerServerEvent('police:server:SetHandcuffStatus', adminCuffed)
    nuiToast(adminCuffed and 'You were cuffed by staff.' or 'You were uncuffed by staff.', 'inform')
end

local function clothingEventAvailable(eventName)
    if not eventName or eventName == '' then return false end

    if eventName:find('citgo_appearance', 1, true) then
        return resourceStarted('citgo_AppearanceV2') or resourceStarted('citgo_appearance')
    end

    if eventName:find('illenium%-appearance') then
        return resourceStarted('illenium-appearance')
    end

    return true
end

local function round(value, places)
    local multiplier = 10 ^ (places or 2)
    return math.floor((tonumber(value) or 0.0) * multiplier + 0.5) / multiplier
end

local function rotationToDirection(rotation)
    local adjusted = {
        x = math.rad(rotation.x),
        y = math.rad(rotation.y),
        z = math.rad(rotation.z)
    }
    local num = math.abs(math.cos(adjusted.x))

    return vector3(
        -math.sin(adjusted.z) * num,
        math.cos(adjusted.z) * num,
        math.sin(adjusted.x)
    )
end

local function cameraFlatDirections(rotation)
    local lookDirection = rotationToDirection(rotation)
    local forward = vector3(lookDirection.x, lookDirection.y, 0.0)
    local forwardLength = math.sqrt((forward.x * forward.x) + (forward.y * forward.y))

    if forwardLength > 0.0 then
        forward = vector3(forward.x / forwardLength, forward.y / forwardLength, 0.0)
    else
        forward = vector3(0.0, 1.0, 0.0)
    end

    return forward, vector3(forward.y, -forward.x, 0.0)
end

local function clamp(value, minValue, maxValue)
    return math.max(minValue, math.min(maxValue, value))
end

local function normalizeHeading(heading)
    heading = heading % 360.0
    if heading < 0.0 then heading = heading + 360.0 end
    return heading
end

local function startNoclipCamera()
    local rotation = GetGameplayCamRot(2)
    noclipCameraYaw = rotation.z
    noclipCameraPitch = clamp(rotation.x, noclipPitchMin, noclipPitchMax)

    if noclipCamera == 0 or not DoesCamExist(noclipCamera) then
        noclipCamera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end

    SetCamActive(noclipCamera, true)
    SetCamFov(noclipCamera, 60.0)
    RenderScriptCams(true, false, 0, true, true)
end

local function stopNoclipCamera(easeTime)
    easeTime = easeTime or 0
    RenderScriptCams(false, easeTime > 0, easeTime, true, true)

    if easeTime > 0 then
        Wait(easeTime)
    end

    if noclipCamera ~= 0 and DoesCamExist(noclipCamera) then
        DestroyCam(noclipCamera, false)
    end

    noclipCamera = 0
end

local function updateNoclipCamera(targetCoords, readInput)
    if noclipCamera == 0 or not DoesCamExist(noclipCamera) then
        startNoclipCamera()
    end

    if readInput ~= false then
        local lookX = GetDisabledControlNormal(0, 1)
        local lookY = GetDisabledControlNormal(0, 2)

        noclipCameraYaw = normalizeHeading(noclipCameraYaw - (lookX * noclipLookSensitivity))
        noclipCameraPitch = clamp(noclipCameraPitch - (lookY * noclipLookSensitivity), noclipPitchMin, noclipPitchMax)
    end

    local rotation = vector3(noclipCameraPitch, 0.0, noclipCameraYaw)
    local forward = rotationToDirection(rotation)
    local _, right = cameraFlatDirections(vector3(0.0, 0.0, noclipCameraYaw))
    local target = targetCoords + vector3(0.0, 0.0, 0.75)
    local cameraCoords = target - (forward * noclipCameraDistance)

    SetCamCoord(noclipCamera, cameraCoords.x, cameraCoords.y, cameraCoords.z)
    SetCamRot(noclipCamera, noclipCameraPitch, 0.0, noclipCameraYaw, 2)
    return forward, right
end

local function disableNoclipControls()
    DisableControlAction(0, 1, true)
    DisableControlAction(0, 2, true)
    DisableControlAction(0, 21, true)
    DisableControlAction(0, 30, true)
    DisableControlAction(0, 31, true)
    DisableControlAction(0, 32, true)
    DisableControlAction(0, 33, true)
    DisableControlAction(0, 34, true)
    DisableControlAction(0, 35, true)
    DisableControlAction(0, 38, true)
    DisableControlAction(0, 44, true)
    DisableControlAction(0, 59, true)
    DisableControlAction(0, 60, true)
    DisableControlAction(0, 61, true)
    DisableControlAction(0, 62, true)
    DisableControlAction(0, 63, true)
    DisableControlAction(0, 64, true)
    DisableControlAction(0, 71, true)
    DisableControlAction(0, 72, true)
    DisableControlAction(0, 75, true)
    DisableControlAction(0, 76, true)
end

local function controlHeld(control)
    return IsControlPressed(0, control) or IsDisabledControlPressed(0, control)
end

local function noclipDirection(forward, right)
    local movement = vector3(0.0, 0.0, 0.0)

    if controlHeld(32) then movement = movement + forward end
    if controlHeld(33) then movement = movement - forward end
    if controlHeld(35) then movement = movement + right end
    if controlHeld(34) then movement = movement - right end
    if controlHeld(38) then movement = movement + vector3(0.0, 0.0, 1.0) end
    if controlHeld(44) then movement = movement - vector3(0.0, 0.0, 1.0) end

    local length = math.sqrt((movement.x * movement.x) + (movement.y * movement.y) + (movement.z * movement.z))
    if length <= 0.0 then
        return vector3(0.0, 0.0, 0.0)
    end

    return vector3(movement.x / length, movement.y / length, movement.z / length)
end

local function cameraRaycast(distance)
    local cameraCoords = GetGameplayCamCoord()
    local rotation = GetGameplayCamRot(2)
    local direction = rotationToDirection(rotation)
    local destination = cameraCoords + (direction * (distance or 200.0))
    local ignoredEntity = currentPlayerEntity()
    local handle = StartShapeTestRay(
        cameraCoords.x,
        cameraCoords.y,
        cameraCoords.z,
        destination.x,
        destination.y,
        destination.z,
        -1,
        ignoredEntity,
        0
    )

    local status, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(handle)
    local attempts = 0
    while status == 1 and attempts < 4 do
        Wait(0)
        status, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(handle)
        attempts = attempts + 1
    end

    local didHit = hit == true or hit == 1

    if status ~= 2 or not didHit then
        endCoords = destination
        didHit = false
    end

    return {
        hit = didHit,
        coords = endCoords,
        normal = surfaceNormal,
        entity = entityHit or 0
    }
end

local function coordLaserOrigin()
    local ped = PlayerPedId()
    local vehicle = currentVehicle()

    if vehicle ~= 0 and DoesEntityExist(vehicle) then
        local coords = GetEntityCoords(vehicle)
        return vector3(coords.x, coords.y, coords.z + 0.9)
    end

    if ped ~= 0 and DoesEntityExist(ped) then
        local originMode = tostring(Config.CoordFinderLaserOrigin or 'body'):lower()
        if originMode == 'head' then
            return GetPedBoneCoords(ped, 31086, 0.0, 0.0, 0.02)
        end

        return GetPedBoneCoords(ped, 24818, 0.0, 0.0, 0.05)
    end

    local coords = GetEntityCoords(currentPlayerEntity())
    return vector3(coords.x, coords.y, coords.z + 0.75)
end

local function currentCoordToolPayload()
    local ped = PlayerPedId()
    local vehicle = currentVehicle()
    local entity = vehicle ~= 0 and vehicle or ped
    local coords = GetEntityCoords(entity)
    local heading = GetEntityHeading(entity)
    local camera = GetGameplayCamCoord()
    local cameraRotation = GetGameplayCamRot(2)
    local target = cameraRaycast(250.0)

    return {
        laser = coordLaser == true,
        player = {
            x = round(coords.x, 2),
            y = round(coords.y, 2),
            z = round(coords.z, 2),
            h = round(heading, 2),
            inVehicle = vehicle ~= 0
        },
        camera = {
            x = round(camera.x, 2),
            y = round(camera.y, 2),
            z = round(camera.z, 2),
            pitch = round(cameraRotation.x, 2),
            roll = round(cameraRotation.y, 2),
            yaw = round(cameraRotation.z, 2)
        },
        target = {
            hit = target.hit,
            x = round(target.coords.x, 2),
            y = round(target.coords.y, 2),
            z = round(target.coords.z, 2),
            entity = target.entity
        }
    }
end

local function sendCoordToolState()
    sendNui('coordTool', currentCoordToolPayload())
end

local function coordPayloadCoords(payload, source)
    if source == 'target' then
        local target = payload.target or {}
        local player = payload.player or {}
        return {
            x = target.x,
            y = target.y,
            z = target.z,
            h = player.h
        }
    end

    return payload.player or {}
end

local function coordClipboardText(source, format)
    local payload = currentCoordToolPayload()
    local coords = coordPayloadCoords(payload, source)
    local x = round(coords.x, 2)
    local y = round(coords.y, 2)
    local z = round(coords.z, 2)
    local h = round(coords.h, 2)

    if format == 'vector3' then
        return ('vector3(%.2f, %.2f, %.2f)'):format(x, y, z)
    end

    if format == 'vector4' then
        return ('vector4(%.2f, %.2f, %.2f, %.2f)'):format(x, y, z, h)
    end

    if format == 'table' then
        return ('{ x = %.2f, y = %.2f, z = %.2f, h = %.2f }'):format(x, y, z, h)
    end

    if format == 'heading' then
        return ('%.2f'):format(h)
    end

    return ('%.2f, %.2f, %.2f, %.2f'):format(x, y, z, h)
end

local function copyCoordToClipboard(source, format, label)
    local text = coordClipboardText(source, format)
    sendNui('clipboard', {
        text = text,
        message = ('Copied %s.'):format(label or 'coordinates')
    })
    gameNotify(('Copied %s.'):format(label or 'coordinates'), 'success')
end

local coordCopyShortcuts = {
    { key = '1', source = 'player', format = 'vector3', label = 'player Vector3' },
    { key = '2', source = 'player', format = 'vector4', label = 'player Vector4' },
    { key = '3', source = 'target', format = 'vector3', label = 'aim Vector3' },
    { key = '4', source = 'target', format = 'vector4', label = 'aim Vector4' },
    { key = '5', source = 'player', format = 'table', label = 'coords table' },
    { key = '6', source = 'player', format = 'heading', label = 'heading' }
}

local function runCoordCopyShortcut(index)
    if not coordLaser then return end

    local shortcut = coordCopyShortcuts[index]
    if not shortcut then return end

    copyCoordToClipboard(shortcut.source, shortcut.format, shortcut.label)
end

local function startCoordFinder()
    if menuOpen then
        closeMenu(false)
    end

    coordLaser = true
    sendNui('coordOverlay', {
        active = true
    })
    SetNuiFocusKeepInput(false)
    SetNuiFocus(false, false)
    sendCoordToolState()
    nuiToast('Coordinate laser enabled. Press Escape to stop.', 'inform')
end

local function stopCoordFinder()
    if not coordLaser then return end

    coordLaser = false
    sendNui('coordOverlay', {
        active = false
    })
    SetNuiFocusKeepInput(false)
    SetNuiFocus(false, false)
    sendCoordToolState()
    nuiToast('Coordinate laser disabled.', 'inform')
end

local function applyAdminVisibility(entity)
    local ped = PlayerPedId()
    local vehicle = entity ~= ped and entity or 0

    if noclip then
        NetworkSetEntityInvisibleToNetwork(ped, true)
        SetEntityVisible(ped, false, false)
        SetEntityAlpha(ped, noclipGhostAlpha, false)
        SetEveryoneIgnorePlayer(PlayerId(), true)
        SetPoliceIgnorePlayer(PlayerId(), true)

        if vehicle ~= 0 and DoesEntityExist(vehicle) then
            noclipGhostVehicle = vehicle
            NetworkSetEntityInvisibleToNetwork(vehicle, true)
            SetEntityVisible(vehicle, false, false)
            SetEntityAlpha(vehicle, noclipGhostAlpha, false)
        end
        return
    end

    NetworkSetEntityInvisibleToNetwork(ped, invisible)
    ResetEntityAlpha(ped)
    SetEntityVisible(ped, not invisible, false)
    SetEveryoneIgnorePlayer(PlayerId(), false)
    SetPoliceIgnorePlayer(PlayerId(), false)

    if vehicle ~= 0 and DoesEntityExist(vehicle) then
        NetworkSetEntityInvisibleToNetwork(vehicle, false)
        ResetEntityAlpha(vehicle)
        SetEntityVisible(vehicle, true, false)
    end

    if noclipGhostVehicle ~= 0 and noclipGhostVehicle ~= vehicle and DoesEntityExist(noclipGhostVehicle) then
        NetworkSetEntityInvisibleToNetwork(noclipGhostVehicle, false)
        ResetEntityAlpha(noclipGhostVehicle)
        SetEntityVisible(noclipGhostVehicle, true, false)
    end
    noclipGhostVehicle = 0
end

local function setSpectateShellHidden(hidden)
    local ped = PlayerPedId()
    local vehicle = currentVehicle()
    local entity = vehicle ~= 0 and vehicle or ped

    NetworkSetEntityInvisibleToNetwork(ped, hidden or invisible)
    SetEntityVisible(ped, hidden and false or not invisible, false)
    SetEntityCollision(entity, not hidden, not hidden)
    FreezeEntityPosition(entity, hidden)
    SetEveryoneIgnorePlayer(PlayerId(), hidden)
    SetPoliceIgnorePlayer(PlayerId(), hidden)

    if vehicle ~= 0 and DoesEntityExist(vehicle) then
        NetworkSetEntityInvisibleToNetwork(vehicle, hidden)
        SetEntityVisible(vehicle, not hidden, false)
    end
end

local function setNoclipState(state, skipCameraEase)
    noclip = state
    local ped = PlayerPedId()
    local entity = currentVehicle() ~= 0 and currentVehicle() or ped
    local coords = GetEntityCoords(entity)
    local exitPosition = noclipPosition
    local exitHeading = normalizeHeading(noclipCameraYaw)

    if state then
        noclipForcedGodmode = noclipLandingGodmode or not godmode
        noclipForcedInvisible = not invisible
        noclipLandingGodmode = false
        noclipLandingGodmodeStartedAt = 0
        godmode = true
        invisible = true
        noclipEntity = entity
        noclipPosition = coords
        startNoclipCamera()
        updateNoclipCamera(coords, false)
    else
        if noclipForcedGodmode then
            noclipLandingGodmode = true
            noclipLandingGodmodeStartedAt = GetGameTimer()
        else
            noclipLandingGodmode = false
            noclipLandingGodmodeStartedAt = 0
        end
        if noclipForcedInvisible then
            invisible = false
        end
        noclipForcedGodmode = false
        noclipForcedInvisible = false
    end

    SetEntityVelocity(entity, 0.0, 0.0, 0.0)
    if state then
        FreezeEntityPosition(entity, false)
        SetEntityCollision(entity, false, false)
        SetEntityHasGravity(entity, false)
    else
        if exitPosition then
            coords = exitPosition
            SetEntityCoordsNoOffset(entity, coords.x, coords.y, coords.z, false, false, false)
            SetEntityHeading(entity, exitHeading)
        end

        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        SetEntityCollision(entity, true, true)
        SetEntityHasGravity(entity, true)
        FreezeEntityPosition(entity, false)
        SetEntityVelocity(entity, 0.0, 0.0, 0.0)
        stopNoclipCamera(skipCameraEase and 0 or 225)
        noclipEntity = 0
        noclipPosition = nil
    end
    applyGodmodeState(godmode)
    applyAdminVisibility(entity)
    sendModeState()
end

local function clearPlayerBlips()
    for _, blip in pairs(playerBlips) do
        if DoesBlipExist(blip) then RemoveBlip(blip) end
    end
    playerBlips = {}
end

local function updateBlips()
    if not latestSnapshot or not latestSnapshot.players then return end

    local active = {}
    local selfServerId = GetPlayerServerId(PlayerId())

    for _, player in ipairs(latestSnapshot.players) do
        if player.id ~= selfServerId and player.coords then
            active[player.id] = true
            local coords = vector3(player.coords.x or 0.0, player.coords.y or 0.0, player.coords.z or 0.0)
            local clientId = GetPlayerFromServerId(player.id)

            if clientId ~= -1 then
                coords = GetEntityCoords(GetPlayerPed(clientId))
            end

            local blip = playerBlips[player.id]
            if not blip or not DoesBlipExist(blip) then
                blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                playerBlips[player.id] = blip
                SetBlipSprite(blip, 1)
                SetBlipScale(blip, 0.75)
                SetBlipColour(blip, 48)
                SetBlipAsShortRange(blip, false)
            end

            SetBlipCoords(blip, coords.x, coords.y, coords.z)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(('%s [%s]'):format(player.displayName or player.name or 'Player', player.id))
            EndTextCommandSetBlipName(blip)
        end
    end

    for serverId, blip in pairs(playerBlips) do
        if not active[serverId] and DoesBlipExist(blip) then
            RemoveBlip(blip)
            playerBlips[serverId] = nil
        end
    end
end

local function setSpectate(targetServerId, targetCoords, skipReturnTeleport)
    targetServerId = tonumber(targetServerId)
    spectateRequestId = spectateRequestId + 1
    local requestId = spectateRequestId

    if not targetServerId then
        if controlMode then
            controlMode = false
            controlTargetServerId = nil
            sendModeState()
            TriggerServerEvent('snipz_adminmenu:server:controlStop')
        end

        if spectating then
            NetworkSetInSpectatorMode(false, PlayerPedId())
        end
        ClearFocus()

        local ped = PlayerPedId()
        setSpectateShellHidden(false)

        if spectateReturnCoords and not skipReturnTeleport then
            teleportTo({
                x = spectateReturnCoords.x,
                y = spectateReturnCoords.y,
                z = spectateReturnCoords.z,
                h = GetEntityHeading(ped)
            })
        end

        spectating = false
        spectateTargetServerId = nil
        spectateReturnCoords = nil
        sendNui('spectateState', {
            active = false
        })
        sendModeState()
        return
    end

    if targetServerId == GetPlayerServerId(PlayerId()) then
        setSpectate(false)
        nuiToast('You cannot spectate yourself.', 'warning')
        return
    end

    if spectating and spectateTargetServerId == targetServerId and not controlStarting then
        setSpectate(false)
        nuiToast('Spectate stopped.', 'inform')
        return
    end

    local targetPed = getStreamedPlayerPed(targetServerId)
    if targetPed == 0 and type(targetCoords) == 'table' then
        if not spectateReturnCoords then
            spectateReturnCoords = GetEntityCoords(PlayerPedId())
        end

        setSpectateShellHidden(true)
        teleportTo(targetCoords)

        local timeout = GetGameTimer() + 6000
        while targetPed == 0 and GetGameTimer() < timeout do
            if requestId ~= spectateRequestId then return end
            targetPed = getStreamedPlayerPed(targetServerId)
            Wait(100)
        end
    end

    if requestId ~= spectateRequestId then return end

    if targetPed == 0 then
        nuiToast('Target could not be streamed in. Check their routing bucket or try again.', 'warning')
        if controlMode then
            controlMode = false
            controlTargetServerId = nil
            sendModeState()
            TriggerServerEvent('snipz_adminmenu:server:controlStop')
        end
        if spectateReturnCoords and not spectating then
            teleportTo({
                x = spectateReturnCoords.x,
                y = spectateReturnCoords.y,
                z = spectateReturnCoords.z,
                h = GetEntityHeading(PlayerPedId())
            })
            spectateReturnCoords = nil
        end
        setSpectateShellHidden(false)
        sendNui('spectateState', {
            active = false
        })
        sendModeState()
        return
    end

    if spectating then
        NetworkSetInSpectatorMode(false, PlayerPedId())
    end

    if not spectateReturnCoords then
        spectateReturnCoords = GetEntityCoords(PlayerPedId())
    end

    local targetCoords = GetEntityCoords(targetPed)
    RequestCollisionAtCoord(targetCoords.x, targetCoords.y, targetCoords.z)
    SetFocusEntity(targetPed)
    setSpectateShellHidden(true)
    NetworkSetInSpectatorMode(true, targetPed)
    spectating = true
    spectateTargetServerId = targetServerId
    if menuOpen then
        closeMenu()
    end
    local playerInfo = snapshotPlayer(targetServerId) or {}
    sendNui('spectateState', {
        active = true,
        target = targetServerId,
        name = playerInfo.displayName or playerInfo.name,
        health = playerInfo.health,
        armor = playerInfo.armor,
        bucket = playerInfo.bucket,
        job = playerInfo.job and playerInfo.job.label,
        message = ('Viewing player #%s. Press Escape to stop.'):format(targetServerId)
    })
end

RegisterCommand(Config.Command, function()
    if menuOpen then
        closeMenu()
        return
    end

    TriggerServerEvent('snipz_adminmenu:server:open')
end, false)

RegisterKeyMapping(Config.Command, 'Open admin menu', 'keyboard', Config.Keybind)

RegisterCommand(Config.NoclipCommand or Config.NoClipCommand or 'noclip', function()
    TriggerServerEvent('snipz_adminmenu:server:adminAction', {
        action = 'self.noclip'
    })
end, false)

RegisterKeyMapping(Config.NoclipCommand or Config.NoClipCommand or 'noclip', 'Toggle admin noclip', 'keyboard', Config.NoclipKeybind or Config.NoClipKeybind or '')

RegisterCommand(Config.CoordFinderCommand or 'coordfinder', function()
    if coordLaser and not menuOpen then
        stopCoordFinder()
        return
    end

    startCoordFinder()
end, false)

for index, shortcut in ipairs(coordCopyShortcuts) do
    local commandName = ('snipz_coordcopy_%s'):format(index)
    RegisterCommand(commandName, function()
        runCoordCopyShortcut(index)
    end, false)
    RegisterKeyMapping(commandName, ('Coord finder copy %s'):format(shortcut.label), 'keyboard', shortcut.key)
end

RegisterCommand(Config.AdminCar.Command, saveAdminVehicle, false)

RegisterNetEvent('snipz_adminmenu:client:admincar', saveAdminVehicle)
RegisterNetEvent('ps-adminmenu:client:Admincar', saveAdminVehicle)
RegisterNetEvent('ps-adminmenu:client:admincar', saveAdminVehicle)

RegisterNUICallback('ready', function(_, cb)
    cb({ ok = true })
end)

RegisterNUICallback('close', function(_, cb)
    closeMenu()
    cb({ ok = true })
end)

RegisterNUICallback('refresh', function(_, cb)
    TriggerServerEvent('snipz_adminmenu:server:requestSnapshot')
    cb({ ok = true })
end)

RegisterNUICallback('action', function(data, cb)
    TriggerServerEvent('snipz_adminmenu:server:adminAction', data)
    cb({ ok = true })
end)

RegisterNUICallback('coordTool', function(data, cb)
    coordLaser = data and data.laser == true
    if menuOpen then
        SetNuiFocusKeepInput(coordLaser)
    end
    sendCoordToolState()
    cb({ ok = true })
end)

RegisterNUICallback('remoteFeed', function(data, cb)
    TriggerServerEvent('snipz_adminmenu:server:requestRemoteFeed', data and data.targets or {})
    cb({ ok = true })
end)

RegisterNetEvent('snipz_adminmenu:client:open', function(snapshot)
    latestSnapshot = snapshot
    menuOpen = true
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)
    sendNui('open', snapshot)
end)

RegisterNetEvent('snipz_adminmenu:client:snapshot', function(snapshot)
    latestSnapshot = snapshot
    sendNui('snapshot', snapshot)
end)

RegisterNetEvent('snipz_adminmenu:client:toast', function(data)
    data = type(data) == 'table' and data or {}
    nuiToast(data.message or 'Action complete.', data.type or 'inform')
end)

RegisterNetEvent('snipz_adminmenu:client:announcement', function(data)
    sendNui('announcement', data)
end)

RegisterNetEvent('snipz_adminmenu:client:staffMessage', function(data)
    sendNui('staffMessage', data)
end)

RegisterNetEvent('snipz_adminmenu:client:actionResult', function(data)
    sendNui('actionResult', data)
end)

RegisterNetEvent('snipz_adminmenu:client:remoteFeedFrame', function(data)
    sendNui('remoteFeedFrame', data)
end)

RegisterNetEvent('snipz_adminmenu:client:forceClose', function()
    closeMenu(true)
end)

RegisterNetEvent('snipz_adminmenu:client:coordFinder', function()
    startCoordFinder()
end)

RegisterNetEvent('snipz_adminmenu:client:revive', function(payload)
    revivePed(payload)
end)

RegisterNetEvent('snipz_adminmenu:client:heal', function(data)
    data = type(data) == 'table' and data or {}
    local ped = PlayerPedId()
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    ClearPedBloodDamage(ped)
    if data and data.armor then
        SetPedArmour(ped, 100)
    end
    resetHealthBuffer(data)
end)

RegisterNetEvent('snipz_adminmenu:client:resetStatus', function(data)
    data = type(data) == 'table' and data or {}
    local ped = PlayerPedId()
    ClearPedBloodDamage(ped)
    ClearPedTasks(ped)
    StopEntityFire(ped)
    ClearTimecycleModifier()
    ResetPedMovementClipset(ped, 0.0)
    resetHealthBuffer(data)
end)

RegisterNetEvent('snipz_adminmenu:client:setArmor', function(amount)
    SetPedArmour(PlayerPedId(), math.max(0, math.min(100, tonumber(amount) or 0)))
end)

RegisterNetEvent('snipz_adminmenu:client:voiceMute', function(state)
    voiceMuted = state == true
    NetworkSetVoiceActive(not voiceMuted)
    nuiToast(voiceMuted and 'You were voice-muted by staff.' or 'Voice mute removed.', voiceMuted and 'warning' or 'inform')
end)

RegisterNetEvent('snipz_adminmenu:client:kill', function()
    SetEntityHealth(PlayerPedId(), 0)
end)

RegisterNetEvent('snipz_adminmenu:client:freeze', function(state)
    if state ~= true then
        releaseFrozenState()
        return
    end

    local ped = PlayerPedId()
    local vehicle = currentVehicle()
    frozenEntity = vehicle ~= 0 and vehicle or ped
    frozen = true
    FreezeEntityPosition(frozenEntity, true)
end)

RegisterNetEvent('snipz_adminmenu:client:slap', function()
    local ped = PlayerPedId()
    SetPedToRagdoll(ped, 2500, 2500, 0, false, false, false)
    ApplyForceToEntity(ped, 1, 0.0, 0.0, 12.0, 0.0, 0.0, 0.0, 0, false, true, true, false, true)
end)

RegisterNetEvent('snipz_adminmenu:client:explode', function()
    local coords = GetEntityCoords(PlayerPedId())
    AddExplosion(coords.x, coords.y, coords.z, 2, 1.0, true, false, 1.0)
end)

RegisterNetEvent('snipz_adminmenu:client:burn', function()
    StartEntityFire(PlayerPedId())
end)

RegisterNetEvent('snipz_adminmenu:client:ragdoll', function()
    SetPedToRagdoll(PlayerPedId(), 5000, 5000, 0, false, false, false)
end)

RegisterNetEvent('snipz_adminmenu:client:handsUp', function()
    local ped = PlayerPedId()
    RequestAnimDict('missminuteman_1ig_2')
    local expires = GetGameTimer() + 1500
    while not HasAnimDictLoaded('missminuteman_1ig_2') and GetGameTimer() < expires do
        Wait(0)
    end

    if HasAnimDictLoaded('missminuteman_1ig_2') then
        TaskPlayAnim(ped, 'missminuteman_1ig_2', 'handsup_base', 8.0, -8.0, 7000, 49, 0, false, false, false)
    end
end)

RegisterNetEvent('snipz_adminmenu:client:seatVehicle', function()
    seatInNearestVehicle()
end)

RegisterNetEvent('snipz_adminmenu:client:escort', function(adminServerId, active)
    setEscortState(adminServerId, active == true)
end)

RegisterNetEvent('snipz_adminmenu:client:setCuffed', function(state)
    setCuffedState(state)
end)

RegisterNetEvent('snipz_adminmenu:client:teleport', function(coords)
    teleportTo(coords)
end)

RegisterNetEvent('snipz_adminmenu:client:spectate', function(targetServerId, targetCoords)
    setSpectate(targetServerId, targetCoords)
end)

RegisterNetEvent('snipz_adminmenu:client:controlStart', function(targetServerId, targetCoords)
    targetServerId = tonumber(targetServerId)
    if not targetServerId then return end

    controlMode = true
    controlTargetServerId = targetServerId
    lastControlSendAt = 0
    closeMenu()
    controlStarting = true
    setSpectate(targetServerId, targetCoords)
    controlStarting = false
    sendModeState()
    nuiToast('Control started. Use WASD, Shift, Alt, E/Q. Press Esc to stop.', 'inform')
end)

RegisterNetEvent('snipz_adminmenu:client:controlStop', function()
    local wasControlling = controlMode
    controlMode = false
    controlTargetServerId = nil

    if spectating then
        setSpectate(false)
    end

    sendModeState()

    if wasControlling then
        nuiToast('Control stopped.', 'inform')
    end
end)

RegisterNetEvent('snipz_adminmenu:client:controlledState', function(adminServerId, active)
    adminServerId = tonumber(adminServerId)

    if active and adminServerId then
        controlledByServerId = adminServerId
        lastControlledInputAt = GetGameTimer()
        SetPlayerControl(PlayerId(), true, 0)
        sendModeState()
        nuiToast('An admin is controlling your player.', 'warning')
        return
    end

    if not adminServerId or controlledByServerId == adminServerId then
        releaseControlledState()
        sendModeState()
    end
end)

RegisterNetEvent('snipz_adminmenu:client:controlInput', function(adminServerId, input)
    if controlledByServerId ~= tonumber(adminServerId) or type(input) ~= 'table' then return end

    local ped = PlayerPedId()
    local vehicle = currentVehicle()
    local entity = vehicle ~= 0 and vehicle or ped
    local coords = GetEntityCoords(entity)
    local x = tonumber(input.x) or 0.0
    local y = tonumber(input.y) or 0.0
    local z = tonumber(input.z) or 0.0
    local h = tonumber(input.h) or GetEntityHeading(entity)

    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    local found, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z + 50.0, false)
    if found and z < 0.0 and coords.z <= groundZ + 1.0 then
        z = 0.0
    end

    SetEntityHeading(entity, h)

    local horizontalSpeed = math.sqrt((x * x) + (y * y))
    if vehicle == 0 and horizontalSpeed > 0.05 and math.abs(z) < 0.05 then
        TaskGoStraightToCoord(ped, coords.x + (x * 0.5), coords.y + (y * 0.5), coords.z, horizontalSpeed, 300, h, 0.0)
        SetEntityVelocity(entity, 0.0, 0.0, 0.0)
    else
        if vehicle == 0 and horizontalSpeed <= 0.05 and math.abs(z) <= 0.05 then
            ClearPedTasks(ped)
        end

        SetEntityVelocity(entity, x, y, z)
    end

    lastControlledInputAt = GetGameTimer()
end)

RegisterNetEvent('snipz_adminmenu:client:clothing', function(data)
    local events = {}

    if type(data) == 'string' then
        events[#events + 1] = data
    elseif type(data) == 'table' then
        if type(data.event) == 'string' and data.event ~= '' then
            events[#events + 1] = data.event
        end
        for _, eventName in ipairs(data.fallbacks or {}) do
            if type(eventName) == 'string' and eventName ~= '' then
                events[#events + 1] = eventName
            end
        end
    end

    if #events == 0 then
        nuiToast('Clothing event is not configured.', 'warning')
        return
    end

    for _, eventName in ipairs(events) do
        if clothingEventAvailable(eventName) then
            TriggerEvent(eventName)
            return
        end
    end

    TriggerEvent(events[1])
end)

RegisterNetEvent('snipz_adminmenu:client:appearanceAction', function(data)
    if type(data) ~= 'table' then return end

    if data.action == 'reset' then
        local ped = PlayerPedId()
        SetPedDefaultComponentVariation(ped)
        ClearPedProp(ped, 0)
        ClearPedProp(ped, 1)
        ClearPedProp(ped, 2)
        ClearPedProp(ped, 6)
        ClearPedProp(ped, 7)
        nuiToast('Appearance reset requested.', 'inform')
        return
    end

    local eventName = data.action == 'barber' and data.barberEvent or data.action == 'tattoo' and data.tattooEvent or nil
    eventName = type(eventName) == 'string' and eventName or ''
    if not eventName or eventName == '' then
        nuiToast('Appearance integration is not configured.', 'warning')
        return
    end

    if clothingEventAvailable(eventName) then
        TriggerEvent(eventName)
        return
    end

    TriggerEvent(eventName)
end)

RegisterNetEvent('snipz_adminmenu:client:setPed', function(model)
    local hash = loadModel(model)
    if not hash or not IsModelAPed(hash) then
        nuiToast('Ped model could not be loaded.', 'error')
        return
    end

    SetPlayerModel(PlayerId(), hash)
    SetPedDefaultComponentVariation(PlayerPedId())
    SetModelAsNoLongerNeeded(hash)
end)

RegisterNetEvent('snipz_adminmenu:client:giveWeapon', function(weapon, ammo)
    if type(weapon) ~= 'string' and type(weapon) ~= 'number' then return end
    local hash = type(weapon) == 'number' and weapon or joaat(weapon)
    GiveWeaponToPed(PlayerPedId(), hash, tonumber(ammo) or 120, false, true)
end)

RegisterNetEvent('snipz_adminmenu:client:clearWeapons', function()
    RemoveAllPedWeapons(PlayerPedId(), true)
end)

RegisterNetEvent('snipz_adminmenu:client:vehicle', function(data)
    if type(data) ~= 'table' or not data.type then return end

    if data.type == 'spawn' then
        spawnVehicle(data)
        return
    end

    if data.type == 'keys' then
        giveVehicleKeys(data.keysEvent, data.keysResource)
        return
    end

    if data.type == 'customize' then
        openMechanicCustomisation(data)
        return
    end

    local vehicle = currentVehicle()
    if vehicle == 0 then vehicle = closestVehicle(8.0) end
    if vehicle == 0 then
        nuiToast('No vehicle found.', 'error')
        return
    end

    if data.type == 'repair' then
        repairVehicle(vehicle)
    elseif data.type == 'flip' then
        flipVehicle(vehicle)
    elseif data.type == 'delete' then
        deleteVehicle(vehicle)
    elseif data.type == 'clean' then
        cleanVehicle(vehicle)
    elseif data.type == 'refuel' then
        setVehicleFuel(vehicle, 100.0, data.fuelResource)
    elseif data.type == 'maxMods' then
        maxVehicleMods(vehicle)
    end
end)

RegisterNetEvent('snipz_adminmenu:client:toggleNoclip', function()
    setNoclipState(not noclip)
    nuiToast(noclip and 'Noclip enabled with godmode and invisibility.' or 'Noclip disabled.', 'inform')
end)

RegisterNetEvent('snipz_adminmenu:client:toggleGodmode', function()
    noclipForcedGodmode = false
    noclipLandingGodmode = false
    noclipLandingGodmodeStartedAt = 0
    godmode = not godmode
    applyGodmodeState(godmode)
    sendModeState()
    nuiToast(godmode and 'Godmode enabled.' or 'Godmode disabled.', 'inform')
end)

RegisterNetEvent('snipz_adminmenu:client:toggleInvisible', function()
    noclipForcedInvisible = false
    invisible = not invisible
    applyAdminVisibility(currentVehicle() ~= 0 and currentVehicle() or PlayerPedId())
    sendModeState()
    nuiToast(invisible and 'Invisibility enabled.' or 'Invisibility disabled.', 'inform')
end)

RegisterNetEvent('snipz_adminmenu:client:toggleBlips', function()
    showingBlips = not showingBlips
    if not showingBlips then clearPlayerBlips() end
    nuiToast(showingBlips and 'Player blips enabled.' or 'Player blips disabled.', 'inform')
end)

RegisterNetEvent('snipz_adminmenu:client:setWeather', function(weather)
    if type(weather) ~= 'string' or weather == '' then return end
    SetWeatherTypeOvertimePersist(weather, 15.0)
    SetWeatherTypePersist(weather)
    SetWeatherTypeNowPersist(weather)
end)

RegisterNetEvent('snipz_adminmenu:client:setTime', function(timeData)
    if type(timeData) ~= 'table' then return end
    NetworkOverrideClockTime(tonumber(timeData.hour) or 12, tonumber(timeData.minute) or 0, 0)
end)

CreateThread(function()
    while true do
        if menuOpen then
            if IsControlJustReleased(0, 200)
                or IsControlJustReleased(0, 322)
                or IsDisabledControlJustReleased(0, 200)
                or IsDisabledControlJustReleased(0, 322)
            then
                closeMenu()
            end

            if coordLaser then
                DisableControlAction(0, 21, true)
                DisableControlAction(0, 22, true)
                DisableControlAction(0, 23, true)
                DisableControlAction(0, 30, true)
                DisableControlAction(0, 31, true)
                DisableControlAction(0, 32, true)
                DisableControlAction(0, 33, true)
                DisableControlAction(0, 34, true)
                DisableControlAction(0, 35, true)
                DisableControlAction(0, 75, true)
            else
                DisableControlAction(0, 1, true)
                DisableControlAction(0, 2, true)
            end
            DisableControlAction(0, 200, true)
            DisableControlAction(0, 322, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            Wait(0)
        elseif coordLaser then
            DisableControlAction(0, 157, true)
            DisableControlAction(0, 158, true)
            DisableControlAction(0, 159, true)
            DisableControlAction(0, 160, true)
            DisableControlAction(0, 161, true)
            DisableControlAction(0, 162, true)

            if IsControlJustReleased(0, 200)
                or IsControlJustReleased(0, 322)
                or IsDisabledControlJustReleased(0, 200)
                or IsDisabledControlJustReleased(0, 322)
            then
                stopCoordFinder()
            end

            Wait(0)
        else
            Wait(250)
        end
    end
end)

CreateThread(function()
    while true do
        if adminCuffed then
            local ped = PlayerPedId()
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 37, true)
            DisableControlAction(0, 45, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            DisablePlayerFiring(PlayerId(), true)

            if not IsEntityPlayingAnim(ped, 'mp_arresting', 'idle', 3) then
                RequestAnimDict('mp_arresting')
                if HasAnimDictLoaded('mp_arresting') then
                    TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, -8.0, -1, 49, 0, false, false, false)
                end
            end

            Wait(0)
        else
            Wait(500)
        end
    end
end)

CreateThread(function()
    while true do
        if escortedByServerId then
            DisableControlAction(0, 21, true)
            DisableControlAction(0, 22, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 30, true)
            DisableControlAction(0, 31, true)
            DisableControlAction(0, 32, true)
            DisableControlAction(0, 33, true)
            DisableControlAction(0, 34, true)
            DisableControlAction(0, 35, true)
            DisablePlayerFiring(PlayerId(), true)

            if not IsEntityAttached(PlayerPedId()) then
                escortedByServerId = nil
            end

            Wait(0)
        else
            Wait(500)
        end
    end
end)

CreateThread(function()
    while true do
        if controlledByServerId then
            local ped = PlayerPedId()
            local vehicle = currentVehicle()
            local entity = vehicle ~= 0 and vehicle or ped

            DisableControlAction(0, 21, true)
            DisableControlAction(0, 22, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 30, true)
            DisableControlAction(0, 31, true)
            DisableControlAction(0, 32, true)
            DisableControlAction(0, 33, true)
            DisableControlAction(0, 34, true)
            DisableControlAction(0, 35, true)
            DisableControlAction(0, 37, true)
            DisableControlAction(0, 44, true)
            DisableControlAction(0, 45, true)
            DisablePlayerFiring(PlayerId(), true)

            if GetGameTimer() - lastControlledInputAt > 1000 then
                SetEntityVelocity(entity, 0.0, 0.0, 0.0)
            end

            Wait(0)
        else
            Wait(250)
        end
    end
end)

CreateThread(function()
    while true do
        if controlMode and controlTargetServerId then
            if IsControlJustReleased(0, 200)
                or IsControlJustReleased(0, 322)
                or IsDisabledControlJustReleased(0, 200)
                or IsDisabledControlJustReleased(0, 322)
            then
                TriggerServerEvent('snipz_adminmenu:server:controlStop')
            end

            local rotation = GetGameplayCamRot(2)
            local forward, right = cameraFlatDirections(rotation)
            local speed = 2.8
            local movement = vector3(0.0, 0.0, 0.0)

            if IsControlPressed(0, 21) or IsDisabledControlPressed(0, 21) then speed = 6.5 end
            if IsControlPressed(0, 19) or IsDisabledControlPressed(0, 19) then speed = 1.0 end

            DisableControlAction(0, 21, true)
            DisableControlAction(0, 30, true)
            DisableControlAction(0, 31, true)
            DisableControlAction(0, 32, true)
            DisableControlAction(0, 33, true)
            DisableControlAction(0, 34, true)
            DisableControlAction(0, 35, true)
            DisableControlAction(0, 38, true)
            DisableControlAction(0, 44, true)

            if IsDisabledControlPressed(0, 32) then movement = movement + (forward * speed) end
            if IsDisabledControlPressed(0, 33) then movement = movement - (forward * speed) end
            if IsDisabledControlPressed(0, 35) then movement = movement + (right * speed) end
            if IsDisabledControlPressed(0, 34) then movement = movement - (right * speed) end
            if IsDisabledControlPressed(0, 38) then movement = movement + vector3(0.0, 0.0, speed) end
            if IsDisabledControlPressed(0, 44) then movement = movement - vector3(0.0, 0.0, speed) end

            if GetGameTimer() - lastControlSendAt >= 50 then
                TriggerServerEvent('snipz_adminmenu:server:controlInput', {
                    x = movement.x,
                    y = movement.y,
                    z = movement.z,
                    h = rotation.z
                })
                lastControlSendAt = GetGameTimer()
            end

            Wait(0)
        else
            Wait(250)
        end
    end
end)

CreateThread(function()
    while true do
        if noclip then
            local ped = PlayerPedId()
            local entity = currentVehicle() ~= 0 and currentVehicle() or ped

            if noclipEntity ~= entity or not noclipPosition then
                noclipEntity = entity
                noclipPosition = GetEntityCoords(entity)
                FreezeEntityPosition(entity, false)
                SetEntityCollision(entity, false, false)
                SetEntityHasGravity(entity, false)
            end

            applyAdminVisibility(entity)
            DisableControlAction(0, 14, true)
            DisableControlAction(0, 15, true)
            if IsDisabledControlJustPressed(0, 15) then
                noclipSpeedIndex = math.min(#noclipSpeeds, noclipSpeedIndex + 1)
                sendModeState()
            elseif IsDisabledControlJustPressed(0, 14) then
                noclipSpeedIndex = math.max(1, noclipSpeedIndex - 1)
                sendModeState()
            end

            local speed = noclipSpeeds[noclipSpeedIndex] or noclipSpeeds[2]

            if controlHeld(21) then speed = speed * 2.2 end
            if controlHeld(19) then speed = speed * 0.35 end

            disableNoclipControls()

            local cameraForward, cameraRight = updateNoclipCamera(noclipPosition)
            local direction = noclipDirection(cameraForward, cameraRight)
            noclipPosition = noclipPosition + (direction * speed)
            updateNoclipCamera(noclipPosition, false)

            SetEntityCoordsNoOffset(entity, noclipPosition.x, noclipPosition.y, noclipPosition.z, false, false, false)
            SetEntityHeading(entity, normalizeHeading(noclipCameraYaw))
            SetEntityVelocity(entity, 0.0, 0.0, 0.0)
            Wait(0)
        else
            Wait(250)
        end
    end
end)

CreateThread(function()
    while true do
        if godmode then
            applyGodmodeState(true)
            Wait(500)
        else
            Wait(1000)
        end
    end
end)

CreateThread(function()
    while true do
        if noclipLandingGodmode then
            if not godmode then
                noclipLandingGodmode = false
                noclipLandingGodmodeStartedAt = 0
            elseif not noclip
                and GetGameTimer() - noclipLandingGodmodeStartedAt >= 500
                and entityHasTouchedGround(currentPlayerEntity())
            then
                noclipLandingGodmode = false
                noclipLandingGodmodeStartedAt = 0
                godmode = false
                applyGodmodeState(false)
                sendModeState()
            end

            Wait(100)
        else
            Wait(500)
        end
    end
end)

CreateThread(function()
    while true do
        if showingBlips then
            updateBlips()
            Wait(1000)
        else
            Wait(1000)
        end
    end
end)

CreateThread(function()
    while true do
        if spectating then
            if not controlMode and (
                IsControlJustReleased(0, 200)
                or IsControlJustReleased(0, 322)
                or IsDisabledControlJustReleased(0, 200)
                or IsDisabledControlJustReleased(0, 322)
            ) then
                setSpectate(false)
                nuiToast('Spectate stopped.', 'inform')
            end

            local targetPed = spectating and spectateTargetServerId and getStreamedPlayerPed(spectateTargetServerId) or 0

            if spectating and targetPed == 0 then
                setSpectate(false)
                nuiToast('Spectate ended because the target is unavailable.', 'warning')
            end

            Wait(0)
        else
            Wait(1000)
        end
    end
end)

CreateThread(function()
    while true do
        if menuOpen then
            sendCoordToolState()
            Wait(coordLaser and 100 or 250)
        elseif coordLaser then
            sendCoordToolState()
            Wait(100)
        else
            Wait(500)
        end
    end
end)

CreateThread(function()
    while true do
        if coordLaser then
            local payload = currentCoordToolPayload()
            local target = payload.target or {}
            local origin = coordLaserOrigin()
            local markerR, markerG, markerB = 255, 138, 31
            if not target.hit then
                markerR, markerG, markerB = 255, 196, 87
            end

            DrawLine(
                origin.x,
                origin.y,
                origin.z,
                target.x or 0.0,
                target.y or 0.0,
                target.z or 0.0,
                markerR,
                markerG,
                markerB,
                235
            )
            DrawMarker(
                28,
                target.x or 0.0,
                target.y or 0.0,
                target.z or 0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.22,
                0.22,
                0.22,
                markerR,
                markerG,
                markerB,
                205,
                false,
                true,
                2,
                false,
                nil,
                nil,
                false
            )
            Wait(0)
        else
            Wait(250)
        end
    end
end)

CreateThread(function()
    while true do
        if menuOpen then
            TriggerServerEvent('snipz_adminmenu:server:requestSnapshot')
            Wait(math.max(1000, tonumber(Config.RefreshInterval) or 5000))
        else
            Wait(1000)
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    if not Config.Security or Config.Security.CleanupSpawnedVehiclesOnStop ~= false then
        for _, vehicle in ipairs(spawnedVehicles) do
            if vehicle ~= 0 and DoesEntityExist(vehicle) then
                if not NetworkHasControlOfEntity(vehicle) then
                    NetworkRequestControlOfEntity(vehicle)
                end
                SetEntityAsMissionEntity(vehicle, true, true)
                DeleteVehicle(vehicle)
                if DoesEntityExist(vehicle) then
                    DeleteEntity(vehicle)
                end
            end
        end
    end

    closeMenu(true, true)
    coordLaser = false
    sendNui('coordOverlay', {
        active = false
    })
    clearPlayerBlips()
    if noclip then setNoclipState(false, true) end
    if noclipCamera ~= 0 then stopNoclipCamera(0) end
    noclipLandingGodmode = false
    noclipLandingGodmodeStartedAt = 0
    if godmode then
        godmode = false
        applyGodmodeState(false)
    end
    if controlMode then
        controlMode = false
        controlTargetServerId = nil
        TriggerServerEvent('snipz_adminmenu:server:controlStop')
    end
    if spectating then setSpectate(false, nil, true) end
    if controlledByServerId then
        releaseControlledState(true)
    end
    if frozen then releaseFrozenState() end
    if adminCuffed then
        adminCuffed = false
        SetEnableHandcuffs(PlayerPedId(), false)
        SetPedCanPlayGestureAnims(PlayerPedId(), true)
        DisablePlayerFiring(PlayerId(), false)
        ClearPedTasksImmediately(PlayerPedId())
    end
    if voiceMuted then
        voiceMuted = false
        NetworkSetVoiceActive(true)
    end
    if escortedByServerId then
        escortedByServerId = nil
        if IsEntityAttached(PlayerPedId()) then
            DetachEntity(PlayerPedId(), true, false)
        end
    end
    SetEntityVisible(PlayerPedId(), true, false)
    SetEntityInvincible(PlayerPedId(), false)
    SetPlayerInvincible(PlayerId(), false)
end)

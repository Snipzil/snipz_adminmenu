const navItems = [
    ['home', 'Home', 'home'],
    ['players', 'Players', 'users'],
    ['monitoring', 'Monitoring', 'monitor'],
    ['moderation', 'Moderation', 'gavel'],
    ['chats', 'Chats', 'chat'],
    ['items', 'Items', 'box'],
    ['vehicles', 'Vehicles', 'car'],
    ['coords', 'Coords', 'pin'],
    ['console', 'Console', 'terminal'],
    ['events', 'Events', 'calendar'],
    ['staff', 'Staff', 'shield'],
    ['blips', 'Blips', 'pin'],
    ['settings', 'Settings', 'settings']
];

const iconPaths = {
    home: '<path d="M3 10.5 12 3l9 7.5"/><path d="M5 10v10h5v-6h4v6h5V10"/>',
    users: '<path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.9"/><path d="M16 3.1a4 4 0 0 1 0 7.8"/>',
    monitor: '<rect x="3" y="4" width="18" height="12" rx="2"/><path d="M8 20h8"/><path d="M12 16v4"/>',
    gavel: '<path d="m14 13-7 7"/><path d="m8 6 10 10"/><path d="m10 4 10 10"/><path d="m3 21 5-5"/>',
    chat: '<path d="M21 15a4 4 0 0 1-4 4H8l-5 3V7a4 4 0 0 1 4-4h10a4 4 0 0 1 4 4z"/>',
    box: '<path d="m21 8-9-5-9 5 9 5 9-5Z"/><path d="M3 8v8l9 5 9-5V8"/><path d="M12 13v8"/>',
    car: '<path d="M5 17h14l-1.5-6h-11L5 17Z"/><path d="M7 17v2"/><path d="M17 17v2"/><circle cx="7.5" cy="17" r="1.5"/><circle cx="16.5" cy="17" r="1.5"/>',
    terminal: '<path d="m4 17 5-5-5-5"/><path d="M12 19h8"/>',
    calendar: '<rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4"/><path d="M8 2v4"/><path d="M3 10h18"/>',
    shield: '<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10Z"/>',
    help: '<circle cx="12" cy="12" r="9"/><path d="M9.5 9a2.7 2.7 0 0 1 5 1.4c0 1.9-2.5 2.1-2.5 4.1"/><path d="M12 18h.01"/>',
    pin: '<path d="M12 21s7-5.2 7-11a7 7 0 0 0-14 0c0 5.8 7 11 7 11Z"/><circle cx="12" cy="10" r="2.5"/>',
    settings: '<path d="M12 8a4 4 0 1 0 0 8 4 4 0 0 0 0-8Z"/><path d="M3 12h2"/><path d="M19 12h2"/><path d="m4.9 4.9 1.4 1.4"/><path d="m17.7 17.7 1.4 1.4"/><path d="m19.1 4.9-1.4 1.4"/><path d="m6.3 17.7-1.4 1.4"/>',
    exit: '<path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><path d="M16 17l5-5-5-5"/><path d="M21 12H9"/>',
    search: '<circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/>',
    refresh: '<path d="M21 12a9 9 0 0 1-15.4 6.4L3 16"/><path d="M3 21v-5h5"/><path d="M3 12A9 9 0 0 1 18.4 5.6L21 8"/><path d="M21 3v5h-5"/>',
    megaphone: '<path d="m3 11 18-6v14L3 13v-2Z"/><path d="M7 14v5a2 2 0 0 0 2 2h1"/>',
    eye: '<path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12Z"/><circle cx="12" cy="12" r="3"/>',
    heart: '<path d="M20.8 4.6a5.5 5.5 0 0 0-7.8 0L12 5.7l-1-1.1a5.5 5.5 0 0 0-7.8 7.8l1 1L12 21l7.8-7.6 1-1a5.5 5.5 0 0 0 0-7.8Z"/>',
    skull: '<path d="M12 2a8 8 0 0 0-8 8c0 3 1.7 5.6 4.2 7v3h7.6v-3A8 8 0 0 0 12 2Z"/><path d="M9 11h.01"/><path d="M15 11h.01"/><path d="M10 16h4"/>',
    snow: '<path d="M12 2v20"/><path d="m4.9 4.9 14.2 14.2"/><path d="M2 12h20"/><path d="m19.1 4.9-14.2 14.2"/>',
    flame: '<path d="M12 22c4 0 7-2.7 7-6.7 0-2.5-1.4-4.9-3.8-6.7.2 2.3-1.2 3.6-2.7 3.9.2-3.2-1.4-6.2-4-8.5.2 4-3.5 6-3.5 10.8C5 19.1 8.1 22 12 22Z"/>',
    ban: '<circle cx="12" cy="12" r="9"/><path d="m5.6 5.6 12.8 12.8"/>',
    zap: '<path d="m13 2-9 13h7l-1 7 9-13h-7l1-7Z"/>',
    send: '<path d="m22 2-7 20-4-9-9-4 20-7Z"/><path d="M22 2 11 13"/>',
    shirt: '<path d="M8 3 5 5 2 8l4 4v9h12v-9l4-4-3-3-3-2a4 4 0 0 1-8 0Z"/>',
    briefcase: '<rect x="3" y="7" width="18" height="13" rx="2"/><path d="M8 7V5a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><path d="M3 12h18"/>',
    bucket: '<path d="M6 8h12l-1 13H7L6 8Z"/><path d="M9 8a3 3 0 0 1 6 0"/>',
    copy: '<rect x="9" y="9" width="13" height="13" rx="2"/><rect x="2" y="2" width="13" height="13" rx="2"/>',
    wrench: '<path d="M14.7 6.3a4 4 0 0 0-5 5L3 18l3 3 6.7-6.7a4 4 0 0 0 5-5l-2.4 2.4-3-3 2.4-2.4Z"/>',
    key: '<circle cx="7.5" cy="14.5" r="4.5"/><path d="M12 14h9"/><path d="M17 14v3"/><path d="M20 14v2"/>',
    dollar: '<path d="M12 2v20"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7H14a3.5 3.5 0 0 1 0 7H6"/>',
    cloud: '<path d="M17.5 19H7a5 5 0 1 1 1.2-9.8A7 7 0 0 1 21 13a4 4 0 0 1-3.5 6Z"/>',
    clock: '<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>',
    camera: '<path d="M15 10 21 7v10l-6-3v-4Z"/><rect x="3" y="7" width="12" height="10" rx="2"/>',
    plus: '<path d="M12 5v14"/><path d="M5 12h14"/>',
    minus: '<path d="M5 12h14"/>',
    trash: '<path d="M3 6h18"/><path d="M8 6V4h8v2"/><path d="M6 6l1 16h10l1-16"/>',
    user: '<circle cx="12" cy="8" r="4"/><path d="M4 22a8 8 0 0 1 16 0"/>',
    food: '<path d="M4 3v8a4 4 0 0 0 4 4v6"/><path d="M4 7h8"/><path d="M12 3v18"/><path d="M18 3v18"/><path d="M18 3c2.5 2 3 5.5 0 8"/>'
};

const state = {
    open: false,
    view: 'home',
    snapshot: null,
    selectedId: null,
    globalSearch: '',
    playerSearch: '',
    adminChatSearch: '',
    serverChatSearch: '',
    itemSearch: '',
    weaponSearch: '',
    itemName: '',
    weaponName: '',
    tab: 'quick',
    notifications: [],
    notificationOpen: false,
    consoleHistoryIndex: -1,
    spectate: {
        active: false,
        target: null
    },
    mode: {
        noclip: false,
        godmode: false,
        invisible: false,
        control: false,
        controlTarget: null,
        controlledBy: null
    },
    coordTool: {
        laser: false,
        player: null,
        camera: null,
        target: null
    },
    coordOverlay: false,
    remoteFeeds: {},
    coordFavorites: [],
    blipMap: {
        zoom: 1,
        x: 0,
        y: 0,
        dragging: false,
        moved: false,
        startX: 0,
        startY: 0,
        originX: 0,
        originY: 0
    }
};

const els = {};
let activeDialog = null;
let activePicker = null;
let notificationAudio = null;
let announcementTimer = null;
let remoteFeedTimer = null;
let lastRemoteFeedRequestAt = 0;
let snapshotTimer = null;

const MAP_BOUNDS = {
    west: -4096,
    east: 4096,
    south: -4096,
    north: 8192
};

const MAP_COORD_CALIBRATION = {
    x: -725,
    y: -170
};

const BLIP_MAP_MIN_ZOOM = 1;
const BLIP_MAP_MAX_ZOOM = 4;
const BLIP_MAP_DEFAULT_ZOOM = 1;
const TRACKER_SNAPSHOT_INTERVAL = 2000;

const MAP_ASSETS = [
    'map.jpg',
    'map.png',
    'assets/map.jpg',
    'assets/map.png'
];

const focusReleaseActions = new Set([
    'player.openInventory',
    'inventory.openStash',
    'inventory.openTrunk',
    'player.clothing'
]);

const protectedSelfTargetActions = {
    'player.spectate': 'You cannot spectate yourself.',
    'player.control': 'You cannot control yourself.',
    'player.cuff': 'You cannot cuff yourself from the admin menu.',
    'player.jail': 'You cannot jail yourself from the admin menu.',
    'player.kick': 'You cannot kick yourself from the admin menu.',
    'player.ban': 'You cannot ban yourself from the admin menu.',
    'player.deleteCharacter': 'You cannot delete your own character from the admin menu.'
};

const actionConfirmations = {
    'player.deleteCharacter': {
        title: 'Delete Character',
        message: 'Delete this character? This cannot be undone.',
        confirmText: 'Delete',
        danger: true
    },
    'player.clearInventory': {
        title: 'Clear Inventory',
        message: 'Clear this player inventory?',
        confirmText: 'Clear',
        danger: true
    },
    'player.clearVehicleKeys': {
        title: 'Clear Vehicle Keys',
        message: 'Remove all configured vehicle key items from this player inventory?',
        confirmText: 'Clear Keys',
        danger: true
    },
    'player.clearWeapons': {
        title: 'Clear Weapons',
        message: 'Clear this player weapons?',
        confirmText: 'Clear',
        danger: true
    },
    'server.reviveAll': {
        title: 'Revive All',
        message: 'Revive every online player?',
        confirmText: 'Revive All'
    },
    'player.kick': {
        title: 'Kick Player',
        message: 'Kick the selected player?',
        confirmText: 'Kick',
        danger: true
    },
    'player.ban': {
        title: 'Ban Player',
        message: 'Ban the selected player?',
        confirmText: 'Ban',
        danger: true
    },
    'player.warn': {
        title: 'Warn Player',
        message: 'Warn the selected player?',
        confirmText: 'Warn'
    },
    'player.kill': {
        title: 'Kill Player',
        message: 'Kill the selected player?',
        confirmText: 'Kill',
        danger: true
    },
    'player.explode': {
        title: 'Explode Player',
        message: 'Trigger an explosion on the selected player?',
        confirmText: 'Explode',
        danger: true
    },
    'player.burn': {
        title: 'Burn Player',
        message: 'Set the selected player on fire?',
        confirmText: 'Burn',
        danger: true
    },
    'vehicle.delete': {
        title: 'Delete Vehicle',
        message: 'Delete the selected or nearby vehicle?',
        confirmText: 'Delete',
        danger: true
    },
    'vehicle.impound': {
        title: 'Impound Vehicle',
        message: 'Impound the selected player current or nearby vehicle?',
        confirmText: 'Impound',
        danger: true
    },
    'staff.tagClear': {
        title: 'Clear Staff Tag',
        message: 'Remove this player custom staff tag?',
        confirmText: 'Clear Tag',
        danger: true
    }
};

function icon(name) {
    const paths = iconPaths[name] || '<circle cx="12" cy="12" r="8"/>';
    return `<svg class="icon" viewBox="0 0 24 24" aria-hidden="true">${paths}</svg>`;
}

function helpTip(text) {
    const label = escapeHtml(text);
    return `<span class="help-dot" data-tooltip="${label}" aria-label="${label}">${icon('help')}</span>`;
}

function hydrateStaticIcons(root = document) {
    root.querySelectorAll('[data-icon]').forEach((el) => {
        el.innerHTML = icon(el.dataset.icon);
    });
}

function escapeHtml(value) {
    return String(value ?? '').replace(/[&<>"']/g, (char) => ({
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;'
    })[char]);
}

function formatMoney(value) {
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD',
        maximumFractionDigits: 0
    }).format(Number(value) || 0);
}

function formatTime(timestamp) {
    if (!timestamp) return '--';
    return new Date(timestamp * 1000).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
}

function initials(name) {
    return String(name || 'Admin')
        .split(/\s+/)
        .filter(Boolean)
        .slice(0, 2)
        .map((part) => part[0])
        .join('')
        .toUpperCase() || 'A';
}

function playerAvatar(player, className = '') {
    const label = initials(player?.displayName || player?.name);
    if (player?.discordAvatar) {
        return `<span class="avatar ${className}"><img src="${escapeHtml(player.discordAvatar)}" alt="" draggable="false" onerror="this.remove();this.parentElement.textContent='${escapeHtml(label)}';"></span>`;
    }

    return `<span class="avatar ${className}">${escapeHtml(label)}</span>`;
}

function tagColorRgb(color) {
    const match = String(color || '').trim().match(/^#?([0-9a-f]{6}|[0-9a-f]{3})$/i);
    if (!match) return '';

    const hex = match[1].length === 3
        ? match[1].split('').map((char) => char + char).join('')
        : match[1];
    const value = Number.parseInt(hex, 16);
    return `${(value >> 16) & 255}, ${(value >> 8) & 255}, ${value & 255}`;
}

function staffTagMarkup(tagOrPlayer, className = '') {
    const tag = tagOrPlayer?.staffTag
        || (Array.isArray(tagOrPlayer?.staffTags) ? tagOrPlayer.staffTags[0] : null)
        || tagOrPlayer;
    if (!tag?.label) return '';

    const rawColor = String(tag.color || 'red').trim();
    const safeClass = rawColor.replace(/[^a-z0-9_-]/gi, '').toLowerCase() || 'red';
    const rgb = tagColorRgb(rawColor);
    const style = rgb ? ` style="--tag-rgb:${rgb};"` : '';
    return `<span class="staff-tag ${safeClass} ${className}"${style}>${escapeHtml(tag.label)}</span>`;
}

function playerStaffTagsMarkup(player, className = '') {
    const tags = Array.isArray(player?.staffTags) && player.staffTags.length > 0
        ? player.staffTags
        : (player?.staffTag ? [player.staffTag] : []);

    return tags.map((tag) => staffTagMarkup(tag, className)).join('');
}

function resourceName() {
    if (typeof GetParentResourceName === 'function') return GetParentResourceName();
    return null;
}

function mapAssetCandidates() {
    const resource = resourceName();
    if (!resource) return MAP_ASSETS;

    return [
        ...MAP_ASSETS,
        ...MAP_ASSETS.map((asset) => `https://cfx-nui-${resource}/web/${asset}`),
        ...MAP_ASSETS.map((asset) => `nui://${resource}/web/${asset}`)
    ];
}

function useNextMapAsset(image) {
    const candidates = mapAssetCandidates();
    const nextIndex = Number(image.dataset.mapIndex || 0) + 1;
    if (nextIndex >= candidates.length) {
        image.hidden = true;
        return;
    }

    image.dataset.mapIndex = String(nextIndex);
    image.src = candidates[nextIndex];
}

async function nui(callback, payload = {}) {
    const resource = resourceName();
    if (!resource) {
        return demoCallback(callback, payload);
    }

    try {
        const response = await fetch(`https://${resource}/${callback}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(payload)
        });

        return await response.json();
    } catch (error) {
        console.error(`NUI callback failed: ${callback}`, error);
        if (callback !== 'close') {
            toast('Menu callback failed. Try reopening the menu.', 'error');
        }
        return { ok: false, error: String(error) };
    }
}

function can(permission) {
    return state.snapshot?.self?.permissions?.[permission] === true || state.snapshot?.self?.permissions?.all === true;
}

function players() {
    return state.snapshot?.players || [];
}

function ownedVehicles() {
    return state.snapshot?.ownedVehicles || [];
}

function selectedPlayer() {
    return players().find((player) => player.id === state.selectedId) || null;
}

function playerById(id) {
    const numericId = Number(id);
    return players().find((player) => Number(player.id) === numericId) || null;
}

function remoteFeedConfig() {
    return state.snapshot?.config?.remoteFeed || {};
}

function remoteFeedEnabled() {
    const config = remoteFeedConfig();
    return config.enabled !== false && can('spectate');
}

function remoteFeedPlayerIds() {
    const config = remoteFeedConfig();
    const maxPlayers = Math.max(1, Math.min(12, Number(config.maxPlayers || 8)));
    const currentSelfId = selfId();

    return players()
        .filter((player) => Number(player.id) !== currentSelfId)
        .slice(0, maxPlayers)
        .map((player) => Number(player.id))
        .filter(Number.isFinite);
}

function remoteFeedPreviewHtml(item) {
    const feed = state.remoteFeeds[item.id] || {};
    const status = feed.error
        ? 'Unavailable'
        : feed.image
            ? 'Live'
            : feed.loading
                ? 'Loading'
                : 'Waiting';
    const updated = feed.updatedAt
        ? `${Math.max(0, Math.round((Date.now() - feed.updatedAt) / 1000))}s`
        : 'No frame';

    return `
        <div class="monitor-feed-preview ${feed.error ? 'error' : ''}" data-feed-preview="${item.id}">
            ${feed.image
                ? `<img src="${escapeHtml(feed.image)}" alt="">`
                : `<div class="monitor-feed-placeholder">${icon('eye')}</div>`}
            <span>${status}</span>
            <small>${escapeHtml(feed.error || updated)}</small>
        </div>
    `;
}

function updateRemoteFeedCard(targetId) {
    if (!state.open || state.view !== 'monitoring') return;

    const item = playerById(targetId);
    const preview = document.querySelector(`[data-feed-preview="${targetId}"]`);
    if (item && preview) {
        preview.outerHTML = remoteFeedPreviewHtml(item);
    }
}

function requestRemoteFeeds() {
    if (!state.open || state.view !== 'monitoring' || !remoteFeedEnabled()) return;

    const targets = remoteFeedPlayerIds();
    if (targets.length === 0) return;

    const interval = Math.max(1500, Number(remoteFeedConfig().refreshInterval || 3500));
    const now = Date.now();
    if (lastRemoteFeedRequestAt && now - lastRemoteFeedRequestAt < Math.floor(interval * 0.75)) return;
    lastRemoteFeedRequestAt = now;

    targets.forEach((target) => {
        state.remoteFeeds[target] = {
            ...(state.remoteFeeds[target] || {}),
            loading: true,
            error: null
        };
    });

    nui('remoteFeed', { targets });
}

function stopRemoteFeedPolling() {
    if (remoteFeedTimer) {
        clearInterval(remoteFeedTimer);
        remoteFeedTimer = null;
    }
}

function updateRemoteFeedPolling() {
    stopRemoteFeedPolling();

    if (!state.open || state.view !== 'monitoring' || !remoteFeedEnabled()) return;

    const interval = Math.max(1500, Number(remoteFeedConfig().refreshInterval || 3500));
    requestRemoteFeeds();
    remoteFeedTimer = setInterval(requestRemoteFeeds, interval);
}

function requestSnapshot() {
    if (!state.open || !['home', 'blips'].includes(state.view)) return;
    nui('refresh');
}

function stopSnapshotPolling() {
    if (snapshotTimer) {
        clearInterval(snapshotTimer);
        snapshotTimer = null;
    }
}

function updateSnapshotPolling() {
    if (!state.open || !['home', 'blips'].includes(state.view)) {
        stopSnapshotPolling();
        return;
    }

    if (snapshotTimer) return;

    requestSnapshot();
    snapshotTimer = setInterval(requestSnapshot, TRACKER_SNAPSHOT_INTERVAL);
}

function selfId() {
    const id = Number(state.snapshot?.self?.id);
    return Number.isFinite(id) ? id : null;
}

function canManagePlayerNote(note = {}) {
    return Number(note.actorId) === selfId() || can('all');
}

function selectedPlayerNote(noteId) {
    const player = selectedPlayer();
    return (player?.notes || []).find((note) => String(note.id) === String(noteId)) || null;
}

function warningId(warning = {}, index = 0) {
    return warning.id || `legacy:${warning.time || 0}:${index + 1}:${warning.reason || ''}`;
}

function selectedPlayerWarning(warningIdValue) {
    const player = selectedPlayer();
    return (player?.warnings || []).map((warning, index) => ({
        ...warning,
        _id: warningId(warning, index)
    })).find((warning) => String(warning._id) === String(warningIdValue)) || null;
}

function playerActionHistory(player) {
    if (!player) return [];

    const names = new Set([
        String(player.id),
        player.name,
        player.displayName,
        player.citizenid,
        player.license
    ].filter(Boolean).map((value) => String(value).toLowerCase()));

    return (state.snapshot?.actionLogs || [])
        .filter((log) => {
            const target = String(log.target || '').toLowerCase();
            return [...names].some((name) => name && target.includes(name));
        })
        .slice(0, 8);
}

function consoleCommandSuggestions() {
    const config = state.snapshot?.config?.console || {};
    const suggestions = Array.isArray(config.suggestions) ? config.suggestions : [];
    if (suggestions.length > 0) {
        return suggestions.map((item) => ({
            command: item.command || item.template || '',
            label: item.label || item.command || item.template || 'Command',
            template: item.template || item.command || ''
        })).filter((item) => item.template);
    }

    return (Array.isArray(config.allowedCommands) ? config.allowedCommands : []).map((command) => {
        const needsSpace = ['say', 'ensure', 'restart', 'start', 'stop'].includes(String(command).toLowerCase());
        return {
            command,
            label: command,
            template: `${command}${needsSpace ? ' ' : ''}`
        };
    });
}

function adminChatTemplates() {
    const templates = state.snapshot?.config?.adminChat?.templates;
    const fallback = [
        'Please keep chat respectful.',
        'Staff is reviewing this now.',
        'Move to support if you need more help.',
        'Reminder: follow server rules and roleplay standards.'
    ];
    return (Array.isArray(templates) && templates.length > 0 ? templates : fallback)
        .map((item) => String(item || '').trim())
        .filter(Boolean);
}

function consoleCommandHistory() {
    return (state.snapshot?.actionLogs || [])
        .filter((log) => log.action === 'Console Command' && log.detail)
        .map((log) => String(log.detail));
}

function focusElement(element) {
    if (!element || typeof element.focus !== 'function') return;

    try {
        element.focus({ preventScroll: true });
    } catch (_) {
        element.focus();
    }
}

function captureScrollPositions(container) {
    const positions = {};
    container?.querySelectorAll('[data-scroll-key]').forEach((element) => {
        positions[element.dataset.scrollKey] = element.scrollTop;
    });
    return positions;
}

function setAdminChatInput(message, focus = true) {
    const input = document.getElementById('adminChatInput');
    if (!input) return;

    input.value = message || '';
    if (focus) {
        focusElement(input);
        const end = input.value.length;
        input.setSelectionRange?.(end, end);
    }
}

function setConsoleInput(command, focus = true) {
    const input = document.getElementById('consoleInput');
    if (!input) return;

    input.value = command || '';
    if (focus) {
        focusElement(input);
        const end = input.value.length;
        input.setSelectionRange?.(end, end);
    }
}

function completeAdminChatInput(input) {
    const current = input.value || '';
    const cursor = typeof input.selectionStart === 'number' ? input.selectionStart : current.length;
    const beforeCursor = current.slice(0, cursor);
    const token = beforeCursor.trim().toLowerCase();

    const match = adminChatTemplates().find((template) => template.toLowerCase().startsWith(token));
    if (!match) return false;

    input.value = `${match}${current.slice(cursor)}`;
    input.setSelectionRange?.(match.length, match.length);
    return true;
}

function completeConsoleCommand(input) {
    const current = input.value || '';
    const cursor = typeof input.selectionStart === 'number' ? input.selectionStart : current.length;
    const beforeCursor = current.slice(0, cursor);
    const firstSpace = beforeCursor.search(/\s/);
    if (firstSpace !== -1) return false;

    const token = beforeCursor.trim().toLowerCase();
    const match = consoleCommandSuggestions().find((item) => {
        const command = String(item.command || item.template || '').toLowerCase();
        return !token || command.startsWith(token);
    });

    if (!match) return false;

    const replacement = match.template || match.command || '';
    input.value = `${replacement}${current.slice(cursor)}`;
    const nextCursor = replacement.length;
    input.setSelectionRange?.(nextCursor, nextCursor);
    return true;
}

function eventByName(name) {
    return (state.snapshot?.config?.events || []).find((event) => event.name === name) || null;
}

function eventNameFromLog(log = {}) {
    const detail = String(log.detail || '');
    return detail.split(' -> ')[0] || String(log.target || '');
}

function selectedEventName() {
    const events = state.snapshot?.config?.events || [];
    return value('eventSelect', events[0]?.name || '');
}

function parseJsonInput(id, fallback = {}) {
    const raw = value(id, '').trim();
    if (!raw) return fallback;

    try {
        return JSON.parse(raw);
    } catch (_) {
        toast('Payload JSON is invalid.', 'error');
        return null;
    }
}

function eventPayloadText(event) {
    return JSON.stringify(event?.payload || {}, null, 2);
}

function setEventSelection(name) {
    const eventConfig = eventByName(name);
    const select = document.getElementById('eventSelect');
    const payload = document.getElementById('eventPayloadInput');
    const target = document.getElementById('eventTargetInput');

    if (select && eventConfig) select.value = eventConfig.name;
    if (payload) payload.value = eventPayloadText(eventConfig);
    if (target && eventConfig?.type === 'client') {
        target.value = String(selectedPlayer()?.id ?? -1);
    }
}

function permissionLabel(key) {
    return String(key || '')
        .replace(/([A-Z])/g, ' $1')
        .replace(/[_-]+/g, ' ')
        .replace(/\b\w/g, (char) => char.toUpperCase())
        .trim();
}

function staffRoster() {
    return players().filter((player) => {
        const hasTags = Array.isArray(player.staffTags) && player.staffTags.length > 0;
        return player.duty || player.staffTag || hasTags;
    });
}

function targetIdForAction(payload = {}) {
    const explicit = payload.target ?? payload.targetId ?? payload.id;
    if (explicit != null) {
        const id = Number(explicit);
        return Number.isFinite(id) ? id : null;
    }

    const player = selectedPlayer();
    return player ? Number(player.id) : null;
}

function selfTargetBlockMessage(actionName, payload = {}) {
    const targetId = targetIdForAction(payload);
    const localId = selfId();
    if (localId == null || targetId !== localId) return '';

    if (actionName === 'player.freeze') {
        return payload.state === false ? '' : 'You cannot freeze yourself from the admin menu.';
    }

    return protectedSelfTargetActions[actionName] || '';
}

function runAttributes(actionName, payload = {}) {
    const blockMessage = selfTargetBlockMessage(actionName, payload);
    const disabled = blockMessage ? ` disabled title="${escapeHtml(blockMessage)}"` : '';
    return `data-run="${escapeHtml(actionName)}"${disabled}`;
}

function syncSelectedPlayer() {
    const list = players();
    if (list.length === 0) {
        state.selectedId = null;
        return;
    }

    if (!list.some((player) => player.id === state.selectedId)) {
        state.selectedId = list[0].id;
    }
}

function filteredPlayers() {
    const search = `${state.playerSearch} ${state.globalSearch}`.trim().toLowerCase();
    if (!search) return players();

    return players().filter((player) => [
        player.id,
        player.name,
        player.displayName,
        player.citizenid,
        player.license,
        player.discord,
        player.job?.label
    ].join(' ').toLowerCase().includes(search));
}

async function action(actionName, payload = {}) {
    const targetActions = actionName.startsWith('player.')
        || actionName.startsWith('staff.')
        || ['item.give', 'item.remove', 'money.add', 'money.remove', 'money.set', 'vehicle.repair', 'vehicle.flip', 'vehicle.delete', 'vehicle.keys', 'vehicle.refuel', 'vehicle.clean', 'vehicle.impound', 'vehicle.maxMods', 'vehicle.spawnForPlayer', 'vehicle.giveOwned'].includes(actionName);
    const player = selectedPlayer();

    if (targetActions && player && payload.target == null && actionName !== 'player.teleportCoords') {
        payload = { ...payload, target: player.id };
    }

    const blockMessage = selfTargetBlockMessage(actionName, payload);
    if (blockMessage) {
        toast(blockMessage, 'warning');
        return { ok: false, message: blockMessage };
    }

    return nui('action', { action: actionName, ...payload });
}

function setSelected(id) {
    state.selectedId = Number(id);
    render();
}

function clampBlipZoom(value) {
    return Math.max(BLIP_MAP_MIN_ZOOM, Math.min(BLIP_MAP_MAX_ZOOM, Number(value) || BLIP_MAP_DEFAULT_ZOOM));
}

function blipMapViewport() {
    return document.querySelector('[data-map-viewport]');
}

function constrainBlipMap(viewport = blipMapViewport()) {
    const map = state.blipMap;
    map.zoom = clampBlipZoom(map.zoom);

    if (!viewport) return;

    if (map.zoom <= 1) {
        map.x = 0;
        map.y = 0;
        return;
    }

    const rect = viewport.getBoundingClientRect();
    const maxX = ((map.zoom - 1) * rect.width) / 2;
    const maxY = ((map.zoom - 1) * rect.height) / 2;
    map.x = Math.max(-maxX, Math.min(maxX, Number(map.x) || 0));
    map.y = Math.max(-maxY, Math.min(maxY, Number(map.y) || 0));
}

function blipMapLayerStyle() {
    const map = state.blipMap;
    constrainBlipMap();

    return [
        `transform:translate(${map.x}px, ${map.y}px) scale(${map.zoom})`,
        `--map-marker-scale:${1 / map.zoom}`
    ].join(';');
}

function setBlipMapZoom(nextZoom, clientX = null, clientY = null) {
    const viewport = blipMapViewport();
    const map = state.blipMap;
    const previousZoom = map.zoom;
    const zoom = clampBlipZoom(nextZoom);
    if (zoom === previousZoom) return;

    if (viewport && clientX != null && clientY != null) {
        const rect = viewport.getBoundingClientRect();
        const x = clientX - rect.left - (rect.width / 2);
        const y = clientY - rect.top - (rect.height / 2);
        map.x = x - (((x - map.x) / previousZoom) * zoom);
        map.y = y - (((y - map.y) / previousZoom) * zoom);
    }

    map.zoom = zoom;
    constrainBlipMap(viewport);
    render({ preserveScroll: true });
}

function resetBlipMap() {
    state.blipMap.zoom = BLIP_MAP_DEFAULT_ZOOM;
    state.blipMap.x = 0;
    state.blipMap.y = 0;
    render({ preserveScroll: true });
}

function centerBlipMapOnSelected() {
    const viewport = blipMapViewport();
    const player = selectedPlayer();
    const pos = mapPosition(player?.coords, 0);
    if (!viewport || !pos) return;

    const rect = viewport.getBoundingClientRect();
    const map = state.blipMap;
    map.zoom = Math.max(map.zoom, 2);
    map.x = -(((pos.left - 50) / 100) * rect.width * map.zoom);
    map.y = -(((pos.top - 50) / 100) * rect.height * map.zoom);
    constrainBlipMap(viewport);
    render({ preserveScroll: true });
}

function mapPosition(coords = {}, edge = 0.5) {
    const x = Number(coords.x) + MAP_COORD_CALIBRATION.x;
    const y = Number(coords.y) + MAP_COORD_CALIBRATION.y;
    if (!Number.isFinite(x) || !Number.isFinite(y)) return null;

    const left = clampPercent(((x - MAP_BOUNDS.west) / (MAP_BOUNDS.east - MAP_BOUNDS.west)) * 100, edge);
    const top = clampPercent((1 - ((y - MAP_BOUNDS.south) / (MAP_BOUNDS.north - MAP_BOUNDS.south))) * 100, edge);
    return { left, top };
}

function clampPercent(value, edge = 4) {
    return Math.max(edge, Math.min(100 - edge, Number(value) || 0));
}

function mapPopPosition(coords = {}) {
    const pos = mapPosition(coords, 8);
    if (!pos) return null;

    return {
        left: pos.left,
        top: pos.top,
        below: pos.top < 24
    };
}

function mapPopStyle(pos) {
    return `left:clamp(76px, ${pos.left}%, calc(100% - 76px));top:${pos.top}%;`;
}

function playerDistanceFromSelected(player) {
    const selected = selectedPlayer();
    if (!selected?.coords || !player?.coords || Number(selected.id) === Number(player.id)) return null;

    const dx = Number(player.coords.x || 0) - Number(selected.coords.x || 0);
    const dy = Number(player.coords.y || 0) - Number(selected.coords.y || 0);
    const dz = Number(player.coords.z || 0) - Number(selected.coords.z || 0);
    return Math.sqrt((dx * dx) + (dy * dy) + (dz * dz));
}

function formatDistance(distance) {
    if (!Number.isFinite(distance)) return '-';
    if (distance >= 1000) return `${(distance / 1000).toFixed(1)}km`;
    return `${Math.round(distance)}m`;
}

function distanceFromSelectedCoords(coords) {
    const selected = selectedPlayer();
    if (!selected?.coords || !coords) return null;

    const dx = Number(coords.x || 0) - Number(selected.coords.x || 0);
    const dy = Number(coords.y || 0) - Number(selected.coords.y || 0);
    const dz = Number(coords.z || 0) - Number(selected.coords.z || 0);
    return Math.sqrt((dx * dx) + (dy * dy) + (dz * dz));
}

function coordsString(coords = {}) {
    return `${Number(coords.x || 0)}, ${Number(coords.y || 0)}, ${Number(coords.z || 0)}, ${Number(coords.h || 0)}`;
}

function coordNumber(value) {
    const number = Number(value || 0);
    return Number.isFinite(number) ? number.toFixed(2) : '0.00';
}

function coordHeading(value) {
    const number = Number(value || 0);
    return Number.isFinite(number) ? number.toFixed(2) : '0.00';
}

function coordFormat(coords = {}, format = 'vector4') {
    const x = coordNumber(coords.x);
    const y = coordNumber(coords.y);
    const z = coordNumber(coords.z);
    const h = coordHeading(coords.h);

    if (format === 'vector3') return `vector3(${x}, ${y}, ${z})`;
    if (format === 'vector4') return `vector4(${x}, ${y}, ${z}, ${h})`;
    if (format === 'table') return `{ x = ${x}, y = ${y}, z = ${z}, h = ${h} }`;
    if (format === 'heading') return h;
    return `${x}, ${y}, ${z}, ${h}`;
}

function coordCopyButtons(coords = {}, prefix = '') {
    const formats = [
        ['Vector3', 'vector3'],
        ['Vector4', 'vector4'],
        ['Coords', 'raw'],
        ['Table', 'table'],
        ['Heading', 'heading']
    ];

    return formats.map(([label, format]) => `
        <button class="soft-button" data-copy-text="${escapeHtml(coordFormat(coords, format))}" title="Copy ${escapeHtml(prefix ? `${prefix} ` : '')}${escapeHtml(label)}">
            ${icon('copy')}<span>${escapeHtml(label)}</span>
        </button>
    `).join('');
}

function loadCoordFavorites() {
    try {
        const raw = localStorage.getItem('snipz_adminmenu_coord_favorites');
        const parsed = raw ? JSON.parse(raw) : [];
        return Array.isArray(parsed) ? parsed.filter((item) => item && item.coords).slice(0, 40) : [];
    } catch (_) {
        return [];
    }
}

function saveCoordFavorites() {
    try {
        localStorage.setItem('snipz_adminmenu_coord_favorites', JSON.stringify(state.coordFavorites.slice(0, 40)));
    } catch (_) {
        toast('Could not save coordinate favorite in this browser.', 'warning');
    }
}

function coordSource(which) {
    if (which === 'target') return state.coordTool.target;
    return state.coordTool.player;
}

function playerMapMarkers(className = '') {
    return players().map((player) => {
        const pos = mapPosition(player.coords);
        if (!pos) return '';

        const title = `${player.displayName || player.name} - x:${Number(player.coords?.x || 0).toFixed(1)}, y:${Number(player.coords?.y || 0).toFixed(1)}`;
        return `<button class="map-marker ${className} ${player.id === state.selectedId ? 'selected' : ''} ${player.duty ? 'staff' : ''}" style="left:${pos.left}%;top:${pos.top}%;" data-select="${player.id}" title="${escapeHtml(title)}"></button>`;
    }).filter(Boolean).join('');
}

function ownedVehicleMapMarkers(className = '') {
    return ownedVehicles().map((vehicle) => {
        const pos = mapPosition(vehicle.coords);
        if (!pos) return '';

        const plate = vehicle.plate || 'NO PLATE';
        const model = vehicle.model || 'Vehicle';
        const owner = vehicle.ownerName || vehicle.citizenid || 'Unknown Owner';
        const title = `${plate} - ${model} - ${owner}${vehicle.stale ? ' - last known' : ''}`;
        return `<button class="map-marker vehicle-marker ${className} ${vehicle.stale ? 'stale' : ''}" style="left:${pos.left}%;top:${pos.top}%;" title="${escapeHtml(title)}" aria-label="${escapeHtml(title)}"></button>`;
    }).filter(Boolean).join('');
}

function copyText(value, message = 'Copied.') {
    const text = String(value || '');
    const fallbackCopy = () => {
        const input = document.createElement('textarea');
        input.value = text;
        document.body.appendChild(input);
        input.select();
        document.execCommand('copy');
        input.remove();
        toast(message, 'success');
    };

    if (navigator.clipboard?.writeText) {
        navigator.clipboard.writeText(text)
            .then(() => toast(message, 'success'))
            .catch(fallbackCopy);
        return;
    }

    fallbackCopy();
}

function notificationTitle(type) {
    return {
        success: 'Action Complete',
        error: 'Action Failed',
        warning: 'Staff Alert',
        inform: 'Admin Notice'
    }[type] || 'Admin Notice';
}

function playNotificationSound() {
    try {
        if (!notificationAudio) {
            notificationAudio = new Audio('assets/notification.mp3');
            notificationAudio.volume = 0.55;
        }

        notificationAudio.currentTime = 0;
        notificationAudio.play().catch(() => {});
    } catch (_) {
        // Audio is non-critical; NUI can reject playback before interaction.
    }
}

function renderNotificationCenter() {
    if (!els.notificationCenter) return;

    const recent = state.notifications.slice(0, 24);
    els.notificationCenter.hidden = !state.notificationOpen;
    if (els.notificationBtn) els.notificationBtn.setAttribute('aria-expanded', state.notificationOpen ? 'true' : 'false');
    if (els.notificationCount) els.notificationCount.textContent = String(recent.length);

    els.notificationCenter.innerHTML = `
        <header>
            <div>
                <strong>Notifications</strong>
                <span>${recent.length} recent</span>
            </div>
            <button class="soft-button" data-clear-notifications>Clear</button>
        </header>
        <div class="notification-list">
            ${recent.map((item) => `
                <article class="notification-item ${escapeHtml(item.type)}">
                    <div>
                        <strong>${escapeHtml(item.title)}</strong>
                        <time>${escapeHtml(item.time)}</time>
                    </div>
                    <p>${escapeHtml(item.message)}</p>
                </article>
            `).join('') || '<div class="empty">No notifications yet</div>'}
        </div>
    `;
}

function toast(message, type = 'inform', title = null, options = {}) {
    const safeType = ['success', 'error', 'warning', 'inform'].includes(type) ? type : 'inform';
    const entry = {
        id: Date.now() + Math.random(),
        title: title || notificationTitle(safeType),
        message: String(message || 'Action complete.'),
        type: safeType,
        time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    };

    state.notifications.unshift(entry);
    state.notifications = state.notifications.slice(0, 40);
    renderNotificationCenter();
    if (options.sound !== false) playNotificationSound();

    const el = document.createElement('div');
    el.className = `toast ${safeType}`;
    el.innerHTML = `<strong>${escapeHtml(entry.title)}</strong><span>${escapeHtml(entry.message)}</span>`;
    els.toasts.appendChild(el);
    setTimeout(() => el.remove(), safeType === 'error' || safeType === 'warning' ? 6500 : 4200);
}

function showAnnouncement(payload = {}) {
    if (!els.announcementHost) return;

    const message = String(payload.message || '').trim();
    if (!message) return;

    playNotificationSound();
    clearTimeout(announcementTimer);
    els.announcementHost.innerHTML = `
        <section class="announcement-banner ${escapeHtml(payload.tone || '')}">
            <small>${escapeHtml(payload.label || 'Server Announcement')}</small>
            ${payload.actor ? `<strong>${escapeHtml(payload.actor)}</strong>` : ''}
            <p>${escapeHtml(message)}</p>
        </section>
    `;

    announcementTimer = setTimeout(() => {
        els.announcementHost.innerHTML = '';
    }, 8500);
}

function closeSelectPicker() {
    if (!activePicker) return false;

    window.removeEventListener('resize', activePicker.onClose, true);
    document.removeEventListener('pointerdown', activePicker.onPointerDown, true);
    activePicker.overlay.remove();
    activePicker = null;
    return true;
}

function openSelectPicker(select) {
    if (!select || select.disabled) return;
    closeSelectPicker();

    const options = Array.from(select.options).filter((option) => !option.disabled);
    const overlay = document.createElement('div');
    overlay.className = 'select-picker';
    overlay.innerHTML = `
        <div class="select-picker-search">
            <span class="field-icon">${icon('search')}</span>
            <input type="search" placeholder="Search options">
        </div>
        <div class="select-picker-list"></div>
    `;

    const search = overlay.querySelector('input');
    const list = overlay.querySelector('.select-picker-list');
    const choose = (value) => {
        select.value = value;
        select.dispatchEvent(new Event('input', { bubbles: true }));
        select.dispatchEvent(new Event('change', { bubbles: true }));
        closeSelectPicker();
        select.focus();
    };
    const renderOptions = () => {
        const query = search.value.trim().toLowerCase();
        const visible = options.filter((option) => !query || option.textContent.toLowerCase().includes(query) || option.value.toLowerCase().includes(query));
        list.innerHTML = visible.map((option) => `
            <button class="${option.value === select.value ? 'active' : ''}" data-picker-value="${escapeHtml(option.value)}">
                <span>${escapeHtml(option.textContent)}</span>
                <small>${escapeHtml(option.value)}</small>
            </button>
        `).join('') || '<div class="empty">No matches</div>';
    };

    overlay.addEventListener('click', (event) => {
        const option = event.target.closest('[data-picker-value]');
        if (option) choose(option.dataset.pickerValue);
    });
    search.addEventListener('input', renderOptions);
    search.addEventListener('keydown', (event) => {
        if (event.key === 'Escape') {
            event.preventDefault();
            closeSelectPicker();
            select.focus();
        }
        if (event.key === 'Enter') {
            const first = list.querySelector('[data-picker-value]');
            if (first) choose(first.dataset.pickerValue);
        }
    });

    (els.app || document.body).appendChild(overlay);
    const rect = select.getBoundingClientRect();
    const width = Math.max(rect.width, 260);
    const spaceBelow = window.innerHeight - rect.bottom - 10;
    const spaceAbove = rect.top - 10;
    const openUp = spaceBelow < 230 && spaceAbove > spaceBelow;
    const listHeight = Math.max(160, Math.min(320, openUp ? spaceAbove - 58 : spaceBelow - 58));
    overlay.style.left = `${Math.max(10, Math.min(rect.left, window.innerWidth - width - 10))}px`;
    overlay.style.top = `${openUp ? Math.max(10, rect.top - listHeight - 66) : rect.bottom + 6}px`;
    overlay.style.width = `${width}px`;
    list.style.maxHeight = `${listHeight}px`;

    renderOptions();
    const picker = {
        overlay,
        onClose: closeSelectPicker,
        onPointerDown: (event) => {
            if (overlay.contains(event.target) || event.target === select) return;
            closeSelectPicker();
        }
    };
    activePicker = picker;

    setTimeout(() => {
        if (activePicker !== picker) return;
        document.addEventListener('pointerdown', picker.onPointerDown, true);
        window.addEventListener('resize', picker.onClose, true);
        search.focus();
    }, 0);
}

function closeActiveDialog(value = null) {
    if (!activeDialog) return false;

    const dialog = activeDialog;
    activeDialog = null;
    window.removeEventListener('keydown', dialog.onKeyDown, true);
    dialog.backdrop.remove();
    dialog.resolve(value);
    return true;
}

function showDialog({
    title,
    message,
    placeholder = '',
    defaultValue = '',
    confirmText = 'Confirm',
    cancelText = 'Cancel',
    danger = false,
    input = false
}) {
    closeActiveDialog(null);

    return new Promise((resolve) => {
        const backdrop = document.createElement('div');
        backdrop.className = 'dialog-backdrop';
        backdrop.innerHTML = `
            <form class="dialog-card">
                <div class="dialog-copy">
                    <h3>${escapeHtml(title)}</h3>
                    ${message ? `<p>${escapeHtml(message)}</p>` : ''}
                </div>
                ${input ? `<textarea class="dialog-input" rows="3" placeholder="${escapeHtml(placeholder)}">${escapeHtml(defaultValue)}</textarea>` : ''}
                <div class="dialog-actions">
                    <button type="button" class="soft-button" data-dialog-cancel>${escapeHtml(cancelText)}</button>
                    <button type="submit" class="${danger ? 'danger-button' : 'primary-button'}">${escapeHtml(confirmText)}</button>
                </div>
            </form>
        `;

        const form = backdrop.querySelector('form');
        const field = backdrop.querySelector('.dialog-input');
        const cancelButton = backdrop.querySelector('[data-dialog-cancel]');
        const onKeyDown = (event) => {
            if (event.key !== 'Escape') return;
            event.preventDefault();
            event.stopImmediatePropagation();
            closeActiveDialog(null);
        };

        activeDialog = { backdrop, onKeyDown, resolve };

        backdrop.addEventListener('click', (event) => {
            if (event.target === backdrop) closeActiveDialog(null);
        });

        cancelButton.addEventListener('click', () => closeActiveDialog(null));

        form.addEventListener('submit', (event) => {
            event.preventDefault();
            closeActiveDialog(input ? field.value : true);
        });

        window.addEventListener('keydown', onKeyDown, true);
        (els.app || document.body).appendChild(backdrop);
        setTimeout(() => (field || cancelButton).focus(), 0);
    });
}

async function confirmDialog(message, options = {}) {
    const result = await showDialog({
        title: options.title || 'Confirm action',
        message,
        confirmText: options.confirmText || 'Confirm',
        danger: options.danger === true
    });

    return result === true;
}

async function confirmAction(actionName) {
    const config = actionConfirmations[actionName];
    if (!config) return true;

    const player = selectedPlayer();
    const targetText = player ? ` Target: #${player.id} ${player.displayName || player.name}.` : '';
    return confirmDialog(`${config.message}${targetText}`, {
        title: config.title,
        confirmText: config.confirmText,
        danger: config.danger === true
    });
}

async function promptDialog(options = {}) {
    const result = await showDialog({
        title: options.title || 'Input required',
        message: options.message || '',
        placeholder: options.placeholder || '',
        defaultValue: options.defaultValue || '',
        confirmText: options.confirmText || 'Submit',
        input: true
    });

    return typeof result === 'string' ? result : null;
}

function optionMarkup(options = []) {
    return options.map((option) => {
        const value = typeof option === 'string' ? option : option.value;
        const label = typeof option === 'string' ? option : option.label;
        return `<option value="${escapeHtml(value)}">${escapeHtml(label ?? value)}</option>`;
    }).join('');
}

function configOptions(list = [], valueKey, labelKey) {
    return list.map((item) => ({
        value: item?.[valueKey],
        label: item?.[labelKey] || item?.[valueKey]
    })).filter((item) => item.value != null);
}

function gymStatOptions(config = {}) {
    const stats = config.stats || config.Stats || [];
    return stats.map((item) => {
        if (typeof item === 'string') return { value: item, label: item };
        const value = item?.name ?? item?.key;
        return { value, label: item?.label || value };
    }).filter((item) => item.value);
}

function playerGymStats(player) {
    const stats = player?.metadata?.gym;
    if (!Array.isArray(stats)) return [];
    return stats.map((item) => ({
        label: item?.label || item?.name,
        value: Number(item?.value ?? 0)
    })).filter((item) => item.label);
}

function staffTagOptions(list = []) {
    return list.map((item) => {
        if (typeof item === 'string') return { value: item, label: item };
        return { value: item?.label, label: item?.label };
    }).filter((item) => item.value);
}

function actionDetailSchema(actionName) {
    const config = state.snapshot?.config || {};
    const player = selectedPlayer();
    const coords = player?.coords
        ? `${Number(player.coords.x || 0).toFixed(2)}, ${Number(player.coords.y || 0).toFixed(2)}, ${Number(player.coords.z || 0).toFixed(2)}, ${Number(player.coords.h || 0).toFixed(2)}`
        : '0, 0, 0, 0';
    const gymConfig = config.gymStats || {};
    const gymMin = Number(gymConfig.min ?? gymConfig.Min ?? 0);
    const gymMax = Number(gymConfig.max ?? gymConfig.Max ?? 100);

    const schemas = {
        'player.warn': {
            title: 'Warn Player',
            fields: [{ id: 'reason', label: 'Reason', type: 'textarea', value: 'Rule violation' }]
        },
        'player.kick': {
            title: 'Kick Player',
            fields: [{ id: 'reason', label: 'Reason', type: 'textarea', value: 'Kicked by staff.' }]
        },
        'player.ban': {
            title: 'Ban Player',
            fields: [
                { id: 'reason', label: 'Reason', type: 'textarea', value: 'Rule violation' },
                { id: 'duration', label: 'Duration', type: 'select', options: [
                    { value: 0, label: 'Permanent' },
                    { value: 30, label: '30 minutes' },
                    { value: 120, label: '2 hours' },
                    { value: 1440, label: '1 day' },
                    { value: 10080, label: '7 days' }
                ] }
            ]
        },
        'player.jail': {
            title: 'Jail Player',
            fields: [
                { id: 'reason', label: 'Reason', type: 'textarea', value: 'Jailed by staff.' },
                { id: 'minutes', label: 'Minutes', type: 'number', value: 15, min: 1 }
            ]
        },
        'player.message': {
            title: 'Send Staff Message',
            fields: [{ id: 'message', label: 'Message', type: 'textarea', value: 'Please contact staff.' }]
        },
        'staff.tagSet': {
            title: 'Set Staff Tag',
            fields: [{ id: 'tag', label: 'Tag', type: 'select', options: staffTagOptions(config.staffTags) }]
        },
        'player.reviveRadius': {
            title: 'Revive Radius',
            fields: [{ id: 'radius', label: 'Radius', type: 'number', value: 20, min: 1 }]
        },
        'player.setArmor': {
            title: 'Set Armor',
            fields: [{ id: 'amount', label: 'Armor', type: 'number', value: 100, min: 0 }]
        },
        'player.teleportPreset': {
            title: 'Teleport Preset',
            fields: [{ id: 'preset', label: 'Location', type: 'select', options: configOptions(config.teleportPresets, 'name', 'label') }]
        },
        'player.teleportCoords': {
            title: 'Teleport To Coordinates',
            fields: [{ id: 'coords', label: 'Coordinates', type: 'text', value: coords }]
        },
        'item.give': {
            title: 'Give Item',
            fields: [
                { id: 'item', label: 'Item', type: 'select', options: configOptions(config.items, 'name', 'label') },
                { id: 'amount', label: 'Amount', type: 'number', value: 1, min: 1 }
            ]
        },
        'item.remove': {
            title: 'Remove Item',
            fields: [
                { id: 'item', label: 'Item', type: 'select', options: configOptions(config.items, 'name', 'label') },
                { id: 'amount', label: 'Amount', type: 'number', value: 1, min: 1 }
            ]
        },
        'player.giveWeapon': {
            title: 'Give Weapon',
            fields: [
                { id: 'weapon', label: 'Weapon', type: 'select', options: configOptions(config.weapons, 'name', 'label') },
                { id: 'ammo', label: 'Ammo', type: 'number', value: 120, min: 1 }
            ]
        },
        'money.add': {
            title: 'Add Money',
            fields: [
                { id: 'account', label: 'Account', type: 'select', options: ['cash', 'bank', 'crypto', 'black_money'] },
                { id: 'amount', label: 'Amount', type: 'number', value: 1000, min: 0 }
            ]
        },
        'money.remove': {
            title: 'Remove Money',
            fields: [
                { id: 'account', label: 'Account', type: 'select', options: ['cash', 'bank', 'crypto', 'black_money'] },
                { id: 'amount', label: 'Amount', type: 'number', value: 1000, min: 0 }
            ]
        },
        'money.set': {
            title: 'Set Money',
            fields: [
                { id: 'account', label: 'Account', type: 'select', options: ['cash', 'bank', 'crypto', 'black_money'] },
                { id: 'amount', label: 'Amount', type: 'number', value: 1000, min: 0 }
            ]
        },
        'vehicle.spawn': {
            title: 'Spawn Vehicle',
            fields: [
                { id: 'model', label: 'Vehicle Model', type: 'text', value: value('vehicleInput', 'sultanrs'), placeholder: 'sultanrs, police, adder' },
                { id: 'plate', label: 'Plate', type: 'text', value: value('plateInput', 'ADMIN') }
            ]
        },
        'vehicle.spawnForPlayer': {
            title: 'Spawn Vehicle For Player',
            fields: [
                { id: 'model', label: 'Vehicle Model', type: 'text', value: value('vehicleInput', 'sultanrs'), placeholder: 'sultanrs, police, adder' },
                { id: 'plate', label: 'Plate', type: 'text', value: value('plateInput', 'ADMIN') }
            ]
        },
        'vehicle.giveOwned': {
            title: 'Give Owned Vehicle',
            fields: [
                { id: 'model', label: 'Vehicle Model', type: 'text', value: value('vehicleInput', 'sultanrs'), placeholder: 'sultanrs, police, adder' },
                { id: 'plate', label: 'Plate', type: 'text', value: '', placeholder: 'Leave blank to generate' },
                { id: 'garage', label: 'Garage', type: 'text', value: '', placeholder: 'Optional garage' }
            ]
        },
        'player.setPed': {
            title: 'Set Ped',
            fields: [{ id: 'model', label: 'Ped Model', type: 'text', value: 'mp_m_freemode_01', placeholder: 'mp_m_freemode_01, s_m_y_cop_01, a_m_m_business_01' }]
        },
        'player.setJob': {
            title: 'Update Job',
            fields: [
                { id: 'job', label: 'Job', type: 'select', options: configOptions(config.jobs, 'name', 'label') },
                { id: 'grade', label: 'Grade', type: 'number', value: 0, min: 0 }
            ]
        },
        'player.setGang': {
            title: 'Update Gang',
            fields: [
                { id: 'gang', label: 'Gang', type: 'select', options: configOptions(config.gangs, 'name', 'label') },
                { id: 'grade', label: 'Grade', type: 'number', value: 0, min: 0 }
            ]
        },
        'player.setDuty': {
            title: 'Set Duty',
            fields: [{ id: 'state', label: 'Duty', type: 'select', options: [
                { value: 'true', label: 'On Duty' },
                { value: 'false', label: 'Off Duty' }
            ] }]
        },
        'player.setLicense': {
            title: 'Update License',
            fields: [
                { id: 'license', label: 'License', type: 'select', options: configOptions(config.licenses, 'name', 'label') },
                { id: 'state', label: 'Action', type: 'select', options: [
                    { value: 'true', label: 'Give' },
                    { value: 'false', label: 'Remove' }
                ] }
            ]
        },
        'player.setGymStats': {
            title: 'Set Gym Stat',
            fields: [
                { id: 'stat', label: 'Stat', type: 'select', options: gymStatOptions(gymConfig) },
                { id: 'value', label: 'Value', type: 'number', value: gymMax, min: gymMin }
            ]
        },
        'player.setBucket': {
            title: 'Routing Bucket',
            fields: [{ id: 'bucket', label: 'Bucket', type: 'number', value: Number(player?.bucket) || 0, min: 0 }]
        },
        'inventory.openStash': {
            title: 'Open Stash',
            fields: [{ id: 'stash', label: 'Stash', type: 'text', value: 'policestash' }]
        },
        'inventory.openTrunk': {
            title: 'Open Trunk',
            fields: [{ id: 'plate', label: 'Plate', type: 'text', value: 'ADMIN' }]
        }
    };

    return schemas[actionName] || null;
}

function showActionDetailsDialog(actionName) {
    const schema = actionDetailSchema(actionName);
    if (!schema) return Promise.resolve({});

    closeActiveDialog(null);

    return new Promise((resolve) => {
        const backdrop = document.createElement('div');
        backdrop.className = 'dialog-backdrop';
        backdrop.innerHTML = `
            <form class="dialog-card action-detail-dialog">
                <div class="dialog-copy">
                    <h3>${escapeHtml(schema.title)}</h3>
                </div>
                <div class="action-detail-fields">
                    ${schema.fields.map((field) => `
                        <label class="detail-field">
                            <span>${escapeHtml(field.label)}</span>
                            ${field.type === 'textarea'
                                ? `<textarea data-detail-field="${escapeHtml(field.id)}" rows="3">${escapeHtml(field.value || '')}</textarea>`
                                : field.type === 'select'
                                    ? `<select data-detail-field="${escapeHtml(field.id)}">${optionMarkup(field.options || [])}</select>`
                                    : `<input data-detail-field="${escapeHtml(field.id)}" type="${escapeHtml(field.type || 'text')}" value="${escapeHtml(field.value ?? '')}" ${field.placeholder ? `placeholder="${escapeHtml(field.placeholder)}"` : ''} ${field.min != null ? `min="${escapeHtml(field.min)}"` : ''}>`}
                        </label>
                    `).join('')}
                </div>
                <div class="dialog-actions">
                    <button type="button" class="soft-button" data-dialog-cancel>Cancel</button>
                    <button type="submit" class="primary-button">Continue</button>
                </div>
            </form>
        `;

        const form = backdrop.querySelector('form');
        const cancelButton = backdrop.querySelector('[data-dialog-cancel]');
        const onKeyDown = (event) => {
            if (event.key !== 'Escape') return;
            event.preventDefault();
            event.stopImmediatePropagation();
            closeActiveDialog(null);
        };

        activeDialog = { backdrop, onKeyDown, resolve };
        backdrop.addEventListener('click', (event) => {
            if (event.target === backdrop) closeActiveDialog(null);
        });
        cancelButton.addEventListener('click', () => closeActiveDialog(null));
        form.addEventListener('submit', (event) => {
            event.preventDefault();
            const payload = {};
            form.querySelectorAll('[data-detail-field]').forEach((field) => {
                payload[field.dataset.detailField] = field.type === 'number' ? Number(field.value) : field.value;
            });
            closeActiveDialog(payload);
        });

        window.addEventListener('keydown', onKeyDown, true);
        (els.app || document.body).appendChild(backdrop);
        setTimeout(() => form.querySelector('[data-detail-field]')?.focus(), 0);
    });
}

function renderNav() {
    els.nav.innerHTML = navItems.map(([view, label, iconName]) => `
        <button class="nav-button ${state.view === view ? 'active' : ''}" data-view="${view}" title="${escapeHtml(label)}">
            <span class="nav-icon">${icon(iconName)}</span>
            <span>${escapeHtml(label)}</span>
        </button>
    `).join('');
}

function applyBranding(config = {}) {
    const title = String(config.title || 'Admin Menu').trim() || 'Admin Menu';
    const logo = String(config.logo || '').trim();

    if (els.brandName) els.brandName.textContent = title.toUpperCase();
    document.title = title;

    if (!els.brandMark) return;

    const initial = title.charAt(0).toUpperCase() || 'A';
    if (els.brandMark.dataset.brand === `${title}|${logo}`) return;
    els.brandMark.dataset.brand = `${title}|${logo}`;
    els.brandMark.classList.remove('has-image');
    els.brandMark.textContent = initial;

    if (!logo) return;

    const img = new Image();
    img.draggable = false;
    img.alt = '';
    img.addEventListener('load', () => {
        els.brandMark.textContent = '';
        els.brandMark.classList.add('has-image');
        els.brandMark.appendChild(img);
    });
    img.src = logo;
}

function renderChrome() {
    const snapshot = state.snapshot || demoSnapshot();
    const server = snapshot.server || {};
    const self = snapshot.self || {};

    applyBranding(snapshot.config || {});

    els.playerCount.textContent = `${server.players || 0}/${server.maxPlayers || 0}`;
    els.uptime.textContent = server.uptime || '0h 0m';
    els.adminName.textContent = self.name || 'Admin';
    els.adminAvatar.textContent = initials(self.name);
    els.dutyToggle.setAttribute('aria-pressed', self.duty === true ? 'true' : 'false');
}

function renderSpectateOverlay() {
    if (!els.spectateOverlay) return;

    const mode = state.mode || {};
    const hasMode = state.spectate.active || mode.control || mode.noclip || mode.controlledBy;
    if (!hasMode) {
        els.spectateOverlay.hidden = true;
        els.spectateOverlay.innerHTML = '';
        return;
    }

    const targetId = state.spectate.target || mode.controlTarget;
    const player = playerById(targetId);
    const label = mode.noclip
        ? 'Noclip'
        : mode.controlledBy
            ? 'Admin Control'
            : state.spectate.name || player?.displayName || `Player #${targetId || '?'}`;
    const health = Math.max(0, Math.min(100, Number(player?.health ?? state.spectate.health ?? 0)));
    const armor = Math.max(0, Math.min(100, Number(player?.armor ?? state.spectate.armor ?? 0)));
    const bucket = player?.bucket ?? state.spectate.bucket ?? 0;
    const job = player?.job?.label || state.spectate.job || 'Unknown';
    const status = mode.noclip
        ? 'Noclip Active'
        : mode.control
            ? 'Remote Control'
            : mode.controlledBy
                ? 'Controlled'
                : 'Remote Feed';
    const meta = mode.noclip
        ? `${mode.godmode ? 'Godmode' : 'Vulnerable'} - ${mode.invisible ? 'Ghosted' : 'Visible'} - Speed ${mode.noclipSpeedValue || mode.noclipSpeed || 1}`
        : mode.controlledBy
            ? `Admin #${mode.controlledBy}`
            : `${job} - Bucket ${bucket}`;
    const keys = mode.noclip || mode.control
        ? [
            ['WASD', 'Move'],
            ['Shift', 'Fast'],
            ['Alt', 'Slow'],
            ['E / Q', 'Up / Down'],
            ...(mode.noclip ? [['Wheel', 'Speed']] : []),
            mode.control ? ['ESC', 'Stop control'] : ['Menu', 'Toggle off']
        ]
        : mode.controlledBy
            ? [['Wait', 'Staff control active']]
            : [['ESC', 'Stop spectate']];

    els.spectateOverlay.hidden = false;
    els.spectateOverlay.innerHTML = `
        <section class="spectate-card">
            <div class="spectate-status">
                <span></span>
                <strong>${escapeHtml(status)}</strong>
            </div>
            <div class="spectate-target">
                <b>${escapeHtml(label)}</b>
                <small>${targetId ? `#${escapeHtml(targetId)}` : ''}</small>
            </div>
            <div class="spectate-meta">
                <span>${escapeHtml(meta)}</span>
            </div>
            ${state.spectate.active || mode.control ? `<div class="spectate-bars">
                <label><span>Health</span><i>${health}</i></label>
                <div class="bar"><i style="--value:${health}%"></i></div>
                <label><span>Armor</span><i>${armor}</i></label>
                <div class="bar armor"><i style="--value:${armor}%"></i></div>
            </div>` : ''}
            <div class="spectate-key-grid">
                ${keys.map(([key, text]) => `<span><kbd>${escapeHtml(key)}</kbd><b>${escapeHtml(text)}</b></span>`).join('')}
            </div>
        </section>
    `;
}

function renderPlayerList() {
    const list = filteredPlayers();
    els.playerList.innerHTML = list.map((player) => `
        <button class="player-row ${player.id === state.selectedId ? 'active' : ''}" data-select="${player.id}">
            ${playerAvatar(player, 'rail-avatar')}
            <small>${player.id}</small>
            <strong>${escapeHtml(player.displayName || player.name)}</strong>
            ${staffTagMarkup(player, 'rail')}
            <span class="rail-badge" title="${player.duty ? 'On duty' : 'Online'}"></span>
        </button>
    `).join('') || '<div class="empty">No players</div>';
}

function render(options = {}) {
    if (!state.snapshot) state.snapshot = demoSnapshot();
    syncSelectedPlayer();
    closeSelectPicker();

    const preserveScroll = options.preserveScroll === true;
    const contentScroll = preserveScroll ? els.content.scrollTop : 0;
    const railScroll = preserveScroll ? els.playerList.scrollTop : 0;
    const nestedScroll = preserveScroll ? captureScrollPositions(els.content) : {};
    const active = preserveScroll ? document.activeElement : null;
    const activeField = active && els.content.contains(active) && active.id
        ? {
            id: active.id,
            value: 'value' in active ? active.value : null,
            selectionStart: typeof active.selectionStart === 'number' ? active.selectionStart : null,
            selectionEnd: typeof active.selectionEnd === 'number' ? active.selectionEnd : null
        }
        : null;

    renderNav();
    renderChrome();
    renderPlayerList();

    const views = {
        home: renderHome,
        players: renderPlayers,
        monitoring: renderMonitoring,
        moderation: renderModeration,
        chats: renderChats,
        items: renderItems,
        vehicles: renderVehicles,
        coords: renderCoords,
        console: renderConsole,
        events: renderEvents,
        staff: renderStaff,
        blips: renderBlips,
        settings: renderSettings
    };

    els.content.innerHTML = (views[state.view] || renderHome)();
    hydrateStaticIcons(els.content);
    updateRemoteFeedPolling();
    updateSnapshotPolling();

    if (preserveScroll) {
        requestAnimationFrame(() => {
            els.content.scrollTop = Math.min(contentScroll, Math.max(0, els.content.scrollHeight - els.content.clientHeight));
            els.playerList.scrollTop = Math.min(railScroll, Math.max(0, els.playerList.scrollHeight - els.playerList.clientHeight));
            els.content.querySelectorAll('[data-scroll-key]').forEach((element) => {
                const scrollTop = nestedScroll[element.dataset.scrollKey];
                if (scrollTop == null) return;

                element.scrollTop = Math.min(scrollTop, Math.max(0, element.scrollHeight - element.clientHeight));
            });

            if (activeField) {
                const restored = document.getElementById(activeField.id);
                if (restored && 'value' in restored) {
                    restored.value = activeField.value;
                    focusElement(restored);
                    if (activeField.selectionStart !== null && typeof restored.setSelectionRange === 'function') {
                        restored.setSelectionRange(activeField.selectionStart, activeField.selectionEnd);
                    }
                }
            }
        });
    }
}

function renderHome() {
    const server = state.snapshot.server || {};
    const player = selectedPlayer();
    const list = players();
    const outVehicles = ownedVehicles();
    const mapSrc = mapAssetCandidates()[0];
    const staffOnline = list.filter((item) => item.duty || item.staffTag || (Array.isArray(item.staffTags) && item.staffTags.length > 0));
    const warnings = list.reduce((total, item) => total + (Array.isArray(item.warnings) ? item.warnings.length : 0), 0);
    const serverTime = `${String(server.time?.hour ?? 12).padStart(2, '0')}:${String(server.time?.minute ?? 0).padStart(2, '0')}`;
    const recentLogs = (state.snapshot.actionLogs || []).slice(0, 6);
    const markers = `${ownedVehicleMapMarkers('dashboard-marker')}${playerMapMarkers('dashboard-marker')}`;
    const pop = player ? (() => {
        const pos = mapPopPosition(player.coords);
        if (!pos) return '';

        return `<div class="map-pop ${pos.below ? 'below' : ''}" style="${mapPopStyle(pos)}">
            <strong>${escapeHtml(player.displayName || player.name)}</strong>
            <span>#${player.id} x:${Number(player.coords?.x || 0).toFixed(1)}, y:${Number(player.coords?.y || 0).toFixed(1)}</span>
            <div class="mini-grid compact">
                <button class="primary-button" ${runAttributes('player.spectate')}>${icon('eye')}<span>View</span></button>
                <button class="soft-button" data-run="player.goto">${icon('send')}<span>Goto</span></button>
            </div>
        </div>`;
    })() : '';
    const selectedCoords = player?.coords
        ? `${Number(player.coords.x || 0).toFixed(2)}, ${Number(player.coords.y || 0).toFixed(2)}, ${Number(player.coords.z || 0).toFixed(2)}`
        : 'No coords';

    return `
        <div class="view-grid dashboard-grid">
            <section class="map-section dashboard-map-section">
                <div class="map-panel dashboard-map" data-map-viewport="dashboard">
                    <div class="map-layer" style="${blipMapLayerStyle()}">
                        <img class="map-image" src="${escapeHtml(mapSrc)}" data-map-index="0" alt="" draggable="false">
                        ${markers}
                        ${pop}
                    </div>
                    <div class="map-toolbar">
                        <button class="soft-button" data-view-jump="blips">${icon('eye')}<span>Tracker</span></button>
                        <button class="soft-button" ${runAttributes('player.revive')}>${icon('heart')}<span>Revive</span></button>
                        <button class="soft-button" data-view-jump="vehicles">${icon('car')}<span>Vehicles</span></button>
                    </div>
                    <div class="blip-map-controls" aria-label="Dashboard map controls">
                        <button class="icon-button" data-map-zoom="in" title="Zoom in">${icon('plus')}</button>
                        <button class="icon-button" data-map-zoom="out" title="Zoom out">${icon('minus')}</button>
                        <button class="icon-button" data-map-center-selected title="Center selected player">${icon('pin')}</button>
                        <button class="icon-button" data-map-zoom="reset" title="Reset map">${icon('refresh')}</button>
                    </div>
                    <div class="blip-legend dashboard-legend">
                        <span><i class="legend-dot"></i>Player</span>
                        <span><i class="legend-dot staff"></i>Staff</span>
                        <span><i class="legend-dot selected"></i>Selected</span>
                        <span><i class="legend-dot vehicle"></i>Owned Vehicle</span>
                    </div>
                </div>
                <div class="latest-strip dashboard-strip">
                    <h3>Latest Players</h3>
                    <div class="dashboard-latest-list">
                        ${list.slice(0, 8).map((item) => `<button class="latest-player ${item.id === state.selectedId ? 'active' : ''}" data-select="${item.id}" title="${escapeHtml(item.displayName || item.name)}">${playerAvatar(item, 'latest-avatar')}<span>${escapeHtml(item.displayName || item.name)}</span></button>`).join('') || '<div class="empty compact">No players online</div>'}
                    </div>
                </div>
            </section>
            <aside class="dashboard-side">
                <section class="form-panel dashboard-status-panel">
                    <header><h3>Server Snapshot</h3><button class="icon-button" data-run="duty.toggle" title="Toggle duty">${icon('shield')}</button></header>
                    <div class="dashboard-stat-grid">
                        <div class="dashboard-stat"><span>Players</span><strong>${list.length}</strong></div>
                        <div class="dashboard-stat"><span>Staff</span><strong>${staffOnline.length}</strong></div>
                        <div class="dashboard-stat"><span>Warnings</span><strong>${warnings}</strong></div>
                        <div class="dashboard-stat"><span>Out Vehicles</span><strong>${outVehicles.length}</strong></div>
                    </div>
                    <div class="dashboard-server-row">
                        <span>${icon('cloud')} ${escapeHtml(server.weather || 'CLEAR')} at ${escapeHtml(serverTime)}</span>
                        <button class="soft-button" data-view-jump="settings">${icon('clock')}<span>Settings</span></button>
                    </div>
                </section>
                <section class="form-panel dashboard-vehicles-panel">
                    <header><h3>Out Owned Vehicles</h3><span class="chip">${outVehicles.length}</span></header>
                    <div class="dashboard-vehicle-list">
                        ${outVehicles.slice(0, 6).map((vehicle) => `
                            <div class="dashboard-vehicle-row">
                                ${icon('car')}
                                <div>
                                    <strong>${escapeHtml(vehicle.plate || 'NO PLATE')}</strong>
                                    <span>${escapeHtml(vehicle.model || 'Vehicle')} - ${escapeHtml(vehicle.ownerName || vehicle.citizenid || 'Unknown Owner')}</span>
                                </div>
                                ${vehicle.stale ? '<small>Last</small>' : '<small>Live</small>'}
                            </div>
                        `).join('') || '<div class="empty compact">No out owned vehicles</div>'}
                    </div>
                </section>
                <section class="form-panel dashboard-selected-panel">
                    <header><h3>Selected Player</h3><span class="chip">ID ${player?.id ?? '-'}</span></header>
                    ${player ? `
                        <div class="dashboard-selected-card">
                            ${playerAvatar(player, 'large')}
                            <div>
                                <strong>${escapeHtml(player.displayName || player.name)}</strong>
                                <span>${escapeHtml(player.job?.label || 'No Job')} - ${escapeHtml(player.job?.gradeLabel || '0')}</span>
                                <code>${escapeHtml(selectedCoords)}</code>
                                <div class="chip-row">
                                    <span class="chip mint">${player.ping ?? 0}ms</span>
                                    <span class="chip amber">${Array.isArray(player.warnings) ? player.warnings.length : 0} Warnings</span>
                                    ${playerStaffTagsMarkup(player, 'dashboard')}
                                </div>
                            </div>
                        </div>
                        <div class="dashboard-action-grid">
                            <button class="soft-button" data-view-jump="players">${icon('user')}<span>Profile</span></button>
                            <button class="soft-button" ${runAttributes('player.spectate')}>${icon('eye')}<span>Spectate</span></button>
                            <button class="soft-button" data-run="player.bring">${icon('send')}<span>Bring</span></button>
                            <button class="soft-button" data-run="copy.coords">${icon('copy')}<span>Coords</span></button>
                            <button class="soft-button" data-run="player.message">${icon('send')}<span>Message</span></button>
                            <button class="soft-button" data-run="player.freeze">${icon('snow')}<span>Freeze</span></button>
                        </div>
                    ` : '<div class="empty compact">No player selected</div>'}
                </section>
                <section class="form-panel dashboard-activity-panel">
                    <header><h3>Recent Activity</h3><span class="chip">${recentLogs.length}</span></header>
                    <div class="log-list">
                        ${recentLogs.map((log) => `<div class="log-row dashboard-log"><strong>${escapeHtml(log.action)}</strong><span>${escapeHtml(log.actor)} -> ${escapeHtml(log.target)} ${escapeHtml(log.detail || '')}</span><small>${escapeHtml(formatTime(log.time))}</small></div>`).join('') || '<div class="empty compact">No recent activity</div>'}
                    </div>
                </section>
            </aside>
        </div>
    `;
}

function playerIdentifierText(player = selectedPlayer()) {
    if (!player) return '';

    const lines = [
        ['Server ID', player.id],
        ['Name', player.name],
        ['Character', player.displayName],
        ['Citizen ID', player.citizenid],
        ['License', player.license],
        ['Discord', player.discord],
        ['Steam', player.steam],
        ['FiveM', player.fivem]
    ];

    return lines
        .filter(([, value]) => value != null && String(value) !== '')
        .map(([label, value]) => `${label}: ${value}`)
        .join('\n');
}

function nearbyPlayersForSelected(limit = 8) {
    return players()
        .map((player) => ({ ...player, _distance: playerDistanceFromSelected(player) }))
        .filter((player) => Number.isFinite(player._distance))
        .sort((a, b) => a._distance - b._distance)
        .slice(0, limit);
}

function statCard(title, subtitle, label, value, actionName, iconName) {
    const actionAttr = actionName.startsWith('view:')
        ? `data-view-jump="${actionName.replace('view:', '')}"`
        : `data-run="${actionName}"`;

    return `
        <div class="stat-card">
            <header>
                <div>
                    <h3>${escapeHtml(title)}</h3>
                    <p>${escapeHtml(subtitle)}</p>
                </div>
                ${icon(iconName)}
            </header>
            <div class="value-line">
                <div>
                    <p>${escapeHtml(label)}</p>
                    <strong class="accent">${escapeHtml(value)}</strong>
                </div>
                <button class="primary-button" ${actionAttr}>Update</button>
            </div>
        </div>
    `;
}

function renderPlayers() {
    const player = selectedPlayer();
    if (!player) return '<div class="empty">No player selected</div>';

    const warnings = player.warnings || [];
    const notes = player.notes || [];
    const staffActions = playerActionHistory(player);
    const nearby = nearbyPlayersForSelected();
    const vehicle = player.vehicle || {};
    const gymStats = playerGymStats(player);
    return `
        <div class="player-view">
            <section class="player-hero">
                ${playerAvatar(player, 'large')}
                <div>
                    <h2>${escapeHtml(player.displayName || player.name)}</h2>
                    <div class="chip-row">
                        <span class="chip">Server ID: ${player.id}</span>
                        <span class="chip">Bucket: ${player.bucket ?? 0}</span>
                        <span class="chip mint">Ping: ${player.ping ?? 0}ms</span>
                        <span class="chip amber">${warnings.length} Warnings</span>
                        ${playerStaffTagsMarkup(player, 'hero')}
                        ${player.metadata?.isdead ? '<span class="chip red">Down</span>' : ''}
                    </div>
                    <div class="chip-row" style="margin-top:8px">
                        <span class="chip">${escapeHtml(player.job?.label || 'No Job')} - ${escapeHtml(player.job?.gradeLabel || '0')}</span>
                        <span class="chip">${escapeHtml(player.gang?.label || 'No Gang')}</span>
                    </div>
                    <div class="identifier-grid">
                        <code>${escapeHtml(player.license || 'license:unknown')}</code>
                        <code>${escapeHtml(player.discord || 'discord:unknown')}</code>
                        <code>${escapeHtml(player.citizenid || 'citizen:unknown')}</code>
                    </div>
                    <div class="meter-grid">
                        ${meter('Health', player.health ?? 0)}
                        ${meter('Armor', player.armor ?? 0)}
                        ${meter('Hunger', player.metadata?.hunger ?? 0)}
                        ${meter('Thirst', player.metadata?.thirst ?? 0)}
                    </div>
                </div>
            </section>

            <section class="info-grid">
                <div class="info-card">
                    <header><h3>Character Information</h3>${icon('user')}</header>
                    <div class="kv">
                        <span>Name</span><span>${escapeHtml(player.displayName)}</span>
                        <span>Character ID</span><span>${escapeHtml(player.citizenid || '-')}</span>
                        <span>Birthday</span><span>${escapeHtml(player.charinfo?.birthdate || '-')}</span>
                        <span>Phone Number</span><span>${escapeHtml(player.charinfo?.phone || '-')}</span>
                    </div>
                </div>
                <div class="info-card">
                    <header><h3>Accounts</h3>${icon('dollar')}</header>
                    <div class="kv">
                        <span>bank</span><span>${formatMoney(player.money?.bank)}</span>
                        <span>cash</span><span>${formatMoney(player.money?.cash)}</span>
                        <span>blackMoney</span><span>${formatMoney(player.money?.black_money)}</span>
                        <span>cryptoExchange</span><span>${formatMoney(player.money?.crypto)}</span>
                    </div>
                </div>
                <div class="info-card">
                    <header><h3>Snapshot</h3>${icon('monitor')}</header>
                    <div class="kv">
                        <span>Health</span><span>${escapeHtml(player.health ?? 0)}</span>
                        <span>Armor</span><span>${escapeHtml(player.armor ?? 0)}</span>
                        <span>Stress</span><span>${escapeHtml(player.metadata?.stress ?? 0)}</span>
                        <span>Jail Time</span><span>${escapeHtml(player.metadata?.jail ?? 0)}</span>
                        ${gymStats.map((stat) => `<span>${escapeHtml(stat.label)}</span><span>${escapeHtml(stat.value)}</span>`).join('')}
                        <span>Vehicle</span><span>${vehicle.plate ? escapeHtml(vehicle.plate) : 'None'}</span>
                        <span>Coords</span><span>${escapeHtml(coordsString(player.coords))}</span>
                    </div>
                </div>
                <div class="info-card">
                    <header><h3>Identifiers</h3><button class="icon-button" data-run="copy.identifiers" title="Copy identifiers">${icon('copy')}</button></header>
                    <div class="kv">
                        <span>Server ID</span><span>${escapeHtml(player.id)}</span>
                        <span>License</span><span>${escapeHtml(player.license || '-')}</span>
                        <span>Discord</span><span>${escapeHtml(player.discord || '-')}</span>
                        <span>Steam</span><span>${escapeHtml(player.steam || '-')}</span>
                        <span>FiveM</span><span>${escapeHtml(player.fivem || '-')}</span>
                    </div>
                </div>
                <div class="info-card">
                    <header><h3>Nearby Players</h3><span class="chip">${nearby.length}</span></header>
                    <div class="staff-action-list">
                        ${nearby.map((item) => `
                            <button class="staff-action-row" data-select="${item.id}">
                                <strong>${escapeHtml(item.displayName || item.name)}</strong>
                                <span>#${item.id} - ${escapeHtml(item.job?.label || 'No Job')}</span>
                                <time>${escapeHtml(formatDistance(item._distance))}</time>
                            </button>
                        `).join('') || '<div class="empty compact">No nearby players</div>'}
                    </div>
                </div>
                <div class="info-card">
                    <header><h3>Staff Notes</h3><span class="chip">${notes.length}</span></header>
                    <div class="note-composer">
                        <textarea id="noteInput" rows="3" placeholder="Leave a staff note"></textarea>
                        <button class="primary-button" data-run="player.noteAdd">${icon('send')}<span>Add Note</span></button>
                    </div>
                    <div class="note-list">
                        ${notes.map(playerNoteRow).join('') || '<div class="empty compact">No staff notes</div>'}
                    </div>
                </div>
                <div class="info-card staff-actions-card">
                    <header><h3>Staff Actions</h3><span class="chip amber">${warnings.length} Warnings</span></header>
                    <div class="staff-action-list">
                        ${warnings.slice(0, 4).map((warning, index) => `
                            <article class="staff-action-row warning">
                                <strong>Warning</strong>
                                <span>${escapeHtml(warning.reason || '')}</span>
                                <time>${escapeHtml(formatTime(warning.time))}</time>
                                <footer>
                                    <button class="soft-button" data-warning-edit="${escapeHtml(warningId(warning, index))}">${icon('chat')}<span>Edit</span></button>
                                    <button class="danger-button" data-warning-delete="${escapeHtml(warningId(warning, index))}">${icon('trash')}<span>Delete</span></button>
                                </footer>
                            </article>
                        `).join('')}
                        ${staffActions.map((log) => `
                            <article class="staff-action-row">
                                <strong>${escapeHtml(log.action)}</strong>
                                <span>${escapeHtml(log.actor)} -> ${escapeHtml(log.target)} ${escapeHtml(log.detail || '')}</span>
                                <time>${escapeHtml(formatTime(log.time))}</time>
                            </article>
                        `).join('')}
                        ${warnings.length === 0 && staffActions.length === 0 ? '<div class="empty compact">No staff actions</div>' : ''}
                    </div>
                </div>
            </section>

            ${renderPlayerActionGroups()}
        </div>
    `;
}

function meter(label, value) {
    const amount = Math.max(0, Math.min(100, Number(value) || 0));
    return `
        <div class="meter">
            <label><span>${escapeHtml(label)}</span><span>${amount}</span></label>
            <div class="bar"><i style="--value:${amount}%"></i></div>
        </div>
    `;
}

function playerNoteRow(note = {}) {
    const editable = canManagePlayerNote(note);
    return `
        <article class="player-note">
            <div>
                <strong>${escapeHtml(note.actor || 'Staff')}</strong>
                <time>${escapeHtml(formatTime(note.updated || note.time))}${note.updated ? ' edited' : ''}</time>
            </div>
            <p>${escapeHtml(note.note || '')}</p>
            ${editable ? `
                <footer>
                    <button class="soft-button" data-note-edit="${escapeHtml(note.id)}">${icon('chat')}<span>Edit</span></button>
                    <button class="danger-button" data-note-delete="${escapeHtml(note.id)}">${icon('trash')}<span>Delete</span></button>
                </footer>
            ` : ''}
        </article>
    `;
}

function actionGroup(title, actions) {
    return `
        <section class="player-action-group">
            <header><h3>${escapeHtml(title)}</h3></header>
            <div class="action-grid">
                ${actions.map(([label, iconName, actionName, tone]) => actionButton(label, iconName, actionName, tone)).join('')}
            </div>
        </section>
    `;
}

function renderPlayerActionGroups() {
    return `
        <div class="player-action-groups">
            ${actionGroup('Monitoring', [
                ['Spectate', 'eye', 'player.spectate', 'green'],
                ['Screenshot', 'camera', 'player.screenshot', 'green'],
                ['Control', 'camera', 'player.control', 'blue'],
                ['Stop Control', 'exit', 'player.controlStop'],
                ['Stop Spectate', 'eye', 'player.spectateStop']
            ])}
            ${actionGroup('Moderation', [
                ['Warn', 'gavel', 'player.warn', 'amber'],
                ['Jail', 'shield', 'player.jail', 'blue'],
                ['Unjail', 'shield', 'player.unjail'],
                ['Kick', 'exit', 'player.kick', 'orange'],
                ['Ban', 'ban', 'player.ban', 'red'],
                ['Send Message', 'send', 'player.message'],
                ['Voice Mute', 'ban', 'player.voiceMute', 'orange'],
                ['Voice Unmute', 'eye', 'player.voiceUnmute'],
                ['Chat Mute', 'chat', 'player.chatMute', 'orange'],
                ['Chat Unmute', 'chat', 'player.chatUnmute']
            ])}
            ${actionGroup('Health and Control', [
                ['Revive', 'heart', 'player.revive'],
                ['Heal', 'heart', 'player.heal'],
                ['Food Water', 'food', 'player.feed'],
                ['Reset Status', 'refresh', 'player.resetStatus'],
                ['Set Armor', 'shield', 'player.setArmor'],
                ['Kill', 'skull', 'player.kill'],
                ['Freeze', 'snow', 'player.freeze'],
                ['Unfreeze', 'snow', 'player.unfreeze'],
                ['Cuff', 'shield', 'player.cuff'],
                ['Uncuff', 'shield', 'player.uncuff'],
                ['Hands Up', 'user', 'player.handsUp'],
                ['Escort', 'users', 'player.escort'],
                ['Seat Vehicle', 'car', 'player.seatVehicle'],
                ['Slap', 'zap', 'player.slap'],
                ['Explode', 'zap', 'player.explode'],
                ['Burn', 'flame', 'player.burn'],
                ['Ragdoll', 'user', 'player.ragdoll']
            ])}
            ${actionGroup('Teleport', [
                ['Teleport', 'pin', 'player.goto'],
                ['Bring', 'pin', 'player.bring'],
                ['Return Player', 'refresh', 'player.return'],
                ['Teleport Preset', 'pin', 'player.teleportPreset'],
                ['Teleport Coords', 'pin', 'player.teleportCoords'],
                ['Copy Coords', 'copy', 'copy.coords'],
                ['Save Location', 'plus', 'player.saveLocation']
            ])}
            ${actionGroup('Inventory and Identity', [
                ['Inventory', 'box', 'player.openInventory'],
                ['Clear Inventory', 'trash', 'player.clearInventory'],
                ['Clear Vehicle Keys', 'key', 'player.clearVehicleKeys', 'red'],
                ['Clothing Menu', 'shirt', 'player.clothing'],
                ['Barber Menu', 'user', 'player.barber'],
                ['Tattoo Menu', 'shirt', 'player.tattoo'],
                ['Reset Appearance', 'refresh', 'player.resetAppearance'],
                ['Change Ped', 'user', 'player.setPed'],
                ['Update Job', 'briefcase', 'player.setJob'],
                ['Update Gang', 'users', 'player.setGang'],
                ['Set Duty', 'shield', 'player.setDuty'],
                ['License', 'key', 'player.setLicense'],
                ['Gym Stats', 'zap', 'player.setGymStats'],
                ['Copy IDs', 'copy', 'copy.identifiers'],
                ['Routing Bucket', 'bucket', 'player.setBucket'],
                ['Give Item', 'plus', 'item.give'],
                ['Remove Item', 'trash', 'item.remove'],
                ['Give Weapon', 'plus', 'player.giveWeapon'],
                ['Clear Weapons', 'trash', 'player.clearWeapons'],
                ['Delete Character', 'trash', 'player.deleteCharacter', 'red']
            ])}
            ${can('manageAdmins') ? actionGroup('Staff Tags', [
                ['Set Staff Tag', 'shield', 'staff.tagSet', 'amber'],
                ['Clear Staff Tag', 'trash', 'staff.tagClear', 'red']
            ]) : ''}
            ${actionGroup('Vehicles and Money', [
                ['Transactions', 'dollar', 'transactions'],
                ['Add Money', 'dollar', 'money.add'],
                ['Remove Money', 'dollar', 'money.remove'],
                ['Set Money', 'dollar', 'money.set'],
                ['Customize', 'settings', 'vehicle.customize', 'amber'],
                ['Repair Vehicle', 'wrench', 'vehicle.repair'],
                ['Vehicle Keys', 'key', 'vehicle.keys'],
                ['Vehicle Spawner', 'plus', 'vehicle.spawn'],
                ['Spawn For Player', 'car', 'vehicle.spawnForPlayer'],
                ['Give Owned Vehicle', 'shield', 'vehicle.giveOwned'],
                ['Flip Vehicle', 'wrench', 'vehicle.flip'],
                ['Refuel Vehicle', 'food', 'vehicle.refuel'],
                ['Clean Vehicle', 'wrench', 'vehicle.clean'],
                ['Impound Vehicle', 'trash', 'vehicle.impound', 'red'],
                ['Max Mods', 'wrench', 'vehicle.maxMods'],
                ['Delete Vehicle', 'trash', 'vehicle.delete']
            ])}
        </div>
    `;
}

function actionButton(label, iconName, actionName, tone = '') {
    const payload = actionName === 'player.freeze'
        ? { state: true }
        : actionName === 'player.voiceMute' || actionName === 'player.chatMute'
            ? { state: true }
            : {};
    if (!tone && actionConfirmations[actionName]?.danger) tone = 'red';
    return `<button class="action-button ${tone}" ${runAttributes(actionName, payload)}>${icon(iconName)}<span>${escapeHtml(label)}</span></button>`;
}

function renderPlayerForms(player) {
    const config = state.snapshot.config || {};
    return `
        <section class="form-panel">
            <header><h3>Action Details</h3><span class="muted">ID ${player.id}</span></header>
            <div class="form-grid">
                <div class="form-row wide"><label>Reason</label><input id="reasonInput" value="Admin action"></div>
                <div class="form-row"><label>Duration</label><select id="durationInput">
                    <option value="0">Permanent</option>
                    <option value="30">30 minutes</option>
                    <option value="120">2 hours</option>
                    <option value="1440">1 day</option>
                    <option value="10080">7 days</option>
                </select></div>
                <div class="form-row"><label>Jail</label><input id="jailMinutes" type="number" value="15" min="1"></div>
                <div class="form-row wide"><label>Message</label><input id="messageInput" value="Please contact staff."></div>
                <div class="form-row"><label>Item</label><select id="itemInput">${(config.items || []).map((item) => `<option value="${escapeHtml(item.name)}">${escapeHtml(item.label)}</option>`).join('')}</select></div>
                <div class="form-row"><label>Amount</label><input id="amountInput" type="number" value="1" min="1"></div>
                <div class="form-row"><label>Radius</label><input id="radiusInput" type="number" value="20" min="1" max="100"></div>
                <div class="form-row"><label>Account</label><select id="accountInput"><option>cash</option><option>bank</option><option>crypto</option><option>black_money</option></select></div>
                <div class="form-row"><label>Money</label><input id="moneyInput" type="number" value="1000" min="0"></div>
                <div class="form-row"><label>Vehicle</label><select id="vehicleInput">${(config.vehicles || []).map((item) => `<option value="${escapeHtml(item.model)}">${escapeHtml(item.label)}</option>`).join('')}</select></div>
                <div class="form-row"><label>Plate</label><input id="plateInput" maxlength="8" value="ADMIN"></div>
                <div class="form-row"><label>Stash</label><input id="stashInput" value="policestash"></div>
                <div class="form-row"><label>Trunk Plate</label><input id="trunkPlateInput" maxlength="12" value="ADMIN"></div>
                <div class="form-row"><label>Ped</label><select id="pedInput">${(config.peds || []).map((item) => `<option value="${escapeHtml(item.model)}">${escapeHtml(item.label)}</option>`).join('')}</select></div>
                <div class="form-row"><label>Weapon</label><select id="weaponInput">${(config.weapons || []).map((item) => `<option value="${escapeHtml(item.name)}">${escapeHtml(item.label)}</option>`).join('')}</select></div>
                <div class="form-row"><label>Job</label><select id="jobInput">${(config.jobs || []).map((item) => `<option value="${escapeHtml(item.name)}">${escapeHtml(item.label)}</option>`).join('')}</select></div>
                <div class="form-row"><label>Grade</label><input id="gradeInput" type="number" value="0" min="0"></div>
                <div class="form-row"><label>Bucket</label><input id="bucketInput" type="number" value="${Number(player.bucket) || 0}" min="0"></div>
                <div class="form-row wide"><label>Coords</label><input id="coordsInput" value="${Number(player.coords?.x || 0).toFixed(2)}, ${Number(player.coords?.y || 0).toFixed(2)}, ${Number(player.coords?.z || 0).toFixed(2)}"></div>
            </div>
            <div class="mini-grid" style="margin-top:12px">
                <button class="soft-button" data-run="item.give">${icon('plus')}<span>Give Item</span></button>
                <button class="soft-button" data-run="item.remove">${icon('trash')}<span>Remove Item</span></button>
                <button class="soft-button" data-run="player.reviveRadius">${icon('heart')}<span>Revive Radius</span></button>
                <button class="soft-button" data-run="money.add">${icon('dollar')}<span>Add Money</span></button>
                <button class="soft-button" data-run="money.remove">${icon('dollar')}<span>Remove Money</span></button>
                <button class="soft-button" data-run="money.set">${icon('dollar')}<span>Set Money</span></button>
                <button class="soft-button" data-run="player.giveWeapon">${icon('plus')}<span>Give Weapon</span></button>
                <button class="soft-button" data-run="player.clearWeapons">${icon('trash')}<span>Clear Weapons</span></button>
                <button class="soft-button" data-run="player.setPed">${icon('user')}<span>Change Ped</span></button>
                <button class="soft-button" data-run="inventory.openStash">${icon('box')}<span>Open Stash</span></button>
                <button class="soft-button" data-run="inventory.openTrunk">${icon('car')}<span>Open Trunk</span></button>
                <button class="danger-button" ${runAttributes('player.deleteCharacter')}>${icon('trash')}<span>Delete Character</span></button>
            </div>
        </section>
    `;
}

function renderMonitoring() {
    const player = selectedPlayer();
    const tabs = [
        ['quick', 'Quick Actions'],
        ['teleport', 'Teleport Options'],
        ['admin', 'Admin Actions']
    ];
    const actionsByTab = {
        quick: [
            ['Kill', 'skull', 'player.kill'],
            ['Revive', 'heart', 'player.revive'],
            ['Heal', 'heart', 'player.heal'],
            ['Freeze', 'snow', 'player.freeze'],
            ['Unfreeze', 'snow', 'player.unfreeze'],
            ['Cuff', 'shield', 'player.cuff'],
            ['Uncuff', 'shield', 'player.uncuff'],
            ['Slap', 'zap', 'player.slap'],
            ['Send Message', 'send', 'player.message']
        ],
        teleport: [
            ['Spectate', 'eye', 'player.spectate'],
            ['Control', 'camera', 'player.control'],
            ['Stop Control', 'exit', 'player.controlStop'],
            ['Stop Spectate', 'exit', 'player.spectateStop'],
            ['Bring', 'pin', 'player.bring'],
            ['Goto', 'pin', 'player.goto'],
            ['Teleport Coords', 'pin', 'player.teleportCoords'],
            ['Copy Coords', 'copy', 'copy.coords']
        ],
        admin: [
            ['Warn', 'gavel', 'player.warn', 'amber'],
            ['Jail', 'shield', 'player.jail', 'blue'],
            ['Kick', 'exit', 'player.kick', 'orange'],
            ['Ban', 'ban', 'player.ban', 'red'],
            ['Food Water', 'food', 'player.feed'],
            ['Revive Radius', 'heart', 'player.reviveRadius'],
            ['Revive All', 'heart', 'server.reviveAll'],
            ['Clear Inventory', 'trash', 'player.clearInventory'],
            ['Delete Character', 'trash', 'player.deleteCharacter', 'red']
        ]
    };
    const activeTab = actionsByTab[state.tab] ? state.tab : 'quick';
    const remoteFeedAvailable = remoteFeedEnabled();
    const feedPlayerIds = remoteFeedPlayerIds();
    const feedPlayers = feedPlayerIds.map(playerById).filter(Boolean);

    return `
        <div class="view-grid monitoring-page">
            <section class="feed-panel monitoring-feed-panel">
                <header>
                    <div>
                        <h3>Remote Feed</h3>
                        <p class="muted">${remoteFeedAvailable ? 'Live player thumbnails with quick watch controls' : 'Remote thumbnails require spectate access'}</p>
                    </div>
                    <span class="chip">${feedPlayers.length}</span>
                </header>
                <div class="monitor-feed-grid">
                    ${feedPlayers.map((item) => {
                        const health = Math.max(0, Math.min(100, Number(item.health || 0)));
                        const armor = Math.max(0, Math.min(100, Number(item.armor || 0)));
                        return `
                            <article class="monitor-feed-card ${item.id === state.selectedId ? 'active' : ''}">
                                <div class="monitor-feed-head">
                                    ${playerAvatar(item, 'mini')}
                                    <div>
                                        <strong>${escapeHtml(item.displayName || item.name)}</strong>
                                     <span>#${item.id} - ${escapeHtml(item.job?.label || 'No Job')} - ${escapeHtml(item.gang?.label || 'No Gang')}</span>
                                 </div>
                                 <button class="icon-button" data-monitor-select="${item.id}" title="Select player">${icon('pin')}</button>
                             </div>
                                ${remoteFeedPreviewHtml(item)}
                                 <div class="monitor-feed-bars">
                                     <span><b>Health</b><i>${health}</i></span>
                                     <div class="bar"><i style="--value:${health}%"></i></div>
                                    <span><b>Armor</b><i>${armor}</i></span>
                                    <div class="bar armor"><i style="--value:${armor}%"></i></div>
                                </div>
                                <div class="monitor-feed-meta">
                                    <code>x:${Number(item.coords?.x || 0).toFixed(1)} y:${Number(item.coords?.y || 0).toFixed(1)}</code>
                                    <span>Bucket ${escapeHtml(item.bucket ?? 0)}</span>
                                </div>
                                <div class="monitor-feed-actions">
                                    <button class="primary-button" data-run="player.spectate" data-target="${item.id}">${icon('eye')}<span>Watch</span></button>
                                    <button class="soft-button" data-run="player.goto" data-target="${item.id}">${icon('send')}<span>Goto</span></button>
                                </div>
                            </article>
                        `;
                    }).join('') || '<div class="empty compact">No players online</div>'}
                </div>
            </section>
            <section class="form-panel">
                <header><h3>Actions</h3><span class="chip">${player ? `1 Selected Player` : '0 Selected Players'}</span></header>
                <div class="tabs">
                    ${tabs.map(([id, label]) => `<button class="${activeTab === id ? 'active' : ''}" data-action-tab="${id}">${escapeHtml(label)}</button>`).join('')}
                </div>
                <div class="mini-grid" style="margin-top:12px">
                    ${actionsByTab[activeTab].map(([label, iconName, actionName, tone]) => actionButton(label, iconName, actionName, tone)).join('')}
                </div>
            </section>
        </div>
    `;
}

function renderModeration() {
    const bans = state.snapshot.bans || [];
    return `
        <div class="view-grid">
            <section class="form-panel">
                <header><h3>Moderation</h3>${icon('gavel')}</header>
                <div class="form-grid">
                    <div class="form-row wide"><label>Reason</label><input id="reasonInput" value="Rule violation"></div>
                    <div class="form-row"><label>Duration</label><select id="durationInput"><option value="0">Permanent</option><option value="60">1 hour</option><option value="1440">1 day</option><option value="10080">7 days</option></select></div>
                    <div class="form-row"><label>Jail</label><input id="jailMinutes" type="number" value="15"></div>
                </div>
                <div class="mini-grid" style="margin-top:12px">
                    <button class="soft-button" data-run="player.warn">${icon('gavel')}<span>Warn</span></button>
                    <button class="soft-button" ${runAttributes('player.jail')}>${icon('shield')}<span>Jail</span></button>
                    <button class="soft-button" data-run="player.unjail">${icon('shield')}<span>Unjail</span></button>
                    <button class="soft-button" ${runAttributes('player.kick')}>${icon('exit')}<span>Kick</span></button>
                    <button class="danger-button" ${runAttributes('player.ban')}>${icon('ban')}<span>Ban</span></button>
                </div>
            </section>
            <section class="form-panel">
                <header><h3>Ban List</h3><span class="chip">${bans.length}</span></header>
                <div class="log-list">
                    ${bans.map((ban) => `<div class="log-row">
                        <strong>${escapeHtml(ban.name || ban.id)}</strong>
                        <span>${escapeHtml(ban.reason || '')}</span>
                        <button class="soft-button" data-unban="${escapeHtml(ban.id)}">Unban</button>
                    </div>`).join('') || '<div class="empty">No active bans</div>'}
                </div>
            </section>
        </div>
    `;
}

function renderChats() {
    const logs = state.snapshot.chatLogs || [];
    const adminLogs = state.snapshot.adminChatLogs || [];
    const player = selectedPlayer();
    const adminQuery = state.adminChatSearch.trim().toLowerCase();
    const serverQuery = state.serverChatSearch.trim().toLowerCase();
    const filteredAdminLogs = adminLogs.filter((log) => !adminQuery || [
        log.actor,
        log.message,
        formatTime(log.time)
    ].join(' ').toLowerCase().includes(adminQuery));
    const filteredLogs = logs.filter((log) => !serverQuery || [
        log.name,
        log.message,
        log.source,
        formatTime(log.time)
    ].join(' ').toLowerCase().includes(serverQuery));
    const templates = adminChatTemplates();

    return `
        <div class="view-grid chats-page">
            <section class="form-panel admin-chat-feed-panel">
                <header>
                    <div>
                        <h3>Admin Chat</h3>
                        <p class="muted">Discord webhook staff feed</p>
                    </div>
                    <span class="chip">${filteredAdminLogs.length}/${adminLogs.length}</span>
                </header>
                <div class="admin-chat-panel">
                    <div class="admin-chat-toolbar">
                        <div class="search-shell compact">
                            ${icon('search')}
                            <input id="adminChatSearch" value="${escapeHtml(state.adminChatSearch)}" placeholder="Search admin chat" autocomplete="off">
                        </div>
                        <span class="chip mint">Discord</span>
                    </div>
                    <div class="admin-chat-log">
                        ${filteredAdminLogs.map((log) => `
                            <article class="admin-chat-row">
                                <span class="avatar mini">${escapeHtml(initials(log.actor || 'Staff'))}</span>
                                <div>
                                    <div>
                                        <strong>${escapeHtml(log.actor || 'Staff')}</strong>
                                        <time>${escapeHtml(formatTime(log.time))}</time>
                                    </div>
                                    <p>${escapeHtml(log.message)}</p>
                                </div>
                            </article>
                        `).join('') || '<div class="empty compact">No admin chat messages</div>'}
                    </div>
                    <div class="admin-chat-compose">
                        <input class="console-input" id="adminChatInput" placeholder="Type a staff message" autocomplete="off" spellcheck="false">
                        <button class="primary-button" data-run="admin.chat">${icon('send')}<span>Send to Discord</span></button>
                    </div>
                    <div class="chat-chip-grid">
                        ${templates.map((template) => `<button data-chat-template="${escapeHtml(template)}">${escapeHtml(template)}</button>`).join('')}
                    </div>
                </div>
            </section>
            <section class="form-panel chat-tools-panel">
                <header><h3>Player Message</h3><span class="chip">${player ? `#${player.id}` : 'No Player'}</span></header>
                <div class="form-grid">
                    <div class="form-row wide"><label>Selected Player</label><input value="${player ? escapeHtml(player.displayName) : 'No player selected'}" disabled></div>
                    <div class="form-row wide"><label>Message</label><input id="playerMessageInput" value="Please contact staff."></div>
                    <button class="primary-button" data-run="player.message">${icon('send')}<span>Send Message</span></button>
                </div>
            </section>
            <section class="form-panel server-chat-panel">
                <header>
                    <h3>Server Chat Logs</h3>
                    <span class="chip">${filteredLogs.length}/${logs.length}</span>
                </header>
                <div class="search-shell compact">
                    ${icon('search')}
                    <input id="serverChatSearch" value="${escapeHtml(state.serverChatSearch)}" placeholder="Search server chat" autocomplete="off">
                </div>
                <div class="log-list">
                    ${filteredLogs.map((log) => `<div class="log-row"><strong>${escapeHtml(formatTime(log.time))}</strong><span>${escapeHtml(log.name)}: ${escapeHtml(log.message)}</span><small>#${log.source}</small></div>`).join('') || '<div class="empty compact">No chat logs</div>'}
                </div>
            </section>
        </div>
    `;
}

function renderItems() {
    const config = state.snapshot.config || {};
    const itemQuery = state.itemSearch.trim().toLowerCase();
    const weaponQuery = state.weaponSearch.trim().toLowerCase();
    const itemList = config.items || [];
    const weaponList = config.weapons || [];
    const filteredItems = itemList.filter((item) => !itemQuery || [
        item.name,
        item.label
    ].join(' ').toLowerCase().includes(itemQuery)).slice(0, 80);
    const filteredWeapons = weaponList.filter((item) => !weaponQuery || [
        item.name,
        item.label
    ].join(' ').toLowerCase().includes(weaponQuery)).slice(0, 60);

    return `
        <div class="view-grid items-page">
            <section class="form-panel item-action-panel">
                <header>
                    <div>
                        <h3>Inventory Tools</h3>
                        <p class="muted">Items are loaded from ox_inventory when available</p>
                    </div>
                    ${icon('box')}
                </header>
                <div class="form-grid">
                    <div class="form-row"><label>Item</label><input id="itemInput" value="${escapeHtml(state.itemName || itemList[0]?.name || 'water')}" placeholder="water, bandage, radio"></div>
                    <div class="form-row"><label>Amount</label><input id="amountInput" type="number" min="1" value="1"></div>
                    <div class="form-row"><label>Weapon</label><input id="weaponInput" value="${escapeHtml(state.weaponName || weaponList[0]?.name || 'WEAPON_PISTOL')}" placeholder="WEAPON_PISTOL"></div>
                    <div class="form-row"><label>Ammo</label><input id="ammoInput" type="number" min="1" value="120"></div>
                    <div class="form-row"><label>Stash</label><input id="stashInput" value="policestash"></div>
                    <div class="form-row"><label>Trunk Plate</label><input id="trunkPlateInput" maxlength="12" value="ADMIN"></div>
                </div>
                <div class="mini-grid" style="margin-top:12px">
                    <button class="primary-button" data-run="item.give">${icon('plus')}<span>Give Item</span></button>
                    <button class="soft-button" data-run="item.remove">${icon('trash')}<span>Remove Item</span></button>
                    <button class="soft-button" data-run="player.openInventory">${icon('box')}<span>Open Player</span></button>
                    <button class="danger-button" data-run="player.clearInventory">${icon('trash')}<span>Clear Player</span></button>
                    <button class="danger-button" data-run="player.clearVehicleKeys">${icon('key')}<span>Clear Vehicle Keys</span></button>
                    <button class="soft-button" data-run="inventory.openStash">${icon('box')}<span>Open Stash</span></button>
                    <button class="soft-button" data-run="inventory.openTrunk">${icon('car')}<span>Open Trunk</span></button>
                    <button class="soft-button" data-run="player.giveWeapon">${icon('plus')}<span>Give Weapon</span></button>
                    <button class="danger-button" data-run="player.clearWeapons">${icon('trash')}<span>Clear Weapons</span></button>
                </div>
            </section>
            <section class="form-panel item-browser-panel">
                <header><h3>Item Browser</h3><span class="chip">${filteredItems.length}/${itemList.length}</span></header>
                <div class="search-shell compact">
                    ${icon('search')}
                    <input id="itemSearch" value="${escapeHtml(state.itemSearch)}" placeholder="Search items" autocomplete="off">
                </div>
                <div class="inventory-browser-list" data-scroll-key="item-browser">
                    ${filteredItems.map((item) => `
                        <button data-preset-item="${escapeHtml(item.name)}">
                            ${icon('box')}
                            <span>
                                <strong>${escapeHtml(item.label || item.name)}</strong>
                                <code>${escapeHtml(item.name)}</code>
                            </span>
                        </button>
                    `).join('') || '<div class="empty compact">No matching items</div>'}
                </div>
            </section>
            <section class="form-panel weapon-browser-panel">
                <header><h3>Weapon Browser</h3><span class="chip">${filteredWeapons.length}/${weaponList.length}</span></header>
                <div class="search-shell compact">
                    ${icon('search')}
                    <input id="weaponSearch" value="${escapeHtml(state.weaponSearch)}" placeholder="Search weapons" autocomplete="off">
                </div>
                <div class="inventory-browser-list" data-scroll-key="weapon-browser">
                    ${filteredWeapons.map((item) => `
                        <button data-preset-weapon="${escapeHtml(item.name)}">
                            ${icon('zap')}
                            <span>
                                <strong>${escapeHtml(item.label || item.name)}</strong>
                                <code>${escapeHtml(item.name)}</code>
                            </span>
                        </button>
                    `).join('') || '<div class="empty compact">No matching weapons</div>'}
                </div>
            </section>
        </div>
    `;
}

function renderVehicles() {
    const config = state.snapshot.config || {};
    const player = selectedPlayer();
    const presets = (config.vehicles || []).slice(0, 18);
    return `
        <div class="view-grid vehicle-page">
            <section class="form-panel vehicle-spawn-panel">
                <header>
                    <div>
                        <h3>Vehicle Spawner</h3>
                        <p class="muted">${escapeHtml(player?.displayName || 'No player selected')}</p>
                    </div>
                    ${icon('car')}
                </header>
                <div class="form-grid vehicle-form-grid">
                    <div class="form-row wide"><label>Model</label><input id="vehicleInput" value="sultanrs" placeholder="sultanrs, police, adder"></div>
                    <div class="form-row"><label>Plate</label><input id="plateInput" maxlength="8" value="ADMIN"></div>
                </div>
                <div class="mini-grid" style="margin-top:12px">
                    <button class="primary-button" data-run="vehicle.spawn">${icon('plus')}<span>Spawn</span></button>
                    <button class="soft-button" data-run="vehicle.admincar">${icon('shield')}<span>Save Current</span></button>
                </div>
                <div class="vehicle-preset-grid">
                    ${presets.map((item) => `
                        <button class="vehicle-preset" data-preset-vehicle="${escapeHtml(item.model)}">
                            <strong>${escapeHtml(item.label || item.model)}</strong>
                            <span>${escapeHtml(item.model)}</span>
                        </button>
                    `).join('')}
                </div>
            </section>

            <section class="form-panel vehicle-tools-panel">
                <header>
                    <div>
                        <h3>Selected Player Vehicle</h3>
                        <p class="muted">${player ? escapeHtml(`#${player.id} ${player.displayName || player.name}`) : 'Select a player'}</p>
                    </div>
                    ${icon('wrench')}
                </header>
                <div class="vehicle-tool-grid">
                    <button class="primary-button" data-run="vehicle.customize">${icon('settings')}<span>Customize</span></button>
                    <button class="soft-button" data-run="vehicle.repair">${icon('wrench')}<span>Repair</span></button>
                    <button class="soft-button" data-run="vehicle.flip">${icon('wrench')}<span>Flip</span></button>
                    <button class="soft-button" data-run="vehicle.refuel">${icon('food')}<span>Refuel</span></button>
                    <button class="soft-button" data-run="vehicle.clean">${icon('wrench')}<span>Clean</span></button>
                    <button class="soft-button" data-run="vehicle.maxMods">${icon('wrench')}<span>Max Mods</span></button>
                    <button class="soft-button" data-run="vehicle.keys">${icon('key')}<span>Keys</span></button>
                    <button class="danger-button" data-run="vehicle.impound">${icon('trash')}<span>Impound</span></button>
                    <button class="danger-button" data-run="vehicle.delete">${icon('trash')}<span>Delete</span></button>
                </div>
            </section>

            <section class="form-panel vehicle-cleanup-panel">
                <header>
                    <div>
                        <h3>Inventory Cleanup</h3>
                        <p class="muted">${player ? escapeHtml(`Remove key stacks from ${player.displayName || player.name}`) : 'Select a player'}</p>
                    </div>
                    ${icon('key')}
                </header>
                <div class="mini-grid">
                    <button class="danger-button" data-run="player.clearVehicleKeys">${icon('key')}<span>Clear Vehicle Keys</span></button>
                </div>
            </section>

            <section class="form-panel vehicle-reference-panel">
                <header><h3>Configured Vehicles</h3><span class="chip">${(config.vehicles || []).length}</span></header>
                <div class="vehicle-reference-list">
                    ${(config.vehicles || []).slice(0, 40).map((item) => `
                        <button data-preset-vehicle="${escapeHtml(item.model)}">
                            <strong>${escapeHtml(item.label || item.model)}</strong>
                            <code>${escapeHtml(item.model)}</code>
                        </button>
                    `).join('') || '<div class="empty compact">No configured vehicles</div>'}
                </div>
            </section>
        </div>
    `;
}

function renderCoords() {
    const self = players().find((player) => Number(player.id) === selfId());
    const livePlayer = state.coordTool.player || self?.coords || selectedPlayer()?.coords || { x: 0, y: 0, z: 0, h: 0 };
    const playerCoords = {
        x: livePlayer.x,
        y: livePlayer.y,
        z: livePlayer.z,
        h: livePlayer.h
    };
    const target = state.coordTool.target || { hit: false, x: 0, y: 0, z: 0 };
    const targetCoords = {
        x: target.x,
        y: target.y,
        z: target.z,
        h: playerCoords.h
    };
    const camera = state.coordTool.camera || {};
    const favoriteName = `Saved ${state.coordFavorites.length + 1}`;
    const targetReady = Number.isFinite(Number(target.x)) && Number.isFinite(Number(target.y)) && Number.isFinite(Number(target.z));

    return `
        <div class="view-grid coords-page">
            <section class="form-panel coords-live-panel">
                <header>
                    <div>
                        <h3>Coordinate Finder</h3>
                        <p class="muted">${livePlayer.inVehicle ? 'Vehicle position' : 'Player position'}</p>
                    </div>
                    <button class="primary-button" data-coord-favorite-add="player">${icon('plus')}<span>Save</span></button>
                </header>
                <div class="coords-readout">
                    <div><span>X</span><strong>${coordNumber(playerCoords.x)}</strong></div>
                    <div><span>Y</span><strong>${coordNumber(playerCoords.y)}</strong></div>
                    <div><span>Z</span><strong>${coordNumber(playerCoords.z)}</strong></div>
                    <div><span>H</span><strong>${coordHeading(playerCoords.h)}</strong></div>
                </div>
                <div class="coords-format-list">
                    <code>${escapeHtml(coordFormat(playerCoords, 'vector3'))}</code>
                    <code>${escapeHtml(coordFormat(playerCoords, 'vector4'))}</code>
                    <code>${escapeHtml(coordFormat(playerCoords, 'table'))}</code>
                </div>
                <div class="coords-copy-grid">
                    ${coordCopyButtons(playerCoords, 'player')}
                </div>
                <div class="coords-action-row">
                    <input id="coordFavoriteName" class="compact-input" value="${escapeHtml(favoriteName)}" maxlength="48">
                    <button class="soft-button" data-coord-teleport="player">${icon('send')}<span>Teleport</span></button>
                </div>
            </section>

            <section class="form-panel coords-target-panel">
                <header>
                    <div>
                        <h3>Vector Finder</h3>
                        <p class="muted">${target.hit ? 'Camera target locked' : 'Camera endpoint'}</p>
                    </div>
                    <button class="switch-button coords-laser-toggle" data-coord-laser="${state.coordTool.laser ? 'false' : 'true'}" aria-pressed="${state.coordTool.laser ? 'true' : 'false'}">
                        <span>Laser</span><i></i>
                    </button>
                </header>
                <div class="coords-target-status ${target.hit ? 'hit' : ''}">
                    <span>${target.hit ? 'Hit' : 'Trace'}</span>
                    <strong>x:${coordNumber(targetCoords.x)} y:${coordNumber(targetCoords.y)} z:${coordNumber(targetCoords.z)}</strong>
                </div>
                <div class="coords-format-list">
                    <code>${escapeHtml(coordFormat(targetCoords, 'vector3'))}</code>
                    <code>${escapeHtml(coordFormat(targetCoords, 'vector4'))}</code>
                    <code>${escapeHtml(coordFormat(targetCoords, 'table'))}</code>
                </div>
                <div class="coords-copy-grid">
                    ${coordCopyButtons(targetCoords, 'target')}
                </div>
                <div class="coords-action-row">
                    <button class="primary-button" data-coord-favorite-add="target" ${targetReady ? '' : 'disabled'}>${icon('plus')}<span>Save Target</span></button>
                    <button class="soft-button" data-coord-teleport="target" ${targetReady ? '' : 'disabled'}>${icon('send')}<span>Teleport Target</span></button>
                </div>
            </section>

            <section class="form-panel coords-camera-panel">
                <header><h3>Camera</h3>${icon('camera')}</header>
                <div class="kv">
                    <span>X</span><span>${coordNumber(camera.x)}</span>
                    <span>Y</span><span>${coordNumber(camera.y)}</span>
                    <span>Z</span><span>${coordNumber(camera.z)}</span>
                    <span>Pitch</span><span>${coordHeading(camera.pitch)}</span>
                    <span>Yaw</span><span>${coordHeading(camera.yaw)}</span>
                    <span>Roll</span><span>${coordHeading(camera.roll)}</span>
                </div>
            </section>

            <section class="form-panel coords-favorites-panel">
                <header>
                    <div>
                        <h3>Favorites</h3>
                        <p class="muted">${state.coordFavorites.length} saved locations</p>
                    </div>
                    <span class="chip">${state.coordFavorites.length}/40</span>
                </header>
                <div class="coords-favorite-list">
                    ${state.coordFavorites.map((favorite, index) => `
                        <article class="coords-favorite-row">
                            <div>
                                <strong>${escapeHtml(favorite.name || `Location ${index + 1}`)}</strong>
                                <code>${escapeHtml(coordFormat(favorite.coords, 'vector4'))}</code>
                            </div>
                            <button class="icon-button" data-copy-text="${escapeHtml(coordFormat(favorite.coords, 'vector4'))}" title="Copy">${icon('copy')}</button>
                            <button class="icon-button" data-coord-favorite-teleport="${index}" title="Teleport">${icon('send')}</button>
                            <button class="icon-button" data-coord-favorite-remove="${index}" title="Delete">${icon('trash')}</button>
                        </article>
                    `).join('') || '<div class="empty compact">No saved coordinates</div>'}
                </div>
            </section>
        </div>
    `;
}

function renderCoordOverlay() {
    if (!els.coordOverlay) return;

    els.coordOverlay.hidden = !state.coordOverlay;
    if (!state.coordOverlay) {
        els.coordOverlay.innerHTML = '';
        return;
    }

    if (!state.snapshot) state.snapshot = demoSnapshot();
    els.coordOverlay.innerHTML = renderCoordHud();
    hydrateStaticIcons(els.coordOverlay);
}

function renderCoordHud() {
    const player = state.coordTool.player || { x: 0, y: 0, z: 0, h: 0 };
    const target = state.coordTool.target || { hit: false, x: 0, y: 0, z: 0 };
    const camera = state.coordTool.camera || {};
    const targetCoords = {
        x: target.x,
        y: target.y,
        z: target.z,
        h: player.h
    };

    return `
        <section class="coord-hud">
            <header>
                <div>
                    <strong>Coordinate Finder</strong>
                    <span>${target.hit ? 'Target locked' : 'Camera trace'}</span>
                </div>
                <i>${target.hit ? 'HIT' : 'TRACE'}</i>
            </header>
            <div class="coord-hud-grid">
                <div><span>X</span><strong>${coordNumber(player.x)}</strong></div>
                <div><span>Y</span><strong>${coordNumber(player.y)}</strong></div>
                <div><span>Z</span><strong>${coordNumber(player.z)}</strong></div>
                <div><span>H</span><strong>${coordHeading(player.h)}</strong></div>
            </div>
            <div class="coord-hud-line">
                <span>Vector4</span>
                <code>${escapeHtml(coordFormat(player, 'vector4'))}</code>
            </div>
            <div class="coord-hud-line target">
                <span>Aim</span>
                <code>${escapeHtml(coordFormat(targetCoords, 'vector3'))}</code>
            </div>
            <div class="coord-hud-shortcuts">
                <span><kbd>1</kbd><b>Vec3</b></span>
                <span><kbd>2</kbd><b>Vec4</b></span>
                <span><kbd>3</kbd><b>Aim Vec3</b></span>
                <span><kbd>4</kbd><b>Aim Vec4</b></span>
                <span><kbd>5</kbd><b>Table</b></span>
                <span><kbd>6</kbd><b>Heading</b></span>
            </div>
            <div class="coord-hud-meta">
                <span>Cam ${coordHeading(camera.pitch)} / ${coordHeading(camera.yaw)}</span>
                <kbd>ESC</kbd><b>Close</b>
            </div>
        </section>
    `;
}

function renderConsole() {
    const logs = state.snapshot.actionLogs || [];
    const serverLogs = state.snapshot.serverConsoleLogs || [];
    const consoleLogs = logs.filter((log) => log.action === 'Console Command');
    const suggestions = consoleCommandSuggestions();
    const accessLabel = can('consoleAll') ? 'Full Access' : 'Allowlisted';
    return `
        <div class="view-grid console-page">
            <section class="form-panel console-exec-panel">
                <header><h3>Console</h3><span class="chip amber">${accessLabel}</span></header>
                <div class="console-line">
                    <input class="console-input" id="consoleInput" value="say Admin menu online" autocomplete="off" spellcheck="false">
                    <button class="primary-button" data-run="console.execute">${icon('terminal')}<span>Execute</span></button>
                </div>
                <div class="console-suggestions">
                    ${suggestions.map((item) => `
                        <button data-console-command="${escapeHtml(item.template || item.command)}">
                            <strong>${escapeHtml(item.label || item.command)}</strong>
                            <code>${escapeHtml(item.template || item.command)}</code>
                        </button>
                    `).join('') || '<div class="empty compact">No command suggestions</div>'}
                </div>
            </section>

            <section class="form-panel console-server-panel">
                <header>
                    <div>
                        <h3>Server Console</h3>
                        <p class="muted">Admin menu server feed</p>
                    </div>
                    <span class="chip">${serverLogs.length}</span>
                </header>
                <div class="console-terminal">
                    ${serverLogs.slice(0, 80).map((log) => `
                        <div class="console-terminal-row ${escapeHtml(log.level || 'info')}">
                            <time>${escapeHtml(formatTime(log.time))}</time>
                            <strong>${escapeHtml(log.source || 'server')}</strong>
                            <span>${escapeHtml(log.message || '')}</span>
                        </div>
                    `).join('') || '<div class="empty compact">No server console messages yet</div>'}
                </div>
            </section>

            <section class="form-panel console-history-panel">
                <header><h3>Recent Commands</h3><span class="chip">${consoleLogs.length}</span></header>
                <div class="log-list">
                    ${consoleLogs.slice(0, 12).map((log) => `
                        <button class="log-row" data-console-command="${escapeHtml(log.detail || '')}">
                            <strong>${escapeHtml(log.actor)}</strong>
                            <span>${escapeHtml(log.detail || '')}</span>
                            <small>${escapeHtml(formatTime(log.time))}</small>
                        </button>
                    `).join('') || '<div class="empty compact">No console commands</div>'}
                </div>
            </section>

            <section class="form-panel console-audit-panel">
                <header><h3>Audit Feed</h3>${icon('terminal')}</header>
                <div class="log-list">
                    ${logs.slice(0, 16).map((log) => `<div class="log-row"><strong>${escapeHtml(log.action)}</strong><span>${escapeHtml(log.actor)} -> ${escapeHtml(log.target)} ${escapeHtml(log.detail)}</span><small>${escapeHtml(formatTime(log.time))}</small></div>`).join('') || '<div class="empty compact">No action logs</div>'}
                </div>
            </section>
        </div>
    `;
}

function renderEvents() {
    const events = state.snapshot.config?.events || [];
    const eventLogs = (state.snapshot.actionLogs || []).filter((log) => log.action === 'Trigger Event');
    const currentEvent = eventByName(selectedEventName()) || events[0] || null;
    const selectedTarget = selectedPlayer();
    return `
        <div class="view-grid events-page">
            <section class="form-panel event-runner-panel">
                <header>
                    <div>
                        <h3>Event Runner</h3>
                        <p class="muted">${currentEvent ? escapeHtml(currentEvent.name) : 'No allowlisted events'}</p>
                    </div>
                    ${icon('zap')}
                </header>
                <div class="form-grid event-form-grid">
                    <div class="form-row wide">
                        <label>Event ${helpTip('Only events listed in Config.AllowedEvents can be triggered from here.')}</label>
                        <select id="eventSelect">
                            ${events.map((event) => `<option value="${escapeHtml(event.name)}" ${currentEvent?.name === event.name ? 'selected' : ''}>${escapeHtml(event.label || event.name)}</option>`).join('')}
                        </select>
                    </div>
                    <div class="form-row">
                        <label>Target ${helpTip('Client events use a server ID here, or -1 for everyone. Server events ignore this.')}</label>
                        <input id="eventTargetInput" type="number" min="-1" value="${currentEvent?.type === 'client' ? escapeHtml(selectedTarget?.id ?? -1) : -1}">
                    </div>
                    <div class="form-row wide">
                        <label>Payload JSON ${helpTip('Configured payload sent to the event. Staff edits apply only when the event sets allowClientPayload = true.')}</label>
                        <textarea id="eventPayloadInput" rows="5" spellcheck="false">${escapeHtml(eventPayloadText(currentEvent))}</textarea>
                    </div>
                </div>
                <div class="mini-grid" style="margin-top:12px">
                    <button class="primary-button" data-run="event.trigger" ${events.length === 0 ? 'disabled' : ''}>${icon('zap')}<span>Trigger Event</span></button>
                    <button class="soft-button" data-event-fill-payload>${icon('copy')}<span>Reset Payload</span></button>
                </div>
            </section>

            <section class="form-panel event-list-panel">
                <header><h3>Allowlist ${helpTip('Edit Config.AllowedEvents to add or remove event cards.')}</h3><span class="chip">${events.length}</span></header>
                <div class="event-card-grid">
                    ${events.map((event) => `
                        <button class="event-card ${currentEvent?.name === event.name ? 'active' : ''}" data-event-select="${escapeHtml(event.name)}">
                            <span class="chip ${event.type === 'client' ? 'mint' : 'amber'}">${escapeHtml(event.type || 'server')}</span>
                            <strong>${escapeHtml(event.label || event.name)}</strong>
                            <code>${escapeHtml(event.name)}</code>
                            ${event.description ? `<small>${escapeHtml(event.description)}</small>` : ''}
                        </button>
                    `).join('') || '<div class="empty compact">No allowlisted events</div>'}
                </div>
            </section>

            <section class="form-panel event-history-panel">
                <header><h3>Recent Events ${helpTip('Click a history row to reselect that event without firing it.')}</h3><span class="chip">${eventLogs.length}</span></header>
                <div class="log-list">
                    ${eventLogs.slice(0, 14).map((log) => `
                        <button class="log-row" data-event-select="${escapeHtml(eventNameFromLog(log))}">
                            <strong>${escapeHtml(log.target || 'Event')}</strong>
                            <span>${escapeHtml(log.actor)} -> ${escapeHtml(log.detail)}</span>
                            <small>${escapeHtml(formatTime(log.time))}</small>
                        </button>
                    `).join('') || '<div class="empty compact">No event history</div>'}
                </div>
            </section>
        </div>
    `;
}

function renderStaff() {
    const staff = staffRoster();
    const onDuty = staff.filter((player) => player.duty);
    const logs = state.snapshot.actionLogs || [];
    const staffLogs = logs.filter((log) => [
        'Duty Toggle',
        'Set Staff Tag',
        'Clear Staff Tag',
        'Admin Chat',
        'Announcement',
        'Trigger Event',
        'Console Command',
        'Denied',
        'Blocked Self Target'
    ].includes(log.action));
    const permissions = Object.entries(state.snapshot.self?.permissions || {})
        .filter(([key]) => key !== 'consoleAll')
        .sort((a, b) => Number(b[1] === true) - Number(a[1] === true) || a[0].localeCompare(b[0]));
    const selected = selectedPlayer();
    const tagCount = state.snapshot.config?.staffTags?.length || 0;
    return `
        <div class="view-grid staff-grid">
            <section class="form-panel staff-overview-panel">
                <header>
                    <div>
                        <h3>Staff Overview</h3>
                        <p class="muted">${escapeHtml(state.snapshot.self?.duty ? 'You are on duty' : 'You are off duty')}</p>
                    </div>
                    <button class="primary-button" data-run="duty.toggle">${icon('shield')}<span>Toggle Duty</span></button>
                </header>
                <div class="staff-stat-grid">
                    <div class="staff-stat"><span>Online Staff</span><strong>${staff.length}</strong></div>
                    <div class="staff-stat"><span>On Duty</span><strong>${onDuty.length}</strong></div>
                    <div class="staff-stat"><span>Configured Tags</span><strong>${tagCount}</strong></div>
                    <div class="staff-stat"><span>Allowed Perms</span><strong>${permissions.filter(([, allowed]) => allowed).length}</strong></div>
                </div>
            </section>

            <section class="form-panel staff-roster-panel">
                <header><h3>Online Staff</h3><span class="chip">${staff.length}</span></header>
                <div class="staff-roster-list">
                    ${staff.map((player) => `
                        <button class="staff-roster-row ${player.id === state.selectedId ? 'active' : ''}" data-select="${player.id}">
                            ${playerAvatar(player, 'mini')}
                            <div>
                                <strong>${escapeHtml(player.displayName || player.name)}</strong>
                                <span>${escapeHtml(player.job?.label || 'Staff')} - #${player.id}</span>
                            </div>
                            <div class="staff-roster-tags">
                                ${playerStaffTagsMarkup(player, 'rail') || '<span class="chip">Staff</span>'}
                                <span class="chip ${player.duty ? 'mint' : ''}">${player.duty ? 'Duty' : 'Online'}</span>
                            </div>
                        </button>
                    `).join('') || '<div class="empty compact">No tagged or on-duty staff online</div>'}
                </div>
            </section>

            <section class="form-panel staff-permissions-panel">
                <header><h3>Your Permissions ${helpTip('Permission states come from ACE, txAdmin/fxPanel bridges, and snipz_adminmenu config.')}</h3>${icon('shield')}</header>
                <div class="permission-grid">
                    ${permissions.map(([key, value]) => `<div class="permission-card ${value ? 'allowed' : 'denied'}"><span>${escapeHtml(permissionLabel(key))}</span><strong>${value ? 'Allowed' : 'Denied'}</strong>${icon(value ? 'shield' : 'ban')}</div>`).join('') || '<div class="empty compact">No permissions found</div>'}
                </div>
            </section>

            ${can('manageAdmins') ? `
                <section class="form-panel staff-tags-panel">
                    <header>
                        <div>
                            <h3>Staff Tags</h3>
                            <p class="muted">${selected ? escapeHtml(selected.displayName || selected.name) : 'Select a player'}</p>
                        </div>
                        ${icon('shield')}
                    </header>
                    <div class="staff-selected-card">
                        ${selected ? `
                            ${playerAvatar(selected, 'mini')}
                            <div>
                                <strong>${escapeHtml(selected.displayName || selected.name)}</strong>
                                <span>${playerStaffTagsMarkup(selected, 'rail') || '<span class="chip">No tag</span>'}</span>
                            </div>
                        ` : '<div class="empty compact">No player selected</div>'}
                    </div>
                    <div class="mini-grid" style="margin-top:12px">
                        <button class="primary-button" data-run="staff.tagSet">${icon('shield')}<span>Set Tag</span></button>
                        <button class="danger-button" data-run="staff.tagClear">${icon('trash')}<span>Clear Tag</span></button>
                    </div>
                </section>
            ` : ''}

            <section class="form-panel staff-audit">
                <header><h3>Staff Activity</h3><span class="chip">${staffLogs.length}</span></header>
                <div class="log-list">
                    ${(staffLogs.length ? staffLogs : logs).slice(0, 14).map((log) => `<div class="log-row"><strong>${escapeHtml(log.action)}</strong><span>${escapeHtml(log.actor)} -> ${escapeHtml(log.target)} ${escapeHtml(log.detail || '')}</span><small>${escapeHtml(formatTime(log.time))}</small></div>`).join('') || '<div class="empty compact">No staff activity</div>'}
                </div>
            </section>
        </div>
    `;
}

function renderBlips() {
    const player = selectedPlayer();
    const outVehicles = ownedVehicles();
    const markers = `${ownedVehicleMapMarkers('tracker')}${playerMapMarkers('tracker')}`;
    const pop = player ? (() => {
        const pos = mapPopPosition(player.coords);
        if (!pos) return '';

        return `<div class="map-pop blip-pop ${pos.below ? 'below' : ''}" style="${mapPopStyle(pos)}">
            <strong>${escapeHtml(player.displayName || player.name)}</strong>
            <span>#${player.id} - ${escapeHtml(player.job?.label || 'No Job')}</span>
            <button class="primary-button" ${runAttributes('player.goto')}>${icon('pin')}<span>Goto</span></button>
        </div>`;
    })() : '';
    const list = players()
        .map((item) => ({ ...item, _distance: playerDistanceFromSelected(item) }))
        .sort((a, b) => {
            if (a.id === state.selectedId) return -1;
            if (b.id === state.selectedId) return 1;
            return (a._distance ?? Number.MAX_SAFE_INTEGER) - (b._distance ?? Number.MAX_SAFE_INTEGER);
        });
    const vehicleList = outVehicles
        .map((vehicle) => ({ ...vehicle, _distance: distanceFromSelectedCoords(vehicle.coords) }))
        .sort((a, b) => {
            if (a.stale !== b.stale) return a.stale ? 1 : -1;
            return (a._distance ?? Number.MAX_SAFE_INTEGER) - (b._distance ?? Number.MAX_SAFE_INTEGER);
        });

    return `
        <div class="view-grid blips-page">
            <section class="form-panel blip-map-panel">
                <header>
                    <div>
                        <h3>Player Tracker</h3>
                        <p class="muted">${players().length} online players</p>
                    </div>
                    <button class="primary-button" data-run="self.blips">${icon('pin')}<span>Toggle Game Blips</span></button>
                </header>
                <div class="map-panel blip-map" data-map-viewport="blips">
                    <div class="map-layer" style="${blipMapLayerStyle()}">
                        <img class="map-image" src="${escapeHtml(mapAssetCandidates()[0])}" data-map-index="0" alt="" draggable="false">
                        ${markers}
                        ${pop}
                    </div>
                    <div class="blip-map-controls" aria-label="Tracker map controls">
                        <button class="icon-button" data-map-zoom="in" title="Zoom in">${icon('plus')}</button>
                        <button class="icon-button" data-map-zoom="out" title="Zoom out">${icon('minus')}</button>
                        <button class="icon-button" data-map-center-selected title="Center selected player">${icon('pin')}</button>
                        <button class="icon-button" data-map-zoom="reset" title="Reset map">${icon('refresh')}</button>
                    </div>
                    <div class="blip-legend">
                        <span><i class="legend-dot player"></i>Player</span>
                        <span><i class="legend-dot selected"></i>Selected</span>
                        <span><i class="legend-dot staff"></i>Duty</span>
                        <span><i class="legend-dot vehicle"></i>Owned Vehicle</span>
                    </div>
                </div>
            </section>

            <section class="form-panel blip-selected-panel">
                <header><h3>Selected</h3><span class="chip">#${escapeHtml(player?.id ?? '-')}</span></header>
                ${player ? `
                    <div class="blip-selected-card">
                        ${playerAvatar(player, 'large')}
                        <div>
                            <strong>${escapeHtml(player.displayName || player.name)}</strong>
                            <span>${escapeHtml(player.job?.label || 'No Job')} - ${escapeHtml(player.gang?.label || 'No Gang')}</span>
                            <code>x:${Number(player.coords?.x || 0).toFixed(1)} y:${Number(player.coords?.y || 0).toFixed(1)} z:${Number(player.coords?.z || 0).toFixed(1)}</code>
                            <div class="chip-row">${playerStaffTagsMarkup(player, 'rail')}${player.duty ? '<span class="chip mint">Duty</span>' : '<span class="chip">Online</span>'}</div>
                        </div>
                    </div>
                    <div class="mini-grid" style="margin-top:12px">
                        <button class="primary-button" ${runAttributes('player.goto')}>${icon('pin')}<span>Goto</span></button>
                        <button class="soft-button" ${runAttributes('player.bring')}>${icon('pin')}<span>Bring</span></button>
                        <button class="soft-button" data-run="copy.coords">${icon('copy')}<span>Copy Coords</span></button>
                    </div>
                ` : '<div class="empty compact">No selected player</div>'}
            </section>

            <section class="form-panel blip-vehicle-panel">
                <header><h3>Out Vehicles</h3><span class="chip">${vehicleList.length}</span></header>
                <div class="blip-vehicle-list">
                    ${vehicleList.slice(0, 18).map((vehicle) => {
                        const coordText = coordsString(vehicle.coords);
                        return `
                            <div class="blip-vehicle-row ${vehicle.stale ? 'stale' : ''}">
                                ${icon('car')}
                                <div>
                                    <strong>${escapeHtml(vehicle.plate || 'NO PLATE')}</strong>
                                    <span>${escapeHtml(vehicle.model || 'Vehicle')} - ${escapeHtml(vehicle.ownerName || vehicle.citizenid || 'Unknown Owner')}</span>
                                </div>
                                <small>${vehicle.stale ? 'Last' : 'Live'}</small>
                                <button class="icon-button" data-copy-coords="${escapeHtml(coordText)}" title="Copy coords">${icon('copy')}</button>
                                <button class="icon-button" data-teleport-coords="${escapeHtml(coordText)}" title="Teleport">${icon('send')}</button>
                            </div>
                        `;
                    }).join('') || '<div class="empty compact">No out owned vehicles</div>'}
                </div>
            </section>

            <section class="form-panel blip-list-panel">
                <header><h3>Players</h3><span class="chip">${list.length}</span></header>
                <div class="blip-player-list">
                    ${list.map((item) => `
                        <button class="blip-player-row ${item.id === state.selectedId ? 'active' : ''}" data-select="${item.id}">
                            ${playerAvatar(item, 'mini')}
                            <div>
                                <strong>${escapeHtml(item.displayName || item.name)}</strong>
                                <span>${escapeHtml(item.job?.label || 'No Job')} - x:${Number(item.coords?.x || 0).toFixed(1)} y:${Number(item.coords?.y || 0).toFixed(1)}</span>
                            </div>
                            <small>${item.id === state.selectedId ? 'Selected' : escapeHtml(formatDistance(item._distance))}</small>
                        </button>
                    `).join('') || '<div class="empty compact">No players online</div>'}
                </div>
            </section>
        </div>
    `;
}

function renderSettings() {
    const server = state.snapshot.server || {};
    const weather = state.snapshot.config?.weather || [];
    const logs = state.snapshot.actionLogs || [];
    const blackoutEnabled = server.blackout === true;
    const serverLogs = logs.filter((log) => [
        'Set Weather',
        'Set Time',
        'Blackout',
        'Revive All',
        'Noclip Toggle',
        'Godmode Toggle',
        'Invisible Toggle',
        'Blips Toggle'
    ].includes(log.action));

    return `
        <div class="view-grid settings-page">
            <section class="form-panel settings-overview-panel">
                <header>
                    <div>
                        <h3>Server State</h3>
                        <p class="muted">${escapeHtml(server.resource || 'snipz_adminmenu')}</p>
                    </div>
                    ${icon('settings')}
                </header>
                <div class="settings-stat-grid">
                    <div class="settings-stat"><span>Players</span><strong>${escapeHtml(`${server.players ?? players().length}/${server.maxPlayers ?? '-'}`)}</strong></div>
                    <div class="settings-stat"><span>Uptime</span><strong>${escapeHtml(server.uptime || '-')}</strong></div>
                    <div class="settings-stat"><span>Weather</span><strong>${escapeHtml(server.weather || 'CLEAR')}</strong></div>
                    <div class="settings-stat"><span>Time</span><strong>${String(server.time?.hour ?? 12).padStart(2, '0')}:${String(server.time?.minute ?? 0).padStart(2, '0')}</strong></div>
                </div>
            </section>

            <section class="form-panel settings-weather-panel">
                <header><h3>Weather</h3>${icon('cloud')}</header>
                <div class="settings-chip-grid">
                    ${weather.map((item) => `<button class="${item === server.weather ? 'active' : ''}" data-run="server.weather" data-weather="${escapeHtml(item)}">${escapeHtml(item)}</button>`).join('')}
                </div>
                <div class="mini-grid" style="margin-top:12px">
                    <button class="switch-button blackout-toggle" data-run="server.blackout" data-state="${blackoutEnabled ? 'false' : 'true'}" aria-pressed="${blackoutEnabled ? 'true' : 'false'}">
                        <i></i><span>Blackout ${blackoutEnabled ? 'On' : 'Off'}</span>
                    </button>
                </div>
            </section>

            <section class="form-panel settings-time-panel">
                <header><h3>Time</h3><button class="primary-button" data-run="server.time">${icon('clock')}<span>Apply</span></button></header>
                <div class="form-grid settings-control-grid">
                    <div class="form-row"><label>Hour</label><input id="hourInput" type="number" min="0" max="23" value="${server.time?.hour ?? 12}"></div>
                    <div class="form-row"><label>Minute</label><input id="minuteInput" type="number" min="0" max="59" value="${server.time?.minute ?? 0}"></div>
                </div>
                <div class="settings-chip-grid">
                    <button data-time-preset="6:0">Morning</button>
                    <button data-time-preset="12:0">Noon</button>
                    <button data-time-preset="18:0">Evening</button>
                    <button data-time-preset="0:0">Midnight</button>
                </div>
            </section>

            <section class="form-panel settings-admin-panel">
                <header><h3>Admin Toggles</h3>${icon('shield')}</header>
                <div class="settings-action-grid">
                    <button class="soft-button" data-run="self.noclip">${icon('pin')}<span>Noclip</span></button>
                    <button class="soft-button" data-run="self.godmode">${icon('shield')}<span>Godmode</span></button>
                    <button class="soft-button" data-run="self.invisible">${icon('eye')}<span>Invisible</span></button>
                    <button class="soft-button" data-run="self.blips">${icon('pin')}<span>Game Blips</span></button>
                    <button class="danger-button" data-run="server.reviveAll">${icon('heart')}<span>Revive All</span></button>
                </div>
            </section>

            <section class="form-panel settings-resource-panel">
                <header><h3>Resource</h3>${icon('terminal')}</header>
                <div class="kv">
                    <span>Name</span><span>${escapeHtml(server.resource || '')}</span>
                    <span>Version</span><span>${escapeHtml(server.version || '')}</span>
                    <span>Command</span><span>/${escapeHtml(state.snapshot.config?.command || 'adminmenu')}</span>
                    <span>ACE Root</span><span>snipz_adminmenu</span>
                    <span>Console</span><span>${state.snapshot.config?.console?.enabled ? 'Enabled' : 'Disabled'}</span>
                    <span>Events</span><span>${state.snapshot.config?.events?.length || 0} allowlisted</span>
                </div>
            </section>

            <section class="form-panel settings-audit-panel">
                <header><h3>Server Activity</h3><span class="chip">${serverLogs.length}</span></header>
                <div class="log-list">
                    ${serverLogs.slice(0, 12).map((log) => `<div class="log-row"><strong>${escapeHtml(log.action)}</strong><span>${escapeHtml(log.actor)} -> ${escapeHtml(log.target)} ${escapeHtml(log.detail || '')}</span><small>${escapeHtml(formatTime(log.time))}</small></div>`).join('') || '<div class="empty compact">No server activity</div>'}
                </div>
            </section>
        </div>
    `;
}

function value(id, fallback = '') {
    const el = document.getElementById(id);
    return el ? el.value : fallback;
}

function numberValue(id, fallback = 0) {
    const parsed = Number(value(id, fallback));
    return Number.isFinite(parsed) ? parsed : fallback;
}

function coordsValue(id = 'coordsInput') {
    return coordsFromString(value(id, ''));
}

function coordsFromString(rawValue = '') {
    const parts = String(rawValue)
        .split(/[,\s]+/)
        .filter(Boolean)
        .map((part) => Number(part));

    return {
        x: Number.isFinite(parts[0]) ? parts[0] : 0,
        y: Number.isFinite(parts[1]) ? parts[1] : 0,
        z: Number.isFinite(parts[2]) ? parts[2] : 0,
        h: Number.isFinite(parts[3]) ? parts[3] : 0
    };
}

async function runAction(actionName, source) {
    const reason = value('reasonInput', 'Admin action');
    const preflightPayload = actionName === 'player.freeze' ? { state: true } : {};
    const blockMessage = selfTargetBlockMessage(actionName, preflightPayload);

    if (blockMessage) {
        toast(blockMessage, 'warning');
        return;
    }

    if (actionName === 'player.noteEdit') {
        const note = selectedPlayerNote(source?.dataset.noteEdit);
        if (!note || !canManagePlayerNote(note)) return;

        const edited = await promptDialog({
            title: 'Edit Staff Note',
            placeholder: 'Staff note',
            defaultValue: note.note || '',
            confirmText: 'Save'
        });
        const trimmed = edited?.trim();
        if (trimmed) action('player.noteEdit', { noteId: note.id, note: trimmed });
        return;
    }

    if (actionName === 'player.noteDelete') {
        const note = selectedPlayerNote(source?.dataset.noteDelete);
        if (!note || !canManagePlayerNote(note)) return;

        if (await confirmDialog('Delete this staff note?', {
            title: 'Delete Staff Note',
            confirmText: 'Delete',
            danger: true
        })) {
            action('player.noteDelete', { noteId: note.id });
        }
        return;
    }

    if (actionName === 'player.warnEdit') {
        const warning = selectedPlayerWarning(source?.dataset.warningEdit);
        if (!warning) return;

        const edited = await promptDialog({
            title: 'Edit Warning',
            placeholder: 'Warning reason',
            defaultValue: warning.reason || '',
            confirmText: 'Save'
        });
        const trimmed = edited?.trim();
        if (trimmed) action('player.warnEdit', { warningId: warning._id, reason: trimmed });
        return;
    }

    if (actionName === 'player.warnDelete') {
        const warning = selectedPlayerWarning(source?.dataset.warningDelete);
        if (!warning) return;

        if (await confirmDialog('Delete this warning?', {
            title: 'Delete Warning',
            confirmText: 'Delete',
            danger: true
        })) {
            action('player.warnDelete', { warningId: warning._id });
        }
        return;
    }

    const detailPayload = await showActionDetailsDialog(actionName);
    if (detailPayload === null) {
        return;
    }

    if (!(await confirmAction(actionName))) {
        return;
    }

    if (actionName === 'transactions') {
        state.view = 'players';
        toast('Account balances are shown on the player card.', 'inform');
        render();
        return;
    }

    if (actionName === 'copy.coords') {
        const player = selectedPlayer();
        if (!player?.coords) return;
        copyText(coordsString(player.coords));
        return;
    }

    if (actionName === 'copy.identifiers') {
        copyText(playerIdentifierText(), 'Identifiers copied.');
        return;
    }

    if (actionName === 'player.saveLocation') {
        const player = selectedPlayer();
        if (!player?.coords) return;
        state.coordFavorites.unshift({
            name: `${player.displayName || player.name} #${player.id}`,
            coords: player.coords,
            savedAt: Date.now()
        });
        state.coordFavorites = state.coordFavorites.slice(0, 40);
        saveCoordFavorites();
        toast('Player location saved.', 'success');
        return;
    }

    if (actionName === 'player.screenshot') {
        const player = selectedPlayer();
        if (!player) return;
        state.remoteFeeds[player.id] = {
            ...(state.remoteFeeds[player.id] || {}),
            loading: true,
            error: null
        };
        await nui('remoteFeed', { targets: [player.id] });
        state.view = 'monitoring';
        render();
        toast('Screenshot requested.', 'inform');
        return;
    }

    if (actionName === 'player.unfreeze') {
        await action('player.freeze', { state: false });
        return;
    }

    if (actionName === 'player.freeze') {
        await action('player.freeze', { state: true });
        return;
    }

    if (actionName === 'player.voiceMute' || actionName === 'player.voiceUnmute') {
        await action('player.voiceMute', { state: actionName === 'player.voiceMute' });
        return;
    }

    if (actionName === 'player.chatMute' || actionName === 'player.chatUnmute') {
        await action('player.chatMute', { state: actionName === 'player.chatMute' });
        return;
    }

    const payloads = {
        'player.warn': () => ({ reason: detailPayload.reason ?? reason }),
        'player.kick': () => ({ reason: detailPayload.reason ?? reason }),
        'player.ban': () => ({ reason: detailPayload.reason ?? reason, duration: Number(detailPayload.duration ?? numberValue('durationInput', 0)) }),
        'player.jail': () => ({ reason: detailPayload.reason ?? reason, minutes: Number(detailPayload.minutes ?? numberValue('jailMinutes', 15)) }),
        'player.reviveRadius': () => ({ radius: Number(detailPayload.radius ?? numberValue('radiusInput', 20)) }),
        'player.setArmor': () => ({ amount: Number(detailPayload.amount ?? 100) }),
        'player.message': () => ({ message: detailPayload.message ?? value('playerMessageInput', value('messageInput', 'Please contact staff.')) }),
        'staff.tagSet': () => ({ tag: detailPayload.tag }),
        'player.noteAdd': () => ({ note: value('noteInput', '') }),
        'admin.chat': () => ({ message: value('adminChatInput', '') }),
        'player.teleportPreset': () => ({ preset: detailPayload.preset }),
        'player.teleportCoords': () => detailPayload.coords ? coordsFromString(detailPayload.coords) : coordsValue(),
        'item.give': () => ({ item: detailPayload.item ?? value('itemInput'), amount: Number(detailPayload.amount ?? numberValue('amountInput', 1)) }),
        'item.remove': () => ({ item: detailPayload.item ?? value('itemInput'), amount: Number(detailPayload.amount ?? numberValue('amountInput', 1)) }),
        'inventory.openStash': () => ({ stash: detailPayload.stash ?? value('stashInput', '') }),
        'inventory.openTrunk': () => ({ plate: detailPayload.plate ?? value('trunkPlateInput', value('plateInput', '')) }),
        'money.add': () => ({ account: detailPayload.account ?? value('accountInput', 'cash'), amount: Number(detailPayload.amount ?? numberValue('moneyInput', 0)) }),
        'money.remove': () => ({ account: detailPayload.account ?? value('accountInput', 'cash'), amount: Number(detailPayload.amount ?? numberValue('moneyInput', 0)) }),
        'money.set': () => ({ account: detailPayload.account ?? value('accountInput', 'cash'), amount: Number(detailPayload.amount ?? numberValue('moneyInput', 0)) }),
        'vehicle.spawn': () => ({ model: detailPayload.model ?? value('vehicleInput', 'adder'), plate: detailPayload.plate ?? value('plateInput', 'ADMIN') }),
        'vehicle.spawnForPlayer': () => ({ model: detailPayload.model ?? value('vehicleInput', 'adder'), plate: detailPayload.plate ?? value('plateInput', 'ADMIN') }),
        'vehicle.giveOwned': () => ({ model: detailPayload.model ?? value('vehicleInput', 'adder'), plate: detailPayload.plate ?? '', garage: detailPayload.garage ?? '' }),
        'player.setPed': () => ({ model: detailPayload.model ?? value('pedInput', 'mp_m_freemode_01') }),
        'player.giveWeapon': () => ({ weapon: detailPayload.weapon ?? value('weaponInput', 'WEAPON_PISTOL'), ammo: Number(detailPayload.ammo ?? numberValue('ammoInput', 120)) }),
        'player.setJob': () => ({ job: detailPayload.job ?? value('jobInput', 'unemployed'), grade: Number(detailPayload.grade ?? numberValue('gradeInput', 0)) }),
        'player.setGang': () => ({ gang: detailPayload.gang ?? value('gangInput', 'none'), grade: Number(detailPayload.grade ?? numberValue('gradeInput', 0)) }),
        'player.setDuty': () => ({ state: String(detailPayload.state) === 'true' }),
        'player.setLicense': () => ({ license: detailPayload.license, state: String(detailPayload.state) === 'true' }),
        'player.setGymStats': () => ({ stat: detailPayload.stat, value: Number(detailPayload.value ?? 100) }),
        'player.setBucket': () => ({ bucket: Number(detailPayload.bucket ?? numberValue('bucketInput', 0)) }),
        'console.execute': () => ({ command: value('consoleInput', '') }),
        'event.trigger': () => {
            const payload = parseJsonInput('eventPayloadInput', {});
            if (payload === null) return null;
            return {
                eventName: selectedEventName(),
                target: numberValue('eventTargetInput', -1),
                payload
            };
        },
        'server.weather': () => ({ weather: source?.dataset.weather || value('weatherInput', 'CLEAR') }),
        'server.time': () => ({ hour: numberValue('hourInput', 12), minute: numberValue('minuteInput', 0) }),
        'server.blackout': () => ({ state: source?.dataset.state === 'true' })
    };

    const payload = payloads[actionName]?.() || {};
    if (payload === null) return;

    const result = await action(actionName, payload);
    if (result?.ok !== false && actionName === 'admin.chat') {
        setAdminChatInput('', false);
    }
    if (result?.ok !== false && focusReleaseActions.has(actionName)) {
        await nui('close');
    }
}

function bindEvents() {
    els.nav.addEventListener('click', (event) => {
        const button = event.target.closest('[data-view]');
        if (!button) return;
        state.view = button.dataset.view;
        render();
    });

    document.body.addEventListener('pointerdown', (event) => {
        const select = event.target instanceof Element ? event.target.closest('.form-row select') : null;
        if (!select) return;

        event.preventDefault();
        event.stopPropagation();
        openSelectPicker(select);
    }, true);

    document.body.addEventListener('keydown', (event) => {
        const select = event.target instanceof Element ? event.target.closest('.form-row select') : null;
        if (!select || !['Enter', ' ', 'ArrowDown'].includes(event.key)) return;

        event.preventDefault();
        openSelectPicker(select);
    }, true);

    document.body.addEventListener('keydown', (event) => {
        const input = event.target instanceof Element ? event.target.closest('#consoleInput') : null;
        if (!input) return;

        if (event.key === 'Enter') {
            event.preventDefault();
            state.consoleHistoryIndex = -1;
            runAction('console.execute', input);
            return;
        }

        if (event.key === 'Tab') {
            event.preventDefault();
            if (!completeConsoleCommand(input)) {
                toast('No matching console command.', 'warning', null, { sound: false });
            }
            return;
        }

        if (event.key === 'ArrowUp' || event.key === 'ArrowDown') {
            const history = consoleCommandHistory();
            if (history.length === 0) return;

            event.preventDefault();
            state.consoleHistoryIndex = event.key === 'ArrowUp'
                ? Math.min(history.length - 1, state.consoleHistoryIndex + 1)
                : Math.max(-1, state.consoleHistoryIndex - 1);
            input.value = state.consoleHistoryIndex === -1 ? '' : history[state.consoleHistoryIndex];
            const end = input.value.length;
            input.setSelectionRange?.(end, end);
        }
    }, true);

    document.body.addEventListener('keydown', (event) => {
        const input = event.target instanceof Element ? event.target.closest('#adminChatInput') : null;
        if (!input) return;

        if (event.key === 'Enter') {
            event.preventDefault();
            runAction('admin.chat', input);
            return;
        }

        if (event.key === 'Tab') {
            event.preventDefault();
            if (!completeAdminChatInput(input)) {
                toast('No matching chat command or template.', 'warning', null, { sound: false });
            }
        }
    }, true);

    document.body.addEventListener('input', (event) => {
        const target = event.target instanceof Element ? event.target : null;
        if (!target) return;

        const fieldMap = {
            adminChatSearch: 'adminChatSearch',
            serverChatSearch: 'serverChatSearch',
            itemSearch: 'itemSearch',
            weaponSearch: 'weaponSearch',
            itemInput: 'itemName',
            weaponInput: 'weaponName'
        };
        const key = fieldMap[target.id];
        if (!key) return;

        state[key] = target.value;
        if (['adminChatSearch', 'serverChatSearch', 'itemSearch', 'weaponSearch'].includes(key)) {
            render({ preserveScroll: true });
        }
    });

    document.body.addEventListener('change', (event) => {
        const eventSelect = event.target instanceof Element ? event.target.closest('#eventSelect') : null;
        if (eventSelect) {
            setEventSelection(eventSelect.value);
        }
    });

    document.body.addEventListener('pointerdown', (event) => {
        const target = event.target instanceof Element ? event.target : null;
        const viewport = target ? target.closest('[data-map-viewport]') : null;
        if (!viewport) return;
        if (target.closest('button, a, input, select, textarea, .map-toolbar, .blip-legend, .blip-map-controls')) return;

        state.blipMap.dragging = true;
        state.blipMap.moved = false;
        state.blipMap.startX = event.clientX;
        state.blipMap.startY = event.clientY;
        state.blipMap.originX = state.blipMap.x;
        state.blipMap.originY = state.blipMap.y;
        viewport.setPointerCapture?.(event.pointerId);
    });

    document.body.addEventListener('pointermove', (event) => {
        if (!state.blipMap.dragging) return;

        const viewport = blipMapViewport();
        if (!viewport) return;

        const dx = event.clientX - state.blipMap.startX;
        const dy = event.clientY - state.blipMap.startY;
        if (Math.abs(dx) > 3 || Math.abs(dy) > 3) {
            state.blipMap.moved = true;
        }

        state.blipMap.x = state.blipMap.originX + dx;
        state.blipMap.y = state.blipMap.originY + dy;
        constrainBlipMap(viewport);

        const layer = viewport.querySelector('.map-layer');
        if (layer) layer.setAttribute('style', blipMapLayerStyle());
    });

    document.body.addEventListener('pointerup', (event) => {
        const viewport = blipMapViewport();
        if (viewport) viewport.releasePointerCapture?.(event.pointerId);
        state.blipMap.dragging = false;
    });

    document.body.addEventListener('pointercancel', () => {
        state.blipMap.dragging = false;
    });

    document.body.addEventListener('wheel', (event) => {
        const viewport = event.target instanceof Element ? event.target.closest('[data-map-viewport]') : null;
        if (!viewport) return;

        event.preventDefault();
        const direction = event.deltaY < 0 ? 1 : -1;
        setBlipMapZoom(state.blipMap.zoom + (direction * 0.25), event.clientX, event.clientY);
    }, { passive: false });

    document.body.addEventListener('click', (event) => {
        if (state.blipMap.moved) {
            state.blipMap.moved = false;
            return;
        }

        const mapZoom = event.target.closest('[data-map-zoom]');
        if (mapZoom) {
            const mode = mapZoom.dataset.mapZoom;
            if (mode === 'in') setBlipMapZoom(state.blipMap.zoom + 0.35);
            if (mode === 'out') setBlipMapZoom(state.blipMap.zoom - 0.35);
            if (mode === 'reset') resetBlipMap();
            return;
        }

        if (event.target.closest('[data-map-center-selected]')) {
            centerBlipMapOnSelected();
            return;
        }

        const select = event.target.closest('[data-select]');
        if (select) {
            setSelected(select.dataset.select);
            return;
        }

        const consoleCommand = event.target.closest('[data-console-command]');
        if (consoleCommand) {
            state.consoleHistoryIndex = -1;
            setConsoleInput(consoleCommand.dataset.consoleCommand || '');
            return;
        }

        const chatTemplate = event.target.closest('[data-chat-template]');
        if (chatTemplate) {
            setAdminChatInput(chatTemplate.dataset.chatTemplate || '');
            return;
        }

        const monitorSelect = event.target.closest('[data-monitor-select]');
        if (monitorSelect) {
            state.selectedId = Number(monitorSelect.dataset.monitorSelect);
            render({ preserveScroll: true });
            return;
        }

        const copyCoords = event.target.closest('[data-copy-coords]');
        if (copyCoords) {
            copyText(copyCoords.dataset.copyCoords);
            return;
        }

        const copyGeneric = event.target.closest('[data-copy-text]');
        if (copyGeneric) {
            copyText(copyGeneric.dataset.copyText);
            return;
        }

        const teleportCoords = event.target.closest('[data-teleport-coords]');
        if (teleportCoords) {
            action('player.teleportCoords', coordsFromString(teleportCoords.dataset.teleportCoords));
            return;
        }

        const coordLaser = event.target.closest('[data-coord-laser]');
        if (coordLaser) {
            const laser = coordLaser.dataset.coordLaser === 'true';
            state.coordTool.laser = laser;
            nui('coordTool', { laser });
            render({ preserveScroll: true });
            return;
        }

        const coordFavoriteAdd = event.target.closest('[data-coord-favorite-add]');
        if (coordFavoriteAdd) {
            const source = coordFavoriteAdd.dataset.coordFavoriteAdd || 'player';
            const coords = coordSource(source);
            if (!coords) return;

            const nameInput = document.getElementById('coordFavoriteName');
            const name = (nameInput?.value || `${source === 'target' ? 'Target' : 'Location'} ${state.coordFavorites.length + 1}`).trim();
            state.coordFavorites.unshift({
                name,
                coords: {
                    x: Number(coords.x) || 0,
                    y: Number(coords.y) || 0,
                    z: Number(coords.z) || 0,
                    h: Number(source === 'target' ? state.coordTool.player?.h : coords.h) || 0
                },
                savedAt: Date.now()
            });
            state.coordFavorites = state.coordFavorites.slice(0, 40);
            saveCoordFavorites();
            toast('Coordinate saved.', 'success');
            render({ preserveScroll: true });
            return;
        }

        const coordTeleport = event.target.closest('[data-coord-teleport]');
        if (coordTeleport) {
            const coords = coordSource(coordTeleport.dataset.coordTeleport || 'player');
            if (coords) {
                action('player.teleportCoords', {
                    x: Number(coords.x) || 0,
                    y: Number(coords.y) || 0,
                    z: Number(coords.z) || 0,
                    h: Number(coords.h ?? state.coordTool.player?.h) || 0
                });
            }
            return;
        }

        const coordFavoriteTeleport = event.target.closest('[data-coord-favorite-teleport]');
        if (coordFavoriteTeleport) {
            const favorite = state.coordFavorites[Number(coordFavoriteTeleport.dataset.coordFavoriteTeleport)];
            if (favorite?.coords) action('player.teleportCoords', favorite.coords);
            return;
        }

        const coordFavoriteRemove = event.target.closest('[data-coord-favorite-remove]');
        if (coordFavoriteRemove) {
            const index = Number(coordFavoriteRemove.dataset.coordFavoriteRemove);
            if (Number.isFinite(index)) {
                state.coordFavorites.splice(index, 1);
                saveCoordFavorites();
                render({ preserveScroll: true });
            }
            return;
        }

        const run = event.target.closest('[data-run]');
        if (run) {
            if (run.dataset.target) {
                state.selectedId = Number(run.dataset.target);
            }
            runAction(run.dataset.run, run);
            return;
        }

        const noteEdit = event.target.closest('[data-note-edit]');
        if (noteEdit) {
            runAction('player.noteEdit', noteEdit);
            return;
        }

        const noteDelete = event.target.closest('[data-note-delete]');
        if (noteDelete) {
            runAction('player.noteDelete', noteDelete);
            return;
        }

        const warningEdit = event.target.closest('[data-warning-edit]');
        if (warningEdit) {
            runAction('player.warnEdit', warningEdit);
            return;
        }

        const warningDelete = event.target.closest('[data-warning-delete]');
        if (warningDelete) {
            runAction('player.warnDelete', warningDelete);
            return;
        }

        const actionTab = event.target.closest('[data-action-tab]');
        if (actionTab) {
            state.tab = actionTab.dataset.actionTab;
            render();
            return;
        }

        const jump = event.target.closest('[data-view-jump]');
        if (jump) {
            state.view = jump.dataset.viewJump;
            render();
            return;
        }

        const unban = event.target.closest('[data-unban]');
        if (unban) {
            action('ban.remove', { banId: unban.dataset.unban });
            return;
        }

        const eventButton = event.target.closest('[data-event-select]');
        if (eventButton) {
            setEventSelection(eventButton.dataset.eventSelect);
            render({ preserveScroll: true });
            setTimeout(() => setEventSelection(eventButton.dataset.eventSelect), 0);
            return;
        }

        if (event.target.closest('[data-event-fill-payload]')) {
            setEventSelection(selectedEventName());
            return;
        }

        const timePreset = event.target.closest('[data-time-preset]');
        if (timePreset) {
            const [hour, minute] = String(timePreset.dataset.timePreset || '12:0').split(':');
            const hourInput = document.getElementById('hourInput');
            const minuteInput = document.getElementById('minuteInput');
            if (hourInput) hourInput.value = hour;
            if (minuteInput) minuteInput.value = minute;
            return;
        }

        if (event.target.closest('[data-clear-notifications]')) {
            state.notifications = [];
            renderNotificationCenter();
            return;
        }

        const preset = event.target.closest('[data-preset-item]');
        if (preset) {
            const input = document.getElementById('itemInput');
            state.itemName = preset.dataset.presetItem || '';
            if (input) {
                input.value = state.itemName;
                focusElement(input);
            }
            return;
        }

        const weaponPreset = event.target.closest('[data-preset-weapon]');
        if (weaponPreset) {
            const input = document.getElementById('weaponInput');
            state.weaponName = weaponPreset.dataset.presetWeapon || '';
            if (input) {
                input.value = state.weaponName;
                focusElement(input);
            }
            return;
        }

        const vehiclePreset = event.target.closest('[data-preset-vehicle]');
        if (vehiclePreset) {
            const input = document.getElementById('vehicleInput');
            if (input) {
                input.value = vehiclePreset.dataset.presetVehicle;
                focusElement(input);
            }
            return;
        }

        const sidebarAction = event.target.closest('[data-action]');
        if (sidebarAction?.dataset.action === 'close') nui('close');
        if (sidebarAction?.dataset.action === 'duty') action('duty.toggle');
    });

    document.body.addEventListener('error', (event) => {
        if (event.target?.classList?.contains('map-image')) {
            useNextMapAsset(event.target);
        }
    }, true);

    els.refreshBtn.addEventListener('click', () => nui('refresh'));
    els.dutyToggle.addEventListener('click', () => action('duty.toggle'));
    els.notificationBtn.addEventListener('click', () => {
        state.notificationOpen = !state.notificationOpen;
        renderNotificationCenter();
    });
    els.announceBtn.addEventListener('click', async () => {
        const message = await promptDialog({
            title: 'Announcement',
            placeholder: 'Server announcement',
            defaultValue: 'Server announcement',
            confirmText: 'Announce'
        });
        const trimmed = message?.trim();
        if (trimmed) action('announce', { message: trimmed });
    });

    els.globalSearch.addEventListener('input', (event) => {
        state.globalSearch = event.target.value;
        renderPlayerList();
    });

    els.playerSearch.addEventListener('input', (event) => {
        state.playerSearch = event.target.value;
        renderPlayerList();
    });

    els.opacityRange.addEventListener('input', (event) => {
        els.shell.style.opacity = String(Number(event.target.value) / 100);
    });

    window.addEventListener('keydown', (event) => {
        if (event.key === 'Escape') {
            event.preventDefault();
            if (closeSelectPicker()) return;
            if (state.notificationOpen) {
                state.notificationOpen = false;
                renderNotificationCenter();
                return;
            }
            if (!closeActiveDialog(null)) nui('close');
        }

        if (activeDialog) return;

        if ((event.ctrlKey || event.metaKey) && event.key.toLowerCase() === 'k') {
            event.preventDefault();
            els.globalSearch.focus();
        }
    });
}

window.addEventListener('message', (event) => {
    const { action: messageAction, payload } = event.data || {};

    if (messageAction === 'open') {
        state.open = true;
        state.snapshot = payload;
        if (payload?.initialView) {
            state.view = payload.initialView;
        }
        syncSelectedPlayer();
        document.body.classList.add('open');
        render();
    }

    if (messageAction === 'snapshot') {
        state.snapshot = payload;
        render({ preserveScroll: true });
        renderSpectateOverlay();
    }

    if (messageAction === 'close') {
        state.open = false;
        closeActiveDialog(null);
        document.body.classList.remove('open');
        stopRemoteFeedPolling();
        stopSnapshotPolling();
    }

    if (messageAction === 'toast' || messageAction === 'actionResult') {
        toast(payload?.message || 'Action complete.', payload?.type || (payload?.ok ? 'success' : 'inform'));
    }

    if (messageAction === 'announcement') {
        showAnnouncement(payload);
    }

    if (messageAction === 'staffMessage') {
        showAnnouncement({
            ...payload,
            label: 'Staff Message',
            tone: 'staff-message'
        });
    }

    if (messageAction === 'spectateState') {
        state.spectate = {
            active: payload?.active === true,
            target: payload?.target || null,
            name: payload?.name || '',
            health: payload?.health,
            armor: payload?.armor,
            bucket: payload?.bucket,
            job: payload?.job
        };
        renderSpectateOverlay();

        if (state.spectate.active) {
            toast(payload?.message || 'Spectate started. Press Escape to stop.', 'inform', 'Remote Feed');
        }
    }

    if (messageAction === 'modeState') {
        state.mode = {
            noclip: payload?.noclip === true,
            godmode: payload?.godmode === true,
            invisible: payload?.invisible === true,
            noclipSpeed: payload?.noclipSpeed || 2,
            noclipSpeedValue: payload?.noclipSpeedValue || null,
            control: payload?.control === true,
            controlTarget: payload?.controlTarget || null,
            controlledBy: payload?.controlledBy || null
        };
        renderSpectateOverlay();
    }

    if (messageAction === 'coordTool') {
        state.coordTool = {
            laser: payload?.laser === true,
            player: payload?.player || null,
            camera: payload?.camera || null,
            target: payload?.target || null
        };

        if (state.open && state.view === 'coords') {
            render({ preserveScroll: true });
        }

        if (state.coordOverlay) {
            renderCoordOverlay();
        }
    }

    if (messageAction === 'coordOverlay') {
        state.coordOverlay = payload?.active === true;
        renderCoordOverlay();
    }

    if (messageAction === 'clipboard') {
        copyText(payload?.text || '', payload?.message || 'Copied.');
    }

    if (messageAction === 'remoteFeedFrame') {
        const target = Number(payload?.target);
        if (!Number.isFinite(target)) return;

        state.remoteFeeds[target] = {
            image: payload?.image || state.remoteFeeds[target]?.image || null,
            error: payload?.error || null,
            loading: false,
            updatedAt: payload?.image ? Date.now() : state.remoteFeeds[target]?.updatedAt || null
        };

        updateRemoteFeedCard(target);
    }
});

function demoCallback(callback, payload) {
    if (callback === 'close') {
        closeActiveDialog(null);
        document.body.classList.remove('open');
        return Promise.resolve({ ok: true });
    }

    if (callback === 'action') {
        if (payload.action === 'server.weather' && state.snapshot?.server) {
            state.snapshot.server.weather = payload.weather;
            render({ preserveScroll: true });
        }

        if (payload.action === 'server.blackout' && state.snapshot?.server) {
            state.snapshot.server.blackout = payload.state === true;
            render({ preserveScroll: true });
        }

        toast(`${payload.action} queued`, 'success');
        return Promise.resolve({ ok: true });
    }

    return Promise.resolve({ ok: true });
}

function demoSnapshot() {
    const demoPlayers = [
        ['Luca Reyes', 'police', 12, -873.11, -1328.81],
        ['Maya Chen', 'ambulance', 18, -54.8, -191.4],
        ['Elias Brooks', 'mechanic', 22, 736.1, -812.3],
        ['Zoe Bennett', 'unemployed', 27, 1854.4, 3683.2],
        ['Noah Silva', 'realestate', 31, -1212.2, -331.2],
        ['Samira Patel', 'police', 44, 424.8, -980.1],
        ['Isaac Morgan', 'ambulance', 58, -247.4, 6330.3],
        ['Kira Walsh', 'mechanic', 73, 1702.2, 6422.7]
    ];

    return {
        config: {
            title: 'Snipz Admin',
            logo: '',
            command: 'adminmenu',
            items: [
                { name: 'water', label: 'Water' },
                { name: 'sandwich', label: 'Sandwich' },
                { name: 'phone', label: 'Phone' },
                { name: 'radio', label: 'Radio' },
                { name: 'repairkit', label: 'Repair Kit' }
            ],
            vehicles: [
                { model: 'adder', label: 'Adder' },
                { model: 'sultanrs', label: 'Sultan RS' },
                { model: 'police3', label: 'Police Cruiser' }
            ],
            peds: [
                { model: 'mp_m_freemode_01', label: 'Male Freemode' },
                { model: 'mp_f_freemode_01', label: 'Female Freemode' }
            ],
            weapons: [
                { name: 'WEAPON_PISTOL', label: 'Pistol' },
                { name: 'WEAPON_CARBINERIFLE', label: 'Carbine Rifle' }
            ],
            jobs: [
                { name: 'unemployed', label: 'Unemployed' },
                { name: 'police', label: 'Police' },
                { name: 'ambulance', label: 'EMS' },
                { name: 'mechanic', label: 'Mechanic' }
            ],
            gangs: [
                { name: 'none', label: 'None' },
                { name: 'ballas', label: 'Ballas' },
                { name: 'families', label: 'Families' }
            ],
            licenses: [
                { name: 'driver', label: 'Driver' },
                { name: 'weapon', label: 'Weapon' }
            ],
            teleportPresets: [
                { name: 'staff_room', label: 'Staff Room' },
                { name: 'pillbox', label: 'Pillbox' }
            ],
            gymStats: {
                Min: 0,
                Max: 100,
                Stats: [
                    { name: 'strength', label: 'Strength' },
                    { name: 'stamina', label: 'Stamina' },
                    { name: 'shooting', label: 'Shooting' },
                    { name: 'driving', label: 'Driving' },
                    { name: 'lung_capacity', label: 'Lung Capacity' }
                ]
            },
            console: {
                enabled: true,
                allowedCommands: ['say', 'status', 'refresh', 'ensure', 'restart', 'start', 'stop'],
                suggestions: [
                    { command: 'say', label: 'Say', template: 'say ' },
                    { command: 'status', label: 'Status', template: 'status' },
                    { command: 'refresh', label: 'Refresh', template: 'refresh' },
                    { command: 'restart', label: 'Restart Resource', template: 'restart ' }
                ]
            },
            weather: ['EXTRASUNNY', 'CLEAR', 'RAIN', 'THUNDER', 'FOGGY'],
            events: [
                {
                    name: 'demo:server:event',
                    label: 'Demo Server Event',
                    description: 'Example server-side allowlist entry',
                    type: 'server',
                    payload: { reason: 'Admin event' }
                },
                {
                    name: 'demo:client:event',
                    label: 'Demo Client Event',
                    description: 'Example targeted client event',
                    type: 'client',
                    payload: { enabled: true }
                }
            ]
        },
        self: {
            id: 1,
            name: 'Leona Hart',
            duty: true,
            permissions: {
                all: true,
                menu: true,
                players: true,
                vehicles: true,
                items: true,
                server: true,
                console: true
            }
        },
        server: {
            players: 8,
            maxPlayers: 128,
            uptime: '9d 6h 23m',
            weather: 'THUNDER',
            time: { hour: 0, minute: 0 },
            blackout: false,
            resource: 'snipz_adminmenu',
            version: '1.0.0'
        },
        players: demoPlayers.map(([name, job, id, x, y], index) => ({
            id,
            name,
            displayName: name,
            citizenid: `EMS-${7700 + id}`,
            license: `license:demo${id}`,
            discord: `discord:${120000000000000000 + id}`,
            ping: 38 + index * 5,
            bucket: index % 2,
            coords: { x, y, z: 31.0, h: 90.0 },
            health: Math.max(35, 100 - index * 8),
            armor: index % 3 === 0 ? 45 : 0,
            job: { name: job, label: job === 'ambulance' ? 'EMS' : job, gradeLabel: index % 5, grade: index % 5 },
            gang: { name: 'none', label: 'None', gradeLabel: '0', grade: 0 },
            money: { bank: 40120 + index * 800, cash: 920 + index * 25, crypto: 800, black_money: 0 },
            charinfo: { birthdate: '1999-09-08', phone: '555-0130' },
            metadata: {
                hunger: 72,
                thirst: 64,
                stress: 14,
                isdead: false,
                gym: [
                    { name: 'strength', label: 'Strength', value: 20 + index * 3 },
                    { name: 'stamina', label: 'Stamina', value: 35 + index * 2 }
                ]
            },
            warnings: index === 1 ? [{ time: Math.floor(Date.now() / 1000), reason: 'Example warning' }] : [],
            notes: index === 1 ? [{
                id: 'demo-note-1',
                time: Math.floor(Date.now() / 1000),
                actor: 'Leona Hart',
                actorId: 1,
                note: 'Prefers Discord contact for support follow-up.'
            }] : [],
            duty: index === 0 || index === 5
        })),
        ownedVehicles: [
            {
                id: 101,
                plate: 'ADMIN01',
                model: 'sultanrs',
                ownerName: 'Maya Chen',
                citizenid: 'EMS-7718',
                coords: { x: -214.4, y: -1320.1, z: 31.2, h: 90 },
                stale: false
            },
            {
                id: 102,
                plate: 'ADMIN1',
                model: 'adder',
                ownerName: 'Luca Reyes',
                citizenid: 'EMS-7712',
                coords: { x: 810.2, y: -102.4, z: 80.1, h: 30 },
                stale: true
            }
        ],
        bans: [],
        warnings: {},
        notes: {},
        actionLogs: [
            { time: Math.floor(Date.now() / 1000), action: 'Console Command', actor: 'Leona Hart', target: 'Server', detail: 'status' },
            { time: Math.floor(Date.now() / 1000) - 42, action: 'Revive', actor: 'Leona Hart', target: 'Maya Chen', detail: '' }
        ],
        serverConsoleLogs: [
            { time: Math.floor(Date.now() / 1000), level: 'success', source: 'console', message: 'Command dispatched: status' },
            { time: Math.floor(Date.now() / 1000) - 6, level: 'command', source: 'console', message: 'Leona Hart executed: status' },
            { time: Math.floor(Date.now() / 1000) - 42, level: 'audit', source: 'snipz_adminmenu', message: 'Leona Hart -> Revive (Maya Chen)' }
        ],
        adminChatLogs: [
            { time: Math.floor(Date.now() / 1000), actor: 'Leona Hart', message: 'Shift handoff: Discord admin chat is connected.' }
        ],
        chatLogs: [
            { time: Math.floor(Date.now() / 1000), source: 22, name: 'Elias Brooks', message: 'Can I get help?' }
        ]
    };
}

function init() {
    els.app = document.getElementById('app');
    els.brandMark = document.getElementById('brandMark');
    els.brandName = document.getElementById('brandName');
    els.nav = document.getElementById('nav');
    els.content = document.getElementById('content');
    els.playerList = document.getElementById('playerList');
    els.playerCount = document.getElementById('playerCount');
    els.uptime = document.getElementById('uptime');
    els.adminName = document.getElementById('adminName');
    els.adminAvatar = document.getElementById('adminAvatar');
    els.globalSearch = document.getElementById('globalSearch');
    els.playerSearch = document.getElementById('playerSearch');
    els.refreshBtn = document.getElementById('refreshBtn');
    els.announceBtn = document.getElementById('announceBtn');
    els.notificationBtn = document.getElementById('notificationBtn');
    els.notificationCount = document.getElementById('notificationCount');
    els.notificationCenter = document.getElementById('notificationCenter');
    els.dutyToggle = document.getElementById('dutyToggle');
    els.opacityRange = document.getElementById('opacityRange');
    els.shell = document.getElementById('shell');
    els.toasts = document.getElementById('toasts');
    els.announcementHost = document.getElementById('announcementHost');
    els.coordOverlay = document.getElementById('coordOverlay');
    els.spectateOverlay = document.getElementById('spectateOverlay');

    hydrateStaticIcons();
    state.coordFavorites = loadCoordFavorites();
    renderNotificationCenter();
    bindEvents();
    nui('ready');

    if (!resourceName()) {
        state.open = true;
        state.snapshot = demoSnapshot();
        state.selectedId = state.snapshot.players[1].id;
        document.body.classList.add('open');
        render();
    }
}

document.addEventListener('DOMContentLoaded', init);

# Snipz Admin Menu

FiveM Qbox admin menu with ACE permissions, a dark NUI interface, player tools, vehicle tools, item/account tools, moderation, staff duty, blips, weather/time, console allowlisting, bans, warnings, and optional integrations.

## Install

1. Place this folder in your server resources as `snipz_adminmenu`.
2. Add `ensure snipz_adminmenu` after `qbx_core` and after your permission sync resources in `server.cfg`. If FxPanel moderation logging is enabled, also ensure `monitor` before this resource.
3. Use the permission bridge defaults or add the optional ACE permissions from `server.cfg.example`.
4. Use `/adminmenu` or `F10` in game.
5. Use `/admincar` while driving a vehicle to save it to your character, matching the ps-adminmenu admin car workflow.

## Permissions

The menu checks permissions server-side through `Config.PermissionBridge`:

- Existing `snipz_adminmenu.*` ACE permissions still work.
- txAdmin admins are accepted through the server-side `txAdmin:events:adminAuth` event. By default, authenticated txAdmin admins get full menu access.
- fxPanel, Badger, and DiscordAcePerms-style setups can be mapped through `Config.PermissionBridge.ExternalAce`, but that bridge is disabled by default so broad `command.*` ACEs do not accidentally unlock the menu.

Prefer a resource-specific full-access ACE:

```cfg
add_ace group.admin snipz_adminmenu allow
```

Keep broad command access separate unless another tool needs it:

```cfg
# add_ace group.admin command allow
```

Scoped ACE access is still available if you want limited staff roles:

```text
snipz_adminmenu
snipz_adminmenu.all
snipz_adminmenu.menu
snipz_adminmenu.players
snipz_adminmenu.spectate
snipz_adminmenu.teleport
snipz_adminmenu.revive
snipz_adminmenu.heal
snipz_adminmenu.punish
snipz_adminmenu.kick
snipz_adminmenu.ban
snipz_adminmenu.warn
snipz_adminmenu.freeze
snipz_adminmenu.kill
snipz_adminmenu.vehicles
snipz_adminmenu.items
snipz_adminmenu.inventory
snipz_adminmenu.clothing
snipz_adminmenu.ped
snipz_adminmenu.accounts
snipz_adminmenu.jobs
snipz_adminmenu.bucket
snipz_adminmenu.server
snipz_adminmenu.console
snipz_adminmenu.console.all
snipz_adminmenu.staff
snipz_adminmenu.manageAdmins
snipz_adminmenu.blips
snipz_adminmenu.destructive
```

To keep txAdmin admins limited instead of full access, set `Config.PermissionBridge.TxAdmin.GrantAll = false` and edit `Config.PermissionBridge.TxAdmin.GrantedPermissions`.

To hook an existing Badger/fxPanel ACE object into the menu, enable `Config.PermissionBridge.ExternalAce` and add it to `FullAccess` or `PermissionMap`.

Leave generic `command.*` entries out of `ExternalAce` unless you intentionally want that broad bridge.

## Branding

- `Config.MenuTitle`: shown in the NUI header (as its first letter when no logo is set) and used as the Discord webhook username.
- `Config.MenuLogo`: optional image URL for the NUI header. Leave blank to show the title initial.

## Integrations

Every integration below is resource-gated: if the resource you point it at is
not running, the menu falls back to its built-in behaviour instead of erroring.
The shipped defaults target a standard Qbox stack. Edit `config.lua` for your
server; each option lists common alternatives in a comment.

- `InventoryResource`: defaults to `ox_inventory` (also `qb-inventory`, `qs-inventory`, `codem-inventory`).
- `FxPanelModeration`: **disabled by default.** Enable to route warn/kick/ban/announce through `exports['monitor']` so they land in FxPanel/txAdmin history. The acting admin must be authenticated in FxPanel with the matching `players.warn`, `players.kick`, `players.ban`, or `announcement` permission.
- `ClothingEvent`: defaults to `illenium-appearance`, then walks `ClothingFallbackEvents` (`qb-clothing`, `fivem-appearance`, `citgo_appearance`).
- `FuelResource`: defaults to `LegacyFuel` (also `ox_fuel`, `ps-fuel`, `cdn-fuel`, `lc_fuel`). The native fuel level is always set regardless.
- `VehicleKeysResource` / `VehicleKeysEvent`: default to `qb-vehiclekeys` (also `Renewed-Vehiclekeys`, `wasabi_carlock`, `MrNewbVehicleKeys`).
- `MechanicResource`: blank by default. Set the three `MechanicCustomisation*` values to expose the customisation shortcut (example for `jg-mechanic` in `config.lua`).
- `HealthResetEvent` / `ReviveEvent`: blank by default. Set an event here if you run a medical/injury system that needs its own reset after revive/heal (e.g. Solstice `visn_are:resetHealthBuffer`).
- `JailResource` / `JailExport` / `JailEvent`: default to `qb-prison` via `police:server:JailPlayer` (also `xt-prison` with export `SetJailTime`, `rcore_prison`).
- `Weather.Resource`: defaults to `Renewed-Weathersync` through its `qb-weathersync` compatibility exports.
- `Console.AllowedCommands`: only these console commands can be executed unless the admin has `snipz_adminmenu.console.all`.
- `Security.StrictAllowLists`: enabled by default, so items, weapons, vehicles, peds, jobs, gangs, licenses, weather, and money accounts must exist in `config.lua` before the menu will apply them.
- `ChatSuggestions`: controls slash-command autocomplete in the FiveM chat box. This server uses the stock `chat` resource with `qbx_chat_theme`, so suggestions are replayed when either starts. Use `/adminsuggestions` in game to refresh suggestions after a chat/resource restart.
- `AdminCar.Command` / `AdminCar.Garage`: controls the ps-style current vehicle save command. Leave `Garage = nil` to save it as out, like ps-adminmenu.
- `PermissionBridge`: maps txAdmin auth and external ACE objects into the menu permissions.
- `AllowedEvents`: add explicit server/client events for the Events tab. The configured payload is used by default; set `allowClientPayload = true` on an individual event if staff may edit that payload from the NUI.

## Stored Data

The resource writes local JSON files in its own folder, created automatically on
first use:

- `bans.json`
- `warnings.json`
- `notes.json`
- `staff_tags.json`

These hold live player identifiers and moderation history, so they are listed in
`.gitignore` and must not be committed. When `FxPanelModeration.Enabled = true`,
new bans are handled by FxPanel instead of `bans.json`; local warnings are still
mirrored so the menu can show them in player profiles.

To configure Discord avatars and role-based staff tags, fill in
`Config.Discord.BotToken`, `Config.Discord.GuildId`, and `Config.Discord.RoleTags`
in `config.lua`. All three are blank by default and Discord lookups stay disabled
until they are set.

## Notes

All real admin actions go through `server/main.lua` and are checked with ACE before any client event fires. Client-side NUI buttons alone do not grant permissions.

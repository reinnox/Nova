--!strict
-- ServerScriptService/Server/Core/DataService.lua
-- __doc: DataService handles save/load, migrations, save/retry queues, and autosave placeholders.
-- Ownership: Core
-- Consumers: PlayerLoader, SessionManager, AuditService

export type Profile = { [string]: unknown }

local DataService = {}
DataService.__doc = [[
Service: DataService
API:
  Init(deps: { datastoreClient: any?, auditService: any?, config: any? }) -> nil
  Start() -> nil
  LoadProfile(userId: number) -> Profile?
  SaveProfile(profile: Profile) -> boolean
  RegisterMigration(fromVersion: number, fn: (Profile) -> Profile) -> nil
Notes:
  - ProfileVersion = 1 expected for initial schema (see SAVE_FORMAT.md)
  - Save/Retry queues are placeholders for batching and resilient writes.
TODO:
  - Implement DataStore retry/backoff, consistent snapshots, and schema migrations.
]]

local datastoreClient: any = nil
local auditService: any = nil
local config: any = nil

local migrations: { [number]: (Profile) -> Profile } = {}

-- Simple in-memory queues (placeholders)
local saveQueue: { Profile } = {}
local retryQueue: { Profile } = {}

function DataService.Init(deps: { datastoreClient: any?, auditService: any?, config: any? })
    datastoreClient = deps.datastoreClient
    auditService = deps.auditService
    config = deps.config
end

function DataService.Start()
    -- TODO: start worker loops for save/retry queues and autosave
end

function DataService.RegisterMigration(fromVersion: number, fn: (Profile) -> Profile)
    migrations[fromVersion] = fn
end

local function runMigrations(profile: Profile)
    local version = profile.ProfileVersion or 1
    local currentVersion = 1
    -- If currentVersion grows, migrations[version] should be applied sequentially
    for v = version, currentVersion - 1 do
        local m = migrations[v]
        if m then
            profile = m(profile)
            profile.ProfileVersion = v + 1
        end
    end
    return profile
end

function DataService.LoadProfile(_userId: number)
    -- TODO: load raw profile from datastoreClient, run runMigrations, return profile
    return nil
end

function DataService.SaveProfile(profile: Profile)
    -- TODO: enqueue profile for saving, take snapshot via auditService, implement retry logic
    table.insert(saveQueue, profile)
    return true
end

return DataService

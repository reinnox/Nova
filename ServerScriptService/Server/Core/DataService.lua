--!strict
-- ServerScriptService/Server/Core/DataService.lua
-- __doc: DataService handles save/load, migrations, and a simple in-memory storage backend for development.
-- Ownership: Core
-- Consumers: PlayerLoader, SessionManager, InventoryRepository

export type Profile = { [string]: any }

local DataService = {}
DataService.__doc = [[
Service: DataService (in-memory reference implementation)
API:
  Init(deps: { logger?: any, autosaveIntervalSec?: number }) -> nil
  Start() -> nil
  LoadProfile(userId: number) -> Profile?
  SaveProfile(profile: Profile) -> boolean
  RegisterMigration(fromVersion: number, fn: (Profile) -> Profile) -> nil
Notes:
  - This implementation is synchronous and stores data in memory. Replace datastoreClient with platform DataStore in production.
]]

local logger: any = nil
local autosaveIntervalSec = 60

local storage: { [number]: Profile } = {}
local migrations: { [number]: (Profile) -> Profile } = {}

function DataService.Init(deps: { logger?: any, autosaveIntervalSec?: number })
    logger = deps and deps.logger or nil
    if deps and type(deps.autosaveIntervalSec) == "number" then
        autosaveIntervalSec = deps.autosaveIntervalSec
    end
end

function DataService.Start()
    -- No background workers in this in-memory implementation.
end

function DataService.RegisterMigration(fromVersion: number, fn: (Profile) -> Profile)
    migrations[fromVersion] = fn
end

local function runMigrations(profile: Profile)
    local version = profile.ProfileVersion or 1
    local currentVersion = 1 -- bump this when new migrations are added
    for v = version, currentVersion - 1 do
        local m = migrations[v]
        if m then
            profile = m(profile)
            profile.ProfileVersion = v + 1
        end
    end
    return profile
end

function DataService.LoadProfile(userId: number)
    if type(userId) ~= "number" then
        return nil
    end
    local profile = storage[userId]
    if not profile then
        return nil
    end
    -- shallow copy to prevent callers mutating stored reference directly
    local copy = {}
    for k, v in pairs(profile) do
        copy[k] = v
    end
    copy = runMigrations(copy)
    return copy
end

function DataService.SaveProfile(profile: Profile)
    if type(profile) ~= "table" or type(profile.UserId) ~= "number" then
        if logger then logger:Error("DataService.SaveProfile: invalid profile") end
        return false
    end
    -- shallow copy to storage
    local stored: Profile = {}
    for k, v in pairs(profile) do
        stored[k] = v
    end
    storage[profile.UserId] = stored
    return true
end

-- For debugging/inspection
function DataService.__get_storage()
    return storage
end

return DataService

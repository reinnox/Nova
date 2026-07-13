--!strict
-- ServerScriptService/Server/Core/PlayerLoader.lua
-- __doc: PlayerLoader loads or creates player profiles and manages session locks.
-- Ownership: Core
-- Consumers: SessionManager, DataService, EventBus, InventoryService

local DEFAULT_PROFILE = {
    ProfileVersion = 1,
    UserId = 0,
    CharacterName = "",
    ClassId = "",
    Level = 1,
    Experience = 0,
    BaseStats = {},
    AllocatedStatusPoints = {},
    Inventory = {},
    Equipment = {},
    CreatedAt = 0,
}

local PlayerLoader = {}
PlayerLoader.__doc = [[
Service: PlayerLoader
API:
  Init(deps: { dataService: any, sessionManager: any, eventBus: any, logger: any }) -> nil
  Start() -> nil
  OnPlayerJoin(player: { UserId: number, Name: string }) -> table -- returns profile
  OnPlayerLeave(player: { UserId: number }) -> nil
Notes:
  - This implementation uses DataService in-memory storage. Persisting to real DataStore requires replacing DataService.
]]

local dataService: any = nil
local sessionManager: any = nil
local eventBus: any = nil
local logger: any = nil

function PlayerLoader.Init(deps: { dataService: any, sessionManager: any, eventBus: any, logger: any })
    dataService = deps.dataService
    sessionManager = deps.sessionManager
    eventBus = deps.eventBus
    logger = deps.logger
end

function PlayerLoader.Start() end

function PlayerLoader._make_default_profile(userId: number, name: string)
    local p = {}
    for k, v in pairs(DEFAULT_PROFILE) do p[k] = v end
    p.UserId = userId
    p.CharacterName = name or ("Player_" .. tostring(userId))
    p.CreatedAt = os.time()
    return p
end

function PlayerLoader.OnPlayerJoin(player: { UserId: number, Name: string })
    local userId = player.UserId
    -- Acquire session lock
    local locked = sessionManager and sessionManager.LockSession(userId) or true
    if not locked then
        if logger then logger:Warn("PlayerLoader: could not acquire lock for user " .. tostring(userId)) end
        return nil
    end
    -- Load or create profile
    local profile = dataService and dataService.LoadProfile(userId) or nil
    if not profile then
        profile = PlayerLoader._make_default_profile(userId, player.Name or "")
        dataService.SaveProfile(profile)
    end
    if eventBus then
        eventBus.Publish("Player.ProfileLoaded", { userId = userId, profile = profile })
    end
    return profile
end

function PlayerLoader.OnPlayerLeave(player: { UserId: number })
    local userId = player.UserId
    -- Save profile if needed via DataService (assuming profile is mutated elsewhere and persisted)
    -- For in-memory DataService profiles are already in storage; if using caches, persist here.
    if eventBus then
        eventBus.Publish("Player.Disconnected", { userId = userId })
    end
    -- Release session lock
    if sessionManager then
        sessionManager.UnlockSession(userId)
    end
end

return PlayerLoader

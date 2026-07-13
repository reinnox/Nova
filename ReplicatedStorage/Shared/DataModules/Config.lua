--!strict
-- ReplicatedStorage/Shared/DataModules/Config.lua
-- __doc: Configuration and keys for core services
-- Ownership: Core
-- Consumers: DataService, PlayerLoader, RemoteMiddleware, other services

local Config = {}

Config.DataStore = {
    PlayerProfileKeyPrefix = "player_profile_v1:",
    SaveBatchSize = 25,
    RetryBaseDelaySec = 5,
    MaxRetryAttempts = 5,
}

Config.Server = {
    AutosaveIntervalSec = 60,
    SessionTimeoutSec = 600,
}

Config.Defaults = {
    StartingLevel = 1,
    MaxInventorySlots = 100,
}

return table.freeze(Config)

--!strict
-- ServerScriptService/Server/Core/PlayerLoader.lua
-- __doc: PlayerLoader handles player join/leave, profile creation/load and session lock integration.
-- Ownership: Core
-- Consumers: SessionManager, DataService, EventBus

local PlayerLoader = {}
PlayerLoader.__doc = [[
Service: PlayerLoader
API:
  Init(deps: { dataService: any, sessionManager: any, eventBus: any }) -> nil
  Start() -> nil
  OnPlayerJoin(player: Player) -> nil
  OnPlayerLeave(player: Player) -> nil
TODO:
  - Implement server-side validation, default profile creation, and shallow caches.
]]

local dataService: any = nil
local sessionManager: any = nil
local eventBus: any = nil

function PlayerLoader.Init(deps: { dataService: any, sessionManager: any, eventBus: any })
    dataService = deps.dataService
    sessionManager = deps.sessionManager
    eventBus = deps.eventBus
end

function PlayerLoader.Start() end

function PlayerLoader.OnPlayerJoin(_player: Player)
    -- TODO: acquire session lock, load or create profile via dataService, publish Player.Loaded
end

function PlayerLoader.OnPlayerLeave(_player: Player)
    -- TODO: trigger save and release locks
end

return PlayerLoader

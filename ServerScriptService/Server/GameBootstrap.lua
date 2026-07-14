--!strict
-- ServerScriptService/Server/GameBootstrap.lua
-- Top-level bootstrap to initialize core and gameplay

local EventBus = require(script.Core.EventBus)
local DataService = require(script.Core.DataService)
local SessionManager = require(script.Core.SessionManager)
local PlayerLoader = require(script.Core.PlayerLoader)
local CombatBootstrap = require(script.Gameplay.CombatBootstrap)

local function InitAll()
    EventBus.Init({})
    DataService.Init({})
    SessionManager.Init({})
    PlayerLoader.Init({ dataService = DataService, sessionManager = SessionManager, eventBus = EventBus })
    CombatBootstrap.Init()
end

local function StartAll()
    EventBus.Start()
    DataService.Start()
    SessionManager.Start()
    CombatBootstrap.Start()
end

return { InitAll = InitAll, StartAll = StartAll }

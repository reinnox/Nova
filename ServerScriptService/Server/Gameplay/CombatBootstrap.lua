--!strict
-- ServerScriptService/Server/Gameplay/CombatBootstrap.lua
-- Wires up Gameplay services with core services via dependency injection.

local EventBus = require(script.Parent.Parent.Core.EventBus)
local DataService = require(script.Parent.Parent.Core.DataService)
local StatusEffectService = require(script.Parent:WaitForChild("StatusEffectService"))
local CombatService = require(script.Parent:WaitForChild("CombatService"))
local SkillService = require(script.Parent:WaitForChild("SkillService"))

local CombatBootstrap = {}

function CombatBootstrap.Init()
    EventBus.Init({})
    DataService.Init({})
    StatusEffectService.Init({})
    CombatService.Init({ eventBus = EventBus, dataService = DataService, auditService = nil, statusEffectService = StatusEffectService })
    SkillService.Init({ eventBus = EventBus, combatService = CombatService, dataService = DataService, statusEffectService = StatusEffectService, rateLimiter = nil, auditService = nil })
end

function CombatBootstrap.Start()
    EventBus.Start()
    DataService.Start()
    StatusEffectService.Start()
    CombatService.Start()
    SkillService.Start()
end

return CombatBootstrap

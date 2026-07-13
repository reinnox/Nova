--!strict
-- tests/gameplay/combatservice_spec.lua
local CombatService = require(script.Parent.Parent.Server.Gameplay.CombatService)
local DataService = require(script.Parent.Parent.Server.Core.DataService)
local EventBus = require(script.Parent.Parent.Server.Core.EventBus)

local function run()
    DataService.Init({})
    DataService.Start()
    CombatService.Init({ eventBus = EventBus, dataService = DataService, auditService = nil, statusEffectService = nil })
    CombatService.Start()
    -- Prepare profiles
    DataService.SaveProfile({ ProfileVersion = 1, UserId = 1001, CharacterName = "A", BaseStats = { Str = 10 }, Health = 200, MaxHealth = 200 })
    DataService.SaveProfile({ ProfileVersion = 1, UserId = 1002, CharacterName = "B", BaseStats = { Def = 5 }, Health = 150, MaxHealth = 150 })
    local attacker = DataService.LoadProfile(1001)
    local defender = DataService.LoadProfile(1002)
    local dmg, isCrit, reason = CombatService.CalculateDamage(attacker, defender, 30)
    local applied = CombatService.ApplyDamage(1002, dmg, { from = 1001 })
    local updated = DataService.LoadProfile(1002)
    if not applied then return false, "apply failed" end
    if updated.Health >= 150 then return false, "health not decreased" end
    return true
end

return { run = run }

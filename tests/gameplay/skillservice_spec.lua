--!strict
-- tests/gameplay/skillservice_spec.lua
local SkillService = require(script.Parent.Parent.Server.Gameplay.SkillService)
local DataService = require(script.Parent.Parent.Server.Core.DataService)
local CombatService = require(script.Parent.Parent.Server.Gameplay.CombatService)
local EventBus = require(script.Parent.Parent.Server.Core.EventBus)

local function run()
    DataService.Init({})
    DataService.Start()
    CombatService.Init({ eventBus = EventBus, dataService = DataService, auditService = nil, statusEffectService = nil })
    CombatService.Start()
    SkillService.Init({ eventBus = EventBus, combatService = CombatService, dataService = DataService, statusEffectService = nil, rateLimiter = nil, auditService = nil })
    SkillService.Start()
    -- Setup balancing data for skill
    local BalancingData = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("DataModules"):WaitForChild("BalancingData"))
    BalancingData.SkillEffects = BalancingData.SkillEffects or {}
    BalancingData.SkillEffects.Fireball = { EffectType = "Damage", Value = 40 }
    BalancingData.Fireball = BalancingData.Fireball or 0
    BalancingData.Fireball = BalancingData.Fireball
    -- Prepare profiles
    DataService.SaveProfile({ ProfileVersion = 1, UserId = 2001, CharacterName = "Caster", BaseStats = { Int = 10 }, Mana = 100, Health = 200, MaxHealth = 200 })
    DataService.SaveProfile({ ProfileVersion = 1, UserId = 2002, CharacterName = "Target", BaseStats = { Def = 5 }, Mana = 50, Health = 200, MaxHealth = 200 })
    local ok, err = SkillService.UseSkill(2001, "skill_fireball_v1", 2002)
    if not ok then return false, tostring(err)
    end
    local t = DataService.LoadProfile(2002)
    if t.Health >= 200 then return false, "target not damaged" end
    return true
end

return { run = run }

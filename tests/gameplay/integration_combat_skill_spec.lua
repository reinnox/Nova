--!strict
-- tests/gameplay/integration_combat_skill_spec.lua
-- Integration test: player uses skill and damage is applied, death event fires.

local CombatBootstrap = require(script.Parent.Parent.Server.Gameplay.CombatBootstrap)
local DataService = require(script.Parent.Parent.Server.Core.DataService)
local EventBus = require(script.Parent.Parent.Server.Core.EventBus)

local function run()
    CombatBootstrap.Init()
    CombatBootstrap.Start()
    -- Prepare balancing data for test skill
    local BalancingData = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("DataModules"):WaitForChild("BalancingData"))
    BalancingData.SkillEffects = BalancingData.SkillEffects or {}
    BalancingData.SkillEffects.Fireball = { EffectType = "Damage", Value = 200 }
    BalancingData.Fireball = BalancingData.Fireball or 0

    -- Save two profiles
    DataService.SaveProfile({ ProfileVersion = 1, UserId = 9001, CharacterName = "Attacker", BaseStats = { Int = 50 }, Mana = 500, Health = 500, MaxHealth = 500 })
    DataService.SaveProfile({ ProfileVersion = 1, UserId = 9002, CharacterName = "Victim", BaseStats = { Def = 0 }, Mana = 100, Health = 100, MaxHealth = 100 })

    local died = false
    EventBus.Subscribe("Combat.PlayerDied", function(payload)
        if payload and payload.userId == 9002 then died = true end
    end)

    local SkillService = require(script.Parent.Parent.Server.Gameplay.SkillService)
    local ok, err = SkillService.UseSkill(9001, "skill_fireball_v1", 9002)
    if not ok then return false, "skill use failed: " .. tostring(err) end
    -- allow save worker to process
    task.wait(0.2)
    if not died then return false, "victim did not die" end
    return true
end

return { run = run }

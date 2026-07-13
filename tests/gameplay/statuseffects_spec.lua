--!strict
-- tests/gameplay/statuseffects_spec.lua
local StatusEffectService = require(script.Parent.Parent.Server.Gameplay.StatusEffectService)

local function run()
    StatusEffectService.Init({})
    StatusEffectService.Start()
    StatusEffectService.AddEffect(3001, { EffectId = "burn", SourceId = 3000, DurationSec = 3, TickIntervalSec = 1, Stacks = 1, MaxStacks = 1, Data = { magnitude = 5 }})
    local effects = StatusEffectService.GetEffects(3001)
    if not effects or #effects == 0 then return false, "effect not added" end
    StatusEffectService.Stop()
    return true
end

return { run = run }

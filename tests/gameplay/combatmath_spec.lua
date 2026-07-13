--!strict
-- tests/gameplay/combatmath_spec.lua
local CombatMath = require(script.Parent.Parent.Server.Gameplay.CombatMath)

local function run()
    math.randomseed(1)
    local ctx = { attackerStats = { Str = 10 }, defenderStats = { Def = 5 }, basePower = 50 }
    local dmg, isCrit, reason = CombatMath.CalculateDamage(ctx)
    if type(dmg) ~= "number" then return false, "damage not number" end
    if reason ~= "hit" and reason ~= "miss" then return false, "invalid reason" end
    return true
end

return { run = run }

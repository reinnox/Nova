--!strict
-- ServerScriptService/Server/Gameplay/CombatMath.lua
-- __doc: Stateless combat math utilities used by CombatService.
-- Ownership: Gameplay
-- Consumers: CombatService, SkillService

local BalancingData = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("DataModules"):WaitForChild("BalancingData"))
local CombatConfig = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("DataModules"):WaitForChild("CombatConfig"))

local CombatMath = {}

export type Stats = { [string]: number }
export type AttackContext = {
    attackerStats: Stats,
    defenderStats: Stats,
    basePower: number,
}

local function getBal(key: string, default: number)
    if BalancingData and BalancingData[key] and type(BalancingData[key]) == "number" then
        return BalancingData[key]
    end
    return default
end

function CombatMath.CalcDefenseMitigation(defenderStats: Stats)
    local def = defenderStats.Def or 0
    local perDef = (BalancingData and BalancingData.StatScaling and BalancingData.StatScaling.DefensePerDef) or 1
    local mitigation = (def * perDef) / (100 + def * perDef)
    return math.clamp(mitigation, 0, 0.95)
end

function CombatMath.CalcRawDamage(ctx: AttackContext)
    local atk = ctx.attackerStats.Str or ctx.attackerStats.Int or 0
    local dmgPerStr = (BalancingData and BalancingData.StatScaling and BalancingData.StatScaling.DmgPerStr) or 2
    local dmgPerInt = (BalancingData and BalancingData.StatScaling and BalancingData.StatScaling.DmgPerInt) or 3
    local factor = 1
    if ctx.attackerStats.Str then
        factor = 1 + (ctx.attackerStats.Str * dmgPerStr) / 100
    elseif ctx.attackerStats.Int then
        factor = 1 + (ctx.attackerStats.Int * dmgPerInt) / 100
    end
    local raw = math.max(0, math.floor(ctx.basePower * factor))
    return raw
end

function CombatMath.RollCritical(attackerStats: Stats)
    local critBase = getBal(CombatConfig.CritChanceRef, 0.05)
    local critChanceFromStat = (attackerStats.Crit or 0) / 100
    local critChance = math.clamp(critBase + critChanceFromStat, 0, 0.95)
    return math.random() < critChance, getBal(CombatConfig.CritMultiplierRef, 1.5)
end

function CombatMath.RollHit(attackerStats: Stats, defenderStats: Stats)
    local baseHit = getBal(CombatConfig.BaseHitChanceRef, 0.95)
    local attackerAcc = (attackerStats.Accuracy or 0) / 100
    local defenderDodge = (defenderStats.Dodge or 0) / 100
    local hitChance = math.clamp(baseHit + attackerAcc - defenderDodge, 0.05, 0.99)
    return math.random() < hitChance
end

function CombatMath.CalculateDamage(ctx: AttackContext)
    if not CombatMath.RollHit(ctx.attackerStats, ctx.defenderStats) then
        return 0, false, "miss"
    end
    local raw = CombatMath.CalcRawDamage(ctx)
    local mitigation = CombatMath.CalcDefenseMitigation(ctx.defenderStats)
    local dmg = math.max(0, math.floor(raw * (1 - mitigation)))
    local isCrit, critMult = CombatMath.RollCritical(ctx.attackerStats)
    if isCrit then
        dmg = math.floor(dmg * critMult)
    end
    return dmg, isCrit, "hit"
end

return CombatMath

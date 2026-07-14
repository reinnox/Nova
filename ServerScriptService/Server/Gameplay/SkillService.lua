--!strict
-- ServerScriptService/Server/Gameplay/SkillService.lua
-- __doc: Server-side skill execution, cooldowns, mana consumption, range & validation.
-- Ownership: Gameplay
-- Consumers: PlayerLoader, CombatService, StatusEffectService, EventBus, RemoteValidationMiddleware

local Skills = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("DataModules"):WaitForChild("Skills"))
local BalancingData = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("DataModules"):WaitForChild("BalancingData"))
local CombatConfig = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("DataModules"):WaitForChild("CombatConfig"))

local SkillService = {}

local eventBus: any = nil
local combatService: any = nil
local dataService: any = nil
local statusEffectService: any = nil
local rateLimiter: any = nil
local auditService: any = nil

-- cooldowns[userId][skillId] = timestamp when available
local cooldowns: { [number]: { [string]: number } } = {}

local function now() return os.time() end

function SkillService.Init(deps: { eventBus: any, combatService: any, dataService: any, statusEffectService: any, rateLimiter: any, auditService: any })
    eventBus = deps.eventBus
    combatService = deps.combatService
    dataService = deps.dataService
    statusEffectService = deps.statusEffectService
    rateLimiter = deps.rateLimiter
    audit_service = deps.auditService
end

function SkillService.Start() end

local function getSkillDef(skillId: string)
    return Skills[skillId]
end

local function getCooldownForSkill(skill: any)
    if not skill or not skill.CooldownSecRef then return 0 end
    local key = skill.CooldownSecRef
    if BalancingData and BalancingData[key] and type(BalancingData[key]) == "number" then
        return BalancingData[key]
    end
    return 0
end

local function getManaCost(skill: any)
    if not skill or not skill.ManaCostRef then return 0 end
    local key = skill.ManaCostRef
    if BalancingData and BalancingData[key] and type(BalancingData[key]) == "number" then
        return BalancingData[key]
    end
    return 0
end

function SkillService.UseSkill(userId: number, skillId: string, targetId: number)
    local skill = getSkillDef(skillId)
    if not skill then return false, "unknown_skill" end
    -- rate limit
    if rateLimiter then
        local allowed = rateLimiter.Allow(userId, "skill_use", { MaxRequests = 20, WindowSec = 1 })
        if not allowed then return false, "rate_limited" end
    end
    -- cooldown
    cooldowns[userId] = cooldowns[userId] or {}
    local cd = cooldowns[userId][skillId]
    if cd and cd > now() then return false, "on_cooldown" end
    -- load profile
    local profile = dataService and dataService.LoadProfile(userId)
    if not profile then return false, "no_profile" end
    local manaCost = getManaCost(skill)
    if (profile.Mana or 0) < manaCost then return false, "insufficient_mana" end
    -- range and target checks omitted for now (requires positions). Assume valid targetId
    -- Apply mana cost
    profile.Mana = profile.Mana - manaCost
    dataService.SaveProfile(profile)
    -- compute effect
    if skill.EffectRef and BalancingData and BalancingData.SkillEffects and BalancingData.SkillEffects[skill.EffectRef] then
        local eff = BalancingData.SkillEffects[skill.EffectRef]
        if eff.EffectType == "Damage" then
            local attacker = { UserId = userId, Level = profile.Level or 1, BaseStats = profile.BaseStats or {} }
            local defenderProfile = dataService and dataService.LoadProfile(targetId)
            local dmg, isCrit, reason = combatService.CalculateDamage(attacker, defenderProfile or {}, eff.Value)
            combatService.ApplyDamage(targetId, dmg, { sourceSkill = skillId, caster = userId })
        elseif eff.EffectType == "Buff" or eff.EffectType == "Debuff" then
            if statusEffectService then
                statusEffectService.AddEffect(targetId, {
                    EffectId = skill.EffectRef,
                    SourceId = userId,
                    DurationSec = eff.DurationSec or 5,
                    TickIntervalSec = eff.TickIntervalSec,
                    Stacks = 1,
                    MaxStacks = eff.MaxStacks or 1,
                    Data = { magnitude = eff.Value },
                })
            end
        end
    end
    -- set cooldown
    local cooldownSec = getCooldownForSkill(skill)
    cooldowns[userId][skillId] = now() + cooldownSec
    if audit_service then audit_service.Log("skill.used", userId, { skill = skillId, target = targetId }) end
    if eventBus then eventBus.Publish("Skill.Used", { userId = userId, skillId = skillId, target = targetId }) end
    return true, nil
end

function SkillService.IsOnCooldown(userId: number, skillId: string)
    cooldowns[userId] = cooldowns[userId] or {}
    local cd = cooldowns[userId][skillId]
    if not cd then return false end
    return cd > now()
end

return SkillService

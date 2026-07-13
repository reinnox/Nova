--!strict
-- ServerScriptService/Server/Gameplay/CombatService.lua
-- __doc: Server-authoritative CombatService integrating CombatMath and StatusEffectService.
-- Ownership: Gameplay
-- Consumers: SkillService, PlayerLoader, AuditService, EventBus

local CombatMath = require(script.Parent:WaitForChild("CombatMath"))

local CombatService = {}

local eventBus: any = nil
local dataService: any = nil
local auditService: any = nil
local statusEffectService: any = nil

function CombatService.Init(deps: { eventBus: any, dataService: any, auditService: any, statusEffectService: any })
    eventBus = deps.eventBus
    dataService = deps.dataService
    audit_service = deps.auditService
    statusEffectService = deps.statusEffectService
end

function CombatService.Start() end

local function loadProfile(userId: number)
    if not dataService then return nil end
    return dataService.LoadProfile(userId)
end

function CombatService.CalculateDamage(attackerProfile: { UserId: number, Level: number, BaseStats: { [string]: number } }, defenderProfile: { UserId: number, Level: number, BaseStats: { [string]: number } }, basePower: number)
    local attackerStats = attackerProfile and attackerProfile.BaseStats or {}
    local defenderStats = defenderProfile and defenderProfile.BaseStats or {}
    local dmg, isCrit, reason = CombatMath.CalculateDamage({ attackerStats = attackerStats, defenderStats = defenderStats, basePower = basePower })
    return dmg, isCrit, reason
end

function CombatService.ApplyDamage(targetUserId: number, amount: number, source: { [string]: unknown })
    if not dataService then return false end
    local profile = dataService.LoadProfile(targetUserId)
    if not profile then return false end
    profile.Health = (profile.Health or profile.MaxHealth or 100) - amount
    if profile.Health <= 0 then
        profile.Health = 0
        -- Death handling hook
        if eventBus then eventBus.Publish("Combat.PlayerDied", { userId = targetUserId, source = source }) end
        if audit_service then audit_service.Log("combat.death", targetUserId, { source = source }) end
    else
        if eventBus then eventBus.Publish("Combat.DamageApplied", { userId = targetUserId, amount = amount, source = source }) end
        if audit_service then audit_service.Log("combat.damage", targetUserId, { amount = amount, source = source }) end
    end
    dataService.SaveProfile(profile)
    return true
end

return CombatService

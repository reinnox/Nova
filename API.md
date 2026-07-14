### CombatService
Path: Server/Gameplay/CombatService.lua
Public API:
  Init(deps: { eventBus, dataService, auditService, statusEffectService }) -> nil
  Start() -> nil
  CalculateDamage(attackerProfile, defenderProfile, basePower) -> (damage: number, isCrit: boolean, reason: string)
  ApplyDamage(targetUserId: number, amount: number, source: table) -> boolean
Events:
  Publishes: Combat.DamageApplied, Combat.PlayerDied
Notes:
  - Server-authoritative damage application. Uses CombatMath for calculations and DataService for persistence.

### SkillService
Path: Server/Gameplay/SkillService.lua
Public API:
  Init(deps: { eventBus, combatService, dataService, statusEffectService, rateLimiter, auditService }) -> nil
  Start() -> nil
  UseSkill(userId: number, skillId: string, targetId: number) -> (boolean, error?)
  IsOnCooldown(userId: number, skillId: string) -> boolean
Events:
  Publishes: Skill.Used
Notes:
  - Manages cooldowns and mana consumption. Skill definitions live in ReplicatedStorage/Shared/DataModules/Skills.lua and reference BalancingData.

### StatusEffectService
Path: Server/Gameplay/StatusEffectService.lua
Public API:
  Init(deps: {}) -> nil
  Start() -> nil
  Stop() -> nil
  AddEffect(userId: number, effect: Effect) -> nil
  RemoveEffect(userId: number, effectId: string) -> nil
  GetEffects(userId: number) -> { Effect }?
Notes:
  - Manages buff/debuff stacks, durations, and tick-based effects. Publishes StatusEffect.Tick events via EventBus where appropriate.

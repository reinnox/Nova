# Public API Guide (API.md)

This file enumerates the public API surface expected from each service. Each service must document the following:
- Module name and path
- Init() and Start() behavior
- Public methods (signatures, types, brief descriptions)
- Events published and subscribed (see EVENTS.md)
- Configuration DataModules required
- TODOs and extension points

Example service API header (required in each service file):

--[[
Service: CombatService
Path: Server/Gameplay/CombatService.lua
Public API:
  Init(eventBus: EventBus, config: table) -> nil
  Start() -> nil
  CalculateDamage(attackerProfile: PlayerProfile, defenderProfile: PlayerProfile, skillId: string) -> (number damage, boolean isCrit)
  ApplyDamage(targetUserId: number, amount: number, source: table) -> nil
Events:
  Subscribes: "PlayerDamaged" (payload: { targetId, amount, source })
  Publishes: "CombatLog" (payload: { attackerId, defenderId, damage, isCrit })
Config:
  ReplicatedStorage/Shared/DataModules/BalancingData.lua
Documentation:
  Put full parameter and return type annotations in Luau at top of file.
TODOs:
  - Add server-side simulation loop for multi-target AoE interactions
  - Integrate with AuditService for rollback snapshotting
]]--


Please ensure this form is present in every service file. API.md will aggregate the per-service headers into a single index for maintainers.

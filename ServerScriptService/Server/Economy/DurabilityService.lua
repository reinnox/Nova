--!strict
-- ServerScriptService/Server/Economy/DurabilityService.lua
-- __doc: Durability management skeleton.
-- Ownership: Economy/Items
-- Consumers: CombatService, EnhancementService, InventoryService

local DurabilityService = {}
DurabilityService.__doc = [[
Service: DurabilityService
API:
  Init(deps: { eventBus: any, durabilityProfiles: any, auditService: any }) -> nil
  Start() -> nil
  ApplyDurabilityLoss(userId: number, instanceId: string, amount: number) -> nil
  RepairItem(userId: number, instanceId: string, cost: number) -> boolean
TODO:
  - Wire with DurabilityProfiles DataModule and inventory mutation via InventoryService.
]]

local eventBus: any
local durabilityProfiles: any
local auditService: any

function DurabilityService.Init(deps: { eventBus: any, durabilityProfiles: any, auditService: any })
    eventBus = deps.eventBus
    durabilityProfiles = deps.durabilityProfiles
    auditService = deps.auditService
end

function DurabilityService.Start() end

function DurabilityService.ApplyDurabilityLoss(_userId: number, _instanceId: string, _amount: number)
    -- TODO: decrement durability and call auditService.Log
end

function DurabilityService.RepairItem(_userId: number, _instanceId: string, _cost: number)
    -- TODO: charge player and restore durability
    return false
end

return DurabilityService

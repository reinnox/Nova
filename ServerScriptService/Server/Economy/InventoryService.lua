--!strict
-- ServerScriptService/Server/Economy/InventoryService.lua
-- __doc: InventoryService (infrastructure-only). Manages reads/writes through InventoryRepository and emits events on changes.
-- Ownership: Economy
-- Consumers: PlayerLoader, TradeService, UI, DataService

local InventoryRepository = require(script.Parent.InventoryRepository)
local InventoryConfig = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("DataModules"):WaitForChild("InventoryConfig"))

export type ItemInstance = {
    ItemId: string,
    InstanceId: string,
    StackCount: number,
    Rarity: string?,
    EnhancementLevel: number?,
    CurrentDurability: number?,
    MaxDurability: number?,
    Extensions: { [string]: unknown }?,
}

local InventoryService = {}
InventoryService.__doc = [[
API:
  Init(deps: { eventBus: any, repository: any, auditService: any, dataService: any }) -> nil
  Start() -> nil
  GetInventory(userId: number) -> (Inventory? inventory)
  AddItem(userId: number, itemId: string, count: number) -> (boolean ok, string? instanceId)
  RemoveItem(userId: number, instanceId: string, count: number) -> boolean
Notes:
  - All modifications must call auditService.Log and publish EventBus events. Validation is done by remote middleware or calling services.
]]

local eventBus: any = nil
local repository: any = nil
local auditService: any = nil
local dataService: any = nil

local function makeInstanceId(userId: number, itemId: string)
    return tostring(userId) .. "_" .. tostring(os.time()) .. "_" .. itemId
end

function InventoryService.Init(deps: { eventBus: any, repository: any, auditService: any, dataService: any })
    eventBus = deps.eventBus
    repository = deps.repository
    auditService = deps.auditService
    data_service = deps.data_service or deps.dataService or deps.dataService
    dataService = deps.dataService or deps.data_service
    if repository and dataService then
        repository.Init({ dataService = dataService })
    end
end

function InventoryService.Start() end

function InventoryService.GetInventory(userId: number)
    local record = repository.Load(userId)
    if record then return record.Inventory end
    return nil
end

function InventoryService.AddItem(userId: number, itemId: string, count: number)
    if type(userId) ~= "number" or type(itemId) ~= "string" or type(count) ~= "number" then return false, nil end
    if count <= 0 then return false, nil end
    local record = repository.Load(userId)
    if not record then
        record = { UserId = userId, Inventory = {}, Equipment = {}, UpdatedAt = os.time() }
    end
    -- stacking: try to merge into existing stacks
    local remaining = count
    for _, inst in ipairs(record.Inventory) do
        if inst.ItemId == itemId and inst.StackCount and inst.StackCount < InventoryConfig.DefaultStackLimit then
            local available = InventoryConfig.DefaultStackLimit - inst.StackCount
            local toAdd = math.min(available, remaining)
            inst.StackCount = inst.StackCount + toAdd
            remaining = remaining - toAdd
            if remaining <= 0 then break end
        end
    end
    while remaining > 0 do
        local take = math.min(InventoryConfig.DefaultStackLimit, remaining)
        local instance = {
            ItemId = itemId,
            InstanceId = makeInstanceId(userId, itemId),
            StackCount = take,
        }
        table.insert(record.Inventory, instance)
        remaining = remaining - take
    end
    record.UpdatedAt = os.time()
    local ok = repository.Save(record)
    if ok and auditService then
        auditService.Log("inventory.add", userId, { itemId = itemId, count = count })
    end
    if ok and eventBus then
        eventBus.Publish("Inventory.Updated", { userId = userId })
    end
    return ok, nil
end

function InventoryService.RemoveItem(userId: number, instanceId: string, count: number)
    if type(userId) ~= "number" or type(instanceId) ~= "string" or type(count) ~= "number" then return false end
    local record = repository.Load(userId)
    if not record then return false end
    for i = #record.Inventory, 1, -1 do
        local inst = record.Inventory[i]
        if inst.InstanceId == instanceId then
            if count >= inst.StackCount then
                table.remove(record.Inventory, i)
            else
                inst.StackCount = inst.StackCount - count
            end
            record.UpdatedAt = os.time()
            local ok = repository.Save(record)
            if ok and auditService then auditService.Log("inventory.remove", userId, { instanceId = instanceId, count = count }) end
            if ok and eventBus then eventBus.Publish("Inventory.Updated", { userId = userId }) end
            return ok
        end
    end
    return false
end

return InventoryService

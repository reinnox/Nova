--!strict
-- ServerScriptService/Server/Economy/InventoryRepository.lua
-- __doc: Persistence adapter for inventory data. Abstracts DataService storage so DataService can be swapped.
-- Ownership: Economy
-- Consumers: InventoryService
-- Notes: Uses DI for DataService to keep backend pluggable.

export type InventoryRecord = {
    UserId: number,
    Inventory: { [number]: any }, -- use ItemInstance when finalized
    Equipment: { [string]: any }?,
    UpdatedAt: number,
}

local InventoryRepository = {}
InventoryRepository.__doc = [[
API:
  Init(deps: { dataService: any }) -> nil
  Load(userId: number) -> (InventoryRecord? record)
  Save(record: InventoryRecord) -> boolean
Notes:
  - This layer keeps DataService-specific code isolated and makes it easy to swap storage backends.
]]

local dataService: any = nil

function InventoryRepository.Init(deps: { dataService: any })
    dataService = deps.dataService
end

function InventoryRepository.Load(userId: number)
    if not dataService then
        error("InventoryRepository: dataService not initialized")
    end
    local profile = dataService.LoadProfile(userId)
    if not profile then
        return nil
    end
    local record: InventoryRecord = {
        UserId = userId,
        Inventory = profile.Inventory or {},
        Equipment = profile.Equipment or {},
        UpdatedAt = os.time(),
    }
    return record
end

function InventoryRepository.Save(record: InventoryRecord)
    if not dataService then
        error("InventoryRepository: dataService not initialized")
    end
    local profile: { [string]: unknown } = {
        ProfileVersion = 1,
        UserId = record.UserId,
        Inventory = record.Inventory,
        Equipment = record.Equipment,
        UpdatedAt = record.UpdatedAt,
    }
    local ok = dataService.SaveProfile(profile)
    return ok
end

return InventoryRepository

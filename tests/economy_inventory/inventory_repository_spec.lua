--!strict
-- tests/economy_inventory/inventory_repository_spec.lua
local InventoryRepository = require(script.Parent.Parent.Server.Economy.InventoryRepository)
local DataService = require(script.Parent.Parent.Server.Core.DataService)

local function run()
    DataService.Init({})
    DataService.Start()
    InventoryRepository.Init({ dataService = DataService })
    local userId = 4001
    local rec = InventoryRepository.Load(userId)
    if rec ~= nil then return false, "expected nil for non-existing profile" end
    local record = { UserId = userId, Inventory = { }, Equipment = {}, UpdatedAt = os.time() }
    local ok = InventoryRepository.Save(record)
    if not ok then return false, "save failed" end
    local loaded = InventoryRepository.Load(userId)
    if not loaded then return false, "load failed after save" end
    return true
end

return { run = run }

--!strict
-- ReplicatedStorage/Shared/DataModules/InventoryConfig.lua
-- __doc: Inventory tuning references. Keep numeric gameplay values in BalancingData.
-- Ownership: Economy
-- Consumers: InventoryService, InventoryRepository, UI

local BalancingData = require(script.Parent.BalancingData)

local InventoryConfig = {
    -- Designers: add MaxInventorySlots to BalancingData for tuning per-class/role.
    MaxSlotsRef = "MaxInventorySlots",
    DefaultStackLimit = 99,
}

return table.freeze(InventoryConfig)

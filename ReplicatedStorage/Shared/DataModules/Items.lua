--!strict
-- ReplicatedStorage/Shared/DataModules/Items.lua
-- __doc: Item definitions. Numeric values and effects reference BalancingData.
-- Ownership: Items team
-- Consumers: InventoryService, CraftingService, Shop systems

local BalancingData = require(script.Parent.BalancingData)

export type ItemDefinition = {
    Id: string, -- stable ID for migration
    Version: number?,
    ItemId: string,
    Name: string,
    Description: string,
    Rarity: string,
    StackLimit: number,
    EquipSlot: string?,
    IsConsumable: boolean?,
    DefaultDurability: number?,
    DefaultEnhancementLevel: number?,
    Affixes: { [string]: number }?,
    EffectRef: string?, -- reference to BalancingData.ItemEffects[EffectRef]
}

local Items: { [string]: ItemDefinition } = {
    ["item_health_potion_small"] = {
        Id = "item_health_potion_small", -- stable id
        Version = 1,
        ItemId = "item_health_potion_small",
        Name = "Small Health Potion",
        Description = "Restores a small amount of health.",
        Rarity = "Common",
        StackLimit = 20,
        IsConsumable = true,
        DefaultDurability = 0,
        DefaultEnhancementLevel = 0,
        Affixes = nil,
        EffectRef = "HealSmall", -- numeric heal amount is in BalancingData.ItemEffects.HealSmall
    },
}

-- Freeze the table to mark it immutable at runtime.
local frozen = table.freeze(Items)
return frozen

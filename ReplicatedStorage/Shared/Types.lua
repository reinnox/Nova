--!strict
-- ReplicatedStorage/Shared/Types.lua
-- __doc: Shared Luau types for Nova DataModules and services.
-- Ownership: Shared Data team
-- Consumers: All server services and client controllers (read-only)

export type Vector3 = { x: number, y: number, z: number }

export type ItemRarity = "Common" | "Uncommon" | "Rare" | "Epic" | "Mythic" | "Legendary"

-- Specific, explicit custom data unions are preferred where known.
-- For generic extension points, use unknown rather than `any`.
export type ItemInstance = {
    ItemId: string,
    InstanceId: string,
    StackCount: number,
    Rarity: ItemRarity,
    BindOnPickup: boolean,
    IsBound: boolean,
    EnhancementLevel: number,
    CurrentDurability: number,
    MaxDurability: number,
    Affixes: { [string]: number }?,
    CustomData: { [string]: unknown }?, -- TODO: replace with concrete shapes when needed
}

export type PlayerProfileRef = {
    UserId: number,
    CharacterName: string,
}

-- Export an empty table with types. Keep immutable for safety.
local Exports = {}

return table.freeze(Exports)

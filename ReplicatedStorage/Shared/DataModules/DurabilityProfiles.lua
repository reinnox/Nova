--!strict
-- ReplicatedStorage/Shared/DataModules/DurabilityProfiles.lua
-- __doc: Durability profiles for items.
-- Ownership: Items team
-- Consumers: DurabilityService, EnhancementService

export type DurabilityProfile = {
    Id: string,
    Version: number?,
    ItemId: string,
    MaxDurability: number,
    LossOnHitTaken: number,
    LossOnHitDealt: number,
    LossOnDeath: number,
}

local Profiles: { [string]: DurabilityProfile } = {}

-- TODO: Populate durability profiles and reference them from Items definitions.

return table.freeze(Profiles)

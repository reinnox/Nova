--!strict
-- src/Types/PlayerProfile.lua
-- __doc: PlayerProfile Luau type definition. ProfileVersion = 1
-- Ownership: Core/DataService
-- Consumers: DataService, PlayerLoader, InventoryService, CombatService

local Types = {}

export type Vector3 = { x: number, y: number, z: number }
export type ItemInstance = {
    ItemId: string,
    InstanceId: string,
    StackCount: number,
    Rarity: string,
    BindOnPickup: boolean,
    IsBound: boolean,
    EnhancementLevel: number,
    CurrentDurability: number,
    MaxDurability: number,
    Affixes: { [string]: number }?,
    CustomData: { [string]: unknown }?, -- use concrete types where available
}

export type PlayerProfile = {
    ProfileVersion: number, -- must exist; current = 1
    UserId: number,
    CharacterName: string,
    RaceId: string,
    ClassId: string,
    SecondaryClassId: string?,
    KingdomId: string?,
    KingdomRank: string?,
    TitleId: string?,

    Level: number,
    Experience: number,
    AscensionLevel: number,
    PrestigeScore: number,

    BaseStats: { [string]: number },
    TotalEarnedStatusPoints: number,
    AllocatedStatusPoints: { [string]: number },

    Health: number, MaxHealth: number,
    Mana: number, MaxMana: number,
    Stamina: number,

    Inventory: { [number]: ItemInstance },
    Equipment: { [string]: ItemInstance? },

    GuildId: string?,
    PartyId: string?,
    Friends: { number },

    LastKnownPosition: Vector3,
    LastValidMoveTime: number,

    TotalPlayTime: number,
    CreatedAt: number,
}

-- Note: Always set PlayerProfile.ProfileVersion = 1 for initial schema.

return Types

--!strict
-- ReplicatedStorage/Shared/DataModules/NPCs.lua
-- __doc: NPC definitions (data-only). AI behavior implemented in NPCService.
-- Ownership: World team
-- Consumers: NPCService, QuestService, DialogueService

export type NPCScheduleEntry = {
    StartHour: number,
    EndHour: number,
    Location: { x: number, y: number, z: number },
    Behavior: "Shop" | "Wander" | "Sleep" | "Quest" | "GuardPost",
    DialogueTreeId: string?,
}

export type NPCDefinition = {
    Id: string, -- stable id
    Version: number?,
    NPCId: string,
    Name: string,
    FactionId: string?,
    AIType: "Static" | "Patrol" | "Schedule" | "Aggressive" | "Guard" | "Worker",
    Schedule: { NPCScheduleEntry }?,
    ShopInventory: { [string]: { Stock: number, RestockIntervalSec: number } }?,
    CombatDefId: string?,
    ReputationGates: { [string]: number }?,
    Hireable: boolean?,
    HireCost: number?,
}

local NPCs: { [string]: NPCDefinition } = {
    ["npc_villager_001"] = {
        Id = "npc_villager_001",
        Version = 1,
        NPCId = "npc_villager_001",
        Name = "Townsperson",
        FactionId = "faction_citizen",
        AIType = "Schedule",
        Schedule = {
            {
                StartHour = 6,
                EndHour = 12,
                Location = { x = 10, y = 0, z = 5 },
                Behavior = "Shop",
                DialogueTreeId = "dialogue_villager_shop",
            },
        },
        ShopInventory = nil,
        CombatDefId = nil,
        ReputationGates = nil,
        Hireable = false,
        HireCost = 0,
    },
}

return table.freeze(NPCs)

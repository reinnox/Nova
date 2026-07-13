--!strict
-- ReplicatedStorage/Shared/DataModules/Quests.lua
-- __doc: Quest data definitions. Quest execution logic is in QuestService.
-- Ownership: Content team
-- Consumers: QuestService, NPCService

export type QuestObjective = {
    ObjectiveId: string,
    Description: string,
    Quantity: number,
}

export type QuestDefinition = {
    Id: string,
    Version: number?,
    QuestId: string,
    Title: string,
    Description: string,
    LevelRequirement: number,
    Objectives: { QuestObjective },
    Rewards: { [string]: number }, -- references to item IDs or currency keys
}

local Quests: { [string]: QuestDefinition } = {}

-- TODO: Populate quest data and ensure reward numbers reference BalancingData.

return table.freeze(Quests)

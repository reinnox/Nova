--!strict
-- ReplicatedStorage/Shared/DataModules/Achievements.lua
-- __doc: Achievement definitions. Achievement logic lives in AchievementService.
-- Ownership: Content team
-- Consumers: AchievementService, UI

export type AchievementTier = {
    Requirement: number,
    RewardGold: number,
    RewardItemId: string?,
    RewardTitleId: string?,
    AchievementPoints: number,
}

export type AchievementDefinition = {
    Id: string,
    Version: number?,
    AchievementId: string,
    Name: string,
    Category: string,
    Tiers: { AchievementTier },
}

local Achievements: { [string]: AchievementDefinition } = {}

-- TODO: Add achievements exported by designers.

return table.freeze(Achievements)

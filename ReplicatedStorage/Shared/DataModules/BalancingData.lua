--!strict
-- ReplicatedStorage/Shared/DataModules/BalancingData.lua
-- __doc: Centralized gameplay tunables. All numeric gameplay values belong here.
-- Ownership: Balance team
-- Consumers: CombatService, SkillService, EnhancementService, Items, Quests

export type ItemEffect = {
    EffectId: string,
    EffectType: "Heal" | "Damage" | "Buff" | "Resource" | "Custom",
    Value: number, -- use BalancingData to tune numeric values
    DurationSec: number?,
}

local BalancingData = {}

-- XP per level (cumulative required XP). Replace with full curve from designers.
BalancingData.LevelXp = table.freeze({
    [1] = 0,
    [2] = 100,
    [3] = 300,
})

-- Stat scaling parameters used by RecalculateDerivedStats (implementations read these values)
BalancingData.StatScaling = table.freeze({
    HpPerVit = 10,
    ManaPerInt = 5,
    DmgPerStr = 2,
    DmgPerInt = 3,
    AtkSpdPerDex = 0.01,
    MoveSpdPerSpd = 0.02,
    DefensePerDef = 1,
})

-- Item effects referenced by Items.lua (keep numbers here, not in item definitions)
BalancingData.ItemEffects = table.freeze({
    HealSmall = {
        EffectId = "HealSmall",
        EffectType = "Heal",
        Value = 100, -- heal amount (tuning)
    },
})

-- Enhancement tuning is kept separately but referenced here for convenience.
BalancingData.EnhancementCap = 20

return table.freeze(BalancingData)

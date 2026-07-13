--!strict
-- ReplicatedStorage/Shared/DataModules/EnhancementTable.lua
-- __doc: Enhancement success/failure table. All tuning here.
-- Ownership: Balance team
-- Consumers: EnhancementService

export type EnhancementTier = {
    Level: number,
    SuccessRate: number,
    OnFailure: string,
    Bonus: number,
}

local EnhancementTable: { [number]: EnhancementTier } = {
    [1] = { Level = 1, SuccessRate = 1.0, OnFailure = "Nothing", Bonus = 0.02 },
    [2] = { Level = 2, SuccessRate = 1.0, OnFailure = "Nothing", Bonus = 0.04 },
    [3] = { Level = 3, SuccessRate = 1.0, OnFailure = "Nothing", Bonus = 0.06 },
    [4] = { Level = 4, SuccessRate = 1.0, OnFailure = "Nothing", Bonus = 0.08 },
    [5] = { Level = 5, SuccessRate = 1.0, OnFailure = "Nothing", Bonus = 0.10 },
    [6] = { Level = 6, SuccessRate = 0.80, OnFailure = "Nothing", Bonus = 0.13 },
    [7] = { Level = 7, SuccessRate = 0.70, OnFailure = "Nothing", Bonus = 0.16 },
    [8] = { Level = 8, SuccessRate = 0.60, OnFailure = "Nothing", Bonus = 0.20 },
    [9] = { Level = 9, SuccessRate = 0.50, OnFailure = "Downgrade", Bonus = 0.24 },
    [10] = { Level = 10, SuccessRate = 0.40, OnFailure = "Downgrade", Bonus = 0.30 },
    [11] = { Level = 11, SuccessRate = 0.35, OnFailure = "Downgrade", Bonus = 0.36 },
    [12] = { Level = 12, SuccessRate = 0.30, OnFailure = "Break", Bonus = 0.42 },
    [13] = { Level = 13, SuccessRate = 0.25, OnFailure = "Break", Bonus = 0.50 },
    [14] = { Level = 14, SuccessRate = 0.20, OnFailure = "Break", Bonus = 0.60 },
    [15] = { Level = 15, SuccessRate = 0.15, OnFailure = "Break", Bonus = 0.70 },
    [16] = { Level = 16, SuccessRate = 0.10, OnFailure = "Break", Bonus = 0.85 },
    [17] = { Level = 17, SuccessRate = 0.08, OnFailure = "Break", Bonus = 1.00 },
    [18] = { Level = 18, SuccessRate = 0.05, OnFailure = "Break", Bonus = 1.20 },
    [19] = { Level = 19, SuccessRate = 0.03, OnFailure = "Break", Bonus = 1.40 },
    [20] = { Level = 20, SuccessRate = 0.01, OnFailure = "Break", Bonus = 1.70 },
}

return table.freeze(EnhancementTable)

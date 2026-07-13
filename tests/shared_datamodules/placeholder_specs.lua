--!strict
-- tests/shared_datamodules/placeholder_specs.lua
-- Placeholder unit-test descriptions for Shared DataModules.
-- TODO: Integrate a Luau test runner and implement these checks.

local specs = {
    {
        name = "Items: definitions have Id and ItemId and EffectRef points to BalancingData",
    },
    {
        name = "EnhancementTable: contains Level 1..20 and SuccessRate in [0,1]",
    },
    {
        name = "BalancingData: LevelXp contains contiguous early values",
    },
}

return specs

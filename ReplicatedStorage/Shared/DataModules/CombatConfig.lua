--!strict
-- ReplicatedStorage/Shared/DataModules/CombatConfig.lua
-- __doc: References to balancing keys used by Combat & Skills.
-- Ownership: Gameplay
-- Consumers: CombatService, SkillService, CombatMath

local CombatConfig = {
    CritChanceRef = "DefaultCritChance",
    CritMultiplierRef = "DefaultCritMultiplier",
    BaseHitChanceRef = "BaseHitChance",
    BaseDodgeRef = "BaseDodge",
}

return table.freeze(CombatConfig)

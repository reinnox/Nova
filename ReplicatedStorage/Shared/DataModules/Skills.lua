--!strict
-- ReplicatedStorage/Shared/DataModules/Skills.lua
-- __doc: Skill definitions (static). Skill runtime behavior implemented in SkillService.
-- Ownership: Gameplay team
-- Consumers: SkillService, UI

export type SkillDefinition = {
    Id: string,
    Version: number?,
    SkillId: string,
    Name: string,
    ClassRequirement: string?,
    LevelRequirement: number,
    ManaCostRef: string?, -- reference to BalancingData entries
    CooldownSecRef: string?,
    CastTimeSec: number,
    SkillType: "Active" | "Passive" | "Toggle",
    TargetType: "Self" | "Single" | "AoE" | "Line" | "Cone",
}

local Skills: { [string]: SkillDefinition } = {}

-- TODO: Populate skills from designer exports.

return table.freeze(Skills)

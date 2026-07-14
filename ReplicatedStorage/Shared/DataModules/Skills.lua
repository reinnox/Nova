--!strict
-- ReplicatedStorage/Shared/DataModules/Skills.lua
-- __doc: Skill definitions. All numeric tunables reference BalancingData keys.
-- Ownership: Gameplay
-- Consumers: SkillService, CombatService, UI

export type SkillDefinition = {
    Id: string,
    Version: number?,
    SkillId: string,
    Name: string,
    Description: string,
    ClassRequirement: string?,
    LevelRequirement: number,
    ManaCostRef: string?,
    CooldownSecRef: string?,
    CastTimeSec: number,
    SkillType: "Active" | "Passive" | "Toggle",
    TargetType: "Self" | "Single" | "AoE",
    EffectRef: string?, -- BalancingData.SkillEffects[EffectRef]
    RangeMetersRef: string?,
}

local Skills: { [string]: SkillDefinition } = {
    ["skill_fireball_v1"] = {
        Id = "skill_fireball_v1",
        Version = 1,
        SkillId = "skill_fireball_v1",
        Name = "Fireball",
        Description = "Hurls a fireball that damages a single target.",
        ClassRequirement = "mage",
        LevelRequirement = 1,
        ManaCostRef = "Fireball.Mana",
        CooldownSecRef = "Fireball.Cooldown",
        CastTimeSec = 0.8,
        SkillType = "Active",
        TargetType = "Single",
        EffectRef = "Fireball.Damage",
        RangeMetersRef = "Fireball.Range",
    },
    ["skill_slash_v1"] = {
        Id = "skill_slash_v1",
        Version = 1,
        SkillId = "skill_slash_v1",
        Name = "Slash",
        Description = "A quick physical attack.",
        ClassRequirement = "fighter",
        LevelRequirement = 1,
        ManaCostRef = nil,
        CooldownSecRef = "Slash.Cooldown",
        CastTimeSec = 0.4,
        SkillType = "Active",
        TargetType = "Single",
        EffectRef = "Slash.Damage",
        RangeMetersRef = "Slash.Range",
    },
}

return table.freeze(Skills)

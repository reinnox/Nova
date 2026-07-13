--!strict
-- ReplicatedStorage/Shared/DataModules/Classes.lua
-- __doc: Class definitions and base curves.
-- Ownership: Gameplay team
-- Consumers: PlayerLoader, RecalculateDerivedStats, UI

export type ClassDefinition = {
    Id: string,
    Version: number?,
    ClassId: string,
    Name: string,
    BaseHealth: number,
    BaseMana: number,
    HpPerVit: number,
    ManaPerInt: number,
    DmgPerStr: number,
    DmgPerInt: number,
    AtkSpdPerDex: number,
    MoveSpdPerSpd: number,
    DefensePerDef: number,
}

local Classes: { [string]: ClassDefinition } = {}

-- TODO: Add class definitions exported from designers. All numeric values should be references to BalancingData when possible.

return table.freeze(Classes)

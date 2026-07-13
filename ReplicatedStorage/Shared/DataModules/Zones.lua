--!strict
-- ReplicatedStorage/Shared/DataModules/Zones.lua
-- __doc: Zone definitions and metadata.
-- Ownership: World team
-- Consumers: ZoneService, NPCService, SpawnSystems

export type ZoneDefinition = {
    Id: string,
    Version: number?,
    ZoneId: string,
    Name: string,
    ZoneType: string,
    LevelRange: { Min: number, Max: number },
}

local Zones: { [string]: ZoneDefinition } = {}

-- TODO: Add zone definitions and spawn metadata.

return table.freeze(Zones)

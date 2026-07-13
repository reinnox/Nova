--!strict
-- ReplicatedStorage/Shared/DataModules/SeasonalEvents.lua
-- __doc: Seasonal event definitions and tunables.
-- Ownership: Events team
-- Consumers: EventService, ShopSystems

export type SeasonalEventDefinition = {
    Id: string,
    Version: number?,
    EventId: string,
    Name: string,
    Season: string,
    StartTimestamp: number,
    EndTimestamp: number,
}

local Events: { [string]: SeasonalEventDefinition } = {}

-- TODO: Populate seasonal events with schedule data.

return table.freeze(Events)

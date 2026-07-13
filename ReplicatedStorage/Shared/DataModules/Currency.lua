--!strict
-- ReplicatedStorage/Shared/DataModules/Currency.lua
-- __doc: Currency definitions. Numeric values (e.g., starting caps) should live in BalancingData.
-- Ownership: Economy
-- Consumers: MarketService, InventoryService, UI

export type CurrencyDefinition = {
    Id: string,
    Version: number?,
    CurrencyId: string,
    Name: string,
    IsPremium: boolean,
}

local Currencies: { [string]: CurrencyDefinition } = {
    ["gold"] = { Id = "gold", Version = 1, CurrencyId = "gold", Name = "Gold", IsPremium = false },
    ["gems"] = { Id = "gems", Version = 1, CurrencyId = "gems", Name = "Gems", IsPremium = true },
}

return table.freeze(Currencies)

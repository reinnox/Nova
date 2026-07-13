--!strict
-- ReplicatedStorage/Shared/DataModules/MarketConfig.lua
-- __doc: Market configuration references. Keep numeric rates in BalancingData.
-- Ownership: Economy
-- Consumers: MarketService, AuctionService

local BalancingData = require(script.Parent.BalancingData)

local MarketConfig = {
    FeePercentRef = "MarketFeePercent", -- reference key in BalancingData (designers should add this)
    AuctionDurationDefaultSec = 86400, -- placeholder; recommend moving to BalancingData
}

return table.freeze(MarketConfig)

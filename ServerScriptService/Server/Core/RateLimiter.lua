--!strict
-- ServerScriptService/Server/Core/RateLimiter.lua
-- __doc: Per-player rate limiter with pluggable backend.
-- Ownership: Core
-- Consumers: RemoteValidationMiddleware, services exposing remotes

export type RateLimitConfig = {
    MaxRequests: number,
    WindowSec: number,
}

local RateLimiter = {}
RateLimiter.__doc = [[
Service: RateLimiter
API:
  Init(deps: { storage?: any? }) -> nil
  Start() -> nil
  Allow(playerId: number, key: string, config: RateLimitConfig) -> boolean
TODO:
  - Implement sliding window or token bucket. Allow pluggable cross-server backend.
]]

-- In-memory placeholder state; replace with distributed store for cross-server limits
local state: { [string]: { count: number, windowStart: number } } = {}

function RateLimiter.Init(_deps: { storage?: any? })
    -- TODO: wire distributed storage
end

function RateLimiter.Start() end

local function keyFor(playerId: number, key: string)
    return tostring(playerId) .. ":" .. key
end

function RateLimiter.Allow(playerId: number, key: string, config: RateLimitConfig)
    local k = keyFor(playerId, key)
    local now = os.time()
    local entry = state[k]
    if not entry or now - entry.windowStart >= config.WindowSec then
        state[k] = { count = 1, windowStart = now }
        return true
    end
    if entry.count < config.MaxRequests then
        entry.count = entry.count + 1
        return true
    end
    return false
end

return RateLimiter

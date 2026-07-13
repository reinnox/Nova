--!strict
-- ServerScriptService/Server/Core/RemoteValidationMiddleware.lua
-- __doc: Centralized Remote validation and middleware. Extensible for schema, permissions, anti-exploit.
-- Ownership: Core
-- Consumers: Remote wrappers, services exposing remotes

export type ValidationResult = { ok: boolean, errorMessage: string? }

local RemoteValidationMiddleware = {}
RemoteValidationMiddleware.__doc = [[
Service: RemoteValidationMiddleware
API:
  Init(deps: { schemaRegistry: any?, rateLimiter: any? }) -> nil
  Start() -> nil
  Validate(remoteName: string, player: Player, payload: { [string]: unknown }) -> ValidationResult
Notes: Use Luau type checks or an external schemaRegistry. Rate-limiter and audit hooks are pluggable.
TODO:
  - Integrate with Remote wrapper and add extensible validators.
]]

local schemaRegistry: any = nil
local rateLimiter: any = nil

function RemoteValidationMiddleware.Init(deps: { schemaRegistry: any?, rateLimiter: any? })
    schemaRegistry = deps.schemaRegistry
    rateLimiter = deps.rateLimiter
end

function RemoteValidationMiddleware.Start() end

function RemoteValidationMiddleware.Validate(remoteName: string, player: Player, payload: { [string]: unknown })
    -- Placeholder validation: 
    -- 1) rate limit check
    if rateLimiter then
        local allowed = rateLimiter.Allow(player.UserId, remoteName, { MaxRequests = 100, WindowSec = 60 })
        if not allowed then
            return { ok = false, errorMessage = "rate_limited" }
        end
    end
    -- 2) schema validation (if registry present) - TODO: implement
    return { ok = true }
end

return RemoteValidationMiddleware

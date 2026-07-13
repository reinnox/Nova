--!strict
-- tests/core_services/placeholder_specs.lua
-- Placeholder unit-test descriptions for core services.

local specs = {
    { name = "EventBus: subscribe/publish flow and middleware invocation" },
    { name = "RemoteValidationMiddleware: Validate returns ok for allowed payloads" },
    { name = "RateLimiter: Allow enforces simple in-memory limits" },
    { name = "AuditService: Log returns a log id and Snapshot returns a ref" },
    { name = "SessionManager: LockSession/UnlockSession manage simple locks" },
    { name = "DataService: RegisterMigration and Save/Load queue placeholders" },
    { name = "PlayerLoader: Init wires dependencies" },
}

return specs

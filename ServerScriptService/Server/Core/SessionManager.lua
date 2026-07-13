--!strict
-- ServerScriptService/Server/Core/SessionManager.lua
-- __doc: Session lifecycle and locking placeholders; designed for future cross-server locking.
-- Ownership: Core
-- Consumers: PlayerLoader, DataService, other services

export type Session = {
    UserId: number,
    StartedAt: number,
    LastActiveAt: number,
}

local SessionManager = {}
SessionManager.__doc = [[
Service: SessionManager
API:
  Init(deps: { dataService: any, auditService: any, eventBus: any }) -> nil
  Start() -> nil
  LockSession(userId: number) -> boolean
  UnlockSession(userId: number) -> nil
  GetActiveSession(userId: number) -> Session?
Notes: Placeholder local locks; design allows swapping to distributed locks.
TODO:
  - Implement distributed locking (Redis/Etcd) and session heartbeat.
]]

local sessions: { [number]: Session } = {}
local locks: { [number]: boolean } = {}

function SessionManager.Init(_deps: { dataService: any, auditService: any, eventBus: any })
    -- TODO: wire dependencies
end

function SessionManager.Start() end

function SessionManager.LockSession(userId: number)
    if locks[userId] then
        return false
    end
    locks[userId] = true
    sessions[userId] = { UserId = userId, StartedAt = os.time(), LastActiveAt = os.time() }
    return true
end

function SessionManager.UnlockSession(userId: number)
    locks[userId] = false
end

function SessionManager.GetActiveSession(userId: number)
    return sessions[userId]
end

return SessionManager

--!strict
-- ServerScriptService/Server/Core/SessionManager.lua
-- __doc: SessionManager with local locks and session records. Designed for easy swap to distributed locks.
-- Ownership: Core
-- Consumers: PlayerLoader, InventoryService, TradeService

export type Session = {
    UserId: number,
    StartedAt: number,
    LastActiveAt: number,
}

local SessionManager = {}
SessionManager.__doc = [[
Service: SessionManager
API:
  Init(deps: { dataService: any?, logger: any? }) -> nil
  Start() -> nil
  LockSession(userId: number) -> boolean
  UnlockSession(userId: number) -> nil
  GetActiveSession(userId: number) -> Session?
Notes:
  - This is a single-process lock for now. Replace with distributed lock (Redis/Etcd) for cross-server.
]]

local dataService: any = nil
local logger: any = nil

local sessions: { [number]: Session } = {}
local locks: { [number]: number } = {} -- store lock owner timestamp

function SessionManager.Init(deps: { dataService: any?, logger: any? })
    dataService = deps and deps.dataService or nil
    logger = deps and deps.logger or nil
end

function SessionManager.Start() end

-- Attempt to acquire a lock; return true on success
function SessionManager.LockSession(userId: number)
    if type(userId) ~= "number" then return false end
    if locks[userId] then
        return false
    end
    locks[userId] = os.time()
    sessions[userId] = { UserId = userId, StartedAt = os.time(), LastActiveAt = os.time() }
    return true
end

function SessionManager.UnlockSession(userId: number)
    locks[userId] = nil
    sessions[userId] = nil
end

function SessionManager.GetActiveSession(userId: number)
    return sessions[userId]
end

return SessionManager

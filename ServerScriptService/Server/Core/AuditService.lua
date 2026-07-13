--!strict
-- ServerScriptService/Server/Core/AuditService.lua
-- __doc: Audit logging service. Supports immutable logs and snapshot hooks.
-- Ownership: Core
-- Consumers: All mutating services

export type AuditLog = {
    LogId: string,
    UserId: number?,
    ActionType: string,
    Details: { [string]: unknown },
    Timestamp: number,
}

local AuditService = {}
AuditService.__doc = [[
Service: AuditService
API:
  Init(deps: { datastore: any?, logger: any? }) -> nil
  Start() -> nil
  Log(actionType: string, userId: number?, details: { [string]: unknown }) -> string -- returns logId
  Snapshot(profile: { [string]: unknown }) -> string -- returns snapshotRef
Notes: Designed to support rollback, economy logs, and moderation logs.
TODO:
  - Wire to durable storage, retention policies, and indexing.
]]

local datastore: any = nil
local logger: any = nil

function AuditService.Init(deps: { datastore: any?, logger: any? })
    datastore = deps.datastore
    logger = deps.logger
end

function AuditService.Start() end

local function makeLogId()
    -- TODO: replace with UUID generator
    return "log_" .. tostring(os.time())
end

function AuditService.Log(actionType: string, userId: number?, details: { [string]: unknown })
    local id = makeLogId()
    local entry: AuditLog = {
        LogId = id,
        UserId = userId,
        ActionType = actionType,
        Details = details,
        Timestamp = os.time(),
    }
    -- TODO: persist to datastore and emit event
    if logger then
        -- logger:Info("AuditLog", entry)
    end
    return id
end

function AuditService.Snapshot(_profile: { [string]: unknown })
    -- TODO: store snapshot and return reference
    return "snapshot_stub"
end

return AuditService

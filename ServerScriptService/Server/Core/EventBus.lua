--!strict
-- ServerScriptService/Server/Core/EventBus.lua
-- __doc: Typed EventBus for service-to-service communication.
-- Ownership: Core
-- Consumers: All services

export type EventPayload = { [string]: unknown }
export type EventHandler = (payload: EventPayload) -> ()
export type Middleware = (next: (EventPayload) -> ()) -> (EventPayload) -> ()

local EventBus = {}
EventBus.__doc = [[
Service: EventBus
API:
  Init(deps: { logger: any? }) -> nil
  Start() -> nil
  Subscribe(eventName: string, handler: EventHandler) -> () -> nil -- returns unsubscribe
  Publish(eventName: string, payload: EventPayload) -> nil
  UseMiddleware(mw: Middleware) -> nil
Notes: Handlers run synchronously by default; middleware chain applies to Publish.
TODO:
  - Add async delivery/backpressure, metrics, and event schemas.
]]

local middlewares: { Middleware } = {}
local handlers: { [string]: { EventHandler } } = {}

function EventBus.Init(_deps: { logger: any? })
    -- TODO: perform initialization (logger, metrics)
end

function EventBus.Start()
    -- TODO: start background processors if needed
end

function EventBus.UseMiddleware(mw: Middleware)
    table.insert(middlewares, mw)
end

function EventBus.Subscribe(eventName: string, handler: EventHandler)
    handlers[eventName] = handlers[eventName] or {}
    table.insert(handlers[eventName], handler)
    local function unsubscribe()
        -- Remove handler reference
        local list = handlers[eventName]
        for i = #list, 1, -1 do
            if list[i] == handler then
                table.remove(list, i)
                break
            end
        end
    end
    return unsubscribe
end

local function applyMiddlewares(payload: EventPayload, final: (EventPayload) -> ())
    local composed = final
    for i = #middlewares, 1, -1 do
        composed = middlewares[i](composed)
    end
    composed(payload)
end

function EventBus.Publish(eventName: string, payload: EventPayload)
    local list = handlers[eventName]
    if not list then
        return
    end
    local function final(p: EventPayload)
        for _, h in ipairs(list) do
            -- pcall to prevent a handler from crashing the bus
            local ok, err = pcall(h, p)
            if not ok then
                -- TODO: emit error to logger/metrics
            end
        end
    end
    applyMiddlewares(payload, final)
end

return EventBus

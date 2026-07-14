--!strict
-- ServerScriptService/Server/Core/EventBus.lua
-- Minimal EventBus implementation with Init/Start/Subscribe/Publish

local EventBus = {}
EventBus.__doc = [[
Simple EventBus used by services.
]]

local handlers: { [string]: { (any) -> () } } = {}
local inited = false

function EventBus.Init(_deps: { logger: any? })
    inited = true
end

function EventBus.Start() end

function EventBus.Subscribe(eventName: string, handler: (any) -> ())
    handlers[eventName] = handlers[eventName] or {}
    table.insert(handlers[eventName], handler)
    local function unsubscribe()
        local list = handlers[eventName]
        for i = #list, 1, -1 do
            if list[i] == handler then table.remove(list, i); break end
        end
    end
    return unsubscribe
end

function EventBus.Publish(eventName: string, payload: any)
    local list = handlers[eventName]
    if not list then return end
    for _, h in ipairs(list) do
        local ok, err = pcall(h, payload)
        if not ok then
            -- swallow for now
        end
    end
end

return EventBus

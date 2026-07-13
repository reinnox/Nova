--!strict
-- ServerScriptService/Server/Gameplay/StatusEffectService.lua
-- __doc: Manages buffs, debuffs, DoT/HoT, durations, stacking rules.
-- Ownership: Gameplay
-- Consumers: CombatService, SkillService, PlayerLoader

local StatusEffectService = {}

export type Effect = {
    EffectId: string,
    SourceId: number?, -- userId or npc id
    DurationSec: number,
    Remaining: number,
    TickIntervalSec: number?,
    Stacks: number?,
    MaxStacks: number?,
    Data: { [string]: any }?,
}

local effects: { [number]: { Effect } } = {}
local running = false
local tickInterval = 1

function StatusEffectService.Init(_deps: { })
    -- no-op for DI compatibility
end

function StatusEffectService.Start()
    if running then return end
    running = true
    task.spawn(function()
        while running do
            local now = os.time()
            for userId, list in pairs(effects) do
                local i = 1
                while i <= #list do
                    local e = list[i]
                    e.Remaining = e.Remaining - tickInterval
                    if e.TickIntervalSec and e.TickIntervalSec > 0 then
                        if (e.Data and e.Data._lastTick and now - e.Data._lastTick >= e.TickIntervalSec) or not e.Data._lastTick then
                            e.Data = e.Data or {}
                            e.Data._lastTick = now
                            -- emit tick event via EventBus in callers by subscribing to StatusEffect.Tick
                        end
                    end
                    if e.Remaining <= 0 then
                        table.remove(list, i)
                    else
                        i = i + 1
                    end
                end
                if #list == 0 then
                    effects[userId] = nil
                end
            end
            task.wait(tickInterval)
        end
    end)
end

function StatusEffectService.Stop()
    running = false
end

function StatusEffectService.AddEffect(userId: number, effect: Effect)
    if not effects[userId] then effects[userId] = {} end
    local list = effects[userId]
    -- stacking rules: if effect exists and MaxStacks > 1, increase stacks
    local found = nil
    for _, e in ipairs(list) do
        if e.EffectId == effect.EffectId then
            found = e
            break
        end
    end
    if found then
        found.Stacks = math.min((found.Stacks or 1) + (effect.Stacks or 1), effect.MaxStacks or 1)
        found.Remaining = math.max(found.Remaining, effect.DurationSec)
    else
        local copy = {}
        for k, v in pairs(effect) do copy[k] = v end
        copy.Remaining = effect.DurationSec
        table.insert(list, copy)
    end
end

function StatusEffectService.RemoveEffect(userId: number, effectId: string)
    local list = effects[userId]
    if not list then return end
    for i = #list, 1, -1 do
        if list[i].EffectId == effectId then table.remove(list, i) end
    end
end

function StatusEffectService.GetEffects(userId: number)
    return effects[userId]
end

return StatusEffectService

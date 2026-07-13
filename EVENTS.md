# EventBus & Events (EVENTS.md)

EventBus
- Central typed event bus for service-to-service communication.
- Event payloads must be documented here and include Luau types.
- Services should register handlers during Init().

Naming conventions
- Use dot-separated names: "Service.Action" or global names like "Combat.PlayerDamaged".
- Payloads must be tables with explicit keys.

Core events (examples)
- "Player.Loaded" { userId: number, profile: PlayerProfile }
- "Player.Saved" { userId: number, snapshotRef: string }
- "Combat.DamageApplied" { attackerId: number, defenderId: number, amount: number, isCrit: boolean }
- "Economy.TradeCompleted" { fromId, toId, items, gold }
- "Audit.ActionLogged" { logId, userId, actionType, details }

Event versioning
- If event payloads change, append a version suffix and update EVENTS.md.

Middleware hooks
- EventBus should support middleware to serialize events and to attach audit info.

TODO
- Expand event list as services are implemented. Each service PR must add its events to this file.

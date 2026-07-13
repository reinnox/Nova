# Nova — Design Document

This repository contains the canonical design and scaffolding for Nova — a server-authoritative, modular, data-driven MMORPG built on Roblox (Luau).

This DESIGN.md is the high-level blueprint. For implementation-level details, see the other docs in this PR (API.md, EVENTS.md, SAVE_FORMAT.md, BALANCING.md, MODULES.md).

Key principles
- Server authority for all gameplay-critical logic (combat, economy, inventory).
- Modular services with a typed EventBus for inter-service communication.
- Data-driven content via Data Modules editable by designers (ReplicatedStorage/Shared/DataModules).
- Anti-exploit first: auditing, rate-limits, server-side validation, and snapshots.

Architecture
- Services expose a public API (documented in API.md) and must implement Init() and Start() methods. Init() should perform registration with the EventBus, dependency injection, and set up data; Start() should begin runtime activity.
- Services communicate through EventBus where possible. Direct module-to-module calls are discouraged and must avoid circular dependencies.
- All constants and tuning values live in DataModules under ReplicatedStorage/Shared/DataModules (Config.lua, EnhancementTable.lua, BalancingData.lua, etc.).
- Every module must include Luau type annotations for public types and exports.

PlayerProfile
- PlayerProfile must contain a ProfileVersion integer. Current ProfileVersion = 1.
- Save/Load and migration is the responsibility of DataService (see SAVE_FORMAT.md).

Anti-Exploit & Audit
- All remote calls must pass through centralized validation and rate-limiting middleware (see SAVE_FORMAT.md and EVENTS.md for middleware hooks).
- AuditService records all mutating actions with snapshot references.

Roadmap & Milestones
- See ROADMAP.md for milestone breakdown and schedule.

TODO
- This DESIGN document is intentionally concise. See other docs in this PR for API surfaces, event definitions, save formats, and balancing tables.

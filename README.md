# Nova — Roblox MMORPG (Production Blueprint)

Nova is a server-authoritative, modular, data-driven MMORPG for Roblox. This repository contains the canonical design and a code-first scaffold for implementing Nova's systems.

Key principles:
- Server authority for all gameplay-critical logic (combat, economy, inventory).
- Data-driven content via Data Modules editable by designers.
- Modular services with a typed EventBus for inter-service communication.
- Anti-exploit first: auditing, rate-limits, and server-side verification.

Roadmap (high level):
- Alpha1 (2 months): Player data, movement validation, basic combat, inventory.
- Alpha2 (2 months): World streaming, day/night, weather, basic NPCs.
- Beta1..Beta4: Progression, economy, social, content features.
- Release: polish, events, hardening.

See `DESIGN.md` for full system descriptions and module layouts. This repo contains starter Luau module skeletons under ReplicatedStorage and ServerScriptService.

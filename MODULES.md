# Modules & Folder Layout

This document describes where files live in the repository and conventions for naming and public APIs.

Top-level layout
```
ReplicatedStorage/
  Shared/
    DataModules/
      Items.lua
      Skills.lua
      Classes.lua
      Config.lua
      EnhancementTable.lua
      BalancingData.lua
    Types.lua
    Utils.lua

ServerScriptService/
  Server/
    Core/
      EventBus.lua
      DataService.lua
      PlayerLoader.lua
      AuditService.lua
    Gameplay/
      CombatService.lua
      SkillService.lua
      EnhancementService.lua
      CraftingService.lua
    World/
      ZoneService.lua
      WeatherService.lua
      NPCService.lua
    Economy/
      InventoryService.lua
      TradeService.lua
      AuctionService.lua
    Naval/
      ShipService.lua
    Social/
      PartyService.lua
      GuildService.lua

StarterPlayerScripts/
  Client/
    Controllers/
    UI/

src/
  Types/
  Utils/
```

Conventions
- Module filenames use PascalCase for services and camel_case for data modules (e.g., EnhancementTable.lua).
- Every service module must export a table with at least: Init(): nil, Start(): nil, Public API functions, and a `__doc` string describing its public API.
- Include Luau type annotations at the top of modules or in `src/Types` and `ReplicatedStorage/Shared/Types.lua`.
- All constants and balancing data must live in DataModules (no magic numbers in service logic).
- Services must not create circular dependencies. Use EventBus events for cross-service interactions.
- RemoteEvent and RemoteFunction handlers must execute through validation and rate-limiting middleware provided by Core/RemoteMiddleware.lua (see Core Services PR).

Testing
- Each service should include a unit-test placeholder file under `tests/` that describes expected behavior and inputs/outputs. Add actual tests when the testing framework is chosen.

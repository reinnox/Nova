# Player Save Format (SAVE_FORMAT.md)

This document defines the saved PlayerProfile schema and migration rules.

Versioning
- PlayerProfile contains: `ProfileVersion: number` at top-level.
- Current ProfileVersion = 1.

Migration framework (DataService responsibility)
- DataService must implement a migration map table:
  local migrations = {
    [1] = function(profile) -- identity for initial version
      return profile
    end,
    [2] = function(profile)
      -- example migration stub from v1 -> v2
      -- TODO: implement
      return profile
    end,
  }

- On load:
  1. Read raw profile from DataStore.
  2. If `ProfileVersion` is nil, assume 1.
  3. For v = profile.ProfileVersion to currentVersion - 1 do
       profile = migrations[v+1](profile)
     end
  4. Persist updated profile if migrations applied.

Backward compatibility
- Migration functions must be idempotent.
- Tests should validate round-trip: save -> migrate -> new-schema fields exist.

Profile minimal fields (must be present in v1)
- ProfileVersion: number
- UserId: number
- CharacterName: string
- ClassId: string
- Level: number
- Experience: number
- BaseStats: table
- AllocatedStatusPoints: table
- Inventory: table
- CreatedAt: number

See `src/Types/PlayerProfile.lua` for Luau type definitions.

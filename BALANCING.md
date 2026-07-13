# Balancing (BALANCING.md)

This document contains canonical gameplay formulas, XP curves, enhancement tables, and other tunables. All values must be placed in DataModules under `ReplicatedStorage/Shared/DataModules`.

Damage formula (canonical)
- See CombatService: CalculateDamage implementation (Combat & Skills PR)
- Example formula:
  finalDmg = floor(rawDmg * (1 - mitigation) * levelMult * critMult)

Enhancement table
- Use `ReplicatedStorage/Shared/DataModules/EnhancementTable.lua` for success rates and failure behavior. Example (excerpt):
  [1] = { SuccessRate = 1.0, OnFailure = "Nothing", Bonus = 0.02 }
  ...

XP curve
- XP per level should live in `LevelCurveData.lua` data module. No hard-coded curves in logic.

Drop rates
- Drop tables must live in `DataModules/MobDrops.lua` with explicit rarity probabilities and guaranteed minimums for bosses.

TODO
- Expand with exact curves and numerical tables in future PRs. This file will track live tuning changes and must be updated when changes are made.

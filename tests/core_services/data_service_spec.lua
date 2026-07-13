--!strict
-- tests/core_services/data_service_spec.lua
-- Minimal unit tests for DataService (works as a spec module for your test runner)

local DataService = require(script.Parent.Parent.Parent.Server.Core.DataService)

local function run()
    local ok = true
    -- Init
    DataService.Init({})
    DataService.Start()
    -- Save and Load
    local profile = { ProfileVersion = 1, UserId = 123, CharacterName = "Test" }
    local saved = DataService.SaveProfile(profile)
    if not saved then return false, "SaveProfile failed" end
    local loaded = DataService.LoadProfile(123)
    if not loaded or loaded.UserId ~= 123 then return false, "LoadProfile mismatch" end
    return true
end

return { run = run }

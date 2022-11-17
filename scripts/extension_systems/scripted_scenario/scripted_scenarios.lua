local ScriptedScenarios = {}

local function _create_scenarios_entry(alias, path)
	local scenarios = require(path)
	ScriptedScenarios[alias] = scenarios
end

_create_scenarios_entry("training_grounds", "scripts/extension_systems/training_grounds/training_grounds_scenarios")
_create_scenarios_entry("shooting_range", "scripts/extension_systems/training_grounds/shooting_range_scenarios")

return ScriptedScenarios

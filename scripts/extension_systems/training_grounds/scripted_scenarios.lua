local ScriptedScenarios = {}

local function _create_scenarios_entry(alias, path)
	local scenarios = require(path)
	ScriptedScenarios[alias] = scenarios
end

_create_scenarios_entry("training_grounds", "scripts/extension_systems/training_grounds/training_grounds_scenarios")

return ScriptedScenarios

-- chunkname: @scripts/extension_systems/scripted_scenario/generic_steps.lua

local ScriptedScenarioUtility = require("scripts/extension_systems/scripted_scenario/scripted_scenario_utility")
local GenericSteps = {
	dynamic = {},
	_condition = {},
}

GenericSteps.dynamic.add_scenario_buff = function (buff_name)
	return {
		name = "add_scenario_buff",
		start_func = function (scenario_system, player, scenario_data, step_data, t)
			scenario_system:add_scenario_buff(player.player_unit, buff_name, t)
		end,
	}
end

GenericSteps.dynamic.start_parallel_scenario = function (alias, name)
	return {
		start_func = function (scenario_system, player, scenario_data, step_data, t)
			scenario_system:start_parallel_scenario(alias, name, t)
		end,
	}
end

ScriptedScenarioUtility.parse_condition_steps(GenericSteps)

return GenericSteps

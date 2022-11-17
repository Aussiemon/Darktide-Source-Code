local ScriptedScenarioUtility = require("scripts/extension_systems/scripted_scenario/scripted_scenario_utility")
local GenericSteps = {
	dynamic = {},
	_condition = {}
}

local function add_unique_buff(unit, buff_name, scenario_data, t)
	scenario_data.unique_buffs = scenario_data.unique_buffs or {}
	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local _, buff_id, component_index = buff_extension:add_externally_controlled_buff(buff_name, t)
	local buff_data = {
		buff_id = buff_id,
		component_index = component_index
	}
	scenario_data.unique_buffs[buff_name] = buff_data
end

GenericSteps.dynamic.add_unique_buff = function (buff_name)
	return {
		name = "add_unique_buff",
		start_func = function (scenario_system, player, scenario_data, step_data, t)
			add_unique_buff(player.player_unit, buff_name, scenario_data, t)
		end
	}
end

GenericSteps.dynamic.start_parallel_scenario = function (alias, name)
	return {
		start_func = function (scenario_system, player, scenario_data, step_data, t)
			scenario_system:start_parallel_scenario(alias, name, t)
		end
	}
end

ScriptedScenarioUtility.parse_condition_steps(GenericSteps)

return GenericSteps

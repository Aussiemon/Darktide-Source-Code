-- chunkname: @scripts/extension_systems/scripted_scenario/scripted_scenario_utility.lua

local ScriptedScenarioUtility = {}

ScriptedScenarioUtility.parse_condition_steps = function (steps)
	steps.condition_if = {}
	steps.condition_elseif = {}

	for step_name, func in pairs(steps._condition) do
		steps.condition_if[step_name] = function (...)
			local template = func(...)

			template.name = step_name
			template.condition_type = "if"
			template.is_condition = true

			return template
		end
		steps.condition_elseif[step_name] = function (...)
			local template = func(...)

			template.name = step_name
			template.condition_type = "elseif"
			template.is_condition = true

			return template
		end
	end

	steps.condition_else = {
		condition_type = "else",
		is_condition = true,
		name = "condition_else",
		condition_func = function ()
			return true
		end,
	}
	steps.condition_end = {
		condition_type = "end",
		is_condition = true,
		name = "condition_end",
	}
end

ScriptedScenarioUtility.validate_steps = function (steps)
	local ignored_templates = {
		_condition = true,
		condition_elseif = true,
		condition_if = true,
		dynamic = true,
	}

	for name, template in pairs(ShootingRangeSteps) do
		if not ignored_templates[name] then
			template.name = name
		end
	end
end

return ScriptedScenarioUtility

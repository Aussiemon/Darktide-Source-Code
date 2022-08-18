local TaskLocalization = require("scripts/settings/contracts/task_localization")
local CriteriaParser = {}
local _task_reserved_words = {
	"count",
	"complexity",
	"value",
	"taskType"
}

CriteriaParser.parse_backend_criteria = function (backend_criteria)
	local task = {
		at = backend_criteria.value,
		target = backend_criteria.count,
		task_type = backend_criteria.taskType,
		complexity = backend_criteria.complexity,
		specifiers = {}
	}

	for name, value in pairs(backend_criteria) do
		if not table.array_contains(_task_reserved_words, name) then
			task.specifiers[name] = value
		end
	end

	return task
end

CriteriaParser.localize_criteria = function (backend_criteria)
	local parsed_task = CriteriaParser.parse_backend_criteria(backend_criteria)
	local target_value = parsed_task.target
	local params = {
		count = target_value
	}
	local localization_data = TaskLocalization[parsed_task.task_type]
	local title_key = localization_data.label_key
	local description_key = localization_data.description_key

	for i = 1, #localization_data.parameters do
		local param = localization_data.parameters[i]
		params[param.key] = Localize(string.format(param.pattern, parsed_task.specifiers[param.input] or "missing_value"))
	end

	local title = Localize(title_key, true, params)
	local description = Localize(description_key, true, params)

	return title, description, target_value
end

return CriteriaParser

local ContractSettings = require("scripts/settings/contracts/contract_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
local ContractCriteriaParser = {}
local _task_reserved_words = {
	"count",
	"complexity",
	"value",
	"taskType"
}
local contract_lookup = {}

for id, setting in pairs(ContractSettings) do
	contract_lookup[setting.backend_name] = id
end

local function default_parameters(target_value, specifiers)
	return {
		count = target_value
	}
end

ContractCriteriaParser.parse_backend_criteria = function (backend_criteria)
	local task_type = contract_lookup[backend_criteria.taskType]
	local task = {
		at = backend_criteria.value,
		target = backend_criteria.count,
		complexity = backend_criteria.complexity,
		specifiers = {},
		task_type = task_type
	}

	for name, value in pairs(backend_criteria) do
		if not table.array_contains(_task_reserved_words, name) then
			task.specifiers[name] = value
		end
	end

	local contract_setting = ContractSettings[task_type]
	local stat_name = contract_setting and contract_setting.stat_name

	if type(stat_name) == "function" then
		stat_name = stat_name(task.target, task.specifiers)
	end

	task.stat_name = stat_name

	return task
end

ContractCriteriaParser.localize_criteria = function (backend_criteria)
	local parsed_task = ContractCriteriaParser.parse_backend_criteria(backend_criteria)
	local target_value = parsed_task.target
	local specifiers = parsed_task.specifiers
	local task_type = parsed_task.task_type
	local contract_setting = ContractSettings[task_type]
	local title_key = contract_setting.title
	local description_key = contract_setting.description
	local parameter_function = contract_setting.localization_parameters or default_parameters
	local parameters = parameter_function(target_value, specifiers)
	local title = Localize(title_key, true, parameters)
	local description = Localize(description_key, true, parameters)

	return title, description, target_value
end

ContractCriteriaParser.icon = function (backend_criteria)
	local type = backend_criteria.taskType
	local contract_settings = UISettings.contracts_icons_by_type

	return contract_settings[type] or contract_settings.default
end

return ContractCriteriaParser

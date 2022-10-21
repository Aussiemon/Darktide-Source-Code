local StatDefinition = require("scripts/managers/stats/stat_definition")
local Activations = require("scripts/managers/stats/utility/activation_functions")
local Parameters = require("scripts/managers/stats/utility/parameter_functions")
local Conditions = require("scripts/managers/stats/utility/conditional_functions")
local NoSave = require("scripts/managers/stats/storage/stat_no_save")
local SingleValue = require("scripts/managers/stats/storage/stat_single_value")
local Tree = require("scripts/managers/stats/storage/stat_tree")
local StatTrigger = require("scripts/managers/stats/stat_trigger")
local StatFactory = {
	create_group = function ()
		return {
			definitions = {},
			triggered_by = {}
		}
	end
}

StatFactory.add_to_group = function (group, stat_definition, ...)
	if stat_definition ~= nil then
		local id = stat_definition:get_id()
		group.definitions[id] = stat_definition

		for _, stat_name in ipairs(stat_definition:get_triggers()) do
			local triggered_by = group.triggered_by[stat_name] or {}
			triggered_by[#triggered_by + 1] = id
			group.triggered_by[stat_name] = triggered_by
		end
	end

	if select("#", ...) > 0 then
		StatFactory.add_to_group(group, ...)
	end
end

StatFactory.create_hook = function (id, params, optional_flags)
	return StatDefinition:new({}, NoSave:new(id, params), optional_flags)
end

StatFactory.create_dynamic_reducer = function (id, stat_to_reduce, in_parameters, activation_function, optional_out_parameters, optional_flags, optional_default_value)
	local out_parameters = optional_out_parameters or in_parameters

	return StatDefinition:new({
		[stat_to_reduce:get_id()] = StatTrigger:new(activation_function, Parameters.pick(stat_to_reduce, unpack(in_parameters)))
	}, Tree:new(id, out_parameters, optional_default_value), optional_flags)
end

StatFactory.create_smart_reducer = function (id, stat_to_reduce, in_parameters, transformers, out_parameters, activation_function, optional_flags, optional_default_value)
	return StatDefinition:new({
		[stat_to_reduce:get_id()] = StatTrigger:new(activation_function, Parameters.smart_pick(stat_to_reduce, in_parameters, transformers))
	}, Tree:new(id, out_parameters, optional_default_value), optional_flags)
end

StatFactory.create_flag = function (id, listens_to, optional_condition, optional_flags)
	local activation_function = optional_condition and Activations.on_condition(optional_condition, Activations.set(1)) or Activations.set(1)

	return StatDefinition:new({
		[listens_to:get_id()] = StatTrigger:new(activation_function)
	}, SingleValue:new(id, 0), optional_flags)
end

StatFactory.create_flag_checker = function (id, flags, optional_flags, optional_max_amount)
	optional_max_amount = optional_max_amount or #flags
	local activation_function = Activations.clamp(Activations.increment, 0, optional_max_amount)
	local triggers = {}

	for i = 1, #flags do
		local flag = flags[i]
		triggers[flag:get_id()] = StatTrigger:new(activation_function)
	end

	return StatDefinition:new(triggers, SingleValue:new(id), optional_flags)
end

StatFactory.create_simple = function (id, stat_to_reduce, activation_function, optional_flags, optional_default_value)
	return StatDefinition:new({
		[stat_to_reduce:get_id()] = StatTrigger:new(activation_function)
	}, SingleValue:new(id, optional_default_value), optional_flags)
end

StatFactory.create_transformer = function (id, stat_to_reduce, activation_function, optional_parameter_function, optional_out_params)
	return StatDefinition:new({
		[stat_to_reduce:get_id()] = StatTrigger:new(activation_function, optional_parameter_function)
	}, NoSave:new(id, optional_out_params))
end

StatFactory.create_echo = function (id, stat_to_echo, optional_condition, optional_delay, optional_flags)
	local delay = optional_delay or 0
	local condition = optional_condition or Conditions.always_true

	return StatDefinition:new({
		[stat_to_echo:get_id()] = StatTrigger:new(Activations.on_condition(condition, delay > 0 and Activations.with_delay(delay, Activations.echo) or Activations.echo), Parameters.echo)
	}, NoSave:new(id, stat_to_echo:get_parameters()), optional_flags)
end

StatFactory.create_in_a_row = function (id, increase_on_stat, reset_on_stat)
	return StatDefinition:new({
		[increase_on_stat:get_id()] = StatTrigger:new(Activations.increment),
		[reset_on_stat:get_id()] = StatTrigger:new(Activations.set(0))
	}, SingleValue:new(id, 0))
end

StatFactory.create_sum_over_time = function (id, input_stat, time, optional_condition, optional_flags)
	local condition = optional_condition or Conditions.always_true
	local echo_stat = StatFactory.create_echo(string.format("_%s_anti", id), input_stat, nil, time)
	local sum_stat = StatDefinition:new({
		[input_stat:get_id()] = StatTrigger:new(Activations.on_condition(condition, Activations.sum)),
		[echo_stat:get_id()] = StatTrigger:new(Activations.on_condition(condition, Activations.difference))
	}, SingleValue:new(id, 0), optional_flags)

	return echo_stat, sum_stat
end

return StatFactory

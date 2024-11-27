﻿-- chunkname: @scripts/extension_systems/action_input/action_input_formatter.lua

local ActionInputFormatterSettings = require("scripts/settings/action_input_formatter/action_input_formatter_settings")
local NO_ACTION_INPUT = "NO_ACTION_INPUT"
local NO_RAW_INPUT = "NO_RAW_INPUT"
local _read_action_inputs, _read_hierarchy
local ActionInputFormatter = {}

ActionInputFormatter.format = function (action_input_type, templates, raw_inputs)
	local raw_inputs_network_lookup = {}

	for i = 1, #raw_inputs do
		local raw_input = raw_inputs[i]

		raw_inputs_network_lookup[i] = raw_input
		raw_inputs_network_lookup[raw_input] = i
	end

	local no_raw_input_index = #raw_inputs_network_lookup + 1

	raw_inputs_network_lookup[no_raw_input_index] = NO_RAW_INPUT
	raw_inputs_network_lookup[NO_RAW_INPUT] = no_raw_input_index

	local action_input_settings = ActionInputFormatterSettings[action_input_type]
	local max_action_inputs = action_input_settings.max_action_inputs
	local max_action_input_queue = action_input_settings.max_action_input_queue
	local max_hierarchy_depth = 0
	local action_inputs_hierarchy = {}
	local action_inputs_configs = {}
	local action_inputs_network_lookups = {}
	local template_keys = table.keys(templates)

	table.sort(template_keys)

	for key_index = 1, #template_keys do
		local name = template_keys[key_index]
		local template = templates[name]
		local action_inputs = template.action_inputs

		if action_inputs then
			local sequences = {}

			action_inputs_configs[name] = sequences

			local network_lookup = {}

			action_inputs_network_lookups[name] = network_lookup

			local num_action_inputs = 1

			network_lookup[num_action_inputs] = NO_ACTION_INPUT
			network_lookup[NO_ACTION_INPUT] = num_action_inputs
			num_action_inputs = _read_action_inputs(name, action_inputs, sequences, network_lookup, num_action_inputs)

			local hierarchy_data = template.action_input_hierarchy

			if hierarchy_data then
				local hierarchy = hierarchy_data

				action_inputs_hierarchy[name] = hierarchy

				local hierarchy_depth = _read_hierarchy(hierarchy_data, sequences)

				if max_hierarchy_depth < hierarchy_depth then
					max_hierarchy_depth = hierarchy_depth
				end
			end
		else
			Log.error("ActionInputFormatter", "No action_inputs defined for Template (%s)", name)
		end
	end

	return action_inputs_configs, action_inputs_network_lookups, action_inputs_hierarchy, raw_inputs_network_lookup, max_action_inputs, max_action_input_queue, max_hierarchy_depth, NO_ACTION_INPUT, NO_RAW_INPUT
end

function _read_action_inputs(name, action_inputs, sequences, network_lookup, total_num_action_inputs)
	local keys = table.keys(action_inputs)

	table.sort(keys)

	for _, action_input in ipairs(keys) do
		local data = action_inputs[action_input]
		local network_lookup_i = #network_lookup + 1

		network_lookup[network_lookup_i] = action_input
		network_lookup[action_input] = network_lookup_i

		local input_sequence = data.input_sequence
		local num_elements = input_sequence and #input_sequence or 0
		local config = {
			action_input_name = action_input,
			elements = Script.new_array(num_elements),
			buffer_time = data.buffer_time,
			reevaluation_time = data.reevaluation_time or nil,
			clear_input_queue = data.clear_input_queue or false,
			max_queue = data.max_queue or false,
			dont_queue = data.dont_queue,
		}

		for ii = 1, num_elements do
			local element = input_sequence[ii]
			local inputs = element.inputs

			if inputs then
				for jj = 1, #inputs do
					local sub_element = inputs[jj]
				end
			end

			config.elements[ii] = element
		end

		sequences[action_input] = config
		total_num_action_inputs = total_num_action_inputs + 1
	end

	return total_num_action_inputs
end

function _read_hierarchy(hierarchy_data, sequences, hierarchy_depth)
	hierarchy_depth = hierarchy_depth and hierarchy_depth + 1 or 1

	local best_children_hierarchy_depth

	for _, entry in ipairs(hierarchy_data) do
		local action_input = entry.input
		local transition = entry.transition

		if type(transition) == "table" then
			local child_hierarchy_depth = _read_hierarchy(transition, sequences, hierarchy_depth)

			if not best_children_hierarchy_depth or best_children_hierarchy_depth < child_hierarchy_depth then
				best_children_hierarchy_depth = child_hierarchy_depth
			end
		else
			local stay = transition == "stay"
			local base = transition == "base"

			if transition ~= "previous" then
				local var_1_0 = false
			else
				local previous = true
			end
		end
	end

	if best_children_hierarchy_depth then
		hierarchy_depth = best_children_hierarchy_depth
	end

	return hierarchy_depth
end

return ActionInputFormatter

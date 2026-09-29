-- chunkname: @scripts/extension_systems/action_input/action_input_parser.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local wield_inputs = PlayerCharacterConstants.wield_inputs
local slot_configuration = PlayerCharacterConstants.slot_configuration
local raw_inputs = {
	"action_one_pressed",
	"action_one_hold",
	"action_one_release",
	"action_two_pressed",
	"action_two_hold",
	"action_two_release",
	"combat_ability_pressed",
	"combat_ability_hold",
	"combat_ability_release",
	"grenade_ability_pressed",
	"grenade_ability_hold",
	"grenade_ability_release",
	"weapon_reload_pressed",
	"weapon_reload_hold",
	"wield_scroll_down",
	"wield_scroll_up",
	"quick_wield",
	"weapon_inspect_hold",
	"weapon_extra_pressed",
	"weapon_extra_hold",
	"weapon_extra_release",
	"toggle_ads",
}

for i = 1, #wield_inputs do
	local input_config = wield_inputs[i]

	raw_inputs[#raw_inputs + 1] = input_config.input
end

local ActionInputFormatter = require("scripts/extension_systems/action_input/action_input_formatter")
local RING_BUFFER_SIZE = 60
local IS_RUNNING = 1
local CURRENT_ELEMENT_INDEX = 2
local ELEMENT_START_T = 3
local ACTION_INPUT = 1
local RAW_INPUT = 2
local HIERARCHY_POSITION = 3
local BOT_REQUEST_RING_BUFFER_MAX = 5
local _get_current_hierarchy, _hierarchy_string, _reset_bot_request_entry, _input_queue_string, _queue_hierarchy_offset
local ActionInputParser = class("ActionInputParser")

ActionInputParser.init = function (self, unit, action_component_name, action_component, config_data, debug_index)
	local action_input_type = config_data.action_input_type
	local templates = config_data.templates
	local action_extension = config_data.action_extension

	self._config_data = config_data
	self._unit = unit
	self._input_extension = ScriptUnit.extension(unit, "input_system")
	self._action_component_name = action_component_name
	self._action_component = action_component
	self._sequences = Script.new_array(RING_BUFFER_SIZE)
	self._action_input_queue = Script.new_array(RING_BUFFER_SIZE)
	self._hierarchy_position = Script.new_array(RING_BUFFER_SIZE)
	self._input_aliases = {}
	self._active_slot_name = nil
	self._ring_buffer_index = 1
	self._debug_index = debug_index
	self._input_queue_first_entry_became_first_entry_t = 0
	self._fixed_frame_offset_start_t_min = NetworkConstants.fixed_frame_offset_start_t_5bit.min

	self:_format_and_initialize_action_inputs(action_input_type, templates)

	local player_unit_spawn_manager = Managers.state.player_unit_spawn

	self._player = player_unit_spawn_manager:owner(unit)

	local unit_data_ext = ScriptUnit.extension(unit, "unit_data_system")

	self._sprint_character_state_component = unit_data_ext:read_component("sprint_character_state")

	local bot_action_input_request_queue = Script.new_array(BOT_REQUEST_RING_BUFFER_MAX)

	self._bot_action_input_request_queue = bot_action_input_request_queue
	self._global_bot_request_id = 0
	self._num_bot_action_input_requests = 0
	self._bot_action_input_current_buffer_index = 0

	local NO_ACTION_INPUT = self._NO_ACTION_INPUT
	local NO_RAW_INPUT = self._NO_RAW_INPUT

	for i = 1, BOT_REQUEST_RING_BUFFER_MAX do
		local entry = {
			action_input = nil,
			global_bot_request_id = nil,
			raw_input = nil,
		}

		_reset_bot_request_entry(entry, NO_ACTION_INPUT, NO_RAW_INPUT)

		bot_action_input_request_queue[i] = entry
	end

	self._last_fixed_frame = 0
	self._last_action_auto_completed = false
	self._fixed_time_step = Managers.state.game_session.fixed_time_step
end

ActionInputParser.set_active_slot = function (self, slot_name_or_nil)
	local input_aliases = self._input_aliases
	local current_slot_name = self._active_slot_name

	if current_slot_name then
		local slot_config = slot_configuration[current_slot_name]
		local slot_wield_inputs = slot_config.wield_inputs

		if slot_wield_inputs then
			if input_aliases.wielded_input_pressed == slot_wield_inputs.pressed then
				input_aliases.wielded_input_pressed = nil
			end

			if input_aliases.wielded_input_hold == slot_wield_inputs.hold then
				input_aliases.wielded_input_hold = nil
			end

			if input_aliases.wielded_input_released == slot_wield_inputs.released then
				input_aliases.wielded_input_released = nil
			end
		end
	end

	self._active_slot_name = slot_name_or_nil

	if slot_name_or_nil then
		local slot_config = slot_configuration[slot_name_or_nil]
		local slot_wield_inputs = slot_config.wield_inputs

		if slot_wield_inputs then
			input_aliases.wielded_input_pressed = slot_wield_inputs.pressed
			input_aliases.wielded_input_hold = slot_wield_inputs.hold
			input_aliases.wielded_input_released = slot_wield_inputs.released
		end
	end
end

ActionInputParser._format_and_initialize_action_inputs = function (self, action_input_type, templates)
	self._ACTION_INPUT_SEQUENCE_CONFIGS, self._ACTION_INPUT_NETWORK_LOOKUP, self._ACTION_INPUT_HIERARCHY, self._RAW_INPUTS_NETWORK_LOOKUP, self._MAX_ACTION_INPUT_SEQUENCES, self._MAX_ACTION_INPUT_QUEUE, self._MAX_HIERARCHY_DEPTH, self._NO_ACTION_INPUT, self._NO_RAW_INPUT = ActionInputFormatter.format(action_input_type, templates, raw_inputs)

	local sequences_ring_buffer = self._sequences
	local action_input_queue_ring_buffer = self._action_input_queue
	local hierarchy_position_ring_buffer = self._hierarchy_position

	for i = 1, RING_BUFFER_SIZE do
		sequences_ring_buffer[i] = nil
		action_input_queue_ring_buffer[i] = nil
		hierarchy_position_ring_buffer[i] = nil
	end

	self:_initialize_ring_buffer_frame(self._ring_buffer_index)
end

ActionInputParser._initialize_ring_buffer_frame = function (self, index)
	local NO_RAW_INPUT = self._NO_RAW_INPUT
	local NO_ACTION_INPUT = self._NO_ACTION_INPUT
	local MAX_ACTION_INPUT_SEQUENCES = self._MAX_ACTION_INPUT_SEQUENCES
	local MAX_ACTION_INPUT_QUEUE = self._MAX_ACTION_INPUT_QUEUE
	local MAX_HIERARCHY_DEPTH = self._MAX_HIERARCHY_DEPTH
	local unset_t = NetworkConstants.fixed_time_offset_unset
	local sequences = {
		[IS_RUNNING] = Script.new_array(MAX_ACTION_INPUT_SEQUENCES),
		[CURRENT_ELEMENT_INDEX] = Script.new_array(MAX_ACTION_INPUT_SEQUENCES),
		[ELEMENT_START_T] = Script.new_array(MAX_ACTION_INPUT_SEQUENCES),
	}
	local sequences_is_running = sequences[IS_RUNNING]
	local sequences_current_element_index = sequences[CURRENT_ELEMENT_INDEX]
	local sequences_element_start_t = sequences[ELEMENT_START_T]

	for j = 1, MAX_ACTION_INPUT_SEQUENCES do
		sequences_is_running[j] = false
		sequences_current_element_index[j] = 1
		sequences_element_start_t[j] = unset_t
	end

	self._sequences[index] = sequences

	local action_input_queue = {
		[ACTION_INPUT] = Script.new_array(MAX_ACTION_INPUT_QUEUE),
		[RAW_INPUT] = Script.new_array(MAX_ACTION_INPUT_QUEUE),
		[HIERARCHY_POSITION] = Script.new_array(MAX_ACTION_INPUT_QUEUE * MAX_HIERARCHY_DEPTH),
	}
	local action_input_queue_action_input = action_input_queue[ACTION_INPUT]
	local action_input_queue_raw_input = action_input_queue[RAW_INPUT]
	local action_input_queue_hierarchy_position = action_input_queue[HIERARCHY_POSITION]

	for j = 1, MAX_ACTION_INPUT_QUEUE do
		action_input_queue_action_input[j] = NO_ACTION_INPUT
		action_input_queue_raw_input[j] = NO_RAW_INPUT

		local hierarchy_offset = _queue_hierarchy_offset(j, MAX_HIERARCHY_DEPTH)

		for k = 1, MAX_HIERARCHY_DEPTH do
			action_input_queue_hierarchy_position[hierarchy_offset + k] = NO_ACTION_INPUT
		end
	end

	self._action_input_queue[index] = action_input_queue

	local hierarchy_position = Script.new_array(MAX_HIERARCHY_DEPTH)

	for j = 1, MAX_HIERARCHY_DEPTH do
		hierarchy_position[j] = NO_ACTION_INPUT
	end

	self._hierarchy_position[index] = hierarchy_position
end

ActionInputParser._ensure_ring_buffer_frame = function (self, index)
	if not self._sequences[index] then
		self:_initialize_ring_buffer_frame(index)
	end
end

ActionInputParser.on_reload = function (self)
	local c = self._config_data

	self:_format_and_initialize_action_inputs(c.action_input_type, c.templates)
end

ActionInputParser.peek_next_input = function (self)
	local input_queue = self._action_input_queue[self._ring_buffer_index]
	local action_input = input_queue[ACTION_INPUT][1]

	if action_input == self._NO_ACTION_INPUT then
		return nil, nil
	else
		return action_input, input_queue[RAW_INPUT][1]
	end
end

ActionInputParser.last_action_auto_completed = function (self)
	return self._last_action_auto_completed
end

ActionInputParser.consume_next_input = function (self, t)
	local ring_buffer_index = self._ring_buffer_index
	local input_queue = self._action_input_queue[ring_buffer_index]
	local input_queue_action_input = input_queue[ACTION_INPUT]
	local input_queue_raw_input = input_queue[RAW_INPUT]
	local input_queue_hierarchy_position = input_queue[HIERARCHY_POSITION]
	local hierarchy_position = self._hierarchy_position[ring_buffer_index]
	local first_entry_action_input = input_queue_action_input[1]
	local MAX_ACTION_INPUT_QUEUE = self._MAX_ACTION_INPUT_QUEUE
	local MAX_HIERARCHY_DEPTH = self._MAX_HIERARCHY_DEPTH
	local NO_ACTION_INPUT = self._NO_ACTION_INPUT
	local NO_RAW_INPUT = self._NO_RAW_INPUT

	if input_queue_action_input[2] ~= NO_ACTION_INPUT then
		local template_name = self._action_component.template_name
		local sequence_configs = self._ACTION_INPUT_SEQUENCE_CONFIGS[template_name]
		local sequence_config = sequence_configs[first_entry_action_input]
		local reevaluation_time = sequence_config.reevaluation_time
		local time_before_consuming_or_nil = reevaluation_time and t - self._input_queue_first_entry_became_first_entry_t

		if time_before_consuming_or_nil and reevaluation_time <= time_before_consuming_or_nil then
			local base_hierarchy = self._ACTION_INPUT_HIERARCHY[template_name]
			local network_lookup = self._ACTION_INPUT_NETWORK_LOOKUP[template_name]
			local sequences = self._sequences[ring_buffer_index]
			local second_entry_hierarchy_offset = _queue_hierarchy_offset(2, MAX_HIERARCHY_DEPTH)

			self:_jump_hierarchy(t, hierarchy_position, input_queue_hierarchy_position, second_entry_hierarchy_offset, base_hierarchy, sequences, t, network_lookup)
			self:_clear_action_input_queue(input_queue)
		else
			for i = 1, MAX_ACTION_INPUT_QUEUE do
				local next_entry_index = i + 1

				if next_entry_index <= MAX_ACTION_INPUT_QUEUE then
					input_queue_action_input[i] = input_queue_action_input[next_entry_index]
					input_queue_raw_input[i] = input_queue_raw_input[next_entry_index]

					local entry_hierarchy_offset = _queue_hierarchy_offset(i, MAX_HIERARCHY_DEPTH)
					local next_entry_hierarchy_offset = _queue_hierarchy_offset(next_entry_index, MAX_HIERARCHY_DEPTH)

					for j = 1, MAX_HIERARCHY_DEPTH do
						input_queue_hierarchy_position[entry_hierarchy_offset + j] = input_queue_hierarchy_position[next_entry_hierarchy_offset + j]
					end
				else
					input_queue_action_input[i] = NO_ACTION_INPUT
					input_queue_raw_input[i] = NO_RAW_INPUT

					local entry_hierarchy_offset = _queue_hierarchy_offset(i, MAX_HIERARCHY_DEPTH)

					for j = 1, MAX_HIERARCHY_DEPTH do
						input_queue_hierarchy_position[entry_hierarchy_offset + j] = NO_ACTION_INPUT
					end
				end
			end

			self._input_queue_first_entry_became_first_entry_t = t
		end
	else
		input_queue_action_input[1] = NO_ACTION_INPUT
		input_queue_raw_input[1] = NO_RAW_INPUT

		self:_clear_action_input_queue_hierarchy(input_queue_hierarchy_position, _queue_hierarchy_offset(1, MAX_HIERARCHY_DEPTH))
	end
end

ActionInputParser.clear_input_queue_and_sequences = function (self)
	local ring_buffer_index = self._ring_buffer_index
	local input_queue = self._action_input_queue[ring_buffer_index]

	self:_clear_action_input_queue(input_queue)

	local sequences = self._sequences[ring_buffer_index]

	for i = 1, self._MAX_ACTION_INPUT_SEQUENCES do
		self:_stop_running_sequence(sequences, i)
	end

	local hierarchy_position = self._hierarchy_position[ring_buffer_index]

	self:_reset_hierarchy_position(hierarchy_position)
end

ActionInputParser.action_transitioned_with_automatic_input = function (self, action_input, t)
	if not self._player:is_human_controlled() then
		return
	end

	local ring_buffer_index = self._ring_buffer_index
	local input_queue = self._action_input_queue[ring_buffer_index]
	local input_queue_action_input = input_queue[ACTION_INPUT]
	local input_queue_hierarchy_position = input_queue[HIERARCHY_POSITION]
	local NO_ACTION_INPUT = self._NO_ACTION_INPUT
	local first_entry_action_input = input_queue_action_input[1]
	local has_first_entry = first_entry_action_input ~= NO_ACTION_INPUT
	local hierarchy_position = self._hierarchy_position[ring_buffer_index]
	local template_name = self._action_component.template_name

	if template_name == "none" then
		return
	end

	local network_lookup = self._ACTION_INPUT_NETWORK_LOOKUP[template_name]
	local sequences = self._sequences[ring_buffer_index]
	local base_hierarchy = self._ACTION_INPUT_HIERARCHY[template_name]
	local MAX_HIERARCHY_DEPTH = self._MAX_HIERARCHY_DEPTH

	if has_first_entry then
		self:_jump_hierarchy(t, hierarchy_position, input_queue_hierarchy_position, _queue_hierarchy_offset(1, MAX_HIERARCHY_DEPTH), base_hierarchy, sequences, t, network_lookup)
		self:_clear_action_input_queue(input_queue)
	end

	local hierarchy = _get_current_hierarchy(hierarchy_position, base_hierarchy, self._MAX_HIERARCHY_DEPTH, NO_ACTION_INPUT)
	local transition = ActionInputHierarchy.find_hierarchy_transition(hierarchy, action_input)
	local hierarchy_s
	local children_to_prepare = self:_handle_hierarchy_transition(transition, hierarchy_position, action_input, base_hierarchy, hierarchy)

	if children_to_prepare then
		self:_prepare_child_sequences(children_to_prepare, sequences, t, network_lookup, transition)
	end
end

ActionInputParser.bot_queue_action_input = function (self, action_input, raw_input)
	local num_bot_action_input_requests = self._num_bot_action_input_requests

	if num_bot_action_input_requests >= BOT_REQUEST_RING_BUFFER_MAX then
		local s = string.format("Reached past the ring_buffer limit (max:%i):", BOT_REQUEST_RING_BUFFER_MAX)

		for i = 1, BOT_REQUEST_RING_BUFFER_MAX do
			local request = self._bot_action_input_request_queue[i]
			local req_action_input, req_raw_input = request.action_input, request.raw_input

			s = string.format("%s\n\t%q - %q", s, req_action_input, req_raw_input)
		end

		ferror(s)
	end

	raw_input = raw_input or self._NO_RAW_INPUT

	local global_bot_request_id = self._global_bot_request_id
	local buffer_index = global_bot_request_id % BOT_REQUEST_RING_BUFFER_MAX + 1
	local request = self._bot_action_input_request_queue[buffer_index]

	request.action_input = action_input
	request.raw_input = raw_input
	request.global_bot_request_id = global_bot_request_id
	self._num_bot_action_input_requests = num_bot_action_input_requests + 1
	self._global_bot_request_id = global_bot_request_id + 1

	return global_bot_request_id
end

ActionInputParser.bot_queue_request_is_consumed = function (self, global_bot_request_id)
	local buffer_index = global_bot_request_id % BOT_REQUEST_RING_BUFFER_MAX + 1
	local request = self._bot_action_input_request_queue[buffer_index]

	if request.global_bot_request_id ~= global_bot_request_id then
		return true
	end

	return false
end

ActionInputParser.bot_queue_clear_requests = function (self, id)
	self._num_bot_action_input_requests = 0
	self._bot_action_input_current_buffer_index = self._global_bot_request_id % BOT_REQUEST_RING_BUFFER_MAX

	local NO_ACTION_INPUT = self._NO_ACTION_INPUT
	local NO_RAW_INPUT = self._NO_RAW_INPUT
	local bot_action_input_request_queue = self._bot_action_input_request_queue

	for i = 1, BOT_REQUEST_RING_BUFFER_MAX do
		local request = bot_action_input_request_queue[i]

		_reset_bot_request_entry(request, NO_ACTION_INPUT, NO_RAW_INPUT)
	end
end

ActionInputParser.pack_input_sequences_and_queue = function (self, input_sequences_is_running_table, input_sequences_current_element_index_table, input_sequences_element_start_t_table, input_queue_hierarchy_position_table, input_queue_produced_by_hierarchy_table, input_queue_action_input_table, input_queue_raw_input_table, hierarchy_position_table)
	local ring_buffer_index = self._ring_buffer_index
	local fixed_time_step = self._fixed_time_step
	local sequences = self._sequences[ring_buffer_index]
	local type_info = NetworkConstants.fixed_frame_offset_small
	local min_value = type_info.min
	local last_fixed_frame = self._last_fixed_frame
	local sequences_is_running = sequences[IS_RUNNING]
	local sequences_current_element_index = sequences[CURRENT_ELEMENT_INDEX]
	local sequences_element_start_t = sequences[ELEMENT_START_T]

	for i = 1, self._MAX_ACTION_INPUT_SEQUENCES do
		input_sequences_is_running_table[i] = sequences_is_running[i]
		input_sequences_current_element_index_table[i] = sequences_current_element_index[i]

		local element_start_frame = math.max(math.round(sequences_element_start_t[i] / fixed_time_step - last_fixed_frame), min_value)

		input_sequences_element_start_t_table[i] = element_start_frame
	end

	local MAX_HIERARCHY_DEPTH = self._MAX_HIERARCHY_DEPTH
	local template_name = self._action_component.template_name

	if template_name ~= "none" then
		local action_input_network_lookup = self._ACTION_INPUT_NETWORK_LOOKUP[template_name]
		local input_queue = self._action_input_queue[ring_buffer_index]
		local input_queue_action_input = input_queue[ACTION_INPUT]
		local input_queue_raw_input = input_queue[RAW_INPUT]
		local input_queue_hierarchy_position = input_queue[HIERARCHY_POSITION]

		for i = 1, self._MAX_ACTION_INPUT_QUEUE do
			input_queue_action_input_table[i] = action_input_network_lookup[input_queue_action_input[i]]
			input_queue_raw_input_table[i] = self._RAW_INPUTS_NETWORK_LOOKUP[input_queue_raw_input[i]]

			local hierarchy_position_offset = _queue_hierarchy_offset(i, MAX_HIERARCHY_DEPTH)
			local produced_by_hierarchy = not self:_hierarchy_position_is_base(input_queue_hierarchy_position, hierarchy_position_offset)

			input_queue_produced_by_hierarchy_table[i] = produced_by_hierarchy

			if i == 1 then
				for j = 1, MAX_HIERARCHY_DEPTH do
					local action_input = input_queue_hierarchy_position[hierarchy_position_offset + j]

					input_queue_hierarchy_position_table[j] = action_input_network_lookup[action_input]
				end
			end
		end

		local hierarchy_position = self._hierarchy_position[ring_buffer_index]

		for i = 1, MAX_HIERARCHY_DEPTH do
			local action_input = hierarchy_position[i]

			hierarchy_position_table[i] = action_input_network_lookup[action_input]
		end
	else
		for i = 1, self._MAX_ACTION_INPUT_QUEUE do
			input_queue_action_input_table[i] = 1
			input_queue_raw_input_table[i] = 1
			input_queue_produced_by_hierarchy_table[i] = false

			for j = 1, MAX_HIERARCHY_DEPTH do
				input_queue_hierarchy_position_table[j] = 1
			end
		end
	end

	local first_entry_became_first_entry_frame = self._input_queue_first_entry_became_first_entry_t / fixed_time_step
	local first_entry_became_first_entry_t_offset = math.max(first_entry_became_first_entry_frame - self._last_fixed_frame, self._fixed_frame_offset_start_t_min)

	return first_entry_became_first_entry_t_offset
end

ActionInputParser._fill_table_with_authoritative_hierarchy_position = function (self, table, input_queue_index, input_queue_produced_by_hierarchy, action_input_network_lookups, input_queue_hierarchy_position, input_queue, base_hierarchy, max_hierarchy_depth, no_action_input)
	local is_first_entry = input_queue_index == 1
	local produced_by_hierarchy = input_queue_produced_by_hierarchy[input_queue_index]
	local flattened_queue_hierarchy_position = input_queue[HIERARCHY_POSITION]

	if produced_by_hierarchy then
		if is_first_entry then
			for i = 1, max_hierarchy_depth do
				local auth_action_input = action_input_network_lookups[input_queue_hierarchy_position[i]]

				table[i] = auth_action_input
			end
		else
			local prev_hierarchy_position_offset = _queue_hierarchy_offset(input_queue_index - 1, max_hierarchy_depth)
			local hierarchy_depth = 0

			for i = 1, max_hierarchy_depth do
				hierarchy_depth = i

				local action_input = flattened_queue_hierarchy_position[prev_hierarchy_position_offset + i]

				if action_input ~= no_action_input then
					table[i] = action_input
				else
					break
				end
			end

			for i = hierarchy_depth + 1, max_hierarchy_depth do
				table[i] = no_action_input
			end

			local prev_action_input = input_queue[ACTION_INPUT][input_queue_index - 1]
			local current_hierarchy = _get_current_hierarchy(table, base_hierarchy, max_hierarchy_depth, no_action_input)
			local transition = ActionInputHierarchy.find_hierarchy_transition(current_hierarchy, prev_action_input)
			local _ = self:_handle_hierarchy_transition(transition, table, prev_action_input, base_hierarchy, current_hierarchy)
		end
	else
		for i = 1, max_hierarchy_depth do
			table[i] = no_action_input
		end
	end
end

local auth_hierarchy_position = {}

ActionInputParser.mispredict_happened = function (self, fixed_frame, input_sequences_is_running, input_sequences_current_element_index, input_sequences_element_start_t, input_qeueue_action_input, input_queue_raw_input, input_queue_produced_by_hierarchy, input_queue_hierarchy_position, input_queue_first_entry_became_first_entry_t, hierarchy_position)
	local buffer_index = (fixed_frame - 1) % RING_BUFFER_SIZE + 1

	self._ring_buffer_index = buffer_index

	self:_ensure_ring_buffer_frame(buffer_index)

	local template_name = self._action_component.template_name

	if template_name == "none" then
		self:set_active_slot(nil)

		return
	end

	self:set_active_slot(self._action_component.slot_name)

	local action_input_network_lookups = self._ACTION_INPUT_NETWORK_LOOKUP[template_name]
	local fixed_time_step = self._fixed_time_step
	local sequences = self._sequences[buffer_index]
	local sequences_is_running = sequences[IS_RUNNING]
	local sequences_current_element_index = sequences[CURRENT_ELEMENT_INDEX]
	local sequences_element_start_t = sequences[ELEMENT_START_T]

	for i = 1, self._MAX_ACTION_INPUT_SEQUENCES do
		local action_input_name = action_input_network_lookups[i]
		local is_running = input_sequences_is_running[i]
		local current_element_index = input_sequences_current_element_index[i]
		local element_start_t = (input_sequences_element_start_t[i] + fixed_frame) * fixed_time_step

		sequences_is_running[i] = is_running
		sequences_current_element_index[i] = current_element_index
		sequences_element_start_t[i] = element_start_t
	end

	local MAX_HIERARCHY_DEPTH = self._MAX_HIERARCHY_DEPTH
	local NO_ACTION_INPUT = self._NO_ACTION_INPUT
	local base_hierarchy = self._ACTION_INPUT_HIERARCHY[template_name]
	local input_queue = self._action_input_queue[buffer_index]
	local input_queue_action_input = input_queue[ACTION_INPUT]
	local flattened_input_queue_raw_input = input_queue[RAW_INPUT]
	local input_queue_hierarchy_position_flat = input_queue[HIERARCHY_POSITION]

	for i = 1, self._MAX_ACTION_INPUT_QUEUE do
		local action_input_name = action_input_network_lookups[input_qeueue_action_input[i]]
		local raw_input = self._RAW_INPUTS_NETWORK_LOOKUP[input_queue_raw_input[i]]
		local entry_hierarchy_position_offset = _queue_hierarchy_offset(i, MAX_HIERARCHY_DEPTH)

		self:_fill_table_with_authoritative_hierarchy_position(auth_hierarchy_position, i, input_queue_produced_by_hierarchy, action_input_network_lookups, input_queue_hierarchy_position, input_queue, base_hierarchy, MAX_HIERARCHY_DEPTH, NO_ACTION_INPUT)

		for j = 1, MAX_HIERARCHY_DEPTH do
			local auth_action_input = auth_hierarchy_position[j]
			local sim_action_input = input_queue_hierarchy_position_flat[entry_hierarchy_position_offset + j]

			if auth_action_input ~= sim_action_input then
				input_queue_hierarchy_position_flat[entry_hierarchy_position_offset + j] = auth_action_input
			end
		end

		input_queue_action_input[i] = action_input_name
		flattened_input_queue_raw_input[i] = raw_input
	end

	self._input_queue_first_entry_became_first_entry_t = (fixed_frame - 1) * self._fixed_time_step + input_queue_first_entry_became_first_entry_t

	local sim_hierarchy_position = self._hierarchy_position[buffer_index]

	for i = 1, MAX_HIERARCHY_DEPTH do
		local sim_action_input = sim_hierarchy_position[i]
		local auth_action_input_index = hierarchy_position[i]
		local auth_action_input = auth_action_input_index and action_input_network_lookups[auth_action_input_index] or self._NO_ACTION_INPUT

		if sim_action_input ~= auth_action_input then
			sim_hierarchy_position[i] = auth_action_input
		end
	end
end

ActionInputParser.update = function (self, dt, t)
	return
end

ActionInputParser.fixed_update = function (self, unit, dt, t, fixed_frame)
	local old_index = self._ring_buffer_index
	local new_index = (fixed_frame - 1) % RING_BUFFER_SIZE + 1

	self._ring_buffer_index = new_index

	self:_ensure_ring_buffer_frame(new_index)

	self._last_fixed_frame = fixed_frame

	local template_name = self._action_component.template_name
	local sequence_configs = self._ACTION_INPUT_SEQUENCE_CONFIGS[template_name]

	if not sequence_configs then
		return
	end

	local old_sequences = self._sequences[old_index]
	local this_frames_sequences = self._sequences[new_index]
	local old_sequences_is_running = old_sequences[IS_RUNNING]
	local old_sequences_current_element_index = old_sequences[CURRENT_ELEMENT_INDEX]
	local old_sequences_element_start_t = old_sequences[ELEMENT_START_T]
	local this_frames_sequences_is_running = this_frames_sequences[IS_RUNNING]
	local this_frames_sequences_current_element_index = this_frames_sequences[CURRENT_ELEMENT_INDEX]
	local this_frames_sequences_element_start_t = this_frames_sequences[ELEMENT_START_T]

	for i = 1, self._MAX_ACTION_INPUT_SEQUENCES do
		this_frames_sequences_is_running[i] = old_sequences_is_running[i]
		this_frames_sequences_current_element_index[i] = old_sequences_current_element_index[i]
		this_frames_sequences_element_start_t[i] = old_sequences_element_start_t[i]
	end

	local hierarchy_position = self._hierarchy_position
	local old_hierarchy_position = hierarchy_position[old_index]
	local this_frames_hierarchy_position = hierarchy_position[new_index]

	for i = 1, self._MAX_HIERARCHY_DEPTH do
		this_frames_hierarchy_position[i] = old_hierarchy_position[i]
	end

	local action_input_queue = self._action_input_queue
	local old_input_queue = action_input_queue[old_index]
	local this_frames_input_queue = action_input_queue[new_index]
	local base_hierarchy = self._ACTION_INPUT_HIERARCHY[template_name]
	local network_lookup = self._ACTION_INPUT_NETWORK_LOOKUP[template_name]

	self:_update_buffering(old_input_queue, this_frames_input_queue, t, sequence_configs, this_frames_hierarchy_position, this_frames_sequences, base_hierarchy, network_lookup)

	if self._player:is_human_controlled() then
		self:_update_sequences(dt, t, template_name, this_frames_hierarchy_position, this_frames_sequences, this_frames_input_queue)
	else
		local num_bot_action_input_requests = self._num_bot_action_input_requests

		if num_bot_action_input_requests > 0 then
			self:_update_bot_action_input_requests(self._bot_action_input_request_queue, num_bot_action_input_requests, this_frames_input_queue, this_frames_hierarchy_position, t)

			self._num_bot_action_input_requests = 0
		end
	end
end

ActionInputParser._update_buffering = function (self, old_input_queue, new_input_queue, t, sequence_configs, hierarchy_position, sequences, base_hierarchy, network_lookup)
	local sprint_character_state_component = self._sprint_character_state_component

	if Sprint.is_sprinting(sprint_character_state_component) or t < sprint_character_state_component.cooldown then
		self._input_queue_first_entry_became_first_entry_t = t
	end

	local old_input_queue_action_input = old_input_queue[ACTION_INPUT]
	local old_input_queue_raw_input = old_input_queue[RAW_INPUT]
	local old_input_queue_hierarchy_position = old_input_queue[HIERARCHY_POSITION]
	local new_input_queue_action_input = new_input_queue[ACTION_INPUT]
	local new_input_queue_raw_input = new_input_queue[RAW_INPUT]
	local new_input_queue_hierarchy_position = new_input_queue[HIERARCHY_POSITION]
	local first_action_input = old_input_queue_action_input[1]
	local has_first_entry = first_action_input ~= self._NO_ACTION_INPUT
	local sequence_config_or_nil = has_first_entry and sequence_configs[first_action_input]
	local buffer_time_or_nil = sequence_config_or_nil and sequence_config_or_nil.buffer_time
	local time_to_buffer = buffer_time_or_nil and t >= self._input_queue_first_entry_became_first_entry_t + buffer_time_or_nil or false

	if time_to_buffer then
		local action_input_config = sequence_configs[first_action_input]
		local buffer_time = action_input_config.buffer_time
		local prepare_child_t = t - buffer_time

		self:_jump_hierarchy(t, hierarchy_position, old_input_queue_hierarchy_position, _queue_hierarchy_offset(1, self._MAX_HIERARCHY_DEPTH), base_hierarchy, sequences, prepare_child_t, network_lookup)
		self:_clear_action_input_queue(new_input_queue)
	else
		for i = 1, self._MAX_ACTION_INPUT_QUEUE do
			new_input_queue_action_input[i] = old_input_queue_action_input[i]
			new_input_queue_raw_input[i] = old_input_queue_raw_input[i]

			local hierarchy_offset = _queue_hierarchy_offset(i, self._MAX_HIERARCHY_DEPTH)

			for j = 1, self._MAX_HIERARCHY_DEPTH do
				new_input_queue_hierarchy_position[hierarchy_offset + j] = old_input_queue_hierarchy_position[hierarchy_offset + j]
			end
		end
	end
end

ActionInputParser._update_bot_action_input_requests = function (self, request_queue, num_requests, this_frames_input_queue, this_frames_hierarchy_position, t)
	local NO_ACTION_INPUT = self._NO_ACTION_INPUT
	local NO_RAW_INPUT = self._NO_RAW_INPUT
	local template_name = self._action_component.template_name
	local sequence_configs = self._ACTION_INPUT_SEQUENCE_CONFIGS[template_name]
	local base_hierarchy = self._ACTION_INPUT_HIERARCHY[template_name]
	local current_buffer_index = self._bot_action_input_current_buffer_index

	for i = 1, num_requests do
		local buffer_index = current_buffer_index % BOT_REQUEST_RING_BUFFER_MAX + 1

		current_buffer_index = buffer_index

		local request = request_queue[buffer_index]
		local action_input = request.action_input
		local raw_input = request.raw_input
		local sequence_config = sequence_configs[action_input]

		if not sequence_config then
			Log.info("ActionInputParser", "No sequence_config found. Player: %q", self._player:name())
			Log.info("ActionInputParser", "Could not find matching input_sequence for queued action_input %q in template %q", action_input, template_name)
		end

		if sequence_config then
			self:_queue_action_input(this_frames_input_queue, sequence_config, t, raw_input, this_frames_hierarchy_position, base_hierarchy)
		end

		_reset_bot_request_entry(request, NO_ACTION_INPUT, NO_RAW_INPUT)
	end

	self._bot_action_input_current_buffer_index = current_buffer_index
end

ActionInputParser._update_sequences = function (self, dt, t, template_name, hierarchy_position, sequences, input_queue)
	local this_frames_inputs = self:_this_frames_inputs(self._input_extension)
	local sequence_configs = self._ACTION_INPUT_SEQUENCE_CONFIGS[template_name]
	local network_lookup = self._ACTION_INPUT_NETWORK_LOOKUP[template_name]
	local MAX_HIERARCHY_DEPTH, NO_ACTION_INPUT = self._MAX_HIERARCHY_DEPTH, self._NO_ACTION_INPUT
	local base_hierarchy = self._ACTION_INPUT_HIERARCHY[template_name]
	local hierarchy = _get_current_hierarchy(hierarchy_position, base_hierarchy, MAX_HIERARCHY_DEPTH, NO_ACTION_INPUT)
	local sequences_is_running = sequences[IS_RUNNING]
	local sequences_current_element_index = sequences[CURRENT_ELEMENT_INDEX]
	local action_input_sequence_completed, action_input_sequence_config, action_input_raw_input

	for _, entry in ipairs(hierarchy) do
		local action_input = entry.input
		local sequence_config = sequence_configs[action_input]
		local sequence_i = network_lookup[action_input]
		local element_index = sequences_current_element_index[sequence_i]
		local element_config_or_nil = sequence_config.elements[element_index]
		local element_failed, element_completed, raw_input, _, auto_completed = self:_evaluate_element(element_config_or_nil, this_frames_inputs, sequences, sequence_i, t)

		self._last_action_auto_completed = auto_completed

		if element_failed and sequences_is_running[sequence_i] then
			self:_stop_running_sequence(sequences, sequence_i)
		elseif element_completed then
			local sequence_completed = self:_progress_input_sequence(sequences, sequence_i, t, sequence_config, input_queue, raw_input, hierarchy_position)

			if sequence_completed then
				action_input_sequence_completed = action_input
				action_input_sequence_config = sequence_config
				action_input_raw_input = raw_input

				break
			end
		end
	end

	if action_input_sequence_completed ~= nil then
		local dont_queue = action_input_sequence_config.dont_queue
		local hierarchy_transition_override, preserved_sequence_state
		local is_combat_ability_wield = action_input_sequence_completed == "wield" and action_input_raw_input == "combat_ability_pressed"
		local is_holding_attack = this_frames_inputs.action_one_hold
		local is_in_action_hierarchy = not self:_hierarchy_position_is_base(hierarchy_position)
		local should_preserve_heavy_charge = is_combat_ability_wield and is_holding_attack and is_in_action_hierarchy and self:_should_preserve_heavy_on_combat_ability()

		if should_preserve_heavy_charge then
			preserved_sequence_state = self:_snapshot_hierarchy_sequence_state(hierarchy, sequences, network_lookup)
			dont_queue = true
			hierarchy_transition_override = "stay"
		end

		self:_stop_running_sequences_from_hierarchy(hierarchy, sequences, network_lookup)

		if not dont_queue then
			local queued_action_input = self:_queue_action_input(input_queue, action_input_sequence_config, t, action_input_raw_input, hierarchy_position, base_hierarchy)

			if not queued_action_input then
				local wanted_hierarchy = input_queue[HIERARCHY_POSITION]

				self:_clear_action_input_queue(input_queue, 2)
				self:_jump_hierarchy(t, hierarchy_position, wanted_hierarchy, _queue_hierarchy_offset(1, MAX_HIERARCHY_DEPTH), base_hierarchy, sequences, t, network_lookup)

				return
			end

			hierarchy = _get_current_hierarchy(hierarchy_position, base_hierarchy, MAX_HIERARCHY_DEPTH, NO_ACTION_INPUT)
		end

		local hierarchy_transition = hierarchy_transition_override or ActionInputHierarchy.find_hierarchy_transition(hierarchy, action_input_sequence_completed)
		local children_to_prepare = self:_handle_hierarchy_transition(hierarchy_transition, hierarchy_position, action_input_sequence_completed, base_hierarchy, hierarchy)

		if children_to_prepare then
			self:_prepare_child_sequences(children_to_prepare, sequences, t, network_lookup, hierarchy_transition)

			if preserved_sequence_state then
				self:_restore_hierarchy_sequence_state(preserved_sequence_state, sequences, network_lookup)
			end
		end
	end
end

local PRESERVE_HEAVY_ON_COMBAT_ABILITY_GROUPS = {
	adamant_stance = true,
	broker_punk_rage_stance = true,
	ogryn_taunt_shout = true,
	psyker_overcharge_stance = true,
	veteran_stealth = true,
	zealot_dash = true,
	zealot_invisibility = true,
}

ActionInputParser._should_preserve_heavy_on_combat_ability = function (self)
	local ability_extension = ScriptUnit.extension(self._unit, "ability_system")
	local combat_ability = ability_extension:ability_is_equipped("combat_ability")
	local ability_group = combat_ability and combat_ability.ability_group

	return ability_group and PRESERVE_HEAVY_ON_COMBAT_ABILITY_GROUPS[ability_group] or false
end

ActionInputParser._snapshot_hierarchy_sequence_state = function (self, hierarchy, sequences, network_lookup)
	local state = {}
	local sequences_current_element_index = sequences[CURRENT_ELEMENT_INDEX]
	local sequences_element_start_t = sequences[ELEMENT_START_T]

	for _, child in ipairs(hierarchy) do
		local action_input = child.input
		local sequence_i = network_lookup[action_input]

		state[action_input] = {
			element_index = sequences_current_element_index[sequence_i],
			element_start_t = sequences_element_start_t[sequence_i],
		}
	end

	return state
end

ActionInputParser._restore_hierarchy_sequence_state = function (self, state, sequences, network_lookup)
	local sequences_current_element_index = sequences[CURRENT_ELEMENT_INDEX]
	local sequences_element_start_t = sequences[ELEMENT_START_T]

	for action_input, saved in pairs(state) do
		local sequence_i = network_lookup[action_input]

		sequences_current_element_index[sequence_i] = saved.element_index
		sequences_element_start_t[sequence_i] = saved.element_start_t
	end
end

ActionInputParser._handle_hierarchy_transition = function (self, transition, hierarchy_position, action_input, base_hierarchy, current_hierarchy)
	local child_sequences_to_prepare

	if type(transition) == "table" then
		self:_progress_hierarchy_position(hierarchy_position, action_input)

		child_sequences_to_prepare = transition
	elseif transition == "previous" then
		self:_regress_hierarchy_position(hierarchy_position)

		child_sequences_to_prepare = _get_current_hierarchy(hierarchy_position, base_hierarchy, self._MAX_HIERARCHY_DEPTH, self._NO_ACTION_INPUT)
	elseif transition == "base" then
		self:_reset_hierarchy_position(hierarchy_position)

		local base_entry = ActionInputHierarchy.find_hierarchy_transition(base_hierarchy, action_input)

		if base_entry and type(base_entry) == "table" then
			self:_progress_hierarchy_position(hierarchy_position, action_input)

			child_sequences_to_prepare = base_entry
		end
	elseif transition == "stay" then
		child_sequences_to_prepare = current_hierarchy
	end

	return child_sequences_to_prepare
end

ActionInputParser._reset_hierarchy_position = function (self, hierarchy_position)
	for i = 1, self._MAX_HIERARCHY_DEPTH do
		hierarchy_position[i] = self._NO_ACTION_INPUT
	end
end

ActionInputParser._progress_hierarchy_position = function (self, hierarchy_position, action_input)
	for i = 1, self._MAX_HIERARCHY_DEPTH do
		if hierarchy_position[i] == self._NO_ACTION_INPUT then
			hierarchy_position[i] = action_input

			return
		end
	end

	ferror("Progressed past MAX_HIERARCHY_DEPTH %q", self._MAX_HIERARCHY_DEPTH)
end

ActionInputParser._regress_hierarchy_position = function (self, hierarchy_position)
	local NO_ACTION_INPUT = self._NO_ACTION_INPUT

	for i = self._MAX_HIERARCHY_DEPTH, 1, -1 do
		if hierarchy_position[i] ~= NO_ACTION_INPUT then
			hierarchy_position[i] = NO_ACTION_INPUT

			return
		end
	end

	ferror("Tried regress empty hierarchy_position.")
end

ActionInputParser._jump_hierarchy = function (self, t, hierarchy_position, wanted_hierarchy_position, wanted_hierarchy_position_offset, base_hierarchy, sequences, prepare_child_t, network_lookup)
	local MAX_HIERARCHY_DEPTH = self._MAX_HIERARCHY_DEPTH
	local NO_ACTION_INPUT = self._NO_ACTION_INPUT
	local current_hierarchy = _get_current_hierarchy(hierarchy_position, base_hierarchy, MAX_HIERARCHY_DEPTH, NO_ACTION_INPUT)

	self:_stop_running_sequences_from_hierarchy(current_hierarchy, sequences, network_lookup)

	for i = 1, MAX_HIERARCHY_DEPTH do
		hierarchy_position[i] = wanted_hierarchy_position[wanted_hierarchy_position_offset + i]
	end

	local hierarchy = _get_current_hierarchy(hierarchy_position, base_hierarchy, MAX_HIERARCHY_DEPTH, NO_ACTION_INPUT)

	self:_prepare_child_sequences(hierarchy, sequences, prepare_child_t, network_lookup)
end

ActionInputParser._prepare_child_sequences = function (self, children, sequences, t, network_lookup, transition)
	local sequences_is_running = sequences[IS_RUNNING]
	local sequences_current_element_index = sequences[CURRENT_ELEMENT_INDEX]
	local sequences_element_start_t = sequences[ELEMENT_START_T]

	for _, child in ipairs(children) do
		local action_input = child.input
		local sequence_i = network_lookup[action_input]

		if sequences_is_running[sequence_i] then
			self:_stop_running_sequence(sequences, sequence_i)
		end

		sequences_is_running[sequence_i] = true
		sequences_current_element_index[sequence_i] = 1

		if transition ~= "stay" then
			sequences_element_start_t[sequence_i] = t
		end
	end
end

local temp_inputs = {}

ActionInputParser._this_frames_inputs = function (self, input_extension)
	for i = 1, #raw_inputs do
		local raw_input = raw_inputs[i]

		temp_inputs[raw_input] = input_extension:get(raw_input)
	end

	return temp_inputs
end

ActionInputParser._has_running_sequences = function (self, sequences)
	local sequences_is_running = sequences[IS_RUNNING]

	for i = 1, self._MAX_ACTION_INPUT_SEQUENCES do
		if sequences_is_running[i] then
			return true
		end
	end

	return false
end

ActionInputParser._evaluate_element = function (self, element_config_or_nil, this_frames_input, sequences, sequence_i, t)
	if element_config_or_nil == nil then
		return false, false, nil, "", false
	end

	local element_config = element_config_or_nil
	local has_input, raw_input = self:_evaluate_input(element_config, this_frames_input)
	local duration = element_config.duration
	local time_window = element_config.time_window
	local hold_input = element_config.hold_input or self._input_aliases[element_config.hold_input_alias]
	local element_failed, element_completed, auto_completed = false, false, false
	local fail_reason = ""

	if duration then
		local start_t = sequences[ELEMENT_START_T][sequence_i]
		local element_duration = t - start_t
		local held_duration = duration <= element_duration

		if held_duration then
			element_completed = true
		elseif not has_input then
			element_failed = true
			fail_reason = "No input during duration"
		end
	elseif time_window then
		local start_t = sequences[ELEMENT_START_T][sequence_i]
		local element_duration = t - start_t
		local within_time_window = element_duration <= time_window

		if has_input and within_time_window then
			element_completed = true
		elseif not within_time_window and element_config.auto_complete then
			auto_completed = true
			element_completed = true
		elseif not within_time_window then
			element_failed = true
			fail_reason = "No input within time window"
		end
	elseif hold_input then
		local any_true = false

		if has_input then
			if type(hold_input) == "table" then
				for hold_input_i = 1, #hold_input do
					if this_frames_input[hold_input[hold_input_i]] then
						any_true = true

						break
					end
				end
			elseif this_frames_input[hold_input] then
				any_true = true
			end
		end

		if any_true then
			element_completed = true
		else
			element_failed = true
			fail_reason = "Released hold input"
		end
	elseif has_input then
		element_completed = true
	else
		element_failed = true
		fail_reason = "No input"
	end

	return element_failed, element_completed, raw_input, fail_reason, auto_completed
end

ActionInputParser._evaluate_input = function (self, input_config, this_frames_input)
	local actual_input_config = input_config
	local input_setting = input_config.input_setting

	if input_setting and this_frames_input[input_setting.setting] == input_setting.setting_value then
		actual_input_config = input_setting
	end

	local inputs = actual_input_config.inputs

	if inputs then
		if actual_input_config.input_mode == "all" then
			local all_true = true
			local true_alias_or_nil

			for inputs_i = 1, #inputs do
				local array_input_config = inputs[inputs_i]
				local input = array_input_config.input or self._input_aliases[array_input_config.input_alias]
				local value = array_input_config.value

				if type(input) == "table" then
					local any_true = false

					for input_i = 1, #input do
						if this_frames_input[input[input_i]] == value then
							true_alias_or_nil = input[input_i]
							any_true = true
						end
					end

					if not any_true then
						all_true = false
					end
				elseif this_frames_input[input] ~= value then
					all_true = false
				end
			end

			if all_true then
				return true, inputs[1].input or true_alias_or_nil
			end
		else
			for inputs_i = 1, #inputs do
				local array_input_config = inputs[inputs_i]
				local input = array_input_config.input or self._input_aliases[array_input_config.input_alias]
				local value = array_input_config.value

				if type(input) == "table" then
					for input_i = 1, #input do
						if this_frames_input[input[input_i]] == value then
							return true, input[input_i]
						end
					end
				elseif this_frames_input[input] == value then
					return true, input
				end
			end
		end

		return false
	else
		local input = actual_input_config.input or self._input_aliases[actual_input_config.input_alias]
		local value = actual_input_config.value

		if type(input) == "table" then
			for input_i = 1, #input do
				if this_frames_input[input[input_i]] == value then
					return true, input[input_i]
				end
			end

			return false, input
		end

		return this_frames_input[input] == value, input
	end
end

ActionInputParser._progress_input_sequence = function (self, sequences, sequence_i, t, sequence_config, this_frames_input_queue, raw_input, hierarchy_position)
	local completed_sequence
	local sequences_is_running = sequences[IS_RUNNING]
	local sequences_current_element_index = sequences[CURRENT_ELEMENT_INDEX]
	local sequences_element_start_t = sequences[ELEMENT_START_T]
	local elements = sequence_config.elements
	local next_index = sequences_current_element_index[sequence_i] + 1

	if elements[next_index] then
		sequences_is_running[sequence_i] = true
		sequences_current_element_index[sequence_i] = next_index
		sequences_element_start_t[sequence_i] = t
		completed_sequence = false
	else
		self:_stop_running_sequence(sequences, sequence_i)

		completed_sequence = true
	end

	return completed_sequence
end

ActionInputParser._stop_running_sequence = function (self, sequences, sequence_i)
	sequences[IS_RUNNING][sequence_i] = false
	sequences[CURRENT_ELEMENT_INDEX][sequence_i] = 1
end

ActionInputParser._queue_action_input = function (self, action_input_queue, sequence_config, t, raw_input, hierarchy_position, base_hierarchy)
	local action_input_name = sequence_config.action_input_name
	local action_input_queue_action_input = action_input_queue[ACTION_INPUT]
	local action_input_queue_raw_input = action_input_queue[RAW_INPUT]
	local action_input_queue_hierarchy_position = action_input_queue[HIERARCHY_POSITION]

	self:_clear_action_input_queue_from_matching_hierarchy_position(action_input_queue, action_input_name, hierarchy_position, base_hierarchy)

	local max_queue = sequence_config.max_queue

	if max_queue then
		self:_manipulate_queue_by_max_queue(action_input_queue, action_input_name, max_queue)
	end

	local next_entry_index = 0
	local has_space = false

	for i = 1, self._MAX_ACTION_INPUT_QUEUE do
		if action_input_queue_action_input[i] == self._NO_ACTION_INPUT then
			next_entry_index = i
			has_space = true

			break
		end
	end

	if not has_space then
		next_entry_index = self:_manipulate_queue_by_no_space(action_input_queue, action_input_name, hierarchy_position)
	end

	if not next_entry_index then
		return false
	end

	local added_entry_index
	local previous_entry_index = next_entry_index - 1
	local previous_entry_hierarchy_offset = previous_entry_index > 0 and _queue_hierarchy_offset(previous_entry_index, self._MAX_HIERARCHY_DEPTH)

	if previous_entry_hierarchy_offset and action_input_queue_action_input[previous_entry_index] == action_input_name and self:_same_hierarchy_position(action_input_queue_hierarchy_position, hierarchy_position, previous_entry_hierarchy_offset) then
		action_input_queue_raw_input[previous_entry_index] = raw_input
		added_entry_index = previous_entry_index
	else
		action_input_queue_action_input[next_entry_index] = action_input_name
		action_input_queue_raw_input[next_entry_index] = raw_input

		local entry_hierarchy_position_offset = _queue_hierarchy_offset(next_entry_index, self._MAX_HIERARCHY_DEPTH)

		for i = 1, self._MAX_HIERARCHY_DEPTH do
			action_input_queue_hierarchy_position[entry_hierarchy_position_offset + i] = hierarchy_position[i]
		end

		added_entry_index = next_entry_index
	end

	if added_entry_index == 1 then
		self._input_queue_first_entry_became_first_entry_t = t
	end

	return true
end

ActionInputParser._manipulate_queue_by_max_queue = function (self, action_input_queue, action_input_name, max_queue)
	local action_input_queue_action_input = action_input_queue[ACTION_INPUT]
	local last_occurrence_of_action_input
	local times_queued = 0

	for i = 1, self._MAX_ACTION_INPUT_QUEUE do
		local queued_action_input = action_input_queue_action_input[i]

		if queued_action_input == self._NO_ACTION_INPUT then
			break
		elseif queued_action_input == action_input_name then
			times_queued = times_queued + 1
			last_occurrence_of_action_input = i
		end
	end

	if max_queue <= times_queued then
		local clear_from = last_occurrence_of_action_input

		self:_clear_action_input_queue(action_input_queue, clear_from)

		for i = 1, self._MAX_ACTION_INPUT_QUEUE do
			local queued_action_input = action_input_queue_action_input[i]

			if queued_action_input == self._NO_ACTION_INPUT then
				break
			end
		end
	end
end

ActionInputParser._manipulate_queue_by_no_space = function (self, action_input_queue, action_input_name, hierarchy_position)
	local MAX_ACTION_INPUT_QUEUE = self._MAX_ACTION_INPUT_QUEUE
	local NO_ACTION_INPUT = self._NO_ACTION_INPUT
	local NO_RAW_INPUT = self._NO_RAW_INPUT
	local MAX_HIERARCHY_DEPTH = self._MAX_HIERARCHY_DEPTH
	local action_input_queue_action_input = action_input_queue[ACTION_INPUT]
	local action_input_queue_raw_input = action_input_queue[RAW_INPUT]
	local action_input_queue_hierarchy_position = action_input_queue[HIERARCHY_POSITION]
	local matching_entry_index

	for i = MAX_ACTION_INPUT_QUEUE, 1, -1 do
		local entry_hierarchy_position_offset = _queue_hierarchy_offset(i, MAX_HIERARCHY_DEPTH)

		if self:_same_hierarchy_position(hierarchy_position, action_input_queue_hierarchy_position, nil, entry_hierarchy_position_offset) then
			matching_entry_index = i

			break
		end
	end

	if not matching_entry_index then
		local template_name = self._action_component.template_name
		local action_input_to_queue_s = string.format("%s %s", action_input_name, _hierarchy_string(hierarchy_position, MAX_HIERARCHY_DEPTH, NO_ACTION_INPUT))
		local action_input_queue_s = _input_queue_string(action_input_queue, MAX_ACTION_INPUT_QUEUE, NO_ACTION_INPUT, MAX_HIERARCHY_DEPTH)
		local exception_message = string.format("Failed modifying queue. %q %s\n%s", template_name, action_input_to_queue_s, action_input_queue_s)

		Crashify.print_exception("ActionInputParser", exception_message)

		return nil
	end

	for i = matching_entry_index, MAX_ACTION_INPUT_QUEUE do
		action_input_queue_action_input[i] = NO_ACTION_INPUT
		action_input_queue_raw_input[i] = NO_RAW_INPUT

		local remove_entry_hierarchy_position_offset = _queue_hierarchy_offset(i, MAX_HIERARCHY_DEPTH)

		for j = 1, MAX_HIERARCHY_DEPTH do
			action_input_queue_hierarchy_position[remove_entry_hierarchy_position_offset + j] = NO_ACTION_INPUT
		end
	end

	return matching_entry_index
end

ActionInputParser._hierarchy_depth = function (self, hierarchy_position)
	local NO_ACTION_INPUT = self._NO_ACTION_INPUT
	local MAX_HIERARCHY_DEPTH = self._MAX_HIERARCHY_DEPTH

	for i = 1, MAX_HIERARCHY_DEPTH do
		local action_input = hierarchy_position[i]

		if action_input == NO_ACTION_INPUT then
			return i - 1
		end
	end

	return MAX_HIERARCHY_DEPTH
end

ActionInputParser._clear_action_input_queue_hierarchy = function (self, hierarchy_position, hierarchy_position_offset)
	local NO_ACTION_INPUT = self._NO_ACTION_INPUT

	hierarchy_position_offset = hierarchy_position_offset or 0

	for i = 1, self._MAX_HIERARCHY_DEPTH do
		hierarchy_position[hierarchy_position_offset + i] = NO_ACTION_INPUT
	end
end

ActionInputParser._clear_action_input_queue = function (self, input_queue, start_index)
	start_index = start_index or 1

	local input_queue_action_input = input_queue[ACTION_INPUT]
	local input_queue_raw_input = input_queue[RAW_INPUT]
	local input_queue_hierarchy_position = input_queue[HIERARCHY_POSITION]

	for i = start_index, self._MAX_ACTION_INPUT_QUEUE do
		if input_queue_action_input[i] == self._NO_ACTION_INPUT then
			break
		else
			input_queue_action_input[i] = self._NO_ACTION_INPUT
			input_queue_raw_input[i] = self._NO_RAW_INPUT

			self:_clear_action_input_queue_hierarchy(input_queue_hierarchy_position, _queue_hierarchy_offset(i, self._MAX_HIERARCHY_DEPTH))
		end
	end
end

ActionInputParser._clear_action_input_queue_from_matching_hierarchy_position = function (self, input_queue, action_input, hierarchy_position, base_hierarchy)
	local clear_from_index
	local NO_ACTION_INPUT = self._NO_ACTION_INPUT
	local MAX_HIERARCHY_DEPTH = self._MAX_HIERARCHY_DEPTH
	local input_queue_action_input = input_queue[ACTION_INPUT]
	local input_queue_hierarchy_position = input_queue[HIERARCHY_POSITION]

	for i = 1, self._MAX_ACTION_INPUT_QUEUE do
		if input_queue_action_input[i] == NO_ACTION_INPUT then
			return
		end

		local entry_hierarchy_position_offset = _queue_hierarchy_offset(i, MAX_HIERARCHY_DEPTH)

		if self:_same_hierarchy_position(input_queue_hierarchy_position, hierarchy_position, entry_hierarchy_position_offset) then
			clear_from_index = i

			break
		end

		local entry_hierarchy = _get_current_hierarchy(input_queue_hierarchy_position, base_hierarchy, MAX_HIERARCHY_DEPTH, NO_ACTION_INPUT, entry_hierarchy_position_offset)
		local transition = ActionInputHierarchy.find_hierarchy_transition(entry_hierarchy, action_input)

		if transition ~= nil then
			clear_from_index = i

			for ii = 1, MAX_HIERARCHY_DEPTH do
				hierarchy_position[ii] = input_queue_hierarchy_position[entry_hierarchy_position_offset + ii]
			end

			break
		end
	end

	if clear_from_index then
		self:_clear_action_input_queue(input_queue, clear_from_index)
	end
end

ActionInputParser._same_hierarchy_position = function (self, hieararchy_a, hierarchy_b, hierarchy_a_offset, hierarchy_b_offset)
	local same_hierarchy_position = true

	hierarchy_a_offset = hierarchy_a_offset or 0
	hierarchy_b_offset = hierarchy_b_offset or 0

	for i = 1, self._MAX_HIERARCHY_DEPTH do
		if hieararchy_a[hierarchy_a_offset + i] ~= hierarchy_b[hierarchy_b_offset + i] then
			same_hierarchy_position = false

			break
		end
	end

	return same_hierarchy_position
end

ActionInputParser._hierarchy_position_is_base = function (self, hierarchy_position, hierarchy_position_offset)
	hierarchy_position_offset = hierarchy_position_offset or 0

	local is_base = hierarchy_position[hierarchy_position_offset + 1] == self._NO_ACTION_INPUT

	return is_base
end

ActionInputParser._stop_running_sequences_from_hierarchy = function (self, hierarchy, sequences, network_lookup)
	local sequences_is_running = sequences[IS_RUNNING]

	for _, entry in ipairs(hierarchy) do
		local action_input = entry.input
		local sequence_i = network_lookup[action_input]

		if sequences_is_running[sequence_i] then
			self:_stop_running_sequence(sequences, sequence_i)
		end
	end
end

function _get_current_hierarchy(hierarchy_position, hierarchy, max_hierarchy_depth, no_action_input, hierarchy_position_offset)
	local current_hierarchy = hierarchy

	hierarchy_position_offset = hierarchy_position_offset or 0

	for i = 1, max_hierarchy_depth do
		local position = hierarchy_position[hierarchy_position_offset + i]

		if position == no_action_input then
			break
		end

		local found_entry = ActionInputHierarchy.find_hierarchy_entry(current_hierarchy, position)

		current_hierarchy = found_entry.transition

		if type(current_hierarchy) ~= "table" then
			break
		end
	end

	return current_hierarchy
end

function _hierarchy_string(hierarchy_position, max_hierarchy_depth, no_action_input, hierarchy_position_offset)
	local hierarchy_string = "["

	hierarchy_position_offset = hierarchy_position_offset or 0

	for i = 1, max_hierarchy_depth do
		local action_input = hierarchy_position[hierarchy_position_offset + i]

		if action_input == no_action_input then
			break
		end

		if i > 1 then
			hierarchy_string = string.format("%s - ", hierarchy_string)
		end

		hierarchy_string = string.format("%s%s", hierarchy_string, action_input)
	end

	hierarchy_string = string.format("%s]", hierarchy_string)

	return hierarchy_string
end

function _queue_hierarchy_offset(input_queue_index, max_hierarchy_depth)
	return (input_queue_index - 1) * max_hierarchy_depth
end

function _reset_bot_request_entry(entry, action_input, raw_input)
	entry.action_input = action_input
	entry.raw_input = raw_input
	entry.global_bot_request_id = -1
end

function _input_queue_string(action_input_queue, MAX_ACTION_INPUT_QUEUE, NO_ACTION_INPUT, MAX_HIERARCHY_DEPTH)
	local s = "[ action_input_queue\n"
	local action_input_queue_action_input = action_input_queue[ACTION_INPUT]
	local action_input_queue_hierarchy_position = action_input_queue[HIERARCHY_POSITION]

	for i = 1, MAX_ACTION_INPUT_QUEUE do
		local action_input = action_input_queue_action_input[i]
		local entry_s

		if action_input ~= NO_ACTION_INPUT then
			local hierarchy_offset = _queue_hierarchy_offset(i, MAX_HIERARCHY_DEPTH)
			local hierarchy_s = _hierarchy_string(action_input_queue_hierarchy_position, MAX_HIERARCHY_DEPTH, NO_ACTION_INPUT, hierarchy_offset)

			entry_s = string.format("%s %s", action_input, hierarchy_s)
		else
			entry_s = "empty"
		end

		s = string.format("%s\t[%i] %s\n", s, i, entry_s)
	end

	s = string.format("%s]", s)

	return s
end

return ActionInputParser

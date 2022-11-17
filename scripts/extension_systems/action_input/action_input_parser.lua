local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local wield_inputs = PlayerCharacterConstants.wield_inputs
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
	"weapon_reload",
	"weapon_reload_hold",
	"wield_scroll_down",
	"wield_scroll_up",
	"quick_wield",
	"weapon_inspect_hold",
	"weapon_extra_pressed",
	"weapon_extra_hold",
	"weapon_extra_release"
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
local _get_current_hierarchy, _hierarchy_string, _reset_bot_request_entry, _input_queue_string = nil
local ActionInputParser = class("ActionInputParser")

ActionInputParser.init = function (self, unit, action_component_name, action_component, config_data, debug_index)
	local action_input_type = config_data.action_input_type
	local templates = config_data.templates
	local action_extension = config_data.action_extension
	self._config_data = config_data
	self._input_extension = ScriptUnit.extension(unit, "input_system")
	self._action_component_name = action_component_name
	self._action_component = action_component
	local sequences_ring_buffer = Script.new_array(RING_BUFFER_SIZE)
	self._sequences = sequences_ring_buffer
	local action_input_queue_ring_buffer = Script.new_array(RING_BUFFER_SIZE)
	self._action_input_queue = action_input_queue_ring_buffer
	local hierarchy_position_ring_buffer = Script.new_array(RING_BUFFER_SIZE)
	self._hierarchy_position = hierarchy_position_ring_buffer
	self._ring_buffer_index = 1
	self._debug_index = debug_index
	self._input_queue_first_entry_became_first_entry_t = 0
	self._fixed_frame_offset_start_t_min = NetworkConstants.fixed_frame_offset_start_t_5bit.min

	self:_format_and_initialize_action_inputs(action_input_type, templates, sequences_ring_buffer, action_input_queue_ring_buffer, hierarchy_position_ring_buffer)

	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	self._player = player_unit_spawn_manager:owner(unit)
	local bot_action_input_request_queue = Script.new_array(BOT_REQUEST_RING_BUFFER_MAX)
	self._bot_action_input_request_queue = bot_action_input_request_queue
	self._global_bot_request_id = 0
	self._num_bot_action_input_requests = 0
	self._bot_action_input_current_buffer_index = 0
	local NO_ACTION_INPUT = self._NO_ACTION_INPUT
	local NO_RAW_INPUT = self._NO_RAW_INPUT

	for i = 1, BOT_REQUEST_RING_BUFFER_MAX do
		local entry = {}

		_reset_bot_request_entry(entry, NO_ACTION_INPUT, NO_RAW_INPUT)

		bot_action_input_request_queue[i] = entry
	end

	self._last_fixed_frame = 0
	self._last_action_auto_completed = false
end

ActionInputParser._format_and_initialize_action_inputs = function (self, action_input_type, templates, sequences_ring_buffer, action_input_queue_ring_buffer, hierarchy_position_ring_buffer)
	self._ACTION_INPUT_SEQUENCE_CONFIGS, self._ACTION_INPUT_NETWORK_LOOKUP, self._ACTION_INPUT_HIERARCHY, self._RAW_INPUTS_NETWORK_LOOKUP, self._MAX_ACTION_INPUT_SEQUENCES, self._MAX_ACTION_INPUT_QUEUE, self._MAX_HIERARCHY_DEPTH, self._NO_ACTION_INPUT, self._NO_RAW_INPUT = ActionInputFormatter.format(action_input_type, templates, raw_inputs)
	local NO_RAW_INPUT = self._NO_RAW_INPUT
	local NO_ACTION_INPUT = self._NO_ACTION_INPUT
	local MAX_ACTION_INPUT_SEQUENCES = self._MAX_ACTION_INPUT_SEQUENCES
	local MAX_ACTION_INPUT_QUEUE = self._MAX_ACTION_INPUT_QUEUE
	local MAX_HIERARCHY_DEPTH = self._MAX_HIERARCHY_DEPTH

	for i = 1, RING_BUFFER_SIZE do
		local sequences = Script.new_array(MAX_ACTION_INPUT_SEQUENCES)

		for j = 1, MAX_ACTION_INPUT_SEQUENCES do
			sequences[j] = {
				[IS_RUNNING] = false,
				[CURRENT_ELEMENT_INDEX] = 1,
				[ELEMENT_START_T] = 0
			}
		end

		sequences_ring_buffer[i] = sequences
		local action_input_queue = Script.new_array(MAX_ACTION_INPUT_QUEUE)

		for j = 1, MAX_ACTION_INPUT_QUEUE do
			action_input_queue[j] = {
				[ACTION_INPUT] = NO_ACTION_INPUT,
				[RAW_INPUT] = NO_RAW_INPUT,
				[HIERARCHY_POSITION] = {
					NO_ACTION_INPUT,
					NO_ACTION_INPUT,
					NO_ACTION_INPUT,
					NO_ACTION_INPUT
				}
			}
		end

		action_input_queue_ring_buffer[i] = action_input_queue
		local hierarchy_position = Script.new_array(MAX_HIERARCHY_DEPTH)

		for j = 1, MAX_HIERARCHY_DEPTH do
			hierarchy_position[j] = NO_ACTION_INPUT
		end

		hierarchy_position_ring_buffer[i] = hierarchy_position
	end
end

ActionInputParser.on_reload = function (self)
	local c = self._config_data

	self:_format_and_initialize_action_inputs(c.action_input_type, c.templates, self._sequences, self._action_input_queue, self._hierarchy_position)
end

ActionInputParser.peek_next_input = function (self)
	local entry = self._action_input_queue[self._ring_buffer_index][1]
	local action_input = entry[ACTION_INPUT]

	if action_input == self._NO_ACTION_INPUT then
		return nil, nil
	else
		return action_input, entry[RAW_INPUT]
	end
end

ActionInputParser.last_action_auto_completed = function (self)
	return self._last_action_auto_completed
end

ActionInputParser.consume_next_input = function (self, t)
	local ring_buffer_index = self._ring_buffer_index
	local input_queue = self._action_input_queue[ring_buffer_index]
	local hierarchy_position = self._hierarchy_position[ring_buffer_index]
	local first_entry = input_queue[1]
	local MAX_ACTION_INPUT_QUEUE = self._MAX_ACTION_INPUT_QUEUE
	local MAX_HIERARCHY_DEPTH = self._MAX_HIERARCHY_DEPTH
	local NO_ACTION_INPUT = self._NO_ACTION_INPUT
	local NO_RAW_INPUT = self._NO_RAW_INPUT
	local second_entry = input_queue[2]

	if second_entry[ACTION_INPUT] ~= NO_ACTION_INPUT then
		local first_entry_action_input = first_entry[ACTION_INPUT]
		local template_name = self._action_component.template_name
		local sequence_configs = self._ACTION_INPUT_SEQUENCE_CONFIGS[template_name]
		local sequence_config = sequence_configs[first_entry_action_input]
		local reevaluation_time = sequence_config.reevaluation_time
		local time_before_consuming_or_nil = reevaluation_time and t - self._input_queue_first_entry_became_first_entry_t

		if time_before_consuming_or_nil and reevaluation_time <= time_before_consuming_or_nil then
			local base_hierarchy = self._ACTION_INPUT_HIERARCHY[template_name]
			local network_lookup = self._ACTION_INPUT_NETWORK_LOOKUP[template_name]
			local sequences = self._sequences[ring_buffer_index]
			local second_entry_hierarchy_position = second_entry[HIERARCHY_POSITION]

			self:_jump_hierarchy(hierarchy_position, second_entry_hierarchy_position, base_hierarchy, sequences, t, network_lookup)
			self:_clear_action_input_queue(input_queue)
		else
			for i = 1, MAX_ACTION_INPUT_QUEUE do
				local entry = input_queue[i]
				local next_entry = input_queue[i + 1]

				if next_entry then
					entry[ACTION_INPUT] = next_entry[ACTION_INPUT]
					entry[RAW_INPUT] = next_entry[RAW_INPUT]
					local entry_hierarchy = entry[HIERARCHY_POSITION]
					local next_entry_hierarchy = next_entry[HIERARCHY_POSITION]

					for j = 1, MAX_HIERARCHY_DEPTH do
						entry_hierarchy[j] = next_entry_hierarchy[j]
					end
				else
					entry[ACTION_INPUT] = NO_ACTION_INPUT
					entry[RAW_INPUT] = NO_RAW_INPUT
					local entry_hierarchy = entry[HIERARCHY_POSITION]

					for j = 1, MAX_HIERARCHY_DEPTH do
						entry_hierarchy[j] = NO_ACTION_INPUT
					end
				end
			end

			self._input_queue_first_entry_became_first_entry_t = t
		end
	else
		first_entry[ACTION_INPUT] = NO_ACTION_INPUT
		first_entry[RAW_INPUT] = NO_RAW_INPUT
		local first_entry_hierarchy_position = first_entry[HIERARCHY_POSITION]

		self:_clear_action_input_queue_hierarchy(first_entry_hierarchy_position)
	end
end

ActionInputParser.clear_input_queue_and_sequences = function (self)
	local ring_buffer_index = self._ring_buffer_index
	local input_queue = self._action_input_queue[ring_buffer_index]

	self:_clear_action_input_queue(input_queue)

	local sequences = self._sequences[ring_buffer_index]

	for i = 1, self._MAX_ACTION_INPUT_SEQUENCES do
		local sequence = sequences[i]

		self:_stop_running_sequence(sequence)
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
	local NO_ACTION_INPUT = self._NO_ACTION_INPUT
	local first_entry = input_queue[1]
	local first_entry_action_input = first_entry[ACTION_INPUT]
	local has_first_entry = first_entry_action_input ~= NO_ACTION_INPUT
	local hierarchy_position = self._hierarchy_position[ring_buffer_index]
	local template_name = self._action_component.template_name
	local network_lookup = self._ACTION_INPUT_NETWORK_LOOKUP[template_name]
	local sequences = self._sequences[ring_buffer_index]
	local base_hierarchy = self._ACTION_INPUT_HIERARCHY[template_name]
	local MAX_HIERARCHY_DEPTH = self._MAX_HIERARCHY_DEPTH

	if has_first_entry then
		local wanted_hierarchy_position = first_entry[HIERARCHY_POSITION]

		self:_jump_hierarchy(hierarchy_position, wanted_hierarchy_position, base_hierarchy, sequences, t, network_lookup)
		self:_clear_action_input_queue(input_queue)
	end

	local hierarchy = _get_current_hierarchy(hierarchy_position, base_hierarchy, self._MAX_HIERARCHY_DEPTH, NO_ACTION_INPUT)
	local transition = hierarchy[action_input]
	local hierarchy_s = nil
	local children_to_prepare = self:_handle_hierarchy_transition(transition, hierarchy_position, action_input, base_hierarchy, hierarchy)

	if children_to_prepare then
		self:_prepare_child_sequences(children_to_prepare, sequences, t, network_lookup)
	end
end

ActionInputParser.bot_queue_action_input = function (self, action_input, raw_input)
	local num_bot_action_input_requests = self._num_bot_action_input_requests

	if BOT_REQUEST_RING_BUFFER_MAX <= num_bot_action_input_requests then
		local s = string.format("Reached past the ring_buffer limit (max:%i):", BOT_REQUEST_RING_BUFFER_MAX)

		for i = 1, BOT_REQUEST_RING_BUFFER_MAX do
			local request = self._bot_action_input_request_queue[i]
			local req_action_input = request.action_input
			local req_raw_input = request.raw_input
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
	local fixed_time_step = GameParameters.fixed_time_step
	local sequences = self._sequences[ring_buffer_index]
	local type_info = NetworkConstants.fixed_frame_offset_small
	local min_value = type_info.min
	local last_fixed_frame = self._last_fixed_frame

	for i = 1, self._MAX_ACTION_INPUT_SEQUENCES do
		local sequence = sequences[i]
		input_sequences_is_running_table[i] = sequence[IS_RUNNING]
		input_sequences_current_element_index_table[i] = sequence[CURRENT_ELEMENT_INDEX]
		local element_start_frame = math.max(math.round(sequence[ELEMENT_START_T] / fixed_time_step - last_fixed_frame), min_value)
		input_sequences_element_start_t_table[i] = element_start_frame
	end

	local MAX_HIERARCHY_DEPTH = self._MAX_HIERARCHY_DEPTH
	local template_name = self._action_component.template_name

	if template_name ~= "none" then
		local action_input_network_lookup = self._ACTION_INPUT_NETWORK_LOOKUP[template_name]
		local input_queue = self._action_input_queue[ring_buffer_index]

		for i = 1, self._MAX_ACTION_INPUT_QUEUE do
			local entry = input_queue[i]
			input_queue_action_input_table[i] = action_input_network_lookup[entry[ACTION_INPUT]]
			input_queue_raw_input_table[i] = self._RAW_INPUTS_NETWORK_LOOKUP[entry[RAW_INPUT]]
			local hierarchy_position = entry[HIERARCHY_POSITION]
			local produced_by_hierarchy = not self:_hierarchy_position_is_base(hierarchy_position)
			input_queue_produced_by_hierarchy_table[i] = produced_by_hierarchy

			if i == 1 then
				for j = 1, MAX_HIERARCHY_DEPTH do
					local action_input = hierarchy_position[j]
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

	if produced_by_hierarchy then
		if is_first_entry then
			for i = 1, max_hierarchy_depth do
				local auth_action_input = action_input_network_lookups[input_queue_hierarchy_position[i]]
				table[i] = auth_action_input
			end
		else
			local prev_entry = input_queue[input_queue_index - 1]
			local prev_hierarchy_position = prev_entry[HIERARCHY_POSITION]
			local hierarchy_depth = 0

			for i = 1, max_hierarchy_depth do
				hierarchy_depth = i
				local action_input = prev_hierarchy_position[i]

				if action_input ~= no_action_input then
					table[i] = action_input
				else
					break
				end
			end

			for i = hierarchy_depth + 1, max_hierarchy_depth do
				table[i] = no_action_input
			end

			local prev_action_input = prev_entry[ACTION_INPUT]
			local current_hierarchy = _get_current_hierarchy(table, base_hierarchy, max_hierarchy_depth, no_action_input)
			local transition = current_hierarchy[prev_action_input]
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
	local template_name = self._action_component.template_name

	if template_name == "none" then
		return
	end

	local action_input_network_lookups = self._ACTION_INPUT_NETWORK_LOOKUP[template_name]
	local fixed_time_step = GameParameters.fixed_time_step
	local sequences = self._sequences[buffer_index]

	for i = 1, self._MAX_ACTION_INPUT_SEQUENCES do
		local sequence = sequences[i]
		local action_input_name = action_input_network_lookups[i]
		local is_running = input_sequences_is_running[i]
		local current_element_index = input_sequences_current_element_index[i]
		local element_start_t = (input_sequences_element_start_t[i] + fixed_frame) * fixed_time_step
		sequence[IS_RUNNING] = is_running
		sequence[CURRENT_ELEMENT_INDEX] = current_element_index
		sequence[ELEMENT_START_T] = element_start_t
	end

	local MAX_HIERARCHY_DEPTH = self._MAX_HIERARCHY_DEPTH
	local NO_ACTION_INPUT = self._NO_ACTION_INPUT
	local base_hierarchy = self._ACTION_INPUT_HIERARCHY[template_name]
	local input_queue = self._action_input_queue[buffer_index]

	for i = 1, self._MAX_ACTION_INPUT_QUEUE do
		local action_input_name = action_input_network_lookups[input_qeueue_action_input[i]]
		local raw_input = self._RAW_INPUTS_NETWORK_LOOKUP[input_queue_raw_input[i]]
		local entry = input_queue[i]
		local entry_hierarchy_position = entry[HIERARCHY_POSITION]

		self:_fill_table_with_authoritative_hierarchy_position(auth_hierarchy_position, i, input_queue_produced_by_hierarchy, action_input_network_lookups, input_queue_hierarchy_position, input_queue, base_hierarchy, MAX_HIERARCHY_DEPTH, NO_ACTION_INPUT)

		for j = 1, MAX_HIERARCHY_DEPTH do
			local auth_action_input = auth_hierarchy_position[j]
			local sim_action_input = entry_hierarchy_position[j]

			if auth_action_input ~= sim_action_input then
				entry_hierarchy_position[j] = auth_action_input
			end
		end

		entry[ACTION_INPUT] = action_input_name
		entry[RAW_INPUT] = raw_input
	end

	self._input_queue_first_entry_became_first_entry_t = (fixed_frame - 1) * GameParameters.fixed_time_step + input_queue_first_entry_became_first_entry_t
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
	self._last_fixed_frame = fixed_frame
	local template_name = self._action_component.template_name
	local sequence_configs = self._ACTION_INPUT_SEQUENCE_CONFIGS[template_name]

	if not sequence_configs then
		return
	end

	local old_sequences = self._sequences[old_index]
	local this_frames_sequences = self._sequences[new_index]

	for i = 1, self._MAX_ACTION_INPUT_SEQUENCES do
		local old_sequence = old_sequences[i]
		local new_sequence = this_frames_sequences[i]

		for j = 1, #old_sequence do
			new_sequence[j] = old_sequence[j]
		end
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
	local first_entry = old_input_queue[1]
	local first_action_input = first_entry[ACTION_INPUT]
	local has_first_entry = first_action_input ~= self._NO_ACTION_INPUT
	local sequence_config_or_nil = has_first_entry and sequence_configs[first_action_input]
	local buffer_time_or_nil = sequence_config_or_nil and sequence_config_or_nil.buffer_time
	local time_to_buffer = buffer_time_or_nil and t >= self._input_queue_first_entry_became_first_entry_t + buffer_time_or_nil or false

	if time_to_buffer then
		local first_entry_hierarchy_position = first_entry[HIERARCHY_POSITION]
		local action_input_config = sequence_configs[first_action_input]
		local buffer_time = action_input_config.buffer_time
		local prepare_child_t = t - buffer_time

		self:_jump_hierarchy(hierarchy_position, first_entry_hierarchy_position, base_hierarchy, sequences, prepare_child_t, network_lookup)
		self:_clear_action_input_queue(new_input_queue)
	else
		for i = 1, self._MAX_ACTION_INPUT_QUEUE do
			local old_entry = old_input_queue[i]
			local new_entry = new_input_queue[i]
			new_entry[ACTION_INPUT] = old_entry[ACTION_INPUT]
			new_entry[RAW_INPUT] = old_entry[RAW_INPUT]
			local new_entry_hierarchy = new_entry[HIERARCHY_POSITION]
			local old_entry_hierarchy = old_entry[HIERARCHY_POSITION]

			for j = 1, self._MAX_HIERARCHY_DEPTH do
				new_entry_hierarchy[j] = old_entry_hierarchy[j]
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
	local MAX_HIERARCHY_DEPTH = self._MAX_HIERARCHY_DEPTH
	local NO_ACTION_INPUT = self._NO_ACTION_INPUT
	local base_hierarchy = self._ACTION_INPUT_HIERARCHY[template_name]
	local hierarchy = _get_current_hierarchy(hierarchy_position, base_hierarchy, MAX_HIERARCHY_DEPTH, NO_ACTION_INPUT)
	local action_input_sequence_completed, action_input_sequence_config, action_input_raw_input = nil

	for action_input, children in pairs(hierarchy) do
		local sequence_config = sequence_configs[action_input]
		local sequence_i = network_lookup[action_input]
		local sequence = sequences[sequence_i]
		local element_index = sequence[CURRENT_ELEMENT_INDEX]
		local element_config_or_nil = sequence_config.elements[element_index]
		local element_failed, element_completed, raw_input, fail_reason, auto_completed = self:_evaluate_element(element_config_or_nil, this_frames_inputs, sequence, t)
		self._last_action_auto_completed = auto_completed

		if element_failed and sequence[IS_RUNNING] then
			self:_stop_running_sequence(sequence)
		elseif element_completed then
			local sequence_completed = self:_progress_input_sequence(sequence, t, sequence_config, input_queue, raw_input, hierarchy_position)

			if sequence_completed then
				action_input_sequence_completed = action_input
				action_input_sequence_config = sequence_config
				action_input_raw_input = raw_input

				break
			end
		end
	end

	if action_input_sequence_completed ~= nil then
		self:_stop_running_sequences_from_hierarchy(hierarchy, sequences, network_lookup)

		local dont_queue = action_input_sequence_config.dont_queue

		if not dont_queue then
			local queued_action_input = self:_queue_action_input(input_queue, action_input_sequence_config, t, action_input_raw_input, hierarchy_position, base_hierarchy)

			if not queued_action_input then
				local first_entry = input_queue[1]
				local wanted_hierarchy = first_entry[HIERARCHY_POSITION]

				self:_clear_action_input_queue(input_queue, 2)
				self:_jump_hierarchy(hierarchy_position, wanted_hierarchy, base_hierarchy, sequences, t, network_lookup)

				return
			end

			hierarchy = _get_current_hierarchy(hierarchy_position, base_hierarchy, MAX_HIERARCHY_DEPTH, NO_ACTION_INPUT)
		end

		local hierarchy_transition = hierarchy[action_input_sequence_completed]
		local children_to_prepare = self:_handle_hierarchy_transition(hierarchy_transition, hierarchy_position, action_input_sequence_completed, base_hierarchy, hierarchy)

		if children_to_prepare then
			self:_prepare_child_sequences(children_to_prepare, sequences, t, network_lookup)
		end
	end
end

ActionInputParser._handle_hierarchy_transition = function (self, transition, hierarchy_position, action_input, base_hierarchy, current_hierarchy)
	local child_sequences_to_prepare = nil

	if type(transition) == "table" then
		self:_progress_hierarchy_position(hierarchy_position, action_input)

		child_sequences_to_prepare = transition
	elseif transition == "previous" then
		self:_regress_hierarchy_position(hierarchy_position)

		child_sequences_to_prepare = _get_current_hierarchy(hierarchy_position, base_hierarchy, self._MAX_HIERARCHY_DEPTH, self._NO_ACTION_INPUT)
	elseif transition == "base" then
		self:_reset_hierarchy_position(hierarchy_position)

		local base_hierarchy_transition = base_hierarchy[action_input]

		if type(base_hierarchy_transition) == "table" then
			self:_progress_hierarchy_position(hierarchy_position, action_input)

			child_sequences_to_prepare = base_hierarchy_transition
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

ActionInputParser._jump_hierarchy = function (self, hierarchy_position, wanted_hierarchy_position, base_hierarchy, sequences, prepare_child_t, network_lookup)
	local MAX_HIERARCHY_DEPTH = self._MAX_HIERARCHY_DEPTH
	local NO_ACTION_INPUT = self._NO_ACTION_INPUT
	local current_hierarchy = _get_current_hierarchy(hierarchy_position, base_hierarchy, MAX_HIERARCHY_DEPTH, NO_ACTION_INPUT)

	self:_stop_running_sequences_from_hierarchy(current_hierarchy, sequences, network_lookup)

	for i = 1, MAX_HIERARCHY_DEPTH do
		hierarchy_position[i] = wanted_hierarchy_position[i]
	end

	local hierarchy = _get_current_hierarchy(hierarchy_position, base_hierarchy, MAX_HIERARCHY_DEPTH, NO_ACTION_INPUT)

	self:_prepare_child_sequences(hierarchy, sequences, prepare_child_t, network_lookup)
end

ActionInputParser._prepare_child_sequences = function (self, children, sequences, t, network_lookup)
	for action_input, _ in pairs(children) do
		local sequence_i = network_lookup[action_input]
		local sequence = sequences[sequence_i]

		if sequence[IS_RUNNING] then
			self:_stop_running_sequence(sequence)
		end

		sequence[IS_RUNNING] = true
		sequence[CURRENT_ELEMENT_INDEX] = 1
		sequence[ELEMENT_START_T] = t
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
	for i = 1, self._MAX_ACTION_INPUT_SEQUENCES do
		local sequence = sequences[i]

		if sequence[IS_RUNNING] then
			return true
		end
	end

	return false
end

ActionInputParser._evaluate_element = function (self, element_config_or_nil, this_frames_input, sequence, t)
	if element_config_or_nil == nil then
		return false, false, nil, "", false
	end

	local element_config = element_config_or_nil
	local has_input, raw_input = self:_evaluate_input(element_config, this_frames_input)
	local duration = element_config.duration
	local time_window = element_config.time_window
	local hold_input = element_config.hold_input
	local element_failed = false
	local element_completed = false
	local auto_completed = false
	local fail_reason = ""

	if duration then
		local start_t = sequence[ELEMENT_START_T]
		local element_duration = t - start_t
		local held_duration = duration <= element_duration

		if held_duration then
			element_completed = true
		elseif not has_input then
			element_failed = true
			fail_reason = "No input during duration"
		end
	elseif time_window then
		local start_t = sequence[ELEMENT_START_T]
		local element_duration = t - start_t
		local within_time_window = time_window >= element_duration

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
		if this_frames_input[hold_input] then
			if has_input then
				element_completed = true
			end
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
	local inputs = input_config.inputs

	if inputs then
		if input_config.input_mode == "all" then
			local all_true = true

			for i = 1, #inputs do
				local array_input_config = inputs[i]
				local input = array_input_config.input
				local value = array_input_config.value

				if this_frames_input[input] ~= value then
					all_true = false
				end
			end

			if all_true then
				return true, inputs[1].input
			end
		else
			for i = 1, #inputs do
				local array_input_config = inputs[i]
				local input = array_input_config.input
				local value = array_input_config.value

				if this_frames_input[input] == value then
					return true, input
				end
			end
		end

		return false
	else
		local input = input_config.input
		local value = input_config.value

		return this_frames_input[input] == value, input
	end
end

ActionInputParser._progress_input_sequence = function (self, sequence, t, sequence_config, this_frames_input_queue, raw_input, hierarchy_position)
	local completed_sequence = nil
	local elements = sequence_config.elements
	local next_index = sequence[CURRENT_ELEMENT_INDEX] + 1

	if elements[next_index] then
		sequence[IS_RUNNING] = true
		sequence[CURRENT_ELEMENT_INDEX] = next_index
		sequence[ELEMENT_START_T] = t
		completed_sequence = false
	else
		self:_stop_running_sequence(sequence)

		completed_sequence = true
	end

	return completed_sequence
end

ActionInputParser._stop_running_sequence = function (self, sequence)
	sequence[IS_RUNNING] = false
	sequence[CURRENT_ELEMENT_INDEX] = 1
end

ActionInputParser._queue_action_input = function (self, action_input_queue, sequence_config, t, raw_input, hierarchy_position, base_hierarchy)
	local action_input_name = sequence_config.action_input_name

	self:_clear_action_input_queue_from_matching_hierarchy_position(action_input_queue, action_input_name, hierarchy_position, base_hierarchy)

	local max_queue = sequence_config.max_queue

	if max_queue then
		self:_manipulate_queue_by_max_queue(action_input_queue, action_input_name, max_queue)
	end

	local next_entry_index = 0
	local has_space = false

	for i = 1, self._MAX_ACTION_INPUT_QUEUE do
		local entry = action_input_queue[i]

		if entry[ACTION_INPUT] == self._NO_ACTION_INPUT then
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

	local added_entry_index = nil
	local previous_entry_index = next_entry_index - 1
	local previous_entry = action_input_queue[previous_entry_index]

	if previous_entry and previous_entry[ACTION_INPUT] == action_input_name and self:_same_hierarchy_position(previous_entry[HIERARCHY_POSITION], hierarchy_position) then
		previous_entry[RAW_INPUT] = raw_input
		added_entry_index = previous_entry_index
	else
		local entry = action_input_queue[next_entry_index]
		entry[ACTION_INPUT] = action_input_name
		entry[RAW_INPUT] = raw_input
		local entry_hierarchy_position = entry[HIERARCHY_POSITION]

		for i = 1, self._MAX_HIERARCHY_DEPTH do
			entry_hierarchy_position[i] = hierarchy_position[i]
		end

		added_entry_index = next_entry_index
	end

	if added_entry_index == 1 then
		self._input_queue_first_entry_became_first_entry_t = t
	end

	return true
end

ActionInputParser._manipulate_queue_by_max_queue = function (self, action_input_queue, action_input_name, max_queue)
	local last_occurrence_of_action_input = nil
	local times_queued = 0

	for i = 1, self._MAX_ACTION_INPUT_QUEUE do
		local entry = action_input_queue[i]
		local queued_action_input = entry[ACTION_INPUT]

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
			local entry = action_input_queue[i]
			local queued_action_input = entry[ACTION_INPUT]

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
	local matching_entry_index = nil

	for i = MAX_ACTION_INPUT_QUEUE, 1, -1 do
		local entry = action_input_queue[i]
		local entry_hierarchy_position = entry[HIERARCHY_POSITION]

		if self:_same_hierarchy_position(hierarchy_position, entry_hierarchy_position) then
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
		local remove_entry = action_input_queue[i]
		remove_entry[ACTION_INPUT] = NO_ACTION_INPUT
		remove_entry[RAW_INPUT] = NO_RAW_INPUT
		local remove_entry_hierarchy_position = remove_entry[HIERARCHY_POSITION]

		for j = 1, MAX_HIERARCHY_DEPTH do
			remove_entry_hierarchy_position[j] = NO_ACTION_INPUT
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

ActionInputParser._clear_action_input_queue_hierarchy = function (self, hierarchy_position)
	local NO_ACTION_INPUT = self._NO_ACTION_INPUT

	for i = 1, self._MAX_HIERARCHY_DEPTH do
		hierarchy_position[i] = NO_ACTION_INPUT
	end
end

ActionInputParser._clear_action_input_queue = function (self, input_queue, start_index)
	start_index = start_index or 1

	for i = start_index, self._MAX_ACTION_INPUT_QUEUE do
		local entry = input_queue[i]

		if entry[ACTION_INPUT] == self._NO_ACTION_INPUT then
			break
		else
			entry[ACTION_INPUT] = self._NO_ACTION_INPUT
			entry[RAW_INPUT] = self._NO_RAW_INPUT
			local hierarchy_position = entry[HIERARCHY_POSITION]

			self:_clear_action_input_queue_hierarchy(hierarchy_position)
		end
	end
end

ActionInputParser._clear_action_input_queue_from_matching_hierarchy_position = function (self, input_queue, action_input, hierarchy_position, base_hierarchy)
	local clear_from_index = nil
	local NO_ACTION_INPUT = self._NO_ACTION_INPUT
	local MAX_HIERARCHY_DEPTH = self._MAX_HIERARCHY_DEPTH

	for i = 1, self._MAX_ACTION_INPUT_QUEUE do
		local entry = input_queue[i]

		if entry[ACTION_INPUT] == NO_ACTION_INPUT then
			return
		end

		local entry_hierarchy_position = entry[HIERARCHY_POSITION]

		if self:_same_hierarchy_position(entry_hierarchy_position, hierarchy_position) then
			clear_from_index = i

			break
		end

		local entry_hierarchy = _get_current_hierarchy(entry_hierarchy_position, base_hierarchy, MAX_HIERARCHY_DEPTH, NO_ACTION_INPUT)

		if entry_hierarchy[action_input] ~= nil then
			clear_from_index = i

			for ii = 1, MAX_HIERARCHY_DEPTH do
				hierarchy_position[ii] = entry_hierarchy_position[ii]
			end

			break
		end
	end

	if clear_from_index then
		self:_clear_action_input_queue(input_queue, clear_from_index)
	end
end

ActionInputParser._same_hierarchy_position = function (self, hieararchy_a, hierarchy_b)
	local same_hierarchy_position = true

	for i = 1, self._MAX_HIERARCHY_DEPTH do
		if hieararchy_a[i] ~= hierarchy_b[i] then
			same_hierarchy_position = false

			break
		end
	end

	return same_hierarchy_position
end

ActionInputParser._hierarchy_position_is_base = function (self, hierarchy_position)
	local is_base = hierarchy_position[1] == self._NO_ACTION_INPUT

	return is_base
end

ActionInputParser._stop_running_sequences_from_hierarchy = function (self, hierarchy, sequences, network_lookup)
	for action_input, _ in pairs(hierarchy) do
		local sequence_i = network_lookup[action_input]
		local sequence = sequences[sequence_i]

		if sequence[IS_RUNNING] then
			self:_stop_running_sequence(sequence)
		end
	end
end

function _get_current_hierarchy(hierarchy_position, hierarchy, max_hierarchy_depth, no_action_input)
	for i = 1, max_hierarchy_depth do
		local position = hierarchy_position[i]

		if position == no_action_input then
			break
		end

		hierarchy = hierarchy[position]
	end

	return hierarchy
end

function _hierarchy_string(hierarchy_position, max_hierarchy_depth, no_action_input)
	local hierarchy_string = "["

	for i = 1, max_hierarchy_depth do
		local action_input = hierarchy_position[i]

		if action_input == no_action_input then
			break
		end

		if i > 1 then
			hierarchy_string = string.format("%s - ", hierarchy_string)
		end

		hierarchy_string = string.format("%s%s", hierarchy_string, hierarchy_position[i])
	end

	hierarchy_string = string.format("%s]", hierarchy_string)

	return hierarchy_string
end

function _reset_bot_request_entry(entry, action_input, raw_input)
	entry.action_input = action_input
	entry.raw_input = raw_input
	entry.global_bot_request_id = -1
end

function _input_queue_string(action_input_queue, MAX_ACTION_INPUT_QUEUE, NO_ACTION_INPUT, MAX_HIERARCHY_DEPTH)
	local s = "[ action_input_queue\n"

	for i = 1, MAX_ACTION_INPUT_QUEUE do
		local entry = action_input_queue[i]
		local action_input = entry[ACTION_INPUT]
		local entry_s = nil

		if action_input ~= NO_ACTION_INPUT then
			local hierarchy_pos = entry[HIERARCHY_POSITION]
			local hierarchy_s = _hierarchy_string(hierarchy_pos, MAX_HIERARCHY_DEPTH, NO_ACTION_INPUT)
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

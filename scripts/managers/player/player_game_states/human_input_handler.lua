-- chunkname: @scripts/managers/player/player_game_states/human_input_handler.lua

local InputHandlerSettings = require("scripts/managers/player/player_game_states/input_handler_settings")
local HumanInputHandler = class("HumanInputHandler")

if HumanInputHandler.reloaded == nil then
	HumanInputHandler.reloaded = false
else
	HumanInputHandler.reloaded = true
end

HumanInputHandler.init = function (self, player, is_server, client_clock_handler)
	self._service = nil
	self._is_server = is_server
	self._last_frame_acknowledged = -1
	self._last_frame_parsed = -1

	if is_server then
		self._frame = 0
	else
		self._frame = nil
		self._last_sent_frame = nil
		self._client_clock_handler = client_clock_handler
	end

	self._player = player

	local settings = InputHandlerSettings
	local input_buffer_size = settings.client_input_buffer_size

	self._input_buffer_size = input_buffer_size
	self._send_buffer_size = settings.buffered_frames

	local num_actions = #settings.actions

	self._num_actions = num_actions
	self._in_panic = false

	local input_cache = Script.new_array(num_actions + 2)
	local action_lookup = {}

	for i, action in ipairs(settings.actions) do
		input_cache[i] = Script.new_array(input_buffer_size)
		action_lookup[action] = i
	end

	local num_ephemeral_actions = #settings.ephemeral_actions

	self._num_ephemeral_actions = num_ephemeral_actions

	local ephemeral_action_cache = {}

	for i, ephemeral_action in ipairs(settings.ephemeral_actions) do
		local index = num_actions + i

		input_cache[index] = Script.new_array(input_buffer_size)
		action_lookup[ephemeral_action] = index
		ephemeral_action_cache[i] = false
	end

	local num_ui_interaction_actions = #settings.ui_interaction_actions

	self._num_ui_interaction_actions = num_ui_interaction_actions

	local ui_interaction_action_cache = {}

	for i, ui_interaction_action in ipairs(settings.ui_interaction_actions) do
		local index = num_actions + num_ephemeral_actions + i

		input_cache[index] = Script.new_array(input_buffer_size)
		action_lookup[ui_interaction_action] = index
		ui_interaction_action_cache[i] = false
	end

	self._action_lookup = action_lookup
	self._ephemeral_action_cache = ephemeral_action_cache
	self._ui_interaction_action_cache = ui_interaction_action_cache
	self._actions = settings.actions
	self._ephemeral_actions = settings.ephemeral_actions
	self._ui_interaction_actions = settings.ui_interaction_actions
	self._yaw_index = num_actions + num_ephemeral_actions + num_ui_interaction_actions + 1

	local yaw_cache = Script.new_array(input_buffer_size, 0)

	yaw_cache[input_buffer_size] = 0
	input_cache[self._yaw_index] = yaw_cache
	self._pitch_index = self._yaw_index + 1

	local pitch_cache = Script.new_array(input_buffer_size, 0)

	pitch_cache[input_buffer_size] = 0
	input_cache[self._pitch_index] = pitch_cache
	self._roll_index = self._pitch_index + 1

	local roll_cache = Script.new_array(input_buffer_size, 0)

	roll_cache[input_buffer_size] = 0
	input_cache[self._roll_index] = roll_cache

	local account_data = Managers.save:account_data()

	self._input_settings_table = account_data.input_settings

	local num_input_settings = #settings.input_settings

	self._num_input_settings = num_input_settings

	for i, input_setting in ipairs(settings.input_settings) do
		local index = self._roll_index + i

		input_cache[index] = Script.new_array(input_buffer_size)
		action_lookup[input_setting] = index
	end

	local action_network_type = settings.action_network_type
	local pack_unpack_action_to_network_type_index = {}

	self._pack_unpack_action_to_network_type_index = pack_unpack_action_to_network_type_index

	local pack_unpack_actions = settings.pack_unpack_actions

	self._pack_unpack_actions = pack_unpack_actions

	local num_pack_unpack_actions = #pack_unpack_actions

	self._num_pack_unpack_actions = num_pack_unpack_actions

	for i = 1, num_pack_unpack_actions do
		local action = pack_unpack_actions[i]

		pack_unpack_action_to_network_type_index[action] = Network.type_index(action_network_type[action])
	end

	self._input_settings = settings.input_settings
	self._input_cache = input_cache

	local input_cache_size = #input_cache

	self._send_array = Script.new_array(input_cache_size)

	for i = 1, input_cache_size do
		self._send_array[i] = {}
	end
end

HumanInputHandler.initialize_client_fixed_frame = function (self, frame, input_service, yaw, pitch, roll)
	self._frame = frame
	self._last_frame_acknowledged = frame
	self._last_frame_parsed = frame

	local index = self:_buffer_index(frame)
	local cache = self._input_cache

	self:_parse_input(cache, input_service, index)

	cache[self._yaw_index][index] = yaw
	cache[self._pitch_index][index] = pitch
	cache[self._roll_index][index] = roll
end

HumanInputHandler._buffer_index = function (self, frame)
	if self._last_frame_parsed and frame <= self._last_frame_parsed then
		frame = self._frame
	end

	return (frame - 1) % self._input_buffer_size + 1
end

HumanInputHandler.pre_update = function (self, dt, t, input_service, ui_interaction_action)
	local ui_inputs_in_use = Managers.ui:inputs_in_use()

	for i = 1, self._num_ephemeral_actions do
		local old_value = self._ephemeral_action_cache[i]
		local new_value = old_value or input_service:get_with_filters(self._ephemeral_actions[i], ui_inputs_in_use)

		self._ephemeral_action_cache[i] = old_value or new_value
	end

	for i = 1, self._num_ui_interaction_actions do
		local old_value = self._ui_interaction_action_cache[i]
		local new_value = false

		for name, value in pairs(ui_interaction_action) do
			if self._ui_interaction_actions[i] == name then
				new_value = value

				break
			end
		end

		self._ui_interaction_action_cache[i] = old_value or new_value
	end
end

HumanInputHandler.fixed_update = function (self, dt, t, frame, input_service, yaw, pitch, roll)
	Log.debug("HumanInputHandler", "Fixed update frame: %i", frame)

	if self._frame then
		if HumanInputHandler.reloaded then
			HumanInputHandler.reloaded = false
			self._frame = frame
		else
			self._frame = self._frame + 1
		end
	end

	local index = self:_buffer_index(frame)
	local cache = self._input_cache

	self:_parse_input(cache, input_service, index)

	cache[self._yaw_index][index] = yaw
	cache[self._pitch_index][index] = pitch
	cache[self._roll_index][index] = roll
end

HumanInputHandler.get_orientation = function (self, frame)
	local index = self:_buffer_index(frame)
	local cache = self._input_cache
	local y, p, r = cache[self._yaw_index][index], cache[self._pitch_index][index], cache[self._roll_index][index]

	return y, p, r
end

HumanInputHandler.get = function (self, action, frame)
	local index = self:_buffer_index(frame)
	local action_lookup = self._action_lookup[action]

	return self._input_cache[action_lookup][index]
end

HumanInputHandler._parse_input = function (self, input_cache, input_service, index)
	if index < 1 then
		ferror("Trying to fill non-positive index to input cache.")
	end

	local ui_inputs_in_use = Managers.ui:inputs_in_use()
	local actions = self._actions
	local num_actions = self._num_actions
	local num_ephemeral_actions = self._num_ephemeral_actions

	for i = 1, num_actions do
		local action = actions[i]

		input_cache[i][index] = input_service:get_with_filters(action, ui_inputs_in_use)
	end

	local ephemeral_action_cache = self._ephemeral_action_cache

	for i = 1, num_ephemeral_actions do
		input_cache[num_actions + i][index] = ephemeral_action_cache[i]
		ephemeral_action_cache[i] = false
	end

	local ui_interaction_action_cache = self._ui_interaction_action_cache

	for i = 1, self._num_ui_interaction_actions do
		local pos = num_actions + num_ephemeral_actions + i

		input_cache[pos][index] = ui_interaction_action_cache[i]
		ui_interaction_action_cache[i] = false
	end

	local action_lookup = self._action_lookup
	local settings = self._input_settings

	for i = 1, self._num_input_settings do
		local input_setting = settings[i]
		local cache_index = action_lookup[input_setting]

		input_cache[cache_index][index] = self._input_settings_table[input_setting]
	end

	local pack_unpack_action_to_network_type_index = self._pack_unpack_action_to_network_type_index
	local pack_unpack_actions = self._pack_unpack_actions

	for i = 1, self._num_pack_unpack_actions do
		local action = pack_unpack_actions[i]
		local cache_index = action_lookup[action]
		local network_type_index = pack_unpack_action_to_network_type_index[action]

		input_cache[cache_index][index] = Network.pack_unpack(network_type_index, input_cache[cache_index][index])
	end
end

HumanInputHandler.update = function (self, dt, t, input_service)
	local frame = self._frame
	local last_frame_acknowledged = self._last_frame_acknowledged
	local last_sent_frame = self._last_sent_frame

	if self._is_server then
		self:frame_parsed(frame)
	elseif frame and last_frame_acknowledged < frame and (not last_sent_frame or last_sent_frame < frame) and Managers.state.game_session:can_send_session_bound_rpcs() then
		local input_cache = self._input_cache
		local start_frame
		local send_buffer_size = self._send_buffer_size

		if send_buffer_size < frame - last_frame_acknowledged then
			start_frame = frame - send_buffer_size + 1
		else
			start_frame = last_frame_acknowledged + 1
		end

		local end_frame_offset = frame - start_frame
		local send_array = self._send_array
		local start_index = self:_buffer_index(start_frame)
		local end_index = self:_buffer_index(start_frame + end_frame_offset)

		if start_index <= end_index then
			for i = 1, #input_cache do
				local _input_cache = input_cache[i]
				local _send_array = send_array[i]

				for j = start_index, end_index do
					_send_array[j - start_index + 1] = _input_cache[j]
				end
			end
		else
			local max_index = self._input_buffer_size
			local wrap_offset = max_index - start_index + 1

			for i = 1, #input_cache do
				local _input_cache = input_cache[i]
				local _send_array = send_array[i]

				for j = start_index, max_index do
					_send_array[j - start_index + 1] = _input_cache[j]
				end

				for j = 1, end_index do
					_send_array[wrap_offset + j] = _input_cache[j]
				end
			end
		end

		local curr_send_size = #send_array[1]

		for i = 1, #send_array do
			local _send_array = send_array[i]

			for j = 2 + end_frame_offset, curr_send_size do
				_send_array[j] = nil
			end
		end

		Managers.state.game_session:send_rpc_server("rpc_player_input_array", self._player:local_player_id(), start_frame, end_frame_offset, unpack(send_array))

		self._last_sent_frame = frame
	end
end

HumanInputHandler.rpc_player_input_array_ack = function (self, channel_id, local_player_id, frame)
	self:frame_acknowledged(frame)
end

HumanInputHandler.frame_parsed = function (self, frame, remainder_time, frame_time)
	if frame > self._last_frame_parsed then
		self._last_frame_parsed = frame

		if not self._is_server then
			self._client_clock_handler:frame_parsed(frame, remainder_time, frame_time)
		end

		if self._last_frame_acknowledged < self._last_frame_parsed then
			self._last_frame_acknowledged = self._last_frame_parsed
		end
	end
end

HumanInputHandler.frame_acknowledged = function (self, frame)
	if frame > self._last_frame_acknowledged then
		self._last_frame_acknowledged = frame
	end
end

HumanInputHandler.had_received_input = function (self, fixed_frame)
	return true
end

HumanInputHandler.in_panic = function (self)
	return self._in_panic
end

HumanInputHandler.set_in_panic = function (self, in_panic)
	self._in_panic = in_panic

	self._client_clock_handler:set_in_panic(in_panic)
end

return HumanInputHandler

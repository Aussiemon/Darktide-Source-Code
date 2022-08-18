local InputHandlerSettings = require("scripts/managers/player/player_game_states/input_handler_settings")
local HumanInputHandler = class("HumanInputHandler")
HumanInputHandler.reloaded = HumanInputHandler.reloaded ~= nil

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

	for i = 1, num_pack_unpack_actions, 1 do
		local action = pack_unpack_actions[i]

		fassert(action_lookup[action], "pack_unpack_actions contain unknown action %q", action)
		fassert(action_network_type[action], "pack_unpack_actions: %q needs a network_type defined in action_network_type.", action)

		pack_unpack_action_to_network_type_index[action] = Network.type_index(action_network_type[action])
	end

	self._input_settings = settings.input_settings
	self._input_cache = input_cache
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
	fassert(frame >= 0, "Trying to access negative frame %i", frame)
	fassert(frame > (self._frame or 0) - self._input_buffer_size, "Buffer has already wrapped around, %i out of bounds (frame: %i)", frame, self._frame)

	if self._last_frame_parsed and frame <= self._last_frame_parsed then
		frame = self._frame
	end

	return (frame - 1) % self._input_buffer_size + 1
end

HumanInputHandler.pre_update = function (self, dt, t, input_service, ui_interaction_action)
	for i = 1, self._num_ephemeral_actions, 1 do
		local old_value = self._ephemeral_action_cache[i]
		local new_value = old_value or input_service:get(self._ephemeral_actions[i])
		self._ephemeral_action_cache[i] = old_value or new_value
	end

	for i = 1, self._num_ui_interaction_actions, 1 do
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

	fassert(frame == self._frame, "Frame mismatch. got %i, expected %i", frame, self._frame)

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
	local y = cache[self._yaw_index][index]
	local p = cache[self._pitch_index][index]
	local r = cache[self._roll_index][index]

	fassert(y and p and r, "no pitch yaw or roll")

	return y, p, r
end

HumanInputHandler.get = function (self, action, frame)
	local index = self:_buffer_index(frame)
	local action_lookup = self._action_lookup[action]

	fassert(action_lookup, "Unrecognized action %s", action)

	return self._input_cache[action_lookup][index]
end

HumanInputHandler._parse_input = function (self, input_cache, input_service, index)
	if index < 1 then
		ferror("Trying to fill non-positive index to input cache.")
	end

	local actions = self._actions
	local num_actions = self._num_actions
	local num_ephemeral_actions = self._num_ephemeral_actions

	for i = 1, num_actions, 1 do
		local action = actions[i]
		input_cache[i][index] = input_service:get(action)
	end

	local ephemeral_action_cache = self._ephemeral_action_cache

	for i = 1, num_ephemeral_actions, 1 do
		input_cache[num_actions + i][index] = ephemeral_action_cache[i]
		ephemeral_action_cache[i] = false
	end

	local ui_interaction_action_cache = self._ui_interaction_action_cache

	for i = 1, self._num_ui_interaction_actions, 1 do
		local pos = num_actions + num_ephemeral_actions + i
		input_cache[pos][index] = ui_interaction_action_cache[i]
		ui_interaction_action_cache[i] = false
	end

	local action_lookup = self._action_lookup
	local settings = self._input_settings

	for i = 1, self._num_input_settings, 1 do
		local input_setting = settings[i]
		local cache_index = action_lookup[input_setting]
		input_cache[cache_index][index] = self._input_settings_table[input_setting]
	end

	local pack_unpack_action_to_network_type_index = self._pack_unpack_action_to_network_type_index
	local pack_unpack_actions = self._pack_unpack_actions

	for i = 1, self._num_pack_unpack_actions, 1 do
		local action = pack_unpack_actions[i]
		local cache_index = action_lookup[action]
		local network_type_index = pack_unpack_action_to_network_type_index[action]
		input_cache[cache_index][index] = Network.pack_unpack(network_type_index, input_cache[cache_index][index])
	end
end

HumanInputHandler.update = function (self, dt, t, input_service)
	local frame = self._frame

	if self._is_server then
		self:frame_parsed(frame)
	elseif frame and self._last_frame_acknowledged < frame and Managers.state.game_session:can_send_session_bound_rpcs() and (not self._last_sent_frame or self._last_sent_frame < frame) then
		local input_cache = self._input_cache
		local start_frame = nil

		if self._send_buffer_size < frame - self._last_frame_acknowledged then
			start_frame = frame - self._send_buffer_size + 1

			Log.info("HumanInputHandler", "Out of buffer space, skipping %i to %i", self._last_frame_acknowledged, start_frame - 1)
		else
			start_frame = self._last_frame_acknowledged + 1
		end

		local end_frame_offset = self._frame - start_frame
		local send_array = {}
		local start_index = self:_buffer_index(start_frame)
		local end_index = self:_buffer_index(start_frame + end_frame_offset)

		if start_index <= end_index then
			for i = 1, #input_cache, 1 do
				send_array[i] = {
					unpack(input_cache[i], start_index, end_index)
				}
			end
		else
			local max_index = self._input_buffer_size

			for i = 1, #input_cache, 1 do
				local cache = input_cache[i]
				local array = {
					unpack(cache, start_index, max_index)
				}
				local field_filled = max_index - start_index + 1

				for j = 1, end_index, 1 do
					array[j + field_filled] = cache[j]
				end

				send_array[i] = array
			end
		end

		fassert(send_array[1][1 + end_frame_offset] ~= nil, "Trying so send less than planned.")
		Managers.state.game_session:send_rpc_server("rpc_player_input_array", self._player:local_player_id(), start_frame, end_frame_offset, unpack(send_array))

		self._last_sent_frame = frame
	end
end

HumanInputHandler.rpc_player_input_array_ack = function (self, channel_id, local_player_id, frame)
	self:frame_acknowledged(frame)
end

HumanInputHandler.frame_parsed = function (self, frame, remainder_time, frame_time)
	if self._last_frame_parsed < frame then
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
	if self._last_frame_acknowledged < frame then
		self._last_frame_acknowledged = frame
	end
end

HumanInputHandler.had_received_input = function (self, fixed_frame)
	return true
end

return HumanInputHandler

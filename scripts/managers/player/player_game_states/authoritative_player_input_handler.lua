local AdaptiveClockHandlerServer = require("scripts/managers/player/player_game_states/utilities/adaptive_clock_handler_server")
local AuthoritativePlayerInputHandler = class("AuthoritativePlayerInputHandler")
local InputHandlerSettings = require("scripts/managers/player/player_game_states/input_handler_settings")

local function _debug(...)
	Log.debug("AuthoritativePlayerInputHandler", ...)
end

local _default_input_value = nil

AuthoritativePlayerInputHandler.init = function (self, player, is_server)
	self._owner_peer_id = player:peer_id()
	self._frame = 0
	self._player = player
	local settings = InputHandlerSettings
	local num_buffered_frames = settings.buffered_frames
	local num_actions = #settings.actions
	local input_cache = Script.new_array(num_actions + 2)
	local action_lookup = {}
	self._action_lookup = action_lookup
	local action_network_type = settings.action_network_type

	for i, action in ipairs(settings.actions) do
		input_cache[i] = Script.new_array(num_buffered_frames)
		input_cache[i][1] = _default_input_value(action_network_type[action])
		action_lookup[action] = i
	end

	local num_ephemeral_actions = #settings.ephemeral_actions

	for i, ephemeral_action in ipairs(settings.ephemeral_actions) do
		local index = num_actions + i
		input_cache[index] = Script.new_array(num_buffered_frames)
		input_cache[index][1] = _default_input_value(action_network_type[ephemeral_action])
		action_lookup[ephemeral_action] = index
	end

	local num_ui_interaction_actions = #settings.ui_interaction_actions

	for i, ui_interaction_action in ipairs(settings.ui_interaction_actions) do
		local index = num_actions + num_ephemeral_actions + i
		input_cache[index] = Script.new_array(num_buffered_frames)
		input_cache[index][1] = _default_input_value(action_network_type[ui_interaction_action])
		action_lookup[ui_interaction_action] = index
	end

	self._yaw_index = num_actions + num_ephemeral_actions + num_ui_interaction_actions + 1
	local yaw_cache = Script.new_array(num_buffered_frames)
	input_cache[self._yaw_index] = yaw_cache
	yaw_cache[1] = 0
	self._pitch_index = self._yaw_index + 1
	local pitch_cache = Script.new_array(num_buffered_frames)
	input_cache[self._pitch_index] = pitch_cache
	pitch_cache[1] = 0
	self._roll_index = self._pitch_index + 1
	local roll_cache = Script.new_array(num_buffered_frames)
	input_cache[self._roll_index] = roll_cache
	roll_cache[1] = 0

	for i, input_setting in ipairs(settings.input_settings) do
		local index = self._roll_index + i
		input_cache[index] = Script.new_array(num_buffered_frames)
		input_cache[index][1] = false
		action_lookup[input_setting] = index
	end

	self._input_cache = input_cache
	self._input_cache_size = #input_cache
	self._first_frame_received = false

	self:_create_clock()
end

AuthoritativePlayerInputHandler._create_clock = function (self)
	local clock_handler, clock_start = AdaptiveClockHandlerServer:new(self._player:channel_id())
	self._clock_handler = clock_handler
	local last_frame = math.floor(clock_start / GameParameters.fixed_time_step)
	self._received_frame = last_frame
	self._last_acked_frame = last_frame
	self._parsed_frame = last_frame
end

AuthoritativePlayerInputHandler.fixed_update = function (self, dt, t, frame)
	if not self._clock_handler then
		return
	end

	self._frame = frame
	local frames_late = frame - self._received_frame

	if frames_late > 0 then
		_debug(string.format("Input not received in time from %s, skipping frame %i, %i frames late. recevied frame: %i", self._player:peer_id(), frame, frames_late, self._received_frame))
		self._clock_handler:frame_missed(frame)
	end
end

AuthoritativePlayerInputHandler.update = function (self, dt, t)
	local clock_handler = self._clock_handler

	if not clock_handler then
		return
	end

	clock_handler:update(dt, t)

	local num_to_remove = math.min(self._frame, self._received_frame) - (self._parsed_frame + 1)

	if num_to_remove > 0 then
		local input_cache = self._input_cache

		for i = 1, self._input_cache_size do
			local cache = input_cache[i]

			table.remove_sequence(cache, 1, num_to_remove)
		end

		self._parsed_frame = self._frame - 1
	end

	if self._last_acked_frame < self._received_frame then
		self._last_acked_frame = self._received_frame

		RPC.rpc_player_input_array_ack(self._player:channel_id(), self._player:local_player_id(), self._received_frame, self._clock_offset)
	end
end

AuthoritativePlayerInputHandler.get_orientation = function (self, frame)
	local index = math.max(math.min(frame, self._received_frame) - self._parsed_frame, 1)
	local cache = self._input_cache
	local y = cache[self._yaw_index][index]
	local p = cache[self._pitch_index][index]
	local r = cache[self._roll_index][index]

	return y, p, r
end

AuthoritativePlayerInputHandler.get = function (self, action, frame)
	local index = math.max(math.min(frame, self._received_frame) - self._parsed_frame, 1)

	return self._input_cache[self._action_lookup[action]][index]
end

AuthoritativePlayerInputHandler.rpc_player_input_array = function (self, channel_id, local_player_id, start_frame, end_frame_offset, ...)
	local end_frame = start_frame + end_frame_offset
	local next_frame = self._received_frame + 1

	if end_frame >= next_frame then
		self._clock_handler:frame_received(end_frame)

		local cache = self._input_cache

		if next_frame < start_frame then
			_debug("We skipped unacked inputs")

			self._parsed_frame = start_frame - 1

			for i = 1, self._input_cache_size do
				table.clear(cache[i])
			end
		end

		local index_offset = start_frame - self._parsed_frame - 1
		local size = #cache[1]

		for i = 1, self._input_cache_size do
			local inputs = select(i, ...)

			for j = 1, end_frame_offset + 1 do
				local value = inputs[j]
				cache[i][index_offset + j] = value
			end
		end

		self._received_frame = end_frame
	end
end

AuthoritativePlayerInputHandler.rewind_ms = function (self)
	return self._clock_handler:rewind_ms()
end

AuthoritativePlayerInputHandler.had_received_input = function (self, fixed_frame)
	return fixed_frame <= self._received_frame
end

function _default_input_value(action_network_type)
	if action_network_type == "float_input" then
		return 0
	else
		return false
	end
end

return AuthoritativePlayerInputHandler

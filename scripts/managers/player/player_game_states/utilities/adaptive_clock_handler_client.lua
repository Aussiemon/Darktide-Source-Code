local AdaptiveClockHandlerClient = class("AdaptiveClockHandlerClient")
local FRAMETIME_BUFFER_SIZE = 10
local TIME_PER_SAMPLE = 0.5
local MAX_SPEED_UP = 0.05
local MAX_SLOW_DOWN = 0.05
local MAX_FRAMERATE_SPIKE_THRESHOLD = 2
local INCREASE_MULTIPLIER_ON_SPIKE = 1.1

AdaptiveClockHandlerClient.init = function (self, network_event_delegate)
	network_event_delegate:register_session_events(self, "rpc_sync_clock_offset")

	self._network_event_delegate = network_event_delegate
	self._frametime_buffer = Script.new_array(FRAMETIME_BUFFER_SIZE)
	self._frametime_buffer_index = 0
	self._max_frame_time = GameParameters.fixed_time_step
	self._time_since_last_sample = 1
	self._time_per_sample = TIME_PER_SAMPLE
	self._offset_correction = 0
	self._has_registered_timer = false
	self._base_time_scale = 1
end

AdaptiveClockHandlerClient.destroy = function (self)
	self._network_event_delegate:unregister_events("rpc_sync_clock_offset")

	if self._has_registered_timer then
		Managers.time:unregister_timer("gameplay")
	end
end

AdaptiveClockHandlerClient.rpc_sync_clock = function (self, clock_start, clock_offset, last_frame)
	Log.info("AdaptiveClockHandlerClient", "Clock synced clock_start:%f clock_offset:%f last_frame:%i", clock_start, clock_offset, last_frame)

	self._server_offset = clock_offset
	self._current_offset = clock_offset
	self._time_scale = self._base_time_scale

	Managers.time:register_timer("gameplay", "main", clock_start)
	Managers.state.extension:initialize_client_fixed_frame(last_frame)
	Managers.player:state_initialize_client_fixed_frame(last_frame)

	self._has_registered_timer = true
	self._gameplay_timer_offset = clock_start - Managers.time:time("main")
	self._initial_server_offset = clock_offset
end

AdaptiveClockHandlerClient._frame_discrepancy_buffer = function (self)
	return math.max(self._max_frame_time, 0.006944444444444444)
end

AdaptiveClockHandlerClient._target_offset = function (self)
	return self._server_offset + self:_frame_discrepancy_buffer() + self._offset_correction
end

AdaptiveClockHandlerClient.frame_parsed = function (self, frame, remainder_time, frame_time)
	local measured_time = frame * GameParameters.fixed_time_step + self:_frame_discrepancy_buffer() + remainder_time - frame_time
	local server = Managers.connection:host()
	local rtt = Network.ping(server)
	local estimated_time = Managers.time:time("gameplay") - self._current_offset - rtt * 0.5
	local wanted_offset_correction = measured_time - estimated_time
	local offset = wanted_offset_correction - self._offset_correction

	if math.abs(offset) > GameParameters.fixed_time_step * 0.01 then
		self._offset_correction = math.lerp(self._offset_correction, wanted_offset_correction, 0.005)
	end
end

AdaptiveClockHandlerClient.post_update = function (self, main_dt)
	self:_update_max_frame_time(main_dt)

	if not self._time_scale then
		return
	end

	local offset_this_frame = (self._time_scale - self._base_time_scale) * main_dt
	self._current_offset = self._current_offset + offset_this_frame
	local target_offset = self:_target_offset()
	local offset_change_required = target_offset - self._current_offset

	if offset_change_required < 0 and offset_change_required > -GameParameters.fixed_time_step * 0.5 then
		self._time_scale = self._base_time_scale
	elseif offset_change_required > 0 then
		self._time_scale = math.min(self._base_time_scale + MAX_SPEED_UP, 1 + offset_change_required / main_dt)
	else
		self._time_scale = math.max(self._base_time_scale - MAX_SLOW_DOWN, 1 + offset_change_required / main_dt)
	end

	Managers.time:set_local_scale("gameplay", self._time_scale)
end

AdaptiveClockHandlerClient._update_max_frame_time = function (self, dt)
	local max_dt = self._max_frame_time * MAX_FRAMERATE_SPIKE_THRESHOLD

	if dt > max_dt then
		Log.info("AdaptiveClockHandlerClient", "Filtering out frame dt of %f, more than %f times old max dt of %f", dt, MAX_FRAMERATE_SPIKE_THRESHOLD, max_dt)

		dt = self._max_frame_time * INCREASE_MULTIPLIER_ON_SPIKE
	end

	self._time_since_last_sample = self._time_since_last_sample + dt
	local buffer = self._frametime_buffer

	if self._time_per_sample < self._time_since_last_sample then
		local index = self._frametime_buffer_index % FRAMETIME_BUFFER_SIZE + 1
		local old_value = buffer[index]
		buffer[index] = dt
		self._frametime_buffer_index = index

		if self._max_frame_time < dt then
			self._max_frame_time = dt
		elseif old_value == self._max_frame_time and dt < old_value then
			self._max_frame_time = math.max(unpack(buffer))
		end

		self._time_since_last_sample = self._time_since_last_sample - self._time_per_sample
	else
		local index = self._frametime_buffer_index

		if buffer[index] < dt then
			buffer[index] = dt
			self._max_frame_time = math.max(dt, self._max_frame_time)
		end
	end
end

AdaptiveClockHandlerClient.rpc_sync_clock_offset = function (self, channel_id, offset, server_gameplay_t)
	self._server_offset = offset
	local gameplay_offset = Managers.time:time("gameplay") - server_gameplay_t
	self._server_gameplay_t = server_gameplay_t

	if self._server_gameplay_t_offset then
		self._server_gameplay_t_offset = math.lerp(self._server_gameplay_t_offset, gameplay_offset, 0.05)
	else
		self._server_gameplay_t_offset = gameplay_offset
	end
end

return AdaptiveClockHandlerClient

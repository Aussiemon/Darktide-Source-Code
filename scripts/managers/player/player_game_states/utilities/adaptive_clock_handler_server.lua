local AdaptiveClockHandlerServer = class("AdaptiveClockHandlerServer")

AdaptiveClockHandlerServer.init = function (self, channel_id)
	self._channel_id = channel_id
	self._peer_id = Managers.state.game_session:channel_to_peer(channel_id)
	local ping = Network.ping(self._peer_id)

	Log.info("AdaptiveClockHandlerServer", "Ping(%s) %ims", self._peer_id, ping * 1000)

	self._estimated_ping = ping
	self._buffer = 0
	local clock_offset = self:_offset()
	local clock_start = Managers.time:time("gameplay") + clock_offset + self._estimated_ping * 0.5
	local start_frame = math.floor(clock_start / GameParameters.fixed_time_step)

	Log.info("AdaptiveClockHandlerServer", "[%s:%i] Sync clock value: %f offset: %f start frame:%i ping:%f", self._peer_id, channel_id, clock_start, clock_offset, start_frame, ping)

	if clock_offset > 0.5 then
		Log.info("AdaptiveClockHandlerServer", "[%s:%i] Clamping clock offset (%f) to 0.5 to not network overflow.", self._peer_id, channel_id, clock_offset)

		clock_offset = 0.5
	end

	RPC.rpc_sync_clock(channel_id, clock_start, clock_offset)

	self._synced_offset = clock_offset
	self._sync_epsilon = GameParameters.fixed_time_step * 0.5
	local size = 32
	self._ping_buffer_size = size
	self._ping_buffer = Script.new_array(size)

	for i = 1, size do
		self._ping_buffer[i] = 0
	end

	self._ping_buffer_index = 1
	self._rewind_ms_buffer = {}
	self._rewind_ms_buffer_index = 0

	return clock_start
end

AdaptiveClockHandlerServer._offset = function (self)
	return self._estimated_ping * 0.5 + self._buffer
end

AdaptiveClockHandlerServer.frame_received = function (self, frame)
	local index = self._ping_buffer_index
	local ping = Network.ping(self._peer_id)
	self._ping_buffer[index] = ping
	self._ping_buffer_index = index % self._ping_buffer_size + 1
	self._estimated_ping = math.max(unpack(self._ping_buffer))
	local offset = self:_offset()

	if self._sync_epsilon < math.abs(self._synced_offset - offset) then
		if offset > 0.5 then
			offset = 0.5
		end

		RPC.rpc_sync_clock_offset(self._channel_id, offset, Managers.time:time("gameplay"))
	end

	self:_calibrate_rewind_ms(frame)
end

AdaptiveClockHandlerServer.frame_missed = function (self, frame)
	return
end

AdaptiveClockHandlerServer._calibrate_rewind_ms = function (self, frame)
	local buffer_size = 5
	local constant_offset = 0.03
	local ping = Network.ping(self._peer_id)
	local client_unit_latency = ping * 0.5
	local current_server_frame = Managers.time:time("gameplay") / GameParameters.fixed_time_step
	local last_client_frame = frame
	local server_client_offset = math.max(last_client_frame - current_server_frame, 0)
	local server_client_offset_time = server_client_offset * GameParameters.fixed_time_step + ping * 0.5
	local buffer_index = self._rewind_ms_buffer_index
	self._rewind_ms_buffer[buffer_index + 1] = (server_client_offset_time + client_unit_latency + constant_offset) * 1000
	self._rewind_ms_buffer_index = (buffer_index + 1) % buffer_size
end

AdaptiveClockHandlerServer.rewind_ms = function (self)
	local rewind_ms_buffer = self._rewind_ms_buffer
	local num_buffered = #rewind_ms_buffer

	if num_buffered == 0 then
		return 0
	end

	local rewind_ms = 0

	for i = 1, num_buffered do
		rewind_ms = rewind_ms + rewind_ms_buffer[i]
	end

	rewind_ms = rewind_ms / num_buffered

	return rewind_ms
end

return AdaptiveClockHandlerServer

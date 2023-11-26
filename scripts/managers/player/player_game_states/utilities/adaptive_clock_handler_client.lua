-- chunkname: @scripts/managers/player/player_game_states/utilities/adaptive_clock_handler_client.lua

local AdaptiveClockHandlerClient = class("AdaptiveClockHandlerClient")
local FRAMETIME_BUFFER_SIZE = 10
local TIME_PER_SAMPLE = 0.5
local MAX_SPEED_UP = 0.05
local MAX_SLOW_DOWN = 0.05
local MAX_FRAMERATE_SPIKE_THRESHOLD = 2
local INCREASE_MULTIPLIER_ON_SPIKE = 1.1
local DIAGNOSTICS_BUFFER = 64
local DIAGNOSTICS_STRIDE = 6
local DIAGNOSTICS_UPDATE_FREQUENCY = 0.25
local DIAGNOSTICS_SIZE = DIAGNOSTICS_BUFFER * DIAGNOSTICS_STRIDE
local OFFSET_CORRECTION_INFO_NUM_FRAMES = 60

AdaptiveClockHandlerClient.init = function (self, network_event_delegate, fixed_time_step)
	network_event_delegate:register_session_events(self, "rpc_sync_clock_offset")

	self._network_event_delegate = network_event_delegate
	self._frametime_buffer = Script.new_array(FRAMETIME_BUFFER_SIZE)
	self._frametime_buffer_index = 0
	self._max_frame_time = fixed_time_step
	self._fixed_time_step = fixed_time_step
	self._time_since_last_sample = 1
	self._time_per_sample = TIME_PER_SAMPLE
	self._offset_correction = 0
	self._has_registered_timer = false
	self._in_panic = false

	local diagnostics = Script.new_array(DIAGNOSTICS_SIZE)

	self._diagnostics = diagnostics
	diagnostics[0] = DIAGNOSTICS_BUFFER

	for i = 1, DIAGNOSTICS_BUFFER do
		local diag_i = (i - 1) * DIAGNOSTICS_STRIDE

		diagnostics[diag_i + 1] = 0
		diagnostics[diag_i + 2] = 0
		diagnostics[diag_i + 3] = 0
		diagnostics[diag_i + 4] = 0
		diagnostics[diag_i + 5] = 0
		diagnostics[diag_i + 6] = 0
	end

	self._diagnostics_timer = 0
	self._last_diagnostics_timer = 0
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
	return (math.max(self._max_frame_time, 0.006944444444444444))
end

AdaptiveClockHandlerClient._target_offset = function (self)
	return self._server_offset + self:_frame_discrepancy_buffer() + self._offset_correction
end

AdaptiveClockHandlerClient.frame_parsed = function (self, frame, remainder_time, frame_time)
	local fixed_time_step = self._fixed_time_step
	local measured_time = frame * fixed_time_step + self:_frame_discrepancy_buffer() + remainder_time - frame_time
	local server = Managers.connection:host()
	local rtt = Network.ping(server)
	local estimated_time = Managers.time:time("gameplay") - self._current_offset - rtt * 0.5
	local wanted_offset_correction = measured_time - estimated_time
	local offset = wanted_offset_correction - self._offset_correction

	if math.abs(offset) > fixed_time_step * 0.01 then
		self._offset_correction = math.lerp(self._offset_correction, wanted_offset_correction, 0.005)
	end
end

AdaptiveClockHandlerClient.post_update = function (self, main_dt)
	self._max_frame_time = Managers.time:mean_dt()

	if not self._time_scale then
		return
	end

	local offset_this_frame = (self._time_scale - self._base_time_scale) * main_dt

	self._current_offset = self._current_offset + offset_this_frame

	local target_offset = self:_target_offset()
	local offset_change_required = target_offset - self._current_offset

	if offset_change_required < 0 and offset_change_required > -self._fixed_time_step * 0.5 then
		self._time_scale = self._base_time_scale
	elseif offset_change_required > 0 then
		self._time_scale = math.min(self._base_time_scale + MAX_SPEED_UP, 1 + offset_change_required / main_dt)
	else
		self._time_scale = math.max(self._base_time_scale - MAX_SLOW_DOWN, 1 + offset_change_required / main_dt)
	end

	Managers.time:set_local_scale("gameplay", self._time_scale)

	local diagnostics_timer = self._diagnostics_timer + main_dt

	self._diagnostics_timer = diagnostics_timer

	local time_since_last_diagnostics = diagnostics_timer - self._last_diagnostics_timer

	if time_since_last_diagnostics > DIAGNOSTICS_UPDATE_FREQUENCY then
		self._last_diagnostics_timer = diagnostics_timer

		local diag = self._diagnostics
		local i = (diag[0] + 1 - 1) % DIAGNOSTICS_BUFFER + 1

		diag[0] = i

		local diag_i = (i - 1) * DIAGNOSTICS_STRIDE

		diag[diag_i + 1] = time_since_last_diagnostics
		diag[diag_i + 2] = target_offset
		diag[diag_i + 3] = self._current_offset
		diag[diag_i + 4] = self._time_scale
		diag[diag_i + 5] = self._server_offset
		diag[diag_i + 6] = self._offset_correction
	end
end

AdaptiveClockHandlerClient.set_in_panic = function (self, in_panic)
	self._in_panic = in_panic
end

AdaptiveClockHandlerClient.in_panic = function (self)
	return self._in_panic
end

AdaptiveClockHandlerClient.diagnostics_dump = function (self)
	local dump
	local diag = self._diagnostics
	local i = diag[0]

	for j = 1, DIAGNOSTICS_BUFFER do
		i = (i + 1 - 1) % DIAGNOSTICS_BUFFER + 1

		local diag_i = (i - 1) * DIAGNOSTICS_STRIDE
		local t = diag[diag_i + 1]
		local target = diag[diag_i + 2]
		local current = diag[diag_i + 3]
		local time_scale = diag[diag_i + 4]
		local server_offset = diag[diag_i + 5]
		local offset_correction = diag[diag_i + 6]
		local frame_string = string.format("\t[%i]t:%.2f target:%.3f current:%.3f time_scale:%.5f server_offset:%.3f offset_correction:%.3f", i, t, target, current, time_scale, server_offset, offset_correction)
		local wrap = (j - 1) % 4 == 0

		if not dump then
			dump = string.format("%s", frame_string)
		elseif wrap then
			dump = string.format("%s\n%s", dump, frame_string)
		else
			dump = string.format("%s %s", dump, frame_string)
		end
	end

	return dump
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

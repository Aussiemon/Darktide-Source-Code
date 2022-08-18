local MissionSoundEvents = require("scripts/settings/sound/mission_sound_events")
local DecoderSynchronizerExtension = class("DecoderSynchronizerExtension", "EventSynchronizerBaseExtension")
local STATES = table.enum("none", "activating_devices", "timer_on", "timer_paused", "complete")

DecoderSynchronizerExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	DecoderSynchronizerExtension.super.init(self, extension_init_context, unit, extension_init_data, ...)

	self._min_time_until_stalling = 10
	self._max_time_until_stalling = 20
	self._time_till_next_stall = 0
	self._num_active_units = 10
	self._pause_timer = 0
	self._attached_devices = {}
	self._used_devices = {}
	self._total_active_devices = 0
	self._current_state = STATES.none
	self._networked_timer_extension = ScriptUnit.extension(unit, "networked_timer_system")
	self._event_active = false
	self._setup_only = false
	self._loaded_view = false
end

DecoderSynchronizerExtension.setup_from_component = function (self, min_time_until_stalling, max_time_until_stalling, num_active_units, stall_once_per_device, objective_name, auto_start, setup_only)
	self._min_time_until_stalling = min_time_until_stalling
	self._max_time_until_stalling = max_time_until_stalling
	self._num_active_units = num_active_units
	self._stall_once_per_device = stall_once_per_device
	self._objective_name = objective_name
	self._auto_start = auto_start
	self._setup_only = setup_only
	local unit = self._unit

	self._mission_objective_system:register_objective_synchronizer(objective_name, unit)
end

DecoderSynchronizerExtension.destroy = function (self)
	if self._loaded_view and Managers.ui then
		Managers.ui:unload_view("scanner_display_view", self.__class_name)

		self._loaded_view = false
	end
end

DecoderSynchronizerExtension.register_connected_units = function (self, stage_units)
	local decoder_units = self:_retrieve_decoder_units(stage_units)

	for i = 1, #decoder_units do
		local decoder_device_extension = ScriptUnit.extension(decoder_units[i], "decoder_device_system")

		decoder_device_extension:register_synchronizer(self)
	end

	self._attached_devices = decoder_units

	return decoder_units
end

DecoderSynchronizerExtension._retrieve_decoder_units = function (self, units)
	local decoder_units = {}

	for i = 1, #units do
		local unit = units[i]
		local decoder_device_extension = ScriptUnit.has_extension(unit, "decoder_device_system")

		if decoder_device_extension then
			decoder_units[#decoder_units + 1] = unit
		end
	end

	if #decoder_units == 0 then
		return decoder_units
	end

	local result = {}
	local random_table, _ = table.generate_random_table(1, #decoder_units, self._seed)
	local num_active_units = self._num_active_units

	for i = 1, num_active_units do
		local index = random_table[i]
		result[#result + 1] = decoder_units[index]
	end

	return result
end

DecoderSynchronizerExtension.fixed_update = function (self, unit, dt, t)
	if self._is_server and self._event_active then
		if self._current_state == STATES.none then
			-- Nothing
		elseif self._current_state == STATES.activating_devices then
			-- Nothing
		elseif self._current_state == STATES.timer_on then
			if self._pause_timer < self._time_till_next_stall then
				self._pause_timer = self._pause_timer + dt
			else
				self:pause_event()
				self._mission_objective_system:sound_event(MissionSoundEvents.decode_blocked)
				self:_set_state(STATES.timer_paused)
			end

			if self:_network_timer_is_finished() then
				self:_set_state(STATES.complete)
			end
		elseif self._current_state == STATES.timer_paused then
			-- Nothing
		elseif self._current_state == STATES.complete then
			self:finished_stage()
		end
	end
end

DecoderSynchronizerExtension._set_state = function (self, state)
	self._current_state = state
end

DecoderSynchronizerExtension._get_next_random_stall_time = function (self)
	local min = self._min_time_until_stalling
	local max = self._max_time_until_stalling
	local stall_once_per_device = self._stall_once_per_device
	local return_time = math.random(min, max)

	if stall_once_per_device and #self._used_devices == #self._attached_devices - 1 then
		local remaining_time = self._networked_timer_extension:get_remaining_time()
		remaining_time = remaining_time - 0.1
		return_time = remaining_time
	end

	return return_time
end

local remaining_devices = {}

DecoderSynchronizerExtension._get_random_decoding_device = function (self)
	local stall_once_per_device = self._stall_once_per_device
	local devices = self._attached_devices

	table.clear(remaining_devices)

	if stall_once_per_device then
		for i = 1, #devices do
			local device = devices[i]

			if not table.contains(self._used_devices, device) then
				remaining_devices[#remaining_devices + 1] = device
			end
		end
	end

	local rnd_unit = nil

	if stall_once_per_device then
		devices = remaining_devices or devices
	end

	local device_amount = #devices

	if device_amount > 0 then
		local rnd_index = math.random(1, device_amount)
		rnd_unit = devices[rnd_index]

		if stall_once_per_device then
			self._used_devices[#self._used_devices + 1] = rnd_unit
		end
	end

	return rnd_unit
end

DecoderSynchronizerExtension.unblock_decoding_progression = function (self)
	fassert(self._is_server, "Server only method.")

	local attached_devices = self._attached_devices
	local num_devices = #attached_devices
	local total_active = self._total_active_devices
	total_active = total_active + 1
	self._total_active_devices = total_active

	if total_active == num_devices then
		if not self._setup_only then
			local rnd_time = self:_get_next_random_stall_time()
			self._time_till_next_stall = rnd_time

			for i = 1, num_devices do
				local attached_device = attached_devices[i]
				local decoder_device_extension = ScriptUnit.extension(attached_device, "decoder_device_system")

				decoder_device_extension:start_decode()
			end

			self:_start_network_timer()
			self:_set_state(STATES.timer_on)
			Unit.flow_event(self._unit, "lua_event_decoding_started")
			self._mission_objective_system:sound_event(MissionSoundEvents.decode_moving)
		else
			self:_set_state(STATES.complete)
		end
	end
end

DecoderSynchronizerExtension.start_event = function (self)
	local is_server = self._is_server

	if is_server then
		self._event_active = true

		self:_set_state(STATES.activating_devices)

		local unit_id = Managers.state.unit_spawner:level_index(self._unit)

		Managers.state.game_session:send_rpc_clients("rpc_event_synchronizer_started", unit_id)
	end

	local attached_devices = self._attached_devices

	for i = 1, #attached_devices do
		local attached_device = attached_devices[i]

		if is_server then
			local decoder_device_extension = ScriptUnit.extension(attached_device, "decoder_device_system")

			decoder_device_extension:enable_unit()
		end

		Unit.flow_event(attached_device, "lua_device_enabled")
	end

	Unit.flow_event(self._unit, "lua_event_started")

	if not self._loaded_view and Managers.ui then
		Managers.ui:load_view("scanner_display_view", self.__class_name)

		self._loaded_view = true
	end
end

DecoderSynchronizerExtension.pause_event = function (self)
	if self._is_server then
		self._pause_timer = 0

		self:_pause_network_timer()

		local total_active = self._total_active_devices
		total_active = total_active - 1
		self._total_active_devices = total_active
		local rnd_unit = self:_get_random_decoding_device()

		if rnd_unit then
			local decoder_device_extension = ScriptUnit.extension(rnd_unit, "decoder_device_system")

			decoder_device_extension:decode_interrupt()

			local unit_id = Managers.state.unit_spawner:level_index(self._unit)

			Managers.state.game_session:send_rpc_clients("rpc_event_synchronizer_paused", unit_id)
			Unit.flow_event(self._unit, "lua_event_paused")
		end
	else
		Unit.flow_event(self._unit, "lua_event_paused")
	end
end

DecoderSynchronizerExtension.finished_event = function (self)
	if self._is_server then
		self._event_active = false
		self._total_active_devices = 0
		self._pause_timer = 0

		self:_set_state(STATES.none)

		local attached_devices = self._attached_devices

		for i = 1, #attached_devices do
			local attached_device = attached_devices[i]
			local decoder_device_extension = ScriptUnit.extension(attached_device, "decoder_device_system")

			decoder_device_extension:finished()
		end
	end

	if self._loaded_view and Managers.ui then
		Managers.ui:unload_view("scanner_display_view", self.__class_name)

		self._loaded_view = false
	end

	DecoderSynchronizerExtension.super.finished_event(self)
end

DecoderSynchronizerExtension.setup_only_finished = function (self)
	if self._setup_only then
		return self._current_state == STATES.complete
	end

	return false
end

DecoderSynchronizerExtension._start_network_timer = function (self)
	self._networked_timer_extension:start()
end

DecoderSynchronizerExtension._pause_network_timer = function (self)
	self._networked_timer_extension:pause()
end

DecoderSynchronizerExtension.is_stuck = function (self)
	return not self._networked_timer_extension:is_counting()
end

DecoderSynchronizerExtension._network_timer_is_finished = function (self)
	local timer_is_active = self._networked_timer_extension:is_active()

	return not timer_is_active
end

return DecoderSynchronizerExtension

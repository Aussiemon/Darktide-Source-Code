-- chunkname: @scripts/extension_systems/event_synchronizer/decoder_synchronizer_extension.lua

local MissionSoundEvents = require("scripts/settings/sound/mission_sound_events")
local DecoderSynchronizerExtension = class("DecoderSynchronizerExtension", "EventSynchronizerBaseExtension")
local STATES = table.enum("none", "activating_devices", "timer_on", "timer_paused", "complete")

DecoderSynchronizerExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	DecoderSynchronizerExtension.super.init(self, extension_init_context, unit, extension_init_data, ...)

	self._min_time_until_stalling = 10
	self._max_time_until_stalling = 20
	self._time_till_next_stall = 0
	self._num_active_units = 10
	self._stalled_decoder = nil
	self._pause_timer = 0
	self._attached_devices = {}
	self._used_devices = {}
	self._total_active_devices = 0
	self._current_state = STATES.none
	self._networked_timer_extension = ScriptUnit.extension(unit, "networked_timer_system")
	self._event_active = false
	self._setup_only = false
	self._progress_in_minigame = false
	self._progress_in_minigame_on_stall = false
	self._loaded_view = false
	self._event_synchronizer_system = Managers.state.extension:system("event_synchronizer_system")
end

DecoderSynchronizerExtension.setup_from_component = function (self, objective_name, auto_start, min_time_until_stalling, max_time_until_stalling, num_active_units, stall_once_per_device, setup_only, progress_in_minigame)
	self._objective_name = objective_name
	self._auto_start = auto_start
	self._min_time_until_stalling = min_time_until_stalling
	self._max_time_until_stalling = max_time_until_stalling
	self._num_active_units = num_active_units
	self._stall_once_per_device = stall_once_per_device
	self._setup_only = setup_only

	if progress_in_minigame == "On Stall" then
		self._progress_in_minigame_on_stall = true
		self._progress_in_minigame = false
	else
		self._progress_in_minigame = progress_in_minigame
	end

	local unit = self._unit

	self._group_id = self._mission_objective_system:register_objective_synchronizer(objective_name, nil, unit)
end

DecoderSynchronizerExtension.destroy = function (self)
	if self._loaded_view then
		self._event_synchronizer_system:unload_scanner_view()

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
		if self._current_state == STATES.timer_on then
			if self:_network_timer_is_finished() then
				self:_set_state(STATES.complete)
			else
				local stall = false

				if self._stall_once_per_device and #self._used_devices == #self._attached_devices then
					stall = false
				elseif self._progress_in_minigame == false then
					if self._pause_timer < self._time_till_next_stall then
						self._pause_timer = self._pause_timer + dt
					else
						stall = true
					end
				elseif not self._stalled_decoder:is_minigame_active() then
					stall = true
				else
					local counting = not self:is_stuck()
					local progressing = self._stalled_decoder:is_minigame_progressing()

					if counting ~= progressing then
						if progressing then
							self:_start_network_timer()
						else
							self:_pause_network_timer()
						end
					end
				end

				if stall then
					self:pause_event()
				end
			end
		elseif self._current_state == STATES.timer_paused then
			if self._progress_in_minigame and self._stalled_decoder:is_minigame_active() then
				self:unblock_decoding_progression()
			end
		elseif self._current_state == STATES.complete then
			self:finished_stage()
		end
	end
end

DecoderSynchronizerExtension._set_state = function (self, state)
	self._current_state = state
end

DecoderSynchronizerExtension._get_next_stall_time = function (self)
	local stall_once_per_device = self._stall_once_per_device

	if stall_once_per_device and #self._used_devices == #self._attached_devices - 1 then
		return self._networked_timer_extension:get_remaining_time() - 0.1
	end

	local min = self._min_time_until_stalling
	local max = self._max_time_until_stalling

	return math.random(min, max)
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

	local rnd_unit

	devices = stall_once_per_device and remaining_devices or devices

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
	local attached_devices = self._attached_devices
	local num_devices = #attached_devices
	local total_active = self._total_active_devices

	total_active = total_active + 1
	self._total_active_devices = total_active

	if total_active == num_devices then
		if not self._setup_only then
			self._time_till_next_stall = self:_get_next_stall_time()

			for i = 1, num_devices do
				local attached_device = attached_devices[i]
				local decoder_device_extension = ScriptUnit.extension(attached_device, "decoder_device_system")

				decoder_device_extension:start_decode()
			end

			if self._progress_in_minigame and self._current_state == STATES.activating_devices then
				self:pause_event()
			else
				Unit.flow_event(self._unit, "lua_event_decoding_started")
				self:_start_network_timer()
				self:_set_state(STATES.timer_on)
				self._mission_objective_system:set_objective_ui_state(self._objective_name, self._group_id, "default")
				self._mission_objective_system:sound_event(MissionSoundEvents.decode_moving)
			end
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

	DecoderSynchronizerExtension.super.start_event(self)

	if not self._loaded_view then
		self._event_synchronizer_system:load_scanner_view()

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

			self._stalled_decoder = decoder_device_extension

			local unit_id = Managers.state.unit_spawner:level_index(self._unit)

			Managers.state.game_session:send_rpc_clients("rpc_event_synchronizer_paused", unit_id)
			Unit.flow_event(self._unit, "lua_event_paused")

			if self._progress_in_minigame_on_stall then
				self._progress_in_minigame_on_stall = false
				self._progress_in_minigame = true
			end
		end
	else
		Unit.flow_event(self._unit, "lua_event_paused")
	end

	self._mission_objective_system:set_objective_ui_state(self._objective_name, self._group_id, "alert")
	self._mission_objective_system:sound_event(MissionSoundEvents.decode_blocked)
	self:_set_state(STATES.timer_paused)
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

	if self._loaded_view then
		self._event_synchronizer_system:unload_scanner_view()

		self._loaded_view = false
	end

	DecoderSynchronizerExtension.super.finished_event(self)
end

DecoderSynchronizerExtension.finished = function (self)
	return self._current_state == STATES.complete
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

﻿-- chunkname: @scripts/extension_systems/event_synchronizer/decoder_synchronizer_extension.lua

local MissionSoundEvents = require("scripts/settings/sound/mission_sound_events")
local FixedFrame = require("scripts/utilities/fixed_frame")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
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
	self._auto_open_auspex = false
	self._loaded_view = false
	self._event_synchronizer_system = Managers.state.extension:system("event_synchronizer_system")
end

DecoderSynchronizerExtension.setup_from_component = function (self, objective_name, auto_start, min_time_until_stalling, max_time_until_stalling, num_active_units, stall_once_per_device, setup_only, progress_in_minigame, auto_open_auspex)
	self._objective_name = objective_name
	self._auto_start = auto_start
	self._min_time_until_stalling = min_time_until_stalling
	self._max_time_until_stalling = max_time_until_stalling
	self._num_active_units = num_active_units
	self._stall_once_per_device = stall_once_per_device
	self._setup_only = setup_only
	self._progress_in_minigame = progress_in_minigame

	local mission_name = Managers.state.mission:mission_name()

	if mission_name == "op_train" then
		self._progress_in_minigame = true
	end

	self._auto_open_auspex = auto_open_auspex

	local unit = self._unit

	self._mission_objective_system:register_objective_synchronizer(objective_name, unit)
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

				if not self._progress_in_minigame then
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
				self._mission_objective_system:set_objective_ui_state(self._objective_name, "default")
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

	Unit.flow_event(self._unit, "lua_event_started")

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

			local placing_unit = decoder_device_extension:placing_unit()

			if self._auto_open_auspex and PlayerUnitStatus.can_interact_with_objective(placing_unit) then
				local decoder_unit = rnd_unit
				local unit_data_extension = ScriptUnit.extension(placing_unit, "unit_data_system")
				local minigame_character_state = unit_data_extension:write_component("minigame_character_state")

				minigame_character_state.interface_unit_id = Managers.state.unit_spawner:level_index(decoder_unit)

				local interactee_extension = ScriptUnit.extension(decoder_unit, "interactee_system")
				local item = interactee_extension:interactor_item_to_equip()
				local fixed_t = FixedFrame.get_latest_fixed_time()
				local inventory_component = unit_data_extension:read_component("inventory")
				local visual_loadout_extension = ScriptUnit.extension(placing_unit, "visual_loadout_system")

				if PlayerUnitVisualLoadout.slot_equipped(inventory_component, visual_loadout_extension, "slot_device") then
					PlayerUnitVisualLoadout.unequip_item_from_slot(placing_unit, "slot_device", fixed_t)
				end

				PlayerUnitVisualLoadout.equip_item_to_slot(placing_unit, item, "slot_device", nil, fixed_t)
				PlayerUnitVisualLoadout.wield_slot("slot_device", placing_unit, fixed_t)
			end
		end
	else
		Unit.flow_event(self._unit, "lua_event_paused")
	end

	self._mission_objective_system:set_objective_ui_state(self._objective_name, "alert")
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

DecoderSynchronizerExtension.auto_open_auspex = function (self)
	return self._auto_open_auspex
end

DecoderSynchronizerExtension._network_timer_is_finished = function (self)
	local timer_is_active = self._networked_timer_extension:is_active()

	return not timer_is_active
end

return DecoderSynchronizerExtension

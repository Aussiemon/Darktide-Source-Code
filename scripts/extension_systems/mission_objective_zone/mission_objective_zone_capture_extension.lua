﻿-- chunkname: @scripts/extension_systems/mission_objective_zone/mission_objective_zone_capture_extension.lua

local MissionObjectiveZoneCaptureExtension = class("MissionObjectiveZoneCaptureExtension", "MissionObjectiveZoneBaseExtension")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local SERVER_STATES = table.enum("progress_inactive", "progress_active", "progress_finished")
local NETWORK_TIMER_STATES = table.enum("pause", "play")

MissionObjectiveZoneCaptureExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	MissionObjectiveZoneCaptureExtension.super.init(self, extension_init_context, unit, extension_init_data, ...)

	self._time_progress = 0
	self._time_in_zone = 0
	self._number_of_players_in_zone = 1
	self._networked_timer_extension = ScriptUnit.extension(unit, "networked_timer_system")
	self._current_server_state = SERVER_STATES.progress_inactive
	self._network_timer_state = NETWORK_TIMER_STATES.pause

	local side_system = Managers.state.extension:system("side_system")

	self._player_side = side_system:get_default_player_side_name()
	self._side_system = side_system
end

MissionObjectiveZoneCaptureExtension.setup_from_component = function (self, num_player_in_zone, time_in_zone, zone_type)
	self._number_of_players_in_zone = num_player_in_zone
	self._time_in_zone = time_in_zone
	self._zone_type = zone_type

	self._networked_timer_extension:setup_from_component(time_in_zone)
end

MissionObjectiveZoneCaptureExtension.update = function (self, dt, t)
	if not self._activated then
		return
	end

	if self._is_server then
		self:_update_server()
	end
end

MissionObjectiveZoneCaptureExtension._update_server = function (self)
	local fulfill_in_zone_check, _ = self:_players_fulfill_in_zone_check()
	local new_state

	if self._current_server_state == SERVER_STATES.progress_inactive then
		if fulfill_in_zone_check then
			new_state = SERVER_STATES.progress_active
		else
			self:_progress_inactive()
		end
	elseif self._current_server_state == SERVER_STATES.progress_active then
		if not fulfill_in_zone_check then
			new_state = SERVER_STATES.progress_inactive
		else
			self:_progress_active()
		end
	elseif self._current_server_state == SERVER_STATES.progress_finished then
		self:zone_finished()
	end

	if new_state then
		self:_set_server_state(new_state)
	end
end

MissionObjectiveZoneCaptureExtension._progress_active = function (self)
	if self._network_timer_state ~= NETWORK_TIMER_STATES.play then
		self:_set_network_timer_state(NETWORK_TIMER_STATES.play)
	end

	local remaining_time = self._networked_timer_extension:get_remaining_time()

	if remaining_time == 0 then
		self:_set_server_state(SERVER_STATES.progress_finished)
	end
end

MissionObjectiveZoneCaptureExtension._progress_inactive = function (self)
	if self._network_timer_state ~= NETWORK_TIMER_STATES.pause then
		self:_set_network_timer_state(NETWORK_TIMER_STATES.pause)
	end
end

MissionObjectiveZoneCaptureExtension._players_fulfill_in_zone_check = function (self)
	local side_name = self._player_side
	local side_system = self._side_system
	local side = side_system:get_side_from_name(side_name)
	local valid_player_units = side.valid_player_units
	local players_in_zone, total_players = 0, #valid_player_units

	for i = 1, total_players do
		local player_unit = valid_player_units[i]
		local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")
		local character_state_component = unit_data_extension and unit_data_extension:read_component("character_state")
		local requires_allied_interaction_help = character_state_component and PlayerUnitStatus.requires_allied_interaction_help(character_state_component)
		local player_position = POSITION_LOOKUP[player_unit]
		local in_zone = self:point_in_zone(player_position)

		if in_zone or requires_allied_interaction_help then
			players_in_zone = players_in_zone + 1
		end
	end

	local num_players_to_trigger = self._number_of_players_in_zone
	local all_inside = total_players > 0 and total_players == players_in_zone

	return all_inside or num_players_to_trigger <= players_in_zone, players_in_zone
end

MissionObjectiveZoneCaptureExtension._set_server_state = function (self, state)
	self._current_server_state = state
end

MissionObjectiveZoneCaptureExtension._set_network_timer_state = function (self, timer_state)
	if self._is_server then
		if timer_state == NETWORK_TIMER_STATES.pause then
			self._networked_timer_extension:pause()
		elseif timer_state == NETWORK_TIMER_STATES.play then
			self._networked_timer_extension:start()
		end

		self._network_timer_state = timer_state
	end
end

MissionObjectiveZoneCaptureExtension.current_progression = function (self)
	local progression = self._activated and self._networked_timer_extension:progression() or 0

	return progression
end

return MissionObjectiveZoneCaptureExtension

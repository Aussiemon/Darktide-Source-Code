-- chunkname: @scripts/extension_systems/mission_objective_zone/mission_objective_zone_base_extension.lua

local MissionObjectiveScanning = require("scripts/settings/mission_objective/mission_objective_scanning")
local Vo = require("scripts/utilities/vo")
local MissionObjectiveZoneBaseExtension = class("MissionObjectiveZoneBaseExtension")

MissionObjectiveZoneBaseExtension.UPDATE_DISABLED_BY_DEFAULT = true

local SCANNING_VO_LINES = MissionObjectiveScanning.vo_trigger_ids
local RETURN_TO_SERVO_SKULL_HEADER = "loc_objective_zone_scanning_return_to_servoskull_header"
local RETURN_TO_SERVO_SKULL_DESC = "loc_objective_zone_scanning_return_to_servoskull_desc"

MissionObjectiveZoneBaseExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._is_server = extension_init_context.is_server
	self._owner_system = extension_init_context.owner_system
	self._unit = unit
	self._activated = false
	self._mission_objective_target_extension = nil
	self._is_local_objective_marker_enabled = nil
	self._zone_type = "base"
	self._progress_ui_type = "none"
	self._return_to_skull = false
	self._start_finish_zone_timer = false
	self._finish_zone_timer = 1
	self._use_vo = true
	self._start_vo_line_timer = false
	self._vo_line_interval = MissionObjectiveScanning.zone_settings.vo_trigger_time
	self._vo_line_timer = self._vo_line_interval

	local mission_objective_zone_system = Managers.state.extension:system("mission_objective_zone_system")

	self._mission_objective_zone_system = mission_objective_zone_system
	self._mission_objective_system = Managers.state.extension:system("mission_objective_system")
end

MissionObjectiveZoneBaseExtension.setup_from_component = function (self)
	return
end

MissionObjectiveZoneBaseExtension.extensions_ready = function (self, world, unit)
	local mission_objective_target_extension = ScriptUnit.has_extension(unit, "mission_objective_target_system")

	self._mission_objective_target_extension = mission_objective_target_extension
end

MissionObjectiveZoneBaseExtension.hot_join_sync = function (self, unit, sender, channel)
	local level_unit_id = Managers.state.unit_spawner:level_index(self._unit)

	if self._activated then
		Managers.state.game_session:send_rpc_clients("rpc_mission_objective_zone_set_active", level_unit_id, true)
	end

	if self._is_waiting_for_player_confirmation then
		Managers.state.game_session:send_rpc_clients("rpc_mission_objective_zone_set_waiting_for_confirmation", level_unit_id)
	end
end

MissionObjectiveZoneBaseExtension.on_gameplay_post_init = function (self, world, unit)
	local mission_objective_target_extension = self._mission_objective_target_extension
	local objective_name = mission_objective_target_extension:objective_name()

	self._objective_name = objective_name

	local objective_group = mission_objective_target_extension:objective_group_id()

	self._objective_group = objective_group

	local mission_objective_system = self._mission_objective_system
	local synchronizer_unit = mission_objective_system:objective_synchronizer_unit(objective_name, objective_group)

	self._synchronizer_extension = ScriptUnit.has_extension(synchronizer_unit, "event_synchronizer_system")
end

MissionObjectiveZoneBaseExtension.update = function (self, unit, dt, t)
	if self._activated and self._is_server then
		if self._start_finish_zone_timer then
			local finish_zone_timer = self._finish_zone_timer

			if finish_zone_timer > 0 then
				finish_zone_timer = math.max(finish_zone_timer - dt, 0)
			else
				self._start_finish_zone_timer = false

				self:set_is_waiting_for_player_confirmation()
				self._synchronizer_extension:set_servo_skull_target_enabled(true)
				self:_play_vo(nil, SCANNING_VO_LINES.all_targets_scanned, true)
			end

			self._finish_zone_timer = finish_zone_timer
		end

		if self._start_vo_line_timer then
			self:_vo_timer(dt)
		end
	end
end

MissionObjectiveZoneBaseExtension._inform_skull_of_completion = function (self)
	if self._return_to_skull then
		self._start_finish_zone_timer = true
	else
		self:zone_finished()

		local mission_objective_system = Managers.state.extension:system("mission_objective_system")
		local objective = mission_objective_system:active_objective(self._objective_name, self._objective_group)

		objective:stage_done()
	end
end

MissionObjectiveZoneBaseExtension.point_in_zone = function (self, position)
	return Unit.is_point_inside_volume(self._unit, "g_mission_objective_zone_volume", position)
end

MissionObjectiveZoneBaseExtension.set_show_progress = function (self, enabled)
	local mission_objective_system = self._mission_objective_system

	if self._progress_ui_type == "counter" then
		mission_objective_system:set_objective_show_counter(self._objective_name, self._objective_group, enabled)
	elseif self._progress_ui_type == "bar" then
		mission_objective_system:set_objective_show_bar(self._objective_name, self._objective_group, enabled)
	end
end

MissionObjectiveZoneBaseExtension.zone_finished = function (self)
	self:set_show_progress(false)

	if self._is_server then
		local unit = self._unit
		local level_object_id = Managers.state.unit_spawner:level_index(unit)

		self._synchronizer_extension:register_finished_zone()

		local game_session_manager = Managers.state.game_session

		game_session_manager:send_rpc_clients("rpc_mission_objective_zone_finished", level_object_id)
	end

	Unit.flow_event(self._unit, "lua_zone_finished")
	self:_deactivate_zone()
end

MissionObjectiveZoneBaseExtension.activate_zone = function (self)
	self:set_active(true)
end

MissionObjectiveZoneBaseExtension._deactivate_zone = function (self)
	self:set_active(false)
end

MissionObjectiveZoneBaseExtension.reset = function (self)
	self:_deactivate_zone()
end

MissionObjectiveZoneBaseExtension.set_active = function (self, active)
	if active == self._activated then
		return
	end

	self._activated = active

	if active then
		Unit.flow_event(self._unit, "lua_zone_activated")
		self:_enable_update()
		self:set_show_progress(true)
	else
		self:_disable_update()

		if self._mission_objective_target_extension and self._is_local_objective_marker_enabled then
			self._mission_objective_target_extension:remove_unit_marker()

			self._is_local_objective_marker_enabled = false
		end
	end

	if self._is_server then
		local level_unit_id = Managers.state.unit_spawner:level_index(self._unit)

		Managers.state.game_session:send_rpc_clients("rpc_mission_objective_zone_set_active", level_unit_id, active)
	end
end

MissionObjectiveZoneBaseExtension.activated = function (self)
	return self._activated
end

MissionObjectiveZoneBaseExtension.zone_type = function (self)
	return self._zone_type
end

MissionObjectiveZoneBaseExtension.objective_name = function (self)
	return self._objective_name
end

MissionObjectiveZoneBaseExtension.objective_group_id = function (self)
	return self._objective_group
end

MissionObjectiveZoneBaseExtension.is_scanning_zone = function (self)
	return self._zone_type == "scan"
end

MissionObjectiveZoneBaseExtension.is_capture_zone = function (self)
	return self._zone_type == "capture"
end

MissionObjectiveZoneBaseExtension.set_seed = function (self, seed)
	self._seed = seed
end

MissionObjectiveZoneBaseExtension.current_progression = function (self)
	return
end

MissionObjectiveZoneBaseExtension.max_progression = function (self)
	return
end

MissionObjectiveZoneBaseExtension.set_is_waiting_for_player_confirmation = function (self)
	self._is_waiting_for_player_confirmation = true

	if self._is_server then
		local mission_objective_system = self._mission_objective_system

		mission_objective_system:override_ui_string(self._objective_name, self._objective_group, RETURN_TO_SERVO_SKULL_HEADER, RETURN_TO_SERVO_SKULL_DESC)
		self:set_show_progress(false)

		local level_object_id = Managers.state.unit_spawner:level_index(self._unit)

		Managers.state.game_session:send_rpc_clients("rpc_mission_objective_zone_set_waiting_for_confirmation", level_object_id)
	end
end

MissionObjectiveZoneBaseExtension.is_waiting_for_player_confirmation = function (self)
	local is_waiting_for_player_confirmation = self._is_waiting_for_player_confirmation

	return is_waiting_for_player_confirmation
end

MissionObjectiveZoneBaseExtension._enable_update = function (self)
	self._owner_system:enable_update_function(self.__class_name, "update", self._unit, self)
end

MissionObjectiveZoneBaseExtension._disable_update = function (self)
	self._owner_system:disable_update_function(self.__class_name, "update", self._unit, self)
end

MissionObjectiveZoneBaseExtension.unit = function (self)
	return self._unit
end

MissionObjectiveZoneBaseExtension._vo_timer = function (self, dt)
	local vo_line_timer = self._vo_line_timer

	if vo_line_timer > 0 then
		vo_line_timer = math.max(vo_line_timer - dt, 0)
	else
		vo_line_timer = self._vo_line_interval

		local is_mission_giver_line = true
		local player

		self:_play_vo(player, SCANNING_VO_LINES.event_scan_skull_waiting, is_mission_giver_line)
	end

	self._vo_line_timer = vo_line_timer
end

MissionObjectiveZoneBaseExtension._play_vo = function (self, player, scanning_vo_line, is_mission_giver_line)
	if not self._use_vo then
		return
	end

	if is_mission_giver_line then
		local mission_objective = self._mission_objective_system:active_objective(self._objective_name, self._objective_group)
		local voice_profile = mission_objective:mission_giver_voice_profile()

		if voice_profile then
			local concept = MissionObjectiveScanning.vo_settings.concept

			Vo.mission_giver_vo_event(voice_profile, concept, scanning_vo_line)
		else
			Vo.mission_giver_mission_info_vo("rule_based", nil, scanning_vo_line)
		end
	else
		local player_unit = player.player_unit

		if not ALIVE[player_unit] then
			return
		end

		Vo.generic_mission_vo_event(player_unit, scanning_vo_line)
	end
end

MissionObjectiveZoneBaseExtension.reset_vo_timer = function (self)
	if self._is_server then
		self._vo_line_timer = self._vo_line_interval
	end
end

MissionObjectiveZoneBaseExtension.abort_vo_timer = function (self)
	if self._is_server then
		self._start_vo_line_timer = false
		self._vo_line_timer = self._vo_line_interval
	end
end

return MissionObjectiveZoneBaseExtension

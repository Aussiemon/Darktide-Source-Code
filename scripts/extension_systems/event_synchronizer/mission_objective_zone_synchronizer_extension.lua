-- chunkname: @scripts/extension_systems/event_synchronizer/mission_objective_zone_synchronizer_extension.lua

local LevelProps = require("scripts/settings/level_prop/level_props")
local MissionObjectiveZoneSynchronizerExtension = class("MissionObjectiveZoneSynchronizerExtension", "EventSynchronizerBaseExtension")

MissionObjectiveZoneSynchronizerExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	MissionObjectiveZoneSynchronizerExtension.super.init(self, extension_init_context, unit, extension_init_data, ...)

	self._is_server = extension_init_context.is_server
	self._num_zones_in_mission_objective = 0
	self._objective_name = "default"
	self._mission_objective_zone_system = nil
	self._servo_skull_activator_extension = nil
	self._servo_skull_unit = nil
	self._servo_skull_target_extension = nil
	self._spline_follower_extension = nil
	self._current_zone_index = 1
	self._on_last_spline = false

	Unit.flow_event(unit, "lua_unit_visibility_disable")
end

MissionObjectiveZoneSynchronizerExtension.setup_from_component = function (self, num_zones_in_mission_objective, objective_name, auto_start, register_on_spawn)
	local unit = self._unit

	self._num_zones_in_mission_objective = num_zones_in_mission_objective
	self._objective_name = objective_name
	self._auto_start = auto_start

	if register_on_spawn then
		self._group_id = self._mission_objective_system:register_objective_synchronizer(objective_name, nil, unit)
	end
end

MissionObjectiveZoneSynchronizerExtension.register = function (self)
	local unit = self._unit

	self._group_id = self._mission_objective_system:register_objective_synchronizer(self._objective_name, nil, unit)
end

MissionObjectiveZoneSynchronizerExtension.destroy = function (self)
	self:_unregister_servo_skull()
end

MissionObjectiveZoneSynchronizerExtension.on_gameplay_post_init = function (self, unit)
	self._mission_objective_zone_system = Managers.state.extension:system("mission_objective_zone_system")
end

MissionObjectiveZoneSynchronizerExtension.hot_join_sync = function (self, sender, channel)
	local servo_skull_unit = self._servo_skull_unit

	if servo_skull_unit then
		local level_unit_id = Managers.state.unit_spawner:level_index(self._unit)
		local servo_skull_unit_go_id = Managers.state.unit_spawner:game_object_id(servo_skull_unit)

		Managers.state.game_session:send_rpc_clients("rpc_event_synchronizer_set_servo_skull", level_unit_id, servo_skull_unit_go_id)
	end
end

MissionObjectiveZoneSynchronizerExtension.spawn_servo_skull = function (self, position, rotation)
	local servo_skull = "servo_skull"
	local prop_settings = LevelProps[servo_skull]
	local servo_skull_unit_name = prop_settings.unit_name
	local unit_spawner_manager = Managers.state.unit_spawner
	local spawned_servo_skull_unit, game_object_id = unit_spawner_manager:spawn_network_unit(servo_skull_unit_name, "level_prop", position, rotation, nil, prop_settings)

	self:register_servo_skull(spawned_servo_skull_unit)

	local game_session_manager = Managers.state.game_session
	local level_unit_id = Managers.state.unit_spawner:level_index(self._unit)

	game_session_manager:send_rpc_clients("rpc_event_synchronizer_set_servo_skull", level_unit_id, game_object_id)
	self:_evaluate_next_step()
end

MissionObjectiveZoneSynchronizerExtension.register_servo_skull = function (self, servo_skull_unit)
	self._servo_skull_unit = servo_skull_unit
	self._servo_skull_extension = ScriptUnit.extension(servo_skull_unit, "servo_skull_system")
	self._spline_follower_extension = ScriptUnit.extension(servo_skull_unit, "spline_follower_system")

	local servo_skull_target_extension = ScriptUnit.extension(servo_skull_unit, "mission_objective_target_system")

	self._servo_skull_target_extension = servo_skull_target_extension

	servo_skull_target_extension:remove_unit_marker()
	servo_skull_target_extension:set_objective_name(self._objective_name)
	servo_skull_target_extension:set_objective_group_id(self._group_id)

	if self._is_server then
		self:set_servo_skull_target_enabled(false)
	end
end

MissionObjectiveZoneSynchronizerExtension.set_servo_skull_target_enabled = function (self, enabled)
	local active_objective = self._mission_objective_system:active_objective(self._objective_name, self._group_id)

	if self._is_server then
		if enabled then
			active_objective:set_marker_type("objective")
			self._servo_skull_target_extension:add_unit_marker()
		else
			self._servo_skull_target_extension:remove_unit_marker()
		end
	else
		local servo_skull_unit = self._servo_skull_unit

		if enabled then
			active_objective:set_marker_type("objective")
			active_objective:add_marker(servo_skull_unit)
		else
			active_objective:remove_marker(servo_skull_unit)
		end
	end
end

MissionObjectiveZoneSynchronizerExtension.follow_spline = function (self)
	local objective_name = self._objective_name
	local group_id = self._group_id
	local spline_follower_extension = self._spline_follower_extension

	spline_follower_extension:follow_spline(objective_name, group_id)

	if self._is_server then
		self:set_servo_skull_target_enabled(true)

		local level_unit_id = Managers.state.unit_spawner:level_index(self._unit)

		Managers.state.game_session:send_rpc_clients("rpc_event_mission_objective_zone_follow_spline", level_unit_id)
		Unit.flow_event(self._unit, "lua_at_start_of_spline")
	end
end

MissionObjectiveZoneSynchronizerExtension.at_end_of_spline = function (self, last_spline)
	if self._is_server then
		self._on_last_spline = last_spline

		local activate_zone = true

		self:_evaluate_next_step(activate_zone)
		self:set_servo_skull_target_enabled(false)
		Unit.flow_event(self._unit, "lua_at_end_of_spline")
	end
end

MissionObjectiveZoneSynchronizerExtension._unregister_servo_skull = function (self)
	if self._is_server then
		local unit_spawner_manager = Managers.state.unit_spawner
		local servo_skull_unit = self._servo_skull_unit

		if servo_skull_unit then
			unit_spawner_manager:mark_for_deletion(servo_skull_unit)

			self._servo_skull_unit = nil
		end

		self._servo_skull_target_extension = nil
		self._servo_skull_activator_extension = nil
	end
end

MissionObjectiveZoneSynchronizerExtension.register_connected_units = function (self)
	local mission_objective_zone_system = self._mission_objective_zone_system
	local selected_units = mission_objective_zone_system:retrieve_selected_units_for_event(self._objective_name, self._group_id)

	return selected_units
end

MissionObjectiveZoneSynchronizerExtension.register_servo_skull_activator_extension = function (self, servo_skull_activator_extension)
	self._servo_skull_activator_extension = servo_skull_activator_extension
end

MissionObjectiveZoneSynchronizerExtension.start_event = function (self)
	if self._is_server then
		if self._servo_skull_activator_extension then
			self._servo_skull_activator_extension:on_start_event()
		else
			self:_evaluate_next_step()
		end
	end

	MissionObjectiveZoneSynchronizerExtension.super.start_event(self)
end

MissionObjectiveZoneSynchronizerExtension.update = function (self, unit, dt, t)
	if self._mission_active then
		local objective_name = self._objective_name
		local objective_group = self._group_id
		local mission_objective = self._mission_objective_system:active_objective(objective_name, objective_group)

		if mission_objective then
			local mission_objective_zone_system = self._mission_objective_zone_system

			mission_objective:update_player_state(mission_objective_zone_system:players_inside_status(objective_name, objective_group))
		end
	end
end

MissionObjectiveZoneSynchronizerExtension.register_finished_zone = function (self)
	self:_evaluate_next_step()
end

MissionObjectiveZoneSynchronizerExtension._evaluate_next_step = function (self, activate_zone)
	local mission_objective_zone_system = self._mission_objective_zone_system
	local objective_name = self._objective_name
	local objective_group = self._group_id

	if self._is_server then
		local selected_zone_units = mission_objective_zone_system:retrieve_selected_units_for_event(objective_name, objective_group)
		local current_index = self._current_zone_index

		if current_index > #selected_zone_units then
			self:_event_completed()
		elseif self:_has_connected_spline() and not self._on_last_spline and not activate_zone then
			self:follow_spline()
		else
			local unit = selected_zone_units[current_index]

			self._current_zone_index = current_index + 1

			self._mission_objective_zone_system:activate_zone(unit)
		end
	end
end

MissionObjectiveZoneSynchronizerExtension._event_completed = function (self)
	self:_unregister_servo_skull()

	self._current_index = 1
	self._on_last_spline = false
end

MissionObjectiveZoneSynchronizerExtension.finished_event = function (self)
	if self:uses_servo_skull() then
		self:_unregister_servo_skull()
	end

	MissionObjectiveZoneSynchronizerExtension.super.finished_event(self)
end

MissionObjectiveZoneSynchronizerExtension.num_zones_in_mission_objective = function (self)
	return self._num_zones_in_mission_objective
end

MissionObjectiveZoneSynchronizerExtension._has_connected_spline = function (self)
	local objective_name = self._objective_name
	local objective_group = self._group_id
	local mission_objective_zone_system = self._mission_objective_zone_system

	return mission_objective_zone_system:has_spline_path(objective_name, objective_group)
end

MissionObjectiveZoneSynchronizerExtension.has_current_active_zone = function (self)
	local objective_name = self._objective_name
	local objective_group = self._group_id
	local mission_objective_zone_system = self._mission_objective_zone_system
	local current_active_zone = mission_objective_zone_system:current_active_zone(objective_name, objective_group)

	return current_active_zone ~= nil
end

MissionObjectiveZoneSynchronizerExtension.current_active_zone_count = function (self)
	local objective_name = self._objective_name
	local objective_group = self._group_id
	local mission_objective_zone_system = self._mission_objective_zone_system

	return mission_objective_zone_system:current_active_zone_count(objective_name, objective_group)
end

MissionObjectiveZoneSynchronizerExtension.uses_servo_skull = function (self)
	return self._servo_skull_unit or self._servo_skull_activator_extension
end

MissionObjectiveZoneSynchronizerExtension.zone_progression = function (self)
	local objective_name = self._objective_name
	local objective_group = self._group_id
	local mission_objective_zone_system = self._mission_objective_zone_system

	return mission_objective_zone_system:zone_progression(objective_name, objective_group)
end

MissionObjectiveZoneSynchronizerExtension.max_progression = function (self)
	local objective_name = self._objective_name
	local objective_group = self._group_id
	local mission_objective_zone_system = self._mission_objective_zone_system

	return mission_objective_zone_system:current_active_zone_objective_max_progression(objective_name, objective_group)
end

MissionObjectiveZoneSynchronizerExtension.progression = function (self)
	local objective_name = self._objective_name
	local objective_group = self._group_id
	local mission_objective_zone_system = self._mission_objective_zone_system

	return mission_objective_zone_system:progression(objective_name, objective_group)
end

MissionObjectiveZoneSynchronizerExtension.second_progression = function (self)
	local mission_objective_zone_system = self._mission_objective_zone_system
	local second_progression = mission_objective_zone_system:second_progression()

	return second_progression
end

MissionObjectiveZoneSynchronizerExtension.reset = function (self)
	MissionObjectiveZoneSynchronizerExtension.super.reset(self)

	self._current_zone_index = 1
	self._on_last_spline = false

	while true do
		local objective_name = self._objective_name
		local objective_group = self._group_id
		local mission_objective_zone_system = self._mission_objective_zone_system
		local current_active_zone = mission_objective_zone_system:current_active_zone(objective_name, objective_group)

		if current_active_zone then
			current_active_zone:reset()
		else
			break
		end
	end
end

return MissionObjectiveZoneSynchronizerExtension

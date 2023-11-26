-- chunkname: @scripts/extension_systems/mission_objective_zone/mission_objective_zone_system.lua

require("scripts/extension_systems/mission_objective_zone/mission_objective_zone_base_extension")
require("scripts/extension_systems/mission_objective_zone/mission_objective_zone_capture_extension")
require("scripts/extension_systems/mission_objective_zone/mission_objective_zone_scan_extension")

local LevelProps = require("scripts/settings/level_prop/level_props")
local MissionObjectiveScanning = require("scripts/settings/mission_objective/mission_objective_scanning")
local MissionObjectiveZoneSystem = class("MissionObjectiveZoneSystem", "ExtensionSystemBase")

MissionObjectiveZoneSystem.SERVO_SKULL_TARGET_STATES = table.enum("disabled", "enabled")

local SERVO_SKULL_MARKER_TYPES = MissionObjectiveScanning.servo_skull_marker_types
local SERVO_SKULL_TARGET_STATES = MissionObjectiveZoneSystem.SERVO_SKULL_TARGET_STATES
local CLIENT_RPCS = {
	"rpc_mission_objective_zone_system_hot_join_sync",
	"rpc_mission_objective_zone_hot_join_sync",
	"rpc_mission_objective_zone_system_on_servo_skull_spawned",
	"rpc_mission_objective_zone_scan_add_player_scanned_object",
	"rpc_mission_objective_zone_register_scannable_unit",
	"rpc_mission_objective_zone_set_waiting_for_confirmation",
	"rpc_event_mission_objective_zone_activate_zone",
	"rpc_event_mission_objective_zone_follow_spline",
	"rpc_mission_objective_zone_finished"
}

MissionObjectiveZoneSystem.init = function (self, context, system_init_data, ...)
	MissionObjectiveZoneSystem.super.init(self, context, system_init_data, ...)

	self._zone_units = {}
	self._selected_zone_units = {}
	self._current_index = 1
	self._servo_skull_unit = nil
	self._servo_skull_target_extension = nil
	self._progress = 0
	self._scannable_units = {}
	self._seed = self._is_server and system_init_data.level_seed or nil
	self._mission_objective_system = nil
	self._spline_follower_system = nil
	self._network_event_delegate = context.network_event_delegate
	self._current_objective_name = nil
	self._physics_world = context.physics_world

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

MissionObjectiveZoneSystem.on_gameplay_post_init = function (self, level)
	self._mission_objective_system = Managers.state.extension:system("mission_objective_system")
	self._spline_follower_system = Managers.state.extension:system("spline_follower_system")

	self:_group_units_by_objective_name()

	if self._is_server then
		self:_select_units_for_event()
	end

	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		if extension.on_gameplay_post_init then
			extension:on_gameplay_post_init(level)
		end
	end
end

MissionObjectiveZoneSystem.hot_join_sync = function (self, sender, channel)
	MissionObjectiveZoneSystem.super.hot_join_sync(self, sender, channel)

	local seed = self._seed
	local servo_skull_unit = self._servo_skull_unit
	local servo_skull_unit_go_id = servo_skull_unit and Managers.state.unit_spawner:game_object_id(servo_skull_unit) or NetworkConstants.invalid_game_object_id

	RPC.rpc_mission_objective_zone_system_hot_join_sync(channel, seed, servo_skull_unit_go_id)

	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		if extension:activated() then
			local level_unit_id = Managers.state.unit_spawner:level_index(unit)

			if level_unit_id then
				local num_scanned_objects_per_player = extension:num_scanned_objects_per_player()

				for player, num_scanned_objects in pairs(num_scanned_objects_per_player) do
					if num_scanned_objects > 0 then
						local peer_id = player:peer_id()
						local local_player_id = player:local_player_id()

						RPC.rpc_mission_objective_zone_scan_add_player_scanned_object(channel, level_unit_id, peer_id, local_player_id, num_scanned_objects)
					end
				end

				RPC.rpc_mission_objective_zone_hot_join_sync(channel, level_unit_id)
			end
		end
	end
end

MissionObjectiveZoneSystem.destroy = function (self)
	if self._is_server then
		-- Nothing
	else
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	MissionObjectiveZoneSystem.super.destroy(self)
end

MissionObjectiveZoneSystem._group_units_by_objective_name = function (self)
	local unit_to_extension_map = self._unit_to_extension_map
	local zone_units = self._zone_units

	for unit, extension in pairs(unit_to_extension_map) do
		local mission_objective_target_extension = ScriptUnit.extension(unit, "mission_objective_target_system")
		local objective_name = mission_objective_target_extension:objective_name()
		local unit_list = zone_units[objective_name]

		if not unit_list then
			unit_list = {}
			zone_units[objective_name] = unit_list
		end

		unit_list[#unit_list + 1] = unit
	end

	self._zone_units = zone_units
end

MissionObjectiveZoneSystem._select_units_for_event = function (self)
	local zone_units = self._zone_units
	local seed = self._seed
	local random_table
	local mission_objective_system = self._mission_objective_system

	for objective_name, units in pairs(zone_units) do
		local synchronizer_unit = mission_objective_system:get_objective_synchronizer_unit(objective_name)
		local synchronizer_unit_extension = ScriptUnit.extension(synchronizer_unit, "event_synchronizer_system")
		local num_active_zones = synchronizer_unit_extension:num_zones_in_mission_objective()
		local selected_units = {}
		local sorted_units = self:_sort_units_by_id(units)
		local num_units = #units
		local zone_unit_extension = self._unit_to_extension_map[sorted_units[num_units]]

		synchronizer_unit_extension:register_zone_type(zone_unit_extension:zone_type())

		if self:has_connected_spline_path(objective_name) then
			local spline_follower_system = self._spline_follower_system
			local spline_path_end_positions = spline_follower_system:spline_path_end_positions(objective_name)
			local num_end_positions = #spline_path_end_positions
			local start_num_zones = math.min(num_end_positions, num_active_zones)
			local counter = 0

			for i = 1, start_num_zones do
				local spline_end_position = spline_path_end_positions[i]
				local selected_unit, closest, zone_seed

				for n = 1, num_units do
					local unit = sorted_units[n]
					local unit_extension = self._unit_to_extension_map[unit]

					if counter < start_num_zones and unit_extension:point_in_zone(spline_end_position) then
						local unit_position = Unit.world_position(unit, 1)
						local distance = Vector3.distance(unit_position, spline_end_position)

						if not closest or distance < closest then
							closest = distance
							selected_unit = unit
							seed, zone_seed = math.random_seed(seed)

							unit_extension:set_seed(zone_seed)
						end
					end
				end

				selected_units[#selected_units + 1] = selected_unit
				counter = counter + 1
			end
		else
			random_table, seed = table.generate_random_table(1, #units, seed)

			for i = 1, num_active_zones do
				local index = random_table[i]

				selected_units[#selected_units + 1] = sorted_units[index]
			end
		end

		self._selected_zone_units[objective_name] = selected_units
	end
end

MissionObjectiveZoneSystem._sort_units_by_id = function (self, units)
	if #units == 0 then
		return units
	end

	local function sort_comp(unit_l, unit_r)
		local unit_id_l = Managers.state.unit_spawner:level_index(unit_l)
		local unit_id_r = Managers.state.unit_spawner:level_index(unit_r)

		return unit_id_l < unit_id_r
	end

	table.sort(units, sort_comp)

	return units
end

MissionObjectiveZoneSystem.spawn_servo_skull = function (self, position, rotation)
	local servo_skull = "servo_skull"
	local prop_settings = LevelProps[servo_skull]
	local servo_skull_unit_name = prop_settings.unit_name
	local unit_spawner_manager = Managers.state.unit_spawner
	local spawned_servo_skull_unit, game_object_id = unit_spawner_manager:spawn_network_unit(servo_skull_unit_name, "level_prop", position, rotation, nil, prop_settings)

	self:_register_servo_skull(spawned_servo_skull_unit)

	local game_session_manager = Managers.state.game_session

	game_session_manager:send_rpc_clients("rpc_mission_objective_zone_system_on_servo_skull_spawned", game_object_id)
end

MissionObjectiveZoneSystem._register_servo_skull = function (self, servo_skull_unit)
	self._servo_skull_unit = servo_skull_unit
	self._spline_follower_extension = ScriptUnit.extension(servo_skull_unit, "spline_follower_system")

	local is_server = self._is_server

	if is_server then
		self._servo_skull_target_extension = ScriptUnit.extension(servo_skull_unit, "mission_objective_target_system")

		self._servo_skull_target_extension:remove_unit_marker()

		local objective_name = self._current_objective_name

		if objective_name then
			self._servo_skull_target_extension:set_objective_name(objective_name)
			self:set_servo_skull_target_state(SERVO_SKULL_TARGET_STATES.disabled, nil, is_server)
		end
	end
end

MissionObjectiveZoneSystem._unregister_servo_skull = function (self)
	if self._is_server then
		local unit_spawner_manager = Managers.state.unit_spawner
		local servo_skull_unit = self._servo_skull_unit

		if servo_skull_unit then
			unit_spawner_manager:mark_for_deletion(servo_skull_unit)

			self._servo_skull_unit = nil
		end

		self._servo_skull_target_extension = nil
	end
end

MissionObjectiveZoneSystem._evaluate_next_step = function (self, objective_name, activate_zone)
	if self._is_server then
		local selected_zone_units = self._selected_zone_units[objective_name]
		local current_index = self._current_index

		if current_index > #selected_zone_units then
			self:event_completed()
		elseif self:has_connected_spline_path(objective_name) and not self._on_last_spline and not activate_zone then
			if not self._servo_skull_unit then
				local spline_follower_system = self._spline_follower_system
				local position, rotation = spline_follower_system:spline_path_start_position_and_rotation(objective_name)

				self:spawn_servo_skull(position, rotation)
			end

			self:_follow_spline(objective_name)
		else
			local unit = selected_zone_units[current_index]

			current_index = current_index + 1
			self._current_index = current_index

			self:_activate_zone(unit)
		end
	end
end

MissionObjectiveZoneSystem._follow_spline = function (self, objective_name)
	local spline_follower_extension = self._spline_follower_extension

	spline_follower_extension:follow_spline(objective_name)

	local is_server = self._is_server

	if is_server then
		self:set_servo_skull_target_state(SERVO_SKULL_TARGET_STATES.enabled, SERVO_SKULL_MARKER_TYPES.objective, is_server)

		local objective_name_id = NetworkLookup.mission_objective_names[objective_name]

		Managers.state.game_session:send_rpc_clients("rpc_event_mission_objective_zone_follow_spline", objective_name_id)

		local synchronizer_unit = self:_current_synchronizer()
		local synchronizer_unit_extension = ScriptUnit.extension(synchronizer_unit, "event_synchronizer_system")

		synchronizer_unit_extension:at_start_of_spline()
	end
end

MissionObjectiveZoneSystem._activate_zone = function (self, unit)
	local extension = self._unit_to_extension_map[unit]

	extension:activate_zone()

	if self._is_server then
		local level_unit_id = Managers.state.unit_spawner:level_index(unit)

		Managers.state.game_session:send_rpc_clients("rpc_event_mission_objective_zone_activate_zone", level_unit_id)
	end
end

MissionObjectiveZoneSystem.at_end_of_spline = function (self, last_spline)
	local is_server = self._is_server

	if is_server and self._current_objective_name then
		self._on_last_spline = last_spline

		local activate_zone = true

		self:_evaluate_next_step(self._current_objective_name, activate_zone)
		self:set_servo_skull_target_state(SERVO_SKULL_TARGET_STATES.disabled, nil, is_server)

		local synchronizer_unit = self:_current_synchronizer()
		local synchronizer_unit_extension = ScriptUnit.extension(synchronizer_unit, "event_synchronizer_system")

		synchronizer_unit_extension:at_end_of_spline()
	end
end

MissionObjectiveZoneSystem.set_servo_skull_target_state = function (self, servo_skull_target_state, marker_type, is_server)
	local mission_objective_system = Managers.state.extension:system("mission_objective_system")
	local mission_name = self._current_objective_name
	local active_objective = mission_objective_system:active_objective(mission_name)

	if is_server then
		if servo_skull_target_state == SERVO_SKULL_TARGET_STATES.enabled then
			active_objective:set_marker_type(marker_type)
			self._servo_skull_target_extension:add_unit_marker()
		elseif servo_skull_target_state == SERVO_SKULL_TARGET_STATES.disabled then
			self._servo_skull_target_extension:remove_unit_marker()
		end
	else
		local servo_skull_unit = self._servo_skull_unit

		if servo_skull_target_state == SERVO_SKULL_TARGET_STATES.enabled then
			active_objective:set_marker_type(marker_type)
			active_objective:add_marker(servo_skull_unit)
		elseif servo_skull_target_state == SERVO_SKULL_TARGET_STATES.disabled then
			active_objective:remove_marker(servo_skull_unit)
		end
	end
end

MissionObjectiveZoneSystem._current_synchronizer = function (self)
	local mission_objective_system = self._mission_objective_system
	local objective_name = self._current_objective_name
	local synchronizer_unit = mission_objective_system:get_objective_synchronizer_unit(objective_name)

	return synchronizer_unit
end

MissionObjectiveZoneSystem.delete_units = function (self)
	if self._is_server then
		self:_unregister_servo_skull()
	end
end

MissionObjectiveZoneSystem.retrieve_selected_units_for_event = function (self, objective_name)
	local selected_units = self._selected_zone_units[objective_name]

	return selected_units
end

MissionObjectiveZoneSystem.start_event = function (self, objective_name)
	self._current_objective_name = objective_name
	self._progress = 0

	if self._servo_skull_target_extension then
		self._servo_skull_target_extension:set_objective_name(objective_name)
	end

	self:_evaluate_next_step(objective_name)
end

MissionObjectiveZoneSystem.register_objective_name = function (self, objective_name)
	self._current_objective_name = objective_name
end

MissionObjectiveZoneSystem.register_scannable_unit = function (self, scannable_unit)
	local unit_to_extension_map = self._unit_to_extension_map
	local scannable_unit_position = POSITION_LOOKUP[scannable_unit]

	for _, extension in pairs(unit_to_extension_map) do
		if extension:point_in_zone(scannable_unit_position) then
			extension:register_scannable_unit(scannable_unit)
		end
	end
end

MissionObjectiveZoneSystem.current_active_zone = function (self)
	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		if extension:activated() then
			return extension
		end
	end

	return nil
end

MissionObjectiveZoneSystem.register_finished_zone = function (self)
	self._progress = self._progress + 1

	local objective_name = self._current_objective_name

	self:_evaluate_next_step(objective_name)
end

MissionObjectiveZoneSystem.reset_progression = function (self)
	self._progress = 0
end

MissionObjectiveZoneSystem.progression = function (self)
	local progress = self._progress

	return progress
end

MissionObjectiveZoneSystem.scannable_progression = function (self)
	local extension = self:current_active_zone()
	local scannable_progression = extension and extension:num_objets_banked() or 0

	return scannable_progression
end

MissionObjectiveZoneSystem.second_progression = function (self)
	local extension = self:current_active_zone()
	local second_progression = extension and extension:current_progression() or 0

	return second_progression
end

MissionObjectiveZoneSystem.seed = function (self)
	return self._seed
end

MissionObjectiveZoneSystem.has_connected_spline_path = function (self, objective_name)
	local spline_follower_system = self._spline_follower_system
	local has_connected_spline_path = spline_follower_system:has_spline_path(objective_name)

	return has_connected_spline_path
end

MissionObjectiveZoneSystem.current_objective_name = function (self)
	local objective_name = self._current_objective_name

	return objective_name
end

MissionObjectiveZoneSystem.event_completed = function (self)
	self:_unregister_servo_skull()

	self._current_objective_name = nil
	self._current_index = 1
	self._on_last_spline = false
end

MissionObjectiveZoneSystem.rpc_mission_objective_zone_system_hot_join_sync = function (self, channel_id, seed, game_object_id)
	self._seed = seed

	if game_object_id ~= NetworkConstants.invalid_game_object_id then
		local is_level_unit = false
		local servo_skull_unit = Managers.state.unit_spawner:unit(game_object_id, is_level_unit)

		self:_register_servo_skull(servo_skull_unit)
	end

	self:_select_units_for_event()
end

MissionObjectiveZoneSystem.rpc_mission_objective_zone_hot_join_sync = function (self, channel_id, level_unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(level_unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:activate_zone()
end

MissionObjectiveZoneSystem.rpc_mission_objective_zone_system_on_servo_skull_spawned = function (self, channel_id, game_object_id)
	local is_level_unit = false
	local unit = Managers.state.unit_spawner:unit(game_object_id, is_level_unit)

	self:_register_servo_skull(unit)
end

MissionObjectiveZoneSystem.rpc_mission_objective_zone_scan_add_player_scanned_object = function (self, channel_id, level_unit_id, peer_id, local_player_id, scanned_object_points)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(level_unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]
	local player = Managers.player:player(peer_id, local_player_id)

	extension:add_scanned_points_to_player(player, scanned_object_points)
end

MissionObjectiveZoneSystem.rpc_mission_objective_zone_register_scannable_unit = function (self, channel_id, level_unit_id, level_scanable_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(level_unit_id, is_level_unit)
	local scanable_unit = Managers.state.unit_spawner:unit(level_scanable_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:register_scannable_unit(scanable_unit)
end

MissionObjectiveZoneSystem.rpc_mission_objective_zone_set_waiting_for_confirmation = function (self, channel_id, level_unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(level_unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:set_is_waiting_for_player_confirmation()
end

MissionObjectiveZoneSystem.rpc_event_mission_objective_zone_follow_spline = function (self, channel_id, objective_name_id)
	local objective_name = NetworkLookup.mission_objective_names[objective_name_id]

	self:_follow_spline(objective_name)
end

MissionObjectiveZoneSystem.rpc_event_mission_objective_zone_activate_zone = function (self, channel_id, level_unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(level_unit_id, is_level_unit)

	self:_activate_zone(unit)
end

MissionObjectiveZoneSystem.rpc_mission_objective_zone_finished = function (self, channel_id, unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:zone_finished()
end

return MissionObjectiveZoneSystem

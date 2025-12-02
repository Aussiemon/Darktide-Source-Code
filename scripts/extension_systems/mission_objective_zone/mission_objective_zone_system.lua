-- chunkname: @scripts/extension_systems/mission_objective_zone/mission_objective_zone_system.lua

require("scripts/extension_systems/mission_objective_zone/mission_objective_zone_base_extension")
require("scripts/extension_systems/mission_objective_zone/mission_objective_zone_capture_extension")
require("scripts/extension_systems/mission_objective_zone/mission_objective_zone_scan_extension")

local MissionObjectiveZoneSystem = class("MissionObjectiveZoneSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_mission_objective_zone_hot_join_sync",
	"rpc_mission_objective_zone_register_scannable_unit",
	"rpc_mission_objective_zone_set_waiting_for_confirmation",
	"rpc_event_mission_objective_zone_activate_zone",
	"rpc_event_mission_objective_zone_follow_spline",
	"rpc_mission_objective_zone_finished",
}

MissionObjectiveZoneSystem.init = function (self, context, system_init_data, ...)
	MissionObjectiveZoneSystem.super.init(self, context, system_init_data, ...)

	self._zone_units = {}
	self._selected_zone_units = {}
	self._seed = system_init_data.level_seed
	self._spline_follower_system = nil
	self._network_event_delegate = context.network_event_delegate

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

MissionObjectiveZoneSystem.on_gameplay_post_init = function (self, level)
	self._spline_follower_system = Managers.state.extension:system("spline_follower_system")

	self:_group_units_by_objective_name()
	self:_select_units_for_event()
	self:call_gameplay_post_init_on_extensions(level)
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
	local zone_groups = self._zone_units

	table.clear(zone_groups)

	for unit, extension in pairs(unit_to_extension_map) do
		local mission_objective_target_extension = ScriptUnit.extension(unit, "mission_objective_target_system")
		local group_id = mission_objective_target_extension:objective_group_id()
		local objective_name = mission_objective_target_extension:objective_name()
		local zone_group = zone_groups[group_id]

		if not zone_group then
			zone_group = {}
			zone_groups[group_id] = zone_group
		end

		local unit_list = zone_group[objective_name]

		if not unit_list then
			unit_list = {}
			zone_group[objective_name] = unit_list
		end

		unit_list[#unit_list + 1] = unit
	end

	self._zone_units = zone_groups
end

MissionObjectiveZoneSystem._select_units_for_event = function (self)
	table.clear(self._selected_zone_units)

	local zone_units = self._zone_units
	local seed = self._seed
	local random_table
	local mission_objective_system = Managers.state.extension:system("mission_objective_system")

	for group_id, objective_groups in pairs(zone_units) do
		for objective_name, units in pairs(objective_groups) do
			local synchronizer_unit = mission_objective_system:objective_synchronizer_unit(objective_name, group_id)
			local synchronizer_unit_extension = ScriptUnit.extension(synchronizer_unit, "event_synchronizer_system")
			local num_active_zones = synchronizer_unit_extension:num_zones_in_mission_objective()
			local selected_units = {}
			local sorted_units = self:_sort_units_by_id(units)
			local num_units = #units
			local zone_unit_extension = self._unit_to_extension_map[sorted_units[num_units]]

			synchronizer_unit_extension:register_zone_type(zone_unit_extension:zone_type())

			if self:has_spline_path(objective_name, group_id) then
				local spline_follower_system = self._spline_follower_system
				local spline_path_end_positions = spline_follower_system:objective_spline_path_end_positions(objective_name, group_id)
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

			self._selected_zone_units[group_id] = self._selected_zone_units[group_id] or {}

			local objective_group = self._selected_zone_units[group_id]

			objective_group[objective_name] = selected_units
		end
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

MissionObjectiveZoneSystem.activate_zone = function (self, unit)
	local extension = self._unit_to_extension_map[unit]

	extension:activate_zone()

	if self._is_server then
		local level_unit_id = Managers.state.unit_spawner:level_index(unit)

		Managers.state.game_session:send_rpc_clients("rpc_event_mission_objective_zone_activate_zone", level_unit_id)
	end
end

MissionObjectiveZoneSystem.retrieve_selected_units_for_event = function (self, objective_name, group_id)
	local objective_group = self._selected_zone_units[group_id]
	local selected_units = objective_group[objective_name]

	return selected_units
end

MissionObjectiveZoneSystem.register_scannable_unit = function (self, scannable_unit)
	local unit_to_extension_map = self._unit_to_extension_map
	local scannable_unit_position = POSITION_LOOKUP[scannable_unit]

	for _, extension in pairs(unit_to_extension_map) do
		if extension:is_scanning_zone() and extension:point_in_zone(scannable_unit_position) then
			extension:register_scannable_unit(scannable_unit)
		end
	end
end

MissionObjectiveZoneSystem.current_active_zone = function (self, objective_name, objective_group)
	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		local same_objective = extension:objective_name() == objective_name and extension:objective_group_id() == objective_group

		if same_objective and extension:activated() then
			return extension
		end
	end

	return nil
end

MissionObjectiveZoneSystem.any_active_scanning_zone = function (self)
	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		if extension:activated() and extension:is_scanning_zone() then
			return true
		end
	end

	return false
end

local SCANNABLE_UNITS = {}

MissionObjectiveZoneSystem.scannable_units = function (self)
	table.clear(SCANNABLE_UNITS)

	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		if extension:activated() and extension:is_scanning_zone() then
			local zone_units = extension:scannable_units()

			for i = 1, #zone_units do
				SCANNABLE_UNITS[zone_units[i]] = true
			end
		end
	end

	return SCANNABLE_UNITS
end

MissionObjectiveZoneSystem.zone_progression = function (self, objective_name, objective_group)
	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		local same_objective = extension:objective_name() == objective_name and extension:objective_group_id() == objective_group

		if same_objective and extension:activated() then
			return extension:current_progression()
		end
	end

	return 0
end

MissionObjectiveZoneSystem.progression = function (self, objective_name, objective_group)
	local unit_to_extension_map = self._unit_to_extension_map
	local progression = 0

	for unit, extension in pairs(unit_to_extension_map) do
		local same_objective = extension:objective_name() == objective_name and extension:objective_group_id() == objective_group

		if same_objective then
			progression = progression + extension:current_progression()
		end
	end

	return progression
end

MissionObjectiveZoneSystem.second_progression = function (self, objective_name, objective_group)
	local extension = self:current_active_zone(objective_name, objective_group)
	local second_progression = extension and extension:current_progression() or 0

	return second_progression
end

MissionObjectiveZoneSystem.seed = function (self)
	return self._seed
end

MissionObjectiveZoneSystem.has_spline_path = function (self, objective_name, group_id)
	local spline_follower_system = self._spline_follower_system

	return spline_follower_system:has_objective_spline_path(objective_name, group_id)
end

MissionObjectiveZoneSystem.rpc_mission_objective_zone_hot_join_sync = function (self, channel_id, level_unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(level_unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:activate_zone()
end

MissionObjectiveZoneSystem.rpc_mission_objective_zone_register_scannable_unit = function (self, channel_id, level_unit_id, level_scannable_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(level_unit_id, is_level_unit)
	local scannable_unit = Managers.state.unit_spawner:unit(level_scannable_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:register_scannable_unit(scannable_unit)
end

MissionObjectiveZoneSystem.rpc_mission_objective_zone_set_waiting_for_confirmation = function (self, channel_id, level_unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(level_unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:set_is_waiting_for_player_confirmation()
end

MissionObjectiveZoneSystem.rpc_event_mission_objective_zone_follow_spline = function (self, channel_id, level_unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(level_unit_id, is_level_unit)
	local synchronizer_unit_extension = ScriptUnit.extension(unit, "event_synchronizer_system")

	synchronizer_unit_extension:follow_spline()
end

MissionObjectiveZoneSystem.rpc_event_mission_objective_zone_activate_zone = function (self, channel_id, level_unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(level_unit_id, is_level_unit)

	self:activate_zone(unit)
end

MissionObjectiveZoneSystem.rpc_mission_objective_zone_finished = function (self, channel_id, unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:zone_finished()
end

return MissionObjectiveZoneSystem

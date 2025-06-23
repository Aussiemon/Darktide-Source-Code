-- chunkname: @scripts/extension_systems/respawn_beacon/respawn_beacon_system.lua

require("scripts/extension_systems/respawn_beacon/respawn_beacon_extension")

local MainPathQueries = require("scripts/utilities/main_path_queries")
local NavQueries = require("scripts/utilities/nav_queries")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local SpawnPointQueries = require("scripts/managers/main_path/utilities/spawn_point_queries")
local BEACON_ACTIVATION_DISTANCE = 45
local PLAYER_MOVE_PLAYERS_TO_BEACON_DISTANCE = 30
local RespawnBeaconSystem = class("RespawnBeaconSystem", "ExtensionSystemBase")

RespawnBeaconSystem.init = function (self, ...)
	RespawnBeaconSystem.super.init(self, ...)

	self._beacon_main_path_data = {}
	self._priority_respawn_beacon = nil
	self._current_active_respawn_beacon = nil
	self._in_hub = Managers.state.game_mode:is_social_hub()
	self._beacon_main_path_distance_lookup = {}
	self._current_update_unit = nil
	self._current_update_extension = nil
end

RespawnBeaconSystem.on_gameplay_post_init = function (self, level)
	local main_path_manager = Managers.state.main_path

	if not main_path_manager:is_main_path_available() then
		return
	end

	self._generate_respawn_beacons = true
end

RespawnBeaconSystem._create_respawn_beacons = function (self)
	local main_path_manager = Managers.state.main_path
	local sorted_beacons = {}
	local unit_to_extension_map, nav_world, beacon_main_path_data = self._unit_to_extension_map, self._nav_world, self._beacon_main_path_data
	local nav_spawn_points = main_path_manager:nav_spawn_points()

	if nav_spawn_points then
		for unit, extension in pairs(unit_to_extension_map) do
			local position = Unit.world_position(unit, 1)
			local target_navmesh_position = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, position, 1, 1, 1)

			if target_navmesh_position then
				local group_index = SpawnPointQueries.group_from_position(nav_world, nav_spawn_points, target_navmesh_position)
				local start_index = main_path_manager:node_index_by_nav_group_index(group_index)
				local end_index = start_index + 1
				local _, distance, percentage, _, segment_index = MainPathQueries.closest_position_between_nodes(position, start_index, end_index)
				local entry = {
					unit = unit,
					distance = distance,
					percentage = percentage,
					segment_index = segment_index
				}

				self._beacon_main_path_distance_lookup[unit] = distance

				local sorted_beacons_entry = {
					unit = unit,
					distance = distance,
					position = position
				}

				sorted_beacons[#sorted_beacons + 1] = sorted_beacons_entry

				local num_beacons = #beacon_main_path_data

				if num_beacons > 0 then
					for i = 1, num_beacons do
						local data = beacon_main_path_data[i]

						if distance < data.distance then
							table.insert(beacon_main_path_data, i, entry)

							break
						elseif i == num_beacons then
							beacon_main_path_data[i + 1] = entry
						end
					end
				else
					beacon_main_path_data[1] = entry
				end
			end
		end

		table.sort(sorted_beacons, function (t1, t2)
			return t1.distance < t2.distance
		end)
	end

	self._sorted_beacons = sorted_beacons
end

RespawnBeaconSystem.on_add_extension = function (self, world, unit, ...)
	local extension = RespawnBeaconSystem.super.on_add_extension(self, world, unit, ...)
	local current_update_unit = self._current_update_unit
	local unit_extension_data = self._unit_to_extension_map

	if current_update_unit == unit then
		self._current_update_unit, self._current_update_extension = next(unit_extension_data, current_update_unit)
	end

	return extension
end

RespawnBeaconSystem.on_remove_extension = function (self, unit, extension_name)
	RespawnBeaconSystem.super.on_remove_extension(self, unit, extension_name)

	local beacon_main_path_data = self._beacon_main_path_data
	local index

	for i = 1, #beacon_main_path_data do
		local data = beacon_main_path_data[i]

		if unit == data.unit then
			index = i

			break
		end
	end

	table.remove(beacon_main_path_data, index)

	local current_update_unit = self._current_update_unit
	local unit_extension_data = self._unit_to_extension_map

	if current_update_unit == unit then
		self._current_update_unit, self._current_update_extension = next(unit_extension_data, current_update_unit)
	end
end

RespawnBeaconSystem.make_respawn_beacon_priority = function (self, unit)
	if not self._is_server then
		return
	end

	self._priority_respawn_beacon = unit

	local side_system = Managers.state.extension:system("side_system")
	local default_player_side_name = side_system:get_default_player_side_name()
	local player_side = side_system:get_side_from_name(default_player_side_name)
	local side_id = player_side.side_id
	local should_move_players, hogtied_players = self:_update_hogtied_players(side_id)

	if should_move_players then
		self:_move_hogtied_players(hogtied_players, self._priority_respawn_beacon)
	end
end

RespawnBeaconSystem.remove_respawn_beacon_priority = function (self)
	if not self._is_server then
		return
	end

	self._priority_respawn_beacon = nil
end

RespawnBeaconSystem.fixed_update = function (self, context, dt, t, frame)
	RespawnBeaconSystem.super.fixed_update(self, context, dt, t, frame)

	if self._in_hub then
		return
	end

	if not self._is_server then
		return
	end

	if self._generate_respawn_beacons then
		local main_path_manager = Managers.state.main_path

		if not main_path_manager:is_main_path_ready() then
			return
		else
			self:_create_respawn_beacons()

			self._generate_respawn_beacons = nil
		end
	end

	local side_system = Managers.state.extension:system("side_system")
	local default_player_side_name = side_system:get_default_player_side_name()
	local player_side = side_system:get_side_from_name(default_player_side_name)
	local side_id = player_side.side_id
	local should_be_active = Managers.state.player_unit_spawn:has_players_waiting_to_spawn()

	if should_be_active then
		local best_beacon = self._priority_respawn_beacon or self._current_active_respawn_beacon

		best_beacon = best_beacon or self:_find_nearest_beacon(side_id)

		if best_beacon then
			local extension = self._unit_to_extension_map[best_beacon]

			extension:respawn_players()

			self._current_active_respawn_beacon = best_beacon
		end
	end

	local should_move_players, hogtied_players = self:_update_hogtied_players(side_id)

	if should_move_players then
		local best_beacon = self._priority_respawn_beacon

		best_beacon = best_beacon or self:_find_nearest_beacon(side_id)

		if best_beacon then
			self:_move_hogtied_players(hogtied_players, best_beacon)
		end
	end

	local unit_extension_data = self._unit_to_extension_map
	local current_update_unit = self._current_update_unit
	local current_update_extension = self._current_update_extension

	if current_update_unit then
		current_update_extension:update(current_update_unit, dt, t, context)
	end

	current_update_unit, current_update_extension = next(unit_extension_data, current_update_unit)
	self._current_update_unit = current_update_unit
	self._current_update_extension = current_update_extension
end

local hogtied_players = {}

RespawnBeaconSystem._update_hogtied_players = function (self, side_id)
	local players = Managers.player:players()

	table.clear(hogtied_players)

	local main_path_manager = Managers.state.main_path

	if #self._beacon_main_path_data == 0 then
		return false
	end

	if not main_path_manager:is_main_path_available() then
		return false
	end

	local _, behind_unit_player_distance = main_path_manager:behind_unit(side_id)

	if not behind_unit_player_distance then
		return false
	end

	for _, player in pairs(players) do
		local player_unit = player.player_unit

		if ALIVE[player_unit] then
			local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
			local character_state_component = unit_data_extension:read_component("character_state")

			if PlayerUnitStatus.is_hogtied(character_state_component) then
				hogtied_players[#hogtied_players + 1] = player
			end
		end
	end

	local num_hogtied_players = #hogtied_players

	if num_hogtied_players > 0 then
		local nav_spawn_points = main_path_manager:nav_spawn_points()

		if nav_spawn_points then
			for i = num_hogtied_players, 1, -1 do
				local hogtied_position = POSITION_LOOKUP[hogtied_players[i].player_unit]
				local _, hogtied_player_distance, _, _, _ = MainPathQueries.closest_position(hogtied_position)
				local team_has_past = behind_unit_player_distance - hogtied_player_distance > PLAYER_MOVE_PLAYERS_TO_BEACON_DISTANCE

				if not team_has_past then
					table.remove(hogtied_players, i)
				end
			end

			if #hogtied_players > 0 then
				return true, hogtied_players
			end
		end
	else
		self._current_active_respawn_beacon = nil
	end

	return false
end

RespawnBeaconSystem._move_hogtied_players = function (self, players, best_beacon)
	local extension = self._unit_to_extension_map[best_beacon]
	local old_beacon = self._current_active_respawn_beacon

	extension:move_hogtied_players(players)

	if old_beacon ~= best_beacon then
		local old_extension = self._unit_to_extension_map[old_beacon]

		old_extension:clear_occupied_units()
	end

	self._current_active_respawn_beacon = best_beacon
end

RespawnBeaconSystem._find_nearest_beacon = function (self, side_id)
	if MainPathQueries.is_main_path_registered() then
		return self:_find_nearest_beacon_with_mainpath(side_id)
	else
		return self:_find_nearest_beacon_no_mainpath()
	end
end

local BEACON_AHEAD_DISTANCE = 25

RespawnBeaconSystem._find_nearest_beacon_with_mainpath = function (self, side_id)
	local beacon_main_path_data = self._beacon_main_path_data
	local num_beacons = #beacon_main_path_data
	local _, ahead_player_distance = Managers.state.main_path:ahead_unit(side_id)

	if not ahead_player_distance then
		return nil
	end

	local min_distance = ahead_player_distance + BEACON_AHEAD_DISTANCE
	local nearest_beacon_unit

	for i = 1, num_beacons do
		local data = beacon_main_path_data[i]
		local beacon_unit = data.unit
		local distance = data.distance

		if min_distance < distance or i == num_beacons then
			nearest_beacon_unit = beacon_unit

			break
		end
	end

	return nearest_beacon_unit
end

RespawnBeaconSystem._find_nearest_beacon_no_mainpath = function (self)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local alive_players = player_unit_spawn_manager:alive_players()
	local unit_to_extension_map = self._unit_to_extension_map
	local nearest_beacon_unit
	local midpoint_position = Vector3.zero()
	local num_alive_players = #alive_players

	for ii = 1, num_alive_players do
		local player = alive_players[ii]
		local player_unit = player.player_unit
		local position = POSITION_LOOKUP[player_unit]

		midpoint_position = position + midpoint_position
	end

	if num_alive_players > 0 then
		midpoint_position = midpoint_position / num_alive_players
	end

	local smallest_distance_sq = math.huge

	for beacon_unit, _ in pairs(unit_to_extension_map) do
		local spawner_position = Unit.world_position(beacon_unit, 1)
		local to_midpoint = spawner_position - midpoint_position
		local distance_sq = Vector3.length_squared(to_midpoint)

		if distance_sq < smallest_distance_sq then
			nearest_beacon_unit = beacon_unit
			smallest_distance_sq = distance_sq
		end
	end

	return nearest_beacon_unit
end

return RespawnBeaconSystem

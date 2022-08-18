local NavQueries = require("scripts/utilities/nav_queries")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local RespawnBeaconGuardSettings = require("scripts/extension_systems/respawn_beacon/respawn_beacon_guard_settings")
local RespawnBeaconQueries = require("scripts/extension_systems/respawn_beacon/utilities/respawn_beacon_queries")
local RespawnBeaconExtension = class("RespawnBeaconExtension")
RespawnBeaconExtension.UPDATE_DISABLED_BY_DEFAULT = true
local _player_max_radius_height = nil

RespawnBeaconExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._physics_world = extension_init_context.physics_world
	self._nav_world = extension_init_context.nav_world
	self._is_server = extension_init_context.is_server
	self._owner_system = extension_init_context.owner_system
	self._unit = unit
	self._player_unit_spawn_manager = Managers.state.player_unit_spawn
	self._spawn_on_navmesh_only = true
	self._side = nil
	self._has_spawned_guards = false
	self._guards = {}
end

RespawnBeaconExtension.update = function (self, unit, dt, t)
	return
end

RespawnBeaconExtension.setup_from_component = function (self, spawn_on_navmesh_only, side)
	self._spawn_on_navmesh_only = spawn_on_navmesh_only
	self._side = side
	local max_player_radius, max_player_height = _player_max_radius_height()
	local valid_spawn_positions, _, _, _ = RespawnBeaconQueries.spawn_locations(self._nav_world, self._physics_world, self._unit, max_player_radius, max_player_height, self._spawn_on_navmesh_only)
end

RespawnBeaconExtension.respawn_players = function (self)
	local player_unit_spawn_manager = self._player_unit_spawn_manager
	local players_to_spawn = player_unit_spawn_manager:players_to_spawn()
	local valid_spawn_positions = self:get_best_respawn_positions()
	local beacon_unit = self._unit
	local volume_node = Unit.node(beacon_unit, "c_respawn_volume")
	local volume_rotation = Unit.world_rotation(beacon_unit, volume_node)
	local spawn_rotation = Quaternion.look(Quaternion.forward(volume_rotation), Vector3.up())
	local side = self._side
	local force_spawn = false
	local is_respawn = true

	for i = 1, #players_to_spawn do
		local player = players_to_spawn[i]
		local spawn_position = valid_spawn_positions[i]

		if spawn_position then
			self:_try_spawn_guards(spawn_position, beacon_unit, valid_spawn_positions)
			player_unit_spawn_manager:spawn_player(player, spawn_position, spawn_rotation, force_spawn, side, nil, "hogtied", is_respawn)
		end
	end
end

RespawnBeaconExtension.get_best_respawn_positions = function (self)
	local max_player_radius, max_player_height = _player_max_radius_height()
	local valid_spawn_positions, _, _, _ = RespawnBeaconQueries.spawn_locations(self._nav_world, self._physics_world, self._unit, max_player_radius, max_player_height, self._spawn_on_navmesh_only)

	return valid_spawn_positions
end

local NAV_ABOVE = 1
local NAV_BELOW = 1
local TOO_CLOSE_TO_SPAWN_POSITION_DISTANCE = 1

RespawnBeaconExtension._try_spawn_guards = function (self, spawn_position, beacon_unit, valid_spawn_positions)
	if self._has_spawned_guards then
		return
	end

	local main_path_manager = Managers.state.main_path
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side_from_name(self._side)
	local side_id = side.side_id
	local furthest_travel_distance = MainPathQueries.is_main_path_registered() and main_path_manager:furthest_travel_distance(side_id)

	if not furthest_travel_distance then
		return
	end

	local settings = Managers.state.difficulty:get_table_entry_by_challenge(RespawnBeaconGuardSettings)
	local _, travel_distance = MainPathQueries.closest_position(spawn_position)
	local travel_distance_threshold = settings.travel_distance_threshold
	local diff = math.max(travel_distance - furthest_travel_distance, 0)

	if diff < travel_distance_threshold then
		return
	end

	local beacon_unit_rotation = Unit.world_rotation(beacon_unit, 1)
	local minion_spawn_manager = Managers.state.minion_spawn
	local breeds = settings.breeds
	local current_faction = Managers.state.pacing:current_faction()
	local faction_breeds = breeds[current_faction]
	local num_guards = settings.num_guards
	local degree_range = settings.direction_degree_range
	local degree_per_direction = degree_range / num_guards
	local position_offset = settings.position_offset_range
	local current_degree = -(degree_range / 2)

	for i = 1, num_guards do
		current_degree = current_degree + degree_per_direction
		local radians = math.degrees_to_radians(current_degree)
		local direction = -Vector3(math.sin(radians), math.cos(radians), 0)
		local rotation = Quaternion.look(direction)
		local wanted_rotation = Quaternion.multiply(beacon_unit_rotation, rotation)
		local wanted_direction = Quaternion.forward(wanted_rotation)
		local offseted_position = spawn_position + wanted_direction * position_offset
		local navmesh_position = NavQueries.position_on_mesh(self._nav_world, offseted_position, NAV_ABOVE, NAV_BELOW)

		if navmesh_position then
			local too_close_to_spawn_position = false

			for j = 1, #valid_spawn_positions do
				local distance_to_spawn_position = Vector3.distance(navmesh_position, valid_spawn_positions[j])

				if distance_to_spawn_position <= TOO_CLOSE_TO_SPAWN_POSITION_DISTANCE then
					too_close_to_spawn_position = true

					break
				end
			end

			if not too_close_to_spawn_position then
				local breed_name = faction_breeds[math.random(1, #faction_breeds)]
				local guard_unit = minion_spawn_manager:spawn_minion(breed_name, navmesh_position, Quaternion.look(wanted_direction), settings.side_id)
				self._guards[#self._guards + 1] = guard_unit
			end
		end
	end

	self._has_spawned_guards = true
end

RespawnBeaconExtension.despawn_guards = function (self)
	local minion_spawn_manager = Managers.state.minion_spawn

	for i = 1, #self._guards do
		local guard_unit = self._guards[i]

		minion_spawn_manager:despawn(guard_unit)
	end
end

function _player_max_radius_height()
	local max_radius = PlayerCharacterConstants.respawn_beacon_spot_radius
	local max_height = PlayerCharacterConstants.respawn_beacon_spot_height

	return max_radius, max_height
end

return RespawnBeaconExtension

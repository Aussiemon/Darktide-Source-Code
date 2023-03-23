require("scripts/extension_systems/respawn_beacon/respawn_beacon_extension")

local MainPathQueries = require("scripts/utilities/main_path_queries")
local PlayerMovement = require("scripts/utilities/player_movement")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local BEACON_ACTIVATION_DISTANCE = 45
local PLAYER_BEHIND_DISTANCE = 35
local BEACON_AHEAD_DISTANCE = 25
local RespawnBeaconSystem = class("RespawnBeaconSystem", "ExtensionSystemBase")

RespawnBeaconSystem.init = function (self, ...)
	RespawnBeaconSystem.super.init(self, ...)

	self._beacon_main_path_data = {}
	self._priority_respawn_beacon = nil
end

RespawnBeaconSystem.on_add_extension = function (self, world, unit, ...)
	local extension = RespawnBeaconSystem.super.on_add_extension(self, world, unit, ...)

	if not Managers.state.main_path:is_main_path_available() then
		return extension
	end

	local beacon_main_path_data = self._beacon_main_path_data
	local position = Unit.world_position(unit, 1)
	local _, distance, percentage, _, segment_index = MainPathQueries.closest_position(position)
	local entry = {
		unit = unit,
		distance = distance,
		percentage = percentage,
		segment_index = segment_index
	}
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

	return extension
end

RespawnBeaconSystem.on_remove_extension = function (self, unit, extension_name)
	RespawnBeaconSystem.super.on_remove_extension(self, unit, extension_name)

	local beacon_main_path_data = self._beacon_main_path_data
	local index = nil

	for i = 1, #beacon_main_path_data do
		local data = beacon_main_path_data[i]

		if unit == data.unit then
			index = i

			break
		end
	end

	table.remove(beacon_main_path_data, index)
end

RespawnBeaconSystem.make_respawn_beacon_priority = function (self, unit)
	if not self._is_server then
		return
	end

	self._priority_respawn_beacon = unit
end

RespawnBeaconSystem.remove_respawn_beacon_priority = function (self)
	if not self._is_server then
		return
	end

	self._priority_respawn_beacon = nil
end

RespawnBeaconSystem.fixed_update = function (self, context, dt, t, frame)
	RespawnBeaconSystem.super.fixed_update(self, context, dt, t, frame)

	if not self._is_server then
		return
	end

	local side_system = Managers.state.extension:system("side_system")
	local default_player_side_name = side_system:get_default_player_side_name()
	local player_side = side_system:get_side_from_name(default_player_side_name)
	local side_id = player_side.side_id
	local should_update_respawn_beacons = true

	if not should_update_respawn_beacons then
		return
	end

	local should_be_active = Managers.state.player_unit_spawn:has_players_waiting_to_spawn()

	if should_be_active then
		local best_beacon = self._priority_respawn_beacon
		best_beacon = best_beacon or self:_find_nearest_beacon(side_id)

		if best_beacon then
			local extension = self._unit_to_extension_map[best_beacon]

			extension:respawn_players()
		end
	end

	local should_move_players, hogtied_players = self:_should_move_hogtied_players(side_id)

	if should_move_players then
		local best_beacon = self._priority_respawn_beacon
		best_beacon = best_beacon or self:_find_nearest_beacon(side_id)

		self:_move_hogtied_players(hogtied_players, best_beacon)
	end
end

RespawnBeaconSystem._should_update_respawn_beacons = function (self, side_id)
	local furthest_back_unit, furthest_back_player_distance = Managers.state.main_path:behind_unit(side_id)

	if not ALIVE[furthest_back_unit] then
		return false
	end

	local final_respawn_beacon_data = self._beacon_main_path_data[#self._beacon_main_path_data]
	local distance = final_respawn_beacon_data.distance + BEACON_ACTIVATION_DISTANCE
	local should_update = furthest_back_player_distance < distance

	return should_update
end

local hogtied_players = {}

RespawnBeaconSystem._should_move_hogtied_players = function (self, side_id)
	local players = Managers.player:players()

	table.clear(hogtied_players)

	local main_path_manager = Managers.state.main_path

	if not main_path_manager:is_main_path_available() then
		return false
	end

	local _, furthest_back_player_distance = main_path_manager:behind_unit(side_id)

	if not furthest_back_player_distance then
		return false
	end

	local beacon_main_path_data = self._beacon_main_path_data
	local furthest_forward_beacon_data = beacon_main_path_data[#beacon_main_path_data]

	if not furthest_forward_beacon_data then
		return false
	end

	local furthest_forward_beacon_distance = furthest_forward_beacon_data.distance

	if furthest_forward_beacon_distance - furthest_back_player_distance < 0 then
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

	local MainPathQueries_closest_position = MainPathQueries.closest_position
	local num_hogtied_players = #hogtied_players

	if num_hogtied_players > 0 then
		local best_beacon = self._priority_respawn_beacon
		best_beacon = best_beacon or self:_find_nearest_beacon(side_id)
		local _, beacon_distance, _, _, _ = MainPathQueries.closest_position(Unit.world_position(best_beacon, 1))

		for ii = #hogtied_players, 1, -1 do
			local player = hogtied_players[ii]
			local player_unit = player.player_unit
			local position = POSITION_LOOKUP[player_unit]
			local _, distance = MainPathQueries_closest_position(position)

			if furthest_back_player_distance - distance < PLAYER_BEHIND_DISTANCE or math.abs(beacon_distance - distance) < PLAYER_BEHIND_DISTANCE then
				table.remove(hogtied_players, ii)
			end
		end
	end

	if #hogtied_players > 0 then
		return true, hogtied_players
	end

	return false
end

RespawnBeaconSystem._move_hogtied_players = function (self, players, best_beacon)
	local extension = self._unit_to_extension_map[best_beacon]
	local move_positions = extension:best_respawn_positions()

	for i = 1, #players do
		local player = players[i]
		local move_position = move_positions[i]

		if move_position then
			local player_unit = player.player_unit
			local rotation = Unit.world_rotation(player_unit, 1)

			PlayerMovement.teleport_fixed_update(player_unit, move_position, rotation)
		end
	end
end

RespawnBeaconSystem._find_nearest_beacon = function (self, side_id)
	if MainPathQueries.is_main_path_registered() then
		return self:_find_nearest_beacon_with_mainpath(side_id)
	else
		return self:_find_nearest_beacon_no_mainpath()
	end
end

RespawnBeaconSystem._find_nearest_beacon_with_mainpath = function (self, side_id)
	local beacon_main_path_data = self._beacon_main_path_data
	local num_beacons = #beacon_main_path_data
	local ahead_player_unit, ahead_player_distance = Managers.state.main_path:ahead_unit(side_id)

	if not ALIVE[ahead_player_unit] then
		local first_beacon = beacon_main_path_data[1]

		return first_beacon and first_beacon.unit
	end

	local min_distance = ahead_player_distance + BEACON_AHEAD_DISTANCE
	local nearest_beacon_unit = nil

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
	local nearest_beacon_unit = nil
	local midpoint_position = Vector3.zero()
	local num_alive_players = #alive_players

	for ii = 1, num_alive_players do
		local player = alive_players[ii]
		local player_unit = player.player_unit
		local position = POSITION_LOOKUP[player_unit]
		midpoint_position = position + midpoint_position
	end

	midpoint_position = midpoint_position / num_alive_players
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

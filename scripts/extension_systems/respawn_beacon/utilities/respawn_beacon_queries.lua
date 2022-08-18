local RespawnBeaconQueries = {}
local _generate_spawn_volume_positions, _find_fitting_positions, _validate_navmesh_positions, _move_positions_outside_exclusion_volume = nil

RespawnBeaconQueries.spawn_locations = function (nav_world, physics_world, beacon_unit, player_radius, player_height, spawn_on_navmesh_only)
	local spawn_volume_positions = _generate_spawn_volume_positions(beacon_unit, player_radius)
	local fitting_positions = _find_fitting_positions(physics_world, beacon_unit, spawn_volume_positions, player_radius, player_height)
	local navmesh_positions = _validate_navmesh_positions(nav_world, fitting_positions, spawn_on_navmesh_only)
	local valid_positions = _move_positions_outside_exclusion_volume(beacon_unit, navmesh_positions, player_radius)

	return valid_positions, navmesh_positions, fitting_positions, spawn_volume_positions
end

local temp_spawn_volume_positions = {}
local DIAMETER_AROUND_VOLUME_CENTER = 20
local HALF_DIAMETER_AROUND_VOLUME_CENTER = DIAMETER_AROUND_VOLUME_CENTER * 0.5

function _generate_spawn_volume_positions(beacon_unit, player_radius)
	table.clear(temp_spawn_volume_positions)

	local player_diameter = player_radius * 2
	local num_players_per_axis = math.floor(DIAMETER_AROUND_VOLUME_CENTER / player_diameter)
	local steps = DIAMETER_AROUND_VOLUME_CENTER / num_players_per_axis
	local volume_node = Unit.node(beacon_unit, "c_respawn_volume")
	local start_position = Unit.world_position(beacon_unit, volume_node)
	start_position.x = start_position.x - HALF_DIAMETER_AROUND_VOLUME_CENTER
	start_position.y = start_position.y - HALF_DIAMETER_AROUND_VOLUME_CENTER
	local volume_scale = Unit.world_scale(beacon_unit, volume_node)
	local volume_height = volume_scale.z

	for j = 1, num_players_per_axis, 1 do
		for i = 1, num_players_per_axis, 1 do
			local position = Vector3(start_position.x + steps * i, start_position.y + steps * j, start_position.z + volume_height)

			if Unit.is_point_inside_volume(beacon_unit, "c_respawn_volume", position) then
				table.insert(temp_spawn_volume_positions, position)
			end
		end
	end

	return temp_spawn_volume_positions
end

local temp_fitting_positions = {}

function _find_fitting_positions(physics_world, beacon_unit, positions, player_radius, player_height)
	table.clear(temp_fitting_positions)

	local raycast_direction = -Vector3.up()
	local capsule_size = Vector3(player_radius, player_height, player_radius)
	local capsule_rotation = Quaternion.axis_angle(Vector3.up(), 0)
	local volume_node = Unit.node(beacon_unit, "c_respawn_volume")
	local volume_scale = Unit.world_scale(beacon_unit, volume_node)
	local volume_height = volume_scale.z

	for _, position in ipairs(positions) do
		local raycast_has_hit, hit_position, _, _, _ = PhysicsWorld.raycast(physics_world, position, raycast_direction, volume_height, "closest", "collision_filter", "filter_player_mover")

		if raycast_has_hit then
			local _, actor_count = PhysicsWorld.immediate_overlap(physics_world, "shape", "capsule", "position", hit_position, "rotation", capsule_rotation, "size", capsule_size, "collision_filter", "filter_respawn_beacon_check")

			if actor_count == 0 then
				table.insert(temp_fitting_positions, hit_position)
			end
		end
	end

	return temp_fitting_positions
end

local ABOVE_LIMIT = 0.1
local BELOW_LIMIT = 0.1
local temp_navmesh_positions = {}

function _validate_navmesh_positions(nav_world, positions, spawn_on_navmesh_only)
	if not spawn_on_navmesh_only then
		return positions
	end

	local GwNavQueries_triangle_from_position = GwNavQueries.triangle_from_position

	table.clear(temp_navmesh_positions)

	for _, position in ipairs(positions) do
		local navmesh_position = nil
		local altitude = GwNavQueries_triangle_from_position(nav_world, position, ABOVE_LIMIT, BELOW_LIMIT)

		if altitude then
			navmesh_position = position
			navmesh_position.z = altitude
		end

		if navmesh_position then
			table.insert(temp_navmesh_positions, navmesh_position)
		end
	end

	return temp_navmesh_positions
end

local temp_offset_tests = {}
local temp_outside_exclusion_positions = {}

function _move_positions_outside_exclusion_volume(beacon_unit, positions, player_radius)
	local has_exclusion_volume = Unit.has_node(beacon_unit, "c_respawn_exclusion_volume")

	if not has_exclusion_volume then
		return positions
	end

	table.clear(temp_outside_exclusion_positions)

	temp_offset_tests[1] = Vector3.zero()
	temp_offset_tests[2] = Vector3(player_radius, 0, 0)
	temp_offset_tests[3] = Vector3(-player_radius, 0, 0)
	temp_offset_tests[4] = Vector3(0, player_radius, 0)
	temp_offset_tests[5] = Vector3(0, -player_radius, 0)

	for _, position in ipairs(positions) do
		local is_inside = false

		for _, offset in ipairs(temp_offset_tests) do
			local pos = position + offset
			local is_inside_exclusion_volume = Unit.is_point_inside_volume(beacon_unit, "c_respawn_exclusion_volume", pos)

			if is_inside_exclusion_volume then
				is_inside = true

				break
			end
		end

		if not is_inside then
			table.insert(temp_outside_exclusion_positions, position)
		end
	end

	return temp_outside_exclusion_positions
end

return RespawnBeaconQueries

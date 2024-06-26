-- chunkname: @scripts/managers/horde/templates/flood_horde_template.lua

local MainPathQueries = require("scripts/utilities/main_path_queries")
local NavQueries = require("scripts/utilities/nav_queries")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local SpawnPointQueries = require("scripts/managers/main_path/utilities/spawn_point_queries")
local aggro_states = PerceptionSettings.aggro_states
local horde_template = {
	main_path_fallback_distance = 40,
	max_spawn_locations = 10,
	name = "flood_horde",
	requires_main_path = true,
	minion_spawner_radius_checks = {
		8,
		12,
		15,
		25,
	},
	spawn_frequency = {
		0.5,
		3,
	},
	num_minion_per_spawn = {
		1,
		3,
	},
	num_minions_for_pause = {
		60,
		75,
		85,
		95,
		110,
	},
}
local breeds_to_spawn = {}

local function _compose_spawn_list(composition)
	local Math_random = math.random

	table.clear_array(breeds_to_spawn, #breeds_to_spawn)

	local breeds = composition.breeds

	for i = 1, #breeds do
		local breed_data = breeds[i]
		local breed_name, amount = breed_data.name, breed_data.amount
		local num_to_spawn = Math_random(amount[1], amount[2])

		for j = 1, num_to_spawn do
			breeds_to_spawn[#breeds_to_spawn + 1] = breed_name
		end
	end

	table.shuffle(breeds_to_spawn)

	return breeds_to_spawn, #breeds_to_spawn
end

local function _position_has_line_of_sight_to_any_enemy_player(physics_world, from_position, side, collision_filter)
	local Vector3_length_squared, Vector3_normalize = Vector3.length_squared, Vector3.normalize
	local PhysicsWorld_raycast = PhysicsWorld.raycast
	local offset = Vector3.up()
	local valid_enemy_player_units_positions = side.valid_enemy_player_units_positions

	for i = 1, #valid_enemy_player_units_positions do
		local target_position = valid_enemy_player_units_positions[i] + offset
		local to_target = target_position - from_position
		local distance_sq = Vector3_length_squared(to_target)

		if distance_sq > 0 then
			local direction = Vector3_normalize(to_target)
			local distance = math.sqrt(distance_sq)
			local hit, _, _, _, _ = PhysicsWorld_raycast(physics_world, from_position, direction, distance, "closest", "collision_filter", collision_filter)

			if not hit then
				return true
			end
		end
	end

	return false
end

local function _try_find_spawn_position(nav_world, center_position, index, num_columns, max_attempts)
	local Math_Random = math.random
	local above, below = 2, 2
	local offset = Vector3(-num_columns / 2 + index % num_columns, -num_columns / 2 + math.floor(index / num_columns), 0)

	for i = 1, max_attempts do
		local spawn_position = NavQueries.position_on_mesh(nav_world, center_position + offset, above, below)

		if spawn_position then
			return spawn_position
		else
			offset = Vector3(4 * Math_Random() - 2, 4 * Math_Random() - 2, 0)
		end
	end
end

local NUM_COLUMNS = 6
local MAX_SPAWN_POSITION_ATTEMPTS = 8
local MIN_DISTANCE_FROM_PLAYERS, MAX_DISTANCE_FROM_PLAYERS = 16, 40
local INITIAL_GROUP_OFFSET = 2
local nearby_spawners, nearby_occluded_positions = {}, {}
local SPAWNER_MIN_RANGE = 10

local function _spawn_flood_minions(horde, target_unit, nav_world, nav_spawn_points, path_position, num_groups, target_side_id, num_to_spawn, travel_distance)
	table.clear(nearby_spawners)
	table.clear(nearby_occluded_positions)

	local minion_spawner_radius_checks = horde_template.minion_spawner_radius_checks
	local max_spawn_locations = math.min(horde_template.max_spawn_locations, num_to_spawn)
	local num_spawn_locations = 0
	local minion_spawn_system = Managers.state.extension:system("minion_spawner_system")
	local side_system = Managers.state.extension:system("side_system")
	local target_side = side_system:get_side(target_side_id)
	local target_units = target_side.valid_player_units
	local num_target_units = #target_units

	for i = 1, #minion_spawner_radius_checks do
		local radius = minion_spawner_radius_checks[i]
		local spawners = minion_spawn_system:spawners_in_range(path_position, radius)

		if spawners then
			for j = 1, #spawners do
				local spawner = spawners[j]
				local spawner_position = spawner:position()
				local is_valid_spawner = true

				for k = 1, num_target_units do
					local player_unit = target_units[k]
					local player_position = POSITION_LOOKUP[player_unit]
					local distance = Vector3.distance(spawner_position, player_position)

					if distance < SPAWNER_MIN_RANGE then
						is_valid_spawner = false

						break
					end
				end

				if is_valid_spawner then
					nearby_spawners[#nearby_spawners + 1] = spawner
					num_spawn_locations = num_spawn_locations + 1
				end
			end

			if max_spawn_locations <= num_spawn_locations then
				break
			end
		end
	end

	local side = horde.side
	local side_id = side.side_id
	local optional_only_search_forward = true

	if num_spawn_locations < max_spawn_locations then
		local spawn_locations_left = max_spawn_locations - num_spawn_locations

		for i = 1, #minion_spawner_radius_checks do
			local radius = minion_spawner_radius_checks[i]
			local occluded_positions, num_occluded_positions = SpawnPointQueries.get_occluded_positions(nav_world, nav_spawn_points, path_position, side, radius, num_groups, MIN_DISTANCE_FROM_PLAYERS, MAX_DISTANCE_FROM_PLAYERS, INITIAL_GROUP_OFFSET, optional_only_search_forward)

			if occluded_positions then
				for j = 1, num_occluded_positions do
					local occluded_position = occluded_positions[j]

					nearby_occluded_positions[#nearby_occluded_positions + 1] = occluded_position
					spawn_locations_left = spawn_locations_left - 1
					num_spawn_locations = math.min(num_spawn_locations + 1, max_spawn_locations)

					if spawn_locations_left == 0 then
						break
					end
				end
			end
		end
	end

	local spawn_list = horde.spawn_list
	local group_id = horde.group_id
	local num_spawned = 0
	local spawns_per_location = math.ceil(num_to_spawn / num_spawn_locations)

	for i = 1, #nearby_spawners do
		repeat
			local spawner = nearby_spawners[i]
			local breed_list = {}

			for j = 1, spawns_per_location do
				local breed_name = spawn_list[num_spawned + 1]

				num_spawned = num_spawned + 1
				breed_list[#breed_list + 1] = breed_name
			end

			local queue_id = spawner:add_spawns(breed_list, side_id, target_side_id, nil, nil, group_id)
		until true
	end

	local spawns_left = num_to_spawn - num_spawned

	if spawns_left > 0 and #nearby_occluded_positions > 0 then
		local spawn_rotation = Quaternion.identity()
		local minion_spawn_manager = Managers.state.minion_spawn

		for i = 1, spawns_left do
			local spawn_position = nearby_occluded_positions[math.random(1, #nearby_occluded_positions)]

			if spawn_position then
				local breed_name = spawn_list[i]
				local unit = minion_spawn_manager:spawn_minion(breed_name, spawn_position, spawn_rotation, side_id, aggro_states.aggroed, target_unit, nil, group_id)

				num_spawned = num_spawned + 1
			end
		end
	end

	spawns_left = num_to_spawn - num_spawned

	if spawns_left <= 0 then
		return num_spawned
	end

	local check_travel_distance = travel_distance + horde_template.main_path_fallback_distance
	local wanted_position, _ = MainPathQueries.position_from_distance(check_travel_distance)

	if not wanted_position then
		Log.info("FloodHorde", "\t\tCouldn't find path position at travel distance %.2f.", check_travel_distance)

		return num_spawned
	end

	local collision_filter = "filter_minion_line_of_sight_check"
	local in_line_of_sight = _position_has_line_of_sight_to_any_enemy_player(horde.physics_world, wanted_position, side, collision_filter)

	if in_line_of_sight then
		Log.info("FloodHorde", "\t\tFallback spawn position in line of sight of enemy player(s).")

		return num_spawned
	end

	local spawn_rotation = Quaternion.identity()
	local minion_spawn_manager = Managers.state.minion_spawn

	for i = 1, spawns_left do
		local spawn_position = _try_find_spawn_position(nav_world, wanted_position, i, NUM_COLUMNS, MAX_SPAWN_POSITION_ATTEMPTS)

		if spawn_position then
			local breed_name = spawn_list[i]

			minion_spawn_manager:spawn_minion(breed_name, spawn_position, spawn_rotation, side_id, aggro_states.aggroed, target_unit, nil, group_id)

			num_spawned = num_spawned + 1
		end
	end

	Log.info("FloodHorde", "\t\tSpawned %d minions at fallback mainpath.", spawns_left)

	return num_spawned
end

horde_template.execute = function (physics_world, nav_world, side, target_side, composition, towards_combat_vector)
	local target_side_id = target_side.side_id
	local main_path_manager = Managers.state.main_path
	local target_unit, travel_distance, path_position = main_path_manager:ahead_unit(target_side_id)

	if not target_unit then
		Log.info("FloodHorde", "Couldn't find a ahead unit, failing horde.")

		return
	end

	local spawn_list, total_num_to_spawn = _compose_spawn_list(composition)
	local horde = {
		attempts = 0,
		num_spawned = 0,
		template_name = horde_template.name,
		side = side,
		target_side = target_side,
		composition = composition,
		nav_world = nav_world,
		num_to_spawn = total_num_to_spawn,
		physics_world = physics_world,
	}
	local group_system = Managers.state.extension:system("group_system")
	local group_id = group_system:generate_group_id()

	horde.group_id = group_id
	horde.spawn_list = spawn_list

	group_system:lock_group_id(group_id)

	local nav_spawn_points = main_path_manager:nav_spawn_points()
	local num_groups = GwNavSpawnPoints.get_count(nav_spawn_points)
	local num_to_spawn = math.random(horde_template.num_minion_per_spawn[1], horde_template.num_minion_per_spawn[2])
	local num_spawned = _spawn_flood_minions(horde, target_unit, nav_world, nav_spawn_points, path_position, num_groups, target_side_id, num_to_spawn, travel_distance)

	horde.next_flood_spawn_at = math.random_range(horde_template.spawn_frequency[1], horde_template.spawn_frequency[2])
	horde.num_spawned = horde.num_spawned + num_spawned

	Log.info("FloodHorde", "Starting flood horde, will try to spawn %d minions.", total_num_to_spawn)

	return horde, path_position, target_unit
end

local MAX_ATTEMPTS = 10

horde_template.update = function (horde, dt, t)
	horde.next_flood_spawn_at = horde.next_flood_spawn_at - dt

	local num_minions_for_pause = Managers.state.difficulty:get_table_entry_by_challenge(horde_template.num_minions_for_pause)
	local num_aggroed_minions = Managers.state.pacing:num_aggroed_minions()
	local too_many_minions = num_minions_for_pause <= num_aggroed_minions

	if too_many_minions or horde.next_flood_spawn_at > 0 or horde.num_spawned >= horde.num_to_spawn then
		return
	end

	local target_side = horde.target_side
	local target_side_id = target_side.side_id
	local main_path_manager = Managers.state.main_path
	local target_unit, travel_distance, path_position = main_path_manager:ahead_unit(target_side_id)

	if not target_unit then
		return
	end

	local nav_spawn_points = main_path_manager:nav_spawn_points()
	local num_groups = GwNavSpawnPoints.get_count(nav_spawn_points)
	local num_to_spawn = math.random(horde_template.num_minion_per_spawn[1], horde_template.num_minion_per_spawn[2])
	local nav_world = horde.nav_world
	local num_spawned = _spawn_flood_minions(horde, target_unit, nav_world, nav_spawn_points, path_position, num_groups, target_side_id, num_to_spawn, travel_distance)

	horde.next_flood_spawn_at = math.random_range(horde_template.spawn_frequency[1], horde_template.spawn_frequency[2])
	horde.num_spawned = horde.num_spawned + num_spawned

	local group_system = Managers.state.extension:system("group_system")
	local group_id = horde.group_id

	if horde.num_spawned >= horde.num_to_spawn or horde.attempts > MAX_ATTEMPTS then
		group_system:unlock_group_id(horde.group_id)
		Log.info("FloodHorde", "Finished, spawned total %d minions.", horde.num_spawned)
	elseif num_spawned == 0 then
		horde.attempts = horde.attempts + 1

		Log.info("FloodHorde", "Failed to spawn minions.. trying again.. %d attempts", horde.attempts)
	else
		horde.attempts = 0

		group_system:lock_group_id(group_id)
	end
end

return horde_template

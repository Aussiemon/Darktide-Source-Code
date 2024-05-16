-- chunkname: @scripts/managers/horde/templates/trickle_horde_template.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breeds = require("scripts/settings/breed/breeds")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local MinionPatrols = require("scripts/utilities/minion_patrols")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local SpawnPointQueries = require("scripts/managers/main_path/utilities/spawn_point_queries")
local aggro_states = PerceptionSettings.aggro_states
local horde_template = {
	name = "trickle_horde",
	occluded_spawn_range = 3,
	requires_main_path = true,
}
local TEMP_BREED_NAMES = {}

local function _compose_spawn_list(composition)
	local math_random = math.random

	table.clear_array(TEMP_BREED_NAMES, #TEMP_BREED_NAMES)

	local breeds = composition.breeds

	for i = 1, #breeds do
		local breed_data = breeds[i]
		local breed_name, amount = breed_data.name, breed_data.amount
		local num_to_spawn = math_random(amount[1], amount[2])

		for j = 1, num_to_spawn do
			TEMP_BREED_NAMES[#TEMP_BREED_NAMES + 1] = breed_name
		end
	end

	table.shuffle(TEMP_BREED_NAMES)

	return TEMP_BREED_NAMES, #TEMP_BREED_NAMES
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

local MIN_DISTANCE_FROM_PLAYERS = 25
local DEFAULT_MAIN_PATH_OFFSET = 35
local OCCLUDED_POINTS_COLLISION_FILTER = "filter_ray_aim_assist_line_of_sight"

local function _try_find_occluded_position(nav_world, physics_world, nav_spawn_points, side, target_side, occluded_spawn_range, num_spawn_groups, try_find_on_main_path, optional_main_path_offset, optional_disallowed_positions)
	local target_side_id = target_side.side_id
	local main_path_manager = Managers.state.main_path
	local target_unit, travel_distance, path_position = main_path_manager:ahead_unit(target_side_id)

	if not target_unit then
		return false, nil, nil, nil
	end

	local wanted_position

	if try_find_on_main_path then
		local main_path_offset = optional_main_path_offset or DEFAULT_MAIN_PATH_OFFSET

		if type(main_path_offset) == "table" then
			main_path_offset = math.random_range(optional_main_path_offset[1], optional_main_path_offset[2])
		end

		local main_path_distance = math.max(travel_distance + main_path_offset, 0)

		wanted_position = MainPathQueries.position_from_distance(main_path_distance)
	else
		wanted_position = path_position
	end

	local only_search_forward = true
	local random_occluded_position = SpawnPointQueries.get_random_occluded_position(nav_world, nav_spawn_points, wanted_position, side, occluded_spawn_range, num_spawn_groups, MIN_DISTANCE_FROM_PLAYERS, nil, nil, only_search_forward, optional_disallowed_positions)

	if not random_occluded_position then
		return false, nil, nil, nil
	end

	local group_index = SpawnPointQueries.group_from_position(nav_world, nav_spawn_points, random_occluded_position)
	local start_index = main_path_manager:node_index_by_nav_group_index(group_index or 1)
	local end_index = start_index + 1
	local closest_mainpath_position = MainPathQueries.closest_position_between_nodes(random_occluded_position, start_index, end_index)

	if _position_has_line_of_sight_to_any_enemy_player(physics_world, closest_mainpath_position + Vector3.up(), side, OCCLUDED_POINTS_COLLISION_FILTER) then
		return false, nil, nil, nil
	end

	local to_target = wanted_position - random_occluded_position
	local target_direction = Vector3.normalize(to_target)

	return true, random_occluded_position, target_direction, target_unit
end

local DEFAULT_NUM_TRIES = 1
local MAINPATH_OFFSET = 10

local function _try_find_horde_position(nav_world, physics_world, nav_spawn_points, side, target_side, occluded_spawn_range, num_spawn_groups, optional_main_path_offset, optional_num_tries, optional_disallowed_positions)
	local try_find_on_main_path = true
	local num_tries = optional_num_tries or DEFAULT_NUM_TRIES
	local success, horde_position, target_direction, target_unit

	for i = 1, num_tries do
		if optional_main_path_offset then
			if type(optional_main_path_offset) == "table" then
				optional_main_path_offset = math.random_range(optional_main_path_offset[1], optional_main_path_offset[2])
			end

			optional_main_path_offset = optional_main_path_offset + (i > 1 and i * MAINPATH_OFFSET or 0)
		end

		success, horde_position, target_direction, target_unit = _try_find_occluded_position(nav_world, physics_world, nav_spawn_points, side, target_side, occluded_spawn_range, num_spawn_groups, try_find_on_main_path, optional_main_path_offset, optional_disallowed_positions)

		if success then
			return horde_position, target_direction, target_unit
		end
	end

	success, horde_position, target_direction, target_unit = _try_find_occluded_position(nav_world, physics_world, nav_spawn_points, side, target_side, occluded_spawn_range, num_spawn_groups, not try_find_on_main_path, optional_disallowed_positions)

	if success then
		return horde_position, target_direction, target_unit
	end

	return nil, nil, nil
end

local PATROL_CHALLENGE_RAITNG_THRESHOLD = 30

horde_template.execute = function (physics_world, nav_world, side, target_side, composition, towards_combat_vector, optional_main_path_offset, optional_num_tries, optional_disallowed_positions, optional_spawn_max_health_modifier)
	local target_side_id = target_side.side_id
	local main_path_manager = Managers.state.main_path
	local _, ahead_travel_distance, ahead_position = main_path_manager:ahead_unit(target_side_id)

	if not ahead_travel_distance then
		return nil, nil, nil
	end

	local nav_spawn_points = main_path_manager:nav_spawn_points()
	local num_groups = GwNavSpawnPoints.get_count(nav_spawn_points)
	local occluded_spawn_range = horde_template.occluded_spawn_range
	local horde_position, horde_direction, target_unit = _try_find_horde_position(nav_world, physics_world, nav_spawn_points, side, target_side, occluded_spawn_range, num_groups, optional_main_path_offset, optional_num_tries, optional_disallowed_positions)

	if not horde_position then
		return nil, nil, nil
	end

	local group_system = Managers.state.extension:system("group_system")
	local group_id = group_system:generate_group_id()
	local spawn_list, num_to_spawn = _compose_spawn_list(composition)
	local spawned_minions = Script.new_array(num_to_spawn)
	local horde = {
		spawned_minions = spawned_minions,
		template_name = horde_template.name,
		side = side,
		target_side = target_side,
		group_id = group_id,
	}
	local spawn_rotation = Quaternion.look(Vector3(horde_direction.x, horde_direction.y, 0))
	local side_id = side.side_id
	local minion_spawn_manager = Managers.state.minion_spawn
	local flood_fill_positions = {}
	local below, above = 2, 2
	local num_positions = GwNavQueries.flood_fill_from_position(nav_world, horde_position, above, below, num_to_spawn, flood_fill_positions)
	local breeds_can_patrol = true

	for i = 1, num_positions do
		local position = flood_fill_positions[i]

		flood_fill_positions[#flood_fill_positions + 1] = position

		local breed_name = spawn_list[i]
		local breed = Breeds[breed_name]

		if not breed.can_patrol then
			breeds_can_patrol = false
		end
	end

	local pacing_manager = Managers.state.pacing
	local challenge_rating = pacing_manager:total_challenge_rating()
	local waiting_for_ramp_clear = Managers.state.pacing:waiting_for_ramp_clear()
	local should_spawn_patrol = not waiting_for_ramp_clear and breeds_can_patrol and challenge_rating < PATROL_CHALLENGE_RAITNG_THRESHOLD

	if should_spawn_patrol then
		for i = 1, num_positions do
			local breed_name = spawn_list[i]
			local spawn_position = flood_fill_positions[i]
			local unit = minion_spawn_manager:spawn_minion(breed_name, spawn_position, spawn_rotation, side_id, aggro_states.passive, nil, nil, group_id, nil, nil, optional_spawn_max_health_modifier)
			local blackboard = BLACKBOARDS[unit]
			local patrol_component = Blackboard.write_component(blackboard, "patrol")

			if i == 1 then
				patrol_component.walk_position:store(ahead_position)

				patrol_component.should_patrol = true
				patrol_component.patrol_index = i
				patrol_component.auto_patrol = true
			else
				local follow_index = MinionPatrols.get_follow_index(i)
				local follow_unit = spawned_minions[follow_index]

				patrol_component.patrol_leader_unit = follow_unit
				patrol_component.patrol_index = i
				patrol_component.should_patrol = true
			end

			spawned_minions[i] = unit
		end
	else
		for i = 1, num_positions do
			local breed_name = spawn_list[i]
			local spawn_position = flood_fill_positions[i]
			local unit = minion_spawn_manager:spawn_minion(breed_name, spawn_position, spawn_rotation, side_id, aggro_states.aggroed, target_unit, nil, group_id, nil, nil, optional_spawn_max_health_modifier)

			spawned_minions[i] = unit
		end
	end

	return horde, horde_position, target_unit
end

horde_template.can_spawn = function (physics_world, nav_world, side, target_side, composition, towards_combat_vector, optional_main_path_offset, optional_num_tries)
	local target_side_id = target_side.side_id
	local main_path_manager = Managers.state.main_path
	local _, ahead_travel_distance = main_path_manager:ahead_unit(target_side_id)

	if not ahead_travel_distance then
		return false
	end

	local nav_spawn_points = main_path_manager:nav_spawn_points()
	local num_groups = GwNavSpawnPoints.get_count(nav_spawn_points)
	local occluded_spawn_range = horde_template.occluded_spawn_range
	local horde_position = _try_find_horde_position(nav_world, physics_world, nav_spawn_points, side, target_side, occluded_spawn_range, num_groups, optional_main_path_offset, optional_num_tries)

	if not horde_position then
		return false
	end

	return true
end

return horde_template

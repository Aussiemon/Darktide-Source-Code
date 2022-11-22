local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breeds = require("scripts/settings/breed/breeds")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local MinionPatrols = require("scripts/utilities/minion_patrols")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local SpawnPointQueries = require("scripts/managers/main_path/utilities/spawn_point_queries")
local aggro_states = PerceptionSettings.aggro_states
local horde_template = {
	requires_main_path = true,
	name = "trickle_horde",
	occluded_spawn_range = 3
}
local TEMP_BREED_NAMES = {}

local function _compose_spawn_list(composition)
	local math_random = math.random

	table.clear_array(TEMP_BREED_NAMES, #TEMP_BREED_NAMES)

	local breeds = composition.breeds

	for i = 1, #breeds do
		local breed_data = breeds[i]
		local breed_name = breed_data.name
		local amount = breed_data.amount
		local num_to_spawn = math_random(amount[1], amount[2])

		for j = 1, num_to_spawn do
			TEMP_BREED_NAMES[#TEMP_BREED_NAMES + 1] = breed_name
		end
	end

	table.shuffle(TEMP_BREED_NAMES)

	return TEMP_BREED_NAMES, #TEMP_BREED_NAMES
end

local MIN_DISTANCE_FROM_PLAYERS = 25
local DEFAULT_MAIN_PATH_OFFSET = 35

local function _try_find_occluded_position(nav_world, nav_spawn_points, side, target_side, occluded_spawn_range, num_spawn_groups, try_find_on_main_path, optional_main_path_offset)
	local target_side_id = target_side.side_id
	local main_path_manager = Managers.state.main_path
	local target_unit, travel_distance, path_position = main_path_manager:ahead_unit(target_side_id)

	if not target_unit then
		return false, nil, nil, nil
	end

	local wanted_position = nil

	if try_find_on_main_path then
		local main_path_offset = optional_main_path_offset or DEFAULT_MAIN_PATH_OFFSET
		local main_path_distance = travel_distance + main_path_offset
		wanted_position = MainPathQueries.position_from_distance(main_path_distance)
	else
		wanted_position = path_position
	end

	local only_search_forward = true
	local random_occluded_position = SpawnPointQueries.get_random_occluded_position(nav_world, nav_spawn_points, wanted_position, side, occluded_spawn_range, num_spawn_groups, MIN_DISTANCE_FROM_PLAYERS, nil, nil, only_search_forward)

	if not random_occluded_position then
		return false, nil, nil, nil
	end

	local to_target = wanted_position - random_occluded_position
	local target_direction = Vector3.normalize(to_target)

	return true, random_occluded_position, target_direction, target_unit
end

local function _try_find_horde_position(nav_world, nav_spawn_points, side, target_side, occluded_spawn_range, num_spawn_groups, optional_main_path_offset)
	local try_find_on_main_path = true
	local success, horde_position, target_direction, target_unit = _try_find_occluded_position(nav_world, nav_spawn_points, side, target_side, occluded_spawn_range, num_spawn_groups, try_find_on_main_path, optional_main_path_offset)

	if success then
		return horde_position, target_direction, target_unit
	end

	success, horde_position, target_direction, target_unit = _try_find_occluded_position(nav_world, nav_spawn_points, side, target_side, occluded_spawn_range, num_spawn_groups, not try_find_on_main_path)

	if success then
		return horde_position, target_direction, target_unit
	end

	return nil, nil, nil
end

local PATROL_CHALLENGE_RAITNG_THRESHOLD = 30

horde_template.execute = function (physics_world, nav_world, side, target_side, composition, towards_combat_vector, optional_main_path_offset)
	local target_side_id = target_side.side_id
	local main_path_manager = Managers.state.main_path
	local _, ahead_travel_distance, ahead_position = main_path_manager:ahead_unit(target_side_id)

	if not ahead_travel_distance then
		return nil, nil, nil
	end

	local nav_spawn_points = main_path_manager:nav_spawn_points()
	local num_groups = GwNavSpawnPoints.get_count(nav_spawn_points)
	local occluded_spawn_range = horde_template.occluded_spawn_range
	local horde_position, horde_direction, target_unit = _try_find_horde_position(nav_world, nav_spawn_points, side, target_side, occluded_spawn_range, num_groups, optional_main_path_offset)

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
		group_id = group_id
	}
	local spawn_rotation = Quaternion.look(Vector3(horde_direction.x, horde_direction.y, 0))
	local side_id = side.side_id
	local minion_spawn_manager = Managers.state.minion_spawn
	local flood_fill_positions = {}
	local below = 2
	local above = 2
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
	local should_spawn_patrol = breeds_can_patrol and challenge_rating < PATROL_CHALLENGE_RAITNG_THRESHOLD

	if should_spawn_patrol then
		for i = 1, num_positions do
			local breed_name = spawn_list[i]
			local spawn_position = flood_fill_positions[i]
			local unit = minion_spawn_manager:spawn_minion(breed_name, spawn_position, spawn_rotation, side_id, aggro_states.passive, nil, nil, group_id, nil, nil, "trickle_horde")
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
			local unit = minion_spawn_manager:spawn_minion(breed_name, spawn_position, spawn_rotation, side_id, aggro_states.aggroed, target_unit, nil, group_id, nil, nil, "trickle_horde")
			spawned_minions[i] = unit
		end
	end

	return horde, horde_position, target_unit
end

return horde_template

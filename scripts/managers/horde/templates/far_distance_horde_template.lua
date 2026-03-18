-- chunkname: @scripts/managers/horde/templates/far_distance_horde_template.lua

local HordeUtilities = require("scripts/managers/horde/utilities/horde_utilities")
local NavQueries = require("scripts/utilities/nav_queries")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local aggro_states = PerceptionSettings.aggro_states
local horde_template = {
	chance_spawning_ahead = 0.67,
	euclidean_distance_from_targets = 20,
	name = "far_distance_horde",
	requires_main_path = true,
	main_path_distance_from_targets = {
		60,
		80,
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

local function _check_spawn_is_hidden(physics_world, wanted_position, side)
	local collision_filter = "filter_minion_line_of_sight_check"
	local in_line_of_sight = HordeUtilities.position_has_line_of_sight_to_any_enemy_player(physics_world, wanted_position, side, collision_filter)

	if in_line_of_sight then
		Log.info("FarVectorHorde", "\t\tSpawn position in line of sight of enemy player(s).")

		return false
	end

	return true
end

local function _find_nav_position(nav_world, traverse_logic, wanted_position)
	local nav_position, _ = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, wanted_position)

	if not nav_position then
		Log.info("FarVectorHorde", "\t\tCouldn't find path position at position: %s", wanted_position)
	end

	return nav_position
end

local function _try_find_position_ahead_or_behind_target(physics_world, nav_world, traverse_logic, check_ahead, travel_distance, min_distance, side, target_side, target_unit)
	if not target_unit then
		Log.info("FarVectorHorde", "\t\tNo tracked unit for target side %q.", target_side:name())

		return false
	end

	local target_position = POSITION_LOOKUP[target_unit]
	local angle = math.random_range(0, math.pi)

	for i = 1, 2 do
		local wanted_position = target_position + Vector3(math.cos(angle), math.sin(angle), 0) * travel_distance
		local nav_position = _find_nav_position(nav_world, traverse_logic, wanted_position)

		if nav_position and _check_spawn_is_hidden(physics_world, nav_position, side) then
			local to_target = target_position - nav_position
			local distance_sq = Vector3.length_squared(to_target)

			if distance_sq >= min_distance * min_distance then
				local target_direction = Vector3.normalize(to_target)

				return true, nav_position, target_direction, target_unit
			else
				Log.info("FarVectorHorde", "\t\tSpawn posisiton is closer than %.2f.", min_distance)
			end
		end

		angle = angle + math.pi
	end

	return false
end

local MAX_POSITION_TRIES = 3

local function _try_find_position_on_nav_world(physics_world, nav_world, traverse_logic, chance_spawning_ahead, distances, euclidean_distance, side, target_side, target_unit)
	local distance = math.random(distances[1], distances[2])
	local success, horde_position, target_direction
	local random_roll = math.random()
	local spawn_horde_ahead = random_roll <= chance_spawning_ahead

	for i = 1, MAX_POSITION_TRIES do
		success, horde_position, target_direction = _try_find_position_ahead_or_behind_target(physics_world, nav_world, traverse_logic, spawn_horde_ahead, distance, euclidean_distance, side, target_side, target_unit)

		if success then
			break
		end
	end

	if not success then
		return
	end

	return horde_position, target_direction, target_unit
end

local NUM_COLUMNS = 6
local MAX_SPAWN_POSITION_ATTEMPTS = 8

horde_template.execute = function (physics_world, nav_world, side, target_side, composition, towards_combat_vector, optional_main_path_offset, optional_num_tries, optional_disallowed_positions, optional_spawn_max_health_modifier, optional_prefered_direction, optional_target_unit)
	if not optional_target_unit then
		return
	end

	local main_path_distance_from_targets = horde_template.main_path_distance_from_targets
	local euclidean_distance_from_targets = horde_template.euclidean_distance_from_targets
	local chance_spawning_ahead = horde_template.chance_spawning_ahead
	local traverse_logic = Managers.state.pacing:roamer_traverse_logic()
	local horde_position, horde_direction, target_unit, spawn_horde_ahead

	horde_position, horde_direction, target_unit, spawn_horde_ahead = _try_find_position_on_nav_world(physics_world, nav_world, traverse_logic, chance_spawning_ahead, main_path_distance_from_targets, euclidean_distance_from_targets, side, target_side, optional_target_unit)

	if not horde_position then
		Log.info("FarVectorHorde", "Couldn't find a spawn position, failing horde.")

		return
	end

	local group_system = Managers.state.extension:system("group_system")
	local group_id = group_system:generate_group_id()
	local spawn_list, num_to_spawn = _compose_spawn_list(composition)
	local horde = {
		template_name = horde_template.name,
		side = side,
		target_side = target_side,
		group_id = group_id,
	}
	local spawn_rotation = Quaternion.look(Vector3(horde_direction.x, horde_direction.y, 0))
	local side_id = side.side_id
	local minion_spawn_manager = Managers.state.minion_spawn
	local num_spawned = 0

	for i = 1, num_to_spawn do
		local spawn_position = HordeUtilities.try_find_spawn_position(nav_world, horde_position, i, NUM_COLUMNS, MAX_SPAWN_POSITION_ATTEMPTS, traverse_logic)

		if spawn_position then
			local breed_name = spawn_list[i]
			local queue_parameters = minion_spawn_manager:queue_minion_to_spawn(breed_name, spawn_position, spawn_rotation, side_id)

			queue_parameters.optional_aggro_state = aggro_states.aggroed
			queue_parameters.optional_target_unit = target_unit
			queue_parameters.optional_group_target = target_unit
			queue_parameters.optional_group_id = group_id
			num_spawned = num_spawned + 1
		end
	end

	Log.info("FarVectorHorde", "Managed to spawn %d/%d horde enemies.", num_spawned, num_to_spawn)

	local spawned_direction = spawn_horde_ahead and "ahead" or "behind"

	return horde, horde_position, target_unit, spawned_direction
end

return horde_template

-- chunkname: @scripts/managers/horde/templates/ambush_horde_template.lua

local NavQueries = require("scripts/utilities/nav_queries")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local SpawnPointQueries = require("scripts/managers/main_path/utilities/spawn_point_queries")
local aggro_states = PerceptionSettings.aggro_states
local horde_template = {
	max_spawn_locations = 10,
	name = "ambush_horde",
	requires_main_path = true,
	minion_spawner_radius_checks = {
		8,
		12,
		15,
		25
	}
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

local MIN_DISTANCE_FROM_PLAYERS, MAX_DISTANCE_FROM_PLAYERS = 12, 25
local INITIAL_GROUP_OFFSET = 2
local nearby_spawners, nearby_occluded_positions = {}, {}

horde_template.execute = function (physics_world, nav_world, side, target_side, composition, towards_combat_vector, optional_main_path_offset, optional_num_tries, optional_disallowed_positions, optional_spawn_max_health_modifier, optional_prefered_direction, optional_target_unit)
	local target_side_id = target_side.side_id
	local side_id = side.side_id
	local main_path_manager = Managers.state.main_path
	local _, ahead_travel_distance = main_path_manager:ahead_unit(target_side_id)

	if not ahead_travel_distance then
		Log.info("AmbushHorde", "Couldn't find a ahead unit, failing horde.")

		return
	end

	local nav_spawn_points = main_path_manager:nav_spawn_points()
	local num_groups = GwNavSpawnPoints.get_count(nav_spawn_points)
	local minion_spawner_radius_checks = horde_template.minion_spawner_radius_checks
	local max_spawn_locations = horde_template.max_spawn_locations
	local target_unit = optional_target_unit

	target_unit = target_unit or main_path_manager:ahead_unit(target_side_id)

	if not target_unit then
		Log.info("AmbushHorde", "\t\tNo main path tracked unit for target side %q.", target_side:name())

		return
	end

	local target_position = POSITION_LOOKUP[target_unit]
	local navmesh_position = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, target_position, 1, 1, 1)

	if not navmesh_position then
		local target_units = side.valid_player_units
		local num_target_units = #target_units

		for j = 1, num_target_units do
			target_unit = target_units[j]
			navmesh_position = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, POSITION_LOOKUP[target_unit], 1, 1, 1)

			if navmesh_position then
				break
			end
		end

		if not navmesh_position then
			Log.info("AmbushHorde", "\t\tNo navmesh on target side %q.", target_side:name())

			return
		end
	end

	local spawn_list, num_to_spawn = _compose_spawn_list(composition)
	local horde = {
		template_name = horde_template.name,
		side = side,
		target_side = target_side
	}

	table.clear(nearby_spawners)
	table.clear(nearby_occluded_positions)

	local num_spawn_locations = 0
	local minion_spawn_system = Managers.state.extension:system("minion_spawner_system")

	for i = 1, #minion_spawner_radius_checks do
		local radius = minion_spawner_radius_checks[i]
		local spawners = minion_spawn_system:spawners_in_range(navmesh_position, radius)

		if spawners then
			for j = 1, #spawners do
				nearby_spawners[#nearby_spawners + 1] = spawners[j]
				num_spawn_locations = num_spawn_locations + 1
			end

			if max_spawn_locations <= num_spawn_locations then
				break
			end
		end
	end

	if num_spawn_locations < max_spawn_locations then
		local spawn_locations_left = max_spawn_locations - num_spawn_locations

		for i = 1, #minion_spawner_radius_checks do
			local radius = minion_spawner_radius_checks[i]
			local occluded_positions = SpawnPointQueries.get_occluded_positions(nav_world, nav_spawn_points, navmesh_position, side, radius, num_groups, MIN_DISTANCE_FROM_PLAYERS, MAX_DISTANCE_FROM_PLAYERS, INITIAL_GROUP_OFFSET)

			if occluded_positions then
				for j = 1, #occluded_positions do
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

	if num_spawn_locations == 0 then
		Log.info("AmbushHorde", "\t\tFound no spawn locations for ambush horde! Failed")

		return
	end

	local group_system = Managers.state.extension:system("group_system")
	local group_id = group_system:generate_group_id()

	horde.group_id = group_id

	local num_spawned = 0
	local spawns_per_location = math.floor(num_to_spawn / num_spawn_locations)

	for i = 1, #nearby_spawners do
		local spawner = nearby_spawners[i]
		local breed_list = {}

		for j = 1, spawns_per_location do
			local breed_name = spawn_list[num_spawned + 1]

			num_spawned = num_spawned + 1
			breed_list[#breed_list + 1] = breed_name
		end

		spawner:add_spawns(breed_list, side_id, target_side_id, nil, nil, group_id)
	end

	local spawns_left = num_to_spawn - num_spawned

	if spawns_left > 0 and #nearby_occluded_positions > 0 then
		local spawn_rotation = Quaternion.identity()
		local minion_spawn_manager = Managers.state.minion_spawn

		for i = 1, spawns_left do
			local spawn_position = nearby_occluded_positions[math.random(1, #nearby_occluded_positions)]

			if spawn_position then
				local breed_name = spawn_list[i]

				minion_spawn_manager:queue_minion_to_spawn(breed_name, spawn_position, spawn_rotation, side_id, aggro_states.aggroed, target_unit, nil, group_id)

				num_spawned = num_spawned + 1
			end
		end
	end

	Log.info("AmbushHorde", "Managed to spawn %d/%d horde enemies.", num_spawned, num_to_spawn)

	return horde, navmesh_position, target_unit
end

return horde_template

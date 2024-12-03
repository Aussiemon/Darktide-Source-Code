-- chunkname: @scripts/managers/horde/utilities/horde_utilities.lua

local NavQueries = require("scripts/utilities/nav_queries")
local HordeUtilities = {}

HordeUtilities.try_find_spawn_position = function (nav_world, center_position, index, num_columns, max_attempts, traverse_logic)
	local Math_Random = math.random
	local above, below = 2, 2
	local offset = Vector3(-num_columns / 2 + index % num_columns, -num_columns / 2 + math.floor(index / num_columns), 0)

	for i = 1, max_attempts do
		local spawn_position = NavQueries.position_on_mesh(nav_world, center_position + offset, above, below, traverse_logic)

		if spawn_position then
			return spawn_position
		else
			offset = Vector3(4 * Math_Random() - 2, 4 * Math_Random() - 2, 0)
		end
	end

	return nil
end

HordeUtilities.position_has_line_of_sight_to_any_enemy_player = function (physics_world, from_position, side, collision_filter)
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

return HordeUtilities

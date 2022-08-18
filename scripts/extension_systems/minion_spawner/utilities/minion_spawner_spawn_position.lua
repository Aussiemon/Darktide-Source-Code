local NavQueries = require("scripts/utilities/nav_queries")
local MinionSpawnerSpawnPosition = {}
local NAV_MESH_ABOVE = 1
local NAV_MESH_BELOW = 1
local NAV_MESH_MAX_DISTANCE = 2
local NAV_MESH_STEP_LENGTH = 0.2

MinionSpawnerSpawnPosition.find_exit_position_on_nav_mesh = function (nav_world, spawn_position, exit_position, traverse_logic)
	local search_direction = Vector3.normalize(exit_position - spawn_position)
	local search_distance = 0

	while search_distance <= NAV_MESH_MAX_DISTANCE do
		local search_position = exit_position + search_direction * search_distance
		local position_on_mesh = NavQueries.position_on_mesh(nav_world, search_position, NAV_MESH_ABOVE, NAV_MESH_BELOW, traverse_logic)

		if position_on_mesh then
			if search_distance > 0 then
				local _, hit_position = GwNavQueries.raycast(nav_world, position_on_mesh, exit_position, traverse_logic)

				if hit_position then
					position_on_mesh = hit_position
				end
			end

			return position_on_mesh
		end

		search_distance = search_distance + NAV_MESH_STEP_LENGTH
	end
end

MinionSpawnerSpawnPosition.validate_exit_position = function (nav_world, exit_position, traverse_logic)
	local position_on_mesh = NavQueries.position_on_mesh(nav_world, exit_position, NAV_MESH_ABOVE, NAV_MESH_BELOW, traverse_logic)
	local is_valid = position_on_mesh ~= nil

	return is_valid
end

return MinionSpawnerSpawnPosition

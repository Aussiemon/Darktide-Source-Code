-- chunkname: @scripts/managers/bot_nav_transition/utilities/ladder_nav_transition.lua

local NavQueries = require("scripts/utilities/nav_queries")
local LadderNavTransition = {}

LadderNavTransition.NAV_TAG_LAYER = "bot_ladders"

local CLIMBING_OFFSET = 0.25
local MAX_DISTANCE_FROM_GROUND = 10

LadderNavTransition.find_ground_position = function (top_position, ladder_length, back_direction, down_direction, physics_world, drawer)
	local ray_start = top_position + back_direction * CLIMBING_OFFSET
	local ray_length = ladder_length + MAX_DISTANCE_FROM_GROUND
	local hit, hit_position = PhysicsWorld.raycast(physics_world, ray_start, down_direction, ray_length, "closest", "collision_filter", "filter_player_mover")

	return hit_position
end

local NAV_MESH_STEP_SIZE, NAV_MESH_MAX_STEPS = 0.2, 7
local NAV_MESH_ABOVE, NAV_MESH_BELOW = 0.3, 0.5

LadderNavTransition.find_position_on_nav_mesh = function (start_position, nav_world, search_direction, traverse_logic, drawer)
	local check_position, nav_mesh_position

	for step_index = 0, NAV_MESH_MAX_STEPS do
		check_position = start_position + search_direction * NAV_MESH_STEP_SIZE * step_index
		nav_mesh_position = NavQueries.position_on_mesh(nav_world, check_position, NAV_MESH_ABOVE, NAV_MESH_BELOW, traverse_logic)

		if nav_mesh_position then
			break
		end
	end

	return nav_mesh_position
end

local CLIMBABLE_HEIGHT = 1.5

LadderNavTransition.is_bidirectional = function (ground_position, ladder_bottom_position)
	local is_bidirectional = ground_position.z > ladder_bottom_position.z - CLIMBABLE_HEIGHT

	return is_bidirectional
end

return LadderNavTransition

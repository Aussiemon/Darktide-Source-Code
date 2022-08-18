local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local NavQueries = require("scripts/utilities/nav_queries")
local LEDGE_TRIGGER_NODE_NAME = "g_ledge_trigger"
local HAND_HOLD_NODE_NAME = "g_hand_hold_area"
local HangLedge = {}
local _is_position_in_line_of_sight = nil

HangLedge.calculate_new_position = function (hang_ledge_unit, player_position)
	local hang_ledge_scale = Unit.local_scale(hang_ledge_unit, 1)
	local ledge_trigger_node = Unit.node(hang_ledge_unit, LEDGE_TRIGGER_NODE_NAME)
	local ledge_rotation = Unit.world_rotation(hang_ledge_unit, ledge_trigger_node)
	local hand_hold_node = Unit.node(hang_ledge_unit, HAND_HOLD_NODE_NAME)
	local hand_hold_position = Unit.world_position(hang_ledge_unit, hand_hold_node)
	local hand_hold_rotation = Unit.world_rotation(hang_ledge_unit, hand_hold_node)
	local hand_hold_scale = Unit.local_scale(hang_ledge_unit, hand_hold_node)
	local hand_hold_right_vector = Quaternion.right(hand_hold_rotation)
	local position_offset = 1 - 0.3 * 1 / hang_ledge_scale.x * 1 / hand_hold_scale.x
	position_offset = position_offset * hang_ledge_scale.x * hand_hold_scale.x
	local left_point = hand_hold_position - hand_hold_right_vector * position_offset
	local right_point = hand_hold_position + hand_hold_right_vector * position_offset
	local player_new_position = Geometry.closest_point_on_line(player_position, left_point, right_point)
	local hang_ledge_spawn_offset = PlayerCharacterConstants.hang_ledge_spawn_offset
	local hang_ledge_spawn_position = player_new_position - Quaternion.forward(ledge_rotation) * hang_ledge_spawn_offset

	return player_new_position, hang_ledge_spawn_position
end

HangLedge.calculate_hanging_rotation = function (hang_ledge_unit)
	local hand_hold_node = Unit.node(hang_ledge_unit, HAND_HOLD_NODE_NAME)
	local hand_hold_rotation = Unit.world_rotation(hang_ledge_unit, hand_hold_node)
	local hand_hold_yaw = Quaternion.yaw(hand_hold_rotation)
	local enter_rotation = Quaternion(Vector3.up(), hand_hold_yaw + math.pi)
	local to_unit = Quaternion.forward(enter_rotation)
	local exit_rotation = Quaternion.look(-to_unit)

	return exit_rotation
end

HangLedge.calculate_offset_rotation = function (physics_world, hang_ledge_unit, rotation, target_position)
	local to_unit = Quaternion.forward(rotation)
	local ray_origin_offset = Vector3.up() * 0.25
	local ray_origin_position = target_position + to_unit * 0.25 + ray_origin_offset
	local below_player_position = ray_origin_position - Vector3.up() * 2.25
	local first_ray_succeded = _is_position_in_line_of_sight(physics_world, ray_origin_position, below_player_position)

	if not first_ray_succeded then
		local ray_succeded, hit_position, ray_goal_position = nil
		local num_rays = 5

		for i = 1, num_rays do
			ray_goal_position = below_player_position + to_unit * 0.5 * i
			ray_succeded, hit_position = _is_position_in_line_of_sight(physics_world, ray_origin_position, ray_goal_position)

			if ray_succeded then
				break
			end
		end

		local ledge_trigger_node = Unit.node(hang_ledge_unit, LEDGE_TRIGGER_NODE_NAME)
		local hang_ledge_position = Unit.world_position(hang_ledge_unit, ledge_trigger_node)

		if ray_succeded then
			local right_dir = Quaternion.right(rotation)
			local to_goal_position = Vector3.normalize(ray_goal_position - hang_ledge_position)
			local cross_dir = Vector3.cross(right_dir, to_goal_position)
			local new_rotation = Quaternion.look(cross_dir)
			rotation = new_rotation
		end
	end

	return rotation
end

HangLedge.calculate_falling_start_position = function (hang_ledge_unit, hanging_unit, distance_from_ledge, player_height)
	local hand_hold_node = Unit.node(hang_ledge_unit, HAND_HOLD_NODE_NAME)
	local hang_ledge_rotation = Unit.world_rotation(hang_ledge_unit, hand_hold_node)
	local hang_ledge_forward = Quaternion.forward(hang_ledge_rotation)
	local hanging_unit_position = Unit.local_position(hanging_unit, 1)
	local new_position = hanging_unit_position - hang_ledge_forward * distance_from_ledge
	new_position.z = new_position.z - player_height

	return new_position
end

local function _calculate_hang_ledge_spawn_position(nav_world, hang_ledge_position)
	local target_position = hang_ledge_position
	local above_limit = 5
	local below_limit = 5
	local horizontal_limit = 10
	local distance_from_nav_border = 0.25
	local new_position_on_nav = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, target_position, above_limit, below_limit, horizontal_limit, distance_from_nav_border)

	return new_position_on_nav
end

HangLedge.calculate_pull_up_end_position = function (nav_world, hang_ledge_unit, hanging_unit)
	local hand_hold_node = Unit.node(hang_ledge_unit, HAND_HOLD_NODE_NAME)
	local hand_hold_position = Unit.world_position(hang_ledge_unit, hand_hold_node)
	local hand_hold_rotation = Unit.world_rotation(hang_ledge_unit, hand_hold_node)
	local hanging_unit_position = Unit.local_position(hanging_unit, 1)
	local hand_hold_right_vector = Quaternion.right(hand_hold_rotation)
	local direction = hanging_unit_position - hand_hold_position
	local position_offset = Vector3.dot(hand_hold_right_vector, direction)
	local respawn_node = Unit.node(hang_ledge_unit, "g_respawn_area")
	local respawn_position = Unit.world_position(hang_ledge_unit, respawn_node)
	local respawn_rotation = Unit.world_rotation(hang_ledge_unit, respawn_node)
	local respawn_right_vector = Quaternion.right(respawn_rotation)
	local new_position = respawn_position + respawn_right_vector * position_offset
	local new_position_on_nav = _calculate_hang_ledge_spawn_position(nav_world, new_position)
	local is_close = false

	if new_position_on_nav then
		local distance = Vector3.distance(new_position, new_position_on_nav)
		is_close = distance < 4

		if is_close then
			new_position = new_position_on_nav
		end
	end

	return new_position
end

function _is_position_in_line_of_sight(physics_world, from_position, target_position, collision_filter)
	collision_filter = collision_filter or "filter_minion_line_of_sight_check"
	local to_target = target_position - from_position
	local distance = Vector3.length(to_target)

	if distance == 0 then
		return false
	end

	local direction = Vector3.normalize(to_target)
	local result, hit_position = PhysicsWorld.raycast(physics_world, from_position, direction, distance, "closest", "collision_filter", collision_filter)
	local no_hit = not result

	return no_hit, hit_position
end

return HangLedge

local NavQueries = {}
local DEFAULT_NAV_ABOVE = 30
local DEFAULT_NAV_BELOW = 30

NavQueries.position_on_mesh = function (nav_world, position, above, below, traverse_logic)
	above = above or DEFAULT_NAV_ABOVE
	below = below or DEFAULT_NAV_BELOW
	local altitude = nil

	if traverse_logic then
		altitude = GwNavQueries.triangle_from_position(nav_world, position, above, below, traverse_logic)
	else
		altitude = GwNavQueries.triangle_from_position(nav_world, position, above, below)
	end

	if altitude then
		local projected_position = Vector3(position.x, position.y, altitude)

		return projected_position
	else
		return nil
	end
end

local DEFAULT_NAV_LATERAL = 0.5
local DEFAULT_DISTANCE_FROM_NAV_MESH = 0

NavQueries.position_on_mesh_with_outside_position = function (nav_world, traverse_logic, position, above, below, lateral, distance_from_nav_mesh)
	above = above or DEFAULT_NAV_ABOVE
	below = below or DEFAULT_NAV_BELOW
	lateral = lateral or DEFAULT_NAV_LATERAL
	distance_from_nav_mesh = distance_from_nav_mesh or DEFAULT_DISTANCE_FROM_NAV_MESH
	local projected_position, altitude = nil

	if traverse_logic then
		altitude = GwNavQueries.triangle_from_position(nav_world, position, above, below, traverse_logic)
	else
		altitude = GwNavQueries.triangle_from_position(nav_world, position, above, below)
	end

	if altitude then
		projected_position = Vector3(position.x, position.y, altitude)
	elseif traverse_logic then
		projected_position = GwNavQueries.inside_position_from_outside_position(nav_world, position, above, below, lateral, distance_from_nav_mesh, traverse_logic)
	else
		projected_position = GwNavQueries.inside_position_from_outside_position(nav_world, position, above, below, lateral, distance_from_nav_mesh)
	end

	return projected_position
end

NavQueries.ray_can_go = function (nav_world, position_start, position_end, traverse_logic, above, below)
	local projected_start_position = NavQueries.position_on_mesh(nav_world, position_start, above, below, traverse_logic)
	local projected_end_position = projected_start_position and NavQueries.position_on_mesh(nav_world, position_end, above, below, traverse_logic)
	local raycango = nil

	if traverse_logic then
		raycango = projected_end_position and GwNavQueries.raycango(nav_world, projected_start_position, projected_end_position, traverse_logic)
	else
		raycango = projected_end_position and GwNavQueries.raycango(nav_world, projected_start_position, projected_end_position)
	end

	return raycango, projected_start_position, projected_end_position
end

local FLAT_GROUND_UP_DOT_THRESHOLD = 0.9

local function _is_on_flat_ground(physics_world, position)
	local ray_source = position + Vector3.up() * 0.1
	local hit_ground, _, _, ground_normal = PhysicsWorld.raycast(physics_world, ray_source, Vector3.down(), 0.15, "closest", "collision_filter", "filter_minion_mover")
	local is_standing_on_flat_ground = nil

	if hit_ground then
		local up_dot = Vector3.dot(ground_normal, Vector3.up())
		is_standing_on_flat_ground = FLAT_GROUND_UP_DOT_THRESHOLD < up_dot
	end

	return is_standing_on_flat_ground
end

local EPSILON_SQ = 0.0001
local NAV_CHECK_ABOVE = 0.25
local NAV_CHECK_BELOW = 0.25
local NAV_CHECK_DISTANCE = 0.3
local WALL_CHECK_RAYCAST_LENGTH = 1.3
local WALL_CHECK_RAYCAST_LOW_HEIGHT = 0.4

NavQueries.movement_check = function (nav_world, physics_world, position, velocity, traverse_logic)
	local is_moving = EPSILON_SQ < Vector3.length_squared(velocity)

	if not is_moving then
		return "navmesh_ok"
	end

	local direction = Vector3.normalize(velocity)
	local target_position = position + direction * NAV_CHECK_DISTANCE
	local ray_can_go, projected_position, projected_target_position = NavQueries.ray_can_go(nav_world, position, target_position, traverse_logic, NAV_CHECK_ABOVE, NAV_CHECK_BELOW)

	if ray_can_go then
		return "navmesh_ok"
	end

	local hit_wall, ray_source, hit_position = nil
	local allowed_to_do_wall_check = _is_on_flat_ground(physics_world, position)

	if allowed_to_do_wall_check then
		ray_source = position + Vector3.up() * WALL_CHECK_RAYCAST_LOW_HEIGHT
		hit_wall, hit_position = PhysicsWorld.raycast(physics_world, ray_source, direction, WALL_CHECK_RAYCAST_LENGTH, "closest", "collision_filter", "filter_minion_mover")
	end

	if hit_wall then
		return "navmesh_hit_wall"
	else
		return "navmesh_use_mover"
	end
end

local CHECKS_PER_DIRECTION = 5
local ANGLE_INCREMENT = math.pi / (2 * CHECKS_PER_DIRECTION)
local CHECK_DISTANCE = 5

NavQueries.position_near_nav_position = function (nav_position, check_direction, nav_world, traverse_logic)
	local Quaternion_rotate = Quaternion.rotate
	local Quaternion_axis_angle = Quaternion.axis_angle
	local GwNavQueries_raycast = GwNavQueries.raycast
	local Vector3_distance_squared = Vector3.distance_squared
	local best_position = nil
	local best_distance_sq = -math.huge
	local angle_sign = 1

	for i = 0, CHECKS_PER_DIRECTION, 1 do
		local directions_to_check = (i > 0 and 2) or 1

		for j = 1, directions_to_check, 1 do
			local angle = angle_sign * ANGLE_INCREMENT * i
			local rotation = Quaternion_axis_angle(Vector3.up(), angle)
			local new_direction = Quaternion_rotate(rotation, check_direction)
			local to_position = nav_position + new_direction * CHECK_DISTANCE
			local success, hit_position = GwNavQueries_raycast(nav_world, nav_position, to_position, traverse_logic)

			if success then
				return hit_position
			end

			local distance_sq = Vector3_distance_squared(nav_position, hit_position)

			if best_distance_sq < distance_sq then
				best_distance_sq = distance_sq
				best_position = hit_position
			end

			angle_sign = -angle_sign
		end
	end

	return best_position
end

return NavQueries

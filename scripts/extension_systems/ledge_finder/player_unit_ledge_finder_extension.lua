-- chunkname: @scripts/extension_systems/ledge_finder/player_unit_ledge_finder_extension.lua

local MaterialQuery = require("scripts/utilities/material_query")
local PlayerUnitLedgeFinderExtension = class("PlayerUnitLedgeFinderExtension")
local RING_BUFFER_SIZE = 32
local MAX_NUM_LEDGE_TRACKING = 5
local HEIGHT_LIMIT = 3
local NUM_RAYS = 10
local NUM_ENTRIES_PER_RAY = 3
local HIT = 1
local POSITION = 2
local DISTANCE = 3
local RAY_LENGTH = 2
local OBB_LENGTH = 1
local HEIGHT_STEP = HEIGHT_LIMIT / NUM_RAYS
local PLAYER_RADIUS = 0.1
local _ring_buffer_index, _significant_obstacles_ring_buffer_index

PlayerUnitLedgeFinderExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	local ledge_finder_tweak_data = extension_init_data.ledge_finder_tweak_data

	self._ledge_finder_tweak_data = ledge_finder_tweak_data

	local physics_world = extension_init_context.physics_world

	self._physics_world = physics_world

	local unit_data = ScriptUnit.extension(unit, "unit_data_system")

	self._unit_data_extension = unit_data

	local fixed_frame = extension_init_context.fixed_frame

	self._fixed_frame = fixed_frame

	local ledge_collision_filter = "filter_player_mover"

	self._ledge_collision_filter = ledge_collision_filter
	self._raycast_object = PhysicsWorld.make_raycast(physics_world, "closest", "types", "statics", "collision_filter", ledge_collision_filter)

	local ledge_ring_buffer = Script.new_array(RING_BUFFER_SIZE)

	self._ledge_ring_buffer = ledge_ring_buffer

	for ii = 1, RING_BUFFER_SIZE do
		local ledge_data = Script.new_array(MAX_NUM_LEDGE_TRACKING)

		for jj = 1, MAX_NUM_LEDGE_TRACKING do
			ledge_data[jj] = self:_new_ledge_data()
		end

		local ledges = {
			num_ledges = 0,
			ledge_data = ledge_data,
		}

		ledge_ring_buffer[ii] = ledges
	end

	local significant_obstacles_size = RING_BUFFER_SIZE * 2
	local significant_obstacles_ring_buffer = Script.new_array(significant_obstacles_size)

	self._significant_obstacles_ring_buffer = significant_obstacles_ring_buffer

	for ii = 1, significant_obstacles_size, 2 do
		significant_obstacles_ring_buffer[ii] = false
		significant_obstacles_ring_buffer[ii + 1] = false
	end
end

PlayerUnitLedgeFinderExtension._new_ledge_data = function (self)
	local ledge_data = {
		left = Vector3Box(),
		right = Vector3Box(),
		forward = Vector3Box(),
		distance_sq_from_player_unit = math.huge,
		distance_flat_sq_from_player_unit = math.huge,
		height_distance_from_player_unit = math.huge,
	}

	return ledge_data
end

PlayerUnitLedgeFinderExtension.ledges = function (self)
	local ledges = self._ledge_ring_buffer[_ring_buffer_index(self._fixed_frame)]

	return ledges.num_ledges, ledges.ledge_data
end

PlayerUnitLedgeFinderExtension.has_significant_obstacle_in_front = function (self)
	local significant_obstacles_ring_buffer = self._significant_obstacles_ring_buffer
	local index = _significant_obstacles_ring_buffer_index(self._fixed_frame)

	return significant_obstacles_ring_buffer[index], significant_obstacles_ring_buffer[index + 1]
end

local OBB_HALF_HEIGHT = HEIGHT_STEP * NUM_RAYS * 0.5

PlayerUnitLedgeFinderExtension.calculate_ledges = function (self, fixed_frame, player_position, base_position_offset, position_1p, rotation_1p)
	self._fixed_frame = fixed_frame

	if self._unit_data_extension.is_resimulating then
		return
	end

	local ledges = self._ledge_ring_buffer[_ring_buffer_index(fixed_frame)]

	ledges.num_ledges = 0

	local significant_obstacles_index = _significant_obstacles_ring_buffer_index(fixed_frame)
	local significant_obstacles_ring_buffer = self._significant_obstacles_ring_buffer

	significant_obstacles_ring_buffer[significant_obstacles_index] = false
	significant_obstacles_ring_buffer[significant_obstacles_index + 1] = false

	local forward = Quaternion.forward(rotation_1p)
	local ray_direction = Vector3.normalize(Vector3.flat(forward))
	local up = Vector3.up()
	local base_position = player_position + base_position_offset
	local from = base_position + up * OBB_HALF_HEIGHT
	local to = from + ray_direction * OBB_LENGTH
	local half_extents = Vector3(PLAYER_RADIUS, 0.1, OBB_HALF_HEIGHT)
	local sweep_rotation = Quaternion.look(ray_direction)
	local collisions = PhysicsWorld.linear_obb_sweep(self._physics_world, from, to, half_extents, sweep_rotation, 1, "types", "statics", "collision_filter", self._ledge_collision_filter)
	local collision = collisions and collisions[1]

	if not collision then
		return
	end

	local right = Quaternion.right(rotation_1p)
	local has_significant_obstacle_in_front = self:_try_find_ledges(ledges, base_position, player_position, forward, right)

	significant_obstacles_ring_buffer[significant_obstacles_index] = has_significant_obstacle_in_front

	if has_significant_obstacle_in_front then
		significant_obstacles_ring_buffer[significant_obstacles_index + 1] = Raycast.cast(self._raycast_object, position_1p, forward, self._ledge_finder_tweak_data.significant_obstacle_distance)
	else
		significant_obstacles_ring_buffer[significant_obstacles_index + 1] = false
	end
end

local RAYCAST_RESULTS_LEFT = {
	[0] = 0,
}
local RAYCAST_RESULTS_RIGHT = {
	[0] = 0,
}

PlayerUnitLedgeFinderExtension._try_find_ledges = function (self, ledges, base_position, player_position, forward, right)
	local left_pos, right_pos

	left_pos = base_position - right * PLAYER_RADIUS
	right_pos = base_position + right * PLAYER_RADIUS

	local ray_direction = Vector3.normalize(Vector3.flat(forward))
	local num_ledges = ledges.num_ledges
	local ledge_data = ledges.ledge_data
	local up_vector = Vector3.up()
	local player_position_flat = Vector3.flat(player_position)
	local physics_world = self._physics_world
	local linear_sphere_sweep = PhysicsWorld.linear_sphere_sweep
	local collision_filter = self._ledge_collision_filter
	local raycast = Raycast.cast
	local raycast_object = self._raycast_object

	for ray_index = 1, NUM_RAYS do
		local up_offset = up_vector * HEIGHT_STEP * ray_index
		local left_ray_pos = left_pos + up_offset
		local right_ray_pos = right_pos + up_offset
		local left_hit, left_position, left_distance = raycast(raycast_object, left_ray_pos, ray_direction, RAY_LENGTH)
		local right_hit, right_position, right_distance = raycast(raycast_object, right_ray_pos, ray_direction, RAY_LENGTH)
		local ray_result_index = (ray_index - 1) * NUM_ENTRIES_PER_RAY
		local hit_index = ray_result_index + HIT
		local position_index = ray_result_index + POSITION
		local distance_index = ray_result_index + DISTANCE

		RAYCAST_RESULTS_LEFT[hit_index] = left_hit
		RAYCAST_RESULTS_LEFT[position_index] = left_position
		RAYCAST_RESULTS_LEFT[distance_index] = left_distance
		RAYCAST_RESULTS_RIGHT[hit_index] = right_hit
		RAYCAST_RESULTS_RIGHT[position_index] = right_position
		RAYCAST_RESULTS_RIGHT[distance_index] = right_distance
	end

	local ledge_finder_tweak_data = self._ledge_finder_tweak_data
	local player_height = ledge_finder_tweak_data.player_height
	local player_width = ledge_finder_tweak_data.player_width
	local significant_obstacle_distance = ledge_finder_tweak_data.significant_obstacle_distance
	local has_significant_obstacle_in_front = false
	local player_pos_z = player_position.z
	local base_pos_z = base_position.z

	for eval_ray_index = 1, NUM_RAYS do
		local eval_strided_i = (eval_ray_index - 1) * NUM_ENTRIES_PER_RAY
		local eval_hit_index = eval_strided_i + HIT
		local left_hit = RAYCAST_RESULTS_LEFT[eval_hit_index]
		local right_hit = RAYCAST_RESULTS_RIGHT[eval_hit_index]

		if left_hit or right_hit then
			local eval_distance_index = eval_strided_i + DISTANCE
			local eval_left_distance = RAYCAST_RESULTS_LEFT[eval_distance_index] or math.huge
			local eval_right_distance = RAYCAST_RESULTS_RIGHT[eval_distance_index] or math.huge
			local eval_distance = math.min(eval_left_distance, eval_right_distance)

			if eval_distance <= significant_obstacle_distance then
				local z_distance = base_pos_z + HEIGHT_STEP * eval_ray_index
				local player_pos_height_delta = z_distance - player_pos_z

				has_significant_obstacle_in_front = player_pos_height_delta >= 0.5
			end

			local possible_ledge = false

			for comp_ray_index = eval_ray_index + 1, NUM_RAYS do
				local comp_strided_i = (comp_ray_index - 1) * NUM_ENTRIES_PER_RAY
				local comp_distance_index = comp_strided_i + DISTANCE
				local comp_left_distance = RAYCAST_RESULTS_LEFT[comp_distance_index] or math.huge
				local comp_right_distance = RAYCAST_RESULTS_RIGHT[comp_distance_index] or math.huge
				local comp_distance = math.min(comp_left_distance, comp_right_distance)

				if not (player_width < comp_distance - eval_distance) then
					break
				end

				local num_comparisons = comp_ray_index - eval_ray_index
				local enough_space_to_fit_height_above = player_height < HEIGHT_STEP * num_comparisons

				if enough_space_to_fit_height_above then
					possible_ledge = true

					break
				end
			end

			if possible_ledge then
				local eval_position_index = eval_strided_i + POSITION
				local eval_left_pos, eval_right_pos

				if math.abs(eval_left_distance - eval_right_distance) > 0.3 then
					local up_offset = up_vector * HEIGHT_STEP * eval_ray_index

					if eval_left_distance < eval_right_distance then
						eval_left_pos = RAYCAST_RESULTS_LEFT[eval_position_index]
						eval_right_pos = right_pos + up_offset + ray_direction * eval_left_distance
					else
						eval_left_pos = left_pos + up_offset + ray_direction * eval_right_distance
						eval_right_pos = RAYCAST_RESULTS_RIGHT[eval_position_index]
					end
				else
					eval_left_pos = RAYCAST_RESULTS_LEFT[eval_position_index]
					eval_right_pos = RAYCAST_RESULTS_RIGHT[eval_position_index]
				end

				local mid_point = Vector3.lerp(eval_left_pos, eval_right_pos, 0.5)
				local radius = 0.1
				local start_pos = mid_point + up_vector * HEIGHT_STEP + up_vector * radius
				local collisions = linear_sphere_sweep(physics_world, start_pos, mid_point, radius, 1, "types", "statics", "collision_filter", collision_filter)
				local collision = collisions and collisions[1]

				if collision then
					local collision_point = collision.position
					local col_pos_z = collision_point.z

					eval_left_pos.z = col_pos_z
					eval_right_pos.z = col_pos_z
					mid_point.z = col_pos_z
					num_ledges = num_ledges + 1
					ledges.num_ledges = num_ledges

					local ledge = ledge_data[num_ledges]

					ledge.left:store(eval_left_pos)
					ledge.right:store(eval_right_pos)

					local ledge_dir = Vector3.normalize(eval_left_pos - eval_right_pos)
					local ledge_forward = Vector3.cross(ledge_dir, up_vector)

					ledge.forward:store(ledge_forward)

					local distance_sq = Vector3.distance_squared(player_position, mid_point)

					ledge.distance_sq_from_player_unit = distance_sq

					local mid_point_flat = Vector3.flat(mid_point)
					local distance_flat_sq = Vector3.distance_squared(player_position_flat, mid_point_flat)

					ledge.distance_flat_sq_from_player_unit = distance_flat_sq

					local height_distance = math.abs(mid_point.z - player_position.z)

					ledge.height_distance_from_player_unit = height_distance

					local actor = collision.actor

					if actor then
						local unit = Actor.unit(actor)

						ledge.material_or_nil = MaterialQuery.query_unit_material(unit, collision_point, -up_vector)
					else
						ledge.material_or_nil = nil
					end
				end
			end
		end
	end

	return has_significant_obstacle_in_front
end

local PERPENDICULAR_RAD = math.pi * 0.5
local HALF_WIGGLE_ROOM_RAD = math.pi * 0.08
local RAD_UPPER = PERPENDICULAR_RAD + HALF_WIGGLE_ROOM_RAD
local RAD_LOWER = PERPENDICULAR_RAD - HALF_WIGGLE_ROOM_RAD

PlayerUnitLedgeFinderExtension._pair_potential_ledge_points = function (self, ledges, potential_left_ledge_points, potential_right_ledge_points, ledge_point_unit_map)
	local up = Vector3.up()
	local down = -up
	local ledge_data = ledges.ledge_data
	local num_left_ledge_points = #potential_left_ledge_points

	for left_i = 1, num_left_ledge_points do
		local eval_point = potential_left_ledge_points[left_i]
		local best_right_i, best_find_point, best_find_rad = nil, nil, math.huge
		local num_potential_right_ledge_points = #potential_right_ledge_points

		for right_i = 1, num_potential_right_ledge_points do
			local comp_point = potential_right_ledge_points[right_i]
			local dir = Vector3.normalize(eval_point - comp_point)
			local dot = math.clamp(Vector3.dot(dir, up), -1, 1)
			local angle_rad = math.acos(dot)
			local within_allowed_angle = angle_rad <= RAD_UPPER and angle_rad >= RAD_LOWER

			if within_allowed_angle and angle_rad < best_find_rad then
				best_right_i = right_i
				best_find_point = comp_point
				best_find_rad = angle_rad
			end
		end

		if best_right_i then
			local ledge_index = ledges.num_ledges + 1

			ledges.num_ledges = ledge_index

			local data = ledge_data[ledge_index]

			data.left:store(eval_point)
			data.right:store(best_find_point)

			local right_unit = ledge_point_unit_map[best_find_point]
			local left_unit = ledge_point_unit_map[eval_point]
			local material_unit = right_unit or left_unit

			if material_unit then
				local impact_position = material_unit == right_unit and best_find_point or eval_point

				data.material_or_nil = MaterialQuery.query_unit_material(material_unit, impact_position, down)
			else
				data.material_or_nil = nil
			end

			table.remove(potential_right_ledge_points, best_right_i)
		end
	end
end

PlayerUnitLedgeFinderExtension._finalize_ledges = function (self, ledges, player_position, peeking_potential, height)
	local peeking_is_possible = false
	local num_ledges = ledges.num_ledges
	local ledge_data = ledges.ledge_data
	local player_position_flat = Vector3.flat(player_position)
	local linear_sphere_sweep = PhysicsWorld.linear_sphere_sweep
	local physics_world = self._physics_world
	local collision_filter = self._ledge_collision_filter
	local up = Vector3.up()

	for i = 1, num_ledges do
		local data = ledge_data[i]
		local left, right = data.left:unbox(), data.right:unbox()
		local mid_point = Vector3.lerp(left, right, 0.5)
		local start_pos = mid_point + up * HEIGHT_STEP
		local radius = 0.1
		local collisions = linear_sphere_sweep(physics_world, start_pos, mid_point, radius, 1, "types", "statics", "collision_filter", collision_filter)
		local first_collision = collisions and collisions[1]

		if first_collision then
			local hit_pos_z = first_collision.position.z

			left.z = hit_pos_z
			right.z = hit_pos_z

			data.left:store(left)
			data.right:store(right)

			mid_point = Vector3.lerp(left, right, 0.5)
		end

		local ledge_dir = Vector3.normalize(left - right)
		local forward = Vector3.cross(ledge_dir, up)

		data.forward:store(forward)

		local distance_sq = Vector3.distance_squared(player_position, mid_point)

		data.distance_sq_from_player_unit = distance_sq

		local mid_point_flat = Vector3.flat(mid_point)
		local distance_flat_sq = Vector3.distance_squared(player_position_flat, mid_point_flat)

		data.distance_flat_sq_from_player_unit = distance_flat_sq

		local height_distance = math.abs(mid_point.z - player_position.z)

		data.height_distance_from_player_unit = height_distance

		if peeking_potential and i == 1 and height <= height_distance then
			peeking_is_possible = true
		end
	end

	return peeking_is_possible
end

function _ring_buffer_index(fixed_frame)
	return fixed_frame % RING_BUFFER_SIZE + 1
end

function _significant_obstacles_ring_buffer_index(fixed_frame)
	return fixed_frame % RING_BUFFER_SIZE * 2 + 1
end

return PlayerUnitLedgeFinderExtension

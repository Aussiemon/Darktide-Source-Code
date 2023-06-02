local Trajectory = {}

local function _wanted_projectile_angle(distance_vector, projectile_gravity, projectile_speed)
	local x = Vector3.length(Vector3.flat(distance_vector))

	if x <= 0 then
		return
	end

	local y = distance_vector.z
	local g = projectile_gravity
	local v = projectile_speed
	local v2 = v * v
	local to_sqrt = v2 * v2 - g * (g * x * x + 2 * y * v2)

	if to_sqrt < 0 then
		return
	end

	local s = math.sqrt(to_sqrt)
	local a1 = math.atan((v2 - s) / (g * x))
	local a2 = math.atan((v2 + s) / (g * x))

	return a1, a2, x
end

local function _wanted_projectile_speed(distance_vector, projectile_gravity, wanted_angle)
	local x = Vector3.length(Vector3.flat(distance_vector))
	local y = distance_vector.z
	local g = math.abs(projectile_gravity)
	local denominator = 2 * (x * math.tan(wanted_angle) - y)
	local aux = math.abs(g / denominator)

	if aux >= 0 then
		return x / math.cos(wanted_angle) * math.sqrt(aux), x
	end
end

Trajectory.angle_to_hit_moving_target = function (from_position, target_position, projectile_speed, target_velocity, gravity, acceptable_accuracy, use_greatest_angle)
	local angle = nil
	local EPSILON = 0.01
	local estimated_target_position = target_position
	local flat_distance = Vector3.length(Vector3.flat(estimated_target_position - from_position))
	local old_flat_distance = flat_distance
	local t = nil

	for i = 1, 10 do
		local height = estimated_target_position.z - from_position.z
		local speed_sq = projectile_speed^2

		if flat_distance < EPSILON then
			return 0, estimated_target_position
		end

		local sqrt_val = speed_sq^2 - gravity * (gravity * flat_distance^2 + 2 * height * speed_sq)

		if sqrt_val <= 0 then
			return nil, estimated_target_position
		end

		local second_degree_component = math.sqrt(sqrt_val)
		local angle1 = math.atan((speed_sq + second_degree_component) / (gravity * flat_distance))
		local angle2 = math.atan((speed_sq - second_degree_component) / (gravity * flat_distance))
		angle = use_greatest_angle and math.max(angle1, angle2) or math.min(angle1, angle2)
		t = flat_distance / (projectile_speed * math.cos(angle))
		estimated_target_position = target_position + t * target_velocity
		flat_distance = Vector3.length(Vector3.flat(estimated_target_position - from_position))
		local distance_error = math.abs(old_flat_distance - flat_distance)

		if distance_error <= acceptable_accuracy then
			return angle, estimated_target_position
		end

		old_flat_distance = flat_distance
	end

	return angle, estimated_target_position
end

Trajectory.get_trajectory_velocity = function (from_position, target_position, gravity, projectile_speed, angle)
	local to_target = target_position - from_position
	local flat_dist = Vector3.length(Vector3.flat(to_target))

	if not projectile_speed and angle then
		projectile_speed = _wanted_projectile_speed(to_target, -gravity, angle)
	end

	if not angle and projectile_speed then
		local a1, a2 = _wanted_projectile_angle(to_target, -gravity, projectile_speed)
		angle = a1 or a2
	end

	local to_target_flat = Vector3.normalize(Vector3.flat(to_target))
	local to_target_right = Vector3.cross(to_target_flat, Vector3.up())
	local velocity = Quaternion.rotate(Quaternion.axis_angle(to_target_right, angle), to_target_flat) * projectile_speed
	local flat_speed = Vector3.length(Vector3(velocity.x, velocity.y, 0))
	local time_in_flight = flat_dist / flat_speed

	return velocity, time_in_flight, angle
end

local SEGMENT_LIST = {}

Trajectory.check_trajectory_collisions = function (physics_world, from_position, target_position, gravity, projectile_speed, angle, sections, collision_filter, time_in_flight, ignored_unit_collisions, debug_draw_trajectory, optional_unit, optional_extra_ray_check_up, optional_extra_ray_check_down)
	table.clear(SEGMENT_LIST)

	local to_target = target_position - from_position
	local to_target_flat = Vector3.normalize(Vector3.flat(to_target))
	local x_vel_0 = math.cos(angle) * projectile_speed
	local y_vel_0 = math.sin(angle) * projectile_speed
	sections = sections or 4
	local segment_pos1 = Vector3(from_position.x, from_position.y, from_position.z)
	local segment_pos2 = nil
	SEGMENT_LIST[1] = from_position
	local t = nil

	for i = 1, sections do
		t = time_in_flight * i / sections
		local x = x_vel_0 * t
		local z = y_vel_0 * t - 0.5 * gravity * t^2
		segment_pos2 = from_position + to_target_flat * x
		segment_pos2.z = segment_pos2.z + z
		local current_velocity = segment_pos2 - segment_pos1
		local length = Vector3.length(current_velocity)
		local result, hit_pos, _, _, actor = PhysicsWorld.raycast(physics_world, segment_pos1, current_velocity, length, "closest", "collision_filter", collision_filter)

		if result then
			if ignored_unit_collisions then
				local hit_unit = Actor.unit(actor)

				if not ignored_unit_collisions[hit_unit] then
					return false, hit_pos, SEGMENT_LIST
				end
			else
				return false, hit_pos, SEGMENT_LIST
			end
		end

		if optional_unit then
			local mover_test_position = (segment_pos1 + segment_pos2) / 2
			local mover_fits = Unit.mover_fits_at(optional_unit, "mover", mover_test_position)

			if not mover_fits then
				return false, nil, SEGMENT_LIST
			end
		end

		if i > 1 and i < sections and optional_extra_ray_check_up and optional_extra_ray_check_down then
			local ray_from = segment_pos2 + optional_extra_ray_check_down
			local ray_to = segment_pos2 + optional_extra_ray_check_up
			local extra_ray_length = Vector3.distance(ray_from, ray_to)
			local extra_ray_direction = Vector3.normalize(optional_extra_ray_check_up)
			local extra_raycast_result, extra_raycast_hit_pos = PhysicsWorld.raycast(physics_world, ray_from, extra_ray_direction, extra_ray_length, "closest", "collision_filter", collision_filter)

			if extra_raycast_result then
				return false, extra_raycast_hit_pos, SEGMENT_LIST
			end
		end

		segment_pos1 = Vector3(segment_pos2.x, segment_pos2.y, segment_pos2.z)
		SEGMENT_LIST[i + 1] = segment_pos1
	end

	return true, time_in_flight, SEGMENT_LIST
end

local SEGMENTS = {}
local MAX_TIME = 1.5
local MAX_STEPS = 30

Trajectory.ballistic_raycast = function (physics_world, collision_filter, original_position, velocity, angle, z_gravity, optional_max_steps, optional_max_time)
	table.clear(SEGMENTS)

	local gravity = Vector3(0, 0, -z_gravity)
	local time_step = (optional_max_time or MAX_TIME) / (optional_max_steps or MAX_STEPS)
	local position = original_position
	SEGMENTS[1] = position
	local total_length = 0

	for i = 1, MAX_STEPS do
		local new_position = position + velocity * time_step
		local delta = new_position - position
		local direction = Vector3.normalize(delta)
		local distance = Vector3.length(delta)
		local _, hit_position, hit_distance, _, _ = PhysicsWorld.raycast(physics_world, position, direction, distance, "closest", "types", "both", "collision_filter", collision_filter)
		total_length = total_length + (hit_distance or distance)

		if hit_position then
			SEGMENTS[#SEGMENTS + 1] = hit_position

			return true, SEGMENTS, total_length, hit_position
		else
			SEGMENTS[#SEGMENTS + 1] = new_position
		end

		velocity = velocity + gravity * time_step
		position = new_position
	end

	return false, SEGMENTS, total_length
end

Trajectory.test_throw_trajectory = function (unit, hit_unit_breed_name, physics_world, force, z_force, test_direction, to, gravity, offset_up_human, offset_up_ogryn, max_steps, max_time)
	local unit_position = POSITION_LOOKUP[unit]
	local is_human = hit_unit_breed_name == "human"
	local up = Vector3.up() * (is_human and offset_up_human or offset_up_ogryn)
	local from = unit_position + test_direction + up
	local direction = Vector3.normalize(test_direction)
	local catapult_velocity = direction * force
	catapult_velocity.z = z_force
	local speed = Vector3.length(catapult_velocity)
	local target_velocity = Vector3(0, 0, 0)
	local angle, estimated_position = Trajectory.angle_to_hit_moving_target(from, to, speed, target_velocity, gravity, 1)

	if angle == nil then
		return false
	end

	local velocity = Trajectory.get_trajectory_velocity(from, estimated_position, gravity, speed, angle)
	local hit, segment_list, _, hit_position = Trajectory.ballistic_raycast(physics_world, "filter_player_mover", from, velocity, angle, gravity, max_steps or MAX_STEPS, max_time or MAX_TIME)

	return hit, segment_list, hit_position
end

return Trajectory

-- chunkname: @scripts/extension_systems/locomotion/utilities/vortex_locomotion.lua

local VortexLocomotion = {}

VortexLocomotion.get_vortex_spin_velocity = function (unit_position, center_pos, wanted_radius, up_direction, rotation_speed, radius_change_speed, ascension_speed, dt)
	local epsilon = 0.0001
	local to_unit = unit_position - center_pos
	local flat_to_unit = Vector3.flat(to_unit)
	local flat_to_unit_dir = Vector3.normalize(flat_to_unit)
	local current_radius = Vector3.length(flat_to_unit)
	local angular_speed = rotation_speed / math.max(current_radius, epsilon)
	local delta_rotation = angular_speed * dt
	local new_rotation = Quaternion.axis_angle(up_direction, delta_rotation)
	local new_radius

	if wanted_radius < current_radius then
		new_radius = math.max(current_radius - radius_change_speed * dt, wanted_radius)
	else
		new_radius = math.min(current_radius + radius_change_speed * dt, wanted_radius)
	end

	local current_height = to_unit.z
	local new_height = current_height + ascension_speed * dt
	local new_direction = Quaternion.rotate(new_rotation, flat_to_unit_dir)
	local wanted_position = center_pos + new_direction * new_radius + new_height * up_direction
	local velocity = (wanted_position - unit_position) / math.max(dt, epsilon)
	local perpenticular_dir = Vector3.cross(flat_to_unit_dir, Vector3.up())

	return velocity, new_radius, new_height, perpenticular_dir
end

VortexLocomotion.wanted_projectile_speed = function (distance_vector, projectile_gravity, wanted_angle)
	local x = Vector3.length(Vector3.flat(distance_vector))
	local y = distance_vector.z
	local g = math.abs(projectile_gravity)
	local denominator = 2 * (x * math.tan(wanted_angle) - y)
	local aux = math.abs(g / denominator)

	if aux >= 0 then
		return x / math.cos(wanted_angle) * math.sqrt(aux), x
	end
end

VortexLocomotion.wanted_projectile_angle = function (distance_vector, projectile_gravity, projectile_speed)
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

VortexLocomotion.test_angled_trajectory = function (physics_world, p1, p2, gravity, projectile_speed, angle, segment_list, sections, collision_filter, always_complete)
	table.clear(segment_list)

	local distance_vector = p2 - p1
	local flat_dist, a1, a2

	if angle then
		projectile_speed, flat_dist = VortexLocomotion.wanted_projectile_speed(distance_vector, -gravity, angle)
	elseif projectile_speed then
		a1, a2, flat_dist = VortexLocomotion.wanted_projectile_angle(distance_vector, -gravity, projectile_speed)
		angle = a1 or a2
	end

	if angle and projectile_speed then
		local vec_flat = Vector3.normalize(Vector3.flat(distance_vector))
		local velocity = Quaternion.rotate(Quaternion.axis_angle(Vector3.cross(vec_flat, Vector3.up()), angle), vec_flat) * projectile_speed
		local x_vel_0 = math.cos(angle) * projectile_speed
		local y_vel_0 = math.sin(angle) * projectile_speed
		local flat_speed = Vector3.length(Vector3(velocity.x, velocity.y, 0))
		local t_total = flat_dist / flat_speed

		sections = sections or 4

		local t
		local segment_pos1 = Vector3(p1.x, p1.y, p1.z)
		local segment_pos2

		segment_list[1] = p1

		for i = 1, sections do
			t = t_total * (i / sections)

			local x = x_vel_0 * t
			local z = y_vel_0 * t + 0.5 * gravity * t^2

			segment_pos2 = p1 + vec_flat * x
			segment_pos2.z = segment_pos2.z + z

			if not always_complete then
				local current_velocity = segment_pos2 - segment_pos1
				local result, hit_position, _, _, actor = PhysicsWorld.immediate_raycast(physics_world, segment_pos1, current_velocity, Vector3.length(current_velocity), "closest", "collision_filter", collision_filter or "filter_ai_mover")

				if result then
					if i == sections then
						local hit_unit = Actor.unit(actor)

						if POSITION_LOOKUP[hit_unit] then
							return true, velocity, t_total
						end
					end

					return false
				end
			end

			segment_pos1 = Vector3(segment_pos2.x, segment_pos2.y, segment_pos2.z)
			segment_list[i + 1] = segment_pos1
		end

		return true, velocity, t_total, angle
	end
end

VortexLocomotion.pivot_offset_by_height = function (vortex_template, height, t)
	local outer_radius = vortex_template.outer_radius
	local max_width = outer_radius * 2
	local max_height = vortex_template.vortex_height

	t = t or 0

	local sin_offset_progress = 0.5 + math.sin(t + height * 0.25) * 0.5
	local cos_offset_progress = 0.5 + math.cos(t + height * 0.25) * 0.5
	local vortex_width_anim_offset = max_width * math.clamp((height - 1) / (max_height - 1), 0, 1)
	local pivot_offset_x = sin_offset_progress * vortex_width_anim_offset
	local pivot_offset_y = cos_offset_progress * vortex_width_anim_offset

	return pivot_offset_x, pivot_offset_y
end

local function _raycast(physics_world, from, direction, distance, collision_filter)
	return PhysicsWorld.raycast(physics_world, from, direction, distance, "closest", "collision_filter", collision_filter or "filter_player_mover")
end

local RAY_START_HEIGHT = 2
local NUM_RAYS = 4
local RAY_LENGTH = 12
local dirs = {}

VortexLocomotion.is_position_indoors = function (target_position, physics_world, optional_from_position)
	table.clear(dirs)

	local from = target_position + Vector3.up() * RAY_START_HEIGHT
	local num_rays, full_rotation

	if optional_from_position then
		full_rotation = math.pi
		num_rays = NUM_RAYS

		local travel_dir = Vector3.normalize(target_position - optional_from_position)

		dirs = {
			Vector3.cross(Vector3.flat(travel_dir), Vector3.up()) * 0.5 + Vector3.up(),
		}
	else
		full_rotation = math.pi * 2
		num_rays = NUM_RAYS * 2
		dirs = {
			Vector3.normalize(Vector3.up() * 2 + Vector3.forward()),
		}
	end

	for i = 1, NUM_RAYS do
		dirs[i + 1] = Quaternion.rotate(Quaternion.axis_angle(Vector3.up(), full_rotation / (num_rays - 1)), dirs[i])
	end

	for i = 1, NUM_RAYS do
		local end_pos = from + dirs[i] * RAY_LENGTH

		if _raycast(physics_world, from, dirs[i], RAY_LENGTH) then
			return true
		end
	end

	return false
end

local CHECK_DISTANCE = 20

VortexLocomotion.is_close_to_expeditions_extractions_zone = function (pos)
	local game_mode_manager = Managers.state.game_mode
	local game_mode = game_mode_manager:game_mode()
	local navigation_handler = game_mode.get_navigation_handler and game_mode:get_navigation_handler()

	if not navigation_handler then
		return
	end

	local extraction_positions = navigation_handler:get_registered_extractions()

	for k, v in pairs(extraction_positions) do
		local extraction_pos = v:unbox()

		if CHECK_DISTANCE > Vector3.distance(pos, extraction_pos) then
			return true
		end
	end

	return false
end

return VortexLocomotion
